Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw1-out.broadcom.com ([216.31.210.62]:40693 "EHLO
	mail-gw1-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757134AbbJ2Tnp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 29 Oct 2015 15:43:45 -0400
From: Arend van Spriel <arend@broadcom.com>
To: Kalle Valo <kvalo@codeaurora.org>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	Hante Meuleman <meuleman@broadcom.com>,
	Arend van Spriel <arend@broadcom.com>
Subject: [PATCH 9/9] brcmfmac: Add wowl wake indication report.
Date: Thu, 29 Oct 2015 20:33:19 +0100
Message-ID: <1446147199-21671-10-git-send-email-arend@broadcom.com> (sfid-20151029_204348_446028_AA35C5FB)
In-Reply-To: <1446147199-21671-1-git-send-email-arend@broadcom.com>
References: <1446147199-21671-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Hante Meuleman <meuleman@broadcom.com>

On wakeup of the system (resume) a wowl wakeup indication report
can be sent to cfg80211. This patch adds support for this. The
report specifies if the device was responsible for the wakeup
and if so, will specify the exact reason.

Reviewed-by: Arend Van Spriel <arend@broadcom.com>
Reviewed-by: Franky (Zhenhui) Lin <frankyl@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Hante Meuleman <meuleman@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/cfg80211.c | 67 +++++++++++++++++++++-
 .../net/wireless/brcm80211/brcmfmac/fwil_types.h   | 12 ++++
 2 files changed, 77 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/cfg80211.c b/drivers/net/wireless/brcm80211/brcmfmac/cfg80211.c
index 0c8cc7f..998c521 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/cfg80211.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/cfg80211.c
@@ -3062,6 +3062,67 @@ static s32 brcmf_config_wowl_pattern(struct brcmf_if *ifp, u8 cmd[4],
 	return ret;
 }
 
+#ifdef CONFIG_PM
+
+static void brcmf_report_wowl_wakeind(struct wiphy *wiphy, struct brcmf_if *ifp)
+{
+	struct brcmf_wowl_wakeind_le wake_ind_le;
+	struct cfg80211_wowlan_wakeup wakeup_data;
+	struct cfg80211_wowlan_wakeup *wakeup;
+	u32 wakeind;
+	s32 err;
+
+	err = brcmf_fil_iovar_data_get(ifp, "wowl_wakeind", &wake_ind_le,
+				       sizeof(wake_ind_le));
+	if (!err) {
+		brcmf_err("Get wowl_wakeind failed, err = %d\n", err);
+		return;
+	}
+
+	wakeind = le32_to_cpu(wake_ind_le.ucode_wakeind);
+	if (wakeind & (BRCMF_WOWL_MAGIC | BRCMF_WOWL_DIS | BRCMF_WOWL_BCN |
+		       BRCMF_WOWL_RETR | BRCMF_WOWL_NET)) {
+		wakeup = &wakeup_data;
+		memset(&wakeup_data, 0, sizeof(wakeup_data));
+		wakeup_data.pattern_idx = -1;
+
+		if (wakeind & BRCMF_WOWL_MAGIC) {
+			brcmf_dbg(INFO, "WOWL Wake indicator: BRCMF_WOWL_MAGIC\n");
+			wakeup_data.magic_pkt = true;
+		}
+		if (wakeind & BRCMF_WOWL_DIS) {
+			brcmf_dbg(INFO, "WOWL Wake indicator: BRCMF_WOWL_DIS\n");
+			wakeup_data.disconnect = true;
+		}
+		if (wakeind & BRCMF_WOWL_BCN) {
+			brcmf_dbg(INFO, "WOWL Wake indicator: BRCMF_WOWL_BCN\n");
+			wakeup_data.disconnect = true;
+		}
+		if (wakeind & BRCMF_WOWL_RETR) {
+			brcmf_dbg(INFO, "WOWL Wake indicator: BRCMF_WOWL_RETR\n");
+			wakeup_data.disconnect = true;
+		}
+		if (wakeind & BRCMF_WOWL_NET) {
+			brcmf_dbg(INFO, "WOWL Wake indicator: BRCMF_WOWL_NET\n");
+			/* For now always map to pattern 0, no API to get
+			 * correct information available at the moment.
+			 */
+			wakeup_data.pattern_idx = 0;
+		}
+	} else {
+		wakeup = NULL;
+	}
+	cfg80211_report_wowlan_wakeup(&ifp->vif->wdev, wakeup, GFP_KERNEL);
+}
+
+#else
+
+static void brcmf_report_wowl_wakeind(struct wiphy *wiphy, struct brcmf_if *ifp)
+{
+}
+
+#endif /* CONFIG_PM */
+
 static s32 brcmf_cfg80211_resume(struct wiphy *wiphy)
 {
 	struct brcmf_cfg80211_info *cfg = wiphy_to_cfg(wiphy);
@@ -3071,11 +3132,12 @@ static s32 brcmf_cfg80211_resume(struct wiphy *wiphy)
 	brcmf_dbg(TRACE, "Enter\n");
 
 	if (cfg->wowl_enabled) {
+		brcmf_report_wowl_wakeind(wiphy, ifp);
+		brcmf_fil_iovar_int_set(ifp, "wowl_clear", 0);
+		brcmf_config_wowl_pattern(ifp, "clr", NULL, 0, NULL, 0);
 		brcmf_configure_arp_offload(ifp, true);
 		brcmf_fil_cmd_int_set(ifp, BRCMF_C_SET_PM,
 				      cfg->pre_wowl_pmmode);
-		brcmf_fil_iovar_int_set(ifp, "wowl_clear", 0);
-		brcmf_config_wowl_pattern(ifp, "clr", NULL, 0, NULL, 0);
 		cfg->wowl_enabled = false;
 	}
 	return 0;
@@ -3109,6 +3171,7 @@ static void brcmf_configure_wowl(struct brcmf_cfg80211_info *cfg,
 				wowl->patterns[i].pkt_offset);
 		}
 	}
+	brcmf_fil_iovar_data_set(ifp, "wowl_wakeind", "clear", strlen("clear"));
 	brcmf_fil_iovar_int_set(ifp, "wowl", wowl_config);
 	brcmf_fil_iovar_int_set(ifp, "wowl_activate", 1);
 	brcmf_bus_wowl_config(cfg->pub->bus_if, true);
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/fwil_types.h b/drivers/net/wireless/brcm80211/brcmfmac/fwil_types.h
index 50ff69d..92ee1ad 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/fwil_types.h
+++ b/drivers/net/wireless/brcm80211/brcmfmac/fwil_types.h
@@ -634,4 +634,16 @@ struct brcmf_assoclist_le {
 	u8 mac[BRCMF_MAX_ASSOCLIST][ETH_ALEN];
 };
 
+/**
+ * struct brcmf_wowl_wakeind_le - Wakeup indicators
+ *	Note: note both fields contain same information.
+ *
+ * @pci_wakeind: Whether PCI PMECSR PMEStatus bit was set.
+ * @ucode_wakeind: What wakeup-event indication was set by ucode
+ */
+struct brcmf_wowl_wakeind_le {
+	__le32 pci_wakeind;
+	__le32 ucode_wakeind;
+};
+
 #endif /* FWIL_TYPES_H_ */
-- 
1.9.1


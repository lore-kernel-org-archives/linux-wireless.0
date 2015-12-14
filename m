Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw2-out.broadcom.com ([216.31.210.63]:55362 "EHLO
	mail-gw2-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932541AbbLNNj7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Dec 2015 08:39:59 -0500
From: Arend van Spriel <arend@broadcom.com>
To: Kalle Valo <kvalo@codeaurora.org>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	Hante Meuleman <meuleman@broadcom.com>,
	Arend van Spriel <arend@broadcom.com>
Subject: [PATCH 3/7] brcmfmac: Add support for scheduled scan mac randomization
Date: Mon, 14 Dec 2015 14:39:50 +0100
Message-ID: <1450100394-17414-4-git-send-email-arend@broadcom.com> (sfid-20151214_144007_002488_F2A012DC)
In-Reply-To: <1450100394-17414-1-git-send-email-arend@broadcom.com>
References: <1450100394-17414-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Hante Meuleman <meuleman@broadcom.com>

Scheduled scan be requested to use mac randomization. This patch
checks the flags and enables the randomization if desired.

Reviewed-by: Arend Van Spriel <arend@broadcom.com>
Reviewed-by: Franky (Zhenhui) Lin <frankyl@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Hante Meuleman <meuleman@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 .../broadcom/brcm80211/brcmfmac/cfg80211.c         | 45 ++++++++++++++++++----
 .../broadcom/brcm80211/brcmfmac/fwil_types.h       | 17 ++++++++
 2 files changed, 55 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
index 6b9339b..5964763 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
@@ -3544,9 +3544,14 @@ static int brcmf_dev_pno_clean(struct net_device *ndev)
 	return ret;
 }
 
-static int brcmf_dev_pno_config(struct net_device *ndev)
+static int brcmf_dev_pno_config(struct brcmf_if *ifp,
+				struct cfg80211_sched_scan_request *request)
 {
 	struct brcmf_pno_param_le pfn_param;
+	struct brcmf_pno_macaddr_le pfn_mac;
+	s32 err;
+	u8 *mac_mask;
+	int i;
 
 	memset(&pfn_param, 0, sizeof(pfn_param));
 	pfn_param.version = cpu_to_le32(BRCMF_PNO_VERSION);
@@ -3559,8 +3564,37 @@ static int brcmf_dev_pno_config(struct net_device *ndev)
 	/* set up pno scan fr */
 	pfn_param.scan_freq = cpu_to_le32(BRCMF_PNO_TIME);
 
-	return brcmf_fil_iovar_data_set(netdev_priv(ndev), "pfn_set",
-					&pfn_param, sizeof(pfn_param));
+	err = brcmf_fil_iovar_data_set(ifp, "pfn_set", &pfn_param,
+				       sizeof(pfn_param));
+	if (err) {
+		brcmf_err("pfn_set failed, err=%d\n", err);
+		return err;
+	}
+
+	/* Find out if mac randomization should be turned on */
+	if (!(request->flags & NL80211_SCAN_FLAG_RANDOM_ADDR))
+		return 0;
+
+	pfn_mac.version = BRCMF_PFN_MACADDR_CFG_VER;
+	pfn_mac.flags = BRCMF_PFN_MAC_OUI_ONLY | BRCMF_PFN_SET_MAC_UNASSOC;
+
+	memcpy(pfn_mac.mac, request->mac_addr, ETH_ALEN);
+	mac_mask = request->mac_addr_mask;
+	for (i = 0; i < ETH_ALEN; i++) {
+		pfn_mac.mac[i] &= mac_mask[i];
+		pfn_mac.mac[i] |= get_random_int() & ~(mac_mask[i]);
+	}
+	/* Clear multi bit */
+	pfn_mac.mac[0] &= 0xFE;
+	/* Set locally administered */
+	pfn_mac.mac[0] |= 0x02;
+
+	err = brcmf_fil_iovar_data_set(ifp, "pfn_macaddr", &pfn_mac,
+				       sizeof(pfn_mac));
+	if (err)
+		brcmf_err("pfn_macaddr failed, err=%d\n", err);
+
+	return err;
 }
 
 static int
@@ -3614,11 +3648,8 @@ brcmf_cfg80211_sched_scan_start(struct wiphy *wiphy,
 		}
 
 		/* configure pno */
-		ret = brcmf_dev_pno_config(ndev);
-		if (ret < 0) {
-			brcmf_err("PNO setup failed!! ret=%d\n", ret);
+		if (brcmf_dev_pno_config(ifp, request))
 			return -EINVAL;
-		}
 
 		/* configure each match set */
 		for (i = 0; i < request->n_match_sets; i++) {
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwil_types.h b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwil_types.h
index 0b1e46d..bf2df49 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwil_types.h
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwil_types.h
@@ -128,6 +128,10 @@
 
 #define	BRCMF_MAXPMKID			16	/* max # PMKID cache entries */
 
+#define BRCMF_PFN_MACADDR_CFG_VER	1
+#define BRCMF_PFN_MAC_OUI_ONLY		BIT(0)
+#define BRCMF_PFN_SET_MAC_UNASSOC	BIT(1)
+
 /* join preference types for join_pref iovar */
 enum brcmf_join_pref_types {
 	BRCMF_JOIN_PREF_RSSI = 1,
@@ -752,6 +756,19 @@ struct brcmf_pno_scanresults_le {
 };
 
 /**
+ * struct brcmf_pno_macaddr_le - to configure PNO macaddr randomization.
+ *
+ * @version: PNO version identifier.
+ * @flags: Flags defining how mac addrss should be used.
+ * @mac: MAC address.
+ */
+struct brcmf_pno_macaddr_le {
+	u8 version;
+	u8 flags;
+	u8 mac[ETH_ALEN];
+};
+
+/**
  * struct brcmf_pktcnt_le - packet counters.
  *
  * @rx_good_pkt: packets (MSDUs & MMPDUs) received from this station
-- 
1.9.1


Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw1-out.broadcom.com ([216.31.210.62]:48528 "EHLO
	mail-gw1-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753593AbaLULoD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 21 Dec 2014 06:44:03 -0500
From: Arend van Spriel <arend@broadcom.com>
To: Kalle Valo <kvalo@codeaurora.org>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	Arend van Spriel <arend@broadcom.com>
Subject: [PATCH 08/10] brcmfmac: follow user-space regulatory domain selection
Date: Sun, 21 Dec 2014 12:43:51 +0100
Message-ID: <1419162233-19492-9-git-send-email-arend@broadcom.com> (sfid-20141221_124427_488806_AD2A71E3)
In-Reply-To: <1419162233-19492-1-git-send-email-arend@broadcom.com>
References: <1419162233-19492-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When user-space uses a valid ISO-3166-1 country code for its
regulatory domain selection, the driver will try to configure
the firmware to use the same.

Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Reviewed-by: Hante Meuleman <meuleman@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/cfg80211.c | 25 +++++++++++++++++++++-
 .../net/wireless/brcm80211/brcmfmac/fwil_types.h   | 14 ++++++++++++
 2 files changed, 38 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/cfg80211.c b/drivers/net/wireless/brcm80211/brcmfmac/cfg80211.c
index 1172551..2471dd5 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/cfg80211.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/cfg80211.c
@@ -3982,7 +3982,6 @@ brcmf_cfg80211_start_ap(struct wiphy *wiphy, struct net_device *ndev,
 	brcmf_dbg(TRACE, "ssid=%s(%zu), auth_type=%d, inactivity_timeout=%d\n",
 		  settings->ssid, settings->ssid_len, settings->auth_type,
 		  settings->inactivity_timeout);
-
 	dev_role = ifp->vif->wdev.iftype;
 	mbss = ifp->vif->mbss;
 
@@ -5921,6 +5920,29 @@ int brcmf_cfg80211_wait_vif_event_timeout(struct brcmf_cfg80211_info *cfg,
 				  vif_event_equals(event, action), timeout);
 }
 
+static void brcmf_cfg80211_reg_notifier(struct wiphy *wiphy,
+					struct regulatory_request *req)
+{
+	struct brcmf_cfg80211_info *cfg = wiphy_priv(wiphy);
+	struct brcmf_if *ifp = netdev_priv(cfg_to_ndev(cfg));
+	struct brcmf_fil_country_le ccreq;
+	int i;
+
+	brcmf_dbg(TRACE, "enter: initiator=%d, alpha=%c%c\n", req->initiator,
+		  req->alpha2[0], req->alpha2[1]);
+
+	/* ignore non-ISO3166 country codes */
+	for (i = 0; i < sizeof(req->alpha2); i++)
+		if (req->alpha2[i] < 'A' || req->alpha2[i] > 'Z') {
+			brcmf_err("not a ISO3166 code\n");
+			return;
+		}
+	memset(&ccreq, 0, sizeof(ccreq));
+	ccreq.rev = cpu_to_le32(-1);
+	memcpy(ccreq.ccode, req->alpha2, sizeof(req->alpha2));
+	brcmf_fil_iovar_data_set(ifp, "country", &ccreq, sizeof(ccreq));
+}
+
 static void brcmf_free_wiphy(struct wiphy *wiphy)
 {
 	kfree(wiphy->iface_combinations);
@@ -5997,6 +6019,7 @@ struct brcmf_cfg80211_info *brcmf_cfg80211_attach(struct brcmf_pub *drvr,
 		goto priv_out;
 
 	brcmf_dbg(INFO, "Registering custom regulatory\n");
+	wiphy->reg_notifier = brcmf_cfg80211_reg_notifier;
 	wiphy->regulatory_flags |= REGULATORY_CUSTOM_REG;
 	wiphy_apply_custom_regulatory(wiphy, &brcmf_regdom);
 
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/fwil_types.h b/drivers/net/wireless/brcm80211/brcmfmac/fwil_types.h
index 50891c0..619669b 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/fwil_types.h
+++ b/drivers/net/wireless/brcm80211/brcmfmac/fwil_types.h
@@ -112,6 +112,7 @@
 #define BRCMF_WOWL_MAXPATTERNS		8
 #define BRCMF_WOWL_MAXPATTERNSIZE	128
 
+#define BRCMF_COUNTRY_BUF_SZ		4
 
 /* join preference types for join_pref iovar */
 enum brcmf_join_pref_types {
@@ -525,4 +526,17 @@ struct brcmf_mbss_ssid_le {
 	unsigned char SSID[32];
 };
 
+/**
+ * struct brcmf_fil_country_le - country configuration structure.
+ *
+ * @country_abbrev: null-terminated country code used in the country IE.
+ * @rev: revision specifier for ccode. on set, -1 indicates unspecified.
+ * @ccode: null-terminated built-in country code.
+ */
+struct brcmf_fil_country_le {
+	char country_abbrev[BRCMF_COUNTRY_BUF_SZ];
+	__le32 rev;
+	char ccode[BRCMF_COUNTRY_BUF_SZ];
+};
+
 #endif /* FWIL_TYPES_H_ */
-- 
1.9.1


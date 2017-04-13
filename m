Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lpdvrndsmtp01.broadcom.com ([192.19.229.170]:59628 "EHLO
        rnd-relay.smtp.broadcom.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751473AbdDMMHH (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 13 Apr 2017 08:07:07 -0400
From: Arend van Spriel <arend.vanspriel@broadcom.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
        Arend van Spriel <arend.vanspriel@broadcom.com>
Subject: [PATCH V2 07/10] brcmfmac: move scheduled scan wiphy param setting to pno module
Date: Thu, 13 Apr 2017 13:06:33 +0100
Message-Id: <1492085196-4574-8-git-send-email-arend.vanspriel@broadcom.com> (sfid-20170413_140713_554174_538F5E45)
In-Reply-To: <1492085196-4574-1-git-send-email-arend.vanspriel@broadcom.com>
References: <1492085196-4574-1-git-send-email-arend.vanspriel@broadcom.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

As pno module is providing scheduled scan functionality have it taking
care of setting related wiphy parameters as well.

Reviewed-by: Hante Meuleman <hante.meuleman@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>
Reviewed-by: Franky Lin <franky.lin@broadcom.com>
Signed-off-by: Arend van Spriel <arend.vanspriel@broadcom.com>
---
 .../wireless/broadcom/brcm80211/brcmfmac/cfg80211.c    | 18 +++++-------------
 .../wireless/broadcom/brcm80211/brcmfmac/cfg80211.h    |  2 ++
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/pno.c | 10 ++++++++++
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/pno.h |  8 ++++++++
 4 files changed, 25 insertions(+), 13 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
index 1ddad30..9244b0b 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
@@ -6353,16 +6353,6 @@ static int brcmf_setup_ifmodes(struct wiphy *wiphy, struct brcmf_if *ifp)
 	return -ENOMEM;
 }
 
-static void brcmf_wiphy_pno_params(struct wiphy *wiphy)
-{
-	/* scheduled scan settings */
-	wiphy->max_sched_scan_reqs = 1;
-	wiphy->max_sched_scan_ssids = BRCMF_PNO_MAX_PFN_COUNT;
-	wiphy->max_match_sets = BRCMF_PNO_MAX_PFN_COUNT;
-	wiphy->max_sched_scan_ie_len = BRCMF_SCAN_IE_LEN_MAX;
-	wiphy->max_sched_scan_plan_interval = BRCMF_PNO_SCHED_SCAN_MAX_PERIOD;
-}
-
 #ifdef CONFIG_PM
 static const struct wiphy_wowlan_support brcmf_wowlan_support = {
 	.flags = WIPHY_WOWLAN_MAGIC_PKT | WIPHY_WOWLAN_DISCONNECT,
@@ -6409,6 +6399,7 @@ static int brcmf_setup_wiphy(struct wiphy *wiphy, struct brcmf_if *ifp)
 	const struct ieee80211_iface_combination *combo;
 	struct ieee80211_supported_band *band;
 	u16 max_interfaces = 0;
+	bool gscan;
 	__le32 bandlist[3];
 	u32 n_bands;
 	int err, i;
@@ -6457,9 +6448,10 @@ static int brcmf_setup_wiphy(struct wiphy *wiphy, struct brcmf_if *ifp)
 		wiphy->flags |= WIPHY_FLAG_SUPPORTS_FW_ROAM;
 	wiphy->mgmt_stypes = brcmf_txrx_stypes;
 	wiphy->max_remain_on_channel_duration = 5000;
-	if (brcmf_feat_is_enabled(ifp, BRCMF_FEAT_PNO))
-		brcmf_wiphy_pno_params(wiphy);
-
+	if (brcmf_feat_is_enabled(ifp, BRCMF_FEAT_PNO)) {
+		gscan = brcmf_feat_is_enabled(ifp, BRCMF_FEAT_GSCAN);
+		brcmf_pno_wiphy_params(wiphy, gscan);
+	}
 	/* vendor commands/events support */
 	wiphy->vendor_commands = brcmf_vendor_cmds;
 	wiphy->n_vendor_commands = BRCMF_VNDR_CMDS_LAST - 1;
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.h b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.h
index 8f19d95..a1c2e0a 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.h
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.h
@@ -24,6 +24,8 @@
 #include "fwil_types.h"
 #include "p2p.h"
 
+#define BRCMF_SCAN_IE_LEN_MAX		2048
+
 #define WL_NUM_SCAN_MAX			10
 #define WL_TLV_INFO_MAX			1024
 #define WL_BSS_INFO_MAX			2048
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pno.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pno.c
index 9a25e79..cc0e6a4 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pno.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pno.c
@@ -241,3 +241,13 @@ int brcmf_pno_start_sched_scan(struct brcmf_if *ifp,
 	return ret;
 }
 
+void brcmf_pno_wiphy_params(struct wiphy *wiphy, bool gscan)
+{
+	/* scheduled scan settings */
+	wiphy->max_sched_scan_reqs = gscan ? 2 : 1;
+	wiphy->max_sched_scan_ssids = BRCMF_PNO_MAX_PFN_COUNT;
+	wiphy->max_match_sets = BRCMF_PNO_MAX_PFN_COUNT;
+	wiphy->max_sched_scan_ie_len = BRCMF_SCAN_IE_LEN_MAX;
+	wiphy->max_sched_scan_plan_interval = BRCMF_PNO_SCHED_SCAN_MAX_PERIOD;
+}
+
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pno.h b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pno.h
index bae55b2..07ec51f 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pno.h
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pno.h
@@ -37,4 +37,12 @@
 int brcmf_pno_start_sched_scan(struct brcmf_if *ifp,
 			       struct cfg80211_sched_scan_request *req);
 
+/**
+ * brcmf_pno_wiphy_params - fill scheduled scan parameters in wiphy instance.
+ *
+ * @wiphy: wiphy instance to be used.
+ * @gscan: indicates whether the device has support for g-scan feature.
+ */
+void brcmf_pno_wiphy_params(struct wiphy *wiphy, bool gscan);
+
 #endif /* _BRCMF_PNO_H */
-- 
1.9.1

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lpdvrndsmtp01.broadcom.com ([192.19.229.170]:59797 "EHLO
        rnd-relay.smtp.broadcom.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1037601AbdDUMFV (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 21 Apr 2017 08:05:21 -0400
From: Arend van Spriel <arend.vanspriel@broadcom.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
        Arend van Spriel <arend.vanspriel@broadcom.com>
Subject: [PATCH V3 6/9] brcmfmac: move scheduled scan wiphy param setting to pno module
Date: Fri, 21 Apr 2017 13:05:05 +0100
Message-Id: <1492776308-15120-7-git-send-email-arend.vanspriel@broadcom.com> (sfid-20170421_140540_992922_B7814FE6)
In-Reply-To: <1492776308-15120-1-git-send-email-arend.vanspriel@broadcom.com>
References: <1492776308-15120-1-git-send-email-arend.vanspriel@broadcom.com>
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
index 8da9ae0..6585411 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
@@ -6356,16 +6356,6 @@ static int brcmf_setup_ifmodes(struct wiphy *wiphy, struct brcmf_if *ifp)
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
@@ -6412,6 +6402,7 @@ static int brcmf_setup_wiphy(struct wiphy *wiphy, struct brcmf_if *ifp)
 	const struct ieee80211_iface_combination *combo;
 	struct ieee80211_supported_band *band;
 	u16 max_interfaces = 0;
+	bool gscan;
 	__le32 bandlist[3];
 	u32 n_bands;
 	int err, i;
@@ -6461,9 +6452,10 @@ static int brcmf_setup_wiphy(struct wiphy *wiphy, struct brcmf_if *ifp)
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
index 6c3bde8..a473445 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pno.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pno.c
@@ -239,3 +239,13 @@ int brcmf_pno_start_sched_scan(struct brcmf_if *ifp,
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

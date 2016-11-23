Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lpdvsmtp01.broadcom.com ([192.19.211.62]:53050 "EHLO
        relay.smtp.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S935357AbcKWKfe (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 23 Nov 2016 05:35:34 -0500
From: Arend van Spriel <arend.vanspriel@broadcom.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
        Arend van Spriel <arend.vanspriel@broadcom.com>
Subject: [PATCH 04/12] brcmfmac: fix handling ssids in .sched_scan_start() callback
Date: Wed, 23 Nov 2016 10:25:23 +0000
Message-Id: <1479896731-5091-5-git-send-email-arend.vanspriel@broadcom.com> (sfid-20161123_113547_366127_2A71CB78)
In-Reply-To: <1479896731-5091-1-git-send-email-arend.vanspriel@broadcom.com>
References: <1479896731-5091-1-git-send-email-arend.vanspriel@broadcom.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The ssids list in the scheduled scan request were not properly taken
into account when configuring in firmware. The hidden bit was set for
any ssid resulting in active scanning for all. Only set it for ssids
that are in the ssids list.

Reviewed-by: Hante Meuleman <hante.meuleman@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>
Reviewed-by: Franky Lin <franky.lin@broadcom.com>
Signed-off-by: Arend van Spriel <arend.vanspriel@broadcom.com>
---
 .../broadcom/brcm80211/brcmfmac/cfg80211.c         | 103 ++++++++++-----------
 .../net/wireless/broadcom/brcm80211/brcmfmac/pno.c |  18 ++++
 .../net/wireless/broadcom/brcm80211/brcmfmac/pno.h |  12 ++-
 3 files changed, 76 insertions(+), 57 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
index ee27095..096e214 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
@@ -3314,19 +3314,37 @@ static void brcmf_init_escan(struct brcmf_cfg80211_info *cfg)
 	return err;
 }
 
+static bool brcmf_is_ssid_active(struct cfg80211_ssid *ssid,
+				 struct cfg80211_sched_scan_request *req)
+{
+	int i;
+
+	if (!ssid || !req->ssids || !req->n_ssids)
+		return false;
+
+	for (i = 0; i < req->n_ssids; i++) {
+		if (ssid->ssid_len == req->ssids[i].ssid_len) {
+			if (!strncmp(ssid->ssid, req->ssids[i].ssid,
+				     ssid->ssid_len))
+				return true;
+		}
+	}
+	return false;
+}
+
 static int
 brcmf_cfg80211_sched_scan_start(struct wiphy *wiphy,
 				struct net_device *ndev,
-				struct cfg80211_sched_scan_request *request)
+				struct cfg80211_sched_scan_request *req)
 {
 	struct brcmf_if *ifp = netdev_priv(ndev);
 	struct brcmf_cfg80211_info *cfg = wiphy_priv(wiphy);
-	struct brcmf_pno_net_param_le pfn;
+	struct cfg80211_ssid *ssid;
 	int i;
 	int ret = 0;
 
 	brcmf_dbg(SCAN, "Enter n_match_sets:%d n_ssids:%d\n",
-		  request->n_match_sets, request->n_ssids);
+		  req->n_match_sets, req->n_ssids);
 	if (test_bit(BRCMF_SCAN_STATUS_BUSY, &cfg->scan_status)) {
 		brcmf_err("Scanning already: status (%lu)\n", cfg->scan_status);
 		return -EAGAIN;
@@ -3337,71 +3355,46 @@ static void brcmf_init_escan(struct brcmf_cfg80211_info *cfg)
 		return -EAGAIN;
 	}
 
-	if (!request->n_ssids || !request->n_match_sets) {
-		brcmf_dbg(SCAN, "Invalid sched scan req!! n_ssids:%d\n",
-			  request->n_ssids);
+	if (req->n_match_sets <= 0) {
+		brcmf_dbg(SCAN, "invalid number of matchsets specified: %d\n",
+			  req->n_match_sets);
 		return -EINVAL;
 	}
 
-	if (request->n_ssids > 0) {
-		for (i = 0; i < request->n_ssids; i++) {
-			/* Active scan req for ssids */
-			brcmf_dbg(SCAN, ">>> Active scan req for ssid (%s)\n",
-				  request->ssids[i].ssid);
-
-			/* match_set ssids is a supert set of n_ssid list,
-			 * so we need not add these set separately.
-			 */
-		}
+	/* clean up everything */
+	ret = brcmf_pno_clean(ifp);
+	if  (ret < 0) {
+		brcmf_err("failed error=%d\n", ret);
+		return ret;
 	}
 
-	if (request->n_match_sets > 0) {
-		/* clean up everything */
-		ret = brcmf_pno_clean(ifp);
-		if  (ret < 0) {
-			brcmf_err("failed error=%d\n", ret);
-			return ret;
-		}
+	/* configure pno */
+	ret = brcmf_pno_config(ifp, req);
+	if (ret < 0)
+		return ret;
 
-		/* configure pno */
-		ret = brcmf_pno_config(ifp, request);
-		if (ret < 0)
-			return ret;
+	/* configure each match set */
+	for (i = 0; i < req->n_match_sets; i++) {
 
-		/* configure each match set */
-		for (i = 0; i < request->n_match_sets; i++) {
-			struct cfg80211_ssid *ssid;
-			u32 ssid_len;
+		ssid = &req->match_sets[i].ssid;
 
-			ssid = &request->match_sets[i].ssid;
-			ssid_len = ssid->ssid_len;
+		if (!ssid->ssid_len) {
+			brcmf_err("skip broadcast ssid\n");
+			continue;
+		}
 
-			if (!ssid_len) {
-				brcmf_err("skip broadcast ssid\n");
-				continue;
-			}
-			pfn.auth = cpu_to_le32(WLAN_AUTH_OPEN);
-			pfn.wpa_auth = cpu_to_le32(BRCMF_PNO_WPA_AUTH_ANY);
-			pfn.wsec = cpu_to_le32(0);
-			pfn.infra = cpu_to_le32(1);
-			pfn.flags = cpu_to_le32(1 << BRCMF_PNO_HIDDEN_BIT);
-			pfn.ssid.SSID_len = cpu_to_le32(ssid_len);
-			memcpy(pfn.ssid.SSID, ssid->ssid, ssid_len);
-			ret = brcmf_fil_iovar_data_set(ifp, "pfn_add", &pfn,
-						       sizeof(pfn));
+		ret = brcmf_pno_add_ssid(ifp, ssid,
+					 brcmf_is_ssid_active(ssid, req));
+		if (ret < 0)
 			brcmf_dbg(SCAN, ">>> PNO filter %s for ssid (%s)\n",
 				  ret == 0 ? "set" : "failed", ssid->ssid);
-		}
-		/* Enable the PNO */
-		if (brcmf_fil_iovar_int_set(ifp, "pfn", 1) < 0) {
-			brcmf_err("PNO enable failed!! ret=%d\n", ret);
-			return -EINVAL;
-		}
-	} else {
-		return -EINVAL;
 	}
+	/* Enable the PNO */
+	ret = brcmf_fil_iovar_int_set(ifp, "pfn", 1);
+	if (ret < 0)
+		brcmf_err("PNO enable failed!! ret=%d\n", ret);
 
-	return 0;
+	return ret;
 }
 
 static int brcmf_cfg80211_sched_scan_stop(struct wiphy *wiphy,
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pno.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pno.c
index 2f6a4e0..c7967d9e 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pno.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pno.c
@@ -28,6 +28,8 @@
 #define BRCMF_PNO_FREQ_EXPO_MAX		3
 #define BRCMF_PNO_ENABLE_ADAPTSCAN_BIT	6
 #define BRCMF_PNO_SCAN_INCOMPLETE	0
+#define BRCMF_PNO_WPA_AUTH_ANY		0xFFFFFFFF
+#define BRCMF_PNO_HIDDEN_BIT		2
 
 int brcmf_pno_clean(struct brcmf_if *ifp)
 {
@@ -98,3 +100,19 @@ int brcmf_pno_config(struct brcmf_if *ifp,
 	return err;
 }
 
+int brcmf_pno_add_ssid(struct brcmf_if *ifp, struct cfg80211_ssid *ssid,
+		       bool active)
+{
+	struct brcmf_pno_net_param_le pfn;
+
+	pfn.auth = cpu_to_le32(WLAN_AUTH_OPEN);
+	pfn.wpa_auth = cpu_to_le32(BRCMF_PNO_WPA_AUTH_ANY);
+	pfn.wsec = cpu_to_le32(0);
+	pfn.infra = cpu_to_le32(1);
+	if (active)
+		pfn.flags = cpu_to_le32(1 << BRCMF_PNO_HIDDEN_BIT);
+	pfn.ssid.SSID_len = cpu_to_le32(ssid->ssid_len);
+	memcpy(pfn.ssid.SSID, ssid->ssid, ssid->ssid_len);
+	return brcmf_fil_iovar_data_set(ifp, "pfn_add", &pfn, sizeof(pfn));
+}
+
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pno.h b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pno.h
index 08d701e..a4a23fc 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pno.h
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pno.h
@@ -17,8 +17,6 @@
 #define _BRCMF_PNO_H
 
 #define BRCMF_PNO_SCAN_COMPLETE		1
-#define BRCMF_PNO_WPA_AUTH_ANY		0xFFFFFFFF
-#define BRCMF_PNO_HIDDEN_BIT		2
 #define BRCMF_PNO_MAX_PFN_COUNT		16
 
 /**
@@ -37,4 +35,14 @@
 int brcmf_pno_config(struct brcmf_if *ifp,
 		     struct cfg80211_sched_scan_request *request);
 
+/**
+ * brcmf_pno_add_ssid - add ssid for pno in firmware.
+ *
+ * @ifp: interface object used.
+ * @ssid: ssid information.
+ * @active: indicate this ssid needs to be actively probed.
+ */
+int brcmf_pno_add_ssid(struct brcmf_if *ifp, struct cfg80211_ssid *ssid,
+		       bool active);
+
 #endif /* _BRCMF_PNO_H */
-- 
1.9.1

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:29198 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754069Ab2B1RRK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Feb 2012 12:17:10 -0500
From: Aarthi Thiruvengadam <athiruve@qca.qualcomm.com>
To: <kvalo@qca.qualcomm.com>
CC: <ath6kl-devel@qualcomm.com>, <linux-wireless@vger.kernel.org>,
	Aarthi Thiruvengadam <athiruve@qca.qualcomm.com>
Subject: [PATCH] ath6kl: Clear the IE in firmware if not set
Date: Tue, 28 Feb 2012 09:17:04 -0800
Message-ID: <1330449424-4975-1-git-send-email-aarthi.thiruvengadam@qca.qualcomm.com> (sfid-20120228_181736_991205_8AB4E608)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Remove check so that IE in firmware is cleared if not set. Without this fix, any
previously set IE will be used incorrectly in the next frame. For example,
consider the scenario where a P2P device scan is followed by a regular station
scan. The P2P IE set by the P2P scan needs to be cleared, otherwise the station
scan will contain the P2P IE.

Signed-off-by: Aarthi Thiruvengadam <athiruve@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/cfg80211.c |   64 +++++++++++++---------------
 1 files changed, 29 insertions(+), 35 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/cfg80211.c b/drivers/net/wireless/ath/ath6kl/cfg80211.c
index a91f521..73848c0 100644
--- a/drivers/net/wireless/ath/ath6kl/cfg80211.c
+++ b/drivers/net/wireless/ath/ath6kl/cfg80211.c
@@ -877,19 +877,14 @@ static int ath6kl_cfg80211_scan(struct wiphy *wiphy, struct net_device *ndev,
 						  request->ssids[i].ssid);
 	}
 
-	/*
-	 * FIXME: we should clear the IE in fw if it's not set so just
-	 * remove the check altogether
-	 */
-	if (request->ie) {
-		ret = ath6kl_wmi_set_appie_cmd(ar->wmi, vif->fw_vif_idx,
-					       WMI_FRAME_PROBE_REQ,
-					       request->ie, request->ie_len);
-		if (ret) {
-			ath6kl_err("failed to set Probe Request appie for "
-				   "scan");
-			return ret;
-		}
+	/* this also clears IE in fw if it's not set */
+	ret = ath6kl_wmi_set_appie_cmd(ar->wmi, vif->fw_vif_idx,
+		WMI_FRAME_PROBE_REQ,
+		request->ie, request->ie_len);
+	if (ret) {
+		ath6kl_err("failed to set Probe Request appie for "
+			"scan");
+		return ret;
 	}
 
 	/*
@@ -2290,28 +2285,27 @@ static int ath6kl_ap_beacon(struct wiphy *wiphy, struct net_device *dev,
 	if (vif->next_mode != AP_NETWORK)
 		return -EOPNOTSUPP;
 
-	if (info->beacon_ies) {
-		res = ath6kl_wmi_set_appie_cmd(ar->wmi, vif->fw_vif_idx,
-					       WMI_FRAME_BEACON,
-					       info->beacon_ies,
-					       info->beacon_ies_len);
-		if (res)
-			return res;
-	}
-	if (info->proberesp_ies) {
-		res = ath6kl_set_ap_probe_resp_ies(vif, info->proberesp_ies,
-						   info->proberesp_ies_len);
-		if (res)
-			return res;
-	}
-	if (info->assocresp_ies) {
-		res = ath6kl_wmi_set_appie_cmd(ar->wmi, vif->fw_vif_idx,
-					       WMI_FRAME_ASSOC_RESP,
-					       info->assocresp_ies,
-					       info->assocresp_ies_len);
-		if (res)
-			return res;
-	}
+	/* this also clears IE in fw if it's not set */
+	res = ath6kl_wmi_set_appie_cmd(ar->wmi, vif->fw_vif_idx,
+		WMI_FRAME_BEACON,
+		info->beacon_ies,
+		info->beacon_ies_len);
+	if (res)
+		return res;
+
+	/* this also clears IE in fw if it's not set */
+	res = ath6kl_set_ap_probe_resp_ies(vif, info->proberesp_ies,
+		info->proberesp_ies_len);
+	if (res)
+		return res;
+
+	/* this also clears IE in fw if it's not set */
+	res = ath6kl_wmi_set_appie_cmd(ar->wmi, vif->fw_vif_idx,
+		WMI_FRAME_ASSOC_RESP,
+		info->assocresp_ies,
+		info->assocresp_ies_len);
+	if (res)
+		return res;
 
 	if (!add)
 		return 0;
-- 
1.7.0.4


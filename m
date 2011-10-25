Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:28348 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754611Ab1JYKOl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Oct 2011 06:14:41 -0400
From: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
To: <kvalo@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>, <nataraja@qca.qualcomm.com>,
	<athiruve@qca.qualcomm.com>
Subject: [PATCH 32/34] ath6kl: Cleanup few function parametrs in cfg80211.c
Date: Tue, 25 Oct 2011 15:40:28 +0530
Message-ID: <1319537430-12459-33-git-send-email-vthiagar@qca.qualcomm.com> (sfid-20111025_122050_176360_47EF6EF1)
In-Reply-To: <1319537430-12459-1-git-send-email-vthiagar@qca.qualcomm.com>
References: <1319537430-12459-1-git-send-email-vthiagar@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

There are few functions getting called with ath6kl and vif->fw_if_idx
as two of the paramers. Passing a respective vif should be enough
to get those information. Also couple of functions are called with
unused wiphy parametr, remove them as well.

Signed-off-by: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/cfg80211.c |   38 ++++++++++++++--------------
 1 files changed, 19 insertions(+), 19 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/cfg80211.c b/drivers/net/wireless/ath/ath6kl/cfg80211.c
index ddf53f3..b5d14fa 100644
--- a/drivers/net/wireless/ath/ath6kl/cfg80211.c
+++ b/drivers/net/wireless/ath/ath6kl/cfg80211.c
@@ -259,9 +259,10 @@ static bool ath6kl_is_rsn_ie(const u8 *pos)
 	return pos[0] == WLAN_EID_RSN;
 }
 
-static int ath6kl_set_assoc_req_ies(struct ath6kl *ar, u8 if_idx, const u8 *ies,
+static int ath6kl_set_assoc_req_ies(struct ath6kl_vif *vif, const u8 *ies,
 				    size_t ies_len)
 {
+	struct ath6kl *ar = vif->ar;
 	const u8 *pos;
 	u8 *buf = NULL;
 	size_t len = 0;
@@ -288,8 +289,8 @@ static int ath6kl_set_assoc_req_ies(struct ath6kl *ar, u8 if_idx, const u8 *ies,
 		}
 	}
 
-	ret = ath6kl_wmi_set_appie_cmd(ar->wmi, if_idx, WMI_FRAME_ASSOC_REQ,
-				       buf, len);
+	ret = ath6kl_wmi_set_appie_cmd(ar->wmi, vif->fw_vif_idx,
+				       WMI_FRAME_ASSOC_REQ, buf, len);
 	kfree(buf);
 	return ret;
 }
@@ -405,8 +406,7 @@ static int ath6kl_cfg80211_connect(struct wiphy *wiphy, struct net_device *dev,
 	}
 
 	if (sme->ie && (sme->ie_len > 0)) {
-		status = ath6kl_set_assoc_req_ies(ar, vif->fw_vif_idx, sme->ie,
-						  sme->ie_len);
+		status = ath6kl_set_assoc_req_ies(vif, sme->ie, sme->ie_len);
 		if (status)
 			return status;
 	}
@@ -1677,9 +1677,10 @@ static bool ath6kl_is_p2p_ie(const u8 *pos)
 		pos[4] == 0x9a && pos[5] == 0x09;
 }
 
-static int ath6kl_set_ap_probe_resp_ies(struct ath6kl *ar, u8 if_idex,
-					const u8 *ies, size_t ies_len)
+static int ath6kl_set_ap_probe_resp_ies(struct ath6kl_vif *vif, const u8 *ies,
+					size_t ies_len)
 {
+	struct ath6kl *ar = vif->ar;
 	const u8 *pos;
 	u8 *buf = NULL;
 	size_t len = 0;
@@ -1706,13 +1707,13 @@ static int ath6kl_set_ap_probe_resp_ies(struct ath6kl *ar, u8 if_idex,
 		}
 	}
 
-	ret = ath6kl_wmi_set_appie_cmd(ar->wmi, if_idex, WMI_FRAME_PROBE_RESP,
-				       buf, len);
+	ret = ath6kl_wmi_set_appie_cmd(ar->wmi, vif->fw_vif_idx,
+				       WMI_FRAME_PROBE_RESP, buf, len);
 	kfree(buf);
 	return ret;
 }
 
-static int ath6kl_ap_beacon(struct wiphy *wiphy, struct net_device *dev,
+static int ath6kl_ap_beacon(struct net_device *dev,
 			    struct beacon_parameters *info, bool add)
 {
 	struct ath6kl *ar = ath6kl_priv(dev);
@@ -1741,8 +1742,7 @@ static int ath6kl_ap_beacon(struct wiphy *wiphy, struct net_device *dev,
 			return res;
 	}
 	if (info->proberesp_ies) {
-		res = ath6kl_set_ap_probe_resp_ies(ar, vif->fw_vif_idx,
-						   info->proberesp_ies,
+		res = ath6kl_set_ap_probe_resp_ies(vif, info->proberesp_ies,
 						   info->proberesp_ies_len);
 		if (res)
 			return res;
@@ -1860,13 +1860,13 @@ static int ath6kl_ap_beacon(struct wiphy *wiphy, struct net_device *dev,
 static int ath6kl_add_beacon(struct wiphy *wiphy, struct net_device *dev,
 			     struct beacon_parameters *info)
 {
-	return ath6kl_ap_beacon(wiphy, dev, info, true);
+	return ath6kl_ap_beacon(dev, info, true);
 }
 
 static int ath6kl_set_beacon(struct wiphy *wiphy, struct net_device *dev,
 			     struct beacon_parameters *info)
 {
-	return ath6kl_ap_beacon(wiphy, dev, info, false);
+	return ath6kl_ap_beacon(dev, info, false);
 }
 
 static int ath6kl_del_beacon(struct wiphy *wiphy, struct net_device *dev)
@@ -1936,10 +1936,10 @@ static int ath6kl_cancel_remain_on_channel(struct wiphy *wiphy,
 	return ath6kl_wmi_cancel_remain_on_chnl_cmd(ar->wmi, vif->fw_vif_idx);
 }
 
-static int ath6kl_send_go_probe_resp(struct ath6kl *ar, u8 if_idx,
-				     const u8 *buf, size_t len,
-				     unsigned int freq)
+static int ath6kl_send_go_probe_resp(struct ath6kl_vif *vif, const u8 *buf,
+				     size_t len, unsigned int freq)
 {
+	struct ath6kl *ar = vif->ar;
 	const u8 *pos;
 	u8 *p2p;
 	int p2p_len;
@@ -1966,7 +1966,7 @@ static int ath6kl_send_go_probe_resp(struct ath6kl *ar, u8 if_idx,
 		pos += 2 + pos[1];
 	}
 
-	ret = ath6kl_wmi_send_probe_response_cmd(ar->wmi, if_idx, freq,
+	ret = ath6kl_wmi_send_probe_response_cmd(ar->wmi, vif->fw_vif_idx, freq,
 						 mgmt->da, p2p, p2p_len);
 	kfree(p2p);
 	return ret;
@@ -1992,7 +1992,7 @@ static int ath6kl_mgmt_tx(struct wiphy *wiphy, struct net_device *dev,
 		 * command to allow the target to fill in the generic IEs.
 		 */
 		*cookie = 0; /* TX status not supported */
-		return ath6kl_send_go_probe_resp(ar, vif->fw_vif_idx, buf, len,
+		return ath6kl_send_go_probe_resp(vif, buf, len,
 						 chan->center_freq);
 	}
 
-- 
1.7.0.4


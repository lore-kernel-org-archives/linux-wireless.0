Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:53018 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755894Ab1LGNiy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 Dec 2011 08:38:54 -0500
From: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
To: <kvalo@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>, <ath6kl-devel@qualcomm.com>
Subject: [PATCH V2 2/2] ath6kl: Use cfg80211_roamed_bss() to report roaming event
Date: Wed, 7 Dec 2011 19:13:01 +0530
Message-ID: <1323265381-1184-1-git-send-email-vthiagar@qca.qualcomm.com> (sfid-20111207_143909_161839_0AC8AECA)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is to avoid the scenario where the bss entry of the AP got
expired when reporting roaming event to current AP. As the bss
entry for the current bss is available in driver, pass this bss
to cfg80211. This fixes WARNING: at net/wireless/sme.c:586.

This patch depends on the following patch in cfg80211
"cfg80211: Define a wrapper function for reporting roaming".

Reported-by: Kalle Valo <kvalo@qca.qualcomm.com>
Signed-off-by: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/cfg80211.c |   38 ++++++++++++++--------------
 1 files changed, 19 insertions(+), 19 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/cfg80211.c b/drivers/net/wireless/ath/ath6kl/cfg80211.c
index aa93527..be0a73a 100644
--- a/drivers/net/wireless/ath/ath6kl/cfg80211.c
+++ b/drivers/net/wireless/ath/ath6kl/cfg80211.c
@@ -568,11 +568,13 @@ static int ath6kl_cfg80211_connect(struct wiphy *wiphy, struct net_device *dev,
 	return 0;
 }
 
-static int ath6kl_add_bss_if_needed(struct ath6kl_vif *vif,
-				    enum network_type nw_type,
-				    const u8 *bssid,
-				    struct ieee80211_channel *chan,
-				    const u8 *beacon_ie, size_t beacon_ie_len)
+static struct cfg80211_bss *
+ath6kl_add_bss_if_needed(struct ath6kl_vif *vif,
+			 enum network_type nw_type,
+			 const u8 *bssid,
+			 struct ieee80211_channel *chan,
+			 const u8 *beacon_ie,
+			 size_t beacon_ie_len)
 {
 	struct ath6kl *ar = vif->ar;
 	struct cfg80211_bss *bss;
@@ -601,7 +603,7 @@ static int ath6kl_add_bss_if_needed(struct ath6kl_vif *vif,
 		 */
 		ie = kmalloc(2 + vif->ssid_len + beacon_ie_len, GFP_KERNEL);
 		if (ie == NULL)
-			return -ENOMEM;
+			return NULL;
 		ie[0] = WLAN_EID_SSID;
 		ie[1] = vif->ssid_len;
 		memcpy(ie + 2, vif->ssid, vif->ssid_len);
@@ -615,15 +617,9 @@ static int ath6kl_add_bss_if_needed(struct ath6kl_vif *vif,
 				   "cfg80211\n", bssid);
 		kfree(ie);
 	} else
-		ath6kl_dbg(ATH6KL_DBG_WLAN_CFG, "cfg80211 already has a bss "
-			   "entry\n");
-
-	if (bss == NULL)
-		return -ENOMEM;
+		ath6kl_dbg(ATH6KL_DBG_WLAN_CFG, "cfg80211 already has a bss\n");
 
-	cfg80211_put_bss(bss);
-
-	return 0;
+	return bss;
 }
 
 void ath6kl_cfg80211_connect_event(struct ath6kl_vif *vif, u16 channel,
@@ -635,6 +631,7 @@ void ath6kl_cfg80211_connect_event(struct ath6kl_vif *vif, u16 channel,
 {
 	struct ieee80211_channel *chan;
 	struct ath6kl *ar = vif->ar;
+	struct cfg80211_bss *bss;
 
 	/* capinfo + listen interval */
 	u8 assoc_req_ie_offset = sizeof(u16) + sizeof(u16);
@@ -675,8 +672,9 @@ void ath6kl_cfg80211_connect_event(struct ath6kl_vif *vif, u16 channel,
 
 	chan = ieee80211_get_channel(ar->wiphy, (int) channel);
 
-	if (ath6kl_add_bss_if_needed(vif, nw_type, bssid, chan, assoc_info,
-				     beacon_ie_len) < 0) {
+	bss = ath6kl_add_bss_if_needed(vif, nw_type, bssid, chan,
+				       assoc_info, beacon_ie_len);
+	if (!bss) {
 		ath6kl_err("could not add cfg80211 bss entry\n");
 		return;
 	}
@@ -685,6 +683,7 @@ void ath6kl_cfg80211_connect_event(struct ath6kl_vif *vif, u16 channel,
 		ath6kl_dbg(ATH6KL_DBG_WLAN_CFG, "ad-hoc %s selected\n",
 			   nw_type & ADHOC_CREATOR ? "creator" : "joiner");
 		cfg80211_ibss_joined(vif->ndev, bssid, GFP_KERNEL);
+		cfg80211_put_bss(bss);
 		return;
 	}
 
@@ -695,11 +694,12 @@ void ath6kl_cfg80211_connect_event(struct ath6kl_vif *vif, u16 channel,
 					assoc_req_ie, assoc_req_len,
 					assoc_resp_ie, assoc_resp_len,
 					WLAN_STATUS_SUCCESS, GFP_KERNEL);
+		cfg80211_put_bss(bss);
 	} else if (vif->sme_state == SME_CONNECTED) {
 		/* inform roam event to cfg80211 */
-		cfg80211_roamed(vif->ndev, chan, bssid,
-				assoc_req_ie, assoc_req_len,
-				assoc_resp_ie, assoc_resp_len, GFP_KERNEL);
+		cfg80211_roamed_bss(vif->ndev, bss, chan, bssid,
+				    assoc_req_ie, assoc_req_len,
+				    assoc_resp_ie, assoc_resp_len, GFP_KERNEL);
 	}
 }
 
-- 
1.7.0.4


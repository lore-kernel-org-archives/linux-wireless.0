Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:39966 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755674AbaKSRfM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Nov 2014 12:35:12 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 4/4] mac80211_hwsim: support scanning with random MAC address
Date: Wed, 19 Nov 2014 18:35:05 +0100
Message-Id: <1416418505-7359-5-git-send-email-johannes@sipsolutions.net> (sfid-20141119_183518_341634_D4AC8D9D)
In-Reply-To: <1416418505-7359-1-git-send-email-johannes@sipsolutions.net>
References: <1416418505-7359-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

This adds support for scanning with random MAC address for
both software and hardware scan.

Change-Id: Ib667b4ba0f515f9d1fc073d8ae4c7785f6c3e124
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Reviewed-on: https://gerrit.rds.intel.com/r/47442
Reviewed-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Tested-by: IWL Jenkins
---
 drivers/net/wireless/mac80211_hwsim.c | 18 ++++++++++++++++--
 1 file changed, 16 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/mac80211_hwsim.c b/drivers/net/wireless/mac80211_hwsim.c
index 6daaad595ea4..c2303dbcb63c 100644
--- a/drivers/net/wireless/mac80211_hwsim.c
+++ b/drivers/net/wireless/mac80211_hwsim.c
@@ -422,6 +422,7 @@ struct mac80211_hwsim_data {
 	struct cfg80211_scan_request *hw_scan_request;
 	struct ieee80211_vif *hw_scan_vif;
 	int scan_chan_idx;
+	u8 scan_addr[ETH_ALEN];
 
 	struct ieee80211_channel *channel;
 	u64 beacon_int	/* beacon interval in us */;
@@ -830,6 +831,9 @@ static bool mac80211_hwsim_addr_match(struct mac80211_hwsim_data *data,
 		.ret = false,
 	};
 
+	if (data->scanning && memcmp(addr, data->scan_addr, ETH_ALEN) == 0)
+		return true;
+
 	memcpy(md.addr, addr, ETH_ALEN);
 
 	ieee80211_iterate_active_interfaces_atomic(data->hw,
@@ -1802,7 +1806,7 @@ static void hw_scan_work(struct work_struct *work)
 			struct sk_buff *probe;
 
 			probe = ieee80211_probereq_get(hwsim->hw,
-						       hwsim->hw_scan_vif->addr,
+						       hwsim->scan_addr,
 						       req->ssids[i].ssid,
 						       req->ssids[i].ssid_len,
 						       req->ie_len);
@@ -1840,6 +1844,12 @@ static int mac80211_hwsim_hw_scan(struct ieee80211_hw *hw,
 	hwsim->hw_scan_request = req;
 	hwsim->hw_scan_vif = vif;
 	hwsim->scan_chan_idx = 0;
+	if (req->flags & NL80211_SCAN_FLAG_RANDOM_ADDR)
+		get_random_mask_addr(hwsim->scan_addr,
+				     hw_req->req.mac_addr,
+				     hw_req->req.mac_addr_mask);
+	else
+		memcpy(hwsim->scan_addr, vif->addr, ETH_ALEN);
 	mutex_unlock(&hwsim->mutex);
 
 	wiphy_debug(hw->wiphy, "hwsim hw_scan request\n");
@@ -1880,6 +1890,8 @@ static void mac80211_hwsim_sw_scan(struct ieee80211_hw *hw,
 	}
 
 	printk(KERN_DEBUG "hwsim sw_scan request, prepping stuff\n");
+
+	memcpy(hwsim->scan_addr, mac_addr, ETH_ALEN);
 	hwsim->scanning = true;
 
 out:
@@ -1895,6 +1907,7 @@ static void mac80211_hwsim_sw_scan_complete(struct ieee80211_hw *hw,
 
 	printk(KERN_DEBUG "hwsim sw_scan_complete\n");
 	hwsim->scanning = false;
+	memset(hwsim->scan_addr, 0, ETH_ALEN);
 
 	mutex_unlock(&hwsim->mutex);
 }
@@ -2320,7 +2333,8 @@ static int mac80211_hwsim_new_radio(struct genl_info *info,
 	hw->wiphy->features |= NL80211_FEATURE_ACTIVE_MONITOR |
 			       NL80211_FEATURE_AP_MODE_CHAN_WIDTH_CHANGE |
 			       NL80211_FEATURE_STATIC_SMPS |
-			       NL80211_FEATURE_DYNAMIC_SMPS;
+			       NL80211_FEATURE_DYNAMIC_SMPS |
+			       NL80211_FEATURE_SCAN_RANDOM_MAC_ADDR;
 
 	/* ask mac80211 to reserve space for magic */
 	hw->vif_data_size = sizeof(struct hwsim_vif_priv);
-- 
2.1.1


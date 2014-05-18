Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:37515 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751635AbaERHSW (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 18 May 2014 03:18:22 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH] cfg80211: allow RSSI compensation
Date: Sun, 18 May 2014 10:15:24 +0300
Message-Id: <1400397324-8153-1-git-send-email-emmanuel.grumbach@intel.com> (sfid-20140518_091825_554950_EDE1479D)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Channels in 2.4GHz band overlap, this means that if we
send a probe request on channel 1 and then move to channel
2, we will hear the probe response on channel 2. In this
case, the RSSI will be lower than if we had heard it on
the channel on which it was sent (1 in this case).

The firmware / low level driver can parse the channel in
the DS IE or HT IE and compensate the RSSI so that it will
still have a valid value even if we heard the frame on an
adjacent channel. This can be done up to a certain offset.

Add this offset as a configuration for the low level driver.
A low level driver that can compensate the low RSSI in this
case should assign the maximal offset for which the RSSI
value is still valid.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 include/net/cfg80211.h |  7 +++++++
 net/wireless/scan.c    | 12 ++++++++----
 2 files changed, 15 insertions(+), 4 deletions(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index ef56b8b..a7facad 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -2934,6 +2934,12 @@ struct wiphy_vendor_command {
  *	(including P2P GO) or 0 to indicate no such limit is advertised. The
  *	driver is allowed to advertise a theoretical limit that it can reach in
  *	some cases, but may not always reach.
+ * @max_adj_channel_rssi_comp: max offset of between the channel on which the
+ *	frame was sent and the channel on which the frame was heard for which
+ *	the reported rssi is still valid. If a driver is able to compensate the
+ *	low rssi when a frame is heard on different channel, then it should set
+ *	this variable to the maximal offset for which it can compensate.
+ *	This value should be set in MHz.
  */
 struct wiphy {
 	/* assign these fields before you register the wiphy */
@@ -3077,6 +3083,7 @@ struct wiphy {
 	 * csa counters. Default (0) means infinite.
 	 */
 	u8 max_num_csa_counters;
+	u8 max_adj_channel_rssi_comp;
 
 	char priv[0] __aligned(NETDEV_ALIGN);
 };
diff --git a/net/wireless/scan.c b/net/wireless/scan.c
index 52a122f..f93b7fa 100644
--- a/net/wireless/scan.c
+++ b/net/wireless/scan.c
@@ -892,6 +892,7 @@ cfg80211_inform_bss_width(struct wiphy *wiphy,
 	struct cfg80211_bss_ies *ies;
 	struct ieee80211_channel *channel;
 	struct cfg80211_internal_bss tmp = {}, *res;
+	bool signal_valid;
 
 	if (WARN_ON(!wiphy))
 		return NULL;
@@ -928,8 +929,9 @@ cfg80211_inform_bss_width(struct wiphy *wiphy,
 	rcu_assign_pointer(tmp.pub.beacon_ies, ies);
 	rcu_assign_pointer(tmp.pub.ies, ies);
 
-	res = cfg80211_bss_update(wiphy_to_rdev(wiphy), &tmp,
-				  rx_channel == channel);
+	signal_valid = abs(rx_channel->center_freq - channel->center_freq) <=
+		wiphy->max_adj_channel_rssi_comp;
+	res = cfg80211_bss_update(wiphy_to_rdev(wiphy), &tmp, signal_valid);
 	if (!res)
 		return NULL;
 
@@ -953,6 +955,7 @@ cfg80211_inform_bss_width_frame(struct wiphy *wiphy,
 	struct cfg80211_internal_bss tmp = {}, *res;
 	struct cfg80211_bss_ies *ies;
 	struct ieee80211_channel *channel;
+	bool signal_valid;
 	size_t ielen = len - offsetof(struct ieee80211_mgmt,
 				      u.probe_resp.variable);
 
@@ -1000,8 +1003,9 @@ cfg80211_inform_bss_width_frame(struct wiphy *wiphy,
 	tmp.pub.beacon_interval = le16_to_cpu(mgmt->u.probe_resp.beacon_int);
 	tmp.pub.capability = le16_to_cpu(mgmt->u.probe_resp.capab_info);
 
-	res = cfg80211_bss_update(wiphy_to_rdev(wiphy), &tmp,
-				  rx_channel == channel);
+	signal_valid = abs(rx_channel->center_freq - channel->center_freq) <=
+		wiphy->max_adj_channel_rssi_comp;
+	res = cfg80211_bss_update(wiphy_to_rdev(wiphy), &tmp, signal_valid);
 	if (!res)
 		return NULL;
 
-- 
1.8.3.2


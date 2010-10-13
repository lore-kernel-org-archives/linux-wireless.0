Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.44.51]:38220 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753628Ab0JMWsy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Oct 2010 18:48:54 -0400
Received: from hpaq6.eem.corp.google.com (hpaq6.eem.corp.google.com [172.25.149.6])
	by smtp-out.google.com with ESMTP id o9DMmrag030357
	for <linux-wireless@vger.kernel.org>; Wed, 13 Oct 2010 15:48:53 -0700
Received: from glenhelen.mtv.corp.google.com (glenhelen.mtv.corp.google.com [172.22.72.223])
	by hpaq6.eem.corp.google.com with ESMTP id o9DMmqnk025364
	for <linux-wireless@vger.kernel.org>; Wed, 13 Oct 2010 15:48:52 -0700
From: Paul Stewart <pstew@google.com>
Date: Wed, 13 Oct 2010 15:10:17 -0700
Subject: [PATCH 2/6] Ad cfg80211 call for threshold notifications
To: linux-wireless@vger.kernel.org
Message-Id: <20101013224851.9C46820418@glenhelen.mtv.corp.google.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Similar to its rssi counterpart, provide a cfg80211 call for sending
bitrate change updates.

Signed-off-by: Paul Stewart <pstew@google.com>

---
 include/net/cfg80211.h |   18 ++++++++++++++++++
 net/wireless/mlme.c    |   13 +++++++++++++
 2 files changed, 31 insertions(+), 0 deletions(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 2a7936d..e7f044e 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -1146,6 +1146,7 @@ struct cfg80211_pmksa {
  * @set_power_mgmt: Configure WLAN power management. A timeout value of -1
  *	allows the driver to adjust the dynamic ps timeout value.
  * @set_cqm_rssi_config: Configure connection quality monitor RSSI threshold.
+ * @set_cqm_bitrate_config: Config connection quality monitor bitrate threshold.
  *
  * @mgmt_frame_register: Notify driver that a management frame type was
  *	registered. Note that this callback may not sleep, and cannot run
@@ -1301,6 +1302,10 @@ struct cfg80211_ops {
 				       struct net_device *dev,
 				       s32 rssi_thold, u32 rssi_hyst);
 
+	int	(*set_cqm_bitrate_config)(struct wiphy *wiphy,
+					  struct net_device *dev,
+					  u32 bitrate_thold);
+
 	void	(*mgmt_frame_register)(struct wiphy *wiphy,
 				       struct net_device *dev,
 				       u16 frame_type, bool reg);
@@ -2595,6 +2600,19 @@ void cfg80211_cqm_rssi_notify(struct net_device *dev,
 			      enum nl80211_cqm_rssi_threshold_event rssi_event,
 			      gfp_t gfp);
 
+/**
+ * cfg80211_cqm_bitrate_notify - connection quality monitoring bitrate event
+ * @dev: network device
+ * @rate: the new transmit rate
+ * @gfp: context flags
+ *
+ * This function is called when a the transmit bitrate changes, and
+ * connection quality monitoring is configured to capture these events.
+ */
+void cfg80211_cqm_bitrate_notify(struct net_device *dev,
+				 u32 bitrate,
+				 gfp_t gfp);
+
 /* Logging, debugging and troubleshooting/diagnostic helpers. */
 
 /* wiphy_printk helpers, similar to dev_printk */
diff --git a/net/wireless/mlme.c b/net/wireless/mlme.c
index 26838d9..ebb4e3a 100644
--- a/net/wireless/mlme.c
+++ b/net/wireless/mlme.c
@@ -1028,3 +1028,16 @@ void cfg80211_cqm_rssi_notify(struct net_device *dev,
 	nl80211_send_cqm_rssi_notify(rdev, dev, rssi_event, gfp);
 }
 EXPORT_SYMBOL(cfg80211_cqm_rssi_notify);
+
+void cfg80211_cqm_bitrate_notify(struct net_device *dev,
+				 u32 bitrate,
+				 gfp_t gfp)
+{
+	struct wireless_dev *wdev = dev->ieee80211_ptr;
+	struct wiphy *wiphy = wdev->wiphy;
+	struct cfg80211_registered_device *rdev = wiphy_to_dev(wiphy);
+
+	/* Indicate roaming trigger event to user space */
+	nl80211_send_cqm_bitrate_notify(rdev, dev, bitrate, gfp);
+}
+EXPORT_SYMBOL(cfg80211_cqm_bitrate_notify);
-- 
1.7.1


Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.neomailbox.net ([178.209.62.157]:30740 "EHLO
	s3.neomailbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754230AbaAULLK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Jan 2014 06:11:10 -0500
From: Antonio Quartulli <antonio@meshcoding.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	Antonio Quartulli <antonio@open-mesh.com>
Subject: [RFC 5/5] cfg80211: implement cfg80211_get_station
Date: Tue, 21 Jan 2014 12:09:51 +0100
Message-Id: <1390302591-3352-6-git-send-email-antonio@meshcoding.com> (sfid-20140121_121121_187569_7B1DDAA3)
In-Reply-To: <1390302591-3352-1-git-send-email-antonio@meshcoding.com>
References: <1390302591-3352-1-git-send-email-antonio@meshcoding.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Antonio Quartulli <antonio@open-mesh.com>

Implement and export the new cfg80211_get_station() API.
This utility can be used by other kernel modules to obtain
detailed information about a given wireless station.

It will be in particular useful to batman-adv which will
implement a wireless rate based metric.

Signed-off-by: Antonio Quartulli <antonio@open-mesh.com>
---
 include/net/cfg80211.h | 11 +++++++++++
 net/wireless/nl80211.c | 22 ++++++++++++++++++++++
 2 files changed, 33 insertions(+)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 51d5d94..8c4b6ee 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -1067,6 +1067,17 @@ struct station_info {
 };
 
 /**
+ * cfg80211_get_station - retrieve information about a given station
+ * @dev: the device where the station is supposed to be connected to
+ * @mac_addr: the mac address of the station of interest
+ * @sinfo: pointer to the structure to fill with the information
+ *
+ * Returns 0 on success or a negative error code otherwise.
+ */
+int cfg80211_get_station(struct net_device *dev, const u8 *mac_addr,
+			 struct station_info *sinfo);
+
+/**
  * enum monitor_flags - monitor flags
  *
  * Monitor interface configuration flags. Note that these must be the bits
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 6e78c62..acba667 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -3780,6 +3780,28 @@ static int nl80211_get_station(struct sk_buff *skb, struct genl_info *info)
 	return genlmsg_reply(msg, info);
 }
 
+int cfg80211_get_station(struct net_device *dev, const u8 *mac_addr,
+			 struct station_info *sinfo)
+{
+	struct cfg80211_registered_device *rdev;
+	struct wireless_dev *wdev;
+	int err;
+
+	wdev = dev->ieee80211_ptr;
+	if (!wdev)
+		return -EOPNOTSUPP;
+
+	rdev = wiphy_to_dev(wdev->wiphy);
+	if (!rdev->ops->get_station)
+		return -EOPNOTSUPP;
+
+	err = rdev_get_station(rdev, dev, mac_addr, sinfo);
+	if (err)
+		return err;
+
+	return 0;
+}
+
 int cfg80211_check_station_change(struct wiphy *wiphy,
 				  struct station_parameters *params,
 				  enum cfg80211_station_type statype)
-- 
1.8.5.3


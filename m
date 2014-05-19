Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.neomailbox.net ([178.209.62.157]:7479 "EHLO
	s3.neomailbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932616AbaESTye (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 May 2014 15:54:34 -0400
From: Antonio Quartulli <antonio@meshcoding.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: b.a.t.m.a.n@lists.open-mesh.org, devel@lists.open80211s.org,
	linux-wireless@vger.kernel.org,
	Antonio Quartulli <antonio@open-mesh.com>
Subject: [PATCHv4 3/3] cfg80211: implement cfg80211_get_station cfg80211 API
Date: Mon, 19 May 2014 21:53:21 +0200
Message-Id: <1400529201-31500-4-git-send-email-antonio@meshcoding.com> (sfid-20140519_215439_873016_4ADF9676)
In-Reply-To: <1400529201-31500-1-git-send-email-antonio@meshcoding.com>
References: <1400529201-31500-1-git-send-email-antonio@meshcoding.com>
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
 include/net/cfg80211.h  | 13 +++++++++++++
 net/wireless/rdev-ops.h |  2 +-
 net/wireless/util.c     | 18 ++++++++++++++++++
 3 files changed, 32 insertions(+), 1 deletion(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 857d647..a75fabd 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -1075,6 +1075,19 @@ struct station_info {
 };
 
 /**
+ * cfg80211_get_station - retrieve information about a given station
+ * @dev: the device where the station is supposed to be connected to
+ * @mac_addr: the mac address of the station of interest
+ * @sinfo: pointer to the structure to fill with the information
+ *
+ * Returns 0 on success and sinfo is filled with the available information
+ * otherwise returns a negative error code and the content of sinfo has to be
+ * considered undefined.
+ */
+int cfg80211_get_station(struct net_device *dev, const u8 *mac_addr,
+			 struct station_info *sinfo);
+
+/**
  * enum monitor_flags - monitor flags
  *
  * Monitor interface configuration flags. Note that these must be the bits
diff --git a/net/wireless/rdev-ops.h b/net/wireless/rdev-ops.h
index 00cdf73..d95bbe3 100644
--- a/net/wireless/rdev-ops.h
+++ b/net/wireless/rdev-ops.h
@@ -199,7 +199,7 @@ static inline int rdev_change_station(struct cfg80211_registered_device *rdev,
 }
 
 static inline int rdev_get_station(struct cfg80211_registered_device *rdev,
-				   struct net_device *dev, u8 *mac,
+				   struct net_device *dev, const u8 *mac,
 				   struct station_info *sinfo)
 {
 	int ret;
diff --git a/net/wireless/util.c b/net/wireless/util.c
index fa61ac9..728f1c0 100644
--- a/net/wireless/util.c
+++ b/net/wireless/util.c
@@ -1546,6 +1546,24 @@ unsigned int ieee80211_get_num_supported_channels(struct wiphy *wiphy)
 }
 EXPORT_SYMBOL(ieee80211_get_num_supported_channels);
 
+int cfg80211_get_station(struct net_device *dev, const u8 *mac_addr,
+			 struct station_info *sinfo)
+{
+	struct cfg80211_registered_device *rdev;
+	struct wireless_dev *wdev;
+
+	wdev = dev->ieee80211_ptr;
+	if (!wdev)
+		return -EOPNOTSUPP;
+
+	rdev = wiphy_to_rdev(wdev->wiphy);
+	if (!rdev->ops->get_station)
+		return -EOPNOTSUPP;
+
+	return rdev_get_station(rdev, dev, mac_addr, sinfo);
+}
+EXPORT_SYMBOL(cfg80211_get_station);
+
 /* See IEEE 802.1H for LLC/SNAP encapsulation/decapsulation */
 /* Ethernet-II snap header (RFC1042 for most EtherTypes) */
 const unsigned char rfc1042_header[] __aligned(2) =
-- 
1.8.5.5


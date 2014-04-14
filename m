Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.neomailbox.net ([178.209.62.157]:12961 "EHLO
	s3.neomailbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753489AbaDNOEH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Apr 2014 10:04:07 -0400
From: Antonio Quartulli <antonio@meshcoding.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: b.a.t.m.a.n@lists.open-mesh.org, linux-wireless@vger.kernel.org,
	devel@lists.open80211s.org,
	Antonio Quartulli <antonio@open-mesh.com>
Subject: [PATCH 7/7] cfg80211: implement cfg80211_get_station cfg80211 API
Date: Mon, 14 Apr 2014 16:03:25 +0200
Message-Id: <1397484205-20905-7-git-send-email-antonio@meshcoding.com> (sfid-20140414_160415_033597_F6CBB7D2)
In-Reply-To: <1397484205-20905-1-git-send-email-antonio@meshcoding.com>
References: <1397484205-20905-1-git-send-email-antonio@meshcoding.com>
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
 include/net/cfg80211.h | 13 +++++++++++++
 net/wireless/util.c    | 18 ++++++++++++++++++
 2 files changed, 31 insertions(+)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index d4b85f7..c890244 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -1065,6 +1065,19 @@ struct station_info {
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
diff --git a/net/wireless/util.c b/net/wireless/util.c
index d032a31..d84d61a 100644
--- a/net/wireless/util.c
+++ b/net/wireless/util.c
@@ -1498,6 +1498,24 @@ unsigned int ieee80211_get_num_supported_channels(struct wiphy *wiphy)
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
+	rdev = wiphy_to_dev(wdev->wiphy);
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
1.8.3.2


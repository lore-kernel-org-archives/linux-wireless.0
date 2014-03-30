Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.neomailbox.net ([178.209.62.157]:10526 "EHLO
	s3.neomailbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752537AbaC3Ufk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 30 Mar 2014 16:35:40 -0400
From: Antonio Quartulli <antonio@meshcoding.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: b.a.t.m.a.n@lists.open-mesh.org, linux-wireless@vger.kernel.org,
	devel@lists.open80211s.org,
	Antonio Quartulli <antonio@open-mesh.com>
Subject: [RFCv2 6/6] cfg80211: implement cfg80211_get_station cfg80211 API
Date: Sun, 30 Mar 2014 22:35:04 +0200
Message-Id: <1396211704-4677-7-git-send-email-antonio@meshcoding.com> (sfid-20140330_223546_735607_6F7A8A32)
In-Reply-To: <1396211704-4677-1-git-send-email-antonio@meshcoding.com>
References: <1396211704-4677-1-git-send-email-antonio@meshcoding.com>
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
 net/wireless/util.c    | 18 ++++++++++++++++++
 2 files changed, 29 insertions(+)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 4c8ebe9..45062aa 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -1065,6 +1065,17 @@ struct station_info {
 };
 
 /**
+ * cfg80211_get_station - retrieve information about a given station
+ * @dev: the device where the station is supposed to be connected to
+ * @mac_addr: the mac address of the station of interest
+ * @sinfo: pointer to the structure to fill with the information
+ *
+ * Returns 0 on success or a negative error code otherwise.
+ */
+int cfg80211_get_station(struct net_device *dev, u8 *mac_addr,
+			 struct station_info *sinfo);
+
+/**
  * enum monitor_flags - monitor flags
  *
  * Monitor interface configuration flags. Note that these must be the bits
diff --git a/net/wireless/util.c b/net/wireless/util.c
index c5d0208..c691cf8 100644
--- a/net/wireless/util.c
+++ b/net/wireless/util.c
@@ -1482,6 +1482,24 @@ unsigned int ieee80211_get_num_supported_channels(struct wiphy *wiphy)
 }
 EXPORT_SYMBOL(ieee80211_get_num_supported_channels);
 
+int cfg80211_get_station(struct net_device *dev, u8 *mac_addr,
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


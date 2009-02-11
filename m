Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:41223 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753084AbZBKWQ1 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Feb 2009 17:16:27 -0500
Subject: [PATCH] cfg80211: age scan results on resume
From: Dan Williams <dcbw@redhat.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes@sipsolutions.net>
Content-Type: text/plain
Date: Wed, 11 Feb 2009 17:14:43 -0500
Message-Id: <1234390484.14687.7.camel@localhost> (sfid-20090211_231631_855423_0C49A264)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Scanned BSS entries are timestamped with jiffies, which doesn't
increment across suspend and hibernate.  On resume, every BSS in the
scan list looks like it was scanned within the last 10 seconds,
irregardless of how long the machine was actually asleep.  Age scan
results on resume with the time spent during sleep so userspace has a
clue how old they really are.

Signed-off-by: Dan Williams <dcbw@redhat.com>
---

diff --git a/net/wireless/core.h b/net/wireless/core.h
index e29ad4c..5d0c682 100644
--- a/net/wireless/core.h
+++ b/net/wireless/core.h
@@ -49,6 +49,7 @@ struct cfg80211_registered_device {
 	struct rb_root bss_tree;
 	u32 bss_generation;
 	struct cfg80211_scan_request *scan_req; /* protected by RTNL */
+	unsigned long suspend_at;
 
 	/* must be last because of the way we do wiphy_priv(),
 	 * and it should at least be aligned to NETDEV_ALIGN */
@@ -113,5 +114,7 @@ void ieee80211_set_bitrate_flags(struct wiphy *wiphy);
 void wiphy_update_regulatory(struct wiphy *wiphy, enum reg_set_by setby);
 
 void cfg80211_bss_expire(struct cfg80211_registered_device *dev);
+void cfg80211_bss_age(struct cfg80211_registered_device *dev,
+                      unsigned long age_secs);
 
 #endif /* __NET_WIRELESS_CORE_H */
diff --git a/net/wireless/scan.c b/net/wireless/scan.c
index b1893c8..9fad163 100644
--- a/net/wireless/scan.c
+++ b/net/wireless/scan.c
@@ -62,6 +62,18 @@ static void bss_release(struct kref *ref)
 }
 
 /* must hold dev->bss_lock! */
+void cfg80211_bss_age(struct cfg80211_registered_device *dev,
+                      unsigned long age_secs)
+{
+	struct cfg80211_internal_bss *bss;
+	unsigned long age_jiffies = msecs_to_jiffies(age_secs * MSEC_PER_SEC);
+
+	list_for_each_entry(bss, &dev->bss_list, list) {
+		bss->ts -= age_jiffies;
+	}
+}
+
+/* must hold dev->bss_lock! */
 void cfg80211_bss_expire(struct cfg80211_registered_device *dev)
 {
 	struct cfg80211_internal_bss *bss, *tmp;
@@ -584,6 +596,15 @@ static void ieee80211_scan_add_ies(struct iw_request_info *info,
 	}
 }
 
+static inline unsigned int elapsed_jiffies_msecs(unsigned long start)
+{
+	unsigned long end = jiffies;
+
+	if (end >= start)
+		return jiffies_to_msecs(end - start);
+
+	return jiffies_to_msecs(end + (MAX_JIFFY_OFFSET - start) + 1);
+}
 
 static char *
 ieee80211_bss(struct iw_request_info *info,
@@ -763,8 +784,8 @@ ieee80211_bss(struct iw_request_info *info,
 						  &iwe, buf);
 		memset(&iwe, 0, sizeof(iwe));
 		iwe.cmd = IWEVCUSTOM;
-		sprintf(buf, " Last beacon: %dms ago",
-			jiffies_to_msecs(jiffies - bss->ts));
+		sprintf(buf, " Last beacon: %ums ago",
+			elapsed_jiffies_msecs(bss->ts));
 		iwe.u.data.length = strlen(buf);
 		current_ev = iwe_stream_add_point(info, current_ev,
 						  end_buf, &iwe, buf);
diff --git a/net/wireless/sysfs.c b/net/wireless/sysfs.c
index 26a72b0..76263c4 100644
--- a/net/wireless/sysfs.c
+++ b/net/wireless/sysfs.c
@@ -60,6 +60,8 @@ static int wiphy_suspend(struct device *dev, pm_message_t state)
 	struct cfg80211_registered_device *rdev = dev_to_rdev(dev);
 	int ret = 0;
 
+	rdev->suspend_at = get_seconds();
+
 	if (rdev->ops->suspend) {
 		rtnl_lock();
 		ret = rdev->ops->suspend(&rdev->wiphy);
@@ -74,6 +76,11 @@ static int wiphy_resume(struct device *dev)
 	struct cfg80211_registered_device *rdev = dev_to_rdev(dev);
 	int ret = 0;
 
+	/* Age scan results with time spent in suspend */
+	spin_lock_bh(&rdev->bss_lock);
+	cfg80211_bss_age(rdev, get_seconds() - rdev->suspend_at);
+	spin_unlock_bh(&rdev->bss_lock);
+
 	if (rdev->ops->resume) {
 		rtnl_lock();
 		ret = rdev->ops->resume(&rdev->wiphy);



Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog107.obsmtp.com ([74.125.149.197]:33996 "EHLO
	na3sys009aog107.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754321Ab2I0THR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Sep 2012 15:07:17 -0400
From: Bing Zhao <bzhao@marvell.com>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes@sipsolutions.net>,
	"John W. Linville" <linville@tuxdriver.com>,
	Sam Leffler <sleffler@chromium.org>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Stone Piao <piaoyun@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH v2 3/5] cfg80211: add support for flushing old scan results
Date: Thu, 27 Sep 2012 11:59:12 -0700
Message-Id: <1348772354-15936-4-git-send-email-bzhao@marvell.com> (sfid-20120927_210726_308867_3C5A92A5)
In-Reply-To: <1348772354-15936-1-git-send-email-bzhao@marvell.com>
References: <1348772354-15936-1-git-send-email-bzhao@marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sam Leffler <sleffler@chromium.org>

Add an NL80211_SCAN_FLAG_FLUSH flag that causes old bss cache
entries to be flushed on scan completion.  This is useful for
collecting guaranteed fresh scan/survey results (e.g. on resume).
Flushing only happens on successful completion of a scan;
i.e. it does not happen if the scan is aborted/canceled.

Signed-off-by: Sam Leffler <sleffler@chromium.org>
Tested-by: Amitkumar Karwar <akarwar@marvell.com>
Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 include/linux/nl80211.h |    2 ++
 include/net/cfg80211.h  |    4 ++++
 net/wireless/nl80211.c  |    1 +
 net/wireless/scan.c     |   31 +++++++++++++++++++++++++++----
 net/wireless/sme.c      |    1 +
 5 files changed, 35 insertions(+), 4 deletions(-)

diff --git a/include/linux/nl80211.h b/include/linux/nl80211.h
index e512baf..71400e7 100644
--- a/include/linux/nl80211.h
+++ b/include/linux/nl80211.h
@@ -3081,9 +3081,11 @@ enum nl80211_connect_failed_reason {
  * requests.
  *
  * @NL80211_SCAN_FLAG_LOW_PRIORITY: scan request has low priority
+ * @NL80211_SCAN_FLAG_FLUSH: flush cache before scanning
  */
 enum nl80211_scan_flags {
 	NL80211_SCAN_FLAG_LOW_PRIORITY			= 1<<0,
+	NL80211_SCAN_FLAG_FLUSH				= 1<<1,
 };
 
 #endif /* __LINUX_NL80211_H */
diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index ed659db..cc63a3a 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -995,9 +995,11 @@ struct cfg80211_ssid {
  * enum cfg80211_scan_flags -  scan request control flags
  *
  * @CFG80211_SCAN_FLAG_LOW_PRIORITY: scan request has low priority
+ * @CFG80211_SCAN__FLAG_FLUSH: flush cache before scanning
  */
 enum cfg80211_scan_flags {
 	CFG80211_SCAN_FLAG_LOW_PRIORITY	= NL80211_SCAN_FLAG_LOW_PRIORITY,
+	CFG80211_SCAN_FLAG_FLUSH	= NL80211_SCAN_FLAG_FLUSH,
 };
 
 /**
@@ -1012,6 +1014,7 @@ enum cfg80211_scan_flags {
  * @flags: bit field of flags controlling operation
  * @rates: bitmap of rates to advertise for each band
  * @wiphy: the wiphy this was for
+ * @scan_start: time (in jiffies) when the scan started
  * @wdev: the wireless device to scan for
  * @aborted: (internal) scan request was notified as aborted
  * @no_cck: used to send probe requests at non CCK rate in 2GHz band
@@ -1030,6 +1033,7 @@ struct cfg80211_scan_request {
 
 	/* internal */
 	struct wiphy *wiphy;
+	unsigned long scan_start;
 	bool aborted;
 	bool no_cck;
 
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index e4312f6..7133477 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -4347,6 +4347,7 @@ static int nl80211_trigger_scan(struct sk_buff *skb, struct genl_info *info)
 
 	request->wdev = wdev;
 	request->wiphy = &rdev->wiphy;
+	request->scan_start = jiffies;
 
 	rdev->scan_req = request;
 	err = rdev->ops->scan(&rdev->wiphy, request);
diff --git a/net/wireless/scan.c b/net/wireless/scan.c
index 9730c98..392e5a9 100644
--- a/net/wireless/scan.c
+++ b/net/wireless/scan.c
@@ -20,6 +20,9 @@
 
 #define IEEE80211_SCAN_RESULT_EXPIRE	(30 * HZ)
 
+static void __cfg80211_bss_expire(struct cfg80211_registered_device *dev,
+				  int maxage, unsigned long expire_time);
+
 void ___cfg80211_scan_done(struct cfg80211_registered_device *rdev, bool leak)
 {
 	struct cfg80211_scan_request *request;
@@ -47,8 +50,15 @@ void ___cfg80211_scan_done(struct cfg80211_registered_device *rdev, bool leak)
 
 	if (request->aborted)
 		nl80211_send_scan_aborted(rdev, wdev);
-	else
+	else {
+		if (request->flags & CFG80211_SCAN_FLAG_FLUSH) {
+			/* flush entries from previous scans */
+			spin_lock_bh(&rdev->bss_lock);
+			__cfg80211_bss_expire(rdev, 0, request->scan_start);
+			spin_unlock_bh(&rdev->bss_lock);
+		}
 		nl80211_send_scan_done(rdev, wdev);
+	}
 
 #ifdef CONFIG_CFG80211_WEXT
 	if (wdev->netdev && !request->aborted) {
@@ -198,7 +208,8 @@ static void __cfg80211_unlink_bss(struct cfg80211_registered_device *dev,
 }
 
 /* must hold dev->bss_lock! */
-void cfg80211_bss_expire(struct cfg80211_registered_device *dev)
+static void __cfg80211_bss_expire(struct cfg80211_registered_device *dev,
+				  int maxage, unsigned long expire_time)
 {
 	struct cfg80211_internal_bss *bss, *tmp;
 	bool expired = false;
@@ -206,8 +217,14 @@ void cfg80211_bss_expire(struct cfg80211_registered_device *dev)
 	list_for_each_entry_safe(bss, tmp, &dev->bss_list, list) {
 		if (atomic_read(&bss->hold))
 			continue;
-		if (!time_after(jiffies, bss->ts + IEEE80211_SCAN_RESULT_EXPIRE))
-			continue;
+		if (maxage) {
+			if (!time_after(jiffies, bss->ts + maxage))
+				continue;
+		} else {
+			if (!time_after(expire_time, bss->ts))
+				continue;
+		}
+
 		__cfg80211_unlink_bss(dev, bss);
 		expired = true;
 	}
@@ -216,6 +233,11 @@ void cfg80211_bss_expire(struct cfg80211_registered_device *dev)
 		dev->bss_generation++;
 }
 
+void cfg80211_bss_expire(struct cfg80211_registered_device *dev)
+{
+	__cfg80211_bss_expire(dev, IEEE80211_SCAN_RESULT_EXPIRE, 0);
+}
+
 const u8 *cfg80211_find_ie(u8 eid, const u8 *ies, int len)
 {
 	while (len > 2 && ies[0] != eid) {
@@ -962,6 +984,7 @@ int cfg80211_wext_siwscan(struct net_device *dev,
 	creq->ssids = (void *)&creq->channels[n_channels];
 	creq->n_channels = n_channels;
 	creq->n_ssids = 1;
+	creq->scan_start = jiffies;
 
 	/* translate "Scan on frequencies" request */
 	i = 0;
diff --git a/net/wireless/sme.c b/net/wireless/sme.c
index 6f39cb8..dde1d47 100644
--- a/net/wireless/sme.c
+++ b/net/wireless/sme.c
@@ -138,6 +138,7 @@ static int cfg80211_conn_scan(struct wireless_dev *wdev)
 
 	request->wdev = wdev;
 	request->wiphy = &rdev->wiphy;
+	request->scan_start = jiffies;
 
 	rdev->scan_req = request;
 
-- 
1.7.0.2


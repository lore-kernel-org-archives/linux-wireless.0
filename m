Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog116.obsmtp.com ([74.125.149.240]:49418 "EHLO
	na3sys009aog116.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752582Ab2JDEs2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 4 Oct 2012 00:48:28 -0400
From: Bing Zhao <bzhao@marvell.com>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes@sipsolutions.net>,
	"John W. Linville" <linville@tuxdriver.com>,
	Sam Leffler <sleffler@chromium.org>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH v3 4/5] cfg80211: add support for flushing old scan results
Date: Wed,  3 Oct 2012 21:47:45 -0700
Message-Id: <1349326066-28501-5-git-send-email-bzhao@marvell.com> (sfid-20121004_064831_861478_B8DEB12C)
In-Reply-To: <1349326066-28501-1-git-send-email-bzhao@marvell.com>
References: <1349326066-28501-1-git-send-email-bzhao@marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sam Leffler <sleffler@chromium.org>

Add an NL80211_SCAN_FLAG_FLUSH flag that causes old bss cache
entries to be flushed on scan completion. This is useful for
collecting guaranteed fresh scan/survey result (e.g. on resume).

For normal scan, flushing only happens on successful completion
of a scan; i.e. it does not happen if the scan is aborted.
For scheduled scan, previous scan results are flushed everytime
when we get new scan results.

Signed-off-by: Sam Leffler <sleffler@chromium.org>
Tested-by: Amitkumar Karwar <akarwar@marvell.com>
Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
v3: avoid static forward declaration (Johannes Berg)

 include/linux/nl80211.h |    2 +
 include/net/cfg80211.h  |    3 ++
 net/wireless/nl80211.c  |    2 +
 net/wireless/scan.c     |   65 ++++++++++++++++++++++++++++++++--------------
 net/wireless/sme.c      |    1 +
 5 files changed, 53 insertions(+), 20 deletions(-)

diff --git a/include/linux/nl80211.h b/include/linux/nl80211.h
index a1d5704..df1b04a 100644
--- a/include/linux/nl80211.h
+++ b/include/linux/nl80211.h
@@ -3092,9 +3092,11 @@ enum nl80211_connect_failed_reason {
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
index dcad5cd..dc54c0f 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -1003,6 +1003,7 @@ struct cfg80211_ssid {
  * @flags: bit field of flags controlling operation
  * @rates: bitmap of rates to advertise for each band
  * @wiphy: the wiphy this was for
+ * @scan_start: time (in jiffies) when the scan started
  * @wdev: the wireless device to scan for
  * @aborted: (internal) scan request was notified as aborted
  * @no_cck: used to send probe requests at non CCK rate in 2GHz band
@@ -1021,6 +1022,7 @@ struct cfg80211_scan_request {
 
 	/* internal */
 	struct wiphy *wiphy;
+	unsigned long scan_start;
 	bool aborted;
 	bool no_cck;
 
@@ -1072,6 +1074,7 @@ struct cfg80211_sched_scan_request {
 	/* internal */
 	struct wiphy *wiphy;
 	struct net_device *dev;
+	unsigned long scan_start;
 
 	/* keep last */
 	struct ieee80211_channel *channels[0];
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index b26b7f7..c562d8e 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -4376,6 +4376,7 @@ static int nl80211_trigger_scan(struct sk_buff *skb, struct genl_info *info)
 
 	request->wdev = wdev;
 	request->wiphy = &rdev->wiphy;
+	request->scan_start = jiffies;
 
 	rdev->scan_req = request;
 	err = rdev->ops->scan(&rdev->wiphy, request);
@@ -4613,6 +4614,7 @@ static int nl80211_start_sched_scan(struct sk_buff *skb,
 	request->dev = dev;
 	request->wiphy = &rdev->wiphy;
 	request->interval = interval;
+	request->scan_start = jiffies;
 
 	err = rdev->ops->sched_scan_start(&rdev->wiphy, dev, request);
 	if (!err) {
diff --git a/net/wireless/scan.c b/net/wireless/scan.c
index 2005096..646a64f 100644
--- a/net/wireless/scan.c
+++ b/net/wireless/scan.c
@@ -47,6 +47,27 @@ static void __cfg80211_unlink_bss(struct cfg80211_registered_device *dev,
 	kref_put(&bss->ref, bss_release);
 }
 
+/* must hold dev->bss_lock! */
+static void __cfg80211_bss_expire(struct cfg80211_registered_device *dev,
+				  unsigned long expire_time)
+{
+	struct cfg80211_internal_bss *bss, *tmp;
+	bool expired = false;
+
+	list_for_each_entry_safe(bss, tmp, &dev->bss_list, list) {
+		if (atomic_read(&bss->hold))
+			continue;
+		if (!time_after(expire_time, bss->ts))
+			continue;
+
+		__cfg80211_unlink_bss(dev, bss);
+		expired = true;
+	}
+
+	if (expired)
+		dev->bss_generation++;
+}
+
 void ___cfg80211_scan_done(struct cfg80211_registered_device *rdev, bool leak)
 {
 	struct cfg80211_scan_request *request;
@@ -72,10 +93,17 @@ void ___cfg80211_scan_done(struct cfg80211_registered_device *rdev, bool leak)
 	if (wdev->netdev)
 		cfg80211_sme_scan_done(wdev->netdev);
 
-	if (request->aborted)
+	if (request->aborted) {
 		nl80211_send_scan_aborted(rdev, wdev);
-	else
+	} else {
+		if (request->flags & NL80211_SCAN_FLAG_FLUSH) {
+			/* flush entries from previous scans */
+			spin_lock_bh(&rdev->bss_lock);
+			__cfg80211_bss_expire(rdev, request->scan_start);
+			spin_unlock_bh(&rdev->bss_lock);
+		}
 		nl80211_send_scan_done(rdev, wdev);
+	}
 
 #ifdef CONFIG_CFG80211_WEXT
 	if (wdev->netdev && !request->aborted) {
@@ -126,16 +154,26 @@ EXPORT_SYMBOL(cfg80211_scan_done);
 void __cfg80211_sched_scan_results(struct work_struct *wk)
 {
 	struct cfg80211_registered_device *rdev;
+	struct cfg80211_sched_scan_request *request;
 
 	rdev = container_of(wk, struct cfg80211_registered_device,
 			    sched_scan_results_wk);
 
+	request = rdev->sched_scan_req;
+
 	mutex_lock(&rdev->sched_scan_mtx);
 
 	/* we don't have sched_scan_req anymore if the scan is stopping */
-	if (rdev->sched_scan_req)
-		nl80211_send_sched_scan_results(rdev,
-						rdev->sched_scan_req->dev);
+	if (request) {
+		if (request->flags & NL80211_SCAN_FLAG_FLUSH) {
+			/* flush entries from previous scans */
+			spin_lock_bh(&rdev->bss_lock);
+			__cfg80211_bss_expire(rdev, request->scan_start);
+			spin_unlock_bh(&rdev->bss_lock);
+			request->scan_start = jiffies + request->interval;
+		}
+		nl80211_send_sched_scan_results(rdev, request->dev);
+	}
 
 	mutex_unlock(&rdev->sched_scan_mtx);
 }
@@ -197,23 +235,9 @@ void cfg80211_bss_age(struct cfg80211_registered_device *dev,
 	}
 }
 
-/* must hold dev->bss_lock! */
 void cfg80211_bss_expire(struct cfg80211_registered_device *dev)
 {
-	struct cfg80211_internal_bss *bss, *tmp;
-	bool expired = false;
-
-	list_for_each_entry_safe(bss, tmp, &dev->bss_list, list) {
-		if (atomic_read(&bss->hold))
-			continue;
-		if (!time_after(jiffies, bss->ts + IEEE80211_SCAN_RESULT_EXPIRE))
-			continue;
-		__cfg80211_unlink_bss(dev, bss);
-		expired = true;
-	}
-
-	if (expired)
-		dev->bss_generation++;
+	__cfg80211_bss_expire(dev, jiffies - IEEE80211_SCAN_RESULT_EXPIRE);
 }
 
 const u8 *cfg80211_find_ie(u8 eid, const u8 *ies, int len)
@@ -962,6 +986,7 @@ int cfg80211_wext_siwscan(struct net_device *dev,
 	creq->ssids = (void *)&creq->channels[n_channels];
 	creq->n_channels = n_channels;
 	creq->n_ssids = 1;
+	creq->scan_start = jiffies;
 
 	/* translate "Scan on frequencies" request */
 	i = 0;
diff --git a/net/wireless/sme.c b/net/wireless/sme.c
index 055d596..07d717e 100644
--- a/net/wireless/sme.c
+++ b/net/wireless/sme.c
@@ -138,6 +138,7 @@ static int cfg80211_conn_scan(struct wireless_dev *wdev)
 
 	request->wdev = wdev;
 	request->wiphy = &rdev->wiphy;
+	request->scan_start = jiffies;
 
 	rdev->scan_req = request;
 
-- 
1.7.0.4


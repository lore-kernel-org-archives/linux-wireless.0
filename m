Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog115.obsmtp.com ([74.125.149.238]:47135 "EHLO
	na3sys009aog115.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754201Ab2JRGgE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Oct 2012 02:36:04 -0400
From: Bing Zhao <bzhao@marvell.com>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes@sipsolutions.net>,
	"John W. Linville" <linville@tuxdriver.com>,
	Sam Leffler <sleffler@chromium.org>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Bing Zhao <bzhao@marvell.com>
Subject: [PATCH v6 5/6] cfg80211: add support for flushing old scan results
Date: Wed, 17 Oct 2012 23:34:30 -0700
Message-Id: <1350542071-26498-6-git-send-email-bzhao@marvell.com> (sfid-20121018_083608_506215_734BA232)
In-Reply-To: <1350542071-26498-1-git-send-email-bzhao@marvell.com>
References: <1350542071-26498-1-git-send-email-bzhao@marvell.com>
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

This feature is enabled by default. Drivers can disable it by
unsetting the NL80211_FEATURE_SCAN_FLUSH flag.

Signed-off-by: Sam Leffler <sleffler@chromium.org>
Tested-by: Amitkumar Karwar <akarwar@marvell.com>
Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
[invert polarity of feature flag to account for old kernels]
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 include/net/cfg80211.h       |    3 ++
 include/uapi/linux/nl80211.h |    4 ++
 net/wireless/core.c          |    2 +
 net/wireless/nl80211.c       |   14 ++++++--
 net/wireless/scan.c          |   66 +++++++++++++++++++++++++++++------------
 net/wireless/sme.c           |    1 +
 6 files changed, 66 insertions(+), 24 deletions(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index d95da8f..aa0e4a1 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -1005,6 +1005,7 @@ struct cfg80211_ssid {
  * @flags: bit field of flags controlling operation
  * @rates: bitmap of rates to advertise for each band
  * @wiphy: the wiphy this was for
+ * @scan_start: time (in jiffies) when the scan started
  * @wdev: the wireless device to scan for
  * @aborted: (internal) scan request was notified as aborted
  * @no_cck: used to send probe requests at non CCK rate in 2GHz band
@@ -1023,6 +1024,7 @@ struct cfg80211_scan_request {
 
 	/* internal */
 	struct wiphy *wiphy;
+	unsigned long scan_start;
 	bool aborted;
 	bool no_cck;
 
@@ -1074,6 +1076,7 @@ struct cfg80211_sched_scan_request {
 	/* internal */
 	struct wiphy *wiphy;
 	struct net_device *dev;
+	unsigned long scan_start;
 
 	/* keep last */
 	struct ieee80211_channel *channels[0];
diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index c68e15e..0e6277a 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -3049,6 +3049,7 @@ enum nl80211_ap_sme_features {
  *	equals (SAE) with user space SME (NL80211_CMD_AUTHENTICATE) in station
  *	mode
  * @NL80211_FEATURE_LOW_PRIORITY_SCAN: This driver supports low priority scan
+ * @NL80211_FEATURE_SCAN_FLUSH: Scan flush is supported
  */
 enum nl80211_feature_flags {
 	NL80211_FEATURE_SK_TX_STATUS			= 1 << 0,
@@ -3058,6 +3059,7 @@ enum nl80211_feature_flags {
 	NL80211_FEATURE_P2P_DEVICE_NEEDS_CHANNEL	= 1 << 4,
 	NL80211_FEATURE_SAE				= 1 << 5,
 	NL80211_FEATURE_LOW_PRIORITY_SCAN		= 1 << 6,
+	NL80211_FEATURE_SCAN_FLUSH			= 1 << 7,
 };
 
 /**
@@ -3100,9 +3102,11 @@ enum nl80211_connect_failed_reason {
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
diff --git a/net/wireless/core.c b/net/wireless/core.c
index 443d4d7..48c2ea4 100644
--- a/net/wireless/core.c
+++ b/net/wireless/core.c
@@ -370,6 +370,8 @@ struct wiphy *wiphy_new(const struct cfg80211_ops *ops, int sizeof_priv)
 	rdev->wiphy.rts_threshold = (u32) -1;
 	rdev->wiphy.coverage_class = 0;
 
+	rdev->wiphy.features = NL80211_FEATURE_SCAN_FLUSH;
+
 	return &rdev->wiphy;
 }
 EXPORT_SYMBOL(wiphy_new);
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index aee252d..9e5a720 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -4371,8 +4371,10 @@ static int nl80211_trigger_scan(struct sk_buff *skb, struct genl_info *info)
 	if (info->attrs[NL80211_ATTR_SCAN_FLAGS]) {
 		request->flags = nla_get_u32(
 			info->attrs[NL80211_ATTR_SCAN_FLAGS]);
-		if ((request->flags & NL80211_SCAN_FLAG_LOW_PRIORITY) &&
-		    !(wiphy->features & NL80211_FEATURE_LOW_PRIORITY_SCAN)) {
+		if (((request->flags & NL80211_SCAN_FLAG_LOW_PRIORITY) &&
+		     !(wiphy->features & NL80211_FEATURE_LOW_PRIORITY_SCAN)) ||
+		    ((request->flags & NL80211_SCAN_FLAG_FLUSH) &&
+		     !(wiphy->features & NL80211_FEATURE_SCAN_FLUSH))) {
 			err = -EOPNOTSUPP;
 			goto out_free;
 		}
@@ -4383,6 +4385,7 @@ static int nl80211_trigger_scan(struct sk_buff *skb, struct genl_info *info)
 
 	request->wdev = wdev;
 	request->wiphy = &rdev->wiphy;
+	request->scan_start = jiffies;
 
 	rdev->scan_req = request;
 	err = rdev->ops->scan(&rdev->wiphy, request);
@@ -4612,8 +4615,10 @@ static int nl80211_start_sched_scan(struct sk_buff *skb,
 	if (info->attrs[NL80211_ATTR_SCAN_FLAGS]) {
 		request->flags = nla_get_u32(
 			info->attrs[NL80211_ATTR_SCAN_FLAGS]);
-		if ((request->flags & NL80211_SCAN_FLAG_LOW_PRIORITY) &&
-		    !(wiphy->features & NL80211_FEATURE_LOW_PRIORITY_SCAN)) {
+		if (((request->flags & NL80211_SCAN_FLAG_LOW_PRIORITY) &&
+		     !(wiphy->features & NL80211_FEATURE_LOW_PRIORITY_SCAN)) ||
+		    ((request->flags & NL80211_SCAN_FLAG_FLUSH) &&
+		     !(wiphy->features & NL80211_FEATURE_SCAN_FLUSH))) {
 			err = -EOPNOTSUPP;
 			goto out_free;
 		}
@@ -4622,6 +4627,7 @@ static int nl80211_start_sched_scan(struct sk_buff *skb,
 	request->dev = dev;
 	request->wiphy = &rdev->wiphy;
 	request->interval = interval;
+	request->scan_start = jiffies;
 
 	err = rdev->ops->sched_scan_start(&rdev->wiphy, dev, request);
 	if (!err) {
diff --git a/net/wireless/scan.c b/net/wireless/scan.c
index 2005096..a8d5a9a 100644
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
@@ -126,16 +154,27 @@ EXPORT_SYMBOL(cfg80211_scan_done);
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
+			request->scan_start =
+				jiffies + msecs_to_jiffies(request->interval);
+		}
+		nl80211_send_sched_scan_results(rdev, request->dev);
+	}
 
 	mutex_unlock(&rdev->sched_scan_mtx);
 }
@@ -197,23 +236,9 @@ void cfg80211_bss_age(struct cfg80211_registered_device *dev,
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
@@ -962,6 +987,7 @@ int cfg80211_wext_siwscan(struct net_device *dev,
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


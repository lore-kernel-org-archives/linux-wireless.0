Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vc0-f202.google.com ([209.85.220.202]:55312 "EHLO
	mail-vc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757352Ab2IZQ7y (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Sep 2012 12:59:54 -0400
Received: by vcbfy27 with SMTP id fy27so90135vcb.1
        for <linux-wireless@vger.kernel.org>; Wed, 26 Sep 2012 09:59:53 -0700 (PDT)
From: Sam Leffler <sleffler@chromium.org>
Date: Fri, 21 Sep 2012 11:08:24 -0700
Subject: [PATCH 3/3] cfg80211: add support for flushing old scan results
To: "John W . Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Message-Id: <20120926165952.BC0E71E051D@sleffler.sfo.corp.google.com> (sfid-20120926_190000_308679_319A2C08)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add an NL80211_SCAN_FLAG_FLUSH flag that causes old bss cache entries to
be flushed on scan completion.  This is useful for collecting guaranteed
fresh scan/survey results (e.g. on resume).  Flushing only happens on
successful completion of a scan; i.e. it does not happen if the scan
is aborted/canceled.

Change-Id: I7741a30857b1dc425f152d1db83c846f09cf8299
Signed-off-by: Sam Leffler <sleffler@chromium.org>
---
 include/linux/nl80211.h |    2 ++
 include/net/cfg80211.h  |    4 ++++
 net/wireless/nl80211.c  |    1 +
 net/wireless/scan.c     |   24 +++++++++++++++++++++---
 net/wireless/sme.c      |    1 +
 5 files changed, 29 insertions(+), 3 deletions(-)

diff --git a/include/linux/nl80211.h b/include/linux/nl80211.h
index 0b37d1d..4cb7676 100644
--- a/include/linux/nl80211.h
+++ b/include/linux/nl80211.h
@@ -3057,9 +3057,11 @@ enum nl80211_probe_resp_offload_support_attr {
  * requests.
  *
  * @NL80211_SCAN_FLAG_TX_ABORT: abort scan if tx collides
+ * @NL80211_SCAN_FLAG_FLUSH: flush cache before scanning
  */
 enum nl80211_scan_flags {
 	NL80211_SCAN_FLAG_TX_ABORT			= 1<<0,
+	NL80211_SCAN_FLAG_FLUSH				= 1<<1,
 };
 
 #endif /* __LINUX_NL80211_H */
diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index a6a10ff..c5da2bd 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -995,9 +995,11 @@ struct cfg80211_ssid {
  * enum cfg80211_scan_flags -  scan request control flags
  *
  * @CFG80211_SCAN__FLAG_TX_ABORT: abort scan on pending transmit
+ * @CFG80211_SCAN__FLAG_FLUSH: flush cache before scanning
  */
 enum cfg80211_scan_flags {
 	CFG80211_SCAN_FLAG_TX_ABORT	= NL80211_SCAN_FLAG_TX_ABORT,
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
index cbd2904..5edc7d8 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -4347,6 +4347,7 @@ static int nl80211_trigger_scan(struct sk_buff *skb, struct genl_info *info)
 
 	request->wdev = wdev;
 	request->wiphy = &rdev->wiphy;
+	request->scan_start = jiffies;
 
 	rdev->scan_req = request;
 	err = rdev->ops->scan(&rdev->wiphy, request);
diff --git a/net/wireless/scan.c b/net/wireless/scan.c
index 9730c98..c3bc184 100644
--- a/net/wireless/scan.c
+++ b/net/wireless/scan.c
@@ -20,6 +20,9 @@
 
 #define IEEE80211_SCAN_RESULT_EXPIRE	(30 * HZ)
 
+static void __cfg80211_bss_expire(struct cfg80211_registered_device *dev,
+				  int maxage);
+
 void ___cfg80211_scan_done(struct cfg80211_registered_device *rdev, bool leak)
 {
 	struct cfg80211_scan_request *request;
@@ -47,8 +50,16 @@ void ___cfg80211_scan_done(struct cfg80211_registered_device *rdev, bool leak)
 
 	if (request->aborted)
 		nl80211_send_scan_aborted(rdev, wdev);
-	else
+	else {
+		if (request->flags & CFG80211_SCAN_FLAG_FLUSH) {
+			/* flush entries from previous scans */
+			spin_lock_bh(&rdev->bss_lock);
+			__cfg80211_bss_expire(rdev,
+				jiffies - request->scan_start);
+			spin_unlock_bh(&rdev->bss_lock);
+		}
 		nl80211_send_scan_done(rdev, wdev);
+	}
 
 #ifdef CONFIG_CFG80211_WEXT
 	if (wdev->netdev && !request->aborted) {
@@ -198,7 +209,8 @@ static void __cfg80211_unlink_bss(struct cfg80211_registered_device *dev,
 }
 
 /* must hold dev->bss_lock! */
-void cfg80211_bss_expire(struct cfg80211_registered_device *dev)
+static void __cfg80211_bss_expire(struct cfg80211_registered_device *dev,
+				  int maxage)
 {
 	struct cfg80211_internal_bss *bss, *tmp;
 	bool expired = false;
@@ -206,7 +218,7 @@ void cfg80211_bss_expire(struct cfg80211_registered_device *dev)
 	list_for_each_entry_safe(bss, tmp, &dev->bss_list, list) {
 		if (atomic_read(&bss->hold))
 			continue;
-		if (!time_after(jiffies, bss->ts + IEEE80211_SCAN_RESULT_EXPIRE))
+		if (!time_after(jiffies, bss->ts + maxage))
 			continue;
 		__cfg80211_unlink_bss(dev, bss);
 		expired = true;
@@ -216,6 +228,11 @@ void cfg80211_bss_expire(struct cfg80211_registered_device *dev)
 		dev->bss_generation++;
 }
 
+void cfg80211_bss_expire(struct cfg80211_registered_device *dev)
+{
+	__cfg80211_bss_expire(dev, IEEE80211_SCAN_RESULT_EXPIRE);
+}
+
 const u8 *cfg80211_find_ie(u8 eid, const u8 *ies, int len)
 {
 	while (len > 2 && ies[0] != eid) {
@@ -962,6 +979,7 @@ int cfg80211_wext_siwscan(struct net_device *dev,
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
1.7.7.3


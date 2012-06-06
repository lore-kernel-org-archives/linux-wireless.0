Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:53644 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750994Ab2FFXTx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Jun 2012 19:19:53 -0400
Received: by mail-pb0-f46.google.com with SMTP id rp8so197408pbb.19
        for <linux-wireless@vger.kernel.org>; Wed, 06 Jun 2012 16:19:53 -0700 (PDT)
From: Jason Abele <jason@cozybit.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	devel@lists.open80211s.org,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: [PATCH v2 3/5] mac80211: Keep tx rate averages for mesh peers for better metric calculation.
Date: Wed,  6 Jun 2012 16:19:33 -0700
Message-Id: <1339024775-15405-4-git-send-email-jason@cozybit.com> (sfid-20120607_011956_950247_AEC5391A)
In-Reply-To: <1339024775-15405-1-git-send-email-jason@cozybit.com>
References: <1339024775-15405-1-git-send-email-jason@cozybit.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Javier Cardona <javier@cozybit.com>

The mesh metric is computed every time it was requested by the path
selection framework.  At that time only the last_tx_rate was taken into
account when computing the metric.  This last frame may not reflect the
average data rate that was possible ver that peer link (it could be a
management frame, a rate control probe, or other outlier).

This patch maintains an average tx rate for each peer link which is used
in metric calculation.

Signed-off-by: Javier Cardona <javier@cozybit.com>
---
 net/mac80211/mesh_hwmp.c |   24 +++++++++++++++---------
 net/mac80211/sta_info.c  |    1 +
 net/mac80211/sta_info.h  |    1 +
 3 files changed, 17 insertions(+), 9 deletions(-)

diff --git a/net/mac80211/mesh_hwmp.c b/net/mac80211/mesh_hwmp.c
index acbd1ad..8fb3e59 100644
--- a/net/mac80211/mesh_hwmp.c
+++ b/net/mac80211/mesh_hwmp.c
@@ -307,7 +307,9 @@ void ieee80211s_update_metric(struct ieee80211_local *local,
 {
 	struct ieee80211_tx_info *txinfo = IEEE80211_SKB_CB(skb);
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *) skb->data;
+	struct rate_info rinfo;
 	int failed;
+	int rate;
 
 	if (!ieee80211_is_data(hdr->frame_control))
 		return;
@@ -318,36 +320,40 @@ void ieee80211s_update_metric(struct ieee80211_local *local,
 	stainfo->fail_avg = ((80 * stainfo->fail_avg + 5) / 100 + 20 * failed);
 	if (stainfo->fail_avg > 95)
 		mesh_plink_broken(stainfo);
+
+	sta_set_rate_info_tx(stainfo, &stainfo->last_tx_rate, &rinfo);
+	rate = cfg80211_calculate_bitrate(&rinfo);
+	if (WARN_ON(!rate))
+		return;
+
+	ewma_add(&stainfo->avg_rate, rate);
+	return;
 }
 
 static u32 airtime_link_metric_get(struct ieee80211_local *local,
 				   struct sta_info *sta)
 {
-	struct rate_info rinfo;
 	/* This should be adjusted for each device */
 	int device_constant = 1 << ARITH_SHIFT;
 	int test_frame_len = TEST_FRAME_LEN << ARITH_SHIFT;
 	int s_unit = 1 << ARITH_SHIFT;
-	int rate, err;
 	u32 tx_time, estimated_retx;
 	u64 result;
+	int rate;
+	int err = (sta->fail_avg << ARITH_SHIFT) / 100;
 
 	if (sta->fail_avg >= 100)
 		return MAX_METRIC;
 
-	sta_set_rate_info_tx(sta, &sta->last_tx_rate, &rinfo);
-	rate = cfg80211_calculate_bitrate(&rinfo);
-	if (WARN_ON(!rate))
-		return MAX_METRIC;
-
-	err = (sta->fail_avg << ARITH_SHIFT) / 100;
+	/* If not enough values accumulated in rate average, assume 1 Mbps */
+	rate = max(ewma_read(&sta->avg_rate), 10UL);
 
 	/* bitrate is in units of 100 Kbps, while we need rate in units of
 	 * 1Mbps. This will be corrected on tx_time computation.
 	 */
 	tx_time = (device_constant + 10 * test_frame_len / rate);
 	estimated_retx = ((1 << (2 * ARITH_SHIFT)) / (s_unit - err));
-	result = (tx_time * estimated_retx) >> (2 * ARITH_SHIFT) ;
+	result = (tx_time * estimated_retx) >> (2 * ARITH_SHIFT);
 	return (u32)result;
 }
 
diff --git a/net/mac80211/sta_info.c b/net/mac80211/sta_info.c
index 77dcf2f..ddbec7b 100644
--- a/net/mac80211/sta_info.c
+++ b/net/mac80211/sta_info.c
@@ -256,6 +256,7 @@ struct sta_info *sta_info_alloc(struct ieee80211_sub_if_data *sdata,
 	do_posix_clock_monotonic_gettime(&uptime);
 	sta->last_connected = uptime.tv_sec;
 	ewma_init(&sta->avg_signal, 1024, 8);
+	ewma_init(&sta->avg_rate, 1, 32);
 
 	if (sta_prepare_rate_control(local, sta, gfp)) {
 		kfree(sta);
diff --git a/net/mac80211/sta_info.h b/net/mac80211/sta_info.h
index 3bb24a1..0bf888e 100644
--- a/net/mac80211/sta_info.h
+++ b/net/mac80211/sta_info.h
@@ -330,6 +330,7 @@ struct sta_info {
 	unsigned long tx_retry_failed, tx_retry_count;
 	/* moving percentage of failed MSDUs */
 	unsigned int fail_avg;
+	struct ewma avg_rate;
 
 	/* Updated from TX path only, no locking requirements */
 	unsigned long tx_packets;
-- 
1.7.9.5


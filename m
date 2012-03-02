Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f46.google.com ([209.85.210.46]:59761 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965407Ab2CBXFc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 2 Mar 2012 18:05:32 -0500
Received: by mail-pz0-f46.google.com with SMTP id r28so2500808daj.19
        for <linux-wireless@vger.kernel.org>; Fri, 02 Mar 2012 15:05:32 -0800 (PST)
MIME-Version: 1.0
From: Thomas Pedersen <thomas@cozybit.com>
To: linux-wireless@vger.kernel.org
Cc: devel@lists.open80211s.org, Thomas Pedersen <thomas@cozybit.com>,
	johannes@sipsolutions.net, linville@tuxdriver.com
Subject: [PATCH 3/3] mac80211: fix mesh airtime link metric estimating
Date: Fri,  2 Mar 2012 15:05:24 -0800
Message-Id: <1330729524-1010-3-git-send-email-thomas@cozybit.com> (sfid-20120303_000542_290976_4F80F825)
In-Reply-To: <1330729524-1010-1-git-send-email-thomas@cozybit.com>
References: <1330729524-1010-1-git-send-email-thomas@cozybit.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Airtime link metric estimation was broken in HT mesh, use
cfg80211_calculate_bitrate to get the right rate value.

Signed-off-by: Thomas Pedersen <thomas@cozybit.com>
---
 net/mac80211/mesh_hwmp.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/net/mac80211/mesh_hwmp.c b/net/mac80211/mesh_hwmp.c
index 31bc762..d4cc3e3 100644
--- a/net/mac80211/mesh_hwmp.c
+++ b/net/mac80211/mesh_hwmp.c
@@ -323,6 +323,7 @@ static u32 airtime_link_metric_get(struct ieee80211_local *local,
 				   struct sta_info *sta)
 {
 	struct ieee80211_supported_band *sband;
+	struct station_info sinfo;
 	/* This should be adjusted for each device */
 	int device_constant = 1 << ARITH_SHIFT;
 	int test_frame_len = TEST_FRAME_LEN << ARITH_SHIFT;
@@ -336,7 +337,9 @@ static u32 airtime_link_metric_get(struct ieee80211_local *local,
 	if (sta->fail_avg >= 100)
 		return MAX_METRIC;
 
-	if (sta->last_tx_rate.flags & IEEE80211_TX_RC_MCS)
+	sta_set_sinfo(sta, &sinfo);
+	rate = cfg80211_calculate_bitrate(&sinfo.txrate);
+	if (WARN_ON(!rate))
 		return MAX_METRIC;
 
 	err = (sta->fail_avg << ARITH_SHIFT) / 100;
@@ -344,7 +347,6 @@ static u32 airtime_link_metric_get(struct ieee80211_local *local,
 	/* bitrate is in units of 100 Kbps, while we need rate in units of
 	 * 1Mbps. This will be corrected on tx_time computation.
 	 */
-	rate = sband->bitrates[sta->last_tx_rate.idx].bitrate;
 	tx_time = (device_constant + 10 * test_frame_len / rate);
 	estimated_retx = ((1 << (2 * ARITH_SHIFT)) / (s_unit - err));
 	result = (tx_time * estimated_retx) >> (2 * ARITH_SHIFT) ;
-- 
1.7.5.4


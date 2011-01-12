Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arroyo.ext.ti.com ([192.94.94.40]:40476 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755331Ab1ALMkk (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Jan 2011 07:40:40 -0500
From: <coelho@ti.com>
To: <linux-wireless@vger.kernel.org>
CC: juuso.oikarinen@nokia.com
Subject: [PATCH 1/2] mac80211: add hw configuration for max ampdu buffer size
Date: Wed, 12 Jan 2011 14:40:51 +0200
Message-ID: <1294836052-16828-1-git-send-email-coelho@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luciano Coelho <coelho@ti.com>

Some devices don't support the maximum AMDPU buffer size of 64, so we
need to add an option to configure this in the hardware configuration.
This value will be used in the ADDBA response instead of the value
suggested in the request, if the latter is greater than the max
supported.

Signed-off-by: Luciano Coelho <coelho@ti.com>
---
 include/net/mac80211.h |    4 ++++
 net/mac80211/agg-rx.c  |    3 +++
 net/mac80211/main.c    |    1 +
 3 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 5b3fd5a..1341d82 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -1143,6 +1143,9 @@ enum ieee80211_hw_flags {
  * @napi_weight: weight used for NAPI polling.  You must specify an
  *	appropriate value here if a napi_poll operation is provided
  *	by your driver.
+ * @max_rx_aggregation_subframes: maximum buffer size (number of
+ *	sub-frames) to be used for A-MPDU block ack receiver
+ *	aggregation.
  */
 struct ieee80211_hw {
 	struct ieee80211_conf conf;
@@ -1161,6 +1164,7 @@ struct ieee80211_hw {
 	u8 max_rates;
 	u8 max_report_rates;
 	u8 max_rate_tries;
+	u8 max_rx_aggregation_subframes;
 };
 
 /**
diff --git a/net/mac80211/agg-rx.c b/net/mac80211/agg-rx.c
index f138b19..002db5e 100644
--- a/net/mac80211/agg-rx.c
+++ b/net/mac80211/agg-rx.c
@@ -239,6 +239,9 @@ void ieee80211_process_addba_request(struct ieee80211_local *local,
 		buf_size = buf_size << sband->ht_cap.ampdu_factor;
 	}
 
+	/* make sure the size doesn't exceed the maximum supported by the hw */
+	if (buf_size > local->hw.max_rx_aggregation_subframes)
+		buf_size = local->hw.max_rx_aggregation_subframes;
 
 	/* examine state machine */
 	mutex_lock(&sta->ampdu_mlme.mtx);
diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index 485d36b..1c507c6 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -552,6 +552,7 @@ struct ieee80211_hw *ieee80211_alloc_hw(size_t priv_data_len,
 	local->hw.queues = 1;
 	local->hw.max_rates = 1;
 	local->hw.max_report_rates = 0;
+	local->hw.max_rx_aggregation_subframes = IEEE80211_MAX_AMPDU_BUF;
 	local->hw.conf.long_frame_max_tx_count = wiphy->retry_long;
 	local->hw.conf.short_frame_max_tx_count = wiphy->retry_short;
 	local->user_power_level = -1;
-- 
1.7.1


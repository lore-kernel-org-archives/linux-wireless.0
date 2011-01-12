Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bear.ext.ti.com ([192.94.94.41]:53289 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756014Ab1ALN0Y (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Jan 2011 08:26:24 -0500
From: <coelho@ti.com>
To: <linville@tuxdriver.com>
CC: linux-wireless@vger.kernel.org, Luciano Coelho <coelho@ti.com>
Subject: [PATCH v2] mac80211: add hw configuration for max ampdu buffer size
Date: Wed, 12 Jan 2011 15:26:30 +0200
Message-ID: <1294838790-408-1-git-send-email-coelho@ti.com>
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
Tested-by: Juuso Oikarinen <juuso.oikarinen@nokia.com>
---
 include/net/mac80211.h |    8 ++++++++
 net/mac80211/agg-rx.c  |    3 +++
 net/mac80211/main.c    |    1 +
 3 files changed, 12 insertions(+), 0 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 5b3fd5a..e651988 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -1143,6 +1143,13 @@ enum ieee80211_hw_flags {
  * @napi_weight: weight used for NAPI polling.  You must specify an
  *	appropriate value here if a napi_poll operation is provided
  *	by your driver.
+
+ * @max_rx_aggregation_subframes: maximum buffer size (number of
+ *	sub-frames) to be used for A-MPDU block ack receiver
+ *	aggregation.
+ *	This is only relevant if the device has restrictions on the
+ *	number of subframes, if it relies on mac80211 to do reordering
+ *	it shouldn't be set.
  */
 struct ieee80211_hw {
 	struct ieee80211_conf conf;
@@ -1161,6 +1168,7 @@ struct ieee80211_hw {
 	u8 max_rates;
 	u8 max_report_rates;
 	u8 max_rate_tries;
+	u8 max_rx_aggregation_subframes;
 };
 
 /**
diff --git a/net/mac80211/agg-rx.c b/net/mac80211/agg-rx.c
index 227ca82..1274440 100644
--- a/net/mac80211/agg-rx.c
+++ b/net/mac80211/agg-rx.c
@@ -232,6 +232,9 @@ void ieee80211_process_addba_request(struct ieee80211_local *local,
 	if (buf_size == 0)
 		buf_size = IEEE80211_MAX_AMPDU_BUF;
 
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


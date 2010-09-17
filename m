Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:59370 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753957Ab0IQOju (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 17 Sep 2010 10:39:50 -0400
Received: by wyf22 with SMTP id 22so2419768wyf.19
        for <linux-wireless@vger.kernel.org>; Fri, 17 Sep 2010 07:39:49 -0700 (PDT)
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net,
	Helmut Schaa <helmut.schaa@googlemail.com>
Subject: [RFC] mac80211: distinct between max rates and the number of rates the hw can report
Date: Fri, 17 Sep 2010 16:39:45 +0200
Message-Id: <1284734385-16064-1-git-send-email-helmut.schaa@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Some drivers cannot handle multiple retrie rates specified by the rc
algorithm but instead use their own retry table (for example rt2800).
However, if such a device registers itself with a max_rates value of 1
the rc algorithm cannot make use of the extended information the device
can provide about retried rates. On the other hand, if a device
registers itself with a max_rates value > 1 the rc algorithm assumes
that the device can handle multi rate retries.

Fix this issue by introducing another hw parameter max_report_rates that
can be set to a different value then max_rates to indicate if a device
is capable of reporting more rates then specified in max_rates. If
max_report_rates is not specified by the driver fall back to max_rates
to not change the behavior for other drivers.

Signed-off-by: Helmut Schaa <helmut.schaa@googlemail.com>
---

Not sure but I guess zd1211rw could make use of this as well.

If there are no objections I'll send this patch (together with the change
in rt2x00) through Ivo's rt2x00 tree.

Thanks,
Helmut

 include/net/mac80211.h |    6 +++++-
 net/mac80211/main.c    |    4 ++++
 net/mac80211/status.c  |    2 +-
 3 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 19a5cb4..7e1426c 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -1092,7 +1092,10 @@ enum ieee80211_hw_flags {
  * @sta_data_size: size (in bytes) of the drv_priv data area
  *	within &struct ieee80211_sta.
  *
- * @max_rates: maximum number of alternate rate retry stages
+ * @max_rates: maximum number of alternate rate retry stages the hw
+ * 	can handle.
+ * @max_report_rates: maximum number of alternate rate retry stages
+ * 	the hw can report back.
  * @max_rate_tries: maximum number of tries for each stage
  *
  * @napi_weight: weight used for NAPI polling.  You must specify an
@@ -1114,6 +1117,7 @@ struct ieee80211_hw {
 	u16 max_listen_interval;
 	s8 max_signal;
 	u8 max_rates;
+	u8 max_report_rates;
 	u8 max_rate_tries;
 };
 
diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index bf0eb6a..da95ede 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -517,6 +517,7 @@ struct ieee80211_hw *ieee80211_alloc_hw(size_t priv_data_len,
 	/* set up some defaults */
 	local->hw.queues = 1;
 	local->hw.max_rates = 1;
+	local->hw.max_report_rates = 0;
 	local->hw.conf.long_frame_max_tx_count = wiphy->retry_long;
 	local->hw.conf.short_frame_max_tx_count = wiphy->retry_short;
 	local->user_power_level = -1;
@@ -592,6 +593,9 @@ int ieee80211_register_hw(struct ieee80211_hw *hw)
 		WLAN_CIPHER_SUITE_AES_CMAC
 	};
 
+	if (hw->max_report_rates == 0)
+		hw->max_report_rates = hw->max_rates;
+
 	/*
 	 * generic code guarantees at least one band,
 	 * set this very early because much code assumes
diff --git a/net/mac80211/status.c b/net/mac80211/status.c
index 571b32b..855000d 100644
--- a/net/mac80211/status.c
+++ b/net/mac80211/status.c
@@ -175,7 +175,7 @@ void ieee80211_tx_status(struct ieee80211_hw *hw, struct sk_buff *skb)
 
 	for (i = 0; i < IEEE80211_TX_MAX_RATES; i++) {
 		/* the HW cannot have attempted that rate */
-		if (i >= hw->max_rates) {
+		if (i >= hw->max_report_rates) {
 			info->status.rates[i].idx = -1;
 			info->status.rates[i].count = 0;
 		} else if (info->status.rates[i].idx >= 0) {
-- 
1.7.1


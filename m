Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:45566 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754138Ab0JBJfe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 2 Oct 2010 05:35:34 -0400
Received: by mail-ww0-f44.google.com with SMTP id 40so2321956wwj.1
        for <linux-wireless@vger.kernel.org>; Sat, 02 Oct 2010 02:35:34 -0700 (PDT)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 13/20] mac80211: distinct between max rates and the number of rates the hw can report
Date: Sat, 2 Oct 2010 11:31:55 +0200
Cc: users@rt2x00.serialmonkey.com, linux-wireless@vger.kernel.org,
	Helmut Schaa <helmut.schaa@googlemail.com>
References: <201010021126.18748.IvDoorn@gmail.com> <201010021131.06386.IvDoorn@gmail.com> <201010021131.33951.IvDoorn@gmail.com>
In-Reply-To: <201010021131.33951.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201010021131.56454.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Helmut Schaa <helmut.schaa@googlemail.com>

Some drivers cannot handle multiple retry rates specified by the rc
algorithm but instead use their own retry table (for example rt2800).
However, if such a device registers itself with a max_rates value of 1
the rc algorithm cannot make use of the extended information the device
can provide about retried rates. On the other hand, if a device
registers itself with a max_rates value > 1 the rc algorithm assumes
that the device can handle multi rate retries.

Fix this issue by introducing another hw parameter max_report_rates that
can be set to a different value then max_rates to indicate if a device
is capable of reporting more rates then specified in max_rates.

Signed-off-by: Helmut Schaa <helmut.schaa@googlemail.com>
Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 include/net/mac80211.h |    6 +++++-
 net/mac80211/main.c    |    4 ++++
 net/mac80211/status.c  |    2 +-
 3 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 12a49f0..2f11881 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -1095,7 +1095,10 @@ enum ieee80211_hw_flags {
  * @sta_data_size: size (in bytes) of the drv_priv data area
  *	within &struct ieee80211_sta.
  *
- * @max_rates: maximum number of alternate rate retry stages
+ * @max_rates: maximum number of alternate rate retry stages the hw
+ *	can handle.
+ * @max_report_rates: maximum number of alternate rate retry stages
+ *	the hw can report back.
  * @max_rate_tries: maximum number of tries for each stage
  *
  * @napi_weight: weight used for NAPI polling.  You must specify an
@@ -1117,6 +1120,7 @@ struct ieee80211_hw {
 	u16 max_listen_interval;
 	s8 max_signal;
 	u8 max_rates;
+	u8 max_report_rates;
 	u8 max_rate_tries;
 };
 
diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index 18fdeca..f245c83 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -532,6 +532,7 @@ struct ieee80211_hw *ieee80211_alloc_hw(size_t priv_data_len,
 	/* set up some defaults */
 	local->hw.queues = 1;
 	local->hw.max_rates = 1;
+	local->hw.max_report_rates = 0;
 	local->hw.conf.long_frame_max_tx_count = wiphy->retry_long;
 	local->hw.conf.short_frame_max_tx_count = wiphy->retry_short;
 	local->user_power_level = -1;
@@ -607,6 +608,9 @@ int ieee80211_register_hw(struct ieee80211_hw *hw)
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
1.7.2.3


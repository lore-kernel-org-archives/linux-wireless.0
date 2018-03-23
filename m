Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:45480 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752443AbeCWOGW (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 23 Mar 2018 10:06:22 -0400
From: Anilkumar Kolli <akolli@codeaurora.org>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH v2] ath10k: Implement get_expected_throughput callback
Date: Fri, 23 Mar 2018 19:37:14 +0530
Message-Id: <1521814034-17880-1-git-send-email-akolli@codeaurora.org> (sfid-20180323_150626_390965_AB10BB85)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Enable support for 'drv_get_expected_throughput' callback.
Export expected throughput if available to cfg80211/nl80211.

Signed-off-by: Anilkumar Kolli <akolli@codeaurora.org>
Signed-off-by: Tamizh chelvam <tamizhr@codeaurora.org>
---
v2:
  - update the avg for all the transmitted frames(Sven)
  - remove the unnecessary NL80211_STA_INFO_EXPECTED_THROUGHPUT update(Sven)

 drivers/net/wireless/ath/ath10k/core.h   |    5 +++++
 drivers/net/wireless/ath/ath10k/htt_rx.c |    4 ++++
 drivers/net/wireless/ath/ath10k/mac.c    |    9 +++++++++
 3 files changed, 18 insertions(+)

diff --git a/drivers/net/wireless/ath/ath10k/core.h b/drivers/net/wireless/ath/ath10k/core.h
index fe6b30356d3b..8e10f7d83a79 100644
--- a/drivers/net/wireless/ath/ath10k/core.h
+++ b/drivers/net/wireless/ath/ath10k/core.h
@@ -1,6 +1,7 @@
 /*
  * Copyright (c) 2005-2011 Atheros Communications Inc.
  * Copyright (c) 2011-2017 Qualcomm Atheros, Inc.
+ * Copyright (c) 2018, The Linux Foundation. All rights reserved.
  *
  * Permission to use, copy, modify, and/or distribute this software for any
  * purpose with or without fee is hereby granted, provided that the above
@@ -37,6 +38,7 @@
 #include "thermal.h"
 #include "wow.h"
 #include "swap.h"
+#include <linux/average.h>
 
 #define MS(_v, _f) (((_v) & _f##_MASK) >> _f##_LSB)
 #define SM(_v, _f) (((_v) << _f##_LSB) & _f##_MASK)
@@ -354,6 +356,8 @@ struct ath10k_txq {
 	unsigned long num_push_allowed;
 };
 
+DECLARE_EWMA(sta_txrate, 4, 16)
+
 struct ath10k_sta {
 	struct ath10k_vif *arvif;
 
@@ -367,6 +371,7 @@ struct ath10k_sta {
 
 	struct work_struct update_wk;
 	u64 rx_duration;
+	struct ewma_sta_txrate ave_sta_txrate;
 
 #ifdef CONFIG_MAC80211_DEBUGFS
 	/* protected by conf_mutex */
diff --git a/drivers/net/wireless/ath/ath10k/htt_rx.c b/drivers/net/wireless/ath/ath10k/htt_rx.c
index 6d96f9560950..9fd8b22552c6 100644
--- a/drivers/net/wireless/ath/ath10k/htt_rx.c
+++ b/drivers/net/wireless/ath/ath10k/htt_rx.c
@@ -2449,6 +2449,7 @@ static inline bool is_valid_legacy_rate(u8 rate)
 	struct ath10k_sta *arsta = (struct ath10k_sta *)sta->drv_priv;
 	u8 rate = 0, sgi;
 	struct rate_info txrate;
+	u32 tx_bitrate;
 
 	lockdep_assert_held(&ar->data_lock);
 
@@ -2500,6 +2501,9 @@ static inline bool is_valid_legacy_rate(u8 rate)
 
 	arsta->txrate.nss = txrate.nss;
 	arsta->txrate.bw = txrate.bw + RATE_INFO_BW_20;
+
+	tx_bitrate = cfg80211_calculate_bitrate(&arsta->txrate);
+	ewma_sta_txrate_add(&arsta->ave_sta_txrate, tx_bitrate);
 }
 
 static void ath10k_htt_fetch_peer_stats(struct ath10k *ar,
diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index 7e02ca02b28e..33e790cf5c42 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -7688,6 +7688,14 @@ static void ath10k_sta_statistics(struct ieee80211_hw *hw,
 	sinfo->filled |= 1ULL << NL80211_STA_INFO_TX_BITRATE;
 }
 
+static u32 ath10k_get_expected_throughput(struct ieee80211_hw *hw,
+					  struct ieee80211_sta *sta)
+{
+	struct ath10k_sta *arsta = (struct ath10k_sta *)sta->drv_priv;
+
+	return ewma_sta_txrate_read(&arsta->ave_sta_txrate);
+}
+
 static const struct ieee80211_ops ath10k_ops = {
 	.tx				= ath10k_mac_op_tx,
 	.wake_tx_queue			= ath10k_mac_op_wake_tx_queue,
@@ -7730,6 +7738,7 @@ static void ath10k_sta_statistics(struct ieee80211_hw *hw,
 	.switch_vif_chanctx		= ath10k_mac_op_switch_vif_chanctx,
 	.sta_pre_rcu_remove		= ath10k_mac_op_sta_pre_rcu_remove,
 	.sta_statistics			= ath10k_sta_statistics,
+	.get_expected_throughput	= ath10k_get_expected_throughput,
 
 	CFG80211_TESTMODE_CMD(ath10k_tm_cmd)
 
-- 
1.7.9.5

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arrakis.dune.hu ([78.24.191.176]:42266 "EHLO arrakis.dune.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755373Ab3JKLTR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 11 Oct 2013 07:19:17 -0400
From: Gabor Juhos <juhosg@openwrt.org>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com,
	Gabor Juhos <juhosg@openwrt.org>
Subject: [PATCH 2/5] rt2x00: rt2x00lib: use rt2x00_has_cap_* helpers
Date: Fri, 11 Oct 2013 13:18:41 +0200
Message-Id: <1381490324-14746-2-git-send-email-juhosg@openwrt.org> (sfid-20131011_131921_379214_1F35A707)
In-Reply-To: <1381490324-14746-1-git-send-email-juhosg@openwrt.org>
References: <1381490324-14746-1-git-send-email-juhosg@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Use the appropriate helper functions instead of
directly accessing the rt2x00dev->cap_flags field
to check device capability flags.

This improves readability of the code a bit.

Signed-off-by: Gabor Juhos <juhosg@openwrt.org>
---
 drivers/net/wireless/rt2x00/rt2x00crypto.c |    4 ++--
 drivers/net/wireless/rt2x00/rt2x00debug.c  |    2 +-
 drivers/net/wireless/rt2x00/rt2x00dev.c    |    8 ++++----
 drivers/net/wireless/rt2x00/rt2x00link.c   |    4 ++--
 drivers/net/wireless/rt2x00/rt2x00mac.c    |    6 +++---
 drivers/net/wireless/rt2x00/rt2x00queue.c  |    2 +-
 6 files changed, 13 insertions(+), 13 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2x00crypto.c b/drivers/net/wireless/rt2x00/rt2x00crypto.c
index 1ca4c7f..3db0d99 100644
--- a/drivers/net/wireless/rt2x00/rt2x00crypto.c
+++ b/drivers/net/wireless/rt2x00/rt2x00crypto.c
@@ -52,7 +52,7 @@ void rt2x00crypto_create_tx_descriptor(struct rt2x00_dev *rt2x00dev,
 	struct ieee80211_tx_info *tx_info = IEEE80211_SKB_CB(skb);
 	struct ieee80211_key_conf *hw_key = tx_info->control.hw_key;
 
-	if (!test_bit(CAPABILITY_HW_CRYPTO, &rt2x00dev->cap_flags) || !hw_key)
+	if (!rt2x00_has_cap_hw_crypto(rt2x00dev) || !hw_key)
 		return;
 
 	__set_bit(ENTRY_TXD_ENCRYPT, &txdesc->flags);
@@ -80,7 +80,7 @@ unsigned int rt2x00crypto_tx_overhead(struct rt2x00_dev *rt2x00dev,
 	struct ieee80211_key_conf *key = tx_info->control.hw_key;
 	unsigned int overhead = 0;
 
-	if (!test_bit(CAPABILITY_HW_CRYPTO, &rt2x00dev->cap_flags) || !key)
+	if (!rt2x00_has_cap_hw_crypto(rt2x00dev) || !key)
 		return overhead;
 
 	/*
diff --git a/drivers/net/wireless/rt2x00/rt2x00debug.c b/drivers/net/wireless/rt2x00/rt2x00debug.c
index fe7a7f6..7f7baae 100644
--- a/drivers/net/wireless/rt2x00/rt2x00debug.c
+++ b/drivers/net/wireless/rt2x00/rt2x00debug.c
@@ -750,7 +750,7 @@ void rt2x00debug_register(struct rt2x00_dev *rt2x00dev)
 				intf, &rt2x00debug_fop_queue_stats);
 
 #ifdef CONFIG_RT2X00_LIB_CRYPTO
-	if (test_bit(CAPABILITY_HW_CRYPTO, &rt2x00dev->cap_flags))
+	if (rt2x00_has_cap_hw_crypto(rt2x00dev))
 		intf->crypto_stats_entry =
 		    debugfs_create_file("crypto", S_IRUGO, intf->queue_folder,
 					intf, &rt2x00debug_fop_crypto_stats);
diff --git a/drivers/net/wireless/rt2x00/rt2x00dev.c b/drivers/net/wireless/rt2x00/rt2x00dev.c
index 712eea9..080b1fc 100644
--- a/drivers/net/wireless/rt2x00/rt2x00dev.c
+++ b/drivers/net/wireless/rt2x00/rt2x00dev.c
@@ -88,7 +88,7 @@ int rt2x00lib_enable_radio(struct rt2x00_dev *rt2x00dev)
 	rt2x00queue_start_queues(rt2x00dev);
 	rt2x00link_start_tuner(rt2x00dev);
 	rt2x00link_start_agc(rt2x00dev);
-	if (test_bit(CAPABILITY_VCO_RECALIBRATION, &rt2x00dev->cap_flags))
+	if (rt2x00_has_cap_vco_recalibration(rt2x00dev))
 		rt2x00link_start_vcocal(rt2x00dev);
 
 	/*
@@ -113,7 +113,7 @@ void rt2x00lib_disable_radio(struct rt2x00_dev *rt2x00dev)
 	 * Stop all queues
 	 */
 	rt2x00link_stop_agc(rt2x00dev);
-	if (test_bit(CAPABILITY_VCO_RECALIBRATION, &rt2x00dev->cap_flags))
+	if (rt2x00_has_cap_vco_recalibration(rt2x00dev))
 		rt2x00link_stop_vcocal(rt2x00dev);
 	rt2x00link_stop_tuner(rt2x00dev);
 	rt2x00queue_stop_queues(rt2x00dev);
@@ -234,7 +234,7 @@ void rt2x00lib_beacondone(struct rt2x00_dev *rt2x00dev)
 	 * here as they will fetch the next beacon directly prior to
 	 * transmission.
 	 */
-	if (test_bit(CAPABILITY_PRE_TBTT_INTERRUPT, &rt2x00dev->cap_flags))
+	if (rt2x00_has_cap_pre_tbtt_interrupt(rt2x00dev))
 		return;
 
 	/* fetch next beacon */
@@ -358,7 +358,7 @@ void rt2x00lib_txdone(struct queue_entry *entry,
 	 * mac80211 will expect the same data to be present it the
 	 * frame as it was passed to us.
 	 */
-	if (test_bit(CAPABILITY_HW_CRYPTO, &rt2x00dev->cap_flags))
+	if (rt2x00_has_cap_hw_crypto(rt2x00dev))
 		rt2x00crypto_tx_insert_iv(entry->skb, header_length);
 
 	/*
diff --git a/drivers/net/wireless/rt2x00/rt2x00link.c b/drivers/net/wireless/rt2x00/rt2x00link.c
index a0e3c02..c2b3b66 100644
--- a/drivers/net/wireless/rt2x00/rt2x00link.c
+++ b/drivers/net/wireless/rt2x00/rt2x00link.c
@@ -353,7 +353,7 @@ static void rt2x00link_tuner(struct work_struct *work)
 	 * do not support link tuning at all, while other devices can disable
 	 * the feature from the EEPROM.
 	 */
-	if (test_bit(CAPABILITY_LINK_TUNING, &rt2x00dev->cap_flags))
+	if (rt2x00_has_cap_link_tuning(rt2x00dev))
 		rt2x00dev->ops->lib->link_tuner(rt2x00dev, qual, link->count);
 
 	/*
@@ -493,7 +493,7 @@ static void rt2x00link_vcocal(struct work_struct *work)
 void rt2x00link_register(struct rt2x00_dev *rt2x00dev)
 {
 	INIT_DELAYED_WORK(&rt2x00dev->link.agc_work, rt2x00link_agc);
-	if (test_bit(CAPABILITY_VCO_RECALIBRATION, &rt2x00dev->cap_flags))
+	if (rt2x00_has_cap_vco_recalibration(rt2x00dev))
 		INIT_DELAYED_WORK(&rt2x00dev->link.vco_work, rt2x00link_vcocal);
 	INIT_DELAYED_WORK(&rt2x00dev->link.watchdog_work, rt2x00link_watchdog);
 	INIT_DELAYED_WORK(&rt2x00dev->link.work, rt2x00link_tuner);
diff --git a/drivers/net/wireless/rt2x00/rt2x00mac.c b/drivers/net/wireless/rt2x00/rt2x00mac.c
index f883802..51f17cf 100644
--- a/drivers/net/wireless/rt2x00/rt2x00mac.c
+++ b/drivers/net/wireless/rt2x00/rt2x00mac.c
@@ -382,11 +382,11 @@ void rt2x00mac_configure_filter(struct ieee80211_hw *hw,
 	 * of different types, but has no a separate filter for PS Poll frames,
 	 * FIF_CONTROL flag implies FIF_PSPOLL.
 	 */
-	if (!test_bit(CAPABILITY_CONTROL_FILTERS, &rt2x00dev->cap_flags)) {
+	if (!rt2x00_has_cap_control_filters(rt2x00dev)) {
 		if (*total_flags & FIF_CONTROL || *total_flags & FIF_PSPOLL)
 			*total_flags |= FIF_CONTROL | FIF_PSPOLL;
 	}
-	if (!test_bit(CAPABILITY_CONTROL_FILTER_PSPOLL, &rt2x00dev->cap_flags)) {
+	if (!rt2x00_has_cap_control_filter_pspoll(rt2x00dev)) {
 		if (*total_flags & FIF_CONTROL)
 			*total_flags |= FIF_PSPOLL;
 	}
@@ -469,7 +469,7 @@ int rt2x00mac_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
 	if (!test_bit(DEVICE_STATE_PRESENT, &rt2x00dev->flags))
 		return 0;
 
-	if (!test_bit(CAPABILITY_HW_CRYPTO, &rt2x00dev->cap_flags))
+	if (!rt2x00_has_cap_hw_crypto(rt2x00dev))
 		return -EOPNOTSUPP;
 
 	/*
diff --git a/drivers/net/wireless/rt2x00/rt2x00queue.c b/drivers/net/wireless/rt2x00/rt2x00queue.c
index 218e320..50590b1 100644
--- a/drivers/net/wireless/rt2x00/rt2x00queue.c
+++ b/drivers/net/wireless/rt2x00/rt2x00queue.c
@@ -61,7 +61,7 @@ struct sk_buff *rt2x00queue_alloc_rxskb(struct queue_entry *entry, gfp_t gfp)
 	 * at least 8 bytes bytes available in headroom for IV/EIV
 	 * and 8 bytes for ICV data as tailroon.
 	 */
-	if (test_bit(CAPABILITY_HW_CRYPTO, &rt2x00dev->cap_flags)) {
+	if (rt2x00_has_cap_hw_crypto(rt2x00dev)) {
 		head_size += 8;
 		tail_size += 8;
 	}
-- 
1.7.10

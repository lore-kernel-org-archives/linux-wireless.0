Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:33480 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752919Ab1KYSlM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 25 Nov 2011 13:41:12 -0500
Received: by mail-ey0-f174.google.com with SMTP id k14so988570eaa.19
        for <linux-wireless@vger.kernel.org>; Fri, 25 Nov 2011 10:41:11 -0800 (PST)
From: Nick Kossifidis <mickflemm@gmail.com>
To: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, me@bobcopeland.com, mcgrof@gmail.com,
	nbd@openwrt.org, jirislaby@gmail.com,
	Nick Kossifidis <mickflemm@gmail.com>
Subject: [PATCH v2 09/12] ath5k: MRR support and 2GHz radio override belong in ah_capabilities
Date: Fri, 25 Nov 2011 20:40:28 +0200
Message-Id: <1322246431-10825-10-git-send-email-mickflemm@gmail.com> (sfid-20111125_194131_925529_668B32B5)
In-Reply-To: <1322246431-10825-1-git-send-email-mickflemm@gmail.com>
References: <1322246431-10825-1-git-send-email-mickflemm@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

MRR support and 2GHz radio override belong in ah_capabilities and we
should use them (e.g. so far  we used to set mrr descriptor without
checking if MRR support is enabled + we checked for MRR support 2
times, one by trying to set up an MRR descriptor and another one based
on MAC version).

Signed-off-by: Nick Kossifidis <mickflemm@gmail.com>
---
 drivers/net/wireless/ath/ath5k/ahb.c    |    4 ++-
 drivers/net/wireless/ath/ath5k/ath5k.h  |   12 ++++----
 drivers/net/wireless/ath/ath5k/attach.c |    5 ---
 drivers/net/wireless/ath/ath5k/base.c   |   47 ++++++++++++-------------------
 drivers/net/wireless/ath/ath5k/caps.c   |   27 +++++++++++++----
 5 files changed, 47 insertions(+), 48 deletions(-)

diff --git a/drivers/net/wireless/ath/ath5k/ahb.c b/drivers/net/wireless/ath/ath5k/ahb.c
index e5be7e70..ee7ea57 100644
--- a/drivers/net/wireless/ath/ath5k/ahb.c
+++ b/drivers/net/wireless/ath/ath5k/ahb.c
@@ -166,7 +166,9 @@ static int ath_ahb_probe(struct platform_device *pdev)
 		if (to_platform_device(ah->dev)->id == 0 &&
 		    (bcfg->config->flags & (BD_WLAN0 | BD_WLAN1)) ==
 		     (BD_WLAN1 | BD_WLAN0))
-			__set_bit(ATH_STAT_2G_DISABLED, ah->status);
+			ah->ah_capabilities.cap_needs_2GHz_ovr = true;
+		else
+			ah->ah_capabilities.cap_needs_2GHz_ovr = false;
 	}
 
 	ret = ath5k_init_ah(ah, &ath_ahb_bus_ops);
diff --git a/drivers/net/wireless/ath/ath5k/ath5k.h b/drivers/net/wireless/ath/ath5k/ath5k.h
index 819c4db5..c3815f7 100644
--- a/drivers/net/wireless/ath/ath5k/ath5k.h
+++ b/drivers/net/wireless/ath/ath5k/ath5k.h
@@ -1159,6 +1159,8 @@ struct ath5k_capabilities {
 	} cap_queues;
 
 	bool cap_has_phyerr_counters;
+	bool cap_has_mrr_support;
+	bool cap_needs_2GHz_ovr;
 };
 
 /* size of noise floor history (keep it a power of two) */
@@ -1274,13 +1276,11 @@ struct ath5k_hw {
 	dma_addr_t		desc_daddr;	/* DMA (physical) address */
 	size_t			desc_len;	/* size of TX/RX descriptors */
 
-	DECLARE_BITMAP(status, 6);
+	DECLARE_BITMAP(status, 4);
 #define ATH_STAT_INVALID	0		/* disable hardware accesses */
-#define ATH_STAT_MRRETRY	1		/* multi-rate retry support */
-#define ATH_STAT_PROMISC	2
-#define ATH_STAT_LEDSOFT	3		/* enable LED gpio status */
-#define ATH_STAT_STARTED	4		/* opened & irqs enabled */
-#define ATH_STAT_2G_DISABLED	5		/* multiband radio without 2G */
+#define ATH_STAT_PROMISC	1
+#define ATH_STAT_LEDSOFT	2		/* enable LED gpio status */
+#define ATH_STAT_STARTED	3		/* opened & irqs enabled */
 
 	unsigned int		filter_flags;	/* HW flags, AR5K_RX_FILTER_* */
 	struct ieee80211_channel *curchan;	/* current h/w channel */
diff --git a/drivers/net/wireless/ath/ath5k/attach.c b/drivers/net/wireless/ath/ath5k/attach.c
index b69e057..d7114c7 100644
--- a/drivers/net/wireless/ath/ath5k/attach.c
+++ b/drivers/net/wireless/ath/ath5k/attach.c
@@ -306,11 +306,6 @@ int ath5k_hw_init(struct ath5k_hw *ah)
 		goto err;
 	}
 
-	if (test_bit(ATH_STAT_2G_DISABLED, ah->status)) {
-		__clear_bit(AR5K_MODE_11B, ah->ah_capabilities.cap_mode);
-		__clear_bit(AR5K_MODE_11G, ah->ah_capabilities.cap_mode);
-	}
-
 	/* Crypto settings */
 	common->keymax = (ah->ah_version == AR5K_AR5210 ?
 			  AR5K_KEYTABLE_SIZE_5210 : AR5K_KEYTABLE_SIZE_5211);
diff --git a/drivers/net/wireless/ath/ath5k/base.c b/drivers/net/wireless/ath/ath5k/base.c
index 02207fa..178a4dd 100644
--- a/drivers/net/wireless/ath/ath5k/base.c
+++ b/drivers/net/wireless/ath/ath5k/base.c
@@ -725,21 +725,24 @@ ath5k_txbuf_setup(struct ath5k_hw *ah, struct ath5k_buf *bf,
 	if (ret)
 		goto err_unmap;
 
-	memset(mrr_rate, 0, sizeof(mrr_rate));
-	memset(mrr_tries, 0, sizeof(mrr_tries));
-	for (i = 0; i < 3; i++) {
-		rate = ieee80211_get_alt_retry_rate(ah->hw, info, i);
-		if (!rate)
-			break;
+	/* Set up MRR descriptor */
+	if (ah->ah_capabilities.cap_has_mrr_support) {
+		memset(mrr_rate, 0, sizeof(mrr_rate));
+		memset(mrr_tries, 0, sizeof(mrr_tries));
+		for (i = 0; i < 3; i++) {
+			rate = ieee80211_get_alt_retry_rate(ah->hw, info, i);
+			if (!rate)
+				break;
 
-		mrr_rate[i] = rate->hw_value;
-		mrr_tries[i] = info->control.rates[i + 1].count;
-	}
+			mrr_rate[i] = rate->hw_value;
+			mrr_tries[i] = info->control.rates[i + 1].count;
+		}
 
-	ath5k_hw_setup_mrr_tx_desc(ah, ds,
-		mrr_rate[0], mrr_tries[0],
-		mrr_rate[1], mrr_tries[1],
-		mrr_rate[2], mrr_tries[2]);
+		ath5k_hw_setup_mrr_tx_desc(ah, ds,
+			mrr_rate[0], mrr_tries[0],
+			mrr_rate[1], mrr_tries[1],
+			mrr_rate[2], mrr_tries[2]);
+	}
 
 	ds->ds_link = 0;
 	ds->ds_data = bf->skbaddr;
@@ -2489,8 +2492,8 @@ ath5k_init_ah(struct ath5k_hw *ah, const struct ath_bus_ops *bus_ops)
 	if (ret)
 		goto err_irq;
 
-	/* set up multi-rate retry capabilities */
-	if (ah->ah_version == AR5K_AR5212) {
+	/* Set up multi-rate retry capabilities */
+	if (ah->ah_capabilities.cap_has_mrr_support) {
 		hw->max_rates = 4;
 		hw->max_rate_tries = max(AR5K_INIT_RETRY_SHORT,
 					 AR5K_INIT_RETRY_LONG);
@@ -2849,20 +2852,6 @@ ath5k_init(struct ieee80211_hw *hw)
 
 
 	/*
-	 * Check if the MAC has multi-rate retry support.
-	 * We do this by trying to setup a fake extended
-	 * descriptor.  MACs that don't have support will
-	 * return false w/o doing anything.  MACs that do
-	 * support it will return true w/o doing anything.
-	 */
-	ret = ath5k_hw_setup_mrr_tx_desc(ah, NULL, 0, 0, 0, 0, 0, 0);
-
-	if (ret < 0)
-		goto err;
-	if (ret > 0)
-		__set_bit(ATH_STAT_MRRETRY, ah->status);
-
-	/*
 	 * Collect the channel list.  The 802.11 layer
 	 * is responsible for filtering this list based
 	 * on settings like the phy mode and regulatory
diff --git a/drivers/net/wireless/ath/ath5k/caps.c b/drivers/net/wireless/ath/ath5k/caps.c
index 810fba9..994169a 100644
--- a/drivers/net/wireless/ath/ath5k/caps.c
+++ b/drivers/net/wireless/ath/ath5k/caps.c
@@ -85,12 +85,19 @@ int ath5k_hw_set_capabilities(struct ath5k_hw *ah)
 			caps->cap_range.range_2ghz_min = 2412;
 			caps->cap_range.range_2ghz_max = 2732;
 
-			if (AR5K_EEPROM_HDR_11B(ee_header))
-				__set_bit(AR5K_MODE_11B, caps->cap_mode);
-
-			if (AR5K_EEPROM_HDR_11G(ee_header) &&
-			    ah->ah_version != AR5K_AR5211)
-				__set_bit(AR5K_MODE_11G, caps->cap_mode);
+			/* Override 2GHz modes on SoCs that need it
+			 * NOTE: cap_needs_2GHz_ovr gets set from
+			 * ath_ahb_probe */
+			if (!caps->cap_needs_2GHz_ovr) {
+				if (AR5K_EEPROM_HDR_11B(ee_header))
+					__set_bit(AR5K_MODE_11B,
+							caps->cap_mode);
+
+				if (AR5K_EEPROM_HDR_11G(ee_header) &&
+				ah->ah_version != AR5K_AR5211)
+					__set_bit(AR5K_MODE_11G,
+							caps->cap_mode);
+			}
 		}
 	}
 
@@ -103,12 +110,18 @@ int ath5k_hw_set_capabilities(struct ath5k_hw *ah)
 	else
 		caps->cap_queues.q_tx_num = AR5K_NUM_TX_QUEUES;
 
-	/* newer hardware has PHY error counters */
+	/* Newer hardware has PHY error counters */
 	if (ah->ah_mac_srev >= AR5K_SREV_AR5213A)
 		caps->cap_has_phyerr_counters = true;
 	else
 		caps->cap_has_phyerr_counters = false;
 
+	/* MACs since AR5212 have MRR support */
+	if (ah->ah_version == AR5K_AR5212)
+		caps->cap_has_mrr_support = true;
+	else
+		caps->cap_has_mrr_support = false;
+
 	return 0;
 }
 
-- 
1.7.8.rc3


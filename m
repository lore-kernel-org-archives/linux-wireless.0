Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:37319 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757727Ab2C1JGP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Mar 2012 05:06:15 -0400
Message-Id: <20120328090432.294221300@sipsolutions.net> (sfid-20120328_110622_832370_A11AA521)
Date: Wed, 28 Mar 2012 11:04:23 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 1/7] mac80211: remove antenna_sel_tx TX info field
References: <20120328090422.367469100@sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

This field is never set to anything non-zero in
mac80211, so we should be able to remove it.
Unfortunately though, the iwlwifi and iwlegacy
drivers use it for their internal TX status
processing (which shouldn't be using the rate
control API to start with), so add a new field
"status.antenna" for them, at least for now.

In the future, I plan to use the new field to
hold the hardware queue, while the SKB's queue
mapping holds the AC.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/b43/xmit.c           |    2 +-
 drivers/net/wireless/b43legacy/xmit.c     |   14 +-------------
 drivers/net/wireless/iwlegacy/4965-mac.c  |    4 ++--
 drivers/net/wireless/iwlegacy/4965-rs.c   |    2 +-
 drivers/net/wireless/iwlwifi/iwl-agn-rs.c |    2 +-
 drivers/net/wireless/iwlwifi/iwl-agn-tx.c |    4 ++--
 drivers/net/wireless/p54/txrx.c           |    3 +--
 include/net/mac80211.h                    |    7 ++++---
 8 files changed, 13 insertions(+), 25 deletions(-)

--- a/drivers/net/wireless/b43/xmit.c	2012-03-23 14:58:31.000000000 +0100
+++ b/drivers/net/wireless/b43/xmit.c	2012-03-23 14:59:06.000000000 +0100
@@ -378,7 +378,7 @@ int b43_generate_txhdr(struct b43_wldev
 	if (info->control.rates[0].flags & IEEE80211_TX_RC_USE_SHORT_PREAMBLE)
 		phy_ctl |= B43_TXH_PHY_SHORTPRMBL;
 
-	switch (b43_ieee80211_antenna_sanitize(dev, info->antenna_sel_tx)) {
+	switch (b43_ieee80211_antenna_sanitize(dev, 0)) {
 	case 0: /* Default */
 		phy_ctl |= B43_TXH_PHY_ANT01AUTO;
 		break;
--- a/drivers/net/wireless/b43legacy/xmit.c	2012-03-23 14:58:31.000000000 +0100
+++ b/drivers/net/wireless/b43legacy/xmit.c	2012-03-23 14:59:06.000000000 +0100
@@ -277,19 +277,7 @@ static int generate_txhdr_fw3(struct b43
 		phy_ctl |= B43legacy_TX4_PHY_ENC_OFDM;
 	if (info->control.rates[0].flags & IEEE80211_TX_RC_USE_SHORT_PREAMBLE)
 		phy_ctl |= B43legacy_TX4_PHY_SHORTPRMBL;
-	switch (info->antenna_sel_tx) {
-	case 0:
-		phy_ctl |= B43legacy_TX4_PHY_ANTLAST;
-		break;
-	case 1:
-		phy_ctl |= B43legacy_TX4_PHY_ANT0;
-		break;
-	case 2:
-		phy_ctl |= B43legacy_TX4_PHY_ANT1;
-		break;
-	default:
-		B43legacy_BUG_ON(1);
-	}
+	phy_ctl |= B43legacy_TX4_PHY_ANTLAST;
 
 	/* MAC control */
 	rates = info->control.rates;
--- a/drivers/net/wireless/p54/txrx.c	2012-03-23 14:58:31.000000000 +0100
+++ b/drivers/net/wireless/p54/txrx.c	2012-03-23 14:59:06.000000000 +0100
@@ -914,8 +914,7 @@ void p54_tx_80211(struct ieee80211_hw *d
 	txhdr->hw_queue = queue;
 	txhdr->backlog = priv->tx_stats[queue].len - 1;
 	memset(txhdr->durations, 0, sizeof(txhdr->durations));
-	txhdr->tx_antenna = ((info->antenna_sel_tx == 0) ?
-		2 : info->antenna_sel_tx - 1) & priv->tx_diversity_mask;
+	txhdr->tx_antenna = 2 & priv->tx_diversity_mask;
 	if (priv->rxhw == 5) {
 		txhdr->longbow.cts_rate = cts_rate;
 		txhdr->longbow.output_power = cpu_to_le16(priv->output_power);
--- a/include/net/mac80211.h	2012-03-23 14:58:31.000000000 +0100
+++ b/include/net/mac80211.h	2012-03-23 14:59:06.000000000 +0100
@@ -520,7 +520,7 @@ struct ieee80211_tx_rate {
  *
  * @flags: transmit info flags, defined above
  * @band: the band to transmit on (use for checking for races)
- * @antenna_sel_tx: antenna to use, 0 for automatic diversity
+ * @reserved: reserved for future use
  * @ack_frame_id: internal frame ID for TX status, used internally
  * @control: union for control data
  * @status: union for status data
@@ -536,7 +536,7 @@ struct ieee80211_tx_info {
 	u32 flags;
 	u8 band;
 
-	u8 antenna_sel_tx;
+	u8 reserved;
 
 	u16 ack_frame_id;
 
@@ -562,7 +562,8 @@ struct ieee80211_tx_info {
 			u8 ampdu_ack_len;
 			int ack_signal;
 			u8 ampdu_len;
-			/* 15 bytes free */
+			u8 antenna;
+			/* 14 bytes free */
 		} status;
 		struct {
 			struct ieee80211_tx_rate driver_rates[
--- a/drivers/net/wireless/iwlegacy/4965-mac.c	2012-03-23 14:58:31.000000000 +0100
+++ b/drivers/net/wireless/iwlegacy/4965-mac.c	2012-03-23 14:59:06.000000000 +0100
@@ -2849,9 +2849,9 @@ void
 il4965_hwrate_to_tx_control(struct il_priv *il, u32 rate_n_flags,
 			    struct ieee80211_tx_info *info)
 {
-	struct ieee80211_tx_rate *r = &info->control.rates[0];
+	struct ieee80211_tx_rate *r = &info->status.rates[0];
 
-	info->antenna_sel_tx =
+	info->status.antenna =
 	    ((rate_n_flags & RATE_MCS_ANT_ABC_MSK) >> RATE_MCS_ANT_POS);
 	if (rate_n_flags & RATE_MCS_HT_MSK)
 		r->flags |= IEEE80211_TX_RC_MCS;
--- a/drivers/net/wireless/iwlegacy/4965-rs.c	2012-03-23 14:58:31.000000000 +0100
+++ b/drivers/net/wireless/iwlegacy/4965-rs.c	2012-03-23 14:59:06.000000000 +0100
@@ -873,7 +873,7 @@ il4965_rs_tx_status(void *il_r, struct i
 	    tbl_type.is_SGI != !!(mac_flags & IEEE80211_TX_RC_SHORT_GI) ||
 	    tbl_type.is_ht40 != !!(mac_flags & IEEE80211_TX_RC_40_MHZ_WIDTH) ||
 	    tbl_type.is_dup != !!(mac_flags & IEEE80211_TX_RC_DUP_DATA) ||
-	    tbl_type.ant_type != info->antenna_sel_tx ||
+	    tbl_type.ant_type != info->status.antenna ||
 	    !!(tx_rate & RATE_MCS_HT_MSK) != !!(mac_flags & IEEE80211_TX_RC_MCS)
 	    || !!(tx_rate & RATE_MCS_GF_MSK) !=
 	    !!(mac_flags & IEEE80211_TX_RC_GREEN_FIELD) || rs_idx != mac_idx) {
--- a/drivers/net/wireless/iwlwifi/iwl-agn-rs.c	2012-03-23 14:58:31.000000000 +0100
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-rs.c	2012-03-23 14:59:06.000000000 +0100
@@ -969,7 +969,7 @@ static void rs_tx_status(void *priv_r, s
 	    (tbl_type.is_SGI != !!(mac_flags & IEEE80211_TX_RC_SHORT_GI)) ||
 	    (tbl_type.is_ht40 != !!(mac_flags & IEEE80211_TX_RC_40_MHZ_WIDTH)) ||
 	    (tbl_type.is_dup != !!(mac_flags & IEEE80211_TX_RC_DUP_DATA)) ||
-	    (tbl_type.ant_type != info->antenna_sel_tx) ||
+	    (tbl_type.ant_type != info->status.antenna) ||
 	    (!!(tx_rate & RATE_MCS_HT_MSK) != !!(mac_flags & IEEE80211_TX_RC_MCS)) ||
 	    (!!(tx_rate & RATE_MCS_GF_MSK) != !!(mac_flags & IEEE80211_TX_RC_GREEN_FIELD)) ||
 	    (rs_index != mac_index)) {
--- a/drivers/net/wireless/iwlwifi/iwl-agn-tx.c	2012-03-23 14:58:31.000000000 +0100
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-tx.c	2012-03-23 14:59:06.000000000 +0100
@@ -779,9 +779,9 @@ static void iwlagn_non_agg_tx_status(str
 static void iwlagn_hwrate_to_tx_control(struct iwl_priv *priv, u32 rate_n_flags,
 				  struct ieee80211_tx_info *info)
 {
-	struct ieee80211_tx_rate *r = &info->control.rates[0];
+	struct ieee80211_tx_rate *r = &info->status.rates[0];
 
-	info->antenna_sel_tx =
+	info->status.antenna =
 		((rate_n_flags & RATE_MCS_ANT_ABC_MSK) >> RATE_MCS_ANT_POS);
 	if (rate_n_flags & RATE_MCS_HT_MSK)
 		r->flags |= IEEE80211_TX_RC_MCS;



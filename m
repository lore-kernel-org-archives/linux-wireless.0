Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f178.google.com ([209.85.212.178]:59934 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752507Ab2G1OdT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 28 Jul 2012 10:33:19 -0400
Received: by wibhr14 with SMTP id hr14so514177wib.1
        for <linux-wireless@vger.kernel.org>; Sat, 28 Jul 2012 07:33:18 -0700 (PDT)
From: Nick Kossifidis <mickflemm@gmail.com>
To: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, mcgrof@gmail.com, jirislaby@gmail.com,
	thomas@net.t-labs.tu-berlin.de, nbd@openwrt.org,
	Nick Kossifidis <mickflemm@gmail.com>
Subject: [PATCH 4/4] ath5k: Put power_level where it belongs and rename it
Date: Sat, 28 Jul 2012 17:32:51 +0300
Message-Id: <1343485971-31360-4-git-send-email-mickflemm@gmail.com> (sfid-20120728_163354_298804_0CB11860)
In-Reply-To: <1343485971-31360-1-git-send-email-mickflemm@gmail.com>
References: <1343485971-31360-1-git-send-email-mickflemm@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Put power_level to ah_txpower struct with the rest tx power infos and
also rename it to txp_requested to make more sense.

Signed-off-by: Nick Kossifidis <mickflemm@gmail.com>
---
 drivers/net/wireless/ath/ath5k/ath5k.h        |    2 +-
 drivers/net/wireless/ath/ath5k/base.c         |    5 +++--
 drivers/net/wireless/ath/ath5k/mac80211-ops.c |    4 ++--
 drivers/net/wireless/ath/ath5k/phy.c          |    5 +++--
 4 files changed, 9 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/ath/ath5k/ath5k.h b/drivers/net/wireless/ath/ath5k/ath5k.h
index 64a453a..3150def 100644
--- a/drivers/net/wireless/ath/ath5k/ath5k.h
+++ b/drivers/net/wireless/ath/ath5k/ath5k.h
@@ -1331,7 +1331,6 @@ struct ath5k_hw {
 	unsigned int		nexttbtt;	/* next beacon time in TU */
 	struct ath5k_txq	*cabq;		/* content after beacon */
 
-	int			power_level;	/* Requested tx power in dBm */
 	bool			assoc;		/* associate state */
 	bool			enable_beacon;	/* true if beacons are on */
 
@@ -1425,6 +1424,7 @@ struct ath5k_hw {
 		/* Value in dB units */
 		s16		txp_cck_ofdm_pwr_delta;
 		bool		txp_setup;
+		int		txp_requested;	/* Requested tx power in dBm */
 	} ah_txpower;
 
 	struct ath5k_nfcal_hist ah_nfcal_hist;
diff --git a/drivers/net/wireless/ath/ath5k/base.c b/drivers/net/wireless/ath/ath5k/base.c
index 8c4c040..9d48f9a 100644
--- a/drivers/net/wireless/ath/ath5k/base.c
+++ b/drivers/net/wireless/ath/ath5k/base.c
@@ -723,7 +723,7 @@ ath5k_txbuf_setup(struct ath5k_hw *ah, struct ath5k_buf *bf,
 	ret = ah->ah_setup_tx_desc(ah, ds, pktlen,
 		ieee80211_get_hdrlen_from_skb(skb), padsize,
 		get_hw_packet_type(skb),
-		(ah->power_level * 2),
+		(ah->ah_txpower.txp_requested * 2),
 		hw_rate,
 		info->control.rates[0].count, keyidx, ah->ah_tx_ant, flags,
 		cts_rate, duration);
@@ -1778,7 +1778,8 @@ ath5k_beacon_setup(struct ath5k_hw *ah, struct ath5k_buf *bf)
 	ds->ds_data = bf->skbaddr;
 	ret = ah->ah_setup_tx_desc(ah, ds, skb->len,
 			ieee80211_get_hdrlen_from_skb(skb), padsize,
-			AR5K_PKT_TYPE_BEACON, (ah->power_level * 2),
+			AR5K_PKT_TYPE_BEACON,
+			(ah->ah_txpower.txp_requested * 2),
 			ieee80211_get_tx_rate(ah->hw, info)->hw_value,
 			1, AR5K_TXKEYIX_INVALID,
 			antenna, flags, 0, 0);
diff --git a/drivers/net/wireless/ath/ath5k/mac80211-ops.c b/drivers/net/wireless/ath/ath5k/mac80211-ops.c
index 260e7dc..92ee3a0 100644
--- a/drivers/net/wireless/ath/ath5k/mac80211-ops.c
+++ b/drivers/net/wireless/ath/ath5k/mac80211-ops.c
@@ -207,8 +207,8 @@ ath5k_config(struct ieee80211_hw *hw, u32 changed)
 	}
 
 	if ((changed & IEEE80211_CONF_CHANGE_POWER) &&
-	(ah->power_level != conf->power_level)) {
-		ah->power_level = conf->power_level;
+	(ah->ah_txpower.txp_requested != conf->power_level)) {
+		ah->ah_txpower.txp_requested = conf->power_level;
 
 		/* Half dB steps */
 		ath5k_hw_set_txpower_limit(ah, (conf->power_level * 2));
diff --git a/drivers/net/wireless/ath/ath5k/phy.c b/drivers/net/wireless/ath/ath5k/phy.c
index 27ca993..b7ea415 100644
--- a/drivers/net/wireless/ath/ath5k/phy.c
+++ b/drivers/net/wireless/ath/ath5k/phy.c
@@ -3802,8 +3802,9 @@ ath5k_hw_phy_init(struct ath5k_hw *ah, struct ieee80211_channel *channel,
 	 * RF buffer settings on 5211/5212+ so that we
 	 * properly set curve indices.
 	 */
-	ret = ath5k_hw_txpower(ah, channel, ah->power_level ?
-			ah->power_level * 2 : AR5K_TUNE_MAX_TXPOWER);
+	ret = ath5k_hw_txpower(ah, channel, ah->ah_txpower.txp_requested ?
+					ah->ah_txpower.txp_requested * 2 :
+					AR5K_TUNE_MAX_TXPOWER);
 	if (ret)
 		return ret;
 
-- 
1.7.3.4


Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:37318 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751249AbdEEJxW (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 5 May 2017 05:53:22 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] mac80211: properly remove RX_ENC_FLAG_40MHZ
Date: Fri,  5 May 2017 11:53:19 +0200
Message-Id: <20170505095319.22833-1-johannes@sipsolutions.net> (sfid-20170505_115326_003815_D075781B)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Somehow I missed this in my RX rate cleanup series, causing some
drivers to not report correct bandwidth since this flag isn't
used by mac80211 anymore. Fix this, and make hwsim also report
higher bandwidths appropriately.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/ath/ath9k/ar9003_mac.c    | 2 +-
 drivers/net/wireless/ath/ath9k/mac.c           | 4 ++--
 drivers/net/wireless/intel/iwlegacy/4965-mac.c | 4 +++-
 drivers/net/wireless/intel/iwlwifi/dvm/rx.c    | 4 +++-
 drivers/net/wireless/mac80211_hwsim.c          | 8 +++++++-
 include/net/mac80211.h                         | 2 --
 6 files changed, 16 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_mac.c b/drivers/net/wireless/ath/ath9k/ar9003_mac.c
index 68fcbe03bce2..b3f20b3c0210 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_mac.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_mac.c
@@ -522,7 +522,7 @@ int ath9k_hw_process_rxdesc_edma(struct ath_hw *ah, struct ath_rx_status *rxs,
 	rxs->rs_moreaggr = (rxsp->status11 & AR_RxMoreAggr) ? 1 : 0;
 	rxs->rs_antenna = (MS(rxsp->status4, AR_RxAntenna) & 0x7);
 	rxs->enc_flags |= (rxsp->status4 & AR_GI) ? RX_ENC_FLAG_SHORT_GI : 0;
-	rxs->enc_flags |= (rxsp->status4 & AR_2040) ? RX_ENC_FLAG_40MHZ : 0;
+	rxs->bw = (rxsp->status4 & AR_2040) ? RATE_INFO_BW_40 : RATE_INFO_BW_20;
 
 	rxs->evm0 = rxsp->status6;
 	rxs->evm1 = rxsp->status7;
diff --git a/drivers/net/wireless/ath/ath9k/mac.c b/drivers/net/wireless/ath/ath9k/mac.c
index 6128c2bb23d8..77c94f9e7b61 100644
--- a/drivers/net/wireless/ath/ath9k/mac.c
+++ b/drivers/net/wireless/ath/ath9k/mac.c
@@ -580,8 +580,8 @@ int ath9k_hw_rxprocdesc(struct ath_hw *ah, struct ath_desc *ds,
 	/* directly mapped flags for ieee80211_rx_status */
 	rs->enc_flags |=
 		(ads.ds_rxstatus3 & AR_GI) ? RX_ENC_FLAG_SHORT_GI : 0;
-	rs->enc_flags |=
-		(ads.ds_rxstatus3 & AR_2040) ? RX_ENC_FLAG_40MHZ : 0;
+	rs->bw = (ads.ds_rxstatus3 & AR_2040) ? RATE_INFO_BW_40 :
+						RATE_INFO_BW_20;
 	if (AR_SREV_9280_20_OR_LATER(ah))
 		rs->enc_flags |=
 			(ads.ds_rxstatus3 & AR_STBC) ?
diff --git a/drivers/net/wireless/intel/iwlegacy/4965-mac.c b/drivers/net/wireless/intel/iwlegacy/4965-mac.c
index 5d5faa3cad24..49a2ff15ddae 100644
--- a/drivers/net/wireless/intel/iwlegacy/4965-mac.c
+++ b/drivers/net/wireless/intel/iwlegacy/4965-mac.c
@@ -734,7 +734,9 @@ il4965_hdl_rx(struct il_priv *il, struct il_rx_buf *rxb)
 	if (rate_n_flags & RATE_MCS_HT_MSK)
 		rx_status.encoding = RX_ENC_HT;
 	if (rate_n_flags & RATE_MCS_HT40_MSK)
-		rx_status.enc_flags |= RX_ENC_FLAG_40MHZ;
+		rx_status.bw = RATE_INFO_BW_40;
+	else
+		rx_status.bw = RATE_INFO_BW_20;
 	if (rate_n_flags & RATE_MCS_SGI_MSK)
 		rx_status.enc_flags |= RX_ENC_FLAG_SHORT_GI;
 
diff --git a/drivers/net/wireless/intel/iwlwifi/dvm/rx.c b/drivers/net/wireless/intel/iwlwifi/dvm/rx.c
index 1ee1ba9931a7..adfd6307edca 100644
--- a/drivers/net/wireless/intel/iwlwifi/dvm/rx.c
+++ b/drivers/net/wireless/intel/iwlwifi/dvm/rx.c
@@ -889,7 +889,9 @@ static void iwlagn_rx_reply_rx(struct iwl_priv *priv,
 	if (rate_n_flags & RATE_MCS_HT_MSK)
 		rx_status.encoding = RX_ENC_HT;
 	if (rate_n_flags & RATE_MCS_HT40_MSK)
-		rx_status.enc_flags |= RX_ENC_FLAG_40MHZ;
+		rx_status.bw = RATE_INFO_BW_40;
+	else
+		rx_status.bw = RATE_INFO_BW_20;
 	if (rate_n_flags & RATE_MCS_SGI_MSK)
 		rx_status.enc_flags |= RX_ENC_FLAG_SHORT_GI;
 	if (rate_n_flags & RATE_MCS_GF_MSK)
diff --git a/drivers/net/wireless/mac80211_hwsim.c b/drivers/net/wireless/mac80211_hwsim.c
index 87444af20fc5..002b25cff5b6 100644
--- a/drivers/net/wireless/mac80211_hwsim.c
+++ b/drivers/net/wireless/mac80211_hwsim.c
@@ -1201,7 +1201,13 @@ static bool mac80211_hwsim_tx_frame_no_nl(struct ieee80211_hw *hw,
 			rx_status.encoding = RX_ENC_HT;
 	}
 	if (info->control.rates[0].flags & IEEE80211_TX_RC_40_MHZ_WIDTH)
-		rx_status.enc_flags |= RX_ENC_FLAG_40MHZ;
+		rx_status.bw = RATE_INFO_BW_40;
+	else if (info->control.rates[0].flags & IEEE80211_TX_RC_80_MHZ_WIDTH)
+		rx_status.bw = RATE_INFO_BW_80;
+	else if (info->control.rates[0].flags & IEEE80211_TX_RC_160_MHZ_WIDTH)
+		rx_status.bw = RATE_INFO_BW_160;
+	else
+		rx_status.bw = RATE_INFO_BW_20;
 	if (info->control.rates[0].flags & IEEE80211_TX_RC_SHORT_GI)
 		rx_status.enc_flags |= RX_ENC_FLAG_SHORT_GI;
 	/* TODO: simulate real signal strength (and optional packet loss) */
diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 4d05a9443344..76ed24a201eb 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -1141,7 +1141,6 @@ enum mac80211_rx_flags {
  * enum mac80211_rx_encoding_flags - MCS & bandwidth flags
  *
  * @RX_ENC_FLAG_SHORTPRE: Short preamble was used for this frame
- * @RX_ENC_FLAG_40MHZ: HT40 (40 MHz) was used
  * @RX_ENC_FLAG_SHORT_GI: Short guard interval was used
  * @RX_ENC_FLAG_HT_GF: This frame was received in a HT-greenfield transmission,
  *	if the driver fills this value it should add
@@ -1153,7 +1152,6 @@ enum mac80211_rx_flags {
  */
 enum mac80211_rx_encoding_flags {
 	RX_ENC_FLAG_SHORTPRE		= BIT(0),
-	RX_ENC_FLAG_40MHZ		= BIT(1),
 	RX_ENC_FLAG_SHORT_GI		= BIT(2),
 	RX_ENC_FLAG_HT_GF		= BIT(3),
 	RX_ENC_FLAG_STBC_MASK		= BIT(4) | BIT(5),
-- 
2.11.0

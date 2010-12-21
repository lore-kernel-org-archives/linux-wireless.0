Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail30s.wh2.ocn.ne.jp ([125.206.180.198]:41548 "HELO
	mail30s.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1757972Ab0LUIa1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Dec 2010 03:30:27 -0500
Received: from vs3015.wh2.ocn.ne.jp (125.206.180.247)
	by mail30s.wh2.ocn.ne.jp (RS ver 1.0.95vs) with SMTP id 5-070407223
	for <linux-wireless@vger.kernel.org>; Tue, 21 Dec 2010 17:30:26 +0900 (JST)
Subject: [PATCH 2/5] ath5k: Separate powertable setup and writing
To: linville@tuxdriver.com
From: Bruno Randolf <br1@einfach.org>
Cc: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org,
	mickflemm@gmail.com
Date: Tue, 21 Dec 2010 17:30:26 +0900
Message-ID: <20101221083026.8765.79160.stgit@localhost6.localdomain6>
In-Reply-To: <20101221083020.8765.16350.stgit@localhost6.localdomain6>
References: <20101221083020.8765.16350.stgit@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

And rename functions which write the powertable to make it clearer.

Signed-off-by: Bruno Randolf <br1@einfach.org>
---
 drivers/net/wireless/ath/ath5k/phy.c |   34 ++++++++++++++++------------------
 1 files changed, 16 insertions(+), 18 deletions(-)

diff --git a/drivers/net/wireless/ath/ath5k/phy.c b/drivers/net/wireless/ath/ath5k/phy.c
index 7c6d7dc..6f0cf3a 100644
--- a/drivers/net/wireless/ath/ath5k/phy.c
+++ b/drivers/net/wireless/ath/ath5k/phy.c
@@ -2593,7 +2593,7 @@ ath5k_combine_linear_pcdac_curves(struct ath5k_hw *ah, s16* table_min,
 
 /* Write PCDAC values on hw */
 static void
-ath5k_setup_pcdac_table(struct ath5k_hw *ah)
+ath5k_write_pcdac_table(struct ath5k_hw *ah)
 {
 	u8 	*pcdac_out = ah->ah_txpower.txp_pd_table;
 	int	i;
@@ -2742,7 +2742,7 @@ ath5k_combine_pwr_to_pdadc_curves(struct ath5k_hw *ah,
 
 /* Write PDADC values on hw */
 static void
-ath5k_setup_pwr_to_pdadc_table(struct ath5k_hw *ah, u8 ee_mode)
+ath5k_write_pwr_to_pdadc_table(struct ath5k_hw *ah, u8 ee_mode)
 {
 	struct ath5k_eeprom_info *ee = &ah->ah_capabilities.cap_eeprom;
 	u8 *pdadc_out = ah->ah_txpower.txp_pd_table;
@@ -2957,8 +2957,7 @@ ath5k_setup_channel_powertable(struct ath5k_hw *ah,
 					(s16) pcinfo_R->freq,
 					pcinfo_L->max_pwr, pcinfo_R->max_pwr);
 
-	/* We are ready to go, fill PCDAC/PDADC
-	 * table and write settings on hardware */
+	/* Fill PCDAC/PDADC table */
 	switch (type) {
 	case AR5K_PWRTABLE_LINEAR_PCDAC:
 		/* For RF5112 we can have one or two curves
@@ -2971,9 +2970,6 @@ ath5k_setup_channel_powertable(struct ath5k_hw *ah,
 		 * match max power value with max
 		 * table index */
 		ah->ah_txpower.txp_offset = 64 - (table_max[0] / 2);
-
-		/* Write settings on hw */
-		ath5k_setup_pcdac_table(ah);
 		break;
 	case AR5K_PWRTABLE_PWR_TO_PCDAC:
 		/* We are done for RF5111 since it has only
@@ -2983,9 +2979,6 @@ ath5k_setup_channel_powertable(struct ath5k_hw *ah,
 		/* No rate powertable adjustment for RF5111 */
 		ah->ah_txpower.txp_min_idx = 0;
 		ah->ah_txpower.txp_offset = 0;
-
-		/* Write settings on hw */
-		ath5k_setup_pcdac_table(ah);
 		break;
 	case AR5K_PWRTABLE_PWR_TO_PDADC:
 		/* Set PDADC boundaries and fill
@@ -2993,9 +2986,6 @@ ath5k_setup_channel_powertable(struct ath5k_hw *ah,
 		ath5k_combine_pwr_to_pdadc_curves(ah, table_min, table_max,
 						ee->ee_pd_gains[ee_mode]);
 
-		/* Write settings on hw */
-		ath5k_setup_pwr_to_pdadc_table(ah, ee_mode);
-
 		/* Set txp.offset, note that table_min
 		 * can be negative */
 		ah->ah_txpower.txp_offset = table_min[0];
@@ -3009,6 +2999,15 @@ ath5k_setup_channel_powertable(struct ath5k_hw *ah,
 	return 0;
 }
 
+/* Write power table for current channel to hw */
+static void
+ath5k_write_channel_powertable(struct ath5k_hw *ah, u8 ee_mode, u8 type)
+{
+	if (type == AR5K_PWRTABLE_PWR_TO_PDADC)
+		ath5k_write_pwr_to_pdadc_table(ah, ee_mode);
+	else
+		ath5k_write_pcdac_table(ah);
+}
 
 /*
  * Per-rate tx power setting
@@ -3159,11 +3158,10 @@ ath5k_hw_txpower(struct ath5k_hw *ah, struct ieee80211_channel *channel,
 							ee_mode, type);
 		if (ret)
 			return ret;
-	/* Write cached table on hw */
-	} else if (type == AR5K_PWRTABLE_PWR_TO_PDADC)
-		ath5k_setup_pwr_to_pdadc_table(ah, ee_mode);
-	else
-		ath5k_setup_pcdac_table(ah);
+	}
+
+	/* Write table on hw */
+	ath5k_write_channel_powertable(ah, ee_mode, type);
 
 	/* Limit max power if we have a CTL available */
 	ath5k_get_max_ctl_power(ah, channel);


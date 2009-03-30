Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:41869 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756318AbZC3KGf (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Mar 2009 06:06:35 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 30 Mar 2009 03:06:34 -0700
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <18896.39086.910489.260877@gargle.gargle.HOWL> (sfid-20090330_120636_792856_3716958D)
Date: Mon, 30 Mar 2009 15:32:22 +0530
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <Jouni.Malinen@Atheros.com>,
	<Luis.Rodriguez@Atheros.com>
Subject: [PATCH 16/17] ath9k: Determine number of streams from HT capabilities
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The number of streams supported by a STA can be determined
directly from the HT capabilities. Remove the redundant
variable storing the stream cap.

Signed-off-by: Sujith <Sujith.Manoharan@atheros.com>
---
 drivers/net/wireless/ath9k/rc.c |   18 ++++++++----------
 drivers/net/wireless/ath9k/rc.h |    2 --
 2 files changed, 8 insertions(+), 12 deletions(-)

diff --git a/drivers/net/wireless/ath9k/rc.c b/drivers/net/wireless/ath9k/rc.c
index 824ccbb..a6933cc 100644
--- a/drivers/net/wireless/ath9k/rc.c
+++ b/drivers/net/wireless/ath9k/rc.c
@@ -524,7 +524,7 @@ static u8 ath_rc_init_validrates(struct ath_rate_priv *ath_rc_priv,
 	u32 valid;
 
 	for (i = 0; i < rate_table->rate_cnt; i++) {
-		valid = (ath_rc_priv->single_stream ?
+		valid = (!(ath_rc_priv->ht_cap & WLAN_RC_DS_FLAG) ?
 			 rate_table->info[i].valid_single_stream :
 			 rate_table->info[i].valid);
 		if (valid == 1) {
@@ -557,9 +557,9 @@ static u8 ath_rc_setvalid_rates(struct ath_rate_priv *ath_rc_priv,
 	for (i = 0; i < rateset->rs_nrates; i++) {
 		for (j = 0; j < rate_table->rate_cnt; j++) {
 			u32 phy = rate_table->info[j].phy;
-			u32 valid = (ath_rc_priv->single_stream ?
-				rate_table->info[j].valid_single_stream :
-				rate_table->info[j].valid);
+			u32 valid = (!(ath_rc_priv->ht_cap & WLAN_RC_DS_FLAG) ?
+				     rate_table->info[j].valid_single_stream :
+				     rate_table->info[j].valid);
 			u8 rate = rateset->rs_rates[i];
 			u8 dot11rate = rate_table->info[j].dot11rate;
 
@@ -603,7 +603,7 @@ static u8 ath_rc_setvalid_htrates(struct ath_rate_priv *ath_rc_priv,
 	for (i = 0; i < rateset->rs_nrates; i++) {
 		for (j = 0; j < rate_table->rate_cnt; j++) {
 			u32 phy = rate_table->info[j].phy;
-			u32 valid = (ath_rc_priv->single_stream ?
+			u32 valid = (!(ath_rc_priv->ht_cap & WLAN_RC_DS_FLAG) ?
 				     rate_table->info[j].valid_single_stream :
 				     rate_table->info[j].valid);
 			u8 rate = rateset->rs_rates[i];
@@ -740,9 +740,10 @@ static u8 ath_rc_ratefind_ht(struct ath_softc *sc,
 	if (rate > (ath_rc_priv->rate_table_size - 1))
 		rate = ath_rc_priv->rate_table_size - 1;
 
-	ASSERT((rate_table->info[rate].valid && !ath_rc_priv->single_stream) ||
+	ASSERT((rate_table->info[rate].valid &&
+		(ath_rc_priv->ht_cap & WLAN_RC_DS_FLAG)) ||
 	       (rate_table->info[rate].valid_single_stream &&
-		ath_rc_priv->single_stream));
+		!(ath_rc_priv->ht_cap & WLAN_RC_DS_FLAG)));
 
 	return rate;
 }
@@ -1422,9 +1423,6 @@ static void ath_rc_init(struct ath_softc *sc,
 	}
 	ath_rc_priv->rc_phy_mode = ath_rc_priv->ht_cap & WLAN_RC_40_FLAG;
 
-	/* Set stream capability */
-	ath_rc_priv->single_stream = (ath_rc_priv->ht_cap & WLAN_RC_DS_FLAG) ? 0 : 1;
-
 	if (!rateset->rs_nrates) {
 		/* No working rate, just initialize valid rates */
 		hi = ath_rc_init_validrates(ath_rc_priv, rate_table,
diff --git a/drivers/net/wireless/ath9k/rc.h b/drivers/net/wireless/ath9k/rc.h
index ec72dd2..bdfd205 100644
--- a/drivers/net/wireless/ath9k/rc.h
+++ b/drivers/net/wireless/ath9k/rc.h
@@ -157,7 +157,6 @@ struct ath_rateset {
  * @probe_interval: interval for ratectrl to probe for other rates
  * @prev_data_rix: rate idx of last data frame
  * @ht_cap: HT capabilities
- * @single_stream: When TRUE, only single TX stream possible
  * @neg_rates: Negotatied rates
  * @neg_ht_rates: Negotiated HT rates
  */
@@ -175,7 +174,6 @@ struct ath_rate_priv {
 	u8 max_valid_rate;
 	u8 valid_rate_index[RATE_TABLE_SIZE];
 	u8 ht_cap;
-	u8 single_stream;
 	u8 valid_phy_ratecnt[WLAN_RC_PHY_MAX];
 	u8 valid_phy_rateidx[WLAN_RC_PHY_MAX][RATE_TABLE_SIZE];
 	u8 rc_phy_mode;
-- 
1.6.2.1


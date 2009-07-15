Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:58369 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756301AbZGOARP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Jul 2009 20:17:15 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org,
	Senthil Balasubramanian <senthilkumar@atheros.com>
Subject: [PATCH 2/9] ath9k: RX stucks during heavy traffic in HT40 mode.
Date: Tue, 14 Jul 2009 20:17:08 -0400
Message-Id: <1247617035-15402-3-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1247617035-15402-1-git-send-email-lrodriguez@atheros.com>
References: <1247617035-15402-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Senthil Balasubramanian <senthilkumar@atheros.com>

Running iperf along with p2p traffic on both TX and RX side then
stop one side, then stop the other side, then start it up again,
eventually the STA gets into a mode that it can not pass data at
all.

A hardware workaround for invalid RSSI can make FIFO write pointer
to jump over read pointer, causing RX data corruption and repeated
DMA. Both TX and RX works fine when the workaround is disabled.

To replace the original hardware work around, software looks for
frames with post delimiter CRC error and mark the RSSI invalid so
that the upperlayer will not use the RSSI associated with this
frame. So disable the hardware workaround by updating the appropriate
registers.

Signed-off-by: Senthil Balasubramanian <senthilkumar@atheros.com>
---
 drivers/net/wireless/ath/ath9k/eeprom.c   |   20 +++++++++++-
 drivers/net/wireless/ath/ath9k/initvals.h |   47 +++++++++++++++-------------
 drivers/net/wireless/ath/ath9k/mac.c      |   30 ++++++++++++++----
 3 files changed, 67 insertions(+), 30 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/eeprom.c b/drivers/net/wireless/ath/ath9k/eeprom.c
index d82a0f9..df41ed5 100644
--- a/drivers/net/wireless/ath/ath9k/eeprom.c
+++ b/drivers/net/wireless/ath/ath9k/eeprom.c
@@ -1208,6 +1208,19 @@ static void ath9k_hw_4k_set_gain(struct ath_hw *ah,
 			      pModal->xatten2Margin[0]);
 		REG_RMW_FIELD(ah, AR_PHY_GAIN_2GHZ + regChainOffset,
 			      AR_PHY_GAIN_2GHZ_XATTEN2_DB, pModal->xatten2Db[0]);
+
+		/* Set the block 1 value to block 0 value */
+		REG_RMW_FIELD(ah, AR_PHY_GAIN_2GHZ + 0x1000,
+			      AR_PHY_GAIN_2GHZ_XATTEN1_MARGIN,
+			      pModal->bswMargin[0]);
+		REG_RMW_FIELD(ah, AR_PHY_GAIN_2GHZ + 0x1000,
+			      AR_PHY_GAIN_2GHZ_XATTEN1_DB, pModal->bswAtten[0]);
+		REG_RMW_FIELD(ah, AR_PHY_GAIN_2GHZ + 0x1000,
+			      AR_PHY_GAIN_2GHZ_XATTEN2_MARGIN,
+			      pModal->xatten2Margin[0]);
+		REG_RMW_FIELD(ah, AR_PHY_GAIN_2GHZ + 0x1000,
+			      AR_PHY_GAIN_2GHZ_XATTEN2_DB,
+			      pModal->xatten2Db[0]);
 	}
 
 	REG_RMW_FIELD(ah, AR_PHY_RXGAIN + regChainOffset,
@@ -1215,6 +1228,11 @@ static void ath9k_hw_4k_set_gain(struct ath_hw *ah,
 	REG_RMW_FIELD(ah, AR_PHY_RXGAIN + regChainOffset,
 		      AR9280_PHY_RXGAIN_TXRX_MARGIN, pModal->rxTxMarginCh[0]);
 
+	REG_RMW_FIELD(ah, AR_PHY_RXGAIN + 0x1000,
+		      AR9280_PHY_RXGAIN_TXRX_ATTEN, txRxAttenLocal);
+	REG_RMW_FIELD(ah, AR_PHY_RXGAIN + 0x1000,
+		      AR9280_PHY_RXGAIN_TXRX_MARGIN, pModal->rxTxMarginCh[0]);
+
 	if (AR_SREV_9285_11(ah))
 		REG_WRITE(ah, AR9285_AN_TOP4, (AR9285_AN_TOP4_DEFAULT | 0x14));
 }
@@ -1239,7 +1257,7 @@ static void ath9k_hw_4k_set_board_values(struct ath_hw *ah,
 	ath9k_hw_4k_set_gain(ah, pModal, eep, txRxAttenLocal, 0);
 
 	/* Initialize Ant Diversity settings from EEPROM */
-	if (pModal->version == 3) {
+	if (pModal->version >= 3) {
 		ant_div_control1 = ((pModal->ob_234 >> 12) & 0xf);
 		ant_div_control2 = ((pModal->db1_234 >> 12) & 0xf);
 		regVal = REG_READ(ah, 0x99ac);
diff --git a/drivers/net/wireless/ath/ath9k/initvals.h b/drivers/net/wireless/ath/ath9k/initvals.h
index e2f0a34..f67a2a9 100644
--- a/drivers/net/wireless/ath/ath9k/initvals.h
+++ b/drivers/net/wireless/ath/ath9k/initvals.h
@@ -2782,7 +2782,7 @@ static const u32 ar9280Common_9280_2[][2] = {
     { 0x00008338, 0x00ff0000 },
     { 0x0000833c, 0x00000000 },
     { 0x00008340, 0x000107ff },
-    { 0x00008344, 0x00581043 },
+    { 0x00008344, 0x00481043 },
     { 0x00009808, 0x00000000 },
     { 0x0000980c, 0xafa68e30 },
     { 0x00009810, 0xfd14e000 },
@@ -3439,7 +3439,7 @@ static const u32 ar9280PciePhy_clkreq_always_on_L1_9280[][2] = {
     {0x00004044,  0x00000000 },
 };
 
-/* AR9285 */
+/* AR9285 Revsion 10*/
 static const u_int32_t ar9285Modes_9285[][6] = {
     { 0x00001030, 0x00000230, 0x00000460, 0x000002c0, 0x00000160, 0x000001e0 },
     { 0x00001070, 0x00000168, 0x000002d0, 0x00000318, 0x0000018c, 0x000001e0 },
@@ -3955,7 +3955,7 @@ static const u_int32_t ar9285Common_9285[][2] = {
     { 0x00008338, 0x00000000 },
     { 0x0000833c, 0x00000000 },
     { 0x00008340, 0x00010380 },
-    { 0x00008344, 0x00581043 },
+    { 0x00008344, 0x00481043 },
     { 0x00009808, 0x00000000 },
     { 0x0000980c, 0xafe68e30 },
     { 0x00009810, 0xfd14e000 },
@@ -4121,8 +4121,9 @@ static const u_int32_t ar9285PciePhy_clkreq_off_L1_9285[][2] = {
     {0x00004044,  0x00000000 },
 };
 
-/* AR9285 v1_2 PCI Register Writes.  Created: 03/04/09 */
+/* AR9285 v1_2 PCI Register Writes.  Created: 04/13/09 */
 static const u_int32_t ar9285Modes_9285_1_2[][6] = {
+    /* Address      5G-HT20     5G-HT40     2G-HT40     2G-HT20     Turbo   */
     { 0x00001030, 0x00000230, 0x00000460, 0x000002c0, 0x00000160, 0x000001e0 },
     { 0x00001070, 0x00000168, 0x000002d0, 0x00000318, 0x0000018c, 0x000001e0 },
     { 0x000010b0, 0x00000e60, 0x00001cc0, 0x00007c70, 0x00003e38, 0x00001180 },
@@ -4139,6 +4140,7 @@ static const u_int32_t ar9285Modes_9285_1_2[][6] = {
     { 0x00009840, 0x206a012e, 0x206a012e, 0x206a012e, 0x206a012e, 0x206a012e },
     { 0x00009844, 0x0372161e, 0x0372161e, 0x03721620, 0x03721620, 0x037216a0 },
     { 0x00009848, 0x00001066, 0x00001066, 0x00001053, 0x00001053, 0x00001059 },
+    { 0x0000a848, 0x00001066, 0x00001066, 0x00001053, 0x00001053, 0x00001059 },
     { 0x00009850, 0x6d4000e2, 0x6d4000e2, 0x6d4000e2, 0x6d4000e2, 0x6d4000e2 },
     { 0x00009858, 0x7ec84d2e, 0x7ec84d2e, 0x7ec84d2e, 0x7ec84d2e, 0x7ec84d2e },
     { 0x0000985c, 0x3139605e, 0x3139605e, 0x3137605e, 0x3137605e, 0x3139605e },
@@ -4419,6 +4421,7 @@ static const u_int32_t ar9285Modes_9285_1_2[][6] = {
     { 0x0000abfc, 0x00000000, 0x00000000, 0x000eb7db, 0x000eb7db, 0x00000000 },
     { 0x0000a204, 0x00000004, 0x00000004, 0x00000004, 0x00000004, 0x00000004 },
     { 0x0000a20c, 0x00000014, 0x00000014, 0x0001f000, 0x0001f000, 0x0001f000 },
+    { 0x0000b20c, 0x00000014, 0x00000014, 0x0001f000, 0x0001f000, 0x0001f000 },
     { 0x0000a21c, 0x1883800a, 0x1883800a, 0x1883800a, 0x1883800a, 0x1883800a },
     { 0x0000a230, 0x00000000, 0x00000000, 0x00000210, 0x00000108, 0x00000000 },
     { 0x0000a250, 0x0004f000, 0x0004f000, 0x0004a000, 0x0004a000, 0x0004a000 },
@@ -4618,7 +4621,7 @@ static const u_int32_t ar9285Common_9285_1_2[][2] = {
     { 0x00008338, 0x00ff0000 },
     { 0x0000833c, 0x00000000 },
     { 0x00008340, 0x00010380 },
-    { 0x00008344, 0x00581043 },
+    { 0x00008344, 0x00481043 },
     { 0x00009808, 0x00000000 },
     { 0x0000980c, 0xafe68e30 },
     { 0x00009810, 0xfd14e000 },
@@ -4752,18 +4755,18 @@ static const u_int32_t ar9285Common_9285_1_2[][2] = {
 static const u_int32_t ar9285Modes_high_power_tx_gain_9285_1_2[][6] = {
     /* Address      5G-HT20     5G-HT40     2G-HT40     2G-HT20     Turbo   */
     { 0x0000a300, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000 },
-    { 0x0000a304, 0x00000000, 0x00000000, 0x00005200, 0x00005200, 0x00000000 },
-    { 0x0000a308, 0x00000000, 0x00000000, 0x00007201, 0x00007201, 0x00000000 },
+    { 0x0000a304, 0x00000000, 0x00000000, 0x00006200, 0x00006200, 0x00000000 },
+    { 0x0000a308, 0x00000000, 0x00000000, 0x00008201, 0x00008201, 0x00000000 },
     { 0x0000a30c, 0x00000000, 0x00000000, 0x0000b240, 0x0000b240, 0x00000000 },
     { 0x0000a310, 0x00000000, 0x00000000, 0x0000d241, 0x0000d241, 0x00000000 },
-    { 0x0000a314, 0x00000000, 0x00000000, 0x0000f440, 0x0000f440, 0x00000000 },
-    { 0x0000a318, 0x00000000, 0x00000000, 0x00014640, 0x00014640, 0x00000000 },
-    { 0x0000a31c, 0x00000000, 0x00000000, 0x00018680, 0x00018680, 0x00000000 },
-    { 0x0000a320, 0x00000000, 0x00000000, 0x00019841, 0x00019841, 0x00000000 },
-    { 0x0000a324, 0x00000000, 0x00000000, 0x0001ca40, 0x0001ca40, 0x00000000 },
-    { 0x0000a328, 0x00000000, 0x00000000, 0x0001fa80, 0x0001fa80, 0x00000000 },
-    { 0x0000a32c, 0x00000000, 0x00000000, 0x00023ac0, 0x00023ac0, 0x00000000 },
-    { 0x0000a330, 0x00000000, 0x00000000, 0x0002ab40, 0x0002ab40, 0x00000000 },
+    { 0x0000a314, 0x00000000, 0x00000000, 0x0000f600, 0x0000f600, 0x00000000 },
+    { 0x0000a318, 0x00000000, 0x00000000, 0x00012800, 0x00012800, 0x00000000 },
+    { 0x0000a31c, 0x00000000, 0x00000000, 0x00016802, 0x00016802, 0x00000000 },
+    { 0x0000a320, 0x00000000, 0x00000000, 0x0001b805, 0x0001b805, 0x00000000 },
+    { 0x0000a324, 0x00000000, 0x00000000, 0x00021a80, 0x00021a80, 0x00000000 },
+    { 0x0000a328, 0x00000000, 0x00000000, 0x00028b00, 0x00028b00, 0x00000000 },
+    { 0x0000a32c, 0x00000000, 0x00000000, 0x0002ab40, 0x0002ab40, 0x00000000 },
+    { 0x0000a330, 0x00000000, 0x00000000, 0x0002cd80, 0x0002cd80, 0x00000000 },
     { 0x0000a334, 0x00000000, 0x00000000, 0x00033d82, 0x00033d82, 0x00000000 },
     { 0x0000a338, 0x0003891e, 0x0003891e, 0x0003891e, 0x0003891e, 0x00000000 },
     { 0x0000a33c, 0x0003a95e, 0x0003a95e, 0x0003a95e, 0x0003a95e, 0x00000000 },
@@ -4776,13 +4779,13 @@ static const u_int32_t ar9285Modes_high_power_tx_gain_9285_1_2[][6] = {
     { 0x00007838, 0xfac68803, 0xfac68803, 0xfac68803, 0xfac68803, 0xfac68803 },
     { 0x0000786c, 0x08609ebe, 0x08609ebe, 0x08609ebe, 0x08609ebe, 0x08609ebe },
     { 0x00007820, 0x00000c00, 0x00000c00, 0x00000c00, 0x00000c00, 0x00000c00 },
-    { 0x0000a274, 0x0a22a652, 0x0a22a652, 0x0a21a652, 0x0a21a652, 0x0a22a652 },
-    { 0x0000a278, 0x1ce739ce, 0x1ce739ce, 0x1ce739ce, 0x1ce739ce, 0x1ce739ce },
-    { 0x0000a27c, 0x050701ce, 0x050701ce, 0x050701ce, 0x050701ce, 0x050701ce },
-    { 0x0000a394, 0x1ce739ce, 0x1ce739ce, 0x1ce739ce, 0x1ce739ce, 0x1ce739ce },
-    { 0x0000a398, 0x000001ce, 0x000001ce, 0x000001ce, 0x000001ce, 0x000001ce },
-    { 0x0000a3dc, 0x1ce739ce, 0x1ce739ce, 0x1ce739ce, 0x1ce739ce, 0x1ce739ce },
-    { 0x0000a3e0, 0x000001ce, 0x000001ce, 0x000001ce, 0x000001ce, 0x000001ce },
+    { 0x0000a274, 0x0a22a652, 0x0a22a652, 0x0a216652, 0x0a216652, 0x0a22a652 },
+    { 0x0000a278, 0x0e739ce7, 0x0e739ce7, 0x0e739ce7, 0x0e739ce7, 0x0e739ce7 },
+    { 0x0000a27c, 0x050380e7, 0x050380e7, 0x050380e7, 0x050380e7, 0x050380e7 },
+    { 0x0000a394, 0x0e739ce7, 0x0e739ce7, 0x0e739ce7, 0x0e739ce7, 0x0e739ce7 },
+    { 0x0000a398, 0x000000e7, 0x000000e7, 0x000000e7, 0x000000e7, 0x000000e7 },
+    { 0x0000a3dc, 0x0e739ce7, 0x0e739ce7, 0x0e739ce7, 0x0e739ce7, 0x0e739ce7 },
+    { 0x0000a3e0, 0x000000e7, 0x000000e7, 0x000000e7, 0x000000e7, 0x000000e7 },
 };
 
 static const u_int32_t ar9285Modes_original_tx_gain_9285_1_2[][6] = {
diff --git a/drivers/net/wireless/ath/ath9k/mac.c b/drivers/net/wireless/ath/ath9k/mac.c
index 8ae4ec2..6f923e3 100644
--- a/drivers/net/wireless/ath/ath9k/mac.c
+++ b/drivers/net/wireless/ath/ath9k/mac.c
@@ -825,13 +825,29 @@ int ath9k_hw_rxprocdesc(struct ath_hw *ah, struct ath_desc *ds,
 	ds->ds_rxstat.rs_datalen = ads.ds_rxstatus1 & AR_DataLen;
 	ds->ds_rxstat.rs_tstamp = ads.AR_RcvTimestamp;
 
-	ds->ds_rxstat.rs_rssi = MS(ads.ds_rxstatus4, AR_RxRSSICombined);
-	ds->ds_rxstat.rs_rssi_ctl0 = MS(ads.ds_rxstatus0, AR_RxRSSIAnt00);
-	ds->ds_rxstat.rs_rssi_ctl1 = MS(ads.ds_rxstatus0, AR_RxRSSIAnt01);
-	ds->ds_rxstat.rs_rssi_ctl2 = MS(ads.ds_rxstatus0, AR_RxRSSIAnt02);
-	ds->ds_rxstat.rs_rssi_ext0 = MS(ads.ds_rxstatus4, AR_RxRSSIAnt10);
-	ds->ds_rxstat.rs_rssi_ext1 = MS(ads.ds_rxstatus4, AR_RxRSSIAnt11);
-	ds->ds_rxstat.rs_rssi_ext2 = MS(ads.ds_rxstatus4, AR_RxRSSIAnt12);
+	if (ads.ds_rxstatus8 & AR_PostDelimCRCErr) {
+		ds->ds_rxstat.rs_rssi = ATH9K_RSSI_BAD;
+		ds->ds_rxstat.rs_rssi_ctl0 = ATH9K_RSSI_BAD;
+		ds->ds_rxstat.rs_rssi_ctl1 = ATH9K_RSSI_BAD;
+		ds->ds_rxstat.rs_rssi_ctl2 = ATH9K_RSSI_BAD;
+		ds->ds_rxstat.rs_rssi_ext0 = ATH9K_RSSI_BAD;
+		ds->ds_rxstat.rs_rssi_ext1 = ATH9K_RSSI_BAD;
+		ds->ds_rxstat.rs_rssi_ext2 = ATH9K_RSSI_BAD;
+	} else {
+		ds->ds_rxstat.rs_rssi = MS(ads.ds_rxstatus4, AR_RxRSSICombined);
+		ds->ds_rxstat.rs_rssi_ctl0 = MS(ads.ds_rxstatus0,
+						AR_RxRSSIAnt00);
+		ds->ds_rxstat.rs_rssi_ctl1 = MS(ads.ds_rxstatus0,
+						AR_RxRSSIAnt01);
+		ds->ds_rxstat.rs_rssi_ctl2 = MS(ads.ds_rxstatus0,
+						AR_RxRSSIAnt02);
+		ds->ds_rxstat.rs_rssi_ext0 = MS(ads.ds_rxstatus4,
+						AR_RxRSSIAnt10);
+		ds->ds_rxstat.rs_rssi_ext1 = MS(ads.ds_rxstatus4,
+						AR_RxRSSIAnt11);
+		ds->ds_rxstat.rs_rssi_ext2 = MS(ads.ds_rxstatus4,
+						AR_RxRSSIAnt12);
+	}
 	if (ads.ds_rxstatus8 & AR_RxKeyIdxValid)
 		ds->ds_rxstat.rs_keyix = MS(ads.ds_rxstatus8, AR_KeyIdx);
 	else
-- 
1.6.0.6


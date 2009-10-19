Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:54695 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754102AbZJSGdm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Oct 2009 02:33:42 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linux-wireless@vger.kernel.org
Cc: ath9k-devel@lists.ath9k.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [RFT 09/15] ath9k_hw: make both analog channel change routines return int
Date: Mon, 19 Oct 2009 02:33:40 -0400
Message-Id: <1255934026-20686-10-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1255934026-20686-1-git-send-email-lrodriguez@atheros.com>
References: <1255934026-20686-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This allows us to later define a callback for both.

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/net/wireless/ath/ath9k/hw.c  |   24 +++++++++++++-----------
 drivers/net/wireless/ath/ath9k/phy.c |   14 +++++++-------
 drivers/net/wireless/ath/ath9k/phy.h |    7 ++-----
 3 files changed, 22 insertions(+), 23 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index 5a08b97..e27be74 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -1867,6 +1867,7 @@ static bool ath9k_hw_channel_change(struct ath_hw *ah,
 	struct ath_common *common = ath9k_hw_common(ah);
 	struct ieee80211_channel *channel = chan->chan;
 	u32 synthDelay, qnum;
+	int r;
 
 	for (qnum = 0; qnum < AR_NUM_QCU; qnum++) {
 		if (ath9k_hw_numtxpending(ah, qnum)) {
@@ -1887,14 +1888,14 @@ static bool ath9k_hw_channel_change(struct ath_hw *ah,
 
 	ath9k_hw_set_regs(ah, chan);
 
-	if (AR_SREV_9280_10_OR_LATER(ah)) {
-		ath9k_hw_ar9280_set_channel(ah, chan);
-	} else {
-		if (!(ath9k_hw_set_channel(ah, chan))) {
-			ath_print(common, ATH_DBG_FATAL,
-				  "Failed to set channel\n");
-			return false;
-		}
+	if (AR_SREV_9280_10_OR_LATER(ah))
+		r = ath9k_hw_ar9280_set_channel(ah, chan);
+	else
+		r = ath9k_hw_set_channel(ah, chan);
+	if (r) {
+		ath_print(common, ATH_DBG_FATAL,
+			  "Failed to set channel\n");
+		return false;
 	}
 
 	ah->eep_ops->set_txpower(ah, chan,
@@ -2533,10 +2534,11 @@ int ath9k_hw_reset(struct ath_hw *ah, struct ath9k_channel *chan,
 	REG_WRITE(ah, AR_RSSI_THR, INIT_RSSI_THR);
 
 	if (AR_SREV_9280_10_OR_LATER(ah))
-		ath9k_hw_ar9280_set_channel(ah, chan);
+		r = ath9k_hw_ar9280_set_channel(ah, chan);
 	else
-		if (!(ath9k_hw_set_channel(ah, chan)))
-			return -EIO;
+		r = ath9k_hw_set_channel(ah, chan);
+	if (r)
+		return r;
 
 	for (i = 0; i < AR_NUM_DCU; i++)
 		REG_WRITE(ah, AR_DQCUMASK(i), 1 << i);
diff --git a/drivers/net/wireless/ath/ath9k/phy.c b/drivers/net/wireless/ath/ath9k/phy.c
index d50b5ff..bfcb9af 100644
--- a/drivers/net/wireless/ath/ath9k/phy.c
+++ b/drivers/net/wireless/ath/ath9k/phy.c
@@ -68,8 +68,7 @@ ath9k_hw_write_regs(struct ath_hw *ah, u32 modesIndex, u32 freqIndex,
  * the channel value. Assumes writes enabled to analog bus and bank6 register
  * cache in ah->analogBank6Data.
  */
-bool
-ath9k_hw_set_channel(struct ath_hw *ah, struct ath9k_channel *chan)
+int ath9k_hw_set_channel(struct ath_hw *ah, struct ath9k_channel *chan)
 {
 	struct ath_common *common = ath9k_hw_common(ah);
 	u32 channelSel = 0;
@@ -94,7 +93,7 @@ ath9k_hw_set_channel(struct ath_hw *ah, struct ath9k_channel *chan)
 		} else {
 			ath_print(common, ATH_DBG_FATAL,
 				  "Invalid channel %u MHz\n", freq);
-			return false;
+			return -EINVAL;
 		}
 
 		channelSel = (channelSel << 2) & 0xff;
@@ -127,7 +126,7 @@ ath9k_hw_set_channel(struct ath_hw *ah, struct ath9k_channel *chan)
 	} else {
 		ath_print(common, ATH_DBG_FATAL,
 			  "Invalid channel %u MHz\n", freq);
-		return false;
+		return -EINVAL;
 	}
 
 	reg32 =
@@ -139,7 +138,7 @@ ath9k_hw_set_channel(struct ath_hw *ah, struct ath9k_channel *chan)
 	ah->curchan = chan;
 	ah->curchan_rad_index = -1;
 
-	return true;
+	return 0;
 }
 
 /**
@@ -163,8 +162,7 @@ ath9k_hw_set_channel(struct ath_hw *ah, struct ath9k_channel *chan)
  * Channel Frequency = (3/2) * freq_ref * (chansel[8:0] + chanfrac[16:0]/2^10)
  * (freq_ref = 40MHz/(24>>amodeRefSel))
  */
-void ath9k_hw_ar9280_set_channel(struct ath_hw *ah,
-				 struct ath9k_channel *chan)
+int ath9k_hw_ar9280_set_channel(struct ath_hw *ah, struct ath9k_channel *chan)
 {
 	u16 bMode, fracMode, aModeRefSel = 0;
 	u32 freq, ndiv, channelSel = 0, channelFrac = 0, reg32 = 0;
@@ -252,6 +250,8 @@ void ath9k_hw_ar9280_set_channel(struct ath_hw *ah,
 
 	ah->curchan = chan;
 	ah->curchan_rad_index = -1;
+
+	return 0;
 }
 
 /**
diff --git a/drivers/net/wireless/ath/ath9k/phy.h b/drivers/net/wireless/ath/ath9k/phy.h
index c083bbf..a0b484e 100644
--- a/drivers/net/wireless/ath/ath9k/phy.h
+++ b/drivers/net/wireless/ath/ath9k/phy.h
@@ -17,11 +17,8 @@
 #ifndef PHY_H
 #define PHY_H
 
-void ath9k_hw_ar9280_set_channel(struct ath_hw *ah,
-				 struct ath9k_channel
-				 *chan);
-bool ath9k_hw_set_channel(struct ath_hw *ah,
-			  struct ath9k_channel *chan);
+int ath9k_hw_ar9280_set_channel(struct ath_hw *ah, struct ath9k_channel *chan);
+int ath9k_hw_set_channel(struct ath_hw *ah, struct ath9k_channel *chan);
 void ath9k_hw_write_regs(struct ath_hw *ah, u32 modesIndex,
 			 u32 freqIndex, int regWrites);
 bool ath9k_hw_set_rf_regs(struct ath_hw *ah,
-- 
1.6.0.4


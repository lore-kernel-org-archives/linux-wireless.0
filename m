Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.21]:38690 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751989Ab3GPGgo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Jul 2013 02:36:44 -0400
From: Sujith Manoharan <sujith@msujith.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 3/6] ath9k: Fix FastChannelChange for AR9462/AR9565
Date: Tue, 16 Jul 2013 12:03:19 +0530
Message-Id: <1373956402-22169-3-git-send-email-sujith@msujith.org> (sfid-20130716_083649_405921_3625AF4E)
In-Reply-To: <1373956402-22169-1-git-send-email-sujith@msujith.org>
References: <1373956402-22169-1-git-send-email-sujith@msujith.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

Right now, even though these chips support cross-band
FCC, the code is non-functional since we bail out early if
the channelFlags differ. Fix this so that cross-band
FCC works for cards that support this feature.

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/hw.c | 45 ++++++++++++++++++++++---------------
 1 file changed, 27 insertions(+), 18 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index 2d385c2..50e5979 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -1496,16 +1496,18 @@ static bool ath9k_hw_channel_change(struct ath_hw *ah,
 				    struct ath9k_channel *chan)
 {
 	struct ath_common *common = ath9k_hw_common(ah);
+	struct ath9k_hw_capabilities *pCap = &ah->caps;
+	bool band_switch = false, mode_diff = false;
+	u8 ini_reloaded;
 	u32 qnum;
 	int r;
-	bool edma = !!(ah->caps.hw_caps & ATH9K_HW_CAP_EDMA);
-	bool band_switch, mode_diff;
-	u8 ini_reloaded;
 
-	band_switch = (chan->channelFlags & (CHANNEL_2GHZ | CHANNEL_5GHZ)) !=
-		      (ah->curchan->channelFlags & (CHANNEL_2GHZ |
-						    CHANNEL_5GHZ));
-	mode_diff = (chan->chanmode != ah->curchan->chanmode);
+	if (pCap->hw_caps & ATH9K_HW_CAP_FCC_BAND_SWITCH) {
+		u32 cur = ah->curchan->channelFlags & (CHANNEL_2GHZ | CHANNEL_5GHZ);
+		u32 new = chan->channelFlags & (CHANNEL_2GHZ | CHANNEL_5GHZ);
+		band_switch = (cur != new);
+		mode_diff = (chan->chanmode != ah->curchan->chanmode);
+	}
 
 	for (qnum = 0; qnum < AR_NUM_QCU; qnum++) {
 		if (ath9k_hw_numtxpending(ah, qnum)) {
@@ -1520,7 +1522,7 @@ static bool ath9k_hw_channel_change(struct ath_hw *ah,
 		return false;
 	}
 
-	if (edma && (band_switch || mode_diff)) {
+	if (band_switch || mode_diff) {
 		ath9k_hw_mark_phy_inactive(ah);
 		udelay(5);
 
@@ -1548,7 +1550,7 @@ static bool ath9k_hw_channel_change(struct ath_hw *ah,
 
 	ath9k_hw_spur_mitigate_freq(ah, chan);
 
-	if (edma && (band_switch || mode_diff)) {
+	if (band_switch || mode_diff) {
 		ah->ah_flags |= AH_FASTCC;
 		if (band_switch || ini_reloaded)
 			ah->eep_ops->set_board_values(ah, chan);
@@ -1778,16 +1780,11 @@ static void ath9k_hw_init_desc(struct ath_hw *ah)
 /*
  * Fast channel change:
  * (Change synthesizer based on channel freq without resetting chip)
- *
- * Don't do FCC when
- *   - Flag is not set
- *   - Chip is just coming out of full sleep
- *   - Channel to be set is same as current channel
- *   - Channel flags are different, (eg.,moving from 2GHz to 5GHz channel)
  */
 static int ath9k_hw_do_fastcc(struct ath_hw *ah, struct ath9k_channel *chan)
 {
 	struct ath_common *common = ath9k_hw_common(ah);
+	struct ath9k_hw_capabilities *pCap = &ah->caps;
 	int ret;
 
 	if (AR_SREV_9280(ah) && common->bus_ops->ath_bus_type == ATH_PCI)
@@ -1806,9 +1803,21 @@ static int ath9k_hw_do_fastcc(struct ath_hw *ah, struct ath9k_channel *chan)
 	    (CHANNEL_HALF | CHANNEL_QUARTER))
 		goto fail;
 
-	if ((chan->channelFlags & CHANNEL_ALL) !=
-	    (ah->curchan->channelFlags & CHANNEL_ALL))
-		goto fail;
+	/*
+	 * If cross-band fcc is not supoprted, bail out if
+	 * either channelFlags or chanmode differ.
+	 *
+	 * chanmode will be different if the HT operating mode
+	 * changes because of CSA.
+	 */
+	if (!(pCap->hw_caps & ATH9K_HW_CAP_FCC_BAND_SWITCH)) {
+		if ((chan->channelFlags & CHANNEL_ALL) !=
+		    (ah->curchan->channelFlags & CHANNEL_ALL))
+			goto fail;
+
+		if (chan->chanmode != ah->curchan->chanmode)
+			goto fail;
+	}
 
 	if (!ath9k_hw_check_alive(ah))
 		goto fail;
-- 
1.8.3.2


Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:25759 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751440AbYHBXtR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 2 Aug 2008 19:49:17 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Sat, 02 Aug 2008 16:49:17 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <linville@tuxdriver.com>, <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <ath9k-devel@lists.ath9k.org>,
	<jouni.malinen@atheros.com>,
	Sujith Manoharan <smanoharan@atheros.com>,
	<linux-wireless@vger.kernel.org>, <ath9k-devel@lists.ath9k.org>,
	Sujith <Sujith.Manoharan@atheros.com>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH 05/12] ath9k: Consolidate channel list
Date: Sat, 2 Aug 2008 16:48:57 -0700
Message-ID: <1217720944-23234-6-git-send-email-lrodriguez@atheros.com> (sfid-20080803_014919_836958_EA834DC2)
In-Reply-To: <1217720944-23234-5-git-send-email-lrodriguez@atheros.com>
References: <1217720944-23234-1-git-send-email-lrodriguez@atheros.com>
 <1217720944-23234-2-git-send-email-lrodriguez@atheros.com>
 <1217720944-23234-3-git-send-email-lrodriguez@atheros.com>
 <1217720944-23234-4-git-send-email-lrodriguez@atheros.com>
 <1217720944-23234-5-git-send-email-lrodriguez@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <smanoharan@atheros.com>

ah_channels now contains unique channel entries with
channelFlags denoting all the modes supported by each channel.
Also, the CTLs are stored separately for each channel mode (11a, 11b, 11g).

Signed-off-by: Sujith <Sujith.Manoharan@atheros.com>
Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/net/wireless/ath9k/ath9k.h |    2 +-
 drivers/net/wireless/ath9k/hw.c    |    9 +--
 drivers/net/wireless/ath9k/regd.c  |  117 ++++++++++++++++++++++++-----------
 3 files changed, 85 insertions(+), 43 deletions(-)

diff --git a/drivers/net/wireless/ath9k/ath9k.h b/drivers/net/wireless/ath9k/ath9k.h
index 98466fd..c99c6ba 100644
--- a/drivers/net/wireless/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath9k/ath9k.h
@@ -483,7 +483,7 @@ struct ath9k_channel {
 	int16_t rawNoiseFloor;
 	int8_t antennaMax;
 	u_int32_t regDmnFlags;
-	u_int32_t conformanceTestLimit;
+	u_int32_t conformanceTestLimit[3]; /* 0:11a, 1: 11b, 2:11g */
 #ifdef ATH_NF_PER_CHAN
 	struct hal_nfcal_hist nfCalHist[NUM_NF_READINGS];
 #endif
diff --git a/drivers/net/wireless/ath9k/hw.c b/drivers/net/wireless/ath9k/hw.c
index 35b9445..0104455 100644
--- a/drivers/net/wireless/ath9k/hw.c
+++ b/drivers/net/wireless/ath9k/hw.c
@@ -4313,12 +4313,11 @@ ath9k_hw_set_power_per_rate_table(struct ath_hal *ah,
 		for (i = 0; (i < AR5416_NUM_CTLS) && pEepData->ctlIndex[i];
 		     i++) {
 			DPRINTF(ah->ah_sc, ATH_DBG_POWER_MGMT,
-				 "  LOOP-Ctlidx %d: cfgCtl 0x%2.2x "
+				"  LOOP-Ctlidx %d: cfgCtl 0x%2.2x "
 				"pCtlMode 0x%2.2x ctlIndex 0x%2.2x "
-				"chan %d chanctl 0x%x\n",
-				 i, cfgCtl, pCtlMode[ctlMode],
-				 pEepData->ctlIndex[i], chan->channel,
-				 chan->conformanceTestLimit);
+				"chan %d\n",
+				i, cfgCtl, pCtlMode[ctlMode],
+				pEepData->ctlIndex[i], chan->channel);
 
 			if ((((cfgCtl & ~CTL_MODE_M) |
 			      (pCtlMode[ctlMode] & CTL_MODE_M)) ==
diff --git a/drivers/net/wireless/ath9k/regd.c b/drivers/net/wireless/ath9k/regd.c
index f40cd66..588dd3d 100644
--- a/drivers/net/wireless/ath9k/regd.c
+++ b/drivers/net/wireless/ath9k/regd.c
@@ -394,6 +394,21 @@ static void ath9k_regd_init_rf_buffer(struct ath9k_channel *ichans,
 }
 #endif
 
+static int ath9k_regd_is_chan_present(struct ath_hal *ah,
+				      u_int16_t c)
+{
+	int i;
+
+	for (i = 0; i < 150; i++) {
+		if (!ah->ah_channels[i].channel)
+			return -1;
+		else if (ah->ah_channels[i].channel == c)
+			return i;
+	}
+
+	return -1;
+}
+
 static bool
 ath9k_regd_add_channel(struct ath_hal *ah,
 		       u_int16_t c,
@@ -409,7 +424,10 @@ ath9k_regd_add_channel(struct ath_hal *ah,
 		       struct ath9k_channel *ichans,
 		       bool enableExtendedChannels)
 {
-	struct ath9k_channel icv;
+	struct ath9k_channel *chan;
+	int ret;
+	u_int32_t channelFlags = 0;
+	u_int8_t privFlags = 0;
 
 	if (!(c_lo <= c && c <= c_hi)) {
 		DPRINTF(ah->ah_sc, ATH_DBG_REGULATORY,
@@ -479,43 +497,36 @@ ath9k_regd_add_channel(struct ath_hal *ah,
 		return false;
 	}
 
-	memset(&icv, 0, sizeof(icv));
-	icv.channel = c;
-	icv.channelFlags = cm->flags;
+	/* Calculate channel flags */
+
+	channelFlags = cm->flags;
 
 	switch (fband->channelBW) {
 	case CHANNEL_HALF_BW:
-		icv.channelFlags |= CHANNEL_HALF;
+		channelFlags |= CHANNEL_HALF;
 		break;
 	case CHANNEL_QUARTER_BW:
-		icv.channelFlags |= CHANNEL_QUARTER;
+		channelFlags |= CHANNEL_QUARTER;
 		break;
 	}
 
-	icv.maxRegTxPower = fband->powerDfs;
-	icv.antennaMax = fband->antennaMax;
-	icv.regDmnFlags = rd->flags;
-	icv.conformanceTestLimit = ctl;
-	icv.maxTxPower = AR5416_MAX_RATE_POWER;
-	icv.minTxPower = AR5416_MAX_RATE_POWER;
-
 	if (fband->usePassScan & rd->pscan)
-		icv.channelFlags |= CHANNEL_PASSIVE;
+		channelFlags |= CHANNEL_PASSIVE;
 	else
-		icv.channelFlags &= ~CHANNEL_PASSIVE;
+		channelFlags &= ~CHANNEL_PASSIVE;
 	if (fband->useDfs & rd->dfsMask)
-		icv.privFlags = CHANNEL_DFS;
+		privFlags = CHANNEL_DFS;
 	else
-		icv.privFlags = 0;
+		privFlags = 0;
 	if (rd->flags & LIMIT_FRAME_4MS)
-		icv.privFlags |= CHANNEL_4MS_LIMIT;
-	if (icv.privFlags & CHANNEL_DFS)
-		icv.privFlags |= CHANNEL_DISALLOW_ADHOC;
-	if (icv.regDmnFlags & ADHOC_PER_11D)
-		icv.privFlags |= CHANNEL_PER_11D_ADHOC;
-
-	if (icv.channelFlags & CHANNEL_PASSIVE) {
-		if ((icv.channel < 2412) || (icv.channel > 2462)) {
+		privFlags |= CHANNEL_4MS_LIMIT;
+	if (privFlags & CHANNEL_DFS)
+		privFlags |= CHANNEL_DISALLOW_ADHOC;
+	if (rd->flags & ADHOC_PER_11D)
+		privFlags |= CHANNEL_PER_11D_ADHOC;
+
+	if (channelFlags & CHANNEL_PASSIVE) {
+		if ((c < 2412) || (c > 2462)) {
 			if (rd5GHz.regDmnEnum == MKK1 ||
 			    rd5GHz.regDmnEnum == MKK2) {
 				u_int32_t regcap = ah->ah_caps.halRegCap;
@@ -523,13 +534,13 @@ ath9k_regd_add_channel(struct ath_hal *ah,
 				      (AR_EEPROM_EEREGCAP_EN_KK_U1_EVEN |
 				       AR_EEPROM_EEREGCAP_EN_KK_U2 |
 				       AR_EEPROM_EEREGCAP_EN_KK_MIDBAND)) &&
-				    isUNII1OddChan(icv.channel)) {
-					icv.channelFlags &= ~CHANNEL_PASSIVE;
+				    isUNII1OddChan(c)) {
+					channelFlags &= ~CHANNEL_PASSIVE;
 				} else {
-					icv.privFlags |= CHANNEL_DISALLOW_ADHOC;
+					privFlags |= CHANNEL_DISALLOW_ADHOC;
 				}
 			} else {
-				icv.privFlags |= CHANNEL_DISALLOW_ADHOC;
+				privFlags |= CHANNEL_DISALLOW_ADHOC;
 			}
 		}
 	}
@@ -538,14 +549,39 @@ ath9k_regd_add_channel(struct ath_hal *ah,
 			ATH9K_MODE_SEL_11NA_HT20 |
 			ATH9K_MODE_SEL_11NA_HT40PLUS |
 			ATH9K_MODE_SEL_11NA_HT40MINUS)) {
-		if (icv.regDmnFlags & (ADHOC_NO_11A | DISALLOW_ADHOC_11A))
-			icv.privFlags |= CHANNEL_DISALLOW_ADHOC;
+		if (rd->flags & (ADHOC_NO_11A | DISALLOW_ADHOC_11A))
+			privFlags |= CHANNEL_DISALLOW_ADHOC;
 	}
 
-	memcpy(&ichans[pos], &icv,
-	       sizeof(struct ath9k_channel));
+	/* Fill in channel details */
+
+	ret = ath9k_regd_is_chan_present(ah, c);
+	if (ret == -1) {
+		chan = &ah->ah_channels[pos];
+		chan->channel = c;
+		chan->maxRegTxPower = fband->powerDfs;
+		chan->antennaMax = fband->antennaMax;
+		chan->regDmnFlags = rd->flags;
+		chan->maxTxPower = AR5416_MAX_RATE_POWER;
+		chan->minTxPower = AR5416_MAX_RATE_POWER;
+		chan->channelFlags = channelFlags;
+		chan->privFlags = privFlags;
+	} else {
+		chan = &ah->ah_channels[ret];
+		chan->channelFlags |= channelFlags;
+		chan->privFlags |= privFlags;
+	}
 
-	return true;
+	/* Set CTLs */
+
+	if ((cm->flags & CHANNEL_ALL) == CHANNEL_A)
+		chan->conformanceTestLimit[0] = ctl;
+	else if ((cm->flags & CHANNEL_ALL) == CHANNEL_B)
+		chan->conformanceTestLimit[1] = ctl;
+	else if ((cm->flags & CHANNEL_ALL) == CHANNEL_G)
+		chan->conformanceTestLimit[2] = ctl;
+
+	return (ret == -1) ? true : false;
 }
 
 static bool ath9k_regd_japan_check(struct ath_hal *ah,
@@ -849,14 +885,15 @@ done:
 		ath9k_regd_sort(ichans, next,
 				sizeof(struct ath9k_channel),
 				ath9k_regd_chansort);
+
 		ah->ah_nchan = next;
 
 		DPRINTF(ah->ah_sc, ATH_DBG_REGULATORY, "Channel list:\n");
 		for (i = 0; i < next; i++) {
 			DPRINTF(ah->ah_sc, ATH_DBG_REGULATORY,
 				"chan: %d flags: 0x%x\n",
-				ichans[i].channel,
-				ichans[i].channelFlags);
+				ah->ah_channels[i].channel,
+				ah->ah_channels[i].channelFlags);
 		}
 	}
 	*nchans = next;
@@ -958,7 +995,13 @@ u_int ath9k_regd_get_ctl(struct ath_hal *ah, struct hal_channel *chan)
 	} else {
 		ichan = ath9k_regd_check_channel(ah, chan);
 		if (ichan != NULL) {
-			ctl = ichan->conformanceTestLimit;
+			/* FIXME */
+			if (IS_CHAN_A(ichan))
+				ctl = ichan->conformanceTestLimit[0];
+			else if (IS_CHAN_B(ichan))
+				ctl = ichan->conformanceTestLimit[1];
+			else if (IS_CHAN_G(ichan))
+				ctl = ichan->conformanceTestLimit[2];
 
 			if (IS_CHAN_PUREG(chan) && (ctl & 0xf) == CTL_11B)
 				ctl = (ctl & ~0xf) | CTL_11G;
-- 
1.5.6.rc2.15.g457bb.dirty


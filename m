Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:19507 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755046AbaFKKtR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Jun 2014 06:49:17 -0400
From: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, Felix Fietkau <nbd@openwrt.org>,
	Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
Subject: [PATCH 13/28] ath9k: save tsf in channel context
Date: Wed, 11 Jun 2014 16:18:01 +0530
Message-ID: <1402483696-2498-14-git-send-email-rmanohar@qti.qualcomm.com> (sfid-20140611_124922_076919_1A11D495)
In-Reply-To: <1402483696-2498-1-git-send-email-rmanohar@qti.qualcomm.com>
References: <1402483696-2498-1-git-send-email-rmanohar@qti.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Felix Fietkau <nbd@openwrt.org>

Save TSF in channel context for multiple operating channels.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
Signed-off-by: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/ath9k.h   |  3 +++
 drivers/net/wireless/ath/ath9k/channel.c |  5 +++++
 drivers/net/wireless/ath/ath9k/hw.c      | 23 ++++++++++++++++++-----
 drivers/net/wireless/ath/ath9k/hw.h      |  1 +
 drivers/net/wireless/ath/ath9k/main.c    | 10 ++++++++++
 5 files changed, 37 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index ffacbf6..4df412b 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -22,6 +22,7 @@
 #include <linux/interrupt.h>
 #include <linux/leds.h>
 #include <linux/completion.h>
+#include <linux/time.h>
 
 #include "common.h"
 #include "debug.h"
@@ -328,6 +329,8 @@ struct ath_chanctx {
 	struct list_head acq[IEEE80211_NUM_ACS];
 
 	struct ath9k_hw_cal_data caldata;
+	struct timespec tsf_ts;
+	u64 tsf_val;
 
 	u16 txpower;
 	bool offchannel;
diff --git a/drivers/net/wireless/ath/ath9k/channel.c b/drivers/net/wireless/ath/ath9k/channel.c
index e3127b5..4a7691e 100644
--- a/drivers/net/wireless/ath/ath9k/channel.c
+++ b/drivers/net/wireless/ath/ath9k/channel.c
@@ -227,6 +227,11 @@ void ath_chanctx_work(struct work_struct *work)
 
 		send_ps = true;
 		spin_lock_bh(&sc->chan_lock);
+
+		if (sc->cur_chan != &sc->offchannel.chan) {
+			getrawmonotonic(&sc->cur_chan->tsf_ts);
+			sc->cur_chan->tsf_val = ath9k_hw_gettsf64(sc->sc_ah);
+		}
 	}
 	sc->cur_chan = sc->next_chan;
 	sc->cur_chan->stopped = false;
diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index 2a8ed83..ace4fe2 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -1730,6 +1730,23 @@ fail:
 	return -EINVAL;
 }
 
+u32 ath9k_hw_get_tsf_offset(struct timespec *last, struct timespec *cur)
+{
+	struct timespec ts;
+	s64 usec;
+
+	if (!cur) {
+		getrawmonotonic(&ts);
+		cur = &ts;
+	}
+
+	usec = cur->tv_sec * 1000000ULL + cur->tv_nsec / 1000;
+	usec -= last->tv_sec * 1000000ULL + last->tv_nsec / 1000;
+
+	return (u32) usec;
+}
+EXPORT_SYMBOL(ath9k_hw_get_tsf_offset);
+
 int ath9k_hw_reset(struct ath_hw *ah, struct ath9k_channel *chan,
 		   struct ath9k_hw_cal_data *caldata, bool fastcc)
 {
@@ -1739,7 +1756,6 @@ int ath9k_hw_reset(struct ath_hw *ah, struct ath9k_channel *chan,
 	u32 saveDefAntenna;
 	u32 macStaId1;
 	u64 tsf = 0;
-	s64 usec = 0;
 	int r;
 	bool start_mci_reset = false;
 	bool save_fullsleep = ah->chip_fullsleep;
@@ -1785,7 +1801,6 @@ int ath9k_hw_reset(struct ath_hw *ah, struct ath9k_channel *chan,
 	/* Save TSF before chip reset, a cold reset clears it */
 	tsf = ath9k_hw_gettsf64(ah);
 	getrawmonotonic(&ts);
-	usec = ts.tv_sec * 1000000ULL + ts.tv_nsec / 1000;
 
 	saveLedState = REG_READ(ah, AR_CFG_LED) &
 		(AR_CFG_LED_ASSOC_CTL | AR_CFG_LED_MODE_SEL |
@@ -1818,9 +1833,7 @@ int ath9k_hw_reset(struct ath_hw *ah, struct ath9k_channel *chan,
 	}
 
 	/* Restore TSF */
-	getrawmonotonic(&ts);
-	usec = ts.tv_sec * 1000000ULL + ts.tv_nsec / 1000 - usec;
-	ath9k_hw_settsf64(ah, tsf + usec);
+	ath9k_hw_settsf64(ah, tsf + ath9k_hw_get_tsf_offset(&ts, NULL));
 
 	if (AR_SREV_9280_20_OR_LATER(ah))
 		REG_SET_BIT(ah, AR_GPIO_INPUT_EN_VAL, AR_GPIO_JTAG_DISABLE);
diff --git a/drivers/net/wireless/ath/ath9k/hw.h b/drivers/net/wireless/ath/ath9k/hw.h
index 0acd4b5..51b4ebe 100644
--- a/drivers/net/wireless/ath/ath9k/hw.h
+++ b/drivers/net/wireless/ath/ath9k/hw.h
@@ -1000,6 +1000,7 @@ u32 ath9k_hw_gettsf32(struct ath_hw *ah);
 u64 ath9k_hw_gettsf64(struct ath_hw *ah);
 void ath9k_hw_settsf64(struct ath_hw *ah, u64 tsf64);
 void ath9k_hw_reset_tsf(struct ath_hw *ah);
+u32 ath9k_hw_get_tsf_offset(struct timespec *last, struct timespec *cur);
 void ath9k_hw_set_tsfadjust(struct ath_hw *ah, bool set);
 void ath9k_hw_init_global_settings(struct ath_hw *ah);
 u32 ar9003_get_pll_sqsum_dvc(struct ath_hw *ah);
diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index 85db24b..6abdf99 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -240,6 +240,16 @@ static bool ath_complete_reset(struct ath_softc *sc, bool start)
 	ath9k_hw_enable_interrupts(ah);
 
 	if (!sc->cur_chan->offchannel && start) {
+		/* restore per chanctx TSF timer */
+		if (sc->cur_chan->tsf_val) {
+			u32 offset;
+
+			offset = ath9k_hw_get_tsf_offset(&sc->cur_chan->tsf_ts,
+							 NULL);
+			ath9k_hw_settsf64(ah, sc->cur_chan->tsf_val + offset);
+		}
+
+
 		if (!test_bit(ATH_OP_BEACONS, &common->op_flags))
 			goto work;
 
-- 
2.0.0


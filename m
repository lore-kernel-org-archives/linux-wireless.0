Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:17988 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753221AbaFDNr0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Jun 2014 09:47:26 -0400
From: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, Felix Fietkau <nbd@openwrt.org>,
	Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
Subject: [PATCH 01/13] ath9k: Add channel context structure
Date: Wed, 4 Jun 2014 19:16:27 +0530
Message-ID: <1401889599-412-2-git-send-email-rmanohar@qti.qualcomm.com> (sfid-20140604_154738_084398_88EDF77A)
In-Reply-To: <1401889599-412-1-git-send-email-rmanohar@qti.qualcomm.com>
References: <1401889599-412-1-git-send-email-rmanohar@qti.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Felix Fietkau <nbd@openwrt.org>

The channel context structure is defined to enable
multi-channel concurrency support.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
Signed-off-by: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/Makefile  |   3 +-
 drivers/net/wireless/ath/ath9k/ath9k.h   |  18 +++++
 drivers/net/wireless/ath/ath9k/channel.c | 133 +++++++++++++++++++++++++++++++
 drivers/net/wireless/ath/ath9k/init.c    |   1 +
 drivers/net/wireless/ath/ath9k/link.c    |   2 +-
 drivers/net/wireless/ath/ath9k/main.c    | 111 +++-----------------------
 drivers/net/wireless/ath/ath9k/recv.c    |   4 +-
 7 files changed, 169 insertions(+), 103 deletions(-)
 create mode 100644 drivers/net/wireless/ath/ath9k/channel.c

diff --git a/drivers/net/wireless/ath/ath9k/Makefile b/drivers/net/wireless/ath/ath9k/Makefile
index 8fcd586..6b4020a 100644
--- a/drivers/net/wireless/ath/ath9k/Makefile
+++ b/drivers/net/wireless/ath/ath9k/Makefile
@@ -5,7 +5,8 @@ ath9k-y +=	beacon.o \
 		recv.o \
 		xmit.o \
 		link.o \
-		antenna.o
+		antenna.o \
+		channel.o
 
 ath9k-$(CONFIG_ATH9K_BTCOEX_SUPPORT) += mci.o
 ath9k-$(CONFIG_ATH9K_PCI) += pci.o
diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index 2ca8f7e..cc75b9d 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -325,6 +325,16 @@ struct ath_rx {
 	u32 ampdu_ref;
 };
 
+struct ath_chanctx {
+	struct cfg80211_chan_def chandef;
+	struct list_head vifs;
+	bool offchannel;
+};
+
+void ath_chanctx_init(struct ath_softc *sc);
+int ath_chanctx_set_channel(struct ath_softc *sc, struct ath_chanctx *ctx,
+			      struct cfg80211_chan_def *chandef);
+int ath_reset_internal(struct ath_softc *sc, struct ath9k_channel *hchan);
 int ath_startrecv(struct ath_softc *sc);
 bool ath_stoprecv(struct ath_softc *sc);
 u32 ath_calcrxfilter(struct ath_softc *sc);
@@ -370,12 +380,15 @@ void ath9k_release_buffered_frames(struct ieee80211_hw *hw,
 /********/
 
 struct ath_vif {
+	struct list_head list;
+
 	struct ieee80211_vif *vif;
 	struct ath_node mcast_node;
 	int av_bslot;
 	bool primary_sta_vif;
 	__le64 tsf_adjust; /* TSF adjustment for staggered beacons */
 	struct ath_buf *av_bcbuf;
+	struct ath_chanctx *chanctx;
 
 	/* P2P Client */
 	struct ieee80211_noa_data noa;
@@ -702,6 +715,8 @@ void ath_ant_comb_scan(struct ath_softc *sc, struct ath_rx_status *rs);
 #define PS_BEACON_SYNC            BIT(4)
 #define PS_WAIT_FOR_ANI           BIT(5)
 
+#define ATH9K_NUM_CHANCTX  3 /* 2 oper_channel + 1 off_channel */
+
 struct ath_softc {
 	struct ieee80211_hw *hw;
 	struct device *dev;
@@ -743,6 +758,9 @@ struct ath_softc {
 	struct ath_tx tx;
 	struct ath_beacon beacon;
 
+	struct ath_chanctx chanctx[ATH9K_NUM_CHANCTX];
+	struct ath_chanctx *cur_chan;
+
 #ifdef CONFIG_MAC80211_LEDS
 	bool led_registered;
 	char led_name[32];
diff --git a/drivers/net/wireless/ath/ath9k/channel.c b/drivers/net/wireless/ath/ath9k/channel.c
new file mode 100644
index 0000000..aee6cdb
--- /dev/null
+++ b/drivers/net/wireless/ath/ath9k/channel.c
@@ -0,0 +1,133 @@
+/*
+ * Copyright (c) 2014 Qualcomm Atheros, Inc.
+ *
+ * Permission to use, copy, modify, and/or distribute this software for any
+ * purpose with or without fee is hereby granted, provided that the above
+ * copyright notice and this permission notice appear in all copies.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
+ * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
+ * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
+ * ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
+ * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
+ * ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
+ * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
+ */
+
+#include "ath9k.h"
+
+/* Set/change channels.  If the channel is really being changed, it's done
+ * by reseting the chip.  To accomplish this we must first cleanup any pending
+ * DMA, then restart stuff.
+ */
+static int ath_set_channel(struct ath_softc *sc)
+{
+	struct ath_hw *ah = sc->sc_ah;
+	struct ath_common *common = ath9k_hw_common(ah);
+	struct ieee80211_hw *hw = sc->hw;
+	struct ath9k_channel *hchan;
+	struct cfg80211_chan_def *chandef = &sc->cur_chan->chandef;
+	struct ieee80211_channel *chan = chandef->chan;
+	int pos = chan->hw_value;
+	int old_pos = -1;
+	int r;
+
+	if (test_bit(ATH_OP_INVALID, &common->op_flags))
+		return -EIO;
+
+	if (ah->curchan)
+		old_pos = ah->curchan - &ah->channels[0];
+
+	ath_dbg(common, CONFIG, "Set channel: %d MHz width: %d\n",
+		chan->center_freq, chandef->width);
+
+	/* update survey stats for the old channel before switching */
+	spin_lock_bh(&common->cc_lock);
+	ath_update_survey_stats(sc);
+	spin_unlock_bh(&common->cc_lock);
+
+	ath9k_cmn_get_channel(hw, ah, chandef);
+
+	/* If the operating channel changes, change the survey in-use flags
+	 * along with it.
+	 * Reset the survey data for the new channel, unless we're switching
+	 * back to the operating channel from an off-channel operation.
+	 */
+	if (!sc->cur_chan->offchannel && sc->cur_survey != &sc->survey[pos]) {
+		if (sc->cur_survey)
+			sc->cur_survey->filled &= ~SURVEY_INFO_IN_USE;
+
+		sc->cur_survey = &sc->survey[pos];
+
+		memset(sc->cur_survey, 0, sizeof(struct survey_info));
+		sc->cur_survey->filled |= SURVEY_INFO_IN_USE;
+	} else if (!(sc->survey[pos].filled & SURVEY_INFO_IN_USE)) {
+		memset(&sc->survey[pos], 0, sizeof(struct survey_info));
+	}
+
+	hchan = &sc->sc_ah->channels[pos];
+	r = ath_reset_internal(sc, hchan);
+	if (r)
+		return r;
+
+	/* The most recent snapshot of channel->noisefloor for the old
+	 * channel is only available after the hardware reset. Copy it to
+	 * the survey stats now.
+	 */
+	if (old_pos >= 0)
+		ath_update_survey_nf(sc, old_pos);
+
+	/* Enable radar pulse detection if on a DFS channel. Spectral
+	 * scanning and radar detection can not be used concurrently.
+	 */
+	if (hw->conf.radar_enabled) {
+		u32 rxfilter;
+
+		/* set HW specific DFS configuration */
+		ath9k_hw_set_radar_params(ah);
+		rxfilter = ath9k_hw_getrxfilter(ah);
+		rxfilter |= ATH9K_RX_FILTER_PHYRADAR |
+				ATH9K_RX_FILTER_PHYERR;
+		ath9k_hw_setrxfilter(ah, rxfilter);
+		ath_dbg(common, DFS, "DFS enabled at freq %d\n",
+			chan->center_freq);
+	} else {
+		/* perform spectral scan if requested. */
+		if (test_bit(ATH_OP_SCANNING, &common->op_flags) &&
+			sc->spectral_mode == SPECTRAL_CHANSCAN)
+			ath9k_spectral_scan_trigger(hw);
+	}
+
+	return 0;
+}
+
+void ath_chanctx_init(struct ath_softc *sc)
+{
+	struct ath_chanctx *ctx;
+	struct ath_common *common = ath9k_hw_common(sc->sc_ah);
+	struct ieee80211_supported_band *sband;
+	struct ieee80211_channel *chan;
+	int i;
+
+	sband = &common->sbands[IEEE80211_BAND_2GHZ];
+	if (!sband->n_channels)
+		sband = &common->sbands[IEEE80211_BAND_5GHZ];
+
+	chan = &sband->channels[0];
+	for (i = 0; i < ATH9K_NUM_CHANCTX; i++) {
+		ctx = &sc->chanctx[i];
+		cfg80211_chandef_create(&ctx->chandef, chan, NL80211_CHAN_HT20);
+		INIT_LIST_HEAD(&ctx->vifs);
+	}
+	sc->cur_chan = &sc->chanctx[0];
+}
+
+int ath_chanctx_set_channel(struct ath_softc *sc, struct ath_chanctx *ctx,
+			      struct cfg80211_chan_def *chandef)
+{
+	memcpy(&ctx->chandef, chandef, sizeof(ctx->chandef));
+	if (ctx != sc->cur_chan)
+		return 0;
+
+	return ath_set_channel(sc);
+}
diff --git a/drivers/net/wireless/ath/ath9k/init.c b/drivers/net/wireless/ath/ath9k/init.c
index 0246b99..32d9542 100644
--- a/drivers/net/wireless/ath/ath9k/init.c
+++ b/drivers/net/wireless/ath/ath9k/init.c
@@ -599,6 +599,7 @@ static int ath9k_init_softc(u16 devid, struct ath_softc *sc,
 	ath9k_cmn_init_crypto(sc->sc_ah);
 	ath9k_init_misc(sc);
 	ath_fill_led_pin(sc);
+	ath_chanctx_init(sc);
 
 	if (common->bus_ops->aspm_init)
 		common->bus_ops->aspm_init(common);
diff --git a/drivers/net/wireless/ath/ath9k/link.c b/drivers/net/wireless/ath/ath9k/link.c
index 72a715f..6f91974 100644
--- a/drivers/net/wireless/ath/ath9k/link.c
+++ b/drivers/net/wireless/ath/ath9k/link.c
@@ -416,7 +416,7 @@ void ath_start_ani(struct ath_softc *sc)
 
 	if (common->disable_ani ||
 	    !test_bit(ATH_OP_ANI_RUN, &common->op_flags) ||
-	    (sc->hw->conf.flags & IEEE80211_CONF_OFFCHANNEL))
+	    sc->cur_chan->offchannel)
 		return;
 
 	common->ani.longcal_timer = timestamp;
diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index 62ac95d..2e7cce7 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -233,7 +233,7 @@ static bool ath_complete_reset(struct ath_softc *sc, bool start)
 	ath9k_hw_set_interrupts(ah);
 	ath9k_hw_enable_interrupts(ah);
 
-	if (!(sc->hw->conf.flags & IEEE80211_CONF_OFFCHANNEL) && start) {
+	if (!sc->cur_chan->offchannel && start) {
 		if (!test_bit(ATH_OP_BEACONS, &common->op_flags))
 			goto work;
 
@@ -266,7 +266,7 @@ static bool ath_complete_reset(struct ath_softc *sc, bool start)
 	return true;
 }
 
-static int ath_reset_internal(struct ath_softc *sc, struct ath9k_channel *hchan)
+int ath_reset_internal(struct ath_softc *sc, struct ath9k_channel *hchan)
 {
 	struct ath_hw *ah = sc->sc_ah;
 	struct ath_common *common = ath9k_hw_common(ah);
@@ -279,7 +279,7 @@ static int ath_reset_internal(struct ath_softc *sc, struct ath9k_channel *hchan)
 	tasklet_disable(&sc->intr_tq);
 	spin_lock_bh(&sc->sc_pcu_lock);
 
-	if (!(sc->hw->conf.flags & IEEE80211_CONF_OFFCHANNEL)) {
+	if (!sc->cur_chan->offchannel) {
 		fastcc = false;
 		caldata = &sc->caldata;
 	}
@@ -307,7 +307,7 @@ static int ath_reset_internal(struct ath_softc *sc, struct ath9k_channel *hchan)
 	}
 
 	if (ath9k_hw_mci_is_enabled(sc->sc_ah) &&
-	    (sc->hw->conf.flags & IEEE80211_CONF_OFFCHANNEL))
+	    sc->cur_chan->offchannel)
 		ath9k_mci_set_txpower(sc, true, false);
 
 	if (!ath_complete_reset(sc, true))
@@ -320,98 +320,6 @@ out:
 	return r;
 }
 
-
-/*
- * Set/change channels.  If the channel is really being changed, it's done
- * by reseting the chip.  To accomplish this we must first cleanup any pending
- * DMA, then restart stuff.
-*/
-static int ath_set_channel(struct ath_softc *sc, struct cfg80211_chan_def *chandef)
-{
-	struct ath_hw *ah = sc->sc_ah;
-	struct ath_common *common = ath9k_hw_common(ah);
-	struct ieee80211_hw *hw = sc->hw;
-	struct ath9k_channel *hchan;
-	struct ieee80211_channel *chan = chandef->chan;
-	bool offchannel;
-	int pos = chan->hw_value;
-	int old_pos = -1;
-	int r;
-
-	if (test_bit(ATH_OP_INVALID, &common->op_flags))
-		return -EIO;
-
-	offchannel = !!(hw->conf.flags & IEEE80211_CONF_OFFCHANNEL);
-
-	if (ah->curchan)
-		old_pos = ah->curchan - &ah->channels[0];
-
-	ath_dbg(common, CONFIG, "Set channel: %d MHz width: %d\n",
-		chan->center_freq, chandef->width);
-
-	/* update survey stats for the old channel before switching */
-	spin_lock_bh(&common->cc_lock);
-	ath_update_survey_stats(sc);
-	spin_unlock_bh(&common->cc_lock);
-
-	ath9k_cmn_get_channel(hw, ah, chandef);
-
-	/*
-	 * If the operating channel changes, change the survey in-use flags
-	 * along with it.
-	 * Reset the survey data for the new channel, unless we're switching
-	 * back to the operating channel from an off-channel operation.
-	 */
-	if (!offchannel && sc->cur_survey != &sc->survey[pos]) {
-		if (sc->cur_survey)
-			sc->cur_survey->filled &= ~SURVEY_INFO_IN_USE;
-
-		sc->cur_survey = &sc->survey[pos];
-
-		memset(sc->cur_survey, 0, sizeof(struct survey_info));
-		sc->cur_survey->filled |= SURVEY_INFO_IN_USE;
-	} else if (!(sc->survey[pos].filled & SURVEY_INFO_IN_USE)) {
-		memset(&sc->survey[pos], 0, sizeof(struct survey_info));
-	}
-
-	hchan = &sc->sc_ah->channels[pos];
-	r = ath_reset_internal(sc, hchan);
-	if (r)
-		return r;
-
-	/*
-	 * The most recent snapshot of channel->noisefloor for the old
-	 * channel is only available after the hardware reset. Copy it to
-	 * the survey stats now.
-	 */
-	if (old_pos >= 0)
-		ath_update_survey_nf(sc, old_pos);
-
-	/*
-	 * Enable radar pulse detection if on a DFS channel. Spectral
-	 * scanning and radar detection can not be used concurrently.
-	 */
-	if (hw->conf.radar_enabled) {
-		u32 rxfilter;
-
-		/* set HW specific DFS configuration */
-		ath9k_hw_set_radar_params(ah);
-		rxfilter = ath9k_hw_getrxfilter(ah);
-		rxfilter |= ATH9K_RX_FILTER_PHYRADAR |
-				ATH9K_RX_FILTER_PHYERR;
-		ath9k_hw_setrxfilter(ah, rxfilter);
-		ath_dbg(common, DFS, "DFS enabled at freq %d\n",
-			chan->center_freq);
-	} else {
-		/* perform spectral scan if requested. */
-		if (test_bit(ATH_OP_SCANNING, &common->op_flags) &&
-			sc->spectral_mode == SPECTRAL_CHANSCAN)
-			ath9k_spectral_scan_trigger(hw);
-	}
-
-	return 0;
-}
-
 static void ath_node_attach(struct ath_softc *sc, struct ieee80211_sta *sta,
 			    struct ieee80211_vif *vif)
 {
@@ -713,6 +621,7 @@ static int ath9k_start(struct ieee80211_hw *hw)
 	struct ath_hw *ah = sc->sc_ah;
 	struct ath_common *common = ath9k_hw_common(ah);
 	struct ieee80211_channel *curchan = hw->conf.chandef.chan;
+	struct ath_chanctx *ctx = sc->cur_chan;
 	struct ath9k_channel *init_channel;
 	int r;
 
@@ -723,7 +632,8 @@ static int ath9k_start(struct ieee80211_hw *hw)
 	ath9k_ps_wakeup(sc);
 	mutex_lock(&sc->mutex);
 
-	init_channel = ath9k_cmn_get_channel(hw, ah, &hw->conf.chandef);
+	memcpy(&ctx->chandef, &hw->conf.chandef, sizeof(ctx->chandef));
+	init_channel = ath9k_cmn_get_channel(hw, ah, &ctx->chandef);
 
 	/* Reset SERDES registers */
 	ath9k_hw_configpcipowersave(ah, false);
@@ -934,7 +844,8 @@ static void ath9k_stop(struct ieee80211_hw *hw)
 	}
 
 	if (!ah->curchan)
-		ah->curchan = ath9k_cmn_get_channel(hw, ah, &hw->conf.chandef);
+		ah->curchan = ath9k_cmn_get_channel(hw, ah,
+						    &sc->cur_chan->chandef);
 
 	ath9k_hw_reset(ah, ah->curchan, ah->caldata, false);
 	ath9k_hw_phy_disable(ah);
@@ -1345,6 +1256,7 @@ static int ath9k_config(struct ieee80211_hw *hw, u32 changed)
 	struct ath_hw *ah = sc->sc_ah;
 	struct ath_common *common = ath9k_hw_common(ah);
 	struct ieee80211_conf *conf = &hw->conf;
+	struct ath_chanctx *ctx = sc->cur_chan;
 	bool reset_channel = false;
 
 	ath9k_ps_wakeup(sc);
@@ -1392,7 +1304,8 @@ static int ath9k_config(struct ieee80211_hw *hw, u32 changed)
 	}
 
 	if ((changed & IEEE80211_CONF_CHANGE_CHANNEL) || reset_channel) {
-		if (ath_set_channel(sc, &hw->conf.chandef) < 0) {
+		ctx->offchannel = !!(conf->flags & IEEE80211_CONF_OFFCHANNEL);
+		if (ath_chanctx_set_channel(sc, ctx, &hw->conf.chandef) < 0) {
 			ath_err(common, "Unable to set channel\n");
 			mutex_unlock(&sc->mutex);
 			ath9k_ps_restore(sc);
diff --git a/drivers/net/wireless/ath/ath9k/recv.c b/drivers/net/wireless/ath/ath9k/recv.c
index 9105a92..de5684a 100644
--- a/drivers/net/wireless/ath/ath9k/recv.c
+++ b/drivers/net/wireless/ath/ath9k/recv.c
@@ -259,7 +259,7 @@ static void ath_edma_start_recv(struct ath_softc *sc)
 	ath_rx_addbuffer_edma(sc, ATH9K_RX_QUEUE_HP);
 	ath_rx_addbuffer_edma(sc, ATH9K_RX_QUEUE_LP);
 	ath_opmode_init(sc);
-	ath9k_hw_startpcureceive(sc->sc_ah, !!(sc->hw->conf.flags & IEEE80211_CONF_OFFCHANNEL));
+	ath9k_hw_startpcureceive(sc->sc_ah, sc->cur_chan->offchannel);
 }
 
 static void ath_edma_stop_recv(struct ath_softc *sc)
@@ -457,7 +457,7 @@ int ath_startrecv(struct ath_softc *sc)
 
 start_recv:
 	ath_opmode_init(sc);
-	ath9k_hw_startpcureceive(ah, !!(sc->hw->conf.flags & IEEE80211_CONF_OFFCHANNEL));
+	ath9k_hw_startpcureceive(ah, sc->cur_chan->offchannel);
 
 	return 0;
 }
-- 
2.0.0


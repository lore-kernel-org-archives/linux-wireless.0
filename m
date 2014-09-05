Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.22]:42620 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755577AbaIECdX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 4 Sep 2014 22:33:23 -0400
From: Sujith Manoharan <sujith@msujith.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, ath9k-devel@qca.qualcomm.com
Subject: [PATCH v3 10/11] ath9k: Fix RX filters in channel contexts
Date: Fri,  5 Sep 2014 08:03:18 +0530
Message-Id: <1409884399-32289-11-git-send-email-sujith@msujith.org> (sfid-20140905_043330_359665_4C7BAE70)
In-Reply-To: <1409884399-32289-1-git-send-email-sujith@msujith.org>
References: <1409884399-32289-1-git-send-email-sujith@msujith.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

Maintain the RX filter on a per-channel-context
basis and not globally. Not doing so was resulting
in incorrect filter calculation.

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/ath9k.h |  3 ++-
 drivers/net/wireless/ath/ath9k/main.c  |  5 ++++-
 drivers/net/wireless/ath/ath9k/recv.c  | 21 +++++++++++++++------
 3 files changed, 21 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index 12cdabb..4f3da18 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -314,7 +314,6 @@ struct ath_rx {
 	bool discard_next;
 	u32 *rxlink;
 	u32 num_pkts;
-	unsigned int rxfilter;
 	struct list_head rxbuf;
 	struct ath_descdma rxdma;
 	struct ath_rx_edma rx_edma[ATH9K_RX_QUEUE_MAX];
@@ -350,6 +349,8 @@ struct ath_chanctx {
 	bool active;
 	bool assigned;
 	bool switch_after_beacon;
+
+	unsigned int rxfilter;
 };
 
 enum ath_chanctx_event {
diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index 18e5e91..a202859 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -1427,7 +1427,10 @@ static void ath9k_configure_filter(struct ieee80211_hw *hw,
 	changed_flags &= SUPPORTED_FILTERS;
 	*total_flags &= SUPPORTED_FILTERS;
 
-	sc->rx.rxfilter = *total_flags;
+	spin_lock_bh(&sc->chan_lock);
+	sc->cur_chan->rxfilter = *total_flags;
+	spin_unlock_bh(&sc->chan_lock);
+
 	ath9k_ps_wakeup(sc);
 	rfilt = ath_calcrxfilter(sc);
 	ath9k_hw_setrxfilter(sc->sc_ah, rfilt);
diff --git a/drivers/net/wireless/ath/ath9k/recv.c b/drivers/net/wireless/ath/ath9k/recv.c
index 63fbc3e..68e56d6 100644
--- a/drivers/net/wireless/ath/ath9k/recv.c
+++ b/drivers/net/wireless/ath/ath9k/recv.c
@@ -387,7 +387,9 @@ u32 ath_calcrxfilter(struct ath_softc *sc)
 	if (sc->hw->conf.radar_enabled)
 		rfilt |= ATH9K_RX_FILTER_PHYRADAR | ATH9K_RX_FILTER_PHYERR;
 
-	if (sc->rx.rxfilter & FIF_PROBE_REQ)
+	spin_lock_bh(&sc->chan_lock);
+
+	if (sc->cur_chan->rxfilter & FIF_PROBE_REQ)
 		rfilt |= ATH9K_RX_FILTER_PROBEREQ;
 
 	/*
@@ -398,24 +400,24 @@ u32 ath_calcrxfilter(struct ath_softc *sc)
 	if (sc->sc_ah->is_monitoring)
 		rfilt |= ATH9K_RX_FILTER_PROM;
 
-	if (sc->rx.rxfilter & FIF_CONTROL)
+	if (sc->cur_chan->rxfilter & FIF_CONTROL)
 		rfilt |= ATH9K_RX_FILTER_CONTROL;
 
 	if ((sc->sc_ah->opmode == NL80211_IFTYPE_STATION) &&
 	    (sc->nvifs <= 1) &&
-	    !(sc->rx.rxfilter & FIF_BCN_PRBRESP_PROMISC))
+	    !(sc->cur_chan->rxfilter & FIF_BCN_PRBRESP_PROMISC))
 		rfilt |= ATH9K_RX_FILTER_MYBEACON;
 	else
 		rfilt |= ATH9K_RX_FILTER_BEACON;
 
 	if ((sc->sc_ah->opmode == NL80211_IFTYPE_AP) ||
-	    (sc->rx.rxfilter & FIF_PSPOLL))
+	    (sc->cur_chan->rxfilter & FIF_PSPOLL))
 		rfilt |= ATH9K_RX_FILTER_PSPOLL;
 
 	if (sc->cur_chandef.width != NL80211_CHAN_WIDTH_20_NOHT)
 		rfilt |= ATH9K_RX_FILTER_COMP_BAR;
 
-	if (sc->nvifs > 1 || (sc->rx.rxfilter & FIF_OTHER_BSS)) {
+	if (sc->nvifs > 1 || (sc->cur_chan->rxfilter & FIF_OTHER_BSS)) {
 		/* This is needed for older chips */
 		if (sc->sc_ah->hw_version.macVersion <= AR_SREV_VERSION_9160)
 			rfilt |= ATH9K_RX_FILTER_PROM;
@@ -429,6 +431,8 @@ u32 ath_calcrxfilter(struct ath_softc *sc)
 	    test_bit(ATH_OP_SCANNING, &common->op_flags))
 		rfilt |= ATH9K_RX_FILTER_BEACON;
 
+	spin_unlock_bh(&sc->chan_lock);
+
 	return rfilt;
 
 }
@@ -865,8 +869,13 @@ static int ath9k_rx_skb_preprocess(struct ath_softc *sc,
 	 * everything but the rate is checked here, the rate check is done
 	 * separately to avoid doing two lookups for a rate for each frame.
 	 */
-	if (!ath9k_cmn_rx_accept(common, hdr, rx_status, rx_stats, decrypt_error, sc->rx.rxfilter))
+	spin_lock_bh(&sc->chan_lock);
+	if (!ath9k_cmn_rx_accept(common, hdr, rx_status, rx_stats, decrypt_error,
+				 sc->cur_chan->rxfilter)) {
+		spin_unlock_bh(&sc->chan_lock);
 		return -EINVAL;
+	}
+	spin_unlock_bh(&sc->chan_lock);
 
 	if (ath_is_mybeacon(common, hdr)) {
 		RX_STAT_INC(rx_beacons);
-- 
2.1.0


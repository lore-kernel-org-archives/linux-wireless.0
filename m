Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f172.google.com ([209.85.217.172]:33945 "EHLO
	mail-lb0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754252AbbFVLnf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Jun 2015 07:43:35 -0400
Received: by lbnk3 with SMTP id k3so782935lbn.1
        for <linux-wireless@vger.kernel.org>; Mon, 22 Jun 2015 04:43:33 -0700 (PDT)
From: Janusz Dziedzic <janusz.dziedzic@tieto.com>
To: linux-wireless@vger.kernel.org
Cc: ath9k-devel@venema.h4ckr.net, nbd@openwrt.org, sujith@msujith.org,
	Janusz Dziedzic <janusz.dziedzic@tieto.com>
Subject: [PATCH 2/3] ath9k: make rxfilter per HW
Date: Mon, 22 Jun 2015 13:43:04 +0200
Message-Id: <1434973385-15865-3-git-send-email-janusz.dziedzic@tieto.com> (sfid-20150622_134339_744222_8D689257)
In-Reply-To: <1434973385-15865-1-git-send-email-janusz.dziedzic@tieto.com>
References: <1434973385-15865-1-git-send-email-janusz.dziedzic@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

mac80211 configure rxfilter per HW,
so we don't need this per channel.

This fix problem when chanctx used and ath9k
allocate new internal ath_chanctx (eg. when
offchannel) and we loose rxfilter configuration.

Eg. when p2p_find (with use_chanctx=1), during
remain on channel, driver create new ath_chanctx
with incorrect rxfilter. Then we didn't receive
probe requests and fail p2p_find.

Signed-off-by: Janusz Dziedzic <janusz.dziedzic@tieto.com>
---
 drivers/net/wireless/ath/ath9k/ath9k.h |  3 ++-
 drivers/net/wireless/ath/ath9k/main.c  |  2 +-
 drivers/net/wireless/ath/ath9k/recv.c  | 12 ++++++------
 3 files changed, 9 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index a7a81b3..030fd0f 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -356,7 +356,6 @@ struct ath_chanctx {
 
 	short nvifs;
 	short nvifs_assigned;
-	unsigned int rxfilter;
 };
 
 enum ath_chanctx_event {
@@ -1001,8 +1000,10 @@ struct ath_softc {
 	struct cfg80211_chan_def cur_chandef;
 	struct ath_chanctx chanctx[ATH9K_NUM_CHANCTX];
 	struct ath_chanctx *cur_chan;
+	unsigned int rxfilter;
 	spinlock_t chan_lock;
 
+
 #ifdef CONFIG_MAC80211_LEDS
 	bool led_registered;
 	char led_name[32];
diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index d285e3a..945f002 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -1463,7 +1463,7 @@ static void ath9k_configure_filter(struct ieee80211_hw *hw,
 	*total_flags &= SUPPORTED_FILTERS;
 
 	spin_lock_bh(&sc->chan_lock);
-	sc->cur_chan->rxfilter = *total_flags;
+	sc->rxfilter = *total_flags;
 	spin_unlock_bh(&sc->chan_lock);
 
 	ath9k_ps_wakeup(sc);
diff --git a/drivers/net/wireless/ath/ath9k/recv.c b/drivers/net/wireless/ath/ath9k/recv.c
index 6c75fb1..5f72c65 100644
--- a/drivers/net/wireless/ath/ath9k/recv.c
+++ b/drivers/net/wireless/ath/ath9k/recv.c
@@ -389,31 +389,31 @@ u32 ath_calcrxfilter(struct ath_softc *sc)
 
 	spin_lock_bh(&sc->chan_lock);
 
-	if (sc->cur_chan->rxfilter & FIF_PROBE_REQ)
+	if (sc->rxfilter & FIF_PROBE_REQ)
 		rfilt |= ATH9K_RX_FILTER_PROBEREQ;
 
 	if (sc->sc_ah->is_monitoring)
 		rfilt |= ATH9K_RX_FILTER_PROM;
 
-	if ((sc->cur_chan->rxfilter & FIF_CONTROL) ||
+	if ((sc->rxfilter & FIF_CONTROL) ||
 	    sc->sc_ah->dynack.enabled)
 		rfilt |= ATH9K_RX_FILTER_CONTROL;
 
 	if ((sc->sc_ah->opmode == NL80211_IFTYPE_STATION) &&
 	    (sc->cur_chan->nvifs <= 1) &&
-	    !(sc->cur_chan->rxfilter & FIF_BCN_PRBRESP_PROMISC))
+	    !(sc->rxfilter & FIF_BCN_PRBRESP_PROMISC))
 		rfilt |= ATH9K_RX_FILTER_MYBEACON;
 	else
 		rfilt |= ATH9K_RX_FILTER_BEACON;
 
 	if ((sc->sc_ah->opmode == NL80211_IFTYPE_AP) ||
-	    (sc->cur_chan->rxfilter & FIF_PSPOLL))
+	    (sc->rxfilter & FIF_PSPOLL))
 		rfilt |= ATH9K_RX_FILTER_PSPOLL;
 
 	if (sc->cur_chandef.width != NL80211_CHAN_WIDTH_20_NOHT)
 		rfilt |= ATH9K_RX_FILTER_COMP_BAR;
 
-	if (sc->cur_chan->nvifs > 1 || (sc->cur_chan->rxfilter & FIF_OTHER_BSS)) {
+	if (sc->cur_chan->nvifs > 1 || (sc->rxfilter & FIF_OTHER_BSS)) {
 		/* This is needed for older chips */
 		if (sc->sc_ah->hw_version.macVersion <= AR_SREV_VERSION_9160)
 			rfilt |= ATH9K_RX_FILTER_PROM;
@@ -878,7 +878,7 @@ static int ath9k_rx_skb_preprocess(struct ath_softc *sc,
 	 */
 	spin_lock_bh(&sc->chan_lock);
 	if (!ath9k_cmn_rx_accept(common, hdr, rx_status, rx_stats, decrypt_error,
-				 sc->cur_chan->rxfilter)) {
+				 sc->rxfilter)) {
 		spin_unlock_bh(&sc->chan_lock);
 		return -EINVAL;
 	}
-- 
1.9.1

--
To unsubscribe from this list: send the line "unsubscribe linux-wireless" in

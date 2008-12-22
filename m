Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:25145 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752423AbYLVSVM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Dec 2008 13:21:12 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 22 Dec 2008 10:21:12 -0800
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <linville@tuxdriver.com>, <linville@tuxdriver.com>
CC: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	<linux-wireless@vger.kernel.org>, <ath9k-devel@lists.ath9k.org>
Subject: [PATCH v2 10/18] ath9k: make use of conf_is_ht*() in the rest of the driver
Date: Mon, 22 Dec 2008 10:20:31 -0800
Message-ID: <1229970039-10561-11-git-send-email-lrodriguez@atheros.com> (sfid-20081222_193905_119690_7ECF379B)
In-Reply-To: <1229970039-10561-10-git-send-email-lrodriguez@atheros.com>
References: <1229970039-10561-1-git-send-email-lrodriguez@atheros.com>
 <1229970039-10561-2-git-send-email-lrodriguez@atheros.com>
 <1229970039-10561-3-git-send-email-lrodriguez@atheros.com>
 <1229970039-10561-4-git-send-email-lrodriguez@atheros.com>
 <1229970039-10561-5-git-send-email-lrodriguez@atheros.com>
 <1229970039-10561-6-git-send-email-lrodriguez@atheros.com>
 <1229970039-10561-7-git-send-email-lrodriguez@atheros.com>
 <1229970039-10561-8-git-send-email-lrodriguez@atheros.com>
 <1229970039-10561-9-git-send-email-lrodriguez@atheros.com>
 <1229970039-10561-10-git-send-email-lrodriguez@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Use shiny new conf_is_ht*() helpers, we can later remove ht.enabled if
desired.

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/net/wireless/ath9k/main.c |    7 +++----
 drivers/net/wireless/ath9k/rc.c   |    4 ++--
 drivers/net/wireless/ath9k/xmit.c |    2 +-
 3 files changed, 6 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/ath9k/main.c b/drivers/net/wireless/ath9k/main.c
index 0c2f6d0..1299f52 100644
--- a/drivers/net/wireless/ath9k/main.c
+++ b/drivers/net/wireless/ath9k/main.c
@@ -2128,9 +2128,8 @@ static int ath9k_config(struct ieee80211_hw *hw, u32 changed)
 			(curchan->band == IEEE80211_BAND_2GHZ) ?
 			CHANNEL_G : CHANNEL_A;
 
-		if (conf->ht.enabled) {
-			if (conf->ht.channel_type == NL80211_CHAN_HT40PLUS ||
-			    conf->ht.channel_type == NL80211_CHAN_HT40MINUS)
+		if (conf_is_ht(conf)) {
+			if (conf_is_ht40(conf))
 				sc->tx_chan_width = ATH9K_HT_MACMODE_2040;
 
 			priv_channel->chanmode =
@@ -2144,7 +2143,7 @@ static int ath9k_config(struct ieee80211_hw *hw, u32 changed)
 			return -EINVAL;
 		}
 
-		ath_update_chainmask(sc, conf->ht.enabled);
+		ath_update_chainmask(sc, conf_is_ht(conf));
 	}
 
 	if (changed & IEEE80211_CONF_CHANGE_POWER)
diff --git a/drivers/net/wireless/ath9k/rc.c b/drivers/net/wireless/ath9k/rc.c
index 04ab457..469b374 100644
--- a/drivers/net/wireless/ath9k/rc.c
+++ b/drivers/net/wireless/ath9k/rc.c
@@ -875,7 +875,7 @@ static void ath_rc_ratefind(struct ath_softc *sc,
 	 * above conditions.
 	 */
 	if ((sc->hw->conf.channel->band == IEEE80211_BAND_2GHZ) &&
-	    (sc->hw->conf.ht.enabled)) {
+	    (conf_is_ht(&sc->hw->conf))) {
 		u8 dot11rate = rate_table->info[rix].dot11rate;
 		u8 phy = rate_table->info[rix].phy;
 		if (i == 4 &&
@@ -1511,7 +1511,7 @@ static void ath_get_rate(void *priv, struct ieee80211_sta *sta, void *priv_sta,
 			tx_info, &is_probe, false);
 
 	/* Check if aggregation has to be enabled for this tid */
-	if (hw->conf.ht.enabled) {
+	if (conf_is_ht(&hw->conf)) {
 		if (ieee80211_is_data_qos(fc)) {
 			u8 *qc, tid;
 			struct ath_node *an;
diff --git a/drivers/net/wireless/ath9k/xmit.c b/drivers/net/wireless/ath9k/xmit.c
index 16456dc..986e527 100644
--- a/drivers/net/wireless/ath9k/xmit.c
+++ b/drivers/net/wireless/ath9k/xmit.c
@@ -1699,7 +1699,7 @@ static int ath_tx_setup_buffer(struct ath_softc *sc, struct ath_buf *bf,
 	(sc->sc_flags & SC_OP_PREAMBLE_SHORT) ?
 		(bf->bf_state.bf_type |= BUF_SHORT_PREAMBLE) :
 		(bf->bf_state.bf_type &= ~BUF_SHORT_PREAMBLE);
-	(sc->hw->conf.ht.enabled && !is_pae(skb) &&
+	(conf_is_ht(&sc->hw->conf) && !is_pae(skb) &&
 	 (tx_info->flags & IEEE80211_TX_CTL_AMPDU)) ?
 		(bf->bf_state.bf_type |= BUF_HT) :
 		(bf->bf_state.bf_type &= ~BUF_HT);
-- 
1.6.1.rc3.51.g5832d


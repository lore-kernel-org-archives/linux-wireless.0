Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:30135 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750940Ab0A2WWW (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 29 Jan 2010 17:22:22 -0500
Subject: [PATCH 1/2] ath: make gcc check format arguments of ath_print(),
	fix all misuses
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
From: Pavel Roskin <proski@gnu.org>
Date: Fri, 29 Jan 2010 17:22:12 -0500
Message-ID: <20100129222212.23641.58699.stgit@mj.roinet.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Numeric channel is hard to get, so it won't be printed.  Replace Mhz
with MHz on the affected lines and add commas as needed.

Signed-off-by: Pavel Roskin <proski@gnu.org>
---
 drivers/net/wireless/ath/ath9k/main.c |    6 +++---
 drivers/net/wireless/ath/ath9k/recv.c |    2 +-
 drivers/net/wireless/ath/ath9k/xmit.c |    2 +-
 drivers/net/wireless/ath/debug.h      |    8 ++++----
 4 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index 99c4dda..56d8902 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -204,7 +204,7 @@ int ath_set_channel(struct ath_softc *sc, struct ieee80211_hw *hw,
 	r = ath9k_hw_reset(ah, hchan, fastcc);
 	if (r) {
 		ath_print(common, ATH_DBG_FATAL,
-			  "Unable to reset channel (%u Mhz) "
+			  "Unable to reset channel (%u MHz), "
 			  "reset status %d\n",
 			  channel->center_freq, r);
 		spin_unlock_bh(&sc->sc_resetlock);
@@ -867,7 +867,7 @@ void ath_radio_enable(struct ath_softc *sc, struct ieee80211_hw *hw)
 	r = ath9k_hw_reset(ah, ah->curchan, false);
 	if (r) {
 		ath_print(common, ATH_DBG_FATAL,
-			  "Unable to reset channel %u (%uMhz) ",
+			  "Unable to reset channel (%u MHz), "
 			  "reset status %d\n",
 			  channel->center_freq, r);
 	}
@@ -922,7 +922,7 @@ void ath_radio_disable(struct ath_softc *sc, struct ieee80211_hw *hw)
 	r = ath9k_hw_reset(ah, ah->curchan, false);
 	if (r) {
 		ath_print(ath9k_hw_common(sc->sc_ah), ATH_DBG_FATAL,
-			  "Unable to reset channel %u (%uMhz) "
+			  "Unable to reset channel (%u MHz), "
 			  "reset status %d\n",
 			  channel->center_freq, r);
 	}
diff --git a/drivers/net/wireless/ath/ath9k/recv.c b/drivers/net/wireless/ath/ath9k/recv.c
index 40b5d05..1ca42e5 100644
--- a/drivers/net/wireless/ath/ath9k/recv.c
+++ b/drivers/net/wireless/ath/ath9k/recv.c
@@ -429,7 +429,7 @@ static void ath_rx_ps(struct ath_softc *sc, struct sk_buff *skb)
 		sc->ps_flags &= ~PS_WAIT_FOR_PSPOLL_DATA;
 		ath_print(common, ATH_DBG_PS,
 			  "Going back to sleep after having received "
-			  "PS-Poll data (0x%x)\n",
+			  "PS-Poll data (0x%lx)\n",
 			sc->ps_flags & (PS_WAIT_FOR_BEACON |
 					PS_WAIT_FOR_CAB |
 					PS_WAIT_FOR_PSPOLL_DATA |
diff --git a/drivers/net/wireless/ath/ath9k/xmit.c b/drivers/net/wireless/ath/ath9k/xmit.c
index a6893cf..3c790a4 100644
--- a/drivers/net/wireless/ath/ath9k/xmit.c
+++ b/drivers/net/wireless/ath/ath9k/xmit.c
@@ -1857,7 +1857,7 @@ static void ath_tx_complete(struct ath_softc *sc, struct sk_buff *skb,
 		sc->ps_flags &= ~PS_WAIT_FOR_TX_ACK;
 		ath_print(common, ATH_DBG_PS,
 			  "Going back to sleep after having "
-			  "received TX status (0x%x)\n",
+			  "received TX status (0x%lx)\n",
 			sc->ps_flags & (PS_WAIT_FOR_BEACON |
 					PS_WAIT_FOR_CAB |
 					PS_WAIT_FOR_PSPOLL_DATA |
diff --git a/drivers/net/wireless/ath/debug.h b/drivers/net/wireless/ath/debug.h
index d6b685a..8263633 100644
--- a/drivers/net/wireless/ath/debug.h
+++ b/drivers/net/wireless/ath/debug.h
@@ -65,11 +65,11 @@ enum ATH_DEBUG {
 #define ATH_DBG_DEFAULT (ATH_DBG_FATAL)
 
 #ifdef CONFIG_ATH_DEBUG
-void ath_print(struct ath_common *common, int dbg_mask, const char *fmt, ...);
+void ath_print(struct ath_common *common, int dbg_mask, const char *fmt, ...)
+	__attribute__ ((format (printf, 3, 4)));
 #else
-static inline void ath_print(struct ath_common *common,
-			     int dbg_mask,
-			     const char *fmt, ...)
+static inline void __attribute__ ((format (printf, 3, 4)))
+ath_print(struct ath_common *common, int dbg_mask, const char *fmt, ...)
 {
 }
 #endif /* CONFIG_ATH_DEBUG */

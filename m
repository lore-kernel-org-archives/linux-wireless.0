Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:31187 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753571AbZG0SxN (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Jul 2009 14:53:13 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 27 Jul 2009 11:53:14 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <ath9k-devel@lists.ath9k.org>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH 3/3] ath9k: move workqueue cancels to stop callback
Date: Mon, 27 Jul 2009 11:53:04 -0700
Message-ID: <1248720784-15671-4-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1248720784-15671-1-git-send-email-lrodriguez@atheros.com>
References: <1248720784-15671-1-git-send-email-lrodriguez@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We should be cancelling our work at the stop callback since
we are borrowing the mac80211 workqueue for our work. As it
stands mac80211 expects this for suspend purposes.

The ath9k specific virtual wiphy stuff need only be
cancelled only when the we have no secondary virtual wiphys.

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/net/wireless/ath/ath9k/main.c |   13 ++++++++-----
 1 files changed, 8 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index dbd5cfd..50d99d7 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -1252,11 +1252,6 @@ void ath_detach(struct ath_softc *sc)
 
 	DPRINTF(sc, ATH_DBG_CONFIG, "Detach ATH hw\n");
 
-	cancel_delayed_work_sync(&sc->ath_led_blink_work);
-	cancel_delayed_work_sync(&sc->tx_complete_work);
-	cancel_delayed_work_sync(&sc->wiphy_work);
-	cancel_work_sync(&sc->chan_work);
-
 	ath_deinit_leds(sc);
 
 	for (i = 0; i < sc->num_sec_wiphy; i++) {
@@ -2092,6 +2087,14 @@ static void ath9k_stop(struct ieee80211_hw *hw)
 
 	aphy->state = ATH_WIPHY_INACTIVE;
 
+	cancel_delayed_work_sync(&sc->ath_led_blink_work);
+	cancel_delayed_work_sync(&sc->tx_complete_work);
+
+	if (!sc->num_sec_wiphy) {
+		cancel_delayed_work_sync(&sc->wiphy_work);
+		cancel_work_sync(&sc->chan_work);
+	}
+
 	if (sc->sc_flags & SC_OP_INVALID) {
 		DPRINTF(sc, ATH_DBG_ANY, "Device not present\n");
 		return;
-- 
1.6.0.4


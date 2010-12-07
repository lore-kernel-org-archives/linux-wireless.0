Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:17662 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752192Ab0LGCtF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Dec 2010 21:49:05 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 06 Dec 2010 18:48:51 -0800
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <linville@tuxdriver.com>
CC: <johannes@sipsolutions.net>, <linux-wireless@vger.kernel.org>,
	<amod.bodas@atheros.com>, <pstew@google.com>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>, <stable@kernel.org>
Subject: [PATCH 2/5] ath9k: Fix power save count imbalance on ath_radio_enable()
Date: Mon, 6 Dec 2010 18:48:52 -0800
Message-ID: <1291690135-4535-3-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1291690135-4535-1-git-send-email-lrodriguez@atheros.com>
References: <1291690135-4535-1-git-send-email-lrodriguez@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Upon a failure we never call ath9k_ps_restore() on ath_radio_enable(),
this will throw off the sc->ps_usecount. When the sc->ps_usecount
is > 0 we never put the chip to full sleep. This drains battery,
and will also make the chip fail upon resume with:

ath: Starting driver with initial channel: 5745 MHz
ath: timeout (100000 us) on reg 0x7000: 0xdeadbeef & 0x00000003 != 0x00000000

This would make the chip useless upon resume.

I cannot prove this can happen but in theory it is so best to
avoid this race completely and not have users complain about
a broken device after resume.

Cc: stable@kernel.org
Cc: Paul Stewart <pstew@google.com>
Cc: Amod Bodas <amod.bodas@atheros.com>
Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/net/wireless/ath/ath9k/main.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index fd27ec9..97ddb32 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -903,8 +903,7 @@ void ath_radio_enable(struct ath_softc *sc, struct ieee80211_hw *hw)
 	if (ath_startrecv(sc) != 0) {
 		ath_print(common, ATH_DBG_FATAL,
 			  "Unable to restart recv logic\n");
-		spin_unlock_bh(&sc->sc_pcu_lock);
-		return;
+		goto out;
 	}
 	if (sc->sc_flags & SC_OP_BEACONS)
 		ath_beacon_config(sc, NULL);	/* restart beacons */
@@ -918,6 +917,7 @@ void ath_radio_enable(struct ath_softc *sc, struct ieee80211_hw *hw)
 	ath9k_hw_set_gpio(ah, ah->led_pin, 0);
 
 	ieee80211_wake_queues(hw);
+out:
 	spin_unlock_bh(&sc->sc_pcu_lock);
 
 	ath9k_ps_restore(sc);
-- 
1.7.3.2.90.gd4c43


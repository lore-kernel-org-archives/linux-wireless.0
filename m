Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:26433 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754789Ab1C1U5g (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 28 Mar 2011 16:57:36 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 28 Mar 2011 13:57:12 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <greg@kroah.com>
CC: <linux-wireless@vger.kernel.org>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>, <stable@kernel.org>,
	Paul Stewart <pstew@google.com>,
	Amod Bodas <amod.bodas@atheros.com>,
	"John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 4/9] ath9k: Fix power save count imbalance on ath_radio_enable()
Date: Mon, 28 Mar 2011 13:57:10 -0700
Message-ID: <1301345835-11401-5-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1301345835-11401-1-git-send-email-lrodriguez@atheros.com>
References: <1301345835-11401-1-git-send-email-lrodriguez@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

commit c2731b814e2aaaa40072ee761b7373c052d86e37 upstream

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
Signed-off-by: John W. Linville <linville@tuxdriver.com>
---
 drivers/net/wireless/ath/ath9k/main.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index 5a5f59f..20cdf3d 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -898,8 +898,7 @@ void ath_radio_enable(struct ath_softc *sc, struct ieee80211_hw *hw)
 	if (ath_startrecv(sc) != 0) {
 		ath_print(common, ATH_DBG_FATAL,
 			  "Unable to restart recv logic\n");
-		spin_unlock_bh(&sc->sc_pcu_lock);
-		return;
+		goto out;
 	}
 	if (sc->sc_flags & SC_OP_BEACONS)
 		ath_beacon_config(sc, NULL);	/* restart beacons */
@@ -913,6 +912,7 @@ void ath_radio_enable(struct ath_softc *sc, struct ieee80211_hw *hw)
 	ath9k_hw_set_gpio(ah, ah->led_pin, 0);
 
 	ieee80211_wake_queues(hw);
+out:
 	spin_unlock_bh(&sc->sc_pcu_lock);
 
 	ath9k_ps_restore(sc);
-- 
1.7.4.15.g7811d


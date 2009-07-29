Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.deathmatch.net ([72.66.92.28]:4887 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752999AbZG2OaG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Jul 2009 10:30:06 -0400
From: Bob Copeland <me@bobcopeland.com>
To: linville@tuxdriver.com, jirislaby@gmail.com, mickflemm@gmail.com,
	lrodriguez@atheros.com
Cc: linux-wireless@vger.kernel.org, ath5k-devel@lists.ath5k.org,
	Bob Copeland <me@bobcopeland.com>
Subject: [PATCH 1/2] ath5k: update PCU opmode whenever a new interface is added
Date: Wed, 29 Jul 2009 10:29:03 -0400
Message-Id: <1248877744-7273-1-git-send-email-me@bobcopeland.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Previously, we would store the operating mode at interface up time,
but only update the PCU registers when the next reset happened.
The result is that if beacon configuration (ops->bss_info_changed)
happens before ops->config, we will program the wrong things into
the timer registers.  Consequently, beacons won't work in AP mode
until after a reset (channel change, scan etc.).

This is fragile anyway so just program the opmode as soon as
mac80211 gives it to us.

Signed-off-by: Bob Copeland <me@bobcopeland.com>
---
 drivers/net/wireless/ath/ath5k/base.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath5k/base.c b/drivers/net/wireless/ath/ath5k/base.c
index 7db32ce..55ee976 100644
--- a/drivers/net/wireless/ath/ath5k/base.c
+++ b/drivers/net/wireless/ath/ath5k/base.c
@@ -1117,6 +1117,8 @@ ath5k_mode_setup(struct ath5k_softc *sc)
 	struct ath5k_hw *ah = sc->ah;
 	u32 rfilt;
 
+	ah->ah_op_mode = sc->opmode;
+
 	/* configure rx filter */
 	rfilt = sc->filter_flags;
 	ath5k_hw_set_rx_filter(ah, rfilt);
@@ -2768,6 +2770,7 @@ static int ath5k_add_interface(struct ieee80211_hw *hw,
 	}
 
 	ath5k_hw_set_lladdr(sc->ah, conf->mac_addr);
+	ath5k_mode_setup(sc);
 
 	ret = 0;
 end:
-- 
1.6.2.5



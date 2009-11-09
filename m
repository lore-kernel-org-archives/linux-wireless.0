Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.deathmatch.net ([72.66.92.28]:3538 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752783AbZKIDAI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 8 Nov 2009 22:00:08 -0500
From: Bob Copeland <me@bobcopeland.com>
To: linville@tuxdriver.com, jirislaby@gmail.com, mickflemm@gmail.com,
	lrodriguez@atheros.com
Cc: linux-wireless@vger.kernel.org, ath5k-devel@lists.ath5k.org,
	ath9k-devel@lists.ath9k.org, Bob Copeland <me@bobcopeland.com>
Subject: [PATCH 1/3] ath5k: don't reset mcast filter when configuring the mode
Date: Sun,  8 Nov 2009 21:59:00 -0500
Message-Id: <1257735542-29658-1-git-send-email-me@bobcopeland.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We should not zero out the multicast hash when configuring
the operating mode, since a zero value means all multicast
frames will get dropped.  Also, ath5k_mode_setup() gets
called after any reset, so the hash already set up in
configure_filter() is lost.

Signed-off-by: Bob Copeland <me@bobcopeland.com>
---
 drivers/net/wireless/ath/ath5k/base.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath/ath5k/base.c b/drivers/net/wireless/ath/ath5k/base.c
index 07c1e52..cb3dc89 100644
--- a/drivers/net/wireless/ath/ath5k/base.c
+++ b/drivers/net/wireless/ath/ath5k/base.c
@@ -1146,7 +1146,6 @@ ath5k_mode_setup(struct ath5k_softc *sc)
 	/* configure operational mode */
 	ath5k_hw_set_opmode(ah);
 
-	ath5k_hw_set_mcast_filter(ah, 0, 0);
 	ATH5K_DBG(sc, ATH5K_DEBUG_MODE, "RX filter 0x%x\n", rfilt);
 }
 
-- 
1.6.2.5



Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.deathmatch.net ([70.167.247.36]:4883 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753016AbZAVNog (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Jan 2009 08:44:36 -0500
From: Bob Copeland <me@bobcopeland.com>
To: linville@tuxdriver.com
Cc: jirislaby@gmail.com, mickflemm@gmail.com, lrodriguez@atheros.com,
	linux-wireless@vger.kernel.org, ath5k-devel@lists.ath5k.org,
	Bob Copeland <me@bobcopeland.com>
Subject: [PATCH 4/6] ath5k: remove unused led_off parameter
Date: Thu, 22 Jan 2009 08:44:19 -0500
Message-Id: <1232631861-6028-5-git-send-email-me@bobcopeland.com> (sfid-20090122_144443_999103_AD3B7226)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

ath5k_softc->led_off hasn't been used since commit
3a078876caee9634dbb9b41e6269262e30e8b535, "convert LED code to use
mac80211 triggers."

Changes-licensed-under: 3-Clause-BSD

Reported-by: Tobias Doerffel <tobias.doerffel@gmail.com>
Signed-off-by: Bob Copeland <me@bobcopeland.com>
---
 drivers/net/wireless/ath5k/base.h |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath5k/base.h b/drivers/net/wireless/ath5k/base.h
index facc60d..c0fb8b5 100644
--- a/drivers/net/wireless/ath5k/base.h
+++ b/drivers/net/wireless/ath5k/base.h
@@ -148,8 +148,7 @@ struct ath5k_softc {
 	u8			bssidmask[ETH_ALEN];
 
 	unsigned int		led_pin,	/* GPIO pin for driving LED */
-				led_on,		/* pin setting for LED on */
-				led_off;	/* off time for current blink */
+				led_on;		/* pin setting for LED on */
 
 	struct tasklet_struct	restq;		/* reset tasklet */
 
-- 
1.6.0.6



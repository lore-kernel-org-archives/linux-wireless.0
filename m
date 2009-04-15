Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.deathmatch.net ([72.66.92.28]:3423 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752919AbZDOL6i (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 Apr 2009 07:58:38 -0400
From: Bob Copeland <me@bobcopeland.com>
To: linville@tuxdriver.com, jirislaby@gmail.com, mickflemm@gmail.com,
	lrodriguez@atheros.com
Cc: linux-wireless@vger.kernel.org, ath5k-devel@lists.ath5k.org,
	Bob Copeland <me@bobcopeland.com>
Subject: [PATCH 2/5] ath5k: use tasklet_hi_schedule for beacon queue
Date: Wed, 15 Apr 2009 07:57:33 -0400
Message-Id: <1239796656-20646-3-git-send-email-me@bobcopeland.com> (sfid-20090415_135846_199119_988B9E03)
In-Reply-To: <1239796656-20646-1-git-send-email-me@bobcopeland.com>
References: <1239796656-20646-1-git-send-email-me@bobcopeland.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

For embedded platforms, beacon transmission can be starved when
flooded with data packets.  Prioritize beacons by giving the beacon
queue the first shot when the isr completes.

Changes-licensed-under: 3-Clause-BSD

Signed-off-by: Bob Copeland <me@bobcopeland.com>
---
 drivers/net/wireless/ath/ath5k/base.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath/ath5k/base.c b/drivers/net/wireless/ath/ath5k/base.c
index ff6d4f8..ef8523e 100644
--- a/drivers/net/wireless/ath/ath5k/base.c
+++ b/drivers/net/wireless/ath/ath5k/base.c
@@ -2496,7 +2496,7 @@ ath5k_intr(int irq, void *dev_id)
 			tasklet_schedule(&sc->restq);
 		} else {
 			if (status & AR5K_INT_SWBA) {
-				tasklet_schedule(&sc->beacontq);
+				tasklet_hi_schedule(&sc->beacontq);
 			}
 			if (status & AR5K_INT_RXEOL) {
 				/*
-- 
1.6.0.6



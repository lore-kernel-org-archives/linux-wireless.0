Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.deathmatch.net ([70.167.247.36]:4884 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753179AbZAVNoh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Jan 2009 08:44:37 -0500
From: Bob Copeland <me@bobcopeland.com>
To: linville@tuxdriver.com
Cc: jirislaby@gmail.com, mickflemm@gmail.com, lrodriguez@atheros.com,
	linux-wireless@vger.kernel.org, ath5k-devel@lists.ath5k.org,
	Bob Copeland <me@bobcopeland.com>
Subject: [PATCH 3/6] ath5k: continue reset sequence if gain calibration fails
Date: Thu, 22 Jan 2009 08:44:18 -0500
Message-Id: <1232631861-6028-4-git-send-email-me@bobcopeland.com> (sfid-20090122_144445_016416_CD3AA972)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

If gain calibration fails, then ath5k_hw_reset will skip writing some
important registers like the interrupt mask.  In legacy_hal, only an
error is emitted in this case but the reset proceeds, so follow suit
here.

Changes to reset.c
Changes-licensed-under: ISC

Changes to base.c
Changes-licensed-under: 3-Clause-BSD

Signed-off-by: Bob Copeland <me@bobcopeland.com>
---
 drivers/net/wireless/ath5k/reset.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath5k/reset.c b/drivers/net/wireless/ath5k/reset.c
index c7cd380..3c8d3d6 100644
--- a/drivers/net/wireless/ath5k/reset.c
+++ b/drivers/net/wireless/ath5k/reset.c
@@ -829,7 +829,6 @@ int ath5k_hw_reset(struct ath5k_hw *ah, enum nl80211_iftype op_mode,
 			AR5K_PHY_AGCCTL_CAL, 0, false)) {
 		ATH5K_ERR(ah->ah_sc, "gain calibration timeout (%uMHz)\n",
 			channel->center_freq);
-		return -EAGAIN;
 	}
 
 	/*
-- 
1.6.0.6



Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from venema.h4ckr.net ([217.24.1.135]:40802 "EHLO venema.h4ckr.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753404AbYBXEYl (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 23 Feb 2008 23:24:41 -0500
Date: Sun, 24 Feb 2008 06:24:25 +0200
From: Nick Kossifidis <mick@madwifi.org>
To: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, bruno@thinktube.com, jirislaby@gmail.com,
	mcgrof@gmail.com
Subject: [PATCH 5/8] ath5k: Remove RF5413 from rf gain optimization
	functions
Message-ID: <20080224042425.GD4426@makis.domain.invalid> (sfid-20080224_042444_030904_D9F403BF)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


 * Since RF2413 it seems that RF_BUFFER settings are different (notice 
that the last part -"bank 7" or whatever- is smaller than in 5111/5112).
So until we know what's going on we assume there is no gain optimization
stuff in post-5112 chips.

Changes-licensed-under: ISC
Signed-off-by: Nick Kossifidis <mickflemm@gmail.com>

---
diff --git a/drivers/net/wireless/ath5k/phy.c b/drivers/net/wireless/ath5k/phy.c
index 75ded08..e69c60d 100644
--- a/drivers/net/wireless/ath5k/phy.c
+++ b/drivers/net/wireless/ath5k/phy.c
@@ -1092,7 +1092,6 @@ static s32 ath5k_hw_rfregs_gain_adjust(struct ath5k_hw *ah)
 		go = &rfgain_opt_5111;
 		break;
 	case AR5K_RF5112:
-	case AR5K_RF5413: /* ??? */
 		go = &rfgain_opt_5112;
 		break;
 	default:
@@ -1556,7 +1555,6 @@ int ath5k_hw_set_rfgain_opt(struct ath5k_hw *ah)
 		ah->ah_gain.g_active = 1;
 		break;
 	case AR5K_RF5112:
-	case AR5K_RF5413: /* ??? */
 		ah->ah_gain.g_step_idx = rfgain_opt_5112.go_default;
 		ah->ah_gain.g_step =
 		    &rfgain_opt_5112.go_step[ah->ah_gain.g_step_idx];



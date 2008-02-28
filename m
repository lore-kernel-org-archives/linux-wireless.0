Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ruslug.rutgers.edu ([165.230.139.146]:45260 "EHLO
	ruslug.rutgers.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755332AbYB1W7T (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Feb 2008 17:59:19 -0500
Date: Thu, 28 Feb 2008 17:59:15 -0500
From: "Luis R. Rodriguez" <mcgrof@winlab.rutgers.edu>
To: linville@tuxdriver.com
Cc: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org,
	jirislaby@gmail.com, mickflemm@gmail.com, bruno@thinktube.com,
	me@bobcopeland.com
Subject: [PATCH 5/8] ath5k: Remove RF5413 from rf gain optimization functions
Message-ID: <337c8a3f140d21bc2b56c23cd6d5888fe5d6cdeb.1204236793.git.mcgrof@winlab.rutgers.edu> (sfid-20080228_225921_845731_357E926B)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <f6d5bb6d43d1ddfb60d5ed8b8d6ee472643eafd8.1204236793.git.mcgrof@winlab.rutgers.edu>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

 * Since RF2413 it seems that RF_BUFFER settings are different (notice
that the last part -"bank 7" or whatever- is smaller than in 5111/5112).
So until we know what's going on we assume there is no gain optimization
stuff in post-5112 chips.

Changes-licensed-under: ISC
Signed-off-by: Nick Kossifidis <mickflemm@gmail.com>
Signed-off-by: Luis R. Rodriguez <mcgrof@winlab.rutgers.edu>
---
 drivers/net/wireless/ath5k/phy.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath5k/phy.c b/drivers/net/wireless/ath5k/phy.c
index 40efd4d..ee1dc0f 100644
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
@@ -1557,7 +1556,6 @@ int ath5k_hw_set_rfgain_opt(struct ath5k_hw *ah)
 		ah->ah_gain.g_active = 1;
 		break;
 	case AR5K_RF5112:
-	case AR5K_RF5413: /* ??? */
 		ah->ah_gain.g_step_idx = rfgain_opt_5112.go_default;
 		ah->ah_gain.g_step =
 		    &rfgain_opt_5112.go_step[ah->ah_gain.g_step_idx];
-- 
1.5.3.7


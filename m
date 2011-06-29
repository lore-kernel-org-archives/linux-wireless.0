Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.deathmatch.net ([72.66.92.28]:4677 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751645Ab1F2DfG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Jun 2011 23:35:06 -0400
Date: Tue, 28 Jun 2011 23:04:51 -0400
From: Bob Copeland <me@bobcopeland.com>
To: linville@tuxdriver.com
Cc: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org
Subject: [PATCH] ath5k: fix memory leak when fewer than N_PD_CURVES are in
 use
Message-ID: <20110629030451.GA2920@hash.lan> (sfid-20110629_053517_337163_745723FD)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Eugene A. Shatokhin <dame_eugene@mail.ru>

We would free the proper number of curves, but in the wrong
slots, due to a missing level of indirection through
the pdgain_idx table.

It's simpler just to try to free all four slots, so do that.

Cc: stable@kernel.org
Signed-off-by: Bob Copeland <me@bobcopeland.com>
---
 drivers/net/wireless/ath/ath5k/eeprom.c |    8 +++-----
 1 files changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/ath/ath5k/eeprom.c b/drivers/net/wireless/ath/ath5k/eeprom.c
index 1fef84f..392771f 100644
--- a/drivers/net/wireless/ath/ath5k/eeprom.c
+++ b/drivers/net/wireless/ath/ath5k/eeprom.c
@@ -691,14 +691,12 @@ ath5k_eeprom_free_pcal_info(struct ath5k_hw *ah, int mode)
 		if (!chinfo[pier].pd_curves)
 			continue;
 
-		for (pdg = 0; pdg < ee->ee_pd_gains[mode]; pdg++) {
+		for (pdg = 0; pdg < AR5K_EEPROM_N_PD_CURVES; pdg++) {
 			struct ath5k_pdgain_info *pd =
 					&chinfo[pier].pd_curves[pdg];
 
-			if (pd != NULL) {
-				kfree(pd->pd_step);
-				kfree(pd->pd_pwr);
-			}
+			kfree(pd->pd_step);
+			kfree(pd->pd_pwr);
 		}
 
 		kfree(chinfo[pier].pd_curves);
-- 
1.7.2.5

-- 
Bob Copeland %% www.bobcopeland.com


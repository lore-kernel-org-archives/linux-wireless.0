Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from venema.h4ckr.net ([217.24.1.135]:45050 "EHLO venema.h4ckr.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753555AbXLPBDG (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 15 Dec 2007 20:03:06 -0500
Date: Sun, 16 Dec 2007 03:03:01 +0200
From: Nick Kossifidis <mick@madwifi.org>
To: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, bruno@thinktube.com, jirislaby@gmail.com,
	mcgrof@gmail.com
Subject: [PATCH 6/9] ath5k: Skip non-data queues for 5210 for now
Message-ID: <20071216010301.GF5482@makis.domain.invalid> (sfid-20071216_010309_805478_F361EA35)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

* Skip non-data tx queues on 5210, don't return -EINVAL since it breaks ifup. This is a temp mesure until we review tx queues etc in base.c. Note that 5210 will wake up and may even scan but needs some more work.

Changes-licensed-under: ISC
Signed-off-by: Nick Kossifidis <mickflemm@gmail.com>

---
diff --git a/drivers/net/wireless/ath5k/hw.c b/drivers/net/wireless/ath5k/hw.c
index ed311ae..ea5960e 100644
--- a/drivers/net/wireless/ath5k/hw.c
+++ b/drivers/net/wireless/ath5k/hw.c
@@ -3184,7 +3184,7 @@ int ath5k_hw_reset_tx_queue(struct ath5k_hw *ah, unsigned int queue)
 	if (ah->ah_version == AR5K_AR5210) {
 		/* Only handle data queues, others will be ignored */
 		if (tq->tqi_type != AR5K_TX_QUEUE_DATA)
-			return -EINVAL;
+			return 0;
 
 		/* Set Slot time */
 		ath5k_hw_reg_write(ah, ah->ah_turbo == true ?




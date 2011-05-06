Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:48309 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753066Ab1EFWYj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 May 2011 18:24:39 -0400
From: greearb@candelatech.com
To: linux-wireless@vger.kernel.org
Cc: Ben Greear <greearb@candelatech.com>
Subject: [PATCH] ath5k:  Fix lockup due to un-init spinlock.
Date: Fri,  6 May 2011 15:24:34 -0700
Message-Id: <1304720674-27031-1-git-send-email-greearb@candelatech.com> (sfid-20110507_002502_080836_A8A0509D)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ben Greear <greearb@candelatech.com>

This was introduced in 2.6.39-rc1 it seems.

Signed-off-by: Ben Greear <greearb@candelatech.com>
---
:100644 100644 203243b... 2204762... M	drivers/net/wireless/ath/ath5k/base.c
 drivers/net/wireless/ath/ath5k/base.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath/ath5k/base.c b/drivers/net/wireless/ath/ath5k/base.c
index 203243b..2204762 100644
--- a/drivers/net/wireless/ath/ath5k/base.c
+++ b/drivers/net/wireless/ath/ath5k/base.c
@@ -2394,7 +2394,7 @@ ath5k_init_softc(struct ath5k_softc *sc, const struct ath_bus_ops *bus_ops)
 	spin_lock_init(&sc->rxbuflock);
 	spin_lock_init(&sc->txbuflock);
 	spin_lock_init(&sc->block);
-
+	spin_lock_init(&sc->irqlock);
 
 	/* Setup interrupt handler */
 	ret = request_irq(sc->irq, ath5k_intr, IRQF_SHARED, "ath", sc);
-- 
1.7.3.4


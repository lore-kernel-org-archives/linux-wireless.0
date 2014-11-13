Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static.88-198-24-112.clients.your-server.de ([88.198.24.112]:52400
	"EHLO nbd.name" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S933529AbaKMReL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Nov 2014 12:34:11 -0500
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com
Subject: [PATCH 3.18 1/3] ath9k: prevent early IRQs from accessing hardware
Date: Thu, 13 Nov 2014 18:34:03 +0100
Message-Id: <1415900045-49093-1-git-send-email-nbd@openwrt.org> (sfid-20141113_183416_271934_3DE220DC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

IRQs are suppressed if ah == NULL and ATH_OP_INVALID being set in
common->op_flags. Close a short time window between those two.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/init.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/init.c b/drivers/net/wireless/ath/ath9k/init.c
index c5bcddd..3c6ded9 100644
--- a/drivers/net/wireless/ath/ath9k/init.c
+++ b/drivers/net/wireless/ath/ath9k/init.c
@@ -529,10 +529,14 @@ static int ath9k_init_softc(u16 devid, struct ath_softc *sc,
 	ah->reg_ops.read = ath9k_ioread32;
 	ah->reg_ops.write = ath9k_iowrite32;
 	ah->reg_ops.rmw = ath9k_reg_rmw;
-	sc->sc_ah = ah;
 	pCap = &ah->caps;
 
 	common = ath9k_hw_common(ah);
+
+	/* Will be cleared in ath9k_start() */
+	set_bit(ATH_OP_INVALID, &common->op_flags);
+
+	sc->sc_ah = ah;
 	sc->dfs_detector = dfs_pattern_detector_init(common, NL80211_DFS_UNSET);
 	sc->tx99_power = MAX_RATE_POWER + 1;
 	init_waitqueue_head(&sc->tx_wait);
@@ -893,9 +897,6 @@ int ath9k_init_device(u16 devid, struct ath_softc *sc,
 	common = ath9k_hw_common(ah);
 	ath9k_set_hw_capab(sc, hw);
 
-	/* Will be cleared in ath9k_start() */
-	set_bit(ATH_OP_INVALID, &common->op_flags);
-
 	/* Initialize regulatory */
 	error = ath_regd_init(&common->regulatory, sc->hw->wiphy,
 			      ath9k_reg_notifier);
-- 
2.1.2


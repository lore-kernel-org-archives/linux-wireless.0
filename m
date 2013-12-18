Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.21]:46215 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752339Ab3LRE20 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Dec 2013 23:28:26 -0500
From: Sujith Manoharan <sujith@msujith.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH v2 03/10] ath9k: Remove unneeded ref. count initialization
Date: Wed, 18 Dec 2013 09:53:20 +0530
Message-Id: <1387340607-20045-4-git-send-email-sujith@msujith.org> (sfid-20131218_052925_243147_19AE8762)
In-Reply-To: <1387340607-20045-1-git-send-email-sujith@msujith.org>
References: <1387340607-20045-1-git-send-email-sujith@msujith.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

The interrupt reference counter is always initialized
in ath9k_start().

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/init.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath9k/init.c b/drivers/net/wireless/ath/ath9k/init.c
index 9d2c3eb..ea67c01 100644
--- a/drivers/net/wireless/ath/ath9k/init.c
+++ b/drivers/net/wireless/ath/ath9k/init.c
@@ -705,7 +705,6 @@ static int ath9k_init_softc(u16 devid, struct ath_softc *sc,
 	ah->reg_ops.read = ath9k_ioread32;
 	ah->reg_ops.write = ath9k_iowrite32;
 	ah->reg_ops.rmw = ath9k_reg_rmw;
-	atomic_set(&ah->intr_ref_cnt, -1);
 	sc->sc_ah = ah;
 	pCap = &ah->caps;
 
-- 
1.8.5.1


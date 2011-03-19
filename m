Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:52440 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751284Ab1CSMzt (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 19 Mar 2011 08:55:49 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, lrodriguez@atheros.com
Subject: [PATCH 1/7] ath9k: remove unnecessary debugfs return code checks
Date: Sat, 19 Mar 2011 13:55:37 +0100
Message-Id: <1300539343-75509-1-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Since the ath9k debugfs directory is cleaned up by debugfs_remove_recursive,
there's no point in checking the return code of every single debugfs create
line.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/debug.c |   88 ++++++++++---------------------
 1 files changed, 29 insertions(+), 59 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/debug.c b/drivers/net/wireless/ath/ath9k/debug.c
index 8df5a92..9fe8693 100644
--- a/drivers/net/wireless/ath/ath9k/debug.c
+++ b/drivers/net/wireless/ath/ath9k/debug.c
@@ -1088,67 +1088,37 @@ int ath9k_init_debug(struct ath_hw *ah)
 		return -ENOMEM;
 
 #ifdef CONFIG_ATH_DEBUG
-	if (!debugfs_create_file("debug", S_IRUSR | S_IWUSR,
-			sc->debug.debugfs_phy, sc, &fops_debug))
-		goto err;
+	debugfs_create_file("debug", S_IRUSR | S_IWUSR, sc->debug.debugfs_phy,
+			    sc, &fops_debug);
 #endif
-
-	if (!debugfs_create_file("dma", S_IRUSR, sc->debug.debugfs_phy,
-			sc, &fops_dma))
-		goto err;
-
-	if (!debugfs_create_file("interrupt", S_IRUSR, sc->debug.debugfs_phy,
-			sc, &fops_interrupt))
-		goto err;
-
-	if (!debugfs_create_file("wiphy", S_IRUSR | S_IWUSR,
-			sc->debug.debugfs_phy, sc, &fops_wiphy))
-		goto err;
-
-	if (!debugfs_create_file("xmit", S_IRUSR, sc->debug.debugfs_phy,
-			sc, &fops_xmit))
-		goto err;
-
-	if (!debugfs_create_file("stations", S_IRUSR, sc->debug.debugfs_phy,
-			sc, &fops_stations))
-		goto err;
-
-	if (!debugfs_create_file("misc", S_IRUSR, sc->debug.debugfs_phy,
-			sc, &fops_misc))
-		goto err;
-
-	if (!debugfs_create_file("recv", S_IRUSR, sc->debug.debugfs_phy,
-			sc, &fops_recv))
-		goto err;
-
-	if (!debugfs_create_file("rx_chainmask", S_IRUSR | S_IWUSR,
-			sc->debug.debugfs_phy, sc, &fops_rx_chainmask))
-		goto err;
-
-	if (!debugfs_create_file("tx_chainmask", S_IRUSR | S_IWUSR,
-			sc->debug.debugfs_phy, sc, &fops_tx_chainmask))
-		goto err;
-
-	if (!debugfs_create_file("regidx", S_IRUSR | S_IWUSR,
-			sc->debug.debugfs_phy, sc, &fops_regidx))
-		goto err;
-
-	if (!debugfs_create_file("regval", S_IRUSR | S_IWUSR,
-			sc->debug.debugfs_phy, sc, &fops_regval))
-		goto err;
-
-	if (!debugfs_create_bool("ignore_extcca", S_IRUSR | S_IWUSR,
-			sc->debug.debugfs_phy, &ah->config.cwm_ignore_extcca))
-		goto err;
-
-	if (!debugfs_create_file("regdump", S_IRUSR, sc->debug.debugfs_phy,
-			sc, &fops_regdump))
-		goto err;
+	debugfs_create_file("dma", S_IRUSR, sc->debug.debugfs_phy, sc,
+			    &fops_dma);
+	debugfs_create_file("interrupt", S_IRUSR, sc->debug.debugfs_phy, sc,
+			    &fops_interrupt);
+	debugfs_create_file("wiphy", S_IRUSR | S_IWUSR, sc->debug.debugfs_phy,
+			    sc, &fops_wiphy);
+	debugfs_create_file("xmit", S_IRUSR, sc->debug.debugfs_phy, sc,
+			    &fops_xmit);
+	debugfs_create_file("stations", S_IRUSR, sc->debug.debugfs_phy, sc,
+			    &fops_stations);
+	debugfs_create_file("misc", S_IRUSR, sc->debug.debugfs_phy, sc,
+			    &fops_misc);
+	debugfs_create_file("recv", S_IRUSR, sc->debug.debugfs_phy, sc,
+			    &fops_recv);
+	debugfs_create_file("rx_chainmask", S_IRUSR | S_IWUSR,
+			    sc->debug.debugfs_phy, sc, &fops_rx_chainmask);
+	debugfs_create_file("tx_chainmask", S_IRUSR | S_IWUSR,
+			    sc->debug.debugfs_phy, sc, &fops_tx_chainmask);
+	debugfs_create_file("regidx", S_IRUSR | S_IWUSR, sc->debug.debugfs_phy,
+			    sc, &fops_regidx);
+	debugfs_create_file("regval", S_IRUSR | S_IWUSR, sc->debug.debugfs_phy,
+			    sc, &fops_regval);
+	debugfs_create_bool("ignore_extcca", S_IRUSR | S_IWUSR,
+			    sc->debug.debugfs_phy,
+			    &ah->config.cwm_ignore_extcca);
+	debugfs_create_file("regdump", S_IRUSR, sc->debug.debugfs_phy, sc,
+			    &fops_regdump);
 
 	sc->debug.regidx = 0;
 	return 0;
-err:
-	debugfs_remove_recursive(sc->debug.debugfs_phy);
-	sc->debug.debugfs_phy = NULL;
-	return -ENOMEM;
 }
-- 
1.7.3.2


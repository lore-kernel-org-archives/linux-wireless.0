Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 162-17-110-37-static.hfc.comcastbusiness.net ([162.17.110.37]:49264
	"EHLO stuffed.shaftnet.org" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1754851Ab3E3Cjz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 May 2013 22:39:55 -0400
From: Solomon Peachy <pizza@shaftnet.org>
To: linux-wireless@vger.kernel.org
Cc: Solomon Peachy <pizza@shaftnet.org>
Subject: [PATCH] wireless-next: cw1200: Fix compile with CONFIG_PM=n
Date: Wed, 29 May 2013 22:22:05 -0400
Message-Id: <1369880525-2984-1-git-send-email-pizza@shaftnet.org> (sfid-20130530_043958_944423_DF328F3B)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Intel's 0-day kernel build tester caught this build failure.  This patch 
properly wraps everything that depends on CONFIG_PM.

Signed-off-by: Solomon Peachy <pizza@shaftnet.org>
---
 drivers/net/wireless/cw1200/Makefile      |  2 +-
 drivers/net/wireless/cw1200/cw1200_sdio.c |  4 ++++
 drivers/net/wireless/cw1200/cw1200_spi.c  |  4 ++++
 drivers/net/wireless/cw1200/main.c        | 10 ++++++++++
 drivers/net/wireless/cw1200/pm.h          | 11 ++++++++---
 5 files changed, 27 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/cw1200/Makefile b/drivers/net/wireless/cw1200/Makefile
index c197372..1aa3682 100644
--- a/drivers/net/wireless/cw1200/Makefile
+++ b/drivers/net/wireless/cw1200/Makefile
@@ -8,9 +8,9 @@ cw1200_core-y := \
 		wsm.o \
 		sta.o \
 		scan.o \
-		pm.o \
 		debug.o
 cw1200_core-$(CONFIG_CW1200_ITP)	+= itp.o
+cw1200_core-$(CONFIG_PM)	+= pm.o
 
 # CFLAGS_sta.o += -DDEBUG
 
diff --git a/drivers/net/wireless/cw1200/cw1200_sdio.c b/drivers/net/wireless/cw1200/cw1200_sdio.c
index f6e2219..2059a31 100644
--- a/drivers/net/wireless/cw1200/cw1200_sdio.c
+++ b/drivers/net/wireless/cw1200/cw1200_sdio.c
@@ -334,6 +334,7 @@ static void cw1200_sdio_disconnect(struct sdio_func *func)
 	}
 }
 
+#ifdef CONFIG_PM
 static int cw1200_sdio_suspend(struct device *dev)
 {
 	int ret;
@@ -360,15 +361,18 @@ static const struct dev_pm_ops cw1200_pm_ops = {
 	.suspend = cw1200_sdio_suspend,
 	.resume = cw1200_sdio_resume,
 };
+#endif
 
 static struct sdio_driver sdio_driver = {
 	.name		= "cw1200_wlan_sdio",
 	.id_table	= cw1200_sdio_ids,
 	.probe		= cw1200_sdio_probe,
 	.remove		= cw1200_sdio_disconnect,
+#ifdef CONFIG_PM
 	.drv = {
 		.pm = &cw1200_pm_ops,
 	}
+#endif
 };
 
 /* Init Module function -> Called by insmod */
diff --git a/drivers/net/wireless/cw1200/cw1200_spi.c b/drivers/net/wireless/cw1200/cw1200_spi.c
index 04af685..b957d4a 100644
--- a/drivers/net/wireless/cw1200/cw1200_spi.c
+++ b/drivers/net/wireless/cw1200/cw1200_spi.c
@@ -436,6 +436,7 @@ static int cw1200_spi_disconnect(struct spi_device *func)
 	return 0;
 }
 
+#ifdef CONFIG_PM
 static int cw1200_spi_suspend(struct device *dev, pm_message_t state)
 {
 	struct sbus_priv *self = spi_get_drvdata(to_spi_device(dev));
@@ -451,6 +452,7 @@ static int cw1200_spi_resume(struct device *dev)
 {
 	return 0;
 }
+#endif
 
 static struct spi_driver spi_driver = {
 	.probe		= cw1200_spi_probe,
@@ -459,8 +461,10 @@ static struct spi_driver spi_driver = {
 		.name		= "cw1200_wlan_spi",
 		.bus            = &spi_bus_type,
 		.owner          = THIS_MODULE,
+#ifdef CONFIG_PM
 		.suspend        = cw1200_spi_suspend,
 		.resume         = cw1200_spi_resume,
+#endif
 	},
 };
 
diff --git a/drivers/net/wireless/cw1200/main.c b/drivers/net/wireless/cw1200/main.c
index 8426d3d..ef4b0b9 100644
--- a/drivers/net/wireless/cw1200/main.c
+++ b/drivers/net/wireless/cw1200/main.c
@@ -234,8 +234,10 @@ static const struct ieee80211_ops cw1200_ops = {
 	.get_stats		= cw1200_get_stats,
 	.ampdu_action		= cw1200_ampdu_action,
 	.flush			= cw1200_flush,
+#ifdef CONFIG_PM
 	.suspend		= cw1200_wow_suspend,
 	.resume			= cw1200_wow_resume,
+#endif
 	/* Intentionally not offloaded:					*/
 	/*.channel_switch	= cw1200_channel_switch,		*/
 	/*.remain_on_channel	= cw1200_remain_on_channel,		*/
@@ -292,10 +294,12 @@ static struct ieee80211_hw *cw1200_init_common(const u8 *macaddr,
 					  BIT(NL80211_IFTYPE_P2P_CLIENT) |
 					  BIT(NL80211_IFTYPE_P2P_GO);
 
+#ifdef CONFIG_PM
 	/* Support only for limited wowlan functionalities */
 	hw->wiphy->wowlan.flags = WIPHY_WOWLAN_ANY |
 		WIPHY_WOWLAN_DISCONNECT;
 	hw->wiphy->wowlan.n_patterns = 0;
+#endif
 
 	hw->wiphy->flags |= WIPHY_FLAG_AP_UAPSD;
 
@@ -419,18 +423,22 @@ static int cw1200_register_common(struct ieee80211_hw *dev)
 		goto done;
 #endif
 
+#ifdef CONFIG_PM
 	err = cw1200_pm_init(&priv->pm_state, priv);
 	if (err) {
 		pr_err("Cannot init PM. (%d).\n",
 		       err);
 		return err;
 	}
+#endif
 
 	err = ieee80211_register_hw(dev);
 	if (err) {
 		pr_err("Cannot register device (%d).\n",
 		       err);
+#ifdef CONFIG_PM
 		cw1200_pm_deinit(&priv->pm_state);
+#endif
 		return err;
 	}
 
@@ -482,7 +490,9 @@ static void cw1200_unregister_common(struct ieee80211_hw *dev)
 		cw1200_queue_deinit(&priv->tx_queue[i]);
 
 	cw1200_queue_stats_deinit(&priv->tx_queue_stats);
+#ifdef CONFIG_PM
 	cw1200_pm_deinit(&priv->pm_state);
+#endif
 }
 
 /* Clock is in KHz */
diff --git a/drivers/net/wireless/cw1200/pm.h b/drivers/net/wireless/cw1200/pm.h
index 516d967..3ed90ff 100644
--- a/drivers/net/wireless/cw1200/pm.h
+++ b/drivers/net/wireless/cw1200/pm.h
@@ -25,14 +25,19 @@ struct cw1200_pm_state {
 	spinlock_t lock; /* Protect access */
 };
 
+#ifdef CONFIG_PM
 int cw1200_pm_init(struct cw1200_pm_state *pm,
 		    struct cw1200_common *priv);
 void cw1200_pm_deinit(struct cw1200_pm_state *pm);
-void cw1200_pm_stay_awake(struct cw1200_pm_state *pm,
-			  unsigned long tmo);
 int cw1200_wow_suspend(struct ieee80211_hw *hw,
 		       struct cfg80211_wowlan *wowlan);
 int cw1200_wow_resume(struct ieee80211_hw *hw);
 int cw1200_can_suspend(struct cw1200_common *priv);
-
+void cw1200_pm_stay_awake(struct cw1200_pm_state *pm,
+			  unsigned long tmo);
+#else
+static inline void cw1200_pm_stay_awake(struct cw1200_pm_state *pm,
+					unsigned long tmo) {
+}
+#endif
 #endif
-- 
1.8.1.4


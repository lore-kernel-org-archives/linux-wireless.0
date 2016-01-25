Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.243]:40778 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753321AbcAYHmd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Jan 2016 02:42:33 -0500
From: Glen Lee <glen.lee@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <adham.abozaeid@atmel.com>,
	<Nicolas.FERRE@atmel.com>
Subject: [PATCH V2 04/26] staging: wilc1000: add sdio resume/suspend
Date: Mon, 25 Jan 2016 16:35:08 +0900
Message-ID: <1453707330-13526-5-git-send-email-glen.lee@atmel.com> (sfid-20160125_084235_806271_842BA152)
In-Reply-To: <1453707330-13526-1-git-send-email-glen.lee@atmel.com>
References: <1453707330-13526-1-git-send-email-glen.lee@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch introduces sdio device suspend and resume functionality. sdio_reset
function is added to reset sdio. Remove static inline keyword from
chip_allow_sleep and chip_wakeup, and export symbols.

Signed-off-by: Glen Lee <glen.lee@atmel.com>
---
Changes in V2:
 - fix checkpatch ERROR: space required before the open parenthesis
---
 drivers/staging/wilc1000/wilc_sdio.c          | 72 +++++++++++++++++++++++++++
 drivers/staging/wilc1000/wilc_wfi_netdevice.h |  1 +
 drivers/staging/wilc1000/wilc_wlan.c          | 11 ++--
 drivers/staging/wilc1000/wilc_wlan.h          |  3 +-
 4 files changed, 82 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_sdio.c b/drivers/staging/wilc1000/wilc_sdio.c
index caad876..f40a527 100644
--- a/drivers/staging/wilc1000/wilc_sdio.c
+++ b/drivers/staging/wilc1000/wilc_sdio.c
@@ -42,6 +42,7 @@ static wilc_sdio_t g_sdio;
 
 static int sdio_write_reg(struct wilc *wilc, u32 addr, u32 data);
 static int sdio_read_reg(struct wilc *wilc, u32 addr, u32 *data);
+static int sdio_init(struct wilc *wilc);
 
 static void wilc_sdio_interrupt(struct sdio_func *func)
 {
@@ -142,11 +143,82 @@ static void linux_sdio_remove(struct sdio_func *func)
 	wilc_netdev_cleanup(sdio_get_drvdata(func));
 }
 
+static int sdio_reset(struct wilc *wilc)
+{
+	sdio_cmd52_t cmd;
+	int ret;
+	struct sdio_func *func = dev_to_sdio_func(wilc->dev);
+
+	cmd.read_write = 1;
+	cmd.function = 0;
+	cmd.raw = 0;
+	cmd.address = 0x6;
+	cmd.data = 0x8;
+	ret = wilc_sdio_cmd52(wilc, &cmd);
+	if (ret) {
+		dev_err(&func->dev, "Fail cmd 52, reset cmd ...\n");
+		return ret;
+	}
+	return 0;
+}
+
+static int wilc_sdio_suspend(struct device *dev)
+{
+	struct sdio_func *func = dev_to_sdio_func(dev);
+	struct wilc *wilc = sdio_get_drvdata(func);
+	int ret;
+
+	dev_info(dev, "sdio suspend\n");
+	chip_wakeup(wilc);
+
+	if (!wilc->suspend_event) {
+		wilc_chip_sleep_manually(wilc);
+	} else {
+		host_sleep_notify(wilc);
+		chip_allow_sleep(wilc);
+	}
+
+	ret = sdio_reset(wilc);
+	if (ret) {
+		dev_err(&func->dev, "Fail reset sdio\n");
+		return ret;
+	}
+	sdio_claim_host(func);
+
+	return 0;
+}
+
+static int wilc_sdio_resume(struct device *dev)
+{
+	struct sdio_func *func = dev_to_sdio_func(dev);
+	struct wilc *wilc = sdio_get_drvdata(func);
+
+	dev_info(dev, "sdio resume\n");
+	sdio_release_host(func);
+	chip_wakeup(wilc);
+	sdio_init(wilc);
+
+	if (wilc->suspend_event)
+		host_wakeup_notify(wilc);
+
+	chip_allow_sleep(wilc);
+
+	return 0;
+}
+
+static const struct dev_pm_ops wilc_sdio_pm_ops = {
+	.suspend = wilc_sdio_suspend,
+	.resume = wilc_sdio_resume,
+};
+
 static struct sdio_driver wilc1000_sdio_driver = {
 	.name		= SDIO_MODALIAS,
 	.id_table	= wilc_sdio_ids,
 	.probe		= linux_sdio_probe,
 	.remove		= linux_sdio_remove,
+	.drv = {
+		.pm = &wilc_sdio_pm_ops,
+	}
 };
 module_driver(wilc1000_sdio_driver,
 	      sdio_register_driver,
diff --git a/drivers/staging/wilc1000/wilc_wfi_netdevice.h b/drivers/staging/wilc1000/wilc_wfi_netdevice.h
index 98ac8ed..cd3d21d 100644
--- a/drivers/staging/wilc1000/wilc_wfi_netdevice.h
+++ b/drivers/staging/wilc1000/wilc_wfi_netdevice.h
@@ -215,6 +215,7 @@ struct wilc {
 	const struct firmware *firmware;
 
 	struct device *dev;
+	bool suspend_event;
 };
 
 struct WILC_WFI_mon_priv {
diff --git a/drivers/staging/wilc1000/wilc_wlan.c b/drivers/staging/wilc1000/wilc_wlan.c
index 977bd8a0..8a39a05 100644
--- a/drivers/staging/wilc1000/wilc_wlan.c
+++ b/drivers/staging/wilc1000/wilc_wlan.c
@@ -3,8 +3,6 @@
 #include "wilc_wfi_netdevice.h"
 #include "wilc_wlan_cfg.h"
 
-static inline void chip_allow_sleep(struct wilc *wilc);
-static inline void chip_wakeup(struct wilc *wilc);
 static u32 dbgflag = N_INIT | N_ERR | N_INTR | N_TXQ | N_RXQ;
 
 /* FIXME: replace with dev_debug() */
@@ -515,7 +513,7 @@ static struct rxq_entry_t *wilc_wlan_rxq_remove(struct wilc *wilc)
 	return NULL;
 }
 
-static inline void chip_allow_sleep(struct wilc *wilc)
+void chip_allow_sleep(struct wilc *wilc)
 {
 	u32 reg = 0;
 
@@ -524,8 +522,9 @@ static inline void chip_allow_sleep(struct wilc *wilc)
 	wilc->hif_func->hif_write_reg(wilc, 0xf0, reg & ~BIT(0));
 	wilc->hif_func->hif_write_reg(wilc, 0xfa, 0);
 }
+EXPORT_SYMBOL_GPL(chip_allow_sleep);
 
-static inline void chip_wakeup(struct wilc *wilc)
+void chip_wakeup(struct wilc *wilc)
 {
 	u32 reg, clk_status_reg, trials = 0;
 
@@ -584,6 +583,7 @@ static inline void chip_wakeup(struct wilc *wilc)
 	}
 	chip_ps_state = CHIP_WAKEDUP;
 }
+EXPORT_SYMBOL_GPL(chip_wakeup);
 
 void wilc_chip_sleep_manually(struct wilc *wilc)
 {
@@ -597,6 +597,7 @@ void wilc_chip_sleep_manually(struct wilc *wilc)
 	chip_ps_state = CHIP_SLEEPING_MANUAL;
 	release_bus(wilc, RELEASE_ONLY);
 }
+EXPORT_SYMBOL_GPL(wilc_chip_sleep_manually);
 
 void host_wakeup_notify(struct wilc *wilc)
 {
@@ -604,6 +605,7 @@ void host_wakeup_notify(struct wilc *wilc)
 	wilc->hif_func->hif_write_reg(wilc, 0x10b0, 1);
 	release_bus(wilc, RELEASE_ONLY);
 }
+EXPORT_SYMBOL_GPL(host_wakeup_notify);
 
 void host_sleep_notify(struct wilc *wilc)
 {
@@ -611,6 +613,7 @@ void host_sleep_notify(struct wilc *wilc)
 	wilc->hif_func->hif_write_reg(wilc, 0x10ac, 1);
 	release_bus(wilc, RELEASE_ONLY);
 }
+EXPORT_SYMBOL_GPL(host_sleep_notify);
 
 int wilc_wlan_handle_txq(struct net_device *dev, u32 *txq_count)
 {
diff --git a/drivers/staging/wilc1000/wilc_wlan.h b/drivers/staging/wilc1000/wilc_wlan.h
index dd5abc5..53e56ff 100644
--- a/drivers/staging/wilc1000/wilc_wlan.h
+++ b/drivers/staging/wilc1000/wilc_wlan.h
@@ -298,5 +298,6 @@ void WILC_WFI_p2p_rx(struct net_device *dev, u8 *buff, u32 size);
 void host_wakeup_notify(struct wilc *wilc);
 void host_sleep_notify(struct wilc *wilc);
 extern bool wilc_enable_ps;
-
+void chip_allow_sleep(struct wilc *wilc);
+void chip_wakeup(struct wilc *wilc);
 #endif
-- 
1.9.1


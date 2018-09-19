Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa1.microchip.iphmx.com ([68.232.147.91]:2371 "EHLO
        esa1.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730841AbeISLnE (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 19 Sep 2018 07:43:04 -0400
From: Ajay Singh <ajay.kathat@microchip.com>
To: <linux-wireless@vger.kernel.org>
CC: <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <ganesh.krishna@microchip.com>, <aditya.shankar@microchip.com>,
        <venkateswara.kaja@microchip.com>, <claudiu.beznea@microchip.com>,
        <adham.abozaeid@microchip.com>,
        Ajay Singh <ajay.kathat@microchip.com>
Subject: [PATCH 21/29] staging: wilc1000: avoid use of 'g_sdio' static variable
Date: Wed, 19 Sep 2018 11:35:11 +0530
Message-ID: <1537337119-14952-22-git-send-email-ajay.kathat@microchip.com> (sfid-20180919_080646_973649_201AAF22)
In-Reply-To: <1537337119-14952-1-git-send-email-ajay.kathat@microchip.com>
References: <1537337119-14952-1-git-send-email-ajay.kathat@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Instead of using static variable 'g_sdio' move it as part of 'wilc'
struct. Also allocating the memory in the probe function and free during
deinitialization.

Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
---
 drivers/staging/wilc1000/linux_wlan.c         |  1 +
 drivers/staging/wilc1000/wilc_sdio.c          | 54 +++++++++++++++++----------
 drivers/staging/wilc1000/wilc_wfi_netdevice.h |  1 +
 3 files changed, 36 insertions(+), 20 deletions(-)

diff --git a/drivers/staging/wilc1000/linux_wlan.c b/drivers/staging/wilc1000/linux_wlan.c
index b666e1e..560c168 100644
--- a/drivers/staging/wilc1000/linux_wlan.c
+++ b/drivers/staging/wilc1000/linux_wlan.c
@@ -1037,6 +1037,7 @@ void wilc_netdev_cleanup(struct wilc *wilc)
 	flush_workqueue(wilc->hif_workqueue);
 	destroy_workqueue(wilc->hif_workqueue);
 	wilc_wlan_cfg_deinit(wilc);
+	kfree(wilc->bus_data);
 	kfree(wilc);
 }
 EXPORT_SYMBOL_GPL(wilc_netdev_cleanup);
diff --git a/drivers/staging/wilc1000/wilc_sdio.c b/drivers/staging/wilc1000/wilc_sdio.c
index b2080d8..7ef047c 100644
--- a/drivers/staging/wilc1000/wilc_sdio.c
+++ b/drivers/staging/wilc1000/wilc_sdio.c
@@ -30,7 +30,6 @@ struct wilc_sdio {
 	int has_thrpt_enh3;
 };
 
-static struct wilc_sdio g_sdio;
 static const struct wilc_hif_func wilc_hif_sdio;
 
 static int sdio_write_reg(struct wilc *wilc, u32 addr, u32 data);
@@ -109,6 +108,11 @@ static int linux_sdio_probe(struct sdio_func *func,
 	struct wilc *wilc;
 	int ret;
 	struct gpio_desc *gpio = NULL;
+	struct wilc_sdio *sdio_priv;
+
+	sdio_priv = kzalloc(sizeof(*sdio_priv), GFP_KERNEL);
+	if (!sdio_priv)
+		return -ENOMEM;
 
 	if (IS_ENABLED(CONFIG_WILC1000_HW_OOB_INTR)) {
 		gpio = gpiod_get(&func->dev, "irq", GPIOD_IN);
@@ -124,9 +128,11 @@ static int linux_sdio_probe(struct sdio_func *func,
 	ret = wilc_netdev_init(&wilc, &func->dev, HIF_SDIO, &wilc_hif_sdio);
 	if (ret) {
 		dev_err(&func->dev, "Couldn't initialize netdev\n");
+		kfree(sdio_priv);
 		return ret;
 	}
 	sdio_set_drvdata(func, wilc);
+	wilc->bus_data = sdio_priv;
 	wilc->dev = &func->dev;
 	wilc->gpio_irq = gpio;
 
@@ -381,6 +387,7 @@ static int sdio_set_func1_block_size(struct wilc *wilc, u32 block_size)
 static int sdio_write_reg(struct wilc *wilc, u32 addr, u32 data)
 {
 	struct sdio_func *func = dev_to_sdio_func(wilc->dev);
+	struct wilc_sdio *sdio_priv = wilc->bus_data;
 	int ret;
 
 	cpu_to_le32s(&data);
@@ -415,7 +422,7 @@ static int sdio_write_reg(struct wilc *wilc, u32 addr, u32 data)
 		cmd.increment = 1;
 		cmd.count = 4;
 		cmd.buffer = (u8 *)&data;
-		cmd.block_size = g_sdio.block_size;
+		cmd.block_size = sdio_priv->block_size;
 		ret = wilc_sdio_cmd53(wilc, &cmd);
 		if (ret) {
 			dev_err(&func->dev,
@@ -434,7 +441,8 @@ static int sdio_write_reg(struct wilc *wilc, u32 addr, u32 data)
 static int sdio_write(struct wilc *wilc, u32 addr, u8 *buf, u32 size)
 {
 	struct sdio_func *func = dev_to_sdio_func(wilc->dev);
-	u32 block_size = g_sdio.block_size;
+	struct wilc_sdio *sdio_priv = wilc->bus_data;
+	u32 block_size = sdio_priv->block_size;
 	struct sdio_cmd53 cmd;
 	int nblk, nleft, ret;
 
@@ -523,6 +531,7 @@ static int sdio_write(struct wilc *wilc, u32 addr, u8 *buf, u32 size)
 static int sdio_read_reg(struct wilc *wilc, u32 addr, u32 *data)
 {
 	struct sdio_func *func = dev_to_sdio_func(wilc->dev);
+	struct wilc_sdio *sdio_priv = wilc->bus_data;
 	int ret;
 
 	if (addr >= 0xf0 && addr <= 0xff) {
@@ -553,7 +562,7 @@ static int sdio_read_reg(struct wilc *wilc, u32 addr, u32 *data)
 		cmd.count = 4;
 		cmd.buffer = (u8 *)data;
 
-		cmd.block_size = g_sdio.block_size;
+		cmd.block_size = sdio_priv->block_size;
 		ret = wilc_sdio_cmd53(wilc, &cmd);
 		if (ret) {
 			dev_err(&func->dev,
@@ -574,7 +583,8 @@ static int sdio_read_reg(struct wilc *wilc, u32 addr, u32 *data)
 static int sdio_read(struct wilc *wilc, u32 addr, u8 *buf, u32 size)
 {
 	struct sdio_func *func = dev_to_sdio_func(wilc->dev);
-	u32 block_size = g_sdio.block_size;
+	struct wilc_sdio *sdio_priv = wilc->bus_data;
+	u32 block_size = sdio_priv->block_size;
 	struct sdio_cmd53 cmd;
 	int nblk, nleft, ret;
 
@@ -674,13 +684,14 @@ static int sdio_deinit(struct wilc *wilc)
 static int sdio_init(struct wilc *wilc, bool resume)
 {
 	struct sdio_func *func = dev_to_sdio_func(wilc->dev);
+	struct wilc_sdio *sdio_priv = wilc->bus_data;
 	struct sdio_cmd52 cmd;
 	int loop, ret;
 	u32 chipid;
 
 	if (!resume) {
-		memset(&g_sdio, 0, sizeof(struct wilc_sdio));
-		g_sdio.irq_gpio = wilc->dev_irq_num;
+		memset(sdio_priv, 0, sizeof(struct wilc_sdio));
+		sdio_priv->irq_gpio = wilc->dev_irq_num;
 	}
 
 	/**
@@ -704,7 +715,7 @@ static int sdio_init(struct wilc *wilc, bool resume)
 		dev_err(&func->dev, "Fail cmd 52, set func 0 block size...\n");
 		goto fail;
 	}
-	g_sdio.block_size = WILC_SDIO_BLOCK_SIZE;
+	sdio_priv->block_size = WILC_SDIO_BLOCK_SIZE;
 
 	/**
 	 *      enable func1 IO
@@ -778,11 +789,11 @@ static int sdio_init(struct wilc *wilc, bool resume)
 		}
 		dev_err(&func->dev, "chipid (%08x)\n", chipid);
 		if ((chipid & 0xfff) > 0x2a0)
-			g_sdio.has_thrpt_enh3 = 1;
+			sdio_priv->has_thrpt_enh3 = 1;
 		else
-			g_sdio.has_thrpt_enh3 = 0;
+			sdio_priv->has_thrpt_enh3 = 0;
 		dev_info(&func->dev, "has_thrpt_enh3 = %d...\n",
-			 g_sdio.has_thrpt_enh3);
+			 sdio_priv->has_thrpt_enh3);
 	}
 
 	return 1;
@@ -820,6 +831,7 @@ static int sdio_read_size(struct wilc *wilc, u32 *size)
 static int sdio_read_int(struct wilc *wilc, u32 *int_status)
 {
 	struct sdio_func *func = dev_to_sdio_func(wilc->dev);
+	struct wilc_sdio *sdio_priv = wilc->bus_data;
 	u32 tmp;
 	struct sdio_cmd52 cmd;
 
@@ -828,7 +840,7 @@ static int sdio_read_int(struct wilc *wilc, u32 *int_status)
 	/**
 	 *      Read IRQ flags
 	 **/
-	if (!g_sdio.irq_gpio) {
+	if (!sdio_priv->irq_gpio) {
 		int i;
 
 		cmd.function = 1;
@@ -848,7 +860,7 @@ static int sdio_read_int(struct wilc *wilc, u32 *int_status)
 			tmp |= INT_4;
 		if (cmd.data & BIT(6))
 			tmp |= INT_5;
-		for (i = g_sdio.nint; i < MAX_NUM_INT; i++) {
+		for (i = sdio_priv->nint; i < MAX_NUM_INT; i++) {
 			if ((tmp >> (IRG_FLAGS_OFFSET + i)) & 0x1) {
 				dev_err(&func->dev,
 					"Unexpected interrupt (1) : tmp=%x, data=%x\n",
@@ -877,13 +889,14 @@ static int sdio_read_int(struct wilc *wilc, u32 *int_status)
 static int sdio_clear_int_ext(struct wilc *wilc, u32 val)
 {
 	struct sdio_func *func = dev_to_sdio_func(wilc->dev);
+	struct wilc_sdio *sdio_priv = wilc->bus_data;
 	int ret;
 	int vmm_ctl;
 
-	if (g_sdio.has_thrpt_enh3) {
+	if (sdio_priv->has_thrpt_enh3) {
 		u32 reg;
 
-		if (g_sdio.irq_gpio) {
+		if (sdio_priv->irq_gpio) {
 			u32 flags;
 
 			flags = val & (BIT(MAX_NUN_INT_THRPT_ENH2) - 1);
@@ -919,7 +932,7 @@ static int sdio_clear_int_ext(struct wilc *wilc, u32 val)
 		}
 		return 1;
 	}
-	if (g_sdio.irq_gpio) {
+	if (sdio_priv->irq_gpio) {
 		/* has_thrpt_enh2 uses register 0xf8 to clear interrupts. */
 		/*
 		 * Cannot clear multiple interrupts.
@@ -932,7 +945,7 @@ static int sdio_clear_int_ext(struct wilc *wilc, u32 val)
 			int i;
 
 			ret = 1;
-			for (i = 0; i < g_sdio.nint; i++) {
+			for (i = 0; i < sdio_priv->nint; i++) {
 				if (flags & 1) {
 					struct sdio_cmd52 cmd;
 
@@ -956,7 +969,7 @@ static int sdio_clear_int_ext(struct wilc *wilc, u32 val)
 			}
 			if (!ret)
 				goto fail;
-			for (i = g_sdio.nint; i < MAX_NUM_INT; i++) {
+			for (i = sdio_priv->nint; i < MAX_NUM_INT; i++) {
 				if (flags & 1)
 					dev_err(&func->dev,
 						"Unexpected interrupt cleared %d...\n",
@@ -1001,6 +1014,7 @@ static int sdio_clear_int_ext(struct wilc *wilc, u32 val)
 static int sdio_sync_ext(struct wilc *wilc, int nint)
 {
 	struct sdio_func *func = dev_to_sdio_func(wilc->dev);
+	struct wilc_sdio *sdio_priv = wilc->bus_data;
 	u32 reg;
 
 	if (nint > MAX_NUM_INT) {
@@ -1013,7 +1027,7 @@ static int sdio_sync_ext(struct wilc *wilc, int nint)
 		return 0;
 	}
 
-	g_sdio.nint = nint;
+	sdio_priv->nint = nint;
 
 	/**
 	 *      Disable power sequencer
@@ -1029,7 +1043,7 @@ static int sdio_sync_ext(struct wilc *wilc, int nint)
 		return 0;
 	}
 
-	if (g_sdio.irq_gpio) {
+	if (sdio_priv->irq_gpio) {
 		u32 reg;
 		int ret, i;
 
diff --git a/drivers/staging/wilc1000/wilc_wfi_netdevice.h b/drivers/staging/wilc1000/wilc_wfi_netdevice.h
index 484c265..4ba5887 100644
--- a/drivers/staging/wilc1000/wilc_wfi_netdevice.h
+++ b/drivers/staging/wilc1000/wilc_wfi_netdevice.h
@@ -205,6 +205,7 @@ struct wilc {
 	struct workqueue_struct *hif_workqueue;
 	enum chip_ps_states chip_ps_state;
 	struct wilc_cfg cfg;
+	void *bus_data;
 };
 
 struct wilc_wfi_mon_priv {
-- 
2.7.4

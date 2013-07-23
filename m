Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog127.obsmtp.com ([74.125.149.107]:47472 "EHLO
	na3sys009aog127.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754162Ab3GWCT1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Jul 2013 22:19:27 -0400
From: Bing Zhao <bzhao@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: "John W. Linville" <linville@tuxdriver.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Yogesh Ashok Powar <yogeshp@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH 19/21] mwifiex: code rearrangement in sdio.c
Date: Mon, 22 Jul 2013 19:17:56 -0700
Message-ID: <1374545878-15683-20-git-send-email-bzhao@marvell.com> (sfid-20130723_041933_258439_2AAD1715)
In-Reply-To: <1374545878-15683-1-git-send-email-bzhao@marvell.com>
References: <1374545878-15683-1-git-send-email-bzhao@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Amitkumar Karwar <akarwar@marvell.com>

Some function definitions are moved to appropriate place
to avoid forward declarations.

Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/sdio.c | 211 ++++++++++++++++++------------------
 1 file changed, 104 insertions(+), 107 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/sdio.c b/drivers/net/wireless/mwifiex/sdio.c
index c32a735..1eb5efa1 100644
--- a/drivers/net/wireless/mwifiex/sdio.c
+++ b/drivers/net/wireless/mwifiex/sdio.c
@@ -50,9 +50,6 @@ static struct mwifiex_if_ops sdio_ops;
 
 static struct semaphore add_remove_card_sem;
 
-static int mwifiex_sdio_resume(struct device *dev);
-static void mwifiex_sdio_interrupt(struct sdio_func *func);
-
 /*
  * SDIO probe.
  *
@@ -113,6 +110,51 @@ mwifiex_sdio_probe(struct sdio_func *func, const struct sdio_device_id *id)
 }
 
 /*
+ * SDIO resume.
+ *
+ * Kernel needs to suspend all functions separately. Therefore all
+ * registered functions must have drivers with suspend and resume
+ * methods. Failing that the kernel simply removes the whole card.
+ *
+ * If already not resumed, this function turns on the traffic and
+ * sends a host sleep cancel request to the firmware.
+ */
+static int mwifiex_sdio_resume(struct device *dev)
+{
+	struct sdio_func *func = dev_to_sdio_func(dev);
+	struct sdio_mmc_card *card;
+	struct mwifiex_adapter *adapter;
+	mmc_pm_flag_t pm_flag = 0;
+
+	if (func) {
+		pm_flag = sdio_get_host_pm_caps(func);
+		card = sdio_get_drvdata(func);
+		if (!card || !card->adapter) {
+			pr_err("resume: invalid card or adapter\n");
+			return 0;
+		}
+	} else {
+		pr_err("resume: sdio_func is not specified\n");
+		return 0;
+	}
+
+	adapter = card->adapter;
+
+	if (!adapter->is_suspended) {
+		dev_warn(adapter->dev, "device already resumed\n");
+		return 0;
+	}
+
+	adapter->is_suspended = false;
+
+	/* Disable Host Sleep */
+	mwifiex_cancel_hs(mwifiex_get_priv(adapter, MWIFIEX_BSS_ROLE_STA),
+			  MWIFIEX_ASYNC_CMD);
+
+	return 0;
+}
+
+/*
  * SDIO remove.
  *
  * This function removes the interface and frees up the card structure.
@@ -212,51 +254,6 @@ static int mwifiex_sdio_suspend(struct device *dev)
 	return ret;
 }
 
-/*
- * SDIO resume.
- *
- * Kernel needs to suspend all functions separately. Therefore all
- * registered functions must have drivers with suspend and resume
- * methods. Failing that the kernel simply removes the whole card.
- *
- * If already not resumed, this function turns on the traffic and
- * sends a host sleep cancel request to the firmware.
- */
-static int mwifiex_sdio_resume(struct device *dev)
-{
-	struct sdio_func *func = dev_to_sdio_func(dev);
-	struct sdio_mmc_card *card;
-	struct mwifiex_adapter *adapter;
-	mmc_pm_flag_t pm_flag = 0;
-
-	if (func) {
-		pm_flag = sdio_get_host_pm_caps(func);
-		card = sdio_get_drvdata(func);
-		if (!card || !card->adapter) {
-			pr_err("resume: invalid card or adapter\n");
-			return 0;
-		}
-	} else {
-		pr_err("resume: sdio_func is not specified\n");
-		return 0;
-	}
-
-	adapter = card->adapter;
-
-	if (!adapter->is_suspended) {
-		dev_warn(adapter->dev, "device already resumed\n");
-		return 0;
-	}
-
-	adapter->is_suspended = false;
-
-	/* Disable Host Sleep */
-	mwifiex_cancel_hs(mwifiex_get_priv(adapter, MWIFIEX_BSS_ROLE_STA),
-			  MWIFIEX_ASYNC_CMD);
-
-	return 0;
-}
-
 /* Device ID for SD8786 */
 #define SDIO_DEVICE_ID_MARVELL_8786   (0x9116)
 /* Device ID for SD8787 */
@@ -707,6 +704,65 @@ static void mwifiex_sdio_disable_host_int(struct mwifiex_adapter *adapter)
 }
 
 /*
+ * This function reads the interrupt status from card.
+ */
+static void mwifiex_interrupt_status(struct mwifiex_adapter *adapter)
+{
+	struct sdio_mmc_card *card = adapter->card;
+	u8 sdio_ireg;
+	unsigned long flags;
+
+	if (mwifiex_read_data_sync(adapter, card->mp_regs,
+				   card->reg->max_mp_regs,
+				   REG_PORT | MWIFIEX_SDIO_BYTE_MODE_MASK, 0)) {
+		dev_err(adapter->dev, "read mp_regs failed\n");
+		return;
+	}
+
+	sdio_ireg = card->mp_regs[HOST_INTSTATUS_REG];
+	if (sdio_ireg) {
+		/*
+		 * DN_LD_HOST_INT_STATUS and/or UP_LD_HOST_INT_STATUS
+		 * For SDIO new mode CMD port interrupts
+		 *	DN_LD_CMD_PORT_HOST_INT_STATUS and/or
+		 *	UP_LD_CMD_PORT_HOST_INT_STATUS
+		 * Clear the interrupt status register
+		 */
+		dev_dbg(adapter->dev, "int: sdio_ireg = %#x\n", sdio_ireg);
+		spin_lock_irqsave(&adapter->int_lock, flags);
+		adapter->int_status |= sdio_ireg;
+		spin_unlock_irqrestore(&adapter->int_lock, flags);
+	}
+}
+
+/*
+ * SDIO interrupt handler.
+ *
+ * This function reads the interrupt status from firmware and handles
+ * the interrupt in current thread (ksdioirqd) right away.
+ */
+static void
+mwifiex_sdio_interrupt(struct sdio_func *func)
+{
+	struct mwifiex_adapter *adapter;
+	struct sdio_mmc_card *card;
+
+	card = sdio_get_drvdata(func);
+	if (!card || !card->adapter) {
+		pr_debug("int: func=%p card=%p adapter=%p\n",
+			 func, card, card ? card->adapter : NULL);
+		return;
+	}
+	adapter = card->adapter;
+
+	if (!adapter->pps_uapsd_mode && adapter->ps_state == PS_STATE_SLEEP)
+		adapter->ps_state = PS_STATE_AWAKE;
+
+	mwifiex_interrupt_status(adapter);
+	mwifiex_main_process(adapter);
+}
+
+/*
  * This function enables the host interrupt.
  *
  * The host interrupt enable mask is written to the card
@@ -963,65 +1019,6 @@ static int mwifiex_check_fw_status(struct mwifiex_adapter *adapter,
 }
 
 /*
- * This function reads the interrupt status from card.
- */
-static void mwifiex_interrupt_status(struct mwifiex_adapter *adapter)
-{
-	struct sdio_mmc_card *card = adapter->card;
-	u8 sdio_ireg;
-	unsigned long flags;
-
-	if (mwifiex_read_data_sync(adapter, card->mp_regs,
-				   card->reg->max_mp_regs,
-				   REG_PORT | MWIFIEX_SDIO_BYTE_MODE_MASK, 0)) {
-		dev_err(adapter->dev, "read mp_regs failed\n");
-		return;
-	}
-
-	sdio_ireg = card->mp_regs[HOST_INTSTATUS_REG];
-	if (sdio_ireg) {
-		/*
-		 * DN_LD_HOST_INT_STATUS and/or UP_LD_HOST_INT_STATUS
-		 * For SDIO new mode CMD port interrupts
-		 *	DN_LD_CMD_PORT_HOST_INT_STATUS and/or
-		 *	UP_LD_CMD_PORT_HOST_INT_STATUS
-		 * Clear the interrupt status register
-		 */
-		dev_dbg(adapter->dev, "int: sdio_ireg = %#x\n", sdio_ireg);
-		spin_lock_irqsave(&adapter->int_lock, flags);
-		adapter->int_status |= sdio_ireg;
-		spin_unlock_irqrestore(&adapter->int_lock, flags);
-	}
-}
-
-/*
- * SDIO interrupt handler.
- *
- * This function reads the interrupt status from firmware and handles
- * the interrupt in current thread (ksdioirqd) right away.
- */
-static void
-mwifiex_sdio_interrupt(struct sdio_func *func)
-{
-	struct mwifiex_adapter *adapter;
-	struct sdio_mmc_card *card;
-
-	card = sdio_get_drvdata(func);
-	if (!card || !card->adapter) {
-		pr_debug("int: func=%p card=%p adapter=%p\n",
-			 func, card, card ? card->adapter : NULL);
-		return;
-	}
-	adapter = card->adapter;
-
-	if (!adapter->pps_uapsd_mode && adapter->ps_state == PS_STATE_SLEEP)
-		adapter->ps_state = PS_STATE_AWAKE;
-
-	mwifiex_interrupt_status(adapter);
-	mwifiex_main_process(adapter);
-}
-
-/*
  * This function decodes a received packet.
  *
  * Based on the type, the packet is treated as either a data, or
-- 
1.8.2.3


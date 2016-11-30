Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:55710 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S932141AbcK3Ox2 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 30 Nov 2016 09:53:28 -0500
From: Amitkumar Karwar <akarwar@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: Cathy Luo <cluo@marvell.com>,
        Nishant Sarmukadam <nishants@marvell.com>,
        <rajatja@google.com>, <briannorris@google.com>,
        <dmitry.torokhov@gmail.com>, Xinming Hu <huxm@marvell.com>,
        Amitkumar Karwar <akarwar@marvell.com>
Subject: [PATCH 1/2] mwifiex: code rearrangement in pcie.c and sdio.c
Date: Wed, 30 Nov 2016 20:22:16 +0530
Message-ID: <1480517537-9920-1-git-send-email-akarwar@marvell.com> (sfid-20161130_155332_848509_AA7FD8F7)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Xinming Hu <huxm@marvell.com>

Next patch in this series is going to use mwifiex_read_reg() in remove
handlers. The changes here are prerequisites to avoid forward
declarations.

Signed-off-by: Xinming Hu <huxm@marvell.com>
Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
---
 drivers/net/wireless/marvell/mwifiex/pcie.c |  73 +++---
 drivers/net/wireless/marvell/mwifiex/sdio.c | 336 ++++++++++++++--------------
 2 files changed, 201 insertions(+), 208 deletions(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/pcie.c b/drivers/net/wireless/marvell/mwifiex/pcie.c
index 32fa4ed..7aa16a5 100644
--- a/drivers/net/wireless/marvell/mwifiex/pcie.c
+++ b/drivers/net/wireless/marvell/mwifiex/pcie.c
@@ -81,6 +81,42 @@ static void mwifiex_unmap_pci_memory(struct mwifiex_adapter *adapter,
 }
 
 /*
+ * This function writes data into PCIE card register.
+ */
+static int mwifiex_write_reg(struct mwifiex_adapter *adapter, int reg, u32 data)
+{
+	struct pcie_service_card *card = adapter->card;
+
+	iowrite32(data, card->pci_mmap1 + reg);
+
+	return 0;
+}
+
+/* This function reads data from PCIE card register.
+ */
+static int mwifiex_read_reg(struct mwifiex_adapter *adapter, int reg, u32 *data)
+{
+	struct pcie_service_card *card = adapter->card;
+
+	*data = ioread32(card->pci_mmap1 + reg);
+	if (*data == 0xffffffff)
+		return 0xffffffff;
+
+	return 0;
+}
+
+/* This function reads u8 data from PCIE card register. */
+static int mwifiex_read_reg_byte(struct mwifiex_adapter *adapter,
+				 int reg, u8 *data)
+{
+	struct pcie_service_card *card = adapter->card;
+
+	*data = ioread8(card->pci_mmap1 + reg);
+
+	return 0;
+}
+
+/*
  * This function reads sleep cookie and checks if FW is ready
  */
 static bool mwifiex_pcie_ok_to_access_hw(struct mwifiex_adapter *adapter)
@@ -374,43 +410,6 @@ static SIMPLE_DEV_PM_OPS(mwifiex_pcie_pm_ops, mwifiex_pcie_suspend,
 };
 
 /*
- * This function writes data into PCIE card register.
- */
-static int mwifiex_write_reg(struct mwifiex_adapter *adapter, int reg, u32 data)
-{
-	struct pcie_service_card *card = adapter->card;
-
-	iowrite32(data, card->pci_mmap1 + reg);
-
-	return 0;
-}
-
-/*
- * This function reads data from PCIE card register.
- */
-static int mwifiex_read_reg(struct mwifiex_adapter *adapter, int reg, u32 *data)
-{
-	struct pcie_service_card *card = adapter->card;
-
-	*data = ioread32(card->pci_mmap1 + reg);
-	if (*data == 0xffffffff)
-		return 0xffffffff;
-
-	return 0;
-}
-
-/* This function reads u8 data from PCIE card register. */
-static int mwifiex_read_reg_byte(struct mwifiex_adapter *adapter,
-				 int reg, u8 *data)
-{
-	struct pcie_service_card *card = adapter->card;
-
-	*data = ioread8(card->pci_mmap1 + reg);
-
-	return 0;
-}
-
-/*
  * This function adds delay loop to ensure FW is awake before proceeding.
  */
 static void mwifiex_pcie_dev_wakeup_delay(struct mwifiex_adapter *adapter)
diff --git a/drivers/net/wireless/marvell/mwifiex/sdio.c b/drivers/net/wireless/marvell/mwifiex/sdio.c
index 66d0dd6..6fcaf26 100644
--- a/drivers/net/wireless/marvell/mwifiex/sdio.c
+++ b/drivers/net/wireless/marvell/mwifiex/sdio.c
@@ -215,6 +215,171 @@ static int mwifiex_sdio_resume(struct device *dev)
 	return 0;
 }
 
+/* Write data into SDIO card register. Caller claims SDIO device. */
+static int
+mwifiex_write_reg_locked(struct sdio_func *func, u32 reg, u8 data)
+{
+	int ret = -1;
+
+	sdio_writeb(func, data, reg, &ret);
+	return ret;
+}
+
+/* This function writes data into SDIO card register.
+ */
+static int
+mwifiex_write_reg(struct mwifiex_adapter *adapter, u32 reg, u8 data)
+{
+	struct sdio_mmc_card *card = adapter->card;
+	int ret;
+
+	sdio_claim_host(card->func);
+	ret = mwifiex_write_reg_locked(card->func, reg, data);
+	sdio_release_host(card->func);
+
+	return ret;
+}
+
+/* This function reads data from SDIO card register.
+ */
+static int
+mwifiex_read_reg(struct mwifiex_adapter *adapter, u32 reg, u8 *data)
+{
+	struct sdio_mmc_card *card = adapter->card;
+	int ret = -1;
+	u8 val;
+
+	sdio_claim_host(card->func);
+	val = sdio_readb(card->func, reg, &ret);
+	sdio_release_host(card->func);
+
+	*data = val;
+
+	return ret;
+}
+
+/* This function writes multiple data into SDIO card memory.
+ *
+ * This does not work in suspended mode.
+ */
+static int
+mwifiex_write_data_sync(struct mwifiex_adapter *adapter,
+			u8 *buffer, u32 pkt_len, u32 port)
+{
+	struct sdio_mmc_card *card = adapter->card;
+	int ret;
+	u8 blk_mode =
+		(port & MWIFIEX_SDIO_BYTE_MODE_MASK) ? BYTE_MODE : BLOCK_MODE;
+	u32 blk_size = (blk_mode == BLOCK_MODE) ? MWIFIEX_SDIO_BLOCK_SIZE : 1;
+	u32 blk_cnt =
+		(blk_mode ==
+		 BLOCK_MODE) ? (pkt_len /
+				MWIFIEX_SDIO_BLOCK_SIZE) : pkt_len;
+	u32 ioport = (port & MWIFIEX_SDIO_IO_PORT_MASK);
+
+	if (adapter->is_suspended) {
+		mwifiex_dbg(adapter, ERROR,
+			    "%s: not allowed while suspended\n", __func__);
+		return -1;
+	}
+
+	sdio_claim_host(card->func);
+
+	ret = sdio_writesb(card->func, ioport, buffer, blk_cnt * blk_size);
+
+	sdio_release_host(card->func);
+
+	return ret;
+}
+
+/* This function reads multiple data from SDIO card memory.
+ */
+static int mwifiex_read_data_sync(struct mwifiex_adapter *adapter, u8 *buffer,
+				  u32 len, u32 port, u8 claim)
+{
+	struct sdio_mmc_card *card = adapter->card;
+	int ret;
+	u8 blk_mode = (port & MWIFIEX_SDIO_BYTE_MODE_MASK) ? BYTE_MODE
+		       : BLOCK_MODE;
+	u32 blk_size = (blk_mode == BLOCK_MODE) ? MWIFIEX_SDIO_BLOCK_SIZE : 1;
+	u32 blk_cnt = (blk_mode == BLOCK_MODE) ? (len / MWIFIEX_SDIO_BLOCK_SIZE)
+			: len;
+	u32 ioport = (port & MWIFIEX_SDIO_IO_PORT_MASK);
+
+	if (claim)
+		sdio_claim_host(card->func);
+
+	ret = sdio_readsb(card->func, buffer, ioport, blk_cnt * blk_size);
+
+	if (claim)
+		sdio_release_host(card->func);
+
+	return ret;
+}
+
+/* This function reads the firmware status.
+ */
+static int
+mwifiex_sdio_read_fw_status(struct mwifiex_adapter *adapter, u16 *dat)
+{
+	struct sdio_mmc_card *card = adapter->card;
+	const struct mwifiex_sdio_card_reg *reg = card->reg;
+	u8 fws0, fws1;
+
+	if (mwifiex_read_reg(adapter, reg->status_reg_0, &fws0))
+		return -1;
+
+	if (mwifiex_read_reg(adapter, reg->status_reg_1, &fws1))
+		return -1;
+
+	*dat = (u16)((fws1 << 8) | fws0);
+	return 0;
+}
+
+/* This function checks the firmware status in card.
+ */
+static int mwifiex_check_fw_status(struct mwifiex_adapter *adapter,
+				   u32 poll_num)
+{
+	int ret = 0;
+	u16 firmware_stat;
+	u32 tries;
+
+	for (tries = 0; tries < poll_num; tries++) {
+		ret = mwifiex_sdio_read_fw_status(adapter, &firmware_stat);
+		if (ret)
+			continue;
+		if (firmware_stat == FIRMWARE_READY_SDIO) {
+			ret = 0;
+			break;
+		}
+
+		msleep(100);
+		ret = -1;
+	}
+
+	return ret;
+}
+
+/* This function checks if WLAN is the winner.
+ */
+static int mwifiex_check_winner_status(struct mwifiex_adapter *adapter)
+{
+	int ret = 0;
+	u8 winner = 0;
+	struct sdio_mmc_card *card = adapter->card;
+
+	if (mwifiex_read_reg(adapter, card->reg->status_reg_0, &winner))
+		return -1;
+
+	if (winner)
+		adapter->winner = 0;
+	else
+		adapter->winner = 1;
+
+	return ret;
+}
+
 /*
  * SDIO remove.
  *
@@ -374,111 +539,6 @@ static int mwifiex_sdio_suspend(struct device *dev)
 	}
 };
 
-/* Write data into SDIO card register. Caller claims SDIO device. */
-static int
-mwifiex_write_reg_locked(struct sdio_func *func, u32 reg, u8 data)
-{
-	int ret = -1;
-	sdio_writeb(func, data, reg, &ret);
-	return ret;
-}
-
-/*
- * This function writes data into SDIO card register.
- */
-static int
-mwifiex_write_reg(struct mwifiex_adapter *adapter, u32 reg, u8 data)
-{
-	struct sdio_mmc_card *card = adapter->card;
-	int ret;
-
-	sdio_claim_host(card->func);
-	ret = mwifiex_write_reg_locked(card->func, reg, data);
-	sdio_release_host(card->func);
-
-	return ret;
-}
-
-/*
- * This function reads data from SDIO card register.
- */
-static int
-mwifiex_read_reg(struct mwifiex_adapter *adapter, u32 reg, u8 *data)
-{
-	struct sdio_mmc_card *card = adapter->card;
-	int ret = -1;
-	u8 val;
-
-	sdio_claim_host(card->func);
-	val = sdio_readb(card->func, reg, &ret);
-	sdio_release_host(card->func);
-
-	*data = val;
-
-	return ret;
-}
-
-/*
- * This function writes multiple data into SDIO card memory.
- *
- * This does not work in suspended mode.
- */
-static int
-mwifiex_write_data_sync(struct mwifiex_adapter *adapter,
-			u8 *buffer, u32 pkt_len, u32 port)
-{
-	struct sdio_mmc_card *card = adapter->card;
-	int ret;
-	u8 blk_mode =
-		(port & MWIFIEX_SDIO_BYTE_MODE_MASK) ? BYTE_MODE : BLOCK_MODE;
-	u32 blk_size = (blk_mode == BLOCK_MODE) ? MWIFIEX_SDIO_BLOCK_SIZE : 1;
-	u32 blk_cnt =
-		(blk_mode ==
-		 BLOCK_MODE) ? (pkt_len /
-				MWIFIEX_SDIO_BLOCK_SIZE) : pkt_len;
-	u32 ioport = (port & MWIFIEX_SDIO_IO_PORT_MASK);
-
-	if (adapter->is_suspended) {
-		mwifiex_dbg(adapter, ERROR,
-			    "%s: not allowed while suspended\n", __func__);
-		return -1;
-	}
-
-	sdio_claim_host(card->func);
-
-	ret = sdio_writesb(card->func, ioport, buffer, blk_cnt * blk_size);
-
-	sdio_release_host(card->func);
-
-	return ret;
-}
-
-/*
- * This function reads multiple data from SDIO card memory.
- */
-static int mwifiex_read_data_sync(struct mwifiex_adapter *adapter, u8 *buffer,
-				  u32 len, u32 port, u8 claim)
-{
-	struct sdio_mmc_card *card = adapter->card;
-	int ret;
-	u8 blk_mode = (port & MWIFIEX_SDIO_BYTE_MODE_MASK) ? BYTE_MODE
-		       : BLOCK_MODE;
-	u32 blk_size = (blk_mode == BLOCK_MODE) ? MWIFIEX_SDIO_BLOCK_SIZE : 1;
-	u32 blk_cnt = (blk_mode == BLOCK_MODE) ? (len / MWIFIEX_SDIO_BLOCK_SIZE)
-			: len;
-	u32 ioport = (port & MWIFIEX_SDIO_IO_PORT_MASK);
-
-	if (claim)
-		sdio_claim_host(card->func);
-
-	ret = sdio_readsb(card->func, buffer, ioport, blk_cnt * blk_size);
-
-	if (claim)
-		sdio_release_host(card->func);
-
-	return ret;
-}
-
 /*
  * This function wakes up the card.
  *
@@ -765,27 +825,6 @@ static int mwifiex_get_wr_port_data(struct mwifiex_adapter *adapter, u32 *port)
 }
 
 /*
- * This function reads the firmware status.
- */
-static int
-mwifiex_sdio_read_fw_status(struct mwifiex_adapter *adapter, u16 *dat)
-{
-	struct sdio_mmc_card *card = adapter->card;
-	const struct mwifiex_sdio_card_reg *reg = card->reg;
-	u8 fws0, fws1;
-
-	if (mwifiex_read_reg(adapter, reg->status_reg_0, &fws0))
-		return -1;
-
-	if (mwifiex_read_reg(adapter, reg->status_reg_1, &fws1))
-		return -1;
-
-	*dat = (u16) ((fws1 << 8) | fws0);
-
-	return 0;
-}
-
-/*
  * This function disables the host interrupt.
  *
  * The host interrupt mask is read, the disable bit is reset and
@@ -1090,51 +1129,6 @@ static int mwifiex_prog_fw_w_helper(struct mwifiex_adapter *adapter,
 }
 
 /*
- * This function checks the firmware status in card.
- */
-static int mwifiex_check_fw_status(struct mwifiex_adapter *adapter,
-				   u32 poll_num)
-{
-	int ret = 0;
-	u16 firmware_stat;
-	u32 tries;
-
-	for (tries = 0; tries < poll_num; tries++) {
-		ret = mwifiex_sdio_read_fw_status(adapter, &firmware_stat);
-		if (ret)
-			continue;
-		if (firmware_stat == FIRMWARE_READY_SDIO) {
-			ret = 0;
-			break;
-		} else {
-			msleep(100);
-			ret = -1;
-		}
-	}
-
-	return ret;
-}
-
-/* This function checks if WLAN is the winner.
- */
-static int mwifiex_check_winner_status(struct mwifiex_adapter *adapter)
-{
-	int ret = 0;
-	u8 winner = 0;
-	struct sdio_mmc_card *card = adapter->card;
-
-	if (mwifiex_read_reg(adapter, card->reg->status_reg_0, &winner))
-		return -1;
-
-	if (winner)
-		adapter->winner = 0;
-	else
-		adapter->winner = 1;
-
-	return ret;
-}
-
-/*
  * This function decode sdio aggreation pkt.
  *
  * Based on the the data block size and pkt_len,
-- 
1.9.1

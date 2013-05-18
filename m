Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog101.obsmtp.com ([74.125.149.67]:58975 "EHLO
	na3sys009aog101.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751044Ab3ERA5W (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 17 May 2013 20:57:22 -0400
From: Bing Zhao <bzhao@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: "John W. Linville" <linville@tuxdriver.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Yogesh Ashok Powar <yogeshp@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH v2 17/17] mwifiex: add support for Marvell SD8897 chipset
Date: Fri, 17 May 2013 17:54:58 -0700
Message-ID: <1368838498-410-1-git-send-email-bzhao@marvell.com> (sfid-20130518_025725_694759_EB59E1A9)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Yogesh Ashok Powar <yogeshp@marvell.com>

Some of the key differences between SD8897 and older chipsets
are as follows:

a) sdio mpa_rx and mpa_tx ports have been increased from 16 to 32
b) Same is the case with read/write bitmap that one receives from
   mpa_reg read
c) aggregation packet count doubled from 8 to 16
d) Most of key reg addresses are changed
e) There is a separate command or control port
f) Now command rx/tx_done have new interrupts

1. 'supports_sdio_new_mode' flag is added to handle (a) and (b).
2. (c) and (d) are taken care of by filling chip specific
   information in global structurei (mwifiex_sdio_sd8897).
3. For older chipsets, port 0 was cmd port and port 1->15 were
   data port. Therefore we had CTRL_PORT_MASK to differentiate
   port type. Now these changes are under 'has_control_mask' flag.

Signed-off-by: Yogesh Ashok Powar <yogeshp@marvell.com>
Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
Signed-off-by: Nishant Sarmukadam <nishants@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
Signed-off-by: Frank Huang <frankh@marvell.com>
---
v2: fix cmd53 single port address overwriting

 drivers/net/wireless/mwifiex/Kconfig |   4 +-
 drivers/net/wireless/mwifiex/sdio.c  | 267 ++++++++++++++++++++++++++++-------
 drivers/net/wireless/mwifiex/sdio.h  | 105 +++++++++++++-
 3 files changed, 315 insertions(+), 61 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/Kconfig b/drivers/net/wireless/mwifiex/Kconfig
index 4f614aa..f7ff472 100644
--- a/drivers/net/wireless/mwifiex/Kconfig
+++ b/drivers/net/wireless/mwifiex/Kconfig
@@ -3,13 +3,13 @@ config MWIFIEX
 	depends on CFG80211
 	---help---
 	  This adds support for wireless adapters based on Marvell
-	  802.11n chipsets.
+	  802.11n/ac chipsets.
 
 	  If you choose to build it as a module, it will be called
 	  mwifiex.
 
 config MWIFIEX_SDIO
-	tristate "Marvell WiFi-Ex Driver for SD8786/SD8787/SD8797"
+	tristate "Marvell WiFi-Ex Driver for SD8786/SD8787/SD8797/SD8897"
 	depends on MWIFIEX && MMC
 	select FW_LOADER
 	---help---
diff --git a/drivers/net/wireless/mwifiex/sdio.c b/drivers/net/wireless/mwifiex/sdio.c
index 4b196dc..5ee5ed0 100644
--- a/drivers/net/wireless/mwifiex/sdio.c
+++ b/drivers/net/wireless/mwifiex/sdio.c
@@ -84,6 +84,8 @@ mwifiex_sdio_probe(struct sdio_func *func, const struct sdio_device_id *id)
 		card->reg = data->reg;
 		card->max_ports = data->max_ports;
 		card->mp_agg_pkt_limit = data->mp_agg_pkt_limit;
+		card->supports_sdio_new_mode = data->supports_sdio_new_mode;
+		card->has_control_mask = data->has_control_mask;
 	}
 
 	sdio_claim_host(func);
@@ -260,6 +262,8 @@ static int mwifiex_sdio_resume(struct device *dev)
 #define SDIO_DEVICE_ID_MARVELL_8787   (0x9119)
 /* Device ID for SD8797 */
 #define SDIO_DEVICE_ID_MARVELL_8797   (0x9129)
+/* Device ID for SD8897 */
+#define SDIO_DEVICE_ID_MARVELL_8897   (0x912d)
 
 /* WLAN IDs */
 static const struct sdio_device_id mwifiex_ids[] = {
@@ -269,6 +273,8 @@ static const struct sdio_device_id mwifiex_ids[] = {
 		.driver_data = (unsigned long) &mwifiex_sdio_sd8787},
 	{SDIO_DEVICE(SDIO_VENDOR_ID_MARVELL, SDIO_DEVICE_ID_MARVELL_8797),
 		.driver_data = (unsigned long) &mwifiex_sdio_sd8797},
+	{SDIO_DEVICE(SDIO_VENDOR_ID_MARVELL, SDIO_DEVICE_ID_MARVELL_8897),
+		.driver_data = (unsigned long) &mwifiex_sdio_sd8897},
 	{},
 };
 
@@ -412,7 +418,40 @@ static int mwifiex_pm_wakeup_card_complete(struct mwifiex_adapter *adapter)
 }
 
 /*
- * This function initializes the IO ports.
+ * This function is used to initialize IO ports for the
+ * chipsets supporting SDIO new mode eg SD8897.
+ */
+static int mwifiex_init_sdio_new_mode(struct mwifiex_adapter *adapter)
+{
+	u8 reg;
+
+	adapter->ioport = MEM_PORT;
+
+	/* enable sdio new mode */
+	if (mwifiex_read_reg(adapter, CARD_CONFIG_2_1_REG, &reg))
+		return -1;
+	if (mwifiex_write_reg(adapter, CARD_CONFIG_2_1_REG,
+			      reg | CMD53_NEW_MODE))
+		return -1;
+
+	/* Configure cmd port and enable reading rx length from the register */
+	if (mwifiex_read_reg(adapter, CMD_CONFIG_0, &reg))
+		return -1;
+	if (mwifiex_write_reg(adapter, CMD_CONFIG_0, reg | CMD_PORT_RD_LEN_EN))
+		return -1;
+
+	/* Enable Dnld/Upld ready auto reset for cmd port after cmd53 is
+	 * completed
+	 */
+	if (mwifiex_read_reg(adapter, CMD_CONFIG_1, &reg))
+		return -1;
+	if (mwifiex_write_reg(adapter, CMD_CONFIG_1, reg | CMD_PORT_AUTO_EN))
+		return -1;
+
+	return 0;
+}
+
+/* This function initializes the IO ports.
  *
  * The following operations are performed -
  *      - Read the IO ports (0, 1 and 2)
@@ -426,6 +465,12 @@ static int mwifiex_init_sdio_ioport(struct mwifiex_adapter *adapter)
 
 	adapter->ioport = 0;
 
+	if (card->supports_sdio_new_mode) {
+		if (mwifiex_init_sdio_new_mode(adapter))
+			return -1;
+		goto cont;
+	}
+
 	/* Read the IO port */
 	if (!mwifiex_read_reg(adapter, IO_PORT_0_REG, &reg))
 		adapter->ioport |= (reg & 0xff);
@@ -441,7 +486,7 @@ static int mwifiex_init_sdio_ioport(struct mwifiex_adapter *adapter)
 		adapter->ioport |= ((reg & 0xff) << 16);
 	else
 		return -1;
-
+cont:
 	pr_debug("info: SDIO FUNC1 IO port: %#x\n", adapter->ioport);
 
 	/* Set Host interrupt reset to read to clear */
@@ -504,10 +549,16 @@ static int mwifiex_get_rd_port(struct mwifiex_adapter *adapter, u8 *port)
 
 	dev_dbg(adapter->dev, "data: mp_rd_bitmap=0x%08x\n", rd_bitmap);
 
-	if (!(rd_bitmap & (CTRL_PORT_MASK | reg->data_port_mask)))
-		return -1;
+	if (card->supports_sdio_new_mode) {
+		if (!(rd_bitmap & reg->data_port_mask))
+			return -1;
+	} else {
+		if (!(rd_bitmap & (CTRL_PORT_MASK | reg->data_port_mask)))
+			return -1;
+	}
 
-	if (card->mp_rd_bitmap & CTRL_PORT_MASK) {
+	if ((card->has_control_mask) &&
+	    (card->mp_rd_bitmap & CTRL_PORT_MASK)) {
 		card->mp_rd_bitmap &= (u32) (~CTRL_PORT_MASK);
 		*port = CTRL_PORT;
 		dev_dbg(adapter->dev, "data: port=%d mp_rd_bitmap=0x%08x\n",
@@ -542,24 +593,34 @@ static int mwifiex_get_rd_port(struct mwifiex_adapter *adapter, u8 *port)
 static int mwifiex_get_wr_port_data(struct mwifiex_adapter *adapter, u32 *port)
 {
 	struct sdio_mmc_card *card = adapter->card;
+	const struct mwifiex_sdio_card_reg *reg = card->reg;
 	u32 wr_bitmap = card->mp_wr_bitmap;
 
 	dev_dbg(adapter->dev, "data: mp_wr_bitmap=0x%08x\n", wr_bitmap);
 
-	if (!(wr_bitmap & card->mp_data_port_mask))
+	if (card->supports_sdio_new_mode &&
+	    !(wr_bitmap & reg->data_port_mask)) {
+		adapter->data_sent = true;
+		return -EBUSY;
+	} else if (!card->supports_sdio_new_mode &&
+		   !(wr_bitmap & card->mp_data_port_mask)) {
 		return -1;
+	}
 
 	if (card->mp_wr_bitmap & (1 << card->curr_wr_port)) {
 		card->mp_wr_bitmap &= (u32) (~(1 << card->curr_wr_port));
 		*port = card->curr_wr_port;
-		if (++card->curr_wr_port == card->mp_end_port)
-			card->curr_wr_port = card->reg->start_wr_port;
+		if (((card->supports_sdio_new_mode) &&
+		     (++card->curr_wr_port == card->max_ports)) ||
+		    ((!card->supports_sdio_new_mode) &&
+		     (++card->curr_wr_port == card->mp_end_port)))
+			card->curr_wr_port = reg->start_wr_port;
 	} else {
 		adapter->data_sent = true;
 		return -EBUSY;
 	}
 
-	if (*port == CTRL_PORT) {
+	if ((card->has_control_mask) && (*port == CTRL_PORT)) {
 		dev_err(adapter->dev,
 			"invalid data port=%d cur port=%d mp_wr_bitmap=0x%08x -> 0x%08x\n",
 			*port, card->curr_wr_port, wr_bitmap,
@@ -904,6 +965,9 @@ static void mwifiex_interrupt_status(struct mwifiex_adapter *adapter)
 	if (sdio_ireg) {
 		/*
 		 * DN_LD_HOST_INT_STATUS and/or UP_LD_HOST_INT_STATUS
+		 * For SDIO new mode CMD port interrupts
+		 *	DN_LD_CMD_PORT_HOST_INT_STATUS and/or
+		 *	UP_LD_CMD_PORT_HOST_INT_STATUS
 		 * Clear the interrupt status register
 		 */
 		dev_dbg(adapter->dev, "int: sdio_ireg = %#x\n", sdio_ireg);
@@ -1031,7 +1095,7 @@ static int mwifiex_sdio_card_to_host_mp_aggr(struct mwifiex_adapter *adapter,
 	u8 *curr_ptr;
 	u32 rx_len = skb->len;
 
-	if (port == CTRL_PORT) {
+	if ((card->has_control_mask) && (port == CTRL_PORT)) {
 		/* Read the command Resp without aggr */
 		dev_dbg(adapter->dev, "info: %s: no aggregation for cmd "
 			"response\n", __func__);
@@ -1048,7 +1112,10 @@ static int mwifiex_sdio_card_to_host_mp_aggr(struct mwifiex_adapter *adapter,
 		goto rx_curr_single;
 	}
 
-	if (card->mp_rd_bitmap & (~((u32) CTRL_PORT_MASK))) {
+	if ((!card->has_control_mask && (card->mp_rd_bitmap &
+					 card->reg->data_port_mask)) ||
+	    (card->has_control_mask && (card->mp_rd_bitmap &
+					(~((u32) CTRL_PORT_MASK))))) {
 		/* Some more data RX pending */
 		dev_dbg(adapter->dev, "info: %s: not last packet\n", __func__);
 
@@ -1100,8 +1167,25 @@ static int mwifiex_sdio_card_to_host_mp_aggr(struct mwifiex_adapter *adapter,
 		dev_dbg(adapter->dev, "info: do_rx_aggr: num of packets: %d\n",
 			card->mpa_rx.pkt_cnt);
 
-		mport = (adapter->ioport | SDIO_MPA_ADDR_BASE |
-			 (card->mpa_rx.ports << 4)) + card->mpa_rx.start_port;
+		if (card->supports_sdio_new_mode) {
+			int i;
+			u32 port_count;
+
+			for (i = 0, port_count = 0; i < card->max_ports; i++)
+				if (card->mpa_rx.ports & BIT(i))
+					port_count++;
+
+			/* Reading data from "start_port + 0" to "start_port +
+			 * port_count -1", so decrease the count by 1
+			 */
+			port_count--;
+			mport = (adapter->ioport | SDIO_MPA_ADDR_BASE |
+				 (port_count << 8)) + card->mpa_rx.start_port;
+		} else {
+			mport = (adapter->ioport | SDIO_MPA_ADDR_BASE |
+				 (card->mpa_rx.ports << 4)) +
+				 card->mpa_rx.start_port;
+		}
 
 		if (mwifiex_read_data_sync(adapter, card->mpa_rx.buf,
 					   card->mpa_rx.buf_len, mport, 1))
@@ -1200,6 +1284,8 @@ static int mwifiex_process_int_status(struct mwifiex_adapter *adapter)
 	u32 rx_blocks;
 	u16 rx_len;
 	unsigned long flags;
+	u32 bitmap;
+	u8 cr;
 
 	spin_lock_irqsave(&adapter->int_lock, flags);
 	sdio_ireg = adapter->int_status;
@@ -1209,12 +1295,60 @@ static int mwifiex_process_int_status(struct mwifiex_adapter *adapter)
 	if (!sdio_ireg)
 		return ret;
 
+	/* Following interrupt is only for SDIO new mode */
+	if (sdio_ireg & DN_LD_CMD_PORT_HOST_INT_STATUS && adapter->cmd_sent)
+		adapter->cmd_sent = false;
+
+	/* Following interrupt is only for SDIO new mode */
+	if (sdio_ireg & UP_LD_CMD_PORT_HOST_INT_STATUS) {
+		u32 pkt_type;
+
+		/* read the len of control packet */
+		rx_len = card->mp_regs[CMD_RD_LEN_1] << 8;
+		rx_len |= (u16) card->mp_regs[CMD_RD_LEN_0];
+		rx_blocks = DIV_ROUND_UP(rx_len, MWIFIEX_SDIO_BLOCK_SIZE);
+		if (rx_len <= INTF_HEADER_LEN ||
+		    (rx_blocks * MWIFIEX_SDIO_BLOCK_SIZE) >
+		     MWIFIEX_RX_DATA_BUF_SIZE)
+			return -1;
+		rx_len = (u16) (rx_blocks * MWIFIEX_SDIO_BLOCK_SIZE);
+
+		skb = dev_alloc_skb(rx_len);
+		if (!skb)
+			return -1;
+
+		skb_put(skb, rx_len);
+
+		if (mwifiex_sdio_card_to_host(adapter, &pkt_type, skb->data,
+					      skb->len, adapter->ioport |
+							CMD_PORT_SLCT)) {
+			dev_err(adapter->dev,
+				"%s: failed to card_to_host", __func__);
+			dev_kfree_skb_any(skb);
+			goto term_cmd;
+		}
+
+		if ((pkt_type != MWIFIEX_TYPE_CMD) &&
+		    (pkt_type != MWIFIEX_TYPE_EVENT))
+			dev_err(adapter->dev,
+				"%s:Received wrong packet on cmd port",
+				__func__);
+
+		mwifiex_decode_rx_packet(adapter, skb, pkt_type);
+	}
+
 	if (sdio_ireg & DN_LD_HOST_INT_STATUS) {
-		card->mp_wr_bitmap =
-			((u32) card->mp_regs[reg->wr_bitmap_u]) << 8;
-		card->mp_wr_bitmap |=
-			(u32) card->mp_regs[reg->wr_bitmap_l];
-		dev_dbg(adapter->dev, "int: DNLD: wr_bitmap=0x%08x\n",
+		bitmap = (u32) card->mp_regs[reg->wr_bitmap_l];
+		bitmap |= ((u32) card->mp_regs[reg->wr_bitmap_u]) << 8;
+		if (card->supports_sdio_new_mode) {
+			bitmap |=
+				((u32) card->mp_regs[reg->wr_bitmap_1l]) << 16;
+			bitmap |=
+				((u32) card->mp_regs[reg->wr_bitmap_1u]) << 24;
+		}
+		card->mp_wr_bitmap = bitmap;
+
+		dev_dbg(adapter->dev, "int: DNLD: wr_bitmap=0x%x\n",
 			card->mp_wr_bitmap);
 		if (adapter->data_sent &&
 		    (card->mp_wr_bitmap & card->mp_data_port_mask)) {
@@ -1227,7 +1361,7 @@ static int mwifiex_process_int_status(struct mwifiex_adapter *adapter)
 	/* As firmware will not generate download ready interrupt if the port
 	   updated is command port only, cmd_sent should be done for any SDIO
 	   interrupt. */
-	if (adapter->cmd_sent) {
+	if (card->has_control_mask && adapter->cmd_sent) {
 		/* Check if firmware has attach buffer at command port and
 		   update just that in wr_bit_map. */
 		card->mp_wr_bitmap |=
@@ -1239,10 +1373,16 @@ static int mwifiex_process_int_status(struct mwifiex_adapter *adapter)
 	dev_dbg(adapter->dev, "info: cmd_sent=%d data_sent=%d\n",
 		adapter->cmd_sent, adapter->data_sent);
 	if (sdio_ireg & UP_LD_HOST_INT_STATUS) {
-		card->mp_rd_bitmap =
-			((u32) card->mp_regs[reg->rd_bitmap_u]) << 8;
-		card->mp_rd_bitmap |= (u32) card->mp_regs[reg->rd_bitmap_l];
-		dev_dbg(adapter->dev, "int: UPLD: rd_bitmap=0x%08x\n",
+		bitmap = (u32) card->mp_regs[reg->rd_bitmap_l];
+		bitmap |= ((u32) card->mp_regs[reg->rd_bitmap_u]) << 8;
+		if (card->supports_sdio_new_mode) {
+			bitmap |=
+				((u32) card->mp_regs[reg->rd_bitmap_1l]) << 16;
+			bitmap |=
+				((u32) card->mp_regs[reg->rd_bitmap_1u]) << 24;
+		}
+		card->mp_rd_bitmap = bitmap;
+		dev_dbg(adapter->dev, "int: UPLD: rd_bitmap=0x%x\n",
 			card->mp_rd_bitmap);
 
 		while (true) {
@@ -1285,37 +1425,33 @@ static int mwifiex_process_int_status(struct mwifiex_adapter *adapter)
 
 			if (mwifiex_sdio_card_to_host_mp_aggr(adapter, skb,
 							      port)) {
-				u8 cr = 0;
-
 				dev_err(adapter->dev, "card_to_host_mpa failed:"
 					" int status=%#x\n", sdio_ireg);
-				if (mwifiex_read_reg(adapter,
-						     CONFIGURATION_REG, &cr))
-					dev_err(adapter->dev,
-						"read CFG reg failed\n");
-
-				dev_dbg(adapter->dev,
-					"info: CFG reg val = %d\n", cr);
-				if (mwifiex_write_reg(adapter,
-						      CONFIGURATION_REG,
-						      (cr | 0x04)))
-					dev_err(adapter->dev,
-						"write CFG reg failed\n");
-
-				dev_dbg(adapter->dev, "info: write success\n");
-				if (mwifiex_read_reg(adapter,
-						     CONFIGURATION_REG, &cr))
-					dev_err(adapter->dev,
-						"read CFG reg failed\n");
-
-				dev_dbg(adapter->dev,
-					"info: CFG reg val =%x\n", cr);
-				return -1;
+				goto term_cmd;
 			}
 		}
 	}
 
 	return 0;
+
+term_cmd:
+	/* terminate cmd */
+	if (mwifiex_read_reg(adapter, CONFIGURATION_REG, &cr))
+		dev_err(adapter->dev, "read CFG reg failed\n");
+	else
+		dev_dbg(adapter->dev, "info: CFG reg val = %d\n", cr);
+
+	if (mwifiex_write_reg(adapter, CONFIGURATION_REG, (cr | 0x04)))
+		dev_err(adapter->dev, "write CFG reg failed\n");
+	else
+		dev_dbg(adapter->dev, "info: write success\n");
+
+	if (mwifiex_read_reg(adapter, CONFIGURATION_REG, &cr))
+		dev_err(adapter->dev, "read CFG reg failed\n");
+	else
+		dev_dbg(adapter->dev, "info: CFG reg val =%x\n", cr);
+
+	return -1;
 }
 
 /*
@@ -1344,7 +1480,9 @@ static int mwifiex_host_to_card_mp_aggr(struct mwifiex_adapter *adapter,
 	s32 f_postcopy_cur_buf = 0;
 	u32 mport;
 
-	if ((!card->mpa_tx.enabled) || (port == CTRL_PORT)) {
+	if (!card->mpa_tx.enabled ||
+	    (card->has_control_mask && (port == CTRL_PORT)) ||
+	    (card->supports_sdio_new_mode && (port == CMD_PORT_SLCT))) {
 		dev_dbg(adapter->dev, "info: %s: tx aggregation disabled\n",
 			__func__);
 
@@ -1419,8 +1557,26 @@ static int mwifiex_host_to_card_mp_aggr(struct mwifiex_adapter *adapter,
 		dev_dbg(adapter->dev, "data: %s: send aggr buffer: %d %d\n",
 			__func__,
 				card->mpa_tx.start_port, card->mpa_tx.ports);
-		mport = (adapter->ioport | SDIO_MPA_ADDR_BASE |
-			 (card->mpa_tx.ports << 4)) + card->mpa_tx.start_port;
+		if (card->supports_sdio_new_mode) {
+			u32 port_count;
+			int i;
+
+			for (i = 0, port_count = 0; i < card->max_ports; i++)
+				if (card->mpa_tx.ports & BIT(i))
+					port_count++;
+
+			/* Writing data from "start_port + 0" to "start_port +
+			 * port_count -1", so decrease the count by 1
+			 */
+			port_count--;
+			mport = (adapter->ioport | SDIO_MPA_ADDR_BASE |
+				 (port_count << 8)) + card->mpa_tx.start_port;
+		} else {
+			mport = (adapter->ioport | SDIO_MPA_ADDR_BASE |
+				 (card->mpa_tx.ports << 4)) +
+				 card->mpa_tx.start_port;
+		}
+
 		ret = mwifiex_write_data_to_card(adapter, card->mpa_tx.buf,
 						 card->mpa_tx.buf_len, mport);
 
@@ -1493,6 +1649,9 @@ static int mwifiex_sdio_host_to_card(struct mwifiex_adapter *adapter,
 		    pkt_len > MWIFIEX_UPLD_SIZE)
 			dev_err(adapter->dev, "%s: payload=%p, nb=%d\n",
 				__func__, payload, pkt_len);
+
+		if (card->supports_sdio_new_mode)
+			port = CMD_PORT_SLCT;
 	}
 
 	/* Transfer data to card */
@@ -1748,8 +1907,11 @@ mwifiex_update_mp_end_port(struct mwifiex_adapter *adapter, u16 port)
 
 	card->mp_data_port_mask = reg->data_port_mask;
 
-	for (i = 1; i <= card->max_ports - card->mp_end_port; i++)
-		card->mp_data_port_mask &= ~(1 << (card->max_ports - i));
+	if (reg->start_wr_port) {
+		for (i = 1; i <= card->max_ports - card->mp_end_port; i++)
+			card->mp_data_port_mask &=
+					~(1 << (card->max_ports - i));
+	}
 
 	card->curr_wr_port = reg->start_wr_port;
 
@@ -1857,3 +2019,4 @@ MODULE_LICENSE("GPL v2");
 MODULE_FIRMWARE(SD8786_DEFAULT_FW_NAME);
 MODULE_FIRMWARE(SD8787_DEFAULT_FW_NAME);
 MODULE_FIRMWARE(SD8797_DEFAULT_FW_NAME);
+MODULE_FIRMWARE(SD8897_DEFAULT_FW_NAME);
diff --git a/drivers/net/wireless/mwifiex/sdio.h b/drivers/net/wireless/mwifiex/sdio.h
index 597db37..6d51dfd 100644
--- a/drivers/net/wireless/mwifiex/sdio.h
+++ b/drivers/net/wireless/mwifiex/sdio.h
@@ -32,6 +32,7 @@
 #define SD8786_DEFAULT_FW_NAME "mrvl/sd8786_uapsta.bin"
 #define SD8787_DEFAULT_FW_NAME "mrvl/sd8787_uapsta.bin"
 #define SD8797_DEFAULT_FW_NAME "mrvl/sd8797_uapsta.bin"
+#define SD8897_DEFAULT_FW_NAME "mrvl/sd8897_uapsta.bin"
 
 #define BLOCK_MODE	1
 #define BYTE_MODE	0
@@ -46,6 +47,23 @@
 #define CTRL_PORT			0
 #define CTRL_PORT_MASK			0x0001
 
+#define CMD_PORT_UPLD_INT_MASK		(0x1U<<6)
+#define CMD_PORT_DNLD_INT_MASK		(0x1U<<7)
+#define HOST_TERM_CMD53			(0x1U << 2)
+#define REG_PORT			0
+#define MEM_PORT			0x10000
+#define CMD_RD_LEN_0			0xB4
+#define CMD_RD_LEN_1			0xB5
+#define CARD_CONFIG_2_1_REG             0xCD
+#define CMD53_NEW_MODE			(0x1U << 0)
+#define CMD_CONFIG_0			0xB8
+#define CMD_PORT_RD_LEN_EN		(0x1U << 2)
+#define CMD_CONFIG_1			0xB9
+#define CMD_PORT_AUTO_EN		(0x1U << 0)
+#define CMD_PORT_SLCT			0x8000
+#define UP_LD_CMD_PORT_HOST_INT_STATUS	(0x40U)
+#define DN_LD_CMD_PORT_HOST_INT_STATUS	(0x80U)
+
 #define SDIO_MP_TX_AGGR_DEF_BUF_SIZE        (8192)	/* 8K */
 
 /* Multi port RX aggregation buffer size */
@@ -73,6 +91,7 @@
 #define UP_LD_HOST_INT_MASK		(0x1U)
 /* Host Control Registers : Download host interrupt mask */
 #define DN_LD_HOST_INT_MASK		(0x2U)
+
 /* Disable Host interrupt mask */
 #define	HOST_INT_DISABLE		0xff
 
@@ -196,8 +215,12 @@ struct mwifiex_sdio_card_reg {
 	u8 max_mp_regs;
 	u8 rd_bitmap_l;
 	u8 rd_bitmap_u;
+	u8 rd_bitmap_1l;
+	u8 rd_bitmap_1u;
 	u8 wr_bitmap_l;
 	u8 wr_bitmap_u;
+	u8 wr_bitmap_1l;
+	u8 wr_bitmap_1u;
 	u8 rd_len_p0_l;
 	u8 rd_len_p0_u;
 	u8 card_misc_cfg_reg;
@@ -211,6 +234,8 @@ struct sdio_mmc_card {
 	const struct mwifiex_sdio_card_reg *reg;
 	u8 max_ports;
 	u8 mp_agg_pkt_limit;
+	bool supports_sdio_new_mode;
+	bool has_control_mask;
 
 	u32 mp_rd_bitmap;
 	u32 mp_wr_bitmap;
@@ -232,6 +257,8 @@ struct mwifiex_sdio_device {
 	const struct mwifiex_sdio_card_reg *reg;
 	u8 max_ports;
 	u8 mp_agg_pkt_limit;
+	bool supports_sdio_new_mode;
+	bool has_control_mask;
 };
 
 static const struct mwifiex_sdio_card_reg mwifiex_reg_sd87xx = {
@@ -255,11 +282,39 @@ static const struct mwifiex_sdio_card_reg mwifiex_reg_sd87xx = {
 	.card_misc_cfg_reg = 0x6c,
 };
 
+static const struct mwifiex_sdio_card_reg mwifiex_reg_sd8897 = {
+	.start_rd_port = 0,
+	.start_wr_port = 0,
+	.base_0_reg = 0x60,
+	.base_1_reg = 0x61,
+	.poll_reg = 0x50,
+	.host_int_enable = UP_LD_HOST_INT_MASK | DN_LD_HOST_INT_MASK |
+			CMD_PORT_UPLD_INT_MASK | CMD_PORT_DNLD_INT_MASK,
+	.status_reg_0 = 0xc0,
+	.status_reg_1 = 0xc1,
+	.sdio_int_mask = 0xff,
+	.data_port_mask = 0xffffffff,
+	.max_mp_regs = 184,
+	.rd_bitmap_l = 0x04,
+	.rd_bitmap_u = 0x05,
+	.rd_bitmap_1l = 0x06,
+	.rd_bitmap_1u = 0x07,
+	.wr_bitmap_l = 0x08,
+	.wr_bitmap_u = 0x09,
+	.wr_bitmap_1l = 0x0a,
+	.wr_bitmap_1u = 0x0b,
+	.rd_len_p0_l = 0x0c,
+	.rd_len_p0_u = 0x0d,
+	.card_misc_cfg_reg = 0xcc,
+};
+
 static const struct mwifiex_sdio_device mwifiex_sdio_sd8786 = {
 	.firmware = SD8786_DEFAULT_FW_NAME,
 	.reg = &mwifiex_reg_sd87xx,
 	.max_ports = 16,
 	.mp_agg_pkt_limit = 8,
+	.supports_sdio_new_mode = false,
+	.has_control_mask = true,
 };
 
 static const struct mwifiex_sdio_device mwifiex_sdio_sd8787 = {
@@ -267,6 +322,8 @@ static const struct mwifiex_sdio_device mwifiex_sdio_sd8787 = {
 	.reg = &mwifiex_reg_sd87xx,
 	.max_ports = 16,
 	.mp_agg_pkt_limit = 8,
+	.supports_sdio_new_mode = false,
+	.has_control_mask = true,
 };
 
 static const struct mwifiex_sdio_device mwifiex_sdio_sd8797 = {
@@ -274,6 +331,17 @@ static const struct mwifiex_sdio_device mwifiex_sdio_sd8797 = {
 	.reg = &mwifiex_reg_sd87xx,
 	.max_ports = 16,
 	.mp_agg_pkt_limit = 8,
+	.supports_sdio_new_mode = false,
+	.has_control_mask = true,
+};
+
+static const struct mwifiex_sdio_device mwifiex_sdio_sd8897 = {
+	.firmware = SD8897_DEFAULT_FW_NAME,
+	.reg = &mwifiex_reg_sd8897,
+	.max_ports = 32,
+	.mp_agg_pkt_limit = 16,
+	.supports_sdio_new_mode = true,
+	.has_control_mask = false,
 };
 
 /*
@@ -302,13 +370,23 @@ mp_rx_aggr_port_limit_reached(struct sdio_mmc_card *card)
 	u8 tmp;
 
 	if (card->curr_rd_port < card->mpa_rx.start_port) {
-		tmp = card->mp_agg_pkt_limit;
+		if (card->supports_sdio_new_mode)
+			tmp = card->mp_end_port >> 1;
+		else
+			tmp = card->mp_agg_pkt_limit;
 
 		if (((card->max_ports - card->mpa_rx.start_port) +
 		    card->curr_rd_port) >= tmp)
 			return true;
 	}
 
+	if (!card->supports_sdio_new_mode)
+		return false;
+
+	if ((card->curr_rd_port - card->mpa_rx.start_port) >=
+	    (card->mp_end_port >> 1))
+		return true;
+
 	return false;
 }
 
@@ -318,13 +396,23 @@ mp_tx_aggr_port_limit_reached(struct sdio_mmc_card *card)
 	u16 tmp;
 
 	if (card->curr_wr_port < card->mpa_tx.start_port) {
-		tmp = card->mp_agg_pkt_limit;
+		if (card->supports_sdio_new_mode)
+			tmp = card->mp_end_port >> 1;
+		else
+			tmp = card->mp_agg_pkt_limit;
 
 		if (((card->max_ports - card->mpa_tx.start_port) +
 		    card->curr_wr_port) >= tmp)
 			return true;
 	}
 
+	if (!card->supports_sdio_new_mode)
+		return false;
+
+	if ((card->curr_wr_port - card->mpa_tx.start_port) >=
+	    (card->mp_end_port >> 1))
+		return true;
+
 	return false;
 }
 
@@ -337,11 +425,14 @@ static inline void mp_rx_aggr_setup(struct sdio_mmc_card *card,
 	if (!card->mpa_rx.pkt_cnt)
 		card->mpa_rx.start_port = port;
 
-	if (card->mpa_rx.start_port <= port)
-		card->mpa_rx.ports |= 1 << (card->mpa_rx.pkt_cnt);
-	else
-		card->mpa_rx.ports |= 1 << (card->mpa_rx.pkt_cnt + 1);
-
+	if (card->supports_sdio_new_mode) {
+		card->mpa_rx.ports |= (1 << port);
+	} else {
+		if (card->mpa_rx.start_port <= port)
+			card->mpa_rx.ports |= 1 << (card->mpa_rx.pkt_cnt);
+		else
+			card->mpa_rx.ports |= 1 << (card->mpa_rx.pkt_cnt + 1);
+	}
 	card->mpa_rx.skb_arr[card->mpa_rx.pkt_cnt] = skb;
 	card->mpa_rx.len_arr[card->mpa_rx.pkt_cnt] = skb->len;
 	card->mpa_rx.pkt_cnt++;
-- 
1.8.2.3


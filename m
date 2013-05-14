Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog136.obsmtp.com ([74.125.149.85]:56492 "EHLO
	na3sys009aog136.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755499Ab3ENBPr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 May 2013 21:15:47 -0400
From: Bing Zhao <bzhao@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: "John W. Linville" <linville@tuxdriver.com>,
	Daniel Drake <dsd@laptop.org>, Paul Fox <pgf@laptop.org>,
	Tim Shepard <shep@laptop.org>,
	Jason Abele <jabele@chromium.org>,
	John Rhodes <jrhodes@marvell.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Yogesh Ashok Powar <yogeshp@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH 10/17] mwifiex: store SDIO chip specific information in separate structure
Date: Mon, 13 May 2013 18:14:54 -0700
Message-ID: <1368494101-23651-11-git-send-email-bzhao@marvell.com> (sfid-20130514_031550_622828_DA4852C6)
In-Reply-To: <1368494101-23651-1-git-send-email-bzhao@marvell.com>
References: <1368494101-23651-1-git-send-email-bzhao@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Amitkumar Karwar <akarwar@marvell.com>

Register addresses, firmware name and some macros are specific to
a chip. They are stored in a new structure.

Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/sdio.c | 116 +++++++++++++++++++++---------------
 drivers/net/wireless/mwifiex/sdio.h | 114 +++++++++++++++++++++++++----------
 2 files changed, 149 insertions(+), 81 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/sdio.c b/drivers/net/wireless/mwifiex/sdio.c
index 7368ee1..022e9fd 100644
--- a/drivers/net/wireless/mwifiex/sdio.c
+++ b/drivers/net/wireless/mwifiex/sdio.c
@@ -77,6 +77,15 @@ mwifiex_sdio_probe(struct sdio_func *func, const struct sdio_device_id *id)
 
 	func->card->quirks |= MMC_QUIRK_BLKSZ_FOR_BYTE_MODE;
 
+	if (id->driver_data) {
+		struct mwifiex_sdio_device *data = (void *)id->driver_data;
+
+		card->firmware = data->firmware;
+		card->reg = data->reg;
+		card->max_ports = data->max_ports;
+		card->mp_agg_pkt_limit = data->mp_agg_pkt_limit;
+	}
+
 	sdio_claim_host(func);
 	ret = sdio_enable_func(func);
 	sdio_release_host(func);
@@ -254,9 +263,12 @@ static int mwifiex_sdio_resume(struct device *dev)
 
 /* WLAN IDs */
 static const struct sdio_device_id mwifiex_ids[] = {
-	{SDIO_DEVICE(SDIO_VENDOR_ID_MARVELL, SDIO_DEVICE_ID_MARVELL_8786)},
-	{SDIO_DEVICE(SDIO_VENDOR_ID_MARVELL, SDIO_DEVICE_ID_MARVELL_8787)},
-	{SDIO_DEVICE(SDIO_VENDOR_ID_MARVELL, SDIO_DEVICE_ID_MARVELL_8797)},
+	{SDIO_DEVICE(SDIO_VENDOR_ID_MARVELL, SDIO_DEVICE_ID_MARVELL_8786),
+		.driver_data = (unsigned long) &mwifiex_sdio_sd8786},
+	{SDIO_DEVICE(SDIO_VENDOR_ID_MARVELL, SDIO_DEVICE_ID_MARVELL_8787),
+		.driver_data = (unsigned long) &mwifiex_sdio_sd8787},
+	{SDIO_DEVICE(SDIO_VENDOR_ID_MARVELL, SDIO_DEVICE_ID_MARVELL_8797),
+		.driver_data = (unsigned long) &mwifiex_sdio_sd8797},
 	{},
 };
 
@@ -410,6 +422,7 @@ static int mwifiex_pm_wakeup_card_complete(struct mwifiex_adapter *adapter)
 static int mwifiex_init_sdio_ioport(struct mwifiex_adapter *adapter)
 {
 	u32 reg;
+	struct sdio_mmc_card *card = adapter->card;
 
 	adapter->ioport = 0;
 
@@ -434,13 +447,13 @@ static int mwifiex_init_sdio_ioport(struct mwifiex_adapter *adapter)
 	/* Set Host interrupt reset to read to clear */
 	if (!mwifiex_read_reg(adapter, HOST_INT_RSR_REG, &reg))
 		mwifiex_write_reg(adapter, HOST_INT_RSR_REG,
-				  reg | SDIO_INT_MASK);
+				  reg | card->reg->sdio_int_mask);
 	else
 		return -1;
 
 	/* Dnld/Upld ready set to auto reset */
-	if (!mwifiex_read_reg(adapter, CARD_MISC_CFG_REG, &reg))
-		mwifiex_write_reg(adapter, CARD_MISC_CFG_REG,
+	if (!mwifiex_read_reg(adapter, card->reg->card_misc_cfg_reg, &reg))
+		mwifiex_write_reg(adapter, card->reg->card_misc_cfg_reg,
 				  reg | AUTO_RE_ENABLE_INT);
 	else
 		return -1;
@@ -486,11 +499,12 @@ static int mwifiex_write_data_to_card(struct mwifiex_adapter *adapter,
 static int mwifiex_get_rd_port(struct mwifiex_adapter *adapter, u8 *port)
 {
 	struct sdio_mmc_card *card = adapter->card;
+	const struct mwifiex_sdio_card_reg *reg = card->reg;
 	u32 rd_bitmap = card->mp_rd_bitmap;
 
 	dev_dbg(adapter->dev, "data: mp_rd_bitmap=0x%08x\n", rd_bitmap);
 
-	if (!(rd_bitmap & (CTRL_PORT_MASK | DATA_PORT_MASK)))
+	if (!(rd_bitmap & (CTRL_PORT_MASK | reg->data_port_mask)))
 		return -1;
 
 	if (card->mp_rd_bitmap & CTRL_PORT_MASK) {
@@ -504,8 +518,8 @@ static int mwifiex_get_rd_port(struct mwifiex_adapter *adapter, u8 *port)
 						(~(1 << card->curr_rd_port));
 			*port = card->curr_rd_port;
 
-			if (++card->curr_rd_port == MAX_PORT)
-				card->curr_rd_port = 1;
+			if (++card->curr_rd_port == card->max_ports)
+				card->curr_rd_port = reg->start_rd_port;
 		} else {
 			return -1;
 		}
@@ -538,7 +552,7 @@ static int mwifiex_get_wr_port_data(struct mwifiex_adapter *adapter, u8 *port)
 		card->mp_wr_bitmap &= (u32) (~(1 << card->curr_wr_port));
 		*port = card->curr_wr_port;
 		if (++card->curr_wr_port == card->mp_end_port)
-			card->curr_wr_port = 1;
+			card->curr_wr_port = card->reg->start_wr_port;
 	} else {
 		adapter->data_sent = true;
 		return -EBUSY;
@@ -564,11 +578,12 @@ static int mwifiex_get_wr_port_data(struct mwifiex_adapter *adapter, u8 *port)
 static int
 mwifiex_sdio_poll_card_status(struct mwifiex_adapter *adapter, u8 bits)
 {
+	struct sdio_mmc_card *card = adapter->card;
 	u32 tries;
 	u32 cs;
 
 	for (tries = 0; tries < MAX_POLL_TRIES; tries++) {
-		if (mwifiex_read_reg(adapter, CARD_STATUS_REG, &cs))
+		if (mwifiex_read_reg(adapter, card->reg->poll_reg, &cs))
 			break;
 		else if ((cs & bits) == bits)
 			return 0;
@@ -587,12 +602,14 @@ mwifiex_sdio_poll_card_status(struct mwifiex_adapter *adapter, u8 bits)
 static int
 mwifiex_sdio_read_fw_status(struct mwifiex_adapter *adapter, u16 *dat)
 {
+	struct sdio_mmc_card *card = adapter->card;
+	const struct mwifiex_sdio_card_reg *reg = card->reg;
 	u32 fws0, fws1;
 
-	if (mwifiex_read_reg(adapter, CARD_FW_STATUS0_REG, &fws0))
+	if (mwifiex_read_reg(adapter, reg->status_reg_0, &fws0))
 		return -1;
 
-	if (mwifiex_read_reg(adapter, CARD_FW_STATUS1_REG, &fws1))
+	if (mwifiex_read_reg(adapter, reg->status_reg_1, &fws1))
 		return -1;
 
 	*dat = (u16) ((fws1 << 8) | fws0);
@@ -633,8 +650,11 @@ static int mwifiex_sdio_disable_host_int(struct mwifiex_adapter *adapter)
  */
 static int mwifiex_sdio_enable_host_int(struct mwifiex_adapter *adapter)
 {
+	struct sdio_mmc_card *card = adapter->card;
+
 	/* Simply write the mask to the register */
-	if (mwifiex_write_reg(adapter, HOST_INT_MASK_REG, HOST_INT_ENABLE)) {
+	if (mwifiex_write_reg(adapter, HOST_INT_MASK_REG,
+			      card->reg->host_int_enable)) {
 		dev_err(adapter->dev, "enable host interrupt failed\n");
 		return -1;
 	}
@@ -686,6 +706,8 @@ static int mwifiex_sdio_card_to_host(struct mwifiex_adapter *adapter,
 static int mwifiex_prog_fw_w_helper(struct mwifiex_adapter *adapter,
 				    struct mwifiex_fw_image *fw)
 {
+	struct sdio_mmc_card *card = adapter->card;
+	const struct mwifiex_sdio_card_reg *reg = card->reg;
 	int ret;
 	u8 *firmware = fw->fw_buf;
 	u32 firmware_len = fw->fw_len;
@@ -727,7 +749,7 @@ static int mwifiex_prog_fw_w_helper(struct mwifiex_adapter *adapter,
 			break;
 
 		for (tries = 0; tries < MAX_POLL_TRIES; tries++) {
-			ret = mwifiex_read_reg(adapter, HOST_F1_RD_BASE_0,
+			ret = mwifiex_read_reg(adapter, reg->base_0_reg,
 					       &base0);
 			if (ret) {
 				dev_err(adapter->dev,
@@ -736,7 +758,7 @@ static int mwifiex_prog_fw_w_helper(struct mwifiex_adapter *adapter,
 					base0, base0);
 				goto done;
 			}
-			ret = mwifiex_read_reg(adapter, HOST_F1_RD_BASE_1,
+			ret = mwifiex_read_reg(adapter, reg->base_1_reg,
 					       &base1);
 			if (ret) {
 				dev_err(adapter->dev,
@@ -828,6 +850,7 @@ done:
 static int mwifiex_check_fw_status(struct mwifiex_adapter *adapter,
 				   u32 poll_num)
 {
+	struct sdio_mmc_card *card = adapter->card;
 	int ret = 0;
 	u16 firmware_stat;
 	u32 tries;
@@ -849,7 +872,7 @@ static int mwifiex_check_fw_status(struct mwifiex_adapter *adapter,
 
 	if (ret) {
 		if (mwifiex_read_reg
-		    (adapter, CARD_FW_STATUS0_REG, &winner_status))
+		    (adapter, card->reg->status_reg_0, &winner_status))
 			winner_status = 0;
 
 		if (winner_status)
@@ -869,9 +892,9 @@ static void mwifiex_interrupt_status(struct mwifiex_adapter *adapter)
 	u32 sdio_ireg;
 	unsigned long flags;
 
-	if (mwifiex_read_data_sync(adapter, card->mp_regs, MAX_MP_REGS,
-				   REG_PORT | MWIFIEX_SDIO_BYTE_MODE_MASK,
-				   0)) {
+	if (mwifiex_read_data_sync(adapter, card->mp_regs,
+				   card->reg->max_mp_regs,
+				   REG_PORT | MWIFIEX_SDIO_BYTE_MODE_MASK, 0)) {
 		dev_err(adapter->dev, "read mp_regs failed\n");
 		return;
 	}
@@ -1167,6 +1190,7 @@ error:
 static int mwifiex_process_int_status(struct mwifiex_adapter *adapter)
 {
 	struct sdio_mmc_card *card = adapter->card;
+	const struct mwifiex_sdio_card_reg *reg = card->reg;
 	int ret = 0;
 	u8 sdio_ireg;
 	struct sk_buff *skb;
@@ -1185,8 +1209,10 @@ static int mwifiex_process_int_status(struct mwifiex_adapter *adapter)
 		return ret;
 
 	if (sdio_ireg & DN_LD_HOST_INT_STATUS) {
-		card->mp_wr_bitmap = ((u32) card->mp_regs[WR_BITMAP_U]) << 8;
-		card->mp_wr_bitmap |= (u32) card->mp_regs[WR_BITMAP_L];
+		card->mp_wr_bitmap =
+			((u32) card->mp_regs[reg->wr_bitmap_u]) << 8;
+		card->mp_wr_bitmap |=
+			(u32) card->mp_regs[reg->wr_bitmap_l];
 		dev_dbg(adapter->dev, "int: DNLD: wr_bitmap=0x%08x\n",
 			card->mp_wr_bitmap);
 		if (adapter->data_sent &&
@@ -1204,7 +1230,7 @@ static int mwifiex_process_int_status(struct mwifiex_adapter *adapter)
 		/* Check if firmware has attach buffer at command port and
 		   update just that in wr_bit_map. */
 		card->mp_wr_bitmap |=
-			(u32) card->mp_regs[WR_BITMAP_L] & CTRL_PORT_MASK;
+			(u32) card->mp_regs[reg->wr_bitmap_l] & CTRL_PORT_MASK;
 		if (card->mp_wr_bitmap & CTRL_PORT_MASK)
 			adapter->cmd_sent = false;
 	}
@@ -1212,8 +1238,9 @@ static int mwifiex_process_int_status(struct mwifiex_adapter *adapter)
 	dev_dbg(adapter->dev, "info: cmd_sent=%d data_sent=%d\n",
 		adapter->cmd_sent, adapter->data_sent);
 	if (sdio_ireg & UP_LD_HOST_INT_STATUS) {
-		card->mp_rd_bitmap = ((u32) card->mp_regs[RD_BITMAP_U]) << 8;
-		card->mp_rd_bitmap |= (u32) card->mp_regs[RD_BITMAP_L];
+		card->mp_rd_bitmap =
+			((u32) card->mp_regs[reg->rd_bitmap_u]) << 8;
+		card->mp_rd_bitmap |= (u32) card->mp_regs[reg->rd_bitmap_l];
 		dev_dbg(adapter->dev, "int: UPLD: rd_bitmap=0x%08x\n",
 			card->mp_rd_bitmap);
 
@@ -1224,8 +1251,8 @@ static int mwifiex_process_int_status(struct mwifiex_adapter *adapter)
 					"info: no more rd_port available\n");
 				break;
 			}
-			len_reg_l = RD_LEN_P0_L + (port << 1);
-			len_reg_u = RD_LEN_P0_U + (port << 1);
+			len_reg_l = reg->rd_len_p0_l + (port << 1);
+			len_reg_u = reg->rd_len_p0_u + (port << 1);
 			rx_len = ((u16) card->mp_regs[len_reg_u]) << 8;
 			rx_len |= (u16) card->mp_regs[len_reg_l];
 			dev_dbg(adapter->dev, "info: RX: port=%d rx_len=%u\n",
@@ -1586,18 +1613,7 @@ static int mwifiex_register_dev(struct mwifiex_adapter *adapter)
 
 	adapter->dev = &func->dev;
 
-	switch (func->device) {
-	case SDIO_DEVICE_ID_MARVELL_8786:
-		strcpy(adapter->fw_name, SD8786_DEFAULT_FW_NAME);
-		break;
-	case SDIO_DEVICE_ID_MARVELL_8797:
-		strcpy(adapter->fw_name, SD8797_DEFAULT_FW_NAME);
-		break;
-	case SDIO_DEVICE_ID_MARVELL_8787:
-	default:
-		strcpy(adapter->fw_name, SD8787_DEFAULT_FW_NAME);
-		break;
-	}
+	strcpy(adapter->fw_name, card->firmware);
 
 	return 0;
 
@@ -1626,6 +1642,7 @@ disable_func:
 static int mwifiex_init_sdio(struct mwifiex_adapter *adapter)
 {
 	struct sdio_mmc_card *card = adapter->card;
+	const struct mwifiex_sdio_card_reg *reg = card->reg;
 	int ret;
 	u32 sdio_ireg;
 
@@ -1645,27 +1662,27 @@ static int mwifiex_init_sdio(struct mwifiex_adapter *adapter)
 	/* Initialize SDIO variables in card */
 	card->mp_rd_bitmap = 0;
 	card->mp_wr_bitmap = 0;
-	card->curr_rd_port = 1;
-	card->curr_wr_port = 1;
+	card->curr_rd_port = reg->start_rd_port;
+	card->curr_wr_port = reg->start_wr_port;
 
-	card->mp_data_port_mask = DATA_PORT_MASK;
+	card->mp_data_port_mask = reg->data_port_mask;
 
 	card->mpa_tx.buf_len = 0;
 	card->mpa_tx.pkt_cnt = 0;
 	card->mpa_tx.start_port = 0;
 
 	card->mpa_tx.enabled = 1;
-	card->mpa_tx.pkt_aggr_limit = SDIO_MP_AGGR_DEF_PKT_LIMIT;
+	card->mpa_tx.pkt_aggr_limit = card->mp_agg_pkt_limit;
 
 	card->mpa_rx.buf_len = 0;
 	card->mpa_rx.pkt_cnt = 0;
 	card->mpa_rx.start_port = 0;
 
 	card->mpa_rx.enabled = 1;
-	card->mpa_rx.pkt_aggr_limit = SDIO_MP_AGGR_DEF_PKT_LIMIT;
+	card->mpa_rx.pkt_aggr_limit = card->mp_agg_pkt_limit;
 
 	/* Allocate buffers for SDIO MP-A */
-	card->mp_regs = kzalloc(MAX_MP_REGS, GFP_KERNEL);
+	card->mp_regs = kzalloc(reg->max_mp_regs, GFP_KERNEL);
 	if (!card->mp_regs)
 		return -ENOMEM;
 
@@ -1716,16 +1733,17 @@ static void
 mwifiex_update_mp_end_port(struct mwifiex_adapter *adapter, u16 port)
 {
 	struct sdio_mmc_card *card = adapter->card;
+	const struct mwifiex_sdio_card_reg *reg = card->reg;
 	int i;
 
 	card->mp_end_port = port;
 
-	card->mp_data_port_mask = DATA_PORT_MASK;
+	card->mp_data_port_mask = reg->data_port_mask;
 
-	for (i = 1; i <= MAX_PORT - card->mp_end_port; i++)
-		card->mp_data_port_mask &= ~(1 << (MAX_PORT - i));
+	for (i = 1; i <= card->max_ports - card->mp_end_port; i++)
+		card->mp_data_port_mask &= ~(1 << (card->max_ports - i));
 
-	card->curr_wr_port = 1;
+	card->curr_wr_port = reg->start_wr_port;
 
 	dev_dbg(adapter->dev, "cmd: mp_end_port %d, data port mask 0x%x\n",
 		port, card->mp_data_port_mask);
diff --git a/drivers/net/wireless/mwifiex/sdio.h b/drivers/net/wireless/mwifiex/sdio.h
index 6588069..0d931f7 100644
--- a/drivers/net/wireless/mwifiex/sdio.h
+++ b/drivers/net/wireless/mwifiex/sdio.h
@@ -37,12 +37,6 @@
 #define BYTE_MODE	0
 
 #define REG_PORT			0
-#define RD_BITMAP_L			0x04
-#define RD_BITMAP_U			0x05
-#define WR_BITMAP_L			0x06
-#define WR_BITMAP_U			0x07
-#define RD_LEN_P0_L			0x08
-#define RD_LEN_P0_U			0x09
 
 #define MWIFIEX_SDIO_IO_PORT_MASK		0xfffff
 
@@ -50,12 +44,8 @@
 
 #define CTRL_PORT			0
 #define CTRL_PORT_MASK			0x0001
-#define DATA_PORT_MASK			0xfffe
 
-#define MAX_MP_REGS			64
-#define MAX_PORT			16
-
-#define SDIO_MP_AGGR_DEF_PKT_LIMIT	8
+#define SDIO_MP_AGGR_DEF_PKT_LIMIT		8
 
 #define SDIO_MP_TX_AGGR_DEF_BUF_SIZE        (8192)	/* 8K */
 
@@ -90,8 +80,6 @@
 #define UP_LD_HOST_INT_MASK		(0x1U)
 /* Host Control Registers : Download host interrupt mask */
 #define DN_LD_HOST_INT_MASK		(0x2U)
-/* Enable Host interrupt mask */
-#define HOST_INT_ENABLE	(UP_LD_HOST_INT_MASK | DN_LD_HOST_INT_MASK)
 /* Disable Host interrupt mask */
 #define	HOST_INT_DISABLE		0xff
 
@@ -106,7 +94,6 @@
 #define HOST_INT_RSR_REG		0x01
 /* Host Control Registers : Upload host interrupt RSR */
 #define UP_LD_HOST_INT_RSR		(0x1U)
-#define SDIO_INT_MASK			0x3F
 
 /* Host Control Registers : Host interrupt status */
 #define HOST_INT_STATUS_REG		0x28
@@ -117,8 +104,6 @@
 /* Host Control Registers : Download restart */
 #define DN_LD_RESTART                   (0x1U << 0)
 
-/* Card Control Registers : Card status register */
-#define CARD_STATUS_REG                 0x30
 /* Card Control Registers : Card I/O ready */
 #define CARD_IO_READY                   (0x1U << 3)
 /* Card Control Registers : CIS card ready */
@@ -153,20 +138,9 @@
 /* Card Control Registers : Power down RSR */
 #define POWER_DOWN_RSR                  (0x1U << 3)
 
-/* Card Control Registers : Miscellaneous Configuration Register */
-#define CARD_MISC_CFG_REG               0x6C
-
-/* Host F1 read base 0 */
-#define HOST_F1_RD_BASE_0		0x0040
-/* Host F1 read base 1 */
-#define HOST_F1_RD_BASE_1		0x0041
 /* Host F1 card ready */
 #define HOST_F1_CARD_RDY		0x0020
 
-/* Firmware status 0 register */
-#define CARD_FW_STATUS0_REG		0x60
-/* Firmware status 1 register */
-#define CARD_FW_STATUS1_REG		0x61
 /* Rx length register */
 #define CARD_RX_LEN_REG			0x62
 /* Rx unit register */
@@ -192,7 +166,8 @@
 	if (a->mpa_tx.start_port <= port)				\
 		a->mpa_tx.ports |= (1<<(a->mpa_tx.pkt_cnt));		\
 	else								\
-		a->mpa_tx.ports |= (1<<(a->mpa_tx.pkt_cnt+1+(MAX_PORT -	\
+		a->mpa_tx.ports |= (1<<(a->mpa_tx.pkt_cnt+1+		\
+						(a->max_ports -	\
 						a->mp_end_port)));	\
 	a->mpa_tx.pkt_cnt++;						\
 } while (0)
@@ -203,9 +178,9 @@
 
 /* SDIO Tx aggregation port limit ? */
 #define MP_TX_AGGR_PORT_LIMIT_REACHED(a) ((a->curr_wr_port <		\
-			a->mpa_tx.start_port) && (((MAX_PORT -		\
+			a->mpa_tx.start_port) && (((a->max_ports -\
 			a->mpa_tx.start_port) + a->curr_wr_port) >=	\
-				SDIO_MP_AGGR_DEF_PKT_LIMIT))
+				a->mp_agg_pkt_limit))
 
 /* Reset SDIO Tx aggregation buffer parameters */
 #define MP_TX_AGGR_BUF_RESET(a) do {					\
@@ -221,9 +196,9 @@
 
 /* SDIO Tx aggregation port limit ? */
 #define MP_RX_AGGR_PORT_LIMIT_REACHED(a) ((a->curr_rd_port <		\
-			a->mpa_rx.start_port) && (((MAX_PORT -		\
+			a->mpa_rx.start_port) && (((a->max_ports -\
 			a->mpa_rx.start_port) + a->curr_rd_port) >=	\
-			SDIO_MP_AGGR_DEF_PKT_LIMIT))
+			a->mp_agg_pkt_limit))
 
 /* SDIO Rx aggregation in progress ? */
 #define MP_RX_AGGR_IN_PROGRESS(a) (a->mpa_rx.pkt_cnt > 0)
@@ -286,10 +261,36 @@ struct mwifiex_sdio_mpa_rx {
 int mwifiex_bus_register(void);
 void mwifiex_bus_unregister(void);
 
+struct mwifiex_sdio_card_reg {
+	u8 start_rd_port;
+	u8 start_wr_port;
+	u8 base_0_reg;
+	u8 base_1_reg;
+	u8 poll_reg;
+	u8 host_int_enable;
+	u8 status_reg_0;
+	u8 status_reg_1;
+	u8 sdio_int_mask;
+	u32 data_port_mask;
+	u8 max_mp_regs;
+	u8 rd_bitmap_l;
+	u8 rd_bitmap_u;
+	u8 wr_bitmap_l;
+	u8 wr_bitmap_u;
+	u8 rd_len_p0_l;
+	u8 rd_len_p0_u;
+	u8 card_misc_cfg_reg;
+};
+
 struct sdio_mmc_card {
 	struct sdio_func *func;
 	struct mwifiex_adapter *adapter;
 
+	const char *firmware;
+	const struct mwifiex_sdio_card_reg *reg;
+	u8 max_ports;
+	u8 mp_agg_pkt_limit;
+
 	u32 mp_rd_bitmap;
 	u32 mp_wr_bitmap;
 
@@ -305,6 +306,55 @@ struct sdio_mmc_card {
 	struct mwifiex_sdio_mpa_rx mpa_rx;
 };
 
+struct mwifiex_sdio_device {
+	const char *firmware;
+	const struct mwifiex_sdio_card_reg *reg;
+	u8 max_ports;
+	u8 mp_agg_pkt_limit;
+};
+
+static const struct mwifiex_sdio_card_reg mwifiex_reg_sd87xx = {
+	.start_rd_port = 1,
+	.start_wr_port = 1,
+	.base_0_reg = 0x0040,
+	.base_1_reg = 0x0041,
+	.poll_reg = 0x30,
+	.host_int_enable = UP_LD_HOST_INT_MASK | DN_LD_HOST_INT_MASK,
+	.status_reg_0 = 0x60,
+	.status_reg_1 = 0x61,
+	.sdio_int_mask = 0x3f,
+	.data_port_mask = 0x0000fffe,
+	.max_mp_regs = 64,
+	.rd_bitmap_l = 0x04,
+	.rd_bitmap_u = 0x05,
+	.wr_bitmap_l = 0x06,
+	.wr_bitmap_u = 0x07,
+	.rd_len_p0_l = 0x08,
+	.rd_len_p0_u = 0x09,
+	.card_misc_cfg_reg = 0x6c,
+};
+
+static const struct mwifiex_sdio_device mwifiex_sdio_sd8786 = {
+	.firmware = SD8786_DEFAULT_FW_NAME,
+	.reg = &mwifiex_reg_sd87xx,
+	.max_ports = 16,
+	.mp_agg_pkt_limit = 8,
+};
+
+static const struct mwifiex_sdio_device mwifiex_sdio_sd8787 = {
+	.firmware = SD8787_DEFAULT_FW_NAME,
+	.reg = &mwifiex_reg_sd87xx,
+	.max_ports = 16,
+	.mp_agg_pkt_limit = 8,
+};
+
+static const struct mwifiex_sdio_device mwifiex_sdio_sd8797 = {
+	.firmware = SD8797_DEFAULT_FW_NAME,
+	.reg = &mwifiex_reg_sd87xx,
+	.max_ports = 16,
+	.mp_agg_pkt_limit = 8,
+};
+
 /*
  * .cmdrsp_complete handler
  */
-- 
1.8.2.3


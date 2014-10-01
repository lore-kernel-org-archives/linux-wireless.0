Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:38231 "EHLO
	mx0a-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752578AbaJFFJ6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Oct 2014 01:09:58 -0400
From: Avinash Patil <patila@marvell.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <maithili@marvell.com>,
	<cluo@marvell.com>, <huxm@marvell.com>, <yangyang@marvell.com>,
	<akarwar@marvell.com>, Avinash Patil <patila@marvell.com>
Subject: [PATCH 1/2] mwifiex: few more register offset entries for sdio card structure
Date: Wed, 1 Oct 2014 19:40:01 +0530
Message-ID: <1412172602-12714-1-git-send-email-patila@marvell.com> (sfid-20141006_071011_429882_8312B870)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch adds some more defitions to card specific register structure
and removes static defines for these registers.

Signed-off-by: Avinash Patil <patila@marvell.com>
Signed-off-by: Cathy Luo <cluo@marvell.com>
---
 drivers/net/wireless/mwifiex/sdio.c | 39 +++++++++++++-----------
 drivers/net/wireless/mwifiex/sdio.h | 59 ++++++++++++++++++++++++-------------
 2 files changed, 59 insertions(+), 39 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/sdio.c b/drivers/net/wireless/mwifiex/sdio.c
index db9e4e3..a22e9a9 100644
--- a/drivers/net/wireless/mwifiex/sdio.c
+++ b/drivers/net/wireless/mwifiex/sdio.c
@@ -448,28 +448,31 @@ static int mwifiex_pm_wakeup_card_complete(struct mwifiex_adapter *adapter)
 static int mwifiex_init_sdio_new_mode(struct mwifiex_adapter *adapter)
 {
 	u8 reg;
+	struct sdio_mmc_card *card = adapter->card;
 
 	adapter->ioport = MEM_PORT;
 
 	/* enable sdio new mode */
-	if (mwifiex_read_reg(adapter, CARD_CONFIG_2_1_REG, &reg))
+	if (mwifiex_read_reg(adapter, card->reg->card_cfg_2_1_reg, &reg))
 		return -1;
-	if (mwifiex_write_reg(adapter, CARD_CONFIG_2_1_REG,
+	if (mwifiex_write_reg(adapter, card->reg->card_cfg_2_1_reg,
 			      reg | CMD53_NEW_MODE))
 		return -1;
 
 	/* Configure cmd port and enable reading rx length from the register */
-	if (mwifiex_read_reg(adapter, CMD_CONFIG_0, &reg))
+	if (mwifiex_read_reg(adapter, card->reg->cmd_cfg_0, &reg))
 		return -1;
-	if (mwifiex_write_reg(adapter, CMD_CONFIG_0, reg | CMD_PORT_RD_LEN_EN))
+	if (mwifiex_write_reg(adapter, card->reg->cmd_cfg_0,
+			      reg | CMD_PORT_RD_LEN_EN))
 		return -1;
 
 	/* Enable Dnld/Upld ready auto reset for cmd port after cmd53 is
 	 * completed
 	 */
-	if (mwifiex_read_reg(adapter, CMD_CONFIG_1, &reg))
+	if (mwifiex_read_reg(adapter, card->reg->cmd_cfg_1, &reg))
 		return -1;
-	if (mwifiex_write_reg(adapter, CMD_CONFIG_1, reg | CMD_PORT_AUTO_EN))
+	if (mwifiex_write_reg(adapter, card->reg->cmd_cfg_1,
+			      reg | CMD_PORT_AUTO_EN))
 		return -1;
 
 	return 0;
@@ -496,17 +499,17 @@ static int mwifiex_init_sdio_ioport(struct mwifiex_adapter *adapter)
 	}
 
 	/* Read the IO port */
-	if (!mwifiex_read_reg(adapter, IO_PORT_0_REG, &reg))
+	if (!mwifiex_read_reg(adapter, card->reg->io_port_0_reg, &reg))
 		adapter->ioport |= (reg & 0xff);
 	else
 		return -1;
 
-	if (!mwifiex_read_reg(adapter, IO_PORT_1_REG, &reg))
+	if (!mwifiex_read_reg(adapter, card->reg->io_port_1_reg, &reg))
 		adapter->ioport |= ((reg & 0xff) << 8);
 	else
 		return -1;
 
-	if (!mwifiex_read_reg(adapter, IO_PORT_2_REG, &reg))
+	if (!mwifiex_read_reg(adapter, card->reg->io_port_2_reg, &reg))
 		adapter->ioport |= ((reg & 0xff) << 16);
 	else
 		return -1;
@@ -514,8 +517,8 @@ cont:
 	pr_debug("info: SDIO FUNC1 IO port: %#x\n", adapter->ioport);
 
 	/* Set Host interrupt reset to read to clear */
-	if (!mwifiex_read_reg(adapter, HOST_INT_RSR_REG, &reg))
-		mwifiex_write_reg(adapter, HOST_INT_RSR_REG,
+	if (!mwifiex_read_reg(adapter, card->reg->host_int_rsr_reg, &reg))
+		mwifiex_write_reg(adapter, card->reg->host_int_rsr_reg,
 				  reg | card->reg->sdio_int_mask);
 	else
 		return -1;
@@ -708,7 +711,7 @@ static void mwifiex_sdio_disable_host_int(struct mwifiex_adapter *adapter)
 	struct sdio_func *func = card->func;
 
 	sdio_claim_host(func);
-	mwifiex_write_reg_locked(func, HOST_INT_MASK_REG, 0);
+	mwifiex_write_reg_locked(func, card->reg->host_int_mask_reg, 0);
 	sdio_release_irq(func);
 	sdio_release_host(func);
 }
@@ -729,7 +732,7 @@ static void mwifiex_interrupt_status(struct mwifiex_adapter *adapter)
 		return;
 	}
 
-	sdio_ireg = card->mp_regs[HOST_INTSTATUS_REG];
+	sdio_ireg = card->mp_regs[card->reg->host_int_status_reg];
 	if (sdio_ireg) {
 		/*
 		 * DN_LD_HOST_INT_STATUS and/or UP_LD_HOST_INT_STATUS
@@ -794,7 +797,7 @@ static int mwifiex_sdio_enable_host_int(struct mwifiex_adapter *adapter)
 	}
 
 	/* Simply write the mask to the register */
-	ret = mwifiex_write_reg_locked(func, HOST_INT_MASK_REG,
+	ret = mwifiex_write_reg_locked(func, card->reg->host_int_mask_reg,
 				       card->reg->host_int_enable);
 	if (ret) {
 		dev_err(adapter->dev, "enable host interrupt failed\n");
@@ -1334,8 +1337,8 @@ static int mwifiex_process_int_status(struct mwifiex_adapter *adapter)
 		u32 pkt_type;
 
 		/* read the len of control packet */
-		rx_len = card->mp_regs[CMD_RD_LEN_1] << 8;
-		rx_len |= (u16) card->mp_regs[CMD_RD_LEN_0];
+		rx_len = card->mp_regs[reg->cmd_rd_len_1] << 8;
+		rx_len |= (u16)card->mp_regs[reg->cmd_rd_len_0];
 		rx_blocks = DIV_ROUND_UP(rx_len, MWIFIEX_SDIO_BLOCK_SIZE);
 		if (rx_len <= INTF_HEADER_LEN ||
 		    (rx_blocks * MWIFIEX_SDIO_BLOCK_SIZE) >
@@ -1823,11 +1826,11 @@ static int mwifiex_init_sdio(struct mwifiex_adapter *adapter)
 	sdio_set_drvdata(card->func, card);
 
 	/*
-	 * Read the HOST_INT_STATUS_REG for ACK the first interrupt got
+	 * Read the host_int_status_reg for ACK the first interrupt got
 	 * from the bootloader. If we don't do this we get a interrupt
 	 * as soon as we register the irq.
 	 */
-	mwifiex_read_reg(adapter, HOST_INTSTATUS_REG, &sdio_ireg);
+	mwifiex_read_reg(adapter, card->reg->host_int_status_reg, &sdio_ireg);
 
 	/* Get SDIO ioport */
 	mwifiex_init_sdio_ioport(adapter);
diff --git a/drivers/net/wireless/mwifiex/sdio.h b/drivers/net/wireless/mwifiex/sdio.h
index 6b8835e..5a08ebc 100644
--- a/drivers/net/wireless/mwifiex/sdio.h
+++ b/drivers/net/wireless/mwifiex/sdio.h
@@ -52,13 +52,9 @@
 #define HOST_TERM_CMD53			(0x1U << 2)
 #define REG_PORT			0
 #define MEM_PORT			0x10000
-#define CMD_RD_LEN_0			0xB4
-#define CMD_RD_LEN_1			0xB5
-#define CARD_CONFIG_2_1_REG             0xCD
+
 #define CMD53_NEW_MODE			(0x1U << 0)
-#define CMD_CONFIG_0			0xB8
 #define CMD_PORT_RD_LEN_EN		(0x1U << 2)
-#define CMD_CONFIG_1			0xB9
 #define CMD_PORT_AUTO_EN		(0x1U << 0)
 #define CMD_PORT_SLCT			0x8000
 #define UP_LD_CMD_PORT_HOST_INT_STATUS	(0x40U)
@@ -70,38 +66,23 @@
 /* Misc. Config Register : Auto Re-enable interrupts */
 #define AUTO_RE_ENABLE_INT              BIT(4)
 
-/* Host Control Registers */
-/* Host Control Registers : I/O port 0 */
-#define IO_PORT_0_REG			0x78
-/* Host Control Registers : I/O port 1 */
-#define IO_PORT_1_REG			0x79
-/* Host Control Registers : I/O port 2 */
-#define IO_PORT_2_REG			0x7A
-
 /* Host Control Registers : Configuration */
 #define CONFIGURATION_REG		0x00
 /* Host Control Registers : Host power up */
 #define HOST_POWER_UP			(0x1U << 1)
 
-/* Host Control Registers : Host interrupt mask */
-#define HOST_INT_MASK_REG		0x02
 /* Host Control Registers : Upload host interrupt mask */
 #define UP_LD_HOST_INT_MASK		(0x1U)
 /* Host Control Registers : Download host interrupt mask */
 #define DN_LD_HOST_INT_MASK		(0x2U)
 
-/* Host Control Registers : Host interrupt status */
-#define HOST_INTSTATUS_REG		0x03
 /* Host Control Registers : Upload host interrupt status */
 #define UP_LD_HOST_INT_STATUS		(0x1U)
 /* Host Control Registers : Download host interrupt status */
 #define DN_LD_HOST_INT_STATUS		(0x2U)
 
-/* Host Control Registers : Host interrupt RSR */
-#define HOST_INT_RSR_REG		0x01
-
 /* Host Control Registers : Host interrupt status */
-#define HOST_INT_STATUS_REG		0x28
+#define CARD_INT_STATUS_REG		0x28
 
 /* Card Control Registers : Card I/O ready */
 #define CARD_IO_READY                   (0x1U << 3)
@@ -203,10 +184,16 @@ struct mwifiex_sdio_card_reg {
 	u8 base_1_reg;
 	u8 poll_reg;
 	u8 host_int_enable;
+	u8 host_int_rsr_reg;
+	u8 host_int_status_reg;
+	u8 host_int_mask_reg;
 	u8 status_reg_0;
 	u8 status_reg_1;
 	u8 sdio_int_mask;
 	u32 data_port_mask;
+	u8 io_port_0_reg;
+	u8 io_port_1_reg;
+	u8 io_port_2_reg;
 	u8 max_mp_regs;
 	u8 rd_bitmap_l;
 	u8 rd_bitmap_u;
@@ -219,6 +206,15 @@ struct mwifiex_sdio_card_reg {
 	u8 rd_len_p0_l;
 	u8 rd_len_p0_u;
 	u8 card_misc_cfg_reg;
+	u8 card_cfg_2_1_reg;
+	u8 cmd_rd_len_0;
+	u8 cmd_rd_len_1;
+	u8 cmd_rd_len_2;
+	u8 cmd_rd_len_3;
+	u8 cmd_cfg_0;
+	u8 cmd_cfg_1;
+	u8 cmd_cfg_2;
+	u8 cmd_cfg_3;
 	u8 fw_dump_ctrl;
 	u8 fw_dump_start;
 	u8 fw_dump_end;
@@ -274,10 +270,16 @@ static const struct mwifiex_sdio_card_reg mwifiex_reg_sd87xx = {
 	.base_1_reg = 0x0041,
 	.poll_reg = 0x30,
 	.host_int_enable = UP_LD_HOST_INT_MASK | DN_LD_HOST_INT_MASK,
+	.host_int_rsr_reg = 0x1,
+	.host_int_mask_reg = 0x02,
+	.host_int_status_reg = 0x03,
 	.status_reg_0 = 0x60,
 	.status_reg_1 = 0x61,
 	.sdio_int_mask = 0x3f,
 	.data_port_mask = 0x0000fffe,
+	.io_port_0_reg = 0x78,
+	.io_port_1_reg = 0x79,
+	.io_port_2_reg = 0x7A,
 	.max_mp_regs = 64,
 	.rd_bitmap_l = 0x04,
 	.rd_bitmap_u = 0x05,
@@ -296,10 +298,16 @@ static const struct mwifiex_sdio_card_reg mwifiex_reg_sd8897 = {
 	.poll_reg = 0x50,
 	.host_int_enable = UP_LD_HOST_INT_MASK | DN_LD_HOST_INT_MASK |
 			CMD_PORT_UPLD_INT_MASK | CMD_PORT_DNLD_INT_MASK,
+	.host_int_rsr_reg = 0x1,
+	.host_int_status_reg = 0x03,
+	.host_int_mask_reg = 0x02,
 	.status_reg_0 = 0xc0,
 	.status_reg_1 = 0xc1,
 	.sdio_int_mask = 0xff,
 	.data_port_mask = 0xffffffff,
+	.io_port_0_reg = 0xD8,
+	.io_port_1_reg = 0xD9,
+	.io_port_2_reg = 0xDA,
 	.max_mp_regs = 184,
 	.rd_bitmap_l = 0x04,
 	.rd_bitmap_u = 0x05,
@@ -312,6 +320,15 @@ static const struct mwifiex_sdio_card_reg mwifiex_reg_sd8897 = {
 	.rd_len_p0_l = 0x0c,
 	.rd_len_p0_u = 0x0d,
 	.card_misc_cfg_reg = 0xcc,
+	.card_cfg_2_1_reg = 0xcd,
+	.cmd_rd_len_0 = 0xb4,
+	.cmd_rd_len_1 = 0xb5,
+	.cmd_rd_len_2 = 0xb6,
+	.cmd_rd_len_3 = 0xb7,
+	.cmd_cfg_0 = 0xb8,
+	.cmd_cfg_1 = 0xb9,
+	.cmd_cfg_2 = 0xba,
+	.cmd_cfg_3 = 0xbb,
 	.fw_dump_ctrl = 0xe2,
 	.fw_dump_start = 0xe3,
 	.fw_dump_end = 0xea,
-- 
1.8.1.4


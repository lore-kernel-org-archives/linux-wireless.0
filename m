Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:41483 "EHLO
	mx0a-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754896AbaLWIO5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Dec 2014 03:14:57 -0500
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
	by mx0a-0016f401.pphosted.com (8.14.5/8.14.5) with SMTP id sBN8EkMa008334
	for <linux-wireless@vger.kernel.org>; Tue, 23 Dec 2014 00:14:57 -0800
Received: from sc-owa04.marvell.com ([199.233.58.150])
	by mx0a-0016f401.pphosted.com with ESMTP id 1rcjut133b-1
	(version=TLSv1/SSLv3 cipher=AES128-SHA bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Tue, 23 Dec 2014 00:14:57 -0800
From: Avinash Patil <patila@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: <akarwar@marvell.com>, <cluo@marvell.com>, <yangyang@marvell.com>,
	<huxm@marvell.com>, Avinash Patil <patila@marvell.com>
Subject: [PATCH 7/8] mwifiex: save sdio register values before firmware dump
Date: Tue, 23 Dec 2014 19:14:11 +0530
Message-ID: <1419342252-2702-8-git-send-email-patila@marvell.com> (sfid-20141223_091513_678840_A03DEEB6)
In-Reply-To: <1419342252-2702-1-git-send-email-patila@marvell.com>
References: <1419342252-2702-1-git-send-email-patila@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Xinming Hu <huxm@marvell.com>

This patch saves sdio registers value before firmware dump,
this can be used to find out reason for FW dump.

Signed-off-by: Xinming Hu <huxm@marvell.com>
Signed-off-by: Cathy Luo <cluo@marvell.com>
Signed-off-by: Avinash Patil <patila@marvell.com>
---
 drivers/net/wireless/mwifiex/main.c |  6 +++
 drivers/net/wireless/mwifiex/main.h |  1 +
 drivers/net/wireless/mwifiex/sdio.c | 94 +++++++++++++++++++++++++++++++++++++
 drivers/net/wireless/mwifiex/sdio.h | 26 ++++++++++
 4 files changed, 127 insertions(+)

diff --git a/drivers/net/wireless/mwifiex/main.c b/drivers/net/wireless/mwifiex/main.c
index 4edaaf4..6125d1c 100644
--- a/drivers/net/wireless/mwifiex/main.c
+++ b/drivers/net/wireless/mwifiex/main.c
@@ -884,6 +884,12 @@ void mwifiex_dump_drv_info(struct mwifiex_adapter *adapter)
 			     priv->netdev->name, priv->num_tx_timeout);
 	}
 
+	if (adapter->iface_type == MWIFIEX_SDIO) {
+		p += sprintf(p, "\n=== SDIO register DUMP===\n");
+		if (adapter->if_ops.reg_dump)
+			p += adapter->if_ops.reg_dump(adapter, p);
+	}
+
 	p += sprintf(p, "\n=== MORE DEBUG INFORMATION\n");
 	debug_info = kzalloc(sizeof(*debug_info), GFP_KERNEL);
 	if (debug_info) {
diff --git a/drivers/net/wireless/mwifiex/main.h b/drivers/net/wireless/mwifiex/main.h
index 2f085de..dd55bc1 100644
--- a/drivers/net/wireless/mwifiex/main.h
+++ b/drivers/net/wireless/mwifiex/main.h
@@ -724,6 +724,7 @@ struct mwifiex_if_ops {
 	int (*dnld_fw) (struct mwifiex_adapter *, struct mwifiex_fw_image *);
 	void (*card_reset) (struct mwifiex_adapter *);
 	void (*fw_dump)(struct mwifiex_adapter *);
+	int (*reg_dump)(struct mwifiex_adapter *, char *);
 	int (*clean_pcie_ring) (struct mwifiex_adapter *adapter);
 	void (*iface_work)(struct work_struct *work);
 	void (*submit_rem_rx_urbs)(struct mwifiex_adapter *adapter);
diff --git a/drivers/net/wireless/mwifiex/sdio.c b/drivers/net/wireless/mwifiex/sdio.c
index 6bdfe67..274a1b2 100644
--- a/drivers/net/wireless/mwifiex/sdio.c
+++ b/drivers/net/wireless/mwifiex/sdio.c
@@ -2168,6 +2168,99 @@ static void mwifiex_sdio_fw_dump(struct mwifiex_adapter *adapter)
 	schedule_work(&adapter->iface_work);
 }
 
+/* Function to dump SDIO function registers and SDIO scratch registers in case
+ * of FW crash
+ */
+static int
+mwifiex_sdio_reg_dump(struct mwifiex_adapter *adapter, char *drv_buf)
+{
+	char *p = drv_buf;
+	struct sdio_mmc_card *cardp = adapter->card;
+	int ret = 0;
+	u8 count, func, data, index = 0, size = 0;
+	u8 reg, reg_start, reg_end;
+	char buf[256], *ptr;
+
+	if (!p)
+		return 0;
+
+	dev_info(adapter->dev, "SDIO register DUMP START\n");
+
+	mwifiex_pm_wakeup_card(adapter);
+
+	sdio_claim_host(cardp->func);
+
+	for (count = 0; count < 5; count++) {
+		memset(buf, 0, sizeof(buf));
+		ptr = buf;
+
+		switch (count) {
+		case 0:
+			/* Read the registers of SDIO function0 */
+			func = count;
+			reg_start = 0;
+			reg_end = 9;
+			break;
+		case 1:
+			/* Read the registers of SDIO function1 */
+			func = count;
+			reg_start = cardp->reg->func1_dump_reg_start;
+			reg_end = cardp->reg->func1_dump_reg_end;
+			break;
+		case 2:
+			index = 0;
+			func = 1;
+			reg_start = cardp->reg->func1_spec_reg_table[index++];
+			size = cardp->reg->func1_spec_reg_num;
+			reg_end = cardp->reg->func1_spec_reg_table[size-1];
+			break;
+		default:
+			/* Read the scratch registers of SDIO function1 */
+			if (count == 4)
+				mdelay(100);
+			func = 1;
+			reg_start = cardp->reg->func1_scratch_reg;
+			reg_end = reg_start + MWIFIEX_SDIO_SCRATCH_SIZE;
+		}
+
+		if (count != 2)
+			ptr += sprintf(ptr, "SDIO Func%d (%#x-%#x): ",
+				       func, reg_start, reg_end);
+		else
+			ptr += sprintf(ptr, "SDIO Func%d: ", func);
+
+		for (reg = reg_start; reg <= reg_end;) {
+			if (func == 0)
+				data = sdio_f0_readb(cardp->func, reg, &ret);
+			else
+				data = sdio_readb(cardp->func, reg, &ret);
+
+			if (count == 2)
+				ptr += sprintf(ptr, "(%#x) ", reg);
+			if (!ret) {
+				ptr += sprintf(ptr, "%02x ", data);
+			} else {
+				ptr += sprintf(ptr, "ERR");
+				break;
+			}
+
+			if (count == 2 && reg < reg_end)
+				reg = cardp->reg->func1_spec_reg_table[index++];
+			else
+				reg++;
+		}
+
+		dev_info(adapter->dev, "%s\n", buf);
+		p += sprintf(p, "%s\n", buf);
+	}
+
+	sdio_release_host(cardp->func);
+
+	dev_info(adapter->dev, "SDIO register DUMP END\n");
+
+	return p - drv_buf;
+}
+
 static struct mwifiex_if_ops sdio_ops = {
 	.init_if = mwifiex_init_sdio,
 	.cleanup_if = mwifiex_cleanup_sdio,
@@ -2190,6 +2283,7 @@ static struct mwifiex_if_ops sdio_ops = {
 	.card_reset = mwifiex_sdio_card_reset,
 	.iface_work = mwifiex_sdio_work,
 	.fw_dump = mwifiex_sdio_fw_dump,
+	.reg_dump = mwifiex_sdio_reg_dump,
 };
 
 /*
diff --git a/drivers/net/wireless/mwifiex/sdio.h b/drivers/net/wireless/mwifiex/sdio.h
index 54c0715..895eea0 100644
--- a/drivers/net/wireless/mwifiex/sdio.h
+++ b/drivers/net/wireless/mwifiex/sdio.h
@@ -44,6 +44,9 @@
 
 #define MWIFIEX_SDIO_BYTE_MODE_MASK	0x80000000
 
+#define MWIFIEX_MAX_FUNC2_REG_NUM	13
+#define MWIFIEX_SDIO_SCRATCH_SIZE	10
+
 #define SDIO_MPA_ADDR_BASE		0x1000
 #define CTRL_PORT			0
 #define CTRL_PORT_MASK			0x0001
@@ -219,6 +222,11 @@ struct mwifiex_sdio_card_reg {
 	u8 fw_dump_ctrl;
 	u8 fw_dump_start;
 	u8 fw_dump_end;
+	u8 func1_dump_reg_start;
+	u8 func1_dump_reg_end;
+	u8 func1_scratch_reg;
+	u8 func1_spec_reg_num;
+	u8 func1_spec_reg_table[MWIFIEX_MAX_FUNC2_REG_NUM];
 };
 
 struct sdio_mmc_card {
@@ -291,6 +299,11 @@ static const struct mwifiex_sdio_card_reg mwifiex_reg_sd87xx = {
 	.rd_len_p0_l = 0x08,
 	.rd_len_p0_u = 0x09,
 	.card_misc_cfg_reg = 0x6c,
+	.func1_dump_reg_start = 0x0,
+	.func1_dump_reg_end = 0x9,
+	.func1_scratch_reg = 0x60,
+	.func1_spec_reg_num = 5,
+	.func1_spec_reg_table = {0x28, 0x30, 0x34, 0x38, 0x3c},
 };
 
 static const struct mwifiex_sdio_card_reg mwifiex_reg_sd8897 = {
@@ -335,6 +348,12 @@ static const struct mwifiex_sdio_card_reg mwifiex_reg_sd8897 = {
 	.fw_dump_ctrl = 0xe2,
 	.fw_dump_start = 0xe3,
 	.fw_dump_end = 0xea,
+	.func1_dump_reg_start = 0x0,
+	.func1_dump_reg_end = 0xb,
+	.func1_scratch_reg = 0xc0,
+	.func1_spec_reg_num = 8,
+	.func1_spec_reg_table = {0x4C, 0x50, 0x54, 0x55, 0x58,
+				 0x59, 0x5c, 0x5d},
 };
 
 static const struct mwifiex_sdio_card_reg mwifiex_reg_sd8887 = {
@@ -376,6 +395,13 @@ static const struct mwifiex_sdio_card_reg mwifiex_reg_sd8887 = {
 	.cmd_cfg_1 = 0xc5,
 	.cmd_cfg_2 = 0xc6,
 	.cmd_cfg_3 = 0xc7,
+	.func1_dump_reg_start = 0x10,
+	.func1_dump_reg_end = 0x17,
+	.func1_scratch_reg = 0x90,
+	.func1_spec_reg_num = 13,
+	.func1_spec_reg_table = {0x08, 0x58, 0x5C, 0x5D, 0x60,
+				 0x61, 0x62, 0x64, 0x65, 0x66,
+				 0x68, 0x69, 0x6a},
 };
 
 static const struct mwifiex_sdio_device mwifiex_sdio_sd8786 = {
-- 
1.8.1.4


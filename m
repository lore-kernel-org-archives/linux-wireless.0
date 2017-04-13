Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f194.google.com ([209.85.192.194]:36821 "EHLO
        mail-pf0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751323AbdDMGsd (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 13 Apr 2017 02:48:33 -0400
Received: by mail-pf0-f194.google.com with SMTP id i5so8821491pfc.3
        for <linux-wireless@vger.kernel.org>; Wed, 12 Apr 2017 23:48:33 -0700 (PDT)
From: Xinming Hu <huxinming820@gmail.com>
To: Linux Wireless <linux-wireless@vger.kernel.org>
Cc: Kalle Valo <kvalo@qca.qualcomm.com>,
        Brian Norris <briannorris@google.com>,
        Dmitry Torokhov <dtor@google.com>, rajatja@google.com,
        Amitkumar Karwar <akarwar@marvell.com>,
        Cathy Luo <cluo@marvell.com>, Xinming Hu <huxm@marvell.com>
Subject: [PATCH v4 3/4] mwifiex: pcie: correct scratch register name
Date: Thu, 13 Apr 2017 06:48:21 +0000
Message-Id: <1492066102-31251-3-git-send-email-huxinming820@gmail.com> (sfid-20170413_084839_800606_AD48D5F2)
In-Reply-To: <1492066102-31251-1-git-send-email-huxinming820@gmail.com>
References: <1492066102-31251-1-git-send-email-huxinming820@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Xinming Hu <huxm@marvell.com>

This patch correct pcie scratch register name, to keep the same with
chipset side definition.

Signed-off-by: Xinming Hu <huxm@marvell.com>
---
v2: code clean and prepare for next patch 4/4
v4: same as v2, v3
---
 drivers/net/wireless/marvell/mwifiex/pcie.c |  4 ++--
 drivers/net/wireless/marvell/mwifiex/pcie.h | 13 +++++++------
 2 files changed, 9 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/pcie.c b/drivers/net/wireless/marvell/mwifiex/pcie.c
index f45ab12..a07cb0a 100644
--- a/drivers/net/wireless/marvell/mwifiex/pcie.c
+++ b/drivers/net/wireless/marvell/mwifiex/pcie.c
@@ -2494,8 +2494,8 @@ static int mwifiex_pcie_host_to_card(struct mwifiex_adapter *adapter, u8 type,
 	struct pcie_service_card *card = adapter->card;
 	const struct mwifiex_pcie_card_reg *reg = card->pcie.reg;
 	int pcie_scratch_reg[] = {PCIE_SCRATCH_12_REG,
-				  PCIE_SCRATCH_13_REG,
-				  PCIE_SCRATCH_14_REG};
+				  PCIE_SCRATCH_14_REG,
+				  PCIE_SCRATCH_15_REG};
 
 	if (!p)
 		return 0;
diff --git a/drivers/net/wireless/marvell/mwifiex/pcie.h b/drivers/net/wireless/marvell/mwifiex/pcie.h
index 00e8ee5..7e2450c 100644
--- a/drivers/net/wireless/marvell/mwifiex/pcie.h
+++ b/drivers/net/wireless/marvell/mwifiex/pcie.h
@@ -77,8 +77,9 @@
 #define PCIE_SCRATCH_10_REG				0xCE8
 #define PCIE_SCRATCH_11_REG				0xCEC
 #define PCIE_SCRATCH_12_REG				0xCF0
-#define PCIE_SCRATCH_13_REG				0xCF8
-#define PCIE_SCRATCH_14_REG				0xCFC
+#define PCIE_SCRATCH_13_REG				0xCF4
+#define PCIE_SCRATCH_14_REG				0xCF8
+#define PCIE_SCRATCH_15_REG				0xCFC
 #define PCIE_RD_DATA_PTR_Q0_Q1                          0xC08C
 #define PCIE_WR_DATA_PTR_Q0_Q1                          0xC05C
 
@@ -217,8 +218,8 @@ struct mwifiex_pcie_card_reg {
 	.ring_tx_start_ptr = MWIFIEX_BD_FLAG_TX_START_PTR,
 	.pfu_enabled = 1,
 	.sleep_cookie = 0,
-	.fw_dump_ctrl = 0xcf4,
-	.fw_dump_start = 0xcf8,
+	.fw_dump_ctrl = PCIE_SCRATCH_13_REG,
+	.fw_dump_start = PCIE_SCRATCH_14_REG,
 	.fw_dump_end = 0xcff,
 	.fw_dump_host_ready = 0xee,
 	.fw_dump_read_done = 0xfe,
@@ -254,8 +255,8 @@ struct mwifiex_pcie_card_reg {
 	.ring_tx_start_ptr = MWIFIEX_BD_FLAG_TX_START_PTR,
 	.pfu_enabled = 1,
 	.sleep_cookie = 0,
-	.fw_dump_ctrl = 0xcf4,
-	.fw_dump_start = 0xcf8,
+	.fw_dump_ctrl = PCIE_SCRATCH_13_REG,
+	.fw_dump_start = PCIE_SCRATCH_14_REG,
 	.fw_dump_end = 0xcff,
 	.fw_dump_host_ready = 0xcc,
 	.fw_dump_read_done = 0xdd,
-- 
1.8.1.4

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rtits2.realtek.com ([211.75.126.72]:34483 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752678AbeC3HTo (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 30 Mar 2018 03:19:44 -0400
From: <pkshih@realtek.com>
To: <kvalo@codeaurora.org>
CC: <Larry.Finger@lwfinger.net>, <linux-wireless@vger.kernel.org>
Subject: [PATCH 09/17] rtlwifi: halmac: add power sequence to turn on/off wifi card
Date: Fri, 30 Mar 2018 15:19:08 +0800
Message-ID: <20180330071916.23360-10-pkshih@realtek.com> (sfid-20180330_091959_204005_A80D8DB6)
In-Reply-To: <20180330071916.23360-1-pkshih@realtek.com>
References: <20180330071916.23360-1-pkshih@realtek.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ping-Ke Shih <pkshih@realtek.com>

Define power sequence command, and fill the sequences of 8822b.

Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
---
 .../halmac_8822b/halmac_pwr_seq_8822b.c            | 396 +++++++++++++++++++++
 .../halmac_8822b/halmac_pwr_seq_8822b.h            |  26 ++
 .../realtek/rtlwifi/halmac/halmac_pwr_seq_cmd.h    |  98 +++++
 3 files changed, 520 insertions(+)
 create mode 100644 drivers/net/wireless/realtek/rtlwifi/halmac/halmac_88xx/halmac_8822b/halmac_pwr_seq_8822b.c
 create mode 100644 drivers/net/wireless/realtek/rtlwifi/halmac/halmac_88xx/halmac_8822b/halmac_pwr_seq_8822b.h
 create mode 100644 drivers/net/wireless/realtek/rtlwifi/halmac/halmac_pwr_seq_cmd.h

diff --git a/drivers/net/wireless/realtek/rtlwifi/halmac/halmac_88xx/halmac_8822b/halmac_pwr_seq_8822b.c b/drivers/net/wireless/realtek/rtlwifi/halmac/halmac_88xx/halmac_8822b/halmac_pwr_seq_8822b.c
new file mode 100644
index 000000000000..5aab588eb094
--- /dev/null
+++ b/drivers/net/wireless/realtek/rtlwifi/halmac/halmac_88xx/halmac_8822b/halmac_pwr_seq_8822b.c
@@ -0,0 +1,396 @@
+/******************************************************************************
+ *
+ * Copyright(c) 2016 - 2018 Realtek Corporation. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of version 2 of the GNU General Public License as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for
+ * more details.
+ *
+ ******************************************************************************/
+
+#include "halmac_pwr_seq_8822b.h"
+
+static struct halmac_wlan_pwr_cfg TRANS_CARDDIS_TO_CARDEMU_8822B[] = {
+	/* { offset, cut_msk, interface_msk, base|cmd, msk, value } */
+	{0x0086,
+	 HALMAC_PWR_CUT_ALL_MSK,
+	 HALMAC_PWR_INTF_SDIO_MSK,
+	 HALMAC_PWR_ADDR_SDIO,
+	 HALMAC_PWR_CMD_WRITE, BIT(0), 0},
+	{0x0086,
+	 HALMAC_PWR_CUT_ALL_MSK,
+	 HALMAC_PWR_INTF_SDIO_MSK,
+	 HALMAC_PWR_ADDR_SDIO,
+	 HALMAC_PWR_CMD_POLLING, BIT(1), BIT(1)},
+	{0x004A,
+	 HALMAC_PWR_CUT_ALL_MSK,
+	 HALMAC_PWR_INTF_USB_MSK,
+	 HALMAC_PWR_ADDR_MAC,
+	 HALMAC_PWR_CMD_WRITE, BIT(0), 0},
+	{0x0005,
+	 HALMAC_PWR_CUT_ALL_MSK,
+	 HALMAC_PWR_INTF_ALL_MSK,
+	 HALMAC_PWR_ADDR_MAC,
+	 HALMAC_PWR_CMD_WRITE, BIT(3) | BIT(4) | BIT(7), 0},
+	{0x0300,
+	 HALMAC_PWR_CUT_ALL_MSK,
+	 HALMAC_PWR_INTF_PCI_MSK,
+	 HALMAC_PWR_ADDR_MAC,
+	 HALMAC_PWR_CMD_WRITE, 0xFF, 0},
+	{0x0301,
+	 HALMAC_PWR_CUT_ALL_MSK,
+	 HALMAC_PWR_INTF_PCI_MSK,
+	 HALMAC_PWR_ADDR_MAC,
+	 HALMAC_PWR_CMD_WRITE, 0xFF, 0},
+	{0xFFFF,
+	 HALMAC_PWR_CUT_ALL_MSK,
+	 HALMAC_PWR_INTF_ALL_MSK,
+	 0,
+	 HALMAC_PWR_CMD_END, 0, 0},
+};
+
+static struct halmac_wlan_pwr_cfg TRANS_CARDEMU_TO_ACT_8822B[] = {
+	/* { offset, cut_msk, interface_msk, base|cmd, msk, value } */
+	{0x0012,
+	 HALMAC_PWR_CUT_ALL_MSK,
+	 HALMAC_PWR_INTF_ALL_MSK,
+	 HALMAC_PWR_ADDR_MAC,
+	 HALMAC_PWR_CMD_WRITE, BIT(1), 0},
+	{0x0012,
+	 HALMAC_PWR_CUT_ALL_MSK,
+	 HALMAC_PWR_INTF_ALL_MSK,
+	 HALMAC_PWR_ADDR_MAC,
+	 HALMAC_PWR_CMD_WRITE, BIT(0), BIT(0)},
+	{0x0020,
+	 HALMAC_PWR_CUT_ALL_MSK,
+	 HALMAC_PWR_INTF_USB_MSK | HALMAC_PWR_INTF_SDIO_MSK,
+	 HALMAC_PWR_ADDR_MAC,
+	 HALMAC_PWR_CMD_WRITE, BIT(0), BIT(0)},
+	{0x0001,
+	 HALMAC_PWR_CUT_ALL_MSK,
+	 HALMAC_PWR_INTF_USB_MSK | HALMAC_PWR_INTF_SDIO_MSK,
+	 HALMAC_PWR_ADDR_MAC,
+	 HALMAC_PWR_CMD_DELAY, 1, HALMAC_PWR_DELAY_MS},
+	{0x0000,
+	 HALMAC_PWR_CUT_ALL_MSK,
+	 HALMAC_PWR_INTF_USB_MSK | HALMAC_PWR_INTF_SDIO_MSK,
+	 HALMAC_PWR_ADDR_MAC,
+	 HALMAC_PWR_CMD_WRITE, BIT(5), 0},
+	{0x0005,
+	 HALMAC_PWR_CUT_ALL_MSK,
+	 HALMAC_PWR_INTF_ALL_MSK,
+	 HALMAC_PWR_ADDR_MAC,
+	 HALMAC_PWR_CMD_WRITE, (BIT(4) | BIT(3) | BIT(2)), 0},
+	{0x0075,
+	 HALMAC_PWR_CUT_ALL_MSK,
+	 HALMAC_PWR_INTF_PCI_MSK,
+	 HALMAC_PWR_ADDR_MAC,
+	 HALMAC_PWR_CMD_WRITE, BIT(0), BIT(0)},
+	{0x0006,
+	 HALMAC_PWR_CUT_ALL_MSK,
+	 HALMAC_PWR_INTF_ALL_MSK,
+	 HALMAC_PWR_ADDR_MAC,
+	 HALMAC_PWR_CMD_POLLING, BIT(1), BIT(1)},
+	{0x0075,
+	 HALMAC_PWR_CUT_ALL_MSK,
+	 HALMAC_PWR_INTF_PCI_MSK,
+	 HALMAC_PWR_ADDR_MAC,
+	 HALMAC_PWR_CMD_WRITE, BIT(0), 0},
+	{0xFF1A,
+	 HALMAC_PWR_CUT_ALL_MSK,
+	 HALMAC_PWR_INTF_USB_MSK,
+	 HALMAC_PWR_ADDR_MAC,
+	 HALMAC_PWR_CMD_WRITE, 0xFF, 0},
+	{0x0006,
+	 HALMAC_PWR_CUT_ALL_MSK,
+	 HALMAC_PWR_INTF_ALL_MSK,
+	 HALMAC_PWR_ADDR_MAC,
+	 HALMAC_PWR_CMD_WRITE, BIT(0), BIT(0)},
+	{0x0005,
+	 HALMAC_PWR_CUT_ALL_MSK,
+	 HALMAC_PWR_INTF_ALL_MSK,
+	 HALMAC_PWR_ADDR_MAC,
+	 HALMAC_PWR_CMD_WRITE, BIT(7), 0},
+	{0x0005,
+	 HALMAC_PWR_CUT_ALL_MSK,
+	 HALMAC_PWR_INTF_ALL_MSK,
+	 HALMAC_PWR_ADDR_MAC,
+	 HALMAC_PWR_CMD_WRITE, (BIT(4) | BIT(3)), 0},
+	{0x10C3,
+	 HALMAC_PWR_CUT_ALL_MSK,
+	 HALMAC_PWR_INTF_USB_MSK,
+	 HALMAC_PWR_ADDR_MAC,
+	 HALMAC_PWR_CMD_WRITE, BIT(0), BIT(0)},
+	{0x0005,
+	 HALMAC_PWR_CUT_ALL_MSK,
+	 HALMAC_PWR_INTF_ALL_MSK,
+	 HALMAC_PWR_ADDR_MAC,
+	 HALMAC_PWR_CMD_WRITE, BIT(0), BIT(0)},
+	{0x0005,
+	 HALMAC_PWR_CUT_ALL_MSK,
+	 HALMAC_PWR_INTF_ALL_MSK,
+	 HALMAC_PWR_ADDR_MAC,
+	 HALMAC_PWR_CMD_POLLING, BIT(0), 0},
+	{0x0020,
+	 HALMAC_PWR_CUT_ALL_MSK,
+	 HALMAC_PWR_INTF_ALL_MSK,
+	 HALMAC_PWR_ADDR_MAC,
+	 HALMAC_PWR_CMD_WRITE, BIT(3), BIT(3)},
+	{0x10A8,
+	 HALMAC_PWR_CUT_C_MSK,
+	 HALMAC_PWR_INTF_ALL_MSK,
+	 HALMAC_PWR_ADDR_MAC,
+	 HALMAC_PWR_CMD_WRITE, 0xFF, 0},
+	{0x10A9,
+	 HALMAC_PWR_CUT_C_MSK,
+	 HALMAC_PWR_INTF_ALL_MSK,
+	 HALMAC_PWR_ADDR_MAC,
+	 HALMAC_PWR_CMD_WRITE, 0xFF, 0xef},
+	{0x10AA,
+	 HALMAC_PWR_CUT_C_MSK,
+	 HALMAC_PWR_INTF_ALL_MSK,
+	 HALMAC_PWR_ADDR_MAC,
+	 HALMAC_PWR_CMD_WRITE, 0xFF, 0x0c},
+	{0x0068,
+	 HALMAC_PWR_CUT_C_MSK,
+	 HALMAC_PWR_INTF_SDIO_MSK,
+	 HALMAC_PWR_ADDR_MAC,
+	 HALMAC_PWR_CMD_WRITE, BIT(4), BIT(4)},
+	{0x0029,
+	 HALMAC_PWR_CUT_ALL_MSK,
+	 HALMAC_PWR_INTF_ALL_MSK,
+	 HALMAC_PWR_ADDR_MAC,
+	 HALMAC_PWR_CMD_WRITE, 0xFF, 0xF9},
+	{0x0024,
+	 HALMAC_PWR_CUT_ALL_MSK,
+	 HALMAC_PWR_INTF_ALL_MSK,
+	 HALMAC_PWR_ADDR_MAC,
+	 HALMAC_PWR_CMD_WRITE, BIT(2), 0},
+	{0x0074,
+	 HALMAC_PWR_CUT_ALL_MSK,
+	 HALMAC_PWR_INTF_PCI_MSK,
+	 HALMAC_PWR_ADDR_MAC,
+	 HALMAC_PWR_CMD_WRITE, BIT(5), BIT(5)},
+	{0x00AF,
+	 HALMAC_PWR_CUT_ALL_MSK,
+	 HALMAC_PWR_INTF_ALL_MSK,
+	 HALMAC_PWR_ADDR_MAC,
+	 HALMAC_PWR_CMD_WRITE, BIT(5), BIT(5)},
+	{0xFFFF,
+	 HALMAC_PWR_CUT_ALL_MSK,
+	 HALMAC_PWR_INTF_ALL_MSK,
+	 0,
+	 HALMAC_PWR_CMD_END, 0, 0},
+};
+
+static struct halmac_wlan_pwr_cfg TRANS_ACT_TO_CARDEMU_8822B[] = {
+	/* { offset, cut_msk, interface_msk, base|cmd, msk, value } */
+	{0x0003,
+	 HALMAC_PWR_CUT_ALL_MSK,
+	 HALMAC_PWR_INTF_SDIO_MSK,
+	 HALMAC_PWR_ADDR_MAC,
+	 HALMAC_PWR_CMD_WRITE, BIT(2), 0},
+	{0x0093,
+	 HALMAC_PWR_CUT_ALL_MSK,
+	 HALMAC_PWR_INTF_ALL_MSK,
+	 HALMAC_PWR_ADDR_MAC,
+	 HALMAC_PWR_CMD_WRITE, BIT(3), 0},
+	{0x001F,
+	 HALMAC_PWR_CUT_ALL_MSK,
+	 HALMAC_PWR_INTF_ALL_MSK,
+	 HALMAC_PWR_ADDR_MAC,
+	 HALMAC_PWR_CMD_WRITE, 0xFF, 0},
+	{0x00EF,
+	 HALMAC_PWR_CUT_ALL_MSK,
+	 HALMAC_PWR_INTF_ALL_MSK,
+	 HALMAC_PWR_ADDR_MAC,
+	 HALMAC_PWR_CMD_WRITE, 0xFF, 0},
+	{0xFF1A,
+	 HALMAC_PWR_CUT_ALL_MSK,
+	 HALMAC_PWR_INTF_USB_MSK,
+	 HALMAC_PWR_ADDR_MAC,
+	 HALMAC_PWR_CMD_WRITE, 0xFF, 0x30},
+	{0x0049,
+	 HALMAC_PWR_CUT_ALL_MSK,
+	 HALMAC_PWR_INTF_ALL_MSK,
+	 HALMAC_PWR_ADDR_MAC,
+	 HALMAC_PWR_CMD_WRITE, BIT(1), 0},
+	{0x0006,
+	 HALMAC_PWR_CUT_ALL_MSK,
+	 HALMAC_PWR_INTF_ALL_MSK,
+	 HALMAC_PWR_ADDR_MAC,
+	 HALMAC_PWR_CMD_WRITE, BIT(0), BIT(0)},
+	{0x0002,
+	 HALMAC_PWR_CUT_ALL_MSK,
+	 HALMAC_PWR_INTF_ALL_MSK,
+	 HALMAC_PWR_ADDR_MAC,
+	 HALMAC_PWR_CMD_WRITE, BIT(1), 0},
+	{0x10C3,
+	 HALMAC_PWR_CUT_ALL_MSK,
+	 HALMAC_PWR_INTF_USB_MSK,
+	 HALMAC_PWR_ADDR_MAC,
+	 HALMAC_PWR_CMD_WRITE, BIT(0), 0},
+	{0x0005,
+	 HALMAC_PWR_CUT_ALL_MSK,
+	 HALMAC_PWR_INTF_ALL_MSK,
+	 HALMAC_PWR_ADDR_MAC,
+	 HALMAC_PWR_CMD_WRITE, BIT(1), BIT(1)},
+	{0x0005,
+	 HALMAC_PWR_CUT_ALL_MSK,
+	 HALMAC_PWR_INTF_ALL_MSK,
+	 HALMAC_PWR_ADDR_MAC,
+	 HALMAC_PWR_CMD_POLLING, BIT(1), 0},
+	{0x0020,
+	 HALMAC_PWR_CUT_ALL_MSK,
+	 HALMAC_PWR_INTF_ALL_MSK,
+	 HALMAC_PWR_ADDR_MAC,
+	 HALMAC_PWR_CMD_WRITE, BIT(3), 0},
+	{0x0000,
+	 HALMAC_PWR_CUT_ALL_MSK,
+	 HALMAC_PWR_INTF_USB_MSK | HALMAC_PWR_INTF_SDIO_MSK,
+	 HALMAC_PWR_ADDR_MAC,
+	 HALMAC_PWR_CMD_WRITE, BIT(5), BIT(5)},
+	{0xFFFF,
+	 HALMAC_PWR_CUT_ALL_MSK,
+	 HALMAC_PWR_INTF_ALL_MSK,
+	 0,
+	 HALMAC_PWR_CMD_END, 0, 0},
+};
+
+static struct halmac_wlan_pwr_cfg TRANS_CARDEMU_TO_CARDDIS_8822B[] = {
+	/* { offset, cut_msk, interface_msk, base|cmd, msk, value } */
+	{0x0005,
+	 HALMAC_PWR_CUT_ALL_MSK,
+	 HALMAC_PWR_INTF_SDIO_MSK,
+	 HALMAC_PWR_ADDR_MAC,
+	 HALMAC_PWR_CMD_WRITE, BIT(7), BIT(7)},
+	{0x0007,
+	 HALMAC_PWR_CUT_ALL_MSK,
+	 HALMAC_PWR_INTF_USB_MSK | HALMAC_PWR_INTF_SDIO_MSK,
+	 HALMAC_PWR_ADDR_MAC,
+	 HALMAC_PWR_CMD_WRITE, 0xFF, 0x20},
+	{0x0067,
+	 HALMAC_PWR_CUT_ALL_MSK,
+	 HALMAC_PWR_INTF_ALL_MSK,
+	 HALMAC_PWR_ADDR_MAC,
+	 HALMAC_PWR_CMD_WRITE, BIT(5), 0},
+	{0x0005,
+	 HALMAC_PWR_CUT_ALL_MSK,
+	 HALMAC_PWR_INTF_USB_MSK | HALMAC_PWR_INTF_SDIO_MSK,
+	 HALMAC_PWR_ADDR_MAC,
+	 HALMAC_PWR_CMD_WRITE, BIT(3) | BIT(4), BIT(3)},
+	{0x0005,
+	 HALMAC_PWR_CUT_ALL_MSK,
+	 HALMAC_PWR_INTF_PCI_MSK,
+	 HALMAC_PWR_ADDR_MAC,
+	 HALMAC_PWR_CMD_WRITE, BIT(2), BIT(2)},
+	{0x004A,
+	 HALMAC_PWR_CUT_ALL_MSK,
+	 HALMAC_PWR_INTF_USB_MSK,
+	 HALMAC_PWR_ADDR_MAC,
+	 HALMAC_PWR_CMD_WRITE, BIT(0), 0},
+	{0x0067,
+	 HALMAC_PWR_CUT_ALL_MSK,
+	 HALMAC_PWR_INTF_SDIO_MSK,
+	 HALMAC_PWR_ADDR_MAC,
+	 HALMAC_PWR_CMD_WRITE, BIT(5), 0},
+	{0x0067,
+	 HALMAC_PWR_CUT_ALL_MSK,
+	 HALMAC_PWR_INTF_SDIO_MSK,
+	 HALMAC_PWR_ADDR_MAC,
+	 HALMAC_PWR_CMD_WRITE, BIT(4), 0},
+	{0x004F,
+	 HALMAC_PWR_CUT_ALL_MSK,
+	 HALMAC_PWR_INTF_SDIO_MSK,
+	 HALMAC_PWR_ADDR_MAC,
+	 HALMAC_PWR_CMD_WRITE, BIT(0), 0},
+	{0x0067,
+	 HALMAC_PWR_CUT_ALL_MSK,
+	 HALMAC_PWR_INTF_SDIO_MSK,
+	 HALMAC_PWR_ADDR_MAC,
+	 HALMAC_PWR_CMD_WRITE, BIT(1), 0},
+	{0x0046,
+	 HALMAC_PWR_CUT_ALL_MSK,
+	 HALMAC_PWR_INTF_SDIO_MSK,
+	 HALMAC_PWR_ADDR_MAC,
+	 HALMAC_PWR_CMD_WRITE, BIT(6), BIT(6)},
+	{0x0067,
+	 HALMAC_PWR_CUT_ALL_MSK,
+	 HALMAC_PWR_INTF_SDIO_MSK,
+	 HALMAC_PWR_ADDR_MAC,
+	 HALMAC_PWR_CMD_WRITE, BIT(2), 0},
+	{0x0046,
+	 HALMAC_PWR_CUT_ALL_MSK,
+	 HALMAC_PWR_INTF_SDIO_MSK,
+	 HALMAC_PWR_ADDR_MAC,
+	 HALMAC_PWR_CMD_WRITE, BIT(7), BIT(7)},
+	{0x0062,
+	 HALMAC_PWR_CUT_ALL_MSK,
+	 HALMAC_PWR_INTF_SDIO_MSK,
+	 HALMAC_PWR_ADDR_MAC,
+	 HALMAC_PWR_CMD_WRITE, BIT(4), BIT(4)},
+	{0x0081,
+	 HALMAC_PWR_CUT_ALL_MSK,
+	 HALMAC_PWR_INTF_ALL_MSK,
+	 HALMAC_PWR_ADDR_MAC,
+	 HALMAC_PWR_CMD_WRITE, BIT(7), 0},
+	{0x0086,
+	 HALMAC_PWR_CUT_ALL_MSK,
+	 HALMAC_PWR_INTF_SDIO_MSK,
+	 HALMAC_PWR_ADDR_SDIO,
+	 HALMAC_PWR_CMD_WRITE, BIT(0), BIT(0)},
+	{0x0086,
+	 HALMAC_PWR_CUT_ALL_MSK,
+	 HALMAC_PWR_INTF_SDIO_MSK,
+	 HALMAC_PWR_ADDR_SDIO,
+	 HALMAC_PWR_CMD_POLLING, BIT(1), 0},
+	{0x0090,
+	 HALMAC_PWR_CUT_ALL_MSK,
+	 HALMAC_PWR_INTF_USB_MSK | HALMAC_PWR_INTF_PCI_MSK,
+	 HALMAC_PWR_ADDR_MAC,
+	 HALMAC_PWR_CMD_WRITE, BIT(1), 0},
+	{0x0044,
+	 HALMAC_PWR_CUT_ALL_MSK,
+	 HALMAC_PWR_INTF_SDIO_MSK,
+	 HALMAC_PWR_ADDR_SDIO,
+	 HALMAC_PWR_CMD_WRITE, 0xFF, 0},
+	{0x0040,
+	 HALMAC_PWR_CUT_ALL_MSK,
+	 HALMAC_PWR_INTF_SDIO_MSK,
+	 HALMAC_PWR_ADDR_SDIO,
+	 HALMAC_PWR_CMD_WRITE, 0xFF, 0x90},
+	{0x0041,
+	 HALMAC_PWR_CUT_ALL_MSK,
+	 HALMAC_PWR_INTF_SDIO_MSK,
+	 HALMAC_PWR_ADDR_SDIO,
+	 HALMAC_PWR_CMD_WRITE, 0xFF, 0x00},
+	{0x0042,
+	 HALMAC_PWR_CUT_ALL_MSK,
+	 HALMAC_PWR_INTF_SDIO_MSK,
+	 HALMAC_PWR_ADDR_SDIO,
+	 HALMAC_PWR_CMD_WRITE, 0xFF, 0x04},
+	{0xFFFF,
+	 HALMAC_PWR_CUT_ALL_MSK,
+	 HALMAC_PWR_INTF_ALL_MSK,
+	 0,
+	 HALMAC_PWR_CMD_END, 0, 0},
+};
+
+/* Card Enable Array */
+struct halmac_wlan_pwr_cfg *card_en_flow_8822b[] = {
+	TRANS_CARDDIS_TO_CARDEMU_8822B,
+	TRANS_CARDEMU_TO_ACT_8822B,
+	NULL
+};
+
+/* Card Disable Array */
+struct halmac_wlan_pwr_cfg *card_dis_flow_8822b[] = {
+	TRANS_ACT_TO_CARDEMU_8822B,
+	TRANS_CARDEMU_TO_CARDDIS_8822B,
+	NULL
+};
diff --git a/drivers/net/wireless/realtek/rtlwifi/halmac/halmac_88xx/halmac_8822b/halmac_pwr_seq_8822b.h b/drivers/net/wireless/realtek/rtlwifi/halmac/halmac_88xx/halmac_8822b/halmac_pwr_seq_8822b.h
new file mode 100644
index 000000000000..76d39b944a02
--- /dev/null
+++ b/drivers/net/wireless/realtek/rtlwifi/halmac/halmac_88xx/halmac_8822b/halmac_pwr_seq_8822b.h
@@ -0,0 +1,26 @@
+/******************************************************************************
+ *
+ * Copyright(c) 2016 - 2018 Realtek Corporation. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of version 2 of the GNU General Public License as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for
+ * more details.
+ *
+ ******************************************************************************/
+
+#ifndef HALMAC_POWER_SEQUENCE_8822B
+#define HALMAC_POWER_SEQUENCE_8822B
+
+#include "../../halmac_pwr_seq_cmd.h"
+
+#define HALMAC_8822B_PWR_SEQ_VER  "V25"
+
+extern struct halmac_wlan_pwr_cfg *card_en_flow_8822b[];
+extern struct halmac_wlan_pwr_cfg *card_dis_flow_8822b[];
+
+#endif
diff --git a/drivers/net/wireless/realtek/rtlwifi/halmac/halmac_pwr_seq_cmd.h b/drivers/net/wireless/realtek/rtlwifi/halmac/halmac_pwr_seq_cmd.h
new file mode 100644
index 000000000000..9b64397dc8cf
--- /dev/null
+++ b/drivers/net/wireless/realtek/rtlwifi/halmac/halmac_pwr_seq_cmd.h
@@ -0,0 +1,98 @@
+/******************************************************************************
+ *
+ * Copyright(c) 2016 - 2018 Realtek Corporation. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of version 2 of the GNU General Public License as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for
+ * more details.
+ *
+ ******************************************************************************/
+
+#ifndef HALMAC_POWER_SEQUENCE_CMD
+#define HALMAC_POWER_SEQUENCE_CMD
+
+#include "../wifi.h"
+
+#define HALMAC_PWR_POLLING_CNT 20000
+
+/* The value of cmd : 4 bits */
+
+/* offset : the read register offset
+ * msk : the mask of the read value
+ * value : N/A, left by 0
+ * Note : dirver shall implement this function by read & msk
+ */
+#define	HALMAC_PWR_CMD_READ		0x00
+/* offset: the read register offset
+ * msk: the mask of the write bits
+ * value: write value
+ * Note: driver shall implement this cmd by read & msk after write
+ */
+#define	HALMAC_PWR_CMD_WRITE	0x01
+/* offset: the read register offset
+ * msk: the mask of the polled value
+ * value: the value to be polled, masked by the msd field.
+ * Note: driver shall implement this cmd by
+ * do{
+ * if( (Read(offset) & msk) == (value & msk) )
+ * break;
+ * } while(not timeout);
+ */
+#define	HALMAC_PWR_CMD_POLLING	0x02
+/* offset: the value to delay
+ * msk: N/A
+ * value: the unit of delay, 0: us, 1: ms
+ */
+#define	HALMAC_PWR_CMD_DELAY	0x03
+/* offset: N/A
+ * msk: N/A
+ * value: N/A
+ */
+#define	HALMAC_PWR_CMD_END	0x04
+
+/* The value of base : 4 bits */
+
+/* define the base address of each block */
+#define   HALMAC_PWR_ADDR_MAC	0x00
+#define   HALMAC_PWR_ADDR_USB	0x01
+#define   HALMAC_PWR_ADDR_PCIE	0x02
+#define   HALMAC_PWR_ADDR_SDIO	0x03
+
+/* The value of interface_msk : 4 bits */
+#define	HALMAC_PWR_INTF_SDIO_MSK	BIT(0)
+#define	HALMAC_PWR_INTF_USB_MSK		BIT(1)
+#define	HALMAC_PWR_INTF_PCI_MSK		BIT(2)
+#define	HALMAC_PWR_INTF_ALL_MSK		(BIT(0) | BIT(1) | BIT(2) | BIT(3))
+
+/* The value of cut_msk : 8 bits */
+#define	HALMAC_PWR_CUT_TESTCHIP_MSK		BIT(0)
+#define	HALMAC_PWR_CUT_A_MSK			BIT(1)
+#define	HALMAC_PWR_CUT_B_MSK			BIT(2)
+#define	HALMAC_PWR_CUT_C_MSK			BIT(3)
+#define	HALMAC_PWR_CUT_D_MSK			BIT(4)
+#define	HALMAC_PWR_CUT_E_MSK			BIT(5)
+#define	HALMAC_PWR_CUT_F_MSK			BIT(6)
+#define	HALMAC_PWR_CUT_G_MSK			BIT(7)
+#define	HALMAC_PWR_CUT_ALL_MSK			0xFF
+
+enum halmac_pwrseq_cmd_delay_unit {
+	HALMAC_PWR_DELAY_US,
+	HALMAC_PWR_DELAY_MS,
+};
+
+struct halmac_wlan_pwr_cfg {
+	u16 offset;
+	u8 cut_msk;
+	u8 interface_msk;
+	u8 base:4;
+	u8 cmd:4;
+	u8 msk;
+	u8 value;
+};
+
+#endif
-- 
2.15.1

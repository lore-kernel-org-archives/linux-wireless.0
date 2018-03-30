Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rtits2.realtek.com ([211.75.126.72]:34503 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752673AbeC3HTy (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 30 Mar 2018 03:19:54 -0400
From: <pkshih@realtek.com>
To: <kvalo@codeaurora.org>
CC: <Larry.Finger@lwfinger.net>, <linux-wireless@vger.kernel.org>
Subject: [PATCH 12/17] rtlwifi: halmac: add halmac init/deinit functions
Date: Fri, 30 Mar 2018 15:19:11 +0800
Message-ID: <20180330071916.23360-13-pkshih@realtek.com> (sfid-20180330_092009_036240_472326CD)
In-Reply-To: <20180330071916.23360-1-pkshih@realtek.com>
References: <20180330071916.23360-1-pkshih@realtek.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ping-Ke Shih <pkshih@realtek.com>

Add files to initialize and free halmac context. Since halmac is an three
levels hierarchy file structure, so the added files provide interfaces of
halmac, 88xx and 8822b.

Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
---
 .../halmac_88xx/halmac_8822b/halmac_init_8822b.c   |  688 +++++++++++++
 .../halmac_88xx/halmac_8822b/halmac_init_8822b.h   |   33 +
 .../rtlwifi/halmac/halmac_88xx/halmac_init_88xx.c  | 1071 ++++++++++++++++++++
 .../rtlwifi/halmac/halmac_88xx/halmac_init_88xx.h  |   70 ++
 .../wireless/realtek/rtlwifi/halmac/halmac_api.c   |  438 ++++++++
 .../wireless/realtek/rtlwifi/halmac/halmac_api.h   |   65 ++
 6 files changed, 2365 insertions(+)
 create mode 100644 drivers/net/wireless/realtek/rtlwifi/halmac/halmac_88xx/halmac_8822b/halmac_init_8822b.c
 create mode 100644 drivers/net/wireless/realtek/rtlwifi/halmac/halmac_88xx/halmac_8822b/halmac_init_8822b.h
 create mode 100644 drivers/net/wireless/realtek/rtlwifi/halmac/halmac_88xx/halmac_init_88xx.c
 create mode 100644 drivers/net/wireless/realtek/rtlwifi/halmac/halmac_88xx/halmac_init_88xx.h
 create mode 100644 drivers/net/wireless/realtek/rtlwifi/halmac/halmac_api.c
 create mode 100644 drivers/net/wireless/realtek/rtlwifi/halmac/halmac_api.h

diff --git a/drivers/net/wireless/realtek/rtlwifi/halmac/halmac_88xx/halmac_8822b/halmac_init_8822b.c b/drivers/net/wireless/realtek/rtlwifi/halmac/halmac_88xx/halmac_8822b/halmac_init_8822b.c
new file mode 100644
index 000000000000..57509fd5942a
--- /dev/null
+++ b/drivers/net/wireless/realtek/rtlwifi/halmac/halmac_88xx/halmac_8822b/halmac_init_8822b.c
@@ -0,0 +1,688 @@
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
+#include "halmac_init_8822b.h"
+#include "halmac_8822b_cfg.h"
+#include "halmac_pcie_8822b.h"
+#include "halmac_sdio_8822b.h"
+#include "halmac_usb_8822b.h"
+#include "halmac_gpio_8822b.h"
+#include "halmac_common_8822b.h"
+#include "halmac_cfg_wmac_8822b.h"
+#include "../halmac_common_88xx.h"
+#include "../halmac_init_88xx.h"
+
+#define RSVD_PG_DRV_NUM			16
+#define RSVD_PG_H2C_EXTRAINFO_NUM	24
+#define RSVD_PG_H2C_STATICINFO_NUM	8
+#define RSVD_PG_H2CQ_NUM		8
+#define RSVD_PG_CPU_INSTRUCTION_NUM	0
+#define RSVD_PG_FW_TXBUF_NUM		4
+#define RSVD_PG_CSIBUF_NUM		0
+#define RSVD_PG_DLLB_NUM		(TX_FIFO_SIZE_8822B / 3 >> \
+					TX_PAGE_SIZE_SHIFT_88XX)
+
+#define MAC_TRX_ENABLE	(BIT_HCI_TXDMA_EN | BIT_HCI_RXDMA_EN | BIT_TXDMA_EN | \
+			BIT_RXDMA_EN | BIT_PROTOCOL_EN | BIT_SCHEDULE_EN | \
+			BIT_MACTXEN | BIT_MACRXEN)
+
+#define BLK_DESC_NUM	0x3
+
+#define WLAN_AMPDU_MAX_TIME		0x70
+#define WLAN_RTS_LEN_TH			0xFF
+#define WLAN_RTS_TX_TIME_TH		0x08
+#define WLAN_MAX_AGG_PKT_LIMIT		0x20
+#define WLAN_RTS_MAX_AGG_PKT_LIMIT	0x20
+#define WALN_FAST_EDCA_VO_TH		0x06
+#define WLAN_FAST_EDCA_VI_TH		0x06
+#define WLAN_FAST_EDCA_BE_TH		0x06
+#define WLAN_FAST_EDCA_BK_TH		0x06
+#define WLAN_BAR_RETRY_LIMIT		0x01
+#define WLAN_RA_TRY_RATE_AGG_LIMIT	0x08
+
+/*SDIO RQPN Mapping*/
+static struct halmac_rqpn HALMAC_RQPN_SDIO_8822B[] = {
+	/* { mode, vo_map, vi_map, be_map, bk_map, mg_map, hi_map } */
+	{HALMAC_TRX_MODE_NORMAL,
+	 HALMAC_MAP2_NQ, HALMAC_MAP2_NQ, HALMAC_MAP2_LQ, HALMAC_MAP2_LQ,
+	 HALMAC_MAP2_EXQ, HALMAC_MAP2_HQ},
+	{HALMAC_TRX_MODE_TRXSHARE,
+	 HALMAC_MAP2_NQ, HALMAC_MAP2_NQ, HALMAC_MAP2_LQ, HALMAC_MAP2_LQ,
+	 HALMAC_MAP2_EXQ, HALMAC_MAP2_HQ},
+	{HALMAC_TRX_MODE_WMM,
+	 HALMAC_MAP2_HQ, HALMAC_MAP2_NQ, HALMAC_MAP2_LQ, HALMAC_MAP2_NQ,
+	 HALMAC_MAP2_EXQ, HALMAC_MAP2_HQ},
+	{HALMAC_TRX_MODE_P2P,
+	 HALMAC_MAP2_NQ, HALMAC_MAP2_NQ, HALMAC_MAP2_LQ, HALMAC_MAP2_LQ,
+	 HALMAC_MAP2_EXQ, HALMAC_MAP2_HQ},
+	{HALMAC_TRX_MODE_LOOPBACK,
+	 HALMAC_MAP2_NQ, HALMAC_MAP2_NQ, HALMAC_MAP2_LQ, HALMAC_MAP2_LQ,
+	 HALMAC_MAP2_EXQ, HALMAC_MAP2_HQ},
+	{HALMAC_TRX_MODE_DELAY_LOOPBACK,
+	 HALMAC_MAP2_NQ, HALMAC_MAP2_NQ, HALMAC_MAP2_LQ, HALMAC_MAP2_LQ,
+	 HALMAC_MAP2_EXQ, HALMAC_MAP2_HQ},
+};
+
+/*PCIE RQPN Mapping*/
+static struct halmac_rqpn HALMAC_RQPN_PCIE_8822B[] = {
+	/* { mode, vo_map, vi_map, be_map, bk_map, mg_map, hi_map } */
+	{HALMAC_TRX_MODE_NORMAL,
+	 HALMAC_MAP2_NQ, HALMAC_MAP2_NQ, HALMAC_MAP2_LQ, HALMAC_MAP2_LQ,
+	 HALMAC_MAP2_EXQ, HALMAC_MAP2_HQ},
+	{HALMAC_TRX_MODE_TRXSHARE,
+	 HALMAC_MAP2_NQ, HALMAC_MAP2_NQ, HALMAC_MAP2_LQ, HALMAC_MAP2_LQ,
+	 HALMAC_MAP2_EXQ, HALMAC_MAP2_HQ},
+	{HALMAC_TRX_MODE_WMM,
+	 HALMAC_MAP2_HQ, HALMAC_MAP2_NQ, HALMAC_MAP2_LQ, HALMAC_MAP2_NQ,
+	 HALMAC_MAP2_EXQ, HALMAC_MAP2_HQ},
+	{HALMAC_TRX_MODE_P2P,
+	 HALMAC_MAP2_NQ, HALMAC_MAP2_NQ, HALMAC_MAP2_LQ, HALMAC_MAP2_LQ,
+	 HALMAC_MAP2_EXQ, HALMAC_MAP2_HQ},
+	{HALMAC_TRX_MODE_LOOPBACK,
+	 HALMAC_MAP2_NQ, HALMAC_MAP2_NQ, HALMAC_MAP2_LQ, HALMAC_MAP2_LQ,
+	 HALMAC_MAP2_EXQ, HALMAC_MAP2_HQ},
+	{HALMAC_TRX_MODE_DELAY_LOOPBACK,
+	 HALMAC_MAP2_NQ, HALMAC_MAP2_NQ, HALMAC_MAP2_LQ, HALMAC_MAP2_LQ,
+	 HALMAC_MAP2_EXQ, HALMAC_MAP2_HQ},
+};
+
+/*USB 2 Bulkout RQPN Mapping*/
+static struct halmac_rqpn HALMAC_RQPN_2BULKOUT_8822B[] = {
+	/* { mode, vo_map, vi_map, be_map, bk_map, mg_map, hi_map } */
+	{HALMAC_TRX_MODE_NORMAL,
+	 HALMAC_MAP2_NQ, HALMAC_MAP2_NQ, HALMAC_MAP2_NQ, HALMAC_MAP2_HQ,
+	 HALMAC_MAP2_HQ, HALMAC_MAP2_HQ},
+	{HALMAC_TRX_MODE_TRXSHARE,
+	 HALMAC_MAP2_NQ, HALMAC_MAP2_NQ, HALMAC_MAP2_NQ, HALMAC_MAP2_HQ,
+	 HALMAC_MAP2_HQ, HALMAC_MAP2_HQ},
+	{HALMAC_TRX_MODE_WMM,
+	 HALMAC_MAP2_NQ, HALMAC_MAP2_NQ, HALMAC_MAP2_NQ, HALMAC_MAP2_HQ,
+	 HALMAC_MAP2_HQ, HALMAC_MAP2_HQ},
+	{HALMAC_TRX_MODE_P2P,
+	 HALMAC_MAP2_HQ, HALMAC_MAP2_HQ, HALMAC_MAP2_HQ, HALMAC_MAP2_NQ,
+	 HALMAC_MAP2_HQ, HALMAC_MAP2_HQ},
+	{HALMAC_TRX_MODE_LOOPBACK,
+	 HALMAC_MAP2_HQ, HALMAC_MAP2_HQ, HALMAC_MAP2_HQ, HALMAC_MAP2_NQ,
+	 HALMAC_MAP2_HQ, HALMAC_MAP2_HQ},
+	{HALMAC_TRX_MODE_DELAY_LOOPBACK,
+	 HALMAC_MAP2_HQ, HALMAC_MAP2_HQ, HALMAC_MAP2_HQ, HALMAC_MAP2_NQ,
+	 HALMAC_MAP2_HQ, HALMAC_MAP2_HQ},
+};
+
+/*USB 3 Bulkout RQPN Mapping*/
+static struct halmac_rqpn HALMAC_RQPN_3BULKOUT_8822B[] = {
+	/* { mode, vo_map, vi_map, be_map, bk_map, mg_map, hi_map } */
+	{HALMAC_TRX_MODE_NORMAL,
+	 HALMAC_MAP2_NQ, HALMAC_MAP2_NQ, HALMAC_MAP2_LQ, HALMAC_MAP2_LQ,
+	 HALMAC_MAP2_HQ, HALMAC_MAP2_HQ},
+	{HALMAC_TRX_MODE_TRXSHARE,
+	 HALMAC_MAP2_NQ, HALMAC_MAP2_NQ, HALMAC_MAP2_LQ, HALMAC_MAP2_LQ,
+	 HALMAC_MAP2_HQ, HALMAC_MAP2_HQ},
+	{HALMAC_TRX_MODE_WMM,
+	 HALMAC_MAP2_HQ, HALMAC_MAP2_NQ, HALMAC_MAP2_LQ, HALMAC_MAP2_NQ,
+	 HALMAC_MAP2_HQ, HALMAC_MAP2_HQ},
+	{HALMAC_TRX_MODE_P2P,
+	 HALMAC_MAP2_HQ, HALMAC_MAP2_HQ, HALMAC_MAP2_LQ, HALMAC_MAP2_NQ,
+	 HALMAC_MAP2_HQ, HALMAC_MAP2_HQ},
+	{HALMAC_TRX_MODE_LOOPBACK,
+	 HALMAC_MAP2_HQ, HALMAC_MAP2_HQ, HALMAC_MAP2_LQ, HALMAC_MAP2_NQ,
+	 HALMAC_MAP2_HQ, HALMAC_MAP2_HQ},
+	{HALMAC_TRX_MODE_DELAY_LOOPBACK,
+	 HALMAC_MAP2_HQ, HALMAC_MAP2_HQ, HALMAC_MAP2_LQ, HALMAC_MAP2_NQ,
+	 HALMAC_MAP2_HQ, HALMAC_MAP2_HQ},
+};
+
+/*USB 4 Bulkout RQPN Mapping*/
+static struct halmac_rqpn HALMAC_RQPN_4BULKOUT_8822B[] = {
+	/* { mode, vo_map, vi_map, be_map, bk_map, mg_map, hi_map } */
+	{HALMAC_TRX_MODE_NORMAL,
+	 HALMAC_MAP2_NQ, HALMAC_MAP2_NQ, HALMAC_MAP2_LQ, HALMAC_MAP2_LQ,
+	 HALMAC_MAP2_EXQ, HALMAC_MAP2_HQ},
+	{HALMAC_TRX_MODE_TRXSHARE,
+	 HALMAC_MAP2_NQ, HALMAC_MAP2_NQ, HALMAC_MAP2_LQ, HALMAC_MAP2_LQ,
+	 HALMAC_MAP2_EXQ, HALMAC_MAP2_HQ},
+	{HALMAC_TRX_MODE_WMM,
+	 HALMAC_MAP2_HQ, HALMAC_MAP2_NQ, HALMAC_MAP2_LQ, HALMAC_MAP2_NQ,
+	 HALMAC_MAP2_EXQ, HALMAC_MAP2_HQ},
+	{HALMAC_TRX_MODE_P2P,
+	 HALMAC_MAP2_NQ, HALMAC_MAP2_NQ, HALMAC_MAP2_LQ, HALMAC_MAP2_LQ,
+	 HALMAC_MAP2_EXQ, HALMAC_MAP2_HQ},
+	{HALMAC_TRX_MODE_LOOPBACK,
+	 HALMAC_MAP2_NQ, HALMAC_MAP2_NQ, HALMAC_MAP2_LQ, HALMAC_MAP2_LQ,
+	 HALMAC_MAP2_EXQ, HALMAC_MAP2_HQ},
+	{HALMAC_TRX_MODE_DELAY_LOOPBACK,
+	 HALMAC_MAP2_NQ, HALMAC_MAP2_NQ, HALMAC_MAP2_LQ, HALMAC_MAP2_LQ,
+	 HALMAC_MAP2_EXQ, HALMAC_MAP2_HQ},
+};
+
+/*SDIO Page Number*/
+static struct halmac_pg_num HALMAC_PG_NUM_SDIO_8822B[] = {
+	/* { mode, hq_num, nq_num, lq_num, exq_num, gap_num} */
+	{HALMAC_TRX_MODE_NORMAL, 64, 64, 64, 64, 1},
+	{HALMAC_TRX_MODE_TRXSHARE, 32, 32, 32, 32, 1},
+	{HALMAC_TRX_MODE_WMM, 64, 64, 64, 64, 1},
+	{HALMAC_TRX_MODE_P2P, 64, 64, 64, 64, 1},
+	{HALMAC_TRX_MODE_LOOPBACK, 64, 64, 64, 64, 1},
+	{HALMAC_TRX_MODE_DELAY_LOOPBACK, 64, 64, 64, 64, 1},
+};
+
+/*PCIE Page Number*/
+static struct halmac_pg_num HALMAC_PG_NUM_PCIE_8822B[] = {
+	/* { mode, hq_num, nq_num, lq_num, exq_num, gap_num} */
+	{HALMAC_TRX_MODE_NORMAL, 64, 64, 64, 64, 1},
+	{HALMAC_TRX_MODE_TRXSHARE, 64, 64, 64, 64, 1},
+	{HALMAC_TRX_MODE_WMM, 64, 64, 64, 64, 1},
+	{HALMAC_TRX_MODE_P2P, 64, 64, 64, 64, 1},
+	{HALMAC_TRX_MODE_LOOPBACK, 64, 64, 64, 64, 1},
+	{HALMAC_TRX_MODE_DELAY_LOOPBACK, 64, 64, 64, 64, 1},
+};
+
+/*USB 2 Bulkout Page Number*/
+static struct halmac_pg_num HALMAC_PG_NUM_2BULKOUT_8822B[] = {
+	/* { mode, hq_num, nq_num, lq_num, exq_num, gap_num} */
+	{HALMAC_TRX_MODE_NORMAL, 64, 64, 0, 0, 1},
+	{HALMAC_TRX_MODE_TRXSHARE, 64, 64, 0, 0, 1},
+	{HALMAC_TRX_MODE_WMM, 64, 64, 0, 0, 1},
+	{HALMAC_TRX_MODE_P2P, 64, 64, 0, 0, 1},
+	{HALMAC_TRX_MODE_LOOPBACK, 64, 64, 0, 0, 1},
+	{HALMAC_TRX_MODE_DELAY_LOOPBACK, 64, 64, 0, 0, 1},
+};
+
+/*USB 3 Bulkout Page Number*/
+static struct halmac_pg_num HALMAC_PG_NUM_3BULKOUT_8822B[] = {
+	/* { mode, hq_num, nq_num, lq_num, exq_num, gap_num} */
+	{HALMAC_TRX_MODE_NORMAL, 64, 64, 64, 0, 1},
+	{HALMAC_TRX_MODE_TRXSHARE, 64, 64, 64, 0, 1},
+	{HALMAC_TRX_MODE_WMM, 64, 64, 64, 0, 1},
+	{HALMAC_TRX_MODE_P2P, 64, 64, 64, 0, 1},
+	{HALMAC_TRX_MODE_LOOPBACK, 64, 64, 64, 0, 1},
+	{HALMAC_TRX_MODE_DELAY_LOOPBACK, 64, 64, 64, 0, 1},
+};
+
+/*USB 4 Bulkout Page Number*/
+static struct halmac_pg_num HALMAC_PG_NUM_4BULKOUT_8822B[] = {
+	/* { mode, hq_num, nq_num, lq_num, exq_num, gap_num} */
+	{HALMAC_TRX_MODE_NORMAL, 64, 64, 64, 64, 1},
+	{HALMAC_TRX_MODE_TRXSHARE, 64, 64, 64, 64, 1},
+	{HALMAC_TRX_MODE_WMM, 64, 64, 64, 64, 1},
+	{HALMAC_TRX_MODE_P2P, 64, 64, 64, 64, 1},
+	{HALMAC_TRX_MODE_LOOPBACK, 64, 64, 64, 64, 1},
+	{HALMAC_TRX_MODE_DELAY_LOOPBACK, 64, 64, 64, 64, 1},
+};
+
+static enum halmac_ret_status
+txdma_queue_mapping_8822b(struct halmac_adapter *adapter,
+			  enum halmac_trx_mode mode);
+
+static enum halmac_ret_status
+priority_queue_cfg_8822b(struct halmac_adapter *adapter,
+			 enum halmac_trx_mode mode);
+
+static enum halmac_ret_status
+set_trx_fifo_info_8822b(struct halmac_adapter *adapter,
+			enum halmac_trx_mode mode);
+enum halmac_ret_status
+mount_api_8822b(struct halmac_adapter *adapter)
+{
+	struct halmac_api *api = (struct halmac_api *)adapter->halmac_api;
+
+	adapter->chip_id = HALMAC_CHIP_ID_8822B;
+	adapter->hw_cfg_info.efuse_size = EFUSE_SIZE_8822B;
+	adapter->hw_cfg_info.eeprom_size = EEPROM_SIZE_8822B;
+	adapter->hw_cfg_info.bt_efuse_size = BT_EFUSE_SIZE_8822B;
+	adapter->hw_cfg_info.cam_entry_num = SEC_CAM_NUM_8822B;
+	adapter->hw_cfg_info.tx_fifo_size = TX_FIFO_SIZE_8822B;
+	adapter->hw_cfg_info.rx_fifo_size = RX_FIFO_SIZE_8822B;
+	adapter->hw_cfg_info.ac_oqt_size = OQT_ENTRY_AC_8822B;
+	adapter->hw_cfg_info.non_ac_oqt_size = OQT_ENTRY_NOAC_8822B;
+	adapter->hw_cfg_info.usb_txagg_num = BLK_DESC_NUM;
+	adapter->txff_alloc.rsvd_drv_pg_num = RSVD_PG_DRV_NUM;
+
+	api->halmac_init_trx_cfg = init_trx_cfg_8822b;
+	api->halmac_init_protocol_cfg = init_protocol_cfg_8822b;
+	api->halmac_init_h2c = init_h2c_8822b;
+	api->halmac_pinmux_get_func = pinmux_get_func_8822b;
+	api->halmac_pinmux_set_func = pinmux_set_func_8822b;
+	api->halmac_pinmux_free_func = pinmux_free_func_8822b;
+	api->halmac_get_hw_value = get_hw_value_8822b;
+	api->halmac_set_hw_value = set_hw_value_8822b;
+	api->halmac_cfg_drv_info = cfg_drv_info_8822b;
+	api->halmac_fill_txdesc_checksum = fill_txdesc_check_sum_8822b;
+	api->halmac_init_low_pwr = init_low_pwr_8822b;
+
+	if (adapter->intf == HALMAC_INTERFACE_SDIO) {
+		api->halmac_mac_power_switch = mac_pwr_switch_sdio_8822b;
+		api->halmac_phy_cfg = phy_cfg_sdio_8822b;
+		api->halmac_pcie_switch = pcie_switch_sdio_8822b;
+		api->halmac_interface_integration_tuning = intf_tun_sdio_8822b;
+		api->halmac_tx_allowed_sdio = tx_allowed_sdio_8822b;
+		api->halmac_get_sdio_tx_addr = get_sdio_tx_addr_8822b;
+		api->halmac_reg_read_8 = reg_r8_sdio_8822b;
+		api->halmac_reg_write_8 = reg_w8_sdio_8822b;
+		api->halmac_reg_read_16 = reg_r16_sdio_8822b;
+		api->halmac_reg_write_16 = reg_w16_sdio_8822b;
+		api->halmac_reg_read_32 = reg_r32_sdio_8822b;
+		api->halmac_reg_write_32 = reg_w32_sdio_8822b;
+
+		adapter->sdio_fs.macid_map_size = MACID_MAX_8822B * 2;
+		if (!adapter->sdio_fs.macid_map) {
+			adapter->sdio_fs.macid_map =
+			kzalloc(adapter->sdio_fs.macid_map_size, GFP_KERNEL);
+			if (!adapter->sdio_fs.macid_map)
+				pr_err("allocate macid_map!!\n");
+		}
+	} else if (adapter->intf == HALMAC_INTERFACE_USB) {
+		api->halmac_mac_power_switch = mac_pwr_switch_usb_8822b;
+		api->halmac_phy_cfg = phy_cfg_usb_8822b;
+		api->halmac_pcie_switch = pcie_switch_usb_8822b;
+		api->halmac_interface_integration_tuning = intf_tun_usb_8822b;
+	} else if (adapter->intf == HALMAC_INTERFACE_PCIE) {
+		api->halmac_mac_power_switch = mac_pwr_switch_pcie_8822b;
+		api->halmac_phy_cfg = phy_cfg_pcie_8822b;
+		api->halmac_pcie_switch = pcie_switch_8822b;
+		api->halmac_interface_integration_tuning = intf_tun_pcie_8822b;
+	} else {
+		pr_err("Undefined IC\n");
+		return HALMAC_RET_CHIP_NOT_SUPPORT;
+	}
+
+	return HALMAC_RET_SUCCESS;
+}
+
+/**
+ * init_trx_cfg_8822b() - config trx dma register
+ * @adapter : the adapter of halmac
+ * @mode : trx mode selection
+ * Author : KaiYuan Chang/Ivan Lin
+ * Return : enum halmac_ret_status
+ * More details of status code can be found in prototype document
+ */
+enum halmac_ret_status
+init_trx_cfg_8822b(struct halmac_adapter *adapter, enum halmac_trx_mode mode)
+{
+	u8 value8;
+	struct halmac_api *api = (struct halmac_api *)adapter->halmac_api;
+	enum halmac_ret_status status = HALMAC_RET_SUCCESS;
+
+	adapter->trx_mode = mode;
+
+	RT_TRACE(adapter->drv_adapter, COMP_HALMAC, DBG_DMESG, "%s ===>\n",
+		 __func__);
+
+	status = txdma_queue_mapping_8822b(adapter, mode);
+	if (status != HALMAC_RET_SUCCESS) {
+		pr_err("queue mapping\n");
+		return status;
+	}
+
+	value8 = 0;
+	HALMAC_REG_W8(REG_CR, value8);
+	value8 = MAC_TRX_ENABLE;
+	HALMAC_REG_W8(REG_CR, value8);
+	HALMAC_REG_W32(REG_H2CQ_CSR, BIT(31));
+
+	status = priority_queue_cfg_8822b(adapter, mode);
+	if (status != HALMAC_RET_SUCCESS) {
+		pr_err("halmac_txdma_queue_mapping fail!\n");
+		return status;
+	}
+
+	if (adapter->txff_alloc.rx_fifo_exp_mode !=
+	    HALMAC_RX_FIFO_EXPANDING_MODE_DISABLE)
+		HALMAC_REG_W8(REG_RX_DRVINFO_SZ, RX_DESC_DUMMY_SIZE_8822B >> 3);
+
+	status = init_h2c_8822b(adapter);
+	if (status != HALMAC_RET_SUCCESS) {
+		pr_err("init h2cq!\n");
+		return status;
+	}
+
+	if (adapter->intf == HALMAC_INTERFACE_USB)
+		HALMAC_REG_W8_SET(REG_TXDMA_PQ_MAP, BIT(0));
+
+	RT_TRACE(adapter->drv_adapter, COMP_HALMAC, DBG_DMESG, "%s <===\n",
+		 __func__);
+	return HALMAC_RET_SUCCESS;
+}
+
+static enum halmac_ret_status
+txdma_queue_mapping_8822b(struct halmac_adapter *adapter,
+			  enum halmac_trx_mode mode)
+{
+	u16 value16;
+	struct halmac_rqpn *cur_rqpn_sel = NULL;
+	enum halmac_ret_status status;
+	struct halmac_api *api = (struct halmac_api *)adapter->halmac_api;
+
+	if (adapter->intf == HALMAC_INTERFACE_SDIO) {
+		cur_rqpn_sel = HALMAC_RQPN_SDIO_8822B;
+	} else if (adapter->intf == HALMAC_INTERFACE_PCIE) {
+		cur_rqpn_sel = HALMAC_RQPN_PCIE_8822B;
+	} else if (adapter->intf == HALMAC_INTERFACE_USB) {
+		if (adapter->bulkout_num == 2) {
+			cur_rqpn_sel = HALMAC_RQPN_2BULKOUT_8822B;
+		} else if (adapter->bulkout_num == 3) {
+			cur_rqpn_sel = HALMAC_RQPN_3BULKOUT_8822B;
+		} else if (adapter->bulkout_num == 4) {
+			cur_rqpn_sel = HALMAC_RQPN_4BULKOUT_8822B;
+		} else {
+			pr_err("invalid intf\n");
+			return HALMAC_RET_NOT_SUPPORT;
+		}
+	} else {
+		return HALMAC_RET_NOT_SUPPORT;
+	}
+
+	status = rqpn_parser_88xx(adapter, mode, cur_rqpn_sel);
+	if (status != HALMAC_RET_SUCCESS)
+		return status;
+
+	value16 = 0;
+	value16 |= BIT_TXDMA_HIQ_MAP(adapter->pq_map[HALMAC_PQ_MAP_HI]);
+	value16 |= BIT_TXDMA_MGQ_MAP(adapter->pq_map[HALMAC_PQ_MAP_MG]);
+	value16 |= BIT_TXDMA_BKQ_MAP(adapter->pq_map[HALMAC_PQ_MAP_BK]);
+	value16 |= BIT_TXDMA_BEQ_MAP(adapter->pq_map[HALMAC_PQ_MAP_BE]);
+	value16 |= BIT_TXDMA_VIQ_MAP(adapter->pq_map[HALMAC_PQ_MAP_VI]);
+	value16 |= BIT_TXDMA_VOQ_MAP(adapter->pq_map[HALMAC_PQ_MAP_VO]);
+	HALMAC_REG_W16(REG_TXDMA_PQ_MAP, value16);
+
+	return HALMAC_RET_SUCCESS;
+}
+
+static enum halmac_ret_status
+priority_queue_cfg_8822b(struct halmac_adapter *adapter,
+			 enum halmac_trx_mode mode)
+{
+	u8 transfer_mode = 0;
+	u8 value8;
+	u32 cnt;
+	struct halmac_txff_allocation *txff_info = &adapter->txff_alloc;
+	enum halmac_ret_status status;
+	struct halmac_pg_num *cur_pg_num = NULL;
+	struct halmac_api *api = (struct halmac_api *)adapter->halmac_api;
+
+	status = set_trx_fifo_info_8822b(adapter, mode);
+	if (status != HALMAC_RET_SUCCESS) {
+		pr_err("set trx fifo!!\n");
+		return status;
+	}
+	if (adapter->intf == HALMAC_INTERFACE_SDIO) {
+		cur_pg_num = HALMAC_PG_NUM_SDIO_8822B;
+	} else if (adapter->intf == HALMAC_INTERFACE_PCIE) {
+		cur_pg_num = HALMAC_PG_NUM_PCIE_8822B;
+	} else if (adapter->intf == HALMAC_INTERFACE_USB) {
+		if (adapter->bulkout_num == 2) {
+			cur_pg_num = HALMAC_PG_NUM_2BULKOUT_8822B;
+		} else if (adapter->bulkout_num == 3) {
+			cur_pg_num = HALMAC_PG_NUM_3BULKOUT_8822B;
+		} else if (adapter->bulkout_num == 4) {
+			cur_pg_num = HALMAC_PG_NUM_4BULKOUT_8822B;
+		} else {
+			pr_err("interface not support\n");
+			return HALMAC_RET_NOT_SUPPORT;
+		}
+	} else {
+		return HALMAC_RET_NOT_SUPPORT;
+	}
+
+	status = pg_num_parser_88xx(adapter, mode, cur_pg_num);
+	if (status != HALMAC_RET_SUCCESS)
+		return status;
+
+	HALMAC_REG_W16(REG_FIFOPAGE_INFO_1, txff_info->high_queue_pg_num);
+	HALMAC_REG_W16(REG_FIFOPAGE_INFO_2, txff_info->low_queue_pg_num);
+	HALMAC_REG_W16(REG_FIFOPAGE_INFO_3, txff_info->normal_queue_pg_num);
+	HALMAC_REG_W16(REG_FIFOPAGE_INFO_4, txff_info->extra_queue_pg_num);
+	HALMAC_REG_W16(REG_FIFOPAGE_INFO_5, txff_info->pub_queue_pg_num);
+	HALMAC_REG_W32_SET(REG_RQPN_CTRL_2, BIT(31));
+
+	adapter->sdio_fs.hiq_pg_num = txff_info->high_queue_pg_num;
+	adapter->sdio_fs.miq_pg_num = txff_info->normal_queue_pg_num;
+	adapter->sdio_fs.lowq_pg_num = txff_info->low_queue_pg_num;
+	adapter->sdio_fs.pubq_pg_num = txff_info->pub_queue_pg_num;
+	adapter->sdio_fs.exq_pg_num = txff_info->extra_queue_pg_num;
+
+	HALMAC_REG_W16(REG_FIFOPAGE_CTRL_2, txff_info->rsvd_boundary);
+	HALMAC_REG_W8_SET(REG_FWHW_TXQ_CTRL + 2, BIT(4));
+
+	/*20170411 Soar*/
+	/* SDIO sometimes use two CMD52 to do HALMAC_REG_W16 */
+	/* and may cause a mismatch between HW status and Reg value. */
+	/* A patch is to write high byte first, suggested by Argis */
+	if (adapter->intf == HALMAC_INTERFACE_SDIO) {
+		value8 = (u8)(txff_info->rsvd_boundary >> 8 & 0xFF);
+		HALMAC_REG_W8(REG_BCNQ_BDNY_V1 + 1, value8);
+		value8 = (u8)(txff_info->rsvd_boundary & 0xFF);
+		HALMAC_REG_W8(REG_BCNQ_BDNY_V1, value8);
+	} else {
+		HALMAC_REG_W16(REG_BCNQ_BDNY_V1, txff_info->rsvd_boundary);
+	}
+
+	HALMAC_REG_W16(REG_FIFOPAGE_CTRL_2 + 2, txff_info->rsvd_boundary);
+
+	/*20170411 Soar*/
+	/* SDIO sometimes use two CMD52 to do HALMAC_REG_W16 */
+	/* and may cause a mismatch between HW status and Reg value. */
+	/* A patch is to write high byte first, suggested by Argis */
+	if (adapter->intf == HALMAC_INTERFACE_SDIO) {
+		value8 = (u8)(txff_info->rsvd_boundary >> 8 & 0xFF);
+		HALMAC_REG_W8(REG_BCNQ1_BDNY_V1 + 1, value8);
+		value8 = (u8)(txff_info->rsvd_boundary & 0xFF);
+		HALMAC_REG_W8(REG_BCNQ1_BDNY_V1, value8);
+	} else {
+		HALMAC_REG_W16(REG_BCNQ1_BDNY_V1, txff_info->rsvd_boundary);
+	}
+
+	HALMAC_REG_W32(REG_RXFF_BNDY,
+		       adapter->hw_cfg_info.rx_fifo_size -
+		       C2H_PKT_BUF_88XX - 1);
+
+	if (adapter->intf == HALMAC_INTERFACE_USB) {
+		value8 = HALMAC_REG_R8(REG_AUTO_LLT_V1);
+		value8 &= ~(BIT_MASK_BLK_DESC_NUM << BIT_SHIFT_BLK_DESC_NUM);
+		value8 |= (BLK_DESC_NUM << BIT_SHIFT_BLK_DESC_NUM);
+		HALMAC_REG_W8(REG_AUTO_LLT_V1, value8);
+
+		HALMAC_REG_W8(REG_AUTO_LLT_V1 + 3, BLK_DESC_NUM);
+		HALMAC_REG_W8_SET(REG_TXDMA_OFFSET_CHK + 1, BIT(1));
+	}
+
+	HALMAC_REG_W8_SET(REG_AUTO_LLT_V1, BIT_AUTO_INIT_LLT_V1);
+	cnt = 1000;
+	while (HALMAC_REG_R8(REG_AUTO_LLT_V1) & BIT_AUTO_INIT_LLT_V1) {
+		cnt--;
+		if (cnt == 0)
+			return HALMAC_RET_INIT_LLT_FAIL;
+	}
+
+	if (mode == HALMAC_TRX_MODE_DELAY_LOOPBACK) {
+		transfer_mode = HALMAC_TRNSFER_LOOPBACK_DELAY;
+		HALMAC_REG_W16(REG_WMAC_LBK_BUF_HD_V1,
+			       adapter->txff_alloc.rsvd_boundary);
+	} else if (mode == HALMAC_TRX_MODE_LOOPBACK) {
+		transfer_mode = HALMAC_TRNSFER_LOOPBACK_DIRECT;
+	} else {
+		transfer_mode = HALMAC_TRNSFER_NORMAL;
+	}
+
+	adapter->hw_cfg_info.trx_mode = transfer_mode;
+	HALMAC_REG_W8(REG_CR + 3, transfer_mode);
+
+	return HALMAC_RET_SUCCESS;
+}
+
+static enum halmac_ret_status
+set_trx_fifo_info_8822b(struct halmac_adapter *adapter,
+			enum halmac_trx_mode mode)
+{
+	u16 cur_pg_addr;
+	u32 txff_size = TX_FIFO_SIZE_8822B;
+	u32 rxff_size = RX_FIFO_SIZE_8822B;
+	struct halmac_txff_allocation *info = &adapter->txff_alloc;
+
+	if (info->rx_fifo_exp_mode == HALMAC_RX_FIFO_EXPANDING_MODE_1_BLOCK) {
+		txff_size = TX_FIFO_SIZE_RX_EXPAND_1BLK_8822B;
+		rxff_size = RX_FIFO_SIZE_RX_EXPAND_1BLK_8822B;
+	}
+
+	if (info->la_mode != HALMAC_LA_MODE_DISABLE) {
+		txff_size = TX_FIFO_SIZE_LA_8822B;
+		rxff_size = RX_FIFO_SIZE_8822B;
+	}
+
+	adapter->hw_cfg_info.tx_fifo_size = txff_size;
+	adapter->hw_cfg_info.rx_fifo_size = rxff_size;
+	info->tx_fifo_pg_num = (u16)(txff_size >> TX_PAGE_SIZE_SHIFT_88XX);
+
+	info->rsvd_pg_num = info->rsvd_drv_pg_num +
+					RSVD_PG_H2C_EXTRAINFO_NUM +
+					RSVD_PG_H2C_STATICINFO_NUM +
+					RSVD_PG_H2CQ_NUM +
+					RSVD_PG_CPU_INSTRUCTION_NUM +
+					RSVD_PG_FW_TXBUF_NUM +
+					RSVD_PG_CSIBUF_NUM;
+
+	if (mode == HALMAC_TRX_MODE_DELAY_LOOPBACK)
+		info->rsvd_pg_num += RSVD_PG_DLLB_NUM;
+
+	if (info->rsvd_pg_num > info->tx_fifo_pg_num)
+		return HALMAC_RET_CFG_TXFIFO_PAGE_FAIL;
+
+	info->acq_pg_num = info->tx_fifo_pg_num - info->rsvd_pg_num;
+	info->rsvd_boundary = info->tx_fifo_pg_num - info->rsvd_pg_num;
+
+	cur_pg_addr = info->tx_fifo_pg_num;
+	cur_pg_addr -= RSVD_PG_CSIBUF_NUM;
+	info->rsvd_csibuf_addr = cur_pg_addr;
+	cur_pg_addr -= RSVD_PG_FW_TXBUF_NUM;
+	info->rsvd_fw_txbuf_addr = cur_pg_addr;
+	cur_pg_addr -= RSVD_PG_CPU_INSTRUCTION_NUM;
+	info->rsvd_cpu_instr_addr = cur_pg_addr;
+	cur_pg_addr -= RSVD_PG_H2CQ_NUM;
+	info->rsvd_h2cq_addr = cur_pg_addr;
+	cur_pg_addr -= RSVD_PG_H2C_STATICINFO_NUM;
+	info->rsvd_h2c_sta_info_addr = cur_pg_addr;
+	cur_pg_addr -= RSVD_PG_H2C_EXTRAINFO_NUM;
+	info->rsvd_h2c_info_addr = cur_pg_addr;
+	cur_pg_addr -= info->rsvd_drv_pg_num;
+	info->rsvd_drv_addr = cur_pg_addr;
+
+	if (mode == HALMAC_TRX_MODE_DELAY_LOOPBACK)
+		info->rsvd_drv_addr -= RSVD_PG_DLLB_NUM;
+
+	if (info->rsvd_boundary != info->rsvd_drv_addr)
+		return HALMAC_RET_CFG_TXFIFO_PAGE_FAIL;
+
+	return HALMAC_RET_SUCCESS;
+}
+
+/**
+ * init_protocol_cfg_8822b() - config protocol register
+ * @adapter : the adapter of halmac
+ * Author : KaiYuan Chang/Ivan Lin
+ * Return : enum halmac_ret_status
+ * More details of status code can be found in prototype document
+ */
+enum halmac_ret_status
+init_protocol_cfg_8822b(struct halmac_adapter *adapter)
+{
+	u32 value32;
+	struct halmac_api *api = (struct halmac_api *)adapter->halmac_api;
+
+	RT_TRACE(adapter->drv_adapter, COMP_HALMAC, DBG_DMESG, "%s ===>\n",
+		 __func__);
+
+	HALMAC_REG_W8_CLR(REG_SW_AMPDU_BURST_MODE_CTRL, BIT(6));
+
+	HALMAC_REG_W8(REG_AMPDU_MAX_TIME_V1, WLAN_AMPDU_MAX_TIME);
+	HALMAC_REG_W8_SET(REG_TX_HANG_CTRL, BIT_EN_EOF_V1);
+
+	value32 = WLAN_RTS_LEN_TH | (WLAN_RTS_TX_TIME_TH << 8) |
+					(WLAN_MAX_AGG_PKT_LIMIT << 16) |
+					(WLAN_RTS_MAX_AGG_PKT_LIMIT << 24);
+	HALMAC_REG_W32(REG_PROT_MODE_CTRL, value32);
+
+	HALMAC_REG_W16(REG_BAR_MODE_CTRL + 2,
+		       WLAN_BAR_RETRY_LIMIT | WLAN_RA_TRY_RATE_AGG_LIMIT << 8);
+
+	HALMAC_REG_W8(REG_FAST_EDCA_VOVI_SETTING, WALN_FAST_EDCA_VO_TH);
+	HALMAC_REG_W8(REG_FAST_EDCA_VOVI_SETTING + 2, WLAN_FAST_EDCA_VI_TH);
+	HALMAC_REG_W8(REG_FAST_EDCA_BEBK_SETTING, WLAN_FAST_EDCA_BE_TH);
+	HALMAC_REG_W8(REG_FAST_EDCA_BEBK_SETTING + 2, WLAN_FAST_EDCA_BK_TH);
+
+	RT_TRACE(adapter->drv_adapter, COMP_HALMAC, DBG_DMESG, "%s <===\n",
+		 __func__);
+
+	return HALMAC_RET_SUCCESS;
+}
+
+/**
+ * init_h2c_8822b() - config h2c packet buffer
+ * @adapter : the adapter of halmac
+ * Author : KaiYuan Chang/Ivan Lin
+ * Return : enum halmac_ret_status
+ * More details of status code can be found in prototype document
+ */
+enum halmac_ret_status
+init_h2c_8822b(struct halmac_adapter *adapter)
+{
+	u8 value8;
+	u32 value32;
+	u32 h2cq_addr;
+	u32 h2cq_size;
+	struct halmac_txff_allocation *txff_info = &adapter->txff_alloc;
+	struct halmac_api *api = (struct halmac_api *)adapter->halmac_api;
+
+	h2cq_addr = txff_info->rsvd_h2cq_addr << TX_PAGE_SIZE_SHIFT_88XX;
+	h2cq_size = RSVD_PG_H2CQ_NUM << TX_PAGE_SIZE_SHIFT_88XX;
+
+	value32 = HALMAC_REG_R32(REG_H2C_HEAD);
+	value32 = (value32 & 0xFFFC0000) | h2cq_addr;
+	HALMAC_REG_W32(REG_H2C_HEAD, value32);
+
+	value32 = HALMAC_REG_R32(REG_H2C_READ_ADDR);
+	value32 = (value32 & 0xFFFC0000) | h2cq_addr;
+	HALMAC_REG_W32(REG_H2C_READ_ADDR, value32);
+
+	value32 = HALMAC_REG_R32(REG_H2C_TAIL);
+	value32 &= 0xFFFC0000;
+	value32 |= (h2cq_addr + h2cq_size);
+	HALMAC_REG_W32(REG_H2C_TAIL, value32);
+
+	value8 = HALMAC_REG_R8(REG_H2C_INFO);
+	value8 = (u8)((value8 & 0xFC) | 0x01);
+	HALMAC_REG_W8(REG_H2C_INFO, value8);
+
+	value8 = HALMAC_REG_R8(REG_H2C_INFO);
+	value8 = (u8)((value8 & 0xFB) | 0x04);
+	HALMAC_REG_W8(REG_H2C_INFO, value8);
+
+	value8 = HALMAC_REG_R8(REG_TXDMA_OFFSET_CHK + 1);
+	value8 = (u8)((value8 & 0x7f) | 0x80);
+	HALMAC_REG_W8(REG_TXDMA_OFFSET_CHK + 1, value8);
+
+	adapter->h2c_info.buf_size = h2cq_size;
+	get_h2c_buf_free_space_88xx(adapter);
+
+	if (adapter->h2c_info.buf_size != adapter->h2c_info.buf_fs) {
+		pr_err("get h2c free space error!\n");
+		return HALMAC_RET_GET_H2C_SPACE_ERR;
+	}
+
+	RT_TRACE(adapter->drv_adapter, COMP_HALMAC, DBG_DMESG, "h2c fs : %d\n",
+		 adapter->h2c_info.buf_fs);
+
+	return HALMAC_RET_SUCCESS;
+}
diff --git a/drivers/net/wireless/realtek/rtlwifi/halmac/halmac_88xx/halmac_8822b/halmac_init_8822b.h b/drivers/net/wireless/realtek/rtlwifi/halmac/halmac_88xx/halmac_8822b/halmac_init_8822b.h
new file mode 100644
index 000000000000..384a4890313f
--- /dev/null
+++ b/drivers/net/wireless/realtek/rtlwifi/halmac/halmac_88xx/halmac_8822b/halmac_init_8822b.h
@@ -0,0 +1,33 @@
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
+#ifndef _HALMAC_INIT_8822B_H_
+#define _HALMAC_INIT_8822B_H_
+
+#include "../../halmac_api.h"
+
+enum halmac_ret_status
+mount_api_8822b(struct halmac_adapter *adapter);
+
+enum halmac_ret_status
+init_trx_cfg_8822b(struct halmac_adapter *adapter, enum halmac_trx_mode mode);
+
+enum halmac_ret_status
+init_protocol_cfg_8822b(struct halmac_adapter *adapter);
+
+enum halmac_ret_status
+init_h2c_8822b(struct halmac_adapter *adapter);
+
+#endif/* _HALMAC_INIT_8822B_H_ */
diff --git a/drivers/net/wireless/realtek/rtlwifi/halmac/halmac_88xx/halmac_init_88xx.c b/drivers/net/wireless/realtek/rtlwifi/halmac/halmac_88xx/halmac_init_88xx.c
new file mode 100644
index 000000000000..a939c3237efa
--- /dev/null
+++ b/drivers/net/wireless/realtek/rtlwifi/halmac/halmac_88xx/halmac_init_88xx.c
@@ -0,0 +1,1071 @@
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
+#include "halmac_init_88xx.h"
+#include "halmac_88xx_cfg.h"
+#include "halmac_fw_88xx.h"
+#include "halmac_common_88xx.h"
+#include "halmac_cfg_wmac_88xx.h"
+#include "halmac_efuse_88xx.h"
+#include "halmac_mimo_88xx.h"
+#include "halmac_bb_rf_88xx.h"
+#include "halmac_sdio_88xx.h"
+#include "halmac_usb_88xx.h"
+#include "halmac_pcie_88xx.h"
+#include "halmac_gpio_88xx.h"
+#include "halmac_flash_88xx.h"
+
+#include "halmac_8822b/halmac_init_8822b.h"
+
+#define PLTFM_INFO_MALLOC_MAX_SIZE	16384
+#define PLTFM_INFO_RSVD_PG_SIZE		16384
+#define DLFW_PKT_MAX_SIZE		8192 /* need multiple of 2 */
+
+#define SYS_FUNC_EN		0xDC
+#define WLAN_SLOT_TIME		0x05
+#define WLAN_PIFS_TIME		0x19
+#define WLAN_SIFS_CCK_CONT_TX	0xA
+#define WLAN_SIFS_OFDM_CONT_TX	0xA
+#define WLAN_SIFS_CCK_TRX	0x10
+#define WLAN_SIFS_OFDM_TRX	0x10
+#define WLAN_VO_TXOP_LIMIT	0x186 /* unit : 32us */
+#define WLAN_VI_TXOP_LIMIT	0x3BC /* unit : 32us */
+#define WLAN_RDG_NAV		0x05
+#define WLAN_TXOP_NAV		0x1B
+#define WLAN_CCK_RX_TSF		0x30
+#define WLAN_OFDM_RX_TSF	0x30
+#define WLAN_TBTT_PROHIBIT	0x04 /* unit : 32us */
+#define WLAN_TBTT_HOLD_TIME	0x064 /* unit : 32us */
+#define WLAN_DRV_EARLY_INT	0x04
+#define WLAN_BCN_DMA_TIME	0x02
+#define WLAN_ACK_TO_CCK		0x40
+
+#define WLAN_RX_FILTER0		0x0FFFFFFF
+#define WLAN_RX_FILTER2		0xFFFF
+#define WLAN_RCR_CFG		0xE400220E
+#define WLAN_RXPKT_MAX_SZ	12288
+#define WLAN_RXPKT_MAX_SZ_512	(WLAN_RXPKT_MAX_SZ >> 9)
+
+#define WLAN_TX_FUNC_CFG1		0x30
+#define WLAN_TX_FUNC_CFG2		0x30
+#define WLAN_MAC_OPT_NORM_FUNC1		0x98
+#define WLAN_MAC_OPT_LB_FUNC1		0x80
+#define WLAN_MAC_OPT_FUNC2		0x30810041
+
+#define WLAN_SIFS_CFG	(WLAN_SIFS_CCK_CONT_TX | \
+			(WLAN_SIFS_OFDM_CONT_TX << BIT_SHIFT_SIFS_OFDM_CTX) | \
+			(WLAN_SIFS_CCK_TRX << BIT_SHIFT_SIFS_CCK_TRX) | \
+			(WLAN_SIFS_OFDM_TRX << BIT_SHIFT_SIFS_OFDM_TRX))
+
+#define WLAN_TBTT_TIME	(WLAN_TBTT_PROHIBIT |\
+			(WLAN_TBTT_HOLD_TIME << BIT_SHIFT_TBTT_HOLD_TIME_AP))
+
+#define WLAN_NAV_CFG		(WLAN_RDG_NAV | (WLAN_TXOP_NAV << 16))
+#define WLAN_RX_TSF_CFG		(WLAN_CCK_RX_TSF | (WLAN_OFDM_RX_TSF) << 8)
+
+static void
+init_state_machine_88xx(struct halmac_adapter *adapter);
+
+static enum halmac_ret_status
+verify_io_88xx(struct halmac_adapter *adapter);
+
+static enum halmac_ret_status
+verify_send_rsvd_page_88xx(struct halmac_adapter *adapter);
+
+void
+init_adapter_param_88xx(struct halmac_adapter *adapter)
+{
+	adapter->api_registry.rx_exp_en = 1;
+	adapter->api_registry.la_mode_en = 1;
+	adapter->api_registry.cfg_drv_rsvd_pg_en = 1;
+	adapter->api_registry.sdio_cmd53_4byte_en = 1;
+
+	adapter->efuse_map = (u8 *)NULL;
+	adapter->efuse_map_valid = 0;
+	adapter->efuse_end = 0;
+
+	adapter->dlfw_pkt_size = DLFW_PKT_MAX_SIZE;
+	adapter->pltfm_info.malloc_size = PLTFM_INFO_MALLOC_MAX_SIZE;
+	adapter->pltfm_info.rsvd_pg_size = PLTFM_INFO_RSVD_PG_SIZE;
+
+	adapter->cfg_param_info.buf = NULL;
+	adapter->cfg_param_info.buf_wptr = NULL;
+	adapter->cfg_param_info.num = 0;
+	adapter->cfg_param_info.full_fifo_mode = 0;
+	adapter->cfg_param_info.buf_size = 0;
+	adapter->cfg_param_info.avl_buf_size = 0;
+	adapter->cfg_param_info.offset_accum = 0;
+	adapter->cfg_param_info.value_accum = 0;
+
+	adapter->ch_sw_info.buf = NULL;
+	adapter->ch_sw_info.buf_wptr = NULL;
+	adapter->ch_sw_info.extra_info_en = 0;
+	adapter->ch_sw_info.buf_size = 0;
+	adapter->ch_sw_info.avl_buf_size = 0;
+	adapter->ch_sw_info.total_size = 0;
+	adapter->ch_sw_info.ch_num = 0;
+
+	adapter->drv_info_size = 0;
+	adapter->tx_desc_transfer = 0;
+
+	adapter->txff_alloc.tx_fifo_pg_num = 0;
+	adapter->txff_alloc.acq_pg_num = 0;
+	adapter->txff_alloc.rsvd_boundary = 0;
+	adapter->txff_alloc.rsvd_drv_addr = 0;
+	adapter->txff_alloc.rsvd_h2c_info_addr = 0;
+	adapter->txff_alloc.rsvd_h2cq_addr = 0;
+	adapter->txff_alloc.rsvd_cpu_instr_addr = 0;
+	adapter->txff_alloc.rsvd_fw_txbuf_addr = 0;
+	adapter->txff_alloc.pub_queue_pg_num = 0;
+	adapter->txff_alloc.high_queue_pg_num = 0;
+	adapter->txff_alloc.low_queue_pg_num = 0;
+	adapter->txff_alloc.normal_queue_pg_num = 0;
+	adapter->txff_alloc.extra_queue_pg_num = 0;
+
+	adapter->txff_alloc.la_mode = HALMAC_LA_MODE_DISABLE;
+	adapter->txff_alloc.rx_fifo_exp_mode =
+					HALMAC_RX_FIFO_EXPANDING_MODE_DISABLE;
+
+	adapter->hw_cfg_info.chk_security_keyid = 0;
+	adapter->hw_cfg_info.acq_num = 8;
+	adapter->hw_cfg_info.page_size = TX_PAGE_SIZE_88XX;
+	adapter->hw_cfg_info.tx_align_size = TX_ALIGN_SIZE_88XX;
+	adapter->hw_cfg_info.txdesc_size = TX_DESC_SIZE_88XX;
+	adapter->hw_cfg_info.rxdesc_size = RX_DESC_SIZE_88XX;
+	adapter->hw_cfg_info.rx_desc_fifo_size = 0;
+
+	adapter->sdio_cmd53_4byte = HALMAC_SDIO_CMD53_4BYTE_MODE_DISABLE;
+	adapter->sdio_hw_info.io_hi_speed_flag = 0;
+	adapter->sdio_hw_info.io_indir_flag = 0;
+	adapter->sdio_hw_info.spec_ver = HALMAC_SDIO_SPEC_VER_2_00;
+	adapter->sdio_hw_info.clock_speed = 50;
+	adapter->sdio_hw_info.block_size = 512;
+	adapter->sdio_hw_info.tx_seq = 1;
+	adapter->sdio_fs.macid_map = (u8 *)NULL;
+
+	adapter->pinmux_info.wl_led = 0;
+	adapter->pinmux_info.sdio_int = 0;
+	adapter->pinmux_info.sw_io_0 = 0;
+	adapter->pinmux_info.sw_io_1 = 0;
+	adapter->pinmux_info.sw_io_2 = 0;
+	adapter->pinmux_info.sw_io_3 = 0;
+	adapter->pinmux_info.sw_io_4 = 0;
+	adapter->pinmux_info.sw_io_5 = 0;
+	adapter->pinmux_info.sw_io_6 = 0;
+	adapter->pinmux_info.sw_io_7 = 0;
+	adapter->pinmux_info.sw_io_8 = 0;
+	adapter->pinmux_info.sw_io_9 = 0;
+	adapter->pinmux_info.sw_io_10 = 0;
+	adapter->pinmux_info.sw_io_11 = 0;
+	adapter->pinmux_info.sw_io_12 = 0;
+	adapter->pinmux_info.sw_io_13 = 0;
+	adapter->pinmux_info.sw_io_14 = 0;
+	adapter->pinmux_info.sw_io_15 = 0;
+
+	adapter->pcie_refautok_en = 1;
+	adapter->pwr_off_flow_flag = 0;
+
+	adapter->rx_ignore_info.hdr_chk_mask = 1;
+	adapter->rx_ignore_info.fcs_chk_mask = 1;
+	adapter->rx_ignore_info.hdr_chk_en = 0;
+	adapter->rx_ignore_info.fcs_chk_en = 0;
+	adapter->rx_ignore_info.cck_rst_en = 0;
+	adapter->rx_ignore_info.fcs_chk_thr = HALMAC_PSF_FCS_CHK_THR_28;
+
+	init_adapter_dynamic_param_88xx(adapter);
+	init_state_machine_88xx(adapter);
+}
+
+void
+init_adapter_dynamic_param_88xx(struct halmac_adapter *adapter)
+{
+	adapter->h2c_info.seq_num = 0;
+	adapter->h2c_info.buf_fs = 0;
+}
+
+enum halmac_ret_status
+mount_api_88xx(struct halmac_adapter *adapter)
+{
+	struct halmac_api *api = NULL;
+
+	adapter->halmac_api =
+		kzalloc(sizeof(struct halmac_api), GFP_KERNEL);
+	if (!adapter->halmac_api)
+		return HALMAC_RET_MALLOC_FAIL;
+
+	api = (struct halmac_api *)adapter->halmac_api;
+
+	api->halmac_read_efuse = NULL;
+	api->halmac_write_efuse = NULL;
+
+	/* Mount function pointer */
+	api->halmac_register_api = register_api_88xx;
+	api->halmac_download_firmware = download_firmware_88xx;
+	api->halmac_free_download_firmware = free_download_firmware_88xx;
+	api->halmac_get_fw_version = get_fw_version_88xx;
+	api->halmac_cfg_mac_addr = cfg_mac_addr_88xx;
+	api->halmac_cfg_bssid = cfg_bssid_88xx;
+	api->halmac_cfg_transmitter_addr = cfg_transmitter_addr_88xx;
+	api->halmac_cfg_net_type = cfg_net_type_88xx;
+	api->halmac_cfg_tsf_rst = cfg_tsf_rst_88xx;
+	api->halmac_cfg_bcn_space = cfg_bcn_space_88xx;
+	api->halmac_rw_bcn_ctrl = rw_bcn_ctrl_88xx;
+	api->halmac_cfg_multicast_addr = cfg_multicast_addr_88xx;
+	api->halmac_pre_init_system_cfg = pre_init_system_cfg_88xx;
+	api->halmac_init_system_cfg = init_system_cfg_88xx;
+	api->halmac_init_edca_cfg = init_edca_cfg_88xx;
+	api->halmac_cfg_operation_mode = cfg_operation_mode_88xx;
+	api->halmac_cfg_ch_bw = cfg_ch_bw_88xx;
+	api->halmac_cfg_bw = cfg_bw_88xx;
+	api->halmac_init_wmac_cfg = init_wmac_cfg_88xx;
+	api->halmac_init_mac_cfg = init_mac_cfg_88xx;
+	api->halmac_dump_efuse_map = dump_efuse_map_88xx;
+	api->halmac_dump_efuse_map_bt = dump_efuse_map_bt_88xx;
+	api->halmac_write_efuse_bt = write_efuse_bt_88xx;
+	api->halmac_read_efuse_bt = read_efuse_bt_88xx;
+	api->halmac_cfg_efuse_auto_check = cfg_efuse_auto_check_88xx;
+	api->halmac_dump_logical_efuse_map = dump_log_efuse_map_88xx;
+	api->halmac_pg_efuse_by_map = pg_efuse_by_map_88xx;
+	api->halmac_mask_logical_efuse = mask_log_efuse_88xx;
+	api->halmac_get_efuse_size = get_efuse_size_88xx;
+	api->halmac_get_efuse_available_size = get_efuse_available_size_88xx;
+	api->halmac_get_c2h_info = get_c2h_info_88xx;
+
+	api->halmac_get_logical_efuse_size = get_log_efuse_size_88xx;
+
+	api->halmac_write_logical_efuse = write_log_efuse_88xx;
+	api->halmac_read_logical_efuse = read_logical_efuse_88xx;
+
+	api->halmac_ofld_func_cfg = ofld_func_cfg_88xx;
+	api->halmac_h2c_lb = h2c_lb_88xx;
+	api->halmac_debug = mac_debug_88xx;
+	api->halmac_cfg_parameter = cfg_parameter_88xx;
+	api->halmac_update_datapack = update_datapack_88xx;
+	api->halmac_run_datapack = run_datapack_88xx;
+	api->halmac_send_bt_coex = send_bt_coex_88xx;
+	api->halmac_verify_platform_api = verify_platform_api_88xx;
+	api->halmac_update_packet = update_packet_88xx;
+	api->halmac_bcn_ie_filter = bcn_ie_filter_88xx;
+	api->halmac_cfg_txbf = cfg_txbf_88xx;
+	api->halmac_cfg_mumimo = cfg_mumimo_88xx;
+	api->halmac_cfg_sounding = cfg_sounding_88xx;
+	api->halmac_del_sounding = del_sounding_88xx;
+	api->halmac_su_bfer_entry_init = su_bfer_entry_init_88xx;
+	api->halmac_su_bfee_entry_init = su_bfee_entry_init_88xx;
+	api->halmac_mu_bfer_entry_init = mu_bfer_entry_init_88xx;
+	api->halmac_mu_bfee_entry_init = mu_bfee_entry_init_88xx;
+	api->halmac_su_bfer_entry_del = su_bfer_entry_del_88xx;
+	api->halmac_su_bfee_entry_del = su_bfee_entry_del_88xx;
+	api->halmac_mu_bfer_entry_del = mu_bfer_entry_del_88xx;
+	api->halmac_mu_bfee_entry_del = mu_bfee_entry_del_88xx;
+
+	api->halmac_add_ch_info = add_ch_info_88xx;
+	api->halmac_add_extra_ch_info = add_extra_ch_info_88xx;
+	api->halmac_ctrl_ch_switch = ctrl_ch_switch_88xx;
+	api->halmac_p2pps = p2pps_88xx;
+	api->halmac_clear_ch_info = clear_ch_info_88xx;
+	api->halmac_send_general_info = send_general_info_88xx;
+
+	api->halmac_start_iqk = start_iqk_88xx;
+	api->halmac_ctrl_pwr_tracking = ctrl_pwr_tracking_88xx;
+	api->halmac_psd = psd_88xx;
+	api->halmac_cfg_la_mode = cfg_la_mode_88xx;
+	api->halmac_cfg_rxff_expand_mode = cfg_rxfifo_expand_mode_88xx;
+
+	api->halmac_config_security = config_security_88xx;
+	api->halmac_get_used_cam_entry_num = get_used_cam_entry_num_88xx;
+	api->halmac_read_cam_entry = read_cam_entry_88xx;
+	api->halmac_write_cam = write_cam_88xx;
+	api->halmac_clear_cam_entry = clear_cam_entry_88xx;
+
+	api->halmac_cfg_drv_rsvd_pg_num = cfg_drv_rsvd_pg_num_88xx;
+	api->halmac_get_chip_version = get_version_88xx;
+
+	api->halmac_query_status = query_status_88xx;
+	api->halmac_reset_feature = reset_ofld_feature_88xx;
+	api->halmac_check_fw_status = check_fw_status_88xx;
+	api->halmac_dump_fw_dmem = dump_fw_dmem_88xx;
+	api->halmac_cfg_max_dl_size = cfg_max_dl_size_88xx;
+
+	api->halmac_dump_fifo = dump_fifo_88xx;
+	api->halmac_get_fifo_size = get_fifo_size_88xx;
+
+	api->halmac_chk_txdesc = chk_txdesc_88xx;
+	api->halmac_dl_drv_rsvd_page = dl_drv_rsvd_page_88xx;
+	api->halmac_cfg_csi_rate = cfg_csi_rate_88xx;
+
+	api->halmac_sdio_cmd53_4byte = sdio_cmd53_4byte_88xx;
+	api->halmac_sdio_hw_info = sdio_hw_info_88xx;
+
+	api->halmac_init_sdio_cfg = init_sdio_cfg_88xx;
+	api->halmac_init_usb_cfg = init_usb_cfg_88xx;
+	api->halmac_init_pcie_cfg = init_pcie_cfg_88xx;
+	api->halmac_deinit_sdio_cfg = deinit_sdio_cfg_88xx;
+	api->halmac_deinit_usb_cfg = deinit_usb_cfg_88xx;
+	api->halmac_deinit_pcie_cfg = deinit_pcie_cfg_88xx;
+	api->halmac_txfifo_is_empty = txfifo_is_empty_88xx;
+	api->halmac_download_flash = download_flash_88xx;
+	api->halmac_read_flash = read_flash_88xx;
+	api->halmac_erase_flash = erase_flash_88xx;
+	api->halmac_check_flash = check_flash_88xx;
+	api->halmac_cfg_edca_para = cfg_edca_para_88xx;
+	api->halmac_pinmux_wl_led_mode = pinmux_wl_led_mode_88xx;
+	api->halmac_pinmux_wl_led_sw_ctrl = pinmux_wl_led_sw_ctrl_88xx;
+	api->halmac_pinmux_sdio_int_polarity = pinmux_sdio_int_polarity_88xx;
+	api->halmac_pinmux_gpio_mode = pinmux_gpio_mode_88xx;
+	api->halmac_pinmux_gpio_output = pinmux_gpio_output_88xx;
+	api->halmac_pinmux_pin_status = pinmux_pin_status_88xx;
+
+	api->halmac_rx_cut_amsdu_cfg = rx_cut_amsdu_cfg_88xx;
+	api->halmac_fw_snding = fw_snding_88xx;
+	api->halmac_get_mac_addr = get_mac_addr_88xx;
+
+	api->halmac_enter_cpu_sleep_mode = enter_cpu_sleep_mode_88xx;
+	api->halmac_get_cpu_mode = get_cpu_mode_88xx;
+	api->halmac_drv_fwctrl = drv_fwctrl_88xx;
+	api->halmac_en_ref_autok_pcie = en_ref_autok_88xx;
+
+	if (adapter->intf == HALMAC_INTERFACE_SDIO) {
+		api->halmac_cfg_rx_aggregation = cfg_sdio_rx_agg_88xx;
+		api->halmac_init_interface_cfg = init_sdio_cfg_88xx;
+		api->halmac_deinit_interface_cfg = deinit_sdio_cfg_88xx;
+		api->halmac_cfg_tx_agg_align = cfg_txagg_sdio_align_88xx;
+		api->halmac_set_bulkout_num = set_sdio_bulkout_num_88xx;
+		api->halmac_get_usb_bulkout_id = get_sdio_bulkout_id_88xx;
+		api->halmac_reg_read_indirect_32 = sdio_indirect_reg_r32_88xx;
+		api->halmac_reg_sdio_cmd53_read_n = sdio_reg_rn_88xx;
+	} else if (adapter->intf == HALMAC_INTERFACE_USB) {
+		api->halmac_cfg_rx_aggregation = cfg_usb_rx_agg_88xx;
+		api->halmac_init_interface_cfg = init_usb_cfg_88xx;
+		api->halmac_deinit_interface_cfg = deinit_usb_cfg_88xx;
+		api->halmac_cfg_tx_agg_align = cfg_txagg_usb_align_88xx;
+		api->halmac_tx_allowed_sdio = tx_allowed_usb_88xx;
+		api->halmac_set_bulkout_num = set_usb_bulkout_num_88xx;
+		api->halmac_get_sdio_tx_addr = get_usb_tx_addr_88xx;
+		api->halmac_get_usb_bulkout_id = get_usb_bulkout_id_88xx;
+		api->halmac_reg_read_8 = reg_r8_usb_88xx;
+		api->halmac_reg_write_8 = reg_w8_usb_88xx;
+		api->halmac_reg_read_16 = reg_r16_usb_88xx;
+		api->halmac_reg_write_16 = reg_w16_usb_88xx;
+		api->halmac_reg_read_32 = reg_r32_usb_88xx;
+		api->halmac_reg_write_32 = reg_w32_usb_88xx;
+		api->halmac_reg_read_indirect_32 = usb_indirect_reg_r32_88xx;
+		api->halmac_reg_sdio_cmd53_read_n = usb_reg_rn_88xx;
+	} else if (adapter->intf == HALMAC_INTERFACE_PCIE) {
+		api->halmac_cfg_rx_aggregation = cfg_pcie_rx_agg_88xx;
+		api->halmac_init_interface_cfg = init_pcie_cfg_88xx;
+		api->halmac_deinit_interface_cfg = deinit_pcie_cfg_88xx;
+		api->halmac_cfg_tx_agg_align = cfg_txagg_pcie_align_88xx;
+		api->halmac_tx_allowed_sdio = tx_allowed_pcie_88xx;
+		api->halmac_set_bulkout_num = set_pcie_bulkout_num_88xx;
+		api->halmac_get_sdio_tx_addr = get_pcie_tx_addr_88xx;
+		api->halmac_get_usb_bulkout_id = get_pcie_bulkout_id_88xx;
+		api->halmac_reg_read_8 = reg_r8_pcie_88xx;
+		api->halmac_reg_write_8 = reg_w8_pcie_88xx;
+		api->halmac_reg_read_16 = reg_r16_pcie_88xx;
+		api->halmac_reg_write_16 = reg_w16_pcie_88xx;
+		api->halmac_reg_read_32 = reg_r32_pcie_88xx;
+		api->halmac_reg_write_32 = reg_w32_pcie_88xx;
+		api->halmac_reg_read_indirect_32 = pcie_indirect_reg_r32_88xx;
+		api->halmac_reg_sdio_cmd53_read_n = pcie_reg_rn_88xx;
+	} else {
+		pr_err("Set halmac io function Error!!\n");
+	}
+
+	if (adapter->chip_id == HALMAC_CHIP_ID_8822B) {
+		mount_api_8822b(adapter);
+	} else if (adapter->chip_id == HALMAC_CHIP_ID_8821C) {
+	} else if (adapter->chip_id == HALMAC_CHIP_ID_8822C) {
+	} else {
+		pr_err("Chip ID undefine!!\n");
+		return HALMAC_RET_CHIP_NOT_SUPPORT;
+	}
+
+	return HALMAC_RET_SUCCESS;
+}
+
+static void
+init_state_machine_88xx(struct halmac_adapter *adapter)
+{
+	struct halmac_state *state = &adapter->halmac_state;
+
+	init_ofld_feature_state_machine_88xx(adapter);
+
+	state->api_state = HALMAC_API_STATE_INIT;
+
+	state->dlfw_state = HALMAC_DLFW_NONE;
+	state->mac_pwr = HALMAC_MAC_POWER_OFF;
+	state->gpio_cfg_state = HALMAC_GPIO_CFG_STATE_IDLE;
+	state->rsvd_pg_state = HALMAC_RSVD_PG_STATE_IDLE;
+}
+
+void
+init_ofld_feature_state_machine_88xx(struct halmac_adapter *adapter)
+{
+	struct halmac_state *state = &adapter->halmac_state;
+
+	state->efuse_state.cmd_cnstr_state = HALMAC_CMD_CNSTR_IDLE;
+	state->efuse_state.proc_status = HALMAC_CMD_PROCESS_IDLE;
+	state->efuse_state.seq_num = adapter->h2c_info.seq_num;
+
+	state->cfg_param_state.cmd_cnstr_state = HALMAC_CMD_CNSTR_IDLE;
+	state->cfg_param_state.proc_status = HALMAC_CMD_PROCESS_IDLE;
+	state->cfg_param_state.seq_num = adapter->h2c_info.seq_num;
+
+	state->scan_state.cmd_cnstr_state = HALMAC_CMD_CNSTR_IDLE;
+	state->scan_state.proc_status = HALMAC_CMD_PROCESS_IDLE;
+	state->scan_state.seq_num = adapter->h2c_info.seq_num;
+
+	state->update_pkt_state.proc_status = HALMAC_CMD_PROCESS_IDLE;
+	state->update_pkt_state.seq_num = adapter->h2c_info.seq_num;
+
+	state->iqk_state.proc_status = HALMAC_CMD_PROCESS_IDLE;
+	state->iqk_state.seq_num = adapter->h2c_info.seq_num;
+
+	state->pwr_trk_state.proc_status = HALMAC_CMD_PROCESS_IDLE;
+	state->pwr_trk_state.seq_num = adapter->h2c_info.seq_num;
+
+	state->psd_state.proc_status = HALMAC_CMD_PROCESS_IDLE;
+	state->psd_state.seq_num = adapter->h2c_info.seq_num;
+	state->psd_state.data_size = 0;
+	state->psd_state.seg_size = 0;
+	state->psd_state.data = NULL;
+
+	state->fw_snding_state.cmd_cnstr_state = HALMAC_CMD_CNSTR_IDLE;
+	state->fw_snding_state.proc_status = HALMAC_CMD_PROCESS_IDLE;
+	state->fw_snding_state.seq_num = adapter->h2c_info.seq_num;
+
+	state->wlcpu_mode = HALMAC_WLCPU_ACTIVE;
+}
+
+/**
+ * register_api_88xx() - register feature list
+ * @adapter
+ * @registry : feature list, 1->enable 0->disable
+ * Author : Ivan Lin
+ *
+ * Default is enable all api registry
+ *
+ * Return : enum halmac_ret_status
+ * More details of status code can be found in prototype document
+ */
+enum halmac_ret_status
+register_api_88xx(struct halmac_adapter *adapter,
+		  struct halmac_api_registry *registry)
+{
+	if (!registry)
+		return HALMAC_RET_NULL_POINTER;
+
+	RT_TRACE(adapter->drv_adapter, COMP_HALMAC, DBG_DMESG, "%s ===>\n",
+		 __func__);
+
+	memcpy(&adapter->api_registry, registry, sizeof(*registry));
+
+	RT_TRACE(adapter->drv_adapter, COMP_HALMAC, DBG_DMESG, "%s <===\n",
+		 __func__);
+
+	return HALMAC_RET_SUCCESS;
+}
+
+/**
+ * pre_init_system_cfg_88xx() - pre-init system config
+ * @adapter : the adapter of halmac
+ * Author : KaiYuan Chang/Ivan Lin
+ * Return : enum halmac_ret_status
+ * More details of status code can be found in prototype document
+ */
+enum halmac_ret_status
+pre_init_system_cfg_88xx(struct halmac_adapter *adapter)
+{
+	u32 value32;
+	struct halmac_api *api = (struct halmac_api *)adapter->halmac_api;
+	u8 enable_bb;
+
+	RT_TRACE(adapter->drv_adapter, COMP_HALMAC, DBG_DMESG, "%s ===>\n",
+		 __func__);
+
+	HALMAC_REG_W8(REG_RSV_CTRL, 0);
+
+	if (adapter->intf == HALMAC_INTERFACE_SDIO) {
+		if (leave_sdio_suspend_88xx(adapter) != HALMAC_RET_SUCCESS)
+			return HALMAC_RET_SDIO_LEAVE_SUSPEND_FAIL;
+	} else if (adapter->intf == HALMAC_INTERFACE_USB) {
+		if (HALMAC_REG_R8(REG_SYS_CFG2 + 3) == 0x20)
+			HALMAC_REG_W8(0xFE5B, HALMAC_REG_R8(0xFE5B) | BIT(4));
+	} else if (adapter->intf == HALMAC_INTERFACE_PCIE) {
+		/* For PCIE power on fail issue */
+		HALMAC_REG_W8(REG_HCI_OPT_CTRL + 1,
+			      HALMAC_REG_R8(REG_HCI_OPT_CTRL + 1) | BIT(0));
+	}
+
+	/* Config PIN Mux */
+	value32 = HALMAC_REG_R32(REG_PAD_CTRL1);
+	value32 = value32 & (~(BIT(28) | BIT(29)));
+	value32 = value32 | BIT(28) | BIT(29);
+	HALMAC_REG_W32(REG_PAD_CTRL1, value32);
+
+	value32 = HALMAC_REG_R32(REG_LED_CFG);
+	value32 = value32 & (~(BIT(25) | BIT(26)));
+	HALMAC_REG_W32(REG_LED_CFG, value32);
+
+	value32 = HALMAC_REG_R32(REG_GPIO_MUXCFG);
+	value32 = value32 & (~(BIT(2)));
+	value32 = value32 | BIT(2);
+	HALMAC_REG_W32(REG_GPIO_MUXCFG, value32);
+
+	enable_bb = 0;
+	set_hw_value_88xx(adapter, HALMAC_HW_EN_BB_RF, &enable_bb);
+
+	if (HALMAC_REG_R8(REG_SYS_CFG1 + 2) & BIT(4)) {
+		pr_err("test mode!!\n");
+		return HALMAC_RET_WLAN_MODE_FAIL;
+	}
+
+	RT_TRACE(adapter->drv_adapter, COMP_HALMAC, DBG_DMESG, "%s <===\n",
+		 __func__);
+
+	return HALMAC_RET_SUCCESS;
+}
+
+/**
+ * init_system_cfg_88xx() -  init system config
+ * @adapter : the adapter of halmac
+ * Author : KaiYuan Chang/Ivan Lin
+ * Return : enum halmac_ret_status
+ * More details of status code can be found in prototype document
+ */
+enum halmac_ret_status
+init_system_cfg_88xx(struct halmac_adapter *adapter)
+{
+	struct halmac_api *api = (struct halmac_api *)adapter->halmac_api;
+	u32 tmp = 0;
+	u32 value32;
+	enum halmac_ret_status status;
+	u8 hwval;
+
+	RT_TRACE(adapter->drv_adapter, COMP_HALMAC, DBG_DMESG, "%s ===>\n",
+		 __func__);
+
+	if (adapter->intf == HALMAC_INTERFACE_PCIE) {
+		hwval = 1;
+		status = api->halmac_set_hw_value(adapter,
+						  HALMAC_HW_PCIE_REF_AUTOK,
+						  &hwval);
+		if (status != HALMAC_RET_SUCCESS)
+			return status;
+	}
+
+	value32 = HALMAC_REG_R32(REG_SYS_SDIO_CTRL) | BIT_LTE_MUX_CTRL_PATH;
+	HALMAC_REG_W32(REG_SYS_SDIO_CTRL, value32);
+
+	value32 = HALMAC_REG_R32(REG_CPU_DMEM_CON) | BIT_WL_PLATFORM_RST;
+	HALMAC_REG_W32(REG_CPU_DMEM_CON, value32);
+
+	HALMAC_REG_W8(REG_SYS_FUNC_EN + 1, SYS_FUNC_EN);
+
+	/*disable boot-from-flash for driver's DL FW*/
+	tmp = HALMAC_REG_R32(REG_MCUFW_CTRL);
+	if (tmp & BIT_BOOT_FSPI_EN) {
+		HALMAC_REG_W32(REG_MCUFW_CTRL, tmp & (~BIT_BOOT_FSPI_EN));
+		value32 = HALMAC_REG_R32(REG_GPIO_MUXCFG) & (~BIT_FSPI_EN);
+		HALMAC_REG_W32(REG_GPIO_MUXCFG, value32);
+	}
+
+	RT_TRACE(adapter->drv_adapter, COMP_HALMAC, DBG_DMESG, "%s <===\n",
+		 __func__);
+
+	return HALMAC_RET_SUCCESS;
+}
+
+/**
+ * init_edca_cfg_88xx() - init EDCA config
+ * @adapter : the adapter of halmac
+ * Author : KaiYuan Chang/Ivan Lin
+ * Return : enum halmac_ret_status
+ * More details of status code can be found in prototype document
+ */
+enum halmac_ret_status
+init_edca_cfg_88xx(struct halmac_adapter *adapter)
+{
+	struct halmac_api *api = (struct halmac_api *)adapter->halmac_api;
+
+	RT_TRACE(adapter->drv_adapter, COMP_HALMAC, DBG_DMESG, "%s ===>\n",
+		 __func__);
+
+	/* Clear TX pause */
+	HALMAC_REG_W16(REG_TXPAUSE, 0x0000);
+
+	HALMAC_REG_W8(REG_SLOT, WLAN_SLOT_TIME);
+	HALMAC_REG_W8(REG_PIFS, WLAN_PIFS_TIME);
+	HALMAC_REG_W32(REG_SIFS, WLAN_SIFS_CFG);
+
+	HALMAC_REG_W16(REG_EDCA_VO_PARAM + 2, WLAN_VO_TXOP_LIMIT);
+	HALMAC_REG_W16(REG_EDCA_VI_PARAM + 2, WLAN_VI_TXOP_LIMIT);
+
+	HALMAC_REG_W32(REG_RD_NAV_NXT, WLAN_NAV_CFG);
+	HALMAC_REG_W16(REG_RXTSF_OFFSET_CCK, WLAN_RX_TSF_CFG);
+
+	/* Set beacon cotnrol - enable TSF and other related functions */
+	HALMAC_REG_W8(REG_BCN_CTRL, (u8)(HALMAC_REG_R8(REG_BCN_CTRL) |
+					  BIT_EN_BCN_FUNCTION));
+
+	/* Set send beacon related registers */
+	HALMAC_REG_W32(REG_TBTT_PROHIBIT, WLAN_TBTT_TIME);
+	HALMAC_REG_W8(REG_DRVERLYINT, WLAN_DRV_EARLY_INT);
+	HALMAC_REG_W8(REG_BCNDMATIM, WLAN_BCN_DMA_TIME);
+
+	HALMAC_REG_W8_CLR(REG_TX_PTCL_CTRL + 1, BIT(4));
+
+	RT_TRACE(adapter->drv_adapter, COMP_HALMAC, DBG_DMESG, "%s <===\n",
+		 __func__);
+
+	return HALMAC_RET_SUCCESS;
+}
+
+/**
+ * init_wmac_cfg_88xx() - init wmac config
+ * @adapter : the adapter of halmac
+ * Author : KaiYuan Chang/Ivan Lin
+ * Return : enum halmac_ret_status
+ * More details of status code can be found in prototype document
+ */
+enum halmac_ret_status
+init_wmac_cfg_88xx(struct halmac_adapter *adapter)
+{
+	u8 value8;
+	struct halmac_api *api = (struct halmac_api *)adapter->halmac_api;
+	enum halmac_ret_status status = HALMAC_RET_SUCCESS;
+
+	RT_TRACE(adapter->drv_adapter, COMP_HALMAC, DBG_DMESG, "%s ===>\n",
+		 __func__);
+
+	HALMAC_REG_W32(REG_RXFLTMAP0, WLAN_RX_FILTER0);
+	HALMAC_REG_W16(REG_RXFLTMAP2, WLAN_RX_FILTER2);
+
+	HALMAC_REG_W32(REG_RCR, WLAN_RCR_CFG);
+
+	HALMAC_REG_W8(REG_RX_PKT_LIMIT, WLAN_RXPKT_MAX_SZ_512);
+
+	HALMAC_REG_W8(REG_TCR + 2, WLAN_TX_FUNC_CFG2);
+	HALMAC_REG_W8(REG_TCR + 1, WLAN_TX_FUNC_CFG1);
+
+	HALMAC_REG_W32(REG_WMAC_OPTION_FUNCTION + 8, WLAN_MAC_OPT_FUNC2);
+
+	if (adapter->hw_cfg_info.trx_mode == HALMAC_TRNSFER_NORMAL)
+		value8 = WLAN_MAC_OPT_NORM_FUNC1;
+	else
+		value8 = WLAN_MAC_OPT_LB_FUNC1;
+
+	HALMAC_REG_W8(REG_WMAC_OPTION_FUNCTION + 4, value8);
+
+	status = api->halmac_init_low_pwr(adapter);
+	if (status != HALMAC_RET_SUCCESS)
+		return status;
+
+	RT_TRACE(adapter->drv_adapter, COMP_HALMAC, DBG_DMESG, "%s <===\n",
+		 __func__);
+
+	return HALMAC_RET_SUCCESS;
+}
+
+/**
+ * init_mac_cfg_88xx() - config page1~page7 register
+ * @adapter : the adapter of halmac
+ * @mode : trx mode
+ * Author : KaiYuan Chang/Ivan Lin
+ * Return : enum halmac_ret_status
+ * More details of status code can be found in prototype document
+ */
+enum halmac_ret_status
+init_mac_cfg_88xx(struct halmac_adapter *adapter, enum halmac_trx_mode mode)
+{
+	struct halmac_api *api = (struct halmac_api *)adapter->halmac_api;
+	enum halmac_ret_status status = HALMAC_RET_SUCCESS;
+
+	RT_TRACE(adapter->drv_adapter, COMP_HALMAC, DBG_DMESG, "%s ===>\n",
+		 __func__);
+
+	status = api->halmac_init_trx_cfg(adapter, mode);
+	if (status != HALMAC_RET_SUCCESS) {
+		pr_err("init trx %x\n", status);
+		return status;
+	}
+
+	status = api->halmac_init_protocol_cfg(adapter);
+	if (status != HALMAC_RET_SUCCESS) {
+		pr_err("init ptcl %x\n", status);
+		return status;
+	}
+
+	status = init_edca_cfg_88xx(adapter);
+	if (status != HALMAC_RET_SUCCESS) {
+		pr_err("init edca %x\n", status);
+		return status;
+	}
+
+	status = init_wmac_cfg_88xx(adapter);
+	if (status != HALMAC_RET_SUCCESS) {
+		pr_err("init wmac %x\n", status);
+		return status;
+	}
+
+	RT_TRACE(adapter->drv_adapter, COMP_HALMAC, DBG_DMESG, "%s <===\n",
+		 __func__);
+
+	return status;
+}
+
+/**
+ * reset_ofld_feature_88xx() -reset async api cmd status
+ * @adapter : the adapter of halmac
+ * @feature_id : feature_id
+ * Author : Ivan Lin/KaiYuan Chang
+ * Return : enum halmac_ret_status.
+ * More details of status code can be found in prototype document
+ */
+enum halmac_ret_status
+reset_ofld_feature_88xx(struct halmac_adapter *adapter,
+			enum halmac_feature_id feature_id)
+{
+	struct halmac_state *state = &adapter->halmac_state;
+
+	RT_TRACE(adapter->drv_adapter, COMP_HALMAC, DBG_DMESG, "%s ===>\n",
+		 __func__);
+
+	switch (feature_id) {
+	case HALMAC_FEATURE_CFG_PARA:
+		state->cfg_param_state.proc_status = HALMAC_CMD_PROCESS_IDLE;
+		state->cfg_param_state.cmd_cnstr_state = HALMAC_CMD_CNSTR_IDLE;
+		break;
+	case HALMAC_FEATURE_DUMP_PHYSICAL_EFUSE:
+	case HALMAC_FEATURE_DUMP_LOGICAL_EFUSE:
+		state->efuse_state.proc_status = HALMAC_CMD_PROCESS_IDLE;
+		state->efuse_state.cmd_cnstr_state = HALMAC_CMD_CNSTR_IDLE;
+		break;
+	case HALMAC_FEATURE_CHANNEL_SWITCH:
+		state->scan_state.proc_status = HALMAC_CMD_PROCESS_IDLE;
+		state->scan_state.cmd_cnstr_state = HALMAC_CMD_CNSTR_IDLE;
+		break;
+	case HALMAC_FEATURE_UPDATE_PACKET:
+		state->update_pkt_state.proc_status = HALMAC_CMD_PROCESS_IDLE;
+		break;
+	case HALMAC_FEATURE_IQK:
+		state->iqk_state.proc_status = HALMAC_CMD_PROCESS_IDLE;
+		break;
+	case HALMAC_FEATURE_POWER_TRACKING:
+		state->pwr_trk_state.proc_status = HALMAC_CMD_PROCESS_IDLE;
+		break;
+	case HALMAC_FEATURE_PSD:
+		state->psd_state.proc_status = HALMAC_CMD_PROCESS_IDLE;
+		break;
+	case HALMAC_FEATURE_FW_SNDING:
+		state->fw_snding_state.proc_status = HALMAC_CMD_PROCESS_IDLE;
+		state->fw_snding_state.cmd_cnstr_state = HALMAC_CMD_CNSTR_IDLE;
+		break;
+	case HALMAC_FEATURE_ALL:
+		state->cfg_param_state.proc_status = HALMAC_CMD_PROCESS_IDLE;
+		state->cfg_param_state.cmd_cnstr_state = HALMAC_CMD_CNSTR_IDLE;
+		state->efuse_state.proc_status = HALMAC_CMD_PROCESS_IDLE;
+		state->efuse_state.cmd_cnstr_state = HALMAC_CMD_CNSTR_IDLE;
+		state->scan_state.proc_status = HALMAC_CMD_PROCESS_IDLE;
+		state->scan_state.cmd_cnstr_state = HALMAC_CMD_CNSTR_IDLE;
+		state->update_pkt_state.proc_status = HALMAC_CMD_PROCESS_IDLE;
+		state->iqk_state.proc_status = HALMAC_CMD_PROCESS_IDLE;
+		state->pwr_trk_state.proc_status = HALMAC_CMD_PROCESS_IDLE;
+		state->psd_state.proc_status = HALMAC_CMD_PROCESS_IDLE;
+		state->fw_snding_state.proc_status = HALMAC_CMD_PROCESS_IDLE;
+		state->fw_snding_state.cmd_cnstr_state = HALMAC_CMD_CNSTR_IDLE;
+		break;
+	default:
+		pr_err("invalid feature id\n");
+		return HALMAC_RET_INVALID_FEATURE_ID;
+	}
+
+	RT_TRACE(adapter->drv_adapter, COMP_HALMAC, DBG_DMESG, "%s <===\n",
+		 __func__);
+
+	return HALMAC_RET_SUCCESS;
+}
+
+/**
+ * (debug API)verify_platform_api_88xx() - verify platform api
+ * @adapter : the adapter of halmac
+ * Author : KaiYuan Chang/Ivan Lin
+ * Return : enum halmac_ret_status
+ * More details of status code can be found in prototype document
+ */
+enum halmac_ret_status
+verify_platform_api_88xx(struct halmac_adapter *adapter)
+{
+	enum halmac_ret_status ret_status = HALMAC_RET_SUCCESS;
+
+	RT_TRACE(adapter->drv_adapter, COMP_HALMAC, DBG_DMESG, "%s ===>\n",
+		 __func__);
+
+	ret_status = verify_io_88xx(adapter);
+
+	if (ret_status != HALMAC_RET_SUCCESS)
+		return ret_status;
+
+	if (adapter->txff_alloc.la_mode != HALMAC_LA_MODE_FULL)
+		ret_status = verify_send_rsvd_page_88xx(adapter);
+
+	if (ret_status != HALMAC_RET_SUCCESS)
+		return ret_status;
+
+	RT_TRACE(adapter->drv_adapter, COMP_HALMAC, DBG_DMESG, "%s <===\n",
+		 __func__);
+
+	return ret_status;
+}
+
+void
+tx_desc_chksum_88xx(struct halmac_adapter *adapter, u8 enable)
+{
+	u16 value16;
+	struct halmac_api *api = (struct halmac_api *)adapter->halmac_api;
+
+	RT_TRACE(adapter->drv_adapter, COMP_HALMAC, DBG_DMESG, "%s ===>\n",
+		 __func__);
+
+	adapter->tx_desc_checksum = enable;
+
+	value16 = HALMAC_REG_R16(REG_TXDMA_OFFSET_CHK);
+	if (enable == 1)
+		HALMAC_REG_W16(REG_TXDMA_OFFSET_CHK, value16 | BIT(13));
+	else
+		HALMAC_REG_W16(REG_TXDMA_OFFSET_CHK, value16 & ~BIT(13));
+}
+
+static enum halmac_ret_status
+verify_io_88xx(struct halmac_adapter *adapter)
+{
+	u8 value8;
+	u8 wvalue8;
+	u32 value32;
+	u32 value32_2;
+	u32 wvalue32;
+	u32 offset;
+	enum halmac_ret_status ret_status = HALMAC_RET_SUCCESS;
+
+	if (adapter->intf == HALMAC_INTERFACE_SDIO) {
+		offset = REG_PAGE5_DUMMY;
+		if (0 == (offset & 0xFFFF0000))
+			offset |= WLAN_IOREG_OFFSET;
+
+		ret_status = cnv_to_sdio_bus_offset_88xx(adapter, &offset);
+
+		/* Verify CMD52 R/W */
+		wvalue8 = 0xab;
+		PLTFM_SDIO_CMD52_W(offset, wvalue8);
+
+		value8 = PLTFM_SDIO_CMD52_R(offset);
+
+		if (value8 != wvalue8) {
+			pr_err("cmd52 r/w\n");
+			ret_status = HALMAC_RET_PLATFORM_API_INCORRECT;
+		}
+
+		/* Verify CMD53 R/W */
+		PLTFM_SDIO_CMD52_W(offset, 0xaa);
+		PLTFM_SDIO_CMD52_W(offset + 1, 0xbb);
+		PLTFM_SDIO_CMD52_W(offset + 2, 0xcc);
+		PLTFM_SDIO_CMD52_W(offset + 3, 0xdd);
+
+		value32 = PLTFM_SDIO_CMD53_R32(offset);
+
+		if (value32 != 0xddccbbaa) {
+			pr_err("cmd53 r\n");
+			ret_status = HALMAC_RET_PLATFORM_API_INCORRECT;
+		}
+
+		wvalue32 = 0x11223344;
+		PLTFM_SDIO_CMD53_W32(offset, wvalue32);
+
+		value32 = PLTFM_SDIO_CMD53_R32(offset);
+
+		if (value32 != wvalue32) {
+			pr_err("cmd53 w\n");
+			ret_status = HALMAC_RET_PLATFORM_API_INCORRECT;
+		}
+
+		/* value32 should be 0x33441122 */
+		value32 = PLTFM_SDIO_CMD53_R32(offset + 2);
+
+		wvalue32 = 0x11225566;
+		PLTFM_SDIO_CMD53_W32(offset, wvalue32);
+
+		/* value32 should be 0x55661122 */
+		value32_2 = PLTFM_SDIO_CMD53_R32(offset + 2);
+		if (value32_2 == value32) {
+			pr_err("cmd52 is used\n");
+			ret_status = HALMAC_RET_PLATFORM_API_INCORRECT;
+		}
+	} else {
+		wvalue32 = 0x77665511;
+		PLTFM_REG_W32(REG_PAGE5_DUMMY, wvalue32);
+
+		value32 = PLTFM_REG_R32(REG_PAGE5_DUMMY);
+		if (value32 != wvalue32) {
+			pr_err("reg rw\n");
+			ret_status = HALMAC_RET_PLATFORM_API_INCORRECT;
+		}
+	}
+
+	return ret_status;
+}
+
+static enum halmac_ret_status
+verify_send_rsvd_page_88xx(struct halmac_adapter *adapter)
+{
+	u8 txdesc_size = adapter->hw_cfg_info.txdesc_size;
+	u8 *rsvd_buf = NULL;
+	u8 *rsvd_page = NULL;
+	u32 i;
+	u32 pkt_size = 64;
+	u32 payload = 0xab;
+	enum halmac_ret_status ret_status = HALMAC_RET_SUCCESS;
+
+	rsvd_buf = kzalloc(pkt_size, GFP_KERNEL);
+
+	if (!rsvd_buf)
+		return HALMAC_RET_MALLOC_FAIL;
+
+	memset(rsvd_buf, (u8)payload, pkt_size);
+
+	ret_status = dl_rsvd_page_88xx(adapter,
+				       adapter->txff_alloc.rsvd_boundary,
+				       rsvd_buf, pkt_size);
+	if (ret_status != HALMAC_RET_SUCCESS) {
+		kfree(rsvd_buf);
+		return ret_status;
+	}
+
+	rsvd_page = kzalloc(pkt_size + txdesc_size, GFP_KERNEL);
+
+	if (!rsvd_page) {
+		kfree(rsvd_buf);
+		return HALMAC_RET_MALLOC_FAIL;
+	}
+
+	memset(rsvd_page, 0x00, pkt_size + txdesc_size);
+
+	ret_status = dump_fifo_88xx(adapter, HAL_FIFO_SEL_RSVD_PAGE, 0,
+				    pkt_size + txdesc_size, rsvd_page);
+
+	if (ret_status != HALMAC_RET_SUCCESS) {
+		kfree(rsvd_buf);
+		kfree(rsvd_page);
+		return ret_status;
+	}
+
+	for (i = 0; i < pkt_size; i++) {
+		if (*(rsvd_buf + i) != *(rsvd_page + (i + txdesc_size))) {
+			pr_err("Compare RSVD page Fail\n");
+			ret_status = HALMAC_RET_PLATFORM_API_INCORRECT;
+		}
+	}
+
+	kfree(rsvd_buf);
+	kfree(rsvd_page);
+
+	return ret_status;
+}
+
+enum halmac_ret_status
+pg_num_parser_88xx(struct halmac_adapter *adapter, enum halmac_trx_mode mode,
+		   struct halmac_pg_num *tbl)
+{
+	u8 flag;
+	u16 hpq_num = 0;
+	u16 lpq_num = 0;
+	u16 npq_num = 0;
+	u16 gapq_num = 0;
+	u16 expq_num = 0;
+	u16 pubq_num = 0;
+	u32 i = 0;
+
+	flag = 0;
+	for (i = 0; i < HALMAC_TRX_MODE_MAX; i++) {
+		if (mode == tbl[i].mode) {
+			hpq_num = tbl[i].hq_num;
+			lpq_num = tbl[i].lq_num;
+			npq_num = tbl[i].nq_num;
+			expq_num = tbl[i].exq_num;
+			gapq_num = tbl[i].gap_num;
+			pubq_num = adapter->txff_alloc.acq_pg_num - hpq_num -
+					lpq_num - npq_num - expq_num - gapq_num;
+			flag = 1;
+			RT_TRACE(adapter->drv_adapter, COMP_HALMAC, DBG_DMESG,
+				 "%s done\n", __func__);
+			break;
+		}
+	}
+
+	if (flag == 0) {
+		pr_err("trx mode!!\n");
+		return HALMAC_RET_TRX_MODE_NOT_SUPPORT;
+	}
+
+	if (adapter->txff_alloc.acq_pg_num <
+	    hpq_num + lpq_num + npq_num + expq_num + gapq_num) {
+		pr_err("acqnum = %d\n", adapter->txff_alloc.acq_pg_num);
+		pr_err("hpq_num = %d\n", hpq_num);
+		pr_err("LPQ_num = %d\n", lpq_num);
+		pr_err("npq_num = %d\n", npq_num);
+		pr_err("EPQ_num = %d\n", expq_num);
+		pr_err("gapq_num = %d\n", gapq_num);
+		return HALMAC_RET_CFG_TXFIFO_PAGE_FAIL;
+	}
+
+	adapter->txff_alloc.high_queue_pg_num = hpq_num;
+	adapter->txff_alloc.low_queue_pg_num = lpq_num;
+	adapter->txff_alloc.normal_queue_pg_num = npq_num;
+	adapter->txff_alloc.extra_queue_pg_num = expq_num;
+	adapter->txff_alloc.pub_queue_pg_num = pubq_num;
+
+	return HALMAC_RET_SUCCESS;
+}
+
+enum halmac_ret_status
+rqpn_parser_88xx(struct halmac_adapter *adapter, enum halmac_trx_mode mode,
+		 struct halmac_rqpn *tbl)
+{
+	u8 flag;
+	u32 i;
+
+	flag = 0;
+	for (i = 0; i < HALMAC_TRX_MODE_MAX; i++) {
+		if (mode == tbl[i].mode) {
+			adapter->pq_map[HALMAC_PQ_MAP_VO] = tbl[i].dma_map_vo;
+			adapter->pq_map[HALMAC_PQ_MAP_VI] = tbl[i].dma_map_vi;
+			adapter->pq_map[HALMAC_PQ_MAP_BE] = tbl[i].dma_map_be;
+			adapter->pq_map[HALMAC_PQ_MAP_BK] = tbl[i].dma_map_bk;
+			adapter->pq_map[HALMAC_PQ_MAP_MG] = tbl[i].dma_map_mg;
+			adapter->pq_map[HALMAC_PQ_MAP_HI] = tbl[i].dma_map_hi;
+			flag = 1;
+			RT_TRACE(adapter->drv_adapter, COMP_HALMAC, DBG_DMESG,
+				 "%s done\n", __func__);
+			break;
+		}
+	}
+
+	if (flag == 0) {
+		pr_err("trx mdoe!!\n");
+		return HALMAC_RET_TRX_MODE_NOT_SUPPORT;
+	}
+
+	return HALMAC_RET_SUCCESS;
+}
diff --git a/drivers/net/wireless/realtek/rtlwifi/halmac/halmac_88xx/halmac_init_88xx.h b/drivers/net/wireless/realtek/rtlwifi/halmac/halmac_88xx/halmac_init_88xx.h
new file mode 100644
index 000000000000..469988484b8e
--- /dev/null
+++ b/drivers/net/wireless/realtek/rtlwifi/halmac/halmac_88xx/halmac_init_88xx.h
@@ -0,0 +1,70 @@
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
+#ifndef _HALMAC_INIT_88XX_H_
+#define _HALMAC_INIT_88XX_H_
+
+#include "../halmac_api.h"
+
+enum halmac_ret_status
+register_api_88xx(struct halmac_adapter *adapter,
+		  struct halmac_api_registry *registry);
+
+void
+init_adapter_param_88xx(struct halmac_adapter *adapter);
+
+void
+init_adapter_dynamic_param_88xx(struct halmac_adapter *adapter);
+
+enum halmac_ret_status
+mount_api_88xx(struct halmac_adapter *adapter);
+
+enum halmac_ret_status
+pre_init_system_cfg_88xx(struct halmac_adapter *adapter);
+
+enum halmac_ret_status
+init_system_cfg_88xx(struct halmac_adapter *adapter);
+
+enum halmac_ret_status
+init_edca_cfg_88xx(struct halmac_adapter *adapter);
+
+enum halmac_ret_status
+init_wmac_cfg_88xx(struct halmac_adapter *adapter);
+
+enum halmac_ret_status
+init_mac_cfg_88xx(struct halmac_adapter *adapter, enum halmac_trx_mode mode);
+
+enum halmac_ret_status
+reset_ofld_feature_88xx(struct halmac_adapter *adapter,
+			enum halmac_feature_id feature_id);
+
+enum halmac_ret_status
+verify_platform_api_88xx(struct halmac_adapter *adapter);
+
+void
+tx_desc_chksum_88xx(struct halmac_adapter *adapter, u8 enable);
+
+enum halmac_ret_status
+pg_num_parser_88xx(struct halmac_adapter *adapter, enum halmac_trx_mode mode,
+		   struct halmac_pg_num *tbl);
+
+enum halmac_ret_status
+rqpn_parser_88xx(struct halmac_adapter *adapter, enum halmac_trx_mode mode,
+		 struct halmac_rqpn *tbl);
+
+void
+init_ofld_feature_state_machine_88xx(struct halmac_adapter *adapter);
+
+#endif/* _HALMAC_INIT_88XX_H_ */
diff --git a/drivers/net/wireless/realtek/rtlwifi/halmac/halmac_api.c b/drivers/net/wireless/realtek/rtlwifi/halmac/halmac_api.c
new file mode 100644
index 000000000000..cd9de2baab8b
--- /dev/null
+++ b/drivers/net/wireless/realtek/rtlwifi/halmac/halmac_api.c
@@ -0,0 +1,438 @@
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
+#include "halmac_type.h"
+#include "halmac_api.h"
+
+#include "halmac_88xx/halmac_init_88xx.h"
+
+enum chip_id_hw_def {
+	CHIP_ID_HW_DEF_8723A = 0x01,
+	CHIP_ID_HW_DEF_8188E = 0x02,
+	CHIP_ID_HW_DEF_8881A = 0x03,
+	CHIP_ID_HW_DEF_8812A = 0x04,
+	CHIP_ID_HW_DEF_8821A = 0x05,
+	CHIP_ID_HW_DEF_8723B = 0x06,
+	CHIP_ID_HW_DEF_8192E = 0x07,
+	CHIP_ID_HW_DEF_8814A = 0x08,
+	CHIP_ID_HW_DEF_8821C = 0x09,
+	CHIP_ID_HW_DEF_8822B = 0x0A,
+	CHIP_ID_HW_DEF_8703B = 0x0B,
+	CHIP_ID_HW_DEF_8188F = 0x0C,
+	CHIP_ID_HW_DEF_8192F = 0x0D,
+	CHIP_ID_HW_DEF_8197F = 0x0E,
+	CHIP_ID_HW_DEF_8723D = 0x0F,
+	CHIP_ID_HW_DEF_8814B = 0x11,
+	CHIP_ID_HW_DEF_8822C = 0x13,
+	CHIP_ID_HW_DEF_UNDEFINE = 0x7F,
+	CHIP_ID_HW_DEF_PS = 0xEA,
+};
+
+static enum halmac_ret_status
+chk_pltfm_api(void *drv_adapter, enum halmac_interface intf,
+	      struct halmac_platform_api *pltfm_api);
+
+static enum halmac_ret_status
+get_chip_info(void *drv_adapter, struct halmac_platform_api *pltfm_api,
+	      enum halmac_interface intf, struct halmac_adapter *adapter);
+
+static u8
+pltfm_reg_r8_sdio(void *drv_adapter, struct halmac_platform_api *pltfm_api,
+		  u32 offset);
+
+static enum halmac_ret_status
+pltfm_reg_w8_sdio(void *drv_adapter, struct halmac_platform_api *pltfm_api,
+		  u32 offset, u8 data);
+
+static u8
+pltfm_reg_r_indir_sdio(void *drv_adapter, struct halmac_platform_api *pltfm_api,
+		       u32 offset);
+
+static enum halmac_ret_status
+cnv_to_sdio_bus_offset(u32 *offset);
+
+/**
+ * halmac_init_adapter() - init halmac_adapter
+ * @drv_adapter : the adapter of caller
+ * @pltfm_api : the platform APIs which is used in halmac
+ * @intf : bus interface
+ * @halmac_adapter : the adapter of halmac
+ * @halmac_api : the function pointer of APIs
+ * Author : KaiYuan Chang / Ivan Lin
+ * Return : enum halmac_ret_status
+ * More details of status code can be found in prototype document
+ */
+enum halmac_ret_status
+halmac_init_adapter(void *drv_adapter, struct halmac_platform_api *pltfm_api,
+		    enum halmac_interface intf,
+		    struct halmac_adapter **halmac_adapter,
+		    struct halmac_api **halmac_api)
+{
+	struct halmac_adapter *adapter = NULL;
+	enum halmac_ret_status status = HALMAC_RET_SUCCESS;
+	u8 *buf = NULL;
+
+	status = chk_pltfm_api(drv_adapter, intf, pltfm_api);
+	if (status != HALMAC_RET_SUCCESS)
+		return status;
+
+	RT_TRACE(drv_adapter, COMP_HALMAC, DBG_DMESG,
+		 HALMAC_SVN_VER "\n"
+		 "HALMAC_MAJOR_VER = %x\n"
+		 "HALMAC_PROTOTYPE_VER = %x\n"
+		 "HALMAC_MINOR_VER = %x\n"
+		 "HALMAC_PATCH_VER = %x\n", HALMAC_MAJOR_VER,
+		 HALMAC_PROTOTYPE_VER, HALMAC_MINOR_VER, HALMAC_PATCH_VER);
+
+	buf = kzalloc(sizeof(*adapter), GFP_KERNEL);
+
+	if (!buf)
+		return HALMAC_RET_MALLOC_FAIL;
+	memset(buf, 0x00, sizeof(*adapter));
+	adapter = (struct halmac_adapter *)buf;
+
+	*halmac_adapter = adapter;
+
+	adapter->pltfm_api = pltfm_api;
+	adapter->drv_adapter = drv_adapter;
+	intf = (intf == HALMAC_INTERFACE_AXI) ? HALMAC_INTERFACE_PCIE : intf;
+	adapter->intf = intf;
+
+	if (get_chip_info(drv_adapter, pltfm_api, intf, adapter)
+	    != HALMAC_RET_SUCCESS) {
+		kfree(*halmac_adapter);
+		*halmac_adapter = NULL;
+		return HALMAC_RET_CHIP_NOT_SUPPORT;
+	}
+
+	mutex_init(&adapter->efuse_mutex);
+	mutex_init(&adapter->h2c_seq_mutex);
+	mutex_init(&adapter->sdio_indir_mutex);
+
+	if (adapter->chip_id == HALMAC_CHIP_ID_8822B ||
+	    adapter->chip_id == HALMAC_CHIP_ID_8821C ||
+	    adapter->chip_id == HALMAC_CHIP_ID_8822C) {
+		init_adapter_param_88xx(adapter);
+		status = mount_api_88xx(adapter);
+	}
+
+	*halmac_api = (struct halmac_api *)adapter->halmac_api;
+
+	RT_TRACE(adapter->drv_adapter, COMP_HALMAC, DBG_DMESG, "%s <===\n",
+		 __func__);
+
+	return status;
+}
+
+/**
+ * halmac_halt_api() - stop halmac_api action
+ * @adapter : the adapter of halmac
+ * Author : Ivan Lin
+ * Return : enum halmac_ret_status
+ * More details of status code can be found in prototype document
+ */
+enum halmac_ret_status
+halmac_halt_api(struct halmac_adapter *adapter)
+{
+	RT_TRACE(adapter->drv_adapter, COMP_HALMAC, DBG_DMESG, "%s ===>\n",
+		 __func__);
+
+	adapter->halmac_state.api_state = HALMAC_API_STATE_HALT;
+
+	RT_TRACE(adapter->drv_adapter, COMP_HALMAC, DBG_DMESG, "%s <===\n",
+		 __func__);
+
+	return HALMAC_RET_SUCCESS;
+}
+
+/**
+ * halmac_deinit_adapter() - deinit halmac adapter
+ * @adapter : the adapter of halmac
+ * Author : KaiYuan Chang / Ivan Lin
+ * Return : enum halmac_ret_status
+ * More details of status code can be found in prototype document
+ */
+enum halmac_ret_status
+halmac_deinit_adapter(struct halmac_adapter *adapter)
+{
+	RT_TRACE(adapter->drv_adapter, COMP_HALMAC, DBG_DMESG, "%s ===>\n",
+		 __func__);
+
+	mutex_destroy(&adapter->efuse_mutex);
+	mutex_destroy(&adapter->h2c_seq_mutex);
+	mutex_destroy(&adapter->sdio_indir_mutex);
+
+	kfree(adapter->efuse_map);
+	adapter->efuse_map = (u8 *)NULL;
+	kfree(adapter->sdio_fs.macid_map);
+	adapter->sdio_fs.macid_map = (u8 *)NULL;
+	kfree(adapter->halmac_state.psd_state.data);
+	adapter->halmac_state.psd_state.data = (u8 *)NULL;
+	kfree(adapter->halmac_api);
+	adapter->halmac_api = NULL;
+
+	kfree(adapter);
+
+	return HALMAC_RET_SUCCESS;
+}
+
+static enum halmac_ret_status
+chk_pltfm_api(void *drv_adapter, enum halmac_interface intf,
+	      struct halmac_platform_api *pltfm_api)
+{
+	if (!pltfm_api)
+		return HALMAC_RET_PLATFORM_API_NULL;
+
+	if (intf == HALMAC_INTERFACE_SDIO) {
+		if (!pltfm_api->SDIO_CMD52_READ) {
+			pr_err("sdio-r\n");
+			return HALMAC_RET_PLATFORM_API_NULL;
+		}
+		if (!pltfm_api->SDIO_CMD53_READ_8) {
+			pr_err("sdio-r8\n");
+			return HALMAC_RET_PLATFORM_API_NULL;
+		}
+		if (!pltfm_api->SDIO_CMD53_READ_16) {
+			pr_err("sdio-r16\n");
+			return HALMAC_RET_PLATFORM_API_NULL;
+		}
+		if (!pltfm_api->SDIO_CMD53_READ_32) {
+			pr_err("sdio-r32\n");
+			return HALMAC_RET_PLATFORM_API_NULL;
+		}
+		if (!pltfm_api->SDIO_CMD53_READ_N) {
+			pr_err("sdio-rn\n");
+			return HALMAC_RET_PLATFORM_API_NULL;
+		}
+		if (!pltfm_api->SDIO_CMD52_WRITE) {
+			pr_err("sdio-w\n");
+			return HALMAC_RET_PLATFORM_API_NULL;
+		}
+		if (!pltfm_api->SDIO_CMD53_WRITE_8) {
+			pr_err("sdio-w8\n");
+			return HALMAC_RET_PLATFORM_API_NULL;
+		}
+		if (!pltfm_api->SDIO_CMD53_WRITE_16) {
+			pr_err("sdio-w16\n");
+			return HALMAC_RET_PLATFORM_API_NULL;
+		}
+		if (!pltfm_api->SDIO_CMD53_WRITE_32) {
+			pr_err("sdio-w32\n");
+			return HALMAC_RET_PLATFORM_API_NULL;
+		}
+		if (!pltfm_api->SDIO_CMD52_CIA_READ) {
+			pr_err("sdio-cia\n");
+			return HALMAC_RET_PLATFORM_API_NULL;
+		}
+	}
+
+	if (intf == HALMAC_INTERFACE_USB || intf == HALMAC_INTERFACE_PCIE) {
+		if (!pltfm_api->REG_READ_8) {
+			pr_err("reg-r8\n");
+			return HALMAC_RET_PLATFORM_API_NULL;
+		}
+		if (!pltfm_api->REG_READ_16) {
+			pr_err("reg-r16\n");
+			return HALMAC_RET_PLATFORM_API_NULL;
+		}
+		if (!pltfm_api->REG_READ_32) {
+			pr_err("reg-r32\n");
+			return HALMAC_RET_PLATFORM_API_NULL;
+		}
+		if (!pltfm_api->REG_WRITE_8) {
+			pr_err("reg-w8\n");
+			return HALMAC_RET_PLATFORM_API_NULL;
+		}
+		if (!pltfm_api->REG_WRITE_16) {
+			pr_err("reg-w16\n");
+			return HALMAC_RET_PLATFORM_API_NULL;
+		}
+		if (!pltfm_api->REG_WRITE_32) {
+			pr_err("reg-w32\n");
+			return HALMAC_RET_PLATFORM_API_NULL;
+		}
+	}
+
+	if (!pltfm_api->EVENT_INDICATION) {
+		pr_err("event-indication\n");
+		return HALMAC_RET_PLATFORM_API_NULL;
+	}
+
+	return HALMAC_RET_SUCCESS;
+}
+
+/**
+ * halmac_get_version() - get HALMAC version
+ * @version : return version of major, prototype and minor information
+ * Author : KaiYuan Chang / Ivan Lin
+ * Return : enum halmac_ret_status
+ * More details of status code can be found in prototype document
+ */
+enum halmac_ret_status
+halmac_get_version(struct halmac_ver *version)
+{
+	version->major_ver = (u8)HALMAC_MAJOR_VER;
+	version->prototype_ver = (u8)HALMAC_PROTOTYPE_VER;
+	version->minor_ver = (u8)HALMAC_MINOR_VER;
+
+	return HALMAC_RET_SUCCESS;
+}
+
+static enum halmac_ret_status
+get_chip_info(void *drv_adapter, struct halmac_platform_api *pltfm_api,
+	      enum halmac_interface intf, struct halmac_adapter *adapter)
+{
+	u8 chip_id;
+	u8 chip_ver;
+	u32 cnt;
+
+	if (adapter->intf == HALMAC_INTERFACE_SDIO) {
+		pltfm_reg_w8_sdio(drv_adapter, pltfm_api, REG_SDIO_HSUS_CTRL,
+				  pltfm_reg_r8_sdio(drv_adapter, pltfm_api,
+						    REG_SDIO_HSUS_CTRL) &
+						    ~(BIT(0)));
+
+		cnt = 10000;
+		while (!(pltfm_reg_r8_sdio(drv_adapter, pltfm_api,
+					   REG_SDIO_HSUS_CTRL) & BIT(1))) {
+			cnt--;
+			if (cnt == 0)
+				return HALMAC_RET_SDIO_LEAVE_SUSPEND_FAIL;
+		}
+
+		chip_id = pltfm_reg_r_indir_sdio(drv_adapter, pltfm_api,
+						 REG_SYS_CFG2);
+		chip_ver = pltfm_reg_r_indir_sdio(drv_adapter, pltfm_api,
+						  REG_SYS_CFG1 + 1) >> 4;
+	} else {
+		chip_id = pltfm_api->REG_READ_8(drv_adapter, REG_SYS_CFG2);
+		chip_ver = pltfm_api->REG_READ_8(drv_adapter,
+						 REG_SYS_CFG1 + 1) >> 4;
+	}
+
+	adapter->chip_ver = (enum halmac_chip_ver)chip_ver;
+
+	if (chip_id == CHIP_ID_HW_DEF_8822B) {
+		adapter->chip_id = HALMAC_CHIP_ID_8822B;
+	} else if (chip_id == CHIP_ID_HW_DEF_8821C) {
+		adapter->chip_id = HALMAC_CHIP_ID_8821C;
+	} else if (chip_id == CHIP_ID_HW_DEF_8814B) {
+		adapter->chip_id = HALMAC_CHIP_ID_8814B;
+	} else if (chip_id == CHIP_ID_HW_DEF_8197F) {
+		adapter->chip_id = HALMAC_CHIP_ID_8197F;
+	} else if (chip_id == CHIP_ID_HW_DEF_8822C) {
+		adapter->chip_id = HALMAC_CHIP_ID_8822C;
+	} else {
+		adapter->chip_id = HALMAC_CHIP_ID_UNDEFINE;
+		pr_err("Chip id is undefined\n");
+		return HALMAC_RET_CHIP_NOT_SUPPORT;
+	}
+
+	return HALMAC_RET_SUCCESS;
+}
+
+static u8
+pltfm_reg_r8_sdio(void *drv_adapter, struct halmac_platform_api *pltfm_api,
+		  u32 offset)
+{
+	u8 value8;
+	enum halmac_ret_status status = HALMAC_RET_SUCCESS;
+
+	if (0 == (offset & 0xFFFF0000))
+		offset |= WLAN_IOREG_OFFSET;
+
+	status = cnv_to_sdio_bus_offset(&offset);
+	if (status != HALMAC_RET_SUCCESS)
+		return status;
+
+	value8 = pltfm_api->SDIO_CMD52_READ(drv_adapter, offset);
+
+	return value8;
+}
+
+static enum halmac_ret_status
+pltfm_reg_w8_sdio(void *drv_adapter, struct halmac_platform_api *pltfm_api,
+		  u32 offset, u8 data)
+{
+	enum halmac_ret_status status = HALMAC_RET_SUCCESS;
+
+	if (0 == (offset & 0xFFFF0000))
+		offset |= WLAN_IOREG_OFFSET;
+
+	status = cnv_to_sdio_bus_offset(&offset);
+
+	if (status != HALMAC_RET_SUCCESS)
+		return status;
+
+	pltfm_api->SDIO_CMD52_WRITE(drv_adapter, offset, data);
+
+	return HALMAC_RET_SUCCESS;
+}
+
+static u8
+pltfm_reg_r_indir_sdio(void *drv_adapter, struct halmac_platform_api *pltfm_api,
+		       u32 offset)
+{
+	u8 value8, tmp, cnt = 50;
+	u32 reg_cfg = REG_SDIO_INDIRECT_REG_CFG;
+	u32 reg_data = REG_SDIO_INDIRECT_REG_DATA;
+	enum halmac_ret_status status = HALMAC_RET_SUCCESS;
+
+	status = cnv_to_sdio_bus_offset(&reg_cfg);
+	if (status != HALMAC_RET_SUCCESS)
+		return status;
+	status = cnv_to_sdio_bus_offset(&reg_data);
+	if (status != HALMAC_RET_SUCCESS)
+		return status;
+
+	pltfm_api->SDIO_CMD52_WRITE(drv_adapter, reg_cfg, (u8)offset);
+	pltfm_api->SDIO_CMD52_WRITE(drv_adapter, reg_cfg + 1,
+				    (u8)(offset >> 8));
+	pltfm_api->SDIO_CMD52_WRITE(drv_adapter, reg_cfg + 2,
+				    (u8)(BIT(3) | BIT(4)));
+
+	do {
+		tmp = pltfm_api->SDIO_CMD52_READ(drv_adapter, reg_cfg + 2);
+		cnt--;
+	} while (((tmp & BIT(4)) == 0) && (cnt > 0));
+
+	if (((cnt & BIT(4)) == 0) && cnt == 0)
+		pr_err("sdio indir read\n");
+
+	value8 = pltfm_api->SDIO_CMD52_READ(drv_adapter, reg_data);
+
+	return value8;
+}
+
+/*Note: copy from cnv_to_sdio_bus_offset_88xx*/
+static enum halmac_ret_status
+cnv_to_sdio_bus_offset(u32 *offset)
+{
+	switch ((*offset) & 0xFFFF0000) {
+	case WLAN_IOREG_OFFSET:
+		*offset &= HALMAC_WLAN_MAC_REG_MSK;
+		*offset |= HALMAC_SDIO_CMD_ADDR_MAC_REG << 13;
+		break;
+	case SDIO_LOCAL_OFFSET:
+		*offset &= HALMAC_SDIO_LOCAL_MSK;
+		*offset |= HALMAC_SDIO_CMD_ADDR_SDIO_REG << 13;
+		break;
+	default:
+		*offset = 0xFFFFFFFF;
+		return HALMAC_RET_CONVERT_SDIO_OFFSET_FAIL;
+	}
+
+	return HALMAC_RET_SUCCESS;
+}
diff --git a/drivers/net/wireless/realtek/rtlwifi/halmac/halmac_api.h b/drivers/net/wireless/realtek/rtlwifi/halmac/halmac_api.h
new file mode 100644
index 000000000000..5bbd6b374ce0
--- /dev/null
+++ b/drivers/net/wireless/realtek/rtlwifi/halmac/halmac_api.h
@@ -0,0 +1,65 @@
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
+#ifndef _HALMAC_API_H_
+#define _HALMAC_API_H_
+
+#define HALMAC_SVN_VER  "11692M"
+
+#define HALMAC_MAJOR_VER        0x0002
+#define HALMAC_PROTOTYPE_VER    0x0004
+#define HALMAC_MINOR_VER        0x0010
+#define HALMAC_PATCH_VER        0x0000
+
+#include "../wifi.h"
+#include "halmac_type.h"
+#include "halmac_usb_reg.h"
+#include "halmac_sdio_reg.h"
+#include "halmac_pcie_reg.h"
+#include "halmac_bit2.h"
+#include "halmac_reg2.h"
+
+#include "halmac_reg_8822b.h"
+#include "halmac_bit_8822b.h"
+
+#include "halmac_tx_desc_nic.h"
+#include "halmac_rx_desc_nic.h"
+#include "halmac_tx_bd_nic.h"
+#include "halmac_rx_bd_nic.h"
+#include "halmac_fw_offload_c2h_nic.h"
+#include "halmac_fw_offload_h2c_nic.h"
+#include "halmac_h2c_extra_info_nic.h"
+#include "halmac_original_c2h_nic.h"
+#include "halmac_original_h2c_nic.h"
+
+#include "halmac_tx_desc_chip.h"
+#include "halmac_rx_desc_chip.h"
+
+enum halmac_ret_status
+halmac_init_adapter(void *drv_adapter, struct halmac_platform_api *pltfm_api,
+		    enum halmac_interface intf,
+		    struct halmac_adapter **halmac_adapter,
+		    struct halmac_api **halmac_api);
+
+enum halmac_ret_status
+halmac_deinit_adapter(struct halmac_adapter *adapter);
+
+enum halmac_ret_status
+halmac_halt_api(struct halmac_adapter *adapter);
+
+enum halmac_ret_status
+halmac_get_version(struct halmac_ver *version);
+
+#endif
-- 
2.15.1

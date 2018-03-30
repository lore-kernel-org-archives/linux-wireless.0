Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rtits2.realtek.com ([211.75.126.72]:34507 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752762AbeC3HT5 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 30 Mar 2018 03:19:57 -0400
From: <pkshih@realtek.com>
To: <kvalo@codeaurora.org>
CC: <Larry.Finger@lwfinger.net>, <linux-wireless@vger.kernel.org>
Subject: [PATCH 13/17] rtlwifi: halmac: add firmware related functions and definitions
Date: Fri, 30 Mar 2018 15:19:12 +0800
Message-ID: <20180330071916.23360-14-pkshih@realtek.com> (sfid-20180330_092018_634393_67E15F31)
In-Reply-To: <20180330071916.23360-1-pkshih@realtek.com>
References: <20180330071916.23360-1-pkshih@realtek.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ping-Ke Shih <pkshih@realtek.com>

Add H2C, C2H, fw header format, download firmware, etc.

Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
---
 .../rtlwifi/halmac/halmac_88xx/halmac_flash_88xx.c |  316 ++++++
 .../rtlwifi/halmac/halmac_88xx/halmac_flash_88xx.h |   35 +
 .../rtlwifi/halmac/halmac_88xx/halmac_fw_88xx.c    | 1149 ++++++++++++++++++++
 .../rtlwifi/halmac/halmac_88xx/halmac_fw_88xx.h    |   57 +
 .../realtek/rtlwifi/halmac/halmac_fw_info.h        |  119 ++
 .../rtlwifi/halmac/halmac_fw_offload_c2h_nic.h     |  371 +++++++
 .../rtlwifi/halmac/halmac_fw_offload_h2c_nic.h     |  694 ++++++++++++
 .../rtlwifi/halmac/halmac_h2c_extra_info_nic.h     |  171 +++
 .../rtlwifi/halmac/halmac_original_c2h_nic.h       |  408 +++++++
 .../rtlwifi/halmac/halmac_original_h2c_nic.h       | 1143 +++++++++++++++++++
 10 files changed, 4463 insertions(+)
 create mode 100644 drivers/net/wireless/realtek/rtlwifi/halmac/halmac_88xx/halmac_flash_88xx.c
 create mode 100644 drivers/net/wireless/realtek/rtlwifi/halmac/halmac_88xx/halmac_flash_88xx.h
 create mode 100644 drivers/net/wireless/realtek/rtlwifi/halmac/halmac_88xx/halmac_fw_88xx.c
 create mode 100644 drivers/net/wireless/realtek/rtlwifi/halmac/halmac_88xx/halmac_fw_88xx.h
 create mode 100644 drivers/net/wireless/realtek/rtlwifi/halmac/halmac_fw_info.h
 create mode 100644 drivers/net/wireless/realtek/rtlwifi/halmac/halmac_fw_offload_c2h_nic.h
 create mode 100644 drivers/net/wireless/realtek/rtlwifi/halmac/halmac_fw_offload_h2c_nic.h
 create mode 100644 drivers/net/wireless/realtek/rtlwifi/halmac/halmac_h2c_extra_info_nic.h
 create mode 100644 drivers/net/wireless/realtek/rtlwifi/halmac/halmac_original_c2h_nic.h
 create mode 100644 drivers/net/wireless/realtek/rtlwifi/halmac/halmac_original_h2c_nic.h

diff --git a/drivers/net/wireless/realtek/rtlwifi/halmac/halmac_88xx/halmac_flash_88xx.c b/drivers/net/wireless/realtek/rtlwifi/halmac/halmac_88xx/halmac_flash_88xx.c
new file mode 100644
index 000000000000..aabedfd84cc6
--- /dev/null
+++ b/drivers/net/wireless/realtek/rtlwifi/halmac/halmac_88xx/halmac_flash_88xx.c
@@ -0,0 +1,316 @@
+/******************************************************************************
+ *
+ * Copyright(c) 2017 - 2018 Realtek Corporation. All rights reserved.
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
+#include "halmac_flash_88xx.h"
+#include "halmac_88xx_cfg.h"
+#include "halmac_common_88xx.h"
+
+/**
+ * download_flash_88xx() -download firmware to flash
+ * @adapter : the adapter of halmac
+ * @fw_bin : pointer to fw
+ * @size : fw size
+ * @rom_addr : flash start address where fw should be download
+ * Author : Pablo Chiu
+ * Return : enum halmac_ret_status
+ * More details of status code can be found in prototype document
+ */
+enum halmac_ret_status
+download_flash_88xx(struct halmac_adapter *adapter, u8 *fw_bin, u32 size,
+		    u32 rom_addr)
+{
+	struct halmac_api *api = (struct halmac_api *)adapter->halmac_api;
+	enum halmac_ret_status rc;
+	struct halmac_h2c_header_info hdr_info;
+	u8 value8;
+	u8 restore[3];
+	u8 h2c_buf[H2C_PKT_SIZE_88XX] = {0};
+	u16 seq_num = 0;
+	u16 h2c_info_offset;
+	u32 pkt_size;
+	u32 mem_offset;
+
+	RT_TRACE(adapter->drv_adapter, COMP_HALMAC, DBG_DMESG, "%s ===>\n",
+		 __func__);
+
+	value8 = HALMAC_REG_R8(REG_CR + 1);
+	restore[0] = value8;
+	value8 = (u8)(value8 | BIT(0));
+	HALMAC_REG_W8(REG_CR + 1, value8);
+
+	value8 = HALMAC_REG_R8(REG_BCN_CTRL);
+	restore[1] = value8;
+	value8 = (u8)((value8 & ~(BIT(3))) | BIT(4));
+	HALMAC_REG_W8(REG_BCN_CTRL, value8);
+
+	value8 = HALMAC_REG_R8(REG_FWHW_TXQ_CTRL + 2);
+	restore[2] = value8;
+	value8 = (u8)(value8 & ~(BIT(6)));
+	HALMAC_REG_W8(REG_FWHW_TXQ_CTRL + 2, value8);
+
+	/* Download FW to Flash flow */
+	h2c_info_offset = adapter->txff_alloc.rsvd_h2c_info_addr -
+					adapter->txff_alloc.rsvd_boundary;
+	mem_offset = 0;
+
+	while (size != 0) {
+		if (size >= (DL_FLASH_RSVDPG_SIZE - 48))
+			pkt_size = DL_FLASH_RSVDPG_SIZE - 48;
+		else
+			pkt_size = size;
+
+		rc = dl_rsvd_page_88xx(adapter,
+				       adapter->txff_alloc.rsvd_h2c_info_addr,
+				       fw_bin + mem_offset, pkt_size);
+		if (rc != HALMAC_RET_SUCCESS) {
+			pr_err("dl rsvd pg!!\n");
+			return rc;
+		}
+
+		DOWNLOAD_FLASH_SET_SPI_CMD(h2c_buf, 0x02);
+		DOWNLOAD_FLASH_SET_LOCATION(h2c_buf, h2c_info_offset);
+		DOWNLOAD_FLASH_SET_SIZE(h2c_buf, pkt_size);
+		DOWNLOAD_FLASH_SET_START_ADDR(h2c_buf, rom_addr);
+
+		hdr_info.sub_cmd_id = SUB_CMD_ID_DOWNLOAD_FLASH;
+		hdr_info.content_size = 20;
+		hdr_info.ack = 1;
+		set_h2c_pkt_hdr_88xx(adapter, h2c_buf, &hdr_info, &seq_num);
+
+		rc = send_h2c_pkt_88xx(adapter, h2c_buf);
+
+		if (rc != HALMAC_RET_SUCCESS) {
+			pr_err("send h2c!!\n");
+			return rc;
+		}
+
+		value8 = HALMAC_REG_R8(REG_MCUTST_I);
+		value8 |= BIT(0);
+		HALMAC_REG_W8(REG_MCUTST_I, value8);
+
+		rom_addr += pkt_size;
+		mem_offset += pkt_size;
+		size -= pkt_size;
+
+		while (((HALMAC_REG_R8(REG_MCUTST_I)) & BIT(0)) != 0)
+			usleep_range(1000, 1100);
+
+		if (((HALMAC_REG_R8(REG_MCUTST_I)) & BIT(0)) != 0) {
+			pr_err("dl flash!!\n");
+			return  HALMAC_RET_DLFW_FAIL;
+		}
+	}
+
+	HALMAC_REG_W8(REG_FWHW_TXQ_CTRL + 2, restore[2]);
+	HALMAC_REG_W8(REG_BCN_CTRL, restore[1]);
+	HALMAC_REG_W8(REG_CR + 1, restore[0]);
+	RT_TRACE(adapter->drv_adapter, COMP_HALMAC, DBG_DMESG, "%s <===\n",
+		 __func__);
+
+	return HALMAC_RET_SUCCESS;
+}
+
+/**
+ * read_flash_88xx() -read data from flash
+ * @adapter : the adapter of halmac
+ * @addr : flash start address where fw should be read
+ * Author : Pablo Chiu
+ * Return : enum halmac_ret_status
+ * More details of status code can be found in prototype document
+ */
+enum halmac_ret_status
+read_flash_88xx(struct halmac_adapter *adapter, u32 addr, u32 length)
+{
+	struct halmac_api *api = (struct halmac_api *)adapter->halmac_api;
+	enum halmac_ret_status status;
+	struct halmac_h2c_header_info hdr_info;
+	u8 value8;
+	u8 restore[3];
+	u8 h2c_buf[H2C_PKT_SIZE_88XX] = {0};
+	u16 seq_num = 0;
+	u16 h2c_info_addr = adapter->txff_alloc.rsvd_h2c_info_addr;
+	u16 rsvd_pg_addr = adapter->txff_alloc.rsvd_boundary;
+
+	RT_TRACE(adapter->drv_adapter, COMP_HALMAC, DBG_DMESG, "%s ===>\n",
+		 __func__);
+
+	value8 = HALMAC_REG_R8(REG_CR + 1);
+	restore[0] = value8;
+	value8 = (u8)(value8 | BIT(0));
+	HALMAC_REG_W8(REG_CR + 1, value8);
+
+	value8 = HALMAC_REG_R8(REG_BCN_CTRL);
+	restore[1] = value8;
+	value8 = (u8)((value8 & ~(BIT(3))) | BIT(4));
+	HALMAC_REG_W8(REG_BCN_CTRL, value8);
+
+	value8 = HALMAC_REG_R8(REG_FWHW_TXQ_CTRL + 2);
+	restore[2] = value8;
+	value8 = (u8)(value8 & ~(BIT(6)));
+	HALMAC_REG_W8(REG_FWHW_TXQ_CTRL + 2, value8);
+
+	HALMAC_REG_W16(REG_FIFOPAGE_CTRL_2, h2c_info_addr);
+	value8 = HALMAC_REG_R8(REG_MCUTST_I);
+	value8 |= BIT(0);
+	HALMAC_REG_W8(REG_MCUTST_I, value8);
+
+	/* Construct H2C Content */
+	DOWNLOAD_FLASH_SET_SPI_CMD(h2c_buf, 0x03);
+	DOWNLOAD_FLASH_SET_LOCATION(h2c_buf, h2c_info_addr - rsvd_pg_addr);
+	DOWNLOAD_FLASH_SET_SIZE(h2c_buf, length);
+	DOWNLOAD_FLASH_SET_START_ADDR(h2c_buf, addr);
+
+	/* Fill in H2C Header */
+	hdr_info.sub_cmd_id = SUB_CMD_ID_DOWNLOAD_FLASH;
+	hdr_info.content_size = 16;
+	hdr_info.ack = 1;
+	set_h2c_pkt_hdr_88xx(adapter, h2c_buf, &hdr_info, &seq_num);
+
+	/* Send H2C Cmd Packet */
+	status = send_h2c_pkt_88xx(adapter, h2c_buf);
+
+	if (status != HALMAC_RET_SUCCESS) {
+		pr_err("send h2c!!\n");
+		return status;
+	}
+
+	while (((HALMAC_REG_R8(REG_MCUTST_I)) & BIT(0)) != 0)
+		usleep_range(1000, 1100);
+
+	HALMAC_REG_W16(REG_FIFOPAGE_CTRL_2, rsvd_pg_addr);
+	HALMAC_REG_W8(REG_FWHW_TXQ_CTRL + 2, restore[2]);
+	HALMAC_REG_W8(REG_BCN_CTRL, restore[1]);
+	HALMAC_REG_W8(REG_CR + 1, restore[0]);
+
+	RT_TRACE(adapter->drv_adapter, COMP_HALMAC, DBG_DMESG, "%s <===\n",
+		 __func__);
+
+	return HALMAC_RET_SUCCESS;
+}
+
+/**
+ * erase_flash_88xx() -erase flash data
+ * @adapter : the adapter of halmac
+ * @erase_cmd : erase command
+ * @addr : flash start address where fw should be erased
+ * Author : Pablo Chiu
+ * Return : enum halmac_ret_status
+ * More details of status code can be found in prototype document
+ */
+enum halmac_ret_status
+erase_flash_88xx(struct halmac_adapter *adapter, u8 erase_cmd, u32 addr)
+{
+	enum halmac_ret_status status;
+	struct halmac_h2c_header_info hdr_info;
+	struct halmac_api *api = (struct halmac_api *)adapter->halmac_api;
+	u8 value8;
+	u8 h2c_buf[H2C_PKT_SIZE_88XX] = {0};
+	u16 seq_num = 0;
+	u32 cnt;
+
+	/* Construct H2C Content */
+	DOWNLOAD_FLASH_SET_SPI_CMD(h2c_buf, erase_cmd);
+	DOWNLOAD_FLASH_SET_LOCATION(h2c_buf, 0);
+	DOWNLOAD_FLASH_SET_START_ADDR(h2c_buf, addr);
+	DOWNLOAD_FLASH_SET_SIZE(h2c_buf, 0);
+
+	value8 = HALMAC_REG_R8(REG_MCUTST_I);
+	value8 |= BIT(0);
+	HALMAC_REG_W8(REG_MCUTST_I, value8);
+
+	/* Fill in H2C Header */
+	hdr_info.sub_cmd_id = SUB_CMD_ID_DOWNLOAD_FLASH;
+	hdr_info.content_size = 16;
+	hdr_info.ack = 1;
+	set_h2c_pkt_hdr_88xx(adapter, h2c_buf, &hdr_info, &seq_num);
+
+	/* Send H2C Cmd Packet */
+	status = send_h2c_pkt_88xx(adapter, h2c_buf);
+
+	if (status != HALMAC_RET_SUCCESS)
+		pr_err("send h2c!!\n");
+
+	cnt = 5000;
+	while (((HALMAC_REG_R8(REG_MCUTST_I)) & BIT(0)) != 0 && cnt != 0) {
+		usleep_range(1000, 1100);
+		cnt--;
+	}
+
+	if (cnt == 0)
+		return HALMAC_RET_FAIL;
+	else
+		return HALMAC_RET_SUCCESS;
+}
+
+/**
+ * check_flash_88xx() -check flash data
+ * @adapter : the adapter of halmac
+ * @fw_bin : pointer to fw
+ * @size : fw size
+ * @addr : flash start address where fw should be checked
+ * Author : Pablo Chiu
+ * Return : enum halmac_ret_status
+ * More details of status code can be found in prototype document
+ */
+enum halmac_ret_status
+check_flash_88xx(struct halmac_adapter *adapter, u8 *fw_bin, u32 size,
+		 u32 addr)
+{
+	struct halmac_api *api = (struct halmac_api *)adapter->halmac_api;
+	u8 value8;
+	u16 i;
+	u16 residue;
+	u16 pg_addr;
+	u32 pkt_size;
+	u32 start_page;
+	u32 cnt;
+
+	pg_addr = adapter->txff_alloc.rsvd_h2c_info_addr;
+
+	while (size != 0) {
+		start_page = ((pg_addr << 7) >> 12) + 0x780;
+		residue = (pg_addr << 7) & (4096 - 1);
+
+		if (size >= DL_FLASH_RSVDPG_SIZE)
+			pkt_size = DL_FLASH_RSVDPG_SIZE;
+		else
+			pkt_size = size;
+
+		read_flash_88xx(adapter, addr, 4096);
+
+		cnt = 0;
+		while (cnt < pkt_size) {
+			HALMAC_REG_W16(REG_PKTBUF_DBG_CTRL, (u16)(start_page));
+			for (i = 0x8000 + residue; i <= 0x8FFF; i++) {
+				value8 = HALMAC_REG_R8(i);
+				if (*fw_bin != value8) {
+					pr_err("check flash!!\n");
+					return HALMAC_RET_FAIL;
+				}
+
+				fw_bin++;
+				cnt++;
+				if (cnt == pkt_size)
+					break;
+			}
+			residue = 0;
+			start_page++;
+		}
+		addr += pkt_size;
+		size -= pkt_size;
+	}
+
+	return HALMAC_RET_SUCCESS;
+}
diff --git a/drivers/net/wireless/realtek/rtlwifi/halmac/halmac_88xx/halmac_flash_88xx.h b/drivers/net/wireless/realtek/rtlwifi/halmac/halmac_88xx/halmac_flash_88xx.h
new file mode 100644
index 000000000000..72564eca531b
--- /dev/null
+++ b/drivers/net/wireless/realtek/rtlwifi/halmac/halmac_88xx/halmac_flash_88xx.h
@@ -0,0 +1,35 @@
+/******************************************************************************
+ *
+ * Copyright(c) 2017 - 2018 Realtek Corporation. All rights reserved.
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
+#ifndef _HALMAC_FLASH_88XX_H_
+#define _HALMAC_FLASH_88XX_H_
+
+#include "../halmac_api.h"
+
+enum halmac_ret_status
+download_flash_88xx(struct halmac_adapter *adapter, u8 *fw_bin, u32 size,
+		    u32 rom_addr);
+
+enum halmac_ret_status
+read_flash_88xx(struct halmac_adapter *adapter, u32 addr, u32 length);
+
+enum halmac_ret_status
+erase_flash_88xx(struct halmac_adapter *adapter, u8 erase_cmd, u32 addr);
+
+enum halmac_ret_status
+check_flash_88xx(struct halmac_adapter *adapter, u8 *fw_bin, u32 size,
+		 u32 addr);
+
+#endif/* _HALMAC_FLASH_88XX_H_ */
diff --git a/drivers/net/wireless/realtek/rtlwifi/halmac/halmac_88xx/halmac_fw_88xx.c b/drivers/net/wireless/realtek/rtlwifi/halmac/halmac_88xx/halmac_fw_88xx.c
new file mode 100644
index 000000000000..7268cf12d707
--- /dev/null
+++ b/drivers/net/wireless/realtek/rtlwifi/halmac/halmac_88xx/halmac_fw_88xx.c
@@ -0,0 +1,1149 @@
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
+#include "halmac_fw_88xx.h"
+#include "halmac_88xx_cfg.h"
+#include "halmac_common_88xx.h"
+#include "halmac_init_88xx.h"
+
+#define DLFW_RESTORE_REG_NUM		6
+#define ILLEGAL_KEY_GROUP		0xFAAAAA00
+
+/* Max dlfw size can not over 31K, due to SDIO HW limitation */
+#define DLFW_PKT_SIZE_LIMIT		31744
+
+#define ID_INFORM_DLEMEM_RDY		0x80
+#define ID_INFORM_ENETR_CPU_SLEEP	0x20
+#define ID_CHECK_DLEMEM_RDY		0x80
+#define ID_CHECK_ENETR_CPU_SLEEP	0x05
+
+#define FW_STATUS_CHK_FATAL	(BIT(1) | BIT(20))
+#define FW_STATUS_CHK_ERR	(BIT(4) | BIT(5) | BIT(6) | BIT(7) | BIT(8) | \
+				 BIT(9) | BIT(12) | BIT(14) | BIT(15) | \
+				 BIT(16) | BIT(17) | BIT(18) | BIT(19) | \
+				 BIT(21) | BIT(22) | BIT(25))
+#define FW_STATUS_CHK_WARN	~(FW_STATUS_CHK_FATAL | FW_STATUS_CHK_ERR)
+
+struct halmac_backup_info {
+	u32 mac_register;
+	u32 value;
+	u8 length;
+};
+
+static enum halmac_ret_status
+update_fw_info_88xx(struct halmac_adapter *adapter, u8 *fw_bin);
+
+static void
+restore_mac_reg_88xx(struct halmac_adapter *adapter,
+		     struct halmac_backup_info *info, u32 num);
+
+static enum halmac_ret_status
+dlfw_to_mem_88xx(struct halmac_adapter *adapter, u8 *fw_bin, u32 src, u32 dest,
+		 u32 size);
+
+static enum halmac_ret_status
+dlfw_end_flow_88xx(struct halmac_adapter *adapter);
+
+static enum halmac_ret_status
+free_dl_fw_end_flow_88xx(struct halmac_adapter *adapter);
+
+static enum halmac_ret_status
+send_fwpkt_88xx(struct halmac_adapter *adapter, u16 pg_addr, u8 *fw_bin,
+		u32 size);
+
+static enum halmac_ret_status
+iddma_dlfw_88xx(struct halmac_adapter *adapter, u32 src, u32 dest, u32 len,
+		u8 first);
+
+static enum halmac_ret_status
+iddma_en_88xx(struct halmac_adapter *adapter, u32 src, u32 dest, u32 ctrl);
+
+static enum halmac_ret_status
+check_fw_chksum_88xx(struct halmac_adapter *adapter, u32 mem_addr);
+
+static void
+fw_fatal_status_debug_88xx(struct halmac_adapter *adapter);
+
+static enum halmac_ret_status
+start_dlfw_88xx(struct halmac_adapter *adapter, u8 *fw_bin, u32 size,
+		u32 dl_addr, u8 emem_only);
+
+static enum halmac_ret_status
+chk_fw_size_88xx(struct halmac_adapter *adapter, u8 *fw_bin, u32 size);
+
+static void
+chk_h2c_ver_88xx(struct halmac_adapter *adapter, u8 *fw_bin);
+
+static void
+wlan_cpu_en_88xx(struct halmac_adapter *adapter, u8 enable);
+
+static void
+pltfm_reset_88xx(struct halmac_adapter *adapter);
+
+static enum halmac_ret_status
+proc_send_general_info_88xx(struct halmac_adapter *adapter,
+			    struct halmac_general_info *info);
+
+static enum halmac_ret_status
+proc_send_phydm_info_88xx(struct halmac_adapter *adapter,
+			  struct halmac_general_info *info);
+
+/**
+ * download_firmware_88xx() - download Firmware
+ * @adapter : the adapter of halmac
+ * @fw_bin : firmware bin
+ * @size : firmware size
+ * Author : KaiYuan Chang/Ivan Lin
+ * Return : enum halmac_ret_status
+ * More details of status code can be found in prototype document
+ */
+enum halmac_ret_status
+download_firmware_88xx(struct halmac_adapter *adapter, u8 *fw_bin, u32 size)
+{
+	u8 value8;
+	u32 bckp_idx = 0;
+	u32 lte_coex_backup = 0;
+	struct halmac_backup_info bckp[DLFW_RESTORE_REG_NUM];
+	enum halmac_ret_status status;
+	struct halmac_api *api = (struct halmac_api *)adapter->halmac_api;
+
+	if (adapter->halmac_state.mac_pwr == HALMAC_MAC_POWER_OFF)
+		return HALMAC_RET_POWER_STATE_INVALID;
+
+	RT_TRACE(adapter->drv_adapter, COMP_HALMAC, DBG_DMESG, "%s ===>\n",
+		 __func__);
+
+	status = chk_fw_size_88xx(adapter, fw_bin, size);
+	if (status != HALMAC_RET_SUCCESS)
+		return status;
+
+	chk_h2c_ver_88xx(adapter, fw_bin);
+
+	if (adapter->halmac_state.wlcpu_mode == HALMAC_WLCPU_ENTER_SLEEP)
+		RT_TRACE(adapter->drv_adapter, COMP_HALMAC, DBG_WARNING,
+			 "Enter Sleep..zZZ\n");
+
+	adapter->halmac_state.dlfw_state = HALMAC_DLFW_NONE;
+
+	status = ltecoex_reg_read_88xx(adapter, 0x38, &lte_coex_backup);
+	if (status != HALMAC_RET_SUCCESS)
+		return status;
+
+	wlan_cpu_en_88xx(adapter, 0);
+
+	/* set HIQ to hi priority */
+	bckp[bckp_idx].length = 1;
+	bckp[bckp_idx].mac_register = REG_TXDMA_PQ_MAP + 1;
+	bckp[bckp_idx].value = HALMAC_REG_R8(REG_TXDMA_PQ_MAP + 1);
+	bckp_idx++;
+	value8 = HALMAC_DMA_MAPPING_HIGH << 6;
+	HALMAC_REG_W8(REG_TXDMA_PQ_MAP + 1, value8);
+
+	/* DLFW only use HIQ, map HIQ to hi priority */
+	adapter->pq_map[HALMAC_PQ_MAP_HI] = HALMAC_DMA_MAPPING_HIGH;
+	bckp[bckp_idx].length = 1;
+	bckp[bckp_idx].mac_register = REG_CR;
+	bckp[bckp_idx].value = HALMAC_REG_R8(REG_CR);
+	bckp_idx++;
+	bckp[bckp_idx].length = 4;
+	bckp[bckp_idx].mac_register = REG_H2CQ_CSR;
+	bckp[bckp_idx].value = BIT(31);
+	bckp_idx++;
+	value8 = BIT_HCI_TXDMA_EN | BIT_TXDMA_EN;
+	HALMAC_REG_W8(REG_CR, value8);
+	HALMAC_REG_W32(REG_H2CQ_CSR, BIT(31));
+
+	/* Config hi priority queue and public priority queue page number */
+	bckp[bckp_idx].length = 2;
+	bckp[bckp_idx].mac_register = REG_FIFOPAGE_INFO_1;
+	bckp[bckp_idx].value = HALMAC_REG_R16(REG_FIFOPAGE_INFO_1);
+	bckp_idx++;
+	bckp[bckp_idx].length = 4;
+	bckp[bckp_idx].mac_register = REG_RQPN_CTRL_2;
+	bckp[bckp_idx].value = HALMAC_REG_R32(REG_RQPN_CTRL_2) | BIT(31);
+	bckp_idx++;
+	HALMAC_REG_W16(REG_FIFOPAGE_INFO_1, 0x200);
+	HALMAC_REG_W32(REG_RQPN_CTRL_2, bckp[bckp_idx - 1].value);
+
+	/* Disable beacon related functions */
+	value8 = HALMAC_REG_R8(REG_BCN_CTRL);
+	bckp[bckp_idx].length = 1;
+	bckp[bckp_idx].mac_register = REG_BCN_CTRL;
+	bckp[bckp_idx].value = value8;
+	bckp_idx++;
+	value8 = (u8)((value8 & (~BIT(3))) | BIT(4));
+	HALMAC_REG_W8(REG_BCN_CTRL, value8);
+
+	if (adapter->intf == HALMAC_INTERFACE_SDIO)
+		HALMAC_REG_R32(REG_SDIO_FREE_TXPG);
+
+	pltfm_reset_88xx(adapter);
+
+	status = start_dlfw_88xx(adapter, fw_bin, size, 0, 0);
+
+	restore_mac_reg_88xx(adapter, bckp, DLFW_RESTORE_REG_NUM);
+
+	if (status != HALMAC_RET_SUCCESS)
+		goto DLFW_FAIL;
+
+	status = dlfw_end_flow_88xx(adapter);
+	if (status != HALMAC_RET_SUCCESS)
+		goto DLFW_FAIL;
+
+	status = ltecoex_reg_write_88xx(adapter, 0x38, lte_coex_backup);
+	if (status != HALMAC_RET_SUCCESS)
+		return status;
+
+	adapter->halmac_state.dlfw_state = HALMAC_DLFW_DONE;
+
+	RT_TRACE(adapter->drv_adapter, COMP_HALMAC, DBG_DMESG, "%s <===\n",
+		 __func__);
+
+	return HALMAC_RET_SUCCESS;
+
+DLFW_FAIL:
+
+	/* Disable FWDL_EN */
+	value8 = HALMAC_REG_R8(REG_MCUFW_CTRL);
+	value8 &= ~BIT(0);
+	HALMAC_REG_W8(REG_MCUFW_CTRL, value8);
+
+	value8 = HALMAC_REG_R8(REG_SYS_FUNC_EN + 1);
+	value8 |= BIT(2);
+	HALMAC_REG_W8(REG_SYS_FUNC_EN + 1, value8);
+
+	if (ltecoex_reg_write_88xx(adapter, 0x38, lte_coex_backup) !=
+	    HALMAC_RET_SUCCESS)
+		return HALMAC_RET_LTECOEX_READY_FAIL;
+
+	return status;
+}
+
+static enum halmac_ret_status
+start_dlfw_88xx(struct halmac_adapter *adapter, u8 *fw_bin, u32 size,
+		u32 dl_addr, u8 emem_only)
+{
+	u8 *cur_fw;
+	u16 value16;
+	u32 imem_size;
+	u32 dmem_size;
+	u32 emem_size = 0;
+	u32 addr;
+	struct halmac_api *api = (struct halmac_api *)adapter->halmac_api;
+	enum halmac_ret_status status;
+
+	dmem_size =
+		le32_to_cpu(*((__le32 *)(fw_bin + WLAN_FW_HDR_DMEM_SIZE)));
+	imem_size =
+		le32_to_cpu(*((__le32 *)(fw_bin + WLAN_FW_HDR_IMEM_SIZE)));
+	if (0 != ((*(fw_bin + WLAN_FW_HDR_MEM_USAGE)) & BIT(4)))
+		emem_size =
+		le32_to_cpu(*((__le32 *)(fw_bin + WLAN_FW_HDR_EMEM_SIZE)));
+
+	dmem_size += WLAN_FW_HDR_CHKSUM_SIZE;
+	imem_size += WLAN_FW_HDR_CHKSUM_SIZE;
+	if (emem_size != 0)
+		emem_size += WLAN_FW_HDR_CHKSUM_SIZE;
+
+	if (emem_only == 1) {
+		if (!emem_size)
+			return HALMAC_RET_SUCCESS;
+		goto DLFW_EMEM;
+	}
+
+	value16 = (u16)(HALMAC_REG_R16(REG_MCUFW_CTRL) & 0x3800);
+	value16 |= BIT(0);
+	HALMAC_REG_W16(REG_MCUFW_CTRL, value16);
+
+	cur_fw = fw_bin + WLAN_FW_HDR_SIZE;
+	addr = le32_to_cpu(*((__le32 *)(fw_bin + WLAN_FW_HDR_DMEM_ADDR)));
+	addr &= ~BIT(31);
+	status = dlfw_to_mem_88xx(adapter, cur_fw, 0, addr, dmem_size);
+	if (status != HALMAC_RET_SUCCESS)
+		return status;
+
+	cur_fw = fw_bin + WLAN_FW_HDR_SIZE + dmem_size;
+	addr = le32_to_cpu(*((__le32 *)(fw_bin + WLAN_FW_HDR_IMEM_ADDR)));
+	addr &= ~BIT(31);
+	status = dlfw_to_mem_88xx(adapter, cur_fw, 0, addr, imem_size);
+	if (status != HALMAC_RET_SUCCESS)
+		return status;
+
+DLFW_EMEM:
+	if (emem_size) {
+		cur_fw = fw_bin + WLAN_FW_HDR_SIZE +
+				dmem_size + imem_size;
+		addr = le32_to_cpu(*((__le32 *)(fw_bin +
+				       WLAN_FW_HDR_EMEM_ADDR)));
+		addr &= ~BIT(31);
+		status = dlfw_to_mem_88xx(adapter, cur_fw, dl_addr << 7, addr,
+					  emem_size);
+		if (status != HALMAC_RET_SUCCESS)
+			return status;
+
+		if (emem_only == 1)
+			return HALMAC_RET_SUCCESS;
+	}
+
+	update_fw_info_88xx(adapter, fw_bin);
+	init_ofld_feature_state_machine_88xx(adapter);
+
+	return HALMAC_RET_SUCCESS;
+}
+
+static void
+chk_h2c_ver_88xx(struct halmac_adapter *adapter, u8 *fw_bin)
+{
+	u16 halmac_h2c_ver;
+	u16 fw_h2c_ver;
+
+	fw_h2c_ver = le16_to_cpu(*((__le16 *)(fw_bin +
+						  WLAN_FW_HDR_H2C_FMT_VER)));
+	halmac_h2c_ver = H2C_FORMAT_VERSION;
+
+	RT_TRACE(adapter->drv_adapter, COMP_HALMAC, DBG_DMESG,
+		 "halmac h2c ver = %x, fw h2c ver = %x!!\n", halmac_h2c_ver,
+		 fw_h2c_ver);
+
+	if (fw_h2c_ver != halmac_h2c_ver)
+		RT_TRACE(adapter->drv_adapter, COMP_HALMAC, DBG_WARNING,
+			 "H2C/C2H ver is compatible!!\n");
+}
+
+static enum halmac_ret_status
+chk_fw_size_88xx(struct halmac_adapter *adapter, u8 *fw_bin, u32 size)
+{
+	u32 imem_size;
+	u32 dmem_size;
+	u32 emem_size = 0;
+	u32 real_size;
+
+	if (size < WLAN_FW_HDR_SIZE) {
+		pr_err("FW size error!\n");
+		return HALMAC_RET_FW_SIZE_ERR;
+	}
+
+	dmem_size =
+		le32_to_cpu(*((__le32 *)(fw_bin + WLAN_FW_HDR_DMEM_SIZE)));
+	imem_size =
+		le32_to_cpu(*((__le32 *)(fw_bin + WLAN_FW_HDR_IMEM_SIZE)));
+	if (0 != ((*(fw_bin + WLAN_FW_HDR_MEM_USAGE)) & BIT(4)))
+		emem_size =
+		le32_to_cpu(*((__le32 *)(fw_bin + WLAN_FW_HDR_EMEM_SIZE)));
+
+	dmem_size += WLAN_FW_HDR_CHKSUM_SIZE;
+	imem_size += WLAN_FW_HDR_CHKSUM_SIZE;
+	if (emem_size != 0)
+		emem_size += WLAN_FW_HDR_CHKSUM_SIZE;
+
+	real_size = WLAN_FW_HDR_SIZE + dmem_size + imem_size + emem_size;
+	if (size != real_size) {
+		pr_err("size != real size!\n");
+		return HALMAC_RET_FW_SIZE_ERR;
+	}
+
+	return HALMAC_RET_SUCCESS;
+}
+
+static void
+wlan_cpu_en_88xx(struct halmac_adapter *adapter, u8 enable)
+{
+	u8 value8;
+	struct halmac_api *api = (struct halmac_api *)adapter->halmac_api;
+
+	if (enable == 1) {
+		/* cpu io interface enable or disable */
+		value8 = HALMAC_REG_R8(REG_RSV_CTRL + 1);
+		value8 |= BIT(0);
+		HALMAC_REG_W8(REG_RSV_CTRL + 1, value8);
+
+		/* cpu enable or disable */
+		value8 = HALMAC_REG_R8(REG_SYS_FUNC_EN + 1);
+		value8 |= BIT(2);
+		HALMAC_REG_W8(REG_SYS_FUNC_EN + 1, value8);
+
+	} else {
+		/* cpu enable or disable */
+		value8 = HALMAC_REG_R8(REG_SYS_FUNC_EN + 1);
+		value8 &= ~BIT(2);
+		HALMAC_REG_W8(REG_SYS_FUNC_EN + 1, value8);
+
+		/* cpu io interface enable or disable */
+		value8 = HALMAC_REG_R8(REG_RSV_CTRL + 1);
+		value8 &= ~BIT(0);
+		HALMAC_REG_W8(REG_RSV_CTRL + 1, value8);
+	}
+}
+
+static void
+pltfm_reset_88xx(struct halmac_adapter *adapter)
+{
+	u8 value8;
+	struct halmac_api *api = (struct halmac_api *)adapter->halmac_api;
+
+	value8 = HALMAC_REG_R8(REG_CPU_DMEM_CON + 2) & ~BIT(0);
+	HALMAC_REG_W8(REG_CPU_DMEM_CON + 2, value8);
+
+	/* For 8822B & 8821C clock sync issue */
+	if (adapter->chip_id == HALMAC_CHIP_ID_8821C ||
+	    adapter->chip_id == HALMAC_CHIP_ID_8822B) {
+		value8 = HALMAC_REG_R8(REG_SYS_CLK_CTRL + 1) & ~BIT(6);
+		HALMAC_REG_W8(REG_SYS_CLK_CTRL + 1, value8);
+	}
+
+	value8 = HALMAC_REG_R8(REG_CPU_DMEM_CON + 2) | BIT(0);
+	HALMAC_REG_W8(REG_CPU_DMEM_CON + 2, value8);
+
+	if (adapter->chip_id == HALMAC_CHIP_ID_8821C ||
+	    adapter->chip_id == HALMAC_CHIP_ID_8822B) {
+		value8 = HALMAC_REG_R8(REG_SYS_CLK_CTRL + 1) | BIT(6);
+		HALMAC_REG_W8(REG_SYS_CLK_CTRL + 1, value8);
+	}
+}
+
+/**
+ * free_download_firmware_88xx() - download specific memory firmware
+ * @adapter
+ * @mem_sel : memory selection
+ * @fw_bin : firmware bin
+ * @size : firmware size
+ * Author : KaiYuan Chang/Ivan Lin
+ * Return : enum halmac_ret_status
+ */
+enum halmac_ret_status
+free_download_firmware_88xx(struct halmac_adapter *adapter,
+			    enum halmac_dlfw_mem mem_sel, u8 *fw_bin, u32 size)
+{
+	u8 tx_pause_bckp;
+	u32 dl_addr;
+	u32 dlfw_size_bckp;
+	enum halmac_ret_status status;
+	struct halmac_api *api = (struct halmac_api *)adapter->halmac_api;
+
+	if (halmac_fw_validate(adapter) != HALMAC_RET_SUCCESS)
+		return HALMAC_RET_NO_DLFW;
+
+	RT_TRACE(adapter->drv_adapter, COMP_HALMAC, DBG_DMESG, "%s ===>\n",
+		 __func__);
+
+	status = chk_fw_size_88xx(adapter, fw_bin, size);
+	if (status != HALMAC_RET_SUCCESS)
+		return status;
+
+	if (((*(fw_bin + WLAN_FW_HDR_MEM_USAGE)) & BIT(4)) == 0)
+		return HALMAC_RET_SUCCESS;
+
+	dlfw_size_bckp = adapter->dlfw_pkt_size;
+	if (mem_sel == HALMAC_DLFW_MEM_EMEM) {
+		dl_addr = 0;
+	} else {
+		dl_addr = adapter->txff_alloc.rsvd_h2c_info_addr;
+		adapter->dlfw_pkt_size = (dlfw_size_bckp > DLFW_RSVDPG_SIZE) ?
+					DLFW_RSVDPG_SIZE : dlfw_size_bckp;
+	}
+
+	tx_pause_bckp = HALMAC_REG_R8(REG_TXPAUSE);
+	HALMAC_REG_W8(REG_TXPAUSE, tx_pause_bckp | BIT(7));
+
+	status = start_dlfw_88xx(adapter, fw_bin, size, dl_addr, 1);
+	if (status != HALMAC_RET_SUCCESS)
+		goto DL_FREE_FW_END;
+
+	status = free_dl_fw_end_flow_88xx(adapter);
+
+DL_FREE_FW_END:
+	HALMAC_REG_W8(REG_TXPAUSE, tx_pause_bckp);
+	adapter->dlfw_pkt_size = dlfw_size_bckp;
+
+	RT_TRACE(adapter->drv_adapter, COMP_HALMAC, DBG_DMESG, "%s <===\n",
+		 __func__);
+
+	return status;
+}
+
+/**
+ * get_fw_version_88xx() - get FW version
+ * @adapter : the adapter of halmac
+ * @ver : fw version info
+ * Author : Ivan Lin
+ * Return : enum halmac_ret_status
+ * More details of status code can be found in prototype document
+ */
+enum halmac_ret_status
+get_fw_version_88xx(struct halmac_adapter *adapter,
+		    struct halmac_fw_version *ver)
+{
+	struct halmac_fw_version *info = &adapter->fw_ver;
+
+	if (!ver)
+		return HALMAC_RET_NULL_POINTER;
+
+	if (adapter->halmac_state.dlfw_state == HALMAC_DLFW_NONE)
+		return HALMAC_RET_NO_DLFW;
+
+	ver->version = info->version;
+	ver->sub_version = info->sub_version;
+	ver->sub_index = info->sub_index;
+	ver->h2c_version = info->h2c_version;
+	ver->build_time.month = info->build_time.month;
+	ver->build_time.date = info->build_time.date;
+	ver->build_time.hour = info->build_time.hour;
+	ver->build_time.min = info->build_time.min;
+	ver->build_time.year = info->build_time.year;
+
+	return HALMAC_RET_SUCCESS;
+}
+
+static enum halmac_ret_status
+update_fw_info_88xx(struct halmac_adapter *adapter, u8 *fw_bin)
+{
+	struct halmac_fw_version *info = &adapter->fw_ver;
+
+	info->version =
+		le16_to_cpu(*((__le16 *)(fw_bin + WLAN_FW_HDR_VERSION)));
+	info->sub_version = *(fw_bin + WLAN_FW_HDR_SUBVERSION);
+	info->sub_index = *(fw_bin + WLAN_FW_HDR_SUBINDEX);
+	info->h2c_version = le16_to_cpu(*((__le16 *)(fw_bin +
+					    WLAN_FW_HDR_H2C_FMT_VER)));
+	info->build_time.month = *(fw_bin + WLAN_FW_HDR_MONTH);
+	info->build_time.date = *(fw_bin + WLAN_FW_HDR_DATE);
+	info->build_time.hour = *(fw_bin + WLAN_FW_HDR_HOUR);
+	info->build_time.min = *(fw_bin + WLAN_FW_HDR_MIN);
+	info->build_time.year =
+		le16_to_cpu(*((__le16 *)(fw_bin + WLAN_FW_HDR_YEAR)));
+
+	RT_TRACE(adapter->drv_adapter, COMP_HALMAC, DBG_DMESG,
+		 "=== FW info ===\n");
+	RT_TRACE(adapter->drv_adapter, COMP_HALMAC, DBG_DMESG, "ver : %X\n",
+		 info->version);
+	RT_TRACE(adapter->drv_adapter, COMP_HALMAC, DBG_DMESG, "sub-ver : %X\n",
+		 info->sub_version);
+	RT_TRACE(adapter->drv_adapter, COMP_HALMAC, DBG_DMESG, "sub-idx : %X\n",
+		 info->sub_index);
+	RT_TRACE(adapter->drv_adapter, COMP_HALMAC, DBG_DMESG,
+		 "build : %d/%d/%d %d:%d\n", info->build_time.year,
+		 info->build_time.month, info->build_time.date,
+		 info->build_time.hour, info->build_time.min);
+
+	return HALMAC_RET_SUCCESS;
+}
+
+static enum halmac_ret_status
+dlfw_to_mem_88xx(struct halmac_adapter *adapter, u8 *fw_bin, u32 src, u32 dest,
+		 u32 size)
+{
+	u8 first_part;
+	u32 mem_offset;
+	u32 residue_size;
+	u32 pkt_size;
+	enum halmac_ret_status status;
+	struct halmac_api *api = (struct halmac_api *)adapter->halmac_api;
+
+	mem_offset = 0;
+	first_part = 1;
+	residue_size = size;
+
+	HALMAC_REG_W32_SET(REG_DDMA_CH0CTRL, BIT_DDMACH0_RESET_CHKSUM_STS);
+
+	while (residue_size != 0) {
+		if (residue_size >= adapter->dlfw_pkt_size)
+			pkt_size = adapter->dlfw_pkt_size;
+		else
+			pkt_size = residue_size;
+
+		status = send_fwpkt_88xx(adapter, (u16)(src >> 7),
+					 fw_bin + mem_offset, pkt_size);
+		if (status != HALMAC_RET_SUCCESS) {
+			pr_err("send fw pkt!!\n");
+			return status;
+		}
+
+		status = iddma_dlfw_88xx(adapter,
+					 OCPBASE_TXBUF_88XX +
+					 src + adapter->hw_cfg_info.txdesc_size,
+					 dest + mem_offset, pkt_size,
+					 first_part);
+		if (status != HALMAC_RET_SUCCESS) {
+			pr_err("iddma dlfw!!\n");
+			return status;
+		}
+
+		first_part = 0;
+		mem_offset += pkt_size;
+		residue_size -= pkt_size;
+	}
+
+	status = check_fw_chksum_88xx(adapter, dest);
+	if (status != HALMAC_RET_SUCCESS) {
+		pr_err("chk fw chksum!!\n");
+		return status;
+	}
+
+	return HALMAC_RET_SUCCESS;
+}
+
+static void
+restore_mac_reg_88xx(struct halmac_adapter *adapter,
+		     struct halmac_backup_info *info, u32 num)
+{
+	u8 len;
+	u32 i;
+	u32 reg;
+	u32 value;
+	struct halmac_api *api = (struct halmac_api *)adapter->halmac_api;
+	struct halmac_backup_info *curr_info = info;
+
+	for (i = 0; i < num; i++) {
+		reg = curr_info->mac_register;
+		value = curr_info->value;
+		len = curr_info->length;
+
+		if (len == 1)
+			HALMAC_REG_W8(reg, (u8)value);
+		else if (len == 2)
+			HALMAC_REG_W16(reg, (u16)value);
+		else if (len == 4)
+			HALMAC_REG_W32(reg, value);
+
+		curr_info++;
+	}
+}
+
+static enum halmac_ret_status
+dlfw_end_flow_88xx(struct halmac_adapter *adapter)
+{
+	u16 fw_ctrl;
+	u32 cnt;
+	struct halmac_api *api = (struct halmac_api *)adapter->halmac_api;
+
+	HALMAC_REG_W32(REG_TXDMA_STATUS, BIT(2));
+
+	/* Check IMEM & DMEM checksum is OK or not */
+	fw_ctrl = HALMAC_REG_R16(REG_MCUFW_CTRL);
+	if ((fw_ctrl & 0x50) != 0x50)
+		return HALMAC_RET_IDMEM_CHKSUM_FAIL;
+
+	HALMAC_REG_W16(REG_MCUFW_CTRL, (fw_ctrl | BIT_FW_DW_RDY) & ~BIT(0));
+
+	wlan_cpu_en_88xx(adapter, 1);
+	RT_TRACE(adapter->drv_adapter, COMP_HALMAC, DBG_DMESG,
+		 "Dlfw OK, enable CPU\n");
+
+	cnt = 5000;
+	while (HALMAC_REG_R16(REG_MCUFW_CTRL) != 0xC078) {
+		if (cnt == 0) {
+			pr_err("Check 0x80 = 0xC078 fail\n");
+			if ((HALMAC_REG_R32(REG_FW_DBG7) & 0xFFFFFF00) ==
+			    ILLEGAL_KEY_GROUP) {
+				pr_err("Key!!\n");
+				return HALMAC_RET_ILLEGAL_KEY_FAIL;
+			}
+			return HALMAC_RET_FW_READY_CHK_FAIL;
+		}
+		cnt--;
+		usleep_range(50, 60);
+	}
+
+	RT_TRACE(adapter->drv_adapter, COMP_HALMAC, DBG_DMESG,
+		 "0x80=0xC078, cnt=%d\n", cnt);
+
+	return HALMAC_RET_SUCCESS;
+}
+
+static enum halmac_ret_status
+free_dl_fw_end_flow_88xx(struct halmac_adapter *adapter)
+{
+	u32 cnt;
+	struct halmac_api *api = (struct halmac_api *)adapter->halmac_api;
+
+	cnt = 100;
+	while (HALMAC_REG_R8(REG_HMETFR + 3) != 0) {
+		cnt--;
+		if (cnt == 0) {
+			pr_err("0x1CF != 0\n");
+			return HALMAC_RET_DLFW_FAIL;
+		}
+		usleep_range(50, 60);
+	}
+
+	HALMAC_REG_W8(REG_HMETFR + 3, ID_INFORM_DLEMEM_RDY);
+
+	cnt = 10000;
+	while (HALMAC_REG_R8(REG_MCU_TST_CFG) != ID_CHECK_DLEMEM_RDY) {
+		cnt--;
+		if (cnt == 0) {
+			pr_err("0x84 != 0x80\n");
+			return HALMAC_RET_DLFW_FAIL;
+		}
+		usleep_range(50, 60);
+	}
+
+	HALMAC_REG_W8(REG_MCU_TST_CFG, 0);
+
+	return HALMAC_RET_SUCCESS;
+}
+
+static enum halmac_ret_status
+send_fwpkt_88xx(struct halmac_adapter *adapter, u16 pg_addr, u8 *fw_bin,
+		u32 size)
+{
+	enum halmac_ret_status status;
+
+	status = dl_rsvd_page_88xx(adapter, pg_addr, fw_bin, size);
+	if (status != HALMAC_RET_SUCCESS)
+		pr_err("dl rsvd page!!\n");
+
+	return status;
+}
+
+static enum halmac_ret_status
+iddma_dlfw_88xx(struct halmac_adapter *adapter, u32 src, u32 dest, u32 len,
+		u8 first)
+{
+	u32 cnt;
+	u32 ch0_ctrl = (u32)(BIT_DDMACH0_CHKSUM_EN | BIT_DDMACH0_OWN);
+	struct halmac_api *api = (struct halmac_api *)adapter->halmac_api;
+
+	cnt = HALMC_DDMA_POLLING_COUNT;
+	while (HALMAC_REG_R32(REG_DDMA_CH0CTRL) & BIT_DDMACH0_OWN) {
+		cnt--;
+		if (cnt == 0) {
+			pr_err("ch0 ready!!\n");
+			return HALMAC_RET_DDMA_FAIL;
+		}
+	}
+
+	ch0_ctrl |= (len & BIT_MASK_DDMACH0_DLEN);
+	if (first == 0)
+		ch0_ctrl |= BIT_DDMACH0_CHKSUM_CONT;
+
+	if (iddma_en_88xx(adapter, src, dest, ch0_ctrl) !=
+	    HALMAC_RET_SUCCESS) {
+		pr_err("iddma en!!\n");
+		return HALMAC_RET_DDMA_FAIL;
+	}
+
+	return HALMAC_RET_SUCCESS;
+}
+
+static enum halmac_ret_status
+iddma_en_88xx(struct halmac_adapter *adapter, u32 src, u32 dest, u32 ctrl)
+{
+	u32 cnt = HALMC_DDMA_POLLING_COUNT;
+	struct halmac_api *api = (struct halmac_api *)adapter->halmac_api;
+
+	HALMAC_REG_W32(REG_DDMA_CH0SA, src);
+	HALMAC_REG_W32(REG_DDMA_CH0DA, dest);
+	HALMAC_REG_W32(REG_DDMA_CH0CTRL, ctrl);
+
+	while (HALMAC_REG_R32(REG_DDMA_CH0CTRL) & BIT_DDMACH0_OWN) {
+		cnt--;
+		if (cnt == 0)
+			return HALMAC_RET_DDMA_FAIL;
+	}
+
+	return HALMAC_RET_SUCCESS;
+}
+
+static enum halmac_ret_status
+check_fw_chksum_88xx(struct halmac_adapter *adapter, u32 mem_addr)
+{
+	u8 fw_ctrl;
+	struct halmac_api *api = (struct halmac_api *)adapter->halmac_api;
+
+	fw_ctrl = HALMAC_REG_R8(REG_MCUFW_CTRL);
+
+	if (HALMAC_REG_R32(REG_DDMA_CH0CTRL) & BIT_DDMACH0_CHKSUM_STS) {
+		if (mem_addr < OCPBASE_DMEM_88XX) {
+			fw_ctrl |= BIT_IMEM_DW_OK;
+			fw_ctrl &= ~BIT_IMEM_CHKSUM_OK;
+			HALMAC_REG_W8(REG_MCUFW_CTRL, fw_ctrl);
+		} else {
+			fw_ctrl |= BIT_DMEM_DW_OK;
+			fw_ctrl &= ~BIT_DMEM_CHKSUM_OK;
+			HALMAC_REG_W8(REG_MCUFW_CTRL, fw_ctrl);
+		}
+
+		pr_err("fw chksum!!\n");
+
+		return HALMAC_RET_FW_CHECKSUM_FAIL;
+	}
+
+	if (mem_addr < OCPBASE_DMEM_88XX) {
+		fw_ctrl |= (BIT_IMEM_DW_OK | BIT_IMEM_CHKSUM_OK);
+		HALMAC_REG_W8(REG_MCUFW_CTRL, fw_ctrl);
+	} else {
+		fw_ctrl |= (BIT_DMEM_DW_OK | BIT_DMEM_CHKSUM_OK);
+		HALMAC_REG_W8(REG_MCUFW_CTRL, fw_ctrl);
+	}
+
+	return HALMAC_RET_SUCCESS;
+}
+
+/**
+ * check_fw_status_88xx() -check fw status
+ * @adapter : the adapter of halmac
+ * @status : fw status
+ * Author : KaiYuan Chang/Ivan Lin
+ * Return : enum halmac_ret_status
+ * More details of status code can be found in prototype document
+ */
+enum halmac_ret_status
+check_fw_status_88xx(struct halmac_adapter *adapter, u8 *fw_status)
+{
+	u32 cnt;
+	u32 fw_dbg6;
+	u32 fw_pc;
+	struct halmac_api *api = (struct halmac_api *)adapter->halmac_api;
+	enum halmac_ret_status status = HALMAC_RET_SUCCESS;
+
+	RT_TRACE(adapter->drv_adapter, COMP_HALMAC, DBG_DMESG, "%s ===>\n",
+		 __func__);
+
+	*fw_status = 1;
+
+	fw_dbg6 = HALMAC_REG_R32(REG_FW_DBG6);
+
+	if (fw_dbg6 != 0) {
+		pr_err("REG_FW_DBG6 !=0\n");
+		if ((fw_dbg6 & FW_STATUS_CHK_WARN) != 0)
+			RT_TRACE(adapter->drv_adapter, COMP_HALMAC, DBG_WARNING,
+				 "fw status(warn):%X\n", fw_dbg6);
+
+		if ((fw_dbg6 & FW_STATUS_CHK_ERR) != 0)
+			pr_err("fw status(err):%X\n", fw_dbg6);
+
+		if ((fw_dbg6 & FW_STATUS_CHK_FATAL) != 0) {
+			pr_err("fw status(fatal):%X\n", fw_dbg6);
+			fw_fatal_status_debug_88xx(adapter);
+			*fw_status = 0;
+			return status;
+		}
+	}
+
+	fw_pc = HALMAC_REG_R32(REG_FW_DBG7);
+	cnt = 10;
+	while (HALMAC_REG_R32(REG_FW_DBG7) == fw_pc) {
+		cnt--;
+		if (cnt == 0)
+			break;
+	}
+
+	if (cnt == 0) {
+		cnt = 200;
+		while (HALMAC_REG_R32(REG_FW_DBG7) == fw_pc) {
+			cnt--;
+			if (cnt == 0) {
+				pr_err("fw pc\n");
+				*fw_status = 0;
+				return status;
+			}
+			usleep_range(50, 60);
+		}
+	}
+
+	RT_TRACE(adapter->drv_adapter, COMP_HALMAC, DBG_DMESG, "%s <===\n",
+		 __func__);
+
+	return status;
+}
+
+static void
+fw_fatal_status_debug_88xx(struct halmac_adapter *adapter)
+{
+	struct halmac_api *api = (struct halmac_api *)adapter->halmac_api;
+
+	pr_err("0x%X = %X\n", REG_FW_DBG6, HALMAC_REG_R32(REG_FW_DBG6));
+
+	pr_err("0x%X = %X\n", REG_ARFR5, HALMAC_REG_R32(REG_ARFR5));
+
+	pr_err("0x%X = %X\n", REG_MCUTST_I, HALMAC_REG_R32(REG_MCUTST_I));
+}
+
+enum halmac_ret_status
+dump_fw_dmem_88xx(struct halmac_adapter *adapter, u8 *dmem, u32 *size)
+{
+	return HALMAC_RET_SUCCESS;
+}
+
+/**
+ * cfg_max_dl_size_88xx() - config max download FW size
+ * @adapter : the adapter of halmac
+ * @size : max download fw size
+ *
+ * Halmac uses this setting to set max packet size for
+ * download FW.
+ * If user has not called this API, halmac use default
+ * setting for download FW
+ * Note1 : size need multiple of 2
+ * Note2 : max size is 31K
+ *
+ * Author : Ivan Lin/KaiYuan Chang
+ * Return : enum halmac_ret_status
+ * More details of status code can be found in prototype document
+ */
+enum halmac_ret_status
+cfg_max_dl_size_88xx(struct halmac_adapter *adapter, u32 size)
+{
+	RT_TRACE(adapter->drv_adapter, COMP_HALMAC, DBG_DMESG, "%s ===>\n",
+		 __func__);
+
+	if (size > DLFW_PKT_SIZE_LIMIT) {
+		pr_err("size > max dl size!\n");
+		return HALMAC_RET_CFG_DLFW_SIZE_FAIL;
+	}
+
+	if ((size & (2 - 1)) != 0) {
+		pr_err("not multiple of 2!\n");
+		return HALMAC_RET_CFG_DLFW_SIZE_FAIL;
+	}
+
+	adapter->dlfw_pkt_size = size;
+
+	RT_TRACE(adapter->drv_adapter, COMP_HALMAC, DBG_DMESG,
+		 "Cfg max size:%X\n", size);
+	RT_TRACE(adapter->drv_adapter, COMP_HALMAC, DBG_DMESG, "%s <===\n",
+		 __func__);
+
+	return HALMAC_RET_SUCCESS;
+}
+
+/**
+ * enter_cpu_sleep_mode_88xx() -wlan cpu enter sleep mode
+ * @adapter : the adapter of halmac
+ * Author : Ivan Lin
+ * Return : enum halmac_ret_status
+ * More details of status code can be found in prototype document
+ */
+enum halmac_ret_status
+enter_cpu_sleep_mode_88xx(struct halmac_adapter *adapter)
+{
+	u32 cnt;
+	struct halmac_api *api = (struct halmac_api *)adapter->halmac_api;
+	enum halmac_wlcpu_mode *cur_mode = &adapter->halmac_state.wlcpu_mode;
+
+	if (halmac_fw_validate(adapter) != HALMAC_RET_SUCCESS)
+		return HALMAC_RET_NO_DLFW;
+
+	if (*cur_mode != HALMAC_WLCPU_ACTIVE)
+		return HALMAC_RET_ERROR_STATE;
+
+	cnt = 100;
+	while (HALMAC_REG_R8(REG_HMETFR + 3) != 0) {
+		cnt--;
+		if (cnt == 0) {
+			pr_err("0x1CF != 0\n");
+			return HALMAC_RET_STATE_INCORRECT;
+		}
+		usleep_range(50, 60);
+	}
+
+	HALMAC_REG_W8(REG_HMETFR + 3, ID_INFORM_ENETR_CPU_SLEEP);
+
+	*cur_mode = HALMAC_WLCPU_ENTER_SLEEP;
+
+	return HALMAC_RET_SUCCESS;
+}
+
+/**
+ * get_cpu_mode_88xx() -get wlcpu mode
+ * @adapter : the adapter of halmac
+ * @mode : cpu mode
+ * Author : Ivan Lin
+ * Return : enum halmac_ret_status
+ * More details of status code can be found in prototype document
+ */
+enum halmac_ret_status
+get_cpu_mode_88xx(struct halmac_adapter *adapter,
+		  enum halmac_wlcpu_mode *mode)
+{
+	struct halmac_api *api = (struct halmac_api *)adapter->halmac_api;
+	enum halmac_wlcpu_mode *cur_mode = &adapter->halmac_state.wlcpu_mode;
+
+	if (halmac_fw_validate(adapter) != HALMAC_RET_SUCCESS)
+		return HALMAC_RET_NO_DLFW;
+
+	if (*cur_mode == HALMAC_WLCPU_ACTIVE) {
+		*mode = HALMAC_WLCPU_ACTIVE;
+		return HALMAC_RET_SUCCESS;
+	}
+
+	if (*cur_mode == HALMAC_WLCPU_SLEEP) {
+		*mode = HALMAC_WLCPU_SLEEP;
+		return HALMAC_RET_SUCCESS;
+	}
+
+	if (HALMAC_REG_R8(REG_MCU_TST_CFG) == ID_CHECK_ENETR_CPU_SLEEP)
+		*mode = HALMAC_WLCPU_SLEEP;
+	else
+		*mode = HALMAC_WLCPU_ENTER_SLEEP;
+
+	HALMAC_REG_W8(REG_MCU_TST_CFG, 0);
+
+	return HALMAC_RET_SUCCESS;
+}
+
+/**
+ * send_general_info_88xx() -send general information to FW
+ * @adapter : the adapter of halmac
+ * @info : general information
+ * Author : KaiYuan Chang/Ivan Lin
+ * Return : enum halmac_ret_status
+ * More details of status code can be found in prototype document
+ */
+enum halmac_ret_status
+send_general_info_88xx(struct halmac_adapter *adapter,
+		       struct halmac_general_info *info)
+{
+	enum halmac_ret_status status = HALMAC_RET_SUCCESS;
+
+	if (halmac_fw_validate(adapter) != HALMAC_RET_SUCCESS)
+		return HALMAC_RET_NO_DLFW;
+
+	if (adapter->fw_ver.h2c_version < 4)
+		return HALMAC_RET_FW_NO_SUPPORT;
+
+	RT_TRACE(adapter->drv_adapter, COMP_HALMAC, DBG_DMESG, "%s ===>\n",
+		 __func__);
+
+	if (adapter->halmac_state.dlfw_state == HALMAC_DLFW_NONE) {
+		pr_err("no dl fw!!\n");
+		return HALMAC_RET_NO_DLFW;
+	}
+
+	status = proc_send_general_info_88xx(adapter, info);
+	if (status != HALMAC_RET_SUCCESS) {
+		pr_err("send gen info!!\n");
+		return status;
+	}
+
+	status = proc_send_phydm_info_88xx(adapter, info);
+	if (status != HALMAC_RET_SUCCESS) {
+		pr_err("send phydm info\n");
+		return status;
+	}
+
+	if (adapter->halmac_state.dlfw_state == HALMAC_DLFW_DONE)
+		adapter->halmac_state.dlfw_state = HALMAC_GEN_INFO_SENT;
+
+	RT_TRACE(adapter->drv_adapter, COMP_HALMAC, DBG_DMESG, "%s <===\n",
+		 __func__);
+
+	return HALMAC_RET_SUCCESS;
+}
+
+static enum halmac_ret_status
+proc_send_general_info_88xx(struct halmac_adapter *adapter,
+			    struct halmac_general_info *info)
+{
+	u8 h2c_buf[H2C_PKT_SIZE_88XX] = { 0 };
+	u16 seq_num = 0;
+	struct halmac_h2c_header_info hdr_info;
+	enum halmac_ret_status status = HALMAC_RET_SUCCESS;
+
+	RT_TRACE(adapter->drv_adapter, COMP_HALMAC, DBG_DMESG, "%s\n",
+		 __func__);
+
+	GENERAL_INFO_SET_FW_TX_BOUNDARY(h2c_buf,
+					adapter->txff_alloc.rsvd_fw_txbuf_addr -
+					adapter->txff_alloc.rsvd_boundary);
+
+	hdr_info.sub_cmd_id = SUB_CMD_ID_GENERAL_INFO;
+	hdr_info.content_size = 4;
+	hdr_info.ack = 0;
+	set_h2c_pkt_hdr_88xx(adapter, h2c_buf, &hdr_info, &seq_num);
+
+	status = send_h2c_pkt_88xx(adapter, h2c_buf);
+
+	if (status != HALMAC_RET_SUCCESS)
+		pr_err("send h2c!!\n");
+
+	return status;
+}
+
+static enum halmac_ret_status
+proc_send_phydm_info_88xx(struct halmac_adapter *adapter,
+			  struct halmac_general_info *info)
+{
+	u8 h2c_buf[H2C_PKT_SIZE_88XX] = { 0 };
+	u16 seq_num = 0;
+	struct halmac_h2c_header_info hdr_info;
+	enum halmac_ret_status status = HALMAC_RET_SUCCESS;
+
+	RT_TRACE(adapter->drv_adapter, COMP_HALMAC, DBG_DMESG, "%s\n",
+		 __func__);
+
+	PHYDM_INFO_SET_REF_TYPE(h2c_buf, info->rfe_type);
+	PHYDM_INFO_SET_RF_TYPE(h2c_buf, info->rf_type);
+	PHYDM_INFO_SET_CUT_VER(h2c_buf, adapter->chip_ver);
+	PHYDM_INFO_SET_RX_ANT_STATUS(h2c_buf, info->rx_ant_status);
+	PHYDM_INFO_SET_TX_ANT_STATUS(h2c_buf, info->tx_ant_status);
+
+	hdr_info.sub_cmd_id = SUB_CMD_ID_PHYDM_INFO;
+	hdr_info.content_size = 8;
+	hdr_info.ack = 0;
+	set_h2c_pkt_hdr_88xx(adapter, h2c_buf, &hdr_info, &seq_num);
+
+	status = send_h2c_pkt_88xx(adapter, h2c_buf);
+
+	if (status != HALMAC_RET_SUCCESS)
+		pr_err("send h2c!!\n");
+
+	return status;
+}
+
+/**
+ * drv_fwctrl_88xx() - send drv-defined h2c pkt
+ * @adapter : the adapter of halmac
+ * @payload : no include offload pkt h2c header
+ * @size : no include offload pkt h2c header
+ * Author : Ivan Lin
+ * Return : enum halmac_ret_status
+ * More details of status code can be found in prototype document
+ */
+enum halmac_ret_status
+drv_fwctrl_88xx(struct halmac_adapter *adapter, u8 *payload, u32 size, u8 ack)
+{
+	u8 h2c_buf[H2C_PKT_SIZE_88XX] = { 0 };
+	u16 seq_num = 0;
+	struct halmac_h2c_header_info hdr_info;
+	enum halmac_ret_status status = HALMAC_RET_SUCCESS;
+
+	RT_TRACE(adapter->drv_adapter, COMP_HALMAC, DBG_DMESG, "%s ===>\n",
+		 __func__);
+
+	if (!payload)
+		return HALMAC_RET_DATA_BUF_NULL;
+
+	if (size > H2C_PKT_SIZE_88XX - H2C_PKT_HDR_SIZE_88XX)
+		return HALMAC_RET_DATA_SIZE_INCORRECT;
+
+	memcpy(h2c_buf + H2C_PKT_HDR_SIZE_88XX, payload, size);
+
+	hdr_info.sub_cmd_id = SUB_CMD_ID_FW_FWCTRL;
+	hdr_info.content_size = (u16)size;
+	hdr_info.ack = ack;
+	set_h2c_pkt_hdr_88xx(adapter, h2c_buf, &hdr_info, &seq_num);
+
+	status = send_h2c_pkt_88xx(adapter, h2c_buf);
+
+	if (status != HALMAC_RET_SUCCESS)
+		pr_err("send h2c!!\n");
+
+	RT_TRACE(adapter->drv_adapter, COMP_HALMAC, DBG_DMESG, "%s <===\n",
+		 __func__);
+
+	return status;
+}
diff --git a/drivers/net/wireless/realtek/rtlwifi/halmac/halmac_88xx/halmac_fw_88xx.h b/drivers/net/wireless/realtek/rtlwifi/halmac/halmac_88xx/halmac_fw_88xx.h
new file mode 100644
index 000000000000..bf8ba8b58f2d
--- /dev/null
+++ b/drivers/net/wireless/realtek/rtlwifi/halmac/halmac_88xx/halmac_fw_88xx.h
@@ -0,0 +1,57 @@
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
+#ifndef _HALMAC_FW_88XX_H_
+#define _HALMAC_FW_88XX_H_
+
+#include "../halmac_api.h"
+
+#define HALMC_DDMA_POLLING_COUNT		1000
+
+enum halmac_ret_status
+download_firmware_88xx(struct halmac_adapter *adapter, u8 *fw_bin, u32 size);
+
+enum halmac_ret_status
+free_download_firmware_88xx(struct halmac_adapter *adapter,
+			    enum halmac_dlfw_mem mem_sel, u8 *fw_bin, u32 size);
+
+enum halmac_ret_status
+get_fw_version_88xx(struct halmac_adapter *adapter,
+		    struct halmac_fw_version *ver);
+
+enum halmac_ret_status
+check_fw_status_88xx(struct halmac_adapter *adapter, u8 *fw_status);
+
+enum halmac_ret_status
+dump_fw_dmem_88xx(struct halmac_adapter *adapter, u8 *dmem, u32 *size);
+
+enum halmac_ret_status
+cfg_max_dl_size_88xx(struct halmac_adapter *adapter, u32 size);
+
+enum halmac_ret_status
+enter_cpu_sleep_mode_88xx(struct halmac_adapter *adapter);
+
+enum halmac_ret_status
+get_cpu_mode_88xx(struct halmac_adapter *adapter,
+		  enum halmac_wlcpu_mode *mode);
+
+enum halmac_ret_status
+send_general_info_88xx(struct halmac_adapter *adapter,
+		       struct halmac_general_info *info);
+
+enum halmac_ret_status
+drv_fwctrl_88xx(struct halmac_adapter *adapter, u8 *payload, u32 size, u8 ack);
+
+#endif/* _HALMAC_FW_88XX_H_ */
diff --git a/drivers/net/wireless/realtek/rtlwifi/halmac/halmac_fw_info.h b/drivers/net/wireless/realtek/rtlwifi/halmac/halmac_fw_info.h
new file mode 100644
index 000000000000..1da64fba231a
--- /dev/null
+++ b/drivers/net/wireless/realtek/rtlwifi/halmac/halmac_fw_info.h
@@ -0,0 +1,119 @@
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
+#ifndef _HALMAC_FW_INFO_H_
+#define _HALMAC_FW_INFO_H_
+
+#define H2C_FORMAT_VERSION		11
+
+/* FW bin information */
+#define WLAN_FW_HDR_SIZE		64
+#define WLAN_FW_HDR_CHKSUM_SIZE		8
+
+#define WLAN_FW_HDR_VERSION		4
+#define WLAN_FW_HDR_SUBVERSION		6
+#define WLAN_FW_HDR_SUBINDEX		7
+#define WLAN_FW_HDR_MONTH		16
+#define WLAN_FW_HDR_DATE		17
+#define WLAN_FW_HDR_HOUR		18
+#define WLAN_FW_HDR_MIN			19
+#define WLAN_FW_HDR_YEAR		20
+#define WLAN_FW_HDR_MEM_USAGE		24
+#define WLAN_FW_HDR_H2C_FMT_VER		28
+#define WLAN_FW_HDR_DMEM_ADDR		32
+#define WLAN_FW_HDR_DMEM_SIZE		36
+#define WLAN_FW_HDR_IMEM_SIZE		48
+#define WLAN_FW_HDR_EMEM_SIZE		52
+#define WLAN_FW_HDR_EMEM_ADDR		56
+#define WLAN_FW_HDR_IMEM_ADDR		60
+
+#define H2C_ACK_HDR_CONTENT_LENGTH		8
+#define CFG_PARAMETER_ACK_CONTENT_LENGTH	16
+#define SCAN_STATUS_RPT_CONTENT_LENGTH		4
+#define C2H_DBG_HDR_LEN				4
+#define C2H_DBG_CONTENT_MAX_LENGTH		228
+#define C2H_DBG_CONTENT_SEQ_OFFSET		1
+
+/* Rename from FW SysHalCom_Debug_RAM.h */
+#define FW_REG_H2CPKT_DONE_SEQ		0x1C8
+#define FW_REG_WOW_REASON		0x1C7
+
+enum halmac_data_type {
+	HALMAC_DATA_TYPE_MAC_REG = 0x00,
+	HALMAC_DATA_TYPE_BB_REG = 0x01,
+	HALMAC_DATA_TYPE_RADIO_A = 0x02,
+	HALMAC_DATA_TYPE_RADIO_B = 0x03,
+	HALMAC_DATA_TYPE_RADIO_C = 0x04,
+	HALMAC_DATA_TYPE_RADIO_D = 0x05,
+
+	HALMAC_DATA_TYPE_DRV_DEFINE_0 = 0x80,
+	HALMAC_DATA_TYPE_DRV_DEFINE_1 = 0x81,
+	HALMAC_DATA_TYPE_DRV_DEFINE_2 = 0x82,
+	HALMAC_DATA_TYPE_DRV_DEFINE_3 = 0x83,
+	HALMAC_DATA_TYPE_UNDEFINE = 0x7FFFFFFF,
+};
+
+enum halmac_packet_id {
+	HALMAC_PACKET_PROBE_REQ = 0x00,
+	HALMAC_PACKET_SYNC_BCN = 0x01,
+	HALMAC_PACKET_DISCOVERY_BCN = 0x02,
+	HALMAC_PACKET_UNDEFINE = 0x7FFFFFFF,
+};
+
+enum halmac_cs_action_id {
+	HALMAC_CS_ACTION_NONE = 0x00,
+	HALMAC_CS_ACTIVE_SCAN = 0x01,
+	HALMAC_CS_NAN_NONMASTER_DW = 0x02,
+	HALMAC_CS_NAN_NONMASTER_NONDW = 0x03,
+	HALMAC_CS_NAN_MASTER_NONDW = 0x04,
+	HALMAC_CS_NAN_MASTER_DW = 0x05,
+	HALMAC_CS_ACTION_UNDEFINE = 0x7FFFFFFF,
+};
+
+enum halmac_cs_extra_action_id {
+	HALMAC_CS_EXTRA_ACTION_NONE = 0x00,
+	HALMAC_CS_EXTRA_UPDATE_PROBE = 0x01,
+	HALMAC_CS_EXTRA_UPDATE_BEACON = 0x02,
+	HALMAC_CS_EXTRA_ACTION_UNDEFINE = 0x7FFFFFFF,
+};
+
+enum halmac_h2c_return_code {
+	HALMAC_H2C_RETURN_SUCCESS = 0x00,
+	HALMAC_H2C_RETURN_CFG_ERR_LEN = 0x01,
+	HALMAC_H2C_RETURN_CFG_ERR_CMD = 0x02,
+	HALMAC_H2C_RETURN_EFUSE_ERR_DUMP = 0x03,
+	HALMAC_H2C_RETURN_DATAPACK_ERR_FULL = 0x04,
+	HALMAC_H2C_RETURN_DATAPACK_ERR_ID = 0x05,
+	HALMAC_H2C_RETURN_RUN_ERR_EMPTY = 0x06,
+	HALMAC_H2C_RETURN_RUN_ERR_LEN = 0x07,
+	HALMAC_H2C_RETURN_RUN_ERR_CMD = 0x08,
+	HALMAC_H2C_RETURN_RUN_ERR_ID = 0x09,
+	HALMAC_H2C_RETURN_PACKET_ERR_FULL = 0x0A,
+	HALMAC_H2C_RETURN_PACKET_ERR_ID = 0x0B,
+	HALMAC_H2C_RETURN_SCAN_ERR_FULL = 0x0C,
+	HALMAC_H2C_RETURN_SCAN_ERR_PHYDM = 0x0D,
+	HALMAC_H2C_RETURN_ORIG_ERR_ID = 0x0E,
+	HALMAC_H2C_RETURN_UNDEFINE = 0x7FFFFFFF,
+};
+
+enum halmac_scan_report_code {
+	HALMAC_SCAN_REPORT_DONE	= 0x00,
+	HALMAC_SCAN_REPORT_ERR_PHYDM = 0x01,
+	HALMAC_SCAN_REPORT_ERR_ID = 0x02,
+	HALMAC_SCAN_REPORT_ERR_TX = 0x03,
+	HALMAC_SCAN_REPORT_UNDEFINE = 0x7FFFFFFF,
+};
+
+#endif
diff --git a/drivers/net/wireless/realtek/rtlwifi/halmac/halmac_fw_offload_c2h_nic.h b/drivers/net/wireless/realtek/rtlwifi/halmac/halmac_fw_offload_c2h_nic.h
new file mode 100644
index 000000000000..b87e34187283
--- /dev/null
+++ b/drivers/net/wireless/realtek/rtlwifi/halmac/halmac_fw_offload_c2h_nic.h
@@ -0,0 +1,371 @@
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
+#ifndef _HAL_FWOFFLOADC2HFORMAT_H2C_C2H_NIC_H_
+#define _HAL_FWOFFLOADC2HFORMAT_H2C_C2H_NIC_H_
+#define C2H_SUB_CMD_ID_C2H_DBG 0X00
+#define C2H_SUB_CMD_ID_BT_COEX_INFO 0X02
+#define C2H_SUB_CMD_ID_SCAN_STATUS_RPT 0X03
+#define C2H_SUB_CMD_ID_H2C_ACK_HDR 0X01
+#define C2H_SUB_CMD_ID_CFG_PARAM_ACK 0X01
+#define C2H_SUB_CMD_ID_BT_COEX_ACK 0X01
+#define C2H_SUB_CMD_ID_DUMP_PHYSICAL_EFUSE_ACK 0X01
+#define C2H_SUB_CMD_ID_UPDATE_PKT_ACK 0X01
+#define C2H_SUB_CMD_ID_UPDATE_DATAPACK_ACK 0X01
+#define C2H_SUB_CMD_ID_RUN_DATAPACK_ACK 0X01
+#define C2H_SUB_CMD_ID_CH_SWITCH_ACK 0X01
+#define C2H_SUB_CMD_ID_IQK_ACK 0X01
+#define C2H_SUB_CMD_ID_PWR_TRK_ACK 0X01
+#define C2H_SUB_CMD_ID_PSD_ACK 0X01
+#define C2H_SUB_CMD_ID_PSD_DATA 0X04
+#define C2H_SUB_CMD_ID_EFUSE_DATA 0X05
+#define C2H_SUB_CMD_ID_IQK_DATA 0X06
+#define C2H_SUB_CMD_ID_C2H_PKT_FTM_DBG 0X07
+#define C2H_SUB_CMD_ID_C2H_PKT_FTM_2_DBG 0X08
+#define C2H_SUB_CMD_ID_C2H_PKT_FTM_3_DBG 0X09
+#define C2H_SUB_CMD_ID_C2H_PKT_FTM_4_DBG 0X0A
+#define C2H_SUB_CMD_ID_FTMACKRPT_HDL_DBG 0X0B
+#define C2H_SUB_CMD_ID_FTMC2H_RPT 0X0C
+#define C2H_SUB_CMD_ID_DRVFTMC2H_RPT 0X0D
+#define C2H_SUB_CMD_ID_C2H_PKT_FTM_5_DBG 0X0E
+#define C2H_SUB_CMD_ID_CCX_RPT 0X0F
+#define C2H_SUB_CMD_ID_C2H_PKT_NAN_RPT 0X10
+#define C2H_SUB_CMD_ID_C2H_PKT_ATM_RPT 0X11
+#define C2H_SUB_CMD_ID_C2H_PKT_FTMSESSION_END 0X1C
+#define C2H_SUB_CMD_ID_C2H_PKT_DETECT_THERMAL 0X1D
+#define C2H_SUB_CMD_ID_FW_DBG_MSG 0XFF
+#define C2H_SUB_CMD_ID_FW_SNDING_ACK 0X01
+#define C2H_SUB_CMD_ID_FW_FWCTRL_RPT 0X1F
+#define C2H_SUB_CMD_ID_H2C_LOOPBACK_ACK 0X20
+#define C2H_SUB_CMD_ID_FWCMD_LOOPBACK_ACK 0X21
+#define H2C_SUB_CMD_ID_CFG_PARAM_ACK SUB_CMD_ID_CFG_PARAM
+#define H2C_SUB_CMD_ID_BT_COEX_ACK SUB_CMD_ID_BT_COEX
+#define H2C_SUB_CMD_ID_DUMP_PHYSICAL_EFUSE_ACK SUB_CMD_ID_DUMP_PHYSICAL_EFUSE
+#define H2C_SUB_CMD_ID_UPDATE_PKT_ACK SUB_CMD_ID_UPDATE_PKT
+#define H2C_SUB_CMD_ID_UPDATE_DATAPACK_ACK SUB_CMD_ID_UPDATE_DATAPACK
+#define H2C_SUB_CMD_ID_RUN_DATAPACK_ACK SUB_CMD_ID_RUN_DATAPACK
+#define H2C_SUB_CMD_ID_CH_SWITCH_ACK SUB_CMD_ID_CH_SWITCH
+#define H2C_SUB_CMD_ID_IQK_ACK SUB_CMD_ID_IQK
+#define H2C_SUB_CMD_ID_PWR_TRK_ACK SUB_CMD_ID_PWR_TRK
+#define H2C_SUB_CMD_ID_PSD_ACK SUB_CMD_ID_PSD
+#define H2C_SUB_CMD_ID_CCX_RPT SUB_CMD_ID_CCX_RPT
+#define H2C_SUB_CMD_ID_FW_DBG_MSG SUB_CMD_ID_FW_DBG_MSG
+#define H2C_SUB_CMD_ID_FW_SNDING_ACK SUB_CMD_ID_FW_SNDING
+#define H2C_SUB_CMD_ID_FW_FWCTRL_RPT SUB_CMD_ID_FW_FWCTRL_RPT
+#define H2C_SUB_CMD_ID_H2C_LOOPBACK_ACK SUB_CMD_ID_H2C_LOOPBACK
+#define H2C_SUB_CMD_ID_FWCMD_LOOPBACK_ACK SUB_CMD_ID_FWCMD_LOOPBACK
+#define H2C_CMD_ID_CFG_PARAM_ACK 0XFF
+#define H2C_CMD_ID_BT_COEX_ACK 0XFF
+#define H2C_CMD_ID_DUMP_PHYSICAL_EFUSE_ACK 0XFF
+#define H2C_CMD_ID_UPDATE_PKT_ACK 0XFF
+#define H2C_CMD_ID_UPDATE_DATAPACK_ACK 0XFF
+#define H2C_CMD_ID_RUN_DATAPACK_ACK 0XFF
+#define H2C_CMD_ID_CH_SWITCH_ACK 0XFF
+#define H2C_CMD_ID_IQK_ACK 0XFF
+#define H2C_CMD_ID_PWR_TRK_ACK 0XFF
+#define H2C_CMD_ID_PSD_ACK 0XFF
+#define H2C_CMD_ID_CCX_RPT 0XFF
+#define H2C_CMD_ID_FW_DBG_MSG 0XFF
+#define H2C_CMD_ID_FW_SNDING_ACK 0XFF
+#define H2C_CMD_ID_FW_FWCTRL_RPT 0XFF
+#define H2C_CMD_ID_H2C_LOOPBACK_ACK 0XFF
+#define H2C_CMD_ID_FWCMD_LOOPBACK_ACK 0XFF
+#define C2H_HDR_GET_CMD_ID(c2h_pkt) LE_BITS_TO_4BYTE(c2h_pkt + 0X00, 0, 8)
+#define C2H_HDR_SET_CMD_ID(c2h_pkt, value)                                     \
+	SET_BITS_TO_LE_4BYTE(c2h_pkt + 0X00, 0, 8, value)
+#define C2H_HDR_GET_SEQ(c2h_pkt) LE_BITS_TO_4BYTE(c2h_pkt + 0X00, 8, 8)
+#define C2H_HDR_SET_SEQ(c2h_pkt, value)                                        \
+	SET_BITS_TO_LE_4BYTE(c2h_pkt + 0X00, 8, 8, value)
+#define C2H_HDR_GET_C2H_SUB_CMD_ID(c2h_pkt)                                    \
+	LE_BITS_TO_4BYTE(c2h_pkt + 0X00, 16, 8)
+#define C2H_HDR_SET_C2H_SUB_CMD_ID(c2h_pkt, value)                             \
+	SET_BITS_TO_LE_4BYTE(c2h_pkt + 0X00, 16, 8, value)
+#define C2H_HDR_GET_LEN(c2h_pkt) LE_BITS_TO_4BYTE(c2h_pkt + 0X00, 24, 8)
+#define C2H_HDR_SET_LEN(c2h_pkt, value)                                        \
+	SET_BITS_TO_LE_4BYTE(c2h_pkt + 0X00, 24, 8, value)
+#define C2H_DBG_GET_DBG_MSG(c2h_pkt) LE_BITS_TO_4BYTE(c2h_pkt + 0X04, 0, 8)
+#define C2H_DBG_SET_DBG_MSG(c2h_pkt, value)                                    \
+	SET_BITS_TO_LE_4BYTE(c2h_pkt + 0X04, 0, 8, value)
+#define BT_COEX_INFO_GET_DATA_START(c2h_pkt)                                   \
+	LE_BITS_TO_4BYTE(c2h_pkt + 0X04, 0, 8)
+#define BT_COEX_INFO_SET_DATA_START(c2h_pkt, value)                            \
+	SET_BITS_TO_LE_4BYTE(c2h_pkt + 0X04, 0, 8, value)
+#define SCAN_STATUS_RPT_GET_H2C_RETURN_CODE(c2h_pkt)                           \
+	LE_BITS_TO_4BYTE(c2h_pkt + 0X04, 0, 8)
+#define SCAN_STATUS_RPT_SET_H2C_RETURN_CODE(c2h_pkt, value)                    \
+	SET_BITS_TO_LE_4BYTE(c2h_pkt + 0X04, 0, 8, value)
+#define SCAN_STATUS_RPT_GET_H2C_SEQ(c2h_pkt)                                   \
+	LE_BITS_TO_4BYTE(c2h_pkt + 0X04, 16, 16)
+#define SCAN_STATUS_RPT_SET_H2C_SEQ(c2h_pkt, value)                            \
+	SET_BITS_TO_LE_4BYTE(c2h_pkt + 0X04, 16, 16, value)
+#define H2C_ACK_HDR_GET_H2C_RETURN_CODE(c2h_pkt)                               \
+	LE_BITS_TO_4BYTE(c2h_pkt + 0X04, 0, 8)
+#define H2C_ACK_HDR_SET_H2C_RETURN_CODE(c2h_pkt, value)                        \
+	SET_BITS_TO_LE_4BYTE(c2h_pkt + 0X04, 0, 8, value)
+#define H2C_ACK_HDR_GET_H2C_CMD_ID(c2h_pkt)                                    \
+	LE_BITS_TO_4BYTE(c2h_pkt + 0X04, 8, 8)
+#define H2C_ACK_HDR_SET_H2C_CMD_ID(c2h_pkt, value)                             \
+	SET_BITS_TO_LE_4BYTE(c2h_pkt + 0X04, 8, 8, value)
+#define H2C_ACK_HDR_GET_H2C_SUB_CMD_ID(c2h_pkt)                                \
+	LE_BITS_TO_4BYTE(c2h_pkt + 0X04, 16, 16)
+#define H2C_ACK_HDR_SET_H2C_SUB_CMD_ID(c2h_pkt, value)                         \
+	SET_BITS_TO_LE_4BYTE(c2h_pkt + 0X04, 16, 16, value)
+#define H2C_ACK_HDR_GET_H2C_SEQ(c2h_pkt) LE_BITS_TO_4BYTE(c2h_pkt + 0X08, 0, 16)
+#define H2C_ACK_HDR_SET_H2C_SEQ(c2h_pkt, value)                                \
+	SET_BITS_TO_LE_4BYTE(c2h_pkt + 0X08, 0, 16, value)
+#define CFG_PARAM_ACK_GET_OFFSET_ACCUMULATION(c2h_pkt)                         \
+	LE_BITS_TO_4BYTE(c2h_pkt + 0XC, 0, 32)
+#define CFG_PARAM_ACK_SET_OFFSET_ACCUMULATION(c2h_pkt, value)                  \
+	SET_BITS_TO_LE_4BYTE(c2h_pkt + 0XC, 0, 32, value)
+#define CFG_PARAM_ACK_GET_VALUE_ACCUMULATION(c2h_pkt)                          \
+	LE_BITS_TO_4BYTE(c2h_pkt + 0X10, 0, 32)
+#define CFG_PARAM_ACK_SET_VALUE_ACCUMULATION(c2h_pkt, value)                   \
+	SET_BITS_TO_LE_4BYTE(c2h_pkt + 0X10, 0, 32, value)
+#define BT_COEX_ACK_GET_DATA_START(c2h_pkt)                                    \
+	LE_BITS_TO_4BYTE(c2h_pkt + 0XC, 0, 8)
+#define BT_COEX_ACK_SET_DATA_START(c2h_pkt, value)                             \
+	SET_BITS_TO_LE_4BYTE(c2h_pkt + 0XC, 0, 8, value)
+#define PSD_DATA_GET_SEGMENT_ID(c2h_pkt) LE_BITS_TO_4BYTE(c2h_pkt + 0X04, 0, 7)
+#define PSD_DATA_SET_SEGMENT_ID(c2h_pkt, value)                                \
+	SET_BITS_TO_LE_4BYTE(c2h_pkt + 0X04, 0, 7, value)
+#define PSD_DATA_GET_END_SEGMENT(c2h_pkt) LE_BITS_TO_4BYTE(c2h_pkt + 0X04, 7, 1)
+#define PSD_DATA_SET_END_SEGMENT(c2h_pkt, value)                               \
+	SET_BITS_TO_LE_4BYTE(c2h_pkt + 0X04, 7, 1, value)
+#define PSD_DATA_GET_SEGMENT_SIZE(c2h_pkt)                                     \
+	LE_BITS_TO_4BYTE(c2h_pkt + 0X04, 8, 8)
+#define PSD_DATA_SET_SEGMENT_SIZE(c2h_pkt, value)                              \
+	SET_BITS_TO_LE_4BYTE(c2h_pkt + 0X04, 8, 8, value)
+#define PSD_DATA_GET_TOTAL_SIZE(c2h_pkt)                                       \
+	LE_BITS_TO_4BYTE(c2h_pkt + 0X04, 16, 16)
+#define PSD_DATA_SET_TOTAL_SIZE(c2h_pkt, value)                                \
+	SET_BITS_TO_LE_4BYTE(c2h_pkt + 0X04, 16, 16, value)
+#define PSD_DATA_GET_H2C_SEQ(c2h_pkt) LE_BITS_TO_4BYTE(c2h_pkt + 0X8, 0, 16)
+#define PSD_DATA_SET_H2C_SEQ(c2h_pkt, value)                                   \
+	SET_BITS_TO_LE_4BYTE(c2h_pkt + 0X8, 0, 16, value)
+#define PSD_DATA_GET_DATA_START(c2h_pkt) LE_BITS_TO_4BYTE(c2h_pkt + 0X8, 16, 8)
+#define PSD_DATA_SET_DATA_START(c2h_pkt, value)                                \
+	SET_BITS_TO_LE_4BYTE(c2h_pkt + 0X8, 16, 8, value)
+#define EFUSE_DATA_GET_SEGMENT_ID(c2h_pkt)                                     \
+	LE_BITS_TO_4BYTE(c2h_pkt + 0X04, 0, 7)
+#define EFUSE_DATA_SET_SEGMENT_ID(c2h_pkt, value)                              \
+	SET_BITS_TO_LE_4BYTE(c2h_pkt + 0X04, 0, 7, value)
+#define EFUSE_DATA_GET_END_SEGMENT(c2h_pkt)                                    \
+	LE_BITS_TO_4BYTE(c2h_pkt + 0X04, 7, 1)
+#define EFUSE_DATA_SET_END_SEGMENT(c2h_pkt, value)                             \
+	SET_BITS_TO_LE_4BYTE(c2h_pkt + 0X04, 7, 1, value)
+#define EFUSE_DATA_GET_SEGMENT_SIZE(c2h_pkt)                                   \
+	LE_BITS_TO_4BYTE(c2h_pkt + 0X04, 8, 8)
+#define EFUSE_DATA_SET_SEGMENT_SIZE(c2h_pkt, value)                            \
+	SET_BITS_TO_LE_4BYTE(c2h_pkt + 0X04, 8, 8, value)
+#define EFUSE_DATA_GET_TOTAL_SIZE(c2h_pkt)                                     \
+	LE_BITS_TO_4BYTE(c2h_pkt + 0X04, 16, 16)
+#define EFUSE_DATA_SET_TOTAL_SIZE(c2h_pkt, value)                              \
+	SET_BITS_TO_LE_4BYTE(c2h_pkt + 0X04, 16, 16, value)
+#define EFUSE_DATA_GET_H2C_SEQ(c2h_pkt) LE_BITS_TO_4BYTE(c2h_pkt + 0X8, 0, 16)
+#define EFUSE_DATA_SET_H2C_SEQ(c2h_pkt, value)                                 \
+	SET_BITS_TO_LE_4BYTE(c2h_pkt + 0X8, 0, 16, value)
+#define EFUSE_DATA_GET_DATA_START(c2h_pkt)                                     \
+	LE_BITS_TO_4BYTE(c2h_pkt + 0X8, 16, 8)
+#define EFUSE_DATA_SET_DATA_START(c2h_pkt, value)                              \
+	SET_BITS_TO_LE_4BYTE(c2h_pkt + 0X8, 16, 8, value)
+#define IQK_DATA_GET_SEGMENT_ID(c2h_pkt) LE_BITS_TO_4BYTE(c2h_pkt + 0X04, 0, 7)
+#define IQK_DATA_SET_SEGMENT_ID(c2h_pkt, value)                                \
+	SET_BITS_TO_LE_4BYTE(c2h_pkt + 0X04, 0, 7, value)
+#define IQK_DATA_GET_END_SEGMENT(c2h_pkt) LE_BITS_TO_4BYTE(c2h_pkt + 0X04, 7, 1)
+#define IQK_DATA_SET_END_SEGMENT(c2h_pkt, value)                               \
+	SET_BITS_TO_LE_4BYTE(c2h_pkt + 0X04, 7, 1, value)
+#define IQK_DATA_GET_SEGMENT_SIZE(c2h_pkt)                                     \
+	LE_BITS_TO_4BYTE(c2h_pkt + 0X04, 8, 8)
+#define IQK_DATA_SET_SEGMENT_SIZE(c2h_pkt, value)                              \
+	SET_BITS_TO_LE_4BYTE(c2h_pkt + 0X04, 8, 8, value)
+#define IQK_DATA_GET_TOTAL_SIZE(c2h_pkt)                                       \
+	LE_BITS_TO_4BYTE(c2h_pkt + 0X04, 16, 16)
+#define IQK_DATA_SET_TOTAL_SIZE(c2h_pkt, value)                                \
+	SET_BITS_TO_LE_4BYTE(c2h_pkt + 0X04, 16, 16, value)
+#define IQK_DATA_GET_H2C_SEQ(c2h_pkt) LE_BITS_TO_4BYTE(c2h_pkt + 0X8, 0, 16)
+#define IQK_DATA_SET_H2C_SEQ(c2h_pkt, value)                                   \
+	SET_BITS_TO_LE_4BYTE(c2h_pkt + 0X8, 0, 16, value)
+#define IQK_DATA_GET_DATA_START(c2h_pkt) LE_BITS_TO_4BYTE(c2h_pkt + 0X8, 16, 8)
+#define IQK_DATA_SET_DATA_START(c2h_pkt, value)                                \
+	SET_BITS_TO_LE_4BYTE(c2h_pkt + 0X8, 16, 8, value)
+#define CCX_RPT_GET_POLLUTED(c2h_pkt) LE_BITS_TO_4BYTE(c2h_pkt + 0X4, 0, 1)
+#define CCX_RPT_SET_POLLUTED(c2h_pkt, value)                                   \
+	SET_BITS_TO_LE_4BYTE(c2h_pkt + 0X4, 0, 1, value)
+#define CCX_RPT_GET_RPT_SEL(c2h_pkt) LE_BITS_TO_4BYTE(c2h_pkt + 0X4, 5, 3)
+#define CCX_RPT_SET_RPT_SEL(c2h_pkt, value)                                    \
+	SET_BITS_TO_LE_4BYTE(c2h_pkt + 0X4, 5, 3, value)
+#define CCX_RPT_GET_QSEL(c2h_pkt) LE_BITS_TO_4BYTE(c2h_pkt + 0X4, 8, 5)
+#define CCX_RPT_SET_QSEL(c2h_pkt, value)                                       \
+	SET_BITS_TO_LE_4BYTE(c2h_pkt + 0X4, 8, 5, value)
+#define CCX_RPT_GET_MISSED_RPT_NUM(c2h_pkt)                                    \
+	LE_BITS_TO_4BYTE(c2h_pkt + 0X4, 13, 3)
+#define CCX_RPT_SET_MISSED_RPT_NUM(c2h_pkt, value)                             \
+	SET_BITS_TO_LE_4BYTE(c2h_pkt + 0X4, 13, 3, value)
+#define CCX_RPT_GET_MACID(c2h_pkt) LE_BITS_TO_4BYTE(c2h_pkt + 0X4, 16, 7)
+#define CCX_RPT_SET_MACID(c2h_pkt, value)                                      \
+	SET_BITS_TO_LE_4BYTE(c2h_pkt + 0X4, 16, 7, value)
+#define CCX_RPT_GET_INITIAL_DATA_RATE(c2h_pkt)                                 \
+	LE_BITS_TO_4BYTE(c2h_pkt + 0X4, 24, 7)
+#define CCX_RPT_SET_INITIAL_DATA_RATE(c2h_pkt, value)                          \
+	SET_BITS_TO_LE_4BYTE(c2h_pkt + 0X4, 24, 7, value)
+#define CCX_RPT_GET_INITIAL_SGI(c2h_pkt) LE_BITS_TO_4BYTE(c2h_pkt + 0X4, 31, 1)
+#define CCX_RPT_SET_INITIAL_SGI(c2h_pkt, value)                                \
+	SET_BITS_TO_LE_4BYTE(c2h_pkt + 0X4, 31, 1, value)
+#define CCX_RPT_GET_QUEUE_TIME(c2h_pkt) LE_BITS_TO_4BYTE(c2h_pkt + 0X8, 0, 16)
+#define CCX_RPT_SET_QUEUE_TIME(c2h_pkt, value)                                 \
+	SET_BITS_TO_LE_4BYTE(c2h_pkt + 0X8, 0, 16, value)
+#define CCX_RPT_GET_SW_DEFINE_BYTE0(c2h_pkt)                                   \
+	LE_BITS_TO_4BYTE(c2h_pkt + 0X8, 16, 8)
+#define CCX_RPT_SET_SW_DEFINE_BYTE0(c2h_pkt, value)                            \
+	SET_BITS_TO_LE_4BYTE(c2h_pkt + 0X8, 16, 8, value)
+#define CCX_RPT_GET_RTS_RETRY_COUNT(c2h_pkt)                                   \
+	LE_BITS_TO_4BYTE(c2h_pkt + 0X8, 24, 4)
+#define CCX_RPT_SET_RTS_RETRY_COUNT(c2h_pkt, value)                            \
+	SET_BITS_TO_LE_4BYTE(c2h_pkt + 0X8, 24, 4, value)
+#define CCX_RPT_GET_BMC(c2h_pkt) LE_BITS_TO_4BYTE(c2h_pkt + 0X8, 29, 1)
+#define CCX_RPT_SET_BMC(c2h_pkt, value)                                        \
+	SET_BITS_TO_LE_4BYTE(c2h_pkt + 0X8, 29, 1, value)
+#define CCX_RPT_GET_TX_STATE(c2h_pkt) LE_BITS_TO_4BYTE(c2h_pkt + 0X8, 30, 2)
+#define CCX_RPT_SET_TX_STATE(c2h_pkt, value)                                   \
+	SET_BITS_TO_LE_4BYTE(c2h_pkt + 0X8, 30, 2, value)
+#define CCX_RPT_GET_DATA_RETRY_COUNT(c2h_pkt)                                  \
+	LE_BITS_TO_4BYTE(c2h_pkt + 0XC, 0, 6)
+#define CCX_RPT_SET_DATA_RETRY_COUNT(c2h_pkt, value)                           \
+	SET_BITS_TO_LE_4BYTE(c2h_pkt + 0XC, 0, 6, value)
+#define CCX_RPT_GET_FINAL_DATA_RATE(c2h_pkt)                                   \
+	LE_BITS_TO_4BYTE(c2h_pkt + 0XC, 8, 7)
+#define CCX_RPT_SET_FINAL_DATA_RATE(c2h_pkt, value)                            \
+	SET_BITS_TO_LE_4BYTE(c2h_pkt + 0XC, 8, 7, value)
+#define CCX_RPT_GET_FINAL_SGI(c2h_pkt) LE_BITS_TO_4BYTE(c2h_pkt + 0XC, 15, 1)
+#define CCX_RPT_SET_FINAL_SGI(c2h_pkt, value)                                  \
+	SET_BITS_TO_LE_4BYTE(c2h_pkt + 0XC, 15, 1, value)
+#define CCX_RPT_GET_RF_CH_NUM(c2h_pkt) LE_BITS_TO_4BYTE(c2h_pkt + 0XC, 16, 10)
+#define CCX_RPT_SET_RF_CH_NUM(c2h_pkt, value)                                  \
+	SET_BITS_TO_LE_4BYTE(c2h_pkt + 0XC, 16, 10, value)
+#define CCX_RPT_GET_SC(c2h_pkt) LE_BITS_TO_4BYTE(c2h_pkt + 0XC, 26, 4)
+#define CCX_RPT_SET_SC(c2h_pkt, value)                                         \
+	SET_BITS_TO_LE_4BYTE(c2h_pkt + 0XC, 26, 4, value)
+#define CCX_RPT_GET_BW(c2h_pkt) LE_BITS_TO_4BYTE(c2h_pkt + 0XC, 30, 2)
+#define CCX_RPT_SET_BW(c2h_pkt, value)                                         \
+	SET_BITS_TO_LE_4BYTE(c2h_pkt + 0XC, 30, 2, value)
+#define FW_DBG_MSG_GET_CMD_ID(c2h_pkt) LE_BITS_TO_4BYTE(c2h_pkt + 0X00, 0, 8)
+#define FW_DBG_MSG_SET_CMD_ID(c2h_pkt, value)                                  \
+	SET_BITS_TO_LE_4BYTE(c2h_pkt + 0X00, 0, 8, value)
+#define FW_DBG_MSG_GET_C2H_SUB_CMD_ID(c2h_pkt)                                 \
+	LE_BITS_TO_4BYTE(c2h_pkt + 0X00, 16, 8)
+#define FW_DBG_MSG_SET_C2H_SUB_CMD_ID(c2h_pkt, value)                          \
+	SET_BITS_TO_LE_4BYTE(c2h_pkt + 0X00, 16, 8, value)
+#define FW_DBG_MSG_GET_FULL(c2h_pkt) LE_BITS_TO_4BYTE(c2h_pkt + 0X00, 24, 1)
+#define FW_DBG_MSG_SET_FULL(c2h_pkt, value)                                    \
+	SET_BITS_TO_LE_4BYTE(c2h_pkt + 0X00, 24, 1, value)
+#define FW_DBG_MSG_GET_OWN(c2h_pkt) LE_BITS_TO_4BYTE(c2h_pkt + 0X00, 31, 1)
+#define FW_DBG_MSG_SET_OWN(c2h_pkt, value)                                     \
+	SET_BITS_TO_LE_4BYTE(c2h_pkt + 0X00, 31, 1, value)
+#define FW_FWCTRL_RPT_GET_EVT_TYPE(c2h_pkt)                                    \
+	LE_BITS_TO_4BYTE(c2h_pkt + 0X00, 0, 8)
+#define FW_FWCTRL_RPT_SET_EVT_TYPE(c2h_pkt, value)                             \
+	SET_BITS_TO_LE_4BYTE(c2h_pkt + 0X00, 0, 8, value)
+#define FW_FWCTRL_RPT_GET_LENGTH(c2h_pkt) LE_BITS_TO_4BYTE(c2h_pkt + 0X00, 8, 8)
+#define FW_FWCTRL_RPT_SET_LENGTH(c2h_pkt, value)                               \
+	SET_BITS_TO_LE_4BYTE(c2h_pkt + 0X00, 8, 8, value)
+#define FW_FWCTRL_RPT_GET_SEQ_NUM(c2h_pkt)                                     \
+	LE_BITS_TO_4BYTE(c2h_pkt + 0X00, 16, 8)
+#define FW_FWCTRL_RPT_SET_SEQ_NUM(c2h_pkt, value)                              \
+	SET_BITS_TO_LE_4BYTE(c2h_pkt + 0X00, 16, 8, value)
+#define FW_FWCTRL_RPT_GET_IS_ACK(c2h_pkt)                                      \
+	LE_BITS_TO_4BYTE(c2h_pkt + 0X00, 24, 1)
+#define FW_FWCTRL_RPT_SET_IS_ACK(c2h_pkt, value)                               \
+	SET_BITS_TO_LE_4BYTE(c2h_pkt + 0X00, 24, 1, value)
+#define FW_FWCTRL_RPT_GET_MORE_CONTENT(c2h_pkt)                                \
+	LE_BITS_TO_4BYTE(c2h_pkt + 0X00, 25, 1)
+#define FW_FWCTRL_RPT_SET_MORE_CONTENT(c2h_pkt, value)                         \
+	SET_BITS_TO_LE_4BYTE(c2h_pkt + 0X00, 25, 1, value)
+#define FW_FWCTRL_RPT_GET_CONTENT_IDX(c2h_pkt)                                 \
+	LE_BITS_TO_4BYTE(c2h_pkt + 0X00, 26, 6)
+#define FW_FWCTRL_RPT_SET_CONTENT_IDX(c2h_pkt, value)                          \
+	SET_BITS_TO_LE_4BYTE(c2h_pkt + 0X00, 26, 6, value)
+#define FW_FWCTRL_RPT_GET_CLASS_ID(c2h_pkt)                                    \
+	LE_BITS_TO_4BYTE(c2h_pkt + 0X04, 0, 8)
+#define FW_FWCTRL_RPT_SET_CLASS_ID(c2h_pkt, value)                             \
+	SET_BITS_TO_LE_4BYTE(c2h_pkt + 0X04, 0, 8, value)
+#define FW_FWCTRL_RPT_GET_CONTENT(c2h_pkt)                                     \
+	LE_BITS_TO_4BYTE(c2h_pkt + 0X04, 16, 16)
+#define FW_FWCTRL_RPT_SET_CONTENT(c2h_pkt, value)                              \
+	SET_BITS_TO_LE_4BYTE(c2h_pkt + 0X04, 16, 16, value)
+#define H2C_LOOPBACK_ACK_GET_H2C_BYTE_0(c2h_pkt)                               \
+	LE_BITS_TO_4BYTE(c2h_pkt + 0X04, 0, 8)
+#define H2C_LOOPBACK_ACK_SET_H2C_BYTE_0(c2h_pkt, value)                        \
+	SET_BITS_TO_LE_4BYTE(c2h_pkt + 0X04, 0, 8, value)
+#define H2C_LOOPBACK_ACK_GET_H2C_BYTE_1(c2h_pkt)                               \
+	LE_BITS_TO_4BYTE(c2h_pkt + 0X04, 8, 8)
+#define H2C_LOOPBACK_ACK_SET_H2C_BYTE_1(c2h_pkt, value)                        \
+	SET_BITS_TO_LE_4BYTE(c2h_pkt + 0X04, 8, 8, value)
+#define H2C_LOOPBACK_ACK_GET_H2C_BYTE_2(c2h_pkt)                               \
+	LE_BITS_TO_4BYTE(c2h_pkt + 0X04, 16, 8)
+#define H2C_LOOPBACK_ACK_SET_H2C_BYTE_2(c2h_pkt, value)                        \
+	SET_BITS_TO_LE_4BYTE(c2h_pkt + 0X04, 16, 8, value)
+#define H2C_LOOPBACK_ACK_GET_H2C_BYTE_3(c2h_pkt)                               \
+	LE_BITS_TO_4BYTE(c2h_pkt + 0X04, 24, 8)
+#define H2C_LOOPBACK_ACK_SET_H2C_BYTE_3(c2h_pkt, value)                        \
+	SET_BITS_TO_LE_4BYTE(c2h_pkt + 0X04, 24, 8, value)
+#define H2C_LOOPBACK_ACK_GET_H2C_BYTE_4(c2h_pkt)                               \
+	LE_BITS_TO_4BYTE(c2h_pkt + 0X8, 0, 8)
+#define H2C_LOOPBACK_ACK_SET_H2C_BYTE_4(c2h_pkt, value)                        \
+	SET_BITS_TO_LE_4BYTE(c2h_pkt + 0X8, 0, 8, value)
+#define H2C_LOOPBACK_ACK_GET_H2C_BYTE_5(c2h_pkt)                               \
+	LE_BITS_TO_4BYTE(c2h_pkt + 0X8, 8, 8)
+#define H2C_LOOPBACK_ACK_SET_H2C_BYTE_5(c2h_pkt, value)                        \
+	SET_BITS_TO_LE_4BYTE(c2h_pkt + 0X8, 8, 8, value)
+#define H2C_LOOPBACK_ACK_GET_H2C_BYTE_6(c2h_pkt)                               \
+	LE_BITS_TO_4BYTE(c2h_pkt + 0X8, 16, 8)
+#define H2C_LOOPBACK_ACK_SET_H2C_BYTE_6(c2h_pkt, value)                        \
+	SET_BITS_TO_LE_4BYTE(c2h_pkt + 0X8, 16, 8, value)
+#define H2C_LOOPBACK_ACK_GET_H2C_BYTE_7(c2h_pkt)                               \
+	LE_BITS_TO_4BYTE(c2h_pkt + 0X8, 24, 8)
+#define H2C_LOOPBACK_ACK_SET_H2C_BYTE_7(c2h_pkt, value)                        \
+	SET_BITS_TO_LE_4BYTE(c2h_pkt + 0X8, 24, 8, value)
+#define FWCMD_LOOPBACK_ACK_GET_H2C_BYTE_0(c2h_pkt)                             \
+	LE_BITS_TO_4BYTE(c2h_pkt + 0X04, 0, 8)
+#define FWCMD_LOOPBACK_ACK_SET_H2C_BYTE_0(c2h_pkt, value)                      \
+	SET_BITS_TO_LE_4BYTE(c2h_pkt + 0X04, 0, 8, value)
+#define FWCMD_LOOPBACK_ACK_GET_H2C_BYTE_1(c2h_pkt)                             \
+	LE_BITS_TO_4BYTE(c2h_pkt + 0X04, 8, 8)
+#define FWCMD_LOOPBACK_ACK_SET_H2C_BYTE_1(c2h_pkt, value)                      \
+	SET_BITS_TO_LE_4BYTE(c2h_pkt + 0X04, 8, 8, value)
+#define FWCMD_LOOPBACK_ACK_GET_H2C_BYTE_2(c2h_pkt)                             \
+	LE_BITS_TO_4BYTE(c2h_pkt + 0X04, 16, 8)
+#define FWCMD_LOOPBACK_ACK_SET_H2C_BYTE_2(c2h_pkt, value)                      \
+	SET_BITS_TO_LE_4BYTE(c2h_pkt + 0X04, 16, 8, value)
+#define FWCMD_LOOPBACK_ACK_GET_H2C_BYTE_3(c2h_pkt)                             \
+	LE_BITS_TO_4BYTE(c2h_pkt + 0X04, 24, 8)
+#define FWCMD_LOOPBACK_ACK_SET_H2C_BYTE_3(c2h_pkt, value)                      \
+	SET_BITS_TO_LE_4BYTE(c2h_pkt + 0X04, 24, 8, value)
+#define FWCMD_LOOPBACK_ACK_GET_H2C_BYTE_4(c2h_pkt)                             \
+	LE_BITS_TO_4BYTE(c2h_pkt + 0X8, 0, 8)
+#define FWCMD_LOOPBACK_ACK_SET_H2C_BYTE_4(c2h_pkt, value)                      \
+	SET_BITS_TO_LE_4BYTE(c2h_pkt + 0X8, 0, 8, value)
+#define FWCMD_LOOPBACK_ACK_GET_H2C_BYTE_5(c2h_pkt)                             \
+	LE_BITS_TO_4BYTE(c2h_pkt + 0X8, 8, 8)
+#define FWCMD_LOOPBACK_ACK_SET_H2C_BYTE_5(c2h_pkt, value)                      \
+	SET_BITS_TO_LE_4BYTE(c2h_pkt + 0X8, 8, 8, value)
+#define FWCMD_LOOPBACK_ACK_GET_H2C_BYTE_6(c2h_pkt)                             \
+	LE_BITS_TO_4BYTE(c2h_pkt + 0X8, 16, 8)
+#define FWCMD_LOOPBACK_ACK_SET_H2C_BYTE_6(c2h_pkt, value)                      \
+	SET_BITS_TO_LE_4BYTE(c2h_pkt + 0X8, 16, 8, value)
+#define FWCMD_LOOPBACK_ACK_GET_H2C_BYTE_7(c2h_pkt)                             \
+	LE_BITS_TO_4BYTE(c2h_pkt + 0X8, 24, 8)
+#define FWCMD_LOOPBACK_ACK_SET_H2C_BYTE_7(c2h_pkt, value)                      \
+	SET_BITS_TO_LE_4BYTE(c2h_pkt + 0X8, 24, 8, value)
+#endif
diff --git a/drivers/net/wireless/realtek/rtlwifi/halmac/halmac_fw_offload_h2c_nic.h b/drivers/net/wireless/realtek/rtlwifi/halmac/halmac_fw_offload_h2c_nic.h
new file mode 100644
index 000000000000..525be7e9d72f
--- /dev/null
+++ b/drivers/net/wireless/realtek/rtlwifi/halmac/halmac_fw_offload_h2c_nic.h
@@ -0,0 +1,694 @@
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
+#ifndef _HAL_FWOFFLOADH2CFORMAT_H2C_C2H_NIC_H_
+#define _HAL_FWOFFLOADH2CFORMAT_H2C_C2H_NIC_H_
+#define CMD_ID_FW_OFFLOAD_H2C 0XFF
+#define CMD_ID_CH_SWITCH 0XFF
+#define CMD_ID_DUMP_PHYSICAL_EFUSE 0XFF
+#define CMD_ID_UPDATE_BEACON_PARSING_INFO 0XFF
+#define CMD_ID_CFG_PARAM 0XFF
+#define CMD_ID_UPDATE_DATAPACK 0XFF
+#define CMD_ID_RUN_DATAPACK 0XFF
+#define CMD_ID_DOWNLOAD_FLASH 0XFF
+#define CMD_ID_UPDATE_PKT 0XFF
+#define CMD_ID_GENERAL_INFO 0XFF
+#define CMD_ID_IQK 0XFF
+#define CMD_ID_PWR_TRK 0XFF
+#define CMD_ID_PSD 0XFF
+#define CMD_ID_P2PPS 0XFF
+#define CMD_ID_BT_COEX 0XFF
+#define CMD_ID_NAN_CTRL 0XFF
+#define CMD_ID_NAN_CHANNEL_PLAN_0 0XFF
+#define CMD_ID_NAN_CHANNEL_PLAN_1 0XFF
+#define CMD_ID_FW_ACCESS_TEST 0XFF
+#define CMD_ID_PHYDM_INFO 0XFF
+#define CMD_ID_FW_SNDING 0XFF
+#define CMD_ID_H2C_LOOPBACK 0XFF
+#define CMD_ID_FWCMD_LOOPBACK 0XFF
+#define CMD_ID_FW_FWCTRL 0XFF
+#define CATEGORY_H2C_CMD_HEADER 0X00
+#define CATEGORY_FW_OFFLOAD_H2C 0X01
+#define CATEGORY_CH_SWITCH 0X01
+#define CATEGORY_DUMP_PHYSICAL_EFUSE 0X01
+#define CATEGORY_UPDATE_BEACON_PARSING_INFO 0X01
+#define CATEGORY_CFG_PARAM 0X01
+#define CATEGORY_UPDATE_DATAPACK 0X01
+#define CATEGORY_RUN_DATAPACK 0X01
+#define CATEGORY_DOWNLOAD_FLASH 0X01
+#define CATEGORY_UPDATE_PKT 0X01
+#define CATEGORY_GENERAL_INFO 0X01
+#define CATEGORY_IQK 0X01
+#define CATEGORY_PWR_TRK 0X01
+#define CATEGORY_PSD 0X01
+#define CATEGORY_P2PPS 0X01
+#define CATEGORY_BT_COEX 0X01
+#define CATEGORY_NAN_CTRL 0X01
+#define CATEGORY_NAN_CHANNEL_PLAN_0 0X01
+#define CATEGORY_NAN_CHANNEL_PLAN_1 0X01
+#define CATEGORY_FW_ACCESS_TEST 0X01
+#define CATEGORY_PHYDM_INFO 0X01
+#define CATEGORY_FW_SNDING 0X01
+#define CATEGORY_H2C_LOOPBACK 0X01
+#define CATEGORY_FWCMD_LOOPBACK 0X01
+#define CATEGORY_FW_FWCTRL 0X01
+#define SUB_CMD_ID_CH_SWITCH 0X02
+#define SUB_CMD_ID_DUMP_PHYSICAL_EFUSE 0X03
+#define SUB_CMD_ID_UPDATE_BEACON_PARSING_INFO 0X05
+#define SUB_CMD_ID_CFG_PARAM 0X08
+#define SUB_CMD_ID_UPDATE_DATAPACK 0X09
+#define SUB_CMD_ID_RUN_DATAPACK 0X0A
+#define SUB_CMD_ID_DOWNLOAD_FLASH 0X0B
+#define SUB_CMD_ID_UPDATE_PKT 0X0C
+#define SUB_CMD_ID_GENERAL_INFO 0X0D
+#define SUB_CMD_ID_IQK 0X0E
+#define SUB_CMD_ID_PWR_TRK 0X0F
+#define SUB_CMD_ID_PSD 0X10
+#define SUB_CMD_ID_P2PPS 0X24
+#define SUB_CMD_ID_BT_COEX 0X60
+#define SUB_CMD_ID_NAN_CTRL 0XB2
+#define SUB_CMD_ID_NAN_CHANNEL_PLAN_0 0XB4
+#define SUB_CMD_ID_NAN_CHANNEL_PLAN_1 0XB5
+#define SUB_CMD_ID_FW_ACCESS_TEST 0X00
+#define SUB_CMD_ID_PHYDM_INFO 0X11
+#define SUB_CMD_ID_FW_SNDING 0X12
+#define SUB_CMD_ID_FW_FWCTRL 0X13
+#define SUB_CMD_ID_H2C_LOOPBACK 0X14
+#define SUB_CMD_ID_FWCMD_LOOPBACK 0X15
+#define H2C_CMD_HEADER_GET_CATEGORY(h2c_pkt)                                   \
+	LE_BITS_TO_4BYTE(h2c_pkt + 0X00, 0, 7)
+#define H2C_CMD_HEADER_SET_CATEGORY(h2c_pkt, value)                            \
+	SET_BITS_TO_LE_4BYTE(h2c_pkt + 0X00, 0, 7, value)
+#define H2C_CMD_HEADER_GET_ACK(h2c_pkt) LE_BITS_TO_4BYTE(h2c_pkt + 0X00, 7, 1)
+#define H2C_CMD_HEADER_SET_ACK(h2c_pkt, value)                                 \
+	SET_BITS_TO_LE_4BYTE(h2c_pkt + 0X00, 7, 1, value)
+#define H2C_CMD_HEADER_GET_TOTAL_LEN(h2c_pkt)                                  \
+	LE_BITS_TO_4BYTE(h2c_pkt + 0X04, 0, 16)
+#define H2C_CMD_HEADER_SET_TOTAL_LEN(h2c_pkt, value)                           \
+	SET_BITS_TO_LE_4BYTE(h2c_pkt + 0X04, 0, 16, value)
+#define H2C_CMD_HEADER_GET_SEQ_NUM(h2c_pkt)                                    \
+	LE_BITS_TO_4BYTE(h2c_pkt + 0X04, 16, 16)
+#define H2C_CMD_HEADER_SET_SEQ_NUM(h2c_pkt, value)                             \
+	SET_BITS_TO_LE_4BYTE(h2c_pkt + 0X04, 16, 16, value)
+#define FW_OFFLOAD_H2C_GET_CATEGORY(h2c_pkt)                                   \
+	LE_BITS_TO_4BYTE(h2c_pkt + 0X00, 0, 7)
+#define FW_OFFLOAD_H2C_SET_CATEGORY(h2c_pkt, value)                            \
+	SET_BITS_TO_LE_4BYTE(h2c_pkt + 0X00, 0, 7, value)
+#define FW_OFFLOAD_H2C_GET_ACK(h2c_pkt) LE_BITS_TO_4BYTE(h2c_pkt + 0X00, 7, 1)
+#define FW_OFFLOAD_H2C_SET_ACK(h2c_pkt, value)                                 \
+	SET_BITS_TO_LE_4BYTE(h2c_pkt + 0X00, 7, 1, value)
+#define FW_OFFLOAD_H2C_GET_CMD_ID(h2c_pkt)                                     \
+	LE_BITS_TO_4BYTE(h2c_pkt + 0X00, 8, 8)
+#define FW_OFFLOAD_H2C_SET_CMD_ID(h2c_pkt, value)                              \
+	SET_BITS_TO_LE_4BYTE(h2c_pkt + 0X00, 8, 8, value)
+#define FW_OFFLOAD_H2C_GET_SUB_CMD_ID(h2c_pkt)                                 \
+	LE_BITS_TO_4BYTE(h2c_pkt + 0X00, 16, 16)
+#define FW_OFFLOAD_H2C_SET_SUB_CMD_ID(h2c_pkt, value)                          \
+	SET_BITS_TO_LE_4BYTE(h2c_pkt + 0X00, 16, 16, value)
+#define FW_OFFLOAD_H2C_GET_TOTAL_LEN(h2c_pkt)                                  \
+	LE_BITS_TO_4BYTE(h2c_pkt + 0X04, 0, 16)
+#define FW_OFFLOAD_H2C_SET_TOTAL_LEN(h2c_pkt, value)                           \
+	SET_BITS_TO_LE_4BYTE(h2c_pkt + 0X04, 0, 16, value)
+#define FW_OFFLOAD_H2C_GET_SEQ_NUM(h2c_pkt)                                    \
+	LE_BITS_TO_4BYTE(h2c_pkt + 0X04, 16, 16)
+#define FW_OFFLOAD_H2C_SET_SEQ_NUM(h2c_pkt, value)                             \
+	SET_BITS_TO_LE_4BYTE(h2c_pkt + 0X04, 16, 16, value)
+#define CH_SWITCH_GET_START(h2c_pkt) LE_BITS_TO_4BYTE(h2c_pkt + 0X08, 0, 1)
+#define CH_SWITCH_SET_START(h2c_pkt, value)                                    \
+	SET_BITS_TO_LE_4BYTE(h2c_pkt + 0X08, 0, 1, value)
+#define CH_SWITCH_GET_DEST_CH_EN(h2c_pkt) LE_BITS_TO_4BYTE(h2c_pkt + 0X08, 1, 1)
+#define CH_SWITCH_SET_DEST_CH_EN(h2c_pkt, value)                               \
+	SET_BITS_TO_LE_4BYTE(h2c_pkt + 0X08, 1, 1, value)
+#define CH_SWITCH_GET_ABSOLUTE_TIME(h2c_pkt)                                   \
+	LE_BITS_TO_4BYTE(h2c_pkt + 0X08, 2, 1)
+#define CH_SWITCH_SET_ABSOLUTE_TIME(h2c_pkt, value)                            \
+	SET_BITS_TO_LE_4BYTE(h2c_pkt + 0X08, 2, 1, value)
+#define CH_SWITCH_GET_PERIODIC_OPT(h2c_pkt)                                    \
+	LE_BITS_TO_4BYTE(h2c_pkt + 0X08, 3, 2)
+#define CH_SWITCH_SET_PERIODIC_OPT(h2c_pkt, value)                             \
+	SET_BITS_TO_LE_4BYTE(h2c_pkt + 0X08, 3, 2, value)
+#define CH_SWITCH_GET_INFO_LOC(h2c_pkt) LE_BITS_TO_4BYTE(h2c_pkt + 0X08, 8, 8)
+#define CH_SWITCH_SET_INFO_LOC(h2c_pkt, value)                                 \
+	SET_BITS_TO_LE_4BYTE(h2c_pkt + 0X08, 8, 8, value)
+#define CH_SWITCH_GET_CH_NUM(h2c_pkt) LE_BITS_TO_4BYTE(h2c_pkt + 0X08, 16, 8)
+#define CH_SWITCH_SET_CH_NUM(h2c_pkt, value)                                   \
+	SET_BITS_TO_LE_4BYTE(h2c_pkt + 0X08, 16, 8, value)
+#define CH_SWITCH_GET_PRI_CH_IDX(h2c_pkt)                                      \
+	LE_BITS_TO_4BYTE(h2c_pkt + 0X08, 24, 4)
+#define CH_SWITCH_SET_PRI_CH_IDX(h2c_pkt, value)                               \
+	SET_BITS_TO_LE_4BYTE(h2c_pkt + 0X08, 24, 4, value)
+#define CH_SWITCH_GET_DEST_BW(h2c_pkt) LE_BITS_TO_4BYTE(h2c_pkt + 0X08, 28, 4)
+#define CH_SWITCH_SET_DEST_BW(h2c_pkt, value)                                  \
+	SET_BITS_TO_LE_4BYTE(h2c_pkt + 0X08, 28, 4, value)
+#define CH_SWITCH_GET_DEST_CH(h2c_pkt) LE_BITS_TO_4BYTE(h2c_pkt + 0X0C, 0, 8)
+#define CH_SWITCH_SET_DEST_CH(h2c_pkt, value)                                  \
+	SET_BITS_TO_LE_4BYTE(h2c_pkt + 0X0C, 0, 8, value)
+#define CH_SWITCH_GET_NORMAL_PERIOD(h2c_pkt)                                   \
+	LE_BITS_TO_4BYTE(h2c_pkt + 0X0C, 8, 6)
+#define CH_SWITCH_SET_NORMAL_PERIOD(h2c_pkt, value)                            \
+	SET_BITS_TO_LE_4BYTE(h2c_pkt + 0X0C, 8, 6, value)
+#define CH_SWITCH_GET_NORMAL_PERIOD_SEL(h2c_pkt)                               \
+	LE_BITS_TO_4BYTE(h2c_pkt + 0X0C, 14, 2)
+#define CH_SWITCH_SET_NORMAL_PERIOD_SEL(h2c_pkt, value)                        \
+	SET_BITS_TO_LE_4BYTE(h2c_pkt + 0X0C, 14, 2, value)
+#define CH_SWITCH_GET_SLOW_PERIOD(h2c_pkt)                                     \
+	LE_BITS_TO_4BYTE(h2c_pkt + 0X0C, 16, 6)
+#define CH_SWITCH_SET_SLOW_PERIOD(h2c_pkt, value)                              \
+	SET_BITS_TO_LE_4BYTE(h2c_pkt + 0X0C, 16, 6, value)
+#define CH_SWITCH_GET_SLOW_PERIOD_SEL(h2c_pkt)                                 \
+	LE_BITS_TO_4BYTE(h2c_pkt + 0X0C, 22, 2)
+#define CH_SWITCH_SET_SLOW_PERIOD_SEL(h2c_pkt, value)                          \
+	SET_BITS_TO_LE_4BYTE(h2c_pkt + 0X0C, 22, 2, value)
+#define CH_SWITCH_GET_NORMAL_CYCLE(h2c_pkt)                                    \
+	LE_BITS_TO_4BYTE(h2c_pkt + 0X0C, 24, 8)
+#define CH_SWITCH_SET_NORMAL_CYCLE(h2c_pkt, value)                             \
+	SET_BITS_TO_LE_4BYTE(h2c_pkt + 0X0C, 24, 8, value)
+#define CH_SWITCH_GET_TSF_HIGH(h2c_pkt) LE_BITS_TO_4BYTE(h2c_pkt + 0X10, 0, 32)
+#define CH_SWITCH_SET_TSF_HIGH(h2c_pkt, value)                                 \
+	SET_BITS_TO_LE_4BYTE(h2c_pkt + 0X10, 0, 32, value)
+#define CH_SWITCH_GET_TSF_LOW(h2c_pkt) LE_BITS_TO_4BYTE(h2c_pkt + 0X14, 0, 32)
+#define CH_SWITCH_SET_TSF_LOW(h2c_pkt, value)                                  \
+	SET_BITS_TO_LE_4BYTE(h2c_pkt + 0X14, 0, 32, value)
+#define CH_SWITCH_GET_INFO_SIZE(h2c_pkt) LE_BITS_TO_4BYTE(h2c_pkt + 0X18, 0, 16)
+#define CH_SWITCH_SET_INFO_SIZE(h2c_pkt, value)                                \
+	SET_BITS_TO_LE_4BYTE(h2c_pkt + 0X18, 0, 16, value)
+#define UPDATE_BEACON_PARSING_INFO_GET_FUNC_EN(h2c_pkt)                        \
+	LE_BITS_TO_4BYTE(h2c_pkt + 0X08, 0, 1)
+#define UPDATE_BEACON_PARSING_INFO_SET_FUNC_EN(h2c_pkt, value)                 \
+	SET_BITS_TO_LE_4BYTE(h2c_pkt + 0X08, 0, 1, value)
+#define UPDATE_BEACON_PARSING_INFO_GET_SIZE_TH(h2c_pkt)                        \
+	LE_BITS_TO_4BYTE(h2c_pkt + 0X08, 8, 4)
+#define UPDATE_BEACON_PARSING_INFO_SET_SIZE_TH(h2c_pkt, value)                 \
+	SET_BITS_TO_LE_4BYTE(h2c_pkt + 0X08, 8, 4, value)
+#define UPDATE_BEACON_PARSING_INFO_GET_TIMEOUT(h2c_pkt)                        \
+	LE_BITS_TO_4BYTE(h2c_pkt + 0X08, 12, 4)
+#define UPDATE_BEACON_PARSING_INFO_SET_TIMEOUT(h2c_pkt, value)                 \
+	SET_BITS_TO_LE_4BYTE(h2c_pkt + 0X08, 12, 4, value)
+#define UPDATE_BEACON_PARSING_INFO_GET_IE_ID_BMP_0(h2c_pkt)                    \
+	LE_BITS_TO_4BYTE(h2c_pkt + 0X0C, 0, 32)
+#define UPDATE_BEACON_PARSING_INFO_SET_IE_ID_BMP_0(h2c_pkt, value)             \
+	SET_BITS_TO_LE_4BYTE(h2c_pkt + 0X0C, 0, 32, value)
+#define UPDATE_BEACON_PARSING_INFO_GET_IE_ID_BMP_1(h2c_pkt)                    \
+	LE_BITS_TO_4BYTE(h2c_pkt + 0X10, 0, 32)
+#define UPDATE_BEACON_PARSING_INFO_SET_IE_ID_BMP_1(h2c_pkt, value)             \
+	SET_BITS_TO_LE_4BYTE(h2c_pkt + 0X10, 0, 32, value)
+#define UPDATE_BEACON_PARSING_INFO_GET_IE_ID_BMP_2(h2c_pkt)                    \
+	LE_BITS_TO_4BYTE(h2c_pkt + 0X14, 0, 32)
+#define UPDATE_BEACON_PARSING_INFO_SET_IE_ID_BMP_2(h2c_pkt, value)             \
+	SET_BITS_TO_LE_4BYTE(h2c_pkt + 0X14, 0, 32, value)
+#define UPDATE_BEACON_PARSING_INFO_GET_IE_ID_BMP_3(h2c_pkt)                    \
+	LE_BITS_TO_4BYTE(h2c_pkt + 0X18, 0, 32)
+#define UPDATE_BEACON_PARSING_INFO_SET_IE_ID_BMP_3(h2c_pkt, value)             \
+	SET_BITS_TO_LE_4BYTE(h2c_pkt + 0X18, 0, 32, value)
+#define UPDATE_BEACON_PARSING_INFO_GET_IE_ID_BMP_4(h2c_pkt)                    \
+	LE_BITS_TO_4BYTE(h2c_pkt + 0X1C, 0, 32)
+#define UPDATE_BEACON_PARSING_INFO_SET_IE_ID_BMP_4(h2c_pkt, value)             \
+	SET_BITS_TO_LE_4BYTE(h2c_pkt + 0X1C, 0, 32, value)
+#define CFG_PARAM_GET_NUM(h2c_pkt) LE_BITS_TO_4BYTE(h2c_pkt + 0X08, 0, 16)
+#define CFG_PARAM_SET_NUM(h2c_pkt, value)                                      \
+	SET_BITS_TO_LE_4BYTE(h2c_pkt + 0X08, 0, 16, value)
+#define CFG_PARAM_GET_INIT_CASE(h2c_pkt) LE_BITS_TO_4BYTE(h2c_pkt + 0X08, 16, 1)
+#define CFG_PARAM_SET_INIT_CASE(h2c_pkt, value)                                \
+	SET_BITS_TO_LE_4BYTE(h2c_pkt + 0X08, 16, 1, value)
+#define CFG_PARAM_GET_LOC(h2c_pkt) LE_BITS_TO_4BYTE(h2c_pkt + 0X08, 24, 8)
+#define CFG_PARAM_SET_LOC(h2c_pkt, value)                                      \
+	SET_BITS_TO_LE_4BYTE(h2c_pkt + 0X08, 24, 8, value)
+#define UPDATE_DATAPACK_GET_SIZE(h2c_pkt)                                      \
+	LE_BITS_TO_4BYTE(h2c_pkt + 0X08, 0, 16)
+#define UPDATE_DATAPACK_SET_SIZE(h2c_pkt, value)                               \
+	SET_BITS_TO_LE_4BYTE(h2c_pkt + 0X08, 0, 16, value)
+#define UPDATE_DATAPACK_GET_DATAPACK_ID(h2c_pkt)                               \
+	LE_BITS_TO_4BYTE(h2c_pkt + 0X08, 16, 8)
+#define UPDATE_DATAPACK_SET_DATAPACK_ID(h2c_pkt, value)                        \
+	SET_BITS_TO_LE_4BYTE(h2c_pkt + 0X08, 16, 8, value)
+#define UPDATE_DATAPACK_GET_DATAPACK_LOC(h2c_pkt)                              \
+	LE_BITS_TO_4BYTE(h2c_pkt + 0X08, 24, 8)
+#define UPDATE_DATAPACK_SET_DATAPACK_LOC(h2c_pkt, value)                       \
+	SET_BITS_TO_LE_4BYTE(h2c_pkt + 0X08, 24, 8, value)
+#define UPDATE_DATAPACK_GET_DATAPACK_SEGMENT(h2c_pkt)                          \
+	LE_BITS_TO_4BYTE(h2c_pkt + 0X0C, 0, 8)
+#define UPDATE_DATAPACK_SET_DATAPACK_SEGMENT(h2c_pkt, value)                   \
+	SET_BITS_TO_LE_4BYTE(h2c_pkt + 0X0C, 0, 8, value)
+#define UPDATE_DATAPACK_GET_END_SEGMENT(h2c_pkt)                               \
+	LE_BITS_TO_4BYTE(h2c_pkt + 0X0C, 8, 1)
+#define UPDATE_DATAPACK_SET_END_SEGMENT(h2c_pkt, value)                        \
+	SET_BITS_TO_LE_4BYTE(h2c_pkt + 0X0C, 8, 1, value)
+#define RUN_DATAPACK_GET_DATAPACK_ID(h2c_pkt)                                  \
+	LE_BITS_TO_4BYTE(h2c_pkt + 0X08, 0, 8)
+#define RUN_DATAPACK_SET_DATAPACK_ID(h2c_pkt, value)                           \
+	SET_BITS_TO_LE_4BYTE(h2c_pkt + 0X08, 0, 8, value)
+#define DOWNLOAD_FLASH_GET_SPI_CMD(h2c_pkt)                                    \
+	LE_BITS_TO_4BYTE(h2c_pkt + 0X08, 0, 8)
+#define DOWNLOAD_FLASH_SET_SPI_CMD(h2c_pkt, value)                             \
+	SET_BITS_TO_LE_4BYTE(h2c_pkt + 0X08, 0, 8, value)
+#define DOWNLOAD_FLASH_GET_LOCATION(h2c_pkt)                                   \
+	LE_BITS_TO_4BYTE(h2c_pkt + 0X08, 8, 16)
+#define DOWNLOAD_FLASH_SET_LOCATION(h2c_pkt, value)                            \
+	SET_BITS_TO_LE_4BYTE(h2c_pkt + 0X08, 8, 16, value)
+#define DOWNLOAD_FLASH_GET_SIZE(h2c_pkt) LE_BITS_TO_4BYTE(h2c_pkt + 0X0C, 0, 32)
+#define DOWNLOAD_FLASH_SET_SIZE(h2c_pkt, value)                                \
+	SET_BITS_TO_LE_4BYTE(h2c_pkt + 0X0C, 0, 32, value)
+#define DOWNLOAD_FLASH_GET_START_ADDR(h2c_pkt)                                 \
+	LE_BITS_TO_4BYTE(h2c_pkt + 0X10, 0, 32)
+#define DOWNLOAD_FLASH_SET_START_ADDR(h2c_pkt, value)                          \
+	SET_BITS_TO_LE_4BYTE(h2c_pkt + 0X10, 0, 32, value)
+#define UPDATE_PKT_GET_SIZE(h2c_pkt) LE_BITS_TO_4BYTE(h2c_pkt + 0X08, 0, 16)
+#define UPDATE_PKT_SET_SIZE(h2c_pkt, value)                                    \
+	SET_BITS_TO_LE_4BYTE(h2c_pkt + 0X08, 0, 16, value)
+#define UPDATE_PKT_GET_ID(h2c_pkt) LE_BITS_TO_4BYTE(h2c_pkt + 0X08, 16, 8)
+#define UPDATE_PKT_SET_ID(h2c_pkt, value)                                      \
+	SET_BITS_TO_LE_4BYTE(h2c_pkt + 0X08, 16, 8, value)
+#define UPDATE_PKT_GET_LOC(h2c_pkt) LE_BITS_TO_4BYTE(h2c_pkt + 0X08, 24, 8)
+#define UPDATE_PKT_SET_LOC(h2c_pkt, value)                                     \
+	SET_BITS_TO_LE_4BYTE(h2c_pkt + 0X08, 24, 8, value)
+#define GENERAL_INFO_GET_FW_TX_BOUNDARY(h2c_pkt)                               \
+	LE_BITS_TO_4BYTE(h2c_pkt + 0X08, 16, 8)
+#define GENERAL_INFO_SET_FW_TX_BOUNDARY(h2c_pkt, value)                        \
+	SET_BITS_TO_LE_4BYTE(h2c_pkt + 0X08, 16, 8, value)
+#define IQK_GET_CLEAR(h2c_pkt) LE_BITS_TO_4BYTE(h2c_pkt + 0X08, 0, 1)
+#define IQK_SET_CLEAR(h2c_pkt, value)                                          \
+	SET_BITS_TO_LE_4BYTE(h2c_pkt + 0X08, 0, 1, value)
+#define IQK_GET_SEGMENT_IQK(h2c_pkt) LE_BITS_TO_4BYTE(h2c_pkt + 0X08, 1, 1)
+#define IQK_SET_SEGMENT_IQK(h2c_pkt, value)                                    \
+	SET_BITS_TO_LE_4BYTE(h2c_pkt + 0X08, 1, 1, value)
+#define PWR_TRK_GET_ENABLE_A(h2c_pkt) LE_BITS_TO_4BYTE(h2c_pkt + 0X08, 0, 1)
+#define PWR_TRK_SET_ENABLE_A(h2c_pkt, value)                                   \
+	SET_BITS_TO_LE_4BYTE(h2c_pkt + 0X08, 0, 1, value)
+#define PWR_TRK_GET_ENABLE_B(h2c_pkt) LE_BITS_TO_4BYTE(h2c_pkt + 0X08, 1, 1)
+#define PWR_TRK_SET_ENABLE_B(h2c_pkt, value)                                   \
+	SET_BITS_TO_LE_4BYTE(h2c_pkt + 0X08, 1, 1, value)
+#define PWR_TRK_GET_ENABLE_C(h2c_pkt) LE_BITS_TO_4BYTE(h2c_pkt + 0X08, 2, 1)
+#define PWR_TRK_SET_ENABLE_C(h2c_pkt, value)                                   \
+	SET_BITS_TO_LE_4BYTE(h2c_pkt + 0X08, 2, 1, value)
+#define PWR_TRK_GET_ENABLE_D(h2c_pkt) LE_BITS_TO_4BYTE(h2c_pkt + 0X08, 3, 1)
+#define PWR_TRK_SET_ENABLE_D(h2c_pkt, value)                                   \
+	SET_BITS_TO_LE_4BYTE(h2c_pkt + 0X08, 3, 1, value)
+#define PWR_TRK_GET_TYPE(h2c_pkt) LE_BITS_TO_4BYTE(h2c_pkt + 0X08, 4, 3)
+#define PWR_TRK_SET_TYPE(h2c_pkt, value)                                       \
+	SET_BITS_TO_LE_4BYTE(h2c_pkt + 0X08, 4, 3, value)
+#define PWR_TRK_GET_BBSWING_INDEX(h2c_pkt)                                     \
+	LE_BITS_TO_4BYTE(h2c_pkt + 0X08, 8, 8)
+#define PWR_TRK_SET_BBSWING_INDEX(h2c_pkt, value)                              \
+	SET_BITS_TO_LE_4BYTE(h2c_pkt + 0X08, 8, 8, value)
+#define PWR_TRK_GET_TX_PWR_INDEX_A(h2c_pkt)                                    \
+	LE_BITS_TO_4BYTE(h2c_pkt + 0X0C, 0, 8)
+#define PWR_TRK_SET_TX_PWR_INDEX_A(h2c_pkt, value)                             \
+	SET_BITS_TO_LE_4BYTE(h2c_pkt + 0X0C, 0, 8, value)
+#define PWR_TRK_GET_OFFSET_VALUE_A(h2c_pkt)                                    \
+	LE_BITS_TO_4BYTE(h2c_pkt + 0X0C, 8, 8)
+#define PWR_TRK_SET_OFFSET_VALUE_A(h2c_pkt, value)                             \
+	SET_BITS_TO_LE_4BYTE(h2c_pkt + 0X0C, 8, 8, value)
+#define PWR_TRK_GET_TSSI_VALUE_A(h2c_pkt)                                      \
+	LE_BITS_TO_4BYTE(h2c_pkt + 0X0C, 16, 8)
+#define PWR_TRK_SET_TSSI_VALUE_A(h2c_pkt, value)                               \
+	SET_BITS_TO_LE_4BYTE(h2c_pkt + 0X0C, 16, 8, value)
+#define PWR_TRK_GET_TX_PWR_INDEX_B(h2c_pkt)                                    \
+	LE_BITS_TO_4BYTE(h2c_pkt + 0X10, 0, 8)
+#define PWR_TRK_SET_TX_PWR_INDEX_B(h2c_pkt, value)                             \
+	SET_BITS_TO_LE_4BYTE(h2c_pkt + 0X10, 0, 8, value)
+#define PWR_TRK_GET_OFFSET_VALUE_B(h2c_pkt)                                    \
+	LE_BITS_TO_4BYTE(h2c_pkt + 0X10, 8, 8)
+#define PWR_TRK_SET_OFFSET_VALUE_B(h2c_pkt, value)                             \
+	SET_BITS_TO_LE_4BYTE(h2c_pkt + 0X10, 8, 8, value)
+#define PWR_TRK_GET_TSSI_VALUE_B(h2c_pkt)                                      \
+	LE_BITS_TO_4BYTE(h2c_pkt + 0X10, 16, 8)
+#define PWR_TRK_SET_TSSI_VALUE_B(h2c_pkt, value)                               \
+	SET_BITS_TO_LE_4BYTE(h2c_pkt + 0X10, 16, 8, value)
+#define PWR_TRK_GET_TX_PWR_INDEX_C(h2c_pkt)                                    \
+	LE_BITS_TO_4BYTE(h2c_pkt + 0X14, 0, 8)
+#define PWR_TRK_SET_TX_PWR_INDEX_C(h2c_pkt, value)                             \
+	SET_BITS_TO_LE_4BYTE(h2c_pkt + 0X14, 0, 8, value)
+#define PWR_TRK_GET_OFFSET_VALUE_C(h2c_pkt)                                    \
+	LE_BITS_TO_4BYTE(h2c_pkt + 0X14, 8, 8)
+#define PWR_TRK_SET_OFFSET_VALUE_C(h2c_pkt, value)                             \
+	SET_BITS_TO_LE_4BYTE(h2c_pkt + 0X14, 8, 8, value)
+#define PWR_TRK_GET_TSSI_VALUE_C(h2c_pkt)                                      \
+	LE_BITS_TO_4BYTE(h2c_pkt + 0X14, 16, 8)
+#define PWR_TRK_SET_TSSI_VALUE_C(h2c_pkt, value)                               \
+	SET_BITS_TO_LE_4BYTE(h2c_pkt + 0X14, 16, 8, value)
+#define PWR_TRK_GET_TX_PWR_INDEX_D(h2c_pkt)                                    \
+	LE_BITS_TO_4BYTE(h2c_pkt + 0X18, 0, 8)
+#define PWR_TRK_SET_TX_PWR_INDEX_D(h2c_pkt, value)                             \
+	SET_BITS_TO_LE_4BYTE(h2c_pkt + 0X18, 0, 8, value)
+#define PWR_TRK_GET_OFFSET_VALUE_D(h2c_pkt)                                    \
+	LE_BITS_TO_4BYTE(h2c_pkt + 0X18, 8, 8)
+#define PWR_TRK_SET_OFFSET_VALUE_D(h2c_pkt, value)                             \
+	SET_BITS_TO_LE_4BYTE(h2c_pkt + 0X18, 8, 8, value)
+#define PWR_TRK_GET_TSSI_VALUE_D(h2c_pkt)                                      \
+	LE_BITS_TO_4BYTE(h2c_pkt + 0X18, 16, 8)
+#define PWR_TRK_SET_TSSI_VALUE_D(h2c_pkt, value)                               \
+	SET_BITS_TO_LE_4BYTE(h2c_pkt + 0X18, 16, 8, value)
+#define PSD_GET_START_PSD(h2c_pkt) LE_BITS_TO_4BYTE(h2c_pkt + 0X08, 0, 16)
+#define PSD_SET_START_PSD(h2c_pkt, value)                                      \
+	SET_BITS_TO_LE_4BYTE(h2c_pkt + 0X08, 0, 16, value)
+#define PSD_GET_END_PSD(h2c_pkt) LE_BITS_TO_4BYTE(h2c_pkt + 0X08, 16, 16)
+#define PSD_SET_END_PSD(h2c_pkt, value)                                        \
+	SET_BITS_TO_LE_4BYTE(h2c_pkt + 0X08, 16, 16, value)
+#define P2PPS_GET_OFFLOAD_EN(h2c_pkt) LE_BITS_TO_4BYTE(h2c_pkt + 0X08, 0, 1)
+#define P2PPS_SET_OFFLOAD_EN(h2c_pkt, value)                                   \
+	SET_BITS_TO_LE_4BYTE(h2c_pkt + 0X08, 0, 1, value)
+#define P2PPS_GET_ROLE(h2c_pkt) LE_BITS_TO_4BYTE(h2c_pkt + 0X08, 1, 1)
+#define P2PPS_SET_ROLE(h2c_pkt, value)                                         \
+	SET_BITS_TO_LE_4BYTE(h2c_pkt + 0X08, 1, 1, value)
+#define P2PPS_GET_CTWINDOW_EN(h2c_pkt) LE_BITS_TO_4BYTE(h2c_pkt + 0X08, 2, 1)
+#define P2PPS_SET_CTWINDOW_EN(h2c_pkt, value)                                  \
+	SET_BITS_TO_LE_4BYTE(h2c_pkt + 0X08, 2, 1, value)
+#define P2PPS_GET_NOA_EN(h2c_pkt) LE_BITS_TO_4BYTE(h2c_pkt + 0X08, 3, 1)
+#define P2PPS_SET_NOA_EN(h2c_pkt, value)                                       \
+	SET_BITS_TO_LE_4BYTE(h2c_pkt + 0X08, 3, 1, value)
+#define P2PPS_GET_NOA_SEL(h2c_pkt) LE_BITS_TO_4BYTE(h2c_pkt + 0X08, 4, 1)
+#define P2PPS_SET_NOA_SEL(h2c_pkt, value)                                      \
+	SET_BITS_TO_LE_4BYTE(h2c_pkt + 0X08, 4, 1, value)
+#define P2PPS_GET_ALLSTASLEEP(h2c_pkt) LE_BITS_TO_4BYTE(h2c_pkt + 0X08, 5, 1)
+#define P2PPS_SET_ALLSTASLEEP(h2c_pkt, value)                                  \
+	SET_BITS_TO_LE_4BYTE(h2c_pkt + 0X08, 5, 1, value)
+#define P2PPS_GET_DISCOVERY(h2c_pkt) LE_BITS_TO_4BYTE(h2c_pkt + 0X08, 6, 1)
+#define P2PPS_SET_DISCOVERY(h2c_pkt, value)                                    \
+	SET_BITS_TO_LE_4BYTE(h2c_pkt + 0X08, 6, 1, value)
+#define P2PPS_GET_DISABLE_CLOSERF(h2c_pkt)                                     \
+	LE_BITS_TO_4BYTE(h2c_pkt + 0X08, 7, 1)
+#define P2PPS_SET_DISABLE_CLOSERF(h2c_pkt, value)                              \
+	SET_BITS_TO_LE_4BYTE(h2c_pkt + 0X08, 7, 1, value)
+#define P2PPS_GET_P2P_PORT_ID(h2c_pkt) LE_BITS_TO_4BYTE(h2c_pkt + 0X08, 8, 8)
+#define P2PPS_SET_P2P_PORT_ID(h2c_pkt, value)                                  \
+	SET_BITS_TO_LE_4BYTE(h2c_pkt + 0X08, 8, 8, value)
+#define P2PPS_GET_P2P_GROUP(h2c_pkt) LE_BITS_TO_4BYTE(h2c_pkt + 0X08, 16, 8)
+#define P2PPS_SET_P2P_GROUP(h2c_pkt, value)                                    \
+	SET_BITS_TO_LE_4BYTE(h2c_pkt + 0X08, 16, 8, value)
+#define P2PPS_GET_P2P_MACID(h2c_pkt) LE_BITS_TO_4BYTE(h2c_pkt + 0X08, 24, 8)
+#define P2PPS_SET_P2P_MACID(h2c_pkt, value)                                    \
+	SET_BITS_TO_LE_4BYTE(h2c_pkt + 0X08, 24, 8, value)
+#define P2PPS_GET_CTWINDOW_LENGTH(h2c_pkt)                                     \
+	LE_BITS_TO_4BYTE(h2c_pkt + 0X0C, 0, 8)
+#define P2PPS_SET_CTWINDOW_LENGTH(h2c_pkt, value)                              \
+	SET_BITS_TO_LE_4BYTE(h2c_pkt + 0X0C, 0, 8, value)
+#define P2PPS_GET_NOA_DURATION_PARA(h2c_pkt)                                   \
+	LE_BITS_TO_4BYTE(h2c_pkt + 0X10, 0, 32)
+#define P2PPS_SET_NOA_DURATION_PARA(h2c_pkt, value)                            \
+	SET_BITS_TO_LE_4BYTE(h2c_pkt + 0X10, 0, 32, value)
+#define P2PPS_GET_NOA_INTERVAL_PARA(h2c_pkt)                                   \
+	LE_BITS_TO_4BYTE(h2c_pkt + 0X14, 0, 32)
+#define P2PPS_SET_NOA_INTERVAL_PARA(h2c_pkt, value)                            \
+	SET_BITS_TO_LE_4BYTE(h2c_pkt + 0X14, 0, 32, value)
+#define P2PPS_GET_NOA_START_TIME_PARA(h2c_pkt)                                 \
+	LE_BITS_TO_4BYTE(h2c_pkt + 0X18, 0, 32)
+#define P2PPS_SET_NOA_START_TIME_PARA(h2c_pkt, value)                          \
+	SET_BITS_TO_LE_4BYTE(h2c_pkt + 0X18, 0, 32, value)
+#define P2PPS_GET_NOA_COUNT_PARA(h2c_pkt)                                      \
+	LE_BITS_TO_4BYTE(h2c_pkt + 0X1C, 0, 32)
+#define P2PPS_SET_NOA_COUNT_PARA(h2c_pkt, value)                               \
+	SET_BITS_TO_LE_4BYTE(h2c_pkt + 0X1C, 0, 32, value)
+#define BT_COEX_GET_DATA_START(h2c_pkt) LE_BITS_TO_4BYTE(h2c_pkt + 0X08, 0, 8)
+#define BT_COEX_SET_DATA_START(h2c_pkt, value)                                 \
+	SET_BITS_TO_LE_4BYTE(h2c_pkt + 0X08, 0, 8, value)
+#define NAN_CTRL_GET_NAN_EN(h2c_pkt) LE_BITS_TO_4BYTE(h2c_pkt + 0X08, 0, 2)
+#define NAN_CTRL_SET_NAN_EN(h2c_pkt, value)                                    \
+	SET_BITS_TO_LE_4BYTE(h2c_pkt + 0X08, 0, 2, value)
+#define NAN_CTRL_GET_WARMUP_TIMER_FLAG(h2c_pkt)                                \
+	LE_BITS_TO_4BYTE(h2c_pkt + 0X08, 2, 1)
+#define NAN_CTRL_SET_WARMUP_TIMER_FLAG(h2c_pkt, value)                         \
+	SET_BITS_TO_LE_4BYTE(h2c_pkt + 0X08, 2, 1, value)
+#define NAN_CTRL_GET_SUPPORT_BAND(h2c_pkt)                                     \
+	LE_BITS_TO_4BYTE(h2c_pkt + 0X08, 8, 2)
+#define NAN_CTRL_SET_SUPPORT_BAND(h2c_pkt, value)                              \
+	SET_BITS_TO_LE_4BYTE(h2c_pkt + 0X08, 8, 2, value)
+#define NAN_CTRL_GET_DISABLE_2G_DISC_BCN(h2c_pkt)                              \
+	LE_BITS_TO_4BYTE(h2c_pkt + 0X08, 10, 1)
+#define NAN_CTRL_SET_DISABLE_2G_DISC_BCN(h2c_pkt, value)                       \
+	SET_BITS_TO_LE_4BYTE(h2c_pkt + 0X08, 10, 1, value)
+#define NAN_CTRL_GET_DISABLE_5G_DISC_BCN(h2c_pkt)                              \
+	LE_BITS_TO_4BYTE(h2c_pkt + 0X08, 11, 1)
+#define NAN_CTRL_SET_DISABLE_5G_DISC_BCN(h2c_pkt, value)                       \
+	SET_BITS_TO_LE_4BYTE(h2c_pkt + 0X08, 11, 1, value)
+#define NAN_CTRL_GET_BCN_RSVD_PAGE_OFFSET(h2c_pkt)                             \
+	LE_BITS_TO_4BYTE(h2c_pkt + 0X08, 16, 8)
+#define NAN_CTRL_SET_BCN_RSVD_PAGE_OFFSET(h2c_pkt, value)                      \
+	SET_BITS_TO_LE_4BYTE(h2c_pkt + 0X08, 16, 8, value)
+#define NAN_CTRL_GET_CHANNEL_2G(h2c_pkt) LE_BITS_TO_4BYTE(h2c_pkt + 0X08, 24, 8)
+#define NAN_CTRL_SET_CHANNEL_2G(h2c_pkt, value)                                \
+	SET_BITS_TO_LE_4BYTE(h2c_pkt + 0X08, 24, 8, value)
+#define NAN_CTRL_GET_CHANNEL_5G(h2c_pkt) LE_BITS_TO_4BYTE(h2c_pkt + 0X0C, 0, 8)
+#define NAN_CTRL_SET_CHANNEL_5G(h2c_pkt, value)                                \
+	SET_BITS_TO_LE_4BYTE(h2c_pkt + 0X0C, 0, 8, value)
+#define NAN_CTRL_GET_MASTERPREFERENCE_VALUE(h2c_pkt)                           \
+	LE_BITS_TO_4BYTE(h2c_pkt + 0X0C, 8, 8)
+#define NAN_CTRL_SET_MASTERPREFERENCE_VALUE(h2c_pkt, value)                    \
+	SET_BITS_TO_LE_4BYTE(h2c_pkt + 0X0C, 8, 8, value)
+#define NAN_CTRL_GET_RANDOMFACTOR_VALUE(h2c_pkt)                               \
+	LE_BITS_TO_4BYTE(h2c_pkt + 0X0C, 16, 8)
+#define NAN_CTRL_SET_RANDOMFACTOR_VALUE(h2c_pkt, value)                        \
+	SET_BITS_TO_LE_4BYTE(h2c_pkt + 0X0C, 16, 8, value)
+#define NAN_CHANNEL_PLAN_0_GET_CHANNEL_NUMBER_0(h2c_pkt)                       \
+	LE_BITS_TO_4BYTE(h2c_pkt + 0X08, 0, 8)
+#define NAN_CHANNEL_PLAN_0_SET_CHANNEL_NUMBER_0(h2c_pkt, value)                \
+	SET_BITS_TO_LE_4BYTE(h2c_pkt + 0X08, 0, 8, value)
+#define NAN_CHANNEL_PLAN_0_GET_UNPAUSE_MACID_0(h2c_pkt)                        \
+	LE_BITS_TO_4BYTE(h2c_pkt + 0X08, 8, 8)
+#define NAN_CHANNEL_PLAN_0_SET_UNPAUSE_MACID_0(h2c_pkt, value)                 \
+	SET_BITS_TO_LE_4BYTE(h2c_pkt + 0X08, 8, 8, value)
+#define NAN_CHANNEL_PLAN_0_GET_START_TIME_SLOT_0(h2c_pkt)                      \
+	LE_BITS_TO_4BYTE(h2c_pkt + 0X0C, 0, 16)
+#define NAN_CHANNEL_PLAN_0_SET_START_TIME_SLOT_0(h2c_pkt, value)               \
+	SET_BITS_TO_LE_4BYTE(h2c_pkt + 0X0C, 0, 16, value)
+#define NAN_CHANNEL_PLAN_0_GET_DURATION_0(h2c_pkt)                             \
+	LE_BITS_TO_4BYTE(h2c_pkt + 0X0C, 16, 16)
+#define NAN_CHANNEL_PLAN_0_SET_DURATION_0(h2c_pkt, value)                      \
+	SET_BITS_TO_LE_4BYTE(h2c_pkt + 0X0C, 16, 16, value)
+#define NAN_CHANNEL_PLAN_0_GET_CHANNEL_NUMBER_1(h2c_pkt)                       \
+	LE_BITS_TO_4BYTE(h2c_pkt + 0X10, 0, 8)
+#define NAN_CHANNEL_PLAN_0_SET_CHANNEL_NUMBER_1(h2c_pkt, value)                \
+	SET_BITS_TO_LE_4BYTE(h2c_pkt + 0X10, 0, 8, value)
+#define NAN_CHANNEL_PLAN_0_GET_UNPAUSE_MACID_1(h2c_pkt)                        \
+	LE_BITS_TO_4BYTE(h2c_pkt + 0X10, 8, 8)
+#define NAN_CHANNEL_PLAN_0_SET_UNPAUSE_MACID_1(h2c_pkt, value)                 \
+	SET_BITS_TO_LE_4BYTE(h2c_pkt + 0X10, 8, 8, value)
+#define NAN_CHANNEL_PLAN_0_GET_START_TIME_SLOT_1(h2c_pkt)                      \
+	LE_BITS_TO_4BYTE(h2c_pkt + 0X14, 0, 16)
+#define NAN_CHANNEL_PLAN_0_SET_START_TIME_SLOT_1(h2c_pkt, value)               \
+	SET_BITS_TO_LE_4BYTE(h2c_pkt + 0X14, 0, 16, value)
+#define NAN_CHANNEL_PLAN_0_GET_DURATION_1(h2c_pkt)                             \
+	LE_BITS_TO_4BYTE(h2c_pkt + 0X14, 16, 16)
+#define NAN_CHANNEL_PLAN_0_SET_DURATION_1(h2c_pkt, value)                      \
+	SET_BITS_TO_LE_4BYTE(h2c_pkt + 0X14, 16, 16, value)
+#define NAN_CHANNEL_PLAN_0_GET_CHANNEL_NUMBER_2(h2c_pkt)                       \
+	LE_BITS_TO_4BYTE(h2c_pkt + 0X18, 0, 8)
+#define NAN_CHANNEL_PLAN_0_SET_CHANNEL_NUMBER_2(h2c_pkt, value)                \
+	SET_BITS_TO_LE_4BYTE(h2c_pkt + 0X18, 0, 8, value)
+#define NAN_CHANNEL_PLAN_0_GET_UNPAUSE_MACID_2(h2c_pkt)                        \
+	LE_BITS_TO_4BYTE(h2c_pkt + 0X18, 8, 8)
+#define NAN_CHANNEL_PLAN_0_SET_UNPAUSE_MACID_2(h2c_pkt, value)                 \
+	SET_BITS_TO_LE_4BYTE(h2c_pkt + 0X18, 8, 8, value)
+#define NAN_CHANNEL_PLAN_0_GET_START_TIME_SLOT_2(h2c_pkt)                      \
+	LE_BITS_TO_4BYTE(h2c_pkt + 0X1C, 0, 16)
+#define NAN_CHANNEL_PLAN_0_SET_START_TIME_SLOT_2(h2c_pkt, value)               \
+	SET_BITS_TO_LE_4BYTE(h2c_pkt + 0X1C, 0, 16, value)
+#define NAN_CHANNEL_PLAN_0_GET_DURATION_2(h2c_pkt)                             \
+	LE_BITS_TO_4BYTE(h2c_pkt + 0X1C, 16, 16)
+#define NAN_CHANNEL_PLAN_0_SET_DURATION_2(h2c_pkt, value)                      \
+	SET_BITS_TO_LE_4BYTE(h2c_pkt + 0X1C, 16, 16, value)
+#define NAN_CHANNEL_PLAN_1_GET_CHANNEL_NUMBER_3(h2c_pkt)                       \
+	LE_BITS_TO_4BYTE(h2c_pkt + 0X08, 0, 8)
+#define NAN_CHANNEL_PLAN_1_SET_CHANNEL_NUMBER_3(h2c_pkt, value)                \
+	SET_BITS_TO_LE_4BYTE(h2c_pkt + 0X08, 0, 8, value)
+#define NAN_CHANNEL_PLAN_1_GET_UNPAUSE_MACID_3(h2c_pkt)                        \
+	LE_BITS_TO_4BYTE(h2c_pkt + 0X08, 8, 8)
+#define NAN_CHANNEL_PLAN_1_SET_UNPAUSE_MACID_3(h2c_pkt, value)                 \
+	SET_BITS_TO_LE_4BYTE(h2c_pkt + 0X08, 8, 8, value)
+#define NAN_CHANNEL_PLAN_1_GET_START_TIME_SLOT_3(h2c_pkt)                      \
+	LE_BITS_TO_4BYTE(h2c_pkt + 0X0C, 0, 16)
+#define NAN_CHANNEL_PLAN_1_SET_START_TIME_SLOT_3(h2c_pkt, value)               \
+	SET_BITS_TO_LE_4BYTE(h2c_pkt + 0X0C, 0, 16, value)
+#define NAN_CHANNEL_PLAN_1_GET_DURATION_3(h2c_pkt)                             \
+	LE_BITS_TO_4BYTE(h2c_pkt + 0X0C, 16, 16)
+#define NAN_CHANNEL_PLAN_1_SET_DURATION_3(h2c_pkt, value)                      \
+	SET_BITS_TO_LE_4BYTE(h2c_pkt + 0X0C, 16, 16, value)
+#define NAN_CHANNEL_PLAN_1_GET_CHANNEL_NUMBER_4(h2c_pkt)                       \
+	LE_BITS_TO_4BYTE(h2c_pkt + 0X10, 0, 8)
+#define NAN_CHANNEL_PLAN_1_SET_CHANNEL_NUMBER_4(h2c_pkt, value)                \
+	SET_BITS_TO_LE_4BYTE(h2c_pkt + 0X10, 0, 8, value)
+#define NAN_CHANNEL_PLAN_1_GET_UNPAUSE_MACID_4(h2c_pkt)                        \
+	LE_BITS_TO_4BYTE(h2c_pkt + 0X10, 8, 8)
+#define NAN_CHANNEL_PLAN_1_SET_UNPAUSE_MACID_4(h2c_pkt, value)                 \
+	SET_BITS_TO_LE_4BYTE(h2c_pkt + 0X10, 8, 8, value)
+#define NAN_CHANNEL_PLAN_1_GET_START_TIME_SLOT_4(h2c_pkt)                      \
+	LE_BITS_TO_4BYTE(h2c_pkt + 0X14, 0, 16)
+#define NAN_CHANNEL_PLAN_1_SET_START_TIME_SLOT_4(h2c_pkt, value)               \
+	SET_BITS_TO_LE_4BYTE(h2c_pkt + 0X14, 0, 16, value)
+#define NAN_CHANNEL_PLAN_1_GET_DURATION_4(h2c_pkt)                             \
+	LE_BITS_TO_4BYTE(h2c_pkt + 0X14, 16, 16)
+#define NAN_CHANNEL_PLAN_1_SET_DURATION_4(h2c_pkt, value)                      \
+	SET_BITS_TO_LE_4BYTE(h2c_pkt + 0X14, 16, 16, value)
+#define NAN_CHANNEL_PLAN_1_GET_CHANNEL_NUMBER_5(h2c_pkt)                       \
+	LE_BITS_TO_4BYTE(h2c_pkt + 0X18, 0, 8)
+#define NAN_CHANNEL_PLAN_1_SET_CHANNEL_NUMBER_5(h2c_pkt, value)                \
+	SET_BITS_TO_LE_4BYTE(h2c_pkt + 0X18, 0, 8, value)
+#define NAN_CHANNEL_PLAN_1_GET_UNPAUSE_MACID_5(h2c_pkt)                        \
+	LE_BITS_TO_4BYTE(h2c_pkt + 0X18, 8, 8)
+#define NAN_CHANNEL_PLAN_1_SET_UNPAUSE_MACID_5(h2c_pkt, value)                 \
+	SET_BITS_TO_LE_4BYTE(h2c_pkt + 0X18, 8, 8, value)
+#define NAN_CHANNEL_PLAN_1_GET_START_TIME_SLOT_5(h2c_pkt)                      \
+	LE_BITS_TO_4BYTE(h2c_pkt + 0X1C, 0, 16)
+#define NAN_CHANNEL_PLAN_1_SET_START_TIME_SLOT_5(h2c_pkt, value)               \
+	SET_BITS_TO_LE_4BYTE(h2c_pkt + 0X1C, 0, 16, value)
+#define NAN_CHANNEL_PLAN_1_GET_DURATION_5(h2c_pkt)                             \
+	LE_BITS_TO_4BYTE(h2c_pkt + 0X1C, 16, 16)
+#define NAN_CHANNEL_PLAN_1_SET_DURATION_5(h2c_pkt, value)                      \
+	SET_BITS_TO_LE_4BYTE(h2c_pkt + 0X1C, 16, 16, value)
+#define FW_ACCESS_TEST_GET_ACCESS_TXFF(h2c_pkt)                                \
+	LE_BITS_TO_4BYTE(h2c_pkt + 0X08, 0, 1)
+#define FW_ACCESS_TEST_SET_ACCESS_TXFF(h2c_pkt, value)                         \
+	SET_BITS_TO_LE_4BYTE(h2c_pkt + 0X08, 0, 1, value)
+#define FW_ACCESS_TEST_GET_ACCESS_RXFF(h2c_pkt)                                \
+	LE_BITS_TO_4BYTE(h2c_pkt + 0X08, 1, 1)
+#define FW_ACCESS_TEST_SET_ACCESS_RXFF(h2c_pkt, value)                         \
+	SET_BITS_TO_LE_4BYTE(h2c_pkt + 0X08, 1, 1, value)
+#define FW_ACCESS_TEST_GET_ACCESS_FWFF(h2c_pkt)                                \
+	LE_BITS_TO_4BYTE(h2c_pkt + 0X08, 2, 1)
+#define FW_ACCESS_TEST_SET_ACCESS_FWFF(h2c_pkt, value)                         \
+	SET_BITS_TO_LE_4BYTE(h2c_pkt + 0X08, 2, 1, value)
+#define FW_ACCESS_TEST_GET_ACCESS_PHYFF(h2c_pkt)                               \
+	LE_BITS_TO_4BYTE(h2c_pkt + 0X08, 3, 1)
+#define FW_ACCESS_TEST_SET_ACCESS_PHYFF(h2c_pkt, value)                        \
+	SET_BITS_TO_LE_4BYTE(h2c_pkt + 0X08, 3, 1, value)
+#define FW_ACCESS_TEST_GET_ACCESS_RPT_BUF(h2c_pkt)                             \
+	LE_BITS_TO_4BYTE(h2c_pkt + 0X08, 4, 1)
+#define FW_ACCESS_TEST_SET_ACCESS_RPT_BUF(h2c_pkt, value)                      \
+	SET_BITS_TO_LE_4BYTE(h2c_pkt + 0X08, 4, 1, value)
+#define FW_ACCESS_TEST_GET_ACCESS_CAM(h2c_pkt)                                 \
+	LE_BITS_TO_4BYTE(h2c_pkt + 0X08, 5, 1)
+#define FW_ACCESS_TEST_SET_ACCESS_CAM(h2c_pkt, value)                          \
+	SET_BITS_TO_LE_4BYTE(h2c_pkt + 0X08, 5, 1, value)
+#define FW_ACCESS_TEST_GET_ACCESS_WOW_CAM(h2c_pkt)                             \
+	LE_BITS_TO_4BYTE(h2c_pkt + 0X08, 6, 1)
+#define FW_ACCESS_TEST_SET_ACCESS_WOW_CAM(h2c_pkt, value)                      \
+	SET_BITS_TO_LE_4BYTE(h2c_pkt + 0X08, 6, 1, value)
+#define FW_ACCESS_TEST_GET_ACCESS_RX_CAM(h2c_pkt)                              \
+	LE_BITS_TO_4BYTE(h2c_pkt + 0X08, 7, 1)
+#define FW_ACCESS_TEST_SET_ACCESS_RX_CAM(h2c_pkt, value)                       \
+	SET_BITS_TO_LE_4BYTE(h2c_pkt + 0X08, 7, 1, value)
+#define FW_ACCESS_TEST_GET_ACCESS_BA_CAM(h2c_pkt)                              \
+	LE_BITS_TO_4BYTE(h2c_pkt + 0X08, 8, 1)
+#define FW_ACCESS_TEST_SET_ACCESS_BA_CAM(h2c_pkt, value)                       \
+	SET_BITS_TO_LE_4BYTE(h2c_pkt + 0X08, 8, 1, value)
+#define FW_ACCESS_TEST_GET_ACCESS_MBSSID_CAM(h2c_pkt)                          \
+	LE_BITS_TO_4BYTE(h2c_pkt + 0X08, 9, 1)
+#define FW_ACCESS_TEST_SET_ACCESS_MBSSID_CAM(h2c_pkt, value)                   \
+	SET_BITS_TO_LE_4BYTE(h2c_pkt + 0X08, 9, 1, value)
+#define FW_ACCESS_TEST_GET_ACCESS_PAGE0(h2c_pkt)                               \
+	LE_BITS_TO_4BYTE(h2c_pkt + 0X08, 16, 1)
+#define FW_ACCESS_TEST_SET_ACCESS_PAGE0(h2c_pkt, value)                        \
+	SET_BITS_TO_LE_4BYTE(h2c_pkt + 0X08, 16, 1, value)
+#define FW_ACCESS_TEST_GET_ACCESS_PAGE1(h2c_pkt)                               \
+	LE_BITS_TO_4BYTE(h2c_pkt + 0X08, 17, 1)
+#define FW_ACCESS_TEST_SET_ACCESS_PAGE1(h2c_pkt, value)                        \
+	SET_BITS_TO_LE_4BYTE(h2c_pkt + 0X08, 17, 1, value)
+#define FW_ACCESS_TEST_GET_ACCESS_PAGE2(h2c_pkt)                               \
+	LE_BITS_TO_4BYTE(h2c_pkt + 0X08, 18, 1)
+#define FW_ACCESS_TEST_SET_ACCESS_PAGE2(h2c_pkt, value)                        \
+	SET_BITS_TO_LE_4BYTE(h2c_pkt + 0X08, 18, 1, value)
+#define FW_ACCESS_TEST_GET_ACCESS_PAGE3(h2c_pkt)                               \
+	LE_BITS_TO_4BYTE(h2c_pkt + 0X08, 19, 1)
+#define FW_ACCESS_TEST_SET_ACCESS_PAGE3(h2c_pkt, value)                        \
+	SET_BITS_TO_LE_4BYTE(h2c_pkt + 0X08, 19, 1, value)
+#define FW_ACCESS_TEST_GET_ACCESS_PAGE4(h2c_pkt)                               \
+	LE_BITS_TO_4BYTE(h2c_pkt + 0X08, 20, 1)
+#define FW_ACCESS_TEST_SET_ACCESS_PAGE4(h2c_pkt, value)                        \
+	SET_BITS_TO_LE_4BYTE(h2c_pkt + 0X08, 20, 1, value)
+#define FW_ACCESS_TEST_GET_ACCESS_PAGE5(h2c_pkt)                               \
+	LE_BITS_TO_4BYTE(h2c_pkt + 0X08, 21, 1)
+#define FW_ACCESS_TEST_SET_ACCESS_PAGE5(h2c_pkt, value)                        \
+	SET_BITS_TO_LE_4BYTE(h2c_pkt + 0X08, 21, 1, value)
+#define FW_ACCESS_TEST_GET_ACCESS_PAGE6(h2c_pkt)                               \
+	LE_BITS_TO_4BYTE(h2c_pkt + 0X08, 22, 1)
+#define FW_ACCESS_TEST_SET_ACCESS_PAGE6(h2c_pkt, value)                        \
+	SET_BITS_TO_LE_4BYTE(h2c_pkt + 0X08, 22, 1, value)
+#define FW_ACCESS_TEST_GET_ACCESS_PAGE7(h2c_pkt)                               \
+	LE_BITS_TO_4BYTE(h2c_pkt + 0X08, 23, 1)
+#define FW_ACCESS_TEST_SET_ACCESS_PAGE7(h2c_pkt, value)                        \
+	SET_BITS_TO_LE_4BYTE(h2c_pkt + 0X08, 23, 1, value)
+#define PHYDM_INFO_GET_REF_TYPE(h2c_pkt) LE_BITS_TO_4BYTE(h2c_pkt + 0X08, 0, 8)
+#define PHYDM_INFO_SET_REF_TYPE(h2c_pkt, value)                                \
+	SET_BITS_TO_LE_4BYTE(h2c_pkt + 0X08, 0, 8, value)
+#define PHYDM_INFO_GET_RF_TYPE(h2c_pkt) LE_BITS_TO_4BYTE(h2c_pkt + 0X08, 8, 8)
+#define PHYDM_INFO_SET_RF_TYPE(h2c_pkt, value)                                 \
+	SET_BITS_TO_LE_4BYTE(h2c_pkt + 0X08, 8, 8, value)
+#define PHYDM_INFO_GET_CUT_VER(h2c_pkt) LE_BITS_TO_4BYTE(h2c_pkt + 0X08, 16, 8)
+#define PHYDM_INFO_SET_CUT_VER(h2c_pkt, value)                                 \
+	SET_BITS_TO_LE_4BYTE(h2c_pkt + 0X08, 16, 8, value)
+#define PHYDM_INFO_GET_RX_ANT_STATUS(h2c_pkt)                                  \
+	LE_BITS_TO_4BYTE(h2c_pkt + 0X08, 24, 4)
+#define PHYDM_INFO_SET_RX_ANT_STATUS(h2c_pkt, value)                           \
+	SET_BITS_TO_LE_4BYTE(h2c_pkt + 0X08, 24, 4, value)
+#define PHYDM_INFO_GET_TX_ANT_STATUS(h2c_pkt)                                  \
+	LE_BITS_TO_4BYTE(h2c_pkt + 0X08, 28, 4)
+#define PHYDM_INFO_SET_TX_ANT_STATUS(h2c_pkt, value)                           \
+	SET_BITS_TO_LE_4BYTE(h2c_pkt + 0X08, 28, 4, value)
+#define FW_SNDING_GET_SU0(h2c_pkt) LE_BITS_TO_4BYTE(h2c_pkt + 0X08, 0, 1)
+#define FW_SNDING_SET_SU0(h2c_pkt, value)                                      \
+	SET_BITS_TO_LE_4BYTE(h2c_pkt + 0X08, 0, 1, value)
+#define FW_SNDING_GET_SU1(h2c_pkt) LE_BITS_TO_4BYTE(h2c_pkt + 0X08, 1, 1)
+#define FW_SNDING_SET_SU1(h2c_pkt, value)                                      \
+	SET_BITS_TO_LE_4BYTE(h2c_pkt + 0X08, 1, 1, value)
+#define FW_SNDING_GET_MU(h2c_pkt) LE_BITS_TO_4BYTE(h2c_pkt + 0X08, 2, 1)
+#define FW_SNDING_SET_MU(h2c_pkt, value)                                       \
+	SET_BITS_TO_LE_4BYTE(h2c_pkt + 0X08, 2, 1, value)
+#define FW_SNDING_GET_PERIOD(h2c_pkt) LE_BITS_TO_4BYTE(h2c_pkt + 0X08, 8, 8)
+#define FW_SNDING_SET_PERIOD(h2c_pkt, value)                                   \
+	SET_BITS_TO_LE_4BYTE(h2c_pkt + 0X08, 8, 8, value)
+#define FW_SNDING_GET_NDPA0_HEAD_PG(h2c_pkt)                                   \
+	LE_BITS_TO_4BYTE(h2c_pkt + 0X08, 16, 8)
+#define FW_SNDING_SET_NDPA0_HEAD_PG(h2c_pkt, value)                            \
+	SET_BITS_TO_LE_4BYTE(h2c_pkt + 0X08, 16, 8, value)
+#define FW_SNDING_GET_NDPA1_HEAD_PG(h2c_pkt)                                   \
+	LE_BITS_TO_4BYTE(h2c_pkt + 0X08, 24, 8)
+#define FW_SNDING_SET_NDPA1_HEAD_PG(h2c_pkt, value)                            \
+	SET_BITS_TO_LE_4BYTE(h2c_pkt + 0X08, 24, 8, value)
+#define FW_SNDING_GET_MU_NDPA_HEAD_PG(h2c_pkt)                                 \
+	LE_BITS_TO_4BYTE(h2c_pkt + 0XC, 0, 8)
+#define FW_SNDING_SET_MU_NDPA_HEAD_PG(h2c_pkt, value)                          \
+	SET_BITS_TO_LE_4BYTE(h2c_pkt + 0XC, 0, 8, value)
+#define FW_SNDING_GET_RPT0_HEAD_PG(h2c_pkt)                                    \
+	LE_BITS_TO_4BYTE(h2c_pkt + 0XC, 8, 8)
+#define FW_SNDING_SET_RPT0_HEAD_PG(h2c_pkt, value)                             \
+	SET_BITS_TO_LE_4BYTE(h2c_pkt + 0XC, 8, 8, value)
+#define FW_SNDING_GET_RPT1_HEAD_PG(h2c_pkt)                                    \
+	LE_BITS_TO_4BYTE(h2c_pkt + 0XC, 16, 8)
+#define FW_SNDING_SET_RPT1_HEAD_PG(h2c_pkt, value)                             \
+	SET_BITS_TO_LE_4BYTE(h2c_pkt + 0XC, 16, 8, value)
+#define FW_SNDING_GET_RPT2_HEAD_PG(h2c_pkt)                                    \
+	LE_BITS_TO_4BYTE(h2c_pkt + 0XC, 24, 8)
+#define FW_SNDING_SET_RPT2_HEAD_PG(h2c_pkt, value)                             \
+	SET_BITS_TO_LE_4BYTE(h2c_pkt + 0XC, 24, 8, value)
+#define FW_FWCTRL_GET_SEQ_NUM(h2c_pkt) LE_BITS_TO_4BYTE(h2c_pkt + 0X08, 0, 8)
+#define FW_FWCTRL_SET_SEQ_NUM(h2c_pkt, value)                                  \
+	SET_BITS_TO_LE_4BYTE(h2c_pkt + 0X08, 0, 8, value)
+#define FW_FWCTRL_GET_MORE_CONTENT(h2c_pkt)                                    \
+	LE_BITS_TO_4BYTE(h2c_pkt + 0X08, 8, 1)
+#define FW_FWCTRL_SET_MORE_CONTENT(h2c_pkt, value)                             \
+	SET_BITS_TO_LE_4BYTE(h2c_pkt + 0X08, 8, 1, value)
+#define FW_FWCTRL_GET_CONTENT_IDX(h2c_pkt)                                     \
+	LE_BITS_TO_4BYTE(h2c_pkt + 0X08, 9, 7)
+#define FW_FWCTRL_SET_CONTENT_IDX(h2c_pkt, value)                              \
+	SET_BITS_TO_LE_4BYTE(h2c_pkt + 0X08, 9, 7, value)
+#define FW_FWCTRL_GET_CLASS_ID(h2c_pkt) LE_BITS_TO_4BYTE(h2c_pkt + 0X08, 16, 8)
+#define FW_FWCTRL_SET_CLASS_ID(h2c_pkt, value)                                 \
+	SET_BITS_TO_LE_4BYTE(h2c_pkt + 0X08, 16, 8, value)
+#define FW_FWCTRL_GET_LENGTH(h2c_pkt) LE_BITS_TO_4BYTE(h2c_pkt + 0X08, 24, 8)
+#define FW_FWCTRL_SET_LENGTH(h2c_pkt, value)                                   \
+	SET_BITS_TO_LE_4BYTE(h2c_pkt + 0X08, 24, 8, value)
+#define FW_FWCTRL_GET_CONTENT(h2c_pkt) LE_BITS_TO_4BYTE(h2c_pkt + 0X0C, 0, 32)
+#define FW_FWCTRL_SET_CONTENT(h2c_pkt, value)                                  \
+	SET_BITS_TO_LE_4BYTE(h2c_pkt + 0X0C, 0, 32, value)
+#endif
diff --git a/drivers/net/wireless/realtek/rtlwifi/halmac/halmac_h2c_extra_info_nic.h b/drivers/net/wireless/realtek/rtlwifi/halmac/halmac_h2c_extra_info_nic.h
new file mode 100644
index 000000000000..d48a683485ea
--- /dev/null
+++ b/drivers/net/wireless/realtek/rtlwifi/halmac/halmac_h2c_extra_info_nic.h
@@ -0,0 +1,171 @@
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
+#ifndef _HAL_H2CEXTRAINFO_H2C_C2H_NIC_H_
+#define _HAL_H2CEXTRAINFO_H2C_C2H_NIC_H_
+
+/* H2C extra info (rsvd page) usage, unit : page (128byte)*/
+/* dlfw : not include txdesc size*/
+/* update pkt : not include txdesc size*/
+/* cfg param : not include txdesc size*/
+/* scan info : not include txdesc size*/
+/* dl flash : not include txdesc size*/
+#define DLFW_RSVDPG_SIZE 2048
+#define UPDATE_PKT_RSVDPG_SIZE 2048
+#define CFG_PARAM_RSVDPG_SIZE 2048
+#define SCAN_INFO_RSVDPG_SIZE 256
+#define DL_FLASH_RSVDPG_SIZE 2048
+/* su0 snding pkt : include txdesc size */
+#define SU0_SNDING_PKT_OFFSET 0
+#define SU0_SNDING_PKT_RSVDPG_SIZE 128
+
+#define PARAM_INFO_GET_LEN(extra_info) LE_BITS_TO_4BYTE(extra_info + 0X00, 0, 8)
+#define PARAM_INFO_SET_LEN(extra_info, value)                                  \
+	SET_BITS_TO_LE_4BYTE(extra_info + 0X00, 0, 8, value)
+#define PARAM_INFO_GET_IO_CMD(extra_info)                                      \
+	LE_BITS_TO_4BYTE(extra_info + 0X00, 8, 7)
+#define PARAM_INFO_SET_IO_CMD(extra_info, value)                               \
+	SET_BITS_TO_LE_4BYTE(extra_info + 0X00, 8, 7, value)
+#define PARAM_INFO_GET_MSK_EN(extra_info)                                      \
+	LE_BITS_TO_4BYTE(extra_info + 0X00, 15, 1)
+#define PARAM_INFO_SET_MSK_EN(extra_info, value)                               \
+	SET_BITS_TO_LE_4BYTE(extra_info + 0X00, 15, 1, value)
+#define PARAM_INFO_GET_LLT_PG_BNDY(extra_info)                                 \
+	LE_BITS_TO_4BYTE(extra_info + 0X00, 16, 8)
+#define PARAM_INFO_SET_LLT_PG_BNDY(extra_info, value)                          \
+	SET_BITS_TO_LE_4BYTE(extra_info + 0X00, 16, 8, value)
+#define PARAM_INFO_GET_EFUSE_RSVDPAGE_LOC(extra_info)                          \
+	LE_BITS_TO_4BYTE(extra_info + 0X00, 16, 8)
+#define PARAM_INFO_SET_EFUSE_RSVDPAGE_LOC(extra_info, value)                   \
+	SET_BITS_TO_LE_4BYTE(extra_info + 0X00, 16, 8, value)
+#define PARAM_INFO_GET_EFUSE_PATCH_EN(extra_info)                              \
+	LE_BITS_TO_4BYTE(extra_info + 0X00, 16, 8)
+#define PARAM_INFO_SET_EFUSE_PATCH_EN(extra_info, value)                       \
+	SET_BITS_TO_LE_4BYTE(extra_info + 0X00, 16, 8, value)
+#define PARAM_INFO_GET_RF_ADDR(extra_info)                                     \
+	LE_BITS_TO_4BYTE(extra_info + 0X00, 16, 8)
+#define PARAM_INFO_SET_RF_ADDR(extra_info, value)                              \
+	SET_BITS_TO_LE_4BYTE(extra_info + 0X00, 16, 8, value)
+#define PARAM_INFO_GET_IO_ADDR(extra_info)                                     \
+	LE_BITS_TO_4BYTE(extra_info + 0X00, 16, 16)
+#define PARAM_INFO_SET_IO_ADDR(extra_info, value)                              \
+	SET_BITS_TO_LE_4BYTE(extra_info + 0X00, 16, 16, value)
+#define PARAM_INFO_GET_DELAY_VAL(extra_info)                                   \
+	LE_BITS_TO_4BYTE(extra_info + 0X00, 16, 16)
+#define PARAM_INFO_SET_DELAY_VAL(extra_info, value)                            \
+	SET_BITS_TO_LE_4BYTE(extra_info + 0X00, 16, 16, value)
+#define PARAM_INFO_GET_RF_PATH(extra_info)                                     \
+	LE_BITS_TO_4BYTE(extra_info + 0X00, 24, 8)
+#define PARAM_INFO_SET_RF_PATH(extra_info, value)                              \
+	SET_BITS_TO_LE_4BYTE(extra_info + 0X00, 24, 8, value)
+#define PARAM_INFO_GET_DATA(extra_info)                                        \
+	LE_BITS_TO_4BYTE(extra_info + 0X04, 0, 32)
+#define PARAM_INFO_SET_DATA(extra_info, value)                                 \
+	SET_BITS_TO_LE_4BYTE(extra_info + 0X04, 0, 32, value)
+#define PARAM_INFO_GET_MASK(extra_info)                                        \
+	LE_BITS_TO_4BYTE(extra_info + 0X08, 0, 32)
+#define PARAM_INFO_SET_MASK(extra_info, value)                                 \
+	SET_BITS_TO_LE_4BYTE(extra_info + 0X08, 0, 32, value)
+#define CH_INFO_GET_CH(extra_info) LE_BITS_TO_4BYTE(extra_info + 0X00, 0, 8)
+#define CH_INFO_SET_CH(extra_info, value)                                      \
+	SET_BITS_TO_LE_4BYTE(extra_info + 0X00, 0, 8, value)
+#define CH_INFO_GET_PRI_CH_IDX(extra_info)                                     \
+	LE_BITS_TO_4BYTE(extra_info + 0X00, 8, 4)
+#define CH_INFO_SET_PRI_CH_IDX(extra_info, value)                              \
+	SET_BITS_TO_LE_4BYTE(extra_info + 0X00, 8, 4, value)
+#define CH_INFO_GET_BW(extra_info) LE_BITS_TO_4BYTE(extra_info + 0X00, 12, 4)
+#define CH_INFO_SET_BW(extra_info, value)                                      \
+	SET_BITS_TO_LE_4BYTE(extra_info + 0X00, 12, 4, value)
+#define CH_INFO_GET_TIMEOUT(extra_info)                                        \
+	LE_BITS_TO_4BYTE(extra_info + 0X00, 16, 8)
+#define CH_INFO_SET_TIMEOUT(extra_info, value)                                 \
+	SET_BITS_TO_LE_4BYTE(extra_info + 0X00, 16, 8, value)
+#define CH_INFO_GET_ACTION_ID(extra_info)                                      \
+	LE_BITS_TO_4BYTE(extra_info + 0X00, 24, 7)
+#define CH_INFO_SET_ACTION_ID(extra_info, value)                               \
+	SET_BITS_TO_LE_4BYTE(extra_info + 0X00, 24, 7, value)
+#define CH_INFO_GET_EXTRA_INFO(extra_info)                                     \
+	LE_BITS_TO_4BYTE(extra_info + 0X00, 31, 1)
+#define CH_INFO_SET_EXTRA_INFO(extra_info, value)                              \
+	SET_BITS_TO_LE_4BYTE(extra_info + 0X00, 31, 1, value)
+#define CH_EXTRA_INFO_GET_ID(extra_info)                                       \
+	LE_BITS_TO_4BYTE(extra_info + 0X00, 0, 7)
+#define CH_EXTRA_INFO_SET_ID(extra_info, value)                                \
+	SET_BITS_TO_LE_4BYTE(extra_info + 0X00, 0, 7, value)
+#define CH_EXTRA_INFO_GET_INFO(extra_info)                                     \
+	LE_BITS_TO_4BYTE(extra_info + 0X00, 7, 1)
+#define CH_EXTRA_INFO_SET_INFO(extra_info, value)                              \
+	SET_BITS_TO_LE_4BYTE(extra_info + 0X00, 7, 1, value)
+#define CH_EXTRA_INFO_GET_SIZE(extra_info)                                     \
+	LE_BITS_TO_4BYTE(extra_info + 0X00, 8, 8)
+#define CH_EXTRA_INFO_SET_SIZE(extra_info, value)                              \
+	SET_BITS_TO_LE_4BYTE(extra_info + 0X00, 8, 8, value)
+#define CH_EXTRA_INFO_GET_DATA(extra_info)                                     \
+	LE_BITS_TO_4BYTE(extra_info + 0X00, 16, 1)
+#define CH_EXTRA_INFO_SET_DATA(extra_info, value)                              \
+	SET_BITS_TO_LE_4BYTE(extra_info + 0X00, 16, 1, value)
+#define HIOE_INSTRUCTION_INFO_GET_BYTEDATA_L(extra_info)                       \
+	LE_BITS_TO_4BYTE(extra_info + 0X00, 0, 16)
+#define HIOE_INSTRUCTION_INFO_SET_BYTEDATA_L(extra_info, value)                \
+	SET_BITS_TO_LE_4BYTE(extra_info + 0X00, 0, 16, value)
+#define HIOE_INSTRUCTION_INFO_GET_BITDATA(extra_info)                          \
+	LE_BITS_TO_4BYTE(extra_info + 0X00, 0, 16)
+#define HIOE_INSTRUCTION_INFO_SET_BITDATA(extra_info, value)                   \
+	SET_BITS_TO_LE_4BYTE(extra_info + 0X00, 0, 16, value)
+#define HIOE_INSTRUCTION_INFO_GET_BYTEDATA_H(extra_info)                       \
+	LE_BITS_TO_4BYTE(extra_info + 0X00, 16, 16)
+#define HIOE_INSTRUCTION_INFO_SET_BYTEDATA_H(extra_info, value)                \
+	SET_BITS_TO_LE_4BYTE(extra_info + 0X00, 16, 16, value)
+#define HIOE_INSTRUCTION_INFO_GET_BITMASK(extra_info)                          \
+	LE_BITS_TO_4BYTE(extra_info + 0X00, 16, 16)
+#define HIOE_INSTRUCTION_INFO_SET_BITMASK(extra_info, value)                   \
+	SET_BITS_TO_LE_4BYTE(extra_info + 0X00, 16, 16, value)
+#define HIOE_INSTRUCTION_INFO_GET_REG_ADDR(extra_info)                         \
+	LE_BITS_TO_4BYTE(extra_info + 0X04, 0, 22)
+#define HIOE_INSTRUCTION_INFO_SET_REG_ADDR(extra_info, value)                  \
+	SET_BITS_TO_LE_4BYTE(extra_info + 0X04, 0, 22, value)
+#define HIOE_INSTRUCTION_INFO_GET_DELAY_VALUE(extra_info)                      \
+	LE_BITS_TO_4BYTE(extra_info + 0X04, 0, 22)
+#define HIOE_INSTRUCTION_INFO_SET_DELAY_VALUE(extra_info, value)               \
+	SET_BITS_TO_LE_4BYTE(extra_info + 0X04, 0, 22, value)
+#define HIOE_INSTRUCTION_INFO_GET_MODE_SELECT(extra_info)                      \
+	LE_BITS_TO_4BYTE(extra_info + 0X04, 22, 1)
+#define HIOE_INSTRUCTION_INFO_SET_MODE_SELECT(extra_info, value)               \
+	SET_BITS_TO_LE_4BYTE(extra_info + 0X04, 22, 1, value)
+#define HIOE_INSTRUCTION_INFO_GET_IO_DELAY(extra_info)                         \
+	LE_BITS_TO_4BYTE(extra_info + 0X04, 23, 1)
+#define HIOE_INSTRUCTION_INFO_SET_IO_DELAY(extra_info, value)                  \
+	SET_BITS_TO_LE_4BYTE(extra_info + 0X04, 23, 1, value)
+#define HIOE_INSTRUCTION_INFO_GET_BYTEMASK(extra_info)                         \
+	LE_BITS_TO_4BYTE(extra_info + 0X04, 24, 4)
+#define HIOE_INSTRUCTION_INFO_SET_BYTEMASK(extra_info, value)                  \
+	SET_BITS_TO_LE_4BYTE(extra_info + 0X04, 24, 4, value)
+#define HIOE_INSTRUCTION_INFO_GET_RD_EN(extra_info)                            \
+	LE_BITS_TO_4BYTE(extra_info + 0X04, 28, 1)
+#define HIOE_INSTRUCTION_INFO_SET_RD_EN(extra_info, value)                     \
+	SET_BITS_TO_LE_4BYTE(extra_info + 0X04, 28, 1, value)
+#define HIOE_INSTRUCTION_INFO_GET_WR_EN(extra_info)                            \
+	LE_BITS_TO_4BYTE(extra_info + 0X04, 29, 1)
+#define HIOE_INSTRUCTION_INFO_SET_WR_EN(extra_info, value)                     \
+	SET_BITS_TO_LE_4BYTE(extra_info + 0X04, 29, 1, value)
+#define HIOE_INSTRUCTION_INFO_GET_RAW_R(extra_info)                            \
+	LE_BITS_TO_4BYTE(extra_info + 0X04, 30, 1)
+#define HIOE_INSTRUCTION_INFO_SET_RAW_R(extra_info, value)                     \
+	SET_BITS_TO_LE_4BYTE(extra_info + 0X04, 30, 1, value)
+#define HIOE_INSTRUCTION_INFO_GET_RAW(extra_info)                              \
+	LE_BITS_TO_4BYTE(extra_info + 0X04, 31, 1)
+#define HIOE_INSTRUCTION_INFO_SET_RAW(extra_info, value)                       \
+	SET_BITS_TO_LE_4BYTE(extra_info + 0X04, 31, 1, value)
+#endif
diff --git a/drivers/net/wireless/realtek/rtlwifi/halmac/halmac_original_c2h_nic.h b/drivers/net/wireless/realtek/rtlwifi/halmac/halmac_original_c2h_nic.h
new file mode 100644
index 000000000000..18cc2c7a09ba
--- /dev/null
+++ b/drivers/net/wireless/realtek/rtlwifi/halmac/halmac_original_c2h_nic.h
@@ -0,0 +1,408 @@
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
+#ifndef _HAL_ORIGINALC2HFORMAT_H2C_C2H_NIC_H_
+#define _HAL_ORIGINALC2HFORMAT_H2C_C2H_NIC_H_
+#define CMD_ID_C2H 0X00
+#define CMD_ID_DBG 0X00
+#define CMD_ID_C2H_LB 0X01
+#define CMD_ID_C2H_SND_TXBF 0X02
+#define CMD_ID_C2H_CCX_RPT 0X03
+#define CMD_ID_C2H_AP_REQ_TXRPT 0X04
+#define CMD_ID_C2H_INITIAL_RATE_COLLECTION 0X05
+#define CMD_ID_C2H_RA_RPT 0X0C
+#define CMD_ID_C2H_SPECIAL_STATISTICS 0X0D
+#define CMD_ID_C2H_RA_PARA_RPT 0X0E
+#define CMD_ID_C2H_CUR_CHANNEL 0X10
+#define CMD_ID_C2H_GPIO_WAKEUP 0X14
+#define C2H_GET_CMD_ID(c2h_pkt) LE_BITS_TO_4BYTE(c2h_pkt + 0X00, 0, 8)
+#define C2H_SET_CMD_ID(c2h_pkt, value)                                         \
+	SET_BITS_TO_LE_4BYTE(c2h_pkt + 0X00, 0, 8, value)
+#define C2H_GET_SEQ(c2h_pkt) LE_BITS_TO_4BYTE(c2h_pkt + 0X00, 8, 8)
+#define C2H_SET_SEQ(c2h_pkt, value)                                            \
+	SET_BITS_TO_LE_4BYTE(c2h_pkt + 0X00, 8, 8, value)
+#define DBG_GET_CMD_ID(c2h_pkt) LE_BITS_TO_4BYTE(c2h_pkt + 0X00, 0, 8)
+#define DBG_SET_CMD_ID(c2h_pkt, value)                                         \
+	SET_BITS_TO_LE_4BYTE(c2h_pkt + 0X00, 0, 8, value)
+#define DBG_GET_SEQ(c2h_pkt) LE_BITS_TO_4BYTE(c2h_pkt + 0X00, 8, 8)
+#define DBG_SET_SEQ(c2h_pkt, value)                                            \
+	SET_BITS_TO_LE_4BYTE(c2h_pkt + 0X00, 8, 8, value)
+#define DBG_GET_DBG_STR1(c2h_pkt) LE_BITS_TO_4BYTE(c2h_pkt + 0X00, 16, 8)
+#define DBG_SET_DBG_STR1(c2h_pkt, value)                                       \
+	SET_BITS_TO_LE_4BYTE(c2h_pkt + 0X00, 16, 8, value)
+#define DBG_GET_DBG_STR2(c2h_pkt) LE_BITS_TO_4BYTE(c2h_pkt + 0X00, 24, 8)
+#define DBG_SET_DBG_STR2(c2h_pkt, value)                                       \
+	SET_BITS_TO_LE_4BYTE(c2h_pkt + 0X00, 24, 8, value)
+#define DBG_GET_DBG_STR3(c2h_pkt) LE_BITS_TO_4BYTE(c2h_pkt + 0X04, 0, 8)
+#define DBG_SET_DBG_STR3(c2h_pkt, value)                                       \
+	SET_BITS_TO_LE_4BYTE(c2h_pkt + 0X04, 0, 8, value)
+#define DBG_GET_DBG_STR4(c2h_pkt) LE_BITS_TO_4BYTE(c2h_pkt + 0X04, 8, 8)
+#define DBG_SET_DBG_STR4(c2h_pkt, value)                                       \
+	SET_BITS_TO_LE_4BYTE(c2h_pkt + 0X04, 8, 8, value)
+#define DBG_GET_DBG_STR5(c2h_pkt) LE_BITS_TO_4BYTE(c2h_pkt + 0X04, 16, 8)
+#define DBG_SET_DBG_STR5(c2h_pkt, value)                                       \
+	SET_BITS_TO_LE_4BYTE(c2h_pkt + 0X04, 16, 8, value)
+#define DBG_GET_DBG_STR6(c2h_pkt) LE_BITS_TO_4BYTE(c2h_pkt + 0X04, 24, 8)
+#define DBG_SET_DBG_STR6(c2h_pkt, value)                                       \
+	SET_BITS_TO_LE_4BYTE(c2h_pkt + 0X04, 24, 8, value)
+#define DBG_GET_DBG_STR7(c2h_pkt) LE_BITS_TO_4BYTE(c2h_pkt + 0X08, 0, 8)
+#define DBG_SET_DBG_STR7(c2h_pkt, value)                                       \
+	SET_BITS_TO_LE_4BYTE(c2h_pkt + 0X08, 0, 8, value)
+#define DBG_GET_DBG_STR8(c2h_pkt) LE_BITS_TO_4BYTE(c2h_pkt + 0X08, 8, 8)
+#define DBG_SET_DBG_STR8(c2h_pkt, value)                                       \
+	SET_BITS_TO_LE_4BYTE(c2h_pkt + 0X08, 8, 8, value)
+#define DBG_GET_DBG_STR9(c2h_pkt) LE_BITS_TO_4BYTE(c2h_pkt + 0X08, 16, 8)
+#define DBG_SET_DBG_STR9(c2h_pkt, value)                                       \
+	SET_BITS_TO_LE_4BYTE(c2h_pkt + 0X08, 16, 8, value)
+#define DBG_GET_DBG_STR10(c2h_pkt) LE_BITS_TO_4BYTE(c2h_pkt + 0X08, 24, 8)
+#define DBG_SET_DBG_STR10(c2h_pkt, value)                                      \
+	SET_BITS_TO_LE_4BYTE(c2h_pkt + 0X08, 24, 8, value)
+#define DBG_GET_DBG_STR11(c2h_pkt) LE_BITS_TO_4BYTE(c2h_pkt + 0X0C, 0, 8)
+#define DBG_SET_DBG_STR11(c2h_pkt, value)                                      \
+	SET_BITS_TO_LE_4BYTE(c2h_pkt + 0X0C, 0, 8, value)
+#define DBG_GET_DBG_STR12(c2h_pkt) LE_BITS_TO_4BYTE(c2h_pkt + 0X0C, 8, 8)
+#define DBG_SET_DBG_STR12(c2h_pkt, value)                                      \
+	SET_BITS_TO_LE_4BYTE(c2h_pkt + 0X0C, 8, 8, value)
+#define DBG_GET_LEN(c2h_pkt) LE_BITS_TO_4BYTE(c2h_pkt + 0X0C, 16, 8)
+#define DBG_SET_LEN(c2h_pkt, value)                                            \
+	SET_BITS_TO_LE_4BYTE(c2h_pkt + 0X0C, 16, 8, value)
+#define DBG_GET_TRIGGER(c2h_pkt) LE_BITS_TO_4BYTE(c2h_pkt + 0X0C, 24, 8)
+#define DBG_SET_TRIGGER(c2h_pkt, value)                                        \
+	SET_BITS_TO_LE_4BYTE(c2h_pkt + 0X0C, 24, 8, value)
+#define C2H_LB_GET_CMD_ID(c2h_pkt) LE_BITS_TO_4BYTE(c2h_pkt + 0X00, 0, 8)
+#define C2H_LB_SET_CMD_ID(c2h_pkt, value)                                      \
+	SET_BITS_TO_LE_4BYTE(c2h_pkt + 0X00, 0, 8, value)
+#define C2H_LB_GET_SEQ(c2h_pkt) LE_BITS_TO_4BYTE(c2h_pkt + 0X00, 8, 8)
+#define C2H_LB_SET_SEQ(c2h_pkt, value)                                         \
+	SET_BITS_TO_LE_4BYTE(c2h_pkt + 0X00, 8, 8, value)
+#define C2H_LB_GET_PAYLOAD1(c2h_pkt) LE_BITS_TO_4BYTE(c2h_pkt + 0X00, 16, 16)
+#define C2H_LB_SET_PAYLOAD1(c2h_pkt, value)                                    \
+	SET_BITS_TO_LE_4BYTE(c2h_pkt + 0X00, 16, 16, value)
+#define C2H_LB_GET_PAYLOAD2(c2h_pkt) LE_BITS_TO_4BYTE(c2h_pkt + 0X04, 0, 32)
+#define C2H_LB_SET_PAYLOAD2(c2h_pkt, value)                                    \
+	SET_BITS_TO_LE_4BYTE(c2h_pkt + 0X04, 0, 32, value)
+#define C2H_LB_GET_LEN(c2h_pkt) LE_BITS_TO_4BYTE(c2h_pkt + 0X0C, 16, 8)
+#define C2H_LB_SET_LEN(c2h_pkt, value)                                         \
+	SET_BITS_TO_LE_4BYTE(c2h_pkt + 0X0C, 16, 8, value)
+#define C2H_LB_GET_TRIGGER(c2h_pkt) LE_BITS_TO_4BYTE(c2h_pkt + 0X0C, 24, 8)
+#define C2H_LB_SET_TRIGGER(c2h_pkt, value)                                     \
+	SET_BITS_TO_LE_4BYTE(c2h_pkt + 0X0C, 24, 8, value)
+#define C2H_SND_TXBF_GET_CMD_ID(c2h_pkt) LE_BITS_TO_4BYTE(c2h_pkt + 0X00, 0, 8)
+#define C2H_SND_TXBF_SET_CMD_ID(c2h_pkt, value)                                \
+	SET_BITS_TO_LE_4BYTE(c2h_pkt + 0X00, 0, 8, value)
+#define C2H_SND_TXBF_GET_SEQ(c2h_pkt) LE_BITS_TO_4BYTE(c2h_pkt + 0X00, 8, 8)
+#define C2H_SND_TXBF_SET_SEQ(c2h_pkt, value)                                   \
+	SET_BITS_TO_LE_4BYTE(c2h_pkt + 0X00, 8, 8, value)
+#define C2H_SND_TXBF_GET_SND_RESULT(c2h_pkt)                                   \
+	LE_BITS_TO_4BYTE(c2h_pkt + 0X00, 16, 1)
+#define C2H_SND_TXBF_SET_SND_RESULT(c2h_pkt, value)                            \
+	SET_BITS_TO_LE_4BYTE(c2h_pkt + 0X00, 16, 1, value)
+#define C2H_SND_TXBF_GET_LEN(c2h_pkt) LE_BITS_TO_4BYTE(c2h_pkt + 0X0C, 16, 8)
+#define C2H_SND_TXBF_SET_LEN(c2h_pkt, value)                                   \
+	SET_BITS_TO_LE_4BYTE(c2h_pkt + 0X0C, 16, 8, value)
+#define C2H_SND_TXBF_GET_TRIGGER(c2h_pkt)                                      \
+	LE_BITS_TO_4BYTE(c2h_pkt + 0X0C, 24, 8)
+#define C2H_SND_TXBF_SET_TRIGGER(c2h_pkt, value)                               \
+	SET_BITS_TO_LE_4BYTE(c2h_pkt + 0X0C, 24, 8, value)
+#define C2H_CCX_RPT_GET_CMD_ID(c2h_pkt) LE_BITS_TO_4BYTE(c2h_pkt + 0X00, 0, 8)
+#define C2H_CCX_RPT_SET_CMD_ID(c2h_pkt, value)                                 \
+	SET_BITS_TO_LE_4BYTE(c2h_pkt + 0X00, 0, 8, value)
+#define C2H_CCX_RPT_GET_SEQ(c2h_pkt) LE_BITS_TO_4BYTE(c2h_pkt + 0X00, 8, 8)
+#define C2H_CCX_RPT_SET_SEQ(c2h_pkt, value)                                    \
+	SET_BITS_TO_LE_4BYTE(c2h_pkt + 0X00, 8, 8, value)
+#define C2H_CCX_RPT_GET_QSEL(c2h_pkt) LE_BITS_TO_4BYTE(c2h_pkt + 0X00, 16, 5)
+#define C2H_CCX_RPT_SET_QSEL(c2h_pkt, value)                                   \
+	SET_BITS_TO_LE_4BYTE(c2h_pkt + 0X00, 16, 5, value)
+#define C2H_CCX_RPT_GET_BMC(c2h_pkt) LE_BITS_TO_4BYTE(c2h_pkt + 0X00, 21, 1)
+#define C2H_CCX_RPT_SET_BMC(c2h_pkt, value)                                    \
+	SET_BITS_TO_LE_4BYTE(c2h_pkt + 0X00, 21, 1, value)
+#define C2H_CCX_RPT_GET_LIFE_TIME_OVER(c2h_pkt)                                \
+	LE_BITS_TO_4BYTE(c2h_pkt + 0X00, 22, 1)
+#define C2H_CCX_RPT_SET_LIFE_TIME_OVER(c2h_pkt, value)                         \
+	SET_BITS_TO_LE_4BYTE(c2h_pkt + 0X00, 22, 1, value)
+#define C2H_CCX_RPT_GET_RETRY_OVER(c2h_pkt)                                    \
+	LE_BITS_TO_4BYTE(c2h_pkt + 0X00, 23, 1)
+#define C2H_CCX_RPT_SET_RETRY_OVER(c2h_pkt, value)                             \
+	SET_BITS_TO_LE_4BYTE(c2h_pkt + 0X00, 23, 1, value)
+#define C2H_CCX_RPT_GET_MACID(c2h_pkt) LE_BITS_TO_4BYTE(c2h_pkt + 0X00, 24, 8)
+#define C2H_CCX_RPT_SET_MACID(c2h_pkt, value)                                  \
+	SET_BITS_TO_LE_4BYTE(c2h_pkt + 0X00, 24, 8, value)
+#define C2H_CCX_RPT_GET_DATA_RETRY_CNT(c2h_pkt)                                \
+	LE_BITS_TO_4BYTE(c2h_pkt + 0X04, 0, 6)
+#define C2H_CCX_RPT_SET_DATA_RETRY_CNT(c2h_pkt, value)                         \
+	SET_BITS_TO_LE_4BYTE(c2h_pkt + 0X04, 0, 6, value)
+#define C2H_CCX_RPT_GET_QUEUE7_0(c2h_pkt) LE_BITS_TO_4BYTE(c2h_pkt + 0X04, 8, 8)
+#define C2H_CCX_RPT_SET_QUEUE7_0(c2h_pkt, value)                               \
+	SET_BITS_TO_LE_4BYTE(c2h_pkt + 0X04, 8, 8, value)
+#define C2H_CCX_RPT_GET_QUEUE15_8(c2h_pkt)                                     \
+	LE_BITS_TO_4BYTE(c2h_pkt + 0X04, 16, 8)
+#define C2H_CCX_RPT_SET_QUEUE15_8(c2h_pkt, value)                              \
+	SET_BITS_TO_LE_4BYTE(c2h_pkt + 0X04, 16, 8, value)
+#define C2H_CCX_RPT_GET_FINAL_DATA_RATE(c2h_pkt)                               \
+	LE_BITS_TO_4BYTE(c2h_pkt + 0X04, 24, 8)
+#define C2H_CCX_RPT_SET_FINAL_DATA_RATE(c2h_pkt, value)                        \
+	SET_BITS_TO_LE_4BYTE(c2h_pkt + 0X04, 24, 8, value)
+#define C2H_CCX_RPT_GET_SW_DEFINE_0(c2h_pkt)                                   \
+	LE_BITS_TO_4BYTE(c2h_pkt + 0X08, 0, 8)
+#define C2H_CCX_RPT_SET_SW_DEFINE_0(c2h_pkt, value)                            \
+	SET_BITS_TO_LE_4BYTE(c2h_pkt + 0X08, 0, 8, value)
+#define C2H_CCX_RPT_GET_SW_DEFINE_1(c2h_pkt)                                   \
+	LE_BITS_TO_4BYTE(c2h_pkt + 0X08, 8, 4)
+#define C2H_CCX_RPT_SET_SW_DEFINE_1(c2h_pkt, value)                            \
+	SET_BITS_TO_LE_4BYTE(c2h_pkt + 0X08, 8, 4, value)
+#define C2H_CCX_RPT_GET_LEN(c2h_pkt) LE_BITS_TO_4BYTE(c2h_pkt + 0X0C, 16, 8)
+#define C2H_CCX_RPT_SET_LEN(c2h_pkt, value)                                    \
+	SET_BITS_TO_LE_4BYTE(c2h_pkt + 0X0C, 16, 8, value)
+#define C2H_CCX_RPT_GET_TRIGGER(c2h_pkt) LE_BITS_TO_4BYTE(c2h_pkt + 0X0C, 24, 8)
+#define C2H_CCX_RPT_SET_TRIGGER(c2h_pkt, value)                                \
+	SET_BITS_TO_LE_4BYTE(c2h_pkt + 0X0C, 24, 8, value)
+#define C2H_AP_REQ_TXRPT_GET_CMD_ID(c2h_pkt)                                   \
+	LE_BITS_TO_4BYTE(c2h_pkt + 0X00, 0, 8)
+#define C2H_AP_REQ_TXRPT_SET_CMD_ID(c2h_pkt, value)                            \
+	SET_BITS_TO_LE_4BYTE(c2h_pkt + 0X00, 0, 8, value)
+#define C2H_AP_REQ_TXRPT_GET_SEQ(c2h_pkt) LE_BITS_TO_4BYTE(c2h_pkt + 0X00, 8, 8)
+#define C2H_AP_REQ_TXRPT_SET_SEQ(c2h_pkt, value)                               \
+	SET_BITS_TO_LE_4BYTE(c2h_pkt + 0X00, 8, 8, value)
+#define C2H_AP_REQ_TXRPT_GET_STA1_MACID(c2h_pkt)                               \
+	LE_BITS_TO_4BYTE(c2h_pkt + 0X00, 16, 8)
+#define C2H_AP_REQ_TXRPT_SET_STA1_MACID(c2h_pkt, value)                        \
+	SET_BITS_TO_LE_4BYTE(c2h_pkt + 0X00, 16, 8, value)
+#define C2H_AP_REQ_TXRPT_GET_TX_OK1_0(c2h_pkt)                                 \
+	LE_BITS_TO_4BYTE(c2h_pkt + 0X00, 24, 8)
+#define C2H_AP_REQ_TXRPT_SET_TX_OK1_0(c2h_pkt, value)                          \
+	SET_BITS_TO_LE_4BYTE(c2h_pkt + 0X00, 24, 8, value)
+#define C2H_AP_REQ_TXRPT_GET_TX_OK1_1(c2h_pkt)                                 \
+	LE_BITS_TO_4BYTE(c2h_pkt + 0X04, 0, 8)
+#define C2H_AP_REQ_TXRPT_SET_TX_OK1_1(c2h_pkt, value)                          \
+	SET_BITS_TO_LE_4BYTE(c2h_pkt + 0X04, 0, 8, value)
+#define C2H_AP_REQ_TXRPT_GET_TX_FAIL1_0(c2h_pkt)                               \
+	LE_BITS_TO_4BYTE(c2h_pkt + 0X04, 8, 8)
+#define C2H_AP_REQ_TXRPT_SET_TX_FAIL1_0(c2h_pkt, value)                        \
+	SET_BITS_TO_LE_4BYTE(c2h_pkt + 0X04, 8, 8, value)
+#define C2H_AP_REQ_TXRPT_GET_TX_FAIL1_1(c2h_pkt)                               \
+	LE_BITS_TO_4BYTE(c2h_pkt + 0X04, 16, 8)
+#define C2H_AP_REQ_TXRPT_SET_TX_FAIL1_1(c2h_pkt, value)                        \
+	SET_BITS_TO_LE_4BYTE(c2h_pkt + 0X04, 16, 8, value)
+#define C2H_AP_REQ_TXRPT_GET_INITIAL_RATE1(c2h_pkt)                            \
+	LE_BITS_TO_4BYTE(c2h_pkt + 0X04, 24, 8)
+#define C2H_AP_REQ_TXRPT_SET_INITIAL_RATE1(c2h_pkt, value)                     \
+	SET_BITS_TO_LE_4BYTE(c2h_pkt + 0X04, 24, 8, value)
+#define C2H_AP_REQ_TXRPT_GET_STA2_MACID(c2h_pkt)                               \
+	LE_BITS_TO_4BYTE(c2h_pkt + 0X08, 0, 8)
+#define C2H_AP_REQ_TXRPT_SET_STA2_MACID(c2h_pkt, value)                        \
+	SET_BITS_TO_LE_4BYTE(c2h_pkt + 0X08, 0, 8, value)
+#define C2H_AP_REQ_TXRPT_GET_TX_OK2_0(c2h_pkt)                                 \
+	LE_BITS_TO_4BYTE(c2h_pkt + 0X08, 8, 8)
+#define C2H_AP_REQ_TXRPT_SET_TX_OK2_0(c2h_pkt, value)                          \
+	SET_BITS_TO_LE_4BYTE(c2h_pkt + 0X08, 8, 8, value)
+#define C2H_AP_REQ_TXRPT_GET_TX_OK2_1(c2h_pkt)                                 \
+	LE_BITS_TO_4BYTE(c2h_pkt + 0X08, 16, 8)
+#define C2H_AP_REQ_TXRPT_SET_TX_OK2_1(c2h_pkt, value)                          \
+	SET_BITS_TO_LE_4BYTE(c2h_pkt + 0X08, 16, 8, value)
+#define C2H_AP_REQ_TXRPT_GET_TX_FAIL2_0(c2h_pkt)                               \
+	LE_BITS_TO_4BYTE(c2h_pkt + 0X08, 24, 8)
+#define C2H_AP_REQ_TXRPT_SET_TX_FAIL2_0(c2h_pkt, value)                        \
+	SET_BITS_TO_LE_4BYTE(c2h_pkt + 0X08, 24, 8, value)
+#define C2H_AP_REQ_TXRPT_GET_TX_FAIL2_1(c2h_pkt)                               \
+	LE_BITS_TO_4BYTE(c2h_pkt + 0X0C, 0, 8)
+#define C2H_AP_REQ_TXRPT_SET_TX_FAIL2_1(c2h_pkt, value)                        \
+	SET_BITS_TO_LE_4BYTE(c2h_pkt + 0X0C, 0, 8, value)
+#define C2H_AP_REQ_TXRPT_GET_INITIAL_RATE2(c2h_pkt)                            \
+	LE_BITS_TO_4BYTE(c2h_pkt + 0X0C, 8, 8)
+#define C2H_AP_REQ_TXRPT_SET_INITIAL_RATE2(c2h_pkt, value)                     \
+	SET_BITS_TO_LE_4BYTE(c2h_pkt + 0X0C, 8, 8, value)
+#define C2H_AP_REQ_TXRPT_GET_LEN(c2h_pkt)                                      \
+	LE_BITS_TO_4BYTE(c2h_pkt + 0X0C, 16, 8)
+#define C2H_AP_REQ_TXRPT_SET_LEN(c2h_pkt, value)                               \
+	SET_BITS_TO_LE_4BYTE(c2h_pkt + 0X0C, 16, 8, value)
+#define C2H_AP_REQ_TXRPT_GET_TRIGGER(c2h_pkt)                                  \
+	LE_BITS_TO_4BYTE(c2h_pkt + 0X0C, 24, 8)
+#define C2H_AP_REQ_TXRPT_SET_TRIGGER(c2h_pkt, value)                           \
+	SET_BITS_TO_LE_4BYTE(c2h_pkt + 0X0C, 24, 8, value)
+#define C2H_INITIAL_RATE_COLLECTION_GET_CMD_ID(c2h_pkt)                        \
+	LE_BITS_TO_4BYTE(c2h_pkt + 0X00, 0, 8)
+#define C2H_INITIAL_RATE_COLLECTION_SET_CMD_ID(c2h_pkt, value)                 \
+	SET_BITS_TO_LE_4BYTE(c2h_pkt + 0X00, 0, 8, value)
+#define C2H_INITIAL_RATE_COLLECTION_GET_SEQ(c2h_pkt)                           \
+	LE_BITS_TO_4BYTE(c2h_pkt + 0X00, 8, 8)
+#define C2H_INITIAL_RATE_COLLECTION_SET_SEQ(c2h_pkt, value)                    \
+	SET_BITS_TO_LE_4BYTE(c2h_pkt + 0X00, 8, 8, value)
+#define C2H_INITIAL_RATE_COLLECTION_GET_TRYING_BITMAP(c2h_pkt)                 \
+	LE_BITS_TO_4BYTE(c2h_pkt + 0X00, 16, 7)
+#define C2H_INITIAL_RATE_COLLECTION_SET_TRYING_BITMAP(c2h_pkt, value)          \
+	SET_BITS_TO_LE_4BYTE(c2h_pkt + 0X00, 16, 7, value)
+#define C2H_INITIAL_RATE_COLLECTION_GET_INITIAL_RATE1(c2h_pkt)                 \
+	LE_BITS_TO_4BYTE(c2h_pkt + 0X00, 24, 8)
+#define C2H_INITIAL_RATE_COLLECTION_SET_INITIAL_RATE1(c2h_pkt, value)          \
+	SET_BITS_TO_LE_4BYTE(c2h_pkt + 0X00, 24, 8, value)
+#define C2H_INITIAL_RATE_COLLECTION_GET_INITIAL_RATE2(c2h_pkt)                 \
+	LE_BITS_TO_4BYTE(c2h_pkt + 0X04, 0, 8)
+#define C2H_INITIAL_RATE_COLLECTION_SET_INITIAL_RATE2(c2h_pkt, value)          \
+	SET_BITS_TO_LE_4BYTE(c2h_pkt + 0X04, 0, 8, value)
+#define C2H_INITIAL_RATE_COLLECTION_GET_INITIAL_RATE3(c2h_pkt)                 \
+	LE_BITS_TO_4BYTE(c2h_pkt + 0X04, 8, 8)
+#define C2H_INITIAL_RATE_COLLECTION_SET_INITIAL_RATE3(c2h_pkt, value)          \
+	SET_BITS_TO_LE_4BYTE(c2h_pkt + 0X04, 8, 8, value)
+#define C2H_INITIAL_RATE_COLLECTION_GET_INITIAL_RATE4(c2h_pkt)                 \
+	LE_BITS_TO_4BYTE(c2h_pkt + 0X04, 16, 8)
+#define C2H_INITIAL_RATE_COLLECTION_SET_INITIAL_RATE4(c2h_pkt, value)          \
+	SET_BITS_TO_LE_4BYTE(c2h_pkt + 0X04, 16, 8, value)
+#define C2H_INITIAL_RATE_COLLECTION_GET_INITIAL_RATE5(c2h_pkt)                 \
+	LE_BITS_TO_4BYTE(c2h_pkt + 0X04, 24, 8)
+#define C2H_INITIAL_RATE_COLLECTION_SET_INITIAL_RATE5(c2h_pkt, value)          \
+	SET_BITS_TO_LE_4BYTE(c2h_pkt + 0X04, 24, 8, value)
+#define C2H_INITIAL_RATE_COLLECTION_GET_INITIAL_RATE6(c2h_pkt)                 \
+	LE_BITS_TO_4BYTE(c2h_pkt + 0X08, 0, 8)
+#define C2H_INITIAL_RATE_COLLECTION_SET_INITIAL_RATE6(c2h_pkt, value)          \
+	SET_BITS_TO_LE_4BYTE(c2h_pkt + 0X08, 0, 8, value)
+#define C2H_INITIAL_RATE_COLLECTION_GET_INITIAL_RATE7(c2h_pkt)                 \
+	LE_BITS_TO_4BYTE(c2h_pkt + 0X08, 8, 8)
+#define C2H_INITIAL_RATE_COLLECTION_SET_INITIAL_RATE7(c2h_pkt, value)          \
+	SET_BITS_TO_LE_4BYTE(c2h_pkt + 0X08, 8, 8, value)
+#define C2H_INITIAL_RATE_COLLECTION_GET_LEN(c2h_pkt)                           \
+	LE_BITS_TO_4BYTE(c2h_pkt + 0X0C, 16, 8)
+#define C2H_INITIAL_RATE_COLLECTION_SET_LEN(c2h_pkt, value)                    \
+	SET_BITS_TO_LE_4BYTE(c2h_pkt + 0X0C, 16, 8, value)
+#define C2H_INITIAL_RATE_COLLECTION_GET_TRIGGER(c2h_pkt)                       \
+	LE_BITS_TO_4BYTE(c2h_pkt + 0X0C, 24, 8)
+#define C2H_INITIAL_RATE_COLLECTION_SET_TRIGGER(c2h_pkt, value)                \
+	SET_BITS_TO_LE_4BYTE(c2h_pkt + 0X0C, 24, 8, value)
+#define C2H_RA_RPT_GET_CMD_ID(c2h_pkt) LE_BITS_TO_4BYTE(c2h_pkt + 0X00, 0, 8)
+#define C2H_RA_RPT_SET_CMD_ID(c2h_pkt, value)                                  \
+	SET_BITS_TO_LE_4BYTE(c2h_pkt + 0X00, 0, 8, value)
+#define C2H_RA_RPT_GET_SEQ(c2h_pkt) LE_BITS_TO_4BYTE(c2h_pkt + 0X00, 8, 8)
+#define C2H_RA_RPT_SET_SEQ(c2h_pkt, value)                                     \
+	SET_BITS_TO_LE_4BYTE(c2h_pkt + 0X00, 8, 8, value)
+#define C2H_RA_RPT_GET_RATE(c2h_pkt) LE_BITS_TO_4BYTE(c2h_pkt + 0X00, 16, 8)
+#define C2H_RA_RPT_SET_RATE(c2h_pkt, value)                                    \
+	SET_BITS_TO_LE_4BYTE(c2h_pkt + 0X00, 16, 8, value)
+#define C2H_RA_RPT_GET_MACID(c2h_pkt) LE_BITS_TO_4BYTE(c2h_pkt + 0X00, 24, 8)
+#define C2H_RA_RPT_SET_MACID(c2h_pkt, value)                                   \
+	SET_BITS_TO_LE_4BYTE(c2h_pkt + 0X00, 24, 8, value)
+#define C2H_RA_RPT_GET_USE_LDPC(c2h_pkt) LE_BITS_TO_4BYTE(c2h_pkt + 0X04, 0, 1)
+#define C2H_RA_RPT_SET_USE_LDPC(c2h_pkt, value)                                \
+	SET_BITS_TO_LE_4BYTE(c2h_pkt + 0X04, 0, 1, value)
+#define C2H_RA_RPT_GET_USE_TXBF(c2h_pkt) LE_BITS_TO_4BYTE(c2h_pkt + 0X04, 1, 1)
+#define C2H_RA_RPT_SET_USE_TXBF(c2h_pkt, value)                                \
+	SET_BITS_TO_LE_4BYTE(c2h_pkt + 0X04, 1, 1, value)
+#define C2H_RA_RPT_GET_COLLISION_STATE(c2h_pkt)                                \
+	LE_BITS_TO_4BYTE(c2h_pkt + 0X04, 8, 8)
+#define C2H_RA_RPT_SET_COLLISION_STATE(c2h_pkt, value)                         \
+	SET_BITS_TO_LE_4BYTE(c2h_pkt + 0X04, 8, 8, value)
+#define C2H_RA_RPT_GET_LEN(c2h_pkt) LE_BITS_TO_4BYTE(c2h_pkt + 0X0C, 16, 8)
+#define C2H_RA_RPT_SET_LEN(c2h_pkt, value)                                     \
+	SET_BITS_TO_LE_4BYTE(c2h_pkt + 0X0C, 16, 8, value)
+#define C2H_RA_RPT_GET_TRIGGER(c2h_pkt) LE_BITS_TO_4BYTE(c2h_pkt + 0X0C, 24, 8)
+#define C2H_RA_RPT_SET_TRIGGER(c2h_pkt, value)                                 \
+	SET_BITS_TO_LE_4BYTE(c2h_pkt + 0X0C, 24, 8, value)
+#define C2H_SPECIAL_STATISTICS_GET_CMD_ID(c2h_pkt)                             \
+	LE_BITS_TO_4BYTE(c2h_pkt + 0X00, 0, 8)
+#define C2H_SPECIAL_STATISTICS_SET_CMD_ID(c2h_pkt, value)                      \
+	SET_BITS_TO_LE_4BYTE(c2h_pkt + 0X00, 0, 8, value)
+#define C2H_SPECIAL_STATISTICS_GET_SEQ(c2h_pkt)                                \
+	LE_BITS_TO_4BYTE(c2h_pkt + 0X00, 8, 8)
+#define C2H_SPECIAL_STATISTICS_SET_SEQ(c2h_pkt, value)                         \
+	SET_BITS_TO_LE_4BYTE(c2h_pkt + 0X00, 8, 8, value)
+#define C2H_SPECIAL_STATISTICS_GET_STATISTICS_IDX(c2h_pkt)                     \
+	LE_BITS_TO_4BYTE(c2h_pkt + 0X00, 16, 8)
+#define C2H_SPECIAL_STATISTICS_SET_STATISTICS_IDX(c2h_pkt, value)              \
+	SET_BITS_TO_LE_4BYTE(c2h_pkt + 0X00, 16, 8, value)
+#define C2H_SPECIAL_STATISTICS_GET_DATA0(c2h_pkt)                              \
+	LE_BITS_TO_4BYTE(c2h_pkt + 0X00, 24, 8)
+#define C2H_SPECIAL_STATISTICS_SET_DATA0(c2h_pkt, value)                       \
+	SET_BITS_TO_LE_4BYTE(c2h_pkt + 0X00, 24, 8, value)
+#define C2H_SPECIAL_STATISTICS_GET_DATA1(c2h_pkt)                              \
+	LE_BITS_TO_4BYTE(c2h_pkt + 0X04, 0, 8)
+#define C2H_SPECIAL_STATISTICS_SET_DATA1(c2h_pkt, value)                       \
+	SET_BITS_TO_LE_4BYTE(c2h_pkt + 0X04, 0, 8, value)
+#define C2H_SPECIAL_STATISTICS_GET_DATA2(c2h_pkt)                              \
+	LE_BITS_TO_4BYTE(c2h_pkt + 0X04, 8, 8)
+#define C2H_SPECIAL_STATISTICS_SET_DATA2(c2h_pkt, value)                       \
+	SET_BITS_TO_LE_4BYTE(c2h_pkt + 0X04, 8, 8, value)
+#define C2H_SPECIAL_STATISTICS_GET_DATA3(c2h_pkt)                              \
+	LE_BITS_TO_4BYTE(c2h_pkt + 0X04, 16, 8)
+#define C2H_SPECIAL_STATISTICS_SET_DATA3(c2h_pkt, value)                       \
+	SET_BITS_TO_LE_4BYTE(c2h_pkt + 0X04, 16, 8, value)
+#define C2H_SPECIAL_STATISTICS_GET_DATA4(c2h_pkt)                              \
+	LE_BITS_TO_4BYTE(c2h_pkt + 0X04, 24, 8)
+#define C2H_SPECIAL_STATISTICS_SET_DATA4(c2h_pkt, value)                       \
+	SET_BITS_TO_LE_4BYTE(c2h_pkt + 0X04, 24, 8, value)
+#define C2H_SPECIAL_STATISTICS_GET_DATA5(c2h_pkt)                              \
+	LE_BITS_TO_4BYTE(c2h_pkt + 0X08, 0, 8)
+#define C2H_SPECIAL_STATISTICS_SET_DATA5(c2h_pkt, value)                       \
+	SET_BITS_TO_LE_4BYTE(c2h_pkt + 0X08, 0, 8, value)
+#define C2H_SPECIAL_STATISTICS_GET_DATA6(c2h_pkt)                              \
+	LE_BITS_TO_4BYTE(c2h_pkt + 0X08, 8, 8)
+#define C2H_SPECIAL_STATISTICS_SET_DATA6(c2h_pkt, value)                       \
+	SET_BITS_TO_LE_4BYTE(c2h_pkt + 0X08, 8, 8, value)
+#define C2H_SPECIAL_STATISTICS_GET_DATA7(c2h_pkt)                              \
+	LE_BITS_TO_4BYTE(c2h_pkt + 0X08, 16, 8)
+#define C2H_SPECIAL_STATISTICS_SET_DATA7(c2h_pkt, value)                       \
+	SET_BITS_TO_LE_4BYTE(c2h_pkt + 0X08, 16, 8, value)
+#define C2H_SPECIAL_STATISTICS_GET_LEN(c2h_pkt)                                \
+	LE_BITS_TO_4BYTE(c2h_pkt + 0X0C, 16, 8)
+#define C2H_SPECIAL_STATISTICS_SET_LEN(c2h_pkt, value)                         \
+	SET_BITS_TO_LE_4BYTE(c2h_pkt + 0X0C, 16, 8, value)
+#define C2H_SPECIAL_STATISTICS_GET_TRIGGER(c2h_pkt)                            \
+	LE_BITS_TO_4BYTE(c2h_pkt + 0X0C, 24, 8)
+#define C2H_SPECIAL_STATISTICS_SET_TRIGGER(c2h_pkt, value)                     \
+	SET_BITS_TO_LE_4BYTE(c2h_pkt + 0X0C, 24, 8, value)
+#define C2H_RA_PARA_RPT_GET_CMD_ID(c2h_pkt)                                    \
+	LE_BITS_TO_4BYTE(c2h_pkt + 0X00, 0, 8)
+#define C2H_RA_PARA_RPT_SET_CMD_ID(c2h_pkt, value)                             \
+	SET_BITS_TO_LE_4BYTE(c2h_pkt + 0X00, 0, 8, value)
+#define C2H_RA_PARA_RPT_GET_SEQ(c2h_pkt) LE_BITS_TO_4BYTE(c2h_pkt + 0X00, 8, 8)
+#define C2H_RA_PARA_RPT_SET_SEQ(c2h_pkt, value)                                \
+	SET_BITS_TO_LE_4BYTE(c2h_pkt + 0X00, 8, 8, value)
+#define C2H_RA_PARA_RPT_GET_LEN(c2h_pkt) LE_BITS_TO_4BYTE(c2h_pkt + 0X0C, 16, 8)
+#define C2H_RA_PARA_RPT_SET_LEN(c2h_pkt, value)                                \
+	SET_BITS_TO_LE_4BYTE(c2h_pkt + 0X0C, 16, 8, value)
+#define C2H_RA_PARA_RPT_GET_TRIGGER(c2h_pkt)                                   \
+	LE_BITS_TO_4BYTE(c2h_pkt + 0X0C, 24, 8)
+#define C2H_RA_PARA_RPT_SET_TRIGGER(c2h_pkt, value)                            \
+	SET_BITS_TO_LE_4BYTE(c2h_pkt + 0X0C, 24, 8, value)
+#define C2H_CUR_CHANNEL_GET_CMD_ID(c2h_pkt)                                    \
+	LE_BITS_TO_4BYTE(c2h_pkt + 0X00, 0, 8)
+#define C2H_CUR_CHANNEL_SET_CMD_ID(c2h_pkt, value)                             \
+	SET_BITS_TO_LE_4BYTE(c2h_pkt + 0X00, 0, 8, value)
+#define C2H_CUR_CHANNEL_GET_SEQ(c2h_pkt) LE_BITS_TO_4BYTE(c2h_pkt + 0X00, 8, 8)
+#define C2H_CUR_CHANNEL_SET_SEQ(c2h_pkt, value)                                \
+	SET_BITS_TO_LE_4BYTE(c2h_pkt + 0X00, 8, 8, value)
+#define C2H_CUR_CHANNEL_GET_CHANNEL_NUM(c2h_pkt)                               \
+	LE_BITS_TO_4BYTE(c2h_pkt + 0X00, 16, 8)
+#define C2H_CUR_CHANNEL_SET_CHANNEL_NUM(c2h_pkt, value)                        \
+	SET_BITS_TO_LE_4BYTE(c2h_pkt + 0X00, 16, 8, value)
+#define C2H_CUR_CHANNEL_GET_LEN(c2h_pkt) LE_BITS_TO_4BYTE(c2h_pkt + 0X0C, 16, 8)
+#define C2H_CUR_CHANNEL_SET_LEN(c2h_pkt, value)                                \
+	SET_BITS_TO_LE_4BYTE(c2h_pkt + 0X0C, 16, 8, value)
+#define C2H_CUR_CHANNEL_GET_TRIGGER(c2h_pkt)                                   \
+	LE_BITS_TO_4BYTE(c2h_pkt + 0X0C, 24, 8)
+#define C2H_CUR_CHANNEL_SET_TRIGGER(c2h_pkt, value)                            \
+	SET_BITS_TO_LE_4BYTE(c2h_pkt + 0X0C, 24, 8, value)
+#define C2H_GPIO_WAKEUP_GET_CMD_ID(c2h_pkt)                                    \
+	LE_BITS_TO_4BYTE(c2h_pkt + 0X00, 0, 8)
+#define C2H_GPIO_WAKEUP_SET_CMD_ID(c2h_pkt, value)                             \
+	SET_BITS_TO_LE_4BYTE(c2h_pkt + 0X00, 0, 8, value)
+#define C2H_GPIO_WAKEUP_GET_SEQ(c2h_pkt) LE_BITS_TO_4BYTE(c2h_pkt + 0X00, 8, 8)
+#define C2H_GPIO_WAKEUP_SET_SEQ(c2h_pkt, value)                                \
+	SET_BITS_TO_LE_4BYTE(c2h_pkt + 0X00, 8, 8, value)
+#define C2H_GPIO_WAKEUP_GET_LEN(c2h_pkt) LE_BITS_TO_4BYTE(c2h_pkt + 0X0C, 16, 8)
+#define C2H_GPIO_WAKEUP_SET_LEN(c2h_pkt, value)                                \
+	SET_BITS_TO_LE_4BYTE(c2h_pkt + 0X0C, 16, 8, value)
+#define C2H_GPIO_WAKEUP_GET_TRIGGER(c2h_pkt)                                   \
+	LE_BITS_TO_4BYTE(c2h_pkt + 0X0C, 24, 8)
+#define C2H_GPIO_WAKEUP_SET_TRIGGER(c2h_pkt, value)                            \
+	SET_BITS_TO_LE_4BYTE(c2h_pkt + 0X0C, 24, 8, value)
+#endif
diff --git a/drivers/net/wireless/realtek/rtlwifi/halmac/halmac_original_h2c_nic.h b/drivers/net/wireless/realtek/rtlwifi/halmac/halmac_original_h2c_nic.h
new file mode 100644
index 000000000000..3870ff4953c8
--- /dev/null
+++ b/drivers/net/wireless/realtek/rtlwifi/halmac/halmac_original_h2c_nic.h
@@ -0,0 +1,1143 @@
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
+#ifndef _HAL_ORIGINALH2CFORMAT_H2C_C2H_NIC_H_
+#define _HAL_ORIGINALH2CFORMAT_H2C_C2H_NIC_H_
+#define CMD_ID_ORIGINAL_H2C 0X00
+#define CMD_ID_H2C2H_LB 0X0
+#define CMD_ID_D0_SCAN_OFFLOAD_CTRL 0X06
+#define CMD_ID_RSVD_PAGE 0X0
+#define CMD_ID_MEDIA_STATUS_RPT 0X01
+#define CMD_ID_KEEP_ALIVE 0X03
+#define CMD_ID_DISCONNECT_DECISION 0X04
+#define CMD_ID_AP_OFFLOAD 0X08
+#define CMD_ID_BCN_RSVDPAGE 0X09
+#define CMD_ID_PROBE_RSP_RSVDPAGE 0X0A
+#define CMD_ID_SINGLE_CHANNELSWITCH 0X1C
+#define CMD_ID_SINGLE_CHANNELSWITCH_V2 0X1D
+#define CMD_ID_SET_PWR_MODE 0X00
+#define CMD_ID_PS_TUNING_PARA 0X01
+#define CMD_ID_PS_TUNING_PARA_II 0X02
+#define CMD_ID_PS_LPS_PARA 0X03
+#define CMD_ID_P2P_PS_OFFLOAD 0X04
+#define CMD_ID_PS_SCAN_EN 0X05
+#define CMD_ID_SAP_PS 0X06
+#define CMD_ID_INACTIVE_PS 0X07
+#define CMD_ID_MACID_CFG 0X00
+#define CMD_ID_TXBF 0X01
+#define CMD_ID_RSSI_SETTING 0X02
+#define CMD_ID_AP_REQ_TXRPT 0X03
+#define CMD_ID_INIT_RATE_COLLECTION 0X04
+#define CMD_ID_IQK_OFFLOAD 0X05
+#define CMD_ID_MACID_CFG_3SS 0X06
+#define CMD_ID_RA_PARA_ADJUST 0X07
+#define CMD_ID_WWLAN 0X00
+#define CMD_ID_REMOTE_WAKE_CTRL 0X01
+#define CMD_ID_AOAC_GLOBAL_INFO 0X02
+#define CMD_ID_AOAC_RSVD_PAGE 0X03
+#define CMD_ID_AOAC_RSVD_PAGE2 0X04
+#define CMD_ID_D0_SCAN_OFFLOAD_INFO 0X05
+#define CMD_ID_CHANNEL_SWITCH_OFFLOAD 0X07
+#define CMD_ID_AOAC_RSVD_PAGE3 0X08
+#define CMD_ID_DBG_MSG_CTRL 0X1E
+#define CLASS_ORIGINAL_H2C 0X00
+#define CLASS_H2C2H_LB 0X07
+#define CLASS_D0_SCAN_OFFLOAD_CTRL 0X04
+#define CLASS_RSVD_PAGE 0X0
+#define CLASS_MEDIA_STATUS_RPT 0X0
+#define CLASS_KEEP_ALIVE 0X0
+#define CLASS_DISCONNECT_DECISION 0X0
+#define CLASS_AP_OFFLOAD 0X0
+#define CLASS_BCN_RSVDPAGE 0X0
+#define CLASS_PROBE_RSP_RSVDPAGE 0X0
+#define CLASS_SINGLE_CHANNELSWITCH 0X0
+#define CLASS_SINGLE_CHANNELSWITCH_V2 0X0
+#define CLASS_SET_PWR_MODE 0X01
+#define CLASS_PS_TUNING_PARA 0X01
+#define CLASS_PS_TUNING_PARA_II 0X01
+#define CLASS_PS_LPS_PARA 0X01
+#define CLASS_P2P_PS_OFFLOAD 0X01
+#define CLASS_PS_SCAN_EN 0X1
+#define CLASS_SAP_PS 0X1
+#define CLASS_INACTIVE_PS 0X1
+#define CLASS_MACID_CFG 0X2
+#define CLASS_TXBF 0X2
+#define CLASS_RSSI_SETTING 0X2
+#define CLASS_AP_REQ_TXRPT 0X2
+#define CLASS_INIT_RATE_COLLECTION 0X2
+#define CLASS_IQK_OFFLOAD 0X2
+#define CLASS_MACID_CFG_3SS 0X2
+#define CLASS_RA_PARA_ADJUST 0X02
+#define CLASS_WWLAN 0X4
+#define CLASS_REMOTE_WAKE_CTRL 0X4
+#define CLASS_AOAC_GLOBAL_INFO 0X04
+#define CLASS_AOAC_RSVD_PAGE 0X04
+#define CLASS_AOAC_RSVD_PAGE2 0X04
+#define CLASS_D0_SCAN_OFFLOAD_INFO 0X04
+#define CLASS_CHANNEL_SWITCH_OFFLOAD 0X04
+#define CLASS_AOAC_RSVD_PAGE3 0X04
+#define CLASS_DBG_MSG_CTRL 0X07
+#define ORIGINAL_H2C_GET_CMD_ID(h2c_pkt) LE_BITS_TO_4BYTE(h2c_pkt + 0X00, 0, 5)
+#define ORIGINAL_H2C_SET_CMD_ID(h2c_pkt, value)                                \
+	SET_BITS_TO_LE_4BYTE(h2c_pkt + 0X00, 0, 5, value)
+#define ORIGINAL_H2C_GET_CLASS(h2c_pkt) LE_BITS_TO_4BYTE(h2c_pkt + 0X00, 5, 3)
+#define ORIGINAL_H2C_SET_CLASS(h2c_pkt, value)                                 \
+	SET_BITS_TO_LE_4BYTE(h2c_pkt + 0X00, 5, 3, value)
+#define H2C2H_LB_GET_CMD_ID(h2c_pkt) LE_BITS_TO_4BYTE(h2c_pkt + 0X00, 0, 5)
+#define H2C2H_LB_SET_CMD_ID(h2c_pkt, value)                                    \
+	SET_BITS_TO_LE_4BYTE(h2c_pkt + 0X00, 0, 5, value)
+#define H2C2H_LB_GET_CLASS(h2c_pkt) LE_BITS_TO_4BYTE(h2c_pkt + 0X00, 5, 3)
+#define H2C2H_LB_SET_CLASS(h2c_pkt, value)                                     \
+	SET_BITS_TO_LE_4BYTE(h2c_pkt + 0X00, 5, 3, value)
+#define H2C2H_LB_GET_SEQ(h2c_pkt) LE_BITS_TO_4BYTE(h2c_pkt + 0X00, 8, 8)
+#define H2C2H_LB_SET_SEQ(h2c_pkt, value)                                       \
+	SET_BITS_TO_LE_4BYTE(h2c_pkt + 0X00, 8, 8, value)
+#define H2C2H_LB_GET_PAYLOAD1(h2c_pkt) LE_BITS_TO_4BYTE(h2c_pkt + 0X00, 16, 16)
+#define H2C2H_LB_SET_PAYLOAD1(h2c_pkt, value)                                  \
+	SET_BITS_TO_LE_4BYTE(h2c_pkt + 0X00, 16, 16, value)
+#define H2C2H_LB_GET_PAYLOAD2(h2c_pkt) LE_BITS_TO_4BYTE(h2c_pkt + 0X04, 0, 32)
+#define H2C2H_LB_SET_PAYLOAD2(h2c_pkt, value)                                  \
+	SET_BITS_TO_LE_4BYTE(h2c_pkt + 0X04, 0, 32, value)
+#define D0_SCAN_OFFLOAD_CTRL_GET_CMD_ID(h2c_pkt)                               \
+	LE_BITS_TO_4BYTE(h2c_pkt + 0X00, 0, 5)
+#define D0_SCAN_OFFLOAD_CTRL_SET_CMD_ID(h2c_pkt, value)                        \
+	SET_BITS_TO_LE_4BYTE(h2c_pkt + 0X00, 0, 5, value)
+#define D0_SCAN_OFFLOAD_CTRL_GET_CLASS(h2c_pkt)                                \
+	LE_BITS_TO_4BYTE(h2c_pkt + 0X00, 5, 3)
+#define D0_SCAN_OFFLOAD_CTRL_SET_CLASS(h2c_pkt, value)                         \
+	SET_BITS_TO_LE_4BYTE(h2c_pkt + 0X00, 5, 3, value)
+#define D0_SCAN_OFFLOAD_CTRL_GET_D0_SCAN_FUN_EN(h2c_pkt)                       \
+	LE_BITS_TO_4BYTE(h2c_pkt + 0X00, 8, 1)
+#define D0_SCAN_OFFLOAD_CTRL_SET_D0_SCAN_FUN_EN(h2c_pkt, value)                \
+	SET_BITS_TO_LE_4BYTE(h2c_pkt + 0X00, 8, 1, value)
+#define D0_SCAN_OFFLOAD_CTRL_GET_RTD3FUN_EN(h2c_pkt)                           \
+	LE_BITS_TO_4BYTE(h2c_pkt + 0X00, 9, 1)
+#define D0_SCAN_OFFLOAD_CTRL_SET_RTD3FUN_EN(h2c_pkt, value)                    \
+	SET_BITS_TO_LE_4BYTE(h2c_pkt + 0X00, 9, 1, value)
+#define D0_SCAN_OFFLOAD_CTRL_GET_U3_SCAN_FUN_EN(h2c_pkt)                       \
+	LE_BITS_TO_4BYTE(h2c_pkt + 0X00, 10, 1)
+#define D0_SCAN_OFFLOAD_CTRL_SET_U3_SCAN_FUN_EN(h2c_pkt, value)                \
+	SET_BITS_TO_LE_4BYTE(h2c_pkt + 0X00, 10, 1, value)
+#define D0_SCAN_OFFLOAD_CTRL_GET_NLO_FUN_EN(h2c_pkt)                           \
+	LE_BITS_TO_4BYTE(h2c_pkt + 0X00, 11, 1)
+#define D0_SCAN_OFFLOAD_CTRL_SET_NLO_FUN_EN(h2c_pkt, value)                    \
+	SET_BITS_TO_LE_4BYTE(h2c_pkt + 0X00, 11, 1, value)
+#define D0_SCAN_OFFLOAD_CTRL_GET_IPS_DEPENDENT(h2c_pkt)                        \
+	LE_BITS_TO_4BYTE(h2c_pkt + 0X00, 12, 1)
+#define D0_SCAN_OFFLOAD_CTRL_SET_IPS_DEPENDENT(h2c_pkt, value)                 \
+	SET_BITS_TO_LE_4BYTE(h2c_pkt + 0X00, 12, 1, value)
+#define D0_SCAN_OFFLOAD_CTRL_GET_LOC_PROBE_PACKET(h2c_pkt)                     \
+	LE_BITS_TO_4BYTE(h2c_pkt + 0X00, 16, 17)
+#define D0_SCAN_OFFLOAD_CTRL_SET_LOC_PROBE_PACKET(h2c_pkt, value)              \
+	SET_BITS_TO_LE_4BYTE(h2c_pkt + 0X00, 16, 17, value)
+#define D0_SCAN_OFFLOAD_CTRL_GET_LOC_SCAN_INFO(h2c_pkt)                        \
+	LE_BITS_TO_4BYTE(h2c_pkt + 0X00, 24, 8)
+#define D0_SCAN_OFFLOAD_CTRL_SET_LOC_SCAN_INFO(h2c_pkt, value)                 \
+	SET_BITS_TO_LE_4BYTE(h2c_pkt + 0X00, 24, 8, value)
+#define D0_SCAN_OFFLOAD_CTRL_GET_LOC_SSID_INFO(h2c_pkt)                        \
+	LE_BITS_TO_4BYTE(h2c_pkt + 0X04, 0, 8)
+#define D0_SCAN_OFFLOAD_CTRL_SET_LOC_SSID_INFO(h2c_pkt, value)                 \
+	SET_BITS_TO_LE_4BYTE(h2c_pkt + 0X04, 0, 8, value)
+#define RSVD_PAGE_GET_CMD_ID(h2c_pkt) LE_BITS_TO_4BYTE(h2c_pkt + 0X00, 0, 5)
+#define RSVD_PAGE_SET_CMD_ID(h2c_pkt, value)                                   \
+	SET_BITS_TO_LE_4BYTE(h2c_pkt + 0X00, 0, 5, value)
+#define RSVD_PAGE_GET_CLASS(h2c_pkt) LE_BITS_TO_4BYTE(h2c_pkt + 0X00, 5, 3)
+#define RSVD_PAGE_SET_CLASS(h2c_pkt, value)                                    \
+	SET_BITS_TO_LE_4BYTE(h2c_pkt + 0X00, 5, 3, value)
+#define RSVD_PAGE_GET_LOC_PROBE_RSP(h2c_pkt)                                   \
+	LE_BITS_TO_4BYTE(h2c_pkt + 0X00, 8, 8)
+#define RSVD_PAGE_SET_LOC_PROBE_RSP(h2c_pkt, value)                            \
+	SET_BITS_TO_LE_4BYTE(h2c_pkt + 0X00, 8, 8, value)
+#define RSVD_PAGE_GET_LOC_PS_POLL(h2c_pkt)                                     \
+	LE_BITS_TO_4BYTE(h2c_pkt + 0X00, 16, 8)
+#define RSVD_PAGE_SET_LOC_PS_POLL(h2c_pkt, value)                              \
+	SET_BITS_TO_LE_4BYTE(h2c_pkt + 0X00, 16, 8, value)
+#define RSVD_PAGE_GET_LOC_NULL_DATA(h2c_pkt)                                   \
+	LE_BITS_TO_4BYTE(h2c_pkt + 0X00, 24, 8)
+#define RSVD_PAGE_SET_LOC_NULL_DATA(h2c_pkt, value)                            \
+	SET_BITS_TO_LE_4BYTE(h2c_pkt + 0X00, 24, 8, value)
+#define RSVD_PAGE_GET_LOC_QOS_NULL(h2c_pkt)                                    \
+	LE_BITS_TO_4BYTE(h2c_pkt + 0X04, 0, 8)
+#define RSVD_PAGE_SET_LOC_QOS_NULL(h2c_pkt, value)                             \
+	SET_BITS_TO_LE_4BYTE(h2c_pkt + 0X04, 0, 8, value)
+#define RSVD_PAGE_GET_LOC_BT_QOS_NULL(h2c_pkt)                                 \
+	LE_BITS_TO_4BYTE(h2c_pkt + 0X04, 8, 8)
+#define RSVD_PAGE_SET_LOC_BT_QOS_NULL(h2c_pkt, value)                          \
+	SET_BITS_TO_LE_4BYTE(h2c_pkt + 0X04, 8, 8, value)
+#define RSVD_PAGE_GET_LOC_CTS2SELF(h2c_pkt)                                    \
+	LE_BITS_TO_4BYTE(h2c_pkt + 0X04, 16, 8)
+#define RSVD_PAGE_SET_LOC_CTS2SELF(h2c_pkt, value)                             \
+	SET_BITS_TO_LE_4BYTE(h2c_pkt + 0X04, 16, 8, value)
+#define RSVD_PAGE_GET_LOC_LTECOEX_QOSNULL(h2c_pkt)                             \
+	LE_BITS_TO_4BYTE(h2c_pkt + 0X04, 24, 8)
+#define RSVD_PAGE_SET_LOC_LTECOEX_QOSNULL(h2c_pkt, value)                      \
+	SET_BITS_TO_LE_4BYTE(h2c_pkt + 0X04, 24, 8, value)
+#define MEDIA_STATUS_RPT_GET_CMD_ID(h2c_pkt)                                   \
+	LE_BITS_TO_4BYTE(h2c_pkt + 0X00, 0, 5)
+#define MEDIA_STATUS_RPT_SET_CMD_ID(h2c_pkt, value)                            \
+	SET_BITS_TO_LE_4BYTE(h2c_pkt + 0X00, 0, 5, value)
+#define MEDIA_STATUS_RPT_GET_CLASS(h2c_pkt)                                    \
+	LE_BITS_TO_4BYTE(h2c_pkt + 0X00, 5, 3)
+#define MEDIA_STATUS_RPT_SET_CLASS(h2c_pkt, value)                             \
+	SET_BITS_TO_LE_4BYTE(h2c_pkt + 0X00, 5, 3, value)
+#define MEDIA_STATUS_RPT_GET_OP_MODE(h2c_pkt)                                  \
+	LE_BITS_TO_4BYTE(h2c_pkt + 0X00, 8, 1)
+#define MEDIA_STATUS_RPT_SET_OP_MODE(h2c_pkt, value)                           \
+	SET_BITS_TO_LE_4BYTE(h2c_pkt + 0X00, 8, 1, value)
+#define MEDIA_STATUS_RPT_GET_MACID_IN(h2c_pkt)                                 \
+	LE_BITS_TO_4BYTE(h2c_pkt + 0X00, 9, 1)
+#define MEDIA_STATUS_RPT_SET_MACID_IN(h2c_pkt, value)                          \
+	SET_BITS_TO_LE_4BYTE(h2c_pkt + 0X00, 9, 1, value)
+#define MEDIA_STATUS_RPT_GET_MACID(h2c_pkt)                                    \
+	LE_BITS_TO_4BYTE(h2c_pkt + 0X00, 16, 8)
+#define MEDIA_STATUS_RPT_SET_MACID(h2c_pkt, value)                             \
+	SET_BITS_TO_LE_4BYTE(h2c_pkt + 0X00, 16, 8, value)
+#define MEDIA_STATUS_RPT_GET_MACID_END(h2c_pkt)                                \
+	LE_BITS_TO_4BYTE(h2c_pkt + 0X00, 24, 8)
+#define MEDIA_STATUS_RPT_SET_MACID_END(h2c_pkt, value)                         \
+	SET_BITS_TO_LE_4BYTE(h2c_pkt + 0X00, 24, 8, value)
+#define KEEP_ALIVE_GET_CMD_ID(h2c_pkt) LE_BITS_TO_4BYTE(h2c_pkt + 0X00, 0, 5)
+#define KEEP_ALIVE_SET_CMD_ID(h2c_pkt, value)                                  \
+	SET_BITS_TO_LE_4BYTE(h2c_pkt + 0X00, 0, 5, value)
+#define KEEP_ALIVE_GET_CLASS(h2c_pkt) LE_BITS_TO_4BYTE(h2c_pkt + 0X00, 5, 3)
+#define KEEP_ALIVE_SET_CLASS(h2c_pkt, value)                                   \
+	SET_BITS_TO_LE_4BYTE(h2c_pkt + 0X00, 5, 3, value)
+#define KEEP_ALIVE_GET_ENABLE(h2c_pkt) LE_BITS_TO_4BYTE(h2c_pkt + 0X00, 8, 1)
+#define KEEP_ALIVE_SET_ENABLE(h2c_pkt, value)                                  \
+	SET_BITS_TO_LE_4BYTE(h2c_pkt + 0X00, 8, 1, value)
+#define KEEP_ALIVE_GET_ADOPT_USER_SETTING(h2c_pkt)                             \
+	LE_BITS_TO_4BYTE(h2c_pkt + 0X00, 9, 1)
+#define KEEP_ALIVE_SET_ADOPT_USER_SETTING(h2c_pkt, value)                      \
+	SET_BITS_TO_LE_4BYTE(h2c_pkt + 0X00, 9, 1, value)
+#define KEEP_ALIVE_GET_PKT_TYPE(h2c_pkt) LE_BITS_TO_4BYTE(h2c_pkt + 0X00, 10, 1)
+#define KEEP_ALIVE_SET_PKT_TYPE(h2c_pkt, value)                                \
+	SET_BITS_TO_LE_4BYTE(h2c_pkt + 0X00, 10, 1, value)
+#define KEEP_ALIVE_GET_KEEP_ALIVE_CHECK_PERIOD(h2c_pkt)                        \
+	LE_BITS_TO_4BYTE(h2c_pkt + 0X00, 16, 8)
+#define KEEP_ALIVE_SET_KEEP_ALIVE_CHECK_PERIOD(h2c_pkt, value)                 \
+	SET_BITS_TO_LE_4BYTE(h2c_pkt + 0X00, 16, 8, value)
+#define DISCONNECT_DECISION_GET_CMD_ID(h2c_pkt)                                \
+	LE_BITS_TO_4BYTE(h2c_pkt + 0X00, 0, 5)
+#define DISCONNECT_DECISION_SET_CMD_ID(h2c_pkt, value)                         \
+	SET_BITS_TO_LE_4BYTE(h2c_pkt + 0X00, 0, 5, value)
+#define DISCONNECT_DECISION_GET_CLASS(h2c_pkt)                                 \
+	LE_BITS_TO_4BYTE(h2c_pkt + 0X00, 5, 3)
+#define DISCONNECT_DECISION_SET_CLASS(h2c_pkt, value)                          \
+	SET_BITS_TO_LE_4BYTE(h2c_pkt + 0X00, 5, 3, value)
+#define DISCONNECT_DECISION_GET_ENABLE(h2c_pkt)                                \
+	LE_BITS_TO_4BYTE(h2c_pkt + 0X00, 8, 1)
+#define DISCONNECT_DECISION_SET_ENABLE(h2c_pkt, value)                         \
+	SET_BITS_TO_LE_4BYTE(h2c_pkt + 0X00, 8, 1, value)
+#define DISCONNECT_DECISION_GET_ADOPT_USER_SETTING(h2c_pkt)                    \
+	LE_BITS_TO_4BYTE(h2c_pkt + 0X00, 9, 1)
+#define DISCONNECT_DECISION_SET_ADOPT_USER_SETTING(h2c_pkt, value)             \
+	SET_BITS_TO_LE_4BYTE(h2c_pkt + 0X00, 9, 1, value)
+#define DISCONNECT_DECISION_GET_TRY_OK_BCN_FAIL_COUNT_EN(h2c_pkt)              \
+	LE_BITS_TO_4BYTE(h2c_pkt + 0X00, 10, 1)
+#define DISCONNECT_DECISION_SET_TRY_OK_BCN_FAIL_COUNT_EN(h2c_pkt, value)       \
+	SET_BITS_TO_LE_4BYTE(h2c_pkt + 0X00, 10, 1, value)
+#define DISCONNECT_DECISION_GET_DISCONNECT_EN(h2c_pkt)                         \
+	LE_BITS_TO_4BYTE(h2c_pkt + 0X00, 11, 1)
+#define DISCONNECT_DECISION_SET_DISCONNECT_EN(h2c_pkt, value)                  \
+	SET_BITS_TO_LE_4BYTE(h2c_pkt + 0X00, 11, 1, value)
+#define DISCONNECT_DECISION_GET_DISCON_DECISION_CHECK_PERIOD(h2c_pkt)          \
+	LE_BITS_TO_4BYTE(h2c_pkt + 0X00, 16, 8)
+#define DISCONNECT_DECISION_SET_DISCON_DECISION_CHECK_PERIOD(h2c_pkt, value)   \
+	SET_BITS_TO_LE_4BYTE(h2c_pkt + 0X00, 16, 8, value)
+#define DISCONNECT_DECISION_GET_TRY_PKT_NUM(h2c_pkt)                           \
+	LE_BITS_TO_4BYTE(h2c_pkt + 0X00, 24, 8)
+#define DISCONNECT_DECISION_SET_TRY_PKT_NUM(h2c_pkt, value)                    \
+	SET_BITS_TO_LE_4BYTE(h2c_pkt + 0X00, 24, 8, value)
+#define DISCONNECT_DECISION_GET_TRY_OK_BCN_FAIL_COUNT_LIMIT(h2c_pkt)           \
+	LE_BITS_TO_4BYTE(h2c_pkt + 0X04, 0, 8)
+#define DISCONNECT_DECISION_SET_TRY_OK_BCN_FAIL_COUNT_LIMIT(h2c_pkt, value)    \
+	SET_BITS_TO_LE_4BYTE(h2c_pkt + 0X04, 0, 8, value)
+#define AP_OFFLOAD_GET_CMD_ID(h2c_pkt) LE_BITS_TO_4BYTE(h2c_pkt + 0X00, 0, 5)
+#define AP_OFFLOAD_SET_CMD_ID(h2c_pkt, value)                                  \
+	SET_BITS_TO_LE_4BYTE(h2c_pkt + 0X00, 0, 5, value)
+#define AP_OFFLOAD_GET_CLASS(h2c_pkt) LE_BITS_TO_4BYTE(h2c_pkt + 0X00, 5, 3)
+#define AP_OFFLOAD_SET_CLASS(h2c_pkt, value)                                   \
+	SET_BITS_TO_LE_4BYTE(h2c_pkt + 0X00, 5, 3, value)
+#define AP_OFFLOAD_GET_ON(h2c_pkt) LE_BITS_TO_4BYTE(h2c_pkt + 0X00, 8, 1)
+#define AP_OFFLOAD_SET_ON(h2c_pkt, value)                                      \
+	SET_BITS_TO_LE_4BYTE(h2c_pkt + 0X00, 8, 1, value)
+#define AP_OFFLOAD_GET_CFG_MIFI_PLATFORM(h2c_pkt)                              \
+	LE_BITS_TO_4BYTE(h2c_pkt + 0X00, 9, 1)
+#define AP_OFFLOAD_SET_CFG_MIFI_PLATFORM(h2c_pkt, value)                       \
+	SET_BITS_TO_LE_4BYTE(h2c_pkt + 0X00, 9, 1, value)
+#define AP_OFFLOAD_GET_LINKED(h2c_pkt) LE_BITS_TO_4BYTE(h2c_pkt + 0X00, 10, 1)
+#define AP_OFFLOAD_SET_LINKED(h2c_pkt, value)                                  \
+	SET_BITS_TO_LE_4BYTE(h2c_pkt + 0X00, 10, 1, value)
+#define AP_OFFLOAD_GET_EN_AUTO_WAKE(h2c_pkt)                                   \
+	LE_BITS_TO_4BYTE(h2c_pkt + 0X00, 11, 1)
+#define AP_OFFLOAD_SET_EN_AUTO_WAKE(h2c_pkt, value)                            \
+	SET_BITS_TO_LE_4BYTE(h2c_pkt + 0X00, 11, 1, value)
+#define AP_OFFLOAD_GET_WAKE_FLAG(h2c_pkt)                                      \
+	LE_BITS_TO_4BYTE(h2c_pkt + 0X00, 12, 1)
+#define AP_OFFLOAD_SET_WAKE_FLAG(h2c_pkt, value)                               \
+	SET_BITS_TO_LE_4BYTE(h2c_pkt + 0X00, 12, 1, value)
+#define AP_OFFLOAD_GET_HIDDEN_ROOT(h2c_pkt)                                    \
+	LE_BITS_TO_4BYTE(h2c_pkt + 0X00, 16, 1)
+#define AP_OFFLOAD_SET_HIDDEN_ROOT(h2c_pkt, value)                             \
+	SET_BITS_TO_LE_4BYTE(h2c_pkt + 0X00, 16, 1, value)
+#define AP_OFFLOAD_GET_HIDDEN_VAP1(h2c_pkt)                                    \
+	LE_BITS_TO_4BYTE(h2c_pkt + 0X00, 17, 1)
+#define AP_OFFLOAD_SET_HIDDEN_VAP1(h2c_pkt, value)                             \
+	SET_BITS_TO_LE_4BYTE(h2c_pkt + 0X00, 17, 1, value)
+#define AP_OFFLOAD_GET_HIDDEN_VAP2(h2c_pkt)                                    \
+	LE_BITS_TO_4BYTE(h2c_pkt + 0X00, 18, 1)
+#define AP_OFFLOAD_SET_HIDDEN_VAP2(h2c_pkt, value)                             \
+	SET_BITS_TO_LE_4BYTE(h2c_pkt + 0X00, 18, 1, value)
+#define AP_OFFLOAD_GET_HIDDEN_VAP3(h2c_pkt)                                    \
+	LE_BITS_TO_4BYTE(h2c_pkt + 0X00, 19, 1)
+#define AP_OFFLOAD_SET_HIDDEN_VAP3(h2c_pkt, value)                             \
+	SET_BITS_TO_LE_4BYTE(h2c_pkt + 0X00, 19, 1, value)
+#define AP_OFFLOAD_GET_HIDDEN_VAP4(h2c_pkt)                                    \
+	LE_BITS_TO_4BYTE(h2c_pkt + 0X00, 20, 1)
+#define AP_OFFLOAD_SET_HIDDEN_VAP4(h2c_pkt, value)                             \
+	SET_BITS_TO_LE_4BYTE(h2c_pkt + 0X00, 20, 1, value)
+#define AP_OFFLOAD_GET_DENYANY_ROOT(h2c_pkt)                                   \
+	LE_BITS_TO_4BYTE(h2c_pkt + 0X00, 24, 1)
+#define AP_OFFLOAD_SET_DENYANY_ROOT(h2c_pkt, value)                            \
+	SET_BITS_TO_LE_4BYTE(h2c_pkt + 0X00, 24, 1, value)
+#define AP_OFFLOAD_GET_DENYANY_VAP1(h2c_pkt)                                   \
+	LE_BITS_TO_4BYTE(h2c_pkt + 0X00, 25, 1)
+#define AP_OFFLOAD_SET_DENYANY_VAP1(h2c_pkt, value)                            \
+	SET_BITS_TO_LE_4BYTE(h2c_pkt + 0X00, 25, 1, value)
+#define AP_OFFLOAD_GET_DENYANY_VAP2(h2c_pkt)                                   \
+	LE_BITS_TO_4BYTE(h2c_pkt + 0X00, 26, 1)
+#define AP_OFFLOAD_SET_DENYANY_VAP2(h2c_pkt, value)                            \
+	SET_BITS_TO_LE_4BYTE(h2c_pkt + 0X00, 26, 1, value)
+#define AP_OFFLOAD_GET_DENYANY_VAP3(h2c_pkt)                                   \
+	LE_BITS_TO_4BYTE(h2c_pkt + 0X00, 27, 1)
+#define AP_OFFLOAD_SET_DENYANY_VAP3(h2c_pkt, value)                            \
+	SET_BITS_TO_LE_4BYTE(h2c_pkt + 0X00, 27, 1, value)
+#define AP_OFFLOAD_GET_DENYANY_VAP4(h2c_pkt)                                   \
+	LE_BITS_TO_4BYTE(h2c_pkt + 0X00, 28, 1)
+#define AP_OFFLOAD_SET_DENYANY_VAP4(h2c_pkt, value)                            \
+	SET_BITS_TO_LE_4BYTE(h2c_pkt + 0X00, 28, 1, value)
+#define AP_OFFLOAD_GET_WAIT_TBTT_CNT(h2c_pkt)                                  \
+	LE_BITS_TO_4BYTE(h2c_pkt + 0X04, 0, 8)
+#define AP_OFFLOAD_SET_WAIT_TBTT_CNT(h2c_pkt, value)                           \
+	SET_BITS_TO_LE_4BYTE(h2c_pkt + 0X04, 0, 8, value)
+#define AP_OFFLOAD_GET_WAKE_TIMEOUT(h2c_pkt)                                   \
+	LE_BITS_TO_4BYTE(h2c_pkt + 0X04, 8, 8)
+#define AP_OFFLOAD_SET_WAKE_TIMEOUT(h2c_pkt, value)                            \
+	SET_BITS_TO_LE_4BYTE(h2c_pkt + 0X04, 8, 8, value)
+#define AP_OFFLOAD_GET_LEN_IV_PAIR(h2c_pkt)                                    \
+	LE_BITS_TO_4BYTE(h2c_pkt + 0X04, 16, 8)
+#define AP_OFFLOAD_SET_LEN_IV_PAIR(h2c_pkt, value)                             \
+	SET_BITS_TO_LE_4BYTE(h2c_pkt + 0X04, 16, 8, value)
+#define AP_OFFLOAD_GET_LEN_IV_GRP(h2c_pkt)                                     \
+	LE_BITS_TO_4BYTE(h2c_pkt + 0X04, 24, 8)
+#define AP_OFFLOAD_SET_LEN_IV_GRP(h2c_pkt, value)                              \
+	SET_BITS_TO_LE_4BYTE(h2c_pkt + 0X04, 24, 8, value)
+#define BCN_RSVDPAGE_GET_CMD_ID(h2c_pkt) LE_BITS_TO_4BYTE(h2c_pkt + 0X00, 0, 5)
+#define BCN_RSVDPAGE_SET_CMD_ID(h2c_pkt, value)                                \
+	SET_BITS_TO_LE_4BYTE(h2c_pkt + 0X00, 0, 5, value)
+#define BCN_RSVDPAGE_GET_CLASS(h2c_pkt) LE_BITS_TO_4BYTE(h2c_pkt + 0X00, 5, 3)
+#define BCN_RSVDPAGE_SET_CLASS(h2c_pkt, value)                                 \
+	SET_BITS_TO_LE_4BYTE(h2c_pkt + 0X00, 5, 3, value)
+#define BCN_RSVDPAGE_GET_LOC_ROOT(h2c_pkt)                                     \
+	LE_BITS_TO_4BYTE(h2c_pkt + 0X00, 8, 8)
+#define BCN_RSVDPAGE_SET_LOC_ROOT(h2c_pkt, value)                              \
+	SET_BITS_TO_LE_4BYTE(h2c_pkt + 0X00, 8, 8, value)
+#define BCN_RSVDPAGE_GET_LOC_VAP1(h2c_pkt)                                     \
+	LE_BITS_TO_4BYTE(h2c_pkt + 0X00, 16, 8)
+#define BCN_RSVDPAGE_SET_LOC_VAP1(h2c_pkt, value)                              \
+	SET_BITS_TO_LE_4BYTE(h2c_pkt + 0X00, 16, 8, value)
+#define BCN_RSVDPAGE_GET_LOC_VAP2(h2c_pkt)                                     \
+	LE_BITS_TO_4BYTE(h2c_pkt + 0X00, 24, 8)
+#define BCN_RSVDPAGE_SET_LOC_VAP2(h2c_pkt, value)                              \
+	SET_BITS_TO_LE_4BYTE(h2c_pkt + 0X00, 24, 8, value)
+#define BCN_RSVDPAGE_GET_LOC_VAP3(h2c_pkt)                                     \
+	LE_BITS_TO_4BYTE(h2c_pkt + 0X04, 0, 8)
+#define BCN_RSVDPAGE_SET_LOC_VAP3(h2c_pkt, value)                              \
+	SET_BITS_TO_LE_4BYTE(h2c_pkt + 0X04, 0, 8, value)
+#define BCN_RSVDPAGE_GET_LOC_VAP4(h2c_pkt)                                     \
+	LE_BITS_TO_4BYTE(h2c_pkt + 0X04, 8, 8)
+#define BCN_RSVDPAGE_SET_LOC_VAP4(h2c_pkt, value)                              \
+	SET_BITS_TO_LE_4BYTE(h2c_pkt + 0X04, 8, 8, value)
+#define PROBE_RSP_RSVDPAGE_GET_CMD_ID(h2c_pkt)                                 \
+	LE_BITS_TO_4BYTE(h2c_pkt + 0X00, 0, 5)
+#define PROBE_RSP_RSVDPAGE_SET_CMD_ID(h2c_pkt, value)                          \
+	SET_BITS_TO_LE_4BYTE(h2c_pkt + 0X00, 0, 5, value)
+#define PROBE_RSP_RSVDPAGE_GET_CLASS(h2c_pkt)                                  \
+	LE_BITS_TO_4BYTE(h2c_pkt + 0X00, 5, 3)
+#define PROBE_RSP_RSVDPAGE_SET_CLASS(h2c_pkt, value)                           \
+	SET_BITS_TO_LE_4BYTE(h2c_pkt + 0X00, 5, 3, value)
+#define PROBE_RSP_RSVDPAGE_GET_LOC_ROOT(h2c_pkt)                               \
+	LE_BITS_TO_4BYTE(h2c_pkt + 0X00, 8, 8)
+#define PROBE_RSP_RSVDPAGE_SET_LOC_ROOT(h2c_pkt, value)                        \
+	SET_BITS_TO_LE_4BYTE(h2c_pkt + 0X00, 8, 8, value)
+#define PROBE_RSP_RSVDPAGE_GET_LOC_VAP1(h2c_pkt)                               \
+	LE_BITS_TO_4BYTE(h2c_pkt + 0X00, 16, 8)
+#define PROBE_RSP_RSVDPAGE_SET_LOC_VAP1(h2c_pkt, value)                        \
+	SET_BITS_TO_LE_4BYTE(h2c_pkt + 0X00, 16, 8, value)
+#define PROBE_RSP_RSVDPAGE_GET_LOC_VAP2(h2c_pkt)                               \
+	LE_BITS_TO_4BYTE(h2c_pkt + 0X00, 24, 8)
+#define PROBE_RSP_RSVDPAGE_SET_LOC_VAP2(h2c_pkt, value)                        \
+	SET_BITS_TO_LE_4BYTE(h2c_pkt + 0X00, 24, 8, value)
+#define PROBE_RSP_RSVDPAGE_GET_LOC_VAP3(h2c_pkt)                               \
+	LE_BITS_TO_4BYTE(h2c_pkt + 0X04, 0, 8)
+#define PROBE_RSP_RSVDPAGE_SET_LOC_VAP3(h2c_pkt, value)                        \
+	SET_BITS_TO_LE_4BYTE(h2c_pkt + 0X04, 0, 8, value)
+#define PROBE_RSP_RSVDPAGE_GET_LOC_VAP4(h2c_pkt)                               \
+	LE_BITS_TO_4BYTE(h2c_pkt + 0X04, 8, 8)
+#define PROBE_RSP_RSVDPAGE_SET_LOC_VAP4(h2c_pkt, value)                        \
+	SET_BITS_TO_LE_4BYTE(h2c_pkt + 0X04, 8, 8, value)
+#define SINGLE_CHANNELSWITCH_GET_CMD_ID(h2c_pkt)                               \
+	LE_BITS_TO_4BYTE(h2c_pkt + 0X00, 0, 5)
+#define SINGLE_CHANNELSWITCH_SET_CMD_ID(h2c_pkt, value)                        \
+	SET_BITS_TO_LE_4BYTE(h2c_pkt + 0X00, 0, 5, value)
+#define SINGLE_CHANNELSWITCH_GET_CLASS(h2c_pkt)                                \
+	LE_BITS_TO_4BYTE(h2c_pkt + 0X00, 5, 3)
+#define SINGLE_CHANNELSWITCH_SET_CLASS(h2c_pkt, value)                         \
+	SET_BITS_TO_LE_4BYTE(h2c_pkt + 0X00, 5, 3, value)
+#define SINGLE_CHANNELSWITCH_GET_CHANNEL_NUM(h2c_pkt)                          \
+	LE_BITS_TO_4BYTE(h2c_pkt + 0X00, 8, 8)
+#define SINGLE_CHANNELSWITCH_SET_CHANNEL_NUM(h2c_pkt, value)                   \
+	SET_BITS_TO_LE_4BYTE(h2c_pkt + 0X00, 8, 8, value)
+#define SINGLE_CHANNELSWITCH_GET_BW(h2c_pkt)                                   \
+	LE_BITS_TO_4BYTE(h2c_pkt + 0X00, 16, 2)
+#define SINGLE_CHANNELSWITCH_SET_BW(h2c_pkt, value)                            \
+	SET_BITS_TO_LE_4BYTE(h2c_pkt + 0X00, 16, 2, value)
+#define SINGLE_CHANNELSWITCH_GET_BW40SC(h2c_pkt)                               \
+	LE_BITS_TO_4BYTE(h2c_pkt + 0X00, 18, 3)
+#define SINGLE_CHANNELSWITCH_SET_BW40SC(h2c_pkt, value)                        \
+	SET_BITS_TO_LE_4BYTE(h2c_pkt + 0X00, 18, 3, value)
+#define SINGLE_CHANNELSWITCH_GET_BW80SC(h2c_pkt)                               \
+	LE_BITS_TO_4BYTE(h2c_pkt + 0X00, 21, 3)
+#define SINGLE_CHANNELSWITCH_SET_BW80SC(h2c_pkt, value)                        \
+	SET_BITS_TO_LE_4BYTE(h2c_pkt + 0X00, 21, 3, value)
+#define SINGLE_CHANNELSWITCH_GET_RFE_TYPE(h2c_pkt)                             \
+	LE_BITS_TO_4BYTE(h2c_pkt + 0X00, 24, 4)
+#define SINGLE_CHANNELSWITCH_SET_RFE_TYPE(h2c_pkt, value)                      \
+	SET_BITS_TO_LE_4BYTE(h2c_pkt + 0X00, 24, 4, value)
+#define SINGLE_CHANNELSWITCH_V2_GET_CMD_ID(h2c_pkt)                            \
+	LE_BITS_TO_4BYTE(h2c_pkt + 0X00, 0, 5)
+#define SINGLE_CHANNELSWITCH_V2_SET_CMD_ID(h2c_pkt, value)                     \
+	SET_BITS_TO_LE_4BYTE(h2c_pkt + 0X00, 0, 5, value)
+#define SINGLE_CHANNELSWITCH_V2_GET_CLASS(h2c_pkt)                             \
+	LE_BITS_TO_4BYTE(h2c_pkt + 0X00, 5, 3)
+#define SINGLE_CHANNELSWITCH_V2_SET_CLASS(h2c_pkt, value)                      \
+	SET_BITS_TO_LE_4BYTE(h2c_pkt + 0X00, 5, 3, value)
+#define SINGLE_CHANNELSWITCH_V2_GET_CENTRAL_CH(h2c_pkt)                        \
+	LE_BITS_TO_4BYTE(h2c_pkt + 0X00, 8, 8)
+#define SINGLE_CHANNELSWITCH_V2_SET_CENTRAL_CH(h2c_pkt, value)                 \
+	SET_BITS_TO_LE_4BYTE(h2c_pkt + 0X00, 8, 8, value)
+#define SINGLE_CHANNELSWITCH_V2_GET_PRIMARY_CH_IDX(h2c_pkt)                    \
+	LE_BITS_TO_4BYTE(h2c_pkt + 0X00, 16, 4)
+#define SINGLE_CHANNELSWITCH_V2_SET_PRIMARY_CH_IDX(h2c_pkt, value)             \
+	SET_BITS_TO_LE_4BYTE(h2c_pkt + 0X00, 16, 4, value)
+#define SINGLE_CHANNELSWITCH_V2_GET_BW(h2c_pkt)                                \
+	LE_BITS_TO_4BYTE(h2c_pkt + 0X00, 20, 4)
+#define SINGLE_CHANNELSWITCH_V2_SET_BW(h2c_pkt, value)                         \
+	SET_BITS_TO_LE_4BYTE(h2c_pkt + 0X00, 20, 4, value)
+#define SET_PWR_MODE_GET_CMD_ID(h2c_pkt) LE_BITS_TO_4BYTE(h2c_pkt + 0X00, 0, 5)
+#define SET_PWR_MODE_SET_CMD_ID(h2c_pkt, value)                                \
+	SET_BITS_TO_LE_4BYTE(h2c_pkt + 0X00, 0, 5, value)
+#define SET_PWR_MODE_GET_CLASS(h2c_pkt) LE_BITS_TO_4BYTE(h2c_pkt + 0X00, 5, 3)
+#define SET_PWR_MODE_SET_CLASS(h2c_pkt, value)                                 \
+	SET_BITS_TO_LE_4BYTE(h2c_pkt + 0X00, 5, 3, value)
+#define SET_PWR_MODE_GET_MODE(h2c_pkt) LE_BITS_TO_4BYTE(h2c_pkt + 0X00, 8, 7)
+#define SET_PWR_MODE_SET_MODE(h2c_pkt, value)                                  \
+	SET_BITS_TO_LE_4BYTE(h2c_pkt + 0X00, 8, 7, value)
+#define SET_PWR_MODE_GET_CLK_REQUEST(h2c_pkt)                                  \
+	LE_BITS_TO_4BYTE(h2c_pkt + 0X00, 15, 1)
+#define SET_PWR_MODE_SET_CLK_REQUEST(h2c_pkt, value)                           \
+	SET_BITS_TO_LE_4BYTE(h2c_pkt + 0X00, 15, 1, value)
+#define SET_PWR_MODE_GET_RLBM(h2c_pkt) LE_BITS_TO_4BYTE(h2c_pkt + 0X00, 16, 4)
+#define SET_PWR_MODE_SET_RLBM(h2c_pkt, value)                                  \
+	SET_BITS_TO_LE_4BYTE(h2c_pkt + 0X00, 16, 4, value)
+#define SET_PWR_MODE_GET_SMART_PS(h2c_pkt)                                     \
+	LE_BITS_TO_4BYTE(h2c_pkt + 0X00, 20, 4)
+#define SET_PWR_MODE_SET_SMART_PS(h2c_pkt, value)                              \
+	SET_BITS_TO_LE_4BYTE(h2c_pkt + 0X00, 20, 4, value)
+#define SET_PWR_MODE_GET_AWAKE_INTERVAL(h2c_pkt)                               \
+	LE_BITS_TO_4BYTE(h2c_pkt + 0X00, 24, 8)
+#define SET_PWR_MODE_SET_AWAKE_INTERVAL(h2c_pkt, value)                        \
+	SET_BITS_TO_LE_4BYTE(h2c_pkt + 0X00, 24, 8, value)
+#define SET_PWR_MODE_GET_B_ALL_QUEUE_UAPSD(h2c_pkt)                            \
+	LE_BITS_TO_4BYTE(h2c_pkt + 0X04, 0, 1)
+#define SET_PWR_MODE_SET_B_ALL_QUEUE_UAPSD(h2c_pkt, value)                     \
+	SET_BITS_TO_LE_4BYTE(h2c_pkt + 0X04, 0, 1, value)
+#define SET_PWR_MODE_GET_BCN_EARLY_RPT(h2c_pkt)                                \
+	LE_BITS_TO_4BYTE(h2c_pkt + 0X04, 2, 1)
+#define SET_PWR_MODE_SET_BCN_EARLY_RPT(h2c_pkt, value)                         \
+	SET_BITS_TO_LE_4BYTE(h2c_pkt + 0X04, 2, 1, value)
+#define SET_PWR_MODE_GET_PORT_ID(h2c_pkt) LE_BITS_TO_4BYTE(h2c_pkt + 0X04, 5, 3)
+#define SET_PWR_MODE_SET_PORT_ID(h2c_pkt, value)                               \
+	SET_BITS_TO_LE_4BYTE(h2c_pkt + 0X04, 5, 3, value)
+#define SET_PWR_MODE_GET_PWR_STATE(h2c_pkt)                                    \
+	LE_BITS_TO_4BYTE(h2c_pkt + 0X04, 8, 8)
+#define SET_PWR_MODE_SET_PWR_STATE(h2c_pkt, value)                             \
+	SET_BITS_TO_LE_4BYTE(h2c_pkt + 0X04, 8, 8, value)
+#define SET_PWR_MODE_GET_LOW_POWER_RX_BCN(h2c_pkt)                             \
+	LE_BITS_TO_4BYTE(h2c_pkt + 0X04, 16, 1)
+#define SET_PWR_MODE_SET_LOW_POWER_RX_BCN(h2c_pkt, value)                      \
+	SET_BITS_TO_LE_4BYTE(h2c_pkt + 0X04, 16, 1, value)
+#define SET_PWR_MODE_GET_ANT_AUTO_SWITCH(h2c_pkt)                              \
+	LE_BITS_TO_4BYTE(h2c_pkt + 0X04, 17, 1)
+#define SET_PWR_MODE_SET_ANT_AUTO_SWITCH(h2c_pkt, value)                       \
+	SET_BITS_TO_LE_4BYTE(h2c_pkt + 0X04, 17, 1, value)
+#define SET_PWR_MODE_GET_PS_ALLOW_BT_HIGH_PRIORITY(h2c_pkt)                    \
+	LE_BITS_TO_4BYTE(h2c_pkt + 0X04, 18, 1)
+#define SET_PWR_MODE_SET_PS_ALLOW_BT_HIGH_PRIORITY(h2c_pkt, value)             \
+	SET_BITS_TO_LE_4BYTE(h2c_pkt + 0X04, 18, 1, value)
+#define SET_PWR_MODE_GET_PROTECT_BCN(h2c_pkt)                                  \
+	LE_BITS_TO_4BYTE(h2c_pkt + 0X04, 19, 1)
+#define SET_PWR_MODE_SET_PROTECT_BCN(h2c_pkt, value)                           \
+	SET_BITS_TO_LE_4BYTE(h2c_pkt + 0X04, 19, 1, value)
+#define SET_PWR_MODE_GET_SILENCE_PERIOD(h2c_pkt)                               \
+	LE_BITS_TO_4BYTE(h2c_pkt + 0X04, 20, 1)
+#define SET_PWR_MODE_SET_SILENCE_PERIOD(h2c_pkt, value)                        \
+	SET_BITS_TO_LE_4BYTE(h2c_pkt + 0X04, 20, 1, value)
+#define SET_PWR_MODE_GET_FAST_BT_CONNECT(h2c_pkt)                              \
+	LE_BITS_TO_4BYTE(h2c_pkt + 0X04, 21, 1)
+#define SET_PWR_MODE_SET_FAST_BT_CONNECT(h2c_pkt, value)                       \
+	SET_BITS_TO_LE_4BYTE(h2c_pkt + 0X04, 21, 1, value)
+#define SET_PWR_MODE_GET_TWO_ANTENNA_EN(h2c_pkt)                               \
+	LE_BITS_TO_4BYTE(h2c_pkt + 0X04, 22, 1)
+#define SET_PWR_MODE_SET_TWO_ANTENNA_EN(h2c_pkt, value)                        \
+	SET_BITS_TO_LE_4BYTE(h2c_pkt + 0X04, 22, 1, value)
+#define SET_PWR_MODE_GET_ADOPT_USER_SETTING(h2c_pkt)                           \
+	LE_BITS_TO_4BYTE(h2c_pkt + 0X04, 24, 1)
+#define SET_PWR_MODE_SET_ADOPT_USER_SETTING(h2c_pkt, value)                    \
+	SET_BITS_TO_LE_4BYTE(h2c_pkt + 0X04, 24, 1, value)
+#define SET_PWR_MODE_GET_DRV_BCN_EARLY_SHIFT(h2c_pkt)                          \
+	LE_BITS_TO_4BYTE(h2c_pkt + 0X04, 25, 3)
+#define SET_PWR_MODE_SET_DRV_BCN_EARLY_SHIFT(h2c_pkt, value)                   \
+	SET_BITS_TO_LE_4BYTE(h2c_pkt + 0X04, 25, 3, value)
+#define SET_PWR_MODE_GET_DRV_BCN_EARLY_SHIFT2(h2c_pkt)                         \
+	LE_BITS_TO_4BYTE(h2c_pkt + 0X04, 28, 4)
+#define SET_PWR_MODE_SET_DRV_BCN_EARLY_SHIFT2(h2c_pkt, value)                  \
+	SET_BITS_TO_LE_4BYTE(h2c_pkt + 0X04, 28, 4, value)
+#define PS_TUNING_PARA_GET_CMD_ID(h2c_pkt)                                     \
+	LE_BITS_TO_4BYTE(h2c_pkt + 0X00, 0, 5)
+#define PS_TUNING_PARA_SET_CMD_ID(h2c_pkt, value)                              \
+	SET_BITS_TO_LE_4BYTE(h2c_pkt + 0X00, 0, 5, value)
+#define PS_TUNING_PARA_GET_CLASS(h2c_pkt) LE_BITS_TO_4BYTE(h2c_pkt + 0X00, 5, 3)
+#define PS_TUNING_PARA_SET_CLASS(h2c_pkt, value)                               \
+	SET_BITS_TO_LE_4BYTE(h2c_pkt + 0X00, 5, 3, value)
+#define PS_TUNING_PARA_GET_BCN_TO_LIMIT(h2c_pkt)                               \
+	LE_BITS_TO_4BYTE(h2c_pkt + 0X00, 8, 7)
+#define PS_TUNING_PARA_SET_BCN_TO_LIMIT(h2c_pkt, value)                        \
+	SET_BITS_TO_LE_4BYTE(h2c_pkt + 0X00, 8, 7, value)
+#define PS_TUNING_PARA_GET_DTIM_TIME_OUT(h2c_pkt)                              \
+	LE_BITS_TO_4BYTE(h2c_pkt + 0X00, 15, 1)
+#define PS_TUNING_PARA_SET_DTIM_TIME_OUT(h2c_pkt, value)                       \
+	SET_BITS_TO_LE_4BYTE(h2c_pkt + 0X00, 15, 1, value)
+#define PS_TUNING_PARA_GET_PS_TIME_OUT(h2c_pkt)                                \
+	LE_BITS_TO_4BYTE(h2c_pkt + 0X00, 16, 4)
+#define PS_TUNING_PARA_SET_PS_TIME_OUT(h2c_pkt, value)                         \
+	SET_BITS_TO_LE_4BYTE(h2c_pkt + 0X00, 16, 4, value)
+#define PS_TUNING_PARA_GET_ADOPT(h2c_pkt)                                      \
+	LE_BITS_TO_4BYTE(h2c_pkt + 0X00, 24, 8)
+#define PS_TUNING_PARA_SET_ADOPT(h2c_pkt, value)                               \
+	SET_BITS_TO_LE_4BYTE(h2c_pkt + 0X00, 24, 8, value)
+#define PS_TUNING_PARA_II_GET_CMD_ID(h2c_pkt)                                  \
+	LE_BITS_TO_4BYTE(h2c_pkt + 0X00, 0, 5)
+#define PS_TUNING_PARA_II_SET_CMD_ID(h2c_pkt, value)                           \
+	SET_BITS_TO_LE_4BYTE(h2c_pkt + 0X00, 0, 5, value)
+#define PS_TUNING_PARA_II_GET_CLASS(h2c_pkt)                                   \
+	LE_BITS_TO_4BYTE(h2c_pkt + 0X00, 5, 3)
+#define PS_TUNING_PARA_II_SET_CLASS(h2c_pkt, value)                            \
+	SET_BITS_TO_LE_4BYTE(h2c_pkt + 0X00, 5, 3, value)
+#define PS_TUNING_PARA_II_GET_BCN_TO_PERIOD(h2c_pkt)                           \
+	LE_BITS_TO_4BYTE(h2c_pkt + 0X00, 8, 7)
+#define PS_TUNING_PARA_II_SET_BCN_TO_PERIOD(h2c_pkt, value)                    \
+	SET_BITS_TO_LE_4BYTE(h2c_pkt + 0X00, 8, 7, value)
+#define PS_TUNING_PARA_II_GET_ADOPT(h2c_pkt)                                   \
+	LE_BITS_TO_4BYTE(h2c_pkt + 0X00, 15, 1)
+#define PS_TUNING_PARA_II_SET_ADOPT(h2c_pkt, value)                            \
+	SET_BITS_TO_LE_4BYTE(h2c_pkt + 0X00, 15, 1, value)
+#define PS_TUNING_PARA_II_GET_DRV_EARLY_IVL(h2c_pkt)                           \
+	LE_BITS_TO_4BYTE(h2c_pkt + 0X00, 16, 8)
+#define PS_TUNING_PARA_II_SET_DRV_EARLY_IVL(h2c_pkt, value)                    \
+	SET_BITS_TO_LE_4BYTE(h2c_pkt + 0X00, 16, 8, value)
+#define PS_LPS_PARA_GET_CMD_ID(h2c_pkt) LE_BITS_TO_4BYTE(h2c_pkt + 0X00, 0, 5)
+#define PS_LPS_PARA_SET_CMD_ID(h2c_pkt, value)                                 \
+	SET_BITS_TO_LE_4BYTE(h2c_pkt + 0X00, 0, 5, value)
+#define PS_LPS_PARA_GET_CLASS(h2c_pkt) LE_BITS_TO_4BYTE(h2c_pkt + 0X00, 5, 3)
+#define PS_LPS_PARA_SET_CLASS(h2c_pkt, value)                                  \
+	SET_BITS_TO_LE_4BYTE(h2c_pkt + 0X00, 5, 3, value)
+#define PS_LPS_PARA_GET_LPS_CONTROL(h2c_pkt)                                   \
+	LE_BITS_TO_4BYTE(h2c_pkt + 0X00, 8, 8)
+#define PS_LPS_PARA_SET_LPS_CONTROL(h2c_pkt, value)                            \
+	SET_BITS_TO_LE_4BYTE(h2c_pkt + 0X00, 8, 8, value)
+#define P2P_PS_OFFLOAD_GET_CMD_ID(h2c_pkt)                                     \
+	LE_BITS_TO_4BYTE(h2c_pkt + 0X00, 0, 5)
+#define P2P_PS_OFFLOAD_SET_CMD_ID(h2c_pkt, value)                              \
+	SET_BITS_TO_LE_4BYTE(h2c_pkt + 0X00, 0, 5, value)
+#define P2P_PS_OFFLOAD_GET_CLASS(h2c_pkt) LE_BITS_TO_4BYTE(h2c_pkt + 0X00, 5, 3)
+#define P2P_PS_OFFLOAD_SET_CLASS(h2c_pkt, value)                               \
+	SET_BITS_TO_LE_4BYTE(h2c_pkt + 0X00, 5, 3, value)
+#define P2P_PS_OFFLOAD_GET_OFFLOAD_EN(h2c_pkt)                                 \
+	LE_BITS_TO_4BYTE(h2c_pkt + 0X00, 8, 1)
+#define P2P_PS_OFFLOAD_SET_OFFLOAD_EN(h2c_pkt, value)                          \
+	SET_BITS_TO_LE_4BYTE(h2c_pkt + 0X00, 8, 1, value)
+#define P2P_PS_OFFLOAD_GET_ROLE(h2c_pkt) LE_BITS_TO_4BYTE(h2c_pkt + 0X00, 9, 1)
+#define P2P_PS_OFFLOAD_SET_ROLE(h2c_pkt, value)                                \
+	SET_BITS_TO_LE_4BYTE(h2c_pkt + 0X00, 9, 1, value)
+#define P2P_PS_OFFLOAD_GET_CTWINDOW_EN(h2c_pkt)                                \
+	LE_BITS_TO_4BYTE(h2c_pkt + 0X00, 10, 1)
+#define P2P_PS_OFFLOAD_SET_CTWINDOW_EN(h2c_pkt, value)                         \
+	SET_BITS_TO_LE_4BYTE(h2c_pkt + 0X00, 10, 1, value)
+#define P2P_PS_OFFLOAD_GET_NOA0_EN(h2c_pkt)                                    \
+	LE_BITS_TO_4BYTE(h2c_pkt + 0X00, 11, 1)
+#define P2P_PS_OFFLOAD_SET_NOA0_EN(h2c_pkt, value)                             \
+	SET_BITS_TO_LE_4BYTE(h2c_pkt + 0X00, 11, 1, value)
+#define P2P_PS_OFFLOAD_GET_NOA1_EN(h2c_pkt)                                    \
+	LE_BITS_TO_4BYTE(h2c_pkt + 0X00, 12, 1)
+#define P2P_PS_OFFLOAD_SET_NOA1_EN(h2c_pkt, value)                             \
+	SET_BITS_TO_LE_4BYTE(h2c_pkt + 0X00, 12, 1, value)
+#define P2P_PS_OFFLOAD_GET_ALL_STA_SLEEP(h2c_pkt)                              \
+	LE_BITS_TO_4BYTE(h2c_pkt + 0X00, 13, 1)
+#define P2P_PS_OFFLOAD_SET_ALL_STA_SLEEP(h2c_pkt, value)                       \
+	SET_BITS_TO_LE_4BYTE(h2c_pkt + 0X00, 13, 1, value)
+#define P2P_PS_OFFLOAD_GET_DISCOVERY(h2c_pkt)                                  \
+	LE_BITS_TO_4BYTE(h2c_pkt + 0X00, 14, 1)
+#define P2P_PS_OFFLOAD_SET_DISCOVERY(h2c_pkt, value)                           \
+	SET_BITS_TO_LE_4BYTE(h2c_pkt + 0X00, 14, 1, value)
+#define PS_SCAN_EN_GET_CMD_ID(h2c_pkt) LE_BITS_TO_4BYTE(h2c_pkt + 0X00, 0, 5)
+#define PS_SCAN_EN_SET_CMD_ID(h2c_pkt, value)                                  \
+	SET_BITS_TO_LE_4BYTE(h2c_pkt + 0X00, 0, 5, value)
+#define PS_SCAN_EN_GET_CLASS(h2c_pkt) LE_BITS_TO_4BYTE(h2c_pkt + 0X00, 5, 3)
+#define PS_SCAN_EN_SET_CLASS(h2c_pkt, value)                                   \
+	SET_BITS_TO_LE_4BYTE(h2c_pkt + 0X00, 5, 3, value)
+#define PS_SCAN_EN_GET_ENABLE(h2c_pkt) LE_BITS_TO_4BYTE(h2c_pkt + 0X00, 8, 1)
+#define PS_SCAN_EN_SET_ENABLE(h2c_pkt, value)                                  \
+	SET_BITS_TO_LE_4BYTE(h2c_pkt + 0X00, 8, 1, value)
+#define SAP_PS_GET_CMD_ID(h2c_pkt) LE_BITS_TO_4BYTE(h2c_pkt + 0X00, 0, 5)
+#define SAP_PS_SET_CMD_ID(h2c_pkt, value)                                      \
+	SET_BITS_TO_LE_4BYTE(h2c_pkt + 0X00, 0, 5, value)
+#define SAP_PS_GET_CLASS(h2c_pkt) LE_BITS_TO_4BYTE(h2c_pkt + 0X00, 5, 3)
+#define SAP_PS_SET_CLASS(h2c_pkt, value)                                       \
+	SET_BITS_TO_LE_4BYTE(h2c_pkt + 0X00, 5, 3, value)
+#define SAP_PS_GET_ENABLE(h2c_pkt) LE_BITS_TO_4BYTE(h2c_pkt + 0X00, 8, 1)
+#define SAP_PS_SET_ENABLE(h2c_pkt, value)                                      \
+	SET_BITS_TO_LE_4BYTE(h2c_pkt + 0X00, 8, 1, value)
+#define SAP_PS_GET_EN_PS(h2c_pkt) LE_BITS_TO_4BYTE(h2c_pkt + 0X00, 9, 1)
+#define SAP_PS_SET_EN_PS(h2c_pkt, value)                                       \
+	SET_BITS_TO_LE_4BYTE(h2c_pkt + 0X00, 9, 1, value)
+#define SAP_PS_GET_EN_LP_RX(h2c_pkt) LE_BITS_TO_4BYTE(h2c_pkt + 0X00, 10, 1)
+#define SAP_PS_SET_EN_LP_RX(h2c_pkt, value)                                    \
+	SET_BITS_TO_LE_4BYTE(h2c_pkt + 0X00, 10, 1, value)
+#define SAP_PS_GET_MANUAL_32K(h2c_pkt) LE_BITS_TO_4BYTE(h2c_pkt + 0X00, 11, 1)
+#define SAP_PS_SET_MANUAL_32K(h2c_pkt, value)                                  \
+	SET_BITS_TO_LE_4BYTE(h2c_pkt + 0X00, 11, 1, value)
+#define SAP_PS_GET_DURATION(h2c_pkt) LE_BITS_TO_4BYTE(h2c_pkt + 0X00, 16, 8)
+#define SAP_PS_SET_DURATION(h2c_pkt, value)                                    \
+	SET_BITS_TO_LE_4BYTE(h2c_pkt + 0X00, 16, 8, value)
+#define INACTIVE_PS_GET_CMD_ID(h2c_pkt) LE_BITS_TO_4BYTE(h2c_pkt + 0X00, 0, 5)
+#define INACTIVE_PS_SET_CMD_ID(h2c_pkt, value)                                 \
+	SET_BITS_TO_LE_4BYTE(h2c_pkt + 0X00, 0, 5, value)
+#define INACTIVE_PS_GET_CLASS(h2c_pkt) LE_BITS_TO_4BYTE(h2c_pkt + 0X00, 5, 3)
+#define INACTIVE_PS_SET_CLASS(h2c_pkt, value)                                  \
+	SET_BITS_TO_LE_4BYTE(h2c_pkt + 0X00, 5, 3, value)
+#define INACTIVE_PS_GET_ENABLE(h2c_pkt) LE_BITS_TO_4BYTE(h2c_pkt + 0X00, 8, 1)
+#define INACTIVE_PS_SET_ENABLE(h2c_pkt, value)                                 \
+	SET_BITS_TO_LE_4BYTE(h2c_pkt + 0X00, 8, 1, value)
+#define INACTIVE_PS_GET_IGNORE_PS_CONDITION(h2c_pkt)                           \
+	LE_BITS_TO_4BYTE(h2c_pkt + 0X00, 9, 1)
+#define INACTIVE_PS_SET_IGNORE_PS_CONDITION(h2c_pkt, value)                    \
+	SET_BITS_TO_LE_4BYTE(h2c_pkt + 0X00, 9, 1, value)
+#define INACTIVE_PS_GET_FREQUENCY(h2c_pkt)                                     \
+	LE_BITS_TO_4BYTE(h2c_pkt + 0X00, 16, 8)
+#define INACTIVE_PS_SET_FREQUENCY(h2c_pkt, value)                              \
+	SET_BITS_TO_LE_4BYTE(h2c_pkt + 0X00, 16, 8, value)
+#define INACTIVE_PS_GET_DURATION(h2c_pkt)                                      \
+	LE_BITS_TO_4BYTE(h2c_pkt + 0X00, 24, 8)
+#define INACTIVE_PS_SET_DURATION(h2c_pkt, value)                               \
+	SET_BITS_TO_LE_4BYTE(h2c_pkt + 0X00, 24, 8, value)
+#define MACID_CFG_GET_CMD_ID(h2c_pkt) LE_BITS_TO_4BYTE(h2c_pkt + 0X00, 0, 5)
+#define MACID_CFG_SET_CMD_ID(h2c_pkt, value)                                   \
+	SET_BITS_TO_LE_4BYTE(h2c_pkt + 0X00, 0, 5, value)
+#define MACID_CFG_GET_CLASS(h2c_pkt) LE_BITS_TO_4BYTE(h2c_pkt + 0X00, 5, 3)
+#define MACID_CFG_SET_CLASS(h2c_pkt, value)                                    \
+	SET_BITS_TO_LE_4BYTE(h2c_pkt + 0X00, 5, 3, value)
+#define MACID_CFG_GET_MAC_ID(h2c_pkt) LE_BITS_TO_4BYTE(h2c_pkt + 0X00, 8, 8)
+#define MACID_CFG_SET_MAC_ID(h2c_pkt, value)                                   \
+	SET_BITS_TO_LE_4BYTE(h2c_pkt + 0X00, 8, 8, value)
+#define MACID_CFG_GET_RATE_ID(h2c_pkt) LE_BITS_TO_4BYTE(h2c_pkt + 0X00, 16, 5)
+#define MACID_CFG_SET_RATE_ID(h2c_pkt, value)                                  \
+	SET_BITS_TO_LE_4BYTE(h2c_pkt + 0X00, 16, 5, value)
+#define MACID_CFG_GET_INIT_RATE_LV(h2c_pkt)                                    \
+	LE_BITS_TO_4BYTE(h2c_pkt + 0X00, 21, 2)
+#define MACID_CFG_SET_INIT_RATE_LV(h2c_pkt, value)                             \
+	SET_BITS_TO_LE_4BYTE(h2c_pkt + 0X00, 21, 2, value)
+#define MACID_CFG_GET_SGI(h2c_pkt) LE_BITS_TO_4BYTE(h2c_pkt + 0X00, 23, 1)
+#define MACID_CFG_SET_SGI(h2c_pkt, value)                                      \
+	SET_BITS_TO_LE_4BYTE(h2c_pkt + 0X00, 23, 1, value)
+#define MACID_CFG_GET_BW(h2c_pkt) LE_BITS_TO_4BYTE(h2c_pkt + 0X00, 24, 2)
+#define MACID_CFG_SET_BW(h2c_pkt, value)                                       \
+	SET_BITS_TO_LE_4BYTE(h2c_pkt + 0X00, 24, 2, value)
+#define MACID_CFG_GET_LDPC_CAP(h2c_pkt) LE_BITS_TO_4BYTE(h2c_pkt + 0X00, 26, 1)
+#define MACID_CFG_SET_LDPC_CAP(h2c_pkt, value)                                 \
+	SET_BITS_TO_LE_4BYTE(h2c_pkt + 0X00, 26, 1, value)
+#define MACID_CFG_GET_NO_UPDATE(h2c_pkt) LE_BITS_TO_4BYTE(h2c_pkt + 0X00, 27, 1)
+#define MACID_CFG_SET_NO_UPDATE(h2c_pkt, value)                                \
+	SET_BITS_TO_LE_4BYTE(h2c_pkt + 0X00, 27, 1, value)
+#define MACID_CFG_GET_WHT_EN(h2c_pkt) LE_BITS_TO_4BYTE(h2c_pkt + 0X00, 28, 2)
+#define MACID_CFG_SET_WHT_EN(h2c_pkt, value)                                   \
+	SET_BITS_TO_LE_4BYTE(h2c_pkt + 0X00, 28, 2, value)
+#define MACID_CFG_GET_DISPT(h2c_pkt) LE_BITS_TO_4BYTE(h2c_pkt + 0X00, 30, 1)
+#define MACID_CFG_SET_DISPT(h2c_pkt, value)                                    \
+	SET_BITS_TO_LE_4BYTE(h2c_pkt + 0X00, 30, 1, value)
+#define MACID_CFG_GET_DISRA(h2c_pkt) LE_BITS_TO_4BYTE(h2c_pkt + 0X00, 31, 1)
+#define MACID_CFG_SET_DISRA(h2c_pkt, value)                                    \
+	SET_BITS_TO_LE_4BYTE(h2c_pkt + 0X00, 31, 1, value)
+#define MACID_CFG_GET_RATE_MASK7_0(h2c_pkt)                                    \
+	LE_BITS_TO_4BYTE(h2c_pkt + 0X04, 0, 8)
+#define MACID_CFG_SET_RATE_MASK7_0(h2c_pkt, value)                             \
+	SET_BITS_TO_LE_4BYTE(h2c_pkt + 0X04, 0, 8, value)
+#define MACID_CFG_GET_RATE_MASK15_8(h2c_pkt)                                   \
+	LE_BITS_TO_4BYTE(h2c_pkt + 0X04, 8, 8)
+#define MACID_CFG_SET_RATE_MASK15_8(h2c_pkt, value)                            \
+	SET_BITS_TO_LE_4BYTE(h2c_pkt + 0X04, 8, 8, value)
+#define MACID_CFG_GET_RATE_MASK23_16(h2c_pkt)                                  \
+	LE_BITS_TO_4BYTE(h2c_pkt + 0X04, 16, 8)
+#define MACID_CFG_SET_RATE_MASK23_16(h2c_pkt, value)                           \
+	SET_BITS_TO_LE_4BYTE(h2c_pkt + 0X04, 16, 8, value)
+#define MACID_CFG_GET_RATE_MASK31_24(h2c_pkt)                                  \
+	LE_BITS_TO_4BYTE(h2c_pkt + 0X04, 24, 8)
+#define MACID_CFG_SET_RATE_MASK31_24(h2c_pkt, value)                           \
+	SET_BITS_TO_LE_4BYTE(h2c_pkt + 0X04, 24, 8, value)
+#define TXBF_GET_CMD_ID(h2c_pkt) LE_BITS_TO_4BYTE(h2c_pkt + 0X00, 0, 5)
+#define TXBF_SET_CMD_ID(h2c_pkt, value)                                        \
+	SET_BITS_TO_LE_4BYTE(h2c_pkt + 0X00, 0, 5, value)
+#define TXBF_GET_CLASS(h2c_pkt) LE_BITS_TO_4BYTE(h2c_pkt + 0X00, 5, 3)
+#define TXBF_SET_CLASS(h2c_pkt, value)                                         \
+	SET_BITS_TO_LE_4BYTE(h2c_pkt + 0X00, 5, 3, value)
+#define TXBF_GET_NDPA0_HEAD_PAGE(h2c_pkt) LE_BITS_TO_4BYTE(h2c_pkt + 0X00, 8, 8)
+#define TXBF_SET_NDPA0_HEAD_PAGE(h2c_pkt, value)                               \
+	SET_BITS_TO_LE_4BYTE(h2c_pkt + 0X00, 8, 8, value)
+#define TXBF_GET_NDPA1_HEAD_PAGE(h2c_pkt)                                      \
+	LE_BITS_TO_4BYTE(h2c_pkt + 0X00, 16, 8)
+#define TXBF_SET_NDPA1_HEAD_PAGE(h2c_pkt, value)                               \
+	SET_BITS_TO_LE_4BYTE(h2c_pkt + 0X00, 16, 8, value)
+#define TXBF_GET_PERIOD_0(h2c_pkt) LE_BITS_TO_4BYTE(h2c_pkt + 0X00, 24, 8)
+#define TXBF_SET_PERIOD_0(h2c_pkt, value)                                      \
+	SET_BITS_TO_LE_4BYTE(h2c_pkt + 0X00, 24, 8, value)
+#define RSSI_SETTING_GET_CMD_ID(h2c_pkt) LE_BITS_TO_4BYTE(h2c_pkt + 0X00, 0, 5)
+#define RSSI_SETTING_SET_CMD_ID(h2c_pkt, value)                                \
+	SET_BITS_TO_LE_4BYTE(h2c_pkt + 0X00, 0, 5, value)
+#define RSSI_SETTING_GET_CLASS(h2c_pkt) LE_BITS_TO_4BYTE(h2c_pkt + 0X00, 5, 3)
+#define RSSI_SETTING_SET_CLASS(h2c_pkt, value)                                 \
+	SET_BITS_TO_LE_4BYTE(h2c_pkt + 0X00, 5, 3, value)
+#define RSSI_SETTING_GET_MAC_ID(h2c_pkt) LE_BITS_TO_4BYTE(h2c_pkt + 0X00, 8, 8)
+#define RSSI_SETTING_SET_MAC_ID(h2c_pkt, value)                                \
+	SET_BITS_TO_LE_4BYTE(h2c_pkt + 0X00, 8, 8, value)
+#define RSSI_SETTING_GET_RSSI(h2c_pkt) LE_BITS_TO_4BYTE(h2c_pkt + 0X00, 24, 7)
+#define RSSI_SETTING_SET_RSSI(h2c_pkt, value)                                  \
+	SET_BITS_TO_LE_4BYTE(h2c_pkt + 0X00, 24, 7, value)
+#define RSSI_SETTING_GET_RA_INFO(h2c_pkt) LE_BITS_TO_4BYTE(h2c_pkt + 0X04, 0, 8)
+#define RSSI_SETTING_SET_RA_INFO(h2c_pkt, value)                               \
+	SET_BITS_TO_LE_4BYTE(h2c_pkt + 0X04, 0, 8, value)
+#define AP_REQ_TXRPT_GET_CMD_ID(h2c_pkt) LE_BITS_TO_4BYTE(h2c_pkt + 0X00, 0, 5)
+#define AP_REQ_TXRPT_SET_CMD_ID(h2c_pkt, value)                                \
+	SET_BITS_TO_LE_4BYTE(h2c_pkt + 0X00, 0, 5, value)
+#define AP_REQ_TXRPT_GET_CLASS(h2c_pkt) LE_BITS_TO_4BYTE(h2c_pkt + 0X00, 5, 3)
+#define AP_REQ_TXRPT_SET_CLASS(h2c_pkt, value)                                 \
+	SET_BITS_TO_LE_4BYTE(h2c_pkt + 0X00, 5, 3, value)
+#define AP_REQ_TXRPT_GET_STA1_MACID(h2c_pkt)                                   \
+	LE_BITS_TO_4BYTE(h2c_pkt + 0X00, 8, 8)
+#define AP_REQ_TXRPT_SET_STA1_MACID(h2c_pkt, value)                            \
+	SET_BITS_TO_LE_4BYTE(h2c_pkt + 0X00, 8, 8, value)
+#define AP_REQ_TXRPT_GET_STA2_MACID(h2c_pkt)                                   \
+	LE_BITS_TO_4BYTE(h2c_pkt + 0X00, 16, 8)
+#define AP_REQ_TXRPT_SET_STA2_MACID(h2c_pkt, value)                            \
+	SET_BITS_TO_LE_4BYTE(h2c_pkt + 0X00, 16, 8, value)
+#define AP_REQ_TXRPT_GET_RTY_OK_TOTAL(h2c_pkt)                                 \
+	LE_BITS_TO_4BYTE(h2c_pkt + 0X00, 24, 1)
+#define AP_REQ_TXRPT_SET_RTY_OK_TOTAL(h2c_pkt, value)                          \
+	SET_BITS_TO_LE_4BYTE(h2c_pkt + 0X00, 24, 1, value)
+#define AP_REQ_TXRPT_GET_RTY_CNT_MACID(h2c_pkt)                                \
+	LE_BITS_TO_4BYTE(h2c_pkt + 0X00, 25, 1)
+#define AP_REQ_TXRPT_SET_RTY_CNT_MACID(h2c_pkt, value)                         \
+	SET_BITS_TO_LE_4BYTE(h2c_pkt + 0X00, 25, 1, value)
+#define INIT_RATE_COLLECTION_GET_CMD_ID(h2c_pkt)                               \
+	LE_BITS_TO_4BYTE(h2c_pkt + 0X00, 0, 5)
+#define INIT_RATE_COLLECTION_SET_CMD_ID(h2c_pkt, value)                        \
+	SET_BITS_TO_LE_4BYTE(h2c_pkt + 0X00, 0, 5, value)
+#define INIT_RATE_COLLECTION_GET_CLASS(h2c_pkt)                                \
+	LE_BITS_TO_4BYTE(h2c_pkt + 0X00, 5, 3)
+#define INIT_RATE_COLLECTION_SET_CLASS(h2c_pkt, value)                         \
+	SET_BITS_TO_LE_4BYTE(h2c_pkt + 0X00, 5, 3, value)
+#define INIT_RATE_COLLECTION_GET_STA1_MACID(h2c_pkt)                           \
+	LE_BITS_TO_4BYTE(h2c_pkt + 0X00, 8, 8)
+#define INIT_RATE_COLLECTION_SET_STA1_MACID(h2c_pkt, value)                    \
+	SET_BITS_TO_LE_4BYTE(h2c_pkt + 0X00, 8, 8, value)
+#define INIT_RATE_COLLECTION_GET_STA2_MACID(h2c_pkt)                           \
+	LE_BITS_TO_4BYTE(h2c_pkt + 0X00, 16, 8)
+#define INIT_RATE_COLLECTION_SET_STA2_MACID(h2c_pkt, value)                    \
+	SET_BITS_TO_LE_4BYTE(h2c_pkt + 0X00, 16, 8, value)
+#define INIT_RATE_COLLECTION_GET_STA3_MACID(h2c_pkt)                           \
+	LE_BITS_TO_4BYTE(h2c_pkt + 0X00, 24, 8)
+#define INIT_RATE_COLLECTION_SET_STA3_MACID(h2c_pkt, value)                    \
+	SET_BITS_TO_LE_4BYTE(h2c_pkt + 0X00, 24, 8, value)
+#define INIT_RATE_COLLECTION_GET_STA4_MACID(h2c_pkt)                           \
+	LE_BITS_TO_4BYTE(h2c_pkt + 0X04, 0, 8)
+#define INIT_RATE_COLLECTION_SET_STA4_MACID(h2c_pkt, value)                    \
+	SET_BITS_TO_LE_4BYTE(h2c_pkt + 0X04, 0, 8, value)
+#define INIT_RATE_COLLECTION_GET_STA5_MACID(h2c_pkt)                           \
+	LE_BITS_TO_4BYTE(h2c_pkt + 0X04, 8, 8)
+#define INIT_RATE_COLLECTION_SET_STA5_MACID(h2c_pkt, value)                    \
+	SET_BITS_TO_LE_4BYTE(h2c_pkt + 0X04, 8, 8, value)
+#define INIT_RATE_COLLECTION_GET_STA6_MACID(h2c_pkt)                           \
+	LE_BITS_TO_4BYTE(h2c_pkt + 0X04, 16, 8)
+#define INIT_RATE_COLLECTION_SET_STA6_MACID(h2c_pkt, value)                    \
+	SET_BITS_TO_LE_4BYTE(h2c_pkt + 0X04, 16, 8, value)
+#define INIT_RATE_COLLECTION_GET_STA7_MACID(h2c_pkt)                           \
+	LE_BITS_TO_4BYTE(h2c_pkt + 0X04, 24, 8)
+#define INIT_RATE_COLLECTION_SET_STA7_MACID(h2c_pkt, value)                    \
+	SET_BITS_TO_LE_4BYTE(h2c_pkt + 0X04, 24, 8, value)
+#define IQK_OFFLOAD_GET_CMD_ID(h2c_pkt) LE_BITS_TO_4BYTE(h2c_pkt + 0X00, 0, 5)
+#define IQK_OFFLOAD_SET_CMD_ID(h2c_pkt, value)                                 \
+	SET_BITS_TO_LE_4BYTE(h2c_pkt + 0X00, 0, 5, value)
+#define IQK_OFFLOAD_GET_CLASS(h2c_pkt) LE_BITS_TO_4BYTE(h2c_pkt + 0X00, 5, 3)
+#define IQK_OFFLOAD_SET_CLASS(h2c_pkt, value)                                  \
+	SET_BITS_TO_LE_4BYTE(h2c_pkt + 0X00, 5, 3, value)
+#define IQK_OFFLOAD_GET_CHANNEL(h2c_pkt) LE_BITS_TO_4BYTE(h2c_pkt + 0X00, 8, 8)
+#define IQK_OFFLOAD_SET_CHANNEL(h2c_pkt, value)                                \
+	SET_BITS_TO_LE_4BYTE(h2c_pkt + 0X00, 8, 8, value)
+#define IQK_OFFLOAD_GET_BWBAND(h2c_pkt) LE_BITS_TO_4BYTE(h2c_pkt + 0X00, 16, 8)
+#define IQK_OFFLOAD_SET_BWBAND(h2c_pkt, value)                                 \
+	SET_BITS_TO_LE_4BYTE(h2c_pkt + 0X00, 16, 8, value)
+#define IQK_OFFLOAD_GET_EXTPALNA(h2c_pkt)                                      \
+	LE_BITS_TO_4BYTE(h2c_pkt + 0X00, 24, 8)
+#define IQK_OFFLOAD_SET_EXTPALNA(h2c_pkt, value)                               \
+	SET_BITS_TO_LE_4BYTE(h2c_pkt + 0X00, 24, 8, value)
+#define MACID_CFG_3SS_GET_CMD_ID(h2c_pkt) LE_BITS_TO_4BYTE(h2c_pkt + 0X00, 0, 5)
+#define MACID_CFG_3SS_SET_CMD_ID(h2c_pkt, value)                               \
+	SET_BITS_TO_LE_4BYTE(h2c_pkt + 0X00, 0, 5, value)
+#define MACID_CFG_3SS_GET_CLASS(h2c_pkt) LE_BITS_TO_4BYTE(h2c_pkt + 0X00, 5, 3)
+#define MACID_CFG_3SS_SET_CLASS(h2c_pkt, value)                                \
+	SET_BITS_TO_LE_4BYTE(h2c_pkt + 0X00, 5, 3, value)
+#define MACID_CFG_3SS_GET_MACID(h2c_pkt) LE_BITS_TO_4BYTE(h2c_pkt + 0X00, 8, 8)
+#define MACID_CFG_3SS_SET_MACID(h2c_pkt, value)                                \
+	SET_BITS_TO_LE_4BYTE(h2c_pkt + 0X00, 8, 8, value)
+#define MACID_CFG_3SS_GET_RATE_MASK_39_32(h2c_pkt)                             \
+	LE_BITS_TO_4BYTE(h2c_pkt + 0X04, 0, 8)
+#define MACID_CFG_3SS_SET_RATE_MASK_39_32(h2c_pkt, value)                      \
+	SET_BITS_TO_LE_4BYTE(h2c_pkt + 0X04, 0, 8, value)
+#define MACID_CFG_3SS_GET_RATE_MASK_47_40(h2c_pkt)                             \
+	LE_BITS_TO_4BYTE(h2c_pkt + 0X04, 8, 8)
+#define MACID_CFG_3SS_SET_RATE_MASK_47_40(h2c_pkt, value)                      \
+	SET_BITS_TO_LE_4BYTE(h2c_pkt + 0X04, 8, 8, value)
+#define RA_PARA_ADJUST_GET_CMD_ID(h2c_pkt)                                     \
+	LE_BITS_TO_4BYTE(h2c_pkt + 0X00, 0, 5)
+#define RA_PARA_ADJUST_SET_CMD_ID(h2c_pkt, value)                              \
+	SET_BITS_TO_LE_4BYTE(h2c_pkt + 0X00, 0, 5, value)
+#define RA_PARA_ADJUST_GET_CLASS(h2c_pkt) LE_BITS_TO_4BYTE(h2c_pkt + 0X00, 5, 3)
+#define RA_PARA_ADJUST_SET_CLASS(h2c_pkt, value)                               \
+	SET_BITS_TO_LE_4BYTE(h2c_pkt + 0X00, 5, 3, value)
+#define RA_PARA_ADJUST_GET_MAC_ID(h2c_pkt)                                     \
+	LE_BITS_TO_4BYTE(h2c_pkt + 0X00, 8, 8)
+#define RA_PARA_ADJUST_SET_MAC_ID(h2c_pkt, value)                              \
+	SET_BITS_TO_LE_4BYTE(h2c_pkt + 0X00, 8, 8, value)
+#define RA_PARA_ADJUST_GET_PARAMETER_INDEX(h2c_pkt)                            \
+	LE_BITS_TO_4BYTE(h2c_pkt + 0X00, 16, 8)
+#define RA_PARA_ADJUST_SET_PARAMETER_INDEX(h2c_pkt, value)                     \
+	SET_BITS_TO_LE_4BYTE(h2c_pkt + 0X00, 16, 8, value)
+#define RA_PARA_ADJUST_GET_RATE_ID(h2c_pkt)                                    \
+	LE_BITS_TO_4BYTE(h2c_pkt + 0X00, 24, 8)
+#define RA_PARA_ADJUST_SET_RATE_ID(h2c_pkt, value)                             \
+	SET_BITS_TO_LE_4BYTE(h2c_pkt + 0X00, 24, 8, value)
+#define RA_PARA_ADJUST_GET_VALUE_BYTE0(h2c_pkt)                                \
+	LE_BITS_TO_4BYTE(h2c_pkt + 0X04, 0, 8)
+#define RA_PARA_ADJUST_SET_VALUE_BYTE0(h2c_pkt, value)                         \
+	SET_BITS_TO_LE_4BYTE(h2c_pkt + 0X04, 0, 8, value)
+#define RA_PARA_ADJUST_GET_VALUE_BYTE1(h2c_pkt)                                \
+	LE_BITS_TO_4BYTE(h2c_pkt + 0X04, 8, 8)
+#define RA_PARA_ADJUST_SET_VALUE_BYTE1(h2c_pkt, value)                         \
+	SET_BITS_TO_LE_4BYTE(h2c_pkt + 0X04, 8, 8, value)
+#define RA_PARA_ADJUST_GET_ASK_FW_FOR_FW_PARA(h2c_pkt)                         \
+	LE_BITS_TO_4BYTE(h2c_pkt + 0X04, 16, 8)
+#define RA_PARA_ADJUST_SET_ASK_FW_FOR_FW_PARA(h2c_pkt, value)                  \
+	SET_BITS_TO_LE_4BYTE(h2c_pkt + 0X04, 16, 8, value)
+#define WWLAN_GET_CMD_ID(h2c_pkt) LE_BITS_TO_4BYTE(h2c_pkt + 0X00, 0, 5)
+#define WWLAN_SET_CMD_ID(h2c_pkt, value)                                       \
+	SET_BITS_TO_LE_4BYTE(h2c_pkt + 0X00, 0, 5, value)
+#define WWLAN_GET_CLASS(h2c_pkt) LE_BITS_TO_4BYTE(h2c_pkt + 0X00, 5, 3)
+#define WWLAN_SET_CLASS(h2c_pkt, value)                                        \
+	SET_BITS_TO_LE_4BYTE(h2c_pkt + 0X00, 5, 3, value)
+#define WWLAN_GET_FUNC_EN(h2c_pkt) LE_BITS_TO_4BYTE(h2c_pkt + 0X00, 8, 1)
+#define WWLAN_SET_FUNC_EN(h2c_pkt, value)                                      \
+	SET_BITS_TO_LE_4BYTE(h2c_pkt + 0X00, 8, 1, value)
+#define WWLAN_GET_PATTERM_MAT_EN(h2c_pkt) LE_BITS_TO_4BYTE(h2c_pkt + 0X00, 9, 1)
+#define WWLAN_SET_PATTERM_MAT_EN(h2c_pkt, value)                               \
+	SET_BITS_TO_LE_4BYTE(h2c_pkt + 0X00, 9, 1, value)
+#define WWLAN_GET_MAGIC_PKT_EN(h2c_pkt) LE_BITS_TO_4BYTE(h2c_pkt + 0X00, 10, 1)
+#define WWLAN_SET_MAGIC_PKT_EN(h2c_pkt, value)                                 \
+	SET_BITS_TO_LE_4BYTE(h2c_pkt + 0X00, 10, 1, value)
+#define WWLAN_GET_UNICAST_WAKEUP_EN(h2c_pkt)                                   \
+	LE_BITS_TO_4BYTE(h2c_pkt + 0X00, 11, 1)
+#define WWLAN_SET_UNICAST_WAKEUP_EN(h2c_pkt, value)                            \
+	SET_BITS_TO_LE_4BYTE(h2c_pkt + 0X00, 11, 1, value)
+#define WWLAN_GET_ALL_PKT_DROP(h2c_pkt) LE_BITS_TO_4BYTE(h2c_pkt + 0X00, 12, 1)
+#define WWLAN_SET_ALL_PKT_DROP(h2c_pkt, value)                                 \
+	SET_BITS_TO_LE_4BYTE(h2c_pkt + 0X00, 12, 1, value)
+#define WWLAN_GET_GPIO_ACTIVE(h2c_pkt) LE_BITS_TO_4BYTE(h2c_pkt + 0X00, 13, 1)
+#define WWLAN_SET_GPIO_ACTIVE(h2c_pkt, value)                                  \
+	SET_BITS_TO_LE_4BYTE(h2c_pkt + 0X00, 13, 1, value)
+#define WWLAN_GET_REKEY_WAKEUP_EN(h2c_pkt)                                     \
+	LE_BITS_TO_4BYTE(h2c_pkt + 0X00, 14, 1)
+#define WWLAN_SET_REKEY_WAKEUP_EN(h2c_pkt, value)                              \
+	SET_BITS_TO_LE_4BYTE(h2c_pkt + 0X00, 14, 1, value)
+#define WWLAN_GET_DEAUTH_WAKEUP_EN(h2c_pkt)                                    \
+	LE_BITS_TO_4BYTE(h2c_pkt + 0X00, 15, 1)
+#define WWLAN_SET_DEAUTH_WAKEUP_EN(h2c_pkt, value)                             \
+	SET_BITS_TO_LE_4BYTE(h2c_pkt + 0X00, 15, 1, value)
+#define WWLAN_GET_GPIO_NUM(h2c_pkt) LE_BITS_TO_4BYTE(h2c_pkt + 0X00, 16, 7)
+#define WWLAN_SET_GPIO_NUM(h2c_pkt, value)                                     \
+	SET_BITS_TO_LE_4BYTE(h2c_pkt + 0X00, 16, 7, value)
+#define WWLAN_GET_DATAPIN_WAKEUP_EN(h2c_pkt)                                   \
+	LE_BITS_TO_4BYTE(h2c_pkt + 0X00, 23, 1)
+#define WWLAN_SET_DATAPIN_WAKEUP_EN(h2c_pkt, value)                            \
+	SET_BITS_TO_LE_4BYTE(h2c_pkt + 0X00, 23, 1, value)
+#define WWLAN_GET_GPIO_DURATION(h2c_pkt) LE_BITS_TO_4BYTE(h2c_pkt + 0X00, 24, 8)
+#define WWLAN_SET_GPIO_DURATION(h2c_pkt, value)                                \
+	SET_BITS_TO_LE_4BYTE(h2c_pkt + 0X00, 24, 8, value)
+#define WWLAN_GET_GPIO_PLUS_EN(h2c_pkt) LE_BITS_TO_4BYTE(h2c_pkt + 0X04, 0, 1)
+#define WWLAN_SET_GPIO_PLUS_EN(h2c_pkt, value)                                 \
+	SET_BITS_TO_LE_4BYTE(h2c_pkt + 0X04, 0, 1, value)
+#define WWLAN_GET_GPIO_PULSE_COUNT(h2c_pkt)                                    \
+	LE_BITS_TO_4BYTE(h2c_pkt + 0X04, 1, 7)
+#define WWLAN_SET_GPIO_PULSE_COUNT(h2c_pkt, value)                             \
+	SET_BITS_TO_LE_4BYTE(h2c_pkt + 0X04, 1, 7, value)
+#define WWLAN_GET_DISABLE_UPHY(h2c_pkt) LE_BITS_TO_4BYTE(h2c_pkt + 0X04, 8, 1)
+#define WWLAN_SET_DISABLE_UPHY(h2c_pkt, value)                                 \
+	SET_BITS_TO_LE_4BYTE(h2c_pkt + 0X04, 8, 1, value)
+#define WWLAN_GET_HST2DEV_EN(h2c_pkt) LE_BITS_TO_4BYTE(h2c_pkt + 0X04, 9, 1)
+#define WWLAN_SET_HST2DEV_EN(h2c_pkt, value)                                   \
+	SET_BITS_TO_LE_4BYTE(h2c_pkt + 0X04, 9, 1, value)
+#define WWLAN_GET_GPIO_DURATION_MS(h2c_pkt)                                    \
+	LE_BITS_TO_4BYTE(h2c_pkt + 0X04, 10, 1)
+#define WWLAN_SET_GPIO_DURATION_MS(h2c_pkt, value)                             \
+	SET_BITS_TO_LE_4BYTE(h2c_pkt + 0X04, 10, 1, value)
+#define REMOTE_WAKE_CTRL_GET_CMD_ID(h2c_pkt)                                   \
+	LE_BITS_TO_4BYTE(h2c_pkt + 0X00, 0, 5)
+#define REMOTE_WAKE_CTRL_SET_CMD_ID(h2c_pkt, value)                            \
+	SET_BITS_TO_LE_4BYTE(h2c_pkt + 0X00, 0, 5, value)
+#define REMOTE_WAKE_CTRL_GET_CLASS(h2c_pkt)                                    \
+	LE_BITS_TO_4BYTE(h2c_pkt + 0X00, 5, 3)
+#define REMOTE_WAKE_CTRL_SET_CLASS(h2c_pkt, value)                             \
+	SET_BITS_TO_LE_4BYTE(h2c_pkt + 0X00, 5, 3, value)
+#define REMOTE_WAKE_CTRL_GET_REMOTE_WAKE_CTRL_EN(h2c_pkt)                      \
+	LE_BITS_TO_4BYTE(h2c_pkt + 0X00, 8, 1)
+#define REMOTE_WAKE_CTRL_SET_REMOTE_WAKE_CTRL_EN(h2c_pkt, value)               \
+	SET_BITS_TO_LE_4BYTE(h2c_pkt + 0X00, 8, 1, value)
+#define REMOTE_WAKE_CTRL_GET_ARP_EN(h2c_pkt)                                   \
+	LE_BITS_TO_4BYTE(h2c_pkt + 0X00, 9, 1)
+#define REMOTE_WAKE_CTRL_SET_ARP_EN(h2c_pkt, value)                            \
+	SET_BITS_TO_LE_4BYTE(h2c_pkt + 0X00, 9, 1, value)
+#define REMOTE_WAKE_CTRL_GET_NDP_EN(h2c_pkt)                                   \
+	LE_BITS_TO_4BYTE(h2c_pkt + 0X00, 10, 1)
+#define REMOTE_WAKE_CTRL_SET_NDP_EN(h2c_pkt, value)                            \
+	SET_BITS_TO_LE_4BYTE(h2c_pkt + 0X00, 10, 1, value)
+#define REMOTE_WAKE_CTRL_GET_GTK_EN(h2c_pkt)                                   \
+	LE_BITS_TO_4BYTE(h2c_pkt + 0X00, 11, 1)
+#define REMOTE_WAKE_CTRL_SET_GTK_EN(h2c_pkt, value)                            \
+	SET_BITS_TO_LE_4BYTE(h2c_pkt + 0X00, 11, 1, value)
+#define REMOTE_WAKE_CTRL_GET_NLO_OFFLOAD_EN(h2c_pkt)                           \
+	LE_BITS_TO_4BYTE(h2c_pkt + 0X00, 12, 1)
+#define REMOTE_WAKE_CTRL_SET_NLO_OFFLOAD_EN(h2c_pkt, value)                    \
+	SET_BITS_TO_LE_4BYTE(h2c_pkt + 0X00, 12, 1, value)
+#define REMOTE_WAKE_CTRL_GET_REAL_WOW_V1_EN(h2c_pkt)                           \
+	LE_BITS_TO_4BYTE(h2c_pkt + 0X00, 13, 1)
+#define REMOTE_WAKE_CTRL_SET_REAL_WOW_V1_EN(h2c_pkt, value)                    \
+	SET_BITS_TO_LE_4BYTE(h2c_pkt + 0X00, 13, 1, value)
+#define REMOTE_WAKE_CTRL_GET_REAL_WOW_V2_EN(h2c_pkt)                           \
+	LE_BITS_TO_4BYTE(h2c_pkt + 0X00, 14, 1)
+#define REMOTE_WAKE_CTRL_SET_REAL_WOW_V2_EN(h2c_pkt, value)                    \
+	SET_BITS_TO_LE_4BYTE(h2c_pkt + 0X00, 14, 1, value)
+#define REMOTE_WAKE_CTRL_GET_FW_UNICAST(h2c_pkt)                               \
+	LE_BITS_TO_4BYTE(h2c_pkt + 0X00, 15, 1)
+#define REMOTE_WAKE_CTRL_SET_FW_UNICAST(h2c_pkt, value)                        \
+	SET_BITS_TO_LE_4BYTE(h2c_pkt + 0X00, 15, 1, value)
+#define REMOTE_WAKE_CTRL_GET_P2P_OFFLOAD_EN(h2c_pkt)                           \
+	LE_BITS_TO_4BYTE(h2c_pkt + 0X00, 16, 1)
+#define REMOTE_WAKE_CTRL_SET_P2P_OFFLOAD_EN(h2c_pkt, value)                    \
+	SET_BITS_TO_LE_4BYTE(h2c_pkt + 0X00, 16, 1, value)
+#define REMOTE_WAKE_CTRL_GET_RUNTIME_PM_EN(h2c_pkt)                            \
+	LE_BITS_TO_4BYTE(h2c_pkt + 0X00, 17, 1)
+#define REMOTE_WAKE_CTRL_SET_RUNTIME_PM_EN(h2c_pkt, value)                     \
+	SET_BITS_TO_LE_4BYTE(h2c_pkt + 0X00, 17, 1, value)
+#define REMOTE_WAKE_CTRL_GET_NET_BIOS_DROP_EN(h2c_pkt)                         \
+	LE_BITS_TO_4BYTE(h2c_pkt + 0X00, 18, 1)
+#define REMOTE_WAKE_CTRL_SET_NET_BIOS_DROP_EN(h2c_pkt, value)                  \
+	SET_BITS_TO_LE_4BYTE(h2c_pkt + 0X00, 18, 1, value)
+#define REMOTE_WAKE_CTRL_GET_ARP_ACTION(h2c_pkt)                               \
+	LE_BITS_TO_4BYTE(h2c_pkt + 0X00, 24, 1)
+#define REMOTE_WAKE_CTRL_SET_ARP_ACTION(h2c_pkt, value)                        \
+	SET_BITS_TO_LE_4BYTE(h2c_pkt + 0X00, 24, 1, value)
+#define REMOTE_WAKE_CTRL_GET_FW_PARSING_UNTIL_WAKEUP(h2c_pkt)                  \
+	LE_BITS_TO_4BYTE(h2c_pkt + 0X00, 28, 1)
+#define REMOTE_WAKE_CTRL_SET_FW_PARSING_UNTIL_WAKEUP(h2c_pkt, value)           \
+	SET_BITS_TO_LE_4BYTE(h2c_pkt + 0X00, 28, 1, value)
+#define REMOTE_WAKE_CTRL_GET_FW_PARSING_AFTER_WAKEUP(h2c_pkt)                  \
+	LE_BITS_TO_4BYTE(h2c_pkt + 0X00, 29, 1)
+#define REMOTE_WAKE_CTRL_SET_FW_PARSING_AFTER_WAKEUP(h2c_pkt, value)           \
+	SET_BITS_TO_LE_4BYTE(h2c_pkt + 0X00, 29, 1, value)
+#define AOAC_GLOBAL_INFO_GET_CMD_ID(h2c_pkt)                                   \
+	LE_BITS_TO_4BYTE(h2c_pkt + 0X00, 0, 5)
+#define AOAC_GLOBAL_INFO_SET_CMD_ID(h2c_pkt, value)                            \
+	SET_BITS_TO_LE_4BYTE(h2c_pkt + 0X00, 0, 5, value)
+#define AOAC_GLOBAL_INFO_GET_CLASS(h2c_pkt)                                    \
+	LE_BITS_TO_4BYTE(h2c_pkt + 0X00, 5, 3)
+#define AOAC_GLOBAL_INFO_SET_CLASS(h2c_pkt, value)                             \
+	SET_BITS_TO_LE_4BYTE(h2c_pkt + 0X00, 5, 3, value)
+#define AOAC_GLOBAL_INFO_GET_PAIR_WISE_ENC_ALG(h2c_pkt)                        \
+	LE_BITS_TO_4BYTE(h2c_pkt + 0X00, 8, 8)
+#define AOAC_GLOBAL_INFO_SET_PAIR_WISE_ENC_ALG(h2c_pkt, value)                 \
+	SET_BITS_TO_LE_4BYTE(h2c_pkt + 0X00, 8, 8, value)
+#define AOAC_GLOBAL_INFO_GET_GROUP_ENC_ALG(h2c_pkt)                            \
+	LE_BITS_TO_4BYTE(h2c_pkt + 0X00, 16, 8)
+#define AOAC_GLOBAL_INFO_SET_GROUP_ENC_ALG(h2c_pkt, value)                     \
+	SET_BITS_TO_LE_4BYTE(h2c_pkt + 0X00, 16, 8, value)
+#define AOAC_RSVD_PAGE_GET_CMD_ID(h2c_pkt)                                     \
+	LE_BITS_TO_4BYTE(h2c_pkt + 0X00, 0, 5)
+#define AOAC_RSVD_PAGE_SET_CMD_ID(h2c_pkt, value)                              \
+	SET_BITS_TO_LE_4BYTE(h2c_pkt + 0X00, 0, 5, value)
+#define AOAC_RSVD_PAGE_GET_CLASS(h2c_pkt) LE_BITS_TO_4BYTE(h2c_pkt + 0X00, 5, 3)
+#define AOAC_RSVD_PAGE_SET_CLASS(h2c_pkt, value)                               \
+	SET_BITS_TO_LE_4BYTE(h2c_pkt + 0X00, 5, 3, value)
+#define AOAC_RSVD_PAGE_GET_LOC_REMOTE_CTRL_INFO(h2c_pkt)                       \
+	LE_BITS_TO_4BYTE(h2c_pkt + 0X00, 8, 8)
+#define AOAC_RSVD_PAGE_SET_LOC_REMOTE_CTRL_INFO(h2c_pkt, value)                \
+	SET_BITS_TO_LE_4BYTE(h2c_pkt + 0X00, 8, 8, value)
+#define AOAC_RSVD_PAGE_GET_LOC_ARP_RESPONSE(h2c_pkt)                           \
+	LE_BITS_TO_4BYTE(h2c_pkt + 0X00, 16, 8)
+#define AOAC_RSVD_PAGE_SET_LOC_ARP_RESPONSE(h2c_pkt, value)                    \
+	SET_BITS_TO_LE_4BYTE(h2c_pkt + 0X00, 16, 8, value)
+#define AOAC_RSVD_PAGE_GET_LOC_NEIGHBOR_ADVERTISEMENT(h2c_pkt)                 \
+	LE_BITS_TO_4BYTE(h2c_pkt + 0X00, 24, 8)
+#define AOAC_RSVD_PAGE_SET_LOC_NEIGHBOR_ADVERTISEMENT(h2c_pkt, value)          \
+	SET_BITS_TO_LE_4BYTE(h2c_pkt + 0X00, 24, 8, value)
+#define AOAC_RSVD_PAGE_GET_LOC_GTK_RSP(h2c_pkt)                                \
+	LE_BITS_TO_4BYTE(h2c_pkt + 0X04, 0, 8)
+#define AOAC_RSVD_PAGE_SET_LOC_GTK_RSP(h2c_pkt, value)                         \
+	SET_BITS_TO_LE_4BYTE(h2c_pkt + 0X04, 0, 8, value)
+#define AOAC_RSVD_PAGE_GET_LOC_GTK_INFO(h2c_pkt)                               \
+	LE_BITS_TO_4BYTE(h2c_pkt + 0X04, 8, 8)
+#define AOAC_RSVD_PAGE_SET_LOC_GTK_INFO(h2c_pkt, value)                        \
+	SET_BITS_TO_LE_4BYTE(h2c_pkt + 0X04, 8, 8, value)
+#define AOAC_RSVD_PAGE_GET_LOC_GTK_EXT_MEM(h2c_pkt)                            \
+	LE_BITS_TO_4BYTE(h2c_pkt + 0X04, 16, 8)
+#define AOAC_RSVD_PAGE_SET_LOC_GTK_EXT_MEM(h2c_pkt, value)                     \
+	SET_BITS_TO_LE_4BYTE(h2c_pkt + 0X04, 16, 8, value)
+#define AOAC_RSVD_PAGE_GET_LOC_NDP_INFO(h2c_pkt)                               \
+	LE_BITS_TO_4BYTE(h2c_pkt + 0X04, 24, 8)
+#define AOAC_RSVD_PAGE_SET_LOC_NDP_INFO(h2c_pkt, value)                        \
+	SET_BITS_TO_LE_4BYTE(h2c_pkt + 0X04, 24, 8, value)
+#define AOAC_RSVD_PAGE2_GET_CMD_ID(h2c_pkt)                                    \
+	LE_BITS_TO_4BYTE(h2c_pkt + 0X00, 0, 5)
+#define AOAC_RSVD_PAGE2_SET_CMD_ID(h2c_pkt, value)                             \
+	SET_BITS_TO_LE_4BYTE(h2c_pkt + 0X00, 0, 5, value)
+#define AOAC_RSVD_PAGE2_GET_CLASS(h2c_pkt)                                     \
+	LE_BITS_TO_4BYTE(h2c_pkt + 0X00, 5, 3)
+#define AOAC_RSVD_PAGE2_SET_CLASS(h2c_pkt, value)                              \
+	SET_BITS_TO_LE_4BYTE(h2c_pkt + 0X00, 5, 3, value)
+#define AOAC_RSVD_PAGE2_GET_LOC_ROUTER_SOLICATION(h2c_pkt)                     \
+	LE_BITS_TO_4BYTE(h2c_pkt + 0X00, 8, 8)
+#define AOAC_RSVD_PAGE2_SET_LOC_ROUTER_SOLICATION(h2c_pkt, value)              \
+	SET_BITS_TO_LE_4BYTE(h2c_pkt + 0X00, 8, 8, value)
+#define AOAC_RSVD_PAGE2_GET_LOC_BUBBLE_PACKET(h2c_pkt)                         \
+	LE_BITS_TO_4BYTE(h2c_pkt + 0X00, 16, 8)
+#define AOAC_RSVD_PAGE2_SET_LOC_BUBBLE_PACKET(h2c_pkt, value)                  \
+	SET_BITS_TO_LE_4BYTE(h2c_pkt + 0X00, 16, 8, value)
+#define AOAC_RSVD_PAGE2_GET_LOC_TEREDO_INFO(h2c_pkt)                           \
+	LE_BITS_TO_4BYTE(h2c_pkt + 0X00, 24, 8)
+#define AOAC_RSVD_PAGE2_SET_LOC_TEREDO_INFO(h2c_pkt, value)                    \
+	SET_BITS_TO_LE_4BYTE(h2c_pkt + 0X00, 24, 8, value)
+#define AOAC_RSVD_PAGE2_GET_LOC_REALWOW_INFO(h2c_pkt)                          \
+	LE_BITS_TO_4BYTE(h2c_pkt + 0X04, 0, 8)
+#define AOAC_RSVD_PAGE2_SET_LOC_REALWOW_INFO(h2c_pkt, value)                   \
+	SET_BITS_TO_LE_4BYTE(h2c_pkt + 0X04, 0, 8, value)
+#define AOAC_RSVD_PAGE2_GET_LOC_KEEP_ALIVE_PKT(h2c_pkt)                        \
+	LE_BITS_TO_4BYTE(h2c_pkt + 0X04, 8, 8)
+#define AOAC_RSVD_PAGE2_SET_LOC_KEEP_ALIVE_PKT(h2c_pkt, value)                 \
+	SET_BITS_TO_LE_4BYTE(h2c_pkt + 0X04, 8, 8, value)
+#define AOAC_RSVD_PAGE2_GET_LOC_ACK_PATTERN(h2c_pkt)                           \
+	LE_BITS_TO_4BYTE(h2c_pkt + 0X04, 16, 8)
+#define AOAC_RSVD_PAGE2_SET_LOC_ACK_PATTERN(h2c_pkt, value)                    \
+	SET_BITS_TO_LE_4BYTE(h2c_pkt + 0X04, 16, 8, value)
+#define AOAC_RSVD_PAGE2_GET_LOC_WAKEUP_PATTERN(h2c_pkt)                        \
+	LE_BITS_TO_4BYTE(h2c_pkt + 0X04, 24, 8)
+#define AOAC_RSVD_PAGE2_SET_LOC_WAKEUP_PATTERN(h2c_pkt, value)                 \
+	SET_BITS_TO_LE_4BYTE(h2c_pkt + 0X04, 24, 8, value)
+#define D0_SCAN_OFFLOAD_INFO_GET_CMD_ID(h2c_pkt)                               \
+	LE_BITS_TO_4BYTE(h2c_pkt + 0X00, 0, 5)
+#define D0_SCAN_OFFLOAD_INFO_SET_CMD_ID(h2c_pkt, value)                        \
+	SET_BITS_TO_LE_4BYTE(h2c_pkt + 0X00, 0, 5, value)
+#define D0_SCAN_OFFLOAD_INFO_GET_CLASS(h2c_pkt)                                \
+	LE_BITS_TO_4BYTE(h2c_pkt + 0X00, 5, 3)
+#define D0_SCAN_OFFLOAD_INFO_SET_CLASS(h2c_pkt, value)                         \
+	SET_BITS_TO_LE_4BYTE(h2c_pkt + 0X00, 5, 3, value)
+#define D0_SCAN_OFFLOAD_INFO_GET_LOC_CHANNEL_INFO(h2c_pkt)                     \
+	LE_BITS_TO_4BYTE(h2c_pkt + 0X00, 8, 8)
+#define D0_SCAN_OFFLOAD_INFO_SET_LOC_CHANNEL_INFO(h2c_pkt, value)              \
+	SET_BITS_TO_LE_4BYTE(h2c_pkt + 0X00, 8, 8, value)
+#define CHANNEL_SWITCH_OFFLOAD_GET_CMD_ID(h2c_pkt)                             \
+	LE_BITS_TO_4BYTE(h2c_pkt + 0X00, 0, 5)
+#define CHANNEL_SWITCH_OFFLOAD_SET_CMD_ID(h2c_pkt, value)                      \
+	SET_BITS_TO_LE_4BYTE(h2c_pkt + 0X00, 0, 5, value)
+#define CHANNEL_SWITCH_OFFLOAD_GET_CLASS(h2c_pkt)                              \
+	LE_BITS_TO_4BYTE(h2c_pkt + 0X00, 5, 3)
+#define CHANNEL_SWITCH_OFFLOAD_SET_CLASS(h2c_pkt, value)                       \
+	SET_BITS_TO_LE_4BYTE(h2c_pkt + 0X00, 5, 3, value)
+#define CHANNEL_SWITCH_OFFLOAD_GET_CHANNEL_NUM(h2c_pkt)                        \
+	LE_BITS_TO_4BYTE(h2c_pkt + 0X00, 8, 8)
+#define CHANNEL_SWITCH_OFFLOAD_SET_CHANNEL_NUM(h2c_pkt, value)                 \
+	SET_BITS_TO_LE_4BYTE(h2c_pkt + 0X00, 8, 8, value)
+#define CHANNEL_SWITCH_OFFLOAD_GET_EN_RFE(h2c_pkt)                             \
+	LE_BITS_TO_4BYTE(h2c_pkt + 0X00, 16, 8)
+#define CHANNEL_SWITCH_OFFLOAD_SET_EN_RFE(h2c_pkt, value)                      \
+	SET_BITS_TO_LE_4BYTE(h2c_pkt + 0X00, 16, 8, value)
+#define CHANNEL_SWITCH_OFFLOAD_GET_RFE_TYPE(h2c_pkt)                           \
+	LE_BITS_TO_4BYTE(h2c_pkt + 0X00, 24, 8)
+#define CHANNEL_SWITCH_OFFLOAD_SET_RFE_TYPE(h2c_pkt, value)                    \
+	SET_BITS_TO_LE_4BYTE(h2c_pkt + 0X00, 24, 8, value)
+#define AOAC_RSVD_PAGE3_GET_CMD_ID(h2c_pkt)                                    \
+	LE_BITS_TO_4BYTE(h2c_pkt + 0X00, 0, 5)
+#define AOAC_RSVD_PAGE3_SET_CMD_ID(h2c_pkt, value)                             \
+	SET_BITS_TO_LE_4BYTE(h2c_pkt + 0X00, 0, 5, value)
+#define AOAC_RSVD_PAGE3_GET_CLASS(h2c_pkt)                                     \
+	LE_BITS_TO_4BYTE(h2c_pkt + 0X00, 5, 3)
+#define AOAC_RSVD_PAGE3_SET_CLASS(h2c_pkt, value)                              \
+	SET_BITS_TO_LE_4BYTE(h2c_pkt + 0X00, 5, 3, value)
+#define AOAC_RSVD_PAGE3_GET_LOC_NLO_INFO(h2c_pkt)                              \
+	LE_BITS_TO_4BYTE(h2c_pkt + 0X00, 8, 8)
+#define AOAC_RSVD_PAGE3_SET_LOC_NLO_INFO(h2c_pkt, value)                       \
+	SET_BITS_TO_LE_4BYTE(h2c_pkt + 0X00, 8, 8, value)
+#define AOAC_RSVD_PAGE3_GET_LOC_AOAC_REPORT(h2c_pkt)                           \
+	LE_BITS_TO_4BYTE(h2c_pkt + 0X00, 16, 8)
+#define AOAC_RSVD_PAGE3_SET_LOC_AOAC_REPORT(h2c_pkt, value)                    \
+	SET_BITS_TO_LE_4BYTE(h2c_pkt + 0X00, 16, 8, value)
+#define DBG_MSG_CTRL_GET_CMD_ID(h2c_pkt) LE_BITS_TO_4BYTE(h2c_pkt + 0X00, 0, 5)
+#define DBG_MSG_CTRL_SET_CMD_ID(h2c_pkt, value)                                \
+	SET_BITS_TO_LE_4BYTE(h2c_pkt + 0X00, 0, 5, value)
+#define DBG_MSG_CTRL_GET_CLASS(h2c_pkt) LE_BITS_TO_4BYTE(h2c_pkt + 0X00, 5, 3)
+#define DBG_MSG_CTRL_SET_CLASS(h2c_pkt, value)                                 \
+	SET_BITS_TO_LE_4BYTE(h2c_pkt + 0X00, 5, 3, value)
+#define DBG_MSG_CTRL_GET_FUN_EN(h2c_pkt) LE_BITS_TO_4BYTE(h2c_pkt + 0X00, 8, 1)
+#define DBG_MSG_CTRL_SET_FUN_EN(h2c_pkt, value)                                \
+	SET_BITS_TO_LE_4BYTE(h2c_pkt + 0X00, 8, 1, value)
+#define DBG_MSG_CTRL_GET_MODE(h2c_pkt) LE_BITS_TO_4BYTE(h2c_pkt + 0X00, 12, 4)
+#define DBG_MSG_CTRL_SET_MODE(h2c_pkt, value)                                  \
+	SET_BITS_TO_LE_4BYTE(h2c_pkt + 0X00, 12, 4, value)
+#endif
-- 
2.15.1

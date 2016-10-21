Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f193.google.com ([209.85.192.193]:33737 "EHLO
        mail-pf0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754332AbcJUKNZ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 21 Oct 2016 06:13:25 -0400
Received: by mail-pf0-f193.google.com with SMTP id i85so8264343pfa.0
        for <linux-wireless@vger.kernel.org>; Fri, 21 Oct 2016 03:13:24 -0700 (PDT)
From: Prameela Rani Garnepudi <prameela.j04cs@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, johannes.berg@intel.com, hofrat@osadl.org,
        xypron.glpk@gmx.de, prameela.garnepudi@redpinesignals.com,
        Prameela Rani Garnepudi <prameela.j04cs@gmail.com>
Subject: [PATCH 1/2] rsi: New firware loading method for RSI 91X devices
Date: Fri, 21 Oct 2016 15:39:55 +0530
Message-Id: <1477044595-10348-1-git-send-email-prameela.j04cs@gmail.com> (sfid-20161021_121347_832438_182D8C91)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

RSI deprecated the old firmware loading method and introduced
new method using soft boot loader for 9113 chipsets.
Current driver only supports 9113 device model hence firmware
loading method has been changed.

In the new method, complete RAM image and flash image are present
in the flash. Two firmwares present in the device, Boot loader firmware
and functional firmware. Boot loader firmware is fixed but functional
firmware can be changed. Before loading the functional firmware, host
issues commands to check whether existing firmware in the chip and the
firmware file content to load are same or not. If not, host issues
commands to load the RAM image and then boot loaded switches to the
functioanl firmware.

Signed-off-by: Prameela Rani Garnepudi <prameela.j04cs@gmail.com>
---
 drivers/net/wireless/rsi/Makefile           |    2 +-
 drivers/net/wireless/rsi/rsi_91x_hal.c      | 1049 +++++++++++++++++++++++++++
 drivers/net/wireless/rsi/rsi_91x_mgmt.c     |   49 ++
 drivers/net/wireless/rsi/rsi_91x_pkt.c      |  215 ------
 drivers/net/wireless/rsi/rsi_91x_sdio.c     |  231 +++++-
 drivers/net/wireless/rsi/rsi_91x_sdio_ops.c |  192 +----
 drivers/net/wireless/rsi/rsi_91x_usb.c      |  176 ++++-
 drivers/net/wireless/rsi/rsi_91x_usb_ops.c  |  130 +---
 drivers/net/wireless/rsi/rsi_common.h       |    4 +
 drivers/net/wireless/rsi/rsi_hal.h          |  150 ++++
 drivers/net/wireless/rsi/rsi_main.h         |   68 +-
 drivers/net/wireless/rsi/rsi_mgmt.h         |    2 +
 drivers/net/wireless/rsi/rsi_sdio.h         |   18 +-
 drivers/net/wireless/rsi/rsi_usb.h          |   14 +-
 14 files changed, 1720 insertions(+), 580 deletions(-)
 create mode 100644 drivers/net/wireless/rsi/rsi_91x_hal.c
 delete mode 100644 drivers/net/wireless/rsi/rsi_91x_pkt.c
 create mode 100644 drivers/net/wireless/rsi/rsi_hal.h

diff --git a/drivers/net/wireless/rsi/Makefile b/drivers/net/wireless/rsi/Makefile
index 25828b6..a475c81 100644
--- a/drivers/net/wireless/rsi/Makefile
+++ b/drivers/net/wireless/rsi/Makefile
@@ -2,7 +2,7 @@ rsi_91x-y			+= rsi_91x_main.o
 rsi_91x-y			+= rsi_91x_core.o
 rsi_91x-y			+= rsi_91x_mac80211.o
 rsi_91x-y			+= rsi_91x_mgmt.o
-rsi_91x-y			+= rsi_91x_pkt.o
+rsi_91x-y			+= rsi_91x_hal.o
 rsi_91x-$(CONFIG_RSI_DEBUGFS)	+= rsi_91x_debugfs.o
 
 rsi_usb-y			+= rsi_91x_usb.o rsi_91x_usb_ops.o
diff --git a/drivers/net/wireless/rsi/rsi_91x_hal.c b/drivers/net/wireless/rsi/rsi_91x_hal.c
new file mode 100644
index 0000000..178d411
--- /dev/null
+++ b/drivers/net/wireless/rsi/rsi_91x_hal.c
@@ -0,0 +1,1049 @@
+/**
+ * Copyright (c) 2014 Redpine Signals Inc.
+ *
+ * Developers
+ *	Prameela Rani Garnepudi 2016 <prameela.garnepudi@redpinesignals.com>
+ *
+ * Permission to use, copy, modify, and/or distribute this software for any
+ * purpose with or without fee is hereby granted, provided that the above
+ * copyright notice and this permission notice appear in all copies.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
+ * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
+ * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
+ * ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
+ * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
+ * ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
+ * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
+ */
+
+#include <linux/firmware.h>
+#include <linux/version.h>
+#include <linux/jiffies.h>
+#include "rsi_mgmt.h"
+#include "rsi_hal.h"
+#include "rsi_sdio.h"
+#include "rsi_common.h"
+
+/* FLASH Firmware */
+struct ta_metadata metadata_flash_content[] = {
+	{"flash_content", 0x00010000},
+	{"RS9113_WLAN_QSPI.rps", 0x00010000},
+	{"RS9113_WLAN_BT_DUAL_MODE.rps", 0x00010000},
+	{"RS9113_WLAN_ZIGBEE.rps", 0x00010000},
+	{"RS9113_AP_BT_DUAL_MODE.rps", 0x00010000},
+	{"RS9113_WLAN_QSPI.rps", 0x00010000}
+};
+
+/**
+ * rsi_send_data_pkt() - This function sends the received data packet from
+ *			 driver to device.
+ * @common: Pointer to the driver private structure.
+ * @skb: Pointer to the socket buffer structure.
+ *
+ * Return: status: 0 on success, -1 on failure.
+ */
+int rsi_send_data_pkt(struct rsi_common *common, struct sk_buff *skb)
+{
+	struct rsi_hw *adapter = common->priv;
+	struct ieee80211_hdr *wh = NULL;
+	struct ieee80211_tx_info *info;
+	struct skb_info *tx_params;
+	struct ieee80211_bss_conf *bss = NULL;
+	int status = -EINVAL;
+	u8 ieee80211_hdr_size = MIN_802_11_HDR_LEN;
+	u8 dword_align_bytes = 0;
+	u8 header_size = 0;
+	__le16 *frame_desc;
+	struct xtended_desc *xtend_desc;
+	u16 seq_num = 0;
+
+	info = IEEE80211_SKB_CB(skb);
+	bss = &info->control.vif->bss_conf;
+	tx_params = (struct skb_info *)info->driver_data;
+
+	if (!bss->assoc)
+		goto err;
+
+	dword_align_bytes = ((uintptr_t)skb->data & 0x3f);
+	header_size = dword_align_bytes + FRAME_DESC_SZ +
+					sizeof(struct xtended_desc);
+	if (header_size > skb_headroom(skb)) {
+		rsi_dbg(ERR_ZONE, "%s: Not enough headroom\n", __func__);
+		status = -ENOSPC;
+		goto err;
+	}
+
+	skb_push(skb, header_size);
+	frame_desc = (__le16 *)&skb->data[0];
+	xtend_desc = (struct xtended_desc *)&skb->data[FRAME_DESC_SZ];
+	memset((u8 *)frame_desc, 0, header_size);
+
+	wh = (struct ieee80211_hdr *)&skb->data[header_size];
+	seq_num = (le16_to_cpu(wh->seq_ctrl) >> 4);
+
+	frame_desc[2] = cpu_to_le16(header_size - FRAME_DESC_SZ);
+	if (ieee80211_is_data_qos(wh->frame_control)) {
+		ieee80211_hdr_size += 2;
+		frame_desc[6] |= cpu_to_le16(BIT(12));
+	}
+
+	if ((!(info->flags & IEEE80211_TX_INTFL_DONT_ENCRYPT)) &&
+	    (common->secinfo.security_enable)) {
+		if (rsi_is_cipher_wep(common))
+			ieee80211_hdr_size += 4;
+		else
+			ieee80211_hdr_size += 8;
+		frame_desc[6] |= cpu_to_le16(BIT(15));
+	}
+
+	frame_desc[0] = cpu_to_le16((skb->len - FRAME_DESC_SZ) |
+				    (RSI_WIFI_DATA_Q << 12));
+	frame_desc[2] |= cpu_to_le16(ieee80211_hdr_size << 8);
+
+	if (common->min_rate != 0xffff) {
+		/* Send fixed rate */
+		frame_desc[3] = cpu_to_le16(RATE_INFO_ENABLE);
+		frame_desc[4] = cpu_to_le16(common->min_rate);
+
+		if (conf_is_ht40(&common->priv->hw->conf))
+			frame_desc[5] = cpu_to_le16(FULL40M_ENABLE);
+
+		if ((common->vif_info[0].sgi) && (common->min_rate & 0x100)) {
+			/* Only MCS rates */
+			frame_desc[4] |= cpu_to_le16(ENABLE_SHORTGI_RATE);
+		}
+	}
+
+	if ((skb->data[header_size + 12] == 0x88) &&
+	    (skb->data[header_size + 12] == 0x8e)) {
+		rsi_dbg(INFO_ZONE, "*** Tx EAPOL ***\n");
+		frame_desc[6] |= cpu_to_le16(BIT(13));
+		frame_desc[1] |= cpu_to_le16(BIT(12));
+#define EAPOL_RETRY_CNT 15
+		xtend_desc->retry_cnt = EAPOL_RETRY_CNT;
+	}
+
+	frame_desc[6] |= cpu_to_le16(seq_num & 0xfff);
+	frame_desc[7] = cpu_to_le16(((tx_params->tid & 0xf) << 4) |
+				    (skb->priority & 0xf) |
+				    (tx_params->sta_id << 8));
+
+	status = adapter->host_intf_ops->write_pkt(common->priv,
+						   skb->data, skb->len);
+	if (status)
+		rsi_dbg(ERR_ZONE, "%s: Failed to write pkt\n", __func__);
+
+err:
+	++common->tx_stats.total_tx_pkt_freed[skb->priority];
+	rsi_indicate_tx_status(common->priv, skb, status);
+	return status;
+}
+
+/**
+ * rsi_send_mgmt_pkt() - This functions prepares the descriptor for
+ *		the given management packet and send to device.
+ * @common: Pointer to the driver private structure.
+ * @skb: Pointer to the socket buffer structure.
+ *
+ * Return: status: 0 on success, -1 on failure.
+ */
+int rsi_send_mgmt_pkt(struct rsi_common *common,
+		      struct sk_buff *skb)
+{
+	struct rsi_hw *adapter = common->priv;
+	struct ieee80211_hdr *wh = NULL;
+	struct ieee80211_tx_info *info;
+	struct ieee80211_bss_conf *bss = NULL;
+	struct ieee80211_hw *hw = adapter->hw;
+	struct ieee80211_conf *conf = &hw->conf;
+	struct skb_info *tx_params;
+	int status = -E2BIG;
+	__le16 *desc = NULL;
+	struct xtended_desc *xtend_desc = NULL;
+	u8 header_size = 0;
+	u8 vap_id = 0;
+	u32 dword_align_req_bytes = 0;
+
+	info = IEEE80211_SKB_CB(skb);
+	tx_params = (struct skb_info *)info->driver_data;
+
+	if (tx_params->flags & INTERNAL_MGMT_PKT) {
+		skb->data[1] |= BIT(7); /* Immediate Wakeup bit*/
+		status = adapter->host_intf_ops->write_pkt(common->priv,
+							   (u8 *)skb->data,
+							   skb->len);
+		if (status) {
+			rsi_dbg(ERR_ZONE,
+				"%s: Failed to write the packet\n",
+				__func__);
+		}
+		dev_kfree_skb(skb);
+		return status;
+	}
+
+	/* Update header size */
+	header_size = FRAME_DESC_SZ + sizeof(struct xtended_desc) +
+					dword_align_req_bytes;
+	if (header_size > skb_headroom(skb)) {
+		rsi_dbg(ERR_ZONE,
+			"%s: Failed to add extended descriptor\n",
+			__func__);
+		goto err;
+	}
+	skb_push(skb, header_size);
+	memset(&skb->data[0], 0, header_size);
+
+	bss = &info->control.vif->bss_conf;
+	wh = (struct ieee80211_hdr *)&skb->data[header_size];
+
+	desc = (__le16 *)skb->data;
+	xtend_desc = (struct xtended_desc *)&skb->data[FRAME_DESC_SZ];
+
+	if (skb->len > MAX_MGMT_PKT_SIZE) {
+		rsi_dbg(INFO_ZONE, "%s: Dropping mgmt pkt > 512\n", __func__);
+		goto err;
+	}
+
+	desc[0] = cpu_to_le16((skb->len - FRAME_DESC_SZ) |
+			      (RSI_WIFI_MGMT_Q << 12));
+	desc[1] = cpu_to_le16(TX_DOT11_MGMT);
+	desc[2] = cpu_to_le16(MIN_802_11_HDR_LEN << 8);
+	desc[2] |= cpu_to_le16(header_size - FRAME_DESC_SZ);
+	desc[3] = cpu_to_le16(RATE_INFO_ENABLE);
+	if (wh->addr1[0] & BIT(0))
+		desc[3] |= cpu_to_le16(RSI_BROADCAST_PKT);
+	desc[6] = cpu_to_le16(le16_to_cpu(wh->seq_ctrl) >> 4);
+
+	if (common->band == NL80211_BAND_2GHZ)
+		desc[4] = cpu_to_le16(RSI_11B_MODE);
+	else
+		desc[4] = cpu_to_le16((RSI_RATE_6 & 0x0f) | RSI_11G_MODE);
+
+	if (conf_is_ht40(conf)) {
+		desc[4] |= cpu_to_le16(0xB | RSI_11G_MODE);
+		desc[5] = cpu_to_le16(0x6);
+	}
+
+	/* Indicate to firmware to give cfm */
+	if (ieee80211_is_probe_req(wh->frame_control) && (!bss->assoc)) {
+		rsi_dbg(INFO_ZONE, "%s: blocking mgmt queue\n", __func__);
+		desc[1] |= cpu_to_le16(RSI_DESC_REQUIRE_CFM_TO_HOST);
+		xtend_desc->confirm_frame_type = PROBEREQ_CONFIRM;
+		common->mgmt_q_block = true;
+	}
+
+	desc[7] |= cpu_to_le16(vap_id << 8); /* Station ID */
+	desc[4] |= cpu_to_le16(vap_id << 14);
+
+	status = adapter->host_intf_ops->write_pkt(common->priv,
+						   (u8 *)desc,
+						   skb->len);
+	if (status) {
+		rsi_dbg(ERR_ZONE,
+			"%s: Failed to write the packet\n",
+			__func__);
+	}
+
+err:
+	rsi_indicate_tx_status(common->priv, skb, status);
+	return status;
+}
+
+/**
+ * bl_cmd_timeout() - This function is called when BL command timed out
+ * @priv: Pointer to the hardware structure.
+ *
+ * Return: NONE.
+ */
+static void bl_cmd_timeout(unsigned long priv)
+{
+	struct rsi_hw *adapter = (struct rsi_hw *)priv;
+
+	adapter->blcmd_timer_expired = 1;
+	del_timer(&adapter->bl_cmd_timer);
+}
+
+/**
+ * bl_start_cmd_timer() - This function starts the BL command timer
+ * @adapter: Pointer to the hardware structure.
+ * @timeout: Timeout of the command in milliseconds
+ *
+ * Return: 0 on success.
+ */
+static int bl_start_cmd_timer(struct rsi_hw *adapter, u32 timeout)
+{
+	init_timer(&adapter->bl_cmd_timer);
+	adapter->bl_cmd_timer.data = (unsigned long)adapter;
+	adapter->bl_cmd_timer.function = (void *)&bl_cmd_timeout;
+	adapter->bl_cmd_timer.expires = (msecs_to_jiffies(timeout) + jiffies);
+
+	adapter->blcmd_timer_expired = 0;
+	add_timer(&adapter->bl_cmd_timer);
+
+	return 0;
+}
+
+/**
+ * bl_stop_cmd_timer() - This function stops the BL command timer
+ * @adapter: Pointer to the hardware structure.
+ *
+ * Return: 0 on success.
+ */
+static int bl_stop_cmd_timer(struct rsi_hw *adapter)
+{
+	adapter->blcmd_timer_expired = 0;
+	if (timer_pending(&adapter->bl_cmd_timer))
+		del_timer(&adapter->bl_cmd_timer);
+
+	return 0;
+}
+
+/**
+ * bl_write_cmd() - This function writes the BL command to device
+ * @adapter: Pointer to the hardware structure.
+ * @cmd: Command to write
+ * @exp_resp: Expected Response
+ * @cmd_resp: Received Response
+ *
+ * Return: 0 on success.
+ */
+int bl_write_cmd(struct rsi_hw *adapter, u8 cmd, u8 exp_resp, u16 *cmd_resp)
+{
+	struct rsi_host_intf_ops *hif_ops = adapter->host_intf_ops;
+	u32 regin_val = 0, regout_val = 0;
+	u8 output = 0;
+	u32 regin_input = 0;
+
+	regin_input = (REGIN_INPUT | adapter->priv->coex_mode);
+
+	while (!adapter->blcmd_timer_expired) {
+		regin_val = 0;
+		if (hif_ops->master_reg_read(adapter,
+					     SWBL_REGIN,
+					     &regin_val,
+					     2) < 0) {
+			rsi_dbg(ERR_ZONE,
+				"%s: Command %0x REGIN reading failed..\n",
+				__func__, cmd);
+			goto fail;
+		}
+		mdelay(1);
+		if ((regin_val >> 12) != REGIN_VALID)
+			break;
+	}
+	if (adapter->blcmd_timer_expired) {
+		rsi_dbg(ERR_ZONE,
+			"%s: Command %0x REGIN reading timed out..\n",
+			__func__, cmd);
+		goto fail;
+	}
+
+	rsi_dbg(INFO_ZONE,
+		"Issuing write to Regin regin_val:%0x sending cmd:%0x\n",
+		regin_val, (cmd | regin_input << 8));
+	if ((hif_ops->master_reg_write(adapter,
+				       SWBL_REGIN,
+				       (cmd | regin_input << 8),
+				       2)) < 0) {
+		goto fail;
+	}
+	mdelay(1);
+
+	if (cmd == LOAD_HOSTED_FW || cmd == JUMP_TO_ZERO_PC) {
+		/* JUMP_TO_ZERO_PC doesn't expect
+		 * any response. So return from here
+		 */
+		return 0;
+	}
+
+	while (!adapter->blcmd_timer_expired) {
+		regout_val = 0;
+		if (hif_ops->master_reg_read(adapter,
+					     SWBL_REGOUT,
+					     &regout_val,
+					     2) < 0) {
+			rsi_dbg(ERR_ZONE,
+				"%s: Command %0x REGOUT reading failed..\n",
+				__func__, cmd);
+			goto fail;
+		}
+		mdelay(1);
+		if ((regout_val >> 8) == REGOUT_VALID)
+			break;
+	}
+	if (adapter->blcmd_timer_expired) {
+		rsi_dbg(ERR_ZONE,
+			"%s: Command %0x REGOUT reading timed out..\n",
+			__func__, cmd);
+		goto fail;
+	}
+
+	*cmd_resp = ((u16 *)&regout_val)[0] & 0xffff;
+
+	output = ((u8 *)&regout_val)[0] & 0xff;
+
+	rsi_dbg(INFO_ZONE, "Invalidating regout\n");
+	if ((hif_ops->master_reg_write(adapter,
+				       SWBL_REGOUT,
+				       (cmd | REGOUT_INVALID << 8),
+				       2)) < 0) {
+		rsi_dbg(ERR_ZONE,
+			"%s: Command %0x REGOUT writing failed..\n",
+			__func__, cmd);
+		goto fail;
+	}
+	mdelay(1);
+
+	if (output == exp_resp) {
+		rsi_dbg(INFO_ZONE,
+			"%s: Recvd Expected resp %x for cmd %0x\n",
+			__func__, output, cmd);
+	} else {
+		rsi_dbg(ERR_ZONE,
+			"%s: Recvd resp %x for cmd %0x\n",
+			__func__, output, cmd);
+		goto fail;
+	}
+	return 0;
+
+fail:
+	return -1;
+}
+
+/**
+ * bl_cmd() - This function initiates the BL command
+ * @adapter: Pointer to the hardware structure.
+ * @cmd: Command to write
+ * @exp_resp: Expected Response
+ * @str: Command string
+ *
+ * Return: 0 on success, -1 on failure.
+ */
+int bl_cmd(struct rsi_hw *adapter, u8 cmd, u8 exp_resp, char *str)
+{
+	u16 regout_val = 0;
+	u32 timeout = 0;
+
+	rsi_dbg(INFO_ZONE, "Issuing cmd: \"%s\"\n", str);
+
+	if ((cmd == EOF_REACHED) || (cmd == PING_VALID) || (cmd == PONG_VALID))
+		timeout = BL_BURN_TIMEOUT;
+	else
+		timeout = BL_CMD_TIMEOUT;
+
+	bl_start_cmd_timer(adapter, timeout);
+	if (bl_write_cmd(adapter, cmd, exp_resp, &regout_val) < 0) {
+		rsi_dbg(ERR_ZONE,
+			"%s: Command %s (%0x) writing failed..\n",
+			__func__, str, cmd);
+		goto fail;
+	}
+	bl_stop_cmd_timer(adapter);
+	return 0;
+
+fail:
+	return -1;
+}
+
+/**
+ * bl_write_header() - This function writes the BL header
+ * @adapter: Pointer to the hardware structure.
+ * @flash_content: Flash content
+ * @content_size: Flash content size
+ *
+ * Return: 0 on success, -1 on failure.
+ */
+static int bl_write_header(struct rsi_hw *adapter,
+			   u8 *flash_content, u32 content_size)
+{
+	struct rsi_host_intf_ops *hif_ops = adapter->host_intf_ops;
+	struct bl_header bl_hdr;
+	u32 write_addr, write_len;
+
+#define CHECK_SUM_OFFSET 20
+#define LEN_OFFSET 8
+#define ADDR_OFFSET 16
+
+	bl_hdr.flags = 0;
+	bl_hdr.image_no = cpu_to_le32(adapter->priv->coex_mode);
+	bl_hdr.check_sum = cpu_to_le32(
+				*(u32 *)&flash_content[CHECK_SUM_OFFSET]);
+	bl_hdr.flash_start_address = cpu_to_le32(
+					*(u32 *)&flash_content[ADDR_OFFSET]);
+	bl_hdr.flash_len = cpu_to_le32(*(u32 *)&flash_content[LEN_OFFSET]);
+	write_len = sizeof(struct bl_header);
+
+	if (adapter->rsi_host_intf == RSI_HOST_INTF_USB) {
+		write_addr = PING_BUFFER_ADDRESS;
+		if ((hif_ops->write_reg_multiple(adapter,
+						 write_addr,
+						 (u8 *)&bl_hdr,
+						 write_len)) < 0) {
+			rsi_dbg(ERR_ZONE,
+				"%s: Failed to load Version/CRC structure\n",
+				__func__);
+			goto fail;
+		}
+	} else {
+		write_addr = PING_BUFFER_ADDRESS >> 16;
+		if ((hif_ops->master_access_msword(adapter, write_addr)) < 0) {
+			rsi_dbg(ERR_ZONE,
+				"%s: Unable to set ms word to common reg\n",
+				__func__);
+			goto fail;
+		}
+		write_addr = RSI_SD_REQUEST_MASTER |
+			     (PING_BUFFER_ADDRESS & 0xFFFF);
+		if ((hif_ops->write_reg_multiple(adapter,
+						 write_addr,
+						 (u8 *)&bl_hdr,
+						 write_len)) < 0) {
+			rsi_dbg(ERR_ZONE,
+				"%s: Failed to load Version/CRC structure\n",
+				__func__);
+			goto fail;
+		}
+	}
+	return 0;
+
+fail:
+	return -1;
+}
+
+/**
+ * read_flash_capacity() - This function reads the flash size from device
+ * @adapter: Pointer to the hardware structure.
+ *
+ * Return: flash capacity on success, 0 on failure.
+ */
+static u32 read_flash_capacity(struct rsi_hw *adapter)
+{
+	u32 flash_sz = 0;
+
+	if ((adapter->host_intf_ops->master_reg_read(adapter,
+						     FLASH_SIZE_ADDR,
+						     &flash_sz, 2)) < 0) {
+		rsi_dbg(ERR_ZONE,
+			"%s: Flash size reading failed..\n",
+			__func__);
+		return 0;
+	}
+	rsi_dbg(INIT_ZONE, "Flash capacity: %d KiloBytes\n", flash_sz);
+
+	return (flash_sz * 1024); /* Return size in kbytes */
+}
+
+/**
+ * ping_pong_write() - This function writes the flash contents throgh ping
+ *			pong buffers
+ * @adapter: Pointer to the hardware structure.
+ * @cmd: command ping/pong write
+ * @addr: address to write
+ * @size: size
+ *
+ * Return: 0 on success, -1 on failure.
+ */
+static int ping_pong_write(struct rsi_hw *adapter, u8 cmd, u8 *addr, u32 size)
+{
+	struct rsi_host_intf_ops *hif_ops = adapter->host_intf_ops;
+	u32 block_size = 0;
+	u32 cmd_addr;
+	u16 cmd_resp = 0, cmd_req = 0;
+	u8 *str;
+
+	if (adapter->rsi_host_intf == RSI_HOST_INTF_SDIO)
+		block_size = 256;
+	else
+		block_size = 252;
+
+	if (cmd == PING_WRITE) {
+		cmd_addr = PING_BUFFER_ADDRESS;
+		cmd_resp = PONG_AVAIL;
+		cmd_req = PING_VALID;
+		str = "PING_VALID";
+	} else {
+		cmd_addr = PONG_BUFFER_ADDRESS;
+		cmd_resp = PING_AVAIL;
+		cmd_req = PONG_VALID;
+		str = "PONG_VALID";
+	}
+
+	if (hif_ops->load_data_master_write(adapter,
+					    cmd_addr,
+					    size,
+					    block_size,
+					    addr)) {
+		rsi_dbg(ERR_ZONE, "%s: Unable to write blk at addr %0x\n",
+			__func__, *addr);
+		goto fail;
+	}
+	if (bl_cmd(adapter, cmd_req, cmd_resp, str) < 0) {
+		bl_stop_cmd_timer(adapter);
+		goto fail;
+	}
+	return 0;
+
+fail:
+	return -1;
+}
+
+/**
+ * auto_fw_upgrade() - This function loads the firmware to device
+ * @adapter: Pointer to the hardware structure.
+ * @flash_content: Firmware to load
+ * @content_size: Size of the firmware
+ *
+ * Return: 0 on success, -1 on failure.
+ */
+static int auto_fw_upgrade(struct rsi_hw *adapter,
+			   u8 *flash_content,
+			   u32 content_size)
+{
+	u8 cmd;
+	u8 *temp_flash_content;
+	u32 temp_content_size;
+	u32 num_flash;
+	u32 index;
+	u32 flash_start_address;
+
+	temp_flash_content = flash_content;
+
+	if (content_size > MAX_FLASH_FILE_SIZE) {
+		rsi_dbg(ERR_ZONE,
+			"%s: Flash Content size is more than 400K %u\n",
+			__func__, MAX_FLASH_FILE_SIZE);
+		goto fail;
+	}
+
+	flash_start_address = cpu_to_le32(
+				*(u32 *)&flash_content[FLASHING_START_ADDRESS]);
+	rsi_dbg(INFO_ZONE, "flash start address: %08x\n", flash_start_address);
+
+	if (flash_start_address < FW_IMAGE_MIN_ADDRESS) {
+		rsi_dbg(ERR_ZONE,
+			"%s: Fw image Flash Start Address is less than 68K\n",
+			__func__);
+		goto fail;
+	}
+
+	if (flash_start_address % FLASH_SECTOR_SIZE) {
+		rsi_dbg(ERR_ZONE,
+			"%s: Flash Start Address is not multiple of 4K\n",
+			__func__);
+		goto fail;
+	}
+
+	if ((flash_start_address + content_size) > adapter->flash_capacity) {
+		rsi_dbg(ERR_ZONE,
+			"%s: Flash Content will cross max flash size\n",
+			__func__);
+		goto fail;
+	}
+
+	temp_content_size  = content_size;
+	num_flash = content_size / FLASH_WRITE_CHUNK_SIZE;
+
+	rsi_dbg(INFO_ZONE, "content_size: %d\n", content_size);
+	rsi_dbg(INFO_ZONE, "num_flash: %d\n", num_flash);
+
+	for (index = 0; index <= num_flash; index++) {
+		rsi_dbg(INFO_ZONE, "flash index: %d\n", index);
+		if (index != num_flash) {
+			content_size = FLASH_WRITE_CHUNK_SIZE;
+			rsi_dbg(INFO_ZONE,
+				"QSPI content_size:%d\n",
+				content_size);
+		} else {
+			content_size =
+				temp_content_size % FLASH_WRITE_CHUNK_SIZE;
+			rsi_dbg(INFO_ZONE,
+				"Writing last sector content_size:%d\n",
+				content_size);
+			if (!content_size) {
+				rsi_dbg(INFO_ZONE, "INSTRUCTION SIZE ZERO\n");
+				break;
+			}
+		}
+
+		if (index % 2)
+			cmd = PING_WRITE;
+		else
+			cmd = PONG_WRITE;
+
+		if (ping_pong_write(adapter,
+				    cmd,
+				    flash_content,
+				    content_size)) {
+			rsi_dbg(ERR_ZONE,
+				"%s: Unable to load %d block\n",
+				__func__, index);
+			goto fail;
+		}
+
+		rsi_dbg(INFO_ZONE,
+			"%s: Successfully loaded %d instructions\n",
+			__func__, index);
+		flash_content += content_size;
+	}
+
+	if (bl_cmd(adapter, EOF_REACHED, FW_LOADING_SUCCESSFUL,
+		   "EOF_REACHED") < 0) {
+		bl_stop_cmd_timer(adapter);
+		goto fail;
+	}
+	rsi_dbg(INFO_ZONE, "FW loading is done and FW is running..\n");
+	return 0;
+
+fail:
+	return -1;
+}
+
+/**
+ * read_flash_content() - This function reads the flash content
+ *				from device
+ * @common: Pointer to the driver private structure.
+ *
+ * Return: status: 0 on success, -1 on failure.
+ */
+static int read_flash_content(struct rsi_hw *adapter,
+			      u8 *temp_buf,
+			      u32 address,
+			      u32 len)
+{
+	struct rsi_host_intf_ops *hif_ops = adapter->host_intf_ops;
+
+	if (adapter->rsi_host_intf == RSI_HOST_INTF_SDIO) {
+		if (hif_ops->master_access_msword(adapter,
+						  address >> 16) < 0) {
+			rsi_dbg(ERR_ZONE,
+				"%s: Unable to set ms word to common reg\n",
+				__func__);
+			return -1;
+		}
+		address &= 0xFFFF;
+		return hif_ops->read_reg_multiple(adapter,
+						address | RSI_SD_REQUEST_MASTER,
+						temp_buf, len);
+	} else {
+		return hif_ops->read_reg_multiple(adapter, address,
+						  temp_buf, len);
+	}
+
+	return 0;
+}
+
+/**
+ * verify_flash_content() - This function verifies the loaded flash content
+ *				from device
+ * @common: Pointer to the driver private structure.
+ *
+ * Return: status: 0 on success, -1 on failure.
+ */
+int verify_flash_content(struct rsi_hw *adapter,
+			 u8 *flash_content,
+			 u32 instructions_sz,
+			 u32 eeprom_offset,
+			 u8  read_mode)
+{
+	u32 status = 0;
+	u32 num_loops = 0, idx;
+	u32 chunk_size = 0;
+	u8 *dest_addr = NULL;
+	u32 addr = 0;
+	u32 flash_chunk_size;
+
+	if (adapter->rsi_host_intf == RSI_HOST_INTF_USB)
+		flash_chunk_size = USB_FLASH_READ_CHUNK_SIZE;
+	else
+		flash_chunk_size = SDIO_FLASH_READ_CHUNK_SIZE;
+
+	num_loops = instructions_sz / flash_chunk_size;
+
+	if (instructions_sz % flash_chunk_size)
+		num_loops++;
+
+	if (read_mode == EEPROM_READ_MODE) {
+		dest_addr = adapter->priv->rx_data_pkt;
+	} else {
+		dest_addr  = kzalloc(instructions_sz, GFP_KERNEL);
+		if (!dest_addr) {
+			rsi_dbg(ERR_ZONE,
+				"%s: Memory allocation for dest_addr failed\n",
+				__func__);
+			return -1;
+		}
+	}
+
+	rsi_dbg(INFO_ZONE, "Number of loops required: %d\n", num_loops);
+	for (idx = 0; idx < num_loops; idx++) {
+		if (instructions_sz < flash_chunk_size)
+			chunk_size = instructions_sz;
+		else
+			chunk_size = flash_chunk_size;
+		rsi_dbg(INFO_ZONE, "idx is %d and chunk size is %d\n",
+			idx, chunk_size);
+		if (read_mode == EEPROM_READ_MODE) {
+			adapter->eeprom.offset = eeprom_offset;
+			rsi_dbg(INFO_ZONE,
+				"eeprom offset is %x\n", eeprom_offset);
+			adapter->eeprom.length = chunk_size;
+			status = rsi_flash_read(adapter);
+			if (status == 0) {
+				rsi_dbg(INFO_ZONE,
+					"%s: BLOCK/SECTOR READING SUCCESSFUL\n",
+					__func__);
+			} else {
+				rsi_dbg(ERR_ZONE,
+					"%s: READING FROM FLASH FAILED\n",
+					__func__);
+				return -1;
+			}
+		} else {
+			memset(dest_addr, 0, chunk_size);
+			addr = SOC_FLASH_ADDR + eeprom_offset;
+			rsi_dbg(INFO_ZONE,
+				"Reading flash addr 0x%0x\n", addr);
+			if (read_flash_content(adapter, dest_addr, addr,
+					       flash_chunk_size) < 0) {
+				rsi_dbg(ERR_ZONE,
+					"%s:Failed to read calib data\n",
+					__func__);
+				kfree(dest_addr);
+				return -1;
+			}
+		}
+		if (memcmp(&flash_content[idx * flash_chunk_size],
+			   dest_addr,
+			   chunk_size)) {
+			rsi_dbg(ERR_ZONE,
+				"%s: VERIFICATION OF FLASH CHUNK FAILED\n",
+				__func__);
+			return -1;
+		}
+		eeprom_offset += chunk_size;
+		instructions_sz -= chunk_size;
+	}
+	return 0;
+}
+
+/**
+ * rsi_load_9113_firmware () - This function loads the TA firmware for 9113
+ *				device.
+ * @adapter: Pointer to the rsi hw.
+ *
+ * Return: status: 0 on success, -1 on failure.
+ */
+int rsi_load_9113_firmware(struct rsi_hw *adapter)
+{
+	struct rsi_host_intf_ops *hif_ops = adapter->host_intf_ops;
+	const struct firmware *fw_entry = NULL;
+	u32 regout_val = 0;
+	u16 tmp_regout_val = 0;
+	u8 *flash_content = NULL;
+	u32 content_size = 0;
+	struct ta_metadata *metadata_p;
+
+	bl_start_cmd_timer(adapter, BL_CMD_TIMEOUT);
+	while (!adapter->blcmd_timer_expired) {
+		if ((hif_ops->master_reg_read(adapter,
+					      SWBL_REGOUT,
+					      &regout_val,
+					      2)) < 0) {
+			rsi_dbg(ERR_ZONE,
+				"%s: REGOUT read failed\n", __func__);
+			goto fail;
+		}
+		mdelay(1);
+		if ((regout_val >> 8) == REGOUT_VALID)
+			break;
+	}
+	if (adapter->blcmd_timer_expired) {
+		rsi_dbg(ERR_ZONE, "%s: REGOUT read timedout\n", __func__);
+		rsi_dbg(ERR_ZONE,
+			"%s: Soft boot loader not present\n", __func__);
+		goto fail;
+	}
+	bl_stop_cmd_timer(adapter);
+
+	rsi_dbg(INFO_ZONE, "Received Board Version Number: %x\n",
+		(regout_val & 0xff));
+
+	if ((hif_ops->master_reg_write(adapter,
+				       SWBL_REGOUT,
+				       (REGOUT_INVALID | REGOUT_INVALID << 8),
+				       2)) < 0) {
+		rsi_dbg(ERR_ZONE, "%s: REGOUT writing failed..\n", __func__);
+		goto fail;
+	}
+	mdelay(1);
+
+	if ((bl_cmd(adapter, CONFIG_AUTO_READ_MODE, CMD_PASS,
+		    "AUTO_READ_CMD")) < 0)
+		goto fail;
+
+	adapter->flash_capacity = read_flash_capacity(adapter);
+	if (adapter->flash_capacity <= 0) {
+		rsi_dbg(ERR_ZONE,
+			"%s: Unable to read flash size from EEPROM\n",
+			__func__);
+		goto fail;
+	}
+
+	metadata_p = &metadata_flash_content[adapter->priv->coex_mode];
+
+	rsi_dbg(INIT_ZONE, "%s: loading file %s\n", __func__, metadata_p->name);
+
+	if ((request_firmware(&fw_entry, metadata_p->name,
+			      adapter->device)) < 0) {
+		rsi_dbg(ERR_ZONE, "%s: Failed to open file %s\n",
+			__func__, metadata_p->name);
+		goto fail;
+	}
+	flash_content = kmemdup(fw_entry->data, fw_entry->size, GFP_KERNEL);
+	if (!flash_content) {
+		rsi_dbg(ERR_ZONE, "%s: Failed to copy firmware\n", __func__);
+		goto fail;
+	}
+	content_size = fw_entry->size;
+
+	if (bl_write_header(adapter, flash_content, content_size)) {
+		rsi_dbg(ERR_ZONE,
+			"%s: RPS Image header loading failed\n",
+			__func__);
+		goto fail;
+	}
+
+	bl_start_cmd_timer(adapter, BL_CMD_TIMEOUT);
+	if (bl_write_cmd(adapter, CHECK_CRC, CMD_PASS, &tmp_regout_val) < 0) {
+		bl_stop_cmd_timer(adapter);
+		rsi_dbg(ERR_ZONE,
+			"%s: CHECK_CRC Command writing failed..\n",
+			__func__);
+		if ((tmp_regout_val & 0xff) == CMD_FAIL) {
+			rsi_dbg(ERR_ZONE,
+				"CRC Fail.. Proceeding to Upgrade mode\n");
+			goto fw_upgrade;
+		}
+	}
+	bl_stop_cmd_timer(adapter);
+
+	if (bl_cmd(adapter, POLLING_MODE, CMD_PASS, "POLLING_MODE") < 0)
+		goto fail;
+
+load_image_cmd:
+	if ((bl_cmd(adapter,
+		    LOAD_HOSTED_FW,
+		    LOADING_INITIATED,
+		    "LOAD_HOSTED_FW")) < 0)
+		goto fail;
+	rsi_dbg(INFO_ZONE, "Load Image command passed..\n");
+	goto success;
+
+fw_upgrade:
+	/* After burning the RPS header, firmware has to be
+	 * burned using the below steps
+	 */
+	if (bl_cmd(adapter, BURN_HOSTED_FW, SEND_RPS_FILE, "FW_UPGRADE") < 0)
+		goto fail;
+
+	rsi_dbg(INFO_ZONE, "Burn Command Pass.. Upgrading the firmware\n");
+
+	if (auto_fw_upgrade(adapter, flash_content, content_size) == 0) {
+		rsi_dbg(ERR_ZONE, "Auto firmware successful\n");
+		goto load_image_cmd;
+	}
+
+	if (bl_cmd(adapter, CONFIG_AUTO_READ_MODE,
+		   CMD_PASS, "AUTO_READ_MODE") < 0)
+		goto fail;
+
+	rsi_dbg(INFO_ZONE, "Starting Flash Verification Process\n");
+
+	if ((verify_flash_content(adapter,
+				  adapter->calib_data,
+				  EEPROM_DATA_SIZE,
+				  0,
+				  MASTER_READ_MODE)) < 0) {
+		rsi_dbg(ERR_ZONE,
+			"%s: FLASHING SBL failed in Calib VERIFICATION phase\n",
+			__func__);
+		goto fail;
+	}
+	if ((verify_flash_content(adapter,
+				  flash_content + BL_HEADER,
+				  (content_size - BL_HEADER),
+				  EEPROM_DATA_SIZE,
+				  MASTER_READ_MODE)) < 0) {
+		rsi_dbg(ERR_ZONE,
+			"%s:FLASHING SBL failed in SBL VERIFICATION phase\n",
+			__func__);
+		goto fail;
+	}
+	rsi_dbg(INFO_ZONE,
+		"Flash Verification Process Completed Successfully\n");
+	rsi_dbg(INFO_ZONE, "SWBL FLASHING THROUGH SWBL PASSED...\n");
+
+success:
+	kfree(flash_content);
+	release_firmware(fw_entry);
+	return 0;
+
+fail:
+	kfree(flash_content);
+	release_firmware(fw_entry);
+	return -1;
+}
+
+/**
+ * rsi_hal_device_init() - This function initializes the Device
+ * @adapter: Pointer to the hardware structure
+ *
+ * Return: status: 0 on success, -1 on failure.
+ */
+int rsi_hal_device_init(struct rsi_hw *adapter)
+{
+	struct rsi_host_intf_ops *hif_ops = adapter->host_intf_ops;
+
+#ifdef CONFIG_RSI_COEX
+	adapter->priv->coex_mode = 4;
+#else
+	adapter->priv->coex_mode = 1;
+#endif
+	adapter->device_model = RSI_DEV_9113; /* TODO: Get from module param */
+	switch (adapter->device_model) {
+	case RSI_DEV_9110:
+		/* TODO: Add code for 9110 */
+		break;
+	case RSI_DEV_9113:
+		if (rsi_load_9113_firmware(adapter)) {
+			rsi_dbg(ERR_ZONE,
+				"%s: Failed to load TA instructions\n",
+				__func__);
+			return -1;
+		}
+		break;
+	case RSI_DEV_9116:
+		/* TODO: Add code for 9116 */
+		break;
+	default:
+		return -1;
+	}
+	if (adapter->rsi_host_intf == RSI_HOST_INTF_SDIO) {
+		if (hif_ops->master_access_msword(adapter,
+						  MISC_CFG_BASE_ADDR)) {
+			rsi_dbg(ERR_ZONE,
+				"%s: Unable to set ms word reg\n",
+				__func__);
+			return -1;
+		}
+		rsi_dbg(INIT_ZONE,
+			"%s: Setting ms word to 0x41050000\n",
+			__func__);
+	}
+	adapter->common_hal_fsm = COMMAN_HAL_WAIT_FOR_CARD_READY;
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(rsi_hal_device_init);
+
diff --git a/drivers/net/wireless/rsi/rsi_91x_mgmt.c b/drivers/net/wireless/rsi/rsi_91x_mgmt.c
index 35c14cc..7aec45a 100644
--- a/drivers/net/wireless/rsi/rsi_91x_mgmt.c
+++ b/drivers/net/wireless/rsi/rsi_91x_mgmt.c
@@ -1240,6 +1240,55 @@ int rsi_send_block_unblock_frame(struct rsi_common *common, bool block_event)
 
 }
 
+/**
+ * rsi_flash_read() - This function sends the frash read frame to device
+ * @adapter: Pointer to the hardware structure.
+ *
+ * Return: status: 0 on success, -1 on failure.
+ */
+int rsi_flash_read(struct rsi_hw *adapter)
+{
+	struct rsi_common *common = adapter->priv;
+	struct rsi_mac_frame *cmd_frame = NULL;
+	struct sk_buff *skb;
+
+	rsi_dbg(MGMT_TX_ZONE, "%s: Sending flash read frame\n", __func__);
+
+	skb = dev_alloc_skb(FRAME_DESC_SZ);
+	if (!skb)
+		return -ENOMEM;
+
+	memset(skb->data, 0, FRAME_DESC_SZ);
+	cmd_frame = (struct rsi_mac_frame *)skb->data;
+
+	/* FrameType */
+	cmd_frame->desc_word[1] = cpu_to_le16(EEPROM_READ_TYPE);
+
+	/* Format of length and offset differs for
+	 * autoflashing and swbl flashing
+	 */
+	cmd_frame->desc_word[0] = cpu_to_le16(RSI_WIFI_MGMT_Q << 12);
+
+	/* Number of bytes to read */
+	rsi_dbg(INFO_ZONE, " eeprom length  0x%x, %d\n",
+		adapter->eeprom.length, adapter->eeprom.length);
+	cmd_frame->desc_word[3] = cpu_to_le16(adapter->eeprom.length << 4);
+
+	cmd_frame->desc_word[2] |= cpu_to_le16(3 << 8);
+	if (adapter->eeprom_init) {
+		rsi_dbg(INFO_ZONE, "spi init sent");
+		cmd_frame->desc_word[2] |= cpu_to_le16(BIT(13));
+	}
+
+	/* Address to read */
+	cmd_frame->desc_word[4] = cpu_to_le16(adapter->eeprom.offset);
+	cmd_frame->desc_word[5] = cpu_to_le16(adapter->eeprom.offset >> 16);
+	cmd_frame->desc_word[6] = cpu_to_le16(0); //delay = 0
+
+	skb_put(skb, FRAME_DESC_SZ);
+
+	return rsi_send_internal_mgmt_frame(common, skb);
+}
 
 /**
  * rsi_handle_ta_confirm_type() - This function handles the confirm frames.
diff --git a/drivers/net/wireless/rsi/rsi_91x_pkt.c b/drivers/net/wireless/rsi/rsi_91x_pkt.c
deleted file mode 100644
index 02920c9..0000000
--- a/drivers/net/wireless/rsi/rsi_91x_pkt.c
+++ /dev/null
@@ -1,215 +0,0 @@
-/**
- * Copyright (c) 2014 Redpine Signals Inc.
- *
- * Permission to use, copy, modify, and/or distribute this software for any
- * purpose with or without fee is hereby granted, provided that the above
- * copyright notice and this permission notice appear in all copies.
- *
- * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
- * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
- * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
- * ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
- * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
- * ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
- * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
- */
-
-#include "rsi_mgmt.h"
-
-/**
- * rsi_send_data_pkt() - This function sends the recieved data packet from
- *			 driver to device.
- * @common: Pointer to the driver private structure.
- * @skb: Pointer to the socket buffer structure.
- *
- * Return: status: 0 on success, -1 on failure.
- */
-int rsi_send_data_pkt(struct rsi_common *common, struct sk_buff *skb)
-{
-	struct rsi_hw *adapter = common->priv;
-	struct ieee80211_hdr *tmp_hdr;
-	struct ieee80211_tx_info *info;
-	struct skb_info *tx_params;
-	struct ieee80211_bss_conf *bss;
-	int status;
-	u8 ieee80211_size = MIN_802_11_HDR_LEN;
-	u8 extnd_size;
-	__le16 *frame_desc;
-	u16 seq_num;
-
-	info = IEEE80211_SKB_CB(skb);
-	bss = &info->control.vif->bss_conf;
-	tx_params = (struct skb_info *)info->driver_data;
-
-	if (!bss->assoc) {
-		status = -EINVAL;
-		goto err;
-	}
-
-	tmp_hdr = (struct ieee80211_hdr *)&skb->data[0];
-	seq_num = (le16_to_cpu(tmp_hdr->seq_ctrl) >> 4);
-
-	extnd_size = ((uintptr_t)skb->data & 0x3);
-
-	if ((FRAME_DESC_SZ + extnd_size) > skb_headroom(skb)) {
-		rsi_dbg(ERR_ZONE, "%s: Unable to send pkt\n", __func__);
-		status = -ENOSPC;
-		goto err;
-	}
-
-	skb_push(skb, (FRAME_DESC_SZ + extnd_size));
-	frame_desc = (__le16 *)&skb->data[0];
-	memset((u8 *)frame_desc, 0, FRAME_DESC_SZ);
-
-	if (ieee80211_is_data_qos(tmp_hdr->frame_control)) {
-		ieee80211_size += 2;
-		frame_desc[6] |= cpu_to_le16(BIT(12));
-	}
-
-	if ((!(info->flags & IEEE80211_TX_INTFL_DONT_ENCRYPT)) &&
-	    (common->secinfo.security_enable)) {
-		if (rsi_is_cipher_wep(common))
-			ieee80211_size += 4;
-		else
-			ieee80211_size += 8;
-		frame_desc[6] |= cpu_to_le16(BIT(15));
-	}
-
-	frame_desc[0] = cpu_to_le16((skb->len - FRAME_DESC_SZ) |
-				    (RSI_WIFI_DATA_Q << 12));
-	frame_desc[2] = cpu_to_le16((extnd_size) | (ieee80211_size) << 8);
-
-	if (common->min_rate != 0xffff) {
-		/* Send fixed rate */
-		frame_desc[3] = cpu_to_le16(RATE_INFO_ENABLE);
-		frame_desc[4] = cpu_to_le16(common->min_rate);
-
-		if (conf_is_ht40(&common->priv->hw->conf))
-			frame_desc[5] = cpu_to_le16(FULL40M_ENABLE);
-
-		if (common->vif_info[0].sgi) {
-			if (common->min_rate & 0x100) /* Only MCS rates */
-				frame_desc[4] |=
-					cpu_to_le16(ENABLE_SHORTGI_RATE);
-		}
-
-	}
-
-	frame_desc[6] |= cpu_to_le16(seq_num & 0xfff);
-	frame_desc[7] = cpu_to_le16(((tx_params->tid & 0xf) << 4) |
-				    (skb->priority & 0xf) |
-				    (tx_params->sta_id << 8));
-
-	status = adapter->host_intf_write_pkt(common->priv,
-					      skb->data,
-					      skb->len);
-	if (status)
-		rsi_dbg(ERR_ZONE, "%s: Failed to write pkt\n",
-			__func__);
-
-err:
-	++common->tx_stats.total_tx_pkt_freed[skb->priority];
-	rsi_indicate_tx_status(common->priv, skb, status);
-	return status;
-}
-
-/**
- * rsi_send_mgmt_pkt() - This functions sends the received management packet
- *			 from driver to device.
- * @common: Pointer to the driver private structure.
- * @skb: Pointer to the socket buffer structure.
- *
- * Return: status: 0 on success, -1 on failure.
- */
-int rsi_send_mgmt_pkt(struct rsi_common *common,
-		      struct sk_buff *skb)
-{
-	struct rsi_hw *adapter = common->priv;
-	struct ieee80211_hdr *wh;
-	struct ieee80211_tx_info *info;
-	struct ieee80211_bss_conf *bss;
-	struct ieee80211_hw *hw = adapter->hw;
-	struct ieee80211_conf *conf = &hw->conf;
-	struct skb_info *tx_params;
-	int status = -E2BIG;
-	__le16 *msg;
-	u8 extnd_size;
-	u8 vap_id = 0;
-
-	info = IEEE80211_SKB_CB(skb);
-	tx_params = (struct skb_info *)info->driver_data;
-	extnd_size = ((uintptr_t)skb->data & 0x3);
-
-	if (tx_params->flags & INTERNAL_MGMT_PKT) {
-		if ((extnd_size) > skb_headroom(skb)) {
-			rsi_dbg(ERR_ZONE, "%s: Unable to send pkt\n", __func__);
-			dev_kfree_skb(skb);
-			return -ENOSPC;
-		}
-		skb_push(skb, extnd_size);
-		skb->data[extnd_size + 4] = extnd_size;
-		status = adapter->host_intf_write_pkt(common->priv,
-						      (u8 *)skb->data,
-						      skb->len);
-		if (status) {
-			rsi_dbg(ERR_ZONE,
-				"%s: Failed to write the packet\n", __func__);
-		}
-		dev_kfree_skb(skb);
-		return status;
-	}
-
-	bss = &info->control.vif->bss_conf;
-	wh = (struct ieee80211_hdr *)&skb->data[0];
-
-	if (FRAME_DESC_SZ > skb_headroom(skb))
-		goto err;
-
-	skb_push(skb, FRAME_DESC_SZ);
-	memset(skb->data, 0, FRAME_DESC_SZ);
-	msg = (__le16 *)skb->data;
-
-	if (skb->len > MAX_MGMT_PKT_SIZE) {
-		rsi_dbg(INFO_ZONE, "%s: Dropping mgmt pkt > 512\n", __func__);
-		goto err;
-	}
-
-	msg[0] = cpu_to_le16((skb->len - FRAME_DESC_SZ) |
-			    (RSI_WIFI_MGMT_Q << 12));
-	msg[1] = cpu_to_le16(TX_DOT11_MGMT);
-	msg[2] = cpu_to_le16(MIN_802_11_HDR_LEN << 8);
-	msg[3] = cpu_to_le16(RATE_INFO_ENABLE);
-	msg[6] = cpu_to_le16(le16_to_cpu(wh->seq_ctrl) >> 4);
-
-	if (wh->addr1[0] & BIT(0))
-		msg[3] |= cpu_to_le16(RSI_BROADCAST_PKT);
-
-	if (common->band == NL80211_BAND_2GHZ)
-		msg[4] = cpu_to_le16(RSI_11B_MODE);
-	else
-		msg[4] = cpu_to_le16((RSI_RATE_6 & 0x0f) | RSI_11G_MODE);
-
-	if (conf_is_ht40(conf)) {
-		msg[4] = cpu_to_le16(0xB | RSI_11G_MODE);
-		msg[5] = cpu_to_le16(0x6);
-	}
-
-	/* Indicate to firmware to give cfm */
-	if ((skb->data[16] == IEEE80211_STYPE_PROBE_REQ) && (!bss->assoc)) {
-		msg[1] |= cpu_to_le16(BIT(10));
-		msg[7] = cpu_to_le16(PROBEREQ_CONFIRM);
-		common->mgmt_q_block = true;
-	}
-
-	msg[7] |= cpu_to_le16(vap_id << 8);
-
-	status = adapter->host_intf_write_pkt(common->priv,
-					      (u8 *)msg,
-					      skb->len);
-	if (status)
-		rsi_dbg(ERR_ZONE, "%s: Failed to write the packet\n", __func__);
-
-err:
-	rsi_indicate_tx_status(common->priv, skb, status);
-	return status;
-}
diff --git a/drivers/net/wireless/rsi/rsi_91x_sdio.c b/drivers/net/wireless/rsi/rsi_91x_sdio.c
index 8428858..6f02600 100644
--- a/drivers/net/wireless/rsi/rsi_91x_sdio.c
+++ b/drivers/net/wireless/rsi/rsi_91x_sdio.c
@@ -1,6 +1,8 @@
 /**
  * Copyright (c) 2014 Redpine Signals Inc.
  *
+ * Developers:
+ *		Fariya Fathima	2014 <fariya.f@redpinesignals.com>
  * Permission to use, copy, modify, and/or distribute this software for any
  * purpose with or without fee is hereby granted, provided that the above
  * copyright notice and this permission notice appear in all copies.
@@ -18,6 +20,7 @@
 #include <linux/module.h>
 #include "rsi_sdio.h"
 #include "rsi_common.h"
+#include "rsi_hal.h"
 
 /**
  * rsi_sdio_set_cmd52_arg() - This function prepares cmd 52 read/write arg.
@@ -386,6 +389,7 @@ static int rsi_setupcard(struct rsi_hw *adapter)
 	rsi_setclock(adapter, 50000);
 
 	dev->tx_blk_size = 256;
+	adapter->tx_blk_size = dev->tx_blk_size;
 	status = rsi_setblocklength(adapter, dev->tx_blk_size);
 	if (status)
 		rsi_dbg(ERR_ZONE,
@@ -473,8 +477,6 @@ void rsi_sdio_ack_intr(struct rsi_hw *adapter, u8 int_bit)
 		rsi_dbg(ERR_ZONE, "%s: unable to send ack\n", __func__);
 }
 
-
-
 /**
  * rsi_sdio_read_register_multiple() - This function read multiple bytes of
  *				       information from the SD card.
@@ -485,10 +487,10 @@ void rsi_sdio_ack_intr(struct rsi_hw *adapter, u8 int_bit)
  *
  * Return: 0 on success, -1 on failure.
  */
-static int rsi_sdio_read_register_multiple(struct rsi_hw *adapter,
-					   u32 addr,
-					   u32 count,
-					   u8 *data)
+int rsi_sdio_read_register_multiple(struct rsi_hw *adapter,
+				    u32 addr,
+				    u8 *data,
+				    u16 count)
 {
 	struct rsi_91x_sdiodev *dev =
 		(struct rsi_91x_sdiodev *)adapter->rsi_dev;
@@ -518,7 +520,7 @@ static int rsi_sdio_read_register_multiple(struct rsi_hw *adapter,
 int rsi_sdio_write_register_multiple(struct rsi_hw *adapter,
 				     u32 addr,
 				     u8 *data,
-				     u32 count)
+				     u16 count)
 {
 	struct rsi_91x_sdiodev *dev =
 		(struct rsi_91x_sdiodev *)adapter->rsi_dev;
@@ -552,6 +554,178 @@ int rsi_sdio_write_register_multiple(struct rsi_hw *adapter,
 	return status;
 }
 
+int rsi_sdio_load_data_master_write(struct rsi_hw *adapter,
+				    u32 base_address,
+				    u32 instructions_sz,
+				    u16 block_size,
+				    u8 *ta_firmware)
+{
+	u32 num_blocks;
+	u16 msb_address;
+	u32 offset, ii;
+	u8 temp_buf[256];
+	u16 lsb_address;
+
+	num_blocks = instructions_sz / block_size;
+	msb_address = base_address >> 16;
+
+	rsi_dbg(INFO_ZONE, "num_blocks: %d\n", num_blocks);
+
+	/* Loading DM ms word in the sdio slave */
+	if (rsi_sdio_master_access_msword(adapter, msb_address)) {
+		rsi_dbg(ERR_ZONE, "%s: Unable to set ms word reg\n", __func__);
+		return -1;
+	}
+
+	for (offset = 0, ii = 0; ii < num_blocks; ii++, offset += block_size) {
+		memset(temp_buf, 0, block_size);
+		memcpy(temp_buf, ta_firmware + offset, block_size);
+		lsb_address = (u16)base_address;
+		if (rsi_sdio_write_register_multiple(adapter,
+					lsb_address | RSI_SD_REQUEST_MASTER,
+					(u8 *)temp_buf, block_size)) {
+			rsi_dbg(ERR_ZONE, "%s: failed to write\n", __func__);
+			return -1;
+		}
+		rsi_dbg(INFO_ZONE, "%s: loading block: %d\n", __func__, ii);
+		base_address += block_size;
+		base_address += block_size;
+
+		if ((base_address >> 16) != msb_address) {
+			msb_address += 1;
+
+			/* Loading DM ms word in the sdio slave */
+			if (rsi_sdio_master_access_msword(adapter,
+							  msb_address)) {
+				rsi_dbg(ERR_ZONE,
+					"%s: Unable to set ms word reg\n",
+					__func__);
+				return -1;
+			}
+		}
+	}
+
+	if (instructions_sz % block_size) {
+		memset(temp_buf, 0, block_size);
+		memcpy(temp_buf,
+		       ta_firmware + offset,
+		       instructions_sz % block_size);
+		lsb_address = (u16)base_address;
+		if (rsi_sdio_write_register_multiple(adapter,
+					lsb_address | RSI_SD_REQUEST_MASTER,
+					(u8 *)(temp_buf),
+					instructions_sz % block_size)) {
+			return -1;
+		}
+		rsi_dbg(INFO_ZONE,
+			"Written Last Block in Address 0x%x Successfully\n",
+			offset | RSI_SD_REQUEST_MASTER);
+	}
+	return 0;
+}
+
+#define align_address(a) ((unsigned long)(a) & ~0x7)
+
+int rsi_sdio_master_reg_read(struct rsi_hw *adapter, u32 addr,
+			     u32 *read_buf, u16 size)
+{
+	u32 *data = NULL;
+	u16 ms_addr = 0;
+	u32 align[2] = {};
+	u32 addr_on_bus;
+
+	data = (u32 *)align_address(&align[1]);
+
+	ms_addr = (addr >> 16);
+	if (rsi_sdio_master_access_msword(adapter, ms_addr)) {
+		rsi_dbg(ERR_ZONE,
+			"%s: Unable to set ms word to common reg\n",
+			__func__);
+		return -1;
+	}
+	addr = addr & 0xFFFF;
+
+	addr_on_bus = (addr & 0xFF000000);
+	if ((addr_on_bus == (FLASH_SIZE_ADDR & 0xFF000000)) ||
+	    (addr_on_bus == 0x0)) {
+		addr_on_bus = (addr & ~(0x3));
+	} else
+		addr_on_bus = addr;
+
+	/* Bringing TA out of reset */
+	if (rsi_sdio_read_register_multiple(adapter,
+					(addr_on_bus | RSI_SD_REQUEST_MASTER),
+					(u8 *)data, 4)) {
+		rsi_dbg(ERR_ZONE, "%s: AHB register read failed\n", __func__);
+		return -1;
+	}
+	if (size == 2) {
+		if ((addr & 0x3) == 0)
+			*read_buf = *data;
+		else
+			*read_buf  = ((*data >> 16));
+		*read_buf = (*read_buf & 0xFFFF);
+	} else if (size == 1) {
+		if ((addr & 0x3) == 0)
+			*read_buf = *data;
+		else if ((addr & 0x3) == 1)
+			*read_buf = (*data >> 8);
+		else if ((addr & 0x3) == 2)
+			*read_buf = (*data >> 16);
+		else
+			*read_buf = (*data >> 24);
+		*read_buf = (*read_buf & 0xFF);
+	} else { /*size is 4 */
+		*read_buf = *data;
+	}
+
+	return 0;
+}
+
+int rsi_sdio_master_reg_write(struct rsi_hw *adapter,
+			      unsigned long addr,
+			      unsigned long data,
+			      u16 size)
+{
+	unsigned long data1[2];
+	unsigned long *data_alligned;
+
+	data_alligned = (unsigned long *)align_address(&data1[1]);
+
+	if (size == 2) {
+		*data_alligned = ((data << 16) | (data & 0xFFFF));
+	} else if (size == 1) {
+		u32 temp_data;
+
+		temp_data = (data & 0xFF);
+		*data_alligned = ((temp_data << 24) |
+				  (temp_data << 16) |
+				  (temp_data << 8) |
+				  (temp_data));
+	} else {
+		*data_alligned = data;
+	}
+	size = 4;
+
+	if (rsi_sdio_master_access_msword(adapter, (addr >> 16))) {
+		rsi_dbg(ERR_ZONE,
+			"%s: Unable to set ms word to common reg\n",
+			__func__);
+		return -1;
+	}
+	addr = addr & 0xFFFF;
+
+	/* Bringing TA out of reset */
+	if (rsi_sdio_write_register_multiple(adapter,
+					     (addr | RSI_SD_REQUEST_MASTER),
+					     (u8 *)data_alligned, size)) {
+		rsi_dbg(ERR_ZONE,
+			"%s: Unable to do AHB reg write\n", __func__);
+		return -1;
+	}
+	return 0;
+}
+
 /**
  * rsi_sdio_host_intf_write_pkt() - This function writes the packet to device.
  * @adapter: Pointer to the adapter structure.
@@ -560,9 +734,9 @@ int rsi_sdio_write_register_multiple(struct rsi_hw *adapter,
  *
  * Return: 0 on success, -1 on failure.
  */
-static int rsi_sdio_host_intf_write_pkt(struct rsi_hw *adapter,
-					u8 *pkt,
-					u32 len)
+int rsi_sdio_host_intf_write_pkt(struct rsi_hw *adapter,
+				 u8 *pkt,
+				 u32 len)
 {
 	struct rsi_91x_sdiodev *dev =
 		(struct rsi_91x_sdiodev *)adapter->rsi_dev;
@@ -585,7 +759,7 @@ static int rsi_sdio_host_intf_write_pkt(struct rsi_hw *adapter,
 						  address,
 						  (u8 *)pkt,
 						  length);
-	if (status)
+	if (status < 0)
 		rsi_dbg(ERR_ZONE, "%s: Unable to write onto the card: %d\n",
 			__func__, status);
 	rsi_dbg(DATA_TX_ZONE, "%s: Successfully written onto card\n", __func__);
@@ -614,8 +788,8 @@ int rsi_sdio_host_intf_read_pkt(struct rsi_hw *adapter,
 
 	status = rsi_sdio_read_register_multiple(adapter,
 						 length,
-						 length, /*num of bytes*/
-						 (u8 *)pkt);
+						 (u8 *)pkt,
+						 length);
 
 	if (status)
 		rsi_dbg(ERR_ZONE, "%s: Failed to read frame: %d\n", __func__,
@@ -676,8 +850,6 @@ static int rsi_init_sdio_interface(struct rsi_hw *adapter,
 	}
 	sdio_release_host(pfunction);
 
-	adapter->host_intf_write_pkt = rsi_sdio_host_intf_write_pkt;
-	adapter->host_intf_read_pkt = rsi_sdio_host_intf_read_pkt;
 	adapter->determine_event_timeout = rsi_sdio_determine_event_timeout;
 	adapter->check_hw_queue_status = rsi_sdio_read_buffer_status_register;
 
@@ -691,6 +863,17 @@ static int rsi_init_sdio_interface(struct rsi_hw *adapter,
 	return status;
 }
 
+static struct rsi_host_intf_ops sdio_host_intf_ops = {
+	.write_pkt		= rsi_sdio_host_intf_write_pkt,
+	.read_pkt		= rsi_sdio_host_intf_read_pkt,
+	.master_access_msword	= rsi_sdio_master_access_msword,
+	.master_reg_read	= rsi_sdio_master_reg_read,
+	.master_reg_write	= rsi_sdio_master_reg_write,
+	.read_reg_multiple	= rsi_sdio_read_register_multiple,
+	.write_reg_multiple	= rsi_sdio_write_register_multiple,
+	.load_data_master_write	= rsi_sdio_load_data_master_write,
+};
+
 /**
  * rsi_probe() - This function is called by kernel when the driver provided
  *		 Vendor and device IDs are matched. All the initialization
@@ -713,6 +896,8 @@ static int rsi_probe(struct sdio_func *pfunction,
 			__func__);
 		return 1;
 	}
+	adapter->rsi_host_intf = RSI_HOST_INTF_SDIO;
+	adapter->host_intf_ops = &sdio_host_intf_ops;
 
 	if (rsi_init_sdio_interface(adapter, pfunction)) {
 		rsi_dbg(ERR_ZONE, "%s: Failed to init sdio interface\n",
@@ -720,14 +905,6 @@ static int rsi_probe(struct sdio_func *pfunction,
 		goto fail;
 	}
 
-	if (rsi_sdio_device_init(adapter->priv)) {
-		rsi_dbg(ERR_ZONE, "%s: Failed in device init\n", __func__);
-		sdio_claim_host(pfunction);
-		sdio_disable_func(pfunction);
-		sdio_release_host(pfunction);
-		goto fail;
-	}
-
 	sdio_claim_host(pfunction);
 	if (sdio_claim_irq(pfunction, rsi_handle_interrupt)) {
 		rsi_dbg(ERR_ZONE, "%s: Failed to request IRQ\n", __func__);
@@ -738,6 +915,14 @@ static int rsi_probe(struct sdio_func *pfunction,
 	sdio_release_host(pfunction);
 	rsi_dbg(INIT_ZONE, "%s: Registered Interrupt handler\n", __func__);
 
+	if (rsi_hal_device_init(adapter)) {
+		rsi_dbg(ERR_ZONE, "%s: Failed in device init\n", __func__);
+		sdio_claim_host(pfunction);
+		sdio_disable_func(pfunction);
+		sdio_release_host(pfunction);
+		goto fail;
+	}
+
 	return 0;
 fail:
 	rsi_91x_deinit(adapter);
diff --git a/drivers/net/wireless/rsi/rsi_91x_sdio_ops.c b/drivers/net/wireless/rsi/rsi_91x_sdio_ops.c
index 40d7231..c54a534 100644
--- a/drivers/net/wireless/rsi/rsi_91x_sdio_ops.c
+++ b/drivers/net/wireless/rsi/rsi_91x_sdio_ops.c
@@ -18,6 +18,7 @@
 #include <linux/firmware.h>
 #include "rsi_sdio.h"
 #include "rsi_common.h"
+#include "rsi_hal.h"
 
 /**
  * rsi_sdio_master_access_msword() - This function sets the AHB master access
@@ -27,8 +28,8 @@
  *
  * Return: status: 0 on success, -1 on failure.
  */
-static int rsi_sdio_master_access_msword(struct rsi_hw *adapter,
-					 u16 ms_word)
+int rsi_sdio_master_access_msword(struct rsi_hw *adapter,
+				  u16 ms_word)
 {
 	u8 byte;
 	u8 function = 0;
@@ -61,171 +62,6 @@ static int rsi_sdio_master_access_msword(struct rsi_hw *adapter,
 }
 
 /**
- * rsi_copy_to_card() - This function includes the actual funtionality of
- *			copying the TA firmware to the card.Basically this
- *			function includes opening the TA file,reading the
- *			TA file and writing their values in blocks of data.
- * @common: Pointer to the driver private structure.
- * @fw: Pointer to the firmware value to be written.
- * @len: length of firmware file.
- * @num_blocks: Number of blocks to be written to the card.
- *
- * Return: 0 on success and -1 on failure.
- */
-static int rsi_copy_to_card(struct rsi_common *common,
-			    const u8 *fw,
-			    u32 len,
-			    u32 num_blocks)
-{
-	struct rsi_hw *adapter = common->priv;
-	struct rsi_91x_sdiodev *dev =
-		(struct rsi_91x_sdiodev *)adapter->rsi_dev;
-	u32 indx, ii;
-	u32 block_size = dev->tx_blk_size;
-	u32 lsb_address;
-	__le32 data[] = { TA_HOLD_THREAD_VALUE, TA_SOFT_RST_CLR,
-			  TA_PC_ZERO, TA_RELEASE_THREAD_VALUE };
-	u32 address[] = { TA_HOLD_THREAD_REG, TA_SOFT_RESET_REG,
-			  TA_TH0_PC_REG, TA_RELEASE_THREAD_REG };
-	u32 base_address;
-	u16 msb_address;
-
-	base_address = TA_LOAD_ADDRESS;
-	msb_address = base_address >> 16;
-
-	for (indx = 0, ii = 0; ii < num_blocks; ii++, indx += block_size) {
-		lsb_address = ((u16) base_address | RSI_SD_REQUEST_MASTER);
-		if (rsi_sdio_write_register_multiple(adapter,
-						     lsb_address,
-						     (u8 *)(fw + indx),
-						     block_size)) {
-			rsi_dbg(ERR_ZONE,
-				"%s: Unable to load %s blk\n", __func__,
-				FIRMWARE_RSI9113);
-			return -1;
-		}
-		rsi_dbg(INIT_ZONE, "%s: loading block: %d\n", __func__, ii);
-		base_address += block_size;
-		if ((base_address >> 16) != msb_address) {
-			msb_address += 1;
-			if (rsi_sdio_master_access_msword(adapter,
-							  msb_address)) {
-				rsi_dbg(ERR_ZONE,
-					"%s: Unable to set ms word reg\n",
-					__func__);
-				return -1;
-			}
-		}
-	}
-
-	if (len % block_size) {
-		lsb_address = ((u16) base_address | RSI_SD_REQUEST_MASTER);
-		if (rsi_sdio_write_register_multiple(adapter,
-						     lsb_address,
-						     (u8 *)(fw + indx),
-						     len % block_size)) {
-			rsi_dbg(ERR_ZONE,
-				"%s: Unable to load f/w\n", __func__);
-			return -1;
-		}
-	}
-	rsi_dbg(INIT_ZONE,
-		"%s: Succesfully loaded TA instructions\n", __func__);
-
-	if (rsi_sdio_master_access_msword(adapter, TA_BASE_ADDR)) {
-		rsi_dbg(ERR_ZONE,
-			"%s: Unable to set ms word to common reg\n",
-			__func__);
-		return -1;
-	}
-
-	for (ii = 0; ii < ARRAY_SIZE(data); ii++) {
-		/* Bringing TA out of reset */
-		if (rsi_sdio_write_register_multiple(adapter,
-						     (address[ii] |
-						     RSI_SD_REQUEST_MASTER),
-						     (u8 *)&data[ii],
-						     4)) {
-			rsi_dbg(ERR_ZONE,
-				"%s: Unable to hold TA threads\n", __func__);
-			return -1;
-		}
-	}
-
-	rsi_dbg(INIT_ZONE, "%s: loaded firmware\n", __func__);
-	return 0;
-}
-
-/**
- * rsi_load_ta_instructions() - This function includes the actual funtionality
- *				of loading the TA firmware.This function also
- *				includes opening the TA file,reading the TA
- *				file and writing their value in blocks of data.
- * @common: Pointer to the driver private structure.
- *
- * Return: status: 0 on success, -1 on failure.
- */
-static int rsi_load_ta_instructions(struct rsi_common *common)
-{
-	struct rsi_hw *adapter = common->priv;
-	struct rsi_91x_sdiodev *dev =
-		(struct rsi_91x_sdiodev *)adapter->rsi_dev;
-	u32 len;
-	u32 num_blocks;
-	const u8 *fw;
-	const struct firmware *fw_entry = NULL;
-	u32 block_size = dev->tx_blk_size;
-	int status = 0;
-	u32 base_address;
-	u16 msb_address;
-
-	if (rsi_sdio_master_access_msword(adapter, TA_BASE_ADDR)) {
-		rsi_dbg(ERR_ZONE,
-			"%s: Unable to set ms word to common reg\n",
-			__func__);
-		return -1;
-	}
-	base_address = TA_LOAD_ADDRESS;
-	msb_address = (base_address >> 16);
-
-	if (rsi_sdio_master_access_msword(adapter, msb_address)) {
-		rsi_dbg(ERR_ZONE,
-			"%s: Unable to set ms word reg\n", __func__);
-		return -1;
-	}
-
-	status = request_firmware(&fw_entry, FIRMWARE_RSI9113, adapter->device);
-	if (status < 0) {
-		rsi_dbg(ERR_ZONE, "%s Firmware file %s not found\n",
-			__func__, FIRMWARE_RSI9113);
-		return status;
-	}
-
-	/* Copy firmware into DMA-accessible memory */
-	fw = kmemdup(fw_entry->data, fw_entry->size, GFP_KERNEL);
-	if (!fw) {
-		status = -ENOMEM;
-		goto out;
-	}
-	len = fw_entry->size;
-
-	if (len % 4)
-		len += (4 - (len % 4));
-
-	num_blocks = (len / block_size);
-
-	rsi_dbg(INIT_ZONE, "%s: Instruction size:%d\n", __func__, len);
-	rsi_dbg(INIT_ZONE, "%s: num blocks: %d\n", __func__, num_blocks);
-
-	status = rsi_copy_to_card(common, fw, len, num_blocks);
-	kfree(fw);
-
-out:
-	release_firmware(fw_entry);
-	return status;
-}
-
-/**
  * rsi_process_pkt() - This Function reads rx_blocks register and figures out
  *		       the size of the rx pkt.
  * @common: Pointer to the driver private structure.
@@ -472,28 +308,6 @@ void rsi_interrupt_handler(struct rsi_hw *adapter)
 }
 
 /**
- * rsi_device_init() - This Function Initializes The HAL.
- * @common: Pointer to the driver private structure.
- *
- * Return: 0 on success, -1 on failure.
- */
-int rsi_sdio_device_init(struct rsi_common *common)
-{
-	if (rsi_load_ta_instructions(common))
-		return -1;
-
-	if (rsi_sdio_master_access_msword(common->priv, MISC_CFG_BASE_ADDR)) {
-		rsi_dbg(ERR_ZONE, "%s: Unable to set ms word reg\n",
-			__func__);
-		return -1;
-	}
-	rsi_dbg(INIT_ZONE,
-		"%s: Setting ms word to 0x41050000\n", __func__);
-
-	return 0;
-}
-
-/**
  * rsi_sdio_read_buffer_status_register() - This function is used to the read
  *					    buffer status register and set
  *					    relevant fields in
diff --git a/drivers/net/wireless/rsi/rsi_91x_usb.c b/drivers/net/wireless/rsi/rsi_91x_usb.c
index ef5d394..84ca609 100644
--- a/drivers/net/wireless/rsi/rsi_91x_usb.c
+++ b/drivers/net/wireless/rsi/rsi_91x_usb.c
@@ -1,6 +1,9 @@
 /**
  * Copyright (c) 2014 Redpine Signals Inc.
  *
+ * Developers:
+ *	Prameela Rani Garnepudi	2016 <prameela.garnepudi@redpinesignals.com>
+ *
  * Permission to use, copy, modify, and/or distribute this software for any
  * purpose with or without fee is hereby granted, provided that the above
  * copyright notice and this permission notice appear in all copies.
@@ -17,6 +20,16 @@
 
 #include <linux/module.h>
 #include "rsi_usb.h"
+#include "rsi_hal.h"
+
+static struct rsi_host_intf_ops usb_host_intf_ops = {
+	.write_pkt		= rsi_usb_host_intf_write_pkt,
+	.master_reg_read	= rsi_usb_master_reg_read,
+	.master_reg_write	= rsi_usb_master_reg_write,
+	.read_reg_multiple	= rsi_usb_read_register_multiple,
+	.write_reg_multiple	= rsi_usb_write_register_multiple,
+	.load_data_master_write	= rsi_usb_load_data_master_write,
+};
 
 /**
  * rsi_usb_card_write() - This function writes to the USB Card.
@@ -141,6 +154,9 @@ static int rsi_find_bulk_in_and_out_endpoints(struct usb_interface *interface,
 	return 0;
 }
 
+#define RSI_USB_REQ_OUT	(USB_TYPE_VENDOR | USB_DIR_OUT | USB_RECIP_DEVICE)
+#define RSI_USB_REQ_IN	(USB_TYPE_VENDOR | USB_DIR_IN | USB_RECIP_DEVICE)
+
 /* rsi_usb_reg_read() - This function reads data from given register address.
  * @usbdev: Pointer to the usb_device structure.
  * @reg: Address of the register to be read.
@@ -151,7 +167,7 @@ static int rsi_find_bulk_in_and_out_endpoints(struct usb_interface *interface,
  */
 static int rsi_usb_reg_read(struct usb_device *usbdev,
 			    u32 reg,
-			    u16 *value,
+			    u32 *value,
 			    u16 len)
 {
 	u8 *buf;
@@ -161,10 +177,11 @@ static int rsi_usb_reg_read(struct usb_device *usbdev,
 	if (!buf)
 		return status;
 
+	len = 2;
 	status = usb_control_msg(usbdev,
 				 usb_rcvctrlpipe(usbdev, 0),
 				 USB_VENDOR_REGISTER_READ,
-				 USB_TYPE_VENDOR,
+				 RSI_USB_REQ_IN,
 				 ((reg & 0xffff0000) >> 16), (reg & 0xffff),
 				 (void *)buf,
 				 len,
@@ -193,7 +210,7 @@ static int rsi_usb_reg_read(struct usb_device *usbdev,
  */
 static int rsi_usb_reg_write(struct usb_device *usbdev,
 			     u32 reg,
-			     u16 value,
+			     u32 value,
 			     u16 len)
 {
 	u8 *usb_reg_buf;
@@ -211,7 +228,7 @@ static int rsi_usb_reg_write(struct usb_device *usbdev,
 	status = usb_control_msg(usbdev,
 				 usb_sndctrlpipe(usbdev, 0),
 				 USB_VENDOR_REGISTER_WRITE,
-				 USB_TYPE_VENDOR,
+				 RSI_USB_REQ_OUT,
 				 ((reg & 0xffff0000) >> 16),
 				 (reg & 0xffff),
 				 (void *)usb_reg_buf,
@@ -274,6 +291,62 @@ static int rsi_rx_urb_submit(struct rsi_hw *adapter)
 }
 
 /**
+ * rsi_usb_read_register_multiple() - This function reads multiple
+ *					bytes of data from the address.
+ * @adapter:	Pointer to the adapter structure.
+ * @addr:	Address of the register.
+ * @data:	Read data.
+ * @len:	Number of bytes to read.
+ *
+ * Return: status: 0 on success, a negative error code on failure.
+ */
+int rsi_usb_read_register_multiple(struct rsi_hw *adapter,
+				   u32 addr,
+				   u8 *data,
+				   u16 count)
+{
+	struct rsi_91x_usbdev *dev = (struct rsi_91x_usbdev *)adapter->rsi_dev;
+	u8 *buf;
+	u16 transfer;
+	int status = 0;
+
+	if (addr == 0)
+		return -EINVAL;
+
+	buf = kzalloc(4096, GFP_KERNEL);
+	if (!buf)
+		return -ENOMEM;
+
+	while (count) {
+		transfer = min_t(int, count, 4096);
+		status = usb_control_msg(dev->usbdev,
+					 usb_rcvctrlpipe(dev->usbdev, 0),
+					 USB_VENDOR_REGISTER_READ,
+					 USB_TYPE_VENDOR,
+					 ((addr & 0xffff0000) >> 16),
+					 (addr & 0xffff),
+					 (void *)buf,
+					 transfer,
+					 HZ * 5);
+		if (status < 0) {
+			rsi_dbg(ERR_ZONE,
+				"Reg read failed with error code :%d\n",
+				 status);
+			kfree(buf);
+			return status;
+
+		} else {
+			memcpy(data, buf, transfer);
+			count -= transfer;
+			data += transfer;
+			addr += transfer;
+		}
+	}
+	kfree(buf);
+	return status;
+}
+
+/**
  * rsi_usb_write_register_multiple() - This function writes multiple bytes of
  *				       information to multiple registers.
  * @adapter: Pointer to the adapter structure.
@@ -286,7 +359,7 @@ static int rsi_rx_urb_submit(struct rsi_hw *adapter)
 int rsi_usb_write_register_multiple(struct rsi_hw *adapter,
 				    u32 addr,
 				    u8 *data,
-				    u32 count)
+				    u16 count)
 {
 	struct rsi_91x_usbdev *dev = (struct rsi_91x_usbdev *)adapter->rsi_dev;
 	u8 *buf;
@@ -333,9 +406,9 @@ int rsi_usb_write_register_multiple(struct rsi_hw *adapter,
  *
  * Return: 0 on success, a negative error code on failure.
  */
-static int rsi_usb_host_intf_write_pkt(struct rsi_hw *adapter,
-				       u8 *pkt,
-				       u32 len)
+int rsi_usb_host_intf_write_pkt(struct rsi_hw *adapter,
+				u8 *pkt,
+				u32 len)
 {
 	u32 queueno = ((pkt[1] >> 4) & 0xf);
 	u8 endpoint;
@@ -344,10 +417,76 @@ static int rsi_usb_host_intf_write_pkt(struct rsi_hw *adapter,
 
 	return rsi_write_multiple(adapter,
 				  endpoint,
-				  (u8 *)pkt,
+				  pkt,
 				  len);
 }
 
+int rsi_usb_master_reg_read(struct rsi_hw *adapter,
+			    u32 reg,
+			    u32 *value,
+			    u16 len)
+{
+	struct usb_device *usbdev =
+		((struct rsi_91x_usbdev *)adapter->rsi_dev)->usbdev;
+
+	return rsi_usb_reg_read(usbdev, reg, value, len);
+}
+
+int rsi_usb_master_reg_write(struct rsi_hw *adapter,
+			     unsigned long reg,
+			     unsigned long value,
+			     u16 len)
+{
+	struct usb_device *usbdev =
+		((struct rsi_91x_usbdev *)adapter->rsi_dev)->usbdev;
+
+	return rsi_usb_reg_write(usbdev, reg, value, len);
+}
+
+int rsi_usb_load_data_master_write(struct rsi_hw *adapter,
+				   u32 base_address,
+				   u32 instructions_sz,
+				   u16 block_size,
+				   u8 *ta_firmware)
+{
+	u16 num_blocks;
+	u32 cur_indx, ii;
+	u8  temp_buf[256];
+
+	num_blocks = instructions_sz / block_size;
+	rsi_dbg(INFO_ZONE, "num_blocks: %d\n", num_blocks);
+
+	for (cur_indx = 0, ii = 0;
+	     ii < num_blocks;
+	     ii++, cur_indx += block_size) {
+		memset(temp_buf, 0, block_size);
+		memcpy(temp_buf, ta_firmware + cur_indx, block_size);
+		if ((rsi_usb_write_register_multiple(adapter,
+						     base_address,
+						     (u8 *)(temp_buf),
+						     block_size)) < 0)
+			return -1;
+
+		rsi_dbg(INFO_ZONE, "%s: loading block: %d\n", __func__, ii);
+		base_address += block_size;
+	}
+
+	if (instructions_sz % block_size) {
+		memset(temp_buf, 0, block_size);
+		memcpy(temp_buf, ta_firmware + cur_indx,
+		       instructions_sz % block_size);
+		if ((rsi_usb_write_register_multiple(adapter,
+					     base_address,
+					     (u8 *)temp_buf,
+					     instructions_sz % block_size)) < 0)
+			return -1;
+		rsi_dbg(INFO_ZONE,
+			"Written Last Block in Address 0x%x Successfully\n",
+			cur_indx);
+	}
+	return 0;
+}
+
 /**
  * rsi_deinit_usb_interface() - This function deinitializes the usb interface.
  * @adapter: Pointer to the adapter structure.
@@ -413,9 +552,9 @@ static int rsi_init_usb_interface(struct rsi_hw *adapter,
 
 	/* Initializing function callbacks */
 	adapter->rx_urb_submit = rsi_rx_urb_submit;
-	adapter->host_intf_write_pkt = rsi_usb_host_intf_write_pkt;
 	adapter->check_hw_queue_status = rsi_usb_check_queue_status;
 	adapter->determine_event_timeout = rsi_usb_event_timeout;
+	adapter->host_intf_ops = &usb_host_intf_ops;
 
 	rsi_init_event(&rsi_dev->rx_thread.event);
 	status = rsi_create_kthread(common, &rsi_dev->rx_thread,
@@ -456,7 +595,7 @@ static int rsi_probe(struct usb_interface *pfunction,
 {
 	struct rsi_hw *adapter;
 	struct rsi_91x_usbdev *dev;
-	u16 fw_status;
+	u32 fw_status;
 	int status;
 
 	rsi_dbg(INIT_ZONE, "%s: Init function called\n", __func__);
@@ -467,6 +606,7 @@ static int rsi_probe(struct usb_interface *pfunction,
 			__func__);
 		return -ENOMEM;
 	}
+	adapter->rsi_host_intf = RSI_HOST_INTF_USB;
 
 	status = rsi_init_usb_interface(adapter, pfunction);
 	if (status) {
@@ -480,25 +620,20 @@ static int rsi_probe(struct usb_interface *pfunction,
 	dev = (struct rsi_91x_usbdev *)adapter->rsi_dev;
 
 	status = rsi_usb_reg_read(dev->usbdev, FW_STATUS_REG, &fw_status, 2);
-	if (status)
+	if (status < 0)
 		goto err1;
 	else
 		fw_status &= 1;
 
 	if (!fw_status) {
-		status = rsi_usb_device_init(adapter->priv);
+		rsi_dbg(INIT_ZONE, "Loading firmware...\n");
+		status = rsi_hal_device_init(adapter);
 		if (status) {
 			rsi_dbg(ERR_ZONE, "%s: Failed in device init\n",
 				__func__);
 			goto err1;
 		}
-
-		status = rsi_usb_reg_write(dev->usbdev,
-					   USB_INTERNAL_REG_1,
-					   RSI_USB_READY_MAGIC_NUM, 1);
-		if (status)
-			goto err1;
-		rsi_dbg(INIT_ZONE, "%s: Performed device init\n", __func__);
+		rsi_dbg(INIT_ZONE, "%s: Device Init Done\n", __func__);
 	}
 
 	status = rsi_rx_urb_submit(adapter);
@@ -554,6 +689,7 @@ static const struct usb_device_id rsi_dev_table[] = {
 	{ USB_DEVICE(0x041B, 0x0301) },
 	{ USB_DEVICE(0x041B, 0x0201) },
 	{ USB_DEVICE(0x041B, 0x9330) },
+	{ USB_DEVICE(0x1618, 0x9113) },
 	{ /* Blank */},
 };
 
diff --git a/drivers/net/wireless/rsi/rsi_91x_usb_ops.c b/drivers/net/wireless/rsi/rsi_91x_usb_ops.c
index de49008..949b572 100644
--- a/drivers/net/wireless/rsi/rsi_91x_usb_ops.c
+++ b/drivers/net/wireless/rsi/rsi_91x_usb_ops.c
@@ -19,67 +19,6 @@
 #include "rsi_usb.h"
 
 /**
- * rsi_copy_to_card() - This function includes the actual funtionality of
- *			copying the TA firmware to the card.Basically this
- *			function includes opening the TA file,reading the TA
- *			file and writing their values in blocks of data.
- * @common: Pointer to the driver private structure.
- * @fw: Pointer to the firmware value to be written.
- * @len: length of firmware file.
- * @num_blocks: Number of blocks to be written to the card.
- *
- * Return: 0 on success and -1 on failure.
- */
-static int rsi_copy_to_card(struct rsi_common *common,
-			    const u8 *fw,
-			    u32 len,
-			    u32 num_blocks)
-{
-	struct rsi_hw *adapter = common->priv;
-	struct rsi_91x_usbdev *dev = (struct rsi_91x_usbdev *)adapter->rsi_dev;
-	u32 indx, ii;
-	u32 block_size = dev->tx_blk_size;
-	u32 lsb_address;
-	u32 base_address;
-
-	base_address = TA_LOAD_ADDRESS;
-
-	for (indx = 0, ii = 0; ii < num_blocks; ii++, indx += block_size) {
-		lsb_address = base_address;
-		if (rsi_usb_write_register_multiple(adapter,
-						    lsb_address,
-						    (u8 *)(fw + indx),
-						    block_size)) {
-			rsi_dbg(ERR_ZONE,
-				"%s: Unable to load %s blk\n", __func__,
-				FIRMWARE_RSI9113);
-			return -EIO;
-		}
-		rsi_dbg(INIT_ZONE, "%s: loading block: %d\n", __func__, ii);
-		base_address += block_size;
-	}
-
-	if (len % block_size) {
-		lsb_address = base_address;
-		if (rsi_usb_write_register_multiple(adapter,
-						    lsb_address,
-						    (u8 *)(fw + indx),
-						    len % block_size)) {
-			rsi_dbg(ERR_ZONE,
-				"%s: Unable to load %s blk\n", __func__,
-				FIRMWARE_RSI9113);
-			return -EIO;
-		}
-	}
-	rsi_dbg(INIT_ZONE,
-		"%s: Succesfully loaded %s instructions\n", __func__,
-		FIRMWARE_RSI9113);
-
-	rsi_dbg(INIT_ZONE, "%s: loaded firmware\n", __func__);
-	return 0;
-}
-
-/**
  * rsi_usb_rx_thread() - This is a kernel thread to receive the packets from
  *			 the USB device.
  * @common: Pointer to the driver private structure.
@@ -103,83 +42,20 @@ void rsi_usb_rx_thread(struct rsi_common *common)
 		if (status) {
 			rsi_dbg(ERR_ZONE, "%s: Failed To read data", __func__);
 			mutex_unlock(&common->tx_rxlock);
-			return;
+			break;
 		}
 		mutex_unlock(&common->tx_rxlock);
 		rsi_reset_event(&dev->rx_thread.event);
 		if (adapter->rx_urb_submit(adapter)) {
 			rsi_dbg(ERR_ZONE,
 				"%s: Failed in urb submission", __func__);
-			return;
+			break;
 		}
 	} while (1);
 
 out:
 	rsi_dbg(INFO_ZONE, "%s: Terminated thread\n", __func__);
+	atomic_inc(&dev->rx_thread.thread_done);
 	complete_and_exit(&dev->rx_thread.completion, 0);
 }
 
-
-/**
- * rsi_load_ta_instructions() - This function includes the actual funtionality
- *				of loading the TA firmware.This function also
- *				includes opening the TA file,reading the TA
- *				file and writing their value in blocks of data.
- * @common: Pointer to the driver private structure.
- *
- * Return: status: 0 on success, -1 on failure.
- */
-static int rsi_load_ta_instructions(struct rsi_common *common)
-{
-	struct rsi_hw *adapter = common->priv;
-	struct rsi_91x_usbdev *dev = (struct rsi_91x_usbdev *)adapter->rsi_dev;
-	const struct firmware *fw_entry = NULL;
-	u32 block_size = dev->tx_blk_size;
-	const u8 *fw;
-	u32 num_blocks, len;
-	int status = 0;
-
-	status = request_firmware(&fw_entry, FIRMWARE_RSI9113, adapter->device);
-	if (status < 0) {
-		rsi_dbg(ERR_ZONE, "%s Firmware file %s not found\n",
-			__func__, FIRMWARE_RSI9113);
-		return status;
-	}
-
-	/* Copy firmware into DMA-accessible memory */
-	fw = kmemdup(fw_entry->data, fw_entry->size, GFP_KERNEL);
-	if (!fw) {
-		status = -ENOMEM;
-		goto out;
-	}
-	len = fw_entry->size;
-
-	if (len % 4)
-		len += (4 - (len % 4));
-
-	num_blocks = (len / block_size);
-
-	rsi_dbg(INIT_ZONE, "%s: Instruction size:%d\n", __func__, len);
-	rsi_dbg(INIT_ZONE, "%s: num blocks: %d\n", __func__, num_blocks);
-
-	status = rsi_copy_to_card(common, fw, len, num_blocks);
-	kfree(fw);
-
-out:
-	release_firmware(fw_entry);
-	return status;
-}
-
-/**
- * rsi_device_init() - This Function Initializes The HAL.
- * @common: Pointer to the driver private structure.
- *
- * Return: 0 on success, -1 on failure.
- */
-int rsi_usb_device_init(struct rsi_common *common)
-{
-	if (rsi_load_ta_instructions(common))
-		return -EIO;
-
-	return 0;
-		}
diff --git a/drivers/net/wireless/rsi/rsi_common.h b/drivers/net/wireless/rsi/rsi_common.h
index d3fbe33..8c8cad4 100644
--- a/drivers/net/wireless/rsi/rsi_common.h
+++ b/drivers/net/wireless/rsi/rsi_common.h
@@ -63,6 +63,7 @@ static inline int rsi_create_kthread(struct rsi_common *common,
 				     u8 *name)
 {
 	init_completion(&thread->completion);
+	atomic_set(&thread->thread_done, 0);
 	thread->task = kthread_run(func_ptr, common, "%s", name);
 	if (IS_ERR(thread->task))
 		return (int)PTR_ERR(thread->task);
@@ -72,6 +73,9 @@ static inline int rsi_create_kthread(struct rsi_common *common,
 
 static inline int rsi_kill_thread(struct rsi_thread *handle)
 {
+	if (atomic_read(&handle->thread_done) > 0)
+		return 0;
+
 	atomic_inc(&handle->thread_done);
 	rsi_set_event(&handle->event);
 
diff --git a/drivers/net/wireless/rsi/rsi_hal.h b/drivers/net/wireless/rsi/rsi_hal.h
new file mode 100644
index 0000000..f9e0fe3
--- /dev/null
+++ b/drivers/net/wireless/rsi/rsi_hal.h
@@ -0,0 +1,150 @@
+/**
+ * Copyright (c) 2014 Redpine Signals Inc.
+ *
+ * Permission to use, copy, modify, and/or distribute this software for any
+ * purpose with or without fee is hereby granted, provided that the above
+ * copyright notice and this permission notice appear in all copies.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
+ * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
+ * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
+ * ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
+ * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
+ * ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
+ * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
+ */
+
+#ifndef __RSI_HAL_H__
+#define __RSI_HAL_H__
+
+#define TA_LOAD_ADDRESS			0x00
+#define FIRMWARE_RSI9113		"rsi_91x.fw"
+#define FLASH_WRITE_CHUNK_SIZE		(4 * 1024)
+#define USB_FLASH_READ_CHUNK_SIZE	((2 * 1024) - 4)
+#define SDIO_FLASH_READ_CHUNK_SIZE	(2 * 1024)
+#define FLASH_SECTOR_SIZE		(4 * 1024)
+#define STARTING_BLOCK_INDEX		0
+#define FLASH_BLOCK_SIZE		(32 * 1024)
+
+#define FLASH_SIZE_ADDR			0x04000016
+#define PING_BUFFER_ADDRESS		0x19000
+#define PONG_BUFFER_ADDRESS		0x1a000
+#define SWBL_REGIN			0x41050034
+#define SWBL_REGOUT			0x4105003c
+#define PING_WRITE			0x1
+#define PONG_WRITE			0x2
+
+#define BL_CMD_TIMEOUT			500
+#define BL_BURN_TIMEOUT			(40 * 1000)
+
+#define MASTER_READ_MODE		1
+#define EEPROM_READ_MODE		2
+
+#define REGIN_VALID			0xA
+#define REGIN_INPUT			0xA0
+#define REGOUT_VALID			0xAB
+#define REGOUT_INVALID			(~0xAB)
+#define CMD_PASS			0xAA
+#define CMD_FAIL			0xCC
+#define INVALID_ADDR			0x4C
+
+#define BURN_BL				0x23
+#define LOAD_HOSTED_FW			'A'
+#define BURN_HOSTED_FW			'B'
+#define PING_VALID			'I'
+#define PONG_VALID			'O'
+#define PING_AVAIL			'I'
+#define PONG_AVAIL			'O'
+#define EOF_REACHED			'E'
+#define CHECK_CRC			'K'
+#define POLLING_MODE			'P'
+#define CONFIG_AUTO_READ_MODE		'R'
+#define JUMP_TO_ZERO_PC			'J'
+#define FW_LOADING_SUCCESSFUL		'S'
+#define LOADING_INITIATED		'1'
+
+/* Boot loader commands */
+#define HOST_INTF_REG_OUT		0x4105003C
+#define HOST_INTF_REG_IN		0x41050034
+#define BOARD_READY			0xABCD
+#define REG_READ			0xD1
+#define REG_WRITE			0xD2
+#define SEND_RPS_FILE			'2'
+#define BOOTUP_OPTIONS_LAST_CONFIG_NOT_SAVED 0xF1
+#define BOOTUP_OPTIONS_CHECKSUM_FAIL 0xF2
+#define INVALID_OPTION			0xF3
+#define CHECKSUM_SUCCESS		0xAA
+#define CHECKSUM_FAILURE		0xCC
+#define CHECKSUM_INVALID_ADDRESS	0x4C
+
+#define EEPROM_VERSION_OFFSET		77
+#define CALIB_CRC_OFFSET		4092
+#define MAGIC_WORD			0x5A
+#define MAGIC_WORD_OFFSET_1		40
+#define MAGIC_WORD_OFFSET_2		424
+#define FW_IMAGE_MIN_ADDRESS		(68 * 1024)
+#define FLASH_MAX_ADDRESS		(4 * 1024 * 1024) //4MB
+#define MAX_FLASH_FILE_SIZE		(400 * 1024) //400K
+#define FLASHING_START_ADDRESS		16
+#define CALIB_VALUES_START_ADDR		16
+#define SOC_FLASH_ADDR			0x04000000
+#define EEPROM_DATA_SIZE		4096
+#define CALIB_DATA_SIZE		(EEPROM_DATA_SIZE - CALIB_VALUES_START_ADDR)
+#define BL_HEADER			32
+
+#define BT_CARD_READY_IND		0x89
+#define WLAN_CARD_READY_IND		0x0
+#define COMMON_HAL_CARD_READY_IND	0x0
+#define ZIGB_CARD_READY_IND		0xff
+
+#define COMMAN_HAL_WAIT_FOR_CARD_READY	1
+#define COMMON_HAL_SEND_CONFIG_PARAMS	2
+#define COMMON_HAL_TX_ACCESS		3
+#define COMMON_HAL_WAIT_FOR_PROTO_CARD_READY 4
+#define HEX_FILE			1
+#define BIN_FILE			0
+#define UNIX_FILE_TYPE			8
+#define DOS_FILE_TYPE			9
+#define LMAC_INSTRUCTIONS_SIZE		(16  * 1024) /* 16Kbytes */
+
+#define ULP_RESET_REG			0x161
+#define WATCH_DOG_TIMER_1		0x16c
+#define WATCH_DOG_TIMER_2		0x16d
+#define WATCH_DOG_DELAY_TIMER_1		0x16e
+#define WATCH_DOG_DELAY_TIMER_2		0x16f
+#define WATCH_DOG_TIMER_ENABLE		0x170
+
+#define RESTART_WDT			BIT(11)
+#define BYPASS_ULP_ON_WDT		BIT(1)
+
+#define RF_SPI_PROG_REG_BASE_ADDR	0x40080000
+
+#define GSPI_CTRL_REG0			(RF_SPI_PROG_REG_BASE_ADDR)
+#define GSPI_CTRL_REG1			(RF_SPI_PROG_REG_BASE_ADDR + 0x2)
+#define GSPI_DATA_REG0			(RF_SPI_PROG_REG_BASE_ADDR + 0x4)
+#define GSPI_DATA_REG1			(RF_SPI_PROG_REG_BASE_ADDR + 0x6)
+#define GSPI_DATA_REG2			(RF_SPI_PROG_REG_BASE_ADDR + 0x8)
+
+#define GSPI_DMA_MODE			BIT(13)
+
+#define GSPI_2_ULP			BIT(12)
+#define GSPI_TRIG			BIT(7)
+#define GSPI_READ			BIT(6)
+#define GSPI_RF_SPI_ACTIVE		BIT(8)
+
+struct bl_header {
+	u32 flags;
+	u32 image_no;
+	u32 check_sum;
+	u32 flash_start_address;
+	u32 flash_len;
+} __packed;
+
+struct ta_metadata {
+	char *name;
+	unsigned int address;
+};
+
+int rsi_hal_device_init(struct rsi_hw *adapter);
+
+#endif
diff --git a/drivers/net/wireless/rsi/rsi_main.h b/drivers/net/wireless/rsi/rsi_main.h
index dcd0957..752c429 100644
--- a/drivers/net/wireless/rsi/rsi_main.h
+++ b/drivers/net/wireless/rsi/rsi_main.h
@@ -204,10 +204,43 @@ struct rsi_common {
 	struct cqm_info cqm_info;
 
 	bool hw_data_qs_blocked;
+	
+	u8 coex_mode;
+};
+
+enum host_intf {
+	RSI_HOST_INTF_SDIO = 0,
+	RSI_HOST_INTF_USB
+};
+
+enum rsi_dev_model {
+	RSI_DEV_9110 = 0,
+	RSI_DEV_9113,
+	RSI_DEV_9116
+};
+
+struct eepromrw_info {
+	u32 offset;
+	u32 length;
+	u8  write;
+	u16 eeprom_erase;
+	u8 data[480];
+};
+
+struct eeprom_read {
+	u16 length;
+	u16 off_set;
+};
+
+struct xtended_desc {
+	u8 confirm_frame_type;
+	u8 retry_cnt;
+	u16 reserved;
 };
 
 struct rsi_hw {
 	struct rsi_common *priv;
+	enum rsi_dev_model device_model;
 	struct ieee80211_hw *hw;
 	struct ieee80211_vif *vifs[RSI_MAX_VIFS];
 	struct ieee80211_tx_queue_params edca_params[NUM_EDCA_QUEUES];
@@ -215,16 +248,47 @@ struct rsi_hw {
 
 	struct device *device;
 	u8 sc_nvifs;
+	enum host_intf rsi_host_intf;
 
 #ifdef CONFIG_RSI_DEBUGFS
 	struct rsi_debugfs *dfsentry;
 	u8 num_debugfs_entries;
 #endif
+
+	struct timer_list bl_cmd_timer;
+	u8 blcmd_timer_expired;
+	u32 flash_capacity;
+	u32 tx_blk_size;
+	u32 common_hal_fsm;
+	u8 eeprom_init;
+	struct eepromrw_info eeprom;
+	u8 *calib_data;
+	u32 interrupt_status;
+
 	void *rsi_dev;
-	int (*host_intf_read_pkt)(struct rsi_hw *adapter, u8 *pkt, u32 len);
-	int (*host_intf_write_pkt)(struct rsi_hw *adapter, u8 *pkt, u32 len);
+
+	struct rsi_host_intf_ops *host_intf_ops;
 	int (*check_hw_queue_status)(struct rsi_hw *adapter, u8 q_num);
 	int (*rx_urb_submit)(struct rsi_hw *adapter);
 	int (*determine_event_timeout)(struct rsi_hw *adapter);
 };
+
+struct rsi_host_intf_ops {
+	int (*read_pkt)(struct rsi_hw *adapter, u8 *pkt, u32 len);
+	int (*write_pkt)(struct rsi_hw *adapter, u8 *pkt, u32 len);
+	int (*master_access_msword)(struct rsi_hw *adapter, u16 ms_word);
+	int (*read_reg_multiple)(struct rsi_hw *adapter, u32 addr,
+				 u8 *data, u16 count);
+	int (*write_reg_multiple)(struct rsi_hw *adapter, u32 addr,
+				  u8 *data, u16 count);
+	int (*master_reg_read)(struct rsi_hw *adapter, u32 addr,
+			       u32 *read_buf, u16 size);
+	int (*master_reg_write)(struct rsi_hw *adapter,
+				unsigned long addr, unsigned long data,
+				u16 size);
+	int (*load_data_master_write)(struct rsi_hw *adapter, u32 addr,
+				      u32 instructions_size, u16 block_size,
+				      u8 *fw);
+};
+
 #endif
diff --git a/drivers/net/wireless/rsi/rsi_mgmt.h b/drivers/net/wireless/rsi/rsi_mgmt.h
index 3741173..f8823126 100644
--- a/drivers/net/wireless/rsi/rsi_mgmt.h
+++ b/drivers/net/wireless/rsi/rsi_mgmt.h
@@ -62,6 +62,7 @@
 #define RF_RESET_ENABLE                 BIT(3)
 #define RATE_INFO_ENABLE                BIT(0)
 #define RSI_BROADCAST_PKT               BIT(9)
+#define RSI_DESC_REQUIRE_CFM_TO_HOST	BIT(10)
 
 #define UPPER_20_ENABLE                 (0x2 << 12)
 #define LOWER_20_ENABLE                 (0x4 << 12)
@@ -306,4 +307,5 @@ void rsi_core_xmit(struct rsi_common *common, struct sk_buff *skb);
 int rsi_send_mgmt_pkt(struct rsi_common *common, struct sk_buff *skb);
 int rsi_send_data_pkt(struct rsi_common *common, struct sk_buff *skb);
 int rsi_band_check(struct rsi_common *common);
+int rsi_flash_read(struct rsi_hw *adapter);
 #endif
diff --git a/drivers/net/wireless/rsi/rsi_sdio.h b/drivers/net/wireless/rsi/rsi_sdio.h
index c7e8f2b..6a747c5 100644
--- a/drivers/net/wireless/rsi/rsi_sdio.h
+++ b/drivers/net/wireless/rsi/rsi_sdio.h
@@ -118,11 +118,25 @@ void rsi_interrupt_handler(struct rsi_hw *adapter);
 int rsi_init_sdio_slave_regs(struct rsi_hw *adapter);
 int rsi_sdio_device_init(struct rsi_common *common);
 int rsi_sdio_read_register(struct rsi_hw *adapter, u32 addr, u8 *data);
-int rsi_sdio_host_intf_read_pkt(struct rsi_hw *adapter, u8 *pkt, u32 length);
 int rsi_sdio_write_register(struct rsi_hw *adapter, u8 function,
 			    u32 addr, u8 *data);
+int rsi_sdio_host_intf_read_pkt(struct rsi_hw *adapter, u8 *pkt, u32 length);
+int rsi_sdio_host_intf_write_pkt(struct rsi_hw *adapter, u8 *pkt, u32 len);
+int rsi_sdio_read_register_multiple(struct rsi_hw *adapter, u32 addr,
+				    u8 *data, u16 count);
 int rsi_sdio_write_register_multiple(struct rsi_hw *adapter, u32 addr,
-				     u8 *data, u32 count);
+				     u8 *data, u16 count);
+int rsi_sdio_master_access_msword(struct rsi_hw *adapter,
+				  u16 ms_word);
+int rsi_sdio_load_data_master_write(struct rsi_hw *adapter,
+				    u32 base_address, u32 instructions_sz,
+				    u16 block_size, u8 *ta_firmware);
+int rsi_sdio_master_reg_read(struct rsi_hw *adapter, u32 addr,
+			     u32 *read_buf, u16 size);
+int rsi_sdio_master_reg_write(struct rsi_hw *adapter,
+			      unsigned long addr,
+			      unsigned long data,
+			      u16 size);
 void rsi_sdio_ack_intr(struct rsi_hw *adapter, u8 int_bit);
 int rsi_sdio_determine_event_timeout(struct rsi_hw *adapter);
 int rsi_sdio_read_buffer_status_register(struct rsi_hw *adapter, u8 q_num);
diff --git a/drivers/net/wireless/rsi/rsi_usb.h b/drivers/net/wireless/rsi/rsi_usb.h
index ebea0c4..d21d40d 100644
--- a/drivers/net/wireless/rsi/rsi_usb.h
+++ b/drivers/net/wireless/rsi/rsi_usb.h
@@ -62,7 +62,19 @@ static inline int rsi_usb_event_timeout(struct rsi_hw *adapter)
 }
 
 int rsi_usb_device_init(struct rsi_common *common);
+int rsi_usb_read_register_multiple(struct rsi_hw *adapter, u32 addr,
+				   u8 *data, u16 count);
 int rsi_usb_write_register_multiple(struct rsi_hw *adapter, u32 addr,
-				    u8 *data, u32 count);
+				    u8 *data, u16 count);
 void rsi_usb_rx_thread(struct rsi_common *common);
+
+int rsi_usb_host_intf_write_pkt(struct rsi_hw *adapter, u8 *pkt, u32 len);
+int rsi_usb_master_reg_read(struct rsi_hw *adapter, u32 reg,
+			    u32 *value, u16 len);
+int rsi_usb_master_reg_write(struct rsi_hw *adapter, unsigned long reg,
+			     unsigned long value, u16 len);
+int rsi_usb_load_data_master_write(struct rsi_hw *adapter, u32 base_address,
+				   u32 instructions_sz,
+				   u16 block_size,
+				   u8 *ta_firmware);
 #endif
-- 
2.4.11

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.redpinesignals.com ([203.196.161.92]:8042 "EHLO
	mail.redpinesignals.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751250AbaAaHZ0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 31 Jan 2014 02:25:26 -0500
Message-ID: <52EB4FEB.4060105@redpinesignals.com> (sfid-20140131_082532_301357_3F43873F)
Date: Fri, 31 Jan 2014 12:55:31 +0530
From: Jahnavi <jahnavi.meher@redpinesignals.com>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: [PATCH 3.13.1 8/9] rsi: Management frames internal to device
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Jahnavi Meher <jahnavi.meher@redpinesignals.com>

This patch has the functions which prepare mgmt frames
that are internal to the device and also handle exchange
of these internal mgmt frames with the device.

Signed-off-by: Jahnavi Meher <jahnavi.meher@redpinesignals.com>
---

rsi_91x_mgmt.c | 1345 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++
1 file changed, 1345 insertions(+)

diff -uprN a/drivers/net/wireless/rsi/91x/rsi_91x_mgmt.c b/drivers/net/wireless/rsi/91x/rsi_91x_mgmt.c
--- a/drivers/net/wireless/rsi/91x/rsi_91x_mgmt.c	1970-01-01 05:30:00.000000000 +0530
+++ b/drivers/net/wireless/rsi/91x/rsi_91x_mgmt.c	2014-01-30 16:26:31.911451234 +0530
@@ -0,0 +1,1345 @@
+/**
+ * @file rsi_91x_mgmt.c
+ * @author
+ * @version 1.0
+ *
+ * @section LICENSE
+ * Copyright (c) 2013 Redpine Signals Inc.
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
+ *
+ * @section DESCRIPTION
+ *
+ * The file contains the message information exchanged between the
+ * driver and underlying device.
+ */
+
+#include "../include/rsi_main.h"
+#include "../include/rsi_hw_intf.h"
+#include "../include/rsi_device_ops.h"
+#include "../include/rsi_mgmt.h"
+#include "../include/rsi_mac80211.h"
+
+static struct bootup_params boot_params_20 = {
+	.magic_number = cpu_to_le16(0x5aa5),
+	.crystal_good_time = 0x0,
+	.valid = cpu_to_le32(VALID_20),
+	.reserved_for_valids = 0x0,
+	.bootup_mode_info = 0x0,
+	.digital_loop_back_params = 0x0,
+	.rtls_timestamp_en = 0x0,
+	.host_spi_intr_cfg = 0x0,
+	.device_clk_info = {{
+		.pll_config_g = {
+			.tapll_info_g = {
+				.pll_reg_1 = cpu_to_le16((TA_PLL_N_VAL_20 << 8)|
+					      (TA_PLL_M_VAL_20)),
+				.pll_reg_2 = cpu_to_le16(TA_PLL_P_VAL_20),
+			},
+			.pll960_info_g = {
+				.pll_reg_1 = cpu_to_le16((PLL960_P_VAL_20 << 8)|
+					      (PLL960_N_VAL_20)),
+				.pll_reg_2 = cpu_to_le16(PLL960_M_VAL_20),
+				.pll_reg_3 = 0x0,
+			},
+			.afepll_info_g = {
+				.pll_reg = cpu_to_le16(0x9f0),
+			}
+		},
+		.switch_clk_g = {
+			.switch_umac_clk = 0x0,
+			.switch_qspi_clk = 0x0,
+			.switch_slp_clk_2_32 = 0x0,
+			.switch_bbp_lmac_clk_reg = 0x1,
+			.switch_mem_ctrl_cfg = 0x0,
+			.reserved = 0x0,
+			.bbp_lmac_clk_reg_val = cpu_to_le16(0x121),
+			.umac_clock_reg_config = 0x0,
+			.qspi_uart_clock_reg_config = 0x0
+		}
+	},
+	{
+		.pll_config_g = {
+			.tapll_info_g = {
+				.pll_reg_1 = cpu_to_le16((TA_PLL_N_VAL_20 << 8)|
+					      (TA_PLL_M_VAL_20)),
+				.pll_reg_2 = cpu_to_le16(TA_PLL_P_VAL_20),
+			},
+			.pll960_info_g = {
+				.pll_reg_1 = cpu_to_le16((PLL960_P_VAL_20 << 8)|
+					      (PLL960_N_VAL_20)),
+				.pll_reg_2 = cpu_to_le16(PLL960_M_VAL_20),
+				.pll_reg_3 = 0x0,
+			},
+			.afepll_info_g = {
+				.pll_reg = cpu_to_le16(0x9f0),
+			}
+		},
+		.switch_clk_g = {
+			.switch_umac_clk = 0x0,
+			.switch_qspi_clk = 0x0,
+			.switch_slp_clk_2_32 = 0x0,
+			.switch_bbp_lmac_clk_reg = 0x0,
+			.switch_mem_ctrl_cfg = 0x0,
+			.reserved = 0x0,
+			.bbp_lmac_clk_reg_val = 0x0,
+			.umac_clock_reg_config = 0x0,
+			.qspi_uart_clock_reg_config = 0x0
+		}
+	},
+	{
+		.pll_config_g = {
+			.tapll_info_g = {
+				.pll_reg_1 = cpu_to_le16((TA_PLL_N_VAL_20 << 8)|
+					      (TA_PLL_M_VAL_20)),
+				.pll_reg_2 = cpu_to_le16(TA_PLL_P_VAL_20),
+			},
+			.pll960_info_g = {
+				.pll_reg_1 = cpu_to_le16((PLL960_P_VAL_20 << 8)|
+					      (PLL960_N_VAL_20)),
+				.pll_reg_2 = cpu_to_le16(PLL960_M_VAL_20),
+				.pll_reg_3 = 0x0,
+			},
+			.afepll_info_g = {
+				.pll_reg = cpu_to_le16(0x9f0),
+			}
+		},
+		.switch_clk_g = {
+			.switch_umac_clk = 0x0,
+			.switch_qspi_clk = 0x0,
+			.switch_slp_clk_2_32 = 0x0,
+			.switch_bbp_lmac_clk_reg = 0x0,
+			.switch_mem_ctrl_cfg = 0x0,
+			.reserved = 0x0,
+			.bbp_lmac_clk_reg_val = 0x0,
+			.umac_clock_reg_config = 0x0,
+			.qspi_uart_clock_reg_config = 0x0
+		}
+	} },
+	.buckboost_wakeup_cnt = 0x0,
+	.pmu_wakeup_wait = 0x0,
+	.shutdown_wait_time = 0x0,
+	.pmu_slp_clkout_sel = 0x0,
+	.wdt_prog_value = 0x0,
+	.wdt_soc_rst_delay = 0x0,
+	.dcdc_operation_mode = 0x0,
+	.soc_reset_wait_cnt = 0x0
+};
+
+static struct bootup_params boot_params_40 = {
+	.magic_number = 0x5aa5,
+	.crystal_good_time = 0x0,
+	.valid = VALID_40,
+	.reserved_for_valids = 0x0,
+	.bootup_mode_info = 0x0,
+	.digital_loop_back_params = 0x0,
+	.rtls_timestamp_en = 0x0,
+	.host_spi_intr_cfg = 0x0,
+	.device_clk_info = {{
+		.pll_config_g = {
+			.tapll_info_g = {
+				.pll_reg_1 = ((TA_PLL_N_VAL_40 << 8) |
+					      (TA_PLL_M_VAL_40)),
+				.pll_reg_2 = (TA_PLL_P_VAL_40),
+			},
+			.pll960_info_g = {
+				.pll_reg_1 = ((PLL960_P_VAL_40 << 8) |
+					      (PLL960_N_VAL_40)),
+				.pll_reg_2 = PLL960_M_VAL_40,
+				.pll_reg_3 = 0x0,
+			},
+			.afepll_info_g = {
+				.pll_reg = 0x9f0,
+			}
+		},
+		.switch_clk_g = {
+			.switch_umac_clk = 0x1,
+			.switch_qspi_clk = 0x0,
+			.switch_slp_clk_2_32 = 0x0,
+			.switch_bbp_lmac_clk_reg = 0x1,
+			.switch_mem_ctrl_cfg = 0x0,
+			.reserved = 0x0,
+			.bbp_lmac_clk_reg_val = 0x1121,
+			.umac_clock_reg_config = 0x48,
+			.qspi_uart_clock_reg_config = 0x0
+		}
+	},
+	{
+		.pll_config_g = {
+			.tapll_info_g = {
+				.pll_reg_1 = ((TA_PLL_N_VAL_40 << 8) |
+					      (TA_PLL_M_VAL_40)),
+				.pll_reg_2 = (TA_PLL_P_VAL_40)
+			},
+			.pll960_info_g = {
+				.pll_reg_1 = ((PLL960_P_VAL_40 << 8) |
+					      (PLL960_N_VAL_40)),
+				.pll_reg_2 = PLL960_M_VAL_40,
+				.pll_reg_3 = 0x0,
+			},
+			.afepll_info_g = {
+				.pll_reg = 0x9f0,
+			}
+		},
+		.switch_clk_g = {
+			.switch_umac_clk = 0x0,
+			.switch_qspi_clk = 0x0,
+			.switch_slp_clk_2_32 = 0x0,
+			.switch_bbp_lmac_clk_reg = 0x0,
+			.switch_mem_ctrl_cfg = 0x0,
+			.reserved = 0x0,
+			.bbp_lmac_clk_reg_val = 0x0,
+			.umac_clock_reg_config = 0x0,
+			.qspi_uart_clock_reg_config = 0x0
+		}
+	},
+	{
+		.pll_config_g = {
+			.tapll_info_g = {
+				.pll_reg_1 = ((TA_PLL_N_VAL_40 << 8) |
+					      (TA_PLL_M_VAL_40)),
+				.pll_reg_2 = (TA_PLL_P_VAL_40),
+			},
+			.pll960_info_g = {
+				.pll_reg_1 = ((PLL960_P_VAL_40 << 8) |
+					      (PLL960_N_VAL_40)),
+				.pll_reg_2 = PLL960_M_VAL_40,
+				.pll_reg_3 = 0x0,
+			},
+			.afepll_info_g = {
+				.pll_reg = 0x9f0,
+			}
+		},
+		.switch_clk_g = {
+			.switch_umac_clk = 0x0,
+			.switch_qspi_clk = 0x0,
+			.switch_slp_clk_2_32 = 0x0,
+			.switch_bbp_lmac_clk_reg = 0x0,
+			.switch_mem_ctrl_cfg = 0x0,
+			.reserved = 0x0,
+			.bbp_lmac_clk_reg_val = 0x0,
+			.umac_clock_reg_config = 0x0,
+			.qspi_uart_clock_reg_config = 0x0
+		}
+	} },
+	.buckboost_wakeup_cnt = 0x0,
+	.pmu_wakeup_wait = 0x0,
+	.shutdown_wait_time = 0x0,
+	.pmu_slp_clkout_sel = 0x0,
+	.wdt_prog_value = 0x0,
+	.wdt_soc_rst_delay = 0x0,
+	.dcdc_operation_mode = 0x0,
+	.soc_reset_wait_cnt = 0x0
+};
+
+static unsigned short mcs[] = {13, 26, 39, 52, 78, 104, 117, 130};
+
+/**
+ * This function sets the contention values for the backoff procedure.
+ *
+ * @param  common Pointer to the driver common structure.
+ * @return None.
+ */
+static void rsi_set_contention_vals(struct rsi_common *common)
+{
+	unsigned char ii = 0;
+
+	for (ii = 0; ii < NUM_EDCA_QUEUES; ii++) {
+		common->tx_qinfo[ii].wme_params =
+			(((common->edca_params[ii].cw_min / 2) +
+			  (common->edca_params[ii].aifs)) *
+			  WMM_SHORT_SLOT_TIME + SIFS_DURATION);
+		common->tx_qinfo[ii].weight = common->tx_qinfo[ii].wme_params;
+		common->tx_qinfo[ii].pkt_contended = 0;
+	}
+}
+
+/**
+ * This function sends management frame to firmware.
+ * Also schedules packet to queue for transmit.
+ *
+ * @param  common Pointer to the driver private structure.
+ * @param  addr Pointer to rsi mac frame structure.
+ * @param  len Length.
+ * @return 0 on success, -1 on failure.
+ */
+static int rsi_send_internal_mgmt_frame(struct rsi_common *common,
+					struct sk_buff *skb)
+{
+	struct skb_info *tx_params;
+
+	if (skb == NULL) {
+		rsi_dbg(ERR_ZONE, "%s: Unable to allocate skb\n", __func__);
+		return -1;
+	}
+	tx_params = (struct skb_info *)&IEEE80211_SKB_CB(skb)->driver_data;
+	tx_params->flags |= INTERNAL_MGMT_PKT;
+	skb_queue_tail(&common->tx_queue[MGMT_SOFT_Q], skb);
+	common->common_ops->set_event(&common->tx_event);
+	return 0;
+}
+
+/**
+ * This function used to send radio capabilities values to firmware.
+ *
+ * @param  common Pointer to the driver private structure.
+ * @return 0 on success, corresponding negative error code on failure.
+ */
+static int rsi_load_radio_caps(struct rsi_common *common)
+{
+	struct rsi_mac_frame *mgmt_frame;
+	struct rsi_hw *adapter = common->priv;
+	struct ieee80211_hw *hw = adapter->hw;
+	unsigned short inx = 0;
+	unsigned char ii;
+	unsigned char radio_id = 0;
+	unsigned short gc[20] = {0xf0, 0xf0, 0xf0, 0xf0,
+				 0xf0, 0xf0, 0xf0, 0xf0,
+				 0xf0, 0xf0, 0xf0, 0xf0,
+				 0xf0, 0xf0, 0xf0, 0xf0,
+				 0xf0, 0xf0, 0xf0, 0xf0};
+	struct ieee80211_conf *conf = &hw->conf;
+	struct sk_buff *skb;
+
+	rsi_dbg(INFO_ZONE,
+		"%s: Sending rate symbol req frame\n", __func__);
+
+	skb = dev_alloc_skb(MAX_MGMT_PKT_SIZE);
+
+	if (!skb) {
+		rsi_dbg(ERR_ZONE, "%s: Failed in allocation of skb\n",
+			__func__);
+		return -1;
+	}
+
+	memset(skb->data, 0, MAX_MGMT_PKT_SIZE);
+	mgmt_frame = (struct rsi_mac_frame *)skb->data;
+
+	mgmt_frame->desc_word[1] = cpu_to_le16(RADIO_CAPABILITIES);
+	mgmt_frame->desc_word[4] = cpu_to_le16(RSI_RF_TYPE << 8);
+
+	if (common->channel_width == BW_40MHZ) {
+		mgmt_frame->desc_word[7] |= cpu_to_le16(RSI_LMAC_CLOCK_80MHZ);
+		mgmt_frame->desc_word[7] |= cpu_to_le16(RSI_ENABLE_40MHZ);
+		if (common->channel_width) {
+			mgmt_frame->desc_word[5] =
+				cpu_to_le16(common->channel_width << 12);
+			mgmt_frame->desc_word[5] |= cpu_to_le16(FULL40M_ENABLE);
+		}
+
+		if (conf_is_ht40_minus(conf)) {
+			mgmt_frame->desc_word[5] = 0;
+			mgmt_frame->desc_word[5] |=
+				cpu_to_le16(LOWER_20_ENABLE);
+			mgmt_frame->desc_word[5] |=
+				cpu_to_le16(LOWER_20_ENABLE >> 12);
+		}
+
+		if (conf_is_ht40_plus(conf)) {
+			mgmt_frame->desc_word[5] = 0;
+			mgmt_frame->desc_word[5] |=
+				cpu_to_le16(UPPER_20_ENABLE);
+			mgmt_frame->desc_word[5] |=
+				cpu_to_le16(UPPER_20_ENABLE >> 12);
+		}
+	}
+
+	mgmt_frame->desc_word[7] |= cpu_to_le16(radio_id << 8);
+
+	for (ii = 0; ii < MAX_HW_QUEUES; ii++) {
+		mgmt_frame->u.radio_caps.qos_params[ii].cont_win_min_q =
+			cpu_to_le16(3);
+		mgmt_frame->u.radio_caps.qos_params[ii].cont_win_max_q =
+			cpu_to_le16(0x3f);
+		mgmt_frame->u.radio_caps.qos_params[ii].aifsn_val_q =
+			cpu_to_le16(2);
+		mgmt_frame->u.radio_caps.qos_params[ii].txop_q = 0;
+	}
+
+	for (ii = 0; ii < MAX_HW_QUEUES - 4; ii++) {
+		mgmt_frame->u.radio_caps.qos_params[ii].cont_win_min_q =
+			cpu_to_le16(common->edca_params[ii].cw_min);
+		mgmt_frame->u.radio_caps.qos_params[ii].cont_win_max_q =
+			cpu_to_le16(common->edca_params[ii].cw_max);
+		mgmt_frame->u.radio_caps.qos_params[ii].aifsn_val_q =
+			cpu_to_le16((common->edca_params[ii].aifs) << 8);
+		mgmt_frame->u.radio_caps.qos_params[ii].txop_q =
+			cpu_to_le16(common->edca_params[ii].txop);
+	}
+
+	memcpy(&common->rate_pwr[0], &gc[0], 40);
+	for (ii = 0; ii < 20; ii++)
+		mgmt_frame->u.radio_caps.gcpd_per_rate[inx++] =
+			cpu_to_le16(common->rate_pwr[ii]  & 0x00FF);
+
+	mgmt_frame->desc_word[0] = cpu_to_le16(sizeof(mgmt_frame->u.radio_caps)|
+				    (RSI_WIFI_MGMT_Q << 12));
+
+
+	skb_put(skb, (sizeof(mgmt_frame->u.radio_caps) + FRAME_DESC_SZ));
+
+	return rsi_send_internal_mgmt_frame(common, skb);
+}
+
+/**
+ * This function is the entry point of Management module.
+ *
+ * @param  common Pointer to the driver private structure.
+ * @param  msg Pointer to received packet.
+ * @param  msg_len Length of the recieved packet.
+ * @param  type Type of recieved packet.
+ * @return 0 on success, -1 on failure.
+ */
+static int rsi_mgmt_pkt_to_core(struct rsi_common *common,
+				unsigned char *msg,
+				int msg_len,
+				unsigned char type)
+{
+	struct ieee80211_tx_info *info;
+	struct skb_info *rx_params;
+	unsigned char pad_bytes = msg[4];
+	unsigned char pkt_recv;
+	struct sk_buff *skb;
+	char *buffer;
+
+	if (type == RX_DOT11_MGMT) {
+		msg_len -= pad_bytes;
+		if ((msg_len <= 0) || (!msg)) {
+			rsi_dbg(MGMT_RX_ZONE, "Invalid rx msg of len = %d\n",
+				__func__, msg_len);
+			return -1;
+		}
+
+		skb = dev_alloc_skb(msg_len);
+		if (!skb) {
+			rsi_dbg(ERR_ZONE, "%s: Failed to allocate skb\n",
+				__func__);
+			return -1;
+		}
+
+		buffer = skb_put(skb, msg_len);
+
+		memcpy(buffer,
+		       (unsigned char *)(msg +  FRAME_DESC_SZ + pad_bytes),
+		       msg_len);
+
+		pkt_recv = buffer[0];
+
+		if ((pkt_recv != 0x50) && (pkt_recv != 0x80) &&
+		    (pkt_recv != 0x40)) {
+			rsi_dbg(MGMT_RX_ZONE, "%s: ===> MGMT PKT RCVD <===\n",
+				__func__);
+		}
+		info = IEEE80211_SKB_CB(skb);
+		rx_params = (struct skb_info *)info->driver_data;
+		rx_params->rssi = rsi_get_rssi(msg);
+		rx_params->channel = rsi_get_channel(msg);
+		rsi_indicate_pkt_to_os(common, skb);
+	} else {
+		rsi_dbg(MGMT_TX_ZONE, "%s: Internal Packet\n", __func__);
+	}
+
+	return 0;
+}
+
+/**
+ * This function sends station notify frame to firmware.
+ *
+ * @param  common Pointer to the driver private structure.
+ * @param  opmode Operating mode of device.
+ * @param  notify_event Notification about station connection.
+ * @param  bssid bssid.
+ * @param  qos_enable Qos is enabled.
+ * @param  aid Aid (unique for all STA).
+ * @return status: 0 on success, corresponding negative error code on failure.
+ */
+static int rsi_hal_send_sta_notify_frame(struct rsi_common *common,
+					 unsigned char opmode,
+					 unsigned char notify_event,
+					 const unsigned char *bssid,
+					 unsigned char qos_enable,
+					 unsigned short aid)
+{
+	struct sk_buff *skb = NULL;
+	struct rsi_mac_frame *mgmt_frame;
+	unsigned short vap_id = 0;
+	int status;
+
+	rsi_dbg(MGMT_TX_ZONE, "%s: Sending sta notify frame\n", __func__);
+
+	skb = dev_alloc_skb(MAX_MGMT_PKT_SIZE);
+
+	if (!skb) {
+		rsi_dbg(ERR_ZONE, "%s: Failed in allocation of skb\n",
+			__func__);
+		return -1;
+	}
+
+	memset(skb->data, 0, MAX_MGMT_PKT_SIZE);
+	mgmt_frame = (struct rsi_mac_frame *)skb->data;
+
+	mgmt_frame->u.peer_notify.command = cpu_to_le16(opmode << 1);
+
+	switch (notify_event) {
+	case STA_CONNECTED:
+		mgmt_frame->u.peer_notify.command |= cpu_to_le16(RSI_ADD_PEER);
+		break;
+	case STA_DISCONNECTED:
+		mgmt_frame->u.peer_notify.command |=
+			cpu_to_le16(RSI_DELETE_PEER);
+		break;
+	case STA_TX_ADDBA_DONE:
+	case STA_TX_DELBA:
+	case STA_RX_ADDBA_DONE:
+	case STA_RX_DELBA:
+		break;
+	default:
+		break;
+	}
+
+	mgmt_frame->u.peer_notify.command |= cpu_to_le16((aid & 0xfff) << 4);
+	memcpy(mgmt_frame->u.peer_notify.mac_addr, bssid, ETH_ALEN);
+	mgmt_frame->u.peer_notify.sta_flags = cpu_to_le16((qos_enable) ? 1 : 0);
+
+	mgmt_frame->desc_word[0] =
+		cpu_to_le16(sizeof(mgmt_frame->u.peer_notify) |
+			    (RSI_WIFI_MGMT_Q << 12));
+	mgmt_frame->desc_word[1] = cpu_to_le16(PEER_NOTIFY);
+	mgmt_frame->desc_word[7] |= cpu_to_le16(vap_id << 8);
+
+	skb_put(skb, sizeof(mgmt_frame->u.peer_notify) + FRAME_DESC_SZ);
+
+	status = rsi_send_internal_mgmt_frame(common, skb);
+
+	if ((!status) && (qos_enable)) {
+		rsi_set_contention_vals(common);
+		status = rsi_load_radio_caps(common);
+	}
+	return status;
+}
+
+/**
+ * This function sends ampdu indication frame to firmware.
+ *
+ * @param  common Pointer to the driver private structure.
+ * @param  tid traffic identifier.
+ * @param  ssn ssn.
+ * @param  buf_size buffer size (for kernel version > 2.6.38).
+ * @param  event notification about station connection.
+ * @return 0 on success, corresponding negative error code on failure.
+ */
+int rsi_send_ampdu_indication_frame(struct rsi_common *common,
+				    unsigned short tid,
+				    unsigned short ssn,
+				    unsigned char buf_size,
+				    unsigned char event)
+{
+	struct sk_buff *skb = NULL;
+	struct rsi_mac_frame *mgmt_frame;
+	unsigned char peer_id = 0;
+
+	skb = dev_alloc_skb(MAX_MGMT_PKT_SIZE);
+
+	if (!skb) {
+		rsi_dbg(ERR_ZONE, "%s: Failed in allocation of skb\n",
+			__func__);
+		return -1;
+	}
+
+	memset(skb->data, 0, MAX_MGMT_PKT_SIZE);
+	mgmt_frame = (struct rsi_mac_frame *)skb->data;
+
+	rsi_dbg(MGMT_TX_ZONE, "%s: Sending AMPDU indication frame\n", __func__);
+
+	mgmt_frame->desc_word[0] = cpu_to_le16(RSI_WIFI_MGMT_Q << 12);
+	mgmt_frame->desc_word[1] = cpu_to_le16(AMPDU_IND);
+
+	if (event == STA_TX_ADDBA_DONE) {
+		mgmt_frame->desc_word[4] = cpu_to_le16(ssn);
+		mgmt_frame->desc_word[5] = cpu_to_le16(buf_size);
+		mgmt_frame->desc_word[7] =
+		cpu_to_le16((tid | (START_AMPDU_AGGR << 4) | (peer_id << 8)));
+	} else if (event == STA_RX_ADDBA_DONE) {
+		mgmt_frame->desc_word[4] = cpu_to_le16(ssn);
+		mgmt_frame->desc_word[7] = cpu_to_le16(tid |
+						       (START_AMPDU_AGGR << 4) |
+						       (RX_BA_INDICATION << 5) |
+						       (peer_id << 8));
+	} else if (event == STA_TX_DELBA) {
+		mgmt_frame->desc_word[7] = cpu_to_le16(tid |
+						       (STOP_AMPDU_AGGR << 4) |
+						       (peer_id << 8));
+	} else if (event == STA_RX_DELBA) {
+		mgmt_frame->desc_word[7] = cpu_to_le16(tid |
+						       (STOP_AMPDU_AGGR << 4) |
+						       (RX_BA_INDICATION << 5) |
+						       (peer_id << 8));
+	}
+
+	skb_put(skb, FRAME_DESC_SZ);
+
+	return rsi_send_internal_mgmt_frame(common, skb);
+}
+
+/**
+ * This function starts base band and RF programming.
+ * This is called after initial configurations are done.
+ *
+ * @param  common Pointer to the driver private structure.
+ * @return 0 on success, corresponding negative error code on failure.
+ */
+static int rsi_program_bb_rf(struct rsi_common *common)
+{
+	struct sk_buff *skb;
+	struct rsi_mac_frame *mgmt_frame;
+
+	rsi_dbg(MGMT_TX_ZONE, "%s: Sending program BB/RF frame\n", __func__);
+
+	skb = dev_alloc_skb(MAX_MGMT_PKT_SIZE);
+	if (!skb) {
+		rsi_dbg(ERR_ZONE, "%s: Failed in allocation of skb\n",
+			__func__);
+		return -1;
+	}
+
+	memset(skb->data, 0, MAX_MGMT_PKT_SIZE);
+	mgmt_frame = (struct rsi_mac_frame *)skb->data;
+
+#ifdef USE_USB_INTF
+	mgmt_frame->desc_word[0] = cpu_to_le16(RSI_WIFI_MGMT_Q << 12);
+#else
+	mgmt_frame->desc_word[0] = cpu_to_le16((FRAME_DESC_SZ) |
+					       (RSI_WIFI_MGMT_Q << 12));
+#endif
+	mgmt_frame->desc_word[1] = cpu_to_le16(BBP_PROG_IN_TA);
+	mgmt_frame->desc_word[4] = cpu_to_le16(common->endpoint << 8);
+
+	if (common->rf_reset) {
+		mgmt_frame->desc_word[7] =  cpu_to_le16(RF_RESET_ENABLE);
+		rsi_dbg(MGMT_TX_ZONE, "%s: ===> RF RESET REQUEST SENT <===\n",
+			__func__);
+		common->rf_reset = 0;
+	}
+	common->bb_rf_prog_count = 1;
+	mgmt_frame->desc_word[7] |= cpu_to_le16(PUT_BBP_RESET |
+				     BBP_REG_WRITE | (RSI_RF_TYPE << 4));
+	skb_put(skb, FRAME_DESC_SZ);
+
+	return rsi_send_internal_mgmt_frame(common, skb);
+}
+
+/**
+ * This function sends vap capabilities to firmware.
+ *
+ * @param  common Pointer to the driver private structure.
+ * @param  opmode Operating mode of device.
+ * @return 0 on success, corresponding negative error code on failure.
+ */
+int rsi_set_vap_capabilities(struct rsi_common *common,
+			     unsigned char opmode)
+{
+	struct sk_buff *skb = NULL;
+	struct rsi_mac_frame *mgmt_frame;
+	unsigned short vap_id = 0;
+
+	rsi_dbg(MGMT_TX_ZONE, "%s: Sending VAP capabilities frame\n", __func__);
+
+	skb = dev_alloc_skb(MAX_MGMT_PKT_SIZE);
+	if (!skb) {
+		rsi_dbg(ERR_ZONE, "%s: Failed in allocation of skb\n",
+			__func__);
+		return -1;
+	}
+
+	memset(skb->data, 0, MAX_MGMT_PKT_SIZE);
+	mgmt_frame = (struct rsi_mac_frame *)skb->data;
+
+	mgmt_frame->desc_word[0] = cpu_to_le16((sizeof(mgmt_frame->u.vap_caps))|
+				    (RSI_WIFI_MGMT_Q << 12));
+	mgmt_frame->desc_word[1] = cpu_to_le16(VAP_CAPABILITIES);
+	mgmt_frame->desc_word[4] = cpu_to_le16(opmode |
+					       (common->channel_width << 8));
+	mgmt_frame->desc_word[7] = cpu_to_le16((vap_id << 8) |
+					       (common->mac_id << 4) |
+					       common->radio_id);
+
+	memcpy(mgmt_frame->u.vap_caps.mac_addr,
+	       common->mac_addr,
+	       IEEE80211_ADDR_LEN);
+	mgmt_frame->u.vap_caps.keep_alive_period = cpu_to_le16(90);
+	mgmt_frame->u.vap_caps.frag_threshold = cpu_to_le16(MAX_FRAG_LEN);
+
+	mgmt_frame->u.vap_caps.rts_threshold =
+		cpu_to_le16(common->rts_threshold);
+	mgmt_frame->u.vap_caps.default_mgmt_rate_bbpinfo = 0;
+	if (conf_is_ht40(&common->priv->hw->conf)) {
+		mgmt_frame->u.vap_caps.default_ctrl_rate_bbpinfo =
+				cpu_to_le16(RSI_RATE_6 | FULL40M_ENABLE << 16);
+	} else {
+		mgmt_frame->u.vap_caps.default_ctrl_rate_bbpinfo =
+			RSI_RATE_6;
+	}
+	mgmt_frame->u.vap_caps.default_data_rate_bbpinfo = cpu_to_le16(0);
+	mgmt_frame->u.vap_caps.beacon_interval = cpu_to_le16(200);
+	mgmt_frame->u.vap_caps.dtim_period = cpu_to_le16(4);
+
+	skb_put(skb, sizeof(mgmt_frame->u.vap_caps) + FRAME_DESC_SZ);
+
+	return rsi_send_internal_mgmt_frame(common, skb);
+}
+
+/**
+ * This function is used to load the keys within the firmware.
+ *
+ * @param  common Pointer to the driver private structure.
+ * @param  data Pointer to the key data.
+ * @param  key_len Key length to be loaded.
+ * @param  key_type Type of key: GROUP/PAIRWISE.
+ * @param  key_id Key index.
+ * @param  cipher Type of cipher used.
+ * @return 0 on success, -1 on failure.
+ */
+int rsi_hal_load_key(struct rsi_common *common,
+		     unsigned char *data,
+		     unsigned short key_len,
+		     unsigned char key_type,
+		     unsigned char key_id,
+		     unsigned int cipher)
+{
+	struct sk_buff *skb = NULL;
+	struct rsi_mac_frame *mgmt_frame;
+	unsigned char key_t1 = 0;
+	unsigned short key_descriptor = 0;
+
+	rsi_dbg(MGMT_TX_ZONE, "%s: Sending load key frame\n", __func__);
+
+	skb = dev_alloc_skb(MAX_MGMT_PKT_SIZE);
+	if (!skb) {
+		rsi_dbg(ERR_ZONE, "%s: Failed in allocation of skb\n",
+			__func__);
+		return -1;
+	}
+
+	memset(skb->data, 0, MAX_MGMT_PKT_SIZE);
+	mgmt_frame = (struct rsi_mac_frame *)skb->data;
+
+	switch (key_type) {
+	case RSI_GROUP_KEY:
+		key_t1 = (1 << 1);
+		break;
+	case RSI_PAIRWISE_KEY:
+		key_t1 = (0 << 1);
+		if ((cipher != WLAN_CIPHER_SUITE_WEP40) &&
+		    (cipher != WLAN_CIPHER_SUITE_WEP104))
+			key_id = 0;
+		break;
+	}
+
+	key_descriptor |= (key_t1 | BIT(13) | (key_id << 14));
+	if ((cipher == WLAN_CIPHER_SUITE_WEP40) ||
+	    (cipher == WLAN_CIPHER_SUITE_WEP104)) {
+		key_len += 1;
+		key_descriptor |= BIT(2);
+		if (key_len >= 13)
+			key_descriptor |= BIT(3);
+	} else if (cipher != KEY_TYPE_CLEAR) {
+		key_descriptor |= BIT(4);
+		if (cipher == WLAN_CIPHER_SUITE_TKIP)
+			key_descriptor |= BIT(5);
+	}
+
+	mgmt_frame->desc_word[0] = cpu_to_le16(sizeof(mgmt_frame->u.set_key) |
+				    (RSI_WIFI_MGMT_Q << 12));
+	mgmt_frame->desc_word[1] = cpu_to_le16(SET_KEY_REQ);
+	mgmt_frame->desc_word[4] = cpu_to_le16(key_descriptor);
+
+	if ((cipher == WLAN_CIPHER_SUITE_WEP40) ||
+	    (cipher == WLAN_CIPHER_SUITE_WEP104)) {
+		memcpy(&mgmt_frame->u.set_key.key[key_id][1],
+		       data,
+		       key_len * 2);
+	} else {
+		memcpy(&mgmt_frame->u.set_key.key[0][0], data, key_len);
+	}
+
+	memcpy(&mgmt_frame->u.set_key.tx_mic_key, &data[16], 8);
+	memcpy(&mgmt_frame->u.set_key.rx_mic_key, &data[24], 8);
+
+	skb_put(skb, sizeof(mgmt_frame->u.set_key) + FRAME_DESC_SZ);
+
+	return rsi_send_internal_mgmt_frame(common, skb);
+}
+
+/**
+ * This function sends bootup parameters to the firmware.
+ *
+ * @param  common Pointer to the driver private structure.
+ * @return 0 on success, corresponding error code on failure.
+ */
+static unsigned char rsi_load_bootup_params(struct rsi_common *common)
+{
+	struct sk_buff *skb;
+	struct rsi_mac_frame *mgmt_frame;
+
+	rsi_dbg(MGMT_TX_ZONE, "%s: Sending boot params frame\n", __func__);
+	skb = dev_alloc_skb(MAX_MGMT_PKT_SIZE);
+	if (!skb) {
+		rsi_dbg(ERR_ZONE, "%s: Failed in allocation of skb\n",
+			__func__);
+		return -1;
+	}
+
+	memset(skb->data, 0, MAX_MGMT_PKT_SIZE);
+	mgmt_frame = (struct rsi_mac_frame *)skb->data;
+
+	rsi_dbg(MGMT_TX_ZONE, "%s:\n", __func__);
+
+	if (common->channel_width == BW_40MHZ) {
+		memcpy(&mgmt_frame->u.bootup_params,
+		       &boot_params_40,
+		       sizeof(struct bootup_params));
+		rsi_dbg(MGMT_TX_ZONE, "%s: Packet 40MHZ <=== %d\n", __func__,
+			UMAC_CLK_40BW);
+		mgmt_frame->desc_word[7] = (UMAC_CLK_40BW);
+	} else {
+		memcpy(&mgmt_frame->u.bootup_params,
+		       &boot_params_20,
+		       sizeof(struct bootup_params));
+		if (boot_params_20.valid != VALID_20) {
+			mgmt_frame->desc_word[7] = (UMAC_CLK_20BW);
+			rsi_dbg(MGMT_TX_ZONE,
+				"%s: Packet 20MHZ <=== %d\n", __func__,
+				UMAC_CLK_20BW);
+		} else {
+			mgmt_frame->desc_word[7] = (UMAC_CLK_40MHZ);
+			rsi_dbg(MGMT_TX_ZONE,
+				"%s: Packet 20MHZ <=== %d\n", __func__,
+				UMAC_CLK_40MHZ);
+		}
+	}
+
+	/* Bit{0:11} indicates length of the Packet
+	 * Bit{12:15} indicates host queue number
+	 */
+	mgmt_frame->desc_word[0] = (sizeof(struct bootup_params) |
+				    (RSI_WIFI_MGMT_Q << 12));
+	mgmt_frame->desc_word[1] = (BOOTUP_PARAMS_REQUEST);
+
+	skb_put(skb, sizeof(struct bootup_params) + FRAME_DESC_SZ);
+
+	return rsi_send_internal_mgmt_frame(common, skb);
+}
+
+/**
+ * This function prepares reset MAC request and sends a internal management
+ * frame to indicate it to firmware.
+ *
+ * @param  common Pointer to the driver private structure.
+ * @return 0 on success, corresponding error code on failure.
+ */
+static int rsi_send_reset_mac(struct rsi_common *common)
+{
+	struct sk_buff *skb;
+	struct rsi_mac_frame *mgmt_frame;
+
+	rsi_dbg(MGMT_TX_ZONE, "%s: Sending reset MAC frame\n", __func__);
+
+	skb = dev_alloc_skb(MAX_MGMT_PKT_SIZE);
+	if (!skb) {
+		rsi_dbg(ERR_ZONE, "%s: Failed in allocation of skb\n",
+			__func__);
+		return -1;
+	}
+
+	memset(skb->data, 0, MAX_MGMT_PKT_SIZE);
+	mgmt_frame = (struct rsi_mac_frame *)skb->data;
+
+	mgmt_frame->desc_word[0] = cpu_to_le16(RSI_WIFI_MGMT_Q << 12);
+	mgmt_frame->desc_word[1] = cpu_to_le16(RESET_MAC_REQ);
+	mgmt_frame->desc_word[4] |= cpu_to_le16(RETRY_COUNT << 8);
+
+	skb_put(skb, FRAME_DESC_SZ);
+
+	return rsi_send_internal_mgmt_frame(common, skb);
+}
+
+/**
+ * This function programs the channel.
+ *
+ * @param  common Pointer to the driver private structure.
+ * @param  channel Channel value to be set.
+ * @return 0 on success, corresponding error code on failure.
+ */
+int rsi_set_channel(struct rsi_common *common, unsigned short channel)
+{
+	struct sk_buff *skb = NULL;
+	struct rsi_mac_frame *mgmt_frame;
+
+	rsi_dbg(MGMT_TX_ZONE,
+		"%s: Sending scan req frame\n", __func__);
+
+	skb = dev_alloc_skb(MAX_MGMT_PKT_SIZE);
+	if (!skb) {
+		rsi_dbg(ERR_ZONE, "%s: Failed in allocation of skb\n",
+			__func__);
+		return -1;
+	}
+
+	memset(skb->data, 0, MAX_MGMT_PKT_SIZE);
+	mgmt_frame = (struct rsi_mac_frame *)skb->data;
+
+	if (common->band == IEEE80211_BAND_5GHZ) {
+		if ((channel >= 36) && (channel <= 64))
+			channel = ((channel - 32) / 4);
+		else if ((channel > 64) && (channel <= 140))
+			channel = ((channel - 102) / 4) + 8;
+		else if (channel >= 149)
+			channel = ((channel - 151) / 4) + 18;
+		else
+			return -1;
+	} else {
+		if (channel > 14) {
+			rsi_dbg(ERR_ZONE, "%s: Invalid chno %d, band = %d\n",
+				__func__, channel, common->band);
+			return 0;
+		}
+	}
+
+	mgmt_frame->desc_word[0] = ((sizeof(mgmt_frame->u.rf_prog_req)) |
+				    (RSI_WIFI_MGMT_Q << 12));
+	mgmt_frame->desc_word[1] = (SCAN_REQUEST);
+	mgmt_frame->desc_word[4] = channel;
+
+	mgmt_frame->desc_word[7] =  (PUT_BBP_RESET |
+				     BBP_REG_WRITE |
+				     (RSI_RF_TYPE << 4));
+
+
+	mgmt_frame->desc_word[4] = channel;
+	mgmt_frame->desc_word[5] = 0x01;
+
+	if (common->channel_width == BW_40MHZ)
+		mgmt_frame->desc_word[5] |= (0x1 << 8);
+
+	common->channel = channel;
+
+	skb_put(skb, sizeof(mgmt_frame->u.rf_prog_req) + FRAME_DESC_SZ);
+
+	return rsi_send_internal_mgmt_frame(common, skb);
+}
+
+/**
+ * This function is used to compare two integers
+ *
+ * @param  pointer to the first integer
+ * @param  pointer to the second integer
+ * @return 0 if both are equal, -1 if the first is smaller, else 1
+ */
+static int rsi_compare(const void *a, const void *b)
+{
+	unsigned short int_a = *(const unsigned short *)(a);
+	unsigned short int_b = *(const unsigned short *)(b);
+
+	if (int_a > int_b)
+		return -1;
+
+	if (int_a < int_b)
+		return 1;
+
+	return 0;
+}
+
+/**
+ * This function is used to map the selected rates to hw rates
+ *
+ * @param  the standard rate to be mapped
+ * @param  offset that will be returned
+ * @return 0 if it is a mcs rate, else 1
+ */
+static bool rsi_map_rates(unsigned short rate, int *offset)
+{
+	int kk;
+	for (kk = 0; kk < ARRAY_SIZE(rsi_mcsrates); kk++) {
+		if (rate == mcs[kk]) {
+			*offset = kk;
+			return 0;
+		}
+	}
+
+	for (kk = 0; kk < ARRAY_SIZE(rsi_rates); kk++) {
+		if (rate == rsi_rates[kk].bitrate/5) {
+			*offset = kk;
+			break;
+		}
+	}
+	return 1;
+}
+
+/**
+ * This function sets rates for connection ,sends autorate request.
+ *
+ * @param  common Pointer to the driver private structure.
+ * @return 0 on success, corresponding error code on failure.
+ */
+static int rsi_send_auto_rate_request(struct rsi_common *common)
+{
+	struct sk_buff *skb;
+	struct rsi_mac_frame *mgmt_frame;
+	int ii, jj, kk;
+	struct ieee80211_hw *hw = common->priv->hw;
+	unsigned char band = hw->conf.chandef.chan->band;
+	unsigned char num_supported_rates = 0;
+	unsigned char rate_offset = 0;
+	unsigned int rate_bitmap = common->bitrate_mask[band];
+
+	unsigned short *selected_rates, min_rate;
+
+	skb = dev_alloc_skb(MAX_MGMT_PKT_SIZE);
+	if (!skb) {
+		rsi_dbg(ERR_ZONE, "%s: Failed in allocation of skb\n",
+			__func__);
+		return -1;
+	}
+
+	selected_rates = kmalloc(2 * RSI_TBL_SZ, GFP_KERNEL);
+
+	memset(skb->data, 0, MAX_MGMT_PKT_SIZE);
+	memset(selected_rates, 0, 2 * RSI_TBL_SZ);
+
+	mgmt_frame = (struct rsi_mac_frame *)skb->data;
+
+	mgmt_frame->u.auto_rate.aarf_rssi = cpu_to_le16(((
+					     (unsigned short)3 << 6) |
+					     (unsigned short)(18 & 0x3f)));
+	mgmt_frame->u.auto_rate.collision_tolerance = cpu_to_le16(3);
+	mgmt_frame->u.auto_rate.failure_limit = cpu_to_le16(3);
+	mgmt_frame->u.auto_rate.initial_boundary = cpu_to_le16(3);
+	mgmt_frame->u.auto_rate.max_threshold_limt = cpu_to_le16(27);
+
+	mgmt_frame->desc_word[1] = cpu_to_le16(AUTO_RATE_IND);
+
+	if (common->channel_width == BW_40MHZ)
+		mgmt_frame->desc_word[7] |= cpu_to_le16(1);
+
+	if (band == IEEE80211_BAND_2GHZ)
+		min_rate = STD_RATE_01;
+	else
+		min_rate = STD_RATE_06;
+
+	for (ii = 0, jj = 0; ii < ARRAY_SIZE(rsi_rates); ii++) {
+		if (rate_bitmap & BIT(ii)) {
+			selected_rates[jj++] = (rsi_rates[ii].bitrate / 5);
+			rate_offset++;
+		}
+	}
+	num_supported_rates = jj;
+
+	if (common->vif_info[0].is_ht) {
+		for (ii = 0; ii < ARRAY_SIZE(mcs); ii++)
+			selected_rates[jj++] = mcs[ii];
+		num_supported_rates += ARRAY_SIZE(mcs);
+		rate_offset += ARRAY_SIZE(mcs);
+	}
+
+	if (rate_offset < (RSI_TBL_SZ / 2) - 1) {
+		for (ii = jj; ii < (RSI_TBL_SZ / 2); ii++) {
+			selected_rates[jj++] = min_rate;
+			rate_offset++;
+		}
+	}
+
+	sort(selected_rates, jj, sizeof(unsigned short), &rsi_compare, NULL);
+
+	/* mapping the rates to RSI rates */
+	for (ii = 0; ii < jj; ii++) {
+		if (rsi_map_rates(selected_rates[ii], &kk)) {
+			mgmt_frame->u.auto_rate.supported_rates[ii] =
+				cpu_to_le16(rsi_rates[kk].hw_value);
+		} else {
+			mgmt_frame->u.auto_rate.supported_rates[ii] =
+				cpu_to_le16(rsi_mcsrates[kk]);
+		}
+	}
+
+	/* loading HT rates in the bottom half of the AR table */
+	if (common->vif_info[0].is_ht) {
+		if (common->vif_info[0].sgi)
+			mgmt_frame->u.auto_rate.supported_rates[rate_offset++] =
+				cpu_to_le16(RSI_RATE_MCS7_SG);
+
+		for (ii = rate_offset, kk = ARRAY_SIZE(rsi_mcsrates)-1;
+		     ii < rate_offset + 2*ARRAY_SIZE(rsi_mcsrates);
+		     ii++) {
+			if (common->vif_info[0].sgi)
+				mgmt_frame->u.auto_rate.supported_rates[ii++] =
+					cpu_to_le16(rsi_mcsrates[kk] | BIT(9));
+			mgmt_frame->u.auto_rate.supported_rates[ii] =
+				cpu_to_le16(rsi_mcsrates[kk--]);
+		}
+
+		for (; ii < RSI_TBL_SZ; ii++) {
+			mgmt_frame->u.auto_rate.supported_rates[ii] =
+				cpu_to_le16(rsi_mcsrates[0]);
+		}
+	}
+
+	mgmt_frame->u.auto_rate.num_supported_rates =
+		cpu_to_le16(num_supported_rates * 2);
+	mgmt_frame->u.auto_rate.moderate_rate_inx =
+		cpu_to_le16(num_supported_rates / 2);
+	mgmt_frame->desc_word[7] |= cpu_to_le16(0 << 8);
+	num_supported_rates *= 2;
+
+	mgmt_frame->desc_word[0] = cpu_to_le16((sizeof(mgmt_frame->u.auto_rate)
+				    + num_supported_rates +
+				    (RSI_WIFI_MGMT_Q << 12)));
+
+	skb_put(skb,
+		sizeof(mgmt_frame->u.auto_rate) + num_supported_rates +
+		       FRAME_DESC_SZ);
+	kfree(selected_rates);
+
+	return rsi_send_internal_mgmt_frame(common, skb);
+}
+
+/**
+ * This function informs about bss status with the help of sta notify
+ * parameters by sending a internal management frame to firmware.
+ *
+ * @param  common Pointer to the driver private structure.
+ * @param  status Bss status type.
+ * @param  bssid Bssid.
+ * @param  qos_enable Qos is enabled.
+ * @param  aid Aid (unique for all STA).
+ * @return None.
+ */
+void rsi_inform_bss_status(struct rsi_common *common,
+			   unsigned char status,
+			   const unsigned char *bssid,
+			   unsigned char qos_enable,
+			   unsigned short aid)
+{
+	if (status) {
+		rsi_hal_send_sta_notify_frame(common,
+					      NL80211_IFTYPE_STATION,
+					      STA_CONNECTED,
+					      bssid,
+					      qos_enable,
+					      aid);
+		if (common->min_rate == 0xffff)
+			rsi_send_auto_rate_request(common);
+	} else {
+		rsi_hal_send_sta_notify_frame(common,
+					      NL80211_IFTYPE_STATION,
+					      STA_DISCONNECTED,
+					      bssid,
+					      qos_enable,
+					      aid);
+	}
+	return;
+}
+
+/**
+ * This function send a frame to read the
+ * mac address from the eeprom.
+ *
+ * @param  common Pointer to the driver private structure.
+ * @return 0 on success, -1 on failure.
+ */
+static int rsi_eeprom_read(struct rsi_common *common)
+{
+	struct rsi_mac_frame *mgmt_frame;
+	struct sk_buff *skb;
+
+	rsi_dbg(MGMT_TX_ZONE, "%s: Sending EEPROM read req frame\n", __func__);
+
+	skb = dev_alloc_skb(MAX_MGMT_PKT_SIZE);
+	if (!skb) {
+		rsi_dbg(ERR_ZONE, "%s: Failed in allocation of skb\n",
+			__func__);
+		return -1;
+	}
+
+	memset(skb->data, 0, MAX_MGMT_PKT_SIZE);
+	mgmt_frame = (struct rsi_mac_frame *)skb->data;
+
+	/* FrameType */
+	mgmt_frame->desc_word[1] = cpu_to_le16(EEPROM_READ_TYPE);
+	mgmt_frame->desc_word[0] = cpu_to_le16(RSI_WIFI_MGMT_Q << 12);
+	/* Number of bytes to read */
+	mgmt_frame->desc_word[3] = cpu_to_le16(ETH_ALEN +
+				    WLAN_MAC_MAGIC_WORD_LEN +
+				    WLAN_HOST_MODE_LEN);
+	/* Address to read */
+	mgmt_frame->desc_word[4] = cpu_to_le16(WLAN_MAC_EEPROM_ADDR);
+
+	skb_put(skb, FRAME_DESC_SZ);
+
+	return rsi_send_internal_mgmt_frame(common, skb);
+}
+
+/**
+ * This function handles the confirm frames.
+ *
+ * @param  common Pointer to the driver private structure.
+ * @param  msg Pointer to received packet.
+ * @return 0 on success, -1 on failure.
+ */
+static int rsi_handle_ta_confirm_type(struct rsi_common *common,
+				      unsigned char *msg)
+{
+	unsigned char sub_type = (msg[15] & 0xff);
+
+	switch (sub_type) {
+	case BOOTUP_PARAMS_REQUEST:
+		rsi_dbg(FSM_ZONE, "%s: Boot up params confirm received\n",
+			__func__);
+		if (common->fsm_state == FSM_BOOT_PARAMS_SENT) {
+			if (rsi_eeprom_read(common)) {
+				common->fsm_state = FSM_CARD_NOT_READY;
+				goto out;
+			} else {
+				common->fsm_state = FSM_EEPROM_READ_MAC_ADDR;
+			}
+		} else {
+			rsi_dbg(ERR_ZONE,
+				"%s: Received bootup params cfm in %d state\n",
+				 __func__, common->fsm_state);
+			return 0;
+		}
+		break;
+
+	case EEPROM_READ_TYPE:
+		if (common->fsm_state == FSM_EEPROM_READ_MAC_ADDR) {
+			if (msg[16] == MAGIC_WORD) {
+				memcpy(common->mac_addr,
+				       &msg[FRAME_DESC_SZ +
+				       WLAN_HOST_MODE_LEN +
+				       WLAN_MAC_MAGIC_WORD_LEN],
+				       ETH_ALEN);
+			} else {
+				common->fsm_state = FSM_CARD_NOT_READY;
+				break;
+			}
+			if (rsi_send_reset_mac(common))
+				goto out;
+			else
+				common->fsm_state = FSM_RESET_MAC_SENT;
+		} else {
+			rsi_dbg(ERR_ZONE,
+				"%s: Received eeprom mac addr in %d state\n",
+				__func__, common->fsm_state);
+			return 0;
+		}
+		break;
+
+	case RESET_MAC_REQ:
+		if (common->fsm_state == FSM_RESET_MAC_SENT) {
+			rsi_dbg(FSM_ZONE, "%s: Reset MAC cfm received\n",
+				__func__);
+
+			if (rsi_load_radio_caps(common))
+				goto out;
+			else
+				common->fsm_state = FSM_RADIO_CAPS_SENT;
+		} else {
+			rsi_dbg(ERR_ZONE,
+				"%s: Received reset mac cfm in %d state\n",
+				 __func__, common->fsm_state);
+			return 0;
+		}
+		break;
+
+	case RADIO_CAPABILITIES:
+		if (common->fsm_state == FSM_RADIO_CAPS_SENT) {
+			common->rf_reset = 1;
+			if (rsi_program_bb_rf(common)) {
+				goto out;
+			} else {
+				common->fsm_state = FSM_BB_RF_PROG_SENT;
+				rsi_dbg(FSM_ZONE, "%s: Radio cap cfm received\n",
+					__func__);
+			}
+		} else {
+			rsi_dbg(ERR_ZONE,
+				"%s: Received radio caps cfm in %d state\n",
+				 __func__, common->fsm_state);
+			return 0;
+		}
+		break;
+
+	case BB_PROG_VALUES_REQUEST:
+	case RF_PROG_VALUES_REQUEST:
+	case BBP_PROG_IN_TA:
+		rsi_dbg(FSM_ZONE, "%s: BB/RF cfm received\n", __func__);
+		if (common->fsm_state == FSM_BB_RF_PROG_SENT) {
+			common->bb_rf_prog_count--;
+			if (!common->bb_rf_prog_count) {
+				common->fsm_state = FSM_MAC_INIT_DONE;
+				return rsi_mac80211_attach(common);
+			}
+		} else {
+			goto out;
+		}
+		break;
+
+	default:
+		rsi_dbg(INFO_ZONE, "%s: Invalid TA confirm pkt received\n",
+			__func__);
+		break;
+	}
+	return 0;
+out:
+	rsi_dbg(ERR_ZONE, "%s: Unable to send pkt/Invalid frame received\n",
+		__func__);
+	return -1;
+}
+
+/**
+ * This function process the management packets recieved from the hardware.
+ *
+ * @param  common Pointer to the driver private structure.
+ * @param  msg Pointer to the received packet.
+ * @return 0 on success, -1 on failure.
+ */
+int rsi_mgmt_pkt_recv(struct rsi_common *common, unsigned char *msg)
+{
+	int msg_len = (*(unsigned short *)&msg[0] & 0x0fff);
+	unsigned short msg_type = (msg[2]);
+
+	rsi_dbg(FSM_ZONE, "%s: Msg Len: %d, Msg Type: %4x\n",
+		__func__, msg_len, msg_type);
+
+	if (msg_type == TA_CONFIRM_TYPE) {
+		return rsi_handle_ta_confirm_type(common, msg);
+	} else if (msg_type == CARD_READY_IND) {
+		rsi_dbg(FSM_ZONE, "%s: Card ready indication received\n",
+			__func__);
+		if (common->fsm_state == FSM_CARD_NOT_READY) {
+			if (rsi_load_bootup_params(common))
+				return -1;
+			else
+				common->fsm_state = FSM_BOOT_PARAMS_SENT;
+		} else {
+			return -1;
+		}
+	} else if (msg_type == TX_STATUS_IND) {
+		if (msg[15] == PROBEREQ_CONFIRM)
+			common->mgmt_q_block = false;
+			rsi_dbg(FSM_ZONE, "%s: Probe confirm received\n",
+				__func__);
+	} else {
+		return rsi_mgmt_pkt_to_core(common, msg, msg_len, msg_type);
+	}
+	return 0;
+}



    
  




Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.redpinesignals.com ([203.196.161.92]:52829 "EHLO
	mail.redpinesignals.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753879AbaCCIWq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Mar 2014 03:22:46 -0500
Received: from [192.168.40.2] ([192.168.40.2])
	(authenticated user fariya.f@redpinesignals.com)
	by mail.redpinesignals.com
	for linux-wireless@vger.kernel.org;
	Mon, 3 Mar 2014 13:52:42 +0530
Message-ID: <53143B7C.5030602@redpinesignals.com> (sfid-20140303_092250_887269_13F7DCB5)
Date: Mon, 03 Mar 2014 13:51:16 +0530
From: Fariya Fatima <fariya.f@redpinesignals.com>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: [PATCH 3.14.0-rc5 v3 6/10] rsi: MAC80211 callbacks and management
 functions internal to device
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Fariya Fatima

This patch has the remaining callbacks from MAC80211 to the
driver and functions which prepare management frames internal
to the device and also handles exchange of these internal
frames with the device.

Signed-off-by: Fariya Fatima <fariya.f@redpinesignals.com>
---

 rsi_91x_mac80211.c |  280 ++++++++++++++++++++++++++
 rsi_91x_mgmt.c     |  561 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 841 insertio

diff -rupN linux-3.14-rc5/drivers/net/wireless/rsi/rsi_91x_mac80211.c linux-3.14-rc5_new/drivers/net/wireless/rsi/rsi_91x_mac80211.c
--- linux-3.14-rc5/drivers/net/wireless/rsi/rsi_91x_mac80211.c	2014-03-04 07:36:41.196731156 +0545
+++ linux-3.14-rc5_new/drivers/net/wireless/rsi/rsi_91x_mac80211.c	2014-03-04 07:36:45.480677599 +0545
@@ -742,3 +742,283 @@ static int rsi_mac80211_set_rate_mask(st
 	return 0;
 }
 
+/**
+ * This function fills rx status in ieee80211_rx_status structure.
+ *
+ * @param  hw Pointer to the ieee80211_hw structure.
+ * @param  skb Pointer to the socket buffer structure.
+ * @param  common Pointer to the driver private structure.
+ * @param  rxs Pointer to the ieee80211_rx_status structure.
+ * @return None.
+ */
+static void rsi_fill_rx_status(struct ieee80211_hw *hw,
+			       struct sk_buff *skb,
+			       struct rsi_common *common,
+			       struct ieee80211_rx_status *rxs)
+{
+	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
+	struct skb_info *rx_params = (struct skb_info *)info->driver_data;
+	struct ieee80211_hdr *hdr;
+	char rssi = rx_params->rssi;
+	u8 hdrlen = 0;
+	u8 channel = rx_params->channel;
+	s32 freq;
+
+	hdr = ((struct ieee80211_hdr *)(skb->data));
+	hdrlen = ieee80211_hdrlen(hdr->frame_control);
+
+	memset(info, 0, sizeof(struct ieee80211_tx_info));
+
+	rxs->signal = -(rssi);
+
+	if (channel <= 14)
+		rxs->band = IEEE80211_BAND_2GHZ;
+	else
+		rxs->band = IEEE80211_BAND_5GHZ;
+
+	freq = ieee80211_channel_to_frequency(channel, rxs->band);
+
+	if (freq)
+		rxs->freq = freq;
+
+	if (ieee80211_has_protected(hdr->frame_control)) {
+		if (rsi_is_cipher_wep(common)) {
+			memmove(skb->data + 4, skb->data, hdrlen);
+			skb_pull(skb, 4);
+		} else {
+			memmove(skb->data + 8, skb->data, hdrlen);
+			skb_pull(skb, 8);
+			rxs->flag |= RX_FLAG_MMIC_STRIPPED;
+		}
+		rxs->flag |= RX_FLAG_DECRYPTED;
+		rxs->flag |= RX_FLAG_IV_STRIPPED;
+	}
+
+	return;
+}
+
+/**
+ * This function sends the recieved packet to mac80211.
+ *
+ * @param  common Pointer to the driver private structure.
+ * @param  skb Pointer to the socket buffer structure.
+ * @return None.
+ */
+void rsi_indicate_pkt_to_os(struct rsi_common *common,
+			    struct sk_buff *skb)
+{
+	struct rsi_hw *adapter = common->priv;
+	struct ieee80211_hw *hw = adapter->hw;
+	struct ieee80211_rx_status *rx_status = IEEE80211_SKB_RXCB(skb);
+
+	if ((common->iface_down) || (!adapter->sc_nvifs)) {
+		dev_kfree_skb(skb);
+		return;
+	}
+
+	/* filling in the ieee80211_rx_status flags */
+	rsi_fill_rx_status(hw, skb, common, rx_status);
+
+	ieee80211_rx_irqsafe(hw, skb);
+	return;
+}
+
+static void rsi_set_min_rate(struct ieee80211_hw *hw,
+			     struct ieee80211_sta *sta,
+			     struct rsi_common *common)
+{
+	u8 band = hw->conf.chandef.chan->band;
+	u8 ii;
+	u32 rate_bitmap;
+	bool matched = false;
+
+	common->bitrate_mask[band] = sta->supp_rates[band];
+
+	rate_bitmap = (common->fixedrate_mask[band] & sta->supp_rates[band]);
+
+	if (rate_bitmap & 0xfff) {
+		/* Find out the min rate */
+		for (ii = 0; ii < ARRAY_SIZE(rsi_rates); ii++) {
+			if (rate_bitmap & BIT(ii)) {
+				common->min_rate = rsi_rates[ii].hw_value;
+				matched = true;
+				break;
+			}
+		}
+	}
+
+	common->vif_info[0].is_ht = sta->ht_cap.ht_supported;
+
+	if ((common->vif_info[0].is_ht) && (rate_bitmap >> 12)) {
+		for (ii = 0; ii < ARRAY_SIZE(rsi_mcsrates); ii++) {
+			if ((rate_bitmap >> 12) & BIT(ii)) {
+				common->min_rate = rsi_mcsrates[ii];
+				matched = true;
+				break;
+			}
+		}
+	}
+
+	if (!matched)
+		common->min_rate = 0xffff;
+	return;
+}
+
+/**
+ * This function notifies driver about a peer getting connected.
+ *
+ * @param  hw pointer to the ieee80211_hw structure.
+ * @param  vif pointer to the ieee80211_vif structure.
+ * @param  sta pointer to the ieee80211_sta structure.
+ * @return 0 on success, -1 on failure.
+ */
+static int rsi_mac80211_sta_add(struct ieee80211_hw *hw,
+				struct ieee80211_vif *vif,
+				struct ieee80211_sta *sta)
+{
+	struct rsi_hw *adapter = hw->priv;
+	struct rsi_common *common = adapter->priv;
+
+	if (!sta)
+		return -1;
+
+	mutex_lock(&common->mutex);
+
+	rsi_set_min_rate(hw, sta, common);
+
+	if ((sta->ht_cap.cap & IEEE80211_HT_CAP_SGI_20) ||
+	    (sta->ht_cap.cap & IEEE80211_HT_CAP_SGI_40)) {
+		common->vif_info[0].sgi = true;
+	}
+
+	if (sta->ht_cap.ht_supported)
+		ieee80211_start_tx_ba_session(sta, 0, 0);
+
+	mutex_unlock(&common->mutex);
+
+	return 0;
+}
+
+/**
+ * This function notifies driver about a peer getting disconnected.
+ *
+ * @param  hw pointer to the ieee80211_hw structure.
+ * @param  vif pointer to the ieee80211_vif structure.
+ * @param  sta pointer to the ieee80211_sta structure.
+ * @return 0 on success, -1 on failure.
+ */
+static int rsi_mac80211_sta_remove(struct ieee80211_hw *hw,
+				   struct ieee80211_vif *vif,
+				   struct ieee80211_sta *sta)
+{
+	struct rsi_hw *adapter = hw->priv;
+	struct rsi_common *common = adapter->priv;
+
+	mutex_lock(&common->mutex);
+	/* Resetting all the fields to default values */
+	common->bitrate_mask[IEEE80211_BAND_2GHZ] = 0;
+	common->bitrate_mask[IEEE80211_BAND_5GHZ] = 0;
+	common->min_rate = 0xffff;
+	common->vif_info[0].is_ht = false;
+	common->vif_info[0].sgi = false;
+	common->vif_info[0].seq_start = 0;
+	common->secinfo.ptk_cipher = 0;
+	common->secinfo.gtk_cipher = 0;
+	mutex_unlock(&common->mutex);
+
+	return 0;
+}
+
+static struct ieee80211_ops mac80211_ops = {
+	.tx = rsi_mac80211_tx,
+	.start = rsi_mac80211_start,
+	.stop = rsi_mac80211_stop,
+	.add_interface = rsi_mac80211_add_interface,
+	.remove_interface = rsi_mac80211_remove_interface,
+	.config = rsi_mac80211_config,
+	.bss_info_changed = rsi_mac80211_bss_info_changed,
+	.conf_tx = rsi_mac80211_conf_tx,
+	.configure_filter = rsi_mac80211_conf_filter,
+	.set_key = rsi_mac80211_set_key,
+	.set_rts_threshold = rsi_mac80211_set_rts_threshold,
+	.set_bitrate_mask = rsi_mac80211_set_rate_mask,
+	.ampdu_action = rsi_mac80211_ampdu_action,
+	.sta_add = rsi_mac80211_sta_add,
+	.sta_remove = rsi_mac80211_sta_remove,
+};
+
+/**
+ * This function is used to initialize Mac80211 stack.
+ *
+ * @param  common Pointer to the driver private structure.
+ * @return 0 on success, -1 on failure.
+ */
+int rsi_mac80211_attach(struct rsi_common *common)
+{
+	int status = 0;
+	struct ieee80211_hw *hw = NULL;
+	struct wiphy *wiphy = NULL;
+	struct rsi_hw *adapter = common->priv;
+	u8 addr_mask[ETH_ALEN] = {0x0, 0x0, 0x0, 0x0, 0x0, 0x3};
+	struct ieee80211_supported_band *sband = &adapter->sbands[0];
+
+	rsi_dbg(INIT_ZONE, "%s: Performing mac80211 attach\n", __func__);
+
+	hw = ieee80211_alloc_hw(sizeof(struct rsi_hw), &mac80211_ops);
+	if (!hw) {
+		rsi_dbg(ERR_ZONE, "%s: ieee80211 hw alloc failed\n", __func__);
+		return -1;
+	}
+
+	wiphy = hw->wiphy;
+
+	SET_IEEE80211_DEV(hw, adapter->device);
+
+	hw->priv = adapter;
+	adapter->hw = hw;
+
+	hw->flags = IEEE80211_HW_SIGNAL_DBM |
+		    IEEE80211_HW_HAS_RATE_CONTROL |
+		    IEEE80211_HW_AMPDU_AGGREGATION |
+		    0;
+
+	hw->queues = MAX_HW_QUEUES;
+	hw->extra_tx_headroom = RSI_NEEDED_HEADROOM;
+
+	hw->max_rates = 1;
+	hw->max_rate_tries = MAX_RETRIES;
+
+	hw->max_tx_aggregation_subframes = 6;
+	rsi_register_rates_channels(adapter, IEEE80211_BAND_2GHZ);
+	/* rsi_register_rates_channels(adapter, IEEE80211_BAND_5GHZ); */
+	hw->rate_control_algorithm = "AARF";
+
+	SET_IEEE80211_PERM_ADDR(hw, common->mac_addr);
+	ether_addr_copy(hw->wiphy->addr_mask, addr_mask);
+
+	wiphy->interface_modes = BIT(NL80211_IFTYPE_STATION);
+	wiphy->signal_type = CFG80211_SIGNAL_TYPE_MBM;
+	wiphy->retry_short = RETRY_SHORT;
+	wiphy->retry_long  = RETRY_LONG;
+	wiphy->frag_threshold = IEEE80211_MAX_FRAG_THRESHOLD;
+	wiphy->rts_threshold = IEEE80211_MAX_RTS_THRESHOLD;
+	wiphy->flags = 0;
+
+	wiphy->available_antennas_rx = 1;
+	wiphy->available_antennas_tx = 1;
+	wiphy->bands[IEEE80211_BAND_2GHZ] = &sband[IEEE80211_BAND_2GHZ];
+	/* wiphy->bands[IEEE80211_BAND_5GHZ] = &sband[IEEE80211_BAND_5GHZ]; */
+
+	status = ieee80211_register_hw(hw);
+	if (status)
+		return status;
+
+#ifdef CONFIG_RSI_DEBUGFS
+	if (rsi_init_dbgfs(adapter)) {
+		rsi_dbg(ERR_ZONE, "%s: dbgfs not created\n", __func__);
+		return -1;
+	}
+#endif
+
+	return 0;
+}
diff -rupN linux-3.14-rc5/drivers/net/wireless/rsi/rsi_91x_mgmt.c linux-3.14-rc5_new/drivers/net/wireless/rsi/rsi_91x_mgmt.c
--- linux-3.14-rc5/drivers/net/wireless/rsi/rsi_91x_mgmt.c	1970-01-01 05:30:00.000000000 +0530
+++ linux-3.14-rc5_new/drivers/net/wireless/rsi/rsi_91x_mgmt.c	2014-03-04 07:37:05.971421430 +0545
@@ -0,0 +1,561 @@
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
+#include <linux/etherdevice.h>
+#include "rsi_mgmt.h"
+#include "rsi_common.h"
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
+							 (PLL960_N_VAL_20)),
+				.pll_reg_2 = cpu_to_le16(PLL960_M_VAL_20),
+				.pll_reg_3 = 0x0,
+			},
+			.afepll_info_g = {
+				.pll_reg = cpu_to_le16(0x9f0),
+			}
+		},
+		.switch_clk_g = {
+			.switch_clk_info = cpu_to_le16(BIT(3)),
+			.bbp_lmac_clk_reg_val = cpu_to_le16(0x121),
+			.umac_clock_reg_config = 0x0,
+			.qspi_uart_clock_reg_config = 0x0
+		}
+	},
+	{
+		.pll_config_g = {
+			.tapll_info_g = {
+				.pll_reg_1 = cpu_to_le16((TA_PLL_N_VAL_20 << 8)|
+							 (TA_PLL_M_VAL_20)),
+				.pll_reg_2 = cpu_to_le16(TA_PLL_P_VAL_20),
+			},
+			.pll960_info_g = {
+				.pll_reg_1 = cpu_to_le16((PLL960_P_VAL_20 << 8)|
+							 (PLL960_N_VAL_20)),
+				.pll_reg_2 = cpu_to_le16(PLL960_M_VAL_20),
+				.pll_reg_3 = 0x0,
+			},
+			.afepll_info_g = {
+				.pll_reg = cpu_to_le16(0x9f0),
+			}
+		},
+		.switch_clk_g = {
+			.switch_clk_info = 0x0,
+			.bbp_lmac_clk_reg_val = 0x0,
+			.umac_clock_reg_config = 0x0,
+			.qspi_uart_clock_reg_config = 0x0
+		}
+	},
+	{
+		.pll_config_g = {
+			.tapll_info_g = {
+				.pll_reg_1 = cpu_to_le16((TA_PLL_N_VAL_20 << 8)|
+							 (TA_PLL_M_VAL_20)),
+				.pll_reg_2 = cpu_to_le16(TA_PLL_P_VAL_20),
+			},
+			.pll960_info_g = {
+				.pll_reg_1 = cpu_to_le16((PLL960_P_VAL_20 << 8)|
+							 (PLL960_N_VAL_20)),
+				.pll_reg_2 = cpu_to_le16(PLL960_M_VAL_20),
+				.pll_reg_3 = 0x0,
+			},
+			.afepll_info_g = {
+				.pll_reg = cpu_to_le16(0x9f0),
+			}
+		},
+		.switch_clk_g = {
+			.switch_clk_info = 0x0,
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
+	.magic_number = cpu_to_le16(0x5aa5),
+	.crystal_good_time = 0x0,
+	.valid = cpu_to_le32(VALID_40),
+	.reserved_for_valids = 0x0,
+	.bootup_mode_info = 0x0,
+	.digital_loop_back_params = 0x0,
+	.rtls_timestamp_en = 0x0,
+	.host_spi_intr_cfg = 0x0,
+	.device_clk_info = {{
+		.pll_config_g = {
+			.tapll_info_g = {
+				.pll_reg_1 = cpu_to_le16((TA_PLL_N_VAL_40 << 8)|
+							 (TA_PLL_M_VAL_40)),
+				.pll_reg_2 = cpu_to_le16(TA_PLL_P_VAL_40),
+			},
+			.pll960_info_g = {
+				.pll_reg_1 = cpu_to_le16((PLL960_P_VAL_40 << 8)|
+							 (PLL960_N_VAL_40)),
+				.pll_reg_2 = cpu_to_le16(PLL960_M_VAL_40),
+				.pll_reg_3 = 0x0,
+			},
+			.afepll_info_g = {
+				.pll_reg = cpu_to_le16(0x9f0),
+			}
+		},
+		.switch_clk_g = {
+			.switch_clk_info = cpu_to_le16(0x09),
+			.bbp_lmac_clk_reg_val = cpu_to_le16(0x1121),
+			.umac_clock_reg_config = cpu_to_le16(0x48),
+			.qspi_uart_clock_reg_config = 0x0
+		}
+	},
+	{
+		.pll_config_g = {
+			.tapll_info_g = {
+				.pll_reg_1 = cpu_to_le16((TA_PLL_N_VAL_40 << 8)|
+							 (TA_PLL_M_VAL_40)),
+				.pll_reg_2 = cpu_to_le16(TA_PLL_P_VAL_40),
+			},
+			.pll960_info_g = {
+				.pll_reg_1 = cpu_to_le16((PLL960_P_VAL_40 << 8)|
+							 (PLL960_N_VAL_40)),
+				.pll_reg_2 = cpu_to_le16(PLL960_M_VAL_40),
+				.pll_reg_3 = 0x0,
+			},
+			.afepll_info_g = {
+				.pll_reg = cpu_to_le16(0x9f0),
+			}
+		},
+		.switch_clk_g = {
+			.switch_clk_info = 0x0,
+			.bbp_lmac_clk_reg_val = 0x0,
+			.umac_clock_reg_config = 0x0,
+			.qspi_uart_clock_reg_config = 0x0
+		}
+	},
+	{
+		.pll_config_g = {
+			.tapll_info_g = {
+				.pll_reg_1 = cpu_to_le16((TA_PLL_N_VAL_40 << 8)|
+							 (TA_PLL_M_VAL_40)),
+				.pll_reg_2 = cpu_to_le16(TA_PLL_P_VAL_40),
+			},
+			.pll960_info_g = {
+				.pll_reg_1 = cpu_to_le16((PLL960_P_VAL_40 << 8)|
+							 (PLL960_N_VAL_40)),
+				.pll_reg_2 = cpu_to_le16(PLL960_M_VAL_40),
+				.pll_reg_3 = 0x0,
+			},
+			.afepll_info_g = {
+				.pll_reg = cpu_to_le16(0x9f0),
+			}
+		},
+		.switch_clk_g = {
+			.switch_clk_info = 0x0,
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
+static u16 mcs[] = {13, 26, 39, 52, 78, 104, 117, 130};
+
+/**
+ * This function sets default parameters.
+ *
+ * @param  common Pointer to the driver private structure.
+ * @return none
+ */
+static void rsi_set_default_parameters(struct rsi_common *common)
+{
+	common->band = IEEE80211_BAND_2GHZ;
+	common->channel_width = BW_20MHZ;
+	common->rts_threshold = IEEE80211_MAX_RTS_THRESHOLD;
+	common->channel = 1;
+	common->min_rate = 0xffff;
+	common->fsm_state = FSM_CARD_NOT_READY;
+	common->iface_down = true;
+	return;
+}
+
+/**
+ * This function sets the contention values for the backoff procedure.
+ *
+ * @param  common Pointer to the driver common structure.
+ * @return None.
+ */
+static void rsi_set_contention_vals(struct rsi_common *common)
+{
+	u8 ii = 0;
+
+	for (; ii < NUM_EDCA_QUEUES; ii++) {
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
+ * This function sends management frames to firmware.
+ * Also schedules packet to queue for transmission.
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
+	rsi_set_event(&common->tx_thread.event);
+	return 0;
+}
+
+/**
+ * This function is used to send radio capabilities values to firmware.
+ *
+ * @param  common Pointer to the driver private structure.
+ * @return 0 on success, corresponding negative error code on failure.
+ */
+static int rsi_load_radio_caps(struct rsi_common *common)
+{
+	struct rsi_radio_caps *radio_caps;
+	struct rsi_hw *adapter = common->priv;
+	struct ieee80211_hw *hw = adapter->hw;
+	u16 inx = 0;
+	u8 ii;
+	u8 radio_id = 0;
+	u16 gc[20] = {0xf0, 0xf0, 0xf0, 0xf0,
+		      0xf0, 0xf0, 0xf0, 0xf0,
+		      0xf0, 0xf0, 0xf0, 0xf0,
+		      0xf0, 0xf0, 0xf0, 0xf0,
+		      0xf0, 0xf0, 0xf0, 0xf0};
+	struct ieee80211_conf *conf = &hw->conf;
+	struct sk_buff *skb;
+
+	rsi_dbg(INFO_ZONE, "%s: Sending rate symbol req frame\n", __func__);
+
+	skb = dev_alloc_skb(sizeof(struct rsi_radio_caps));
+
+	if (!skb) {
+		rsi_dbg(ERR_ZONE, "%s: Failed in allocation of skb\n",
+			__func__);
+		return -1;
+	}
+
+	memset(skb->data, 0, sizeof(struct rsi_radio_caps));
+	radio_caps = (struct rsi_radio_caps *)skb->data;
+
+	radio_caps->desc_word[1] = cpu_to_le16(RADIO_CAPABILITIES);
+	radio_caps->desc_word[4] = cpu_to_le16(RSI_RF_TYPE << 8);
+
+	if (common->channel_width == BW_40MHZ) {
+		radio_caps->desc_word[7] |= cpu_to_le16(RSI_LMAC_CLOCK_80MHZ);
+		radio_caps->desc_word[7] |= cpu_to_le16(RSI_ENABLE_40MHZ);
+		if (common->channel_width) {
+			radio_caps->desc_word[5] =
+				cpu_to_le16(common->channel_width << 12);
+			radio_caps->desc_word[5] |= cpu_to_le16(FULL40M_ENABLE);
+		}
+
+		if (conf_is_ht40_minus(conf)) {
+			radio_caps->desc_word[5] = 0;
+			radio_caps->desc_word[5] |=
+				cpu_to_le16(LOWER_20_ENABLE);
+			radio_caps->desc_word[5] |=
+				cpu_to_le16(LOWER_20_ENABLE >> 12);
+		}
+
+		if (conf_is_ht40_plus(conf)) {
+			radio_caps->desc_word[5] = 0;
+			radio_caps->desc_word[5] |=
+				cpu_to_le16(UPPER_20_ENABLE);
+			radio_caps->desc_word[5] |=
+				cpu_to_le16(UPPER_20_ENABLE >> 12);
+		}
+	}
+
+	radio_caps->desc_word[7] |= cpu_to_le16(radio_id << 8);
+
+	for (ii = 0; ii < MAX_HW_QUEUES; ii++) {
+		radio_caps->qos_params[ii].cont_win_min_q = cpu_to_le16(3);
+		radio_caps->qos_params[ii].cont_win_max_q = cpu_to_le16(0x3f);
+		radio_caps->qos_params[ii].aifsn_val_q = cpu_to_le16(2);
+		radio_caps->qos_params[ii].txop_q = 0;
+	}
+
+	for (ii = 0; ii < MAX_HW_QUEUES - 4; ii++) {
+		radio_caps->qos_params[ii].cont_win_min_q =
+			cpu_to_le16(common->edca_params[ii].cw_min);
+		radio_caps->qos_params[ii].cont_win_max_q =
+			cpu_to_le16(common->edca_params[ii].cw_max);
+		radio_caps->qos_params[ii].aifsn_val_q =
+			cpu_to_le16((common->edca_params[ii].aifs) << 8);
+		radio_caps->qos_params[ii].txop_q =
+			cpu_to_le16(common->edca_params[ii].txop);
+	}
+
+	memcpy(&common->rate_pwr[0], &gc[0], 40);
+	for (ii = 0; ii < 20; ii++)
+		radio_caps->gcpd_per_rate[inx++] =
+			cpu_to_le16(common->rate_pwr[ii]  & 0x00FF);
+
+	radio_caps->desc_word[0] = cpu_to_le16((sizeof(struct rsi_radio_caps) -
+						FRAME_DESC_SZ) |
+					       (RSI_WIFI_MGMT_Q << 12));
+
+
+	skb_put(skb, (sizeof(struct rsi_radio_caps)));
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
+				u8 *msg,
+				s32 msg_len,
+				u8 type)
+{
+	struct rsi_hw *adapter = common->priv;
+	struct ieee80211_tx_info *info;
+	struct skb_info *rx_params;
+	u8 pad_bytes = msg[4];
+	u8 pkt_recv;
+	struct sk_buff *skb;
+	char *buffer;
+
+	if (type == RX_DOT11_MGMT) {
+		if (!adapter->sc_nvifs)
+			return -1;
+
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
+		       (u8 *)(msg +  FRAME_DESC_SZ + pad_bytes),
+		       msg_len);
+
+		pkt_recv = buffer[0];
+
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
+ * This function sends the station notify frame to firmware.
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
+					 u8 opmode,
+					 u8 notify_event,
+					 const unsigned char *bssid,
+					 u8 qos_enable,
+					 u16 aid)
+{
+	struct sk_buff *skb = NULL;
+	struct rsi_peer_notify *peer_notify;
+	u16 vap_id = 0;
+	int status;
+
+	rsi_dbg(MGMT_TX_ZONE, "%s: Sending sta notify frame\n", __func__);
+
+	skb = dev_alloc_skb(sizeof(struct rsi_peer_notify));
+
+	if (!skb) {
+		rsi_dbg(ERR_ZONE, "%s: Failed in allocation of skb\n",
+			__func__);
+		return -1;
+	}
+
+	memset(skb->data, 0, sizeof(struct rsi_peer_notify));
+	peer_notify = (struct rsi_peer_notify *)skb->data;
+
+	peer_notify->command = cpu_to_le16(opmode << 1);
+
+	switch (notify_event) {
+	case STA_CONNECTED:
+		peer_notify->command |= cpu_to_le16(RSI_ADD_PEER);
+		break;
+	case STA_DISCONNECTED:
+		peer_notify->command |= cpu_to_le16(RSI_DELETE_PEER);
+		break;
+	default:
+		break;
+	}
+
+	peer_notify->command |= cpu_to_le16((aid & 0xfff) << 4);
+	ether_addr_copy(peer_notify->mac_addr, bssid);
+
+	peer_notify->sta_flags = cpu_to_le32((qos_enable) ? 1 : 0);
+
+	peer_notify->desc_word[0] =
+		cpu_to_le16((sizeof(struct rsi_peer_notify) - FRAME_DESC_SZ) |
+			    (RSI_WIFI_MGMT_Q << 12));
+	peer_notify->desc_word[1] = cpu_to_le16(PEER_NOTIFY);
+	peer_notify->desc_word[7] |= cpu_to_le16(vap_id << 8);
+
+	skb_put(skb, sizeof(struct rsi_peer_notify));
+
+	status = rsi_send_internal_mgmt_frame(common, skb);
+
+	if (!status && qos_enable) {
+		rsi_set_contention_vals(common);
+		status = rsi_load_radio_caps(common);
+	}
+	return status;
+}
+
+/**
+ * This function sends the ampdu indication frame to firmware.
+ *
+ * @param  common Pointer to the driver private structure.
+ * @param  tid traffic identifier.
+ * @param  ssn ssn.
+ * @param  buf_size buffer size.
+ * @param  event notification about station connection.
+ * @return 0 on success, corresponding negative error code on failure.
+ */
+int rsi_send_aggregation_params_frame(struct rsi_common *common,
+				      u16 tid,
+				      u16 ssn,
+				      u8 buf_size,
+				      u8 event)
+{
+	struct sk_buff *skb = NULL;
+	struct rsi_mac_frame *mgmt_frame;
+	u8 peer_id = 0;
+
+	skb = dev_alloc_skb(FRAME_DESC_SZ);
+
+	if (!skb) {
+		rsi_dbg(ERR_ZONE, "%s: Failed in allocation of skb\n",
+			__func__);
+		return -1;
+	}
+
+	memset(skb->data, 0, FRAME_DESC_SZ);
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
+



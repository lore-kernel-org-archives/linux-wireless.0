Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:61162 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754598Ab1BSW3G (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 19 Feb 2011 17:29:06 -0500
Date: Sat, 19 Feb 2011 16:29:02 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
To: John W Linville <linville@tuxdriver.com>
Cc: george0505@realtek.com, chaoming_li@realsil.com.cn,
	linux-wireless@vger.kernel.org
Subject: [PATCH V2 4/16] rtlwifi: Add headers for rtl8187cu
Message-ID: <4d60442e.IC3Vrj+wwNSzQR0K%Larry.Finger@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: George <george0505@realtek.com>
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Signed-off-by: George <george0505@realtek.com>
---

Index: wireless-testing/drivers/net/wireless/rtlwifi/rtl8192cu/def.h
===================================================================
--- /dev/null
+++ wireless-testing/drivers/net/wireless/rtlwifi/rtl8192cu/def.h
@@ -0,0 +1,64 @@
+/******************************************************************************
+ *
+ * Copyright(c) 2009-2010  Realtek Corporation.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of version 2 of the GNU General Public License as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License along with
+ * this program; if not, write to the Free Software Foundation, Inc.,
+ * 51 Franklin Street, Fifth Floor, Boston, MA 02110, USA
+ *
+ * The full GNU General Public License is included in this distribution in the
+ * file called LICENSE.
+ *
+ * Contact Information:
+ * wlanfae <wlanfae@realtek.com>
+ * Realtek Corporation, No. 2, Innovation Road II, Hsinchu Science Park,
+ * Hsinchu 300, Taiwan.
+ *
+ * Larry Finger <Larry.Finger@lwfinger.net>
+ *
+ *****************************************************************************/
+
+#include "../rtl8192ce/def.h"
+
+/*-------------------------------------------------------------------------
+ *	Chip specific
+ *-------------------------------------------------------------------------*/
+#define CHIP_8723			BIT(2) /* RTL8723 With BT feature */
+#define CHIP_8723_DRV_REV		BIT(3) /* RTL8723 Driver Revised */
+#define NORMAL_CHIP			BIT(4)
+#define CHIP_VENDOR_UMC			BIT(5)
+#define CHIP_VENDOR_UMC_B_CUT		BIT(6)
+
+#define IS_NORMAL_CHIP(version)		\
+	(((version) & NORMAL_CHIP) ? true : false)
+
+#define IS_8723_SERIES(version)		\
+	(((version) & CHIP_8723) ? true : false)
+
+#define IS_92C_1T2R(version)		\
+	(((version) & CHIP_92C) && ((version) & CHIP_92C_1T2R))
+
+#define IS_VENDOR_UMC(version)		\
+	(((version) & CHIP_VENDOR_UMC) ? true : false)
+
+#define IS_VENDOR_UMC_A_CUT(version)	\
+	(((version) & CHIP_VENDOR_UMC) ? (((version) & (BIT(6) | BIT(7))) ? \
+	false : true) : false)
+
+#define IS_VENDOR_8723_A_CUT(version)	\
+	(((version) & CHIP_VENDOR_UMC) ? (((version) & (BIT(6))) ? \
+	false : true) : false)
+
+#define CHIP_BONDING_92C_1T2R	0x1
+#define CHIP_BONDING_IDENTIFIER(_value)	(((_value) >> 22) & 0x3)
+
+
Index: wireless-testing/drivers/net/wireless/rtlwifi/rtl8192cu/dm.h
===================================================================
--- /dev/null
+++ wireless-testing/drivers/net/wireless/rtlwifi/rtl8192cu/dm.h
@@ -0,0 +1,33 @@
+/******************************************************************************
+ *
+ * Copyright(c) 2009-2010  Realtek Corporation.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of version 2 of the GNU General Public License as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License along with
+ * this program; if not, write to the Free Software Foundation, Inc.,
+ * 51 Franklin Street, Fifth Floor, Boston, MA 02110, USA
+ *
+ * The full GNU General Public License is included in this distribution in the
+ * file called LICENSE.
+ *
+ * Contact Information:
+ * wlanfae <wlanfae@realtek.com>
+ * Realtek Corporation, No. 2, Innovation Road II, Hsinchu Science Park,
+ * Hsinchu 300, Taiwan.
+ *
+ * Larry Finger <Larry.Finger@lwfinger.net>
+ *
+ *****************************************************************************/
+
+#include "../rtl8192ce/dm.h"
+
+void rtl92c_dm_dynamic_txpower(struct ieee80211_hw *hw);
+
Index: wireless-testing/drivers/net/wireless/rtlwifi/rtl8192cu/fw.h
===================================================================
--- /dev/null
+++ wireless-testing/drivers/net/wireless/rtlwifi/rtl8192cu/fw.h
@@ -0,0 +1,32 @@
+/******************************************************************************
+ *
+ * Copyright(c) 2009-2010  Realtek Corporation.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of version 2 of the GNU General Public License as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License along with
+ * this program; if not, write to the Free Software Foundation, Inc.,
+ * 51 Franklin Street, Fifth Floor, Boston, MA 02110, USA
+ *
+ * The full GNU General Public License is included in this distribution in the
+ * file called LICENSE.
+ *
+ * Contact Information:
+ * wlanfae <wlanfae@realtek.com>
+ * Realtek Corporation, No. 2, Innovation Road II, Hsinchu Science Park,
+ * Hsinchu 300, Taiwan.
+ *
+ * Larry Finger <Larry.Finger@lwfinger.net>
+ *
+ *****************************************************************************/
+
+#include "../rtl8192ce/fw.h"
+
+
Index: wireless-testing/drivers/net/wireless/rtlwifi/rtl8192cu/hw.h
===================================================================
--- /dev/null
+++ wireless-testing/drivers/net/wireless/rtlwifi/rtl8192cu/hw.h
@@ -0,0 +1,109 @@
+/******************************************************************************
+ *
+ * Copyright(c) 2009-2010  Realtek Corporation.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of version 2 of the GNU General Public License as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License along with
+ * this program; if not, write to the Free Software Foundation, Inc.,
+ * 51 Franklin Street, Fifth Floor, Boston, MA 02110, USA
+ *
+ * The full GNU General Public License is included in this distribution in the
+ * file called LICENSE.
+ *
+ * Contact Information:
+ * wlanfae <wlanfae@realtek.com>
+ * Realtek Corporation, No. 2, Innovation Road II, Hsinchu Science Park,
+ * Hsinchu 300, Taiwan.
+ *
+ * Larry Finger <Larry.Finger@lwfinger.net>
+ *
+ *****************************************************************************/
+
+#ifndef __RTL92CU_HW_H__
+#define __RTL92CU_HW_H__
+
+#define LLT_POLLING_LLT_THRESHOLD		20
+#define LLT_POLLING_READY_TIMEOUT_COUNT		100
+#define LLT_LAST_ENTRY_OF_TX_PKT_BUFFER		255
+
+#define RX_PAGE_SIZE_REG_VALUE			PBP_128
+/* Note: We will divide number of page equally for each queue
+ * other than public queue! */
+#define TX_TOTAL_PAGE_NUMBER			0xF8
+#define TX_PAGE_BOUNDARY			(TX_TOTAL_PAGE_NUMBER + 1)
+
+
+#define CHIP_B_PAGE_NUM_PUBQ			0xE7
+
+/* For Test Chip Setting
+ * (HPQ + LPQ + PUBQ) shall be TX_TOTAL_PAGE_NUMBER */
+#define CHIP_A_PAGE_NUM_PUBQ			0x7E
+
+
+/* For Chip A Setting */
+#define WMM_CHIP_A_TX_TOTAL_PAGE_NUMBER		0xF5
+#define WMM_CHIP_A_TX_PAGE_BOUNDARY		\
+	(WMM_CHIP_A_TX_TOTAL_PAGE_NUMBER + 1) /* F6 */
+
+#define WMM_CHIP_A_PAGE_NUM_PUBQ		0xA3
+#define WMM_CHIP_A_PAGE_NUM_HPQ			0x29
+#define WMM_CHIP_A_PAGE_NUM_LPQ			0x29
+
+
+
+/* Note: For Chip B Setting ,modify later */
+#define WMM_CHIP_B_TX_TOTAL_PAGE_NUMBER		0xF5
+#define WMM_CHIP_B_TX_PAGE_BOUNDARY		\
+	(WMM_CHIP_B_TX_TOTAL_PAGE_NUMBER + 1) /* F6 */
+
+#define WMM_CHIP_B_PAGE_NUM_PUBQ		0xB0
+#define WMM_CHIP_B_PAGE_NUM_HPQ			0x29
+#define WMM_CHIP_B_PAGE_NUM_LPQ			0x1C
+#define WMM_CHIP_B_PAGE_NUM_NPQ			0x1C
+
+#define BOARD_TYPE_NORMAL_MASK			0xE0
+#define BOARD_TYPE_TEST_MASK			0x0F
+
+/* should be renamed and moved to another file */
+enum _BOARD_TYPE_8192CUSB {
+	BOARD_USB_DONGLE		= 0,	/* USB dongle */
+	BOARD_USB_High_PA		= 1,	/* USB dongle - high power PA */
+	BOARD_MINICARD			= 2,	/* Minicard */
+	BOARD_USB_SOLO			= 3,	/* USB solo-Slim module */
+	BOARD_USB_COMBO			= 4,	/* USB Combo-Slim module */
+};
+
+#define IS_HIGHT_PA(boardtype)		\
+	((boardtype == BOARD_USB_High_PA) ? true : false)
+
+#define RTL92C_DRIVER_INFO_SIZE				4
+void rtl92cu_read_eeprom_info(struct ieee80211_hw *hw);
+void rtl92cu_enable_hw_security_config(struct ieee80211_hw *hw);
+int rtl92cu_hw_init(struct ieee80211_hw *hw);
+void rtl92cu_card_disable(struct ieee80211_hw *hw);
+int rtl92cu_set_network_type(struct ieee80211_hw *hw, enum nl80211_iftype type);
+void rtl92cu_set_beacon_related_registers(struct ieee80211_hw *hw);
+void rtl92cu_set_beacon_interval(struct ieee80211_hw *hw);
+void rtl92cu_update_interrupt_mask(struct ieee80211_hw *hw,
+				   u32 add_msr, u32 rm_msr);
+void rtl92cu_get_hw_reg(struct ieee80211_hw *hw, u8 variable, u8 *val);
+void rtl92cu_set_hw_reg(struct ieee80211_hw *hw, u8 variable, u8 *val);
+void rtl92cu_update_hal_rate_table(struct ieee80211_hw *hw);
+void rtl92cu_update_hal_rate_mask(struct ieee80211_hw *hw, u8 rssi_level);
+
+void rtl92cu_update_channel_access_setting(struct ieee80211_hw *hw);
+bool rtl92cu_gpio_radio_on_off_checking(struct ieee80211_hw *hw, u8 * valid);
+void rtl92cu_set_check_bssid(struct ieee80211_hw *hw, bool check_bssid);
+u8 _rtl92c_get_chnl_group(u8 chnl);
+
+#endif
+
+
Index: wireless-testing/drivers/net/wireless/rtlwifi/rtl8192cu/led.h
===================================================================
--- /dev/null
+++ wireless-testing/drivers/net/wireless/rtlwifi/rtl8192cu/led.h
@@ -0,0 +1,38 @@
+/******************************************************************************
+ *
+ * Copyright(c) 2009-2010  Realtek Corporation. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of version 2 of the GNU General Public License as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License along with
+ * this program; if not, write to the Free Software Foundation, Inc.,
+ * 51 Franklin Street, Fifth Floor, Boston, MA 02110, USA
+ *
+ * The full GNU General Public License is included in this distribution in the
+ * file called LICENSE.
+ *
+ * Contact Information:
+ * wlanfae <wlanfae@realtek.com>
+ * Realtek Corporation, No. 2, Innovation Road II, Hsinchu Science Park,
+ * Hsinchu 300, Taiwan.
+ *
+ *****************************************************************************/
+
+#ifndef __RTL92CU_LED_H__
+#define __RTL92CU_LED_H__
+
+void rtl92cu_init_sw_leds(struct ieee80211_hw *hw);
+void rtl92cu_deinit_sw_leds(struct ieee80211_hw *hw);
+void rtl92cu_sw_led_on(struct ieee80211_hw *hw, struct rtl_led *pled);
+void rtl92cu_sw_led_off(struct ieee80211_hw *hw, struct rtl_led *pled);
+void rtl92cu_led_control(struct ieee80211_hw *hw, enum led_ctl_mode ledaction);
+
+#endif
+
Index: wireless-testing/drivers/net/wireless/rtlwifi/rtl8192cu/mac.h
===================================================================
--- /dev/null
+++ wireless-testing/drivers/net/wireless/rtlwifi/rtl8192cu/mac.h
@@ -0,0 +1,182 @@
+/******************************************************************************
+ *
+ * Copyright(c) 2009-2010  Realtek Corporation. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of version 2 of the GNU General Public License as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License along with
+ * this program; if not, write to the Free Software Foundation, Inc.,
+ * 51 Franklin Street, Fifth Floor, Boston, MA 02110, USA
+ *
+ * The full GNU General Public License is included in this distribution in the
+ * file called LICENSE.
+ *
+ * Contact Information:
+ * wlanfae <wlanfae@realtek.com>
+ * Realtek Corporation, No. 2, Innovation Road II, Hsinchu Science Park,
+ * Hsinchu 300, Taiwan.
+ *
+ * Larry Finger <Larry.Finger@lwfinger.net>
+ *
+ *****************************************************************************/
+
+#ifndef __RTL92C_MAC_H__
+#define __RTL92C_MAC_H__
+
+#define LLT_LAST_ENTRY_OF_TX_PKT_BUFFER		255
+#define DRIVER_EARLY_INT_TIME					0x05
+#define BCN_DMA_ATIME_INT_TIME				0x02
+
+void rtl92c_read_chip_version(struct ieee80211_hw *hw);
+bool rtl92c_llt_write(struct ieee80211_hw *hw, u32 address, u32 data);
+bool rtl92c_init_llt_table(struct ieee80211_hw *hw, u32 boundary);
+void rtl92c_set_key(struct ieee80211_hw *hw, u32 key_index,
+		     u8 *p_macaddr, bool is_group, u8 enc_algo,
+		     bool is_wepkey, bool clear_all);
+void rtl92c_enable_interrupt(struct ieee80211_hw *hw);
+void rtl92c_disable_interrupt(struct ieee80211_hw *hw);
+void rtl92c_set_qos(struct ieee80211_hw *hw, int aci);
+
+
+/*---------------------------------------------------------------
+ *	Hardware init functions
+ *---------------------------------------------------------------*/
+void rtl92c_set_mac_addr(struct ieee80211_hw *hw, const u8 *addr);
+void rtl92c_init_interrupt(struct ieee80211_hw *hw);
+void rtl92c_init_driver_info_size(struct ieee80211_hw *hw, u8 size);
+
+int rtl92c_set_network_type(struct ieee80211_hw *hw, enum nl80211_iftype type);
+void rtl92c_init_network_type(struct ieee80211_hw *hw);
+void rtl92c_init_adaptive_ctrl(struct ieee80211_hw *hw);
+void rtl92c_init_rate_fallback(struct ieee80211_hw *hw);
+
+void rtl92c_init_edca_param(struct ieee80211_hw *hw,
+							u16 queue,
+							u16 txop,
+							u8 ecwmax,
+							u8 ecwmin,
+							u8 aifs);
+
+void rtl92c_init_edca(struct ieee80211_hw *hw);
+void rtl92c_init_ampdu_aggregation(struct ieee80211_hw *hw);
+void rtl92c_init_beacon_max_error(struct ieee80211_hw *hw, bool infra_mode);
+void rtl92c_init_rdg_setting(struct ieee80211_hw *hw);
+void rtl92c_init_retry_function(struct ieee80211_hw *hw);
+
+void rtl92c_init_beacon_parameters(struct ieee80211_hw *hw,
+				   enum version_8192c version);
+
+void rtl92c_disable_fast_edca(struct ieee80211_hw *hw);
+void rtl92c_set_min_space(struct ieee80211_hw *hw, bool is2T);
+
+/* For filter */
+u16 rtl92c_get_mgt_filter(struct ieee80211_hw *hw);
+void rtl92c_set_mgt_filter(struct ieee80211_hw *hw, u16 filter);
+u16 rtl92c_get_ctrl_filter(struct ieee80211_hw *hw);
+void rtl92c_set_ctrl_filter(struct ieee80211_hw *hw, u16 filter);
+u16 rtl92c_get_data_filter(struct ieee80211_hw *hw);
+void rtl92c_set_data_filter(struct ieee80211_hw *hw, u16 filter);
+
+
+u32 rtl92c_get_txdma_status(struct ieee80211_hw *hw);
+
+#define RX_HAL_IS_CCK_RATE(_pdesc)\
+	(GET_RX_DESC_RX_MCS(_pdesc) == DESC92C_RATE1M ||\
+	 GET_RX_DESC_RX_MCS(_pdesc) == DESC92C_RATE2M ||\
+	 GET_RX_DESC_RX_MCS(_pdesc) == DESC92C_RATE5_5M ||\
+	 GET_RX_DESC_RX_MCS(_pdesc) == DESC92C_RATE11M)
+
+struct rx_fwinfo_92c {
+	u8 gain_trsw[4];
+	u8 pwdb_all;
+	u8 cfosho[4];
+	u8 cfotail[4];
+	char rxevm[2];
+	char rxsnr[4];
+	u8 pdsnr[2];
+	u8 csi_current[2];
+	u8 csi_target[2];
+	u8 sigevm;
+	u8 max_ex_pwr;
+	u8 ex_intf_flag:1;
+	u8 sgi_en:1;
+	u8 rxsc:2;
+	u8 reserve:4;
+} __packed;
+
+struct rx_desc_92c {
+	u32 length:14;
+	u32 crc32:1;
+	u32 icverror:1;
+	u32 drv_infosize:4;
+	u32 security:3;
+	u32 qos:1;
+	u32 shift:2;
+	u32 phystatus:1;
+	u32 swdec:1;
+	u32 lastseg:1;
+	u32 firstseg:1;
+	u32 eor:1;
+	u32 own:1;
+	u32 macid:5;	/* word 1 */
+	u32 tid:4;
+	u32 hwrsvd:5;
+	u32 paggr:1;
+	u32 faggr:1;
+	u32 a1_fit:4;
+	u32 a2_fit:4;
+	u32 pam:1;
+	u32 pwr:1;
+	u32 moredata:1;
+	u32 morefrag:1;
+	u32 type:2;
+	u32 mc:1;
+	u32 bc:1;
+	u32 seq:12;	/* word 2 */
+	u32 frag:4;
+	u32 nextpktlen:14;
+	u32 nextind:1;
+	u32 rsvd:1;
+	u32 rxmcs:6;	/* word 3 */
+	u32 rxht:1;
+	u32 amsdu:1;
+	u32 splcp:1;
+	u32 bandwidth:1;
+	u32 htc:1;
+	u32 tcpchk_rpt:1;
+	u32 ipcchk_rpt:1;
+	u32 tcpchk_valid:1;
+	u32 hwpcerr:1;
+	u32 hwpcind:1;
+	u32 iv0:16;
+	u32 iv1;	/* word 4 */
+	u32 tsfl;	/* word 5 */
+	u32 bufferaddress;	/* word 6 */
+	u32 bufferaddress64;	/* word 7 */
+} __packed;
+
+enum rtl_desc_qsel rtl92c_map_hwqueue_to_fwqueue(u16 fc,
+							  unsigned int
+							  skb_queue);
+void rtl92c_translate_rx_signal_stuff(struct ieee80211_hw *hw,
+				      struct sk_buff *skb,
+				      struct rtl_stats *pstats,
+				      struct rx_desc_92c *pdesc,
+				      struct rx_fwinfo_92c *p_drvinfo);
+
+/*---------------------------------------------------------------
+ *	Card disable functions
+ *---------------------------------------------------------------*/
+
+
+
+#endif
+
+
Index: wireless-testing/drivers/net/wireless/rtlwifi/rtl8192cu/phy.h
===================================================================
--- /dev/null
+++ wireless-testing/drivers/net/wireless/rtlwifi/rtl8192cu/phy.h
@@ -0,0 +1,35 @@
+/******************************************************************************
+ *
+ * Copyright(c) 2009-2010  Realtek Corporation.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of version 2 of the GNU General Public License as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License along with
+ * this program; if not, write to the Free Software Foundation, Inc.,
+ * 51 Franklin Street, Fifth Floor, Boston, MA 02110, USA
+ *
+ * The full GNU General Public License is included in this distribution in the
+ * file called LICENSE.
+ *
+ * Contact Information:
+ * wlanfae <wlanfae@realtek.com>
+ * Realtek Corporation, No. 2, Innovation Road II, Hsinchu Science Park,
+ * Hsinchu 300, Taiwan.
+ *
+ * Larry Finger <Larry.Finger@lwfinger.net>
+ *
+ *****************************************************************************/
+
+#include "../rtl8192ce/phy.h"
+
+void rtl92c_bb_block_on(struct ieee80211_hw *hw);
+bool rtl8192_phy_check_is_legal_rfpath(struct ieee80211_hw *hw, u32 rfpath);
+void rtl92c_phy_set_io(struct ieee80211_hw *hw);
+
Index: wireless-testing/drivers/net/wireless/rtlwifi/rtl8192cu/reg.h
===================================================================
--- /dev/null
+++ wireless-testing/drivers/net/wireless/rtlwifi/rtl8192cu/reg.h
@@ -0,0 +1,32 @@
+/******************************************************************************
+ *
+ * Copyright(c) 2009-2010  Realtek Corporation.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of version 2 of the GNU General Public License as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License along with
+ * this program; if not, write to the Free Software Foundation, Inc.,
+ * 51 Franklin Street, Fifth Floor, Boston, MA 02110, USA
+ *
+ * The full GNU General Public License is included in this distribution in the
+ * file called LICENSE.
+ *
+ * Contact Information:
+ * wlanfae <wlanfae@realtek.com>
+ * Realtek Corporation, No. 2, Innovation Road II, Hsinchu Science Park,
+ * Hsinchu 300, Taiwan.
+ *
+ * Larry Finger <Larry.Finger@lwfinger.net>
+ *
+ *****************************************************************************/
+
+#include "../rtl8192ce/reg.h"
+
+
Index: wireless-testing/drivers/net/wireless/rtlwifi/rtl8192cu/rf.h
===================================================================
--- /dev/null
+++ wireless-testing/drivers/net/wireless/rtlwifi/rtl8192cu/rf.h
@@ -0,0 +1,32 @@
+/******************************************************************************
+ *
+ * Copyright(c) 2009-2010  Realtek Corporation.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of version 2 of the GNU General Public License as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License along with
+ * this program; if not, write to the Free Software Foundation, Inc.,
+ * 51 Franklin Street, Fifth Floor, Boston, MA 02110, USA
+ *
+ * The full GNU General Public License is included in this distribution in the
+ * file called LICENSE.
+ *
+ * Contact Information:
+ * wlanfae <wlanfae@realtek.com>
+ * Realtek Corporation, No. 2, Innovation Road II, Hsinchu Science Park,
+ * Hsinchu 300, Taiwan.
+ *
+ * Larry Finger <Larry.Finger@lwfinger.net>
+ *
+ *****************************************************************************/
+
+#include "../rtl8192ce/rf.h"
+
+
Index: wireless-testing/drivers/net/wireless/rtlwifi/rtl8192cu/sw.h
===================================================================
--- /dev/null
+++ wireless-testing/drivers/net/wireless/rtlwifi/rtl8192cu/sw.h
@@ -0,0 +1,38 @@
+/******************************************************************************
+ *
+ * Copyright(c) 2009-2010  Realtek Corporation. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of version 2 of the GNU General Public License as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License along with
+ * this program; if not, write to the Free Software Foundation, Inc.,
+ * 51 Franklin Street, Fifth Floor, Boston, MA 02110, USA
+ *
+ * The full GNU General Public License is included in this distribution in the
+ * file called LICENSE.
+ *
+ * Contact Information:
+ * wlanfae <wlanfae@realtek.com>
+ * Realtek Corporation, No. 2, Innovation Road II, Hsinchu Science Park,
+ * Hsinchu 300, Taiwan.
+ *
+ * Larry Finger <Larry.Finger@lwfinger.net>
+ *
+ *****************************************************************************/
+
+#ifndef __RTL92CU_SW_H__
+#define __RTL92CU_SW_H__
+
+#define EFUSE_MAX_SECTION	16
+
+#endif
+
+
+
Index: wireless-testing/drivers/net/wireless/rtlwifi/rtl8192cu/table.h
===================================================================
--- /dev/null
+++ wireless-testing/drivers/net/wireless/rtlwifi/rtl8192cu/table.h
@@ -0,0 +1,73 @@
+/******************************************************************************
+ *
+ * Copyright(c) 2009-2010  Realtek Corporation. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of version 2 of the GNU General Public License as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License along with
+ * this program; if not, write to the Free Software Foundation, Inc.,
+ * 51 Franklin Street, Fifth Floor, Boston, MA 02110, USA
+ *
+ * The full GNU General Public License is included in this distribution in the
+ * file called LICENSE.
+ *
+ * Contact Information:
+ * wlanfae <wlanfae@realtek.com>
+ * Realtek Corporation, No. 2, Innovation Road II, Hsinchu Science Park,
+ * Hsinchu 300, Taiwan.
+ *
+ * Larry Finger <Larry.Finger@lwfinger.net>
+ *
+ *****************************************************************************/
+
+#ifndef __RTL92CU_TABLE__H_
+#define __RTL92CU_TABLE__H_
+
+#include <linux/types.h>
+
+#define RTL8192CUPHY_REG_2TARRAY_LENGTH		374
+extern u32 RTL8192CUPHY_REG_2TARRAY[RTL8192CUPHY_REG_2TARRAY_LENGTH];
+#define RTL8192CUPHY_REG_1TARRAY_LENGTH		374
+extern u32 RTL8192CUPHY_REG_1TARRAY[RTL8192CUPHY_REG_1TARRAY_LENGTH];
+
+#define RTL8192CUPHY_REG_ARRAY_PGLENGTH		336
+extern u32 RTL8192CUPHY_REG_ARRAY_PG[RTL8192CUPHY_REG_ARRAY_PGLENGTH];
+
+#define RTL8192CURADIOA_2TARRAYLENGTH	282
+extern u32 RTL8192CURADIOA_2TARRAY[RTL8192CURADIOA_2TARRAYLENGTH];
+#define RTL8192CURADIOB_2TARRAYLENGTH	78
+extern u32 RTL8192CU_RADIOB_2TARRAY[RTL8192CURADIOB_2TARRAYLENGTH];
+#define RTL8192CURADIOA_1TARRAYLENGTH	282
+extern u32 RTL8192CU_RADIOA_1TARRAY[RTL8192CURADIOA_1TARRAYLENGTH];
+#define RTL8192CURADIOB_1TARRAYLENGTH	1
+extern u32 RTL8192CU_RADIOB_1TARRAY[RTL8192CURADIOB_1TARRAYLENGTH];
+
+#define RTL8192CUMAC_2T_ARRAYLENGTH		172
+extern u32 RTL8192CUMAC_2T_ARRAY[RTL8192CUMAC_2T_ARRAYLENGTH];
+
+#define RTL8192CUAGCTAB_2TARRAYLENGTH	320
+extern u32 RTL8192CUAGCTAB_2TARRAY[RTL8192CUAGCTAB_2TARRAYLENGTH];
+#define RTL8192CUAGCTAB_1TARRAYLENGTH	320
+extern u32 RTL8192CUAGCTAB_1TARRAY[RTL8192CUAGCTAB_1TARRAYLENGTH];
+
+#define RTL8192CUPHY_REG_1T_HPArrayLength 378
+extern u32 RTL8192CUPHY_REG_1T_HPArray[RTL8192CUPHY_REG_1T_HPArrayLength];
+
+#define RTL8192CUPHY_REG_Array_PG_HPLength 336
+extern u32 RTL8192CUPHY_REG_Array_PG_HP[RTL8192CUPHY_REG_Array_PG_HPLength];
+
+#define RTL8192CURadioA_1T_HPArrayLength 282
+extern u32 RTL8192CURadioA_1T_HPArray[RTL8192CURadioA_1T_HPArrayLength];
+#define RTL8192CUAGCTAB_1T_HPArrayLength 320
+extern u32 Rtl8192CUAGCTAB_1T_HPArray[RTL8192CUAGCTAB_1T_HPArrayLength];
+
+#endif
+
+
Index: wireless-testing/drivers/net/wireless/rtlwifi/rtl8192cu/trx.h
===================================================================
--- /dev/null
+++ wireless-testing/drivers/net/wireless/rtlwifi/rtl8192cu/trx.h
@@ -0,0 +1,432 @@
+/******************************************************************************
+ *
+ * Copyright(c) 2009-2010  Realtek Corporation. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of version 2 of the GNU General Public License as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License along with
+ * this program; if not, write to the Free Software Foundation, Inc.,
+ * 51 Franklin Street, Fifth Floor, Boston, MA 02110, USA
+ *
+ * The full GNU General Public License is included in this distribution in the
+ * file called LICENSE.
+ *
+ * Contact Information:
+ * wlanfae <wlanfae@realtek.com>
+ * Realtek Corporation, No. 2, Innovation Road II, Hsinchu Science Park,
+ * Hsinchu 300, Taiwan.
+ *
+ * Larry Finger <Larry.Finger@lwfinger.net>
+ *
+ *****************************************************************************/
+
+#ifndef __RTL92CU_TRX_H__
+#define __RTL92CU_TRX_H__
+
+#define RTL92C_USB_BULK_IN_NUM			1
+#define RTL92C_NUM_RX_URBS			8
+#define RTL92C_NUM_TX_URBS			32
+
+#define RTL92C_SIZE_MAX_RX_BUFFER		15360   /* 8192 */
+#define RX_DRV_INFO_SIZE_UNIT			8
+
+enum usb_rx_agg_mode {
+	USB_RX_AGG_DISABLE,
+	USB_RX_AGG_DMA,
+	USB_RX_AGG_USB,
+	USB_RX_AGG_DMA_USB
+};
+
+#define TX_SELE_HQ				BIT(0)	/* High Queue */
+#define TX_SELE_LQ				BIT(1)	/* Low Queue */
+#define TX_SELE_NQ				BIT(2)	/* Normal Queue */
+
+#define RTL_USB_TX_AGG_NUM_DESC			5
+
+#define RTL_USB_RX_AGG_PAGE_NUM			4
+#define RTL_USB_RX_AGG_PAGE_TIMEOUT		3
+
+#define RTL_USB_RX_AGG_BLOCK_NUM		5
+#define RTL_USB_RX_AGG_BLOCK_TIMEOUT		3
+
+/*======================== rx status =========================================*/
+
+struct rx_drv_info_92c {
+	/*
+	 * Driver info contain PHY status and other variabel size info
+	 * PHY Status content as below
+	 */
+
+	/* DWORD 0 */
+	u8 gain_trsw[4];
+
+	/* DWORD 1 */
+	u8 pwdb_all;
+	u8 cfosho[4];
+
+	/* DWORD 2 */
+	u8 cfotail[4];
+
+	/* DWORD 3 */
+	s8 rxevm[2];
+	s8 rxsnr[4];
+
+	/* DWORD 4 */
+	u8 pdsnr[2];
+
+	/* DWORD 5 */
+	u8 csi_current[2];
+	u8 csi_target[2];
+
+	/* DWORD 6 */
+	u8 sigevm;
+	u8 max_ex_pwr;
+	u8 ex_intf_flag:1;
+	u8 sgi_en:1;
+	u8 rxsc:2;
+	u8 reserve:4;
+} __packed;
+
+/* Define a macro that takes a le32 word, converts it to host ordering,
+ * right shifts by a specified count, creates a mask of the specified
+ * bit count, and extracts that number of bits.
+ */
+
+#define SHIFT_AND_MASK_LE(__pdesc, __shift, __bits)		\
+	((le32_to_cpu(*(((__le32 *)(__pdesc)))) >> (__shift)) &	\
+	BIT_LEN_MASK_32(__bits))
+
+/* Define a macro that clears a bit field in an le32 word and
+ * sets the specified value into that bit field. The resulting
+ * value remains in le32 ordering; however, it is properly converted
+ * to host ordering for the clear and set operations before conversion
+ * back to le32.
+ */
+
+#define SET_BITS_OFFSET_LE(__pdesc, __shift, __len, __val)	\
+	(*(__le32 *)(__pdesc) = 				\
+	(cpu_to_le32((le32_to_cpu(*((__le32 *)(__pdesc))) &	\
+	(~(BIT_OFFSET_LEN_MASK_32((__shift), __len)))) |		\
+	(((u32)(__val) & BIT_LEN_MASK_32(__len)) << (__shift)))));
+
+/* macros to read various fields in RX descriptor */
+
+/* DWORD 0 */
+#define GET_RX_DESC_PKT_LEN(__rxdesc)		\
+	SHIFT_AND_MASK_LE((__rxdesc), 0, 14)
+#define GET_RX_DESC_CRC32(__rxdesc)		\
+	SHIFT_AND_MASK_LE(__rxdesc, 14, 1)
+#define GET_RX_DESC_ICV(__rxdesc)		\
+	SHIFT_AND_MASK_LE(__rxdesc, 15, 1)
+#define GET_RX_DESC_DRVINFO_SIZE(__rxdesc)	\
+	SHIFT_AND_MASK_LE(__rxdesc, 16, 4)
+#define GET_RX_DESC_SECURITY(__rxdesc)		\
+	SHIFT_AND_MASK_LE(__rxdesc, 20, 3)
+#define GET_RX_DESC_QOS(__rxdesc)		\
+	SHIFT_AND_MASK_LE(__rxdesc, 23, 1)
+#define GET_RX_DESC_SHIFT(__rxdesc)		\
+	SHIFT_AND_MASK_LE(__rxdesc, 24, 2)
+#define GET_RX_DESC_PHY_STATUS(__rxdesc)	\
+	SHIFT_AND_MASK_LE(__rxdesc, 26, 1)
+#define GET_RX_DESC_SWDEC(__rxdesc)		\
+	SHIFT_AND_MASK_LE(__rxdesc, 27, 1)
+#define GET_RX_DESC_LAST_SEG(__rxdesc)		\
+	SHIFT_AND_MASK_LE(__rxdesc, 28, 1)
+#define GET_RX_DESC_FIRST_SEG(__rxdesc)		\
+	SHIFT_AND_MASK_LE(__rxdesc, 29, 1)
+#define GET_RX_DESC_EOR(__rxdesc)		\
+	SHIFT_AND_MASK_LE(__rxdesc, 30, 1)
+#define GET_RX_DESC_OWN(__rxdesc)		\
+	SHIFT_AND_MASK_LE(__rxdesc, 31, 1)
+
+/* DWORD 1 */
+#define GET_RX_DESC_MACID(__rxdesc)		\
+	SHIFT_AND_MASK_LE(__rxdesc+4, 0, 5)
+#define GET_RX_DESC_TID(__rxdesc)		\
+	SHIFT_AND_MASK_LE(__rxdesc+4, 5, 4)
+#define GET_RX_DESC_PAGGR(__rxdesc)		\
+	SHIFT_AND_MASK_LE(__rxdesc+4, 14, 1)
+#define GET_RX_DESC_FAGGR(__rxdesc)		\
+	SHIFT_AND_MASK_LE(__rxdesc+4, 15, 1)
+#define GET_RX_DESC_A1_FIT(__rxdesc)		\
+	SHIFT_AND_MASK_LE(__rxdesc+4, 16, 4)
+#define GET_RX_DESC_A2_FIT(__rxdesc)		\
+	SHIFT_AND_MASK_LE(__rxdesc+4, 20, 4)
+#define GET_RX_DESC_PAM(__rxdesc)		\
+	SHIFT_AND_MASK_LE(__rxdesc+4, 24, 1)
+#define GET_RX_DESC_PWR(__rxdesc)		\
+	SHIFT_AND_MASK_LE(__rxdesc+4, 25, 1)
+#define GET_RX_DESC_MORE_DATA(__rxdesc)		\
+	SHIFT_AND_MASK_LE(__rxdesc+4, 26, 1)
+#define GET_RX_DESC_MORE_FRAG(__rxdesc)		\
+	SHIFT_AND_MASK_LE(__rxdesc+4, 27, 1)
+#define GET_RX_DESC_TYPE(__rxdesc)		\
+	SHIFT_AND_MASK_LE(__rxdesc+4, 28, 2)
+#define GET_RX_DESC_MC(__rxdesc)		\
+	SHIFT_AND_MASK_LE(__rxdesc+4, 30, 1)
+#define GET_RX_DESC_BC(__rxdesc)		\
+	SHIFT_AND_MASK_LE(__rxdesc+4, 31, 1)
+
+/* DWORD 2 */
+#define GET_RX_DESC_SEQ(__rxdesc)		\
+	SHIFT_AND_MASK_LE(__rxdesc+8, 0, 12)
+#define GET_RX_DESC_FRAG(__rxdesc)		\
+	SHIFT_AND_MASK_LE(__rxdesc+8, 12, 4)
+#define GET_RX_DESC_USB_AGG_PKTNUM(__rxdesc)	\
+	SHIFT_AND_MASK_LE(__rxdesc+8, 16, 8)
+#define GET_RX_DESC_NEXT_IND(__rxdesc)		\
+	SHIFT_AND_MASK_LE(__rxdesc+8, 30, 1)
+
+/* DWORD 3 */
+#define GET_RX_DESC_RX_MCS(__rxdesc)		\
+	SHIFT_AND_MASK_LE(__rxdesc+12, 0, 6)
+#define GET_RX_DESC_RX_HT(__rxdesc)		\
+	SHIFT_AND_MASK_LE(__rxdesc+12, 6, 1)
+#define GET_RX_DESC_AMSDU(__rxdesc)		\
+	SHIFT_AND_MASK_LE(__rxdesc+12, 7, 1)
+#define GET_RX_DESC_SPLCP(__rxdesc)		\
+	SHIFT_AND_MASK_LE(__rxdesc+12, 8, 1)
+#define GET_RX_DESC_BW(__rxdesc)		\
+	SHIFT_AND_MASK_LE(__rxdesc+12, 9, 1)
+#define GET_RX_DESC_HTC(__rxdesc)		\
+	SHIFT_AND_MASK_LE(__rxdesc+12, 10, 1)
+#define GET_RX_DESC_TCP_CHK_RPT(__rxdesc)	\
+	SHIFT_AND_MASK_LE(__rxdesc+12, 11, 1)
+#define GET_RX_DESC_IP_CHK_RPT(__rxdesc)	\
+	SHIFT_AND_MASK_LE(__rxdesc+12, 12, 1)
+#define GET_RX_DESC_TCP_CHK_VALID(__rxdesc)	\
+	SHIFT_AND_MASK_LE(__rxdesc+12, 13, 1)
+#define GET_RX_DESC_HWPC_ERR(__rxdesc)		\
+	SHIFT_AND_MASK_LE(__rxdesc+12, 14, 1)
+#define GET_RX_DESC_HWPC_IND(__rxdesc)		\
+	SHIFT_AND_MASK_LE(__rxdesc+12, 15, 1)
+#define GET_RX_DESC_IV0(__rxdesc)		\
+	SHIFT_AND_MASK_LE(__rxdesc+12, 16, 16)
+
+/* DWORD 4 */
+#define GET_RX_DESC_IV1(__rxdesc)		\
+	SHIFT_AND_MASK_LE(__rxdesc+16, 0, 32)
+
+/* DWORD 5 */
+#define GET_RX_DESC_TSFL(__rxdesc)		\
+	SHIFT_AND_MASK_LE(__rxdesc+20, 0, 32)
+
+/*======================= tx desc ============================================*/
+
+/* macros to set various fields in TX descriptor */
+
+/* Dword 0 */
+#define SET_TX_DESC_PKT_SIZE(__txdesc, __value)		\
+	SET_BITS_OFFSET_LE(__txdesc, 0, 16, __value)
+#define SET_TX_DESC_OFFSET(__txdesc, __value)		\
+	SET_BITS_OFFSET_LE(__txdesc, 16, 8, __value)
+#define SET_TX_DESC_BMC(__txdesc, __value)		\
+	SET_BITS_OFFSET_LE(__txdesc, 24, 1, __value)
+#define SET_TX_DESC_HTC(__txdesc, __value)		\
+	SET_BITS_OFFSET_LE(__txdesc, 25, 1, __value)
+#define SET_TX_DESC_LAST_SEG(__txdesc, __value)		\
+	SET_BITS_OFFSET_LE(__txdesc, 26, 1, __value)
+#define SET_TX_DESC_FIRST_SEG(__txdesc, __value)	\
+	 SET_BITS_OFFSET_LE(__txdesc, 27, 1, __value)
+#define SET_TX_DESC_LINIP(__txdesc, __value)		\
+	SET_BITS_OFFSET_LE(__txdesc, 28, 1, __value)
+#define SET_TX_DESC_NO_ACM(__txdesc, __value)		\
+	SET_BITS_OFFSET_LE(__txdesc, 29, 1, __value)
+#define SET_TX_DESC_GF(__txdesc, __value)		\
+	SET_BITS_OFFSET_LE(__txdesc, 30, 1, __value)
+#define SET_TX_DESC_OWN(__txdesc, __value)		\
+	SET_BITS_OFFSET_LE(__txdesc, 31, 1, __value)
+
+
+/* Dword 1 */
+#define SET_TX_DESC_MACID(__txdesc, __value)		\
+	SET_BITS_OFFSET_LE(__txdesc+4, 0, 5, __value)
+#define SET_TX_DESC_AGG_ENABLE(__txdesc, __value)	\
+	SET_BITS_OFFSET_LE(__txdesc+4, 5, 1, __value)
+#define SET_TX_DESC_AGG_BREAK(__txdesc, __value)	\
+	SET_BITS_OFFSET_LE(__txdesc+4, 6, 1, __value)
+#define SET_TX_DESC_RDG_ENABLE(__txdesc, __value)	\
+	SET_BITS_OFFSET_LE(__txdesc+4, 7, 1, __value)
+#define SET_TX_DESC_QUEUE_SEL(__txdesc, __value)	\
+	SET_BITS_OFFSET_LE(__txdesc+4, 8, 5, __value)
+#define SET_TX_DESC_RDG_NAV_EXT(__txdesc, __value)	\
+	SET_BITS_OFFSET_LE(__txdesc+4, 13, 1, __value)
+#define SET_TX_DESC_LSIG_TXOP_EN(__txdesc, __value)	\
+	SET_BITS_OFFSET_LE(__txdesc+4, 14, 1, __value)
+#define SET_TX_DESC_PIFS(__txdesc, __value)		\
+	SET_BITS_OFFSET_LE(__txdesc+4, 15, 1, __value)
+#define SET_TX_DESC_RATE_ID(__txdesc, __value)		\
+	SET_BITS_OFFSET_LE(__txdesc+4, 16, 4, __value)
+#define SET_TX_DESC_RA_BRSR_ID(__txdesc, __value)	\
+	SET_BITS_OFFSET_LE(__txdesc+4, 16, 4, __value)
+#define SET_TX_DESC_NAV_USE_HDR(__txdesc, __value)	\
+	SET_BITS_OFFSET_LE(__txdesc+4, 20, 1, __value)
+#define SET_TX_DESC_EN_DESC_ID(__txdesc, __value)	\
+	SET_BITS_OFFSET_LE(__txdesc+4, 21, 1, __value)
+#define SET_TX_DESC_SEC_TYPE(__txdesc, __value)		\
+	SET_BITS_OFFSET_LE(__txdesc+4, 22, 2, __value)
+#define SET_TX_DESC_PKT_OFFSET(__txdesc, __value)	\
+	SET_BITS_OFFSET_LE(__txdesc+4, 26, 5, __value)
+
+/* Dword 2 */
+#define SET_TX_DESC_RTS_RC(__txdesc, __value)		\
+	SET_BITS_OFFSET_LE(__txdesc+8, 0, 6, __value)
+#define SET_TX_DESC_DATA_RC(__txdesc, __value)		\
+	SET_BITS_OFFSET_LE(__txdesc+8, 6, 6, __value)
+#define SET_TX_DESC_BAR_RTY_TH(__txdesc, __value)	\
+	SET_BITS_OFFSET_LE(__txdesc+8, 14, 2, __value)
+#define SET_TX_DESC_MORE_FRAG(__txdesc, __value)	\
+	SET_BITS_OFFSET_LE(__txdesc+8, 17, 1, __value)
+#define SET_TX_DESC_RAW(__txdesc, __value)		\
+	SET_BITS_OFFSET_LE(__txdesc+8, 18, 1, __value)
+#define SET_TX_DESC_CCX(__txdesc, __value)		\
+	SET_BITS_OFFSET_LE(__txdesc+8, 19, 1, __value)
+#define SET_TX_DESC_AMPDU_DENSITY(__txdesc, __value)	\
+	SET_BITS_OFFSET_LE(__txdesc+8, 20, 3, __value)
+#define SET_TX_DESC_ANTSEL_A(__txdesc, __value)		\
+	SET_BITS_OFFSET_LE(__txdesc+8, 24, 1, __value)
+#define SET_TX_DESC_ANTSEL_B(__txdesc, __value)		\
+	SET_BITS_OFFSET_LE(__txdesc+8, 25, 1, __value)
+#define SET_TX_DESC_TX_ANT_CCK(__txdesc, __value)	\
+	SET_BITS_OFFSET_LE(__txdesc+8, 26, 2, __value)
+#define SET_TX_DESC_TX_ANTL(__txdesc, __value)		\
+	SET_BITS_OFFSET_LE(__txdesc+8, 28, 2, __value)
+#define SET_TX_DESC_TX_ANT_HT(__txdesc, __value)	\
+	SET_BITS_OFFSET_LE(__txdesc+8, 30, 2, __value)
+
+/* Dword 3 */
+#define SET_TX_DESC_NEXT_HEAP_PAGE(__txdesc, __value)	\
+	SET_BITS_OFFSET_LE(__txdesc+12, 0, 8, __value)
+#define SET_TX_DESC_TAIL_PAGE(__txdesc, __value)	\
+	SET_BITS_OFFSET_LE(__txdesc+12, 8, 8, __value)
+#define SET_TX_DESC_SEQ(__txdesc, __value)		\
+	SET_BITS_OFFSET_LE(__txdesc+12, 16, 12, __value)
+#define SET_TX_DESC_PKT_ID(__txdesc, __value)		\
+	SET_BITS_OFFSET_LE(__txdesc+12, 28, 4, __value)
+
+/* Dword 4 */
+#define SET_TX_DESC_RTS_RATE(__txdesc, __value)		\
+	SET_BITS_OFFSET_LE(__txdesc+16, 0, 5, __value)
+#define SET_TX_DESC_AP_DCFE(__txdesc, __value)		\
+	SET_BITS_OFFSET_LE(__txdesc+16, 5, 1, __value)
+#define SET_TX_DESC_QOS(__txdesc, __value)		\
+	SET_BITS_OFFSET_LE(__txdesc+16, 6, 1, __value)
+#define SET_TX_DESC_HWSEQ_EN(__txdesc, __value)		\
+	SET_BITS_OFFSET_LE(__txdesc+16, 7, 1, __value)
+#define SET_TX_DESC_USE_RATE(__txdesc, __value)		\
+	SET_BITS_OFFSET_LE(__txdesc+16, 8, 1, __value)
+#define SET_TX_DESC_DISABLE_RTS_FB(__txdesc, __value)	\
+	SET_BITS_OFFSET_LE(__txdesc+16, 9, 1, __value)
+#define SET_TX_DESC_DISABLE_FB(__txdesc, __value)	\
+	SET_BITS_OFFSET_LE(__txdesc+16, 10, 1, __value)
+#define SET_TX_DESC_CTS2SELF(__txdesc, __value)		\
+	SET_BITS_OFFSET_LE(__txdesc+16, 11, 1, __value)
+#define SET_TX_DESC_RTS_ENABLE(__txdesc, __value)	\
+	SET_BITS_OFFSET_LE(__txdesc+16, 12, 1, __value)
+#define SET_TX_DESC_HW_RTS_ENABLE(__txdesc, __value)	\
+	SET_BITS_OFFSET_LE(__txdesc+16, 13, 1, __value)
+#define SET_TX_DESC_WAIT_DCTS(__txdesc, __value)	\
+	SET_BITS_OFFSET_LE(__txdesc+16, 18, 1, __value)
+#define SET_TX_DESC_CTS2AP_EN(__txdesc, __value)	\
+	SET_BITS_OFFSET_LE(__txdesc+16, 19, 1, __value)
+#define SET_TX_DESC_DATA_SC(__txdesc, __value)		\
+	SET_BITS_OFFSET_LE(__txdesc+16, 20, 2, __value)
+#define SET_TX_DESC_DATA_STBC(__txdesc, __value)	\
+	SET_BITS_OFFSET_LE(__txdesc+16, 22, 2, __value)
+#define SET_TX_DESC_DATA_SHORT(__txdesc, __value)	\
+	SET_BITS_OFFSET_LE(__txdesc+16, 24, 1, __value)
+#define SET_TX_DESC_DATA_BW(__txdesc, __value)		\
+	SET_BITS_OFFSET_LE(__txdesc+16, 25, 1, __value)
+#define SET_TX_DESC_RTS_SHORT(__txdesc, __value)	\
+	SET_BITS_OFFSET_LE(__txdesc+16, 26, 1, __value)
+#define SET_TX_DESC_RTS_BW(__txdesc, __value)		\
+	SET_BITS_OFFSET_LE(__txdesc+16, 27, 1, __value)
+#define SET_TX_DESC_RTS_SC(__txdesc, __value)		\
+	SET_BITS_OFFSET_LE(__txdesc+16, 28, 2, __value)
+#define SET_TX_DESC_RTS_STBC(__txdesc, __value)		\
+	SET_BITS_OFFSET_LE(__txdesc+16, 30, 2, __value)
+
+/* Dword 5 */
+#define SET_TX_DESC_TX_RATE(__pdesc, __val)		\
+	SET_BITS_OFFSET_LE(__pdesc+20, 0, 6, __val)
+#define SET_TX_DESC_DATA_SHORTGI(__pdesc, __val)	\
+	SET_BITS_OFFSET_LE(__pdesc+20, 6, 1, __val)
+#define SET_TX_DESC_CCX_TAG(__pdesc, __val)		\
+	SET_BITS_OFFSET_LE(__pdesc+20, 7, 1, __val)
+#define SET_TX_DESC_DATA_RATE_FB_LIMIT(__txdesc, __value) \
+	SET_BITS_OFFSET_LE(__txdesc+20, 8, 5, __value)
+#define SET_TX_DESC_RTS_RATE_FB_LIMIT(__txdesc, __value) \
+	SET_BITS_OFFSET_LE(__txdesc+20, 13, 4, __value)
+#define SET_TX_DESC_RETRY_LIMIT_ENABLE(__txdesc, __value) \
+	SET_BITS_OFFSET_LE(__txdesc+20, 17, 1, __value)
+#define SET_TX_DESC_DATA_RETRY_LIMIT(__txdesc, __value)	\
+	SET_BITS_OFFSET_LE(__txdesc+20, 18, 6, __value)
+#define SET_TX_DESC_USB_TXAGG_NUM(__txdesc, __value)	\
+	SET_BITS_OFFSET_LE(__txdesc+20, 24, 8, __value)
+
+/* Dword 6 */
+#define SET_TX_DESC_TXAGC_A(__txdesc, __value)		\
+	SET_BITS_OFFSET_LE(__txdesc+24, 0, 5, __value)
+#define SET_TX_DESC_TXAGC_B(__txdesc, __value)		\
+	SET_BITS_OFFSET_LE(__txdesc+24, 5, 5, __value)
+#define SET_TX_DESC_USB_MAX_LEN(__txdesc, __value)	\
+	SET_BITS_OFFSET_LE(__txdesc+24, 10, 1, __value)
+#define SET_TX_DESC_MAX_AGG_NUM(__txdesc, __value)	\
+	SET_BITS_OFFSET_LE(__txdesc+24, 11, 5, __value)
+#define SET_TX_DESC_MCSG1_MAX_LEN(__txdesc, __value)	\
+	SET_BITS_OFFSET_LE(__txdesc+24, 16, 4, __value)
+#define SET_TX_DESC_MCSG2_MAX_LEN(__txdesc, __value)	\
+	SET_BITS_OFFSET_LE(__txdesc+24, 20, 4, __value)
+#define SET_TX_DESC_MCSG3_MAX_LEN(__txdesc, __value)	\
+	SET_BITS_OFFSET_LE(__txdesc+24, 24, 4, __value)
+#define SET_TX_DESC_MCSG7_MAX_LEN(__txdesc, __value)	\
+	SET_BITS_OFFSET_LE(__txdesc+24, 28, 4, __value)
+
+/* Dword 7 */
+#define SET_TX_DESC_TX_DESC_CHECKSUM(__txdesc, __value) \
+	SET_BITS_OFFSET_LE(__txdesc+28, 0, 16, __value)
+#define SET_TX_DESC_MCSG4_MAX_LEN(__txdesc, __value)	\
+	SET_BITS_OFFSET_LE(__txdesc+28, 16, 4, __value)
+#define SET_TX_DESC_MCSG5_MAX_LEN(__txdesc, __value)	\
+	SET_BITS_OFFSET_LE(__txdesc+28, 20, 4, __value)
+#define SET_TX_DESC_MCSG6_MAX_LEN(__txdesc, __value)	\
+	SET_BITS_OFFSET_LE(__txdesc+28, 24, 4, __value)
+#define SET_TX_DESC_MCSG15_MAX_LEN(__txdesc, __value)	\
+	SET_BITS_OFFSET_LE(__txdesc+28, 28, 4, __value)
+
+
+int  rtl8192cu_endpoint_mapping(struct ieee80211_hw *hw);
+u16 rtl8192cu_mq_to_hwq(__le16 fc, u16 mac80211_queue_index);
+bool rtl92cu_rx_query_desc(struct ieee80211_hw *hw,
+			   struct rtl_stats *stats,
+			   struct ieee80211_rx_status *rx_status,
+			   u8 *p_desc, struct sk_buff *skb);
+void  rtl8192cu_rx_hdl(struct ieee80211_hw *hw, struct sk_buff * skb);
+void rtl8192c_rx_segregate_hdl(struct ieee80211_hw *, struct sk_buff *,
+			       struct sk_buff_head *);
+void rtl8192c_tx_cleanup(struct ieee80211_hw *hw, struct sk_buff  *skb);
+int rtl8192c_tx_post_hdl(struct ieee80211_hw *hw, struct urb *urb,
+			 struct sk_buff *skb);
+struct sk_buff *rtl8192c_tx_aggregate_hdl(struct ieee80211_hw *,
+					   struct sk_buff_head *);
+void rtl92cu_tx_fill_desc(struct ieee80211_hw *hw,
+			  struct ieee80211_hdr *hdr, u8 *pdesc_tx,
+			  struct ieee80211_tx_info *info, struct sk_buff *skb,
+			  unsigned int queue_index);
+void rtl92cu_fill_fake_txdesc(struct ieee80211_hw *hw, u8 * pDesc,
+			      u32 buffer_len, bool bIsPsPoll);
+void rtl92cu_tx_fill_cmddesc(struct ieee80211_hw *hw,
+			     u8 *pdesc, bool b_firstseg,
+			     bool b_lastseg, struct sk_buff *skb);
+bool rtl92cu_cmd_send_packet(struct ieee80211_hw *hw, struct sk_buff *skb);
+
+#endif
+
+
Index: wireless-testing/drivers/net/wireless/rtlwifi/wifi.h
===================================================================
--- wireless-testing.orig/drivers/net/wireless/rtlwifi/wifi.h
+++ wireless-testing/drivers/net/wireless/rtlwifi/wifi.h
@@ -114,6 +114,7 @@ enum hardware_type {
 	HARDWARE_TYPE_RTL8192CU,
 	HARDWARE_TYPE_RTL8192DE,
 	HARDWARE_TYPE_RTL8192DU,
+	HARDWARE_TYPE_RTL8723U,
 
 	/*keep it last*/
 	HARDWARE_TYPE_NUM
@@ -121,6 +122,10 @@ enum hardware_type {
 
 #define IS_HARDWARE_TYPE_8192CE(rtlhal)			\
 	(rtlhal->hw_type == HARDWARE_TYPE_RTL8192CE)
+#define IS_HARDWARE_TYPE_8192CU(rtlhal)			\
+	(rtlhal->hw_type == HARDWARE_TYPE_RTL8192CU)
+#define IS_HARDWARE_TYPE_8723U(rtlhal)			\
+	(rtlhal->hw_type == HARDWARE_TYPE_RTL8723U)
 
 enum scan_operation_backup_opt {
 	SCAN_OPT_BACKUP = 0,
@@ -363,6 +368,8 @@ enum rtl_var_map {
 	EFUSE_LOADER_CLK_EN,
 	EFUSE_ANA8M,
 	EFUSE_HWSET_MAX_SIZE,
+	EFUSE_MAX_SECTION_MAP,
+	EFUSE_REAL_CONTENT_SIZE,
 
 	/*CAM map */
 	RWCAM,
@@ -509,6 +516,17 @@ enum wireless_mode {
 	WIRELESS_MODE_N_5G = 0x20
 };
 
+#define IS_WIRELESS_MODE_A(wirelessmode)	\
+	(wirelessmode == WIRELESS_MODE_A)
+#define IS_WIRELESS_MODE_B(wirelessmode)	\
+	(wirelessmode == WIRELESS_MODE_B)
+#define IS_WIRELESS_MODE_G(wirelessmode)	\
+	(wirelessmode == WIRELESS_MODE_G)
+#define IS_WIRELESS_MODE_N_24G(wirelessmode)	\
+	(wirelessmode == WIRELESS_MODE_N_24G)
+#define IS_WIRELESS_MODE_N_5G(wirelessmode)	\
+	(wirelessmode == WIRELESS_MODE_N_5G)
+
 enum ratr_table_mode {
 	RATR_INX_WIRELESS_NGB = 0,
 	RATR_INX_WIRELESS_NG = 1,
@@ -694,6 +712,25 @@ struct rtl_rfkill {
 	bool rfkill_state;	/*0 is off, 1 is on */
 };
 
+struct phy_parameters {
+	u16 length;
+	u32 *pdata;
+};
+
+enum hw_param_tab_index {
+	PHY_REG_2T,
+	PHY_REG_1T,
+	PHY_REG_PG,
+	RADIOA_2T,
+	RADIOB_2T,
+	RADIOA_1T,
+	RADIOB_1T,
+	MAC_REG,
+	AGCTAB_2T,
+	AGCTAB_1T,
+	MAX_TAB
+};
+
 struct rtl_phy {
 	struct bb_reg_def phyreg_def[4];	/*Radio A/B/C/D */
 	struct init_gain initgain_backup;
@@ -747,6 +784,7 @@ struct rtl_phy {
 	u32 framesync_c34;
 
 	u8 num_total_rfpath;
+	struct phy_parameters hwparam_tables[MAX_TAB];
 };
 
 #define MAX_TID_COUNT				9
@@ -862,11 +900,13 @@ struct rtl_hal {
 	enum intf_type interface;
 	u16 hw_type;		/*92c or 92d or 92s and so on */
 	u8 oem_id;
-	u8 version;		/*version of chip */
+	u32 version;		/*version of chip */
 	u8 state;		/*stop 0, start 1 */
 
 	/*firmware */
 	u8 *pfirmware;
+	u16 fw_version;
+	u16 fw_subversion;
 	bool h2c_setinprogress;
 	u8 last_hmeboxnum;
 	bool fw_ready;
@@ -925,10 +965,10 @@ struct rtl_dm {
 	char cck_index;
 };
 
-#define	EFUSE_MAX_LOGICAL_SIZE			 128
+#define	EFUSE_MAX_LOGICAL_SIZE			 256
 
 struct rtl_efuse {
-	bool autoLoad_ok;
+	bool autoload_ok;
 	bool bootfromefuse;
 	u16 max_physical_size;
 	u8 contents[EFUSE_MAX_LOGICAL_SIZE];
@@ -947,6 +987,8 @@ struct rtl_efuse {
 	u8 eeprom_oemid;
 	u16 eeprom_channelplan;
 	u8 eeprom_version;
+	u8 board_type;
+	u8 external_pa;
 
 	u8 dev_addr[6];
 
@@ -1020,6 +1062,7 @@ struct rtl_ps_ctl {
 	/*just for PCIE ASPM */
 	u8 const_amdpci_aspm;
 
+	bool pwrdown_mode;
 	enum rf_pwrstate inactive_pwrstate;
 	enum rf_pwrstate rfpwr_state;	/*cur power state */
 };
@@ -1120,9 +1163,11 @@ struct rtl_hal_ops {
 	void (*disable_interrupt) (struct ieee80211_hw *hw);
 	int (*set_network_type) (struct ieee80211_hw *hw,
 				 enum nl80211_iftype type);
+	void (*set_chk_bssid)(struct ieee80211_hw *hw,
+				bool check_bssid);
 	void (*set_bw_mode) (struct ieee80211_hw *hw,
 			     enum nl80211_channel_type ch_type);
-	 u8(*switch_channel) (struct ieee80211_hw *hw);
+	u8 (*switch_channel) (struct ieee80211_hw *hw);
 	void (*set_qos) (struct ieee80211_hw *hw, int aci);
 	void (*set_bcn_reg) (struct ieee80211_hw *hw);
 	void (*set_bcn_intv) (struct ieee80211_hw *hw);
@@ -1136,6 +1181,8 @@ struct rtl_hal_ops {
 			      struct ieee80211_hdr *hdr, u8 *pdesc_tx,
 			      struct ieee80211_tx_info *info,
 			      struct sk_buff *skb, unsigned int queue_index);
+	void (*fill_fake_txdesc) (struct ieee80211_hw *hw, u8 * pDesc,
+				  u32 buffer_len, bool bIsPsPoll);
 	void (*fill_tx_cmddesc) (struct ieee80211_hw *hw, u8 *pdesc,
 				 bool firstseg, bool lastseg,
 				 struct sk_buff *skb);
@@ -1311,6 +1358,89 @@ struct rtl_priv {
 #define rtl_efuse(rtlpriv)	(&((rtlpriv)->efuse))
 #define rtl_psc(rtlpriv)	(&((rtlpriv)->psc))
 
+/***************************************
+    Bluetooth Co-existance Related
+****************************************/
+
+enum bt_ant_num {
+	ANT_X2 = 0,
+	ANT_X1 = 1,
+};
+
+enum bt_co_type {
+	BT_2WIRE = 0,
+	BT_ISSC_3WIRE = 1,
+	BT_ACCEL = 2,
+	BT_CSR_BC4 = 3,
+	BT_CSR_BC8 = 4,
+	BT_RTL8756 = 5,
+};
+
+enum bt_cur_state {
+	BT_OFF = 0,
+	BT_ON = 1,
+};
+
+enum bt_service_type {
+	BT_SCO = 0,
+	BT_A2DP = 1,
+	BT_HID = 2,
+	BT_HID_IDLE = 3,
+	BT_SCAN = 4,
+	BT_IDLE = 5,
+	BT_OTHER_ACTION = 6,
+	BT_BUSY = 7,
+	BT_OTHERBUSY = 8,
+	BT_PAN = 9,
+};
+
+enum bt_radio_shared {
+	BT_RADIO_SHARED = 0,
+	BT_RADIO_INDIVIDUAL = 1,
+};
+
+struct bt_coexist_info {
+
+	/* EEPROM BT info. */
+	u8 eeprom_bt_coexist;
+	u8 eeprom_bt_type;
+	u8 eeprom_bt_ant_num;
+	u8 eeprom_bt_ant_isolation;
+	u8 eeprom_bt_radio_shared;
+
+	u8 bt_coexistence;
+	u8 bt_ant_num;
+	u8 bt_coexist_type;
+	u8 bt_state;
+	u8 bt_cur_state;	/* 0:on, 1:off */
+	u8 bt_ant_isolation;	/* 0:good, 1:bad */
+	u8 bt_pape_ctrl;	/* 0:SW, 1:SW/HW dynamic */
+	u8 bt_service;
+	u8 bt_radio_shared_type;
+	u8 bt_rfreg_origin_1e;
+	u8 bt_rfreg_origin_1f;
+	u8 bt_rssi_state;
+	u32 ratio_tx;
+	u32 ratio_pri;
+	u32 bt_edca_ul;
+	u32 bt_edca_dl;
+
+	bool b_init_set;
+	bool b_bt_busy_traffic;
+	bool b_bt_traffic_mode_set;
+	bool b_bt_non_traffic_mode_set;
+
+	bool b_fw_coexist_all_off;
+	bool b_sw_coexist_all_off;
+	u32 current_state;
+	u32 previous_state;
+	u8 bt_pre_rssi_state;
+
+	u8 b_reg_bt_iso;
+	u8 b_reg_bt_sco;
+
+};
+
 /****************************************
 	mem access macro define start
 	Call endian free function when

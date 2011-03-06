Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:40284 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754216Ab1CFUm2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 6 Mar 2011 15:42:28 -0500
Date: Sun, 06 Mar 2011 14:42:23 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
To: John W Linville <linville@tuxdriver.com>
Cc: chaoming_li@realsil.com.cn, linux-wireless@vger.kernel.org
Subject: [RFC/RFT V2 11/11] rtlwifi: rtl8192se: Modify rtlwifi routines to handle rtl8192se and add Makefile and Kconfig
Message-ID: <4d73f1af.l2CCminUYNI1kQ1O%Larry.Finger@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Chaoming Li <chaoming_li@realsil.com.cn>

Modify rtlwifi routines for rtl8192se and set up Kconfig
and Makefile for new driver.

Signed-off-by: Chaoming_Li <chaoming_li@realsil.com.cn>
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---

Index: wireless-testing/drivers/net/wireless/rtlwifi/efuse.h
===================================================================
--- wireless-testing.orig/drivers/net/wireless/rtlwifi/efuse.h
+++ wireless-testing/drivers/net/wireless/rtlwifi/efuse.h
@@ -30,6 +30,7 @@
 #ifndef __RTL_EFUSE_H_
 #define __RTL_EFUSE_H_
 
+#define EFUSE_IC_ID_OFFSET		506
 #define EFUSE_REAL_CONTENT_LEN		512
 #define EFUSE_MAP_LEN			128
 #define EFUSE_MAX_SECTION		16
@@ -117,5 +118,6 @@ extern bool efuse_shadow_update_chk(stru
 extern void rtl_efuse_shadow_map_update(struct ieee80211_hw *hw);
 extern void efuse_force_write_vendor_Id(struct ieee80211_hw *hw);
 extern void efuse_re_pg_section(struct ieee80211_hw *hw, u8 section_idx);
+void read_efuse_byte(struct ieee80211_hw *hw, u16 _offset, u8 *pbuf);
 
 #endif
Index: wireless-testing/drivers/net/wireless/rtlwifi/rtl8192ce/sw.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/rtlwifi/rtl8192ce/sw.c
+++ wireless-testing/drivers/net/wireless/rtlwifi/rtl8192ce/sw.c
@@ -152,6 +152,7 @@ static struct rtl_mod_params rtl92ce_mod
 };
 
 static struct rtl_hal_cfg rtl92ce_hal_cfg = {
+	.bar_id = 2,
 	.name = "rtl92c_pci",
 	.fw_name = "rtlwifi/rtl8192cfw.bin",
 	.ops = &rtl8192ce_hal_ops,
Index: wireless-testing/drivers/net/wireless/rtlwifi/rtl8192ce/trx.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/rtlwifi/rtl8192ce/trx.c
+++ wireless-testing/drivers/net/wireless/rtlwifi/rtl8192ce/trx.c
@@ -723,7 +723,8 @@ bool rtl92ce_rx_query_desc(struct ieee80
 void rtl92ce_tx_fill_desc(struct ieee80211_hw *hw,
 			  struct ieee80211_hdr *hdr, u8 *pdesc_tx,
 			  struct ieee80211_tx_info *info, struct sk_buff *skb,
-			  unsigned int queue_index)
+			  unsigned int queue_index,
+			  struct rtl_tcb_desc *ptcb_desc)
 {
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
 	struct rtl_mac *mac = rtl_mac(rtl_priv(hw));
@@ -861,7 +862,7 @@ void rtl92ce_tx_fill_desc(struct ieee802
 
 	SET_TX_DESC_TX_BUFFER_SIZE(pdesc, (u16) skb->len);
 
-	SET_TX_DESC_TX_BUFFER_ADDRESS(pdesc, cpu_to_le32(mapping));
+	SET_TX_DESC_TX_BUFFER_ADDRESS(pdesc, mapping);
 
 	if (rtlpriv->dm.useramask) {
 		SET_TX_DESC_RATE_ID(pdesc, tcb_desc.ratr_index);
@@ -923,7 +924,7 @@ void rtl92ce_tx_fill_cmddesc(struct ieee
 
 	SET_TX_DESC_TX_BUFFER_SIZE(pdesc, (u16) (skb->len));
 
-	SET_TX_DESC_TX_BUFFER_ADDRESS(pdesc, cpu_to_le32(mapping));
+	SET_TX_DESC_TX_BUFFER_ADDRESS(pdesc, mapping);
 
 	SET_TX_DESC_RATE_ID(pdesc, 7);
 	SET_TX_DESC_MACID(pdesc, 0);
Index: wireless-testing/drivers/net/wireless/rtlwifi/rtl8192ce/trx.h
===================================================================
--- wireless-testing.orig/drivers/net/wireless/rtlwifi/rtl8192ce/trx.h
+++ wireless-testing/drivers/net/wireless/rtlwifi/rtl8192ce/trx.h
@@ -722,9 +722,10 @@ struct rx_desc_92c {
 } __packed;
 
 void rtl92ce_tx_fill_desc(struct ieee80211_hw *hw,
-			  struct ieee80211_hdr *hdr,
-			  u8 *pdesc, struct ieee80211_tx_info *info,
-			  struct sk_buff *skb, unsigned int qsel);
+			  struct ieee80211_hdr *hdr, u8 *pdesc_tx,
+			  struct ieee80211_tx_info *info, struct sk_buff *skb,
+			  unsigned int queue_index,
+			  struct rtl_tcb_desc *ptcb_desc);
 bool rtl92ce_rx_query_desc(struct ieee80211_hw *hw,
 			   struct rtl_stats *stats,
 			   struct ieee80211_rx_status *rx_status,
Index: wireless-testing/drivers/net/wireless/rtlwifi/rtl8192cu/trx.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/rtlwifi/rtl8192cu/trx.c
+++ wireless-testing/drivers/net/wireless/rtlwifi/rtl8192cu/trx.c
@@ -498,7 +498,8 @@ static void _rtl_tx_desc_checksum(u8 *tx
 void rtl92cu_tx_fill_desc(struct ieee80211_hw *hw,
 			  struct ieee80211_hdr *hdr, u8 *pdesc_tx,
 			  struct ieee80211_tx_info *info, struct sk_buff *skb,
-			  unsigned int queue_index)
+			  unsigned int queue_index,
+			  struct rtl_tcb_desc *ptcb_desc)
 {
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
 	struct rtl_mac *mac = rtl_mac(rtl_priv(hw));
Index: wireless-testing/drivers/net/wireless/rtlwifi/rtl8192cu/trx.h
===================================================================
--- wireless-testing.orig/drivers/net/wireless/rtlwifi/rtl8192cu/trx.h
+++ wireless-testing/drivers/net/wireless/rtlwifi/rtl8192cu/trx.h
@@ -419,7 +419,8 @@ struct sk_buff *rtl8192c_tx_aggregate_hd
 void rtl92cu_tx_fill_desc(struct ieee80211_hw *hw,
 			  struct ieee80211_hdr *hdr, u8 *pdesc_tx,
 			  struct ieee80211_tx_info *info, struct sk_buff *skb,
-			  unsigned int queue_index);
+			  unsigned int queue_index,
+			  struct rtl_tcb_desc *ptcb_desc);
 void rtl92cu_fill_fake_txdesc(struct ieee80211_hw *hw, u8 * pDesc,
 			      u32 buffer_len, bool bIsPsPoll);
 void rtl92cu_tx_fill_cmddesc(struct ieee80211_hw *hw,
Index: wireless-testing/drivers/net/wireless/rtlwifi/usb.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/rtlwifi/usb.c
+++ wireless-testing/drivers/net/wireless/rtlwifi/usb.c
@@ -852,6 +852,7 @@ static void _rtl_usb_tx_preprocess(struc
 	struct rtl_mac *mac = rtl_mac(rtl_priv(hw));
 	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
 	struct rtl_tx_desc *pdesc = NULL;
+	struct rtl_tcb_desc *ptcb_desc = NULL;
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)(skb->data);
 	__le16 fc = hdr->frame_control;
 	u8 *pda_addr = hdr->addr1;
@@ -878,7 +879,7 @@ static void _rtl_usb_tx_preprocess(struc
 		seq_number <<= 4;
 	}
 	rtlpriv->cfg->ops->fill_tx_desc(hw, hdr, (u8 *)pdesc, info, skb,
-					hw_queue);
+					hw_queue, ptcb_desc);
 	if (!ieee80211_has_morefrags(hdr->frame_control)) {
 		if (qc)
 			mac->tids[tid].seq_number = seq_number;
@@ -887,7 +888,8 @@ static void _rtl_usb_tx_preprocess(struc
 		rtlpriv->cfg->ops->led_control(hw, LED_CTL_TX);
 }
 
-static int rtl_usb_tx(struct ieee80211_hw *hw, struct sk_buff *skb)
+static int rtl_usb_tx(struct ieee80211_hw *hw, struct sk_buff *skb,
+		      struct rtl_tcb_desc *dummy)
 {
 	struct rtl_usb *rtlusb = rtl_usbdev(rtl_usbpriv(hw));
 	struct rtl_hal *rtlhal = rtl_hal(rtl_priv(hw));
Index: wireless-testing/drivers/net/wireless/rtlwifi/rtl8192c/phy_common.h
===================================================================
--- wireless-testing.orig/drivers/net/wireless/rtlwifi/rtl8192c/phy_common.h
+++ wireless-testing/drivers/net/wireless/rtlwifi/rtl8192c/phy_common.h
@@ -242,5 +242,21 @@ static bool _rtl92c_phy_set_sw_chnl_cmda
 static bool _rtl92c_phy_sw_chnl_step_by_step(struct ieee80211_hw *hw,
 					     u8 channel, u8 *stage, u8 *step,
 					     u32 *delay);
+u32 _rtl92c_phy_fw_rf_serial_read(struct ieee80211_hw *hw,
+				  enum radio_path rfpath, u32 offset);
+void _rtl92c_phy_fw_rf_serial_write(struct ieee80211_hw *hw,
+				    enum radio_path rfpath, u32 offset,
+				    u32 data);
+u32 _rtl92c_phy_rf_serial_read(struct ieee80211_hw *hw,
+			       enum radio_path rfpath, u32 offset);
+void _rtl92c_phy_rf_serial_write(struct ieee80211_hw *hw,
+				 enum radio_path rfpath, u32 offset,
+				 u32 data);
+bool _rtl92c_phy_bb8192c_config_parafile(struct ieee80211_hw *hw);
+void _rtl92c_store_pwrIndex_diffrate_offset(struct ieee80211_hw *hw,
+					    u32 regaddr, u32 bitmask,
+					    u32 data);
+bool rtl92c_phy_set_io_cmd(struct ieee80211_hw *hw, enum io_type iotype);
+void _rtl92c_phy_set_rf_sleep(struct ieee80211_hw *hw);
 
 #endif
Index: wireless-testing/drivers/net/wireless/rtlwifi/rtl8192ce/phy.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/rtlwifi/rtl8192ce/phy.c
+++ wireless-testing/drivers/net/wireless/rtlwifi/rtl8192ce/phy.c
@@ -39,7 +39,7 @@
 #include "table.h"
 
 u32 rtl92ce_phy_query_rf_reg(struct ieee80211_hw *hw,
-			    enum radio_path rfpath, u32 regaddr, u32 bitmask)
+			     enum radio_path rfpath, u32 regaddr, u32 bitmask)
 {
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
 	u32 original_value, readback_value, bitshift;
@@ -177,7 +177,7 @@ bool _rtl92ce_phy_config_mac_with_header
 }
 
 bool _rtl92ce_phy_config_bb_with_headerfile(struct ieee80211_hw *hw,
-						  u8 configtype)
+					    u8 configtype)
 {
 	int i;
 	u32 *phy_regarray_table;
@@ -236,7 +236,7 @@ bool _rtl92ce_phy_config_bb_with_headerf
 }
 
 bool _rtl92ce_phy_config_bb_with_pgheaderfile(struct ieee80211_hw *hw,
-						    u8 configtype)
+					      u8 configtype)
 {
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
 	int i;
Index: wireless-testing/drivers/net/wireless/rtlwifi/rtl8192ce/phy.h
===================================================================
--- wireless-testing.orig/drivers/net/wireless/rtlwifi/rtl8192ce/phy.h
+++ wireless-testing/drivers/net/wireless/rtlwifi/rtl8192ce/phy.h
@@ -250,5 +250,15 @@ bool _rtl92ce_phy_config_mac_with_header
 void _rtl92c_phy_init_bb_rf_register_definition(struct ieee80211_hw *hw);
 bool _rtl92c_phy_bb8192c_config_parafile(struct ieee80211_hw *hw);
 void _rtl92c_phy_set_rf_sleep(struct ieee80211_hw *hw);
+u32 rtl92ce_phy_query_rf_reg(struct ieee80211_hw *hw,
+			     enum radio_path rfpath, u32 regaddr, u32 bitmask);
+bool _rtl92ce_phy_config_bb_with_headerfile(struct ieee80211_hw *hw,
+					    u8 configtype);
+bool _rtl92ce_phy_config_bb_with_headerfile(struct ieee80211_hw *hw,
+					    u8 configtype);
+void rtl92ce_phy_set_bw_mode_callback(struct ieee80211_hw *hw);
+void _rtl92ce_phy_lc_calibrate(struct ieee80211_hw *hw, bool is2t);
+bool _rtl92ce_phy_config_bb_with_pgheaderfile(struct ieee80211_hw *hw,
+					      u8 configtype);
 
 #endif
Index: wireless-testing/drivers/net/wireless/rtlwifi/rtl8192ce/rf.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/rtlwifi/rtl8192ce/rf.c
+++ wireless-testing/drivers/net/wireless/rtlwifi/rtl8192ce/rf.c
@@ -62,7 +62,7 @@ void rtl92c_phy_rf6052_set_bandwidth(str
 }
 
 void rtl92ce_phy_rf6052_set_cck_txpower(struct ieee80211_hw *hw,
-				       u8 *ppowerlevel)
+					u8 *ppowerlevel)
 {
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
 	struct rtl_phy *rtlphy = &(rtlpriv->phy);
@@ -411,7 +411,7 @@ static void _rtl92c_write_ofdm_power_reg
 }
 
 void rtl92ce_phy_rf6052_set_ofdm_txpower(struct ieee80211_hw *hw,
-					u8 *ppowerlevel, u8 channel)
+					 u8 *ppowerlevel, u8 channel)
 {
 	u32 writeVal[2], powerBase0[2], powerBase1[2];
 	u8 index;
Index: wireless-testing/drivers/net/wireless/rtlwifi/rtl8192ce/rf.h
===================================================================
--- wireless-testing.orig/drivers/net/wireless/rtlwifi/rtl8192ce/rf.h
+++ wireless-testing/drivers/net/wireless/rtlwifi/rtl8192ce/rf.h
@@ -43,5 +43,9 @@ extern void rtl92c_phy_rf6052_set_ofdm_t
 bool rtl92ce_phy_rf6052_config(struct ieee80211_hw *hw);
 bool rtl92ce_phy_config_rf_with_headerfile(struct ieee80211_hw *hw,
 					  enum radio_path rfpath);
+void rtl92ce_phy_rf6052_set_cck_txpower(struct ieee80211_hw *hw,
+					u8 *ppowerlevel);
+void rtl92ce_phy_rf6052_set_ofdm_txpower(struct ieee80211_hw *hw,
+					 u8 *ppowerlevel, u8 channel);
 
 #endif
Index: wireless-testing/drivers/net/wireless/rtlwifi/rtl8192cu/phy.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/rtlwifi/rtl8192cu/phy.c
+++ wireless-testing/drivers/net/wireless/rtlwifi/rtl8192cu/phy.c
@@ -35,6 +35,7 @@
 #include "phy.h"
 #include "rf.h"
 #include "dm.h"
+#include "sw.h"
 #include "table.h"
 
 u32 rtl92cu_phy_query_rf_reg(struct ieee80211_hw *hw,
@@ -460,7 +461,7 @@ void _rtl92cu_phy_lc_calibrate(struct ie
 }
 
 bool _rtl92cu_phy_set_rf_power_state(struct ieee80211_hw *hw,
-					    enum rf_pwrstate rfpwr_state)
+				     enum rf_pwrstate rfpwr_state)
 {
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
 	struct rtl_pci_priv *pcipriv = rtl_pcipriv(hw);
Index: wireless-testing/drivers/net/wireless/rtlwifi/rtl8192cu/phy.h
===================================================================
--- wireless-testing.orig/drivers/net/wireless/rtlwifi/rtl8192cu/phy.h
+++ wireless-testing/drivers/net/wireless/rtlwifi/rtl8192cu/phy.h
@@ -34,3 +34,6 @@ bool rtl8192_phy_check_is_legal_rfpath(s
 void rtl92c_phy_set_io(struct ieee80211_hw *hw);
 bool _rtl92cu_phy_config_mac_with_headerfile(struct ieee80211_hw *hw);
 bool rtl92cu_phy_bb_config(struct ieee80211_hw *hw);
+bool rtl92cu_phy_mac_config(struct ieee80211_hw *hw);
+bool _rtl92cu_phy_set_rf_power_state(struct ieee80211_hw *hw,
+				     enum rf_pwrstate rfpwr_state);
Index: wireless-testing/drivers/net/wireless/rtlwifi/rtl8192cu/rf.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/rtlwifi/rtl8192cu/rf.c
+++ wireless-testing/drivers/net/wireless/rtlwifi/rtl8192cu/rf.c
@@ -62,7 +62,7 @@ void rtl92cu_phy_rf6052_set_bandwidth(st
 }
 
 void rtl92cu_phy_rf6052_set_cck_txpower(struct ieee80211_hw *hw,
-				       u8 *ppowerlevel)
+					u8 *ppowerlevel)
 {
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
 	struct rtl_phy *rtlphy = &(rtlpriv->phy);
@@ -389,7 +389,7 @@ static void _rtl92c_write_ofdm_power_reg
 }
 
 void rtl92cu_phy_rf6052_set_ofdm_txpower(struct ieee80211_hw *hw,
-					u8 *ppowerlevel, u8 channel)
+					 u8 *ppowerlevel, u8 channel)
 {
 	u32 writeVal[2], powerBase0[2], powerBase1[2];
 	u8 index = 0;
Index: wireless-testing/drivers/net/wireless/rtlwifi/rtl8192cu/rf.h
===================================================================
--- wireless-testing.orig/drivers/net/wireless/rtlwifi/rtl8192cu/rf.h
+++ wireless-testing/drivers/net/wireless/rtlwifi/rtl8192cu/rf.h
@@ -43,5 +43,9 @@ extern void rtl92c_phy_rf6052_set_ofdm_t
 bool rtl92cu_phy_rf6052_config(struct ieee80211_hw *hw);
 bool rtl92cu_phy_config_rf_with_headerfile(struct ieee80211_hw *hw,
 					  enum radio_path rfpath);
+void rtl92cu_phy_rf6052_set_cck_txpower(struct ieee80211_hw *hw,
+					u8 *ppowerlevel);
+void rtl92cu_phy_rf6052_set_ofdm_txpower(struct ieee80211_hw *hw,
+					 u8 *ppowerlevel, u8 channel);
 
 #endif
Index: wireless-testing/drivers/net/wireless/rtlwifi/base.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/rtlwifi/base.c
+++ wireless-testing/drivers/net/wireless/rtlwifi/base.c
@@ -50,8 +50,9 @@
  *3) functions called by core.c
  *4) wq & timer callback functions
  *5) frame process functions
- *6) sysfs functions
- *7) ...
+ *6) IOT functions
+ *7) sysfs functions
+ *8) ...
  */
 
 /*********************************************************
@@ -59,7 +60,7 @@
  * mac80211 init functions
  *
  *********************************************************/
-static struct ieee80211_channel rtl_channeltable[] = {
+static struct ieee80211_channel rtl_channeltable_2g[] = {
 	{.center_freq = 2412, .hw_value = 1,},
 	{.center_freq = 2417, .hw_value = 2,},
 	{.center_freq = 2422, .hw_value = 3,},
@@ -76,7 +77,34 @@ static struct ieee80211_channel rtl_chan
 	{.center_freq = 2484, .hw_value = 14,},
 };
 
-static struct ieee80211_rate rtl_ratetable[] = {
+static struct ieee80211_channel rtl_channeltable_5g[] = {
+	{.center_freq = 5180, .hw_value = 36,},
+	{.center_freq = 5200, .hw_value = 40,},
+	{.center_freq = 5220, .hw_value = 44,},
+	{.center_freq = 5240, .hw_value = 48,},
+	{.center_freq = 5260, .hw_value = 52,},
+	{.center_freq = 5280, .hw_value = 56,},
+	{.center_freq = 5300, .hw_value = 60,},
+	{.center_freq = 5320, .hw_value = 64,},
+	{.center_freq = 5500, .hw_value = 100,},
+	{.center_freq = 5520, .hw_value = 104,},
+	{.center_freq = 5540, .hw_value = 108,},
+	{.center_freq = 5560, .hw_value = 112,},
+	{.center_freq = 5580, .hw_value = 116,},
+	{.center_freq = 5600, .hw_value = 120,},
+	{.center_freq = 5620, .hw_value = 124,},
+	{.center_freq = 5640, .hw_value = 128,},
+	{.center_freq = 5660, .hw_value = 132,},
+	{.center_freq = 5680, .hw_value = 136,},
+	{.center_freq = 5700, .hw_value = 140,},
+	{.center_freq = 5745, .hw_value = 149,},
+	{.center_freq = 5765, .hw_value = 153,},
+	{.center_freq = 5785, .hw_value = 157,},
+	{.center_freq = 5805, .hw_value = 161,},
+	{.center_freq = 5825, .hw_value = 165,},
+};
+
+static struct ieee80211_rate rtl_ratetable_2g[] = {
 	{.bitrate = 10, .hw_value = 0x00,},
 	{.bitrate = 20, .hw_value = 0x01,},
 	{.bitrate = 55, .hw_value = 0x02,},
@@ -91,14 +119,37 @@ static struct ieee80211_rate rtl_ratetab
 	{.bitrate = 540, .hw_value = 0x0b,},
 };
 
+static struct ieee80211_rate rtl_ratetable_5g[] = {
+	{.bitrate = 60, .hw_value = 0x04,},
+	{.bitrate = 90, .hw_value = 0x05,},
+	{.bitrate = 120, .hw_value = 0x06,},
+	{.bitrate = 180, .hw_value = 0x07,},
+	{.bitrate = 240, .hw_value = 0x08,},
+	{.bitrate = 360, .hw_value = 0x09,},
+	{.bitrate = 480, .hw_value = 0x0a,},
+	{.bitrate = 540, .hw_value = 0x0b,},
+};
+
 static const struct ieee80211_supported_band rtl_band_2ghz = {
 	.band = IEEE80211_BAND_2GHZ,
 
-	.channels = rtl_channeltable,
-	.n_channels = ARRAY_SIZE(rtl_channeltable),
+	.channels = rtl_channeltable_2g,
+	.n_channels = ARRAY_SIZE(rtl_channeltable_2g),
 
-	.bitrates = rtl_ratetable,
-	.n_bitrates = ARRAY_SIZE(rtl_ratetable),
+	.bitrates = rtl_ratetable_2g,
+	.n_bitrates = ARRAY_SIZE(rtl_ratetable_2g),
+
+	.ht_cap = {0},
+};
+
+static struct ieee80211_supported_band rtl_band_5ghz = {
+	.band = IEEE80211_BAND_5GHZ,
+
+	.channels = rtl_channeltable_5g,
+	.n_channels = ARRAY_SIZE(rtl_channeltable_5g),
+
+	.bitrates = rtl_ratetable_5g,
+	.n_bitrates = ARRAY_SIZE(rtl_ratetable_5g),
 
 	.ht_cap = {0},
 };
@@ -115,6 +166,9 @@ static void _rtl_init_hw_ht_capab(struct
 	    IEEE80211_HT_CAP_SGI_20 |
 	    IEEE80211_HT_CAP_DSSSCCK40 | IEEE80211_HT_CAP_MAX_AMSDU;
 
+	if (rtlpriv->rtlhal.disable_amsdu_8k)
+		ht_cap->cap &= ~IEEE80211_HT_CAP_MAX_AMSDU;
+
 	/*
 	 *Maximum length of AMPDU that the STA can receive.
 	 *Length = 2 ^ (13 + max_ampdu_length_exp) - 1 (octets)
@@ -159,35 +213,93 @@ static void _rtl_init_hw_ht_capab(struct
 
 static void _rtl_init_mac80211(struct ieee80211_hw *hw)
 {
-	struct rtl_mac *rtlmac = rtl_mac(rtl_priv(hw));
-	struct rtl_efuse *rtlefuse = rtl_efuse(rtl_priv(hw));
+	struct rtl_priv *rtlpriv = rtl_priv(hw);
+	struct rtl_hal *rtlhal = rtl_hal(rtlpriv);
+	struct rtl_mac *rtlmac = rtl_mac(rtlpriv);
+	struct rtl_efuse *rtlefuse = rtl_efuse(rtlpriv);
 	struct ieee80211_supported_band *sband;
 
-	/* <1> use  mac->bands as mem for hw->wiphy->bands */
-	sband = &(rtlmac->bands[IEEE80211_BAND_2GHZ]);
+	if (rtlhal->macphymode == SINGLEMAC_SINGLEPHY &&
+	    rtlhal->bandset == BAND_ON_BOTH) {
+		/* 1: 2.4 G bands */
+		/* <1> use  mac->bands as mem for hw->wiphy->bands */
+		sband = &(rtlmac->bands[IEEE80211_BAND_2GHZ]);
+
+		/* <2> set hw->wiphy->bands[IEEE80211_BAND_2GHZ]
+		 * to default value(1T1R) */
+		memcpy(&(rtlmac->bands[IEEE80211_BAND_2GHZ]), &rtl_band_2ghz,
+				sizeof(struct ieee80211_supported_band));
+
+		/* <3> init ht cap base on ant_num */
+		_rtl_init_hw_ht_capab(hw, &sband->ht_cap);
+
+		/* <4> set mac->sband to wiphy->sband */
+		hw->wiphy->bands[IEEE80211_BAND_2GHZ] = sband;
+
+		/* 2: 5 G bands */
+		/* <1> use  mac->bands as mem for hw->wiphy->bands */
+		sband = &(rtlmac->bands[IEEE80211_BAND_5GHZ]);
+
+		/* <2> set hw->wiphy->bands[IEEE80211_BAND_5GHZ]
+		 * to default value(1T1R) */
+		memcpy(&(rtlmac->bands[IEEE80211_BAND_5GHZ]), &rtl_band_5ghz,
+				sizeof(struct ieee80211_supported_band));
 
-	/*
-	 * <2> set hw->wiphy->bands[IEEE80211_BAND_2GHZ]
-	 * to default value(1T1R)
-	 */
-	memcpy(&(rtlmac->bands[IEEE80211_BAND_2GHZ]), &rtl_band_2ghz,
-	       sizeof(struct ieee80211_supported_band));
+		/* <3> init ht cap base on ant_num */
+		_rtl_init_hw_ht_capab(hw, &sband->ht_cap);
 
-	/* <3> init ht cap base on ant_num */
-	_rtl_init_hw_ht_capab(hw, &sband->ht_cap);
+		/* <4> set mac->sband to wiphy->sband */
+		hw->wiphy->bands[IEEE80211_BAND_5GHZ] = sband;
+	} else {
+		if (rtlhal->current_bandtype == BAND_ON_2_4G) {
+			/* <1> use  mac->bands as mem for hw->wiphy->bands */
+			sband = &(rtlmac->bands[IEEE80211_BAND_2GHZ]);
+
+			/* <2> set hw->wiphy->bands[IEEE80211_BAND_2GHZ]
+			 * to default value(1T1R) */
+			memcpy(&(rtlmac->bands[IEEE80211_BAND_2GHZ]),
+			       &rtl_band_2ghz,
+			       sizeof(struct ieee80211_supported_band));
+
+			/* <3> init ht cap base on ant_num */
+			_rtl_init_hw_ht_capab(hw, &sband->ht_cap);
+
+			/* <4> set mac->sband to wiphy->sband */
+			hw->wiphy->bands[IEEE80211_BAND_2GHZ] = sband;
+		} else if (rtlhal->current_bandtype == BAND_ON_5G) {
+			/* <1> use  mac->bands as mem for hw->wiphy->bands */
+			sband = &(rtlmac->bands[IEEE80211_BAND_5GHZ]);
+
+			/* <2> set hw->wiphy->bands[IEEE80211_BAND_5GHZ]
+			 * to default value(1T1R) */
+			memcpy(&(rtlmac->bands[IEEE80211_BAND_5GHZ]),
+			       &rtl_band_5ghz,
+			       sizeof(struct ieee80211_supported_band));
 
-	/* <4> set mac->sband to wiphy->sband */
-	hw->wiphy->bands[IEEE80211_BAND_2GHZ] = sband;
+			/* <3> init ht cap base on ant_num */
+			_rtl_init_hw_ht_capab(hw, &sband->ht_cap);
 
+			/* <4> set mac->sband to wiphy->sband */
+			hw->wiphy->bands[IEEE80211_BAND_5GHZ] = sband;
+		} else {
+			RT_TRACE(rtlpriv, COMP_INIT, DBG_EMERG,
+				 ("Err BAND %d\n", rtlhal->current_bandtype));
+		}
+	}
 	/* <5> set hw caps */
 	hw->flags = IEEE80211_HW_SIGNAL_DBM |
 	    IEEE80211_HW_RX_INCLUDES_FCS |
-	    IEEE80211_HW_BEACON_FILTER | IEEE80211_HW_AMPDU_AGGREGATION | /*PS*/
-	    /*IEEE80211_HW_SUPPORTS_PS | */
-	    /*IEEE80211_HW_PS_NULLFUNC_STACK | */
-	    /*IEEE80211_HW_SUPPORTS_DYNAMIC_PS | */
+	    IEEE80211_HW_BEACON_FILTER |
+	    IEEE80211_HW_AMPDU_AGGREGATION |
 	    IEEE80211_HW_REPORTS_TX_ACK_STATUS | 0;
 
+	/* swlps or hwlps has been set in diff chip in init_sw_vars */
+	if (rtlpriv->psc.swctrl_lps)
+		hw->flags |= IEEE80211_HW_SUPPORTS_PS |
+			IEEE80211_HW_PS_NULLFUNC_STACK |
+			/* IEEE80211_HW_SUPPORTS_DYNAMIC_PS | */
+			0;
+
 	hw->wiphy->interface_modes =
 	    BIT(NL80211_IFTYPE_STATION) | BIT(NL80211_IFTYPE_ADHOC);
 
@@ -199,7 +311,7 @@ static void _rtl_init_mac80211(struct ie
 	/* TODO: Correct this value for our hw */
 	/* TODO: define these hard code value */
 	hw->channel_change_time = 100;
-	hw->max_listen_interval = 5;
+	hw->max_listen_interval = 10;
 	hw->max_rate_tries = 4;
 	/* hw->max_rates = 1; */
 
@@ -230,6 +342,10 @@ static void _rtl_init_deferred_work(stru
 			  (void *)rtl_watchdog_wq_callback);
 	INIT_DELAYED_WORK(&rtlpriv->works.ips_nic_off_wq,
 			  (void *)rtl_ips_nic_off_wq_callback);
+	INIT_DELAYED_WORK(&rtlpriv->works.ps_work,
+			  (void *)rtl_swlps_wq_callback);
+	INIT_DELAYED_WORK(&rtlpriv->works.ps_rfon_wq,
+			  (void *)rtl_swlps_rfon_wq_callback);
 
 }
 
@@ -241,6 +357,8 @@ void rtl_deinit_deferred_work(struct iee
 
 	cancel_delayed_work(&rtlpriv->works.watchdog_wq);
 	cancel_delayed_work(&rtlpriv->works.ips_nic_off_wq);
+	cancel_delayed_work(&rtlpriv->works.ps_work);
+	cancel_delayed_work(&rtlpriv->works.ps_rfon_wq);
 }
 
 void rtl_init_rfkill(struct ieee80211_hw *hw)
@@ -251,15 +369,18 @@ void rtl_init_rfkill(struct ieee80211_hw
 	bool blocked;
 	u8 valid = 0;
 
-	radio_state = rtlpriv->cfg->ops->radio_onoff_checking(hw, &valid);
+	/*1. set init state to on */
+	rtlpriv->rfkill.rfkill_state = 1;
+	wiphy_rfkill_set_hw_state(hw->wiphy, 0);
 
-	/*set init state to that of switch */
-	rtlpriv->rfkill.rfkill_state = radio_state;
-	printk(KERN_INFO "rtlwifi: wireless switch is %s\n",
-	       rtlpriv->rfkill.rfkill_state ? "on" : "off");
+	/*2. check gpio for rf state */
+	radio_state = rtlpriv->cfg->ops->radio_onoff_checking(hw, &valid);
 
+	/*3. if valid, change state based on gpio */
 	if (valid) {
 		rtlpriv->rfkill.rfkill_state = radio_state;
+		printk(KERN_INFO "rtlwifi: wireless switch is %s\n",
+		       rtlpriv->rfkill.rfkill_state ? "on" : "off");
 
 		blocked = (rtlpriv->rfkill.rfkill_state == 1) ? 0 : 1;
 		wiphy_rfkill_set_hw_state(hw->wiphy, blocked);
@@ -308,6 +429,8 @@ int rtl_init_core(struct ieee80211_hw *h
 	spin_lock_init(&rtlpriv->locks.rf_ps_lock);
 	spin_lock_init(&rtlpriv->locks.rf_lock);
 	spin_lock_init(&rtlpriv->locks.lps_lock);
+	spin_lock_init(&rtlpriv->locks.waitq_lock);
+	spin_lock_init(&rtlpriv->locks.cck_and_rw_pagea_lock);
 
 	rtlmac->link_state = MAC80211_NOLINK;
 
@@ -327,12 +450,6 @@ void rtl_init_rx_config(struct ieee80211
 	struct rtl_mac *mac = rtl_mac(rtl_priv(hw));
 
 	rtlpriv->cfg->ops->get_hw_reg(hw, HW_VAR_RCR, (u8 *) (&mac->rx_conf));
-	rtlpriv->cfg->ops->get_hw_reg(hw, HW_VAR_MGT_FILTER,
-				      (u8 *) (&mac->rx_mgt_filter));
-	rtlpriv->cfg->ops->get_hw_reg(hw, HW_VAR_CTRL_FILTER,
-				      (u8 *) (&mac->rx_ctrl_filter));
-	rtlpriv->cfg->ops->get_hw_reg(hw, HW_VAR_DATA_FILTER,
-				      (u8 *) (&mac->rx_data_filter));
 }
 
 /*********************************************************
@@ -435,14 +552,16 @@ static void _rtl_txrate_selectmode(struc
 		/* TODO adhoc and station handled differently in the future */
 		tcb_desc->mac_id = 0;
 
-		if ((mac->mode == WIRELESS_MODE_N_24G) ||
-		    (mac->mode == WIRELESS_MODE_N_5G)) {
+		if (mac->mode == WIRELESS_MODE_N_24G)
 			tcb_desc->ratr_index = RATR_INX_WIRELESS_NGB;
-		} else if (mac->mode & WIRELESS_MODE_G) {
+		else if (mac->mode == WIRELESS_MODE_N_5G)
+			tcb_desc->ratr_index = RATR_INX_WIRELESS_NG;
+		else if (mac->mode & WIRELESS_MODE_G)
 			tcb_desc->ratr_index = RATR_INX_WIRELESS_GB;
-		} else if (mac->mode & WIRELESS_MODE_B) {
+		else if (mac->mode & WIRELESS_MODE_B)
 			tcb_desc->ratr_index = RATR_INX_WIRELESS_B;
-		}
+		else if (mac->mode & WIRELESS_MODE_A)
+			tcb_desc->ratr_index = RATR_INX_WIRELESS_G;
 	}
 
 }
@@ -492,14 +611,13 @@ void rtl_get_tcb_desc(struct ieee80211_h
 	struct ieee80211_rate *txrate;
 	__le16 fc = hdr->frame_control;
 
-	memset(tcb_desc, 0, sizeof(struct rtl_tcb_desc));
+	txrate = ieee80211_get_tx_rate(hw, info);
+	tcb_desc->hw_rate = txrate->hw_value;
 
 	if (ieee80211_is_data(fc)) {
-		txrate = ieee80211_get_tx_rate(hw, info);
-		tcb_desc->hw_rate = txrate->hw_value;
 
 		/*
-		 *we set data rate RTL_RC_CCK_RATE1M
+		 *we set data rate INX 0
 		 *in rtl_rc.c   if skb is special data or
 		 *mgt which need low data rate.
 		 */
@@ -508,12 +626,10 @@ void rtl_get_tcb_desc(struct ieee80211_h
 		 *So tcb_desc->hw_rate is just used for
 		 *special data and mgt frames
 		 */
-		if (tcb_desc->hw_rate < rtlpriv->cfg->maps[RTL_RC_CCK_RATE11M]) {
+		if (info->control.rates[0].idx == 0) {
 			tcb_desc->use_driver_rate = true;
-			tcb_desc->ratr_index = 7;
+			tcb_desc->ratr_index = RATR_INX_WIRELESS_MC;
 
-			tcb_desc->hw_rate =
-			    rtlpriv->cfg->maps[RTL_RC_CCK_RATE1M];
 			tcb_desc->disable_ratefallback = 1;
 		} else {
 			/*
@@ -528,10 +644,12 @@ void rtl_get_tcb_desc(struct ieee80211_h
 			} else {
 				if (rtlmac->mode == WIRELESS_MODE_B) {
 					tcb_desc->hw_rate =
-					   rtlpriv->cfg->maps[RTL_RC_CCK_RATE11M];
+					   rtlpriv->cfg->maps
+					   [RTL_RC_CCK_RATE11M];
 				} else {
 					tcb_desc->hw_rate =
-					   rtlpriv->cfg->maps[RTL_RC_OFDM_RATE54M];
+					   rtlpriv->cfg->maps
+					   [RTL_RC_OFDM_RATE54M];
 				}
 			}
 		}
@@ -548,11 +666,11 @@ void rtl_get_tcb_desc(struct ieee80211_h
 		_rtl_query_protection_mode(hw, tcb_desc, info);
 	} else {
 		tcb_desc->use_driver_rate = true;
-		tcb_desc->ratr_index = 7;
+		tcb_desc->ratr_index = RATR_INX_WIRELESS_MC;
 		tcb_desc->disable_ratefallback = 1;
 		tcb_desc->mac_id = 0;
 
-		tcb_desc->hw_rate = rtlpriv->cfg->maps[RTL_RC_CCK_RATE1M];
+		tcb_desc->packet_bw = false;
 	}
 }
 EXPORT_SYMBOL(rtl_get_tcb_desc);
@@ -569,6 +687,8 @@ bool rtl_tx_mgmt_proc(struct ieee80211_h
 		rtl_ips_nic_on(hw);
 
 		mac->link_state = MAC80211_LINKING;
+		/* Dual mac */
+		rtlpriv->phy.need_iqk = true;
 	}
 
 	return true;
@@ -792,11 +912,8 @@ void rtl_watchdog_wq_callback(void *data
 		mac->cnt_after_linked = 0;
 	}
 
-	/* <2> DM */
-	rtlpriv->cfg->ops->dm_watchdog(hw);
-
 	/*
-	 *<3> to check if traffic busy, if
+	 *<2> to check if traffic busy, if
 	 * busytraffic we don't change channel
 	 */
 	if (mac->link_state >= MAC80211_LINKED) {
@@ -858,6 +975,8 @@ void rtl_watchdog_wq_callback(void *data
 	rtlpriv->link_info.higher_busytraffic = higher_busytraffic;
 	rtlpriv->link_info.higher_busyrxtraffic = higher_busyrxtraffic;
 
+	/* <3> DM */
+	rtlpriv->cfg->ops->dm_watchdog(hw);
 }
 
 void rtl_watch_dog_timer_callback(unsigned long data)
@@ -874,6 +993,180 @@ void rtl_watch_dog_timer_callback(unsign
 
 /*********************************************************
  *
+ * frame process functions
+ *
+ *********************************************************/
+u8 *rtl_find_ie(u8 *data, unsigned int len, u8 ie)
+{
+	struct ieee80211_mgmt *mgmt = (void *)data;
+	u8 *pos, *end;
+
+	pos = (u8 *)mgmt->u.beacon.variable;
+	end = data + len;
+	while (pos < end) {
+		if (pos + 2 + pos[1] > end)
+			return NULL;
+
+		if (pos[0] == ie)
+			return pos;
+
+		pos += 2 + pos[1];
+	}
+	return NULL;
+}
+
+/*********************************************************
+ *
+ * IOT functions
+ *
+ *********************************************************/
+static bool rtl_chk_vendor_ouisub(struct ieee80211_hw *hw,
+		struct octet_string vendor_ie)
+{
+	struct rtl_priv *rtlpriv = rtl_priv(hw);
+	bool matched = false;
+	static u8 athcap_1[] = { 0x00, 0x03, 0x7F };
+	static u8 athcap_2[] = { 0x00, 0x13, 0x74 };
+	static u8 broadcap_1[] = { 0x00, 0x10, 0x18 };
+	static u8 broadcap_2[] = { 0x00, 0x0a, 0xf7 };
+	static u8 broadcap_3[] = { 0x00, 0x05, 0xb5 };
+	static u8 racap[] = { 0x00, 0x0c, 0x43 };
+	static u8 ciscocap[] = { 0x00, 0x40, 0x96 };
+	static u8 marvcap[] = { 0x00, 0x50, 0x43 };
+
+	if (memcmp(vendor_ie.octet, athcap_1, 3) == 0 ||
+		memcmp(vendor_ie.octet, athcap_2, 3) == 0) {
+		rtlpriv->mac80211.vendor = PEER_ATH;
+		matched = true;
+	} else if (memcmp(vendor_ie.octet, broadcap_1, 3) == 0 ||
+		memcmp(vendor_ie.octet, broadcap_2, 3) == 0 ||
+		memcmp(vendor_ie.octet, broadcap_3, 3) == 0) {
+		rtlpriv->mac80211.vendor = PEER_BROAD;
+		matched = true;
+	} else if (memcmp(vendor_ie.octet, racap, 3) == 0) {
+		rtlpriv->mac80211.vendor = PEER_RAL;
+		matched = true;
+	} else if (memcmp(vendor_ie.octet, ciscocap, 3) == 0) {
+		rtlpriv->mac80211.vendor = PEER_CISCO;
+		matched = true;
+	} else if (memcmp(vendor_ie.octet, marvcap, 3) == 0) {
+		rtlpriv->mac80211.vendor = PEER_MARV;
+		matched = true;
+	}
+
+	return matched;
+}
+
+static bool rtl_find_221_ie(struct ieee80211_hw *hw, u8 *data,
+		unsigned int len)
+{
+	struct ieee80211_mgmt *mgmt = (void *)data;
+	struct octet_string vendor_ie;
+	u8 *pos, *end;
+
+	pos = (u8 *)mgmt->u.beacon.variable;
+	end = data + len;
+	while (pos < end) {
+		if (pos[0] == 221) {
+			vendor_ie.length = pos[1];
+			vendor_ie.octet = &pos[2];
+			if (rtl_chk_vendor_ouisub(hw, vendor_ie))
+				return true;
+		}
+
+		if (pos + 2 + pos[1] > end)
+			return false;
+
+		pos += 2 + pos[1];
+	}
+	return false;
+}
+
+void rtl_recognize_peer(struct ieee80211_hw *hw, u8 *data, unsigned int len)
+{
+	struct rtl_priv *rtlpriv = rtl_priv(hw);
+	struct rtl_mac *mac = rtl_mac(rtl_priv(hw));
+	struct ieee80211_hdr *hdr = (void *)data;
+	u32 vendor = PEER_UNKNOWN;
+
+	static u8 ap3_1[3] = { 0x00, 0x14, 0xbf };
+	static u8 ap3_2[3] = { 0x00, 0x1a, 0x70 };
+	static u8 ap3_3[3] = { 0x00, 0x1d, 0x7e };
+	static u8 ap4_1[3] = { 0x00, 0x90, 0xcc };
+	static u8 ap4_2[3] = { 0x00, 0x0e, 0x2e };
+	static u8 ap4_3[3] = { 0x00, 0x18, 0x02 };
+	static u8 ap4_4[3] = { 0x00, 0x17, 0x3f };
+	static u8 ap4_5[3] = { 0x00, 0x1c, 0xdf };
+	static u8 ap5_1[3] = { 0x00, 0x1c, 0xf0 };
+	static u8 ap5_2[3] = { 0x00, 0x21, 0x91 };
+	static u8 ap5_3[3] = { 0x00, 0x24, 0x01 };
+	static u8 ap5_4[3] = { 0x00, 0x15, 0xe9 };
+	static u8 ap5_5[3] = { 0x00, 0x17, 0x9A };
+	static u8 ap5_6[3] = { 0x00, 0x18, 0xE7 };
+	static u8 ap6_1[3] = { 0x00, 0x17, 0x94 };
+	static u8 ap7_1[3] = { 0x00, 0x14, 0xa4 };
+
+	if (mac->link_state == MAC80211_NOLINK) {
+		mac->vendor = PEER_UNKNOWN;
+		return;
+	}
+
+	if (mac->cnt_after_linked > 2)
+		return;
+
+	/* check if this really is a beacon */
+	if (!ieee80211_is_beacon(hdr->frame_control))
+		return;
+
+	/* min. beacon length + FCS_LEN */
+	if (len <= 40 + FCS_LEN)
+		return;
+
+	/* and only beacons from the associated BSSID, please */
+	if (compare_ether_addr(hdr->addr3, rtlpriv->mac80211.bssid))
+		return;
+
+	if (rtl_find_221_ie(hw, data, len))
+		vendor = mac->vendor;
+
+	if ((memcmp(mac->bssid, ap5_1, 3) == 0) ||
+		(memcmp(mac->bssid, ap5_2, 3) == 0) ||
+		(memcmp(mac->bssid, ap5_3, 3) == 0) ||
+		(memcmp(mac->bssid, ap5_4, 3) == 0) ||
+		(memcmp(mac->bssid, ap5_5, 3) == 0) ||
+		(memcmp(mac->bssid, ap5_6, 3) == 0) ||
+		vendor == PEER_ATH) {
+		vendor = PEER_ATH;
+		RT_TRACE(rtlpriv, COMP_MAC80211, DBG_LOUD, ("=>ath find\n"));
+	} else if ((memcmp(mac->bssid, ap4_4, 3) == 0) ||
+		(memcmp(mac->bssid, ap4_5, 3) == 0) ||
+		(memcmp(mac->bssid, ap4_1, 3) == 0) ||
+		(memcmp(mac->bssid, ap4_2, 3) == 0) ||
+		(memcmp(mac->bssid, ap4_3, 3) == 0) ||
+		vendor == PEER_RAL) {
+		RT_TRACE(rtlpriv, COMP_MAC80211, DBG_LOUD, ("=>ral findn\n"));
+		vendor = PEER_RAL;
+	} else if (memcmp(mac->bssid, ap6_1, 3) == 0 ||
+		vendor == PEER_CISCO) {
+		vendor = PEER_CISCO;
+		RT_TRACE(rtlpriv, COMP_MAC80211, DBG_LOUD, ("=>cisco find\n"));
+	} else if ((memcmp(mac->bssid, ap3_1, 3) == 0) ||
+		(memcmp(mac->bssid, ap3_2, 3) == 0) ||
+		(memcmp(mac->bssid, ap3_3, 3) == 0) ||
+		vendor == PEER_BROAD) {
+		RT_TRACE(rtlpriv, COMP_MAC80211, DBG_LOUD, ("=>broad find\n"));
+		vendor = PEER_BROAD;
+	} else if (memcmp(mac->bssid, ap7_1, 3) == 0 ||
+		vendor == PEER_MARV) {
+		vendor = PEER_MARV;
+		RT_TRACE(rtlpriv, COMP_MAC80211, DBG_LOUD, ("=>marv find\n"));
+	}
+
+	mac->vendor = vendor;
+}
+
+/*********************************************************
+ *
  * sysfs functions
  *
  *********************************************************/
@@ -939,6 +1232,9 @@ static int __init rtl_core_module_init(v
 	if (rtl_rate_control_register())
 		printk(KERN_ERR "rtlwifi: Unable to register rtl_rc,"
 		       "use default RC !!\n");
+	/* add proc for debug */
+	rtl_proc_add_topdir();
+
 	return 0;
 }
 
@@ -946,6 +1242,9 @@ static void __exit rtl_core_module_exit(
 {
 	 /*RC*/
 	rtl_rate_control_unregister();
+
+	/* remove proc for debug */
+	rtl_proc_remove_topdir();
 }
 
 module_init(rtl_core_module_init);
Index: wireless-testing/drivers/net/wireless/rtlwifi/debug.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/rtlwifi/debug.c
+++ wireless-testing/drivers/net/wireless/rtlwifi/debug.c
@@ -27,6 +27,7 @@
  *****************************************************************************/
 
 #include "wifi.h"
+#include "cam.h"
 
 void rtl_dbgp_flag_init(struct ieee80211_hw *hw)
 {
@@ -48,3 +49,804 @@ void rtl_dbgp_flag_init(struct ieee80211
 
 	/*Init Debug flag enable condition */
 }
+
+static struct proc_dir_entry *proc_topdir;
+
+static int rtl_proc_get_mac_0(char *page, char **start,
+		off_t offset, int count, int *eof, void *data)
+{
+	struct ieee80211_hw *hw = data;
+	struct rtl_priv *rtlpriv = rtl_priv(hw);
+	int len = 0;
+	int i, n, page0;
+	int max = 0xff;
+	page0 = 0x000;
+
+	for (n = 0; n <= max; ) {
+		len += snprintf(page + len, count - len, "\n%8.8x  ",
+				n + page0);
+		for (i = 0; i < 4 && n <= max; i++, n += 4)
+			len += snprintf(page + len, count - len,
+					"%8.8x    ",
+					rtl_read_dword(rtlpriv, (page0 | n)));
+	}
+
+	len += snprintf(page + len, count - len, "\n");
+	*eof = 1;
+	return len;
+
+}
+
+static int rtl_proc_get_mac_1(char *page, char **start,
+		off_t offset, int count, int *eof, void *data)
+{
+	struct ieee80211_hw *hw = data;
+	struct rtl_priv *rtlpriv = rtl_priv(hw);
+	int len = 0;
+	int i, n, page0;
+	int max = 0xff;
+	page0 = 0x100;
+
+	for (n = 0; n <= max; ) {
+		len += snprintf(page + len, count - len, "\n%8.8x  ",
+				n + page0);
+		for (i = 0; i < 4 && n <= max; i++, n += 4)
+			len += snprintf(page + len, count - len,
+					"%8.8x    ",
+					rtl_read_dword(rtlpriv, (page0 | n)));
+	}
+
+	len += snprintf(page + len, count - len, "\n");
+	*eof = 1;
+	return len;
+
+}
+static int rtl_proc_get_mac_2(char *page, char **start,
+		off_t offset, int count, int *eof, void *data)
+{
+	struct ieee80211_hw *hw = data;
+	struct rtl_priv *rtlpriv = rtl_priv(hw);
+	int len = 0;
+	int i, n, page0;
+	int max = 0xff;
+	page0 = 0x200;
+
+	for (n = 0; n <= max; ) {
+		len += snprintf(page + len, count - len, "\n%8.8x  ",
+				n + page0);
+		for (i = 0; i < 4 && n <= max; i++, n += 4)
+			len += snprintf(page + len, count - len,
+					"%8.8x    ",
+					rtl_read_dword(rtlpriv, (page0 | n)));
+	}
+
+	len += snprintf(page + len, count - len, "\n");
+	*eof = 1;
+	return len;
+
+}
+
+static int rtl_proc_get_mac_3(char *page, char **start,
+		off_t offset, int count, int *eof, void *data)
+{
+	struct ieee80211_hw *hw = data;
+	struct rtl_priv *rtlpriv = rtl_priv(hw);
+	int len = 0;
+	int i, n, page0;
+	int max = 0xff;
+	page0 = 0x300;
+
+	for (n = 0; n <= max; ) {
+		len += snprintf(page + len, count - len, "\n%8.8x  ",
+				n + page0);
+		for (i = 0; i < 4 && n <= max; i++, n += 4)
+			len += snprintf(page + len, count - len,
+					"%8.8x    ",
+					rtl_read_dword(rtlpriv, (page0 | n)));
+	}
+
+	len += snprintf(page + len, count - len, "\n");
+	*eof = 1;
+	return len;
+
+}
+
+static int rtl_proc_get_mac_4(char *page, char **start,
+		off_t offset, int count, int *eof, void *data)
+{
+	struct ieee80211_hw *hw = data;
+	struct rtl_priv *rtlpriv = rtl_priv(hw);
+	int len = 0;
+	int i, n, page0;
+	int max = 0xff;
+	page0 = 0x400;
+
+	for (n = 0; n <= max; ) {
+		len += snprintf(page + len, count - len, "\n%8.8x  ",
+				n + page0);
+		for (i = 0; i < 4 && n <= max; i++, n += 4)
+			len += snprintf(page + len, count - len,
+					"%8.8x    ",
+					rtl_read_dword(rtlpriv, (page0 | n)));
+	}
+
+	len += snprintf(page + len, count - len, "\n");
+	*eof = 1;
+	return len;
+
+}
+
+static int rtl_proc_get_mac_5(char *page, char **start,
+		off_t offset, int count, int *eof, void *data)
+{
+	struct ieee80211_hw *hw = data;
+	struct rtl_priv *rtlpriv = rtl_priv(hw);
+	int len = 0;
+	int i, n, page0;
+	int max = 0xff;
+	page0 = 0x500;
+
+	for (n = 0; n <= max; ) {
+		len += snprintf(page + len, count - len, "\n%8.8x  ",
+				n + page0);
+		for (i = 0; i < 4 && n <= max; i++, n += 4)
+			len += snprintf(page + len, count - len,
+					"%8.8x    ",
+					rtl_read_dword(rtlpriv, (page0 | n)));
+	}
+
+	len += snprintf(page + len, count - len, "\n");
+	*eof = 1;
+	return len;
+
+}
+
+static int rtl_proc_get_mac_6(char *page, char **start,
+			      off_t offset, int count,
+			      int *eof, void *data)
+{
+	struct ieee80211_hw *hw = data;
+	struct rtl_priv *rtlpriv = rtl_priv(hw);
+	int len = 0;
+	int i, n, page0;
+	int max = 0xff;
+	page0 = 0x600;
+
+	for (n = 0; n <= max; ) {
+		len += snprintf(page + len, count - len, "\n%8.8x  ",
+				n + page0);
+		for (i = 0; i < 4 && n <= max; i++, n += 4)
+			len += snprintf(page + len, count - len,
+					"%8.8x    ",
+					rtl_read_dword(rtlpriv, (page0 | n)));
+	}
+
+	len += snprintf(page + len, count - len, "\n");
+	*eof = 1;
+	return len;
+
+}
+static int rtl_proc_get_mac_7(char *page, char **start,
+		off_t offset, int count, int *eof, void *data)
+{
+	struct ieee80211_hw *hw = data;
+	struct rtl_priv *rtlpriv = rtl_priv(hw);
+	int len = 0;
+	int i, n, page0;
+	int max = 0xff;
+	page0 = 0x700;
+
+	for (n = 0; n <= max; ) {
+		len += snprintf(page + len, count - len, "\n%8.8x  ",
+				n + page0);
+		for (i = 0; i < 4 && n <= max; i++, n += 4)
+			len += snprintf(page + len, count - len,
+					"%8.8x    ",
+					rtl_read_dword(rtlpriv, (page0 | n)));
+	}
+
+	len += snprintf(page + len, count - len, "\n");
+	*eof = 1;
+	return len;
+
+}
+
+static int rtl_proc_get_bb_8(char *page, char **start,
+		off_t offset, int count, int *eof, void *data)
+{
+	struct ieee80211_hw *hw = data;
+	int len = 0;
+	int i, n, page0;
+	int max = 0xff;
+	page0 = 0x800;
+
+	for (n = 0; n <= max; ) {
+		len += snprintf(page + len, count - len, "\n%#8.8x  ",
+				n + page0);
+		for (i = 0; i < 4 && n <= max; n += 4, i++)
+			len += snprintf(page + len, count - len,
+					"%8.8x     ",
+					rtl_get_bbreg(hw, (page0 | n),
+						      0xffffffff));
+	}
+
+	len += snprintf(page + len, count - len, "\n");
+	*eof = 1;
+	return len;
+
+}
+static int rtl_proc_get_bb_9(char *page, char **start,
+		off_t offset, int count, int *eof, void *data)
+{
+	struct ieee80211_hw *hw = data;
+	int len = 0;
+	int i, n, page0;
+	int max = 0xff;
+	page0 = 0x900;
+
+	for (n = 0; n <= max; ) {
+		len += snprintf(page + len, count - len, "\n%#8.8x  ",
+				n + page0);
+		for (i = 0; i < 4 && n <= max; n += 4, i++)
+			len += snprintf(page + len, count - len,
+					"%8.8x     ",
+					rtl_get_bbreg(hw, (page0 | n),
+						       0xffffffff));
+	}
+
+	len += snprintf(page + len, count - len, "\n");
+	*eof = 1;
+	return len;
+}
+
+static int rtl_proc_get_bb_a(char *page, char **start,
+		off_t offset, int count, int *eof, void *data)
+{
+	struct ieee80211_hw *hw = data;
+	int len = 0;
+	int i, n, page0;
+	int max = 0xff;
+	page0 = 0xa00;
+
+	for (n = 0; n <= max; ) {
+		len += snprintf(page + len, count - len, "\n%#8.8x  ",
+				n + page0);
+		for (i = 0; i < 4 && n <= max; n += 4, i++)
+			len += snprintf(page + len, count - len,
+					"%8.8x     ",
+					rtl_get_bbreg(hw, (page0 | n),
+						      0xffffffff));
+	}
+
+	len += snprintf(page + len, count - len, "\n");
+	*eof = 1;
+	return len;
+}
+
+static int rtl_proc_get_bb_b(char *page, char **start,
+		off_t offset, int count, int *eof, void *data)
+{
+	struct ieee80211_hw *hw = data;
+	int len = 0;
+	int i, n, page0;
+	int max = 0xff;
+	page0 = 0xb00;
+
+	for (n = 0; n <= max; ) {
+		len += snprintf(page + len, count - len, "\n%#8.8x  ",
+				n + page0);
+		for (i = 0; i < 4 && n <= max; n += 4, i++)
+			len += snprintf(page + len, count - len,
+					"%8.8x     ",
+					rtl_get_bbreg(hw, (page0 | n),
+						      0xffffffff));
+	}
+
+	len += snprintf(page + len, count - len, "\n");
+	*eof = 1;
+	return len;
+}
+static int rtl_proc_get_bb_c(char *page, char **start,
+		off_t offset, int count, int *eof, void *data)
+{
+	struct ieee80211_hw *hw = data;
+	int len = 0;
+	int i, n, page0;
+	int max = 0xff;
+	page0 = 0xc00;
+
+	for (n = 0; n <= max; ) {
+		len += snprintf(page + len, count - len, "\n%#8.8x  ",
+				n + page0);
+		for (i = 0; i < 4 && n <= max; n += 4, i++)
+			len += snprintf(page + len, count - len,
+					"%8.8x     ",
+					rtl_get_bbreg(hw, (page0 | n),
+						      0xffffffff));
+	}
+
+	len += snprintf(page + len, count - len, "\n");
+	*eof = 1;
+	return len;
+}
+static int rtl_proc_get_bb_d(char *page, char **start,
+		off_t offset, int count, int *eof, void *data)
+{
+	struct ieee80211_hw *hw = data;
+	int len = 0;
+	int i, n, page0;
+	int max = 0xff;
+	page0 = 0xd00;
+
+	for (n = 0; n <= max; ) {
+		len += snprintf(page + len, count - len, "\n%#8.8x  ",
+				n + page0);
+		for (i = 0; i < 4 && n <= max; n += 4, i++)
+			len += snprintf(page + len, count - len,
+					"%8.8x     ",
+					rtl_get_bbreg(hw, (page0 | n),
+						      0xffffffff));
+	}
+
+	len += snprintf(page + len, count - len, "\n");
+	*eof = 1;
+	return len;
+}
+
+static int rtl_proc_get_bb_e(char *page, char **start,
+		off_t offset, int count, int *eof, void *data)
+{
+	struct ieee80211_hw *hw = data;
+	int len = 0;
+	int i, n, page0;
+	int max = 0xff;
+	page0 = 0xe00;
+
+	for (n = 0; n <= max; ) {
+		len += snprintf(page + len, count - len, "\n%#8.8x  ",
+				n + page0);
+		for (i = 0; i < 4 && n <= max; n += 4, i++)
+			len += snprintf(page + len, count - len,
+					"%8.8x     ",
+					rtl_get_bbreg(hw, (page0 | n),
+						      0xffffffff));
+	}
+
+	len += snprintf(page + len, count - len, "\n");
+	*eof = 1;
+	return len;
+}
+
+static int rtl_proc_get_bb_f(char *page, char **start,
+		off_t offset, int count, int *eof, void *data)
+{
+	struct ieee80211_hw *hw = data;
+	int len = 0;
+	int i, n, page0;
+	int max = 0xff;
+	page0 = 0xf00;
+
+	for (n = 0; n <= max; ) {
+		len += snprintf(page + len, count - len, "\n%#8.8x  ",
+				n + page0);
+		for (i = 0; i < 4 && n <= max; n += 4, i++)
+			len += snprintf(page + len, count - len,
+					"%8.8x     ",
+					rtl_get_bbreg(hw, (page0 | n),
+						      0xffffffff));
+	}
+
+	len += snprintf(page + len, count - len, "\n");
+	*eof = 1;
+	return len;
+}
+
+static int rtl_proc_get_reg_rf_a(char *page, char **start,
+		off_t offset, int count, int *eof, void *data)
+{
+	struct ieee80211_hw *hw = data;
+	int len = 0;
+	int i, n;
+	int max = 0x40;
+
+	for (n = 0; n <= max; ) {
+		len += snprintf(page + len, count - len, "\n%#8.8x  ", n);
+		for (i = 0; i < 4 && n <= max; n += 1, i++)
+			len += snprintf(page + len, count - len,
+				"%8.8x     ",
+				rtl_get_rfreg(hw, RF90_PATH_A, n,
+					      0xffffffff));
+	}
+
+	len += snprintf(page + len, count - len, "\n");
+	*eof = 1;
+	return len;
+}
+
+static int rtl_proc_get_reg_rf_b(char *page, char **start,
+		off_t offset, int count, int *eof, void *data)
+{
+	struct ieee80211_hw *hw = data;
+	int len = 0;
+	int i, n;
+	int max = 0x40;
+
+	for (n = 0; n <= max; ) {
+		len += snprintf(page + len, count - len, "\n%#8.8x  ", n);
+		for (i = 0; i < 4 && n <= max; n += 1, i++)
+			len += snprintf(page + len, count - len,
+					"%8.8x     ",
+					rtl_get_rfreg(hw, RF90_PATH_B, n,
+						      0xffffffff));
+	}
+
+	len += snprintf(page + len, count - len, "\n");
+	*eof = 1;
+	return len;
+}
+
+static int rtl_proc_get_cam_register_1(char *page, char **start,
+		off_t offset, int count, int *eof, void *data)
+{
+	struct ieee80211_hw *hw = data;
+	struct rtl_priv *rtlpriv = rtl_priv(hw);
+	u32 target_cmd = 0;
+	u32 target_val = 0;
+	u8 entry_i = 0;
+	u32 ulstatus;
+	int len = 0;
+	int i = 100, j = 0;
+
+	/* This dump the current register page */
+	len += snprintf(page + len, count - len,
+		"\n################# SECURITY CAM (0-10) ################\n ");
+
+	for (j = 0; j < 11; j++) {
+		len += snprintf(page + len, count - len, "\nD:  %2x > ", j);
+		for (entry_i = 0; entry_i < CAM_CONTENT_COUNT; entry_i++) {
+			/* polling bit, and No Write enable, and address  */
+			target_cmd = entry_i + CAM_CONTENT_COUNT * j;
+			target_cmd = target_cmd | BIT(31);
+
+			/* Check polling bit is clear */
+			while ((i--) >= 0) {
+				ulstatus = rtl_read_dword(rtlpriv,
+						rtlpriv->cfg->maps[RWCAM]);
+				if (ulstatus & BIT(31))
+					continue;
+				else
+					break;
+			}
+
+			rtl_write_dword(rtlpriv, rtlpriv->cfg->maps[RWCAM],
+					target_cmd);
+			target_val = rtl_read_dword(rtlpriv,
+					rtlpriv->cfg->maps[RCAMO]);
+			len += snprintf(page + len, count - len, "%8.8x ",
+					target_val);
+		}
+	}
+
+	len += snprintf(page + len, count - len, "\n");
+	*eof = 1;
+	return len;
+}
+
+static int rtl_proc_get_cam_register_2(char *page, char **start,
+		off_t offset, int count, int *eof, void *data)
+{
+	struct ieee80211_hw *hw = data;
+	struct rtl_priv *rtlpriv = rtl_priv(hw);
+	u32 target_cmd = 0;
+	u32 target_val = 0;
+	u8 entry_i = 0;
+	u32 ulstatus;
+	int len = 0;
+	int i = 100, j = 0;
+
+	/* This dump the current register page */
+	len += snprintf(page + len, count - len,
+		"\n################# SECURITY CAM (11-21) ###############\n ");
+
+	for (j = 11; j < 22; j++) {
+		len += snprintf(page + len, count - len, "\nD:  %2x > ", j);
+		for (entry_i = 0; entry_i < CAM_CONTENT_COUNT; entry_i++) {
+			target_cmd = entry_i + CAM_CONTENT_COUNT * j;
+			target_cmd = target_cmd | BIT(31);
+
+			while ((i--) >= 0) {
+				ulstatus = rtl_read_dword(rtlpriv,
+						 rtlpriv->cfg->maps[RWCAM]);
+				if (ulstatus & BIT(31))
+					continue;
+				else
+					break;
+			}
+
+			rtl_write_dword(rtlpriv,
+					rtlpriv->cfg->maps[RWCAM], target_cmd);
+			target_val = rtl_read_dword(rtlpriv,
+					rtlpriv->cfg->maps[RCAMO]);
+			len += snprintf(page + len, count - len, "%8.8x ",
+					target_val);
+		}
+	}
+
+	len += snprintf(page + len, count - len, "\n");
+	*eof = 1;
+	return len;
+}
+
+static int rtl_proc_get_cam_register_3(char *page, char **start,
+		off_t offset, int count, int *eof, void *data)
+{
+	struct ieee80211_hw *hw = data;
+	struct rtl_priv *rtlpriv = rtl_priv(hw);
+	u32 target_cmd = 0;
+	u32 target_val = 0;
+	u8 entry_i = 0;
+	u32 ulstatus;
+	int len = 0;
+	int i = 100, j = 0;
+
+	/* This dump the current register page */
+	len += snprintf(page + len, count - len,
+		"\n################## SECURITY CAM (22-31) ##############\n ");
+
+	for (j = 22; j < TOTAL_CAM_ENTRY; j++) {
+		len += snprintf(page + len, count - len, "\nD:  %2x > ", j);
+		for (entry_i = 0; entry_i < CAM_CONTENT_COUNT; entry_i++) {
+			target_cmd = entry_i+CAM_CONTENT_COUNT*j;
+			target_cmd = target_cmd | BIT(31);
+
+			while ((i--) >= 0) {
+				ulstatus = rtl_read_dword(rtlpriv,
+						rtlpriv->cfg->maps[RWCAM]);
+				if (ulstatus & BIT(31))
+					continue;
+				else
+					break;
+			}
+
+			rtl_write_dword(rtlpriv, rtlpriv->cfg->maps[RWCAM],
+					target_cmd);
+			target_val = rtl_read_dword(rtlpriv,
+						    rtlpriv->cfg->maps[RCAMO]);
+			len += snprintf(page + len, count - len,
+					"%8.8x ", target_val);
+		}
+	}
+
+	len += snprintf(page + len, count - len, "\n");
+	*eof = 1;
+	return len;
+}
+
+void rtl_proc_add_one(struct ieee80211_hw *hw)
+{
+	struct rtl_priv *rtlpriv = rtl_priv(hw);
+	struct rtl_efuse *rtlefuse = rtl_efuse(rtl_priv(hw));
+	struct proc_dir_entry *entry;
+
+	snprintf(rtlpriv->dbg.proc_name, 18, "%x-%x-%x-%x-%x-%x",
+		rtlefuse->dev_addr[0], rtlefuse->dev_addr[1],
+		rtlefuse->dev_addr[2], rtlefuse->dev_addr[3],
+		rtlefuse->dev_addr[4], rtlefuse->dev_addr[5]);
+
+	rtlpriv->dbg.proc_dir = create_proc_entry(rtlpriv->dbg.proc_name,
+		S_IFDIR | S_IRUGO | S_IXUGO, proc_topdir);
+	if (!rtlpriv->dbg.proc_dir) {
+		RT_TRACE(rtlpriv, COMP_INIT, DBG_EMERG, ("Unable to init "
+			"/proc/net/%s/%s\n", rtlpriv->cfg->name,
+			rtlpriv->dbg.proc_name));
+		return;
+	}
+
+	entry = create_proc_read_entry("mac-0", S_IFREG | S_IRUGO,
+				   rtlpriv->dbg.proc_dir,
+				   rtl_proc_get_mac_0, hw);
+	if (!entry)
+		RT_TRACE(rtlpriv, COMP_INIT, DBG_EMERG, ("Unable to initialize "
+		      "/proc/net/%s/%s/mac-0\n",
+		      rtlpriv->cfg->name, rtlpriv->dbg.proc_name));
+
+	entry = create_proc_read_entry("mac-1", S_IFREG | S_IRUGO,
+				   rtlpriv->dbg.proc_dir,
+				   rtl_proc_get_mac_1, hw);
+	if (!entry)
+		RT_TRACE(rtlpriv, COMP_INIT, COMP_ERR, ("Unable to initialize "
+		      "/proc/net/%s/%s/mac-1\n",
+		      rtlpriv->cfg->name, rtlpriv->dbg.proc_name));
+
+	entry = create_proc_read_entry("mac-2", S_IFREG | S_IRUGO,
+				   rtlpriv->dbg.proc_dir,
+				   rtl_proc_get_mac_2, hw);
+	if (!entry)
+		RT_TRACE(rtlpriv, COMP_INIT, COMP_ERR, ("Unable to initialize "
+		      "/proc/net/%s/%s/mac-2\n",
+		      rtlpriv->cfg->name, rtlpriv->dbg.proc_name));
+
+	entry = create_proc_read_entry("mac-3", S_IFREG | S_IRUGO,
+				   rtlpriv->dbg.proc_dir,
+				   rtl_proc_get_mac_3, hw);
+	if (!entry)
+		RT_TRACE(rtlpriv, COMP_INIT, COMP_ERR, ("Unable to initialize "
+		      "/proc/net/%s/%s/mac-3\n",
+		      rtlpriv->cfg->name, rtlpriv->dbg.proc_name));
+
+	entry = create_proc_read_entry("mac-4", S_IFREG | S_IRUGO,
+				   rtlpriv->dbg.proc_dir,
+				   rtl_proc_get_mac_4, hw);
+	if (!entry)
+		RT_TRACE(rtlpriv, COMP_INIT, COMP_ERR, ("Unable to initialize "
+		      "/proc/net/%s/%s/mac-4\n",
+		      rtlpriv->cfg->name, rtlpriv->dbg.proc_name));
+
+	entry = create_proc_read_entry("mac-5", S_IFREG | S_IRUGO,
+				   rtlpriv->dbg.proc_dir,
+				   rtl_proc_get_mac_5, hw);
+	if (!entry)
+		RT_TRACE(rtlpriv, COMP_INIT, COMP_ERR, ("Unable to initialize "
+		      "/proc/net/%s/%s/mac-5\n",
+		      rtlpriv->cfg->name, rtlpriv->dbg.proc_name));
+
+	entry = create_proc_read_entry("mac-6", S_IFREG | S_IRUGO,
+				   rtlpriv->dbg.proc_dir,
+				   rtl_proc_get_mac_6, hw);
+	if (!entry)
+		RT_TRACE(rtlpriv, COMP_INIT, COMP_ERR, ("Unable to initialize "
+		      "/proc/net/%s/%s/mac-6\n",
+		      rtlpriv->cfg->name, rtlpriv->dbg.proc_name));
+
+	entry = create_proc_read_entry("mac-7", S_IFREG | S_IRUGO,
+				   rtlpriv->dbg.proc_dir,
+				   rtl_proc_get_mac_7, hw);
+	if (!entry)
+		RT_TRACE(rtlpriv, COMP_INIT, COMP_ERR, ("Unable to initialize "
+		      "/proc/net/%s/%s/mac-7\n",
+		      rtlpriv->cfg->name, rtlpriv->dbg.proc_name));
+
+	entry = create_proc_read_entry("bb-8", S_IFREG | S_IRUGO,
+				   rtlpriv->dbg.proc_dir,
+				   rtl_proc_get_bb_8, hw);
+	if (!entry)
+		RT_TRACE(rtlpriv, COMP_INIT, COMP_ERR, ("Unable to initialize "
+		      "/proc/net/%s/%s/bb-8\n",
+		      rtlpriv->cfg->name, rtlpriv->dbg.proc_name));
+
+	entry = create_proc_read_entry("bb-9", S_IFREG | S_IRUGO,
+				  rtlpriv->dbg.proc_dir,
+				  rtl_proc_get_bb_9, hw);
+	if (!entry)
+		RT_TRACE(rtlpriv, COMP_INIT, COMP_ERR, ("Unable to initialize "
+		      "/proc/net/%s/%s/bb-9\n",
+		      rtlpriv->cfg->name, rtlpriv->dbg.proc_name));
+
+	entry = create_proc_read_entry("bb-a", S_IFREG | S_IRUGO,
+				  rtlpriv->dbg.proc_dir, rtl_proc_get_bb_a, hw);
+	if (!entry)
+		RT_TRACE(rtlpriv, COMP_INIT, COMP_ERR, ("Unable to initialize "
+		      "/proc/net/%s/%s/bb-a\n",
+		      rtlpriv->cfg->name, rtlpriv->dbg.proc_name));
+
+	entry = create_proc_read_entry("bb-b", S_IFREG | S_IRUGO,
+				  rtlpriv->dbg.proc_dir, rtl_proc_get_bb_b, hw);
+	if (!entry)
+		RT_TRACE(rtlpriv, COMP_INIT, COMP_ERR, ("Unable to initialize "
+		      "/proc/net/%s/%s/bb-b\n",
+		      rtlpriv->cfg->name, rtlpriv->dbg.proc_name));
+
+	entry = create_proc_read_entry("bb-c", S_IFREG | S_IRUGO,
+				  rtlpriv->dbg.proc_dir, rtl_proc_get_bb_c, hw);
+	if (!entry)
+		RT_TRACE(rtlpriv, COMP_INIT, COMP_ERR, ("Unable to initialize "
+		      "/proc/net/%s/%s/bb-c\n",
+		      rtlpriv->cfg->name, rtlpriv->dbg.proc_name));
+
+	entry = create_proc_read_entry("bb-d", S_IFREG | S_IRUGO,
+				  rtlpriv->dbg.proc_dir, rtl_proc_get_bb_d, hw);
+	if (!entry)
+		RT_TRACE(rtlpriv, COMP_INIT, COMP_ERR, ("Unable to initialize "
+		      "/proc/net/%s/%s/bb-d\n",
+		      rtlpriv->cfg->name, rtlpriv->dbg.proc_name));
+
+	entry = create_proc_read_entry("bb-e", S_IFREG | S_IRUGO,
+				  rtlpriv->dbg.proc_dir, rtl_proc_get_bb_e, hw);
+	if (!entry)
+		RT_TRACE(rtlpriv, COMP_INIT, COMP_ERR, ("Unable to initialize "
+		      "/proc/net/%s/%s/bb-e\n",
+		      rtlpriv->cfg->name, rtlpriv->dbg.proc_name));
+
+	entry = create_proc_read_entry("bb-f", S_IFREG | S_IRUGO,
+				  rtlpriv->dbg.proc_dir, rtl_proc_get_bb_f, hw);
+	if (!entry)
+		RT_TRACE(rtlpriv, COMP_INIT, COMP_ERR, ("Unable to initialize "
+		      "/proc/net/%s/%s/bb-f\n",
+		      rtlpriv->cfg->name, rtlpriv->dbg.proc_name));
+
+	entry = create_proc_read_entry("rf-a", S_IFREG | S_IRUGO,
+				  rtlpriv->dbg.proc_dir,
+				  rtl_proc_get_reg_rf_a, hw);
+	if (!entry)
+		RT_TRACE(rtlpriv, COMP_INIT, COMP_ERR, ("Unable to initialize "
+		      "/proc/net/%s/%s/rf-a\n",
+		      rtlpriv->cfg->name, rtlpriv->dbg.proc_name));
+
+	entry = create_proc_read_entry("rf-b", S_IFREG | S_IRUGO,
+				   rtlpriv->dbg.proc_dir,
+				   rtl_proc_get_reg_rf_b, hw);
+	if (!entry)
+		RT_TRACE(rtlpriv, COMP_INIT, COMP_ERR, ("Unable to initialize "
+		      "/proc/net/%s/%s/rf-b\n",
+		      rtlpriv->cfg->name, rtlpriv->dbg.proc_name));
+
+	entry = create_proc_read_entry("cam-1", S_IFREG | S_IRUGO,
+				   rtlpriv->dbg.proc_dir,
+				   rtl_proc_get_cam_register_1, hw);
+	if (!entry)
+		RT_TRACE(rtlpriv, COMP_INIT, COMP_ERR, ("Unable to initialize "
+		      "/proc/net/%s/%s/cam-1\n",
+		      rtlpriv->cfg->name, rtlpriv->dbg.proc_name));
+
+	entry = create_proc_read_entry("cam-2", S_IFREG | S_IRUGO,
+				   rtlpriv->dbg.proc_dir,
+				   rtl_proc_get_cam_register_2, hw);
+	if (!entry)
+		RT_TRACE(rtlpriv, COMP_INIT, COMP_ERR, ("Unable to initialize "
+		      "/proc/net/%s/%s/cam-2\n",
+		      rtlpriv->cfg->name, rtlpriv->dbg.proc_name));
+
+	entry = create_proc_read_entry("cam-3", S_IFREG | S_IRUGO,
+				   rtlpriv->dbg.proc_dir,
+				   rtl_proc_get_cam_register_3, hw);
+	if (!entry)
+		RT_TRACE(rtlpriv, COMP_INIT, COMP_ERR, ("Unable to initialize "
+		      "/proc/net/%s/%s/cam-3\n",
+		      rtlpriv->cfg->name, rtlpriv->dbg.proc_name));
+}
+
+void rtl_proc_remove_one(struct ieee80211_hw *hw)
+{
+	struct rtl_priv *rtlpriv = rtl_priv(hw);
+
+	if (rtlpriv->dbg.proc_dir) {
+		remove_proc_entry("mac-0", rtlpriv->dbg.proc_dir);
+		remove_proc_entry("mac-1", rtlpriv->dbg.proc_dir);
+		remove_proc_entry("mac-2", rtlpriv->dbg.proc_dir);
+		remove_proc_entry("mac-3", rtlpriv->dbg.proc_dir);
+		remove_proc_entry("mac-4", rtlpriv->dbg.proc_dir);
+		remove_proc_entry("mac-5", rtlpriv->dbg.proc_dir);
+		remove_proc_entry("mac-6", rtlpriv->dbg.proc_dir);
+		remove_proc_entry("mac-7", rtlpriv->dbg.proc_dir);
+		remove_proc_entry("bb-8", rtlpriv->dbg.proc_dir);
+		remove_proc_entry("bb-9", rtlpriv->dbg.proc_dir);
+		remove_proc_entry("bb-a", rtlpriv->dbg.proc_dir);
+		remove_proc_entry("bb-b", rtlpriv->dbg.proc_dir);
+		remove_proc_entry("bb-c", rtlpriv->dbg.proc_dir);
+		remove_proc_entry("bb-d", rtlpriv->dbg.proc_dir);
+		remove_proc_entry("bb-e", rtlpriv->dbg.proc_dir);
+		remove_proc_entry("bb-f", rtlpriv->dbg.proc_dir);
+		remove_proc_entry("rf-a", rtlpriv->dbg.proc_dir);
+		remove_proc_entry("rf-b", rtlpriv->dbg.proc_dir);
+		remove_proc_entry("cam-1", rtlpriv->dbg.proc_dir);
+		remove_proc_entry("cam-2", rtlpriv->dbg.proc_dir);
+		remove_proc_entry("cam-3", rtlpriv->dbg.proc_dir);
+
+		remove_proc_entry(rtlpriv->dbg.proc_name, proc_topdir);
+
+		rtlpriv->dbg.proc_dir = NULL;
+	}
+}
+
+void rtl_proc_add_topdir(void)
+{
+		proc_topdir = create_proc_entry("rtlwifi",
+			S_IFDIR, init_net.proc_net);
+}
+
+void rtl_proc_remove_topdir(void)
+{
+	if (proc_topdir)
+		remove_proc_entry("rtlwifi", init_net.proc_net);
+}
+
Index: wireless-testing/drivers/net/wireless/rtlwifi/debug.h
===================================================================
--- wireless-testing.orig/drivers/net/wireless/rtlwifi/debug.h
+++ wireless-testing/drivers/net/wireless/rtlwifi/debug.h
@@ -210,4 +210,9 @@ enum dbgp_flag_e {
 	((u8 *)(x))[3], ((u8 *)(x))[4], ((u8 *)(x))[5]
 
 void rtl_dbgp_flag_init(struct ieee80211_hw *hw);
+void rtl_proc_add_one(struct ieee80211_hw *hw);
+void rtl_proc_remove_one(struct ieee80211_hw *hw);
+void rtl_proc_add_topdir(void);
+void rtl_proc_remove_topdir(void);
+
 #endif
Index: wireless-testing/drivers/net/wireless/rtlwifi/efuse.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/rtlwifi/efuse.c
+++ wireless-testing/drivers/net/wireless/rtlwifi/efuse.c
@@ -52,8 +52,6 @@ static const struct efuse_map RTL8712_SD
 	{11, 0, 0, 28}
 };
 
-static void read_efuse_byte(struct ieee80211_hw *hw, u16 _offset,
-					u8 *pbuf);
 static void efuse_shadow_read_1byte(struct ieee80211_hw *hw, u16 offset,
 				    u8 *value);
 static void efuse_shadow_read_2byte(struct ieee80211_hw *hw, u16 offset,
@@ -115,8 +113,10 @@ u8 efuse_read_1byte(struct ieee80211_hw
 	u8 bytetemp;
 	u8 temp;
 	u32 k = 0;
+	const u32 efuse_real_content_len =
+		rtlpriv->cfg->maps[EFUSE_REAL_CONTENT_SIZE];
 
-	if (address < EFUSE_REAL_CONTENT_LEN) {
+	if (address < efuse_real_content_len) {
 		temp = address & 0xFF;
 		rtl_write_byte(rtlpriv, rtlpriv->cfg->maps[EFUSE_CTRL] + 1,
 			       temp);
@@ -158,11 +158,13 @@ void efuse_write_1byte(struct ieee80211_
 	u8 bytetemp;
 	u8 temp;
 	u32 k = 0;
+	const u32 efuse_real_content_len =
+		rtlpriv->cfg->maps[EFUSE_REAL_CONTENT_SIZE];
 
 	RT_TRACE(rtlpriv, COMP_EFUSE, DBG_LOUD,
 		 ("Addr=%x Data =%x\n", address, value));
 
-	if (address < EFUSE_REAL_CONTENT_LEN) {
+	if (address < efuse_real_content_len) {
 		rtl_write_byte(rtlpriv, rtlpriv->cfg->maps[EFUSE_CTRL], value);
 
 		temp = address & 0xFF;
@@ -198,7 +200,7 @@ void efuse_write_1byte(struct ieee80211_
 
 }
 
-static void read_efuse_byte(struct ieee80211_hw *hw, u16 _offset, u8 *pbuf)
+void read_efuse_byte(struct ieee80211_hw *hw, u16 _offset, u8 *pbuf)
 {
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
 	u32 value32;
@@ -239,18 +241,22 @@ void read_efuse(struct ieee80211_hw *hw,
 	u8 offset, wren;
 	u16 i;
 	u16 j;
+	const u16 efuse_max_section =
+		rtlpriv->cfg->maps[EFUSE_MAX_SECTION_MAP];
+	const u32 efuse_real_content_len =
+		rtlpriv->cfg->maps[EFUSE_REAL_CONTENT_SIZE];
 	u16 efuse_word[EFUSE_MAX_SECTION][EFUSE_MAX_WORD_UNIT];
 	u16 efuse_utilized = 0;
 	u8 efuse_usage;
 
-	if ((_offset + _size_byte) > EFUSE_MAP_LEN) {
+	if ((_offset + _size_byte) > rtlpriv->cfg->maps[EFUSE_HWSET_MAX_SIZE]) {
 		RT_TRACE(rtlpriv, COMP_EFUSE, DBG_LOUD,
 			 ("read_efuse(): Invalid offset(%#x) with read "
 			  "bytes(%#x)!!\n", _offset, _size_byte));
 		return;
 	}
 
-	for (i = 0; i < EFUSE_MAX_SECTION; i++)
+	for (i = 0; i < efuse_max_section; i++)
 		for (j = 0; j < EFUSE_MAX_WORD_UNIT; j++)
 			efuse_word[i][j] = 0xFFFF;
 
@@ -262,10 +268,10 @@ void read_efuse(struct ieee80211_hw *hw,
 		efuse_addr++;
 	}
 
-	while ((*rtemp8 != 0xFF) && (efuse_addr < EFUSE_REAL_CONTENT_LEN)) {
+	while ((*rtemp8 != 0xFF) && (efuse_addr < efuse_real_content_len)) {
 		offset = ((*rtemp8 >> 4) & 0x0f);
 
-		if (offset < EFUSE_MAX_SECTION) {
+		if (offset < efuse_max_section) {
 			wren = (*rtemp8 & 0x0f);
 			RTPRINT(rtlpriv, FEEPROM, EFUSE_READ_ALL,
 				("offset-%d Worden=%x\n", offset, wren));
@@ -281,7 +287,8 @@ void read_efuse(struct ieee80211_hw *hw,
 					efuse_utilized++;
 					efuse_word[offset][i] = (*rtemp8 & 0xff);
 
-					if (efuse_addr >= EFUSE_REAL_CONTENT_LEN)
+					if (efuse_addr >=
+					    efuse_real_content_len)
 						break;
 
 					RTPRINT(rtlpriv, FEEPROM,
@@ -294,7 +301,8 @@ void read_efuse(struct ieee80211_hw *hw,
 					efuse_word[offset][i] |=
 					    (((u16)*rtemp8 << 8) & 0xff00);
 
-					if (efuse_addr >= EFUSE_REAL_CONTENT_LEN)
+					if (efuse_addr >=
+					    efuse_real_content_len)
 						break;
 				}
 
@@ -305,13 +313,13 @@ void read_efuse(struct ieee80211_hw *hw,
 		RTPRINT(rtlpriv, FEEPROM, EFUSE_READ_ALL,
 			("Addr=%d\n", efuse_addr));
 		read_efuse_byte(hw, efuse_addr, rtemp8);
-		if (*rtemp8 != 0xFF && (efuse_addr < 512)) {
+		if (*rtemp8 != 0xFF && (efuse_addr < efuse_real_content_len)) {
 			efuse_utilized++;
 			efuse_addr++;
 		}
 	}
 
-	for (i = 0; i < EFUSE_MAX_SECTION; i++) {
+	for (i = 0; i < efuse_max_section; i++) {
 		for (j = 0; j < EFUSE_MAX_WORD_UNIT; j++) {
 			efuse_tbl[(i * 8) + (j * 2)] =
 			    (efuse_word[i][j] & 0xff);
@@ -324,7 +332,7 @@ void read_efuse(struct ieee80211_hw *hw,
 		pbuf[i] = efuse_tbl[_offset + i];
 
 	rtlefuse->efuse_usedbytes = efuse_utilized;
-	efuse_usage = (u8)((efuse_utilized * 100) / EFUSE_REAL_CONTENT_LEN);
+	efuse_usage = (u8) ((efuse_utilized * 100) / efuse_real_content_len);
 	rtlefuse->efuse_usedpercentage = efuse_usage;
 	rtlpriv->cfg->ops->set_hw_reg(hw, HW_VAR_EFUSE_BYTES,
 				      (u8 *)&efuse_utilized);
@@ -338,11 +346,11 @@ bool efuse_shadow_update_chk(struct ieee
 	struct rtl_efuse *rtlefuse = rtl_efuse(rtl_priv(hw));
 	u8 section_idx, i, Base;
 	u16 words_need = 0, hdr_num = 0, totalbytes, efuse_used;
-	bool wordchanged, result = true;
+	bool bwordchanged, result = true;
 
 	for (section_idx = 0; section_idx < 16; section_idx++) {
 		Base = section_idx * 8;
-		wordchanged = false;
+		bwordchanged = false;
 
 		for (i = 0; i < 8; i = i + 2) {
 			if ((rtlefuse->efuse_map[EFUSE_INIT_MAP][Base + i] !=
@@ -351,11 +359,11 @@ bool efuse_shadow_update_chk(struct ieee
 			     rtlefuse->efuse_map[EFUSE_MODIFY_MAP][Base + i +
 								   1])) {
 				words_need++;
-				wordchanged = true;
+				bwordchanged = true;
 			}
 		}
 
-		if (wordchanged == true)
+		if (bwordchanged == true)
 			hdr_num++;
 	}
 
@@ -394,7 +402,7 @@ void efuse_shadow_write(struct ieee80211
 	else if (type == 2)
 		efuse_shadow_write_2byte(hw, offset, (u16) value);
 	else if (type == 4)
-		efuse_shadow_write_4byte(hw, offset, value);
+		efuse_shadow_write_4byte(hw, offset, (u32) value);
 
 }
 
@@ -478,15 +486,15 @@ void rtl_efuse_shadow_map_update(struct
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
 	struct rtl_efuse *rtlefuse = rtl_efuse(rtl_priv(hw));
 
-	if (rtlefuse->autoload_failflag == true) {
-		memset((void *)(&rtlefuse->efuse_map[EFUSE_INIT_MAP][0]), 128,
-		       0xFF);
-	} else
+	if (rtlefuse->autoload_failflag == true)
+		memset((void *)(&rtlefuse->efuse_map[EFUSE_INIT_MAP][0]),
+			rtlpriv->cfg->maps[EFUSE_HWSET_MAX_SIZE], 0xFF);
+	else
 		efuse_read_all_map(hw, &rtlefuse->efuse_map[EFUSE_INIT_MAP][0]);
 
 	memcpy((void *)&rtlefuse->efuse_map[EFUSE_MODIFY_MAP][0],
-	       (void *)&rtlefuse->efuse_map[EFUSE_INIT_MAP][0],
-	       rtlpriv->cfg->maps[EFUSE_HWSET_MAX_SIZE]);
+			(void *)&rtlefuse->efuse_map[EFUSE_INIT_MAP][0],
+			rtlpriv->cfg->maps[EFUSE_HWSET_MAX_SIZE]);
 
 }
 EXPORT_SYMBOL(rtl_efuse_shadow_map_update);
@@ -605,6 +613,7 @@ static int efuse_one_byte_write(struct i
 {
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
 	u8 tmpidx = 0;
+	bool result;
 
 	RT_TRACE(rtlpriv, COMP_EFUSE, DBG_LOUD,
 		 ("Addr = %x Data=%x\n", addr, data));
@@ -626,15 +635,18 @@ static int efuse_one_byte_write(struct i
 	}
 
 	if (tmpidx < 100)
-		return true;
+		result = true;
+	else
+		result = false;
 
-	return false;
+	return result;
 }
 
-static void efuse_read_all_map(struct ieee80211_hw *hw, u8 * efuse)
+static void efuse_read_all_map(struct ieee80211_hw *hw, u8 *efuse)
 {
+	struct rtl_priv *rtlpriv = rtl_priv(hw);
 	efuse_power_switch(hw, false, true);
-	read_efuse(hw, 0, 128, efuse);
+	read_efuse(hw, 0, rtlpriv->cfg->maps[EFUSE_HWSET_MAX_SIZE], efuse);
 	efuse_power_switch(hw, false, false);
 }
 
@@ -655,16 +667,16 @@ static void efuse_read_data_case1(struct
 	if (hoffset == offset) {
 		for (tmpidx = 0; tmpidx < word_cnts * 2; tmpidx++) {
 			if (efuse_one_byte_read(hw, *efuse_addr + 1 + tmpidx,
-			    &efuse_data)) {
+				&efuse_data)) {
 				tmpdata[tmpidx] = efuse_data;
 				if (efuse_data != 0xff)
 					bdataempty = true;
 			}
 		}
 
-		if (bdataempty == true)
+		if (bdataempty == true) {
 			*readstate = PG_STATE_DATA;
-		else {
+		} else {
 			*efuse_addr = *efuse_addr + (word_cnts * 2) + 1;
 			*readstate = PG_STATE_HEADER;
 		}
@@ -683,6 +695,7 @@ static int efuse_pg_packet_read(struct i
 
 	u8 efuse_data, word_cnts = 0;
 	u16 efuse_addr = 0;
+	u8 hworden = 0;
 	u8 tmpdata[8];
 
 	if (data == NULL)
@@ -698,13 +711,12 @@ static int efuse_pg_packet_read(struct i
 			if (efuse_one_byte_read(hw, efuse_addr, &efuse_data)
 			    && (efuse_data != 0xFF))
 				efuse_read_data_case1(hw, &efuse_addr,
-						      efuse_data,
-						      offset, tmpdata,
-						      &readstate);
+						      efuse_data, offset,
+						      tmpdata, &readstate);
 			else
 				continual = false;
 		} else if (readstate & PG_STATE_DATA) {
-			efuse_word_enable_data_read(0, tmpdata, data);
+			efuse_word_enable_data_read(hworden, tmpdata, data);
 			efuse_addr = efuse_addr + (word_cnts * 2) + 1;
 			readstate = PG_STATE_HEADER;
 		}
@@ -722,13 +734,14 @@ static int efuse_pg_packet_read(struct i
 }
 
 static void efuse_write_data_case1(struct ieee80211_hw *hw, u16 *efuse_addr,
-			u8 efuse_data, u8 offset, int *continual,
-			u8 *write_state, struct pgpkt_struct *target_pkt,
-			int *repeat_times, int *result, u8 word_en)
+				u8 efuse_data, u8 offset, int *continual,
+				u8 *write_state,
+				struct pgpkt_struct *target_pkt,
+				int *repeat_times, int *result, u8 word_en)
 {
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
 	struct pgpkt_struct tmp_pkt;
-	bool dataempty = true;
+	int bdataempty = true;
 	u8 originaldata[8 * sizeof(u8)];
 	u8 badworden = 0x0F;
 	u8 match_word_en, tmp_word_en;
@@ -745,70 +758,69 @@ static void efuse_write_data_case1(struc
 		*write_state = PG_STATE_HEADER;
 	} else {
 		for (tmpindex = 0; tmpindex < (tmp_word_cnts * 2); tmpindex++) {
-			u16 address = *efuse_addr + 1 + tmpindex;
-			if (efuse_one_byte_read(hw, address,
-			     &efuse_data) && (efuse_data != 0xFF))
-				dataempty = false;
+			if (efuse_one_byte_read(hw, (*efuse_addr+1+tmpindex),
+				&efuse_data) && (efuse_data != 0xFF))
+				bdataempty = false;
 		}
 
-		if (dataempty == false) {
+		if (bdataempty == false) {
 			*efuse_addr = *efuse_addr + (tmp_word_cnts * 2) + 1;
 			*write_state = PG_STATE_HEADER;
 		} else {
 			match_word_en = 0x0F;
 			if (!((target_pkt->word_en & BIT(0)) |
-			     (tmp_pkt.word_en & BIT(0))))
+				(tmp_pkt.word_en & BIT(0))))
 				match_word_en &= (~BIT(0));
 
 			if (!((target_pkt->word_en & BIT(1)) |
-			     (tmp_pkt.word_en & BIT(1))))
+			       (tmp_pkt.word_en & BIT(1))))
 				match_word_en &= (~BIT(1));
 
 			if (!((target_pkt->word_en & BIT(2)) |
-			     (tmp_pkt.word_en & BIT(2))))
+			       (tmp_pkt.word_en & BIT(2))))
 				match_word_en &= (~BIT(2));
 
 			if (!((target_pkt->word_en & BIT(3)) |
-			     (tmp_pkt.word_en & BIT(3))))
+			       (tmp_pkt.word_en & BIT(3))))
 				match_word_en &= (~BIT(3));
 
 			if ((match_word_en & 0x0F) != 0x0F) {
-				badworden = efuse_word_enable_data_write(
-							    hw, *efuse_addr + 1,
-							    tmp_pkt.word_en,
-							    target_pkt->data);
+				badworden = efuse_word_enable_data_write(hw,
+					*efuse_addr + 1,
+					tmp_pkt.word_en, target_pkt->data);
 
-				if (0x0F != (badworden & 0x0F)) {
+				if (0x0F != (badworden & 0x0F))	{
 					u8 reorg_offset = offset;
 					u8 reorg_worden = badworden;
 					efuse_pg_packet_write(hw, reorg_offset,
-							       reorg_worden,
-							       originaldata);
+						reorg_worden, originaldata);
 				}
 
 				tmp_word_en = 0x0F;
 				if ((target_pkt->word_en & BIT(0)) ^
-				    (match_word_en & BIT(0)))
+				     (match_word_en & BIT(0)))
 					tmp_word_en &= (~BIT(0));
 
 				if ((target_pkt->word_en & BIT(1)) ^
-				    (match_word_en & BIT(1)))
+				     (match_word_en & BIT(1)))
 					tmp_word_en &= (~BIT(1));
 
 				if ((target_pkt->word_en & BIT(2)) ^
-					(match_word_en & BIT(2)))
+				     (match_word_en & BIT(2)))
 					tmp_word_en &= (~BIT(2));
 
 				if ((target_pkt->word_en & BIT(3)) ^
-				    (match_word_en & BIT(3)))
+				     (match_word_en & BIT(3)))
 					tmp_word_en &= (~BIT(3));
 
 				if ((tmp_word_en & 0x0F) != 0x0F) {
-					*efuse_addr = efuse_get_current_size(hw);
+					*efuse_addr =
+					    efuse_get_current_size(hw);
 					target_pkt->offset = offset;
 					target_pkt->word_en = tmp_word_en;
-				} else
+				} else {
 					*continual = false;
+				}
 				*write_state = PG_STATE_HEADER;
 				*repeat_times += 1;
 				if (*repeat_times > EFUSE_REPEAT_THRESHOLD_) {
@@ -843,9 +855,9 @@ static void efuse_write_data_case2(struc
 	efuse_one_byte_write(hw, *efuse_addr, pg_header);
 	efuse_one_byte_read(hw, *efuse_addr, &tmp_header);
 
-	if (tmp_header == pg_header)
+	if (tmp_header == pg_header) {
 		*write_state = PG_STATE_DATA;
-	else if (tmp_header == 0xFF) {
+	} else if (tmp_header == 0xFF) {
 		*write_state = PG_STATE_HEADER;
 		*repeat_times += 1;
 		if (*repeat_times > EFUSE_REPEAT_THRESHOLD_) {
@@ -858,25 +870,27 @@ static void efuse_write_data_case2(struc
 
 		tmp_word_cnts = efuse_calculate_word_cnts(tmp_pkt.word_en);
 
-		memset((void *)originaldata, 8 * sizeof(u8), 0xff);
+		memset((void *)originaldata,  8 * sizeof(u8), 0xff);
 
 		if (efuse_pg_packet_read(hw, tmp_pkt.offset, originaldata)) {
 			badworden = efuse_word_enable_data_write(hw,
-				    *efuse_addr + 1, tmp_pkt.word_en,
-				    originaldata);
+					 *efuse_addr + 1,
+					 tmp_pkt.word_en, originaldata);
 
 			if (0x0F != (badworden & 0x0F)) {
 				u8 reorg_offset = tmp_pkt.offset;
 				u8 reorg_worden = badworden;
 				efuse_pg_packet_write(hw, reorg_offset,
-						      reorg_worden,
-						      originaldata);
+					 reorg_worden,
+					 originaldata);
 				*efuse_addr = efuse_get_current_size(hw);
-			 } else
+			} else {
 				*efuse_addr = *efuse_addr + (tmp_word_cnts * 2)
 					      + 1;
-		} else
+			}
+		} else {
 			*efuse_addr = *efuse_addr + (tmp_word_cnts * 2) + 1;
+		}
 
 		*write_state = PG_STATE_HEADER;
 		*repeat_times += 1;
@@ -896,7 +910,7 @@ static int efuse_pg_packet_write(struct
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
 	struct pgpkt_struct target_pkt;
 	u8 write_state = PG_STATE_HEADER;
-	int continual = true, dataempty = true, result = true;
+	int continual = true, bdataempty = true, result = true;
 	u16 efuse_addr = 0;
 	u8 efuse_data;
 	u8 target_word_cnts = 0;
@@ -913,7 +927,7 @@ static int efuse_pg_packet_write(struct
 	target_pkt.offset = offset;
 	target_pkt.word_en = word_en;
 
-	memset((void *)target_pkt.data, 8 * sizeof(u8), 0xFF);
+	memset((void *)target_pkt.data,  8 * sizeof(u8), 0xFF);
 
 	efuse_word_enable_data_read(word_en, data, target_pkt.data);
 	target_word_cnts = efuse_calculate_word_cnts(target_pkt.word_en);
@@ -921,10 +935,10 @@ static int efuse_pg_packet_write(struct
 	RTPRINT(rtlpriv, FEEPROM, EFUSE_PG, ("efuse Power ON\n"));
 
 	while (continual && (efuse_addr <
-	       (EFUSE_MAX_SIZE - EFUSE_OOB_PROTECT_BYTES))) {
+			      (EFUSE_MAX_SIZE - EFUSE_OOB_PROTECT_BYTES))) {
 
 		if (write_state == PG_STATE_HEADER) {
-			dataempty = true;
+			bdataempty = true;
 			badworden = 0x0F;
 			RTPRINT(rtlpriv, FEEPROM, EFUSE_PG,
 				("efuse PG_STATE_HEADER\n"));
@@ -932,22 +946,23 @@ static int efuse_pg_packet_write(struct
 			if (efuse_one_byte_read(hw, efuse_addr, &efuse_data) &&
 			    (efuse_data != 0xFF))
 				efuse_write_data_case1(hw, &efuse_addr,
-						       efuse_data, offset,
-						       &continual,
-						       &write_state, &target_pkt,
-						       &repeat_times, &result,
-						       word_en);
+						     efuse_data, offset,
+						     &continual,
+						     &write_state, &target_pkt,
+						     &repeat_times, &result,
+						     word_en);
 			else
 				efuse_write_data_case2(hw, &efuse_addr,
-						       &continual,
-						       &write_state,
-						       target_pkt,
-						       &repeat_times,
-						       &result);
+						     &continual,
+						     &write_state,
+						     target_pkt,
+						     &repeat_times,
+						     &result);
 
 		} else if (write_state == PG_STATE_DATA) {
 			RTPRINT(rtlpriv, FEEPROM, EFUSE_PG,
 				("efuse PG_STATE_DATA\n"));
+			badworden = 0x0f;
 			badworden =
 			    efuse_word_enable_data_write(hw, efuse_addr + 1,
 							 target_pkt.word_en,
@@ -956,7 +971,8 @@ static int efuse_pg_packet_write(struct
 			if ((badworden & 0x0F) == 0x0F) {
 				continual = false;
 			} else {
-				efuse_addr += (2 * target_word_cnts) + 1;
+				efuse_addr =
+				    efuse_addr + (2 * target_word_cnts) + 1;
 
 				target_pkt.offset = offset;
 				target_pkt.word_en = badworden;
@@ -1067,13 +1083,15 @@ static u8 efuse_word_enable_data_write(s
 	return badworden;
 }
 
-static void efuse_power_switch(struct ieee80211_hw *hw, u8 write, u8 pwrstate)
+static void efuse_power_switch(struct ieee80211_hw *hw, u8 bwrite, u8 pwrstate)
 {
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
+	struct rtl_hal *rtlhal = rtl_hal(rtl_priv(hw));
 	u8 tempval;
 	u16 tmpV16;
 
-	if (pwrstate) {
+	if (pwrstate == true && (rtlhal->hw_type !=
+		HARDWARE_TYPE_RTL8192SE)) {
 		tmpV16 = rtl_read_word(rtlpriv,
 				       rtlpriv->cfg->maps[SYS_ISO_CTRL]);
 		if (!(tmpV16 & rtlpriv->cfg->maps[EFUSE_PWC_EV12V])) {
@@ -1101,20 +1119,29 @@ static void efuse_power_switch(struct ie
 		}
 	}
 
-	if (pwrstate) {
-		if (write) {
+	if (pwrstate == true) {
+		if (bwrite == true) {
 			tempval = rtl_read_byte(rtlpriv,
 						rtlpriv->cfg->maps[EFUSE_TEST] +
 						3);
-			tempval &= 0x0F;
-			tempval |= (VOLTAGE_V25 << 4);
+
+			if (rtlhal->hw_type != HARDWARE_TYPE_RTL8192SE) {
+				tempval &= 0x0F;
+				tempval |= (VOLTAGE_V25 << 4);
+			}
+
 			rtl_write_byte(rtlpriv,
 				       rtlpriv->cfg->maps[EFUSE_TEST] + 3,
 				       (tempval | 0x80));
 		}
 
+		if (rtlhal->hw_type == HARDWARE_TYPE_RTL8192SE) {
+			rtl_write_byte(rtlpriv, rtlpriv->cfg->maps[EFUSE_CLK],
+						0x03);
+		}
+
 	} else {
-		if (write) {
+		if (bwrite == true) {
 			tempval = rtl_read_byte(rtlpriv,
 						rtlpriv->cfg->maps[EFUSE_TEST] +
 						3);
@@ -1123,6 +1150,11 @@ static void efuse_power_switch(struct ie
 				       (tempval & 0x7F));
 		}
 
+		if (rtlhal->hw_type == HARDWARE_TYPE_RTL8192SE) {
+			rtl_write_byte(rtlpriv, rtlpriv->cfg->maps[EFUSE_CLK],
+						0x02);
+		}
+
 	}
 
 }
Index: wireless-testing/drivers/net/wireless/rtlwifi/ps.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/rtlwifi/ps.c
+++ wireless-testing/drivers/net/wireless/rtlwifi/ps.c
@@ -194,10 +194,10 @@ static void _rtl_ps_inactive_ps(struct i
 
 	if (ppsc->inactive_pwrstate == ERFON && rtlhal->interface == INTF_PCI) {
 		if ((ppsc->reg_rfps_level & RT_RF_OFF_LEVL_ASPM) &&
-		    RT_IN_PS_LEVEL(ppsc, RT_RF_OFF_LEVL_ASPM) &&
+		    RT_IN_PS_LEVEL(ppsc, RT_PS_LEVEL_ASPM) &&
 		    rtlhal->interface == INTF_PCI) {
 			rtlpriv->intf_ops->disable_aspm(hw);
-			RT_CLEAR_PS_LEVEL(ppsc, RT_RF_OFF_LEVL_ASPM);
+			RT_CLEAR_PS_LEVEL(ppsc, RT_PS_LEVEL_ASPM);
 		}
 	}
 
@@ -206,9 +206,10 @@ static void _rtl_ps_inactive_ps(struct i
 
 	if (ppsc->inactive_pwrstate == ERFOFF &&
 	    rtlhal->interface == INTF_PCI) {
-		if (ppsc->reg_rfps_level & RT_RF_OFF_LEVL_ASPM) {
+		if (ppsc->reg_rfps_level & RT_RF_OFF_LEVL_ASPM &&
+			!RT_IN_PS_LEVEL(ppsc, RT_PS_LEVEL_ASPM)) {
 			rtlpriv->intf_ops->enable_aspm(hw);
-			RT_SET_PS_LEVEL(ppsc, RT_RF_OFF_LEVL_ASPM);
+			RT_SET_PS_LEVEL(ppsc, RT_PS_LEVEL_ASPM);
 		}
 	}
 
@@ -232,6 +233,9 @@ void rtl_ips_nic_off_wq_callback(void *d
 		return;
 	}
 
+	if (mac->link_state > MAC80211_NOLINK)
+		return;
+
 	if (is_hal_stop(rtlhal))
 		return;
 
@@ -369,8 +373,7 @@ static void rtl_lps_set_psmode(struct ie
 	 *   mode and set RPWM to turn RF on.
 	 */
 
-	if ((ppsc->fwctrl_lps) && (ppsc->leisure_ps) &&
-	     ppsc->report_linked) {
+	if ((ppsc->fwctrl_lps) && ppsc->report_linked) {
 		bool fw_current_inps;
 		if (ppsc->dot11_psmode == EACTIVE) {
 			RT_TRACE(rtlpriv, COMP_RF, DBG_DMESG,
@@ -424,7 +427,7 @@ void rtl_lps_enter(struct ieee80211_hw *
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
 	unsigned long flag;
 
-	if (!(ppsc->fwctrl_lps && ppsc->leisure_ps))
+	if (!ppsc->fwctrl_lps)
 		return;
 
 	if (rtlpriv->sec.being_setkey)
@@ -445,15 +448,13 @@ void rtl_lps_enter(struct ieee80211_hw *
 
 	spin_lock_irqsave(&rtlpriv->locks.lps_lock, flag);
 
-	if (ppsc->leisure_ps) {
-		/* Idle for a while if we connect to AP a while ago. */
-		if (mac->cnt_after_linked >= 2) {
-			if (ppsc->dot11_psmode == EACTIVE) {
-				RT_TRACE(rtlpriv, COMP_POWER, DBG_LOUD,
-					("Enter 802.11 power save mode...\n"));
+	/* Idle for a while if we connect to AP a while ago. */
+	if (mac->cnt_after_linked >= 2) {
+		if (ppsc->dot11_psmode == EACTIVE) {
+			RT_TRACE(rtlpriv, COMP_POWER, DBG_LOUD,
+				("Enter 802.11 power save mode...\n"));
 
-				rtl_lps_set_psmode(hw, EAUTOPS);
-			}
+			rtl_lps_set_psmode(hw, EAUTOPS);
 		}
 	}
 	spin_unlock_irqrestore(&rtlpriv->locks.lps_lock, flag);
@@ -469,17 +470,17 @@ void rtl_lps_leave(struct ieee80211_hw *
 
 	spin_lock_irqsave(&rtlpriv->locks.lps_lock, flag);
 
-	if (ppsc->fwctrl_lps && ppsc->leisure_ps) {
+	if (ppsc->fwctrl_lps) {
 		if (ppsc->dot11_psmode != EACTIVE) {
 
 			/*FIX ME */
 			rtlpriv->cfg->ops->enable_interrupt(hw);
 
 			if (ppsc->reg_rfps_level & RT_RF_LPS_LEVEL_ASPM &&
-			    RT_IN_PS_LEVEL(ppsc, RT_RF_LPS_LEVEL_ASPM) &&
+			    RT_IN_PS_LEVEL(ppsc, RT_PS_LEVEL_ASPM) &&
 			    rtlhal->interface == INTF_PCI) {
 				rtlpriv->intf_ops->disable_aspm(hw);
-				RT_CLEAR_PS_LEVEL(ppsc, RT_RF_LPS_LEVEL_ASPM);
+				RT_CLEAR_PS_LEVEL(ppsc, RT_PS_LEVEL_ASPM);
 			}
 
 			RT_TRACE(rtlpriv, COMP_POWER, DBG_LOUD,
@@ -490,3 +491,211 @@ void rtl_lps_leave(struct ieee80211_hw *
 	}
 	spin_unlock_irqrestore(&rtlpriv->locks.lps_lock, flag);
 }
+
+/* For sw LPS*/
+void rtl_swlps_beacon(struct ieee80211_hw *hw, void *data, unsigned int len)
+{
+	struct rtl_priv *rtlpriv = rtl_priv(hw);
+	struct ieee80211_hdr *hdr = (void *) data;
+	struct ieee80211_tim_ie *tim_ie;
+	u8 *tim;
+	u8 tim_len;
+	bool u_buffed;
+	bool m_buffed;
+
+	if (!rtlpriv->psc.swctrl_lps)
+		return;
+
+	if (rtlpriv->mac80211.link_state != MAC80211_LINKED)
+		return;
+
+	if (!rtlpriv->psc.sw_ps_enabled)
+		return;
+
+	if (rtlpriv->psc.fwctrl_lps)
+		return;
+
+	if (likely(!(hw->conf.flags & IEEE80211_CONF_PS)))
+		return;
+
+	/* check if this really is a beacon */
+	if (!ieee80211_is_beacon(hdr->frame_control))
+		return;
+
+	/* min. beacon length + FCS_LEN */
+	if (len <= 40 + FCS_LEN)
+		return;
+
+	/* and only beacons from the associated BSSID, please */
+	if (compare_ether_addr(hdr->addr3, rtlpriv->mac80211.bssid))
+		return;
+
+	rtlpriv->psc.last_beacon = jiffies;
+
+	tim = rtl_find_ie(data, len - FCS_LEN, WLAN_EID_TIM);
+	if (!tim)
+		return;
+
+	if (tim[1] < sizeof(*tim_ie))
+		return;
+
+	tim_len = tim[1];
+	tim_ie = (struct ieee80211_tim_ie *) &tim[2];
+
+	if (!WARN_ON_ONCE(!hw->conf.ps_dtim_period))
+		rtlpriv->psc.dtim_counter = tim_ie->dtim_count;
+
+	/* Check whenever the PHY can be turned off again. */
+
+	/* 1. What about buffered unicast traffic for our AID? */
+	u_buffed = ieee80211_check_tim(tim_ie, tim_len,
+				       rtlpriv->mac80211.assoc_id);
+
+	/* 2. Maybe the AP wants to send multicast/broadcast data? */
+	m_buffed = tim_ie->bitmap_ctrl & 0x01;
+	rtlpriv->psc.multi_buffered = m_buffed;
+
+	/* unicast will process by mac80211 through
+	 * set ~IEEE80211_CONF_PS, So we just check
+	 * multicast frames here */
+	if (!m_buffed) {/*&&) {// !rtlpriv->psc.tx_doing) { */
+		/* back to low-power land. and delay is
+		 * prevent null power save frame tx fail */
+		queue_delayed_work(rtlpriv->works.rtl_wq,
+				&rtlpriv->works.ps_work, MSECS(5));
+	} else {
+		RT_TRACE(rtlpriv, COMP_POWER, DBG_DMESG, ("u_bufferd: %x, "
+				"m_buffered: %x\n", u_buffed, m_buffed));
+	}
+}
+
+void rtl_swlps_rf_awake(struct ieee80211_hw *hw)
+{
+	struct rtl_priv *rtlpriv = rtl_priv(hw);
+	struct rtl_ps_ctl *ppsc = rtl_psc(rtl_priv(hw));
+	struct rtl_mac *mac = rtl_mac(rtl_priv(hw));
+	unsigned long flag;
+
+	if (!rtlpriv->psc.swctrl_lps)
+		return;
+	if (mac->link_state != MAC80211_LINKED)
+		return;
+
+	if (ppsc->reg_rfps_level & RT_RF_LPS_LEVEL_ASPM &&
+		RT_IN_PS_LEVEL(ppsc, RT_PS_LEVEL_ASPM)) {
+		rtlpriv->intf_ops->disable_aspm(hw);
+		RT_CLEAR_PS_LEVEL(ppsc, RT_PS_LEVEL_ASPM);
+	}
+
+	spin_lock_irqsave(&rtlpriv->locks.lps_lock, flag);
+	rtl_ps_set_rf_state(hw, ERFON, RF_CHANGE_BY_PS, false);
+	spin_unlock_irqrestore(&rtlpriv->locks.lps_lock, flag);
+}
+
+void rtl_swlps_rfon_wq_callback(void *data)
+{
+	struct rtl_works *rtlworks =
+	    container_of_dwork_rtl(data, struct rtl_works, ps_rfon_wq);
+	struct ieee80211_hw *hw = rtlworks->hw;
+
+	rtl_swlps_rf_awake(hw);
+}
+
+void rtl_swlps_rf_sleep(struct ieee80211_hw *hw)
+{
+	struct rtl_priv *rtlpriv = rtl_priv(hw);
+	struct rtl_mac *mac = rtl_mac(rtl_priv(hw));
+	struct rtl_ps_ctl *ppsc = rtl_psc(rtl_priv(hw));
+	unsigned long flag;
+	u8 sleep_intv;
+
+	if (!rtlpriv->psc.sw_ps_enabled)
+		return;
+
+	if ((rtlpriv->sec.being_setkey) ||
+	    (mac->opmode == NL80211_IFTYPE_ADHOC))
+		return;
+
+	/*sleep after linked 10s, to let DHCP and 4-way handshake ok enough!! */
+	if ((mac->link_state != MAC80211_LINKED) || (mac->cnt_after_linked < 5))
+		return;
+
+	if (rtlpriv->link_info.busytraffic)
+		return;
+
+	spin_lock_irqsave(&rtlpriv->locks.rf_ps_lock, flag);
+	if (rtlpriv->psc.rfchange_inprogress) {
+		spin_unlock_irqrestore(&rtlpriv->locks.rf_ps_lock, flag);
+		return;
+	}
+	spin_unlock_irqrestore(&rtlpriv->locks.rf_ps_lock, flag);
+
+	spin_lock_irqsave(&rtlpriv->locks.lps_lock, flag);
+	rtl_ps_set_rf_state(hw, ERFSLEEP, RF_CHANGE_BY_PS, false);
+	spin_unlock_irqrestore(&rtlpriv->locks.lps_lock, flag);
+
+	if (ppsc->reg_rfps_level & RT_RF_OFF_LEVL_ASPM &&
+		!RT_IN_PS_LEVEL(ppsc, RT_PS_LEVEL_ASPM)) {
+		rtlpriv->intf_ops->enable_aspm(hw);
+		RT_SET_PS_LEVEL(ppsc, RT_PS_LEVEL_ASPM);
+	}
+
+	/* here is power save alg, when this beacon is DTIM
+	 * we will set sleep time to dtim_period * n;
+	 * when this beacon is not DTIM, we will set sleep
+	 * time to sleep_intv = rtlpriv->psc.dtim_counter or
+	 * MAX_SW_LPS_SLEEP_INTV(default set to 5) */
+
+	if (rtlpriv->psc.dtim_counter == 0) {
+		if (hw->conf.ps_dtim_period == 1)
+			sleep_intv = hw->conf.ps_dtim_period * 2;
+		else
+			sleep_intv = hw->conf.ps_dtim_period;
+	} else {
+		sleep_intv = rtlpriv->psc.dtim_counter;
+	}
+
+	if (sleep_intv > MAX_SW_LPS_SLEEP_INTV)
+		sleep_intv = MAX_SW_LPS_SLEEP_INTV;
+
+	/* this print should always be dtim_conter = 0 &
+	 * sleep  = dtim_period, that meaons, we should
+	 * awake before every dtim */
+	RT_TRACE(rtlpriv, COMP_POWER, DBG_DMESG,
+		 ("dtim_counter:%x will sleep :%d"
+		 " beacon_intv\n", rtlpriv->psc.dtim_counter, sleep_intv));
+
+	/* we tested that 40ms is enough for sw & hw sw delay */
+	queue_delayed_work(rtlpriv->works.rtl_wq, &rtlpriv->works.ps_rfon_wq,
+			MSECS(sleep_intv * mac->vif->bss_conf.beacon_int - 40));
+}
+
+
+void rtl_swlps_wq_callback(void *data)
+{
+	struct rtl_works *rtlworks = container_of_dwork_rtl(data,
+					 struct rtl_works,
+					 ps_work);
+	struct ieee80211_hw *hw = rtlworks->hw;
+	struct rtl_priv *rtlpriv = rtl_priv(hw);
+	bool ps = false;
+
+	ps = (hw->conf.flags & IEEE80211_CONF_PS);
+
+	/* we can sleep after ps null send ok */
+	if (rtlpriv->psc.state_inap) {
+		rtl_swlps_rf_sleep(hw);
+
+		if (rtlpriv->psc.state && !ps) {
+			rtlpriv->psc.sleep_ms = jiffies_to_msecs(jiffies -
+					rtlpriv->psc.last_action);
+		}
+
+		if (ps)
+			rtlpriv->psc.last_slept = jiffies;
+
+		rtlpriv->psc.last_action = jiffies;
+		rtlpriv->psc.state = ps;
+	}
+}
+
Index: wireless-testing/drivers/net/wireless/rtlwifi/ps.h
===================================================================
--- wireless-testing.orig/drivers/net/wireless/rtlwifi/ps.h
+++ wireless-testing/drivers/net/wireless/rtlwifi/ps.h
@@ -30,6 +30,8 @@
 #ifndef __REALTEK_RTL_PCI_PS_H__
 #define __REALTEK_RTL_PCI_PS_H__
 
+#define MAX_SW_LPS_SLEEP_INTV		5
+
 bool rtl_ps_set_rf_state(struct ieee80211_hw *hw,
 			 enum rf_pwrstate state_toset, u32 changesource,
 			 bool protect_or_not);
@@ -40,4 +42,10 @@ void rtl_ips_nic_on(struct ieee80211_hw
 void rtl_ips_nic_off_wq_callback(void *data);
 void rtl_lps_enter(struct ieee80211_hw *hw);
 void rtl_lps_leave(struct ieee80211_hw *hw);
+void rtl_swlps_beacon(struct ieee80211_hw *hw, void *data, unsigned int len);
+void rtl_swlps_wq_callback(void *data);
+void rtl_swlps_rfon_wq_callback(void *data);
+void rtl_swlps_rf_awake(struct ieee80211_hw *hw);
+void rtl_swlps_rf_sleep(struct ieee80211_hw *hw);
+
 #endif
Index: wireless-testing/drivers/net/wireless/rtlwifi/pci.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/rtlwifi/pci.c
+++ wireless-testing/drivers/net/wireless/rtlwifi/pci.c
@@ -32,6 +32,7 @@
 #include "pci.h"
 #include "base.h"
 #include "ps.h"
+#include "efuse.h"
 
 static const u16 pcibridge_vendors[PCI_BRIDGE_VENDOR_MAX] = {
 	INTEL_VENDOR_ID,
@@ -48,6 +49,7 @@ static void _rtl_pci_update_default_sett
 	struct rtl_ps_ctl *ppsc = rtl_psc(rtl_priv(hw));
 	struct rtl_pci *rtlpci = rtl_pcidev(rtl_pcipriv(hw));
 	u8 pcibridge_vendor = pcipriv->ndis_adapter.pcibridge_vendor;
+	u8 init_aspm;
 
 	ppsc->reg_rfps_level = 0;
 	ppsc->support_aspm = 0;
@@ -129,9 +131,16 @@ static void _rtl_pci_update_default_sett
 		break;
 	default:
 		RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG,
-			 ("switch case not process\n"));
+			 ("switch case not processed\n"));
 		break;
 	}
+
+	/* toshiba aspm issue, toshiba will set aspm selfly
+	 * so we should not set aspm in driver */
+	pci_read_config_byte(rtlpci->pdev, 0x80, &init_aspm);
+	if (rtlpriv->rtlhal.hw_type == HARDWARE_TYPE_RTL8192SE &&
+	    init_aspm == 0x43)
+		ppsc->support_aspm = false;
 }
 
 static bool _rtl_pci_platform_switch_device_pci_aspm(
@@ -139,8 +148,11 @@ static bool _rtl_pci_platform_switch_dev
 			u8 value)
 {
 	struct rtl_pci *rtlpci = rtl_pcidev(rtl_pcipriv(hw));
+	struct rtl_hal *rtlhal = rtl_hal(rtl_priv(hw));
+
+	if (rtlhal->hw_type != HARDWARE_TYPE_RTL8192SE)
+		value |= 0x40;
 
-	value |= 0x40;
 	pci_write_config_byte(rtlpci->pdev, 0x80, value);
 
 	return false;
@@ -150,10 +162,11 @@ static bool _rtl_pci_platform_switch_dev
 static bool _rtl_pci_switch_clk_req(struct ieee80211_hw *hw, u8 value)
 {
 	struct rtl_pci *rtlpci = rtl_pcidev(rtl_pcipriv(hw));
-	u8 buffer;
+	struct rtl_hal *rtlhal = rtl_hal(rtl_priv(hw));
 
-	buffer = value;
 	pci_write_config_byte(rtlpci->pdev, 0x81, value);
+	if (rtlhal->hw_type == HARDWARE_TYPE_RTL8192SE)
+		udelay(100);
 
 	return true;
 }
@@ -173,7 +186,10 @@ static void rtl_pci_disable_aspm(struct
 	u16 pcibridge_linkctrlreg = pcipriv->ndis_adapter.
 				pcibridge_linkctrlreg;
 	u16 aspmlevel = 0;
-	u8 tmp_u1b = 0;
+	u8 tmp = 0;
+
+	if (!ppsc->support_aspm)
+		return;
 
 	if (pcibridge_vendor == PCI_BRIDGE_VENDOR_UNKNOWN) {
 		RT_TRACE(rtlpriv, COMP_POWER, DBG_TRACE,
@@ -188,7 +204,7 @@ static void rtl_pci_disable_aspm(struct
 	}
 
 	/*for promising device will in L0 state after an I/O. */
-	pci_read_config_byte(rtlpci->pdev, 0x80, &tmp_u1b);
+	pci_read_config_byte(rtlpci->pdev, 0x80, &tmp);
 
 	/*Set corresponding value. */
 	aspmlevel |= BIT(0) | BIT(1);
@@ -228,6 +244,9 @@ static void rtl_pci_enable_aspm(struct i
 	u8 u_pcibridge_aspmsetting;
 	u8 u_device_aspmsetting;
 
+	if (!ppsc->support_aspm)
+		return;
+
 	if (pcibridge_vendor == PCI_BRIDGE_VENDOR_UNKNOWN) {
 		RT_TRACE(rtlpriv, COMP_POWER, DBG_TRACE,
 			 ("PCI(Bridge) UNKNOWN.\n"));
@@ -272,7 +291,7 @@ static void rtl_pci_enable_aspm(struct i
 					     RT_RF_OFF_LEVL_CLK_REQ) ? 1 : 0);
 		RT_SET_PS_LEVEL(ppsc, RT_RF_OFF_LEVL_CLK_REQ);
 	}
-	udelay(200);
+	udelay(100);
 }
 
 static bool rtl_pci_get_amd_l1_patch(struct ieee80211_hw *hw)
@@ -309,13 +328,13 @@ static void rtl_pci_get_linkcontrol_fiel
 	u8 capabilityoffset = pcipriv->ndis_adapter.pcibridge_pciehdr_offset;
 	u32 pcicfg_addrport = pcipriv->ndis_adapter.pcicfg_addrport;
 	u8 linkctrl_reg;
-	u8 num4bBytes;
+	u8 num4bbytes;
 
-	num4bBytes = (capabilityoffset + 0x10) / 4;
+	num4bbytes = (capabilityoffset + 0x10) / 4;
 
 	/*Read  Link Control Register */
 	rtl_pci_raw_write_port_ulong(PCI_CONF_ADDRESS,
-				     pcicfg_addrport + (num4bBytes << 2));
+				     pcicfg_addrport + (num4bbytes << 2));
 	rtl_pci_raw_read_port_uchar(PCI_CONF_DATA, &linkctrl_reg);
 
 	pcipriv->ndis_adapter.pcibridge_linkctrlreg = linkctrl_reg;
@@ -348,7 +367,7 @@ static void rtl_pci_parse_configuration(
 	pci_write_config_byte(pdev, 0x70f, tmp);
 }
 
-static void _rtl_pci_initialize_adapter_common(struct ieee80211_hw *hw)
+static void rtl_pci_init_aspm(struct ieee80211_hw *hw)
 {
 	struct rtl_ps_ctl *ppsc = rtl_psc(rtl_priv(hw));
 
@@ -359,53 +378,6 @@ static void _rtl_pci_initialize_adapter_
 		rtl_pci_enable_aspm(hw);
 		RT_SET_PS_LEVEL(ppsc, RT_RF_PS_LEVEL_ALWAYS_ASPM);
 	}
-
-}
-
-static void rtl_pci_init_aspm(struct ieee80211_hw *hw)
-{
-	struct rtl_pci *rtlpci = rtl_pcidev(rtl_pcipriv(hw));
-
-	/*close ASPM for AMD defaultly */
-	rtlpci->const_amdpci_aspm = 0;
-
-	/*
-	 * ASPM PS mode.
-	 * 0 - Disable ASPM,
-	 * 1 - Enable ASPM without Clock Req,
-	 * 2 - Enable ASPM with Clock Req,
-	 * 3 - Alwyas Enable ASPM with Clock Req,
-	 * 4 - Always Enable ASPM without Clock Req.
-	 * set defult to RTL8192CE:3 RTL8192E:2
-	 * */
-	rtlpci->const_pci_aspm = 3;
-
-	/*Setting for PCI-E device */
-	rtlpci->const_devicepci_aspm_setting = 0x03;
-
-	/*Setting for PCI-E bridge */
-	rtlpci->const_hostpci_aspm_setting = 0x02;
-
-	/*
-	 * In Hw/Sw Radio Off situation.
-	 * 0 - Default,
-	 * 1 - From ASPM setting without low Mac Pwr,
-	 * 2 - From ASPM setting with low Mac Pwr,
-	 * 3 - Bus D3
-	 * set default to RTL8192CE:0 RTL8192SE:2
-	 */
-	rtlpci->const_hwsw_rfoff_d3 = 0;
-
-	/*
-	 * This setting works for those device with
-	 * backdoor ASPM setting such as EPHY setting.
-	 * 0 - Not support ASPM,
-	 * 1 - Support ASPM,
-	 * 2 - According to chipset.
-	 */
-	rtlpci->const_support_pciaspm = 1;
-
-	_rtl_pci_initialize_adapter_common(hw);
 }
 
 static void _rtl_pci_io_handler_init(struct device *dev,
@@ -429,17 +401,131 @@ static void _rtl_pci_io_handler_release(
 {
 }
 
+static bool _rtl_update_earlymode_info(struct ieee80211_hw *hw,
+				       struct sk_buff *skb,
+				       struct rtl_tcb_desc *tcb_desc)
+{
+	struct rtl_priv *rtlpriv = rtl_priv(hw);
+	struct rtl_mac *mac = rtl_mac(rtl_priv(hw));
+	enum rt_enc_alg pairwise_enc = rtlpriv->sec.pairwise_enc_algorithm;
+	u8 additionlen = 0;
+	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)(skb->data);
+	__le16 fc = hdr->frame_control;
+	struct sk_buff *next_skb;
+	unsigned int queue_index = skb_get_queue_mapping(skb);
+	u8 *da = ieee80211_get_DA(hdr);
+
+	if (rtlpriv->rtlhal.hw_type != HARDWARE_TYPE_RTL8192DE)
+		return false;
+
+	switch (pairwise_enc) {
+	case NO_ENCRYPTION:
+		additionlen = 4;
+		break;
+
+	case WEP40_ENCRYPTION:
+	case WEP104_ENCRYPTION:
+		additionlen = 8;
+		break;
+
+	case TKIP_ENCRYPTION:
+		additionlen = 16;
+		break;
+
+	case AESCCMP_ENCRYPTION:
+		additionlen = 12;
+		break;
+
+	default:
+		break;
+	}
+
+	/* Some macaddr can't do early mode. */
+	if (is_multicast_ether_addr(da) || is_broadcast_ether_addr(da) ||
+		!ieee80211_is_data_qos(fc))
+		return false;
+
+	/* The most skb num is 6 */
+	tcb_desc->empkt_num = 0;
+	skb_queue_walk(&mac->skb_waitq[queue_index], next_skb) {
+		hdr = (struct ieee80211_hdr *)(next_skb->data);
+
+		/* rdg is not used now */
+		if (memcmp(ieee80211_get_DA(hdr), da, ETH_ALEN) == 0 &&
+			(queue_index == skb_get_queue_mapping(next_skb))) {
+			tcb_desc->empkt_len[tcb_desc->empkt_num] =
+				next_skb->len + additionlen;
+			tcb_desc->empkt_num++;
+		}
+
+		if (skb_queue_is_last(&mac->skb_waitq[queue_index], next_skb))
+			break;
+
+		if (tcb_desc->empkt_num >= 5)
+			break;
+	}
+
+	return true;
+}
+
+/* just for early mode now */
+static void _rtl_pci_tx_chk_waitq(struct ieee80211_hw *hw)
+{
+	struct rtl_priv *rtlpriv = rtl_priv(hw);
+	struct rtl_mac *mac = rtl_mac(rtl_priv(hw));
+	int queue_idx;
+	struct sk_buff *skb = NULL;
+	struct ieee80211_hdr *hdr = NULL;
+	struct ieee80211_tx_info *info = NULL;
+	u8 *qc = NULL;
+	u8 tid = 0;
+	struct rtl_tcb_desc tcb_desc;
+	memset(&tcb_desc, 0, sizeof(struct rtl_tcb_desc));
+
+	if (!rtlpriv->rtlhal.earlymode_enable)
+		return;
+
+	if (rtlpriv->rtlhal.hw_type != HARDWARE_TYPE_RTL8192DE)
+		return;
+
+	for (queue_idx = 0; queue_idx < RTL_PCI_MAX_TX_QUEUE_COUNT;
+	     queue_idx++) {
+		if (queue_idx >= BEACON_QUEUE)
+			break;
+
+		while (!skb_queue_empty(&mac->skb_waitq[queue_idx]) &&
+				!mac->act_scanning &&
+				rtlpriv->psc.rfpwr_state == ERFON) {
+			tcb_desc.empkt_num = 0;
+			memset(tcb_desc.empkt_len, 0, 20);
+
+			skb = skb_dequeue(&mac->skb_waitq[queue_idx]);
+			info = IEEE80211_SKB_CB(skb);
+			hdr = (struct ieee80211_hdr *)(skb->data);
+			qc = ieee80211_get_qos_ctl(hdr);
+			tid = qc[0] & IEEE80211_QOS_CTL_TID_MASK;
+
+			if (mac->tids[tid].agg.agg_state == RTL_AGG_ON &&
+					info->flags & IEEE80211_TX_CTL_AMPDU)
+				_rtl_update_earlymode_info(hw, skb, &tcb_desc);
+
+			rtlpriv->intf_ops->adapter_tx(hw, skb, &tcb_desc);
+		}
+	}
+}
+
 static void _rtl_pci_tx_isr(struct ieee80211_hw *hw, int prio)
 {
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
 	struct rtl_pci *rtlpci = rtl_pcidev(rtl_pcipriv(hw));
-
 	struct rtl8192_tx_ring *ring = &rtlpci->tx_ring[prio];
 
 	while (skb_queue_len(&ring->queue)) {
 		struct rtl_tx_desc *entry = &ring->desc[ring->idx];
 		struct sk_buff *skb;
 		struct ieee80211_tx_info *info;
+		struct ieee80211_hdr *hdr;
+		__le16 fc;
 
 		u8 own = (u8) rtlpriv->cfg->ops->get_desc((u8 *) entry, true,
 							  HW_DESC_OWN);
@@ -460,6 +546,10 @@ static void _rtl_pci_tx_isr(struct ieee8
 						      HW_DESC_TXBUFF_ADDR),
 				 skb->len, PCI_DMA_TODEVICE);
 
+		/* remove early mode header */
+		if (rtlpriv->rtlhal.earlymode_enable)
+			skb_pull(skb, EM_HDR_LEN);
+
 		RT_TRACE(rtlpriv, (COMP_INTR | COMP_SEND), DBG_TRACE,
 			 ("new ring->idx:%d, "
 			  "free: skb_queue_len:%d, free: seq:%x\n",
@@ -467,6 +557,24 @@ static void _rtl_pci_tx_isr(struct ieee8
 			  skb_queue_len(&ring->queue),
 			  *(u16 *) (skb->data + 22)));
 
+		if (prio == TXCMD_QUEUE) {
+			dev_kfree_skb(skb);
+			goto tx_status_ok;
+
+		}
+
+		/* for sw LPS, just after NULL skb send out, we can
+		 * sure AP kown we are sleeped, our we should not let
+		 * rf to sleep*/
+		hdr = (struct ieee80211_hdr *)(skb->data);
+		fc = hdr->frame_control;
+		if (ieee80211_is_nullfunc(fc)) {
+			if (ieee80211_has_pm(fc))
+				rtlpriv->psc.state_inap = 1;
+			else
+				rtlpriv->psc.state_inap = 0;
+		}
+
 		info = IEEE80211_SKB_CB(skb);
 		ieee80211_tx_info_clear_status(info);
 
@@ -490,6 +598,7 @@ static void _rtl_pci_tx_isr(struct ieee8
 					(skb));
 		}
 
+tx_status_ok:
 		skb = NULL;
 	}
 
@@ -564,20 +673,18 @@ static void _rtl_pci_rx_interrupt(struct
 			hdr = (struct ieee80211_hdr *)(skb->data);
 			fc = hdr->frame_control;
 
-			if (!stats.crc) {
+			if (!stats.crc || !stats.hwerror) {
 				memcpy(IEEE80211_SKB_RXCB(skb), &rx_status,
 				       sizeof(rx_status));
 
-				if (is_broadcast_ether_addr(hdr->addr1))
+				if (is_broadcast_ether_addr(hdr->addr1)) {
 					;/*TODO*/
-				else {
-					if (is_multicast_ether_addr(hdr->addr1))
-						;/*TODO*/
-					else {
-						unicast = true;
-						rtlpriv->stats.rxbytesunicast +=
-						    skb->len;
-					}
+				} else if (is_multicast_ether_addr(hdr->addr1)) {
+					;/*TODO*/
+				} else {
+					unicast = true;
+					rtlpriv->stats.rxbytesunicast +=
+					    skb->len;
 				}
 
 				rtl_is_special_data(hw, skb, false);
@@ -591,8 +698,15 @@ static void _rtl_pci_rx_interrupt(struct
 						    num_rx_inperiod++;
 				}
 
+				/* for sw lps */
+				rtl_swlps_beacon(hw,
+						 (void *)skb->data, skb->len);
+
+				rtl_recognize_peer(hw,
+						   (void *)skb->data, skb->len);
+
 				if (unlikely(!rtl_action_proc(hw, skb,
-				    false))) {
+					     false))) {
 					dev_kfree_skb_any(skb);
 				} else {
 					struct sk_buff *uskb = NULL;
@@ -674,6 +788,7 @@ static irqreturn_t _rtl_pci_interrupt(in
 	struct ieee80211_hw *hw = dev_id;
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
 	struct rtl_pci *rtlpci = rtl_pcidev(rtl_pcipriv(hw));
+	struct rtl_hal *rtlhal = rtl_hal(rtl_priv(hw));
 	unsigned long flags;
 	u32 inta = 0;
 	u32 intb = 0;
@@ -760,23 +875,36 @@ static irqreturn_t _rtl_pci_interrupt(in
 		_rtl_pci_tx_isr(hw, VO_QUEUE);
 	}
 
+	if (rtlhal->hw_type == HARDWARE_TYPE_RTL8192SE) {
+		if (inta & rtlpriv->cfg->maps[RTL_IMR_COMDOK]) {
+			rtlpriv->link_info.num_tx_inperiod++;
+
+			RT_TRACE(rtlpriv, COMP_INTR, DBG_TRACE,
+					("CMD TX OK interrupt!\n"));
+			_rtl_pci_tx_isr(hw, TXCMD_QUEUE);
+		}
+	}
+
 	/*<2> Rx related */
 	if (inta & rtlpriv->cfg->maps[RTL_IMR_ROK]) {
 		RT_TRACE(rtlpriv, COMP_INTR, DBG_TRACE, ("Rx ok interrupt!\n"));
-		tasklet_schedule(&rtlpriv->works.irq_tasklet);
+		_rtl_pci_rx_interrupt(hw);
 	}
 
 	if (unlikely(inta & rtlpriv->cfg->maps[RTL_IMR_RDU])) {
 		RT_TRACE(rtlpriv, COMP_ERR, DBG_WARNING,
 			 ("rx descriptor unavailable!\n"));
-		tasklet_schedule(&rtlpriv->works.irq_tasklet);
+		_rtl_pci_rx_interrupt(hw);
 	}
 
 	if (unlikely(inta & rtlpriv->cfg->maps[RTL_IMR_RXFOVW])) {
 		RT_TRACE(rtlpriv, COMP_ERR, DBG_WARNING, ("rx overflow !\n"));
-		tasklet_schedule(&rtlpriv->works.irq_tasklet);
+		_rtl_pci_rx_interrupt(hw);
 	}
 
+	if (rtlpriv->rtlhal.earlymode_enable)
+		tasklet_schedule(&rtlpriv->works.irq_tasklet);
+
 	spin_unlock_irqrestore(&rtlpriv->locks.irq_th_lock, flags);
 	return IRQ_HANDLED;
 
@@ -787,7 +915,7 @@ done:
 
 static void _rtl_pci_irq_tasklet(struct ieee80211_hw *hw)
 {
-	_rtl_pci_rx_interrupt(hw);
+	_rtl_pci_tx_chk_waitq(hw);
 }
 
 static void _rtl_pci_prepare_bcn_tasklet(struct ieee80211_hw *hw)
@@ -799,10 +927,12 @@ static void _rtl_pci_prepare_bcn_tasklet
 	struct ieee80211_hdr *hdr = NULL;
 	struct ieee80211_tx_info *info = NULL;
 	struct sk_buff *pskb = NULL;
+	struct rtl_tcb_desc tcb_desc;
 	struct rtl_tx_desc *pdesc = NULL;
 	unsigned int queue_index;
 	u8 temp_one = 1;
 
+	memset(&tcb_desc, 0, sizeof(struct rtl_tcb_desc));
 	ring = &rtlpci->tx_ring[BEACON_QUEUE];
 	pskb = __skb_dequeue(&ring->queue);
 	if (pskb)
@@ -819,7 +949,8 @@ static void _rtl_pci_prepare_bcn_tasklet
 
 	pdesc = &ring->desc[0];
 	rtlpriv->cfg->ops->fill_tx_desc(hw, hdr, (u8 *) pdesc,
-					info, pskb, queue_index);
+					info, pskb, queue_index,
+					&tcb_desc);
 
 	__skb_queue_tail(&ring->queue, pskb);
 
@@ -861,7 +992,6 @@ static void _rtl_pci_init_struct(struct
 	struct rtl_mac *mac = rtl_mac(rtl_priv(hw));
 	struct rtl_pci *rtlpci = rtl_pcidev(rtl_pcipriv(hw));
 	struct rtl_hal *rtlhal = rtl_hal(rtl_priv(hw));
-	struct rtl_ps_ctl *ppsc = rtl_psc(rtl_priv(hw));
 
 	rtlpci->up_first_time = true;
 	rtlpci->being_init_adapter = false;
@@ -869,31 +999,21 @@ static void _rtl_pci_init_struct(struct
 	rtlhal->hw = hw;
 	rtlpci->pdev = pdev;
 
-	ppsc->inactiveps = false;
-	ppsc->leisure_ps = true;
-	ppsc->fwctrl_lps = true;
-	ppsc->reg_fwctrl_lps = 3;
-	ppsc->reg_max_lps_awakeintvl = 5;
-
-	if (ppsc->reg_fwctrl_lps == 1)
-		ppsc->fwctrl_psmode = FW_PS_MIN_MODE;
-	else if (ppsc->reg_fwctrl_lps == 2)
-		ppsc->fwctrl_psmode = FW_PS_MAX_MODE;
-	else if (ppsc->reg_fwctrl_lps == 3)
-		ppsc->fwctrl_psmode = FW_PS_DTIM_MODE;
-
 	/*Tx/Rx related var */
 	_rtl_pci_init_trx_var(hw);
 
-	 /*IBSS*/ mac->beacon_interval = 100;
+	/*IBSS*/
+	mac->beacon_interval = 100;
 
-	 /*AMPDU*/ mac->min_space_cfg = 0;
+	/*AMPDU*/
+	mac->min_space_cfg = 0;
 	mac->max_mss_density = 0;
 	/*set sane AMPDU defaults */
 	mac->current_ampdu_density = 7;
 	mac->current_ampdu_factor = 3;
 
-	 /*QOS*/ rtlpci->acm_method = eAcmWay2_SW;
+	/*QOS*/
+	rtlpci->acm_method = eAcmWay2_SW;
 
 	/*task */
 	tasklet_init(&rtlpriv->works.irq_tasklet,
@@ -1182,9 +1302,10 @@ int rtl_pci_reset_trx_ring(struct ieee80
 	return 0;
 }
 
-static unsigned int _rtl_mac_to_hwqueue(__le16 fc,
-		unsigned int mac80211_queue_index)
+static unsigned int _rtl_mac_to_hwqueue(struct ieee80211_hw *hw, __le16 fc,
+					unsigned int mac80211_queue_index)
 {
+	struct rtl_hal *rtlhal = rtl_hal(rtl_priv(hw));
 	unsigned int hw_queue_index;
 
 	if (unlikely(ieee80211_is_beacon(fc))) {
@@ -1197,6 +1318,13 @@ static unsigned int _rtl_mac_to_hwqueue(
 		goto out;
 	}
 
+	if (rtlhal->hw_type == HARDWARE_TYPE_RTL8192SE) {
+		if (ieee80211_is_nullfunc(fc)) {
+			hw_queue_index = HIGH_QUEUE;
+			goto out;
+		}
+	}
+
 	switch (mac80211_queue_index) {
 	case 0:
 		hw_queue_index = VO_QUEUE;
@@ -1205,7 +1333,7 @@ static unsigned int _rtl_mac_to_hwqueue(
 		hw_queue_index = VI_QUEUE;
 		break;
 	case 2:
-		hw_queue_index = BE_QUEUE;;
+		hw_queue_index = BE_QUEUE;
 		break;
 	case 3:
 		hw_queue_index = BK_QUEUE;
@@ -1221,7 +1349,49 @@ out:
 	return hw_queue_index;
 }
 
-static int rtl_pci_tx(struct ieee80211_hw *hw, struct sk_buff *skb)
+static bool rtl_pci_tx_chk_waitq_insert(struct ieee80211_hw *hw,
+					struct sk_buff *skb)
+{
+	struct rtl_priv *rtlpriv = rtl_priv(hw);
+	struct rtl_mac *mac = rtl_mac(rtl_priv(hw));
+	struct rtl_hal *rtlhal = rtl_hal(rtl_priv(hw));
+	struct rtl_pci *rtlpci = rtl_pcidev(rtl_pcipriv(hw));
+	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)(skb->data);
+	__le16 fc = hdr->frame_control;
+	unsigned int queue_index = skb_get_queue_mapping(skb);
+	unsigned int hw_queue = _rtl_mac_to_hwqueue(hw, fc, queue_index);
+	struct rtl8192_tx_ring *ring = &rtlpci->tx_ring[hw_queue];
+	u8 *qc = ieee80211_get_qos_ctl(hdr);
+	u8 tid = qc[0] & IEEE80211_QOS_CTL_TID_MASK;
+
+	if (!rtlhal->earlymode_enable)
+		return 0;
+
+	if (!ieee80211_is_data_qos(fc))
+		return 0;
+
+	if (mac->tids[tid].agg.agg_state != RTL_AGG_ON)
+		return 0;
+
+	RT_TRACE(rtlpriv, COMP_SEND, DBG_DMESG, ("===insert to skb_waitq "
+		 "for early mode desc_used_num[%d]:%d\n", queue_index,
+		 skb_queue_len(&ring->queue)));
+	if (skb_queue_len(&ring->queue) > mac->earlymode_threshold ||
+		!skb_queue_empty(&mac->skb_waitq[queue_index])) {
+		skb_queue_tail(&mac->skb_waitq[queue_index], skb);
+
+		RT_TRACE(rtlpriv, COMP_SEND, DBG_DMESG, ("insert to skb_waitq "
+			 "for early mode desc_used_num[%d]:%d\n",
+			  queue_index, skb_queue_len(&ring->queue)));
+
+		return 1;
+	}
+
+	return 0;
+}
+
+static int rtl_pci_tx(struct ieee80211_hw *hw, struct sk_buff *skb,
+		      struct rtl_tcb_desc *ptcb_desc)
 {
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
 	struct rtl_mac *mac = rtl_mac(rtl_priv(hw));
@@ -1244,10 +1414,17 @@ static int rtl_pci_tx(struct ieee80211_h
 
 	if (ieee80211_is_mgmt(fc))
 		rtl_tx_mgmt_proc(hw, skb);
+
+	if (rtlpriv->psc.sw_ps_enabled) {
+		if (ieee80211_is_data(fc) && !ieee80211_is_nullfunc(fc) &&
+			!ieee80211_has_pm(fc))
+			hdr->frame_control |= cpu_to_le16(IEEE80211_FCTL_PM);
+	}
+
 	rtl_action_proc(hw, skb, true);
 
 	queue_index = skb_get_queue_mapping(skb);
-	hw_queue = _rtl_mac_to_hwqueue(fc, queue_index);
+	hw_queue = _rtl_mac_to_hwqueue(hw, fc, queue_index);
 
 	if (is_multicast_ether_addr(pda_addr))
 		rtlpriv->stats.txbytesmulticast += skb->len;
@@ -1280,13 +1457,6 @@ static int rtl_pci_tx(struct ieee80211_h
 		return skb->len;
 	}
 
-	/*
-	 *if(ieee80211_is_nullfunc(fc)) {
-	 *      spin_unlock_irqrestore(&rtlpriv->locks.irq_th_lock, flags);
-	 *      return 1;
-	 *}
-	 */
-
 	if (ieee80211_is_data_qos(fc)) {
 		qc = ieee80211_get_qos_ctl(hdr);
 		tid = qc[0] & IEEE80211_QOS_CTL_TID_MASK;
@@ -1306,7 +1476,8 @@ static int rtl_pci_tx(struct ieee80211_h
 		rtlpriv->cfg->ops->led_control(hw, LED_CTL_TX);
 
 	rtlpriv->cfg->ops->fill_tx_desc(hw, hdr, (u8 *) pdesc,
-					info, skb, hw_queue);
+					info, skb, hw_queue,
+					ptcb_desc);
 
 	__skb_queue_tail(&ring->queue, skb);
 
@@ -1328,7 +1499,7 @@ static int rtl_pci_tx(struct ieee80211_h
 			  hw_queue, ring->idx, idx,
 			  skb_queue_len(&ring->queue)));
 
-		ieee80211_stop_queue(hw, skb_get_queue_mapping(skb));
+		ieee80211_stop_queue(hw, queue_index);
 	}
 
 	spin_unlock_irqrestore(&rtlpriv->locks.irq_th_lock, flags);
@@ -1454,14 +1625,13 @@ static bool _rtl_pci_find_adapter(struct
 	struct rtl_pci_priv *pcipriv = rtl_pcipriv(hw);
 	struct rtl_hal *rtlhal = rtl_hal(rtl_priv(hw));
 	struct pci_dev *bridge_pdev = pdev->bus->self;
-	u16 venderid;
-	u16 deviceid;
+	u16 venderid = pdev->vendor;
+	u16 deviceid = pdev->device;
+	u8 revisionid = pdev->revision;
 	u16 irqline;
 	u8 tmp;
 
-	venderid = pdev->vendor;
-	deviceid = pdev->device;
-	pci_read_config_word(pdev, 0x3C, &irqline);
+	pci_read_config_word(pdev, PCI_INTERRUPT_LINE, &irqline);
 
 	if (deviceid == RTL_PCI_8192_DID ||
 	    deviceid == RTL_PCI_0044_DID ||
@@ -1471,7 +1641,7 @@ static bool _rtl_pci_find_adapter(struct
 	    deviceid == RTL_PCI_8173_DID ||
 	    deviceid == RTL_PCI_8172_DID ||
 	    deviceid == RTL_PCI_8171_DID) {
-		switch (pdev->revision) {
+		switch (revisionid) {
 		case RTL_PCI_REVISION_ID_8192PCIE:
 			RT_TRACE(rtlpriv, COMP_INIT, DBG_DMESG,
 				 ("8192 PCI-E is found - "
@@ -1500,6 +1670,12 @@ static bool _rtl_pci_find_adapter(struct
 		RT_TRACE(rtlpriv, COMP_INIT, DBG_DMESG,
 			 ("8192C PCI-E is found - "
 			  "vid/did=%x/%x\n", venderid, deviceid));
+	} else if (deviceid == RTL_PCI_8192DE_DID ||
+		   deviceid == RTL_PCI_8192DE_DID2) {
+		rtlhal->hw_type = HARDWARE_TYPE_RTL8192DE;
+		RT_TRACE(rtlpriv, COMP_INIT, DBG_DMESG,
+			 ("8192D PCI-E is found - "
+			  "vid/did=%x/%x\n", venderid, deviceid));
 	} else {
 		RT_TRACE(rtlpriv, COMP_ERR, DBG_WARNING,
 			 ("Err: Unknown device -"
@@ -1508,6 +1684,25 @@ static bool _rtl_pci_find_adapter(struct
 		rtlhal->hw_type = RTL_DEFAULT_HARDWARE_TYPE;
 	}
 
+	if (rtlhal->hw_type == HARDWARE_TYPE_RTL8192DE) {
+		if (revisionid == 0 || revisionid == 1) {
+			if (revisionid == 0) {
+				RT_TRACE(rtlpriv, COMP_INIT, DBG_LOUD,
+					 ("Find 92DE MAC0.\n"));
+				rtlhal->interfaceindex = 0;
+			} else if (revisionid == 1) {
+				RT_TRACE(rtlpriv, COMP_INIT, DBG_LOUD,
+					 ("Find 92DE MAC1.\n"));
+					 rtlhal->interfaceindex = 1;
+			}
+		} else {
+			RT_TRACE(rtlpriv, COMP_INIT, DBG_LOUD,
+				 ("Unknown device - "
+				 "VendorID/DeviceID=%x/%x, Revision=%x\n",
+				 venderid, deviceid, revisionid));
+			rtlhal->interfaceindex = 0;
+		}
+	}
 	/*find bus info */
 	pcipriv->ndis_adapter.busnumber = pdev->bus->number;
 	pcipriv->ndis_adapter.devnumber = PCI_SLOT(pdev->devfn);
@@ -1533,12 +1728,12 @@ static bool _rtl_pci_find_adapter(struct
 		    PCI_SLOT(bridge_pdev->devfn);
 		pcipriv->ndis_adapter.pcibridge_funcnum =
 		    PCI_FUNC(bridge_pdev->devfn);
-		pcipriv->ndis_adapter.pcibridge_pciehdr_offset =
-		    pci_pcie_cap(bridge_pdev);
 		pcipriv->ndis_adapter.pcicfg_addrport =
 		    (pcipriv->ndis_adapter.pcibridge_busnum << 16) |
 		    (pcipriv->ndis_adapter.pcibridge_devnum << 11) |
 		    (pcipriv->ndis_adapter.pcibridge_funcnum << 8) | (1 << 31);
+		pcipriv->ndis_adapter.pcibridge_pciehdr_offset =
+		    pci_pcie_cap(bridge_pdev);
 		pcipriv->ndis_adapter.num4bytes =
 		    (pcipriv->ndis_adapter.pcibridge_pciehdr_offset + 0x10) / 4;
 
@@ -1621,6 +1816,11 @@ int __devinit rtl_pci_probe(struct pci_d
 	pcipriv = (void *)rtlpriv->priv;
 	pcipriv->dev.pdev = pdev;
 
+	/* init cfg & intf_ops */
+	rtlpriv->rtlhal.interface = INTF_PCI;
+	rtlpriv->cfg = (struct rtl_hal_cfg *)(id->driver_data);
+	rtlpriv->intf_ops = &rtl_pci_ops;
+
 	/*
 	 *init dbgp flags before all
 	 *other functions, because we will
@@ -1638,13 +1838,14 @@ int __devinit rtl_pci_probe(struct pci_d
 		return err;
 	}
 
-	pmem_start = pci_resource_start(pdev, 2);
-	pmem_len = pci_resource_len(pdev, 2);
-	pmem_flags = pci_resource_flags(pdev, 2);
+	pmem_start = pci_resource_start(pdev, rtlpriv->cfg->bar_id);
+	pmem_len = pci_resource_len(pdev, rtlpriv->cfg->bar_id);
+	pmem_flags = pci_resource_flags(pdev, rtlpriv->cfg->bar_id);
 
 	/*shared mem start */
 	rtlpriv->io.pci_mem_start =
-			(unsigned long)pci_iomap(pdev, 2, pmem_len);
+			(unsigned long)pci_iomap(pdev,
+			rtlpriv->cfg->bar_id, pmem_len);
 	if (rtlpriv->io.pci_mem_start == 0) {
 		RT_ASSERT(false, ("Can't map PCI mem\n"));
 		goto fail2;
@@ -1663,11 +1864,6 @@ int __devinit rtl_pci_probe(struct pci_d
 	pci_write_config_byte(pdev, 0x04, 0x06);
 	pci_write_config_byte(pdev, 0x04, 0x07);
 
-	/* init cfg & intf_ops */
-	rtlpriv->rtlhal.interface = INTF_PCI;
-	rtlpriv->cfg = (struct rtl_hal_cfg *)(id->driver_data);
-	rtlpriv->intf_ops = &rtl_pci_ops;
-
 	/* find adapter */
 	_rtl_pci_find_adapter(pdev, hw);
 
@@ -1720,6 +1916,9 @@ int __devinit rtl_pci_probe(struct pci_d
 		goto fail3;
 	}
 
+	/* add for prov */
+	rtl_proc_add_one(hw);
+
 	/*init rfkill */
 	rtl_init_rfkill(hw);
 
@@ -1771,6 +1970,9 @@ void rtl_pci_disconnect(struct pci_dev *
 
 	sysfs_remove_group(&pdev->dev.kobj, &rtl_attribute_group);
 
+	/* add for prov */
+	rtl_proc_remove_one(hw);
+
 	/*ieee80211_unregister_hw will call ops_stop */
 	if (rtlmac->mac80211_registered == 1) {
 		ieee80211_unregister_hw(hw);
@@ -1785,7 +1987,6 @@ void rtl_pci_disconnect(struct pci_dev *
 
 	rtl_pci_deinit(hw);
 	rtl_deinit_core(hw);
-	rtlpriv->cfg->ops->deinit_sw_leds(hw);
 	_rtl_pci_io_handler_release(hw);
 	rtlpriv->cfg->ops->deinit_sw_vars(hw);
 
@@ -1800,6 +2001,7 @@ void rtl_pci_disconnect(struct pci_dev *
 	}
 
 	pci_disable_device(pdev);
+	rtl_pci_disable_aspm(hw);
 	pci_set_drvdata(pdev, NULL);
 
 	ieee80211_free_hw(hw);
@@ -1823,6 +2025,11 @@ no need to call hw_disable here.
 ****************************************/
 int rtl_pci_suspend(struct pci_dev *pdev, pm_message_t state)
 {
+	struct ieee80211_hw *hw = pci_get_drvdata(pdev);
+	struct rtl_priv *rtlpriv = rtl_priv(hw);
+
+	rtlpriv->cfg->ops->hw_suspend(hw);
+	rtl_deinit_rfkill(hw);
 	pci_save_state(pdev);
 	pci_disable_device(pdev);
 	pci_set_power_state(pdev, PCI_D3hot);
@@ -1833,6 +2040,8 @@ EXPORT_SYMBOL(rtl_pci_suspend);
 
 int rtl_pci_resume(struct pci_dev *pdev)
 {
+	struct ieee80211_hw *hw = pci_get_drvdata(pdev);
+	struct rtl_priv *rtlpriv = rtl_priv(hw);
 	int ret;
 
 	pci_set_power_state(pdev, PCI_D0);
@@ -1843,16 +2052,20 @@ int rtl_pci_resume(struct pci_dev *pdev)
 	}
 
 	pci_restore_state(pdev);
+	rtlpriv->cfg->ops->hw_resume(hw);
+	rtl_init_rfkill(hw);
 
 	return 0;
 }
 EXPORT_SYMBOL(rtl_pci_resume);
 
 struct rtl_intf_ops rtl_pci_ops = {
+	.read_efuse_byte = read_efuse_byte,
 	.adapter_start = rtl_pci_start,
 	.adapter_stop = rtl_pci_stop,
 	.adapter_tx = rtl_pci_tx,
 	.reset_trx_ring = rtl_pci_reset_trx_ring,
+	.waitq_insert = rtl_pci_tx_chk_waitq_insert,
 
 	.disable_aspm = rtl_pci_disable_aspm,
 	.enable_aspm = rtl_pci_enable_aspm,
Index: wireless-testing/drivers/net/wireless/rtlwifi/pci.h
===================================================================
--- wireless-testing.orig/drivers/net/wireless/rtlwifi/pci.h
+++ wireless-testing/drivers/net/wireless/rtlwifi/pci.h
@@ -102,8 +102,8 @@
 #define RTL_PCI_8191CE_DID	0x8177	/*8192ce */
 #define RTL_PCI_8188CE_DID	0x8176	/*8192ce */
 #define RTL_PCI_8192CU_DID	0x8191	/*8192ce */
-#define RTL_PCI_8192DE_DID	0x092D	/*8192ce */
-#define RTL_PCI_8192DU_DID	0x092D	/*8192ce */
+#define RTL_PCI_8192DE_DID	0x8193	/*8192de */
+#define RTL_PCI_8192DE_DID2	0x002B	/*92DE	 */
 
 /*8192 support 16 pages of IO registers*/
 #define RTL_MEM_MAPPED_IO_RANGE_8190PCI		0x1000
@@ -129,6 +129,11 @@ enum pci_bridge_vendor {
 	PCI_BRIDGE_VENDOR_MAX,
 };
 
+struct rtl_pci_capabilities_header {
+	u8 capability_id;
+	u8 next;
+};
+
 struct rtl_rx_desc {
 	u32 dword[8];
 } __packed;
@@ -161,6 +166,7 @@ struct rtl_pci {
 
 	bool driver_is_goingto_unload;
 	bool up_first_time;
+	bool first_init;
 	bool being_init_adapter;
 	bool irq_enabled;
 
@@ -197,6 +203,8 @@ struct rtl_pci {
 
 	/*QOS & EDCA */
 	enum acm_method acm_method;
+	u16 shortretry_limit;
+	u16 longretry_limit;
 };
 
 struct mp_adapter {
@@ -227,6 +235,7 @@ struct rtl_pci_priv {
 	struct rtl_pci dev;
 	struct mp_adapter ndis_adapter;
 	struct rtl_led_ctl ledctl;
+	struct bt_coexist_info bt_coexist;
 };
 
 #define rtl_pcipriv(hw)		(((struct rtl_pci_priv *)(rtl_priv(hw))->priv))
Index: wireless-testing/drivers/net/wireless/rtlwifi/Kconfig
===================================================================
--- wireless-testing.orig/drivers/net/wireless/rtlwifi/Kconfig
+++ wireless-testing/drivers/net/wireless/rtlwifi/Kconfig
@@ -10,6 +10,17 @@ config RTL8192CE
 
 	If you choose to build it as a module, it will be called rtl8192ce
 
+config RTL8192SE
+	tristate "Realtek RTL8192SE/RTL8191SE PCIe Wireless Network Adapter"
+	depends on MAC80211 && EXPERIMENTAL
+	select FW_LOADER
+	select RTLWIFI
+	---help---
+	This is the driver for Realtek RTL8192SE/RTL8191SE 802.11n PCIe
+	wireless network adapters.
+
+	If you choose to build it as a module, it will be called rtl8192se
+
 config RTL8192CU
 	tristate "Realtek RTL8192CU/RTL8188CU USB Wireless Network Adapter"
 	depends on MAC80211 && USB && EXPERIMENTAL
@@ -24,10 +35,10 @@ config RTL8192CU
 
 config RTLWIFI
 	tristate
-	depends on RTL8192CE || RTL8192CU
+	depends on RTL8192CE || RTL8192CU || RTL8192SE
 	default m
 
 config RTL8192C_COMMON
 	tristate
-	depends on RTL8192CE || RTL8192CU
+	depends on RTL8192CE || RTL8192CU || RTL8192SE
 	default m
Index: wireless-testing/drivers/net/wireless/rtlwifi/Makefile
===================================================================
--- wireless-testing.orig/drivers/net/wireless/rtlwifi/Makefile
+++ wireless-testing/drivers/net/wireless/rtlwifi/Makefile
@@ -22,5 +22,6 @@ endif
 obj-$(CONFIG_RTL8192C_COMMON)	+= rtl8192c/
 obj-$(CONFIG_RTL8192CE)		+= rtl8192ce/
 obj-$(CONFIG_RTL8192CU)		+= rtl8192cu/
+obj-$(CONFIG_RTL8192SE)		+= rtl8192se/
 
 ccflags-y += -D__CHECK_ENDIAN__
Index: wireless-testing/drivers/net/wireless/rtlwifi/rtl8192se/Makefile
===================================================================
--- /dev/null
+++ wireless-testing/drivers/net/wireless/rtlwifi/rtl8192se/Makefile
@@ -0,0 +1,13 @@
+rtl8192se-objs :=		\
+		dm.o		\
+		fw.o		\
+		hw.o		\
+		led.o		\
+		phy.o		\
+		rf.o		\
+		sw.o		\
+		table.o		\
+		trx.o
+
+obj-$(CONFIG_RTL8192SE) += rtl8192se.o
+
Index: wireless-testing/drivers/net/wireless/rtlwifi/cam.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/rtlwifi/cam.c
+++ wireless-testing/drivers/net/wireless/rtlwifi/cam.c
@@ -23,6 +23,8 @@
  * Realtek Corporation, No. 2, Innovation Road II, Hsinchu Science Park,
  * Hsinchu 300, Taiwan.
  *
+ * Larry Finger <Larry.Finger@lwfinger.net>
+ *
  *****************************************************************************/
 
 #include "wifi.h"
Index: wireless-testing/drivers/net/wireless/rtlwifi/core.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/rtlwifi/core.c
+++ wireless-testing/drivers/net/wireless/rtlwifi/core.c
@@ -24,6 +24,7 @@
  * Hsinchu 300, Taiwan.
  *
  * Larry Finger <Larry.Finger@lwfinger.net>
+ *
  *****************************************************************************/
 
 #include "wifi.h"
@@ -70,6 +71,7 @@ static void rtl_op_stop(struct ieee80211
 
 	mac->link_state = MAC80211_NOLINK;
 	memset(mac->bssid, 0, 6);
+	mac->vendor = PEER_UNKNOWN;
 
 	/*reset sec info */
 	rtl_cam_reset_sec_info(hw);
@@ -85,7 +87,9 @@ static void rtl_op_tx(struct ieee80211_h
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
 	struct rtl_hal *rtlhal = rtl_hal(rtl_priv(hw));
 	struct rtl_ps_ctl *ppsc = rtl_psc(rtl_priv(hw));
+	struct rtl_tcb_desc tcb_desc;
 
+	memset(&tcb_desc, 0, sizeof(struct rtl_tcb_desc));
 	if (unlikely(is_hal_stop(rtlhal) || ppsc->rfpwr_state != ERFON))
 		goto err_free;
 
@@ -93,12 +97,14 @@ static void rtl_op_tx(struct ieee80211_h
 		goto err_free;
 
 
-	rtlpriv->intf_ops->adapter_tx(hw, skb);
+	if (!rtlpriv->intf_ops->waitq_insert(hw, skb))
+		rtlpriv->intf_ops->adapter_tx(hw, skb, &tcb_desc);
 
 	return;
 
 err_free:
 	dev_kfree_skb_any(skb);
+	return;
 }
 
 static int rtl_op_add_interface(struct ieee80211_hw *hw,
@@ -134,6 +140,9 @@ static int rtl_op_add_interface(struct i
 
 		mac->link_state = MAC80211_LINKED;
 		rtlpriv->cfg->ops->set_bcn_reg(hw);
+		mac->basic_rates = 0xfff;
+		rtlpriv->cfg->ops->set_hw_reg(hw, HW_VAR_BASIC_RATE,
+				(u8 *) (&mac->basic_rates));
 		break;
 	case NL80211_IFTYPE_AP:
 		RT_TRACE(rtlpriv, COMP_MAC80211, DBG_LOUD,
@@ -184,6 +193,7 @@ static void rtl_op_remove_interface(stru
 	mac->vif = NULL;
 	mac->link_state = MAC80211_NOLINK;
 	memset(mac->bssid, 0, 6);
+	mac->vendor = PEER_UNKNOWN;
 	mac->opmode = NL80211_IFTYPE_UNSPECIFIED;
 	rtlpriv->cfg->ops->set_network_type(hw, mac->opmode);
 
@@ -222,10 +232,25 @@ static int rtl_op_config(struct ieee8021
 
 	/*For LPS */
 	if (changed & IEEE80211_CONF_CHANGE_PS) {
-		if (conf->flags & IEEE80211_CONF_PS)
-			rtl_lps_enter(hw);
-		else
-			rtl_lps_leave(hw);
+		cancel_delayed_work(&rtlpriv->works.ps_work);
+		cancel_delayed_work(&rtlpriv->works.ps_rfon_wq);
+		if (conf->flags & IEEE80211_CONF_PS) {
+			rtlpriv->psc.sw_ps_enabled = true;
+			/* sleep here is must, or we may recv the beacon and
+			 * cause mac80211 into wrong ps state, this will cause
+			 * power save nullfunc send fail, and further cause
+			 * pkt loss, So sleep must quickly but not immediatly
+			 * because that will cause nullfunc send by mac80211
+			 * fail, and cause pkt loss, we have tested that 5mA
+			 * is worked very well */
+			if (!rtlpriv->psc.multi_buffered)
+				queue_delayed_work(rtlpriv->works.rtl_wq,
+						   &rtlpriv->works.ps_work,
+						   MSECS(5));
+		} else {
+			rtl_swlps_rf_awake(hw);
+			rtlpriv->psc.sw_ps_enabled = false;
+		}
 	}
 
 	if (changed & IEEE80211_CONF_CHANGE_RETRY_LIMITS) {
@@ -235,8 +260,7 @@ static int rtl_op_config(struct ieee8021
 		mac->retry_long = hw->conf.long_frame_max_tx_count;
 		mac->retry_short = hw->conf.long_frame_max_tx_count;
 		rtlpriv->cfg->ops->set_hw_reg(hw, HW_VAR_RETRY_LIMIT,
-					      (u8 *) (&hw->conf.
-						      long_frame_max_tx_count));
+				(u8 *) (&hw->conf.long_frame_max_tx_count));
 	}
 
 	if (changed & IEEE80211_CONF_CHANGE_CHANNEL) {
@@ -294,8 +318,8 @@ static int rtl_op_config(struct ieee8021
 			wide_chan = 1;
 		rtlphy->current_channel = wide_chan;
 
-		rtlpriv->cfg->ops->set_channel_access(hw);
 		rtlpriv->cfg->ops->switch_channel(hw);
+		rtlpriv->cfg->ops->set_channel_access(hw);
 		rtlpriv->cfg->ops->set_bw_mode(hw,
 					       hw->conf.channel_type);
 	}
@@ -343,27 +367,25 @@ static void rtl_op_configure_filter(stru
 		}
 	}
 
-	if (changed_flags & FIF_BCN_PRBRESP_PROMISC) {
-		/*
-		 *TODO: BIT(5) is probe response BIT(8) is beacon
-		 *TODO: Use define for BIT(5) and BIT(8)
-		 */
+	/* if ssid not set to hw don't check bssid
+	 * here just used for linked scanning, & linked
+	 * and nolink check bssid is set in set network_type */
+	if ((changed_flags & FIF_BCN_PRBRESP_PROMISC) &&
+		(mac->link_state >= MAC80211_LINKED)) {
 		if (*new_flags & FIF_BCN_PRBRESP_PROMISC)
-			mac->rx_mgt_filter |= (BIT(5) | BIT(8));
+			rtlpriv->cfg->ops->set_chk_bssid(hw, false);
 		else
-			mac->rx_mgt_filter &= ~(BIT(5) | BIT(8));
+			rtlpriv->cfg->ops->set_chk_bssid(hw, true);
 	}
 
 	if (changed_flags & FIF_CONTROL) {
 		if (*new_flags & FIF_CONTROL) {
 			mac->rx_conf |= rtlpriv->cfg->maps[MAC_RCR_ACF];
-			mac->rx_ctrl_filter |= RTL_SUPPORTED_CTRL_FILTER;
 
 			RT_TRACE(rtlpriv, COMP_MAC80211, DBG_LOUD,
 				 ("Enable receive control frame.\n"));
 		} else {
 			mac->rx_conf &= ~rtlpriv->cfg->maps[MAC_RCR_ACF];
-			mac->rx_ctrl_filter &= ~RTL_SUPPORTED_CTRL_FILTER;
 			RT_TRACE(rtlpriv, COMP_MAC80211, DBG_LOUD,
 				 ("Disable receive control frame.\n"));
 		}
@@ -380,12 +402,6 @@ static void rtl_op_configure_filter(stru
 				 ("Disable receive other BSS's frame.\n"));
 		}
 	}
-
-	rtlpriv->cfg->ops->set_hw_reg(hw, HW_VAR_RCR, (u8 *) (&mac->rx_conf));
-	rtlpriv->cfg->ops->set_hw_reg(hw, HW_VAR_MGT_FILTER,
-				      (u8 *) (&mac->rx_mgt_filter));
-	rtlpriv->cfg->ops->set_hw_reg(hw, HW_VAR_CTRL_FILTER,
-				      (u8 *) (&mac->rx_ctrl_filter));
 }
 
 static int _rtl_get_hal_qnum(u16 queue)
@@ -444,8 +460,9 @@ static void rtl_op_bss_info_changed(stru
 			     struct ieee80211_bss_conf *bss_conf, u32 changed)
 {
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
-	struct rtl_mac *mac = rtl_mac(rtl_priv(hw));
-	struct rtl_ps_ctl *ppsc = rtl_psc(rtl_priv(hw));
+	struct rtl_hal *rtlhal = rtl_hal(rtlpriv);
+	struct rtl_mac *mac = rtl_mac(rtlpriv);
+	struct rtl_ps_ctl *ppsc = rtl_psc(rtlpriv);
 
 	mutex_lock(&rtlpriv->locks.conf_mutex);
 
@@ -492,6 +509,16 @@ static void rtl_op_bss_info_changed(stru
 	/*TODO: reference to enum ieee80211_bss_change */
 	if (changed & BSS_CHANGED_ASSOC) {
 		if (bss_conf->assoc) {
+			/* we should reset all sec info & cam
+			 * before set cam after linked, we should not
+			 * reset in disassoc, that will cause tkip->wep
+			 * fail because some flag will be wrong */
+			/* reset sec info */
+			rtl_cam_reset_sec_info(hw);
+			/* reset cam to fix wep fail issue
+			 * when change from wpa to wep */
+			rtl_cam_reset_all_entry(hw);
+
 			mac->link_state = MAC80211_LINKED;
 			mac->cnt_after_linked = 0;
 			mac->assoc_id = bss_conf->aid;
@@ -506,8 +533,7 @@ static void rtl_op_bss_info_changed(stru
 			mac->link_state = MAC80211_NOLINK;
 			memset(mac->bssid, 0, 6);
 
-			/* reset sec info */
-			rtl_cam_reset_sec_info(hw);
+			mac->vendor = PEER_UNKNOWN;
 
 			RT_TRACE(rtlpriv, COMP_MAC80211, DBG_DMESG,
 				 ("BSS_CHANGED_UN_ASSOC\n"));
@@ -583,6 +609,7 @@ static void rtl_op_bss_info_changed(stru
 		RT_TRACE(rtlpriv, COMP_MAC80211, DBG_DMESG,
 			 (MAC_FMT "\n", MAC_ARG(bss_conf->bssid)));
 
+		mac->vendor = PEER_UNKNOWN;
 		memcpy(mac->bssid, bss_conf->bssid, 6);
 		if (is_valid_ether_addr(bss_conf->bssid)) {
 			switch (vif->type) {
@@ -609,17 +636,31 @@ static void rtl_op_bss_info_changed(stru
 		mac->sgi_40 = false;
 		mac->sgi_20 = false;
 
-		if (!bss_conf->use_short_slot)
-			mac->mode = WIRELESS_MODE_B;
-		else
+		if (vif->type == NL80211_IFTYPE_ADHOC) {
 			mac->mode = WIRELESS_MODE_G;
+			if (rtlpriv->dm.useramask)
+				rtlpriv->cfg->ops->update_rate_mask(hw, 0);
+			else
+				rtlpriv->cfg->ops->update_rate_table(hw);
+		} else {
+			if (!bss_conf->use_short_slot)
+				mac->mode = WIRELESS_MODE_B;
+			else
+				mac->mode = WIRELESS_MODE_G;
+		}
+
+		if (rtlhal->current_bandtype == BAND_ON_5G)
+			mac->mode = WIRELESS_MODE_A;
 
 		rcu_read_lock();
 		sta = ieee80211_find_sta(mac->vif, mac->bssid);
 
 		if (sta) {
 			if (sta->ht_cap.ht_supported) {
-				mac->mode = WIRELESS_MODE_N_24G;
+				if (rtlhal->current_bandtype == BAND_ON_2_4G)
+					mac->mode = WIRELESS_MODE_N_24G;
+				else
+					mac->mode = WIRELESS_MODE_N_5G;
 				mac->ht_enable = true;
 			}
 
@@ -657,6 +698,9 @@ static void rtl_op_bss_info_changed(stru
 		if (changed & BSS_CHANGED_BASIC_RATES) {
 			if (mac->mode == WIRELESS_MODE_B)
 				basic_rates = bss_conf->basic_rates | 0x00f;
+			else if (mac->mode == WIRELESS_MODE_G ||
+				 mac->mode == WIRELESS_MODE_N_24G)
+				basic_rates = bss_conf->basic_rates | 0xfff;
 			else
 				basic_rates = bss_conf->basic_rates | 0xff0;
 
@@ -797,8 +841,12 @@ static void rtl_op_sw_scan_start(struct
 	if (mac->link_state == MAC80211_LINKED) {
 		rtl_lps_leave(hw);
 		mac->link_state = MAC80211_LINKED_SCANNING;
-	} else
+	} else {
 		rtl_ips_nic_on(hw);
+	}
+
+	/* Dual mac */
+	rtlpriv->rtlhal.load_imrandiqk_setting_for2g = false;
 
 	rtlpriv->cfg->ops->led_control(hw, LED_CTL_SITE_SURVEY);
 	rtlpriv->cfg->ops->scan_operation_backup(hw, SCAN_OPT_BACKUP);
@@ -811,8 +859,10 @@ static void rtl_op_sw_scan_complete(stru
 
 	RT_TRACE(rtlpriv, COMP_MAC80211, DBG_LOUD, ("\n"));
 
-	rtlpriv->cfg->ops->scan_operation_backup(hw, SCAN_OPT_RESTORE);
 	mac->act_scanning = false;
+	/* Dual mac */
+	rtlpriv->rtlhal.load_imrandiqk_setting_for2g = false;
+
 	if (mac->link_state == MAC80211_LINKED_SCANNING) {
 		mac->link_state = MAC80211_LINKED;
 
@@ -825,7 +875,7 @@ static void rtl_op_sw_scan_complete(stru
 			rtlpriv->cfg->ops->update_rate_table(hw);
 
 	}
-
+	rtlpriv->cfg->ops->scan_operation_backup(hw, SCAN_OPT_RESTORE);
 }
 
 static int rtl_op_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
@@ -866,31 +916,41 @@ static int rtl_op_set_key(struct ieee802
 		RT_TRACE(rtlpriv, COMP_SEC, DBG_DMESG,
 			 ("alg:WEP104\n"));
 		key_type = WEP104_ENCRYPTION;
-		rtlpriv->sec.use_defaultkey = true;
 		break;
 	case WLAN_CIPHER_SUITE_TKIP:
 		key_type = TKIP_ENCRYPTION;
 		RT_TRACE(rtlpriv, COMP_SEC, DBG_DMESG, ("alg:TKIP\n"));
-		if (mac->opmode == NL80211_IFTYPE_ADHOC)
-			rtlpriv->sec.use_defaultkey = true;
 		break;
 	case WLAN_CIPHER_SUITE_CCMP:
 		key_type = AESCCMP_ENCRYPTION;
 		RT_TRACE(rtlpriv, COMP_SEC, DBG_DMESG, ("alg:CCMP\n"));
-		if (mac->opmode == NL80211_IFTYPE_ADHOC)
-			rtlpriv->sec.use_defaultkey = true;
 		break;
 	default:
 		RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG,
 			 ("alg_err:%x!!!!:\n", key->cipher));
 		goto out_unlock;
 	}
+	if (key_type == WEP40_ENCRYPTION ||
+			key_type == WEP104_ENCRYPTION ||
+			mac->opmode == NL80211_IFTYPE_ADHOC)
+		rtlpriv->sec.use_defaultkey = true;
 	/* <2> get key_idx */
 	key_idx = (u8) (key->keyidx);
 	if (key_idx > 3)
 		goto out_unlock;
 	/* <3> if pairwise key enable_hw_sec */
 	group_key = !(key->flags & IEEE80211_KEY_FLAG_PAIRWISE);
+
+	/* WEP will always be group key, but there are two conditions:
+	 * 1) WEP only: is just for WEP enc, in this condition
+	 * rtlpriv->sec.pairwise_enc_algorithm == NO_ENCRYPTION
+	 * will be true & enable_hw_sec will be set when WEP
+	 * key setting.
+	 * 2) WEP(group) + AES(pairwise): some APs like Cisco
+	 * may use it, in this condition enable_hw_sec will not
+	 * be set when WEP key setting */
+	/* we must reset sec_info after linked before set key,
+	 * or some flags will be wrong */
 	if ((!group_key) || (mac->opmode == NL80211_IFTYPE_ADHOC) ||
 	    rtlpriv->sec.pairwise_enc_algorithm == NO_ENCRYPTION) {
 		if (rtlpriv->sec.pairwise_enc_algorithm == NO_ENCRYPTION &&
@@ -898,6 +958,9 @@ static int rtl_op_set_key(struct ieee802
 		     key_type == WEP104_ENCRYPTION))
 			wep_only = true;
 		rtlpriv->sec.pairwise_enc_algorithm = key_type;
+		RT_TRACE(rtlpriv, COMP_SEC, DBG_DMESG,
+			 ("set enable_hw_sec, key_type:%x(OPEN:0 WEP40:1 "
+			 "TKIP:2 AES:4 WEP104:5)\n", key_type));
 		rtlpriv->cfg->ops->enable_hw_sec(hw);
 	}
 	/* <4> set key based on cmd */
@@ -980,10 +1043,10 @@ out_unlock:
 static void rtl_op_rfkill_poll(struct ieee80211_hw *hw)
 {
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
-
 	bool radio_state;
 	bool blocked;
 	u8 valid = 0;
+	static bool init;
 
 	if (!test_bit(RTL_STATUS_INTERFACE_START, &rtlpriv->status))
 		return;
@@ -993,7 +1056,8 @@ static void rtl_op_rfkill_poll(struct ie
 	/*if Radio On return true here */
 	radio_state = rtlpriv->cfg->ops->radio_onoff_checking(hw, &valid);
 
-	if (valid) {
+	if (valid || !init) {
+		init = true;
 		if (unlikely(radio_state != rtlpriv->rfkill.rfkill_state)) {
 			rtlpriv->rfkill.rfkill_state = radio_state;
 
Index: wireless-testing/drivers/net/wireless/rtlwifi/rc.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/rtlwifi/rc.c
+++ wireless-testing/drivers/net/wireless/rtlwifi/rc.c
@@ -35,20 +35,15 @@
  *Finds the highest rate index we can use
  *if skb is special data like DHCP/EAPOL, we set should
  *it to lowest rate CCK_1M, otherwise we set rate to
- *CCK11M or OFDM_54M based on wireless mode.
+ *highest rate based on wireless mode used for iwconfig
+ *show Tx rate.
  */
 static u8 _rtl_rc_get_highest_rix(struct rtl_priv *rtlpriv,
 				  struct sk_buff *skb, bool not_data)
 {
 	struct rtl_mac *rtlmac = rtl_mac(rtlpriv);
-
-	/*
-	 *mgt use 1M, although we have check it
-	 *before this function use rate_control_send_low,
-	 *we still check it here
-	 */
-	if (not_data)
-		return rtlpriv->cfg->maps[RTL_RC_CCK_RATE1M];
+	struct rtl_hal *rtlhal = rtl_hal(rtlpriv);
+	struct rtl_phy *rtlphy = &(rtlpriv->phy);
 
 	/*
 	 *this rate is no use for true rate, firmware
@@ -57,13 +52,31 @@ static u8 _rtl_rc_get_highest_rix(struct
 	 *2.in rtl_get_tcb_desc when we check rate is
 	 *      1M we will not use FW rate but user rate.
 	 */
-	if (rtl_is_special_data(rtlpriv->mac80211.hw, skb, true)) {
-		return rtlpriv->cfg->maps[RTL_RC_CCK_RATE1M];
+	if (rtl_is_special_data(rtlpriv->mac80211.hw, skb, true) ||
+			not_data) {
+		return 0;
 	} else {
-		if (rtlmac->mode == WIRELESS_MODE_B)
-			return rtlpriv->cfg->maps[RTL_RC_CCK_RATE11M];
-		else
-			return rtlpriv->cfg->maps[RTL_RC_OFDM_RATE54M];
+		if (rtlhal->current_bandtype == BAND_ON_2_4G) {
+			if (rtlmac->mode == WIRELESS_MODE_B) {
+				return B_MODE_MAX_RIX;
+			} else if (rtlmac->mode == WIRELESS_MODE_G) {
+				return G_MODE_MAX_RIX;
+			} else {
+				if (get_rf_type(rtlphy) != RF_2T2R)
+					return N_MODE_MCS7_RIX;
+				else
+					return N_MODE_MCS15_RIX;
+			}
+		} else {
+			if (rtlmac->mode == WIRELESS_MODE_A) {
+				return A_MODE_MAX_RIX;
+			} else {
+				if (get_rf_type(rtlphy) != RF_2T2R)
+					return N_MODE_MCS7_RIX;
+				else
+					return N_MODE_MCS15_RIX;
+			}
+		}
 	}
 }
 
@@ -76,7 +89,7 @@ static void _rtl_rc_rate_set_series(stru
 	struct rtl_mac *mac = rtl_mac(rtlpriv);
 
 	rate->count = tries;
-	rate->idx = (rix > 0x2) ? rix : 0x2;
+	rate->idx = rix >= 0x00 ? rix : 0x00;
 
 	if (!not_data) {
 		if (txrc->short_preamble)
Index: wireless-testing/drivers/net/wireless/rtlwifi/rc.h
===================================================================
--- wireless-testing.orig/drivers/net/wireless/rtlwifi/rc.h
+++ wireless-testing/drivers/net/wireless/rtlwifi/rc.h
@@ -30,6 +30,14 @@
 #ifndef __RTL_RC_H__
 #define __RTL_RC_H__
 
+#define B_MODE_MAX_RIX 3
+#define G_MODE_MAX_RIX 11
+#define A_MODE_MAX_RIX 7
+
+/* in mac80211 mcs0-mcs15 is idx0-idx15*/
+#define N_MODE_MCS7_RIX 7
+#define N_MODE_MCS15_RIX 15
+
 struct rtl_rate_priv {
 	u8 cur_ratetab_idx;
 	u8 ht_cap;
@@ -37,4 +45,5 @@ struct rtl_rate_priv {
 
 int rtl_rate_control_register(void);
 void rtl_rate_control_unregister(void);
+
 #endif
Index: wireless-testing/drivers/net/wireless/rtlwifi/regd.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/rtlwifi/regd.c
+++ wireless-testing/drivers/net/wireless/rtlwifi/regd.c
@@ -66,6 +66,27 @@ static struct country_code_to_enum_rd al
 	NL80211_RRF_PASSIVE_SCAN | \
 	NL80211_RRF_NO_OFDM)
 
+/* 5G chan 36 - chan 64*/
+#define RTL819x_5GHZ_5150_5350	\
+	REG_RULE(5150-10, 5350+10, 40, 0, 30, \
+	NL80211_RRF_PASSIVE_SCAN | \
+	NL80211_RRF_NO_IBSS)
+
+/* 5G chan 100 - chan 165*/
+#define RTL819x_5GHZ_5470_5850	\
+	REG_RULE(5470-10, 5850+10, 40, 0, 30, \
+	NL80211_RRF_PASSIVE_SCAN | \
+	NL80211_RRF_NO_IBSS)
+
+/* 5G chan 149 - chan 165*/
+#define RTL819x_5GHZ_5725_5850	\
+	REG_RULE(5725-10, 5850+10, 40, 0, 30, \
+	NL80211_RRF_PASSIVE_SCAN | \
+	NL80211_RRF_NO_IBSS)
+
+#define RTL819x_5GHZ_ALL	\
+	(RTL819x_5GHZ_5150_5350, RTL819x_5GHZ_5470_5850)
+
 static const struct ieee80211_regdomain rtl_regdom_11 = {
 	.n_reg_rules = 1,
 	.alpha2 = "99",
@@ -74,22 +95,53 @@ static const struct ieee80211_regdomain
 	}
 };
 
-static const struct ieee80211_regdomain rtl_regdom_global = {
-	.n_reg_rules = 3,
+static const struct ieee80211_regdomain rtl_regdom_12_13 = {
+	.n_reg_rules = 2,
 	.alpha2 = "99",
 	.reg_rules = {
 		      RTL819x_2GHZ_CH01_11,
-		      RTL819x_2GHZ_CH12_13,
-		      RTL819x_2GHZ_CH14,
+			  RTL819x_2GHZ_CH12_13,
+		      }
+};
+
+static const struct ieee80211_regdomain rtl_regdom_no_midband = {
+	.n_reg_rules = 3,
+	.alpha2 = "99",
+	.reg_rules = {
+			RTL819x_2GHZ_CH01_11,
+			RTL819x_5GHZ_5150_5350,
+			RTL819x_5GHZ_5725_5850,
 	}
 };
 
-static const struct ieee80211_regdomain rtl_regdom_world = {
-	.n_reg_rules = 2,
+static const struct ieee80211_regdomain rtl_regdom_60_64 = {
+	.n_reg_rules = 3,
 	.alpha2 = "99",
 	.reg_rules = {
-		      RTL819x_2GHZ_CH01_11,
-		      RTL819x_2GHZ_CH12_13,
+			RTL819x_2GHZ_CH01_11,
+			RTL819x_2GHZ_CH12_13,
+			RTL819x_5GHZ_5725_5850,
+	}
+};
+
+static const struct ieee80211_regdomain rtl_regdom_14_60_64 = {
+	.n_reg_rules = 4,
+	.alpha2 = "99",
+	.reg_rules = {
+		RTL819x_2GHZ_CH01_11,
+		RTL819x_2GHZ_CH12_13,
+		RTL819x_2GHZ_CH14,
+		RTL819x_5GHZ_5725_5850,
+	}
+};
+
+static const struct ieee80211_regdomain rtl_regdom_14 = {
+	.n_reg_rules = 3,
+	.alpha2 = "99",
+	.reg_rules = {
+		RTL819x_2GHZ_CH01_11,
+		RTL819x_2GHZ_CH12_13,
+		RTL819x_2GHZ_CH14,
 	}
 };
 
@@ -162,6 +214,8 @@ static void _rtl_reg_apply_active_scan_f
 	u32 bandwidth = 0;
 	int r;
 
+	if (!wiphy->bands[IEEE80211_BAND_2GHZ])
+		return;
 	sband = wiphy->bands[IEEE80211_BAND_2GHZ];
 
 	/*
@@ -292,25 +346,26 @@ static const struct ieee80211_regdomain
 {
 	switch (reg->country_code) {
 	case COUNTRY_CODE_FCC:
+		return &rtl_regdom_no_midband;
 	case COUNTRY_CODE_IC:
 		return &rtl_regdom_11;
 	case COUNTRY_CODE_ETSI:
+	case COUNTRY_CODE_TELEC_NETGEAR:
+		return &rtl_regdom_60_64;
 	case COUNTRY_CODE_SPAIN:
 	case COUNTRY_CODE_FRANCE:
 	case COUNTRY_CODE_ISRAEL:
-	case COUNTRY_CODE_TELEC_NETGEAR:
-		return &rtl_regdom_world;
+	case COUNTRY_CODE_WORLD_WIDE_13:
+		return &rtl_regdom_12_13;
 	case COUNTRY_CODE_MKK:
 	case COUNTRY_CODE_MKK1:
 	case COUNTRY_CODE_TELEC:
 	case COUNTRY_CODE_MIC:
-		return &rtl_regdom_global;
+		return &rtl_regdom_14_60_64;
 	case COUNTRY_CODE_GLOBAL_DOMAIN:
-		return &rtl_regdom_global;
-	case COUNTRY_CODE_WORLD_WIDE_13:
-		return &rtl_regdom_world;
+		return &rtl_regdom_14;
 	default:
-		return &rtl_regdom_world;
+		return &rtl_regdom_no_midband;
 	}
 }
 
@@ -355,8 +410,8 @@ int rtl_regd_init(struct ieee80211_hw *h
 	if (wiphy == NULL || &rtlpriv->regd == NULL)
 		return -EINVAL;
 
-	/* force the channel plan to world wide 13 */
-	rtlpriv->regd.country_code = COUNTRY_CODE_WORLD_WIDE_13;
+	/* init country_code from efuse channel plan */
+	rtlpriv->regd.country_code = rtlpriv->efuse.channel_plan;
 
 	RT_TRACE(rtlpriv, COMP_REGD, DBG_TRACE,
 		 (KERN_DEBUG "rtl: EEPROM regdomain: 0x%0x\n",
@@ -373,8 +428,8 @@ int rtl_regd_init(struct ieee80211_hw *h
 	country = _rtl_regd_find_country(rtlpriv->regd.country_code);
 
 	if (country) {
-		rtlpriv->regd.alpha2[0] = country->isoName[0];
-		rtlpriv->regd.alpha2[1] = country->isoName[1];
+		rtlpriv->regd.alpha2[0] = country->iso_name[0];
+		rtlpriv->regd.alpha2[1] = country->iso_name[1];
 	} else {
 		rtlpriv->regd.alpha2[0] = '0';
 		rtlpriv->regd.alpha2[1] = '0';
Index: wireless-testing/drivers/net/wireless/rtlwifi/regd.h
===================================================================
--- wireless-testing.orig/drivers/net/wireless/rtlwifi/regd.h
+++ wireless-testing/drivers/net/wireless/rtlwifi/regd.h
@@ -32,7 +32,7 @@
 
 struct country_code_to_enum_rd {
 	u16 countrycode;
-	const char *isoName;
+	const char *iso_name;
 };
 
 enum country_code_type_t {
@@ -58,4 +58,5 @@ int rtl_regd_init(struct ieee80211_hw *h
 		  int (*reg_notifier) (struct wiphy *wiphy,
 				       struct regulatory_request *request));
 int rtl_reg_notifier(struct wiphy *wiphy, struct regulatory_request *request);
+
 #endif
Index: wireless-testing/drivers/net/wireless/rtlwifi/wifi.h
===================================================================
--- wireless-testing.orig/drivers/net/wireless/rtlwifi/wifi.h
+++ wireless-testing/drivers/net/wireless/rtlwifi/wifi.h
@@ -1404,7 +1404,8 @@ struct rtl_intf_ops {
 	int (*adapter_start) (struct ieee80211_hw *hw);
 	void (*adapter_stop) (struct ieee80211_hw *hw);
 
-	int (*adapter_tx) (struct ieee80211_hw *hw, struct sk_buff *skb);
+	int (*adapter_tx) (struct ieee80211_hw *hw, struct sk_buff *skb,
+			struct rtl_tcb_desc *ptcb_desc);
 	int (*reset_trx_ring) (struct ieee80211_hw *hw);
 	bool (*waitq_insert) (struct ieee80211_hw *hw, struct sk_buff *skb);
 

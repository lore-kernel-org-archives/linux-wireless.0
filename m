Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:36090 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758667Ab1DYRwu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Apr 2011 13:52:50 -0400
Date: Mon, 25 Apr 2011 12:52:49 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
To: John W Linville <linville@tuxdriver.com>,
	chaoming_li@realsil.com.cn
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 02/18] rtlwifi: Change wifi.h for rtl8192se and rtl8192de
Message-ID: <4db5b4f1.0FWfpohs7SJWqEJt%Larry.Finger@lwfinger.net> (sfid-20110425_195254_965848_BE710109)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Chaoming_Li <chaoming_li@realsil.com.cn>

Change wifi.h for addition of RTL8192SE and RTL8192DE code

Signed-off-by: Chaoming_Li <chaoming_li@realsil.com.cn>
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---

 rtl8192c/dm_common.c |    4 -
 wifi.h               |  163 ++++++++++++++++++++++++++++++++++++++++++++++++---
 2 files changed, 157 insertions(+), 10 deletions(-)
---

Index: wireless-testing/drivers/net/wireless/rtlwifi/wifi.h
===================================================================
--- wireless-testing.orig/drivers/net/wireless/rtlwifi/wifi.h
+++ wireless-testing/drivers/net/wireless/rtlwifi/wifi.h
@@ -68,6 +68,8 @@
 #define QBSS_LOAD_SIZE				5
 #define MAX_WMMELE_LENGTH			64
 
+#define TOTAL_CAM_ENTRY				32
+
 /*slot time for 11g. */
 #define RTL_SLOT_TIME_9				9
 #define RTL_SLOT_TIME_20			20
@@ -94,8 +96,10 @@
 #define	CHANNEL_GROUP_MAX_5G		9
 #define CHANNEL_MAX_NUMBER_2G		14
 #define AVG_THERMAL_NUM			8
+#define MAX_TID_COUNT			9
 
 /* for early mode */
+#define FCS_LEN				4
 #define EM_HDR_LEN			8
 enum intf_type {
 	INTF_PCI = 0,
@@ -159,6 +163,8 @@ enum hardware_type {
 (IS_HARDWARE_TYPE_8192DE(rtlhal) || IS_HARDWARE_TYPE_8192DU(rtlhal))
 #define	IS_HARDWARE_TYPE_8723(rtlhal)			\
 (IS_HARDWARE_TYPE_8723E(rtlhal) || IS_HARDWARE_TYPE_8723U(rtlhal))
+#define IS_HARDWARE_TYPE_8723U(rtlhal)			\
+	(rtlhal->hw_type == HARDWARE_TYPE_RTL8723U)
 
 enum scan_operation_backup_opt {
 	SCAN_OPT_BACKUP = 0,
@@ -843,6 +849,7 @@ struct rtl_phy {
 	bool apk_done;
 	u32 reg_rf3c[2];	/* pathA / pathB  */
 
+	/* bfsync */
 	u8 framesync;
 	u32 framesync_c34;
 
@@ -852,6 +859,10 @@ struct rtl_phy {
 };
 
 #define MAX_TID_COUNT				9
+#define RTL_AGG_STOP				0
+#define RTL_AGG_PROGRESS			1
+#define RTL_AGG_START				2
+#define RTL_AGG_OPERATIONAL			3
 #define RTL_AGG_OFF				0
 #define RTL_AGG_ON				1
 #define RTL_AGG_EMPTYING_HW_QUEUE_ADDBA		2
@@ -871,6 +882,13 @@ struct rtl_tid_data {
 	struct rtl_ht_agg agg;
 };
 
+struct rtl_sta_info {
+	u8 ratr_index;
+	u8 wireless_mode;
+	u8 mimo_ps;
+	struct rtl_tid_data tids[MAX_TID_COUNT];
+} __packed;
+
 struct rtl_priv;
 struct rtl_io {
 	struct device *dev;
@@ -894,6 +912,7 @@ struct rtl_io {
 	u32(*read32_sync) (struct rtl_priv *rtlpriv, u32 addr);
 	int (*readN_sync) (struct rtl_priv *rtlpriv, u32 addr, u16 len,
 			    u8 *pdata);
+
 };
 
 struct rtl_mac {
@@ -916,6 +935,8 @@ struct rtl_mac {
 	int n_channels;
 	int n_bitrates;
 
+	bool offchan_deley;
+
 	/*filters */
 	u32 rx_conf;
 	u16 rx_mgt_filter;
@@ -1032,7 +1053,9 @@ struct rtl_security {
 	enum rt_enc_alg pairwise_enc_algorithm;
 	/*Encryption Algorithm for Brocast/Multicast */
 	enum rt_enc_alg group_enc_algorithm;
-
+	/*Cam Entry Bitmap */
+	u32 hwsec_cam_bitmap;
+	u8 hwsec_cam_sta_addr[TOTAL_CAM_ENTRY][ETH_ALEN];
 	/*local Key buffer, indx 0 is for
 	   pairwise key 1-4 is for agoup key. */
 	u8 key_buf[KEY_BUF_SIZE][MAX_KEY_LEN];
@@ -1053,7 +1076,7 @@ struct rtl_dm {
 	bool current_turbo_edca;
 	bool is_any_nonbepkts;	/*out dm */
 	bool is_cur_rdlstate;
-	bool txpower_trackingInit;
+	bool txpower_trackinginit;
 	bool disable_framebursting;
 	bool cck_inch14;
 	bool txpower_tracking;
@@ -1079,7 +1102,6 @@ struct rtl_dm {
 	bool disable_tx_int;
 	char ofdm_index[2];
 	char cck_index;
-	u8 power_index_backup[6];
 };
 
 #define	EFUSE_MAX_LOGICAL_SIZE			256
@@ -1175,6 +1197,7 @@ struct rtl_ps_ctl {
 	 * otherwise Offset[560h] = 0x00.
 	 * */
 	bool support_aspm;
+
 	bool support_backdoor;
 
 	/*for LPS */
@@ -1201,7 +1224,6 @@ struct rtl_ps_ctl {
 
 	/*just for PCIE ASPM */
 	u8 const_amdpci_aspm;
-
 	bool pwrdown_mode;
 
 	enum rf_pwrstate inactive_pwrstate;
@@ -1282,6 +1304,10 @@ struct rt_link_detect {
 	bool busytraffic;
 	bool higher_busytraffic;
 	bool higher_busyrxtraffic;
+
+	u32 tidtx_in4period[MAX_TID_COUNT][4];
+	u32 tidtx_inperiod[MAX_TID_COUNT];
+	bool higher_busytxtraffic[MAX_TID_COUNT];
 };
 
 struct rtl_tcb_desc {
@@ -1344,13 +1370,26 @@ struct rtl_hal_ops {
 				       u32 add_msr, u32 rm_msr);
 	void (*get_hw_reg) (struct ieee80211_hw *hw, u8 variable, u8 *val);
 	void (*set_hw_reg) (struct ieee80211_hw *hw, u8 variable, u8 *val);
+#if 0	/* temporary */
+	void (*update_rate_tbl) (struct ieee80211_hw *hw,
+			      struct ieee80211_sta *sta, u8 rssi_level);
+#else
 	void (*update_rate_table) (struct ieee80211_hw *hw);
+#endif
 	void (*update_rate_mask) (struct ieee80211_hw *hw, u8 rssi_level);
+#if 0	/* temporary */
+	void (*fill_tx_desc) (struct ieee80211_hw *hw,
+			      struct ieee80211_hdr *hdr, u8 *pdesc_tx,
+			      struct ieee80211_tx_info *info,
+			      struct sk_buff *skb, u8 hw_queue,
+			      struct rtl_tcb_desc *ptcb_desc);
+#else
 	void (*fill_tx_desc) (struct ieee80211_hw *hw,
 			      struct ieee80211_hdr *hdr, u8 *pdesc_tx,
 			      struct ieee80211_tx_info *info,
 			      struct sk_buff *skb, unsigned int queue_index);
-	void (*fill_fake_txdesc) (struct ieee80211_hw *hw, u8 * pDesc,
+#endif
+	void (*fill_fake_txdesc) (struct ieee80211_hw *hw, u8 *pDesc,
 				  u32 buffer_len, bool bIsPsPoll);
 	void (*fill_tx_cmddesc) (struct ieee80211_hw *hw, u8 *pdesc,
 				 bool firstseg, bool lastseg,
@@ -1370,10 +1409,10 @@ struct rtl_hal_ops {
 			     enum led_ctl_mode ledaction);
 	void (*set_desc) (u8 *pdesc, bool istx, u8 desc_name, u8 *val);
 	u32 (*get_desc) (u8 *pdesc, bool istx, u8 desc_name);
-	void (*tx_polling) (struct ieee80211_hw *hw, unsigned int hw_queue);
+	void (*tx_polling) (struct ieee80211_hw *hw, u8 hw_queue);
 	void (*enable_hw_sec) (struct ieee80211_hw *hw);
 	void (*set_key) (struct ieee80211_hw *hw, u32 key_index,
-			 u8 *p_macaddr, bool is_group, u8 enc_algo,
+			 u8 *macaddr, bool is_group, u8 enc_algo,
 			 bool is_wepkey, bool clear_all);
 	void (*init_sw_leds) (struct ieee80211_hw *hw);
 	void (*deinit_sw_leds) (struct ieee80211_hw *hw);
@@ -1384,6 +1423,7 @@ struct rtl_hal_ops {
 			  u32 regaddr, u32 bitmask);
 	void (*set_rfreg) (struct ieee80211_hw *hw, enum radio_path rfpath,
 			   u32 regaddr, u32 bitmask, u32 data);
+	void (*linked_set_reg) (struct ieee80211_hw *hw);
 	bool (*phy_rf6052_config) (struct ieee80211_hw *hw);
 	void (*phy_rf6052_set_cck_txpower) (struct ieee80211_hw *hw,
 					    u8 *powerlevel);
@@ -1404,7 +1444,13 @@ struct rtl_intf_ops {
 	int (*adapter_start) (struct ieee80211_hw *hw);
 	void (*adapter_stop) (struct ieee80211_hw *hw);
 
+#if 0	/* temporary */
+	int (*adapter_tx) (struct ieee80211_hw *hw, struct sk_buff *skb,
+			struct rtl_tcb_desc *ptcb_desc);
+#else
 	int (*adapter_tx) (struct ieee80211_hw *hw, struct sk_buff *skb);
+#endif
+	void (*flush)(struct ieee80211_hw *hw, bool drop);
 	int (*reset_trx_ring) (struct ieee80211_hw *hw);
 	bool (*waitq_insert) (struct ieee80211_hw *hw, struct sk_buff *skb);
 
@@ -1418,6 +1464,15 @@ struct rtl_intf_ops {
 struct rtl_mod_params {
 	/* default: 0 = using hardware encryption */
 	int sw_crypto;
+
+	/* default: 1 = using no linked power save */
+	bool inactiveps;
+
+	/* default: 1 = using linked sw power save */
+	bool swctrl_lps;
+
+	/* default: 1 = using linked fw power save */
+	bool fwctrl_lps;
 };
 
 struct rtl_hal_usbint_cfg {
@@ -1445,6 +1500,7 @@ struct rtl_hal_usbint_cfg {
 
 struct rtl_hal_cfg {
 	u8 bar_id;
+	bool write_readback;
 	char *name;
 	char *fw_name;
 	struct rtl_hal_ops *ops;
@@ -1469,7 +1525,6 @@ struct rtl_locks {
 	spinlock_t rf_lock;
 	spinlock_t lps_lock;
 	spinlock_t waitq_lock;
-	spinlock_t tx_urb_lock;
 
 	/*Dual mac*/
 	spinlock_t cck_and_rw_pagea_lock;
@@ -1653,13 +1708,23 @@ struct bt_coexist_info {
 #define EF4BYTE(_val)		\
 	(le32_to_cpu(_val))
 
+/* Read data from memory */
+#define READEF1BYTE(_ptr)	\
+	EF1BYTE(*((u8 *)(_ptr)))
 /* Read le16 data from memory and convert to host ordering */
 #define READEF2BYTE(_ptr)	\
 	EF2BYTE(*((u16 *)(_ptr)))
+#define READEF4BYTE(_ptr)	\
+	EF4BYTE(*((u32 *)(_ptr)))
 
+/* Write data to memory */
+#define WRITEEF1BYTE(_ptr, _val)	\
+	(*((u8 *)(_ptr))) = EF1BYTE(_val)
 /* Write le16 data to memory in host ordering */
 #define WRITEEF2BYTE(_ptr, _val)	\
 	(*((u16 *)(_ptr))) = EF2BYTE(_val)
+#define WRITEEF4BYTE(_ptr, _val)	\
+	(*((u16 *)(_ptr))) = EF2BYTE(_val)
 
 /* Create a bit mask
  * Examples:
@@ -1698,6 +1763,25 @@ struct bt_coexist_info {
 #define LE_P1BYTE_TO_HOST_1BYTE(__pstart) \
 	(EF1BYTE(*((u8 *)(__pstart))))
 
+/*Description:
+Translate subfield (continuous bits in little-endian) of 4-byte
+value to host byte ordering.*/
+#define LE_BITS_TO_4BYTE(__pstart, __bitoffset, __bitlen) \
+	( \
+		(LE_P4BYTE_TO_HOST_4BYTE(__pstart) >> (__bitoffset))  & \
+		BIT_LEN_MASK_32(__bitlen) \
+	)
+#define LE_BITS_TO_2BYTE(__pstart, __bitoffset, __bitlen) \
+	( \
+		(LE_P2BYTE_TO_HOST_2BYTE(__pstart) >> (__bitoffset)) & \
+		BIT_LEN_MASK_16(__bitlen) \
+	)
+#define LE_BITS_TO_1BYTE(__pstart, __bitoffset, __bitlen) \
+	( \
+		(LE_P1BYTE_TO_HOST_1BYTE(__pstart) >> (__bitoffset)) & \
+		BIT_LEN_MASK_8(__bitlen) \
+	)
+
 /* Description:
  * Mask subfield (continuous bits in little-endian) of 4-byte value
  * and return the result in 4-byte value in host byte ordering.
@@ -1721,6 +1805,18 @@ struct bt_coexist_info {
 /* Description:
  * Set subfield of little-endian 4-byte value to specified value.
  */
+#define SET_BITS_TO_LE_4BYTE(__pstart, __bitoffset, __bitlen, __val) \
+	*((u32 *)(__pstart)) = EF4BYTE \
+	( \
+		LE_BITS_CLEARED_TO_4BYTE(__pstart, __bitoffset, __bitlen) | \
+		((((u32)__val) & BIT_LEN_MASK_32(__bitlen)) << (__bitoffset)) \
+	);
+#define SET_BITS_TO_LE_2BYTE(__pstart, __bitoffset, __bitlen, __val) \
+	*((u16 *)(__pstart)) = EF2BYTE \
+	( \
+		LE_BITS_CLEARED_TO_2BYTE(__pstart, __bitoffset, __bitlen) | \
+		((((u16)__val) & BIT_LEN_MASK_16(__bitlen)) << (__bitoffset)) \
+	);
 #define SET_BITS_TO_LE_1BYTE(__pstart, __bitoffset, __bitlen, __val) \
 	*((u8 *)(__pstart)) = EF1BYTE \
 	( \
@@ -1728,12 +1824,16 @@ struct bt_coexist_info {
 		((((u8)__val) & BIT_LEN_MASK_8(__bitlen)) << (__bitoffset)) \
 	);
 
+#define	N_BYTE_ALIGMENT(__value, __aligment) ((__aligment == 1) ? \
+	(__value) : (((__value + __aligment - 1) / __aligment) * __aligment))
+
 /****************************************
 	mem access macro define end
 ****************************************/
 
 #define byte(x, n) ((x >> (8 * n)) & 0xff)
 
+#define packet_get_type(_packet) (EF1BYTE((_packet).octet[0]) & 0xFC)
 #define RTL_WATCH_DOG_TIME	2000
 #define MSECS(t)		msecs_to_jiffies(t)
 #define WLAN_FC_GET_VERS(fc)	(le16_to_cpu(fc) & IEEE80211_FCTL_VERS)
@@ -1768,6 +1868,15 @@ struct bt_coexist_info {
 #define container_of_dwork_rtl(x, y, z) \
 	container_of(container_of(x, struct delayed_work, work), y, z)
 
+#define FILL_OCTET_STRING(_os, _octet, _len)	\
+		(_os).octet = (u8 *)(_octet);		\
+		(_os).length = (_len);
+
+#define CP_MACADDR(des, src)	\
+	((des)[0] = (src)[0], (des)[1] = (src)[1],\
+	(des)[2] = (src)[2], (des)[3] = (src)[3],\
+	(des)[4] = (src)[4], (des)[5] = (src)[5])
+
 static inline u8 rtl_read_byte(struct rtl_priv *rtlpriv, u32 addr)
 {
 	return rtlpriv->io.read8_sync(rtlpriv, addr);
@@ -1786,17 +1895,26 @@ static inline u32 rtl_read_dword(struct
 static inline void rtl_write_byte(struct rtl_priv *rtlpriv, u32 addr, u8 val8)
 {
 	rtlpriv->io.write8_async(rtlpriv, addr, val8);
+
+	if (rtlpriv->cfg->write_readback)
+		rtlpriv->io.read8_sync(rtlpriv, addr);
 }
 
 static inline void rtl_write_word(struct rtl_priv *rtlpriv, u32 addr, u16 val16)
 {
 	rtlpriv->io.write16_async(rtlpriv, addr, val16);
+
+	if (rtlpriv->cfg->write_readback)
+		rtlpriv->io.read16_sync(rtlpriv, addr);
 }
 
 static inline void rtl_write_dword(struct rtl_priv *rtlpriv,
 				   u32 addr, u32 val32)
 {
 	rtlpriv->io.write32_async(rtlpriv, addr, val32);
+
+	if (rtlpriv->cfg->write_readback)
+		rtlpriv->io.read32_sync(rtlpriv, addr);
 }
 
 static inline u32 rtl_get_bbreg(struct ieee80211_hw *hw,
@@ -1855,4 +1973,33 @@ static inline u8 get_rf_type(struct rtl_
 	return rtlphy->rf_type;
 }
 
+static inline struct ieee80211_hdr *rtl_get_hdr(struct sk_buff *skb)
+{
+	return (struct ieee80211_hdr *)(skb->data);
+}
+
+static inline u16 rtl_get_fc(struct sk_buff *skb)
+{
+	return le16_to_cpu(rtl_get_hdr(skb)->frame_control);
+}
+
+static inline u16 rtl_get_tid_h(struct ieee80211_hdr *hdr)
+{
+	return (ieee80211_get_qos_ctl(hdr))[0] & IEEE80211_QOS_CTL_TID_MASK;
+}
+
+static inline u16 rtl_get_tid(struct sk_buff *skb)
+{
+	return rtl_get_tid_h(rtl_get_hdr(skb));
+}
+
+static inline struct ieee80211_sta *get_sta(struct ieee80211_hw *hw,
+					    struct ieee80211_vif *vif,
+					    u8 *bssid)
+{
+	return ieee80211_find_sta(vif, bssid);
+}
+
 #endif
+
+
Index: wireless-testing/drivers/net/wireless/rtlwifi/rtl8192c/dm_common.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/rtlwifi/rtl8192c/dm_common.c
+++ wireless-testing/drivers/net/wireless/rtlwifi/rtl8192c/dm_common.c
@@ -640,7 +640,7 @@ static void rtl92c_dm_txpower_tracking_c
 	u8 txpwr_level[2] = {0, 0};
 	u8 ofdm_min_index = 6, rf;
 
-	rtlpriv->dm.txpower_trackingInit = true;
+	rtlpriv->dm.txpower_trackinginit = true;
 	RT_TRACE(rtlpriv, COMP_POWER_TRACKING, DBG_LOUD,
 		 ("rtl92c_dm_txpower_tracking_callback_thermalmeter\n"));
 
@@ -1062,7 +1062,7 @@ static void rtl92c_dm_initialize_txpower
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
 
 	rtlpriv->dm.txpower_tracking = true;
-	rtlpriv->dm.txpower_trackingInit = false;
+	rtlpriv->dm.txpower_trackinginit = false;
 
 	RT_TRACE(rtlpriv, COMP_POWER_TRACKING, DBG_LOUD,
 		 ("pMgntInfo->txpower_tracking = %d\n",

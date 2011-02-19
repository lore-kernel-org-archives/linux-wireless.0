Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:49694 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754607Ab1BSW3J (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 19 Feb 2011 17:29:09 -0500
Date: Sat, 19 Feb 2011 16:29:07 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
To: John W Linville <linville@tuxdriver.com>
Cc: george0505@realtek.com, chaoming_li@realsil.com.cn,
	linux-wireless@vger.kernel.org
Subject: [PATCH V2 5/16] rtlwifi: Modify wifi.h for rtl8192cu
Message-ID: <4d604433.J3TQd+HyBRbtW7xj%Larry.Finger@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Further merge of parameters needed for rtl8192cu. In addition,
some changes needed for rtl8192se and rtl8192de are included
and additional Hungarian notation is removed.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---

Index: wireless-testing/drivers/net/wireless/rtlwifi/wifi.h
===================================================================
--- wireless-testing.orig/drivers/net/wireless/rtlwifi/wifi.h
+++ wireless-testing/drivers/net/wireless/rtlwifi/wifi.h
@@ -83,6 +83,19 @@
 #define MAC80211_3ADDR_LEN			24
 #define MAC80211_4ADDR_LEN			30
 
+#define CHANNEL_MAX_NUMBER	(14 + 24 + 21)	/* 14 is the max channel no */
+#define CHANNEL_GROUP_MAX	(3 + 9)	/*  ch1~3, 4~9, 10~14 = three groups */
+#define MAX_PG_GROUP			13
+#define	CHANNEL_GROUP_MAX_2G		3
+#define	CHANNEL_GROUP_IDX_5GL		3
+#define	CHANNEL_GROUP_IDX_5GM		6
+#define	CHANNEL_GROUP_IDX_5GH		9
+#define	CHANNEL_GROUP_MAX_5G		9
+#define CHANNEL_MAX_NUMBER_2G		14
+#define AVG_THERMAL_NUM			8
+
+/* for early mode */
+#define EM_HDR_LEN			8
 enum intf_type {
 	INTF_PCI = 0,
 	INTF_USB = 1,
@@ -114,18 +127,37 @@ enum hardware_type {
 	HARDWARE_TYPE_RTL8192CU,
 	HARDWARE_TYPE_RTL8192DE,
 	HARDWARE_TYPE_RTL8192DU,
+	HARDWARE_TYPE_RTL8723E,
 	HARDWARE_TYPE_RTL8723U,
 
-	/*keep it last*/
+	/* keep it last */
 	HARDWARE_TYPE_NUM
 };
 
+#define IS_HARDWARE_TYPE_8192SU(rtlhal)			\
+	(rtlhal->hw_type == HARDWARE_TYPE_RTL8192SU)
+#define IS_HARDWARE_TYPE_8192SE(rtlhal)			\
+	(rtlhal->hw_type == HARDWARE_TYPE_RTL8192SE)
 #define IS_HARDWARE_TYPE_8192CE(rtlhal)			\
 	(rtlhal->hw_type == HARDWARE_TYPE_RTL8192CE)
 #define IS_HARDWARE_TYPE_8192CU(rtlhal)			\
 	(rtlhal->hw_type == HARDWARE_TYPE_RTL8192CU)
+#define IS_HARDWARE_TYPE_8192DE(rtlhal)			\
+	(rtlhal->hw_type == HARDWARE_TYPE_RTL8192DE)
+#define IS_HARDWARE_TYPE_8192DU(rtlhal)			\
+	(rtlhal->hw_type == HARDWARE_TYPE_RTL8192DU)
+#define IS_HARDWARE_TYPE_8723E(rtlhal)			\
+	(rtlhal->hw_type == HARDWARE_TYPE_RTL8723E)
 #define IS_HARDWARE_TYPE_8723U(rtlhal)			\
 	(rtlhal->hw_type == HARDWARE_TYPE_RTL8723U)
+#define	IS_HARDWARE_TYPE_8192S(rtlhal)			\
+(IS_HARDWARE_TYPE_8192SE(rtlhal) || IS_HARDWARE_TYPE_8192SU(rtlhal))
+#define	IS_HARDWARE_TYPE_8192C(rtlhal)			\
+(IS_HARDWARE_TYPE_8192CE(rtlhal) || IS_HARDWARE_TYPE_8192CU(rtlhal))
+#define	IS_HARDWARE_TYPE_8192D(rtlhal)			\
+(IS_HARDWARE_TYPE_8192DE(rtlhal) || IS_HARDWARE_TYPE_8192DU(rtlhal))
+#define	IS_HARDWARE_TYPE_8723(rtlhal)			\
+(IS_HARDWARE_TYPE_8723E(rtlhal) || IS_HARDWARE_TYPE_8723U(rtlhal))
 
 enum scan_operation_backup_opt {
 	SCAN_OPT_BACKUP = 0,
@@ -324,6 +356,7 @@ enum rf_type {
 	RF_1T1R = 0,
 	RF_1T2R = 1,
 	RF_2T2R = 2,
+	RF_2T2R_GREEN = 3,
 };
 
 enum ht_channel_width {
@@ -408,6 +441,7 @@ enum rtl_var_map {
 	RTL_IMR_ATIMEND,	/*For 92C,ATIM Window End Interrupt */
 	RTL_IMR_BDOK,		/*Beacon Queue DMA OK Interrup */
 	RTL_IMR_HIGHDOK,	/*High Queue DMA OK Interrupt */
+	RTL_IMR_COMDOK,		/*Command Queue DMA OK Interrupt*/
 	RTL_IMR_TBDOK,		/*Transmit Beacon OK interrup */
 	RTL_IMR_MGNTDOK,	/*Management Queue DMA OK Interrupt */
 	RTL_IMR_TBDER,		/*For 92C,Transmit Beacon Error Interrupt */
@@ -416,7 +450,8 @@ enum rtl_var_map {
 	RTL_IMR_VIDOK,		/*AC_VI DMA OK Interrupt */
 	RTL_IMR_VODOK,		/*AC_VO DMA Interrupt */
 	RTL_IMR_ROK,		/*Receive DMA OK Interrupt */
-	RTL_IBSS_INT_MASKS,	/*(RTL_IMR_BcnInt|RTL_IMR_TBDOK|RTL_IMR_TBDER)*/
+	RTL_IBSS_INT_MASKS,	/*(RTL_IMR_BcnInt | RTL_IMR_TBDOK |
+				 * RTL_IMR_TBDER) */
 
 	/*CCK Rates, TxHT = 0 */
 	RTL_RC_CCK_RATE1M,
@@ -492,6 +527,19 @@ enum acm_method {
 	eAcmWay2_SW = 2,
 };
 
+enum macphy_mode {
+	SINGLEMAC_SINGLEPHY = 0,
+	DUALMAC_DUALPHY,
+	DUALMAC_SINGLEPHY,
+};
+
+enum band_type {
+	BAND_ON_2_4G = 0,
+	BAND_ON_5G,
+	BAND_ON_BOTH,
+	BANDMAX
+};
+
 /*aci/aifsn Field.
 Ref: WMM spec 2.2.2: WME Parameter Element, p.12.*/
 union aci_aifsn {
@@ -625,6 +673,8 @@ struct false_alarm_statistics {
 	u32 cnt_rate_illegal;
 	u32 cnt_crc8_fail;
 	u32 cnt_mcs_fail;
+	u32 cnt_fast_fsync_fail;
+	u32 cnt_sb_search_fail;
 	u32 cnt_ofdm_fail;
 	u32 cnt_cck_fail;
 	u32 cnt_all;
@@ -712,6 +762,13 @@ struct rtl_rfkill {
 	bool rfkill_state;	/*0 is off, 1 is on */
 };
 
+#define IQK_MATRIX_REG_NUM	8
+#define IQK_MATRIX_SETTINGS_NUM	(1 + 24 + 21)
+struct iqk_matrix_regs {
+	bool b_iqk_done;
+	long value[1][IQK_MATRIX_REG_NUM];
+};
+
 struct phy_parameters {
 	u16 length;
 	u32 *pdata;
@@ -746,8 +803,9 @@ struct rtl_phy {
 	u8 current_channel;
 	u8 h2c_box_num;
 	u8 set_io_inprogress;
+	u8 lck_inprogress;
 
-	/*record for power tracking*/
+	/* record for power tracking */
 	s32 reg_e94;
 	s32 reg_e9c;
 	s32 reg_ea4;
@@ -764,27 +822,32 @@ struct rtl_phy {
 	u32 iqk_mac_backup[IQK_MAC_REG_NUM];
 	u32 iqk_bb_backup[10];
 
+	/* Dual mac */
+	bool need_iqk;
+	struct iqk_matrix_regs iqk_matrix_regsetting[IQK_MATRIX_SETTINGS_NUM];
+
 	bool rfpi_enable;
 
 	u8 pwrgroup_cnt;
 	u8 cck_high_power;
-	/* 3 groups of pwr diff by rates*/
-	u32 mcs_txpwrlevel_origoffset[4][16];
+	/* MAX_PG_GROUP groups of pwr diff by rates */
+	u32 mcs_txpwrlevel_origoffset[MAX_PG_GROUP][16];
 	u8 default_initialgain[4];
 
-	/*the current Tx power level*/
+	/* the current Tx power level */
 	u8 cur_cck_txpwridx;
 	u8 cur_ofdm24g_txpwridx;
 
 	u32 rfreg_chnlval[2];
 	bool apk_done;
+	u32 reg_rf3c[2];	/* pathA / pathB  */
 
-	/*fsync*/
 	u8 framesync;
 	u32 framesync_c34;
 
 	u8 num_total_rfpath;
 	struct phy_parameters hwparam_tables[MAX_TAB];
+	u16 rf_pathmap;
 };
 
 #define MAX_TID_COUNT				9
@@ -825,12 +888,11 @@ struct rtl_io {
 	int (*writeN_async) (struct rtl_priv *rtlpriv, u32 addr, u16 len,
 			     u8 *pdata);
 
-	 u8(*read8_sync) (struct rtl_priv *rtlpriv, u32 addr);
-	 u16(*read16_sync) (struct rtl_priv *rtlpriv, u32 addr);
-	 u32(*read32_sync) (struct rtl_priv *rtlpriv, u32 addr);
+	u8(*read8_sync) (struct rtl_priv *rtlpriv, u32 addr);
+	u16(*read16_sync) (struct rtl_priv *rtlpriv, u32 addr);
+	u32(*read32_sync) (struct rtl_priv *rtlpriv, u32 addr);
 	int (*readN_sync) (struct rtl_priv *rtlpriv, u32 addr, u16 len,
 			    u8 *pdata);
-
 };
 
 struct rtl_mac {
@@ -862,16 +924,24 @@ struct rtl_mac {
 	bool act_scanning;
 	u8 cnt_after_linked;
 
-	 /*RDG*/ bool rdg_en;
-
-	 /*AP*/ u8 bssid[6];
-	u8 mcs[16];	/*16 bytes mcs for HT rates.*/
-	u32 basic_rates; /*b/g rates*/
+	/* early mode */
+	/* skb wait queue */
+	struct sk_buff_head skb_waitq[MAX_TID_COUNT];
+	u8 earlymode_threshold;
+
+	/*RDG*/
+	bool rdg_en;
+
+	/*AP*/
+	u8 bssid[6];
+	u32 vendor;
+	u8 mcs[16];	/* 16 bytes mcs for HT rates. */
+	u32 basic_rates; /* b/g rates */
 	u8 ht_enable;
 	u8 sgi_40;
 	u8 sgi_20;
 	u8 bw_40;
-	u8 mode;		/*wireless mode*/
+	u8 mode;		/* wireless mode */
 	u8 slot_time;
 	u8 short_preamble;
 	u8 use_cts_protect;
@@ -882,9 +952,11 @@ struct rtl_mac {
 	u8 retry_long;
 	u16 assoc_id;
 
-	 /*IBSS*/ int beacon_interval;
+	/*IBSS*/
+	int beacon_interval;
 
-	 /*AMPDU*/ u8 min_space_cfg;	/*For Min spacing configurations */
+	/*AMPDU*/
+	u8 min_space_cfg;	/*For Min spacing configurations */
 	u8 max_mss_density;
 	u8 current_ampdu_factor;
 	u8 current_ampdu_density;
@@ -899,11 +971,13 @@ struct rtl_hal {
 
 	enum intf_type interface;
 	u16 hw_type;		/*92c or 92d or 92s and so on */
+	u8 ic_class;
 	u8 oem_id;
 	u32 version;		/*version of chip */
 	u8 state;		/*stop 0, start 1 */
 
 	/*firmware */
+	u32 fwsize;
 	u8 *pfirmware;
 	u16 fw_version;
 	u16 fw_subversion;
@@ -912,6 +986,39 @@ struct rtl_hal {
 	bool fw_ready;
 	/*Reserve page start offset except beacon in TxQ. */
 	u8 fw_rsvdpage_startoffset;
+	u8 h2c_txcmd_seq;
+
+	/* FW Cmd IO related */
+	u16 fwcmd_iomap;
+	u32 fwcmd_ioparam;
+	bool set_fwcmd_inprogress;
+	u8 current_fwcmd_io;
+
+	/**/
+	bool driver_going2unload;
+
+	/*AMPDU init min space*/
+	u8 minspace_cfg;	/*For Min spacing configurations */
+
+	/* Dual mac */
+	enum macphy_mode macphymode;
+	enum band_type current_bandtype;	/* 0:2.4G, 1:5G */
+	enum band_type current_bandtypebackup;
+	enum band_type bandset;
+	/* dual MAC 0--Mac0 1--Mac1 */
+	u32 interfaceindex;
+	/* just for DualMac S3S4 */
+	u8 macphyctl_reg;
+	bool earlymode_enable;
+	/* Dual mac*/
+	bool during_mac0init_radiob;
+	bool during_mac1init_radioa;
+	bool reloadtxpowerindex;
+	/* True if IMR or IQK  have done
+	for 2.4G in scan progress */
+	bool load_imrandiqk_setting_for2g;
+
+	bool disable_amsdu_8k;
 };
 
 struct rtl_security {
@@ -936,7 +1043,7 @@ struct rtl_security {
 };
 
 struct rtl_dm {
-	/*PHY status for DM (dynamic management) */
+	/*PHY status for Dynamic Management */
 	long entry_min_undecoratedsmoothed_pwdb;
 	long undecorated_smoothed_pwdb;	/*out dm */
 	long entry_max_undecoratedsmoothed_pwdb;
@@ -951,33 +1058,46 @@ struct rtl_dm {
 	bool txpower_tracking;
 	bool useramask;
 	bool rfpath_rxenable[4];
+	bool inform_fw_driverctrldm;
+	bool current_mrc_switch;
+	u8 txpowercount;
 
+	u8 thermalvalue_rxgain;
 	u8 thermalvalue_iqk;
 	u8 thermalvalue_lck;
 	u8 thermalvalue;
 	u8 last_dtp_lvl;
+	u8 thermalvalue_avg[AVG_THERMAL_NUM];
+	u8 thermalvalue_avg_index;
+	bool done_txpower;
 	u8 dynamic_txhighpower_lvl;	/*Tx high power level */
-	u8 dm_flag;	/*Indicate if each dynamic mechanism's status. */
+	u8 dm_flag;		/*Indicate each dynamic mechanism's status. */
 	u8 dm_type;
 	u8 txpower_track_control;
-
+	bool interrupt_migration;
+	bool disable_tx_int;
 	char ofdm_index[2];
 	char cck_index;
+	u8 power_index_backup[6];
 };
 
-#define	EFUSE_MAX_LOGICAL_SIZE			 256
+#define	EFUSE_MAX_LOGICAL_SIZE			256
 
 struct rtl_efuse {
-	bool autoload_ok;
+	bool autoLoad_ok;
 	bool bootfromefuse;
 	u16 max_physical_size;
-	u8 contents[EFUSE_MAX_LOGICAL_SIZE];
 
 	u8 efuse_map[2][EFUSE_MAX_LOGICAL_SIZE];
 	u16 efuse_usedbytes;
 	u8 efuse_usedpercentage;
+#ifdef EFUSE_REPG_WORKAROUND
+	bool efuse_re_pg_sec1flag;
+	u8 efuse_re_pg_data[8];
+#endif
 
 	u8 autoload_failflag;
+	u8 autoload_status;
 
 	short epromtype;
 	u16 eeprom_vid;
@@ -993,43 +1113,61 @@ struct rtl_efuse {
 	u8 dev_addr[6];
 
 	bool txpwr_fromeprom;
+	u8 eeprom_crystalcap;
 	u8 eeprom_tssi[2];
-	u8 eeprom_pwrlimit_ht20[3];
-	u8 eeprom_pwrlimit_ht40[3];
-	u8 eeprom_chnlarea_txpwr_cck[2][3];
-	u8 eeprom_chnlarea_txpwr_ht40_1s[2][3];
-	u8 eeprom_chnlarea_txpwr_ht40_2sdiif[2][3];
-	u8 txpwrlevel_cck[2][14];
-	u8 txpwrlevel_ht40_1s[2][14];	/*For HT 40MHZ pwr */
-	u8 txpwrlevel_ht40_2s[2][14];	/*For HT 40MHZ pwr */
+	u8 eeprom_tssi_5g[3][2]; /* for 5GL/5GM/5GH band. */
+	u8 eeprom_pwrlimit_ht20[CHANNEL_GROUP_MAX];
+	u8 eeprom_pwrlimit_ht40[CHANNEL_GROUP_MAX];
+	u8 eeprom_chnlarea_txpwr_cck[2][CHANNEL_GROUP_MAX_2G];
+	u8 eeprom_chnlarea_txpwr_ht40_1s[2][CHANNEL_GROUP_MAX];
+	u8 eeprom_chnlarea_txpwr_ht40_2sdiif[2][CHANNEL_GROUP_MAX];
+	u8 txpwrlevel_cck[2][CHANNEL_MAX_NUMBER_2G];
+	u8 txpwrlevel_ht40_1s[2][CHANNEL_MAX_NUMBER];	/*For HT 40MHZ pwr */
+	u8 txpwrlevel_ht40_2s[2][CHANNEL_MAX_NUMBER];	/*For HT 40MHZ pwr */
+
+	u8 internal_pa_5g[2];	/* pathA / pathB */
+	u8 eeprom_c9;
+	u8 eeprom_cc;
 
 	/*For power group */
-	u8 pwrgroup_ht20[2][14];
-	u8 pwrgroup_ht40[2][14];
-
-	char txpwr_ht20diff[2][14];	/*HT 20<->40 Pwr diff */
-	u8 txpwr_legacyhtdiff[2][14];	/*For HT<->legacy pwr diff */
+	u8 eeprom_pwrgroup[2][3];
+	u8 pwrgroup_ht20[2][CHANNEL_MAX_NUMBER];
+	u8 pwrgroup_ht40[2][CHANNEL_MAX_NUMBER];
+
+	char txpwr_ht20diff[2][CHANNEL_MAX_NUMBER]; /*HT 20<->40 Pwr diff */
+	/*For HT<->legacy pwr diff*/
+	u8 txpwr_legacyhtdiff[2][CHANNEL_MAX_NUMBER];
+	u8 txpwr_safetyflag;			/* Band edge enable flag */
+	u16 eeprom_txpowerdiff;
+	u8 legacy_httxpowerdiff;	/* Legacy to HT rate power diff */
+	u8 antenna_txpwdiff[3];
 
 	u8 eeprom_regulatory;
 	u8 eeprom_thermalmeter;
-	/*ThermalMeter, index 0 for RFIC0, and 1 for RFIC1 */
-	u8 thermalmeter[2];
+	u8 thermalmeter[2]; /*ThermalMeter, index 0 for RFIC0, 1 for RFIC1 */
+	u16 tssi_13dbm;
+	u8 crystalcap;		/* CrystalCap. */
+	u8 delta_iqk;
+	u8 delta_lck;
 
 	u8 legacy_ht_txpowerdiff;	/*Legacy to HT rate power diff */
 	bool apk_thermalmeterignore;
+
+	bool b1x1_recvcombine;
+	bool b1ss_support;
+
+	/*channel plan */
+	u8 channel_plan;
 };
 
 struct rtl_ps_ctl {
+	bool pwrdomain_protect;
 	bool set_rfpowerstate_inprogress;
 	bool in_powersavemode;
 	bool rfchange_inprogress;
 	bool swrf_processing;
 	bool hwradiooff;
 
-	u32 last_sleep_jiffies;
-	u32 last_awake_jiffies;
-	u32 last_delaylps_stamp_jiffies;
-
 	/*
 	 * just for PCIE ASPM
 	 * If it supports ASPM, Offset[560h] = 0x40,
@@ -1040,6 +1178,7 @@ struct rtl_ps_ctl {
 
 	/*for LPS */
 	enum rt_psmode dot11_psmode;	/*Power save mode configured. */
+	bool swctrl_lps;
 	bool leisure_ps;
 	bool fwctrl_lps;
 	u8 fwctrl_psmode;
@@ -1063,8 +1202,25 @@ struct rtl_ps_ctl {
 	u8 const_amdpci_aspm;
 
 	bool pwrdown_mode;
+
 	enum rf_pwrstate inactive_pwrstate;
 	enum rf_pwrstate rfpwr_state;	/*cur power state */
+
+	/* for SW LPS*/
+	bool sw_ps_enabled;
+	bool state;
+	bool state_inap;
+	bool multi_buffered;
+	u16 nullfunc_seq;
+	unsigned int dtim_counter;
+	unsigned int sleep_ms;
+	unsigned long last_sleep_jiffies;
+	unsigned long last_awake_jiffies;
+	unsigned long last_delaylps_stamp_jiffies;
+	unsigned long last_dtim;
+	unsigned long last_beacon;
+	unsigned long last_action;
+	unsigned long last_slept;
 };
 
 struct rtl_stats {
@@ -1103,6 +1259,7 @@ struct rtl_stats {
 	u8 rx_drvinfo_size;
 	u8 rx_bufshift;
 	bool isampdu;
+	bool isfirst_ampdu;
 	bool rx_is40Mhzpacket;
 	u32 rx_pwdb_all;
 	u8 rx_mimo_signalstrength[4];	/*in 0~100 index */
@@ -1148,6 +1305,15 @@ struct rtl_tcb_desc {
 	u8 ratr_index;
 	u8 mac_id;
 	u8 hw_rate;
+
+	u8 last_inipkt:1;
+	u8 cmd_or_init:1;
+	u8 queue_index;
+
+	/* early mode */
+	u8 empkt_num;
+	/* The max value by HW */
+	u32 empkt_len[5];
 };
 
 struct rtl_hal_ops {
@@ -1159,6 +1325,8 @@ struct rtl_hal_ops {
 				      u32 *p_inta, u32 *p_intb);
 	int (*hw_init) (struct ieee80211_hw *hw);
 	void (*hw_disable) (struct ieee80211_hw *hw);
+	void (*hw_suspend) (struct ieee80211_hw *hw);
+	void (*hw_resume) (struct ieee80211_hw *hw);
 	void (*enable_interrupt) (struct ieee80211_hw *hw);
 	void (*disable_interrupt) (struct ieee80211_hw *hw);
 	int (*set_network_type) (struct ieee80211_hw *hw,
@@ -1167,7 +1335,7 @@ struct rtl_hal_ops {
 				bool check_bssid);
 	void (*set_bw_mode) (struct ieee80211_hw *hw,
 			     enum nl80211_channel_type ch_type);
-	u8 (*switch_channel) (struct ieee80211_hw *hw);
+	 u8(*switch_channel) (struct ieee80211_hw *hw);
 	void (*set_qos) (struct ieee80211_hw *hw, int aci);
 	void (*set_bcn_reg) (struct ieee80211_hw *hw);
 	void (*set_bcn_intv) (struct ieee80211_hw *hw);
@@ -1219,6 +1387,7 @@ struct rtl_hal_ops {
 
 struct rtl_intf_ops {
 	/*com */
+	void (*read_efuse_byte)(struct ieee80211_hw *hw, u16 _offset, u8 *pbuf);
 	int (*adapter_start) (struct ieee80211_hw *hw);
 	void (*adapter_stop) (struct ieee80211_hw *hw);
 
@@ -1262,6 +1431,7 @@ struct rtl_hal_usbint_cfg {
 };
 
 struct rtl_hal_cfg {
+	u8 bar_id;
 	char *name;
 	char *fw_name;
 	struct rtl_hal_ops *ops;
@@ -1285,7 +1455,11 @@ struct rtl_locks {
 	spinlock_t rf_ps_lock;
 	spinlock_t rf_lock;
 	spinlock_t lps_lock;
+	spinlock_t waitq_lock;
 	spinlock_t tx_urb_lock;
+
+	/*Dual mac*/
+	spinlock_t cck_and_rw_pagea_lock;
 };
 
 struct rtl_works {
@@ -1302,12 +1476,20 @@ struct rtl_works {
 	struct workqueue_struct *rtl_wq;
 	struct delayed_work watchdog_wq;
 	struct delayed_work ips_nic_off_wq;
+
+	/* For SW LPS */
+	struct delayed_work ps_work;
+	struct delayed_work ps_rfon_wq;
 };
 
 struct rtl_debug {
 	u32 dbgp_type[DBGP_TYPE_MAX];
 	u32 global_debuglevel;
 	u64 global_debugcomponents;
+
+	/* add for proc debug */
+	struct proc_dir_entry *proc_dir;
+	char proc_name[20];
 };
 
 struct rtl_priv {
@@ -1358,6 +1540,7 @@ struct rtl_priv {
 #define rtl_efuse(rtlpriv)	(&((rtlpriv)->efuse))
 #define rtl_psc(rtlpriv)	(&((rtlpriv)->psc))
 
+
 /***************************************
     Bluetooth Co-existance Related
 ****************************************/
@@ -1441,6 +1624,7 @@ struct bt_coexist_info {
 
 };
 
+
 /****************************************
 	mem access macro define start
 	Call endian free function when
@@ -1563,10 +1747,15 @@ Set subfield of little-endian 4-byte val
 		((((u8)__val) & BIT_LEN_MASK_8(__bitlen)) << (__bitoffset)) \
 	);
 
+#define	N_BYTE_ALIGMENT(__value, __aligment) ((__aligment == 1) ? \
+	(__value) : (((__value + __aligment - 1) / __aligment) * __aligment))
+
 /****************************************
 	mem access macro define end
 ****************************************/
 
+#define byte(x, n) ((x >> (8 * n)) & 0xff)
+
 #define packet_get_type(_packet) (EF1BYTE((_packet).octet[0]) & 0xFC)
 #define RTL_WATCH_DOG_TIME	2000
 #define MSECS(t)		msecs_to_jiffies(t)
@@ -1587,6 +1776,8 @@ Set subfield of little-endian 4-byte val
 #define	RT_RF_OFF_LEVL_FW_32K		BIT(5)	/*FW in 32k */
 /*Always enable ASPM and Clock Req in initialization.*/
 #define	RT_RF_PS_LEVEL_ALWAYS_ASPM	BIT(6)
+/* no matter RFOFF or SLEEP we set PS_ASPM_LEVL*/
+#define	RT_PS_LEVEL_ASPM		BIT(7)
 /*When LPS is on, disable 2R if no packet is received or transmittd.*/
 #define	RT_RF_LPS_DISALBE_2R		BIT(30)
 #define	RT_RF_LPS_LEVEL_ASPM		BIT(31)	/*LPS with ASPM */
@@ -1601,8 +1792,10 @@ Set subfield of little-endian 4-byte val
 	container_of(container_of(x, struct delayed_work, work), y, z)
 
 #define FILL_OCTET_STRING(_os, _octet, _len)	\
-		(_os).octet = (u8 *)(_octet);		\
-		(_os).length = (_len);
+	do {					\
+		(_os). octet = (u8 *)(_octet);		\
+		(_os). length = (_len);		\
+	} while (0);
 
 #define CP_MACADDR(des, src)		\
 	memcpy((des), (src), ETH_ALEN)
@@ -1695,3 +1888,5 @@ static inline u8 get_rf_type(struct rtl_
 }
 
 #endif
+
+
Index: wireless-testing/drivers/net/wireless/rtlwifi/rtl8192ce/phy.h
===================================================================
--- wireless-testing.orig/drivers/net/wireless/rtlwifi/rtl8192ce/phy.h
+++ wireless-testing/drivers/net/wireless/rtlwifi/rtl8192ce/phy.h
@@ -57,8 +57,6 @@
 #define IQK_MAC_REG_NUM			4
 
 #define RF90_PATH_MAX			2
-#define CHANNEL_MAX_NUMBER		14
-#define CHANNEL_GROUP_MAX		3
 
 #define CT_OFFSET_MAC_ADDR		0X16
 
@@ -78,8 +76,6 @@
 #define CT_OFFSET_CUSTOMER_ID		0x7F
 
 #define RTL92C_MAX_PATH_NUM		2
-#define CHANNEL_MAX_NUMBER		14
-#define CHANNEL_GROUP_MAX		3
 #define LLT_LAST_ENTRY_OF_TX_PKT_BUFFER	255
 enum swchnlcmd_id {
 	CMDID_END,

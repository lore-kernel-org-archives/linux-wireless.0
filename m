Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx51.mymxserver.com ([85.199.173.110]:9919 "EHLO
	mx51.mymxserver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755964AbZJVNfB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Oct 2009 09:35:01 -0400
Message-Id: <20091022133409.461601141@mail.mn-solutions.de>
References: <20091022133043.185554096@mail.mn-solutions.de>
Date: Thu, 22 Oct 2009 15:30:49 +0200
From: Holger Schurig <hs4233@mail.mn-solutions.de>
To: linux-wireless@vger.kernel.org,
	John Linville <linville@tuxdriver.com>,
	Dan Williams <dcbw@redhat.com>
Subject: [PATCH 06/19] libertas: sort variables in struct lbs_private
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Having the variables in logical groups allows us to easier
#ifdef stuff out.

No functional change.

---

Another cfg80211-preparation patch :-)


--- linux-wl.orig/drivers/net/wireless/libertas/dev.h
+++ linux-wl/drivers/net/wireless/libertas/dev.h
@@ -35,113 +35,96 @@
 
 /** Private structure for the MV device */
 struct lbs_private {
+
+	/* Basic networking */
+	struct net_device *dev;
+	u32 connect_status;
+	int infra_open;
+	struct work_struct mcast_work;
+	u32 nr_of_multicastmacaddr;
+	u8 multicastlist[MRVDRV_MAX_MULTICAST_LIST_SIZE][ETH_ALEN];
+
+	/* CFG80211 */
 	struct wireless_dev *wdev;
+
+	/* Mesh */
+	struct net_device *mesh_dev; /* Virtual device */
+	u32 mesh_connect_status;
+	struct lbs_mesh_stats mstats;
 	int mesh_open;
 	int mesh_fw_ver;
-	int infra_open;
 	int mesh_autostart_enabled;
+	uint16_t mesh_tlv;
+	u8 mesh_ssid[IEEE80211_MAX_SSID_LEN + 1];
+	u8 mesh_ssid_len;
+	struct work_struct sync_channel;
 
-	char name[DEV_NAME_LEN];
-
-	void *card;
-	struct net_device *dev;
-
-	struct net_device *mesh_dev; /* Virtual device */
+	/* Monitor mode */
 	struct net_device *rtap_net_dev;
+	u32 monitormode;
 
-	struct iw_statistics wstats;
-	struct lbs_mesh_stats mstats;
+	/* Debugfs */
 	struct dentry *debugfs_dir;
 	struct dentry *debugfs_debug;
 	struct dentry *debugfs_files[6];
-
 	struct dentry *events_dir;
 	struct dentry *debugfs_events_files[6];
-
 	struct dentry *regs_dir;
 	struct dentry *debugfs_regs_files[6];
 
+	/* Hardware debugging */
 	u32 mac_offset;
 	u32 bbp_offset;
 	u32 rf_offset;
+	struct lbs_offset_value offsetvalue;
+
+	/* Power management */
+	u16 psmode;
+	u32 psstate;
+	u8 needtowakeup;
 
-	/** Deep sleep flag */
+	/* Deep sleep */
 	int is_deep_sleep;
-	/** Auto deep sleep enabled flag */
 	int is_auto_deep_sleep_enabled;
-	/** Device wakeup required flag */
 	int wakeup_dev_required;
-	/** Auto deep sleep flag*/
 	int is_activity_detected;
-	/** Auto deep sleep timeout (in miliseconds) */
-	int auto_deep_sleep_timeout;
-
-	/** Deep sleep wait queue */
-	wait_queue_head_t       ds_awake_q;
-
-	/* Download sent:
-	   bit0 1/0=data_sent/data_tx_done,
-	   bit1 1/0=cmd_sent/cmd_tx_done,
-	   all other bits reserved 0 */
-	u8 dnld_sent;
-
-	/** thread to service interrupts */
-	struct task_struct *main_thread;
-	wait_queue_head_t waitq;
-	struct workqueue_struct *work_thread;
-
-	struct work_struct mcast_work;
-
-	/** Scanning */
-	struct delayed_work scan_work;
-	struct delayed_work assoc_work;
-	struct work_struct sync_channel;
-	/* remember which channel was scanned last, != 0 if currently scanning */
-	int scan_channel;
-	u8 scan_ssid[IEEE80211_MAX_SSID_LEN + 1];
-	u8 scan_ssid_len;
+	int auto_deep_sleep_timeout; /* in ms */
+	wait_queue_head_t ds_awake_q;
+	struct timer_list auto_deepsleep_timer;
 
-	/** Hardware access */
+	/* Hardware access */
+	void *card;
+	u8 fw_ready;
+	u8 surpriseremoved;
 	int (*hw_host_to_card) (struct lbs_private *priv, u8 type, u8 *payload, u16 nb);
 	void (*reset_card) (struct lbs_private *priv);
 	int (*enter_deep_sleep) (struct lbs_private *priv);
 	int (*exit_deep_sleep) (struct lbs_private *priv);
 	int (*reset_deep_sleep_wakeup) (struct lbs_private *priv);
 
-	/* Wake On LAN */
-	uint32_t wol_criteria;
-	uint8_t wol_gpio;
-	uint8_t wol_gap;
-
-	/** Wlan adapter data structure*/
-	/** STATUS variables */
+	/* Adapter info (from EEPROM) */
 	u32 fwrelease;
 	u32 fwcapinfo;
+	u16 regioncode;
+	u8 current_addr[ETH_ALEN];
 
-	struct mutex lock;
-
-	/* TX packet ready to be sent... */
-	int tx_pending_len;		/* -1 while building packet */
-
-	u8 tx_pending_buf[LBS_UPLD_SIZE];
-	/* protected by hard_start_xmit serialization */
-
-	/** command-related variables */
+	/* Command download */
+	u8 dnld_sent;
+	/* bit0 1/0=data_sent/data_tx_done,
+	   bit1 1/0=cmd_sent/cmd_tx_done,
+	   all other bits reserved 0 */
 	u16 seqnum;
-
 	struct cmd_ctrl_node *cmd_array;
-	/** Current command */
 	struct cmd_ctrl_node *cur_cmd;
-	int cur_cmd_retcode;
-	/** command Queues */
-	/** Free command buffers */
-	struct list_head cmdfreeq;
-	/** Pending command buffers */
-	struct list_head cmdpendingq;
-
+	struct list_head cmdfreeq;    /* free command buffers */
+	struct list_head cmdpendingq; /* pending command buffers */
 	wait_queue_head_t cmd_pending;
+	struct timer_list command_timer;
+	int nr_retries;
+	int cmd_timed_out;
 
 	/* Command responses sent from the hardware to the driver */
+	int cur_cmd_retcode;
 	u8 resp_idx;
 	u8 resp_buf[2][LBS_UPLD_SIZE];
 	u32 resp_len[2];
@@ -149,90 +132,75 @@
 	/* Events sent from hardware to driver */
 	struct kfifo *event_fifo;
 
-	/* nickname */
-	u8 nodename[16];
-
-	/** spin locks */
-	spinlock_t driver_lock;
-
-	/** Timers */
-	struct timer_list command_timer;
-	struct timer_list auto_deepsleep_timer;
-	int nr_retries;
-	int cmd_timed_out;
-
-	/** current ssid/bssid related parameters*/
-	struct current_bss_params curbssparams;
-
-	uint16_t mesh_tlv;
-	u8 mesh_ssid[IEEE80211_MAX_SSID_LEN + 1];
-	u8 mesh_ssid_len;
-
-	/* IW_MODE_* */
-	u8 mode;
-
-	/* Scan results list */
-	struct list_head network_list;
-	struct list_head network_free_list;
-	struct bss_descriptor *networks;
-
-	u16 beacon_period;
-	u8 beacon_enable;
-	u8 adhoccreate;
-
-	/** capability Info used in Association, start, join */
-	u16 capability;
-
-	/** MAC address information */
-	u8 current_addr[ETH_ALEN];
-	u8 multicastlist[MRVDRV_MAX_MULTICAST_LIST_SIZE][ETH_ALEN];
-	u32 nr_of_multicastmacaddr;
+	/** thread to service interrupts */
+	struct task_struct *main_thread;
+	wait_queue_head_t waitq;
+	struct workqueue_struct *work_thread;
 
-	/** 802.11 statistics */
-//	struct cmd_DS_802_11_GET_STAT wlan802_11Stat;
+	/** Encryption stuff */
+	struct lbs_802_11_security secinfo;
+	struct enc_key wpa_mcast_key;
+	struct enc_key wpa_unicast_key;
+	u8 wpa_ie[MAX_WPA_IE_LEN];
+	u8 wpa_ie_len;
+	u16 wep_tx_keyidx;
+	struct enc_key wep_keys[4];
 
-	uint16_t enablehwauto;
-	uint16_t ratebitmap;
+	/* Wake On LAN */
+	uint32_t wol_criteria;
+	uint8_t wol_gpio;
+	uint8_t wol_gap;
 
+	/* Transmitting */
+	int tx_pending_len;		/* -1 while building packet */
+	u8 tx_pending_buf[LBS_UPLD_SIZE];
+	/* protected by hard_start_xmit serialization */
 	u8 txretrycount;
-
-	/** Tx-related variables (for single packet tx) */
 	struct sk_buff *currenttxskb;
 
-	/** NIC Operation characteristics */
+	/* Locks */
+	struct mutex lock;
+	spinlock_t driver_lock;
+
+	/* NIC/link operation characteristics */
 	u16 mac_control;
-	u32 connect_status;
-	u32 mesh_connect_status;
-	u16 regioncode;
+	u8 radio_on;
 	s16 txpower_cur;
 	s16 txpower_min;
 	s16 txpower_max;
 
-	/** POWER MANAGEMENT AND PnP SUPPORT */
-	u8 surpriseremoved;
-
-	u16 psmode;		/* Wlan802_11PowermodeCAM=disable
-				   Wlan802_11PowermodeMAX_PSP=enable */
-	u32 psstate;
-	u8 needtowakeup;
+	/** Scanning */
+	struct delayed_work scan_work;
+	int scan_channel;
+	/* remember which channel was scanned last, != 0 if currently scanning */
+	u8 scan_ssid[IEEE80211_MAX_SSID_LEN + 1];
+	u8 scan_ssid_len;
 
+	/* Associating */
+	struct delayed_work assoc_work;
+	struct current_bss_params curbssparams;
+	u8 mode;
+	struct list_head network_list;
+	struct list_head network_free_list;
+	struct bss_descriptor *networks;
 	struct assoc_request * pending_assoc_req;
 	struct assoc_request * in_progress_assoc_req;
+	u16 capability;
+	uint16_t enablehwauto;
+	uint16_t ratebitmap;
 
-	/** Encryption parameter */
-	struct lbs_802_11_security secinfo;
-
-	/** WEP keys */
-	struct enc_key wep_keys[4];
-	u16 wep_tx_keyidx;
-
-	/** WPA keys */
-	struct enc_key wpa_mcast_key;
-	struct enc_key wpa_unicast_key;
+	/* ADHOC */
+	u16 beacon_period;
+	u8 beacon_enable;
+	u8 adhoccreate;
 
-	/** WPA Information Elements*/
-	u8 wpa_ie[MAX_WPA_IE_LEN];
-	u8 wpa_ie_len;
+	/* WEXT */
+	char name[DEV_NAME_LEN];
+	u8 nodename[16];
+	struct iw_statistics wstats;
+	u8 cur_rate;
+#define	MAX_REGION_CHANNEL_NUM	2
+	struct region_channel region_channel[MAX_REGION_CHANNEL_NUM];
 
 	/** Requested Signal Strength*/
 	u16 SNR[MAX_TYPE_B][MAX_TYPE_AVG];
@@ -242,23 +210,6 @@
 	u8 rawNF[DEFAULT_DATA_AVG_FACTOR];
 	u16 nextSNRNF;
 	u16 numSNRNF;
-
-	u8 radio_on;
-
-	/** data rate stuff */
-	u8 cur_rate;
-
-	/** RF calibration data */
-
-#define	MAX_REGION_CHANNEL_NUM	2
-	/** region channel data */
-	struct region_channel region_channel[MAX_REGION_CHANNEL_NUM];
-
-	/**	MISCELLANEOUS */
-	struct lbs_offset_value offsetvalue;
-
-	u32 monitormode;
-	u8 fw_ready;
 };
 
 extern struct cmd_confirm_sleep confirm_sleep;

-- 

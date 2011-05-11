Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dakia2.marvell.com ([65.219.4.35]:47303 "EHLO
	dakia2.marvell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753937Ab1EKDm7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 May 2011 23:42:59 -0400
From: Bing Zhao <bzhao@marvell.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Kiran Divekar <dkiran@marvell.com>,
	Yogesh Powar <yogeshp@marvell.com>,
	Marc Yang <yangyang@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH 2/2] mwifiex: cleanup ioctl.h
Date: Tue, 10 May 2011 20:47:36 -0700
Message-Id: <1305085656-12484-2-git-send-email-bzhao@marvell.com> (sfid-20110511_054316_191932_7812F087)
In-Reply-To: <1305085656-12484-1-git-send-email-bzhao@marvell.com>
References: <1305085656-12484-1-git-send-email-bzhao@marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Some structures and macros in ioctl.h are redundant or no longer
used.

Signed-off-by: Bing Zhao <bzhao@marvell.com>
Signed-off-by: Yogesh Ashok Powar <yogeshp@marvell.com>
---
 drivers/net/wireless/mwifiex/cfg80211.c |    9 +---
 drivers/net/wireless/mwifiex/fw.h       |   16 +------
 drivers/net/wireless/mwifiex/ioctl.h    |   81 +------------------------------
 3 files changed, 4 insertions(+), 102 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/cfg80211.c b/drivers/net/wireless/mwifiex/cfg80211.c
index 19be887..660831c 100644
--- a/drivers/net/wireless/mwifiex/cfg80211.c
+++ b/drivers/net/wireless/mwifiex/cfg80211.c
@@ -761,7 +761,6 @@ static int mwifiex_cfg80211_inform_ibss_bss(struct mwifiex_private *priv)
 static int mwifiex_inform_bss_from_scan_result(struct mwifiex_private *priv,
 					       struct mwifiex_802_11_ssid *ssid)
 {
-	struct mwifiex_scan_resp scan_resp;
 	struct mwifiex_bssdescriptor *scan_table;
 	int i, j;
 	struct ieee80211_channel *chan;
@@ -771,10 +770,6 @@ static int mwifiex_inform_bss_from_scan_result(struct mwifiex_private *priv,
 	int beacon_size;
 	u8 element_id, element_len;
 
-	memset(&scan_resp, 0, sizeof(scan_resp));
-	scan_resp.scan_table = (u8 *) priv->adapter->scan_table;
-	scan_resp.num_in_scan_table = priv->adapter->num_in_scan_table;
-
 #define MAX_IE_BUF	2048
 	ie_buf = kzalloc(MAX_IE_BUF, GFP_KERNEL);
 	if (!ie_buf) {
@@ -783,8 +778,8 @@ static int mwifiex_inform_bss_from_scan_result(struct mwifiex_private *priv,
 		return -ENOMEM;
 	}
 
-	scan_table = (struct mwifiex_bssdescriptor *) scan_resp.scan_table;
-	for (i = 0; i < scan_resp.num_in_scan_table; i++) {
+	scan_table = priv->adapter->scan_table;
+	for (i = 0; i < priv->adapter->num_in_scan_table; i++) {
 		if (ssid) {
 			/* Inform specific BSS only */
 			if (memcmp(ssid->ssid, scan_table[i].ssid.ssid,
diff --git a/drivers/net/wireless/mwifiex/fw.h b/drivers/net/wireless/mwifiex/fw.h
index c6b2681..afdd145 100644
--- a/drivers/net/wireless/mwifiex/fw.h
+++ b/drivers/net/wireless/mwifiex/fw.h
@@ -816,14 +816,7 @@ struct host_cmd_ds_txpwr_cfg {
 
 struct mwifiex_scan_cmd_config {
 	/*
-	 *  BSS Type to be sent in the firmware command
-	 *
-	 *  Field can be used to restrict the types of networks returned in the
-	 *    scan.  Valid settings are:
-	 *
-	 *   - MWIFIEX_SCAN_MODE_BSS  (infrastructure)
-	 *   - MWIFIEX_SCAN_MODE_IBSS (adhoc)
-	 *   - MWIFIEX_SCAN_MODE_ANY  (unrestricted, adhoc and infrastructure)
+	 *  BSS mode to be sent in the firmware command
 	 */
 	u8 bss_mode;
 
@@ -866,13 +859,6 @@ struct mwifiex_user_scan_cfg {
 	u8 keep_previous_scan;
 	/*
 	 *  BSS mode to be sent in the firmware command
-	 *
-	 *  Field can be used to restrict the types of networks returned in the
-	 *    scan.  Valid settings are:
-	 *
-	 *   - MWIFIEX_SCAN_MODE_BSS  (infrastructure)
-	 *   - MWIFIEX_SCAN_MODE_IBSS (adhoc)
-	 *   - MWIFIEX_SCAN_MODE_ANY  (unrestricted, adhoc and infrastructure)
 	 */
 	u8 bss_mode;
 	/* Configure the number of probe requests for active chan scans */
diff --git a/drivers/net/wireless/mwifiex/ioctl.h b/drivers/net/wireless/mwifiex/ioctl.h
index 5488e11..7c1c5ee 100644
--- a/drivers/net/wireless/mwifiex/ioctl.h
+++ b/drivers/net/wireless/mwifiex/ioctl.h
@@ -23,49 +23,16 @@
 #include <net/mac80211.h>
 
 enum {
-	MWIFIEX_SCAN_MODE_UNCHANGED = 0,
-	MWIFIEX_SCAN_MODE_BSS,
-	MWIFIEX_SCAN_MODE_IBSS,
-	MWIFIEX_SCAN_MODE_ANY
-};
-
-enum {
 	MWIFIEX_SCAN_TYPE_UNCHANGED = 0,
 	MWIFIEX_SCAN_TYPE_ACTIVE,
 	MWIFIEX_SCAN_TYPE_PASSIVE
 };
 
-struct mwifiex_get_scan_table_fixed {
-	u8 bssid[ETH_ALEN];
-	u8 channel;
-	u8 rssi;
-	long long network_tsf;
-};
-
-struct mwifiex_scan_time_params {
-	u32 specific_scan_time;
-	u32 active_scan_time;
-	u32 passive_scan_time;
-};
-
 struct mwifiex_user_scan {
 	u32 scan_cfg_len;
 	u8 scan_cfg_buf[1];
 };
 
-struct mwifiex_scan_req {
-	u32 scan_mode;
-	u32 scan_type;
-	struct mwifiex_802_11_ssid scan_ssid;
-	struct mwifiex_scan_time_params scan_time;
-	struct mwifiex_user_scan user_scan;
-};
-
-struct mwifiex_scan_resp {
-	u32 num_in_scan_table;
-	u8 *scan_table;
-};
-
 #define MWIFIEX_PROMISC_MODE            1
 #define MWIFIEX_MULTICAST_MODE		2
 #define	MWIFIEX_ALL_MULTI_MODE		4
@@ -77,18 +44,11 @@ struct mwifiex_multicast_list {
 	u8 mac_list[MWIFIEX_MAX_MULTICAST_LIST_SIZE][ETH_ALEN];
 };
 
-#define MWIFIEX_MAX_CHANNEL_NUM		128
-
 struct mwifiex_chan_freq {
 	u32 channel;
 	u32 freq;
 };
 
-struct mwifiex_chan_list {
-	u32 num_of_chan;
-	struct mwifiex_chan_freq cf[MWIFIEX_MAX_CHANNEL_NUM];
-};
-
 struct mwifiex_ssid_bssid {
 	struct mwifiex_802_11_ssid ssid;
 	u8 bssid[ETH_ALEN];
@@ -136,18 +96,8 @@ struct mwifiex_ds_get_stats {
 	u32 wep_icv_error[4];
 };
 
-#define BCN_RSSI_LAST_MASK              0x00000001
 #define BCN_RSSI_AVG_MASK               0x00000002
-#define DATA_RSSI_LAST_MASK             0x00000004
-#define DATA_RSSI_AVG_MASK              0x00000008
-#define BCN_SNR_LAST_MASK               0x00000010
-#define BCN_SNR_AVG_MASK                0x00000020
-#define DATA_SNR_LAST_MASK              0x00000040
-#define DATA_SNR_AVG_MASK               0x00000080
-#define BCN_NF_LAST_MASK                0x00000100
 #define BCN_NF_AVG_MASK                 0x00000200
-#define DATA_NF_LAST_MASK               0x00000400
-#define DATA_NF_AVG_MASK                0x00000800
 #define ALL_RSSI_INFO_MASK              0x00000fff
 
 struct mwifiex_ds_get_signal {
@@ -174,11 +124,6 @@ struct mwifiex_ds_get_signal {
 	s16 data_nf_avg;
 };
 
-struct mwifiex_fw_info {
-	u32 fw_ver;
-	u8 mac_addr[ETH_ALEN];
-};
-
 #define MWIFIEX_MAX_VER_STR_LEN    128
 
 struct mwifiex_ver_ext {
@@ -286,11 +231,6 @@ struct mwifiex_rate_cfg {
 	u32 rate;
 };
 
-struct mwifiex_data_rate {
-	u32 tx_data_rate;
-	u32 rx_data_rate;
-};
-
 struct mwifiex_power_cfg {
 	u32 is_power_auto;
 	u32 power_level;
@@ -309,21 +249,14 @@ struct mwifiex_ds_hs_cfg {
 };
 
 #define DEEP_SLEEP_ON  1
-#define DEEP_SLEEP_OFF 0
-
 #define DEEP_SLEEP_IDLE_TIME	100
+#define PS_MODE_AUTO		1
 
 struct mwifiex_ds_auto_ds {
 	u16 auto_ds;
 	u16 idle_time;
 };
 
-#define PS_MODE_UNCHANGED			0
-#define PS_MODE_AUTO				1
-#define PS_MODE_POLL				2
-#define PS_MODE_NULL				3
-
-
 struct mwifiex_ds_pm_cfg {
 	union {
 		u32 ps_mode;
@@ -333,18 +266,6 @@ struct mwifiex_ds_pm_cfg {
 	} param;
 };
 
-struct mwifiex_ioctl_wmm_queue_status_ac {
-	u8 wmm_acm;
-	u8 flow_required;
-	u8 flow_created;
-	u8 disabled;
-};
-
-struct mwifiex_ds_wmm_queue_status {
-	struct mwifiex_ioctl_wmm_queue_status_ac
-		ac_status[IEEE80211_MAX_QUEUES];
-};
-
 struct mwifiex_ds_11n_tx_cfg {
 	u16 tx_htcap;
 	u16 tx_htinfo;
-- 
1.7.0.2


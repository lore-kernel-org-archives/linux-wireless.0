Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dakia2.marvell.com ([65.219.4.35]:38393 "EHLO
	dakia2.marvell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751212Ab1HKBr7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Aug 2011 21:47:59 -0400
From: Bing Zhao <bzhao@marvell.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Kiran Divekar <dkiran@marvell.com>,
	Yogesh Powar <yogeshp@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH] mwifiex: use cfg80211 dynamic scan table and cfg80211_get_bss API
Date: Wed, 10 Aug 2011 18:53:57 -0700
Message-Id: <1313027637-21196-1-git-send-email-bzhao@marvell.com> (sfid-20110811_034806_608104_9B2E8064)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Amitkumar Karwar <akarwar@marvell.com>

Instead of maintaining static scan table in driver, scan list is sent
to cfg80211 stack (after parsing each scan command response).
In assoc handler (for infra and ibss network) requested BSS information
is retrieved using cfg80211_get_bss() API.

With the changes above some redundant code are removed.

Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
Signed-off-by: Yogesh Ashok Powar <yogeshp@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/cfg80211.c  |  207 +----
 drivers/net/wireless/mwifiex/fw.h        |   15 +-
 drivers/net/wireless/mwifiex/init.c      |   21 -
 drivers/net/wireless/mwifiex/join.c      |   32 -
 drivers/net/wireless/mwifiex/main.h      |   49 +-
 drivers/net/wireless/mwifiex/scan.c      | 1576 ++++++------------------------
 drivers/net/wireless/mwifiex/sta_event.c |    5 -
 drivers/net/wireless/mwifiex/sta_ioctl.c |  202 +++--
 8 files changed, 472 insertions(+), 1635 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/cfg80211.c b/drivers/net/wireless/mwifiex/cfg80211.c
index c979a90..6fd53e4 100644
--- a/drivers/net/wireless/mwifiex/cfg80211.c
+++ b/drivers/net/wireless/mwifiex/cfg80211.c
@@ -793,139 +793,6 @@ static int mwifiex_cfg80211_inform_ibss_bss(struct mwifiex_private *priv)
 }
 
 /*
- * This function informs the CFG802.11 subsystem of a new BSS connection.
- *
- * The following information are sent to the CFG802.11 subsystem
- * to register the new BSS connection. If we do not register the new BSS,
- * a kernel panic will result.
- *      - MAC address
- *      - Capabilities
- *      - Beacon period
- *      - RSSI value
- *      - Channel
- *      - Supported rates IE
- *      - Extended capabilities IE
- *      - DS parameter set IE
- *      - HT Capability IE
- *      - Vendor Specific IE (221)
- *      - WPA IE
- *      - RSN IE
- */
-static int mwifiex_inform_bss_from_scan_result(struct mwifiex_private *priv,
-					       struct mwifiex_802_11_ssid *ssid)
-{
-	struct mwifiex_bssdescriptor *scan_table;
-	int i, j;
-	struct ieee80211_channel *chan;
-	u8 *ie, *ie_buf;
-	u32 ie_len;
-	u8 *beacon;
-	int beacon_size;
-	u8 element_id, element_len;
-
-#define MAX_IE_BUF	2048
-	ie_buf = kzalloc(MAX_IE_BUF, GFP_KERNEL);
-	if (!ie_buf) {
-		dev_err(priv->adapter->dev, "%s: failed to alloc ie_buf\n",
-						__func__);
-		return -ENOMEM;
-	}
-
-	scan_table = priv->adapter->scan_table;
-	for (i = 0; i < priv->adapter->num_in_scan_table; i++) {
-		if (ssid) {
-			/* Inform specific BSS only */
-			if (memcmp(ssid->ssid, scan_table[i].ssid.ssid,
-					   ssid->ssid_len))
-				continue;
-		}
-		memset(ie_buf, 0, MAX_IE_BUF);
-		ie_buf[0] = WLAN_EID_SSID;
-		ie_buf[1] = scan_table[i].ssid.ssid_len;
-		memcpy(&ie_buf[sizeof(struct ieee_types_header)],
-		       scan_table[i].ssid.ssid, ie_buf[1]);
-
-		ie = ie_buf + ie_buf[1] + sizeof(struct ieee_types_header);
-		ie_len = ie_buf[1] + sizeof(struct ieee_types_header);
-
-		ie[0] = WLAN_EID_SUPP_RATES;
-
-		for (j = 0; j < sizeof(scan_table[i].supported_rates); j++) {
-			if (!scan_table[i].supported_rates[j])
-				break;
-			else
-				ie[j + sizeof(struct ieee_types_header)] =
-					scan_table[i].supported_rates[j];
-		}
-
-		ie[1] = j;
-		ie_len += ie[1] + sizeof(struct ieee_types_header);
-
-		beacon = scan_table[i].beacon_buf;
-		beacon_size = scan_table[i].beacon_buf_size;
-
-		/* Skip time stamp, beacon interval and capability */
-
-		if (beacon) {
-			beacon += sizeof(scan_table[i].beacon_period)
-				+ sizeof(scan_table[i].time_stamp) +
-				+sizeof(scan_table[i].cap_info_bitmap);
-
-			beacon_size -= sizeof(scan_table[i].beacon_period)
-				+ sizeof(scan_table[i].time_stamp)
-				+ sizeof(scan_table[i].cap_info_bitmap);
-		}
-
-		while (beacon_size >= sizeof(struct ieee_types_header)) {
-			ie = ie_buf + ie_len;
-			element_id = *beacon;
-			element_len = *(beacon + 1);
-			if (beacon_size < (int) element_len +
-			    sizeof(struct ieee_types_header)) {
-				dev_err(priv->adapter->dev, "%s: in processing"
-					" IE, bytes left < IE length\n",
-					__func__);
-				break;
-			}
-			switch (element_id) {
-			case WLAN_EID_EXT_CAPABILITY:
-			case WLAN_EID_DS_PARAMS:
-			case WLAN_EID_HT_CAPABILITY:
-			case WLAN_EID_VENDOR_SPECIFIC:
-			case WLAN_EID_RSN:
-			case WLAN_EID_BSS_AC_ACCESS_DELAY:
-				ie[0] = element_id;
-				ie[1] = element_len;
-				memcpy(&ie[sizeof(struct ieee_types_header)],
-				       (u8 *) beacon
-				       + sizeof(struct ieee_types_header),
-				       element_len);
-				ie_len += ie[1] +
-					sizeof(struct ieee_types_header);
-				break;
-			default:
-				break;
-			}
-			beacon += element_len +
-					sizeof(struct ieee_types_header);
-			beacon_size -= element_len +
-					sizeof(struct ieee_types_header);
-		}
-		chan = ieee80211_get_channel(priv->wdev->wiphy,
-						scan_table[i].freq);
-		cfg80211_inform_bss(priv->wdev->wiphy, chan,
-					scan_table[i].mac_address,
-					0, scan_table[i].cap_info_bitmap,
-					scan_table[i].beacon_period,
-					ie_buf, ie_len,
-					scan_table[i].rssi, GFP_KERNEL);
-	}
-
-	kfree(ie_buf);
-	return 0;
-}
-
-/*
  * This function connects with a BSS.
  *
  * This function handles both Infra and Ad-Hoc modes. It also performs
@@ -937,8 +804,7 @@ static int mwifiex_inform_bss_from_scan_result(struct mwifiex_private *priv,
  * For Infra mode, the function returns failure if the specified SSID
  * is not found in scan table. However, for Ad-Hoc mode, it can create
  * the IBSS if it does not exist. On successful completion in either case,
- * the function notifies the CFG802.11 subsystem of the new BSS connection,
- * otherwise the kernel will panic.
+ * the function notifies the CFG802.11 subsystem of the new BSS connection.
  */
 static int
 mwifiex_cfg80211_assoc(struct mwifiex_private *priv, size_t ssid_len, u8 *ssid,
@@ -946,11 +812,11 @@ mwifiex_cfg80211_assoc(struct mwifiex_private *priv, size_t ssid_len, u8 *ssid,
 		       struct cfg80211_connect_params *sme, bool privacy)
 {
 	struct mwifiex_802_11_ssid req_ssid;
-	struct mwifiex_ssid_bssid ssid_bssid;
 	int ret, auth_type = 0;
+	struct cfg80211_bss *bss = NULL;
+	u8 is_scanning_required = 0;
 
 	memset(&req_ssid, 0, sizeof(struct mwifiex_802_11_ssid));
-	memset(&ssid_bssid, 0, sizeof(struct mwifiex_ssid_bssid));
 
 	req_ssid.ssid_len = ssid_len;
 	if (ssid_len > IEEE80211_MAX_SSID_LEN) {
@@ -1028,30 +894,48 @@ done:
 		return -EFAULT;
 	}
 
+	/*
+	 * Scan entries are valid for some time (15 sec). So we can save one
+	 * active scan time if we just try cfg80211_get_bss first. If it fails
+	 * then request scan and cfg80211_get_bss() again for final output.
+	 */
+	while (1) {
+		if (is_scanning_required) {
+			/* Do specific SSID scanning */
+			if (mwifiex_request_scan(priv, &req_ssid)) {
+				dev_err(priv->adapter->dev, "scan error\n");
+				return -EFAULT;
+			}
+		}
 
-	memcpy(&ssid_bssid.ssid, &req_ssid, sizeof(struct mwifiex_802_11_ssid));
-
-	if (mode != NL80211_IFTYPE_ADHOC) {
-		if (mwifiex_find_best_bss(priv, &ssid_bssid))
-			return -EFAULT;
-		/* Inform the BSS information to kernel, otherwise
-		 * kernel will give a panic after successful assoc */
-		if (mwifiex_inform_bss_from_scan_result(priv, &req_ssid))
-			return -EFAULT;
+		/* Find the BSS we want using available scan results */
+		if (mode == NL80211_IFTYPE_ADHOC)
+			bss = cfg80211_get_bss(priv->wdev->wiphy, channel,
+					       bssid, ssid, ssid_len,
+					       WLAN_CAPABILITY_IBSS,
+					       WLAN_CAPABILITY_IBSS);
+		else
+			bss = cfg80211_get_bss(priv->wdev->wiphy, channel,
+					       bssid, ssid, ssid_len,
+					       WLAN_CAPABILITY_ESS,
+					       WLAN_CAPABILITY_ESS);
+
+		if (!bss) {
+			if (is_scanning_required) {
+				dev_warn(priv->adapter->dev, "assoc: requested "
+					 "bss not found in scan results\n");
+				break;
+			}
+			is_scanning_required = 1;
+		} else {
+			dev_dbg(priv->adapter->dev, "info: trying to associate to %s and bssid %pM\n",
+					(char *) req_ssid.ssid, bss->bssid);
+			memcpy(&priv->cfg_bssid, bss->bssid, ETH_ALEN);
+			break;
+		}
 	}
 
-	dev_dbg(priv->adapter->dev, "info: trying to associate to %s and bssid %pM\n",
-	       (char *) req_ssid.ssid, ssid_bssid.bssid);
-
-	memcpy(&priv->cfg_bssid, ssid_bssid.bssid, 6);
-
-	/* Connect to BSS by ESSID */
-	memset(&ssid_bssid.bssid, 0, ETH_ALEN);
-
-	if (!netif_queue_stopped(priv->netdev))
-		netif_stop_queue(priv->netdev);
-
-	if (mwifiex_bss_start(priv, &ssid_bssid))
+	if (mwifiex_bss_start(priv, bss, &req_ssid))
 		return -EFAULT;
 
 	if (mode == NL80211_IFTYPE_ADHOC) {
@@ -1416,13 +1300,8 @@ mwifiex_cfg80211_results(struct work_struct *work)
 					MWIFIEX_SCAN_TYPE_ACTIVE;
 			scan_req->chan_list[i].scan_time = 0;
 		}
-		if (mwifiex_set_user_scan_ioctl(priv, scan_req)) {
+		if (mwifiex_set_user_scan_ioctl(priv, scan_req))
 			ret = -EFAULT;
-			goto done;
-		}
-		if (mwifiex_inform_bss_from_scan_result(priv, NULL))
-			ret = -EFAULT;
-done:
 		priv->scan_result_status = ret;
 		dev_dbg(priv->adapter->dev, "info: %s: sending scan results\n",
 							__func__);
diff --git a/drivers/net/wireless/mwifiex/fw.h b/drivers/net/wireless/mwifiex/fw.h
index 4fee099..f23ec72 100644
--- a/drivers/net/wireless/mwifiex/fw.h
+++ b/drivers/net/wireless/mwifiex/fw.h
@@ -821,6 +821,14 @@ struct host_cmd_ds_txpwr_cfg {
 	__le32 mode;
 } __packed;
 
+struct mwifiex_bcn_param {
+	u8 bssid[ETH_ALEN];
+	u8 rssi;
+	__le32 timestamp[2];
+	__le16 beacon_period;
+	__le16 cap_info_bitmap;
+} __packed;
+
 #define MWIFIEX_USER_SCAN_CHAN_MAX             50
 
 #define MWIFIEX_MAX_SSID_LIST_LENGTH         10
@@ -862,13 +870,6 @@ struct mwifiex_user_scan_ssid {
 
 struct mwifiex_user_scan_cfg {
 	/*
-	 *  Flag set to keep the previous scan table intact
-	 *
-	 *  If set, the scan results will accumulate, replacing any previous
-	 *   matched entries for a BSS with the new scan data
-	 */
-	u8 keep_previous_scan;
-	/*
 	 *  BSS mode to be sent in the firmware command
 	 */
 	u8 bss_mode;
diff --git a/drivers/net/wireless/mwifiex/init.c b/drivers/net/wireless/mwifiex/init.c
index a57c8de..26e685a 100644
--- a/drivers/net/wireless/mwifiex/init.c
+++ b/drivers/net/wireless/mwifiex/init.c
@@ -152,19 +152,6 @@ static int mwifiex_init_priv(struct mwifiex_private *priv)
 static int mwifiex_allocate_adapter(struct mwifiex_adapter *adapter)
 {
 	int ret;
-	u32 buf_size;
-	struct mwifiex_bssdescriptor *temp_scan_table;
-
-	/* Allocate buffer to store the BSSID list */
-	buf_size = sizeof(struct mwifiex_bssdescriptor) * MWIFIEX_MAX_AP;
-	temp_scan_table = kzalloc(buf_size, GFP_KERNEL);
-	if (!temp_scan_table) {
-		dev_err(adapter->dev, "%s: failed to alloc temp_scan_table\n",
-		       __func__);
-		return -ENOMEM;
-	}
-
-	adapter->scan_table = temp_scan_table;
 
 	/* Allocate command buffer */
 	ret = mwifiex_alloc_cmd_buffer(adapter);
@@ -222,14 +209,8 @@ static void mwifiex_init_adapter(struct mwifiex_adapter *adapter)
 	adapter->active_scan_time = MWIFIEX_ACTIVE_SCAN_CHAN_TIME;
 	adapter->passive_scan_time = MWIFIEX_PASSIVE_SCAN_CHAN_TIME;
 
-	adapter->num_in_scan_table = 0;
-	memset(adapter->scan_table, 0,
-	       (sizeof(struct mwifiex_bssdescriptor) * MWIFIEX_MAX_AP));
 	adapter->scan_probes = 1;
 
-	memset(adapter->bcn_buf, 0, sizeof(adapter->bcn_buf));
-	adapter->bcn_buf_end = adapter->bcn_buf;
-
 	adapter->multiple_dtim = 1;
 
 	adapter->local_listen_interval = 0;	/* default value in firmware
@@ -326,8 +307,6 @@ mwifiex_free_adapter(struct mwifiex_adapter *adapter)
 	del_timer(&adapter->cmd_timer);
 
 	dev_dbg(adapter->dev, "info: free scan table\n");
-	kfree(adapter->scan_table);
-	adapter->scan_table = NULL;
 
 	adapter->if_ops.cleanup_if(adapter);
 
diff --git a/drivers/net/wireless/mwifiex/join.c b/drivers/net/wireless/mwifiex/join.c
index 644e2e4..5cdad92 100644
--- a/drivers/net/wireless/mwifiex/join.c
+++ b/drivers/net/wireless/mwifiex/join.c
@@ -224,32 +224,6 @@ mwifiex_setup_rates_from_bssdesc(struct mwifiex_private *priv,
 }
 
 /*
- * This function updates the scan entry TSF timestamps to reflect
- * a new association.
- */
-static void
-mwifiex_update_tsf_timestamps(struct mwifiex_private *priv,
-			      struct mwifiex_bssdescriptor *new_bss_desc)
-{
-	struct mwifiex_adapter *adapter = priv->adapter;
-	u32 table_idx;
-	long long new_tsf_base;
-	signed long long tsf_delta;
-
-	memcpy(&new_tsf_base, new_bss_desc->time_stamp, sizeof(new_tsf_base));
-
-	tsf_delta = new_tsf_base - new_bss_desc->network_tsf;
-
-	dev_dbg(adapter->dev, "info: TSF: update TSF timestamps, "
-		"0x%016llx -> 0x%016llx\n",
-	       new_bss_desc->network_tsf, new_tsf_base);
-
-	for (table_idx = 0; table_idx < adapter->num_in_scan_table;
-	     table_idx++)
-		adapter->scan_table[table_idx].network_tsf += tsf_delta;
-}
-
-/*
  * This function appends a WAPI IE.
  *
  * This function is called from the network join command preparation routine.
@@ -639,12 +613,6 @@ int mwifiex_ret_802_11_associate(struct mwifiex_private *priv,
 
 	priv->curr_bss_params.band = (u8) bss_desc->bss_band;
 
-	/*
-	 * Adjust the timestamps in the scan table to be relative to the newly
-	 * associated AP's TSF
-	 */
-	mwifiex_update_tsf_timestamps(priv, bss_desc);
-
 	if (bss_desc->wmm_ie.vend_hdr.element_id == WLAN_EID_VENDOR_SPECIFIC)
 		priv->curr_bss_params.wmm_enabled = true;
 	else
diff --git a/drivers/net/wireless/mwifiex/main.h b/drivers/net/wireless/mwifiex/main.h
index e6db047..e6b6c0c 100644
--- a/drivers/net/wireless/mwifiex/main.h
+++ b/drivers/net/wireless/mwifiex/main.h
@@ -229,21 +229,6 @@ struct ieee_types_header {
 	u8 len;
 } __packed;
 
-struct ieee_obss_scan_param {
-	u16 obss_scan_passive_dwell;
-	u16 obss_scan_active_dwell;
-	u16 bss_chan_width_trigger_scan_int;
-	u16 obss_scan_passive_total;
-	u16 obss_scan_active_total;
-	u16 bss_width_chan_trans_delay;
-	u16 obss_scan_active_threshold;
-} __packed;
-
-struct ieee_types_obss_scan_param {
-	struct ieee_types_header ieee_hdr;
-	struct ieee_obss_scan_param obss_scan;
-} __packed;
-
 #define MWIFIEX_SUPPORTED_RATES                 14
 
 #define MWIFIEX_SUPPORTED_RATES_EXT             32
@@ -291,8 +276,6 @@ struct mwifiex_bssdescriptor {
 	u16 bss_co_2040_offset;
 	u8 *bcn_ext_cap;
 	u16 ext_cap_offset;
-	struct ieee_types_obss_scan_param *bcn_obss_scan;
-	u16 overlap_bss_offset;
 	struct ieee_types_vendor_specific *bcn_wpa_ie;
 	u16 wpa_offset;
 	struct ieee_types_generic *bcn_rsn_ie;
@@ -301,8 +284,6 @@ struct mwifiex_bssdescriptor {
 	u16 wapi_offset;
 	u8 *beacon_buf;
 	u32 beacon_buf_size;
-	u32 beacon_buf_size_max;
-
 };
 
 struct mwifiex_current_bss_params {
@@ -624,15 +605,11 @@ struct mwifiex_adapter {
 	u32 scan_processing;
 	u16 region_code;
 	struct mwifiex_802_11d_domain_reg domain_reg;
-	struct mwifiex_bssdescriptor *scan_table;
-	u32 num_in_scan_table;
 	u16 scan_probes;
 	u32 scan_mode;
 	u16 specific_scan_time;
 	u16 active_scan_time;
 	u16 passive_scan_time;
-	u8 bcn_buf[MAX_SCAN_BEACON_BUFFER];
-	u8 *bcn_buf_end;
 	u8 fw_bands;
 	u8 adhoc_start_band;
 	u8 config_bands;
@@ -765,13 +742,6 @@ void mwifiex_queue_scan_cmd(struct mwifiex_private *priv,
 			    struct cmd_ctrl_node *cmd_node);
 int mwifiex_ret_802_11_scan(struct mwifiex_private *priv,
 			    struct host_cmd_ds_command *resp);
-s32 mwifiex_find_ssid_in_list(struct mwifiex_private *priv,
-				struct mwifiex_802_11_ssid *ssid, u8 *bssid,
-				u32 mode);
-s32 mwifiex_find_bssid_in_list(struct mwifiex_private *priv, u8 *bssid,
-				 u32 mode);
-int mwifiex_find_best_network(struct mwifiex_private *priv,
-			      struct mwifiex_ssid_bssid *req_ssid_bssid);
 s32 mwifiex_ssid_cmp(struct mwifiex_802_11_ssid *ssid1,
 		       struct mwifiex_802_11_ssid *ssid2);
 int mwifiex_associate(struct mwifiex_private *priv,
@@ -782,7 +752,6 @@ int mwifiex_cmd_802_11_associate(struct mwifiex_private *priv,
 int mwifiex_ret_802_11_associate(struct mwifiex_private *priv,
 				 struct host_cmd_ds_command *resp);
 void mwifiex_reset_connect_state(struct mwifiex_private *priv);
-void mwifiex_2040_coex_event(struct mwifiex_private *priv);
 u8 mwifiex_band_to_radio_type(u8 band);
 int mwifiex_deauthenticate(struct mwifiex_private *priv, u8 *mac);
 int mwifiex_adhoc_start(struct mwifiex_private *priv,
@@ -922,8 +891,8 @@ int mwifiex_request_set_multicast_list(struct mwifiex_private *priv,
 int mwifiex_copy_mcast_addr(struct mwifiex_multicast_list *mlist,
 			    struct net_device *dev);
 int mwifiex_wait_queue_complete(struct mwifiex_adapter *adapter);
-int mwifiex_bss_start(struct mwifiex_private *priv,
-		      struct mwifiex_ssid_bssid *ssid_bssid);
+int mwifiex_bss_start(struct mwifiex_private *priv, struct cfg80211_bss *bss,
+		      struct mwifiex_802_11_ssid *req_ssid);
 int mwifiex_set_hs_params(struct mwifiex_private *priv,
 			      u16 action, int cmd_type,
 			      struct mwifiex_ds_hs_cfg *hscfg);
@@ -934,8 +903,6 @@ int mwifiex_get_signal_info(struct mwifiex_private *priv,
 			    struct mwifiex_ds_get_signal *signal);
 int mwifiex_drv_get_data_rate(struct mwifiex_private *priv,
 			      struct mwifiex_rate_cfg *rate);
-int mwifiex_find_best_bss(struct mwifiex_private *priv,
-			  struct mwifiex_ssid_bssid *ssid_bssid);
 int mwifiex_request_scan(struct mwifiex_private *priv,
 			 struct mwifiex_802_11_ssid *req_ssid);
 int mwifiex_set_user_scan_ioctl(struct mwifiex_private *priv,
@@ -984,12 +951,20 @@ int mwifiex_main_process(struct mwifiex_adapter *);
 
 int mwifiex_bss_set_channel(struct mwifiex_private *,
 			    struct mwifiex_chan_freq_power *cfp);
-int mwifiex_bss_ioctl_find_bss(struct mwifiex_private *,
-			       struct mwifiex_ssid_bssid *);
 int mwifiex_set_radio_band_cfg(struct mwifiex_private *,
 			 struct mwifiex_ds_band_cfg *);
 int mwifiex_get_bss_info(struct mwifiex_private *,
 			 struct mwifiex_bss_info *);
+int mwifiex_fill_new_bss_desc(struct mwifiex_private *priv,
+			      u8 *bssid, s32 rssi, u8 *ie_buf,
+			      size_t ie_len, u16 beacon_period,
+			      u16 cap_info_bitmap,
+			      struct mwifiex_bssdescriptor *bss_desc);
+int mwifiex_update_bss_desc_with_ie(struct mwifiex_adapter *adapter,
+				struct mwifiex_bssdescriptor *bss_entry,
+				u8 *ie_buf, u32 ie_len);
+int mwifiex_check_network_compatibility(struct mwifiex_private *priv,
+					struct mwifiex_bssdescriptor *bss_desc);
 
 #ifdef CONFIG_DEBUG_FS
 void mwifiex_debugfs_init(void);
diff --git a/drivers/net/wireless/mwifiex/scan.c b/drivers/net/wireless/mwifiex/scan.c
index 1fdfd41..b28241c 100644
--- a/drivers/net/wireless/mwifiex/scan.c
+++ b/drivers/net/wireless/mwifiex/scan.c
@@ -172,36 +172,6 @@ mwifiex_ssid_cmp(struct mwifiex_802_11_ssid *ssid1,
 }
 
 /*
- * Sends IOCTL request to get the best BSS.
- *
- * This function allocates the IOCTL request buffer, fills it
- * with requisite parameters and calls the IOCTL handler.
- */
-int mwifiex_find_best_bss(struct mwifiex_private *priv,
-			  struct mwifiex_ssid_bssid *ssid_bssid)
-{
-	struct mwifiex_ssid_bssid tmp_ssid_bssid;
-	u8 *mac;
-
-	if (!ssid_bssid)
-		return -1;
-
-	memcpy(&tmp_ssid_bssid, ssid_bssid,
-	       sizeof(struct mwifiex_ssid_bssid));
-
-	if (!mwifiex_bss_ioctl_find_bss(priv, &tmp_ssid_bssid)) {
-		memcpy(ssid_bssid, &tmp_ssid_bssid,
-		       sizeof(struct mwifiex_ssid_bssid));
-		mac = (u8 *) &ssid_bssid->bssid;
-		dev_dbg(priv->adapter->dev, "cmd: found network: ssid=%s,"
-				" %pM\n", ssid_bssid->ssid.ssid, mac);
-		return 0;
-	}
-
-	return -1;
-}
-
-/*
  * Sends IOCTL request to start a scan with user configurations.
  *
  * This function allocates the IOCTL request buffer, fills it
@@ -286,8 +256,7 @@ mwifiex_is_network_compatible_for_static_wep(struct mwifiex_private *priv,
  */
 static bool
 mwifiex_is_network_compatible_for_wpa(struct mwifiex_private *priv,
-				      struct mwifiex_bssdescriptor *bss_desc,
-				      int index)
+				      struct mwifiex_bssdescriptor *bss_desc)
 {
 	if (priv->sec_info.wep_status == MWIFIEX_802_11_WEP_DISABLED
 	    && priv->sec_info.wpa_enabled && !priv->sec_info.wpa2_enabled
@@ -298,9 +267,9 @@ mwifiex_is_network_compatible_for_wpa(struct mwifiex_private *priv,
 	    * LinkSys WRT54G && bss_desc->privacy
 	    */
 	 ) {
-		dev_dbg(priv->adapter->dev, "info: %s: WPA: index=%d"
+		dev_dbg(priv->adapter->dev, "info: %s: WPA:"
 			" wpa_ie=%#x wpa2_ie=%#x WEP=%s WPA=%s WPA2=%s "
-			"EncMode=%#x privacy=%#x\n", __func__, index,
+			"EncMode=%#x privacy=%#x\n", __func__,
 			(bss_desc->bcn_wpa_ie) ?
 			(*(bss_desc->bcn_wpa_ie)).
 			vend_hdr.element_id : 0,
@@ -324,8 +293,7 @@ mwifiex_is_network_compatible_for_wpa(struct mwifiex_private *priv,
  */
 static bool
 mwifiex_is_network_compatible_for_wpa2(struct mwifiex_private *priv,
-				       struct mwifiex_bssdescriptor *bss_desc,
-				       int index)
+				       struct mwifiex_bssdescriptor *bss_desc)
 {
 	if (priv->sec_info.wep_status == MWIFIEX_802_11_WEP_DISABLED
 	   && !priv->sec_info.wpa_enabled && priv->sec_info.wpa2_enabled
@@ -336,9 +304,9 @@ mwifiex_is_network_compatible_for_wpa2(struct mwifiex_private *priv,
 	    * LinkSys WRT54G && bss_desc->privacy
 	    */
 	 ) {
-		dev_dbg(priv->adapter->dev, "info: %s: WPA2: index=%d"
+		dev_dbg(priv->adapter->dev, "info: %s: WPA2: "
 			" wpa_ie=%#x wpa2_ie=%#x WEP=%s WPA=%s WPA2=%s "
-			"EncMode=%#x privacy=%#x\n", __func__, index,
+			"EncMode=%#x privacy=%#x\n", __func__,
 			(bss_desc->bcn_wpa_ie) ?
 			(*(bss_desc->bcn_wpa_ie)).
 			vend_hdr.element_id : 0,
@@ -383,8 +351,7 @@ mwifiex_is_network_compatible_for_adhoc_aes(struct mwifiex_private *priv,
  */
 static bool
 mwifiex_is_network_compatible_for_dynamic_wep(struct mwifiex_private *priv,
-				       struct mwifiex_bssdescriptor *bss_desc,
-				       int index)
+				       struct mwifiex_bssdescriptor *bss_desc)
 {
 	if (priv->sec_info.wep_status == MWIFIEX_802_11_WEP_DISABLED
 	    && !priv->sec_info.wpa_enabled && !priv->sec_info.wpa2_enabled
@@ -395,9 +362,9 @@ mwifiex_is_network_compatible_for_dynamic_wep(struct mwifiex_private *priv,
 	    && priv->sec_info.encryption_mode
 	    && bss_desc->privacy) {
 		dev_dbg(priv->adapter->dev, "info: %s: dynamic "
-			"WEP: index=%d wpa_ie=%#x wpa2_ie=%#x "
+			"WEP: wpa_ie=%#x wpa2_ie=%#x "
 			"EncMode=%#x privacy=%#x\n",
-			__func__, index,
+			__func__,
 			(bss_desc->bcn_wpa_ie) ?
 			(*(bss_desc->bcn_wpa_ie)).
 			vend_hdr.element_id : 0,
@@ -430,42 +397,41 @@ mwifiex_is_network_compatible_for_dynamic_wep(struct mwifiex_private *priv,
  * Compatibility is not matched while roaming, except for mode.
  */
 static s32
-mwifiex_is_network_compatible(struct mwifiex_private *priv, u32 index, u32 mode)
+mwifiex_is_network_compatible(struct mwifiex_private *priv,
+			      struct mwifiex_bssdescriptor *bss_desc, u32 mode)
 {
 	struct mwifiex_adapter *adapter = priv->adapter;
-	struct mwifiex_bssdescriptor *bss_desc;
 
-	bss_desc = &adapter->scan_table[index];
 	bss_desc->disable_11n = false;
 
 	/* Don't check for compatibility if roaming */
 	if (priv->media_connected && (priv->bss_mode == NL80211_IFTYPE_STATION)
 	    && (bss_desc->bss_mode == NL80211_IFTYPE_STATION))
-		return index;
+		return 0;
 
 	if (priv->wps.session_enable) {
 		dev_dbg(adapter->dev,
 			"info: return success directly in WPS period\n");
-		return index;
+		return 0;
 	}
 
 	if (mwifiex_is_network_compatible_for_wapi(priv, bss_desc)) {
 		dev_dbg(adapter->dev, "info: return success for WAPI AP\n");
-		return index;
+		return 0;
 	}
 
 	if (bss_desc->bss_mode == mode) {
 		if (mwifiex_is_network_compatible_for_no_sec(priv, bss_desc)) {
 			/* No security */
-			return index;
+			return 0;
 		} else if (mwifiex_is_network_compatible_for_static_wep(priv,
 								bss_desc)) {
 			/* Static WEP enabled */
 			dev_dbg(adapter->dev, "info: Disable 11n in WEP mode.\n");
 			bss_desc->disable_11n = true;
-			return index;
-		} else if (mwifiex_is_network_compatible_for_wpa(priv, bss_desc,
-								 index)) {
+			return 0;
+		} else if (mwifiex_is_network_compatible_for_wpa(priv,
+								 bss_desc)) {
 			/* WPA enabled */
 			if (((priv->adapter->config_bands & BAND_GN
 			      || priv->adapter->config_bands & BAND_AN)
@@ -483,9 +449,9 @@ mwifiex_is_network_compatible(struct mwifiex_private *priv, u32 index, u32 mode)
 					return -1;
 				}
 			}
-			return index;
+			return 0;
 		} else if (mwifiex_is_network_compatible_for_wpa2(priv,
-							bss_desc, index)) {
+							bss_desc)) {
 			/* WPA2 enabled */
 			if (((priv->adapter->config_bands & BAND_GN
 			      || priv->adapter->config_bands & BAND_AN)
@@ -503,22 +469,22 @@ mwifiex_is_network_compatible(struct mwifiex_private *priv, u32 index, u32 mode)
 					return -1;
 				}
 			}
-			return index;
+			return 0;
 		} else if (mwifiex_is_network_compatible_for_adhoc_aes(priv,
 								bss_desc)) {
 			/* Ad-hoc AES enabled */
-			return index;
+			return 0;
 		} else if (mwifiex_is_network_compatible_for_dynamic_wep(priv,
-							bss_desc, index)) {
+							bss_desc)) {
 			/* Dynamic WEP enabled */
-			return index;
+			return 0;
 		}
 
 		/* Security doesn't match */
-		dev_dbg(adapter->dev, "info: %s: failed: index=%d "
+		dev_dbg(adapter->dev, "info: %s: failed: "
 		       "wpa_ie=%#x wpa2_ie=%#x WEP=%s WPA=%s WPA2=%s EncMode"
 		       "=%#x privacy=%#x\n",
-		       __func__, index,
+		       __func__,
 		       (bss_desc->bcn_wpa_ie) ?
 		       (*(bss_desc->bcn_wpa_ie)).vend_hdr.
 		       element_id : 0,
@@ -538,52 +504,6 @@ mwifiex_is_network_compatible(struct mwifiex_private *priv, u32 index, u32 mode)
 }
 
 /*
- * This function finds the best SSID in the scan list.
- *
- * It searches the scan table for the best SSID that also matches the current
- * adapter network preference (mode, security etc.).
- */
-static s32
-mwifiex_find_best_network_in_list(struct mwifiex_private *priv)
-{
-	struct mwifiex_adapter *adapter = priv->adapter;
-	u32 mode = priv->bss_mode;
-	s32 best_net = -1;
-	s32 best_rssi = 0;
-	u32 i;
-
-	dev_dbg(adapter->dev, "info: num of BSSIDs = %d\n",
-				adapter->num_in_scan_table);
-
-	for (i = 0; i < adapter->num_in_scan_table; i++) {
-		switch (mode) {
-		case NL80211_IFTYPE_STATION:
-		case NL80211_IFTYPE_ADHOC:
-			if (mwifiex_is_network_compatible(priv, i, mode) >= 0) {
-				if (SCAN_RSSI(adapter->scan_table[i].rssi) >
-				    best_rssi) {
-					best_rssi = SCAN_RSSI(adapter->
-							  scan_table[i].rssi);
-					best_net = i;
-				}
-			}
-			break;
-		case NL80211_IFTYPE_UNSPECIFIED:
-		default:
-			if (SCAN_RSSI(adapter->scan_table[i].rssi) >
-			    best_rssi) {
-				best_rssi = SCAN_RSSI(adapter->scan_table[i].
-						      rssi);
-				best_net = i;
-			}
-			break;
-		}
-	}
-
-	return best_net;
-}
-
-/*
  * This function creates a channel list for the driver to scan, based
  * on region/band information.
  *
@@ -1161,34 +1081,13 @@ mwifiex_ret_802_11_scan_get_tlv_ptrs(struct mwifiex_adapter *adapter,
 }
 
 /*
- * This function interprets a BSS scan response returned from the firmware.
- *
- * The various fixed fields and IEs are parsed and passed back for a BSS
- * probe response or beacon from scan command. Information is recorded as
- * needed in the scan table for that entry.
- *
- * The following IE types are recognized and parsed -
- *      - SSID
- *      - Supported rates
- *      - FH parameters set
- *      - DS parameters set
- *      - CF parameters set
- *      - IBSS parameters set
- *      - ERP information
- *      - Extended supported rates
- *      - Vendor specific (221)
- *      - RSN IE
- *      - WAPI IE
- *      - HT capability
- *      - HT operation
- *      - BSS Coexistence 20/40
- *      - Extended capability
- *      - Overlapping BSS scan parameters
+ * This function parses provided beacon buffer and updates
+ * respective fields in bss descriptor structure.
  */
-static int
-mwifiex_interpret_bss_desc_with_ie(struct mwifiex_adapter *adapter,
-				   struct mwifiex_bssdescriptor *bss_entry,
-				   u8 **beacon_info, u32 *bytes_left)
+int
+mwifiex_update_bss_desc_with_ie(struct mwifiex_adapter *adapter,
+				struct mwifiex_bssdescriptor *bss_entry,
+				u8 *ie_buf, u32 ie_len)
 {
 	int ret = 0;
 	u8 element_id;
@@ -1196,135 +1095,43 @@ mwifiex_interpret_bss_desc_with_ie(struct mwifiex_adapter *adapter,
 	struct ieee_types_ds_param_set *ds_param_set;
 	struct ieee_types_cf_param_set *cf_param_set;
 	struct ieee_types_ibss_param_set *ibss_param_set;
-	__le16 beacon_interval;
-	__le16 capabilities;
 	u8 *current_ptr;
 	u8 *rate;
 	u8 element_len;
 	u16 total_ie_len;
 	u8 bytes_to_copy;
 	u8 rate_size;
-	u16 beacon_size;
 	u8 found_data_rate_ie;
-	u32 bytes_left_for_current_beacon;
+	u32 bytes_left;
 	struct ieee_types_vendor_specific *vendor_ie;
 	const u8 wpa_oui[4] = { 0x00, 0x50, 0xf2, 0x01 };
 	const u8 wmm_oui[4] = { 0x00, 0x50, 0xf2, 0x02 };
 
 	found_data_rate_ie = false;
 	rate_size = 0;
-	beacon_size = 0;
-
-	if (*bytes_left >= sizeof(beacon_size)) {
-		/* Extract & convert beacon size from the command buffer */
-		memcpy(&beacon_size, *beacon_info, sizeof(beacon_size));
-		*bytes_left -= sizeof(beacon_size);
-		*beacon_info += sizeof(beacon_size);
-	}
-
-	if (!beacon_size || beacon_size > *bytes_left) {
-		*beacon_info += *bytes_left;
-		*bytes_left = 0;
-		return -1;
-	}
-
-	/* Initialize the current working beacon pointer for this BSS
-	   iteration */
-	current_ptr = *beacon_info;
-
-	/* Advance the return beacon pointer past the current beacon */
-	*beacon_info += beacon_size;
-	*bytes_left -= beacon_size;
-
-	bytes_left_for_current_beacon = beacon_size;
-
-	memcpy(bss_entry->mac_address, current_ptr, ETH_ALEN);
-	dev_dbg(adapter->dev, "info: InterpretIE: AP MAC Addr: %pM\n",
-						bss_entry->mac_address);
-
-	current_ptr += ETH_ALEN;
-	bytes_left_for_current_beacon -= ETH_ALEN;
-
-	if (bytes_left_for_current_beacon < 12) {
-		dev_err(adapter->dev, "InterpretIE: not enough bytes left\n");
-		return -1;
-	}
-
-	/*
-	 * Next 4 fields are RSSI, time stamp, beacon interval,
-	 *   and capability information
-	 */
-
-	/* RSSI is 1 byte long */
-	bss_entry->rssi = (s32) (*current_ptr);
-	dev_dbg(adapter->dev, "info: InterpretIE: RSSI=%02X\n", *current_ptr);
-	current_ptr += 1;
-	bytes_left_for_current_beacon -= 1;
-
-	/*
-	 *  The RSSI is not part of the beacon/probe response.  After we have
-	 *    advanced current_ptr past the RSSI field, save the remaining
-	 *    data for use at the application layer
-	 */
-	bss_entry->beacon_buf = current_ptr;
-	bss_entry->beacon_buf_size = bytes_left_for_current_beacon;
-
-	/* Time stamp is 8 bytes long */
-	memcpy(bss_entry->time_stamp, current_ptr, 8);
-	current_ptr += 8;
-	bytes_left_for_current_beacon -= 8;
-
-	/* Beacon interval is 2 bytes long */
-	memcpy(&beacon_interval, current_ptr, 2);
-	bss_entry->beacon_period = le16_to_cpu(beacon_interval);
-	current_ptr += 2;
-	bytes_left_for_current_beacon -= 2;
-
-	/* Capability information is 2 bytes long */
-	memcpy(&capabilities, current_ptr, 2);
-	dev_dbg(adapter->dev, "info: InterpretIE: capabilities=0x%X\n",
-	       capabilities);
-	bss_entry->cap_info_bitmap = le16_to_cpu(capabilities);
-	current_ptr += 2;
-	bytes_left_for_current_beacon -= 2;
-
-	/* Rest of the current buffer are IE's */
-	dev_dbg(adapter->dev, "info: InterpretIE: IELength for this AP = %d\n",
-	       bytes_left_for_current_beacon);
-
-	if (bss_entry->cap_info_bitmap & WLAN_CAPABILITY_PRIVACY) {
-		dev_dbg(adapter->dev, "info: InterpretIE: AP WEP enabled\n");
-		bss_entry->privacy = MWIFIEX_802_11_PRIV_FILTER_8021X_WEP;
-	} else {
-		bss_entry->privacy = MWIFIEX_802_11_PRIV_FILTER_ACCEPT_ALL;
-	}
-
-	if (bss_entry->cap_info_bitmap & WLAN_CAPABILITY_IBSS)
-		bss_entry->bss_mode = NL80211_IFTYPE_ADHOC;
-	else
-		bss_entry->bss_mode = NL80211_IFTYPE_STATION;
-
+	current_ptr = ie_buf;
+	bytes_left = ie_len;
+	bss_entry->beacon_buf = ie_buf;
+	bss_entry->beacon_buf_size = ie_len;
 
 	/* Process variable IE */
-	while (bytes_left_for_current_beacon >= 2) {
+	while (bytes_left >= 2) {
 		element_id = *current_ptr;
 		element_len = *(current_ptr + 1);
 		total_ie_len = element_len + sizeof(struct ieee_types_header);
 
-		if (bytes_left_for_current_beacon < total_ie_len) {
+		if (bytes_left < total_ie_len) {
 			dev_err(adapter->dev, "err: InterpretIE: in processing"
 				" IE, bytes left < IE length\n");
-			bytes_left_for_current_beacon = 0;
-			ret = -1;
-			continue;
+			return -1;
 		}
 		switch (element_id) {
 		case WLAN_EID_SSID:
 			bss_entry->ssid.ssid_len = element_len;
 			memcpy(bss_entry->ssid.ssid, (current_ptr + 2),
 			       element_len);
-			dev_dbg(adapter->dev, "info: InterpretIE: ssid: %-32s\n",
-			       bss_entry->ssid.ssid);
+			dev_dbg(adapter->dev, "info: InterpretIE: ssid: "
+					      "%-32s\n", bss_entry->ssid.ssid);
 			break;
 
 		case WLAN_EID_SUPP_RATES:
@@ -1471,13 +1278,6 @@ mwifiex_interpret_bss_desc_with_ie(struct mwifiex_adapter *adapter,
 					sizeof(struct ieee_types_header) -
 					bss_entry->beacon_buf);
 			break;
-		case WLAN_EID_OVERLAP_BSS_SCAN_PARAM:
-			bss_entry->bcn_obss_scan =
-				(struct ieee_types_obss_scan_param *)
-				current_ptr;
-			bss_entry->overlap_bss_offset = (u16) (current_ptr -
-							bss_entry->beacon_buf);
-			break;
 		default:
 			break;
 		}
@@ -1485,577 +1285,13 @@ mwifiex_interpret_bss_desc_with_ie(struct mwifiex_adapter *adapter,
 		current_ptr += element_len + 2;
 
 		/* Need to account for IE ID and IE Len */
-		bytes_left_for_current_beacon -= (element_len + 2);
+		bytes_left -= (element_len + 2);
 
-	}	/* while (bytes_left_for_current_beacon > 2) */
+	}	/* while (bytes_left > 2) */
 	return ret;
 }
 
 /*
- * This function adjusts the pointers used in beacon buffers to reflect
- * shifts.
- *
- * The memory allocated for beacon buffers is of fixed sizes where all the
- * saved beacons must be stored. New beacons are added in the free portion
- * of this memory, space permitting; while duplicate beacon buffers are
- * placed at the same start location. However, since duplicate beacon
- * buffers may not match the size of the old one, all the following buffers
- * in the memory must be shifted to either make space, or to fill up freed
- * up space.
- *
- * This function is used to update the beacon buffer pointers that are past
- * an existing beacon buffer that is updated with a new one of different
- * size. The pointers are shifted by a fixed amount, either forward or
- * backward.
- *
- * the following pointers in every affected beacon buffers are changed, if
- * present -
- *      - WPA IE pointer
- *      - RSN IE pointer
- *      - WAPI IE pointer
- *      - HT capability IE pointer
- *      - HT information IE pointer
- *      - BSS coexistence 20/40 IE pointer
- *      - Extended capability IE pointer
- *      - Overlapping BSS scan parameter IE pointer
- */
-static void
-mwifiex_adjust_beacon_buffer_ptrs(struct mwifiex_private *priv, u8 advance,
-				  u8 *bcn_store, u32 rem_bcn_size,
-				  u32 num_of_ent)
-{
-	struct mwifiex_adapter *adapter = priv->adapter;
-	u32 adj_idx;
-	for (adj_idx = 0; adj_idx < num_of_ent; adj_idx++) {
-		if (adapter->scan_table[adj_idx].beacon_buf > bcn_store) {
-
-			if (advance)
-				adapter->scan_table[adj_idx].beacon_buf +=
-					rem_bcn_size;
-			else
-				adapter->scan_table[adj_idx].beacon_buf -=
-					rem_bcn_size;
-
-			if (adapter->scan_table[adj_idx].bcn_wpa_ie)
-				adapter->scan_table[adj_idx].bcn_wpa_ie =
-				(struct ieee_types_vendor_specific *)
-				(adapter->scan_table[adj_idx].beacon_buf +
-				 adapter->scan_table[adj_idx].wpa_offset);
-			if (adapter->scan_table[adj_idx].bcn_rsn_ie)
-				adapter->scan_table[adj_idx].bcn_rsn_ie =
-				(struct ieee_types_generic *)
-				(adapter->scan_table[adj_idx].beacon_buf +
-				 adapter->scan_table[adj_idx].rsn_offset);
-			if (adapter->scan_table[adj_idx].bcn_wapi_ie)
-				adapter->scan_table[adj_idx].bcn_wapi_ie =
-				(struct ieee_types_generic *)
-				(adapter->scan_table[adj_idx].beacon_buf +
-				 adapter->scan_table[adj_idx].wapi_offset);
-			if (adapter->scan_table[adj_idx].bcn_ht_cap)
-				adapter->scan_table[adj_idx].bcn_ht_cap =
-				(struct ieee80211_ht_cap *)
-				(adapter->scan_table[adj_idx].beacon_buf +
-				 adapter->scan_table[adj_idx].ht_cap_offset);
-
-			if (adapter->scan_table[adj_idx].bcn_ht_info)
-				adapter->scan_table[adj_idx].bcn_ht_info =
-				(struct ieee80211_ht_info *)
-				(adapter->scan_table[adj_idx].beacon_buf +
-				 adapter->scan_table[adj_idx].ht_info_offset);
-			if (adapter->scan_table[adj_idx].bcn_bss_co_2040)
-				adapter->scan_table[adj_idx].bcn_bss_co_2040 =
-				(u8 *)
-				(adapter->scan_table[adj_idx].beacon_buf +
-			       adapter->scan_table[adj_idx].bss_co_2040_offset);
-			if (adapter->scan_table[adj_idx].bcn_ext_cap)
-				adapter->scan_table[adj_idx].bcn_ext_cap =
-				(u8 *)
-				(adapter->scan_table[adj_idx].beacon_buf +
-				 adapter->scan_table[adj_idx].ext_cap_offset);
-			if (adapter->scan_table[adj_idx].bcn_obss_scan)
-				adapter->scan_table[adj_idx].bcn_obss_scan =
-				(struct ieee_types_obss_scan_param *)
-				(adapter->scan_table[adj_idx].beacon_buf +
-			       adapter->scan_table[adj_idx].overlap_bss_offset);
-		}
-	}
-}
-
-/*
- * This function updates the pointers used in beacon buffer for given bss
- * descriptor to reflect shifts
- *
- * Following pointers are updated
- *      - WPA IE pointer
- *      - RSN IE pointer
- *      - WAPI IE pointer
- *      - HT capability IE pointer
- *      - HT information IE pointer
- *      - BSS coexistence 20/40 IE pointer
- *      - Extended capability IE pointer
- *      - Overlapping BSS scan parameter IE pointer
- */
-static void
-mwifiex_update_beacon_buffer_ptrs(struct mwifiex_bssdescriptor *beacon)
-{
-	if (beacon->bcn_wpa_ie)
-		beacon->bcn_wpa_ie = (struct ieee_types_vendor_specific *)
-			(beacon->beacon_buf + beacon->wpa_offset);
-	if (beacon->bcn_rsn_ie)
-		beacon->bcn_rsn_ie = (struct ieee_types_generic *)
-			(beacon->beacon_buf + beacon->rsn_offset);
-	if (beacon->bcn_wapi_ie)
-		beacon->bcn_wapi_ie = (struct ieee_types_generic *)
-			(beacon->beacon_buf + beacon->wapi_offset);
-	if (beacon->bcn_ht_cap)
-		beacon->bcn_ht_cap = (struct ieee80211_ht_cap *)
-			(beacon->beacon_buf + beacon->ht_cap_offset);
-	if (beacon->bcn_ht_info)
-		beacon->bcn_ht_info = (struct ieee80211_ht_info *)
-			(beacon->beacon_buf + beacon->ht_info_offset);
-	if (beacon->bcn_bss_co_2040)
-		beacon->bcn_bss_co_2040 = (u8 *) (beacon->beacon_buf +
-			beacon->bss_co_2040_offset);
-	if (beacon->bcn_ext_cap)
-		beacon->bcn_ext_cap = (u8 *) (beacon->beacon_buf +
-			beacon->ext_cap_offset);
-	if (beacon->bcn_obss_scan)
-		beacon->bcn_obss_scan = (struct ieee_types_obss_scan_param *)
-			(beacon->beacon_buf + beacon->overlap_bss_offset);
-}
-
-/*
- * This function stores a beacon or probe response for a BSS returned
- * in the scan.
- *
- * This stores a new scan response or an update for a previous scan response.
- * New entries need to verify that they do not exceed the total amount of
- * memory allocated for the table.
- *
- * Replacement entries need to take into consideration the amount of space
- * currently allocated for the beacon/probe response and adjust the entry
- * as needed.
- *
- * A small amount of extra pad (SCAN_BEACON_ENTRY_PAD) is generally reserved
- * for an entry in case it is a beacon since a probe response for the
- * network will by larger per the standard.  This helps to reduce the
- * amount of memory copying to fit a new probe response into an entry
- * already occupied by a network's previously stored beacon.
- */
-static void
-mwifiex_ret_802_11_scan_store_beacon(struct mwifiex_private *priv,
-				     u32 beacon_idx, u32 num_of_ent,
-				     struct mwifiex_bssdescriptor *new_beacon)
-{
-	struct mwifiex_adapter *adapter = priv->adapter;
-	u8 *bcn_store;
-	u32 new_bcn_size;
-	u32 old_bcn_size;
-	u32 bcn_space;
-
-	if (adapter->scan_table[beacon_idx].beacon_buf) {
-
-		new_bcn_size = new_beacon->beacon_buf_size;
-		old_bcn_size = adapter->scan_table[beacon_idx].beacon_buf_size;
-		bcn_space = adapter->scan_table[beacon_idx].beacon_buf_size_max;
-		bcn_store = adapter->scan_table[beacon_idx].beacon_buf;
-
-		/* Set the max to be the same as current entry unless changed
-		   below */
-		new_beacon->beacon_buf_size_max = bcn_space;
-		if (new_bcn_size == old_bcn_size) {
-			/*
-			 * Beacon is the same size as the previous entry.
-			 *   Replace the previous contents with the scan result
-			 */
-			memcpy(bcn_store, new_beacon->beacon_buf,
-			       new_beacon->beacon_buf_size);
-
-		} else if (new_bcn_size <= bcn_space) {
-			/*
-			 * New beacon size will fit in the amount of space
-			 *   we have previously allocated for it
-			 */
-
-			/* Copy the new beacon buffer entry over the old one */
-			memcpy(bcn_store, new_beacon->beacon_buf, new_bcn_size);
-
-			/*
-			 *  If the old beacon size was less than the maximum
-			 *  we had alloted for the entry, and the new entry
-			 *  is even smaller, reset the max size to the old
-			 *  beacon entry and compress the storage space
-			 *  (leaving a new pad space of (old_bcn_size -
-			 *  new_bcn_size).
-			 */
-			if (old_bcn_size < bcn_space
-			    && new_bcn_size <= old_bcn_size) {
-				/*
-				 * Old Beacon size is smaller than the alloted
-				 * storage size. Shrink the alloted storage
-				 * space.
-				 */
-				dev_dbg(adapter->dev, "info: AppControl:"
-					" smaller duplicate beacon "
-				       "(%d), old = %d, new = %d, space = %d,"
-				       "left = %d\n",
-				       beacon_idx, old_bcn_size, new_bcn_size,
-				       bcn_space,
-				       (int)(sizeof(adapter->bcn_buf) -
-					(adapter->bcn_buf_end -
-					 adapter->bcn_buf)));
-
-				/*
-				 *  memmove (since the memory overlaps) the
-				 *  data after the beacon we just stored to the
-				 *  end of the current beacon.  This cleans up
-				 *  any unused space the old larger beacon was
-				 *  using in the buffer
-				 */
-				memmove(bcn_store + old_bcn_size,
-					bcn_store + bcn_space,
-					adapter->bcn_buf_end - (bcn_store +
-								   bcn_space));
-
-				/*
-				 * Decrement the end pointer by the difference
-				 * between the old larger size and the new
-				 * smaller size since we are using less space
-				 * due to the new beacon being smaller
-				 */
-				adapter->bcn_buf_end -=
-					(bcn_space - old_bcn_size);
-
-				/* Set the maximum storage size to the old
-				   beacon size */
-				new_beacon->beacon_buf_size_max = old_bcn_size;
-
-				/* Adjust beacon buffer pointers that are past
-				   the current */
-				mwifiex_adjust_beacon_buffer_ptrs(priv, 0,
-					bcn_store, (bcn_space - old_bcn_size),
-					num_of_ent);
-			}
-		} else if (adapter->bcn_buf_end + (new_bcn_size - bcn_space)
-			   < (adapter->bcn_buf + sizeof(adapter->bcn_buf))) {
-			/*
-			 * Beacon is larger than space previously allocated
-			 * (bcn_space) and there is enough space left in the
-			 * beaconBuffer to store the additional data
-			 */
-			dev_dbg(adapter->dev, "info: AppControl:"
-				" larger duplicate beacon (%d), "
-			       "old = %d, new = %d, space = %d, left = %d\n",
-			       beacon_idx, old_bcn_size, new_bcn_size,
-			       bcn_space,
-			       (int)(sizeof(adapter->bcn_buf) -
-				(adapter->bcn_buf_end -
-				 adapter->bcn_buf)));
-
-			/*
-			 * memmove (since the memory overlaps) the data
-			 *  after the beacon we just stored to the end of
-			 *  the current beacon.  This moves the data for
-			 *  the beacons after this further in memory to
-			 *  make space for the new larger beacon we are
-			 *  about to copy in.
-			 */
-			memmove(bcn_store + new_bcn_size,
-				bcn_store + bcn_space,
-				adapter->bcn_buf_end - (bcn_store + bcn_space));
-
-			/* Copy the new beacon buffer entry over the old one */
-			memcpy(bcn_store, new_beacon->beacon_buf, new_bcn_size);
-
-			/* Move the beacon end pointer by the amount of new
-			   beacon data we are adding */
-			adapter->bcn_buf_end += (new_bcn_size - bcn_space);
-
-			/*
-			 * This entry is bigger than the alloted max space
-			 *  previously reserved.  Increase the max space to
-			 *  be equal to the new beacon size
-			 */
-			new_beacon->beacon_buf_size_max = new_bcn_size;
-
-			/* Adjust beacon buffer pointers that are past the
-			   current */
-			mwifiex_adjust_beacon_buffer_ptrs(priv, 1, bcn_store,
-						(new_bcn_size - bcn_space),
-						num_of_ent);
-		} else {
-			/*
-			 * Beacon is larger than the previously allocated space,
-			 * but there is not enough free space to store the
-			 * additional data.
-			 */
-			dev_err(adapter->dev, "AppControl: larger duplicate "
-				" beacon (%d), old = %d new = %d, space = %d,"
-				" left = %d\n", beacon_idx, old_bcn_size,
-				new_bcn_size, bcn_space,
-				(int)(sizeof(adapter->bcn_buf) -
-				(adapter->bcn_buf_end - adapter->bcn_buf)));
-
-			/* Storage failure, keep old beacon intact */
-			new_beacon->beacon_buf_size = old_bcn_size;
-			if (new_beacon->bcn_wpa_ie)
-				new_beacon->wpa_offset =
-					adapter->scan_table[beacon_idx].
-					wpa_offset;
-			if (new_beacon->bcn_rsn_ie)
-				new_beacon->rsn_offset =
-					adapter->scan_table[beacon_idx].
-					rsn_offset;
-			if (new_beacon->bcn_wapi_ie)
-				new_beacon->wapi_offset =
-					adapter->scan_table[beacon_idx].
-					wapi_offset;
-			if (new_beacon->bcn_ht_cap)
-				new_beacon->ht_cap_offset =
-					adapter->scan_table[beacon_idx].
-					ht_cap_offset;
-			if (new_beacon->bcn_ht_info)
-				new_beacon->ht_info_offset =
-					adapter->scan_table[beacon_idx].
-					ht_info_offset;
-			if (new_beacon->bcn_bss_co_2040)
-				new_beacon->bss_co_2040_offset =
-					adapter->scan_table[beacon_idx].
-					bss_co_2040_offset;
-			if (new_beacon->bcn_ext_cap)
-				new_beacon->ext_cap_offset =
-					adapter->scan_table[beacon_idx].
-					ext_cap_offset;
-			if (new_beacon->bcn_obss_scan)
-				new_beacon->overlap_bss_offset =
-					adapter->scan_table[beacon_idx].
-					overlap_bss_offset;
-		}
-		/* Point the new entry to its permanent storage space */
-		new_beacon->beacon_buf = bcn_store;
-		mwifiex_update_beacon_buffer_ptrs(new_beacon);
-	} else {
-		/*
-		 * No existing beacon data exists for this entry, check to see
-		 *   if we can fit it in the remaining space
-		 */
-		if (adapter->bcn_buf_end + new_beacon->beacon_buf_size +
-		    SCAN_BEACON_ENTRY_PAD < (adapter->bcn_buf +
-					     sizeof(adapter->bcn_buf))) {
-
-			/*
-			 * Copy the beacon buffer data from the local entry to
-			 * the adapter dev struct buffer space used to store
-			 * the raw beacon data for each entry in the scan table
-			 */
-			memcpy(adapter->bcn_buf_end, new_beacon->beacon_buf,
-			       new_beacon->beacon_buf_size);
-
-			/* Update the beacon ptr to point to the table save
-			   area */
-			new_beacon->beacon_buf = adapter->bcn_buf_end;
-			new_beacon->beacon_buf_size_max =
-				(new_beacon->beacon_buf_size +
-				 SCAN_BEACON_ENTRY_PAD);
-
-			mwifiex_update_beacon_buffer_ptrs(new_beacon);
-
-			/* Increment the end pointer by the size reserved */
-			adapter->bcn_buf_end += new_beacon->beacon_buf_size_max;
-
-			dev_dbg(adapter->dev, "info: AppControl: beacon[%02d]"
-				" sz=%03d, used = %04d, left = %04d\n",
-			       beacon_idx,
-			       new_beacon->beacon_buf_size,
-			       (int)(adapter->bcn_buf_end - adapter->bcn_buf),
-			       (int)(sizeof(adapter->bcn_buf) -
-				(adapter->bcn_buf_end -
-				 adapter->bcn_buf)));
-		} else {
-			/* No space for new beacon */
-			dev_dbg(adapter->dev, "info: AppControl: no space for"
-				" beacon (%d): %pM sz=%03d, left=%03d\n",
-			       beacon_idx, new_beacon->mac_address,
-			       new_beacon->beacon_buf_size,
-			       (int)(sizeof(adapter->bcn_buf) -
-				(adapter->bcn_buf_end -
-				 adapter->bcn_buf)));
-
-			/* Storage failure; clear storage records for this
-			   bcn */
-			new_beacon->beacon_buf = NULL;
-			new_beacon->beacon_buf_size = 0;
-			new_beacon->beacon_buf_size_max = 0;
-			new_beacon->bcn_wpa_ie = NULL;
-			new_beacon->wpa_offset = 0;
-			new_beacon->bcn_rsn_ie = NULL;
-			new_beacon->rsn_offset = 0;
-			new_beacon->bcn_wapi_ie = NULL;
-			new_beacon->wapi_offset = 0;
-			new_beacon->bcn_ht_cap = NULL;
-			new_beacon->ht_cap_offset = 0;
-			new_beacon->bcn_ht_info = NULL;
-			new_beacon->ht_info_offset = 0;
-			new_beacon->bcn_bss_co_2040 = NULL;
-			new_beacon->bss_co_2040_offset = 0;
-			new_beacon->bcn_ext_cap = NULL;
-			new_beacon->ext_cap_offset = 0;
-			new_beacon->bcn_obss_scan = NULL;
-			new_beacon->overlap_bss_offset = 0;
-		}
-	}
-}
-
-/*
- * This function restores a beacon buffer of the current BSS descriptor.
- */
-static void mwifiex_restore_curr_bcn(struct mwifiex_private *priv)
-{
-	struct mwifiex_adapter *adapter = priv->adapter;
-	struct mwifiex_bssdescriptor *curr_bss =
-		&priv->curr_bss_params.bss_descriptor;
-	unsigned long flags;
-
-	if (priv->curr_bcn_buf &&
-	    ((adapter->bcn_buf_end + priv->curr_bcn_size) <
-	     (adapter->bcn_buf + sizeof(adapter->bcn_buf)))) {
-		spin_lock_irqsave(&priv->curr_bcn_buf_lock, flags);
-
-		/* restore the current beacon buffer */
-		memcpy(adapter->bcn_buf_end, priv->curr_bcn_buf,
-		       priv->curr_bcn_size);
-		curr_bss->beacon_buf = adapter->bcn_buf_end;
-		curr_bss->beacon_buf_size = priv->curr_bcn_size;
-		adapter->bcn_buf_end += priv->curr_bcn_size;
-
-		/* adjust the pointers in the current BSS descriptor */
-		if (curr_bss->bcn_wpa_ie)
-			curr_bss->bcn_wpa_ie =
-				(struct ieee_types_vendor_specific *)
-				(curr_bss->beacon_buf +
-				 curr_bss->wpa_offset);
-
-		if (curr_bss->bcn_rsn_ie)
-			curr_bss->bcn_rsn_ie = (struct ieee_types_generic *)
-				(curr_bss->beacon_buf +
-				 curr_bss->rsn_offset);
-
-		if (curr_bss->bcn_ht_cap)
-			curr_bss->bcn_ht_cap = (struct ieee80211_ht_cap *)
-				(curr_bss->beacon_buf +
-				 curr_bss->ht_cap_offset);
-
-		if (curr_bss->bcn_ht_info)
-			curr_bss->bcn_ht_info = (struct ieee80211_ht_info *)
-				(curr_bss->beacon_buf +
-				 curr_bss->ht_info_offset);
-
-		if (curr_bss->bcn_bss_co_2040)
-			curr_bss->bcn_bss_co_2040 =
-				(u8 *) (curr_bss->beacon_buf +
-				 curr_bss->bss_co_2040_offset);
-
-		if (curr_bss->bcn_ext_cap)
-			curr_bss->bcn_ext_cap = (u8 *) (curr_bss->beacon_buf +
-				 curr_bss->ext_cap_offset);
-
-		if (curr_bss->bcn_obss_scan)
-			curr_bss->bcn_obss_scan =
-				(struct ieee_types_obss_scan_param *)
-				(curr_bss->beacon_buf +
-				 curr_bss->overlap_bss_offset);
-
-		spin_unlock_irqrestore(&priv->curr_bcn_buf_lock, flags);
-
-		dev_dbg(adapter->dev, "info: current beacon restored %d\n",
-		       priv->curr_bcn_size);
-	} else {
-		dev_warn(adapter->dev,
-			"curr_bcn_buf not saved or bcn_buf has no space\n");
-	}
-}
-
-/*
- * This function post processes the scan table after a new scan command has
- * completed.
- *
- * It inspects each entry of the scan table and tries to find an entry that
- * matches with our current associated/joined network from the scan. If
- * one is found, the stored copy of the BSS descriptor of our current network
- * is updated.
- *
- * It also debug dumps the current scan table contents after processing is over.
- */
-static void
-mwifiex_process_scan_results(struct mwifiex_private *priv)
-{
-	struct mwifiex_adapter *adapter = priv->adapter;
-	s32 j;
-	u32 i;
-	unsigned long flags;
-
-	if (priv->media_connected) {
-
-		j = mwifiex_find_ssid_in_list(priv, &priv->curr_bss_params.
-					      bss_descriptor.ssid,
-					      priv->curr_bss_params.
-					      bss_descriptor.mac_address,
-					      priv->bss_mode);
-
-		if (j >= 0) {
-			spin_lock_irqsave(&priv->curr_bcn_buf_lock, flags);
-			priv->curr_bss_params.bss_descriptor.bcn_wpa_ie = NULL;
-			priv->curr_bss_params.bss_descriptor.wpa_offset = 0;
-			priv->curr_bss_params.bss_descriptor.bcn_rsn_ie = NULL;
-			priv->curr_bss_params.bss_descriptor.rsn_offset = 0;
-			priv->curr_bss_params.bss_descriptor.bcn_wapi_ie = NULL;
-			priv->curr_bss_params.bss_descriptor.wapi_offset = 0;
-			priv->curr_bss_params.bss_descriptor.bcn_ht_cap = NULL;
-			priv->curr_bss_params.bss_descriptor.ht_cap_offset =
-				0;
-			priv->curr_bss_params.bss_descriptor.bcn_ht_info = NULL;
-			priv->curr_bss_params.bss_descriptor.ht_info_offset =
-				0;
-			priv->curr_bss_params.bss_descriptor.bcn_bss_co_2040 =
-				NULL;
-			priv->curr_bss_params.bss_descriptor.
-				bss_co_2040_offset = 0;
-			priv->curr_bss_params.bss_descriptor.bcn_ext_cap = NULL;
-			priv->curr_bss_params.bss_descriptor.ext_cap_offset = 0;
-			priv->curr_bss_params.bss_descriptor.
-				bcn_obss_scan = NULL;
-			priv->curr_bss_params.bss_descriptor.
-				overlap_bss_offset = 0;
-			priv->curr_bss_params.bss_descriptor.beacon_buf = NULL;
-			priv->curr_bss_params.bss_descriptor.beacon_buf_size =
-				0;
-			priv->curr_bss_params.bss_descriptor.
-				beacon_buf_size_max = 0;
-
-			dev_dbg(adapter->dev, "info: Found current ssid/bssid"
-				" in list @ index #%d\n", j);
-			/* Make a copy of current BSSID descriptor */
-			memcpy(&priv->curr_bss_params.bss_descriptor,
-			       &adapter->scan_table[j],
-			       sizeof(priv->curr_bss_params.bss_descriptor));
-
-			mwifiex_save_curr_bcn(priv);
-			spin_unlock_irqrestore(&priv->curr_bcn_buf_lock, flags);
-
-		} else {
-			mwifiex_restore_curr_bcn(priv);
-		}
-	}
-
-	for (i = 0; i < adapter->num_in_scan_table; i++)
-		dev_dbg(adapter->dev, "info: scan:(%02d) %pM "
-		       "RSSI[%03d], SSID[%s]\n",
-		       i, adapter->scan_table[i].mac_address,
-		       (s32) adapter->scan_table[i].rssi,
-		       adapter->scan_table[i].ssid.ssid);
-}
-
-/*
  * This function converts radio type scan parameter to a band configuration
  * to be used in join command.
  */
@@ -2072,175 +1308,6 @@ mwifiex_radio_type_to_band(u8 radio_type)
 }
 
 /*
- * This function deletes a specific indexed entry from the scan table.
- *
- * This also compacts the remaining entries and adjusts any buffering
- * of beacon/probe response data if needed.
- */
-static void
-mwifiex_scan_delete_table_entry(struct mwifiex_private *priv, s32 table_idx)
-{
-	struct mwifiex_adapter *adapter = priv->adapter;
-	u32 del_idx;
-	u32 beacon_buf_adj;
-	u8 *beacon_buf;
-
-	/*
-	 * Shift the saved beacon buffer data for the scan table back over the
-	 *   entry being removed.  Update the end of buffer pointer.  Save the
-	 *   deleted buffer allocation size for pointer adjustments for entries
-	 *   compacted after the deleted index.
-	 */
-	beacon_buf_adj = adapter->scan_table[table_idx].beacon_buf_size_max;
-
-	dev_dbg(adapter->dev, "info: Scan: Delete Entry %d, beacon buffer "
-		"removal = %d bytes\n", table_idx, beacon_buf_adj);
-
-	/* Check if the table entry had storage allocated for its beacon */
-	if (beacon_buf_adj) {
-		beacon_buf = adapter->scan_table[table_idx].beacon_buf;
-
-		/*
-		 * Remove the entry's buffer space, decrement the table end
-		 * pointer by the amount we are removing
-		 */
-		adapter->bcn_buf_end -= beacon_buf_adj;
-
-		dev_dbg(adapter->dev, "info: scan: delete entry %d,"
-			" compact data: %p <- %p (sz = %d)\n",
-		       table_idx, beacon_buf,
-		       beacon_buf + beacon_buf_adj,
-		       (int)(adapter->bcn_buf_end - beacon_buf));
-
-		/*
-		 * Compact data storage.  Copy all data after the deleted
-		 * entry's end address (beacon_buf + beacon_buf_adj) back
-		 * to the original start address (beacon_buf).
-		 *
-		 * Scan table entries affected by the move will have their
-		 * entry pointer adjusted below.
-		 *
-		 * Use memmove since the dest/src memory regions overlap.
-		 */
-		memmove(beacon_buf, beacon_buf + beacon_buf_adj,
-			adapter->bcn_buf_end - beacon_buf);
-	}
-
-	dev_dbg(adapter->dev,
-		"info: Scan: Delete Entry %d, num_in_scan_table = %d\n",
-	       table_idx, adapter->num_in_scan_table);
-
-	/* Shift all of the entries after the table_idx back by one, compacting
-	   the table and removing the requested entry */
-	for (del_idx = table_idx; (del_idx + 1) < adapter->num_in_scan_table;
-	     del_idx++) {
-		/* Copy the next entry over this one */
-		memcpy(adapter->scan_table + del_idx,
-		       adapter->scan_table + del_idx + 1,
-		       sizeof(struct mwifiex_bssdescriptor));
-
-		/*
-		 * Adjust this entry's pointer to its beacon buffer based on
-		 * the removed/compacted entry from the deleted index.  Don't
-		 * decrement if the buffer pointer is NULL (no data stored for
-		 * this entry).
-		 */
-		if (adapter->scan_table[del_idx].beacon_buf) {
-			adapter->scan_table[del_idx].beacon_buf -=
-				beacon_buf_adj;
-			if (adapter->scan_table[del_idx].bcn_wpa_ie)
-				adapter->scan_table[del_idx].bcn_wpa_ie =
-					(struct ieee_types_vendor_specific *)
-					(adapter->scan_table[del_idx].
-					 beacon_buf +
-					 adapter->scan_table[del_idx].
-					 wpa_offset);
-			if (adapter->scan_table[del_idx].bcn_rsn_ie)
-				adapter->scan_table[del_idx].bcn_rsn_ie =
-					(struct ieee_types_generic *)
-					(adapter->scan_table[del_idx].
-					 beacon_buf +
-					 adapter->scan_table[del_idx].
-					 rsn_offset);
-			if (adapter->scan_table[del_idx].bcn_wapi_ie)
-				adapter->scan_table[del_idx].bcn_wapi_ie =
-					(struct ieee_types_generic *)
-					(adapter->scan_table[del_idx].beacon_buf
-					 + adapter->scan_table[del_idx].
-					 wapi_offset);
-			if (adapter->scan_table[del_idx].bcn_ht_cap)
-				adapter->scan_table[del_idx].bcn_ht_cap =
-					(struct ieee80211_ht_cap *)
-					(adapter->scan_table[del_idx].beacon_buf
-					 + adapter->scan_table[del_idx].
-					  ht_cap_offset);
-
-			if (adapter->scan_table[del_idx].bcn_ht_info)
-				adapter->scan_table[del_idx].bcn_ht_info =
-					(struct ieee80211_ht_info *)
-					(adapter->scan_table[del_idx].beacon_buf
-					 + adapter->scan_table[del_idx].
-					  ht_info_offset);
-			if (adapter->scan_table[del_idx].bcn_bss_co_2040)
-				adapter->scan_table[del_idx].bcn_bss_co_2040 =
-					(u8 *)
-					(adapter->scan_table[del_idx].beacon_buf
-					 + adapter->scan_table[del_idx].
-					   bss_co_2040_offset);
-			if (adapter->scan_table[del_idx].bcn_ext_cap)
-				adapter->scan_table[del_idx].bcn_ext_cap =
-					(u8 *)
-					(adapter->scan_table[del_idx].beacon_buf
-					 + adapter->scan_table[del_idx].
-					     ext_cap_offset);
-			if (adapter->scan_table[del_idx].bcn_obss_scan)
-				adapter->scan_table[del_idx].
-					bcn_obss_scan =
-					(struct ieee_types_obss_scan_param *)
-					(adapter->scan_table[del_idx].beacon_buf
-					 + adapter->scan_table[del_idx].
-					     overlap_bss_offset);
-		}
-	}
-
-	/* The last entry is invalid now that it has been deleted or moved
-	   back */
-	memset(adapter->scan_table + adapter->num_in_scan_table - 1,
-	       0x00, sizeof(struct mwifiex_bssdescriptor));
-
-	adapter->num_in_scan_table--;
-}
-
-/*
- * This function deletes all occurrences of a given SSID from the scan table.
- *
- * This iterates through the scan table and deletes all entries that match
- * the given SSID. It also compacts the remaining scan table entries.
- */
-static int
-mwifiex_scan_delete_ssid_table_entry(struct mwifiex_private *priv,
-				     struct mwifiex_802_11_ssid *del_ssid)
-{
-	s32 table_idx = -1;
-
-	dev_dbg(priv->adapter->dev, "info: scan: delete ssid entry: %-32s\n",
-			del_ssid->ssid);
-
-	/* If the requested SSID is found in the table, delete it.  Then keep
-	   searching the table for multiple entires for the SSID until no
-	   more are found */
-	while ((table_idx = mwifiex_find_ssid_in_list(priv, del_ssid, NULL,
-					NL80211_IFTYPE_UNSPECIFIED)) >= 0) {
-		dev_dbg(priv->adapter->dev,
-			"info: Scan: Delete SSID Entry: Found Idx = %d\n",
-		       table_idx);
-		mwifiex_scan_delete_table_entry(priv, table_idx);
-	}
-
-	return table_idx == -1 ? -1 : 0;
-}
-
-/*
  * This is an internal function used to start a scan based on an input
  * configuration.
  *
@@ -2258,7 +1325,6 @@ int mwifiex_scan_networks(struct mwifiex_private *priv,
 	struct mwifiex_ie_types_chan_list_param_set *chan_list_out;
 	u32 buf_size;
 	struct mwifiex_chan_scan_param_set *scan_chan_list;
-	u8 keep_previous_scan;
 	u8 filtered_scan;
 	u8 scan_current_chan_only;
 	u8 max_chan_per_scan;
@@ -2295,24 +1361,11 @@ int mwifiex_scan_networks(struct mwifiex_private *priv,
 		return -ENOMEM;
 	}
 
-	keep_previous_scan = false;
-
 	mwifiex_scan_setup_scan_config(priv, user_scan_in,
 				       &scan_cfg_out->config, &chan_list_out,
 				       scan_chan_list, &max_chan_per_scan,
 				       &filtered_scan, &scan_current_chan_only);
 
-	if (user_scan_in)
-		keep_previous_scan = user_scan_in->keep_previous_scan;
-
-
-	if (!keep_previous_scan) {
-		memset(adapter->scan_table, 0x00,
-		       sizeof(struct mwifiex_bssdescriptor) * MWIFIEX_MAX_AP);
-		adapter->num_in_scan_table = 0;
-		adapter->bcn_buf_end = adapter->bcn_buf;
-	}
-
 	ret = mwifiex_scan_channel_list(priv, max_chan_per_scan, filtered_scan,
 					&scan_cfg_out->config, chan_list_out,
 					scan_chan_list);
@@ -2379,6 +1432,107 @@ int mwifiex_cmd_802_11_scan(struct host_cmd_ds_command *cmd,
 }
 
 /*
+ * This function checks compatibility of requested network with current
+ * driver settings.
+ */
+int mwifiex_check_network_compatibility(struct mwifiex_private *priv,
+					struct mwifiex_bssdescriptor *bss_desc)
+{
+	int ret = -1;
+
+	if (!bss_desc)
+		return -1;
+
+	if ((mwifiex_get_cfp_by_band_and_channel_from_cfg80211(priv,
+			(u8) bss_desc->bss_band, (u16) bss_desc->channel))) {
+		switch (priv->bss_mode) {
+		case NL80211_IFTYPE_STATION:
+		case NL80211_IFTYPE_ADHOC:
+			ret = mwifiex_is_network_compatible(priv, bss_desc,
+							    priv->bss_mode);
+			if (ret)
+				dev_err(priv->adapter->dev, "cannot find ssid "
+					"%s\n", bss_desc->ssid.ssid);
+				break;
+		default:
+				ret = 0;
+		}
+	}
+
+	return ret;
+}
+
+static int
+mwifiex_update_curr_bss_params(struct mwifiex_private *priv,
+			u8 *bssid, s32 rssi, const u8 *ie_buf,
+			size_t ie_len, u16 beacon_period, u16 cap_info_bitmap)
+{
+	struct mwifiex_bssdescriptor *bss_desc = NULL;
+	int ret;
+	unsigned long flags;
+	u8 *beacon_ie;
+
+	/* Allocate and fill new bss descriptor */
+	bss_desc = kzalloc(sizeof(struct mwifiex_bssdescriptor),
+			GFP_KERNEL);
+	if (!bss_desc) {
+		dev_err(priv->adapter->dev, " failed to alloc bss_desc\n");
+		return -ENOMEM;
+	}
+	beacon_ie = kzalloc(ie_len, GFP_KERNEL);
+	if (!bss_desc) {
+		dev_err(priv->adapter->dev, " failed to alloc bss_desc\n");
+		return -ENOMEM;
+	}
+	memcpy(beacon_ie, ie_buf, ie_len);
+
+	ret = mwifiex_fill_new_bss_desc(priv, bssid, rssi, beacon_ie,
+					ie_len, beacon_period,
+					cap_info_bitmap, bss_desc);
+	if (ret)
+		goto done;
+
+	ret = mwifiex_check_network_compatibility(priv, bss_desc);
+	if (ret)
+		goto done;
+
+	/* Update current bss descriptor parameters */
+	spin_lock_irqsave(&priv->curr_bcn_buf_lock, flags);
+	priv->curr_bss_params.bss_descriptor.bcn_wpa_ie = NULL;
+	priv->curr_bss_params.bss_descriptor.wpa_offset = 0;
+	priv->curr_bss_params.bss_descriptor.bcn_rsn_ie = NULL;
+	priv->curr_bss_params.bss_descriptor.rsn_offset = 0;
+	priv->curr_bss_params.bss_descriptor.bcn_wapi_ie = NULL;
+	priv->curr_bss_params.bss_descriptor.wapi_offset = 0;
+	priv->curr_bss_params.bss_descriptor.bcn_ht_cap = NULL;
+	priv->curr_bss_params.bss_descriptor.ht_cap_offset =
+		0;
+	priv->curr_bss_params.bss_descriptor.bcn_ht_info = NULL;
+	priv->curr_bss_params.bss_descriptor.ht_info_offset =
+		0;
+	priv->curr_bss_params.bss_descriptor.bcn_bss_co_2040 =
+		NULL;
+	priv->curr_bss_params.bss_descriptor.
+		bss_co_2040_offset = 0;
+	priv->curr_bss_params.bss_descriptor.bcn_ext_cap = NULL;
+	priv->curr_bss_params.bss_descriptor.ext_cap_offset = 0;
+	priv->curr_bss_params.bss_descriptor.beacon_buf = NULL;
+	priv->curr_bss_params.bss_descriptor.beacon_buf_size =
+		0;
+
+	/* Make a copy of current BSSID descriptor */
+	memcpy(&priv->curr_bss_params.bss_descriptor, bss_desc,
+		sizeof(priv->curr_bss_params.bss_descriptor));
+	mwifiex_save_curr_bcn(priv);
+	spin_unlock_irqrestore(&priv->curr_bcn_buf_lock, flags);
+
+done:
+	kfree(bss_desc);
+	kfree(beacon_ie);
+	return 0;
+}
+
+/*
  * This function handles the command response of scan.
  *
  * The response buffer for the scan command has the following
@@ -2404,21 +1558,16 @@ int mwifiex_ret_802_11_scan(struct mwifiex_private *priv,
 	struct mwifiex_adapter *adapter = priv->adapter;
 	struct cmd_ctrl_node *cmd_node;
 	struct host_cmd_ds_802_11_scan_rsp *scan_rsp;
-	struct mwifiex_bssdescriptor *bss_new_entry = NULL;
 	struct mwifiex_ie_types_data *tlv_data;
 	struct mwifiex_ie_types_tsf_timestamp *tsf_tlv;
 	u8 *bss_info;
 	u32 scan_resp_size;
 	u32 bytes_left;
-	u32 num_in_table;
-	u32 bss_idx;
 	u32 idx;
 	u32 tlv_buf_size;
-	long long tsf_val;
 	struct mwifiex_chan_freq_power *cfp;
 	struct mwifiex_ie_types_chan_band_list_param_set *chan_band_tlv;
 	struct chan_band_param_set *chan_band;
-	u8 band;
 	u8 is_bgscan_resp;
 	unsigned long flags;
 
@@ -2447,7 +1596,6 @@ int mwifiex_ret_802_11_scan(struct mwifiex_private *priv,
 		"info: SCAN_RESP: returned %d APs before parsing\n",
 	       scan_rsp->number_of_sets);
 
-	num_in_table = adapter->num_in_scan_table;
 	bss_info = scan_rsp->bss_desc_and_tlv_buffer;
 
 	/*
@@ -2479,125 +1627,147 @@ int mwifiex_ret_802_11_scan(struct mwifiex_private *priv,
 					     (struct mwifiex_ie_types_data **)
 					     &chan_band_tlv);
 
-	/*
-	 *  Process each scan response returned (scan_rsp->number_of_sets).
-	 *  Save the information in the bss_new_entry and then insert into the
-	 *  driver scan table either as an update to an existing entry
-	 *  or as an addition at the end of the table
-	 */
-	bss_new_entry = kzalloc(sizeof(struct mwifiex_bssdescriptor),
-				GFP_KERNEL);
-	if (!bss_new_entry) {
-		dev_err(adapter->dev, " failed to alloc bss_new_entry\n");
-		return -ENOMEM;
-	}
-
 	for (idx = 0; idx < scan_rsp->number_of_sets && bytes_left; idx++) {
-		/* Zero out the bss_new_entry we are about to store info in */
-		memset(bss_new_entry, 0x00,
-		       sizeof(struct mwifiex_bssdescriptor));
-
-		if (mwifiex_interpret_bss_desc_with_ie(adapter, bss_new_entry,
-							&bss_info,
-							&bytes_left)) {
-			/* Error parsing/interpreting scan response, skipped */
-			dev_err(adapter->dev, "SCAN_RESP: "
-			       "mwifiex_interpret_bss_desc_with_ie "
-			       "returned ERROR\n");
-			continue;
+		u8 bssid[ETH_ALEN];
+		s32 rssi;
+		const u8 *ie_buf;
+		size_t ie_len;
+		int channel = -1;
+		u64 network_tsf = 0;
+		u16 beacon_size = 0;
+		u32 curr_bcn_bytes;
+		u32 freq;
+		u16 beacon_period;
+		u16 cap_info_bitmap;
+		u8 *current_ptr;
+		struct mwifiex_bcn_param *bcn_param;
+
+		if (bytes_left >= sizeof(beacon_size)) {
+			/* Extract & convert beacon size from command buffer */
+			memcpy(&beacon_size, bss_info, sizeof(beacon_size));
+			bytes_left -= sizeof(beacon_size);
+			bss_info += sizeof(beacon_size);
 		}
 
-		/* Process the data fields and IEs returned for this BSS */
-		dev_dbg(adapter->dev, "info: SCAN_RESP: BSSID = %pM\n",
-		       bss_new_entry->mac_address);
+		if (!beacon_size || beacon_size > bytes_left) {
+			bss_info += bytes_left;
+			bytes_left = 0;
+			return -1;
+		}
 
-		/* Search the scan table for the same bssid */
-		for (bss_idx = 0; bss_idx < num_in_table; bss_idx++) {
-			if (memcmp(bss_new_entry->mac_address,
-				adapter->scan_table[bss_idx].mac_address,
-				sizeof(bss_new_entry->mac_address))) {
-				continue;
+		/* Initialize the current working beacon pointer for this BSS
+		 * iteration */
+		current_ptr = bss_info;
+
+		/* Advance the return beacon pointer past the current beacon */
+		bss_info += beacon_size;
+		bytes_left -= beacon_size;
+
+		curr_bcn_bytes = beacon_size;
+
+		/*
+		 * First 5 fields are bssid, RSSI, time stamp, beacon interval,
+		 *   and capability information
+		 */
+		if (curr_bcn_bytes < sizeof(struct mwifiex_bcn_param)) {
+			dev_err(adapter->dev, "InterpretIE: not enough bytes left\n");
+			continue;
+		}
+		bcn_param = (struct mwifiex_bcn_param *)current_ptr;
+		current_ptr += sizeof(*bcn_param);
+		curr_bcn_bytes -= sizeof(*bcn_param);
+
+		memcpy(bssid, bcn_param->bssid, ETH_ALEN);
+
+		rssi = (s32) (bcn_param->rssi);
+		dev_dbg(adapter->dev, "info: InterpretIE: RSSI=%02X\n",
+					rssi);
+
+		beacon_period = le16_to_cpu(bcn_param->beacon_period);
+
+		cap_info_bitmap = le16_to_cpu(bcn_param->cap_info_bitmap);
+		dev_dbg(adapter->dev, "info: InterpretIE: capabilities=0x%X\n",
+				cap_info_bitmap);
+
+		/* Rest of the current buffer are IE's */
+		ie_buf = current_ptr;
+		ie_len = curr_bcn_bytes;
+		dev_dbg(adapter->dev, "info: InterpretIE: IELength for this AP"
+				      " = %d\n", curr_bcn_bytes);
+
+		while (curr_bcn_bytes >= sizeof(struct ieee_types_header)) {
+			u8 element_id, element_len;
+
+			element_id = *current_ptr;
+			element_len = *(current_ptr + 1);
+			if (curr_bcn_bytes < element_len +
+					sizeof(struct ieee_types_header)) {
+				dev_err(priv->adapter->dev, "%s: in processing"
+					" IE, bytes left < IE length\n",
+					__func__);
+				goto done;
 			}
-			/*
-			 * If the SSID matches as well, it is a
-			 * duplicate of this entry.  Keep the bss_idx
-			 * set to this entry so we replace the old
-			 * contents in the table
-			 */
-			if ((bss_new_entry->ssid.ssid_len
-				== adapter->scan_table[bss_idx]. ssid.ssid_len)
-					&& (!memcmp(bss_new_entry->ssid.ssid,
-					adapter->scan_table[bss_idx].ssid.ssid,
-					bss_new_entry->ssid.ssid_len))) {
-				dev_dbg(adapter->dev, "info: SCAN_RESP:"
-					" duplicate of index: %d\n", bss_idx);
+			if (element_id == WLAN_EID_DS_PARAMS) {
+				channel = *(u8 *) (current_ptr +
+					sizeof(struct ieee_types_header));
 				break;
 			}
-		}
-		/*
-		 * If the bss_idx is equal to the number of entries in
-		 * the table, the new entry was not a duplicate; append
-		 * it to the scan table
-		 */
-		if (bss_idx == num_in_table) {
-			/* Range check the bss_idx, keep it limited to
-			   the last entry */
-			if (bss_idx == MWIFIEX_MAX_AP)
-				bss_idx--;
-			else
-				num_in_table++;
+
+			current_ptr += element_len +
+					sizeof(struct ieee_types_header);
+			curr_bcn_bytes -= element_len +
+					sizeof(struct ieee_types_header);
 		}
 
 		/*
-		 * Save the beacon/probe response returned for later application
-		 * retrieval.  Duplicate beacon/probe responses are updated if
-		 * possible
-		 */
-		mwifiex_ret_802_11_scan_store_beacon(priv, bss_idx,
-						num_in_table, bss_new_entry);
-		/*
 		 * If the TSF TLV was appended to the scan results, save this
 		 * entry's TSF value in the networkTSF field.The networkTSF is
 		 * the firmware's TSF value at the time the beacon or probe
 		 * response was received.
 		 */
-		if (tsf_tlv) {
-			memcpy(&tsf_val, &tsf_tlv->tsf_data[idx * TSF_DATA_SIZE]
-					, sizeof(tsf_val));
-			memcpy(&bss_new_entry->network_tsf, &tsf_val,
-					sizeof(bss_new_entry->network_tsf));
-		}
-		band = BAND_G;
-		if (chan_band_tlv) {
-			chan_band = &chan_band_tlv->chan_band_param[idx];
-			band = mwifiex_radio_type_to_band(chan_band->radio_type
-					& (BIT(0) | BIT(1)));
-		}
-
-		/* Save the band designation for this entry for use in join */
-		bss_new_entry->bss_band = band;
-		cfp = mwifiex_get_cfp_by_band_and_channel_from_cfg80211(priv,
-					(u8) bss_new_entry->bss_band,
-					(u16)bss_new_entry->channel);
+		if (tsf_tlv)
+			memcpy(&network_tsf,
+					&tsf_tlv->tsf_data[idx * TSF_DATA_SIZE],
+					sizeof(network_tsf));
+
+		if (channel != -1) {
+			struct ieee80211_channel *chan;
+			u8 band;
+
+			band = BAND_G;
+			if (chan_band_tlv) {
+				chan_band =
+					&chan_band_tlv->chan_band_param[idx];
+				band = mwifiex_radio_type_to_band(
+						chan_band->radio_type
+						& (BIT(0) | BIT(1)));
+			}
 
-		if (cfp)
-			bss_new_entry->freq = cfp->freq;
-		else
-			bss_new_entry->freq = 0;
+			cfp = mwifiex_get_cfp_by_band_and_channel_from_cfg80211(
+						priv, (u8)band, (u16)channel);
 
-		/* Copy the locally created bss_new_entry to the scan table */
-		memcpy(&adapter->scan_table[bss_idx], bss_new_entry,
-		       sizeof(adapter->scan_table[bss_idx]));
+			freq = cfp ? cfp->freq : 0;
 
-	}
+			chan = ieee80211_get_channel(priv->wdev->wiphy, freq);
 
-	dev_dbg(adapter->dev,
-		"info: SCAN_RESP: Scanned %2d APs, %d valid, %d total\n",
-	       scan_rsp->number_of_sets,
-	       num_in_table - adapter->num_in_scan_table, num_in_table);
+			if (chan && !(chan->flags & IEEE80211_CHAN_DISABLED)) {
+				cfg80211_inform_bss(priv->wdev->wiphy, chan,
+					bssid, network_tsf, cap_info_bitmap,
+					beacon_period, ie_buf, ie_len, rssi,
+					GFP_KERNEL);
 
-	/* Update the total number of BSSIDs in the scan table */
-	adapter->num_in_scan_table = num_in_table;
+				if (priv->media_connected && !memcmp(bssid,
+					priv->curr_bss_params.bss_descriptor
+						     .mac_address, ETH_ALEN))
+					mwifiex_update_curr_bss_params(priv,
+							bssid, rssi, ie_buf,
+							ie_len, beacon_period,
+							cap_info_bitmap);
+			}
+		} else {
+			dev_dbg(adapter->dev, "missing BSS channel IE\n");
+		}
+	}
 
 	spin_lock_irqsave(&adapter->scan_pending_q_lock, flags);
 	if (list_empty(&adapter->scan_pending_q)) {
@@ -2605,12 +1775,6 @@ int mwifiex_ret_802_11_scan(struct mwifiex_private *priv,
 		spin_lock_irqsave(&adapter->mwifiex_cmd_lock, flags);
 		adapter->scan_processing = false;
 		spin_unlock_irqrestore(&adapter->mwifiex_cmd_lock, flags);
-		/*
-		 * Process the resulting scan table:
-		 *   - Remove any bad ssids
-		 *   - Update our current BSS information from scan data
-		 */
-		mwifiex_process_scan_results(priv);
 
 		/* Need to indicate IOCTL complete */
 		if (adapter->curr_cmd->wait_q_enabled) {
@@ -2636,7 +1800,6 @@ int mwifiex_ret_802_11_scan(struct mwifiex_private *priv,
 	}
 
 done:
-	kfree((u8 *) bss_new_entry);
 	return ret;
 }
 
@@ -2663,141 +1826,6 @@ int mwifiex_cmd_802_11_bg_scan_query(struct host_cmd_ds_command *cmd)
 }
 
 /*
- * This function finds a SSID in the scan table.
- *
- * A BSSID may optionally be provided to qualify the SSID.
- * For non-Auto mode, further check is made to make sure the
- * BSS found in the scan table is compatible with the current
- * settings of the driver.
- */
-s32
-mwifiex_find_ssid_in_list(struct mwifiex_private *priv,
-			  struct mwifiex_802_11_ssid *ssid, u8 *bssid,
-			  u32 mode)
-{
-	struct mwifiex_adapter *adapter = priv->adapter;
-	s32 net = -1, j;
-	u8 best_rssi = 0;
-	u32 i;
-
-	dev_dbg(adapter->dev, "info: num of entries in table = %d\n",
-	       adapter->num_in_scan_table);
-
-	/*
-	 * Loop through the table until the maximum is reached or until a match
-	 *   is found based on the bssid field comparison
-	 */
-	for (i = 0;
-	     i < adapter->num_in_scan_table && (!bssid || (bssid && net < 0));
-	     i++) {
-		if (!mwifiex_ssid_cmp(&adapter->scan_table[i].ssid, ssid) &&
-		    (!bssid
-		     || !memcmp(adapter->scan_table[i].mac_address, bssid,
-				ETH_ALEN))
-		    &&
-		    (mwifiex_get_cfp_by_band_and_channel_from_cfg80211
-		     (priv, (u8) adapter->scan_table[i].bss_band,
-		      (u16) adapter->scan_table[i].channel))) {
-			switch (mode) {
-			case NL80211_IFTYPE_STATION:
-			case NL80211_IFTYPE_ADHOC:
-				j = mwifiex_is_network_compatible(priv, i,
-								  mode);
-
-				if (j >= 0) {
-					if (SCAN_RSSI
-					    (adapter->scan_table[i].rssi) >
-					    best_rssi) {
-						best_rssi = SCAN_RSSI(adapter->
-								  scan_table
-								  [i].rssi);
-						net = i;
-					}
-				} else {
-					if (net == -1)
-						net = j;
-				}
-				break;
-			case NL80211_IFTYPE_UNSPECIFIED:
-			default:
-				/*
-				 * Do not check compatibility if the mode
-				 * requested is Auto/Unknown.  Allows generic
-				 * find to work without verifying against the
-				 * Adapter security settings
-				 */
-				if (SCAN_RSSI(adapter->scan_table[i].rssi) >
-				    best_rssi) {
-					best_rssi = SCAN_RSSI(adapter->
-							  scan_table[i].rssi);
-					net = i;
-				}
-				break;
-			}
-		}
-	}
-
-	return net;
-}
-
-/*
- * This function finds a specific compatible BSSID in the scan list.
- *
- * This function loops through the scan table looking for a compatible
- * match. If a BSSID matches, but the BSS is found to be not compatible
- * the function ignores it and continues to search through the rest of
- * the entries in case there is an AP with multiple SSIDs assigned to
- * the same BSSID.
- */
-s32
-mwifiex_find_bssid_in_list(struct mwifiex_private *priv, u8 *bssid,
-			   u32 mode)
-{
-	struct mwifiex_adapter *adapter = priv->adapter;
-	s32 net = -1;
-	u32 i;
-
-	if (!bssid)
-		return -1;
-
-	dev_dbg(adapter->dev, "info: FindBSSID: Num of BSSIDs = %d\n",
-	       adapter->num_in_scan_table);
-
-	/*
-	 * Look through the scan table for a compatible match. The ret return
-	 *   variable will be equal to the index in the scan table (greater
-	 *   than zero) if the network is compatible.  The loop will continue
-	 *   past a matched bssid that is not compatible in case there is an
-	 *   AP with multiple SSIDs assigned to the same BSSID
-	 */
-	for (i = 0; net < 0 && i < adapter->num_in_scan_table; i++) {
-		if (!memcmp
-		    (adapter->scan_table[i].mac_address, bssid, ETH_ALEN)
-			&& mwifiex_get_cfp_by_band_and_channel_from_cfg80211
-								(priv,
-							    (u8) adapter->
-							    scan_table[i].
-							    bss_band,
-							    (u16) adapter->
-							    scan_table[i].
-							    channel)) {
-			switch (mode) {
-			case NL80211_IFTYPE_STATION:
-			case NL80211_IFTYPE_ADHOC:
-				net = mwifiex_is_network_compatible(priv, i,
-								    mode);
-				break;
-			default:
-				net = i;
-				break;
-			}
-		}
-	}
-
-	return net;
-}
-
-/*
  * This function inserts scan command node to the scan pending queue.
  */
 void
@@ -2814,42 +1842,6 @@ mwifiex_queue_scan_cmd(struct mwifiex_private *priv,
 }
 
 /*
- * This function finds an AP with specific ssid in the scan list.
- */
-int mwifiex_find_best_network(struct mwifiex_private *priv,
-			      struct mwifiex_ssid_bssid *req_ssid_bssid)
-{
-	struct mwifiex_adapter *adapter = priv->adapter;
-	struct mwifiex_bssdescriptor *req_bss;
-	s32 i;
-
-	memset(req_ssid_bssid, 0, sizeof(struct mwifiex_ssid_bssid));
-
-	i = mwifiex_find_best_network_in_list(priv);
-
-	if (i >= 0) {
-		req_bss = &adapter->scan_table[i];
-		memcpy(&req_ssid_bssid->ssid, &req_bss->ssid,
-		       sizeof(struct mwifiex_802_11_ssid));
-		memcpy((u8 *) &req_ssid_bssid->bssid,
-		       (u8 *) &req_bss->mac_address, ETH_ALEN);
-
-		/* Make sure we are in the right mode */
-		if (priv->bss_mode == NL80211_IFTYPE_UNSPECIFIED)
-			priv->bss_mode = req_bss->bss_mode;
-	}
-
-	if (!req_ssid_bssid->ssid.ssid_len)
-		return -1;
-
-	dev_dbg(adapter->dev, "info: Best network found = [%s], "
-	       "[%pM]\n", req_ssid_bssid->ssid.ssid,
-	       req_ssid_bssid->bssid);
-
-	return 0;
-}
-
-/*
  * This function sends a scan command for all available channels to the
  * firmware, filtered on a specific SSID.
  */
@@ -2874,8 +1866,6 @@ static int mwifiex_scan_specific_ssid(struct mwifiex_private *priv,
 		return ret;
 	}
 
-	mwifiex_scan_delete_ssid_table_entry(priv, req_ssid);
-
 	scan_cfg = kzalloc(sizeof(struct mwifiex_user_scan_cfg), GFP_KERNEL);
 	if (!scan_cfg) {
 		dev_err(adapter->dev, "failed to alloc scan_cfg\n");
@@ -2884,7 +1874,6 @@ static int mwifiex_scan_specific_ssid(struct mwifiex_private *priv,
 
 	memcpy(scan_cfg->ssid_list[0].ssid, req_ssid->ssid,
 	       req_ssid->ssid_len);
-	scan_cfg->keep_previous_scan = true;
 
 	ret = mwifiex_scan_networks(priv, scan_cfg);
 
@@ -3010,6 +1999,39 @@ mwifiex_save_curr_bcn(struct mwifiex_private *priv)
 		curr_bss->beacon_buf_size);
 	dev_dbg(priv->adapter->dev, "info: current beacon saved %d\n",
 		priv->curr_bcn_size);
+
+	curr_bss->beacon_buf = priv->curr_bcn_buf;
+
+	/* adjust the pointers in the current BSS descriptor */
+	if (curr_bss->bcn_wpa_ie)
+		curr_bss->bcn_wpa_ie =
+			(struct ieee_types_vendor_specific *)
+			(curr_bss->beacon_buf +
+			 curr_bss->wpa_offset);
+
+	if (curr_bss->bcn_rsn_ie)
+		curr_bss->bcn_rsn_ie = (struct ieee_types_generic *)
+			(curr_bss->beacon_buf +
+			 curr_bss->rsn_offset);
+
+	if (curr_bss->bcn_ht_cap)
+		curr_bss->bcn_ht_cap = (struct ieee80211_ht_cap *)
+			(curr_bss->beacon_buf +
+			 curr_bss->ht_cap_offset);
+
+	if (curr_bss->bcn_ht_info)
+		curr_bss->bcn_ht_info = (struct ieee80211_ht_info *)
+			(curr_bss->beacon_buf +
+			 curr_bss->ht_info_offset);
+
+	if (curr_bss->bcn_bss_co_2040)
+		curr_bss->bcn_bss_co_2040 =
+			(u8 *) (curr_bss->beacon_buf +
+					curr_bss->bss_co_2040_offset);
+
+	if (curr_bss->bcn_ext_cap)
+		curr_bss->bcn_ext_cap = (u8 *) (curr_bss->beacon_buf +
+				curr_bss->ext_cap_offset);
 }
 
 /*
diff --git a/drivers/net/wireless/mwifiex/sta_event.c b/drivers/net/wireless/mwifiex/sta_event.c
index 6e8b198..f204810 100644
--- a/drivers/net/wireless/mwifiex/sta_event.c
+++ b/drivers/net/wireless/mwifiex/sta_event.c
@@ -299,11 +299,6 @@ int mwifiex_process_sta_event(struct mwifiex_private *priv)
 
 	case EVENT_BG_SCAN_REPORT:
 		dev_dbg(adapter->dev, "event: BGS_REPORT\n");
-		/* Clear the previous scan result */
-		memset(adapter->scan_table, 0x00,
-		       sizeof(struct mwifiex_bssdescriptor) * MWIFIEX_MAX_AP);
-		adapter->num_in_scan_table = 0;
-		adapter->bcn_buf_end = adapter->bcn_buf;
 		ret = mwifiex_send_cmd_async(priv,
 					     HostCmd_CMD_802_11_BG_SCAN_QUERY,
 					     HostCmd_ACT_GEN_GET, 0, NULL);
diff --git a/drivers/net/wireless/mwifiex/sta_ioctl.c b/drivers/net/wireless/mwifiex/sta_ioctl.c
index fd764b3..3fca219 100644
--- a/drivers/net/wireless/mwifiex/sta_ioctl.c
+++ b/drivers/net/wireless/mwifiex/sta_ioctl.c
@@ -142,90 +142,142 @@ int mwifiex_request_set_multicast_list(struct mwifiex_private *priv,
 }
 
 /*
+ * This function fills bss descriptor structure using provided
+ * information.
+ */
+int mwifiex_fill_new_bss_desc(struct mwifiex_private *priv,
+			      u8 *bssid, s32 rssi, u8 *ie_buf,
+			      size_t ie_len, u16 beacon_period,
+			      u16 cap_info_bitmap,
+			      struct mwifiex_bssdescriptor *bss_desc)
+{
+	int ret;
+
+	memcpy(bss_desc->mac_address, bssid, ETH_ALEN);
+	bss_desc->rssi = rssi;
+	bss_desc->beacon_buf = ie_buf;
+	bss_desc->beacon_buf_size = ie_len;
+	bss_desc->beacon_period = beacon_period;
+	bss_desc->cap_info_bitmap = cap_info_bitmap;
+	if (bss_desc->cap_info_bitmap & WLAN_CAPABILITY_PRIVACY) {
+		dev_dbg(priv->adapter->dev, "info: InterpretIE: AP WEP enabled\n");
+		bss_desc->privacy = MWIFIEX_802_11_PRIV_FILTER_8021X_WEP;
+	} else {
+		bss_desc->privacy = MWIFIEX_802_11_PRIV_FILTER_ACCEPT_ALL;
+	}
+	if (bss_desc->cap_info_bitmap & WLAN_CAPABILITY_IBSS)
+		bss_desc->bss_mode = NL80211_IFTYPE_ADHOC;
+	else
+		bss_desc->bss_mode = NL80211_IFTYPE_STATION;
+
+	ret = mwifiex_update_bss_desc_with_ie(priv->adapter, bss_desc,
+					      ie_buf, ie_len);
+
+	return ret;
+}
+
+/*
  * In Ad-Hoc mode, the IBSS is created if not found in scan list.
  * In both Ad-Hoc and infra mode, an deauthentication is performed
  * first.
  */
-int mwifiex_bss_start(struct mwifiex_private *priv,
-		      struct mwifiex_ssid_bssid *ssid_bssid)
+int mwifiex_bss_start(struct mwifiex_private *priv, struct cfg80211_bss *bss,
+		      struct mwifiex_802_11_ssid *req_ssid)
 {
 	int ret;
 	struct mwifiex_adapter *adapter = priv->adapter;
-	s32 i = -1;
+	struct mwifiex_bssdescriptor *bss_desc = NULL;
+	u8 *beacon_ie = NULL;
 
 	priv->scan_block = false;
-	if (!ssid_bssid)
-		return -1;
+
+	if (bss) {
+		/* Allocate and fill new bss descriptor */
+		bss_desc = kzalloc(sizeof(struct mwifiex_bssdescriptor),
+				GFP_KERNEL);
+		if (!bss_desc) {
+			dev_err(priv->adapter->dev, " failed to alloc bss_desc\n");
+			return -ENOMEM;
+		}
+		beacon_ie = kzalloc(bss->len_beacon_ies, GFP_KERNEL);
+		if (!beacon_ie) {
+			dev_err(priv->adapter->dev, " failed to alloc bss_desc\n");
+			return -ENOMEM;
+		}
+		memcpy(beacon_ie, bss->information_elements,
+		       bss->len_beacon_ies);
+		ret = mwifiex_fill_new_bss_desc(priv, bss->bssid, bss->signal,
+						beacon_ie, bss->len_beacon_ies,
+						bss->beacon_interval,
+						bss->capability, bss_desc);
+		if (ret)
+			goto done;
+	}
 
 	if (priv->bss_mode == NL80211_IFTYPE_STATION) {
 		/* Infra mode */
 		ret = mwifiex_deauthenticate(priv, NULL);
 		if (ret)
-			return ret;
+			goto done;
 
-		/* Search for the requested SSID in the scan table */
-		if (ssid_bssid->ssid.ssid_len)
-			i = mwifiex_find_ssid_in_list(priv, &ssid_bssid->ssid,
-						NULL, NL80211_IFTYPE_STATION);
-		else
-			i = mwifiex_find_bssid_in_list(priv,
-						(u8 *) &ssid_bssid->bssid,
-						NL80211_IFTYPE_STATION);
-		if (i < 0)
-			return -1;
+		ret = mwifiex_check_network_compatibility(priv, bss_desc);
+		if (ret)
+			goto done;
+
+		dev_dbg(adapter->dev, "info: SSID found in scan list ... "
+				      "associating...\n");
 
-		dev_dbg(adapter->dev,
-			"info: SSID found in scan list ... associating...\n");
+		if (!netif_queue_stopped(priv->netdev))
+			netif_stop_queue(priv->netdev);
 
 		/* Clear any past association response stored for
 		 * application retrieval */
 		priv->assoc_rsp_size = 0;
-		ret = mwifiex_associate(priv, &adapter->scan_table[i]);
-		if (ret)
-			return ret;
+		ret = mwifiex_associate(priv, bss_desc);
+		if (bss)
+			cfg80211_put_bss(bss);
 	} else {
 		/* Adhoc mode */
 		/* If the requested SSID matches current SSID, return */
-		if (ssid_bssid->ssid.ssid_len &&
+		if (bss_desc && bss_desc->ssid.ssid_len &&
 		    (!mwifiex_ssid_cmp
 		     (&priv->curr_bss_params.bss_descriptor.ssid,
-		      &ssid_bssid->ssid)))
+		      &bss_desc->ssid))) {
+			kfree(bss_desc);
+			kfree(beacon_ie);
 			return 0;
+		}
 
 		/* Exit Adhoc mode first */
 		dev_dbg(adapter->dev, "info: Sending Adhoc Stop\n");
 		ret = mwifiex_deauthenticate(priv, NULL);
 		if (ret)
-			return ret;
+			goto done;
 
 		priv->adhoc_is_link_sensed = false;
 
-		/* Search for the requested network in the scan table */
-		if (ssid_bssid->ssid.ssid_len)
-			i = mwifiex_find_ssid_in_list(priv,
-						      &ssid_bssid->ssid, NULL,
-						      NL80211_IFTYPE_ADHOC);
-		else
-			i = mwifiex_find_bssid_in_list(priv,
-						       (u8 *)&ssid_bssid->bssid,
-						       NL80211_IFTYPE_ADHOC);
-
-		if (i >= 0) {
+		ret = mwifiex_check_network_compatibility(priv, bss_desc);
+
+		if (!netif_queue_stopped(priv->netdev))
+			netif_stop_queue(priv->netdev);
+
+		if (!ret) {
 			dev_dbg(adapter->dev, "info: network found in scan"
 							" list. Joining...\n");
-			ret = mwifiex_adhoc_join(priv, &adapter->scan_table[i]);
-			if (ret)
-				return ret;
+			ret = mwifiex_adhoc_join(priv, bss_desc);
+			if (bss)
+				cfg80211_put_bss(bss);
 		} else {
 			dev_dbg(adapter->dev, "info: Network not found in "
 				"the list, creating adhoc with ssid = %s\n",
-			       ssid_bssid->ssid.ssid);
-			ret = mwifiex_adhoc_start(priv, &ssid_bssid->ssid);
-			if (ret)
-				return ret;
+				req_ssid->ssid);
+			ret = mwifiex_adhoc_start(priv, req_ssid);
 		}
 	}
 
+done:
+	kfree(bss_desc);
+	kfree(beacon_ie);
 	return ret;
 }
 
@@ -574,50 +626,6 @@ static int mwifiex_bss_ioctl_ibss_channel(struct mwifiex_private *priv,
 }
 
 /*
- * IOCTL request handler to find a particular BSS.
- *
- * The BSS can be searched with either a BSSID or a SSID. If none of
- * these are provided, just the best BSS (best RSSI) is returned.
- */
-int mwifiex_bss_ioctl_find_bss(struct mwifiex_private *priv,
-			       struct mwifiex_ssid_bssid *ssid_bssid)
-{
-	struct mwifiex_adapter *adapter = priv->adapter;
-	struct mwifiex_bssdescriptor *bss_desc;
-	u8 zero_mac[ETH_ALEN] = { 0, 0, 0, 0, 0, 0 };
-	u8 mac[ETH_ALEN];
-	int i = 0;
-
-	if (memcmp(ssid_bssid->bssid, zero_mac, sizeof(zero_mac))) {
-		i = mwifiex_find_bssid_in_list(priv,
-					       (u8 *) ssid_bssid->bssid,
-					       priv->bss_mode);
-		if (i < 0) {
-			memcpy(mac, ssid_bssid->bssid, sizeof(mac));
-			dev_err(adapter->dev, "cannot find bssid %pM\n", mac);
-			return -1;
-		}
-		bss_desc = &adapter->scan_table[i];
-		memcpy(&ssid_bssid->ssid, &bss_desc->ssid,
-				sizeof(struct mwifiex_802_11_ssid));
-	} else if (ssid_bssid->ssid.ssid_len) {
-		i = mwifiex_find_ssid_in_list(priv, &ssid_bssid->ssid, NULL,
-					      priv->bss_mode);
-		if (i < 0) {
-			dev_err(adapter->dev, "cannot find ssid %s\n",
-					ssid_bssid->ssid.ssid);
-			return -1;
-		}
-		bss_desc = &adapter->scan_table[i];
-		memcpy(ssid_bssid->bssid, bss_desc->mac_address, ETH_ALEN);
-	} else {
-		return mwifiex_find_best_network(priv, ssid_bssid);
-	}
-
-	return 0;
-}
-
-/*
  * IOCTL request handler to change Ad-Hoc channel.
  *
  * This function allocates the IOCTL request buffer, fills it
@@ -641,6 +649,8 @@ mwifiex_drv_change_adhoc_chan(struct mwifiex_private *priv, int channel)
 	struct mwifiex_bss_info bss_info;
 	struct mwifiex_ssid_bssid ssid_bssid;
 	u16 curr_chan = 0;
+	struct cfg80211_bss *bss = NULL;
+	struct ieee80211_channel *chan;
 
 	memset(&bss_info, 0, sizeof(bss_info));
 
@@ -676,12 +686,20 @@ mwifiex_drv_change_adhoc_chan(struct mwifiex_private *priv, int channel)
 		ret = -1;
 		goto done;
 	}
-	/* Start/Join Adhoc network */
-	memset(&ssid_bssid, 0, sizeof(struct mwifiex_ssid_bssid));
-	memcpy(&ssid_bssid.ssid, &bss_info.ssid,
-	       sizeof(struct mwifiex_802_11_ssid));
 
-	ret = mwifiex_bss_start(priv, &ssid_bssid);
+	chan = __ieee80211_get_channel(priv->wdev->wiphy,
+			ieee80211_channel_to_frequency(channel,
+						priv->curr_bss_params.band));
+
+	/* Find the BSS we want using available scan results */
+	bss = cfg80211_get_bss(priv->wdev->wiphy, chan, bss_info.bssid,
+			       bss_info.ssid.ssid, bss_info.ssid.ssid_len,
+			       WLAN_CAPABILITY_ESS, WLAN_CAPABILITY_ESS);
+	if (!bss)
+		wiphy_warn(priv->wdev->wiphy, "assoc: bss %pM not in scan results\n",
+			  bss_info.bssid);
+
+	ret = mwifiex_bss_start(priv, bss, &bss_info.ssid);
 done:
 	return ret;
 }
-- 
1.7.0.2


Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa1.microchip.iphmx.com ([68.232.147.91]:45786 "EHLO
        esa1.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727416AbeGSGq7 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 19 Jul 2018 02:46:59 -0400
From: Ajay Singh <ajay.kathat@microchip.com>
To: <linux-wireless@vger.kernel.org>
CC: <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <ganesh.krishna@microchip.com>, <venkateswara.kaja@microchip.com>,
        <aditya.shankar@microchip.com>, <claudiu.beznea@microchip.com>,
        <adham.abozaeid@microchip.com>,
        Ajay Singh <ajay.kathat@microchip.com>
Subject: [PATCH 21/23] staging: wilc1000: use 'int' inplace of 's32' date type
Date: Thu, 19 Jul 2018 04:15:17 +0530
Message-ID: <1531953919-20804-22-git-send-email-ajay.kathat@microchip.com> (sfid-20180719_080535_966273_2E436921)
In-Reply-To: <1531953919-20804-1-git-send-email-ajay.kathat@microchip.com>
References: <1531953919-20804-1-git-send-email-ajay.kathat@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Cleanup patch to use 'int' instead of 's32' to have the same data type
based on its usage.

Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
---
 drivers/staging/wilc1000/host_interface.c         | 48 +++++++++++------------
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c | 28 ++++++-------
 2 files changed, 38 insertions(+), 38 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index d251a64..fb063e5 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -722,9 +722,9 @@ static void handle_cfg_param(struct work_struct *work)
 	kfree(msg);
 }
 
-static s32 handle_scan_done(struct wilc_vif *vif, enum scan_event evt)
+static int handle_scan_done(struct wilc_vif *vif, enum scan_event evt)
 {
-	s32 result = 0;
+	int result = 0;
 	u8 abort_running_scan;
 	struct wid wid;
 	struct host_if_drv *hif_drv = vif->hif_drv;
@@ -765,7 +765,7 @@ static void handle_scan(struct work_struct *work)
 	struct host_if_msg *msg = container_of(work, struct host_if_msg, work);
 	struct wilc_vif *vif = msg->vif;
 	struct scan_attr *scan_info = &msg->body.scan_info;
-	s32 result = 0;
+	int result = 0;
 	struct wid wid_list[5];
 	u32 index = 0;
 	u32 i;
@@ -883,7 +883,7 @@ static void handle_connect(struct work_struct *work)
 	struct host_if_msg *msg = container_of(work, struct host_if_msg, work);
 	struct wilc_vif *vif = msg->vif;
 	struct connect_attr *conn_attr = &msg->body.con_info;
-	s32 result = 0;
+	int result = 0;
 	struct wid wid_list[8];
 	u32 wid_cnt = 0, dummyval = 0;
 	u8 *cur_byte = NULL;
@@ -1148,7 +1148,7 @@ static void handle_connect_timeout(struct work_struct *work)
 {
 	struct host_if_msg *msg = container_of(work, struct host_if_msg, work);
 	struct wilc_vif *vif = msg->vif;
-	s32 result;
+	int result;
 	struct connect_info info;
 	struct wid wid;
 	u16 dummy_reason_code = 0;
@@ -1454,7 +1454,7 @@ static s32 host_int_get_assoc_res_info(struct wilc_vif *vif,
 				       u32 max_assoc_resp_info_len,
 				       u32 *rcvd_assoc_resp_info_len)
 {
-	s32 result;
+	int result;
 	struct wid wid;
 
 	wid.id = WID_ASSOC_RES_INFO;
@@ -1926,7 +1926,7 @@ static void handle_disconnect(struct work_struct *work)
 	struct disconnect_info disconn_info;
 	struct user_scan_req *scan_req;
 	struct user_conn_req *conn_req;
-	s32 result;
+	int result;
 	u16 dummy_reason_code = 0;
 
 	wid.id = WID_DISCONNECT;
@@ -2004,7 +2004,7 @@ static void handle_get_rssi(struct work_struct *work)
 {
 	struct host_if_msg *msg = container_of(work, struct host_if_msg, work);
 	struct wilc_vif *vif = msg->vif;
-	s32 result;
+	int result;
 	struct wid wid;
 
 	wid.id = WID_RSSI;
@@ -2084,7 +2084,7 @@ static void handle_get_inactive_time(struct work_struct *work)
 	struct host_if_msg *msg = container_of(work, struct host_if_msg, work);
 	struct wilc_vif *vif = msg->vif;
 	struct sta_inactive_t *hif_sta_inactive = &msg->body.mac_info;
-	s32 result;
+	int result;
 	struct wid wid;
 
 	wid.id = WID_SET_STA_MAC_INACTIVE_TIME;
@@ -2126,7 +2126,7 @@ static void handle_add_beacon(struct work_struct *work)
 	struct host_if_msg *msg = container_of(work, struct host_if_msg, work);
 	struct wilc_vif *vif = msg->vif;
 	struct beacon_attr *param = &msg->body.beacon_info;
-	s32 result;
+	int result;
 	struct wid wid;
 	u8 *cur_byte;
 
@@ -2181,7 +2181,7 @@ static void handle_del_beacon(struct work_struct *work)
 {
 	struct host_if_msg *msg = container_of(work, struct host_if_msg, work);
 	struct wilc_vif *vif = msg->vif;
-	s32 result;
+	int result;
 	struct wid wid;
 	u8 del_beacon = 0;
 
@@ -2232,7 +2232,7 @@ static void handle_add_station(struct work_struct *work)
 	struct host_if_msg *msg = container_of(work, struct host_if_msg, work);
 	struct wilc_vif *vif = msg->vif;
 	struct add_sta_param *param = &msg->body.add_sta_info;
-	s32 result;
+	int result;
 	struct wid wid;
 	u8 *cur_byte;
 
@@ -2263,7 +2263,7 @@ static void handle_del_all_sta(struct work_struct *work)
 	struct host_if_msg *msg = container_of(work, struct host_if_msg, work);
 	struct wilc_vif *vif = msg->vif;
 	struct del_all_sta *param = &msg->body.del_all_sta_info;
-	s32 result;
+	int result;
 	struct wid wid;
 	u8 *curr_byte;
 	u8 i;
@@ -2307,7 +2307,7 @@ static void handle_del_station(struct work_struct *work)
 	struct host_if_msg *msg = container_of(work, struct host_if_msg, work);
 	struct wilc_vif *vif = msg->vif;
 	struct del_sta *param = &msg->body.del_sta_info;
-	s32 result;
+	int result;
 	struct wid wid;
 
 	wid.id = WID_REMOVE_STA;
@@ -2335,7 +2335,7 @@ static void handle_edit_station(struct work_struct *work)
 	struct host_if_msg *msg = container_of(work, struct host_if_msg, work);
 	struct wilc_vif *vif = msg->vif;
 	struct add_sta_param *param = &msg->body.edit_sta_info;
-	s32 result;
+	int result;
 	struct wid wid;
 	u8 *cur_byte;
 
@@ -2364,7 +2364,7 @@ static void handle_edit_station(struct work_struct *work)
 static int handle_remain_on_chan(struct wilc_vif *vif,
 				 struct remain_ch *hif_remain_ch)
 {
-	s32 result;
+	int result;
 	u8 remain_on_chan_flag;
 	struct wid wid;
 	struct host_if_drv *hif_drv = vif->hif_drv;
@@ -2433,7 +2433,7 @@ static void handle_register_frame(struct work_struct *work)
 	struct host_if_msg *msg = container_of(work, struct host_if_msg, work);
 	struct wilc_vif *vif = msg->vif;
 	struct reg_frame *hif_reg_frame = &msg->body.reg_frame;
-	s32 result;
+	int result;
 	struct wid wid;
 	u8 *cur_byte;
 
@@ -2468,7 +2468,7 @@ static void handle_listen_state_expired(struct work_struct *work)
 	struct remain_ch *hif_remain_ch = &msg->body.remain_on_ch;
 	u8 remain_on_chan_flag;
 	struct wid wid;
-	s32 result;
+	int result;
 	struct host_if_drv *hif_drv = vif->hif_drv;
 
 	if (p2p_listen_state) {
@@ -2510,7 +2510,7 @@ static void listen_timer_cb(struct timer_list *t)
 	struct host_if_drv *hif_drv = from_timer(hif_drv, t,
 						      remain_on_ch_timer);
 	struct wilc_vif *vif = hif_drv->remain_on_ch_timer_vif;
-	s32 result;
+	int result;
 	struct host_if_msg *msg;
 
 	del_timer(&vif->hif_drv->remain_on_ch_timer);
@@ -2533,7 +2533,7 @@ static void handle_power_management(struct work_struct *work)
 	struct host_if_msg *msg = container_of(work, struct host_if_msg, work);
 	struct wilc_vif *vif = msg->vif;
 	struct power_mgmt_param *pm_param = &msg->body.pwr_mgmt_info;
-	s32 result;
+	int result;
 	struct wid wid;
 	s8 power_mode;
 
@@ -2559,7 +2559,7 @@ static void handle_set_mcast_filter(struct work_struct *work)
 	struct host_if_msg *msg = container_of(work, struct host_if_msg, work);
 	struct wilc_vif *vif = msg->vif;
 	struct set_multicast *hif_set_mc = &msg->body.multicast_info;
-	s32 result;
+	int result;
 	struct wid wid;
 	u8 *cur_byte;
 
@@ -3548,7 +3548,7 @@ int wilc_deinit(struct wilc_vif *vif)
 
 void wilc_network_info_received(struct wilc *wilc, u8 *buffer, u32 length)
 {
-	s32 result;
+	int result;
 	struct host_if_msg *msg;
 	int id;
 	struct host_if_drv *hif_drv;
@@ -3589,7 +3589,7 @@ void wilc_network_info_received(struct wilc *wilc, u8 *buffer, u32 length)
 
 void wilc_gnrl_async_info_received(struct wilc *wilc, u8 *buffer, u32 length)
 {
-	s32 result;
+	int result;
 	struct host_if_msg *msg;
 	int id;
 	struct host_if_drv *hif_drv;
@@ -3646,7 +3646,7 @@ void wilc_gnrl_async_info_received(struct wilc *wilc, u8 *buffer, u32 length)
 
 void wilc_scan_complete_received(struct wilc *wilc, u8 *buffer, u32 length)
 {
-	s32 result;
+	int result;
 	int id;
 	struct host_if_drv *hif_drv;
 	struct wilc_vif *vif;
diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
index e7e529f..ba6f9ed 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -615,7 +615,7 @@ static int scan(struct wiphy *wiphy, struct cfg80211_scan_request *request)
 {
 	struct wilc_priv *priv;
 	u32 i;
-	s32 ret = 0;
+	int ret = 0;
 	u8 scan_ch_list[MAX_NUM_SCANNED_NETWORKS];
 	struct hidden_network hidden_ntwk;
 	struct wilc_vif *vif;
@@ -669,7 +669,7 @@ static int scan(struct wiphy *wiphy, struct cfg80211_scan_request *request)
 static int connect(struct wiphy *wiphy, struct net_device *dev,
 		   struct cfg80211_connect_params *sme)
 {
-	s32 ret;
+	int ret;
 	u32 i;
 	u32 sel_bssi_idx = UINT_MAX;
 	u8 security = NO_ENCRYPT;
@@ -818,7 +818,7 @@ static int connect(struct wiphy *wiphy, struct net_device *dev,
 static int disconnect(struct wiphy *wiphy, struct net_device *dev,
 		      u16 reason_code)
 {
-	s32 ret;
+	int ret;
 	struct wilc_priv *priv;
 	struct host_if_drv *wfi_drv;
 	struct wilc_vif *vif;
@@ -914,7 +914,7 @@ static int add_key(struct wiphy *wiphy, struct net_device *netdev, u8 key_index,
 		   bool pairwise, const u8 *mac_addr, struct key_params *params)
 
 {
-	s32 ret = 0, keylen = params->key_len;
+	int ret = 0, keylen = params->key_len;
 	struct wilc_priv *priv;
 	const u8 *rx_mic = NULL;
 	const u8 *tx_mic = NULL;
@@ -1174,7 +1174,7 @@ static int change_bss(struct wiphy *wiphy, struct net_device *dev,
 
 static int set_wiphy_params(struct wiphy *wiphy, u32 changed)
 {
-	s32 ret;
+	int ret;
 	struct cfg_param_attr cfg_param_val;
 	struct wilc_priv *priv;
 	struct wilc_vif *vif;
@@ -1213,7 +1213,7 @@ static int set_pmksa(struct wiphy *wiphy, struct net_device *netdev,
 		     struct cfg80211_pmksa *pmksa)
 {
 	u32 i;
-	s32 ret = 0;
+	int ret = 0;
 	u8 flag = 0;
 	struct wilc_vif *vif;
 	struct wilc_priv *priv = wiphy_priv(wiphy);
@@ -1249,7 +1249,7 @@ static int del_pmksa(struct wiphy *wiphy, struct net_device *netdev,
 		     struct cfg80211_pmksa *pmksa)
 {
 	u32 i;
-	s32 ret = 0;
+	int ret = 0;
 	struct wilc_priv *priv = wiphy_priv(wiphy);
 
 	for (i = 0; i < priv->pmkid_list.numpmkid; i++)	{
@@ -1505,7 +1505,7 @@ static int remain_on_channel(struct wiphy *wiphy,
 			     struct ieee80211_channel *chan,
 			     unsigned int duration, u64 *cookie)
 {
-	s32 ret = 0;
+	int ret = 0;
 	struct wilc_priv *priv;
 	struct wilc_vif *vif;
 
@@ -1879,7 +1879,7 @@ static int start_ap(struct wiphy *wiphy, struct net_device *dev,
 		    struct cfg80211_ap_settings *settings)
 {
 	struct cfg80211_beacon_data *beacon = &settings->beacon;
-	s32 ret;
+	int ret;
 	struct wilc *wl;
 	struct wilc_vif *vif;
 
@@ -1916,7 +1916,7 @@ static int change_beacon(struct wiphy *wiphy, struct net_device *dev,
 
 static int stop_ap(struct wiphy *wiphy, struct net_device *dev)
 {
-	s32 ret;
+	int ret;
 	struct wilc_priv *priv;
 	struct wilc_vif *vif;
 	u8 null_bssid[ETH_ALEN] = {0};
@@ -1940,7 +1940,7 @@ static int stop_ap(struct wiphy *wiphy, struct net_device *dev)
 static int add_station(struct wiphy *wiphy, struct net_device *dev,
 		       const u8 *mac, struct station_parameters *params)
 {
-	s32 ret = 0;
+	int ret = 0;
 	struct wilc_priv *priv;
 	struct add_sta_param sta_params = { {0} };
 	struct wilc_vif *vif;
@@ -1981,7 +1981,7 @@ static int del_station(struct wiphy *wiphy, struct net_device *dev,
 		       struct station_del_parameters *params)
 {
 	const u8 *mac = params->mac;
-	s32 ret = 0;
+	int ret = 0;
 	struct wilc_priv *priv;
 	struct wilc_vif *vif;
 	struct sta_info *info;
@@ -2009,7 +2009,7 @@ static int del_station(struct wiphy *wiphy, struct net_device *dev,
 static int change_station(struct wiphy *wiphy, struct net_device *dev,
 			  const u8 *mac, struct station_parameters *params)
 {
-	s32 ret = 0;
+	int ret = 0;
 	struct add_sta_param sta_params = { {0} };
 	struct wilc_vif *vif;
 
@@ -2215,7 +2215,7 @@ struct wireless_dev *wilc_create_wiphy(struct net_device *net,
 {
 	struct wilc_priv *priv;
 	struct wireless_dev *wdev;
-	s32 ret;
+	int ret;
 
 	wdev = wilc_wfi_cfg_alloc();
 	if (!wdev) {
-- 
2.7.4

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa3.microchip.iphmx.com ([68.232.153.233]:3194 "EHLO
        esa3.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727416AbeGSGq5 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 19 Jul 2018 02:46:57 -0400
From: Ajay Singh <ajay.kathat@microchip.com>
To: <linux-wireless@vger.kernel.org>
CC: <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <ganesh.krishna@microchip.com>, <venkateswara.kaja@microchip.com>,
        <aditya.shankar@microchip.com>, <claudiu.beznea@microchip.com>,
        <adham.abozaeid@microchip.com>,
        Ajay Singh <ajay.kathat@microchip.com>
Subject: [PATCH 20/23] staging: wilc1000: avoid setting default value for variable at declaration
Date: Thu, 19 Jul 2018 04:15:16 +0530
Message-ID: <1531953919-20804-21-git-send-email-ajay.kathat@microchip.com> (sfid-20180719_080534_854802_99186DD1)
In-Reply-To: <1531953919-20804-1-git-send-email-ajay.kathat@microchip.com>
References: <1531953919-20804-1-git-send-email-ajay.kathat@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Cleanup patch to avoid setting default value for local variables and
also clubbed similar variables together.

Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
---
 drivers/staging/wilc1000/coreconfigurator.c       |  25 ++---
 drivers/staging/wilc1000/host_interface.c         | 122 +++++++++++-----------
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c |  20 ++--
 3 files changed, 79 insertions(+), 88 deletions(-)

diff --git a/drivers/staging/wilc1000/coreconfigurator.c b/drivers/staging/wilc1000/coreconfigurator.c
index 5933e4d..e09f10d 100644
--- a/drivers/staging/wilc1000/coreconfigurator.c
+++ b/drivers/staging/wilc1000/coreconfigurator.c
@@ -123,9 +123,7 @@ static inline void get_BSSID(u8 *data, u8 *bssid)
 
 static inline void get_ssid(u8 *data, u8 *ssid, u8 *p_ssid_len)
 {
-	u8 len = 0;
-	u8 i   = 0;
-	u8 j   = 0;
+	u8 i, j, len;
 
 	len = data[TAG_PARAM_OFFSET + 1];
 	j   = TAG_PARAM_OFFSET + 2;
@@ -198,18 +196,11 @@ static u8 get_current_channel_802_11n(u8 *msa, u16 rx_len)
 s32 wilc_parse_network_info(u8 *msg_buffer,
 			    struct network_info **ret_network_info)
 {
-	struct network_info *network_info = NULL;
-	u8 msg_type = 0;
-	u16 wid_len  = 0;
-	u8 *wid_val = NULL;
-	u8 *msa = NULL;
-	u16 rx_len = 0;
-	u8 *tim_elm = NULL;
-	u8 *ies = NULL;
-	u16 ies_len = 0;
-	u8 index = 0;
-	u32 tsf_lo;
-	u32 tsf_hi;
+	struct network_info *network_info;
+	u8 *wid_val, *msa, *tim_elm, *ies;
+	u32 tsf_lo, tsf_hi;
+	u16 wid_len, rx_len, ies_len;
+	u8 msg_type, index;
 
 	msg_type = msg_buffer[0];
 
@@ -271,8 +262,8 @@ s32 wilc_parse_network_info(u8 *msg_buffer,
 s32 wilc_parse_assoc_resp_info(u8 *buffer, u32 buffer_len,
 			       struct connect_info *ret_conn_info)
 {
-	u8 *ies = NULL;
-	u16 ies_len = 0;
+	u8 *ies;
+	u16 ies_len;
 
 	ret_conn_info->status = get_asoc_status(buffer);
 	if (ret_conn_info->status == WLAN_STATUS_SUCCESS) {
diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 895a126..d251a64 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -259,7 +259,7 @@ static void handle_set_channel(struct work_struct *work)
 	struct host_if_msg *msg = container_of(work, struct host_if_msg, work);
 	struct wilc_vif *vif = msg->vif;
 	struct channel_attr *hif_set_ch = &msg->body.channel_info;
-	int ret = 0;
+	int ret;
 	struct wid wid;
 
 	wid.id = WID_CURRENT_CHANNEL;
@@ -280,10 +280,10 @@ static void handle_set_wfi_drv_handler(struct work_struct *work)
 	struct host_if_msg *msg = container_of(work, struct host_if_msg, work);
 	struct wilc_vif *vif = msg->vif;
 	struct drv_handler *hif_drv_handler = &msg->body.drv;
-	int ret = 0;
+	int ret;
 	struct wid wid;
 	u8 *currbyte, *buffer;
-	struct host_if_drv *hif_drv = NULL;
+	struct host_if_drv *hif_drv;
 
 	if (!vif->hif_drv || !hif_drv_handler)
 		goto free_msg;
@@ -327,7 +327,7 @@ static void handle_set_operation_mode(struct work_struct *work)
 	struct host_if_msg *msg = container_of(work, struct host_if_msg, work);
 	struct wilc_vif *vif = msg->vif;
 	struct op_mode *hif_op_mode = &msg->body.mode;
-	int ret = 0;
+	int ret;
 	struct wid wid;
 
 	wid.id = WID_SET_OPERATION_MODE;
@@ -352,7 +352,7 @@ static void handle_set_ip_address(struct work_struct *work)
 	struct wilc_vif *vif = msg->vif;
 	u8 *ip_addr = msg->body.ip_info.ip_addr;
 	u8 idx = msg->body.ip_info.idx;
-	int ret = 0;
+	int ret;
 	struct wid wid;
 	char firmware_ip_addr[4] = {0};
 
@@ -381,7 +381,7 @@ static void handle_get_ip_address(struct work_struct *work)
 	struct host_if_msg *msg = container_of(work, struct host_if_msg, work);
 	struct wilc_vif *vif = msg->vif;
 	u8 idx = msg->body.ip_info.idx;
-	int ret = 0;
+	int ret;
 	struct wid wid;
 
 	wid.id = WID_IP_ADDRESS;
@@ -409,7 +409,7 @@ static void handle_get_mac_address(struct work_struct *work)
 	struct host_if_msg *msg = container_of(work, struct host_if_msg, work);
 	struct wilc_vif *vif = msg->vif;
 	struct get_mac_addr *get_mac_addr = &msg->body.get_mac_info;
-	int ret = 0;
+	int ret;
 	struct wid wid;
 
 	wid.id = WID_MAC_ADDR;
@@ -431,7 +431,7 @@ static void handle_cfg_param(struct work_struct *work)
 	struct host_if_msg *msg = container_of(work, struct host_if_msg, work);
 	struct wilc_vif *vif = msg->vif;
 	struct cfg_param_attr *param = &msg->body.cfg_info;
-	int ret = 0;
+	int ret;
 	struct wid wid_list[32];
 	struct host_if_drv *hif_drv = vif->hif_drv;
 	int i = 0;
@@ -1148,7 +1148,7 @@ static void handle_connect_timeout(struct work_struct *work)
 {
 	struct host_if_msg *msg = container_of(work, struct host_if_msg, work);
 	struct wilc_vif *vif = msg->vif;
-	s32 result = 0;
+	s32 result;
 	struct connect_info info;
 	struct wid wid;
 	u16 dummy_reason_code = 0;
@@ -1389,7 +1389,7 @@ static void handle_rcvd_ntwrk_info(struct work_struct *work)
 	u32 i;
 	bool found;
 	struct network_info *info = NULL;
-	void *params = NULL;
+	void *params;
 	struct host_if_drv *hif_drv = vif->hif_drv;
 	struct user_scan_req *scan_req = &hif_drv->usr_scan_req;
 
@@ -1608,7 +1608,7 @@ static void handle_rcvd_gnrl_async_info(struct work_struct *work)
 	struct host_if_msg *msg = container_of(work, struct host_if_msg, work);
 	struct wilc_vif *vif = msg->vif;
 	struct rcvd_async_info *rcvd_info = &msg->body.async_info;
-	u8 msg_type = 0;
+	u8 msg_type;
 	u8 mac_status;
 	struct host_if_drv *hif_drv = vif->hif_drv;
 
@@ -1926,7 +1926,7 @@ static void handle_disconnect(struct work_struct *work)
 	struct disconnect_info disconn_info;
 	struct user_scan_req *scan_req;
 	struct user_conn_req *conn_req;
-	s32 result = 0;
+	s32 result;
 	u16 dummy_reason_code = 0;
 
 	wid.id = WID_DISCONNECT;
@@ -2004,7 +2004,7 @@ static void handle_get_rssi(struct work_struct *work)
 {
 	struct host_if_msg *msg = container_of(work, struct host_if_msg, work);
 	struct wilc_vif *vif = msg->vif;
-	s32 result = 0;
+	s32 result;
 	struct wid wid;
 
 	wid.id = WID_RSSI;
@@ -2026,7 +2026,7 @@ static void handle_get_statistics(struct work_struct *work)
 	struct host_if_msg *msg = container_of(work, struct host_if_msg, work);
 	struct wilc_vif *vif = msg->vif;
 	struct wid wid_list[5];
-	u32 wid_cnt = 0, result = 0;
+	u32 wid_cnt = 0, result;
 	struct rf_info *stats = (struct rf_info *)msg->body.data;
 
 	wid_list[wid_cnt].id = WID_LINKSPEED;
@@ -2084,7 +2084,7 @@ static void handle_get_inactive_time(struct work_struct *work)
 	struct host_if_msg *msg = container_of(work, struct host_if_msg, work);
 	struct wilc_vif *vif = msg->vif;
 	struct sta_inactive_t *hif_sta_inactive = &msg->body.mac_info;
-	s32 result = 0;
+	s32 result;
 	struct wid wid;
 
 	wid.id = WID_SET_STA_MAC_INACTIVE_TIME;
@@ -2126,7 +2126,7 @@ static void handle_add_beacon(struct work_struct *work)
 	struct host_if_msg *msg = container_of(work, struct host_if_msg, work);
 	struct wilc_vif *vif = msg->vif;
 	struct beacon_attr *param = &msg->body.beacon_info;
-	s32 result = 0;
+	s32 result;
 	struct wid wid;
 	u8 *cur_byte;
 
@@ -2181,7 +2181,7 @@ static void handle_del_beacon(struct work_struct *work)
 {
 	struct host_if_msg *msg = container_of(work, struct host_if_msg, work);
 	struct wilc_vif *vif = msg->vif;
-	s32 result = 0;
+	s32 result;
 	struct wid wid;
 	u8 del_beacon = 0;
 
@@ -2232,7 +2232,7 @@ static void handle_add_station(struct work_struct *work)
 	struct host_if_msg *msg = container_of(work, struct host_if_msg, work);
 	struct wilc_vif *vif = msg->vif;
 	struct add_sta_param *param = &msg->body.add_sta_info;
-	s32 result = 0;
+	s32 result;
 	struct wid wid;
 	u8 *cur_byte;
 
@@ -2263,7 +2263,7 @@ static void handle_del_all_sta(struct work_struct *work)
 	struct host_if_msg *msg = container_of(work, struct host_if_msg, work);
 	struct wilc_vif *vif = msg->vif;
 	struct del_all_sta *param = &msg->body.del_all_sta_info;
-	s32 result = 0;
+	s32 result;
 	struct wid wid;
 	u8 *curr_byte;
 	u8 i;
@@ -2307,7 +2307,7 @@ static void handle_del_station(struct work_struct *work)
 	struct host_if_msg *msg = container_of(work, struct host_if_msg, work);
 	struct wilc_vif *vif = msg->vif;
 	struct del_sta *param = &msg->body.del_sta_info;
-	s32 result = 0;
+	s32 result;
 	struct wid wid;
 
 	wid.id = WID_REMOVE_STA;
@@ -2335,7 +2335,7 @@ static void handle_edit_station(struct work_struct *work)
 	struct host_if_msg *msg = container_of(work, struct host_if_msg, work);
 	struct wilc_vif *vif = msg->vif;
 	struct add_sta_param *param = &msg->body.edit_sta_info;
-	s32 result = 0;
+	s32 result;
 	struct wid wid;
 	u8 *cur_byte;
 
@@ -2364,7 +2364,7 @@ static void handle_edit_station(struct work_struct *work)
 static int handle_remain_on_chan(struct wilc_vif *vif,
 				 struct remain_ch *hif_remain_ch)
 {
-	s32 result = 0;
+	s32 result;
 	u8 remain_on_chan_flag;
 	struct wid wid;
 	struct host_if_drv *hif_drv = vif->hif_drv;
@@ -2433,7 +2433,7 @@ static void handle_register_frame(struct work_struct *work)
 	struct host_if_msg *msg = container_of(work, struct host_if_msg, work);
 	struct wilc_vif *vif = msg->vif;
 	struct reg_frame *hif_reg_frame = &msg->body.reg_frame;
-	s32 result = 0;
+	s32 result;
 	struct wid wid;
 	u8 *cur_byte;
 
@@ -2468,7 +2468,7 @@ static void handle_listen_state_expired(struct work_struct *work)
 	struct remain_ch *hif_remain_ch = &msg->body.remain_on_ch;
 	u8 remain_on_chan_flag;
 	struct wid wid;
-	s32 result = 0;
+	s32 result;
 	struct host_if_drv *hif_drv = vif->hif_drv;
 
 	if (p2p_listen_state) {
@@ -2510,7 +2510,7 @@ static void listen_timer_cb(struct timer_list *t)
 	struct host_if_drv *hif_drv = from_timer(hif_drv, t,
 						      remain_on_ch_timer);
 	struct wilc_vif *vif = hif_drv->remain_on_ch_timer_vif;
-	s32 result = 0;
+	s32 result;
 	struct host_if_msg *msg;
 
 	del_timer(&vif->hif_drv->remain_on_ch_timer);
@@ -2533,7 +2533,7 @@ static void handle_power_management(struct work_struct *work)
 	struct host_if_msg *msg = container_of(work, struct host_if_msg, work);
 	struct wilc_vif *vif = msg->vif;
 	struct power_mgmt_param *pm_param = &msg->body.pwr_mgmt_info;
-	s32 result = 0;
+	s32 result;
 	struct wid wid;
 	s8 power_mode;
 
@@ -2559,7 +2559,7 @@ static void handle_set_mcast_filter(struct work_struct *work)
 	struct host_if_msg *msg = container_of(work, struct host_if_msg, work);
 	struct wilc_vif *vif = msg->vif;
 	struct set_multicast *hif_set_mc = &msg->body.multicast_info;
-	s32 result = 0;
+	s32 result;
 	struct wid wid;
 	u8 *cur_byte;
 
@@ -2621,7 +2621,7 @@ static void handle_get_tx_pwr(struct work_struct *work)
 	struct host_if_msg *msg = container_of(work, struct host_if_msg, work);
 	struct wilc_vif *vif = msg->vif;
 	u8 *tx_pwr = &msg->body.tx_power.tx_pwr;
-	int ret = 0;
+	int ret;
 	struct wid wid;
 
 	wid.id = WID_TX_POWER;
@@ -2713,7 +2713,7 @@ static void timer_connect_cb(struct timer_list *t)
 
 int wilc_remove_wep_key(struct wilc_vif *vif, u8 index)
 {
-	int result = 0;
+	int result;
 	struct host_if_msg *msg;
 	struct host_if_drv *hif_drv = vif->hif_drv;
 
@@ -2743,7 +2743,7 @@ int wilc_remove_wep_key(struct wilc_vif *vif, u8 index)
 
 int wilc_set_wep_default_keyid(struct wilc_vif *vif, u8 index)
 {
-	int result = 0;
+	int result;
 	struct host_if_msg *msg;
 	struct host_if_drv *hif_drv = vif->hif_drv;
 
@@ -3005,7 +3005,7 @@ int wilc_add_rx_gtk(struct wilc_vif *vif, const u8 *rx_gtk, u8 gtk_key_len,
 int wilc_set_pmkid_info(struct wilc_vif *vif,
 			struct host_if_pmkid_attr *pmkid)
 {
-	int result = 0;
+	int result;
 	struct host_if_msg *msg;
 	int i;
 
@@ -3034,7 +3034,7 @@ int wilc_set_pmkid_info(struct wilc_vif *vif,
 
 int wilc_get_mac_address(struct wilc_vif *vif, u8 *mac_addr)
 {
-	int result = 0;
+	int result;
 	struct host_if_msg *msg;
 
 	msg = wilc_alloc_work(vif, handle_get_mac_address, true);
@@ -3060,7 +3060,7 @@ int wilc_set_join_req(struct wilc_vif *vif, u8 *bssid, const u8 *ssid,
 		      u8 security, enum authtype auth_type,
 		      u8 channel, void *join_params)
 {
-	int result = 0;
+	int result;
 	struct host_if_msg *msg;
 	struct host_if_drv *hif_drv = vif->hif_drv;
 
@@ -3141,7 +3141,7 @@ int wilc_set_join_req(struct wilc_vif *vif, u8 *bssid, const u8 *ssid,
 
 int wilc_disconnect(struct wilc_vif *vif, u16 reason_code)
 {
-	int result = 0;
+	int result;
 	struct host_if_msg *msg;
 	struct host_if_drv *hif_drv = vif->hif_drv;
 
@@ -3187,7 +3187,7 @@ int wilc_set_mac_chnl_num(struct wilc_vif *vif, u8 channel)
 int wilc_set_wfi_drv_handler(struct wilc_vif *vif, int index, u8 mode,
 			     u8 ifc_id)
 {
-	int result = 0;
+	int result;
 	struct host_if_msg *msg;
 
 	msg = wilc_alloc_work(vif, handle_set_wfi_drv_handler, false);
@@ -3209,7 +3209,7 @@ int wilc_set_wfi_drv_handler(struct wilc_vif *vif, int index, u8 mode,
 
 int wilc_set_operation_mode(struct wilc_vif *vif, u32 mode)
 {
-	int result = 0;
+	int result;
 	struct host_if_msg *msg;
 
 	msg  = wilc_alloc_work(vif, handle_set_operation_mode, false);
@@ -3229,7 +3229,7 @@ int wilc_set_operation_mode(struct wilc_vif *vif, u32 mode)
 s32 wilc_get_inactive_time(struct wilc_vif *vif, const u8 *mac,
 			   u32 *out_val)
 {
-	s32 result = 0;
+	s32 result;
 	struct host_if_msg *msg;
 	struct host_if_drv *hif_drv = vif->hif_drv;
 
@@ -3258,7 +3258,7 @@ s32 wilc_get_inactive_time(struct wilc_vif *vif, const u8 *mac,
 
 int wilc_get_rssi(struct wilc_vif *vif, s8 *rssi_level)
 {
-	int result = 0;
+	int result;
 	struct host_if_msg *msg;
 
 	if (!rssi_level) {
@@ -3293,7 +3293,7 @@ int wilc_get_rssi(struct wilc_vif *vif, s8 *rssi_level)
 int
 wilc_get_statistics(struct wilc_vif *vif, struct rf_info *stats, bool is_sync)
 {
-	int result = 0;
+	int result;
 	struct host_if_msg *msg;
 
 	msg = wilc_alloc_work(vif, handle_get_statistics, is_sync);
@@ -3322,7 +3322,7 @@ int wilc_scan(struct wilc_vif *vif, u8 scan_source, u8 scan_type,
 	      size_t ies_len, wilc_scan_result scan_result, void *user_arg,
 	      struct hidden_network *hidden_network)
 {
-	int result = 0;
+	int result;
 	struct host_if_msg *msg;
 	struct scan_attr *scan_info;
 	struct host_if_drv *hif_drv = vif->hif_drv;
@@ -3548,10 +3548,10 @@ int wilc_deinit(struct wilc_vif *vif)
 
 void wilc_network_info_received(struct wilc *wilc, u8 *buffer, u32 length)
 {
-	s32 result = 0;
+	s32 result;
 	struct host_if_msg *msg;
 	int id;
-	struct host_if_drv *hif_drv = NULL;
+	struct host_if_drv *hif_drv;
 	struct wilc_vif *vif;
 
 	id = buffer[length - 4];
@@ -3589,10 +3589,10 @@ void wilc_network_info_received(struct wilc *wilc, u8 *buffer, u32 length)
 
 void wilc_gnrl_async_info_received(struct wilc *wilc, u8 *buffer, u32 length)
 {
-	s32 result = 0;
+	s32 result;
 	struct host_if_msg *msg;
 	int id;
-	struct host_if_drv *hif_drv = NULL;
+	struct host_if_drv *hif_drv;
 	struct wilc_vif *vif;
 
 	mutex_lock(&hif_deinit_lock);
@@ -3646,9 +3646,9 @@ void wilc_gnrl_async_info_received(struct wilc *wilc, u8 *buffer, u32 length)
 
 void wilc_scan_complete_received(struct wilc *wilc, u8 *buffer, u32 length)
 {
-	s32 result = 0;
+	s32 result;
 	int id;
-	struct host_if_drv *hif_drv = NULL;
+	struct host_if_drv *hif_drv;
 	struct wilc_vif *vif;
 
 	id = buffer[length - 4];
@@ -3684,7 +3684,7 @@ int wilc_remain_on_channel(struct wilc_vif *vif, u32 session_id,
 			   wilc_remain_on_chan_ready ready,
 			   void *user_arg)
 {
-	int result = 0;
+	int result;
 	struct host_if_msg *msg;
 
 	msg = wilc_alloc_work(vif, handle_remain_on_chan_work, false);
@@ -3709,7 +3709,7 @@ int wilc_remain_on_channel(struct wilc_vif *vif, u32 session_id,
 
 int wilc_listen_state_expired(struct wilc_vif *vif, u32 session_id)
 {
-	int result = 0;
+	int result;
 	struct host_if_msg *msg;
 	struct host_if_drv *hif_drv = vif->hif_drv;
 
@@ -3737,7 +3737,7 @@ int wilc_listen_state_expired(struct wilc_vif *vif, u32 session_id)
 
 int wilc_frame_register(struct wilc_vif *vif, u16 frame_type, bool reg)
 {
-	int result = 0;
+	int result;
 	struct host_if_msg *msg;
 
 	msg = wilc_alloc_work(vif, handle_register_frame, false);
@@ -3771,7 +3771,7 @@ int wilc_frame_register(struct wilc_vif *vif, u16 frame_type, bool reg)
 int wilc_add_beacon(struct wilc_vif *vif, u32 interval, u32 dtim_period,
 		    u32 head_len, u8 *head, u32 tail_len, u8 *tail)
 {
-	int result = 0;
+	int result;
 	struct host_if_msg *msg;
 	struct beacon_attr *beacon_info;
 
@@ -3816,7 +3816,7 @@ int wilc_add_beacon(struct wilc_vif *vif, u32 interval, u32 dtim_period,
 
 int wilc_del_beacon(struct wilc_vif *vif)
 {
-	int result = 0;
+	int result;
 	struct host_if_msg *msg;
 
 	msg = wilc_alloc_work(vif, handle_del_beacon, false);
@@ -3834,7 +3834,7 @@ int wilc_del_beacon(struct wilc_vif *vif)
 
 int wilc_add_station(struct wilc_vif *vif, struct add_sta_param *sta_param)
 {
-	int result = 0;
+	int result;
 	struct host_if_msg *msg;
 	struct add_sta_param *add_sta_info;
 
@@ -3865,7 +3865,7 @@ int wilc_add_station(struct wilc_vif *vif, struct add_sta_param *sta_param)
 
 int wilc_del_station(struct wilc_vif *vif, const u8 *mac_addr)
 {
-	int result = 0;
+	int result;
 	struct host_if_msg *msg;
 	struct del_sta *del_sta_info;
 
@@ -3890,7 +3890,7 @@ int wilc_del_station(struct wilc_vif *vif, const u8 *mac_addr)
 
 int wilc_del_allstation(struct wilc_vif *vif, u8 mac_addr[][ETH_ALEN])
 {
-	int result = 0;
+	int result;
 	struct host_if_msg *msg;
 	struct del_all_sta *del_all_sta_info;
 	u8 zero_addr[ETH_ALEN] = {0};
@@ -3931,7 +3931,7 @@ int wilc_del_allstation(struct wilc_vif *vif, u8 mac_addr[][ETH_ALEN])
 int wilc_edit_station(struct wilc_vif *vif,
 		      struct add_sta_param *sta_param)
 {
-	int result = 0;
+	int result;
 	struct host_if_msg *msg;
 	struct add_sta_param *add_sta_info;
 
@@ -3963,7 +3963,7 @@ int wilc_edit_station(struct wilc_vif *vif,
 
 int wilc_set_power_mgmt(struct wilc_vif *vif, bool enabled, u32 timeout)
 {
-	int result = 0;
+	int result;
 	struct host_if_msg *msg;
 
 	if (wilc_wlan_get_num_conn_ifcs(vif->wilc) == 2 && enabled)
@@ -3987,7 +3987,7 @@ int wilc_set_power_mgmt(struct wilc_vif *vif, bool enabled, u32 timeout)
 int wilc_setup_multicast_filter(struct wilc_vif *vif, bool enabled,
 				u32 count)
 {
-	int result = 0;
+	int result;
 	struct host_if_msg *msg;
 
 	msg = wilc_alloc_work(vif, handle_set_mcast_filter, false);
@@ -4007,7 +4007,7 @@ int wilc_setup_multicast_filter(struct wilc_vif *vif, bool enabled,
 
 int wilc_setup_ipaddress(struct wilc_vif *vif, u8 *ip_addr, u8 idx)
 {
-	int result = 0;
+	int result;
 	struct host_if_msg *msg;
 
 	msg = wilc_alloc_work(vif, handle_set_ip_address, false);
@@ -4028,7 +4028,7 @@ int wilc_setup_ipaddress(struct wilc_vif *vif, u8 *ip_addr, u8 idx)
 
 static int host_int_get_ipaddress(struct wilc_vif *vif, u8 *ip_addr, u8 idx)
 {
-	int result = 0;
+	int result;
 	struct host_if_msg *msg;
 
 	msg = wilc_alloc_work(vif, handle_get_ip_address, false);
@@ -4049,7 +4049,7 @@ static int host_int_get_ipaddress(struct wilc_vif *vif, u8 *ip_addr, u8 idx)
 
 int wilc_set_tx_power(struct wilc_vif *vif, u8 tx_power)
 {
-	int ret = 0;
+	int ret;
 	struct host_if_msg *msg;
 
 	msg = wilc_alloc_work(vif, handle_set_tx_pwr, false);
@@ -4069,7 +4069,7 @@ int wilc_set_tx_power(struct wilc_vif *vif, u8 tx_power)
 
 int wilc_get_tx_power(struct wilc_vif *vif, u8 *tx_power)
 {
-	int ret = 0;
+	int ret;
 	struct host_if_msg *msg;
 
 	msg = wilc_alloc_work(vif, handle_get_tx_pwr, true);
diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
index 96aaf14..e7e529f 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -669,7 +669,7 @@ static int scan(struct wiphy *wiphy, struct cfg80211_scan_request *request)
 static int connect(struct wiphy *wiphy, struct net_device *dev,
 		   struct cfg80211_connect_params *sme)
 {
-	s32 ret = 0;
+	s32 ret;
 	u32 i;
 	u32 sel_bssi_idx = UINT_MAX;
 	u8 security = NO_ENCRYPT;
@@ -677,7 +677,7 @@ static int connect(struct wiphy *wiphy, struct net_device *dev,
 	u32 cipher_group;
 	struct wilc_priv *priv;
 	struct host_if_drv *wfi_drv;
-	struct network_info *nw_info = NULL;
+	struct network_info *nw_info;
 	struct wilc_vif *vif;
 
 	wilc_connecting = 1;
@@ -818,7 +818,7 @@ static int connect(struct wiphy *wiphy, struct net_device *dev,
 static int disconnect(struct wiphy *wiphy, struct net_device *dev,
 		      u16 reason_code)
 {
-	s32 ret = 0;
+	s32 ret;
 	struct wilc_priv *priv;
 	struct host_if_drv *wfi_drv;
 	struct wilc_vif *vif;
@@ -1174,7 +1174,7 @@ static int change_bss(struct wiphy *wiphy, struct net_device *dev,
 
 static int set_wiphy_params(struct wiphy *wiphy, u32 changed)
 {
-	s32 ret = 0;
+	s32 ret;
 	struct cfg_param_attr cfg_param_val;
 	struct wilc_priv *priv;
 	struct wilc_vif *vif;
@@ -1879,7 +1879,7 @@ static int start_ap(struct wiphy *wiphy, struct net_device *dev,
 		    struct cfg80211_ap_settings *settings)
 {
 	struct cfg80211_beacon_data *beacon = &settings->beacon;
-	s32 ret = 0;
+	s32 ret;
 	struct wilc *wl;
 	struct wilc_vif *vif;
 
@@ -1916,7 +1916,7 @@ static int change_beacon(struct wiphy *wiphy, struct net_device *dev,
 
 static int stop_ap(struct wiphy *wiphy, struct net_device *dev)
 {
-	s32 ret = 0;
+	s32 ret;
 	struct wilc_priv *priv;
 	struct wilc_vif *vif;
 	u8 null_bssid[ETH_ALEN] = {0};
@@ -2049,7 +2049,7 @@ static struct wireless_dev *add_virtual_intf(struct wiphy *wiphy,
 {
 	struct wilc_vif *vif;
 	struct wilc_priv *priv;
-	struct net_device *new_ifc = NULL;
+	struct net_device *new_ifc;
 
 	priv = wiphy_priv(wiphy);
 	vif = netdev_priv(priv->wdev->netdev);
@@ -2215,7 +2215,7 @@ struct wireless_dev *wilc_create_wiphy(struct net_device *net,
 {
 	struct wilc_priv *priv;
 	struct wireless_dev *wdev;
-	s32 ret = 0;
+	s32 ret;
 
 	wdev = wilc_wfi_cfg_alloc();
 	if (!wdev) {
@@ -2257,7 +2257,7 @@ struct wireless_dev *wilc_create_wiphy(struct net_device *net,
 
 int wilc_init_host_int(struct net_device *net)
 {
-	int ret = 0;
+	int ret;
 	struct wilc_priv *priv;
 
 	priv = wdev_priv(net->ieee80211_ptr);
@@ -2279,7 +2279,7 @@ int wilc_init_host_int(struct net_device *net)
 
 int wilc_deinit_host_int(struct net_device *net)
 {
-	int ret = 0;
+	int ret;
 	struct wilc_vif *vif;
 	struct wilc_priv *priv;
 
-- 
2.7.4

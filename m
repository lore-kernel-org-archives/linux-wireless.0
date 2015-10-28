Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.243]:41545 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755152AbbJ1G6B (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Oct 2015 02:58:01 -0400
From: Glen Lee <glen.lee@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <adel.noureldin@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH 04/80] staging: wilc1000: fixes missing a blank line after declarations
Date: Wed, 28 Oct 2015 15:59:24 +0900
Message-ID: <1446015640-29398-4-git-send-email-glen.lee@atmel.com> (sfid-20151028_075805_558558_EEF7AC7A)
In-Reply-To: <1446015640-29398-1-git-send-email-glen.lee@atmel.com>
References: <1446015640-29398-1-git-send-email-glen.lee@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Leo Kim <leo.kim@atmel.com>

This patch fixes the warnings reported by checkpatch.pl
for Missing a blank line after declarations.

Signed-off-by: Leo Kim <leo.kim@atmel.com>
Signed-off-by: Glen Lee <glen.lee@atmel.com>
---
 drivers/staging/wilc1000/host_interface.c | 16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 74f1f9d..15278f7 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -471,6 +471,7 @@ static s32 Handle_SetMacAddress(struct host_if_drv *hif_drv,
 	s32 result = 0;
 	struct wid strWID;
 	u8 *mac_buf = kmalloc(ETH_ALEN, GFP_KERNEL);
+
 	if (!mac_buf) {
 		PRINT_ER("No buffer to send mac address\n");
 		return -EFAULT;
@@ -770,6 +771,7 @@ static s32 Handle_CfgParam(struct host_if_drv *hif_drv,
 	}
 	if (strHostIFCfgParamAttr->cfg_attr_info.flag & CURRENT_TX_RATE) {
 		enum CURRENT_TXRATE curr_tx_rate = strHostIFCfgParamAttr->cfg_attr_info.curr_tx_rate;
+
 		if (curr_tx_rate == AUTORATE || curr_tx_rate == MBPS_1
 		    || curr_tx_rate == MBPS_2 || curr_tx_rate == MBPS_5_5
 		    || curr_tx_rate == MBPS_11 || curr_tx_rate == MBPS_6
@@ -3688,8 +3690,8 @@ int host_int_set_mac_chnl_num(struct host_if_drv *hif_drv, u8 channel)
 int host_int_wait_msg_queue_idle(void)
 {
 	int result = 0;
-
 	struct host_if_msg msg;
+
 	memset(&msg, 0, sizeof(struct host_if_msg));
 	msg.id = HOST_IF_MSG_Q_IDLE;
 	result = wilc_mq_send(&hif_msg_q, &msg, sizeof(struct host_if_msg));
@@ -3706,8 +3708,8 @@ int host_int_wait_msg_queue_idle(void)
 int host_int_set_wfi_drv_handler(struct host_if_drv *hif_drv)
 {
 	int result = 0;
-
 	struct host_if_msg msg;
+
 	memset(&msg, 0, sizeof(struct host_if_msg));
 	msg.id = HOST_IF_MSG_SET_WFIDRV_HANDLER;
 	msg.body.drv.u32Address = get_id_from_handler(hif_drv);
@@ -3725,8 +3727,8 @@ int host_int_set_wfi_drv_handler(struct host_if_drv *hif_drv)
 int host_int_set_operation_mode(struct host_if_drv *hif_drv, u32 mode)
 {
 	int result = 0;
-
 	struct host_if_msg msg;
+
 	memset(&msg, 0, sizeof(struct host_if_msg));
 	msg.id = HOST_IF_MSG_SET_OPERATION_MODE;
 	msg.body.mode.u32Mode = mode;
@@ -3826,8 +3828,8 @@ s32 host_int_get_rssi(struct host_if_drv *hif_drv, s8 *ps8Rssi)
 {
 	s32 result = 0;
 	struct host_if_msg msg;
-	memset(&msg, 0, sizeof(struct host_if_msg));
 
+	memset(&msg, 0, sizeof(struct host_if_msg));
 	msg.id = HOST_IF_MSG_GET_RSSI;
 	msg.drv = hif_drv;
 
@@ -3853,8 +3855,8 @@ s32 host_int_get_link_speed(struct host_if_drv *hif_drv, s8 *ps8lnkspd)
 {
 	struct host_if_msg msg;
 	s32 result = 0;
-	memset(&msg, 0, sizeof(struct host_if_msg));
 
+	memset(&msg, 0, sizeof(struct host_if_msg));
 	msg.id = HOST_IF_MSG_GET_LINKSPEED;
 	msg.drv = hif_drv;
 
@@ -3880,8 +3882,8 @@ s32 host_int_get_statistics(struct host_if_drv *hif_drv, struct rf_info *pstrSta
 {
 	s32 result = 0;
 	struct host_if_msg msg;
-	memset(&msg, 0, sizeof(struct host_if_msg));
 
+	memset(&msg, 0, sizeof(struct host_if_msg));
 	msg.id = HOST_IF_MSG_GET_STATISTICS;
 	msg.body.data = (char *)pstrStatistics;
 	msg.drv = hif_drv;
@@ -4584,6 +4586,7 @@ s32 host_int_add_station(struct host_if_drv *hif_drv,
 	memcpy(pstrAddStationMsg, pstrStaParams, sizeof(struct add_sta_param));
 	if (pstrAddStationMsg->u8NumRates > 0) {
 		u8 *rates = kmalloc(pstrAddStationMsg->u8NumRates, GFP_KERNEL);
+
 		if (!rates)
 			return -ENOMEM;
 
@@ -4700,6 +4703,7 @@ s32 host_int_edit_station(struct host_if_drv *hif_drv,
 	memcpy(pstrAddStationMsg, pstrStaParams, sizeof(struct add_sta_param));
 	if (pstrAddStationMsg->u8NumRates > 0) {
 		u8 *rates = kmalloc(pstrAddStationMsg->u8NumRates, GFP_KERNEL);
+
 		if (!rates)
 			return -ENOMEM;
 
-- 
1.9.1


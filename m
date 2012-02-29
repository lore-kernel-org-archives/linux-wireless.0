Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh06.mail.saunalahti.fi ([62.142.5.116]:44803 "EHLO
	emh06.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758184Ab2B2RUJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Feb 2012 12:20:09 -0500
Subject: [PATCH 11/12] ath6kl: fix too long lines
To: kvalo@qca.qualcomm.com
From: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: ath6kl-devel@qualcomm.com, linux-wireless@vger.kernel.org
Date: Wed, 29 Feb 2012 19:20:03 +0200
Message-ID: <20120229172003.24264.9451.stgit@localhost6.localdomain6> (sfid-20120229_182025_016232_4D4A30EA)
In-Reply-To: <20120229171525.24264.22062.stgit@localhost6.localdomain6>
References: <20120229171525.24264.22062.stgit@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Found by checkpatch:

drivers/net/wireless/ath/ath6kl/init.c:78: WARNING: line over 80 characters
drivers/net/wireless/ath/ath6kl/init.c:397: WARNING: line over 80 characters
drivers/net/wireless/ath/ath6kl/init.c:407: WARNING: line over 80 characters
drivers/net/wireless/ath/ath6kl/htc.c:189: WARNING: line over 80 characters
drivers/net/wireless/ath/ath6kl/htc.c:704: WARNING: line over 80 characters
drivers/net/wireless/ath/ath6kl/htc.c:2452: WARNING: line over 80 characters

Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/htc.c  |   43 ++++++++++++++++----------------
 drivers/net/wireless/ath/ath6kl/init.c |    6 ++--
 drivers/net/wireless/ath/ath6kl/wmi.h  |    4 +--
 3 files changed, 27 insertions(+), 26 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/htc.c b/drivers/net/wireless/ath/ath6kl/htc.c
index 24cfc3b..4849d99 100644
--- a/drivers/net/wireless/ath/ath6kl/htc.c
+++ b/drivers/net/wireless/ath/ath6kl/htc.c
@@ -172,31 +172,29 @@ static void ath6kl_credit_reduce(struct ath6kl_htc_credit_info *cred_info,
 static void ath6kl_credit_update(struct ath6kl_htc_credit_info *cred_info,
 				 struct list_head *epdist_list)
 {
-	struct htc_endpoint_credit_dist *cur_dist_list;
+	struct htc_endpoint_credit_dist *cur_list;
 
-	list_for_each_entry(cur_dist_list, epdist_list, list) {
-		if (cur_dist_list->endpoint == ENDPOINT_0)
+	list_for_each_entry(cur_list, epdist_list, list) {
+		if (cur_list->endpoint == ENDPOINT_0)
 			continue;
 
-		if (cur_dist_list->cred_to_dist > 0) {
-			cur_dist_list->credits +=
-					cur_dist_list->cred_to_dist;
-			cur_dist_list->cred_to_dist = 0;
-			if (cur_dist_list->credits >
-			    cur_dist_list->cred_assngd)
+		if (cur_list->cred_to_dist > 0) {
+			cur_list->credits += cur_list->cred_to_dist;
+			cur_list->cred_to_dist = 0;
+
+			if (cur_list->credits > cur_list->cred_assngd)
 				ath6kl_credit_reduce(cred_info,
-						     cur_dist_list,
-						     cur_dist_list->cred_assngd);
+						     cur_list,
+						     cur_list->cred_assngd);
 
-			if (cur_dist_list->credits >
-			    cur_dist_list->cred_norm)
-				ath6kl_credit_reduce(cred_info, cur_dist_list,
-						     cur_dist_list->cred_norm);
+			if (cur_list->credits > cur_list->cred_norm)
+				ath6kl_credit_reduce(cred_info, cur_list,
+						     cur_list->cred_norm);
 
-			if (!(cur_dist_list->dist_flags & HTC_EP_ACTIVE)) {
-				if (cur_dist_list->txq_depth == 0)
+			if (!(cur_list->dist_flags & HTC_EP_ACTIVE)) {
+				if (cur_list->txq_depth == 0)
 					ath6kl_credit_reduce(cred_info,
-							     cur_dist_list, 0);
+							     cur_list, 0);
 			}
 		}
 	}
@@ -674,6 +672,7 @@ static int ath6kl_htc_tx_setup_scat_list(struct htc_target *target,
 	struct htc_packet *packet;
 	int i, len, rem_scat, cred_pad;
 	int status = 0;
+	u8 flags;
 
 	rem_scat = target->max_tx_bndl_sz;
 
@@ -700,8 +699,8 @@ static int ath6kl_htc_tx_setup_scat_list(struct htc_target *target,
 
 		scat_req->scat_list[i].packet = packet;
 		/* prepare packet and flag message as part of a send bundle */
-		ath6kl_htc_tx_prep_pkt(packet,
-				       packet->info.tx.flags | HTC_FLAGS_SEND_BUNDLE,
+		flags = packet->info.tx.flags | HTC_FLAGS_SEND_BUNDLE;
+		ath6kl_htc_tx_prep_pkt(packet, flags,
 				       cred_pad, packet->info.tx.seqno);
 		/* Make sure the buffer is 4-byte aligned */
 		ath6kl_htc_tx_buf_align(&packet->buf,
@@ -2405,6 +2404,7 @@ int ath6kl_htc_conn_service(struct htc_target *target,
 	enum htc_endpoint_id assigned_ep = ENDPOINT_MAX;
 	unsigned int max_msg_sz = 0;
 	int status = 0;
+	u16 msg_id;
 
 	ath6kl_dbg(ATH6KL_DBG_HTC,
 		   "htc connect service target 0x%p service id 0x%x\n",
@@ -2448,8 +2448,9 @@ int ath6kl_htc_conn_service(struct htc_target *target,
 		}
 
 		resp_msg = (struct htc_conn_service_resp *)rx_pkt->buf;
+		msg_id = le16_to_cpu(resp_msg->msg_id);
 
-		if ((le16_to_cpu(resp_msg->msg_id) != HTC_MSG_CONN_SVC_RESP_ID) ||
+		if ((msg_id != HTC_MSG_CONN_SVC_RESP_ID) ||
 		    (rx_pkt->act_len < sizeof(*resp_msg))) {
 			status = -ENOMEM;
 			goto fail_tx;
diff --git a/drivers/net/wireless/ath/ath6kl/init.c b/drivers/net/wireless/ath/ath6kl/init.c
index c7d5149..231675d 100644
--- a/drivers/net/wireless/ath/ath6kl/init.c
+++ b/drivers/net/wireless/ath/ath6kl/init.c
@@ -75,7 +75,7 @@ static const struct ath6kl_hw hw_list[] = {
 		},
 
 		.fw_board		= AR6003_HW_2_1_1_BOARD_DATA_FILE,
-		.fw_default_board	= AR6003_HW_2_1_1_DEFAULT_BOARD_DATA_FILE,
+		.fw_default_board = AR6003_HW_2_1_1_DEFAULT_BOARD_DATA_FILE,
 	},
 	{
 		.id				= AR6004_HW_1_0_VERSION,
@@ -394,7 +394,7 @@ static int ath6kl_target_config_wlan_params(struct ath6kl *ar, int idx)
 
 	if (ar->conf_flags & ATH6KL_CONF_IGNORE_PS_FAIL_EVT_IN_SCAN) {
 		ret = ath6kl_wmi_pmparams_cmd(ar->wmi, idx, 0, 1, 0, 0, 1,
-					      IGNORE_POWER_SAVE_FAIL_EVENT_DURING_SCAN);
+					      IGNORE_PS_FAIL_DURING_SCAN);
 		if (ret) {
 			ath6kl_err("unable to set power save fail event policy: %d\n",
 				   ret);
@@ -404,7 +404,7 @@ static int ath6kl_target_config_wlan_params(struct ath6kl *ar, int idx)
 
 	if (!(ar->conf_flags & ATH6KL_CONF_IGNORE_ERP_BARKER)) {
 		ret = ath6kl_wmi_set_lpreamble_cmd(ar->wmi, idx, 0,
-						   WMI_DONOT_IGNORE_BARKER_IN_ERP);
+						   WMI_FOLLOW_BARKER_IN_ERP);
 		if (ret) {
 			ath6kl_err("unable to set barker preamble policy: %d\n",
 				   ret);
diff --git a/drivers/net/wireless/ath/ath6kl/wmi.h b/drivers/net/wireless/ath/ath6kl/wmi.h
index 9137850..70bc2f7 100644
--- a/drivers/net/wireless/ath/ath6kl/wmi.h
+++ b/drivers/net/wireless/ath/ath6kl/wmi.h
@@ -1017,7 +1017,7 @@ struct wmi_power_mode_cmd {
  */
 enum power_save_fail_event_policy {
 	SEND_POWER_SAVE_FAIL_EVENT_ALWAYS = 1,
-	IGNORE_POWER_SAVE_FAIL_EVENT_DURING_SCAN = 2,
+	IGNORE_PS_FAIL_DURING_SCAN = 2,
 };
 
 struct wmi_power_params_cmd {
@@ -1215,7 +1215,7 @@ struct wmi_snr_threshold_params_cmd {
 
 enum wmi_preamble_policy {
 	WMI_IGNORE_BARKER_IN_ERP = 0,
-	WMI_DONOT_IGNORE_BARKER_IN_ERP
+	WMI_FOLLOW_BARKER_IN_ERP,
 };
 
 struct wmi_set_lpreamble_cmd {


Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:18619 "EHLO
        wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753980AbdCOPqm (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 15 Mar 2017 11:46:42 -0400
Subject: [PATCH v6 08/10] ath10k: htc: ready_ext msg support
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>
Date: Wed, 15 Mar 2017 17:46:29 +0200
Message-ID: <148959278974.31432.11930315036023225910.stgit@potku.adurom.net> (sfid-20170315_164951_901444_92F9193B)
In-Reply-To: <148959263520.31432.8488419244476213373.stgit@potku.adurom.net>
References: <148959263520.31432.8488419244476213373.stgit@potku.adurom.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Erik Stromdahl <erik.stromdahl@gmail.com>

Added support for extended ready message.
The extended ready message contains the maximum bundle
count supported by SDIO chipsets.

It is transmitted by SDIO chipset only and replaces the
"standard" ready message in this case.

Signed-off-by: Erik Stromdahl <erik.stromdahl@gmail.com>
Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/htc.c |   28 ++++++++++++++++++++++------
 drivers/net/wireless/ath/ath10k/htc.h |    5 +++++
 2 files changed, 27 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/htc.c b/drivers/net/wireless/ath/ath10k/htc.c
index a8452ce77873..361eeab59283 100644
--- a/drivers/net/wireless/ath/ath10k/htc.c
+++ b/drivers/net/wireless/ath/ath10k/htc.c
@@ -583,8 +583,6 @@ int ath10k_htc_wait_target(struct ath10k_htc *htc)
 	unsigned long time_left;
 	struct ath10k_htc_msg *msg;
 	u16 message_id;
-	u16 credit_count;
-	u16 credit_size;
 
 	time_left = wait_for_completion_timeout(&htc->ctl_resp,
 						ATH10K_HTC_WAIT_TIMEOUT_HZ);
@@ -621,16 +619,14 @@ int ath10k_htc_wait_target(struct ath10k_htc *htc)
 
 	msg = (struct ath10k_htc_msg *)htc->control_resp_buffer;
 	message_id   = __le16_to_cpu(msg->hdr.message_id);
-	credit_count = __le16_to_cpu(msg->ready.credit_count);
-	credit_size  = __le16_to_cpu(msg->ready.credit_size);
 
 	if (message_id != ATH10K_HTC_MSG_READY_ID) {
 		ath10k_err(ar, "Invalid HTC ready msg: 0x%x\n", message_id);
 		return -ECOMM;
 	}
 
-	htc->total_transmit_credits = credit_count;
-	htc->target_credit_size = credit_size;
+	htc->total_transmit_credits = __le16_to_cpu(msg->ready.credit_count);
+	htc->target_credit_size = __le16_to_cpu(msg->ready.credit_size);
 
 	ath10k_dbg(ar, ATH10K_DBG_HTC,
 		   "Target ready! transmit resources: %d size:%d\n",
@@ -643,6 +639,19 @@ int ath10k_htc_wait_target(struct ath10k_htc *htc)
 		return -ECOMM;
 	}
 
+	/* The only way to determine if the ready message is an extended
+	 * message is from the size.
+	 */
+	if (htc->control_resp_len >=
+	    sizeof(msg->hdr) + sizeof(msg->ready_ext)) {
+		htc->max_msgs_per_htc_bundle =
+			min_t(u8, msg->ready_ext.max_msgs_per_htc_bundle,
+			      HTC_HOST_MAX_MSG_PER_BUNDLE);
+		ath10k_dbg(ar, ATH10K_DBG_HTC,
+			   "Extended ready message. RX bundle size: %d\n",
+			   htc->max_msgs_per_htc_bundle);
+	}
+
 	return 0;
 }
 
@@ -838,6 +847,13 @@ int ath10k_htc_start(struct ath10k_htc *htc)
 	msg->hdr.message_id =
 		__cpu_to_le16(ATH10K_HTC_MSG_SETUP_COMPLETE_EX_ID);
 
+	if (ar->hif.bus == ATH10K_BUS_SDIO) {
+		/* Extra setup params used by SDIO */
+		msg->setup_complete_ext.flags =
+			__cpu_to_le32(ATH10K_HTC_SETUP_COMPLETE_FLAGS_RX_BNDL_EN);
+		msg->setup_complete_ext.max_msgs_per_bundled_recv =
+			htc->max_msgs_per_htc_bundle;
+	}
 	ath10k_dbg(ar, ATH10K_DBG_HTC, "HTC is using TX credit flow control\n");
 
 	status = ath10k_htc_send(htc, ATH10K_HTC_EP_0, skb);
diff --git a/drivers/net/wireless/ath/ath10k/htc.h b/drivers/net/wireless/ath/ath10k/htc.h
index ae6003495649..24663b07eeac 100644
--- a/drivers/net/wireless/ath/ath10k/htc.h
+++ b/drivers/net/wireless/ath/ath10k/htc.h
@@ -112,6 +112,10 @@ enum ath10k_htc_conn_svc_status {
 	ATH10K_HTC_CONN_SVC_STATUS_NO_MORE_EP   = 4
 };
 
+enum ath10k_htc_setup_complete_flags {
+	ATH10K_HTC_SETUP_COMPLETE_FLAGS_RX_BNDL_EN = 1
+};
+
 struct ath10k_ath10k_htc_msg_hdr {
 	__le16 message_id; /* @enum htc_message_id */
 } __packed;
@@ -360,6 +364,7 @@ struct ath10k_htc {
 
 	int total_transmit_credits;
 	int target_credit_size;
+	u8 max_msgs_per_htc_bundle;
 };
 
 int ath10k_htc_init(struct ath10k *ar);

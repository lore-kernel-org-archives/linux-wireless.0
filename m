Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh06.mail.saunalahti.fi ([62.142.5.116]:38924 "EHLO
	emh06.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753216Ab1J0PtE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Oct 2011 11:49:04 -0400
Subject: [PATCH 09/10] ath6kl: create ath6kl_htc_reset()
To: kvalo@qca.qualcomm.com
From: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org
Date: Thu, 27 Oct 2011 18:49:00 +0300
Message-ID: <20111027154900.23519.53111.stgit@localhost6.localdomain6> (sfid-20111027_174908_716959_D06CC7E2)
In-Reply-To: <20111027154746.23519.39680.stgit@localhost6.localdomain6>
References: <20111027154746.23519.39680.stgit@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When rebooting hardware we need to reset the htc state in ath6kl_htc_stop().

Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/htc.c |   91 ++++++++++++++++++---------------
 1 files changed, 49 insertions(+), 42 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/htc.c b/drivers/net/wireless/ath/ath6kl/htc.c
index d03456b..04b4070 100644
--- a/drivers/net/wireless/ath/ath6kl/htc.c
+++ b/drivers/net/wireless/ath/ath6kl/htc.c
@@ -2656,6 +2656,44 @@ int ath6kl_htc_start(struct htc_target *target)
 	return status;
 }
 
+static int ath6kl_htc_reset(struct htc_target *target)
+{
+	u32 block_size, ctrl_bufsz;
+	struct htc_packet *packet;
+	int i;
+
+	reset_ep_state(target);
+
+	block_size = target->dev->ar->mbox_info.block_size;
+
+	ctrl_bufsz = (block_size > HTC_MAX_CTRL_MSG_LEN) ?
+		      (block_size + HTC_HDR_LENGTH) :
+		      (HTC_MAX_CTRL_MSG_LEN + HTC_HDR_LENGTH);
+
+	for (i = 0; i < NUM_CONTROL_BUFFERS; i++) {
+		packet = kzalloc(sizeof(*packet), GFP_KERNEL);
+		if (!packet)
+			return -ENOMEM;
+
+		packet->buf_start = kzalloc(ctrl_bufsz, GFP_KERNEL);
+		if (!packet->buf_start) {
+			kfree(packet);
+			return -ENOMEM;
+		}
+
+		packet->buf_len = ctrl_bufsz;
+		if (i < NUM_CONTROL_RX_BUFFERS) {
+			packet->act_len = 0;
+			packet->buf = packet->buf_start;
+			packet->endpoint = ENDPOINT_0;
+			list_add_tail(&packet->list, &target->free_ctrl_rxbuf);
+		} else
+			list_add_tail(&packet->list, &target->free_ctrl_txbuf);
+	}
+
+	return 0;
+}
+
 /* htc_stop: stop interrupt reception, and flush all queued buffers */
 void ath6kl_htc_stop(struct htc_target *target)
 {
@@ -2674,15 +2712,13 @@ void ath6kl_htc_stop(struct htc_target *target)
 
 	ath6kl_htc_flush_rx_buf(target);
 
-	reset_ep_state(target);
+	ath6kl_htc_reset(target);
 }
 
 void *ath6kl_htc_create(struct ath6kl *ar)
 {
 	struct htc_target *target = NULL;
-	struct htc_packet *packet;
-	int status = 0, i = 0;
-	u32 block_size, ctrl_bufsz;
+	int status = 0;
 
 	target = kzalloc(sizeof(*target), GFP_KERNEL);
 	if (!target) {
@@ -2694,7 +2730,7 @@ void *ath6kl_htc_create(struct ath6kl *ar)
 	if (!target->dev) {
 		ath6kl_err("unable to allocate memory\n");
 		status = -ENOMEM;
-		goto fail_create_htc;
+		goto err_htc_cleanup;
 	}
 
 	spin_lock_init(&target->htc_lock);
@@ -2709,49 +2745,20 @@ void *ath6kl_htc_create(struct ath6kl *ar)
 	target->dev->htc_cnxt = target;
 	target->ep_waiting = ENDPOINT_MAX;
 
-	reset_ep_state(target);
-
 	status = ath6kl_hif_setup(target->dev);
-
 	if (status)
-		goto fail_create_htc;
-
-	block_size = ar->mbox_info.block_size;
-
-	ctrl_bufsz = (block_size > HTC_MAX_CTRL_MSG_LEN) ?
-		      (block_size + HTC_HDR_LENGTH) :
-		      (HTC_MAX_CTRL_MSG_LEN + HTC_HDR_LENGTH);
+		goto err_htc_cleanup;
 
-	for (i = 0; i < NUM_CONTROL_BUFFERS; i++) {
-		packet = kzalloc(sizeof(*packet), GFP_KERNEL);
-		if (!packet)
-			break;
-
-		packet->buf_start = kzalloc(ctrl_bufsz, GFP_KERNEL);
-		if (!packet->buf_start) {
-			kfree(packet);
-			break;
-		}
+	status = ath6kl_htc_reset(target);
+	if (status)
+		goto err_htc_cleanup;
 
-		packet->buf_len = ctrl_bufsz;
-		if (i < NUM_CONTROL_RX_BUFFERS) {
-			packet->act_len = 0;
-			packet->buf = packet->buf_start;
-			packet->endpoint = ENDPOINT_0;
-			list_add_tail(&packet->list, &target->free_ctrl_rxbuf);
-		} else
-			list_add_tail(&packet->list, &target->free_ctrl_txbuf);
-	}
+	return target;
 
-fail_create_htc:
-	if (i != NUM_CONTROL_BUFFERS || status) {
-		if (target) {
-			ath6kl_htc_cleanup(target);
-			target = NULL;
-		}
-	}
+err_htc_cleanup:
+	ath6kl_htc_cleanup(target);
 
-	return target;
+	return NULL;
 }
 
 /* cleanup the HTC instance */


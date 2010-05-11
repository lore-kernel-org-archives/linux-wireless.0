Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:47754 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751545Ab0EKKzN (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 May 2010 06:55:13 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Tue, 11 May 2010 03:55:13 -0700
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <19433.14244.829946.555964@gargle.gargle.HOWL>
Date: Tue, 11 May 2010 16:25:32 +0530
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <error27@gmail.com>
Subject: [PATCH 5/5] ath9k_htc: Fix array overflow
From: <Sujith.Manoharan@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Use ENDPOINT_MAX instead of HST_ENDPOINT_MAX.
This fixes a stack corruption issue.

This is based on a patch sent by Dan Carpenter <error27@gmail.com>.

Cc: Dan Carpenter <error27@gmail.com>
Signed-off-by: Sujith <Sujith.Manoharan@atheros.com>
---
 drivers/net/wireless/ath/ath9k/htc_hst.c |    8 ++++----
 drivers/net/wireless/ath/ath9k/htc_hst.h |    5 +----
 2 files changed, 5 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/htc_hst.c b/drivers/net/wireless/ath/ath9k/htc_hst.c
index e86e172..5cd5e2f 100644
--- a/drivers/net/wireless/ath/ath9k/htc_hst.c
+++ b/drivers/net/wireless/ath/ath9k/htc_hst.c
@@ -39,7 +39,7 @@ static struct htc_endpoint *get_next_avail_ep(struct htc_endpoint *endpoint)
 {
 	enum htc_endpoint_id avail_epid;
 
-	for (avail_epid = ENDPOINT_MAX; avail_epid > ENDPOINT0; avail_epid--)
+	for (avail_epid = (ENDPOINT_MAX - 1); avail_epid > ENDPOINT0; avail_epid--)
 		if (endpoint[avail_epid].service_id == 0)
 			return &endpoint[avail_epid];
 	return NULL;
@@ -117,7 +117,7 @@ static void htc_process_conn_rsp(struct htc_target *target,
 		max_msglen = be16_to_cpu(svc_rspmsg->max_msg_len);
 		endpoint = &target->endpoint[epid];
 
-		for (tepid = ENDPOINT_MAX; tepid > ENDPOINT0; tepid--) {
+		for (tepid = (ENDPOINT_MAX - 1); tepid > ENDPOINT0; tepid--) {
 			tmp_endpoint = &target->endpoint[tepid];
 			if (tmp_endpoint->service_id == service_id) {
 				tmp_endpoint->service_id = 0;
@@ -298,7 +298,7 @@ void htc_stop(struct htc_target *target)
 	enum htc_endpoint_id epid;
 	struct htc_endpoint *endpoint;
 
-	for (epid = ENDPOINT0; epid <= ENDPOINT_MAX; epid++) {
+	for (epid = ENDPOINT0; epid < ENDPOINT_MAX; epid++) {
 		endpoint = &target->endpoint[epid];
 		if (endpoint->service_id != 0)
 			target->hif->stop(target->hif_dev, endpoint->ul_pipeid);
@@ -310,7 +310,7 @@ void htc_start(struct htc_target *target)
 	enum htc_endpoint_id epid;
 	struct htc_endpoint *endpoint;
 
-	for (epid = ENDPOINT0; epid <= ENDPOINT_MAX; epid++) {
+	for (epid = ENDPOINT0; epid < ENDPOINT_MAX; epid++) {
 		endpoint = &target->endpoint[epid];
 		if (endpoint->service_id != 0)
 			target->hif->start(target->hif_dev,
diff --git a/drivers/net/wireless/ath/ath9k/htc_hst.h b/drivers/net/wireless/ath/ath9k/htc_hst.h
index 4f1cdb0..faba679 100644
--- a/drivers/net/wireless/ath/ath9k/htc_hst.h
+++ b/drivers/net/wireless/ath/ath9k/htc_hst.h
@@ -123,9 +123,6 @@ struct htc_endpoint {
 #define HTC_CONTROL_BUFFER_SIZE	\
 	(HTC_MAX_CONTROL_MESSAGE_LENGTH + sizeof(struct htc_frame_hdr))
 
-#define NUM_CONTROL_BUFFERS 8
-#define HST_ENDPOINT_MAX 8
-
 struct htc_control_buf {
 	struct htc_packet htc_pkt;
 	u8 buf[HTC_CONTROL_BUFFER_SIZE];
@@ -139,7 +136,7 @@ struct htc_target {
 	struct ath9k_htc_priv *drv_priv;
 	struct device *dev;
 	struct ath9k_htc_hif *hif;
-	struct htc_endpoint endpoint[HST_ENDPOINT_MAX];
+	struct htc_endpoint endpoint[ENDPOINT_MAX];
 	struct completion target_wait;
 	struct completion cmd_wait;
 	struct list_head list;
-- 
1.7.1


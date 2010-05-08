Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f183.google.com ([209.85.221.183]:57211 "EHLO
	mail-qy0-f183.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753590Ab0EHQW1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 8 May 2010 12:22:27 -0400
Received: by qyk13 with SMTP id 13so3445524qyk.1
        for <linux-wireless@vger.kernel.org>; Sat, 08 May 2010 09:22:26 -0700 (PDT)
Date: Sat, 8 May 2010 18:22:01 +0200
From: Dan Carpenter <error27@gmail.com>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: Jouni Malinen <jmalinen@atheros.com>,
	Sujith Manoharan <Sujith.Manoharan@atheros.com>,
	Vasanthakumar Thiagarajan <vasanth@atheros.com>,
	Senthil Balasubramanian <senthilkumar@atheros.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	Ming Lei <tom.leiming@gmail.com>,
	linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org
Subject: [patch 2/9] ath9k: range checking issues in htc_hst.c
Message-ID: <20100508162201.GN27064@bicker>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The original code had ENDPOINT_MAX and HST_ENDPOINT_MAX switched.

Also the first loop was off by one, it started past the end of the array
and went down to 1 instead of going down to 0.  The test at the end of
the loop to see if we exited via a break wasn't right because
"tmp_endpoint" is always non-null here.

Signed-off-by: Dan Carpenter <error27@gmail.com>

diff --git a/drivers/net/wireless/ath/ath9k/htc_hst.c b/drivers/net/wireless/ath/ath9k/htc_hst.c
index 7bf6ce1..0c062d0 100644
--- a/drivers/net/wireless/ath/ath9k/htc_hst.c
+++ b/drivers/net/wireless/ath/ath9k/htc_hst.c
@@ -116,7 +116,7 @@ static void htc_process_conn_rsp(struct htc_target *target,
 		max_msglen = be16_to_cpu(svc_rspmsg->max_msg_len);
 		endpoint = &target->endpoint[epid];
 
-		for (tepid = ENDPOINT_MAX; tepid > ENDPOINT0; tepid--) {
+		for (tepid = HST_ENDPOINT_MAX - 1; tepid >= ENDPOINT0; tepid--) {
 			tmp_endpoint = &target->endpoint[tepid];
 			if (tmp_endpoint->service_id == service_id) {
 				tmp_endpoint->service_id = 0;
@@ -124,7 +124,7 @@ static void htc_process_conn_rsp(struct htc_target *target,
 			}
 		}
 
-		if (!tmp_endpoint)
+		if (tepid < ENDPOINT0)
 			return;
 
 		endpoint->service_id = service_id;
@@ -297,7 +297,7 @@ void htc_stop(struct htc_target *target)
 	enum htc_endpoint_id epid;
 	struct htc_endpoint *endpoint;
 
-	for (epid = ENDPOINT0; epid <= ENDPOINT_MAX; epid++) {
+	for (epid = ENDPOINT0; epid < HST_ENDPOINT_MAX; epid++) {
 		endpoint = &target->endpoint[epid];
 		if (endpoint->service_id != 0)
 			target->hif->stop(target->hif_dev, endpoint->ul_pipeid);
@@ -309,7 +309,7 @@ void htc_start(struct htc_target *target)
 	enum htc_endpoint_id epid;
 	struct htc_endpoint *endpoint;
 
-	for (epid = ENDPOINT0; epid <= ENDPOINT_MAX; epid++) {
+	for (epid = ENDPOINT0; epid < HST_ENDPOINT_MAX; epid++) {
 		endpoint = &target->endpoint[epid];
 		if (endpoint->service_id != 0)
 			target->hif->start(target->hif_dev,
@@ -377,7 +377,7 @@ void ath9k_htc_rx_msg(struct htc_target *htc_handle,
 	htc_hdr = (struct htc_frame_hdr *) skb->data;
 	epid = htc_hdr->endpoint_id;
 
-	if (epid >= ENDPOINT_MAX) {
+	if (epid >= HST_ENDPOINT_MAX) {
 		if (pipe_id != USB_REG_IN_PIPE)
 			dev_kfree_skb_any(skb);
 		else

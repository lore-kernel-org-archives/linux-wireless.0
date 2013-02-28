Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:17346 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750775Ab3B1ErE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 Feb 2013 23:47:04 -0500
Date: Thu, 28 Feb 2013 07:45:47 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [patch] ath6kl: small cleanup in ath6kl_htc_pipe_rx_complete()
Message-ID: <20130228044547.GC15239@longonot.mountain> (sfid-20130228_054711_079994_2D23B5B8)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

It's harmless, but Smatch complains if we use "htc_hdr->eid" before
doing the bounds check.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/net/wireless/ath/ath6kl/htc_pipe.c b/drivers/net/wireless/ath/ath6kl/htc_pipe.c
index 2813901..9adb567 100644
--- a/drivers/net/wireless/ath/ath6kl/htc_pipe.c
+++ b/drivers/net/wireless/ath/ath6kl/htc_pipe.c
@@ -988,8 +988,6 @@ static int ath6kl_htc_pipe_rx_complete(struct ath6kl *ar, struct sk_buff *skb,
 
 	htc_hdr = (struct htc_frame_hdr *) netdata;
 
-	ep = &target->endpoint[htc_hdr->eid];
-
 	if (htc_hdr->eid >= ENDPOINT_MAX) {
 		ath6kl_dbg(ATH6KL_DBG_HTC,
 			   "HTC Rx: invalid EndpointID=%d\n",
@@ -997,6 +995,7 @@ static int ath6kl_htc_pipe_rx_complete(struct ath6kl *ar, struct sk_buff *skb,
 		status = -EINVAL;
 		goto free_skb;
 	}
+	ep = &target->endpoint[htc_hdr->eid];
 
 	payload_len = le16_to_cpu(get_unaligned(&htc_hdr->payld_len));
 

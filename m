Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh07.mail.saunalahti.fi ([62.142.5.117]:35730 "EHLO
	emh07.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031925Ab2CSQPZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Mar 2012 12:15:25 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: kvalo@qca.qualcomm.com
Cc: linux-wireless@vger.kernel.org, ath6kl-devel@qualcomm.com
Subject: [PATCH 3/9] ath6kl: add tx_comp_multi() to struct htc_ep_callbacks
Date: Mon, 19 Mar 2012 18:14:58 +0200
Message-Id: <1332173704-18877-4-git-send-email-kvalo@qca.qualcomm.com> (sfid-20120319_171611_498055_64D8C855)
In-Reply-To: <1332173704-18877-1-git-send-email-kvalo@qca.qualcomm.com>
References: <1332173704-18877-1-git-send-email-kvalo@qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

It's also needed by the USB code.

Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/htc.h  |    1 +
 drivers/net/wireless/ath/ath6kl/init.c |    1 +
 2 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/htc.h b/drivers/net/wireless/ath/ath6kl/htc.h
index 7b0c489..51f2485 100644
--- a/drivers/net/wireless/ath/ath6kl/htc.h
+++ b/drivers/net/wireless/ath/ath6kl/htc.h
@@ -326,6 +326,7 @@ struct htc_ep_callbacks {
 					      struct htc_packet *);
 	struct htc_packet *(*rx_allocthresh) (struct htc_target *,
 					      enum htc_endpoint_id, int);
+	void (*tx_comp_multi) (struct htc_target *, struct list_head *);
 	int rx_alloc_thresh;
 	int rx_refill_thresh;
 };
diff --git a/drivers/net/wireless/ath/ath6kl/init.c b/drivers/net/wireless/ath/ath6kl/init.c
index 1b97f26..d33691e 100644
--- a/drivers/net/wireless/ath/ath6kl/init.c
+++ b/drivers/net/wireless/ath/ath6kl/init.c
@@ -256,6 +256,7 @@ static int ath6kl_init_service_ep(struct ath6kl *ar)
 	memset(&connect, 0, sizeof(connect));
 
 	/* these fields are the same for all service endpoints */
+	connect.ep_cb.tx_comp_multi = ath6kl_tx_complete;
 	connect.ep_cb.rx = ath6kl_rx;
 	connect.ep_cb.rx_refill = ath6kl_rx_refill;
 	connect.ep_cb.tx_full = ath6kl_tx_queue_full;
-- 
1.7.1


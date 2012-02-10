Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:10533 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750845Ab2BJPKl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 10 Feb 2012 10:10:41 -0500
From: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
To: <kvalo@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>, <ath6kl-devel@qualcomm.com>
Subject: [PATCH 1/2] ath6kl: Make sure to allocate rx buffers after the endpoint connection
Date: Fri, 10 Feb 2012 20:40:32 +0530
Message-ID: <1328886633-2823-1-git-send-email-vthiagar@qca.qualcomm.com> (sfid-20120210_161046_111260_011E33FA)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Rx buffers should be allocated for control and best effort endpoints only
after the enpoints connection is esablished. But this is done before the
endpoint connection is complete, we don't even the control and BE endpoints
that time. Move the buffer allocation after endpoint connection is over,
after ath6kl_init_hw_start(). Found in review, never seen any real issue
with this.

Signed-off-by: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/core.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/core.c b/drivers/net/wireless/ath/ath6kl/core.c
index c4926cf..ce7d9b5 100644
--- a/drivers/net/wireless/ath/ath6kl/core.c
+++ b/drivers/net/wireless/ath/ath6kl/core.c
@@ -136,10 +136,6 @@ int ath6kl_core_init(struct ath6kl *ar)
 	ar->ac_stream_pri_map[WMM_AC_VI] = 2;
 	ar->ac_stream_pri_map[WMM_AC_VO] = 3; /* highest */
 
-	/* give our connected endpoints some buffers */
-	ath6kl_rx_refill(ar->htc_target, ar->ctrl_ep);
-	ath6kl_rx_refill(ar->htc_target, ar->ac2ep_map[WMM_AC_BE]);
-
 	/* allocate some buffers that handle larger AMSDU frames */
 	ath6kl_refill_amsdu_rxbufs(ar, ATH6KL_MAX_AMSDU_RX_BUFFERS);
 
@@ -182,6 +178,10 @@ int ath6kl_core_init(struct ath6kl *ar)
 		goto err_rxbuf_cleanup;
 	}
 
+	/* give our connected endpoints some buffers */
+	ath6kl_rx_refill(ar->htc_target, ar->ctrl_ep);
+	ath6kl_rx_refill(ar->htc_target, ar->ac2ep_map[WMM_AC_BE]);
+
 	/*
 	 * Set mac address which is received in ready event
 	 * FIXME: Move to ath6kl_interface_add()
-- 
1.7.0.4


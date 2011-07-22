Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:37995 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753085Ab1GVFok (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Jul 2011 01:44:40 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
Subject: [PATCH 14/31] ath6kl: Remove ath6kldev_setup_msg_bndl()
Date: Fri, 22 Jul 2011 08:41:47 +0300
Message-ID: <1311313324-6766-16-git-send-email-kvalo@qca.qualcomm.com> (sfid-20110722_074444_922161_08E14E24)
In-Reply-To: <1311313324-6766-1-git-send-email-kvalo@qca.qualcomm.com>
References: <1311313324-6766-1-git-send-email-kvalo@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>

Use appropriate hif function directly.

Signed-off-by: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/htc.c     |    2 +-
 drivers/net/wireless/ath/ath6kl/htc_hif.c |    5 -----
 drivers/net/wireless/ath/ath6kl/htc_hif.h |    1 -
 3 files changed, 1 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/htc.c b/drivers/net/wireless/ath/ath6kl/htc.c
index e77e768..a359332 100644
--- a/drivers/net/wireless/ath/ath6kl/htc.c
+++ b/drivers/net/wireless/ath/ath6kl/htc.c
@@ -2175,7 +2175,7 @@ static void htc_setup_msg_bndl(struct htc_target *target)
 	target->msg_per_bndl_max = min(HTC_HOST_MAX_MSG_PER_BUNDLE,
 				       target->msg_per_bndl_max);
 
-	if (ath6kldev_setup_msg_bndl(target->dev, target->msg_per_bndl_max)) {
+	if (ath6kl_hif_enable_scatter(target->dev->ar, scat_info)) {
 		target->msg_per_bndl_max = 0;
 		return;
 	}
diff --git a/drivers/net/wireless/ath/ath6kl/htc_hif.c b/drivers/net/wireless/ath/ath6kl/htc_hif.c
index c5fb78b..003fe0a 100644
--- a/drivers/net/wireless/ath/ath6kl/htc_hif.c
+++ b/drivers/net/wireless/ath/ath6kl/htc_hif.c
@@ -216,11 +216,6 @@ int ath6kldev_submit_scat_req(struct ath6kl_device *dev,
 	return status;
 }
 
-int ath6kldev_setup_msg_bndl(struct ath6kl_device *dev, int max_msg_per_trans)
-{
-	return ath6kl_hif_enable_scatter(dev->ar, &dev->hif_scat_info);
-}
-
 static int ath6kldev_proc_counter_intr(struct ath6kl_device *dev)
 {
 	u8 counter_int_status;
diff --git a/drivers/net/wireless/ath/ath6kl/htc_hif.h b/drivers/net/wireless/ath/ath6kl/htc_hif.h
index 4cab5fb..5e65f1e 100644
--- a/drivers/net/wireless/ath/ath6kl/htc_hif.h
+++ b/drivers/net/wireless/ath/ath6kl/htc_hif.h
@@ -103,7 +103,6 @@ int ath6kldev_rw_comp_handler(void *context, int status);
 int ath6kldev_intr_bh_handler(struct ath6kl *ar);
 
 /* Scatter Function and Definitions */
-int ath6kldev_setup_msg_bndl(struct ath6kl_device *dev, int max_msg_per_xfer);
 int ath6kldev_submit_scat_req(struct ath6kl_device *dev,
 			    struct hif_scatter_req *scat_req, bool read);
 
-- 
1.7.1


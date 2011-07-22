Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:54611 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752398Ab1GVFnJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Jul 2011 01:43:09 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
Subject: [PATCH 15/31] ath6kl: Minor cleanup in ath6kldev_submit_scat_req()
Date: Fri, 22 Jul 2011 08:41:48 +0300
Message-ID: <1311313324-6766-17-git-send-email-kvalo@qca.qualcomm.com> (sfid-20110722_074314_104707_F5B8316C)
In-Reply-To: <1311313324-6766-1-git-send-email-kvalo@qca.qualcomm.com>
References: <1311313324-6766-1-git-send-email-kvalo@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>

Signed-off-by: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/htc_hif.c |    7 ++-----
 1 files changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/htc_hif.c b/drivers/net/wireless/ath/ath6kl/htc_hif.c
index 003fe0a..043f85f 100644
--- a/drivers/net/wireless/ath/ath6kl/htc_hif.c
+++ b/drivers/net/wireless/ath/ath6kl/htc_hif.c
@@ -191,16 +191,13 @@ int ath6kldev_submit_scat_req(struct ath6kl_device *dev,
 		   scat_req->addr, !read ? "async" : "sync",
 		   (read) ? "rd" : "wr");
 
-	if (!read && scat_req->virt_scat)
+	if (!read && scat_req->virt_scat) {
 		status = ath6kldev_cp_scat_dma_buf(scat_req, false);
-
-	if (status) {
-		if (!read) {
+		if (status) {
 			scat_req->status = status;
 			scat_req->complete(dev->ar->htc_target, scat_req);
 			return 0;
 		}
-		return status;
 	}
 
 	status = ath6kl_hif_scat_req_rw(dev->ar, scat_req);
-- 
1.7.1


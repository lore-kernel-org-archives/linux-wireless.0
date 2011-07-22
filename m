Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:20650 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753266Ab1GVFms (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Jul 2011 01:42:48 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
Subject: [PATCH 08/31] ath6kl: Cleanup ath6kl_sdio_cleanup_scatter()
Date: Fri, 22 Jul 2011 08:41:41 +0300
Message-ID: <1311313324-6766-10-git-send-email-kvalo@qca.qualcomm.com> (sfid-20110722_074256_235866_3D8DFFAF)
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
 drivers/net/wireless/ath/ath6kl/sdio.c |   12 +++---------
 1 files changed, 3 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/sdio.c b/drivers/net/wireless/ath/ath6kl/sdio.c
index 5de3884..797a39f 100644
--- a/drivers/net/wireless/ath/ath6kl/sdio.c
+++ b/drivers/net/wireless/ath/ath6kl/sdio.c
@@ -319,8 +319,9 @@ static int ath6kl_sdio_alloc_prep_scat_req(struct ath6kl_sdio *ar_sdio,
 }
 
 /* clean up scatter support */
-static void ath6kl_sdio_cleanup_scat_resource(struct ath6kl_sdio *ar_sdio)
+static void ath6kl_sdio_cleanup_scatter(struct ath6kl *ar)
 {
+	struct ath6kl_sdio *ar_sdio = ath6kl_sdio_priv(ar);
 	struct hif_scatter_req *s_req, *tmp_req;
 	unsigned long flag;
 
@@ -365,7 +366,7 @@ static int ath6kl_sdio_enable_scatter(struct ath6kl *ar,
 					      MAX_SCATTER_REQUESTS, 0);
 	if (ret) {
 		ath6kl_err("hif-scatter: failed to alloc scatter resources !\n");
-		ath6kl_sdio_cleanup_scat_resource(ar_sdio);
+		ath6kl_sdio_cleanup_scatter(ar);
 		return ret;
 	}
 
@@ -657,13 +658,6 @@ static int ath6kl_sdio_async_rw_scatter(struct ath6kl *ar,
 	return status;
 }
 
-static void ath6kl_sdio_cleanup_scatter(struct ath6kl *ar)
-{
-	struct ath6kl_sdio *ar_sdio = ath6kl_sdio_priv(ar);
-
-	ath6kl_sdio_cleanup_scat_resource(ar_sdio);
-}
-
 static const struct ath6kl_hif_ops ath6kl_sdio_ops = {
 	.read_write_sync = ath6kl_sdio_read_write_sync,
 	.write_async = ath6kl_sdio_write_async,
-- 
1.7.1


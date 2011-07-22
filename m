Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:20650 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753211Ab1GVFmq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Jul 2011 01:42:46 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
Subject: [PATCH 07/31] ath6kl: Cleanup ath6kl_sdio_enable_scatter()
Date: Fri, 22 Jul 2011 08:41:40 +0300
Message-ID: <1311313324-6766-9-git-send-email-kvalo@qca.qualcomm.com> (sfid-20110722_074255_701731_A12EB87F)
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
 drivers/net/wireless/ath/ath6kl/sdio.c |   16 +++-------------
 1 files changed, 3 insertions(+), 13 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/sdio.c b/drivers/net/wireless/ath/ath6kl/sdio.c
index 36f25fc..5de3884 100644
--- a/drivers/net/wireless/ath/ath6kl/sdio.c
+++ b/drivers/net/wireless/ath/ath6kl/sdio.c
@@ -342,9 +342,10 @@ static void ath6kl_sdio_cleanup_scat_resource(struct ath6kl_sdio *ar_sdio)
 }
 
 /* setup of HIF scatter resources */
-static int ath6kl_sdio_setup_scat_resource(struct ath6kl_sdio *ar_sdio,
-					   struct hif_dev_scat_sup_info *pinfo)
+static int ath6kl_sdio_enable_scatter(struct ath6kl *ar,
+				      struct hif_dev_scat_sup_info *pinfo)
 {
+	struct ath6kl_sdio *ar_sdio = ath6kl_sdio_priv(ar);
 	int ret = 0;
 
 	/* check if host supports scatter and it meets our requirements */
@@ -626,17 +627,6 @@ static void ath6kl_sdio_scatter_req_add(struct ath6kl *ar,
 
 }
 
-static int ath6kl_sdio_enable_scatter(struct ath6kl *ar,
-				      struct hif_dev_scat_sup_info *info)
-{
-	struct ath6kl_sdio *ar_sdio = ath6kl_sdio_priv(ar);
-	int ret;
-
-	ret = ath6kl_sdio_setup_scat_resource(ar_sdio, info);
-
-	return ret;
-}
-
 /* scatter gather read write request */
 static int ath6kl_sdio_async_rw_scatter(struct ath6kl *ar,
 					struct hif_scatter_req *scat_req)
-- 
1.7.1


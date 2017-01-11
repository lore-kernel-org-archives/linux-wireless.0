Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pg0-f66.google.com ([74.125.83.66]:33073 "EHLO
        mail-pg0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755628AbdAKQbm (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 11 Jan 2017 11:31:42 -0500
Received: by mail-pg0-f66.google.com with SMTP id 194so9675051pgd.0
        for <linux-wireless@vger.kernel.org>; Wed, 11 Jan 2017 08:31:42 -0800 (PST)
From: Wei Yongjun <weiyj.lk@gmail.com>
To: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: Wei Yongjun <weiyongjun1@huawei.com>,
        linux-wireless@vger.kernel.org
Subject: [PATCH net-next] ath6kl: fix warning for using 0 as NULL
Date: Wed, 11 Jan 2017 16:31:30 +0000
Message-Id: <20170111163130.19087-1-weiyj.lk@gmail.com> (sfid-20170111_173146_082462_37A1D2BB)
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Wei Yongjun <weiyongjun1@huawei.com>

Fixes the following sparse warning:

drivers/net/wireless/ath/ath6kl/sdio.c:716:55: warning:
 Using plain integer as NULL pointer

Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
---
 drivers/net/wireless/ath/ath6kl/sdio.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath6kl/sdio.c b/drivers/net/wireless/ath/ath6kl/sdio.c
index 8ec66e7..2195b1b 100644
--- a/drivers/net/wireless/ath/ath6kl/sdio.c
+++ b/drivers/net/wireless/ath/ath6kl/sdio.c
@@ -713,7 +713,7 @@ static void ath6kl_sdio_cleanup_scatter(struct ath6kl *ar)
 		 * that the packet is properly freed?
 		 */
 		if (s_req->busrequest) {
-			s_req->busrequest->scat_req = 0;
+			s_req->busrequest->scat_req = NULL;
 			ath6kl_sdio_free_bus_req(ar_sdio, s_req->busrequest);
 		}
 		kfree(s_req->virt_dma_buf);

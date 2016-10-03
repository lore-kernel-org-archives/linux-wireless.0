Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from skprod3.natinst.com ([130.164.80.24]:34272 "EHLO ni.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752266AbcJCSBO (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 3 Oct 2016 14:01:14 -0400
From: James Minor <james.minor@ni.com>
To: linux-wireless@vger.kernel.org, ath6kl@lists.infradead.org
Cc: kvalo@qca.qualcomm.com, julia.cartwright@ni.com,
        steve.derosier@lairdtech.com, James Minor <james.minor@ni.com>
Subject: [PATCH 1/3] ath6kl: fix busreqs so they can be reused when sg is cleaned up
Date: Mon, 3 Oct 2016 13:00:02 -0500
Message-Id: <1475517604-17710-2-git-send-email-james.minor@ni.com> (sfid-20161003_200118_948055_1CC38670)
In-Reply-To: <1475517604-17710-1-git-send-email-james.minor@ni.com>
References: <1475510510-16906-1-git-send-email-james.minor@ni.com>
 <1475517604-17710-1-git-send-email-james.minor@ni.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

To reuse the busreqs in case of hardware restart, they must be
properly reinitialized.  If the scat_req pointer isn't reset to
0, __ath6kl_sdio_write_async() will assume there is sg work to be
done (causing a kernel OOPS).

Signed-off-by: James Minor <james.minor@ni.com>
Reviewed-by: Steve deRosier <steve.derosier@lairdtech.com>
---
 drivers/net/wireless/ath/ath6kl/sdio.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath6kl/sdio.c b/drivers/net/wireless/ath/ath6kl/sdio.c
index eab0ab9..96ed060 100644
--- a/drivers/net/wireless/ath/ath6kl/sdio.c
+++ b/drivers/net/wireless/ath/ath6kl/sdio.c
@@ -703,8 +703,10 @@ static void ath6kl_sdio_cleanup_scatter(struct ath6kl *ar)
 		 * ath6kl_hif_rw_comp_handler() with status -ECANCELED so
 		 * that the packet is properly freed?
 		 */
-		if (s_req->busrequest)
+		if (s_req->busrequest) {
+			s_req->busrequest->scat_req = 0;
 			ath6kl_sdio_free_bus_req(ar_sdio, s_req->busrequest);
+		}
 		kfree(s_req->virt_dma_buf);
 		kfree(s_req->sgentries);
 		kfree(s_req);
-- 
1.9.1

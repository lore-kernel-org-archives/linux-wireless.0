Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from skprod2.natinst.com ([130.164.80.23]:58740 "EHLO ni.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751657AbcJCSBM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 3 Oct 2016 14:01:12 -0400
From: James Minor <james.minor@ni.com>
To: linux-wireless@vger.kernel.org, ath6kl@lists.infradead.org
Cc: kvalo@qca.qualcomm.com, julia.cartwright@ni.com,
        steve.derosier@lairdtech.com, James Minor <james.minor@ni.com>
Subject: [PATCH 2/3] ath6kl: after cleanup properly reflect that sg is disabled
Date: Mon, 3 Oct 2016 13:00:03 -0500
Message-Id: <1475517604-17710-3-git-send-email-james.minor@ni.com> (sfid-20161003_200117_316120_C531CF4E)
In-Reply-To: <1475517604-17710-1-git-send-email-james.minor@ni.com>
References: <1475510510-16906-1-git-send-email-james.minor@ni.com>
 <1475517604-17710-1-git-send-email-james.minor@ni.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This allows the hardware to be restarted, as it will cause the
sg to be reinitialized.

Signed-off-by: James Minor <james.minor@ni.com>
Reviewed-by: Steve deRosier <steve.derosier@lairdtech.com>
---
 drivers/net/wireless/ath/ath6kl/sdio.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/wireless/ath/ath6kl/sdio.c b/drivers/net/wireless/ath/ath6kl/sdio.c
index 96ed060..8261e24 100644
--- a/drivers/net/wireless/ath/ath6kl/sdio.c
+++ b/drivers/net/wireless/ath/ath6kl/sdio.c
@@ -714,6 +714,8 @@ static void ath6kl_sdio_cleanup_scatter(struct ath6kl *ar)
 		spin_lock_bh(&ar_sdio->scat_lock);
 	}
 	spin_unlock_bh(&ar_sdio->scat_lock);
+
+	ar_sdio->scatter_enabled = false;
 }
 
 /* setup of HIF scatter resources */
-- 
1.9.1

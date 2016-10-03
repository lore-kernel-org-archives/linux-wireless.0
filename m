Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from skprod3.natinst.com ([130.164.80.24]:34278 "EHLO ni.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751502AbcJCSBO (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 3 Oct 2016 14:01:14 -0400
From: James Minor <james.minor@ni.com>
To: linux-wireless@vger.kernel.org, ath6kl@lists.infradead.org
Cc: kvalo@qca.qualcomm.com, julia.cartwright@ni.com,
        steve.derosier@lairdtech.com, James Minor <james.minor@ni.com>
Subject: [PATCH 3/3] ath6kl: configure SDIO when power is reapplied
Date: Mon, 3 Oct 2016 13:00:04 -0500
Message-Id: <1475517604-17710-4-git-send-email-james.minor@ni.com> (sfid-20161003_200120_726948_BA7E0195)
In-Reply-To: <1475517604-17710-1-git-send-email-james.minor@ni.com>
References: <1475510510-16906-1-git-send-email-james.minor@ni.com>
 <1475517604-17710-1-git-send-email-james.minor@ni.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When power is removed from the device, all of the SDIO settings
return to default.  Fix that by reconfiguring after power is
applied.

Signed-off-by: James Minor <james.minor@ni.com>
Reviewed-by: Steve deRosier <steve.derosier@lairdtech.com>
---
 drivers/net/wireless/ath/ath6kl/sdio.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/net/wireless/ath/ath6kl/sdio.c b/drivers/net/wireless/ath/ath6kl/sdio.c
index 8261e24..c2df075 100644
--- a/drivers/net/wireless/ath/ath6kl/sdio.c
+++ b/drivers/net/wireless/ath/ath6kl/sdio.c
@@ -75,6 +75,8 @@ struct ath6kl_sdio {
 #define CMD53_ARG_FIXED_ADDRESS 0
 #define CMD53_ARG_INCR_ADDRESS  1
 
+static int ath6kl_sdio_config(struct ath6kl *ar);
+
 static inline struct ath6kl_sdio *ath6kl_sdio_priv(struct ath6kl *ar)
 {
 	return ar->hif_priv;
@@ -526,8 +528,15 @@ static int ath6kl_sdio_power_on(struct ath6kl *ar)
 	 */
 	msleep(10);
 
+	ret = ath6kl_sdio_config(ar);
+	if (ret) {
+		ath6kl_err("Failed to config sdio: %d\n", ret);
+		goto out;
+	}
+
 	ar_sdio->is_disabled = false;
 
+out:
 	return ret;
 }
 
-- 
1.9.1

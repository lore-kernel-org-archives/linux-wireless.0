Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ig0-f181.google.com ([209.85.213.181]:35348 "EHLO
	mail-ig0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751886AbbD2XwX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Apr 2015 19:52:23 -0400
Received: by igbyr2 with SMTP id yr2so133969153igb.0
        for <linux-wireless@vger.kernel.org>; Wed, 29 Apr 2015 16:52:22 -0700 (PDT)
From: "Nick Kossifidis" <mickflemm@gmail.com>
To: kvalo@codeaurora.org, ath9k-devel@qca.qualcomm.com
Cc: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org,
	adrian.chadd@gmail.com, Nick Kossifidis <mickflemm@gmail.com>
Subject: [PATCH 11/11] ath9k: Enable short repeat by default on ath9k_htc
Date: Wed, 29 Apr 2015 23:51:22 +0000
Message-Id: <1430351482-59418-12-git-send-email-mickflemm@gmail.com> (sfid-20150430_020417_822050_1F48AFAC)
In-Reply-To: <1430351482-59418-1-git-send-email-mickflemm@gmail.com>
References: <1430351482-59418-1-git-send-email-mickflemm@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Normal FFT reports generate a LOT of data, to save resources
enable short repeat by default also on ath9k_htc (it's already
enabled by default on ath9k). This can always be changed from
userspace if needed.

Signed-off-by: Nick Kossifidis <mickflemm@gmail.com>
---
 drivers/net/wireless/ath/ath9k/htc_drv_init.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_init.c b/drivers/net/wireless/ath/ath9k/htc_drv_init.c
index d7beefe..7468562 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_init.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_init.c
@@ -594,7 +594,7 @@ static void ath9k_init_misc(struct ath9k_htc_priv *priv)
 
 	priv->spec_priv.ah = priv->ah;
 	priv->spec_priv.spec_config.enabled = 0;
-	priv->spec_priv.spec_config.short_repeat = false;
+	priv->spec_priv.spec_config.short_repeat = true;
 	priv->spec_priv.spec_config.count = 8;
 	priv->spec_priv.spec_config.endless = false;
 	priv->spec_priv.spec_config.period = 0x12;
-- 
2.3.5


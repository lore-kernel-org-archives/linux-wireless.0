Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:37219 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751468AbdB1AQf (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 27 Feb 2017 19:16:35 -0500
From: Colin King <colin.king@canonical.com>
To: Stanislav Yakovlev <stas.yakovlev@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] wireless: ipw2200: remove redundant check of rc < 0
Date: Mon, 27 Feb 2017 23:40:19 +0000
Message-Id: <20170227234019.19081-1-colin.king@canonical.com> (sfid-20170228_011807_652278_3E80D0CC)
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Colin Ian King <colin.king@canonical.com>

The check for rc < 0 is always false so the check is redundant
and can be removed.

Detected with CoverityScan, CID#101143 ("Logically dead code")

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/net/wireless/intel/ipw2x00/ipw2200.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/net/wireless/intel/ipw2x00/ipw2200.c b/drivers/net/wireless/intel/ipw2x00/ipw2200.c
index 5ef3c5c..bbc579b 100644
--- a/drivers/net/wireless/intel/ipw2x00/ipw2200.c
+++ b/drivers/net/wireless/intel/ipw2x00/ipw2200.c
@@ -3539,9 +3539,6 @@ static int ipw_load(struct ipw_priv *priv)
 	fw_img = &fw->data[le32_to_cpu(fw->boot_size) +
 			   le32_to_cpu(fw->ucode_size)];
 
-	if (rc < 0)
-		goto error;
-
 	if (!priv->rxq)
 		priv->rxq = ipw_rx_queue_alloc(priv);
 	else
-- 
2.10.2

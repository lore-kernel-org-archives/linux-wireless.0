Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pl0-f65.google.com ([209.85.160.65]:39525 "EHLO
        mail-pl0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752583AbeEOJWh (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 15 May 2018 05:22:37 -0400
Received: by mail-pl0-f65.google.com with SMTP id c19-v6so9068741pls.6
        for <linux-wireless@vger.kernel.org>; Tue, 15 May 2018 02:22:37 -0700 (PDT)
From: Sushant Kumar Mishra <sushant2k1513@gmail.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: Sushant Kumar Mishra <sushant.mishra@redpinesignals.com>,
        linux-wireless@vger.kernel.org,
        Amitkumar Karwar <amit.karwar@redpinesignals.com>,
        Siva Rebbagondla <siva.rebbagondla@redpinesignals.com>,
        Sanjay Konduri <sanjay.konduri@redpinesignals.com>
Subject: [PATCH 2/2] rsi: add fix for corruption of auto rate table
Date: Tue, 15 May 2018 14:34:31 +0530
Message-Id: <1526375071-7010-2-git-send-email-sushant2k1513@gmail.com> (sfid-20180515_112310_166360_06E2958C)
In-Reply-To: <1526375071-7010-1-git-send-email-sushant2k1513@gmail.com>
References: <1526375071-7010-1-git-send-email-sushant2k1513@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sanjay Konduri <sanjay.konduri@redpinesignals.com>

Auto rate table sent to firmware is getting corrupted
as memset to zeros is not done. Added memset to skb
data before filling auto rate table.

Signed-off-by: Sanjay Konduri <sanjay.konduri@redpinesignals.com>
Signed-off-by: Sushant Kumar Mishra <sushant.mishra@redpinesignals.com>
---
 drivers/net/wireless/rsi/rsi_91x_mgmt.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/rsi/rsi_91x_mgmt.c b/drivers/net/wireless/rsi/rsi_91x_mgmt.c
index 0757adc..d0e5937 100644
--- a/drivers/net/wireless/rsi/rsi_91x_mgmt.c
+++ b/drivers/net/wireless/rsi/rsi_91x_mgmt.c
@@ -1190,6 +1190,7 @@ static int rsi_send_auto_rate_request(struct rsi_common *common,
 		return -ENOMEM;
 	}
 
+	memset(skb->data, 0, frame_len);
 	selected_rates = kzalloc(2 * RSI_TBL_SZ, GFP_KERNEL);
 	if (!selected_rates) {
 		rsi_dbg(ERR_ZONE, "%s: Failed in allocation of mem\n",
-- 
2.1.0

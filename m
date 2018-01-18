Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from gateway34.websitewelcome.com ([192.185.149.222]:38579 "EHLO
        gateway34.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1754507AbeASAlw (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 18 Jan 2018 19:41:52 -0500
Received: from cm16.websitewelcome.com (cm16.websitewelcome.com [100.42.49.19])
        by gateway34.websitewelcome.com (Postfix) with ESMTP id 735DB40F801
        for <linux-wireless@vger.kernel.org>; Thu, 18 Jan 2018 17:54:29 -0600 (CST)
Date: Thu, 18 Jan 2018 17:54:28 -0600
From: "Gustavo A. R. Silva" <garsilva@embeddedor.com>
To: Michael Buesch <m@bues.ch>
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <garsilva@embeddedor.com>
Subject: [PATCH] ssb: return boolean instead of integer in
 ssb_dma_translation_special_bit
Message-ID: <20180118235428.GA25892@embeddedor.com> (sfid-20180119_014157_544233_CEFD06B9)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Return statements in functions returning bool should use
true/false instead of 1/0.

This issue was detected with the help of Coccinelle.

Signed-off-by: Gustavo A. R. Silva <garsilva@embeddedor.com>
---
 drivers/ssb/main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/ssb/main.c b/drivers/ssb/main.c
index 65420a9..fdb89b6 100644
--- a/drivers/ssb/main.c
+++ b/drivers/ssb/main.c
@@ -1116,7 +1116,7 @@ static bool ssb_dma_translation_special_bit(struct ssb_device *dev)
 			chip_id == 43231 || chip_id == 43222);
 	}
 
-	return 0;
+	return false;
 }
 
 u32 ssb_dma_translation(struct ssb_device *dev)
-- 
2.7.4

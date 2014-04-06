Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xavier.telenet-ops.be ([195.130.132.52]:41774 "EHLO
	xavier.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750856AbaDFNfn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 6 Apr 2014 09:35:43 -0400
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: "John W. Linville" <linville@tuxdriver.com>,
	Fariya Fatima <fariyaf@gmail.com>
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH] rsi: Add missing initialization of ii
Date: Sun,  6 Apr 2014 15:30:39 +0200
Message-Id: <1396791040-26816-1-git-send-email-geert@linux-m68k.org> (sfid-20140406_153551_655063_AE17AA68)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

drivers/net/wireless/rsi/rsi_91x_core.c: In function ‘rsi_core_determine_hal_queue’:
drivers/net/wireless/rsi/rsi_91x_core.c:91: warning: ‘ii’ may be used uninitialized in this function

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
Is zero the correct initialization value?

 drivers/net/wireless/rsi/rsi_91x_core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/rsi/rsi_91x_core.c b/drivers/net/wireless/rsi/rsi_91x_core.c
index e89535e86caf..20a62f36e89b 100644
--- a/drivers/net/wireless/rsi/rsi_91x_core.c
+++ b/drivers/net/wireless/rsi/rsi_91x_core.c
@@ -88,7 +88,7 @@ static u8 rsi_core_determine_hal_queue(struct rsi_common *common)
 	bool recontend_queue = false;
 	u32 q_len = 0;
 	u8 q_num = INVALID_QUEUE;
-	u8 ii, min = 0;
+	u8 ii = 0, min = 0;
 
 	if (skb_queue_len(&common->tx_queue[MGMT_SOFT_Q])) {
 		if (!common->mgmt_q_block)
-- 
1.7.9.5


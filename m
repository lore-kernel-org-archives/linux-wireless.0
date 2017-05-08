Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:35094 "EHLO
        mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751147AbdEHWea (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 8 May 2017 18:34:30 -0400
From: Karim Eshapa <karim.eshapa@gmail.com>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Karim Eshapa <karim.eshapa@gmail.com>
Subject: [PATCH] drivers: net: wireless: rsi: rsi_91x_core: Use time_after time comparison
Date: Tue,  9 May 2017 00:34:10 +0200
Message-Id: <1494282850-13782-1-git-send-email-karim.eshapa@gmail.com> (sfid-20170509_003546_332653_712E093E)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Use time_after kernel macro for time comparison.

Signed-off-by: Karim Eshapa <karim.eshapa@gmail.com>
---
 drivers/net/wireless/rsi/rsi_91x_core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/rsi/rsi_91x_core.c b/drivers/net/wireless/rsi/rsi_91x_core.c
index f3d3995..68f04a7 100644
--- a/drivers/net/wireless/rsi/rsi_91x_core.c
+++ b/drivers/net/wireless/rsi/rsi_91x_core.c
@@ -306,7 +306,7 @@ void rsi_core_qos_processor(struct rsi_common *common)
 		tstamp_2 = jiffies;
 		mutex_unlock(&common->tx_rxlock);
 
-		if (tstamp_2 > tstamp_1 + (300 * HZ / 1000))
+		if (time_after(tstamp_2, tstamp_1 + (300 * HZ) / 1000))
 			schedule();
 	}
 }
-- 
2.7.4

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.20]:49993 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751071AbaEYR7w (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 25 May 2014 13:59:52 -0400
From: =?UTF-8?q?Manuel=20Sch=C3=B6lling?= <manuel.schoelling@gmx.de>
To: bzhao@marvell.com
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
	kernel-janitors@vger.kernel.org,
	=?UTF-8?q?Manuel=20Sch=C3=B6lling?= <manuel.schoelling@gmx.de>
Subject: [PATCH] mwifiex: use time_after()
Date: Sun, 25 May 2014 19:59:36 +0200
Message-Id: <1401040776-13711-1-git-send-email-manuel.schoelling@gmx.de> (sfid-20140525_200019_642998_71DA518B)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

To be future-proof and for better readability the time comparisons are
modified to use time_after() instead of plain, error-prone math.

Signed-off-by: Manuel Schölling <manuel.schoelling@gmx.de>
---
 drivers/net/wireless/mwifiex/main.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mwifiex/main.h b/drivers/net/wireless/mwifiex/main.h
index d53e1e8..3191066 100644
--- a/drivers/net/wireless/mwifiex/main.h
+++ b/drivers/net/wireless/mwifiex/main.h
@@ -1101,7 +1101,7 @@ mwifiex_11h_get_csa_closed_channel(struct mwifiex_private *priv)
 		return 0;
 
 	/* Clear csa channel, if DFS channel move time has passed */
-	if (jiffies > priv->csa_expire_time) {
+	if (time_after(jiffies, priv->csa_expire_time)) {
 		priv->csa_chan = 0;
 		priv->csa_expire_time = 0;
 	}
-- 
1.7.10.4


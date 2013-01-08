Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog133.obsmtp.com ([74.125.149.82]:57517 "EHLO
	na3sys009aog133.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751241Ab3AHEwH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 Jan 2013 23:52:07 -0500
Date: Tue, 8 Jan 2013 10:14:59 +0530
From: Nishant Sarmukadam <nishants@marvell.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Lennert Buytenhek <buytenh@wantstofly.org>,
	Nishant Sarmukadam <nishants@marvell.com>
Subject: [PATCH] mwl8k: Wake up queues in mwl8k_start
Message-ID: <20130108044455.GA12979@markyou.marvell.com> (sfid-20130108_055211_379163_B756AA3E)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Nishant Sarmukadam <nishants@marvell.com>

If queues are stopped in mwl8k_stop,
these should be started in mwl8k_start

Signed-off-by: Nishant Sarmukadam <nishants@marvell.com>
Signed-off-by: Yogesh Powar <yogeshp@marvell.com>
---
 drivers/net/wireless/mwl8k.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mwl8k.c b/drivers/net/wireless/mwl8k.c
index 696848d..5c3c764 100644
--- a/drivers/net/wireless/mwl8k.c
+++ b/drivers/net/wireless/mwl8k.c
@@ -4533,7 +4533,8 @@ static int mwl8k_start(struct ieee80211_hw *hw)
 		priv->irq = -1;
 		tasklet_disable(&priv->poll_tx_task);
 		tasklet_disable(&priv->poll_rx_task);
-	}
+	} else
+		ieee80211_wake_queues(hw);
 
 	return rc;
 }
-- 
1.8.0.3


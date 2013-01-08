Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog114.obsmtp.com ([74.125.149.211]:47533 "EHLO
	na3sys009aog114.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751354Ab3AHExV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 Jan 2013 23:53:21 -0500
Date: Tue, 8 Jan 2013 10:16:05 +0530
From: Nishant Sarmukadam <nishants@marvell.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Lennert Buytenhek <buytenh@wantstofly.org>,
	Nishant Sarmukadam <nishants@marvell.com>
Subject: [PATCH] mwl8k: Disable tx_wait completion
Message-ID: <20130108044600.GA13030@markyou.marvell.com> (sfid-20130108_055323_876372_B8B37B97)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Nishant Sarmukadam <nishants@marvell.com>

Whenever TX ring is drained, priv->tx_wait still points
to a valid completion. Making sure that it points to
NULL before returning from the  mwl8k_tx_wait_empty
check.

Signed-off-by: Nishant Sarmukadam <nishants@marvell.com>
Signed-off-by: Yogesh Ashok Powar <yogeshp@marvell.com>
---
 drivers/net/wireless/mwl8k.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/mwl8k.c b/drivers/net/wireless/mwl8k.c
index 86e0a38..696848d 100644
--- a/drivers/net/wireless/mwl8k.c
+++ b/drivers/net/wireless/mwl8k.c
@@ -1588,6 +1588,7 @@ static int mwl8k_tx_wait_empty(struct ieee80211_hw *hw)
 
 		rc = -ETIMEDOUT;
 	}
+	priv->tx_wait = NULL;
 	spin_unlock_bh(&priv->tx_lock);
 
 	return rc;
-- 
1.8.0.3


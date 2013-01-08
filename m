Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog118.obsmtp.com ([74.125.149.244]:59561 "EHLO
	na3sys009aog118.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751214Ab3AHGse (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Jan 2013 01:48:34 -0500
Date: Tue, 8 Jan 2013 12:10:53 +0530
From: Nishant Sarmukadam <nishants@marvell.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Lennert Buytenhek <buytenh@wantstofly.org>,
	Yogesh Ashok Powar <yogeshp@marvell.com>
Subject: [PATCH v2] mwl8k: Wake up queues in mwl8k_start
Message-ID: <20130108064049.GA16806@markyou.marvell.com> (sfid-20130108_074837_873685_1A6392C0)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20130108044455.GA12979@markyou.marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Nishant Sarmukadam <nishants@marvell.com>

If queues are stopped in mwl8k_stop,
these should be started in mwl8k_start

Signed-off-by: Nishant Sarmukadam <nishants@marvell.com>
Signed-off-by: Yogesh Powar <yogeshp@marvell.com>
---

v2: Fixing coding style as suggested by
    Sergey V <sftp.mtuci@gmail.com>

 drivers/net/wireless/mwl8k.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/wireless/mwl8k.c b/drivers/net/wireless/mwl8k.c
index 696848d..434a862 100644
--- a/drivers/net/wireless/mwl8k.c
+++ b/drivers/net/wireless/mwl8k.c
@@ -4533,6 +4533,8 @@ static int mwl8k_start(struct ieee80211_hw *hw)
 		priv->irq = -1;
 		tasklet_disable(&priv->poll_tx_task);
 		tasklet_disable(&priv->poll_rx_task);
+	} else {
+		ieee80211_wake_queues(hw);
 	}
 
 	return rc;
-- 
1.8.0.3


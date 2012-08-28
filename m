Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog118.obsmtp.com ([74.125.149.244]:38287 "EHLO
	na3sys009aog118.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751133Ab2H1DfR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Aug 2012 23:35:17 -0400
From: Bing Zhao <bzhao@marvell.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Kiran Divekar <dkiran@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Yogesh Powar <yogeshp@marvell.com>,
	Stone Piao <piaoyun@marvell.com>, Ying Luo <luoy@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH 1/4] mwifiex: release semaphore acquired for internal scan operation
Date: Mon, 27 Aug 2012 20:32:51 -0700
Message-Id: <1346124774-17701-1-git-send-email-bzhao@marvell.com> (sfid-20120828_054600_946902_B5A8D170)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Amitkumar Karwar <akarwar@marvell.com>

If "iw connect" command is fired for station interface, when
heavy traffic is running on AP interface, internal scan operation
performed before actual association is aborted. In this case we
missed to release semaphore.

Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
Signed-off-by: Kiran Divekar <dkiran@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/init.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/init.c b/drivers/net/wireless/mwifiex/init.c
index fad2c8d..c510563 100644
--- a/drivers/net/wireless/mwifiex/init.c
+++ b/drivers/net/wireless/mwifiex/init.c
@@ -92,6 +92,11 @@ static void scan_delay_timer_fn(unsigned long data)
 			kfree(priv->user_scan_cfg);
 			priv->user_scan_cfg = NULL;
 		}
+
+		if (priv->scan_pending_on_block) {
+			priv->scan_pending_on_block = false;
+			up(&priv->async_sem);
+		}
 		goto done;
 	}
 
-- 
1.7.0.2


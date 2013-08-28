Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 162-17-110-37-static.hfc.comcastbusiness.net ([162.17.110.37]:45971
	"EHLO stuffed.shaftnet.org" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753220Ab3H1ART (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Aug 2013 20:17:19 -0400
From: Solomon Peachy <pizza@shaftnet.org>
To: linux-wireless@vger.kernel.org
Cc: Solomon Peachy <pizza@shaftnet.org>
Subject: [PATCH 2/2] cw1200: When debug is enabled, display all wakeup conditions for the wait_event_interruptible_timeout() call.
Date: Tue, 27 Aug 2013 20:17:13 -0400
Message-Id: <1377649033-2091-2-git-send-email-pizza@shaftnet.org> (sfid-20130828_021723_215415_134DBCA8)
In-Reply-To: <1377649033-2091-1-git-send-email-pizza@shaftnet.org>
References: <1377649033-2091-1-git-send-email-pizza@shaftnet.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When trying to debug an interrupt delivery problem I noticed that not 
all of the wakeup conditions on the worker thread were included in the 
debug message.  This patch rectifies that.

Signed-off-by: Solomon Peachy <pizza@shaftnet.org>
---
 drivers/net/wireless/cw1200/bh.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/cw1200/bh.c b/drivers/net/wireless/cw1200/bh.c
index c1ec2a4..92d299a 100644
--- a/drivers/net/wireless/cw1200/bh.c
+++ b/drivers/net/wireless/cw1200/bh.c
@@ -465,8 +465,8 @@ static int cw1200_bh(void *arg)
 				(rx || tx || term || suspend || priv->bh_error);
 			}), status);
 
-		pr_debug("[BH] - rx: %d, tx: %d, term: %d, suspend: %d, status: %ld\n",
-			 rx, tx, term, suspend, status);
+		pr_debug("[BH] - rx: %d, tx: %d, term: %d, bh_err: %d, suspend: %d, status: %ld\n",
+			 rx, tx, term, suspend, priv->bh_error, status);
 
 		/* Did an error occur? */
 		if ((status < 0 && status != -ERESTARTSYS) ||
-- 
1.8.3.1


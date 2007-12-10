Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:55290 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753072AbXLJPqG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Dec 2007 10:46:06 -0500
In-Reply-To: <libertas-12345@shinybook.infradead.org>
To: John Linville <linville@tuxdriver.com>
Cc: Dan Williams <dcbw@redhat.com>, libertas-dev@lists.infradead.org,
	linux-wireless@vger.kernel.org
From: David Woodhouse <dwmw2@infradead.org>
Subject: [PATCH 32/48] libertas: stop debugfs code looking at cmdpendingq
Message-Id: <E1J1kpb-0006mh-Q8@shinybook.infradead.org> (sfid-20071210_154610_189755_36779ABB)
Date: Mon, 10 Dec 2007 10:46:07 -0500
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Date: Sun, 9 Dec 2007 11:08:25 -0500

It doesn't need to wait until no commands are pending anyway -- it only
needs to wait until the scan is finished.

We can hopefully find it something else to wait on too -- it's the only
user of the cmd_pending waitqueue.

Signed-off-by: David Woodhouse <dwmw2@infradead.org>
---
 drivers/net/wireless/libertas/debugfs.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/libertas/debugfs.c b/drivers/net/wireless/libertas/debugfs.c
index 9917a18..e8a24d7 100644
--- a/drivers/net/wireless/libertas/debugfs.c
+++ b/drivers/net/wireless/libertas/debugfs.c
@@ -320,8 +320,7 @@ static ssize_t lbs_setuserscan(struct file *file,
 
 	lbs_scan_networks(priv, scan_cfg, 1);
 	wait_event_interruptible(priv->cmd_pending,
-				 priv->surpriseremoved || 
-				 (!priv->cur_cmd && list_empty(&priv->cmdpendingq)));
+				 priv->surpriseremoved || !priv->last_scanned_channel);
 
 	if (priv->surpriseremoved)
 		goto out_scan_cfg;
-- 
1.5.3.4


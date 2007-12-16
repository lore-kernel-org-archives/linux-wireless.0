Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:49263 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759994AbXLPW6i (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 16 Dec 2007 17:58:38 -0500
Subject: [PATCH 106/48] libertas: don't re-initialise cmdnode when taking it off the free queue
From: David Woodhouse <dwmw2@infradead.org>
In-Reply-To: <libertas-12345@shinybook.infradead.org>
To: John Linville <linville@tuxdriver.com>
Cc: Dan Williams <dcbw@redhat.com>, libertas-dev@lists.infradead.org,
	linux-wireless@vger.kernel.org
Message-Id: <E1J42S1-00038L-Er@shinybook.infradead.org> (sfid-20071216_225846_371275_4F3BA86D)
Date: Sun, 16 Dec 2007 17:59:13 -0500
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Date: Sat, 15 Dec 2007 01:57:12 -0500

We initialise it when we add it to the queue. No need to do it again.

Signed-off-by: David Woodhouse <dwmw2@infradead.org>
---
 drivers/net/wireless/libertas/cmd.c |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/libertas/cmd.c b/drivers/net/wireless/libertas/cmd.c
index 9c73902..fd321dd 100644
--- a/drivers/net/wireless/libertas/cmd.c
+++ b/drivers/net/wireless/libertas/cmd.c
@@ -1761,9 +1761,6 @@ static struct cmd_ctrl_node *lbs_get_cmd_ctrl_node(struct lbs_private *priv)
 
 	spin_unlock_irqrestore(&priv->driver_lock, flags);
 
-	if (tempnode)
-		cleanup_cmdnode(tempnode);
-
 	lbs_deb_leave(LBS_DEB_HOST);
 	return tempnode;
 }
-- 
1.5.3.4


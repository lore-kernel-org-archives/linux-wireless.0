Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:55248 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751899AbXLJPpi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Dec 2007 10:45:38 -0500
In-Reply-To: <libertas-12345@shinybook.infradead.org>
To: John Linville <linville@tuxdriver.com>
Cc: Dan Williams <dcbw@redhat.com>, libertas-dev@lists.infradead.org,
	linux-wireless@vger.kernel.org
From: David Woodhouse <dwmw2@infradead.org>
Subject: [PATCH 06/48] libertas: remove cmd_ctrl_node->status
Message-Id: <E1J1kpA-0006kb-Dr@shinybook.infradead.org> (sfid-20071210_154543_309765_3F465217)
Date: Mon, 10 Dec 2007 10:45:40 -0500
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Holger Schurig <h.schurig@mn-solutions.de>
Date: Wed, 5 Dec 2007 17:57:58 +0100

There was no code that ever did set this variable.

Signed-off-by: Holger Schurig <hs4233@mail.mn-solutions.de>
Signed-off-by: David Woodhouse <dwmw2@infradead.org>
---
 drivers/net/wireless/libertas/cmd.c     |    1 -
 drivers/net/wireless/libertas/hostcmd.h |    1 -
 2 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/libertas/cmd.c b/drivers/net/wireless/libertas/cmd.c
index 6658590..43dde7e 100644
--- a/drivers/net/wireless/libertas/cmd.c
+++ b/drivers/net/wireless/libertas/cmd.c
@@ -1667,7 +1667,6 @@ static void cleanup_cmdnode(struct cmd_ctrl_node *ptempnode)
 		return;
 	ptempnode->cmdwaitqwoken = 1;
 	wake_up_interruptible(&ptempnode->cmdwait_q);
-	ptempnode->status = 0;
 	ptempnode->wait_option = 0;
 	ptempnode->pdata_buf = NULL;
 
diff --git a/drivers/net/wireless/libertas/hostcmd.h b/drivers/net/wireless/libertas/hostcmd.h
index 217ae12..f096d99 100644
--- a/drivers/net/wireless/libertas/hostcmd.h
+++ b/drivers/net/wireless/libertas/hostcmd.h
@@ -68,7 +68,6 @@ struct rxpd {
 struct cmd_ctrl_node {
 	/* CMD link list */
 	struct list_head list;
-	u32 status;
 	/*CMD wait option: wait for finish or no wait */
 	u16 wait_option;
 	/* command parameter */
-- 
1.5.3.4


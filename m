Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:45582 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753005AbXLJRVu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Dec 2007 12:21:50 -0500
In-Reply-To: <libertas-12345@shinybook.infradead.org>
To: John Linville <linville@tuxdriver.com>
Cc: Dan Williams <dcbw@redhat.com>, libertas-dev@lists.infradead.org,
	linux-wireless@vger.kernel.org
From: David Woodhouse <dwmw2@infradead.org>
Subject: [PATCH 11/48] libertas: Zero 'pdata_size' field in cmd_ctrl_node reliably.
Message-Id: <E1J1kpF-0006l0-Kx@shinybook.infradead.org> (sfid-20071210_172153_240258_969FE31D)
Date: Mon, 10 Dec 2007 10:45:45 -0500
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Date: Thu, 6 Dec 2007 12:37:31 +0000

Otherwise, lbs_process_rx_command() will take the new path for
lbs_cmd() responses, when it shouldn't.

Signed-off-by: David Woodhouse <dwmw2@infradead.org>
---
 drivers/net/wireless/libertas/cmd.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/libertas/cmd.c b/drivers/net/wireless/libertas/cmd.c
index 9064513..4fc3e4b 100644
--- a/drivers/net/wireless/libertas/cmd.c
+++ b/drivers/net/wireless/libertas/cmd.c
@@ -1674,6 +1674,7 @@ static void cleanup_cmdnode(struct cmd_ctrl_node *ptempnode)
 	wake_up_interruptible(&ptempnode->cmdwait_q);
 	ptempnode->wait_option = 0;
 	ptempnode->pdata_buf = NULL;
+	ptempnode->pdata_size = 0;
 
 	if (ptempnode->bufvirtualaddr != NULL)
 		memset(ptempnode->bufvirtualaddr, 0, MRVDRV_SIZE_OF_CMD_BUFFER);
@@ -1701,6 +1702,7 @@ void lbs_set_cmd_ctrl_node(struct lbs_private *priv,
 
 	ptempnode->wait_option = wait_option;
 	ptempnode->pdata_buf = pdata_buf;
+	ptempnode->pdata_size = 0;
 
 	lbs_deb_leave(LBS_DEB_HOST);
 }
-- 
1.5.3.4


Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:32811 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751805AbXLJQvQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Dec 2007 11:51:16 -0500
In-Reply-To: <libertas-12345@shinybook.infradead.org>
To: John Linville <linville@tuxdriver.com>
Cc: Dan Williams <dcbw@redhat.com>, libertas-dev@lists.infradead.org,
	linux-wireless@vger.kernel.org
From: David Woodhouse <dwmw2@infradead.org>
Subject: [PATCH 12/48] libertas: Byteswap cmdptr->size in lbs_cmd()
Message-Id: <E1J1kpG-0006l5-Mo@shinybook.infradead.org> (sfid-20071210_165118_686669_2CDD857F)
Date: Mon, 10 Dec 2007 10:45:46 -0500
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Date: Thu, 6 Dec 2007 12:38:31 +0000

Bad Holger. Always test on big-endian machines, if it's little-endian
you need to be swapping to/from.

Signed-off-by: David Woodhouse <dwmw2@infradead.org>
---
 drivers/net/wireless/libertas/cmd.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/libertas/cmd.c b/drivers/net/wireless/libertas/cmd.c
index 4fc3e4b..7097dcf 100644
--- a/drivers/net/wireless/libertas/cmd.c
+++ b/drivers/net/wireless/libertas/cmd.c
@@ -2072,7 +2072,7 @@ int lbs_cmd(struct lbs_private *priv,
 	/* Set sequence number, clean result, move to buffer */
 	adapter->seqnum++;
 	cmdptr->command = cpu_to_le16(command);
-	cmdptr->size    = cmd_size + S_DS_GEN;
+	cmdptr->size    = cpu_to_le16(cmd_size + S_DS_GEN);
 	cmdptr->seqnum = cpu_to_le16(adapter->seqnum);
 	cmdptr->result = 0;
 	memcpy(cmdptr->cmdresp, cmd, cmd_size);
-- 
1.5.3.4


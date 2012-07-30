Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtaout02-winn.ispmail.ntl.com ([81.103.221.48]:3126 "EHLO
	mtaout02-winn.ispmail.ntl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754895Ab2G3V6Q (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Jul 2012 17:58:16 -0400
From: Daniel Drake <dsd@laptop.org>
To: linville@tuxdriver.com
Cc: libertas-dev@lists.infradead.org, linux-wireless@vger.kernel.org,
	dcbw@redhat.com
Subject: [PATCH] libertas: don't reset card on error when it is being removed
Message-Id: <20120730215804.4BFA89D401E@zog.reactivated.net> (sfid-20120730_235820_384447_12FE842C)
Date: Mon, 30 Jul 2012 22:58:04 +0100 (BST)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On an OLPC XO-1.5 we have seen the following situation:
 - the system starts going into suspend
 - no wake params are set, so the mmc layer removes the card
 - during remove, we send a command to the card
 - that command fails, causing if_sdio's reset method to try and remove
   the mmc card in attempt to reset it
 - the mmc layer is not happy about being asked to remove a card that
   it is already removing, and the kernel crashes

While the MMC layer could possibly be taught to behave better here,
it also seems sensible for libertas not to try and reset a card if
we're in the process of removing it anyway.

Signed-off-by: Daniel Drake <dsd@laptop.org>
---
 drivers/net/wireless/libertas/main.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/libertas/main.c b/drivers/net/wireless/libertas/main.c
index e96ee0a..8d17cac 100644
--- a/drivers/net/wireless/libertas/main.c
+++ b/drivers/net/wireless/libertas/main.c
@@ -565,7 +565,10 @@ static int lbs_thread(void *data)
 			netdev_info(dev, "Timeout submitting command 0x%04x\n",
 				    le16_to_cpu(cmdnode->cmdbuf->command));
 			lbs_complete_command(priv, cmdnode, -ETIMEDOUT);
-			if (priv->reset_card)
+
+			/* Reset card, but only when it isn't in the process
+			 * of being shutdown anyway. */
+			if (!dev->dismantle && priv->reset_card)
 				priv->reset_card(priv);
 		}
 		priv->cmd_timed_out = 0;
-- 
1.7.11.2


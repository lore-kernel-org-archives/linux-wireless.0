Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtaout02-winn.ispmail.ntl.com ([81.103.221.48]:64829 "EHLO
	mtaout02-winn.ispmail.ntl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751404Ab2GOWsF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 15 Jul 2012 18:48:05 -0400
From: Daniel Drake <dsd@laptop.org>
To: dcbw@redhat.com, linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, libertas-dev@lists.infradead.org
Subject: [PATCH 2/3] libertas: handle command failure immediately
Message-Id: <20120715224751.42CD29D401E@zog.reactivated.net> (sfid-20120716_004809_264304_68DFE8C3)
Date: Sun, 15 Jul 2012 23:47:51 +0100 (BST)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Fail commands immediately when the request cannot be sent to the hardware.

This solves the following deadlock:
 1. Two commands are in the queue.
 2. The first command is sent, but causes a timeout, which kicks off an
    asynchronous device reset
 3. The second command is submitted to the device, and fails. The failure
    is noted but the existing code waits for the timeout handler to take
    care of the failure.
 4. The device reset kicks in, causing the device "surprise removed" flag
    to be set as the device disappears from the bus.
 5. lbs_thread notes this and enters "adapter removed; waiting to die"
    mode, without processing any further command timeouts.

While adjusting lbs thread logic to handle this situation may be one way
to fix this, it seems more practical to simplify handling of host_to_card
failure so that the commands are failed immediately without waiting for
more compliated timeout logic to kick in.

Signed-off-by: Daniel Drake <dsd@laptop.org>
---
 drivers/net/wireless/libertas/cmd.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/libertas/cmd.c b/drivers/net/wireless/libertas/cmd.c
index dd0743c..26e6832 100644
--- a/drivers/net/wireless/libertas/cmd.c
+++ b/drivers/net/wireless/libertas/cmd.c
@@ -1020,9 +1020,9 @@ static void lbs_submit_command(struct lbs_private *priv,
 	if (ret) {
 		netdev_info(priv->dev, "DNLD_CMD: hw_host_to_card failed: %d\n",
 			    ret);
-		/* Let the timer kick in and retry, and potentially reset
-		   the whole thing if the condition persists */
-		timeo = HZ/4;
+		/* Reset dnld state machine, report failure */
+		priv->dnld_sent = DNLD_RES_RECEIVED;
+		lbs_complete_command(priv, cmdnode, ret);
 	}
 
 	if (command == CMD_802_11_DEEP_SLEEP) {
-- 
1.7.10.4


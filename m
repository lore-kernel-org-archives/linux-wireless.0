Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtaout01-winn.ispmail.ntl.com ([81.103.221.47]:3079 "EHLO
	mtaout01-winn.ispmail.ntl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751161Ab2GOWsF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 15 Jul 2012 18:48:05 -0400
From: Daniel Drake <dsd@laptop.org>
To: dcbw@redhat.com, linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, libertas-dev@lists.infradead.org
Subject: [PATCH 3/3] libertas USB: don't set surpriseremoved flag
Message-Id: <20120715224801.008E69D401F@zog.reactivated.net> (sfid-20120716_004810_186524_97D79BFE)
Date: Sun, 15 Jul 2012 23:48:00 +0100 (BST)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We found a deadlock in the handling of command failures/reset conditions.
For example:

 1. Two commands are in the queue.
 2. The first command is sent, but causes a timeout, which kicks off an
    asynchronous device reset
 3. The second command is queued (but not yet sent to the hardware)
 4. The device reset kicks in, causing the if_usb disconnect handler to
    set the "surprise removed" flag to be set as the device disappears
    from the bus. This causes lbs_thread to stop processing things
    ("adapter removed; waiting to die"), not processing any further
    commands, leaving the second queued command "in the air", causing a
    deadlock.

Fix this by removing the surpriseremoved flag setting in if_usb. I can't
see any reason why this needs to be done so early. lbs_remove_card will set
this flag at an appropriate time - i.e. after all pending commands have
been completed or cancelled, avoiding this deadlock.

Signed-off-by: Daniel Drake <dsd@laptop.org>
---
 drivers/net/wireless/libertas/if_usb.c |    1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/wireless/libertas/if_usb.c b/drivers/net/wireless/libertas/if_usb.c
index cd3b0d4..92b6885 100644
--- a/drivers/net/wireless/libertas/if_usb.c
+++ b/drivers/net/wireless/libertas/if_usb.c
@@ -309,7 +309,6 @@ static void if_usb_disconnect(struct usb_interface *intf)
 	cardp->surprise_removed = 1;
 
 	if (priv) {
-		priv->surpriseremoved = 1;
 		lbs_stop_card(priv);
 		lbs_remove_card(priv);
 	}
-- 
1.7.10.4


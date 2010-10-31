Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from queueout02-winn.ispmail.ntl.com ([81.103.221.56]:51710 "EHLO
	queueout02-winn.ispmail.ntl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755733Ab0JaOxJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 31 Oct 2010 10:53:09 -0400
From: Daniel Drake <dsd@laptop.org>
To: linville@tuxdriver.com
Cc: dcbw@redhat.com
Cc: linux-wireless@vger.kernel.org
Cc: libertas-dev@lists.infradead.org
Cc: akarwar@marvell.com
Subject: [PATCH] libertas: don't block usb8388 suspend if no wakeup conditions are set
Message-Id: <20101031134012.F21FF9D401B@zog.reactivated.net>
Date: Sun, 31 Oct 2010 13:40:12 +0000 (GMT)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This hunk added by commit 66fceb69b72f seems erroneous. We don't want to
prevent suspend of the whole system if no wakeup params are set.

In the case of the usb8388 we do want to keep the card powered up even
if there are no wakeup params. This is because it will continue acting
as a mesh node.

If the mesh is disabled, it would indeed make more sense to power down
the card during suspend, as the equivalent hunk does for the SD interface.
But that's a separate task; for now just restore the previous behaviour.

Signed-off-by: Daniel Drake <dsd@laptop.org>
---
 drivers/net/wireless/libertas/if_usb.c |    6 ------
 1 files changed, 0 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/libertas/if_usb.c b/drivers/net/wireless/libertas/if_usb.c
index efaf850..35931cf 100644
--- a/drivers/net/wireless/libertas/if_usb.c
+++ b/drivers/net/wireless/libertas/if_usb.c
@@ -1090,12 +1090,6 @@ static int if_usb_suspend(struct usb_interface *intf, pm_message_t message)
 	if (priv->psstate != PS_STATE_FULL_POWER)
 		return -1;
 
-	if (priv->wol_criteria == EHS_REMOVE_WAKEUP) {
-		lbs_pr_info("Suspend attempt without "
-						"configuring wake params!\n");
-		return -ENOSYS;
-	}
-
 	ret = lbs_suspend(priv);
 	if (ret)
 		goto out;
-- 
1.7.2.3


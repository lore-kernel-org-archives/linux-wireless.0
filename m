Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtaout02-winn.ispmail.ntl.com ([81.103.221.48]:61361 "EHLO
	mtaout02-winn.ispmail.ntl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754528Ab1G0QTG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 Jul 2011 12:19:06 -0400
From: Daniel Drake <dsd@laptop.org>
To: linville@tuxdriver.com
To: dcbw@redhat.com
Cc: linux-wireless@vger.kernel.org
Cc: libertas-dev@lists.infradead.org
Subject: [PATCH] libertas_usb: program OLPC EC wakeup mask for wake-on-WLAN
Message-Id: <20110727161900.DE2109D401C@zog.reactivated.net> (sfid-20110727_181910_059862_3B1ECC6C)
Date: Wed, 27 Jul 2011 17:19:00 +0100 (BST)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

OLPC power management code has recently gone upstream. This piece
completes the puzzle for libertas_usb, which now programs the OLPC EC
for wlan wakeups when they have been requested.

Signed-off-by: Daniel Drake <dsd@laptop.org>
---
 drivers/net/wireless/libertas/if_usb.c |    9 +++++++++
 1 files changed, 9 insertions(+), 0 deletions(-)

Depends on some patches that were into Linus's tree yesterday.

diff --git a/drivers/net/wireless/libertas/if_usb.c b/drivers/net/wireless/libertas/if_usb.c
index b5acc39..8f73e80 100644
--- a/drivers/net/wireless/libertas/if_usb.c
+++ b/drivers/net/wireless/libertas/if_usb.c
@@ -1112,6 +1112,15 @@ static int if_usb_suspend(struct usb_interface *intf, pm_message_t message)
 	if (priv->psstate != PS_STATE_FULL_POWER)
 		return -1;
 
+#ifdef CONFIG_OLPC
+	if (machine_is_olpc()) {
+		if (priv->wol_criteria == EHS_REMOVE_WAKEUP)
+			olpc_ec_wakeup_clear(EC_SCI_SRC_WLAN);
+		else
+			olpc_ec_wakeup_set(EC_SCI_SRC_WLAN);
+	}
+#endif
+
 	ret = lbs_suspend(priv);
 	if (ret)
 		goto out;
-- 
1.7.6


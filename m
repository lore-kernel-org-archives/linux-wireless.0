Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtaout01-winn.ispmail.ntl.com ([81.103.221.47]:49721 "EHLO
	mtaout01-winn.ispmail.ntl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753050Ab1GUTns (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Jul 2011 15:43:48 -0400
From: Daniel Drake <dsd@laptop.org>
To: linville@tuxdriver.com
To: dcbw@redhat.com
Cc: linux-wireless@vger.kernel.org
Cc: libertas-dev@lists.infradead.org
Subject: [PATCH] libertas_usb: use USB interface as parent device
Message-Id: <20110721194344.9DDC99D401C@zog.reactivated.net> (sfid-20110721_214351_849179_6CFBC762)
Date: Thu, 21 Jul 2011 20:43:44 +0100 (BST)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Currently, "udevadm info -a -p /sys/class/net/wlan0" doesn't mention
the usb8xxx or libertas driver anywhere. This makes writing udev rules
a bit uncomfortable.

Using the USB interface as the parent device corrects the hierarchy.

Signed-off-by: Daniel Drake <dsd@laptop.org>
---
 drivers/net/wireless/libertas/if_usb.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/libertas/if_usb.c b/drivers/net/wireless/libertas/if_usb.c
index b5acc39..e368b29 100644
--- a/drivers/net/wireless/libertas/if_usb.c
+++ b/drivers/net/wireless/libertas/if_usb.c
@@ -324,7 +324,7 @@ static int if_usb_probe(struct usb_interface *intf,
 	}
 	kparam_unblock_sysfs_write(fw_name);
 
-	if (!(priv = lbs_add_card(cardp, &udev->dev)))
+	if (!(priv = lbs_add_card(cardp, &intf->dev)))
 		goto err_prog_firmware;
 
 	cardp->priv = priv;
-- 
1.7.6


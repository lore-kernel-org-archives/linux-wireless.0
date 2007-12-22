Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from viefep18-int.chello.at ([213.46.255.22]:12599 "EHLO
	viefep14-int.chello.at" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753488AbXLVVve (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 22 Dec 2007 16:51:34 -0500
From: Bjorge Dijkstra <bjd@jooz.net>
To: dbrownell@users.sourceforge.net
Cc: netdev@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: [PATCH 1/8] Fix sparse warning: returning void-valued expression
Date: Sat, 22 Dec 2007 22:51:27 +0100
Message-Id: <11983602952341-git-send-email-bjd@jooz.net> (sfid-20071222_215141_405360_0E2C9AD8)
In-Reply-To: <11983602942818-git-send-email-bjd@jooz.net>
References: <11983602942818-git-send-email-bjd@jooz.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

rndis_unbind and usbnet_cdc_unbind don't return anything.

Signed-off-by: Bjorge Dijkstra <bjd@jooz.net>
---
 drivers/net/usb/rndis_host.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/usb/rndis_host.c b/drivers/net/usb/rndis_host.c
index 1ebe325..96ef6a9 100644
--- a/drivers/net/usb/rndis_host.c
+++ b/drivers/net/usb/rndis_host.c
@@ -585,7 +585,7 @@ static void rndis_unbind(struct usbnet *dev, struct usb_interface *intf)
 		kfree(halt);
 	}
 
-	return usbnet_cdc_unbind(dev, intf);
+	usbnet_cdc_unbind(dev, intf);
 }
 
 /*
-- 
1.5.2.5


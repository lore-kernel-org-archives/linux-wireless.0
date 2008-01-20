Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from pne-smtpout4-sn2.hy.skanova.net ([81.228.8.154]:49048 "EHLO
	pne-smtpout4-sn2.hy.skanova.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752639AbYATANx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 19 Jan 2008 19:13:53 -0500
From: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Subject: [PATCH 01/14] Fix sparse warning: returning void-valued expression
To: linux-wireless@vger.kernel.org
Cc: bjd@jooz.net, dbrownell@users.sourceforge.net,
	netdev@vger.kernel.org
Date: Sun, 20 Jan 2008 02:13:48 +0200
Message-ID: <20080120001348.25718.36756.stgit@fate.lan> (sfid-20080120_001358_229021_70305BAB)
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Bjorge Dijkstra <bjd@jooz.net>

rndis_unbind and usbnet_cdc_unbind don't return anything.

Signed-off-by: Bjorge Dijkstra <bjd@jooz.net>
Signed-off-by: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
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


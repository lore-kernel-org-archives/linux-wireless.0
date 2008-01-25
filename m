Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from pne-smtpout4-sn1.fre.skanova.net ([81.228.11.168]:60270 "EHLO
	pne-smtpout4-sn1.fre.skanova.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753789AbYAYWuq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 25 Jan 2008 17:50:46 -0500
From: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Subject: [PATCH 01/14] Fix sparse warning: returning void-valued expression
To: linux-wireless@vger.kernel.org
Cc: netdev@vger.kernel.org, bjd@jooz.net, david-b@pacbell.net
Date: Sat, 26 Jan 2008 00:50:38 +0200
Message-ID: <20080125225038.11716.27071.stgit@fate.lan> (sfid-20080125_225052_492517_8430066C)
In-Reply-To: <20080125225032.11716.77713.stgit@fate.lan>
References: <20080125225032.11716.77713.stgit@fate.lan>
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


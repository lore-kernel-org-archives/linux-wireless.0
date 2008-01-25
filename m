Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from pne-smtpout3-sn2.hy.skanova.net ([81.228.8.111]:58374 "EHLO
	pne-smtpout3-sn2.hy.skanova.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757179AbYAYWvE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 25 Jan 2008 17:51:04 -0500
From: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Subject: [PATCH 04/14] [rndis_host] Halt device if rndis_bind fails.
To: linux-wireless@vger.kernel.org
Cc: netdev@vger.kernel.org, bjd@jooz.net, david-b@pacbell.net
Date: Sat, 26 Jan 2008 00:50:55 +0200
Message-ID: <20080125225055.11716.51265.stgit@fate.lan> (sfid-20080125_225124_932837_997D9364)
In-Reply-To: <20080125225032.11716.77713.stgit@fate.lan>
References: <20080125225032.11716.77713.stgit@fate.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When bind fails after device was initialized, shutdown device properly
by sending RNDIS_MSG_HALT.

Signed-off-by: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Signed-off-by: Bjorge Dijkstra <bjd@jooz.net>
---

 drivers/net/usb/rndis_host.c |   12 +++++++++---
 1 files changed, 9 insertions(+), 3 deletions(-)

diff --git a/drivers/net/usb/rndis_host.c b/drivers/net/usb/rndis_host.c
index 42b161c..c686025 100644
--- a/drivers/net/usb/rndis_host.c
+++ b/drivers/net/usb/rndis_host.c
@@ -467,6 +467,7 @@ static int rndis_bind(struct usbnet *dev, struct usb_interface *intf)
 		struct rndis_query_c	*get_c;
 		struct rndis_set	*set;
 		struct rndis_set_c	*set_c;
+		struct rndis_halt	*halt;
 	} u;
 	u32			tmp;
 	int			reply_len;
@@ -517,7 +518,7 @@ static int rndis_bind(struct usbnet *dev, struct usb_interface *intf)
 				"dev can't take %u byte packets (max %u)\n",
 				dev->hard_mtu, tmp);
 			retval = -EINVAL;
-			goto fail_and_release;
+			goto halt_fail_and_release;
 		}
 		dev->hard_mtu = tmp;
 		net->mtu = dev->hard_mtu - net->hard_header_len;
@@ -539,7 +540,7 @@ static int rndis_bind(struct usbnet *dev, struct usb_interface *intf)
 			48, (void **) &bp, &reply_len);
 	if (unlikely(retval< 0)) {
 		dev_err(&intf->dev, "rndis get ethaddr, %d\n", retval);
-		goto fail_and_release;
+		goto halt_fail_and_release;
 	}
 	memcpy(net->dev_addr, bp, ETH_ALEN);
 
@@ -555,7 +556,7 @@ static int rndis_bind(struct usbnet *dev, struct usb_interface *intf)
 	retval = rndis_command(dev, u.header);
 	if (unlikely(retval < 0)) {
 		dev_err(&intf->dev, "rndis set packet filter, %d\n", retval);
-		goto fail_and_release;
+		goto halt_fail_and_release;
 	}
 
 	retval = 0;
@@ -563,6 +564,11 @@ static int rndis_bind(struct usbnet *dev, struct usb_interface *intf)
 	kfree(u.buf);
 	return retval;
 
+halt_fail_and_release:
+	memset(u.halt, 0, sizeof *u.halt);
+	u.halt->msg_type = RNDIS_MSG_HALT;
+	u.halt->msg_len = ccpu2(sizeof *u.halt);
+	(void) rndis_command(dev, (void *)u.halt);
 fail_and_release:
 	usb_set_intfdata(info->data, NULL);
 	usb_driver_release_interface(driver_of(intf), info->data);


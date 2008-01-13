Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mfe1.polimi.it ([131.175.12.23]:52692 "EHLO polimi.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753325AbYAMSyu (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 13 Jan 2008 13:54:50 -0500
Date: Sun, 13 Jan 2008 19:48:34 +0100
From: Stefano Brivio <stefano.brivio@polimi.it>
To: "John W. Linville" <linville@tuxdriver.com>,
	rt2400-devel@lists.sourceforge.net
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH] rt2x00: remove unused variable
Message-ID: <20080113194834.677af663@morte> (sfid-20080113_185454_458346_9B1981C1)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Remove an unused variable that caused a warning while building. Please note
that the pipe obtained there isn't used anywhere else.

Signed-off-by: Stefano Brivio <stefano.brivio@polimi.it>
---
Index: wireless-2.6/drivers/net/wireless/rt2x00/rt2x00usb.c
===================================================================
--- wireless-2.6.orig/drivers/net/wireless/rt2x00/rt2x00usb.c
+++ wireless-2.6/drivers/net/wireless/rt2x00/rt2x00usb.c
@@ -176,7 +176,6 @@ int rt2x00usb_write_tx_data(struct rt2x0
 	struct usb_device *usb_dev =
 	    interface_to_usbdev(rt2x00dev_usb(rt2x00dev));
 	struct data_entry *entry = rt2x00_get_data_entry(ring);
-	int pipe = usb_sndbulkpipe(usb_dev, 1);
 	struct skb_desc *desc;
 	u32 length;
 


--
Ciao
Stefano

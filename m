Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from MGW3.Sony.CO.JP ([137.153.0.15]:39031 "EHLO mgw3.sony.co.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754004AbYBVHqS (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Feb 2008 02:46:18 -0500
Received: from mail37.sony.co.jp (localhost [127.0.0.1])
	by mail37.sony.co.jp (R8/Sony) with ESMTP id m1M7jQL4010949
	for <linux-wireless@vger.kernel.org>; Fri, 22 Feb 2008 16:45:27 +0900 (JST)
Received: from smail1.sm.sony.co.jp (smail1.sm.sony.co.jp [43.11.253.1])
	by mail37.sony.co.jp (R8/Sony) with ESMTP id m1M7jQNY010937
	for <linux-wireless@vger.kernel.org>; Fri, 22 Feb 2008 16:45:26 +0900 (JST)
Received: from imail.sm.sony.co.jp (imail.sm.sony.co.jp [43.4.141.32]) by smail1.sm.sony.co.jp (8.11.6p2/8.11.6) with ESMTP id m1M7jQP23705 for <linux-wireless@vger.kernel.org>; Fri, 22 Feb 2008 16:45:26 +0900 (JST)
Received: from [43.4.146.40] (bluenote.sm.sony.co.jp [43.4.146.40])
	by imail.sm.sony.co.jp (8.12.11/3.7W) with ESMTP id m1M7jQbd015686
	for <linux-wireless@vger.kernel.org>; Fri, 22 Feb 2008 16:45:26 +0900 (JST)
Date: Fri, 22 Feb 2008 16:45:26 +0900
From: Masakazu Mokuno <mokuno@sm.sony.co.jp>
To: linux-wireless@vger.kernel.org
Subject: [PATCH] PS3: gelic: Link the wireless net_device structure to the corresponding device structure
Message-Id: <20080222163604.CFC0.40F06B3A@sm.sony.co.jp> (sfid-20080222_074630_846188_6D101D44)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Link the net_device structure of the wireless part to the
corresponding device structure.  

Without this, the sysfs node for this net_device would not have
'device' link.

Signed-off-by: Masakazu Mokuno <mokuno@sm.sony.co.jp>
---
 drivers/net/ps3_gelic_wireless.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/net/ps3_gelic_wireless.c
+++ b/drivers/net/ps3_gelic_wireless.c
@@ -2690,6 +2690,7 @@ int gelic_wl_driver_probe(struct gelic_c
 		return -ENOMEM;
 
 	/* setup net_device structure */
+	SET_NETDEV_DEV(netdev, &card->dev->core);
 	gelic_wl_setup_netdev_ops(netdev);
 
 	/* setup some of net_device and register it */

-- 
Masakazu MOKUNO


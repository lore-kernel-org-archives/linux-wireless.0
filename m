Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.27]:47777 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752626AbZGYMXJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 25 Jul 2009 08:23:09 -0400
Received: by ey-out-2122.google.com with SMTP id 9so595782eyd.37
        for <linux-wireless@vger.kernel.org>; Sat, 25 Jul 2009 05:23:08 -0700 (PDT)
Date: Sat, 25 Jul 2009 15:22:59 +0300 (EAT)
From: Dan Carpenter <error27@gmail.com>
To: samuel.ortiz@intel.com, yi.zhu@intel.com
cc: linux-wireless@vger.kernel.org
Subject: [patch] wireless: ERR_PTR vs null
Message-ID: <alpine.DEB.2.00.0907241000250.11771@bicker>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

iwm_wdev_alloc() returns an ERR_PTR on failure and not null.  It also 
prints its own dev_err() message so I removed that as well.

Compile tested only.  Sorry.  
Found by smatch (http://repo.or.cz/w/smatch.git).

regards,
dan carpenter

Signed-off-by: Dan Carpenter <error27@gmail.com>

--- orig/drivers/net/wireless/iwmc3200wifi/netdev.c	2009-07-24 09:56:49.000000000 +0300
+++ devel/drivers/net/wireless/iwmc3200wifi/netdev.c	2009-07-24 09:57:31.000000000 +0300
@@ -106,10 +106,8 @@
 	int ret = 0;
 
 	wdev = iwm_wdev_alloc(sizeof_bus, dev);
-	if (!wdev) {
-		dev_err(dev, "no memory for wireless device instance\n");
-		return ERR_PTR(-ENOMEM);
-	}
+	if (IS_ERR(wdev))
+		return wdev;
 
 	iwm = wdev_to_iwm(wdev);
 	iwm->bus_ops = if_ops;

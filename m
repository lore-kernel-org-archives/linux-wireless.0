Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yx0-f184.google.com ([209.85.210.184]:49145 "EHLO
	mail-yx0-f184.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753582AbZGSMwH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 19 Jul 2009 08:52:07 -0400
Received: by mail-yx0-f184.google.com with SMTP id 14so2912186yxe.33
        for <linux-wireless@vger.kernel.org>; Sun, 19 Jul 2009 05:52:07 -0700 (PDT)
Date: Sun, 19 Jul 2009 14:53:57 +0300 (EAT)
From: Dan Carpenter <error27@gmail.com>
To: flamingice@sourmilk.net
cc: linux-wireless@vger.kernel.org
Subject: [patch] wireless: potential null deref in p54spi.c
Message-ID: <alpine.DEB.2.00.0907171607280.12306@bicker>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We can't use dev_err() becuase "priv" is NULL.

Found by smatch (http://repo.or.cz/w/smatch.git).

regards,
dan carpenter

Signed-off-by: Dan Carpenter <error27@gmail.com>

--- orig/drivers/net/wireless/p54/p54spi.c	2009-07-17 16:04:20.000000000 +0300
+++ new/drivers/net/wireless/p54/p54spi.c	2009-07-17 16:05:28.000000000 +0300
@@ -635,7 +635,7 @@
 
 	hw = p54_init_common(sizeof(*priv));
 	if (!hw) {
-		dev_err(&priv->spi->dev, "could not alloc ieee80211_hw");
+		printk(KERN_ERR "could not alloc ieee80211_hw");
 		return -ENOMEM;
 	}
 

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.170]:7883 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756528AbYFAX17 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 1 Jun 2008 19:27:59 -0400
Received: by wf-out-1314.google.com with SMTP id 27so628289wfd.4
        for <linux-wireless@vger.kernel.org>; Sun, 01 Jun 2008 16:27:59 -0700 (PDT)
Message-Id: <20080601231543.372911291@gmail.com> (sfid-20080602_012818_462285_D822534A)
References: <20080601231329.223608711@gmail.com>
Date: Mon, 02 Jun 2008 08:13:40 +0900
From: akinobu.mita@gmail.com
To: linux-kernel@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
	netdev@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: [patch -v2 11/23] airo: use simple_read_from_buffer
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: John W. Linville <linville@tuxdriver.com>
Cc: netdev@vger.kernel.org
Cc: linux-wireless@vger.kernel.org
---
 drivers/net/wireless/airo.c |   15 +++------------
 1 file changed, 3 insertions(+), 12 deletions(-)

Index: 2.6-git/drivers/net/wireless/airo.c
===================================================================
--- 2.6-git.orig/drivers/net/wireless/airo.c
+++ 2.6-git/drivers/net/wireless/airo.c
@@ -4560,22 +4560,13 @@ static ssize_t proc_read( struct file *f
 			  size_t len,
 			  loff_t *offset )
 {
-	loff_t pos = *offset;
-	struct proc_data *priv = (struct proc_data*)file->private_data;
+	struct proc_data *priv = file->private_data;
 
 	if (!priv->rbuffer)
 		return -EINVAL;
 
-	if (pos < 0)
-		return -EINVAL;
-	if (pos >= priv->readlen)
-		return 0;
-	if (len > priv->readlen - pos)
-		len = priv->readlen - pos;
-	if (copy_to_user(buffer, priv->rbuffer + pos, len))
-		return -EFAULT;
-	*offset = pos + len;
-	return len;
+	return simple_read_from_buffer(buffer, len, offset, priv->rbuffer,
+					priv->readlen);
 }
 
 /*

-- 

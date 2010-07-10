Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:40313 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751511Ab0GJIzM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 10 Jul 2010 04:55:12 -0400
Date: Sat, 10 Jul 2010 10:53:38 +0200
From: Dan Carpenter <error27@gmail.com>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	=?iso-8859-1?Q?Andr=E9?= Goddard Rosa <andre.goddard@gmail.com>,
	Jiri Kosina <jkosina@suse.cz>, linux-wireless@vger.kernel.org,
	kernel-janitors@vger.kernel.org
Subject: [patch] prism54: call BUG_ON() earlier
Message-ID: <20100710085338.GQ19184@bicker>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This test is off by one because strlen() doesn't include the NULL
terminator.

Signed-off-by: Dan Carpenter <error27@gmail.com>

diff --git a/drivers/net/wireless/prism54/isl_ioctl.c b/drivers/net/wireless/prism54/isl_ioctl.c
index 8d1190c..1051268 100644
--- a/drivers/net/wireless/prism54/isl_ioctl.c
+++ b/drivers/net/wireless/prism54/isl_ioctl.c
@@ -2067,7 +2067,7 @@ send_simple_event(islpci_private *priv, const char *str)
 	memptr = kmalloc(IW_CUSTOM_MAX, GFP_KERNEL);
 	if (!memptr)
 		return;
-	BUG_ON(n > IW_CUSTOM_MAX);
+	BUG_ON(n >= IW_CUSTOM_MAX);
 	wrqu.data.pointer = memptr;
 	wrqu.data.length = n;
 	strcpy(memptr, str);

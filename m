Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:60320 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756145AbZKWK1g (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Nov 2009 05:27:36 -0500
Subject: [PATCH 2.6.32] rfkill: fix miscdev ops
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: Maxim Levitsky <maximlevitsky@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1258968499.3271.5.camel@maxim-laptop>
References: <1258968499.3271.5.camel@maxim-laptop>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 23 Nov 2009 11:27:30 +0100
Message-ID: <1258972050.7094.140.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The /dev/rfkill ops don't refer to the module,
so it is possible to unload the module while
file descriptors are open. Fix this oversight.

Reported-by: Maxim Levitsky <maximlevitsky@gmail.com>
Cc: stable@kernel.org
Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 net/rfkill/core.c |    1 +
 1 file changed, 1 insertion(+)

--- wireless-testing.orig/net/rfkill/core.c	2009-11-23 11:11:13.000000000 +0100
+++ wireless-testing/net/rfkill/core.c	2009-11-23 11:11:59.000000000 +0100
@@ -1191,6 +1191,7 @@ static long rfkill_fop_ioctl(struct file
 #endif
 
 static const struct file_operations rfkill_fops = {
+	.owner		= THIS_MODULE,
 	.open		= rfkill_fop_open,
 	.read		= rfkill_fop_read,
 	.write		= rfkill_fop_write,



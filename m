Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:33106 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755208Ab0IPWit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Sep 2010 18:38:49 -0400
Subject: [PATCH] wext: fix potential private ioctl memory content leak
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: Jeff Mahoney <jeffm@suse.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 17 Sep 2010 00:38:25 +0200
Message-ID: <1284676705.3731.16.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

When a driver doesn't fill the entire buffer, old
heap contents may remain, and if it also doesn't
update the length properly, this old heap content
will be copied back to userspace.

It is very unlikely that this happens in any of
the drivers using private ioctls since it would
show up as junk being reported by iwpriv, but it
seems better to be safe here, so use kzalloc.

Reported-by: Jeff Mahoney <jeffm@suse.com>
Cc: stable@kernel.org
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/wireless/wext-priv.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- wireless-testing.orig/net/wireless/wext-priv.c	2010-09-17 00:32:34.000000000 +0200
+++ wireless-testing/net/wireless/wext-priv.c	2010-09-17 00:32:43.000000000 +0200
@@ -152,7 +152,7 @@ static int ioctl_private_iw_point(struct
 	} else if (!iwp->pointer)
 		return -EFAULT;
 
-	extra = kmalloc(extra_size, GFP_KERNEL);
+	extra = kzalloc(extra_size, GFP_KERNEL);
 	if (!extra)
 		return -ENOMEM;
 



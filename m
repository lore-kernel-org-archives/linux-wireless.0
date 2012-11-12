Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:49658 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753769Ab2KLV67 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Nov 2012 16:58:59 -0500
Received: by mail-ee0-f46.google.com with SMTP id b15so3644080eek.19
        for <linux-wireless@vger.kernel.org>; Mon, 12 Nov 2012 13:58:58 -0800 (PST)
From: Maxim Mikityanskiy <maxtram95@gmail.com>
To: greg@kroah.com, linux-wireless@vger.kernel.org
Cc: Maxim Mikityanskiy <maxtram95@gmail.com>
Subject: [PATCH 06/17] Fix oops when rmmoding
Date: Mon, 12 Nov 2012 23:58:20 +0200
Message-Id: <1352757511-26957-7-git-send-email-maxtram95@gmail.com> (sfid-20121112_225904_085861_F9B736FA)
In-Reply-To: <1352757511-26957-1-git-send-email-maxtram95@gmail.com>
References: <1352757511-26957-1-git-send-email-maxtram95@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Signed-off-by: Maxim Mikityanskiy <maxtram95@gmail.com>
---
 r8180_core.c |    1 -
 1 file changed, 1 deletion(-)

diff --git a/r8180_core.c b/r8180_core.c
index d903786..e04bb04 100644
--- a/r8180_core.c
+++ b/r8180_core.c
@@ -323,7 +323,6 @@ void rtl8180_proc_remove_one(struct net_device *dev)
 		remove_proc_entry("stats-tx", priv->dir_dev);
 		remove_proc_entry("stats-rx", priv->dir_dev);
 		remove_proc_entry("registers", priv->dir_dev);
-		remove_proc_entry(dev->name, rtl8180_proc);
 		priv->dir_dev = NULL;
 	}
 }
-- 
1.7.10.4


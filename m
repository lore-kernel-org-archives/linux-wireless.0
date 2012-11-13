Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:54986 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755393Ab2KMR3A (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Nov 2012 12:29:00 -0500
Received: by mail-ee0-f46.google.com with SMTP id b15so4133183eek.19
        for <linux-wireless@vger.kernel.org>; Tue, 13 Nov 2012 09:28:59 -0800 (PST)
From: Maxim Mikityanskiy <maxtram95@gmail.com>
To: greg@kroah.com, Larry.Finger@lwfinger.net,
	linux-wireless@vger.kernel.org
Cc: Maxim Mikityanskiy <maxtram95@gmail.com>
Subject: [PATCH 06/17] staging: rtl8187se: Fixed oops when rmmoding
Date: Tue, 13 Nov 2012 19:28:12 +0200
Message-Id: <1352827703-4659-7-git-send-email-maxtram95@gmail.com> (sfid-20121113_182904_466948_AA08708C)
In-Reply-To: <1352827703-4659-1-git-send-email-maxtram95@gmail.com>
References: <1352827703-4659-1-git-send-email-maxtram95@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Don't remove procfs entry that is never created

Signed-off-by: Maxim Mikityanskiy <maxtram95@gmail.com>
---
 drivers/staging/rtl8187se/r8180_core.c |    1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/staging/rtl8187se/r8180_core.c b/drivers/staging/rtl8187se/r8180_core.c
index 6ec3a93..8139f26 100644
--- a/drivers/staging/rtl8187se/r8180_core.c
+++ b/drivers/staging/rtl8187se/r8180_core.c
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


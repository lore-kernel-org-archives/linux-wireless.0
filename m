Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:46927 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751085Ab2E3WzS (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 May 2012 18:55:18 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: mcgrof@gmail.com
Cc: lf_driver_backport@lists.linux-foundation.org,
	linux-wireless@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH] compat-wireless: fix syntax error introduced recently
Date: Thu, 31 May 2012 00:55:10 +0200
Message-Id: <1338418510-4970-1-git-send-email-hauke@hauke-m.de> (sfid-20120531_005523_179358_CEF689D7)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

A closing parenthesis was accentually removed in this commit:
ommit 86596a46269e9b317ef3ee92f21453320d855018
Author: Luis R. Rodriguez <mcgrof@frijolero.org>
Date:   Tue May 29 12:50:42 2012 -0700

    compat-wireless: fix patches/24-pcmcia.patch for next-20120524

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 patches/24-pcmcia.patch |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/patches/24-pcmcia.patch b/patches/24-pcmcia.patch
index 7e6c16e..5fcdc94 100644
--- a/patches/24-pcmcia.patch
+++ b/patches/24-pcmcia.patch
@@ -29,7 +29,7 @@
  	}
  
  	do {
-+#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,36)
++#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,36))
  		unsigned int iobase = info->p_dev->resource[0]->start;
 +#else
 +		unsigned int iobase = info->p_dev->io.BasePort1;
-- 
1.7.9.5


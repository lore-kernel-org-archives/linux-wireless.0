Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:59757 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757158Ab0GRTJa (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 18 Jul 2010 15:09:30 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: lrodriguez@atheros.com
Cc: linux-wireless@vger.kernel.org, mcgrof@infradead.org,
	Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH] compat: fix build if CONFIG_PCCARD=y and CONFIG_PCMCIA=n
Date: Sun, 18 Jul 2010 21:09:22 +0200
Message-Id: <1279480162-20673-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The includes are needed for pccard_loop_tuple.

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 include/linux/compat-2.6.33.h |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/include/linux/compat-2.6.33.h b/include/linux/compat-2.6.33.h
index 0b434fc..e4dff72 100644
--- a/include/linux/compat-2.6.33.h
+++ b/include/linux/compat-2.6.33.h
@@ -7,12 +7,10 @@
 
 #include <linux/skbuff.h>
 #if defined(CONFIG_PCCARD) || defined(CONFIG_PCCARD_MODULE)
-#if defined(CONFIG_PCMCIA) || defined(CONFIG_PCMCIA_MODULE)
 #include <pcmcia/cs_types.h>
 #include <pcmcia/cistpl.h>
 #include <pcmcia/ds.h>
 #endif
-#endif
 #include <linux/kfifo.h>
 #include <linux/firmware.h>
 
-- 
1.7.0.4


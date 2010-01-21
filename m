Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:58989 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753519Ab0AUTdG (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Jan 2010 14:33:06 -0500
From: Hauke Mehrtens <hauke@hauke-m.de>
To: lrodriguez@atheros.com
Cc: linux-wireless@vger.kernel.org, linux-bluetooth@vger.kernel.org,
	awozniak@irobot.com, mcgrof@infradead.org,
	Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH] compat: fix build on arm
Date: Thu, 21 Jan 2010 20:32:48 +0100
Message-Id: <1264102368-8918-1-git-send-email-hauke@hauke-m.de>
In-Reply-To: <43e72e891001211012y4f4c8721t7eb9e0eea0221820@mail.gmail.com>
References: <43e72e891001211012y4f4c8721t7eb9e0eea0221820@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

ARM does not provided the include file asm/compat.h. Use linux/compat.h
instead, it includes asm/compat.h if needed.
This patch is from OpenWRT:
https://dev.openwrt.org/browser/trunk/package/mac80211/patches/020-fix_compat_h.patch?rev=19063

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 include/linux/compat-2.6.32.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/linux/compat-2.6.32.h b/include/linux/compat-2.6.32.h
index c3e4dbe..11060d8 100644
--- a/include/linux/compat-2.6.32.h
+++ b/include/linux/compat-2.6.32.h
@@ -6,7 +6,7 @@
 #if (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,32))
 
 #include <linux/netdevice.h>
-#include <asm/compat.h>
+#include <linux/compat.h>
 #include <net/iw_handler.h>
 #include <linux/workqueue.h>
 
-- 
1.6.3.3


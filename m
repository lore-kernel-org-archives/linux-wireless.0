Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:35608 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755503AbZKHW1Z (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 8 Nov 2009 17:27:25 -0500
From: Hauke Mehrtens <hauke@hauke-m.de>
To: lrodriguez@atheros.com
Cc: linux-wireless@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>,
	philipp_subx@redfish-solutions.com
Subject: [PATCH 1/4] Fix build problem, missing get_unaligned_le16
Date: Sun,  8 Nov 2009 23:27:08 +0100
Message-Id: <1257719231-2031-2-git-send-email-hauke@hauke-m.de>
In-Reply-To: <1257719231-2031-1-git-send-email-hauke@hauke-m.de>
References: <1257719231-2031-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch fixes the "implicit declaration of function
'get_unaligned_le16'" in drivers/net/wireless/libertas/assoc.c

CC: philipp_subx@redfish-solutions.com
Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 compat/patches/06-header-changes.patch |   12 ++++++++++++
 1 files changed, 12 insertions(+), 0 deletions(-)

diff --git a/compat/patches/06-header-changes.patch b/compat/patches/06-header-changes.patch
index ee0be7f..14e544a 100644
--- a/compat/patches/06-header-changes.patch
+++ b/compat/patches/06-header-changes.patch
@@ -16,6 +16,18 @@ cases.
  
  struct b43_wldev;
  
+--- a/drivers/net/wireless/libertas/assoc.c
++++ b/drivers/net/wireless/libertas/assoc.c
+@@ -5,6 +5,9 @@
+ #include <linux/ieee80211.h>
+ #include <linux/if_arp.h>
+ #include <net/lib80211.h>
++#if (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,29))
++#include <asm/unaligned.h>
++#endif
+ 
+ #include "assoc.h"
+ #include "decl.h"
 --- a/drivers/net/wireless/wl12xx/wl1251_main.c	2009-08-07 11:42:12.532495607 -0700
 +++ b/drivers/net/wireless/wl12xx/wl1251_main.c	2009-08-07 12:08:31.167548696 -0700
 @@ -26,6 +26,9 @@
-- 
1.6.3.3


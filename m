Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:42134 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752635Ab0H0SlP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Aug 2010 14:41:15 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: lrodriguez@atheros.com
Cc: linux-wireless@vger.kernel.org, mcgrof@infradead.org,
	Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 3/7] compat-wireless: remove linux/gpio.h include
Date: Fri, 27 Aug 2010 20:40:49 +0200
Message-Id: <1282934453-18093-4-git-send-email-hauke@hauke-m.de>
In-Reply-To: <1282934453-18093-1-git-send-email-hauke@hauke-m.de>
References: <1282934453-18093-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Kernel 2.6.24 does not have this header file. No method provided by
gpio.h is used in wl12*1_boot.c so this include looks unneeded to me.
This should probably also go into mainline.

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 patches/06-header-changes.patch |   24 ++++++++++++++++++++++--
 1 files changed, 22 insertions(+), 2 deletions(-)

diff --git a/patches/06-header-changes.patch b/patches/06-header-changes.patch
index e0846f5..17c4465 100644
--- a/patches/06-header-changes.patch
+++ b/patches/06-header-changes.patch
@@ -16,9 +16,19 @@ cases.
  
  struct b43_wldev;
  
+--- a/drivers/net/wireless/wl12xx/wl1251_boot.c
++++ b/drivers/net/wireless/wl12xx/wl1251_boot.c
+@@ -19,7 +19,6 @@
+  *
+  */
+ 
+-#include <linux/gpio.h>
+ #include <linux/slab.h>
+ 
+ #include "wl1251_reg.h"
 --- a/drivers/net/wireless/wl12xx/wl1251_main.c
 +++ b/drivers/net/wireless/wl12xx/wl1251_main.c
-@@ -26,6 +26,9 @@
+@@ -24,6 +24,9 @@
  #include <linux/firmware.h>
  #include <linux/delay.h>
  #include <linux/irq.h>
@@ -30,7 +40,7 @@ cases.
  #include <linux/vmalloc.h>
 --- a/drivers/net/wireless/wl12xx/wl1251_spi.c
 +++ b/drivers/net/wireless/wl12xx/wl1251_spi.c
-@@ -25,6 +25,9 @@
+@@ -23,6 +23,9 @@
  #include <linux/module.h>
  #include <linux/slab.h>
  #include <linux/crc7.h>
@@ -40,6 +50,16 @@ cases.
  #include <linux/spi/spi.h>
  #include <linux/spi/wl12xx.h>
  
+--- a/drivers/net/wireless/wl12xx/wl1271_boot.c
++++ b/drivers/net/wireless/wl12xx/wl1271_boot.c
+@@ -21,7 +21,6 @@
+  *
+  */
+ 
+-#include <linux/gpio.h>
+ #include <linux/slab.h>
+ 
+ #include "wl1271_acx.h"
 --- a/net/mac80211/key.c
 +++ b/net/mac80211/key.c
 @@ -22,6 +22,9 @@
-- 
1.7.0.4


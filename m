Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:58841 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753457Ab1EVKr4 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 22 May 2011 06:47:56 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: mcgrof@gmail.com, lrodriguez@atheros.com
Cc: linux-wireless@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 1/3] Revert "compat-wireless: fix rfkill patches from applying"
Date: Sun, 22 May 2011 12:47:05 +0200
Message-Id: <1306061227-4159-1-git-send-email-hauke@hauke-m.de> (sfid-20110522_124759_883780_DEBD59E9)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The commit was removed from linux-next, so this backport patch should also be removed.

This reverts commit b8e46e19937710d2ae14731871cf8c45a0fc9d74.

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 config.mk                   |    1 +
 defconfigs/atheros-debug.mk |    1 +
 patches/03-rfkill.patch     |   18 +++++++++++++++---
 3 files changed, 17 insertions(+), 3 deletions(-)

diff --git a/config.mk b/config.mk
index ce67176..99485a4 100644
--- a/config.mk
+++ b/config.mk
@@ -626,5 +626,6 @@ CONFIG_RFKILL_BACKPORT=m
 ifdef CONFIG_LEDS_TRIGGERS
 CONFIG_RFKILL_BACKPORT_LEDS=y
 endif #CONFIG_LEDS_TRIGGERS
+CONFIG_RFKILL_BACKPORT_INPUT=y
 endif #CONFIG_COMPAT_KERNEL_31
 
diff --git a/defconfigs/atheros-debug.mk b/defconfigs/atheros-debug.mk
index 8850df5..d9534eb 100644
--- a/defconfigs/atheros-debug.mk
+++ b/defconfigs/atheros-debug.mk
@@ -587,5 +587,6 @@ endif #CONFIG_COMPAT_KERNEL_27
 ifdef CONFIG_COMPAT_KERNEL_31
 CONFIG_RFKILL_BACKPORT=m
 CONFIG_RFKILL_BACKPORT_LEDS=y
+CONFIG_RFKILL_BACKPORT_INPUT=y
 endif #CONFIG_COMPAT_KERNEL_31
 
diff --git a/patches/03-rfkill.patch b/patches/03-rfkill.patch
index e623a35..a13dd9a 100644
--- a/patches/03-rfkill.patch
+++ b/patches/03-rfkill.patch
@@ -35,11 +35,23 @@ This would do the policing from within mac80211.
  #
  
 -rfkill-y			+= core.o
+-rfkill-$(CONFIG_RFKILL_INPUT)	+= input.o
 -obj-$(CONFIG_RFKILL)		+= rfkill.o
-+rfkill_backport-y 		+= core.o
-+obj-$(CONFIG_RFKILL_BACKPORT)	+= rfkill_backport.o
++rfkill_backport-y			+= core.o
++rfkill_backport-$(CONFIG_RFKILL_BACKPORT_INPUT)	+= input.o
++obj-$(CONFIG_RFKILL_BACKPORT)		+= rfkill_backport.o
  obj-$(CONFIG_RFKILL_REGULATOR)	+= rfkill-regulator.o
- obj-$(CONFIG_RFKILL_GPIO)	+= rfkill-gpio.o
+--- a/net/rfkill/input.c
++++ b/net/rfkill/input.c
+@@ -232,7 +232,7 @@ static int rfkill_connect(struct input_h
+ 
+ 	handle->dev = dev;
+ 	handle->handler = handler;
+-	handle->name = "rfkill";
++	handle->name = "rfkill_backport";
+ 
+ 	/* causes rfkill_start() to be called */
+ 	error = input_register_handle(handle);
 --- a/net/rfkill/core.c
 +++ b/net/rfkill/core.c
 @@ -658,7 +658,7 @@ static int rfkill_resume(struct device *
-- 
1.7.4.1


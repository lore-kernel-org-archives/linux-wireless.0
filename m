Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50494 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935353AbYCDX1u (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Mar 2008 18:27:50 -0500
Message-Id: <200803042326.m24NQ6jm003261@imap1.linux-foundation.org> (sfid-20080304_232755_016107_EF721C90)
Subject: [patch 01/10] make b43_mac_{enable,suspend}() static
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, akpm@linux-foundation.org,
	bunk@kernel.org, mb@bu3sch.de
From: akpm@linux-foundation.org
Date: Tue, 04 Mar 2008 15:26:06 -0800
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Adrian Bunk <bunk@kernel.org>

b43_mac_{enable,suspend}() can now become static.

Signed-off-by: Adrian Bunk <bunk@kernel.org>
Acked-by: Michael Buesch <mb@bu3sch.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/wireless/b43/main.c |    4 ++--
 drivers/net/wireless/b43/main.h |    3 ---
 2 files changed, 2 insertions(+), 5 deletions(-)

diff -puN drivers/net/wireless/b43/main.c~make-b43_mac_enablesuspend-static drivers/net/wireless/b43/main.c
--- a/drivers/net/wireless/b43/main.c~make-b43_mac_enablesuspend-static
+++ a/drivers/net/wireless/b43/main.c
@@ -2043,7 +2043,7 @@ static void b43_gpio_cleanup(struct b43_
 }
 
 /* http://bcm-specs.sipsolutions.net/EnableMac */
-void b43_mac_enable(struct b43_wldev *dev)
+static void b43_mac_enable(struct b43_wldev *dev)
 {
 	dev->mac_suspended--;
 	B43_WARN_ON(dev->mac_suspended < 0);
@@ -2067,7 +2067,7 @@ void b43_mac_enable(struct b43_wldev *de
 }
 
 /* http://bcm-specs.sipsolutions.net/SuspendMAC */
-void b43_mac_suspend(struct b43_wldev *dev)
+static void b43_mac_suspend(struct b43_wldev *dev)
 {
 	int i;
 	u32 tmp;
diff -puN drivers/net/wireless/b43/main.h~make-b43_mac_enablesuspend-static drivers/net/wireless/b43/main.h
--- a/drivers/net/wireless/b43/main.h~make-b43_mac_enablesuspend-static
+++ a/drivers/net/wireless/b43/main.h
@@ -102,9 +102,6 @@ void b43_dummy_transmission(struct b43_w
 
 void b43_wireless_core_reset(struct b43_wldev *dev, u32 flags);
 
-void b43_mac_suspend(struct b43_wldev *dev);
-void b43_mac_enable(struct b43_wldev *dev);
-
 void b43_controller_restart(struct b43_wldev *dev, const char *reason);
 
 #define B43_PS_ENABLED	(1 << 0)	/* Force enable hardware power saving */
_

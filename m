Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:43923 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755321Ab2E2WkK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 May 2012 18:40:10 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: mcgrof@gmail.com
Cc: lf_driver_backport@lists.linux-foundation.org,
	linux-wireless@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 6/8] compat-wireless: add bluetooth to pr_fmt patch
Date: Wed, 30 May 2012 00:39:40 +0200
Message-Id: <1338331182-29589-7-git-send-email-hauke@hauke-m.de> (sfid-20120530_004019_218752_1562A787)
In-Reply-To: <1338331182-29589-1-git-send-email-hauke@hauke-m.de>
References: <1338331182-29589-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 patches/53-pr_fmt.patch |   14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/patches/53-pr_fmt.patch b/patches/53-pr_fmt.patch
index 1e5ee79..874e756 100644
--- a/patches/53-pr_fmt.patch
+++ b/patches/53-pr_fmt.patch
@@ -374,6 +374,20 @@ compiler warnings. This is going to be sent upstream.
  #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
  
  #include <linux/types.h>
+--- a/net/bluetooth/lib.c
++++ b/net/bluetooth/lib.c
+@@ -24,9 +24,11 @@
+ 
+ /* Bluetooth kernel library. */
+ 
++#undef pr_fmt
+ #define pr_fmt(fmt) "Bluetooth: " fmt
+ 
+ #include <linux/export.h>
++#include <linux/printk.h>
+ 
+ #include <net/bluetooth/bluetooth.h>
+ 
 --- a/net/wireless/lib80211.c
 +++ b/net/wireless/lib80211.c
 @@ -13,8 +13,10 @@
-- 
1.7.9.5


Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:43917 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755842Ab2E2WkG (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 May 2012 18:40:06 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: mcgrof@gmail.com
Cc: lf_driver_backport@lists.linux-foundation.org,
	linux-wireless@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 4/8] compat-wireless: add linux/compat.h header
Date: Wed, 30 May 2012 00:39:38 +0200
Message-Id: <1338331182-29589-5-git-send-email-hauke@hauke-m.de> (sfid-20120530_004016_232662_726FE33E)
In-Reply-To: <1338331182-29589-1-git-send-email-hauke@hauke-m.de>
References: <1338331182-29589-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

For some older kernel versions we have to include linux/compat.h in
some bluetooth code, otherwise it will not find functions like
compat_ptr().

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 patches/06-header-changes.patch |   30 ++++++++++++++++++++++++++++++
 1 file changed, 30 insertions(+)

diff --git a/patches/06-header-changes.patch b/patches/06-header-changes.patch
index 92ed02d..db84468 100644
--- a/patches/06-header-changes.patch
+++ b/patches/06-header-changes.patch
@@ -75,3 +75,33 @@ cases.
  
  /**
   * DOC: Key handling basics
+--- a/net/bluetooth/bnep/sock.c
++++ b/net/bluetooth/bnep/sock.c
+@@ -26,6 +26,7 @@
+ 
+ #include <linux/export.h>
+ #include <linux/file.h>
++#include <linux/compat.h>
+ 
+ #include "bnep.h"
+ 
+--- a/net/bluetooth/hci_sock.c
++++ b/net/bluetooth/hci_sock.c
+@@ -25,6 +25,7 @@
+ /* Bluetooth HCI sockets. */
+ 
+ #include <linux/export.h>
++#include <linux/compat.h>
+ #include <asm/unaligned.h>
+ 
+ #include <net/bluetooth/bluetooth.h>
+--- a/net/bluetooth/hidp/sock.c
++++ b/net/bluetooth/hidp/sock.c
+@@ -22,6 +22,7 @@
+ 
+ #include <linux/export.h>
+ #include <linux/file.h>
++#include <linux/compat.h>
+ 
+ #include "hidp.h"
+ 
-- 
1.7.9.5


Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:44585 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755375Ab1DXQLY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 24 Apr 2011 12:11:24 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: mcgrof@gmail.com, lrodriguez@atheros.com
Cc: linux-wireless@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 2/2] compat: fix TASK_INTERRUPTIBLE missing
Date: Sun, 24 Apr 2011 18:11:15 +0200
Message-Id: <1303661475-26632-2-git-send-email-hauke@hauke-m.de> (sfid-20110424_181136_380907_CB977765)
In-Reply-To: <1303661475-26632-1-git-send-email-hauke@hauke-m.de>
References: <1303661475-26632-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When compiling against the Ubuntu Natty kernel (2.6.38-8-generic)
TASK_INTERRUPTIBLE is not defined here.

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 compat/compat-2.6.39.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/compat/compat-2.6.39.c b/compat/compat-2.6.39.c
index 8d85877..5bb9322 100644
--- a/compat/compat-2.6.39.c
+++ b/compat/compat-2.6.39.c
@@ -10,6 +10,7 @@
 
 #include <linux/compat.h>
 #include <linux/tty.h>
+#include <linux/sched.h>
 
 #if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,27))
 /*
-- 
1.7.1


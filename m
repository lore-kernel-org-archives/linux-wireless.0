Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:59593 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756906Ab2COHor (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Mar 2012 03:44:47 -0400
From: Vivek Natarajan <nataraja@qca.qualcomm.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Vivek Natarajan <nataraja@qca.qualcomm.com>
Subject: [PATCH 1/2] cfg80211: Fix a compilation warning
Date: Thu, 15 Mar 2012 13:14:39 +0530
Message-ID: <1331797479-2838-1-git-send-email-nataraja@qca.qualcomm.com> (sfid-20120315_084450_920775_6E2CFD1C)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Fix a macro redefined warning:

net/wireless/reg.c:45:1 warning: "pr_fmt" redefined

Also remove an unused instance in core.c

Signed-off-by: Vivek Natarajan <nataraja@qca.qualcomm.com>
---
 net/wireless/core.c |    2 --
 net/wireless/reg.c  |    2 ++
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/wireless/core.c b/net/wireless/core.c
index ccdfed8..067c008 100644
--- a/net/wireless/core.c
+++ b/net/wireless/core.c
@@ -4,8 +4,6 @@
  * Copyright 2006-2010		Johannes Berg <johannes@sipsolutions.net>
  */
 
-#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
-
 #include <linux/if.h>
 #include <linux/module.h>
 #include <linux/err.h>
diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index e9a0ac8..1797fcc 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -42,7 +42,9 @@
  *
  */
 
+#ifndef pr_fmt
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+#endif
 
 #include <linux/kernel.h>
 #include <linux/export.h>
-- 
1.7.0.4


Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f53.google.com ([209.85.220.53]:54003 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752608AbaDRBZy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Apr 2014 21:25:54 -0400
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: bzhao@marvell.com, linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, backports@vger.kernel.org,
	"Luis R. Rodriguez" <mcgrof@suse.com>
Subject: [PATCH] mwifiex: use generic header for if_arp.h
Date: Thu, 17 Apr 2014 18:25:48 -0700
Message-Id: <1397784348-16059-1-git-send-email-mcgrof@do-not-panic.com> (sfid-20140418_032607_937178_735DFC63)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: "Luis R. Rodriguez" <mcgrof@suse.com>

Older kernels require both, but if we instead include
the general header we get both in-kernel and UAPI
stuff. This simplifies the backport.

Cc: Bing Zhao <bzhao@marvell.com>
Cc: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Signed-off-by: Luis R. Rodriguez <mcgrof@suse.com>
---
 drivers/net/wireless/mwifiex/decl.h   | 2 +-
 drivers/net/wireless/mwifiex/sta_rx.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/decl.h b/drivers/net/wireless/mwifiex/decl.h
index e7b3e16..51e0f6d 100644
--- a/drivers/net/wireless/mwifiex/decl.h
+++ b/drivers/net/wireless/mwifiex/decl.h
@@ -26,7 +26,7 @@
 #include <linux/wait.h>
 #include <linux/timer.h>
 #include <linux/ieee80211.h>
-#include <uapi/linux/if_arp.h>
+#include <linux/if_arp.h>
 #include <net/mac80211.h>
 
 
diff --git a/drivers/net/wireless/mwifiex/sta_rx.c b/drivers/net/wireless/mwifiex/sta_rx.c
index ed26387..ea20fef 100644
--- a/drivers/net/wireless/mwifiex/sta_rx.c
+++ b/drivers/net/wireless/mwifiex/sta_rx.c
@@ -17,7 +17,7 @@
  * this warranty disclaimer.
  */
 
-#include <uapi/linux/ipv6.h>
+#include <linux/ipv6.h>
 #include <net/ndisc.h>
 #include "decl.h"
 #include "ioctl.h"
-- 
1.9.1


Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:42299 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750896Ab2CDIcz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 4 Mar 2012 03:32:55 -0500
Subject: [PATCH] compat-wireless: remove unaligned from mac80211 patch
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 04 Mar 2012 09:32:52 +0100
Message-ID: <1330849972.4000.3.camel@jlt3.sipsolutions.net> (sfid-20120304_093326_755903_AF5661D5)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

This is no longer needed as upstream includes it.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 patches/06-header-changes.patch |   12 ------------
 1 files changed, 0 insertions(+), 12 deletions(-)

diff --git a/patches/06-header-changes.patch b/patches/06-header-changes.patch
index 15355d5..c3f8cff 100644
--- a/patches/06-header-changes.patch
+++ b/patches/06-header-changes.patch
@@ -50,15 +50,3 @@ cases.
  #include <linux/spi/spi.h>
  #include <linux/wl12xx.h>
  
---- a/net/mac80211/key.c
-+++ b/net/mac80211/key.c
-@@ -23,6 +23,9 @@
- #include "aes_ccm.h"
- #include "aes_cmac.h"
- 
-+#if (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,29))
-+#include <asm/unaligned.h>
-+#endif
- 
- /**
-  * DOC: Key handling basics
-- 
1.7.6.3




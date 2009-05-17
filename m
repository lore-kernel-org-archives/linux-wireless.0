Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:57233 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752200AbZEQMru (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 17 May 2009 08:47:50 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: lrodriguez@atheros.com
Cc: linux-wireless@vger.kernel.org, stecklum@tls-tautenburg.de,
	me@bobcopeland.com, breusshe@hotmail.com,
	Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 1/4] compat-2.6: update compat.diff
Date: Sun, 17 May 2009 14:47:40 +0200
Message-Id: <1242564463-9120-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In kernel versions > 2.9.28 linux/etherdevice.h includes asm/unaligned.h.
This is needed by net/mac80211/key.c.

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 compat/compat.diff |   12 ++++++++++++
 1 files changed, 12 insertions(+), 0 deletions(-)

diff --git a/compat/compat.diff b/compat/compat.diff
index 725aadf..3ee9e86 100644
--- a/compat/compat.diff
+++ b/compat/compat.diff
@@ -542,6 +542,18 @@
  	if (ieee80211_vif_is_mesh(&sdata->vif) &&
  	    params && params->mesh_id_len)
  		ieee80211_sdata_set_mesh_id(sdata,
+--- a/net/mac80211/key.c
++++ b/net/mac80211/key.c
+@@ -21,6 +21,9 @@
+ #include "aes_ccm.h"
+ #include "aes_cmac.h"
+ 
++#if (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,29))
++#include <asm/unaligned.h>
++#endif
+ 
+ /**
+  * DOC: Key handling basics
 --- a/net/mac80211/main.c	2009-04-28 15:34:50.000000000 -0700
 +++ b/net/mac80211/main.c	2009-04-28 15:35:06.000000000 -0700
 @@ -469,6 +469,7 @@
-- 
1.6.2.1


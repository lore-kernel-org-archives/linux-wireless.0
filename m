Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:60468 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754328Ab2EPP1z (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 May 2012 11:27:55 -0400
Received: by wgbdr13 with SMTP id dr13so859592wgb.1
        for <linux-wireless@vger.kernel.org>; Wed, 16 May 2012 08:27:54 -0700 (PDT)
From: Eliad Peller <eliad@wizery.com>
To: "Luis R. Rodriguez" <mcgrof@frijolero.org>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH] compat: backport IS_ENABLED macro
Date: Wed, 16 May 2012 18:28:00 +0300
Message-Id: <1337182080-25318-1-git-send-email-eliad@wizery.com> (sfid-20120516_172800_052192_6ADD4A12)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

IS_ENABLED(option) was backported as defined(option), but
because of the indirection, option was evaluated too early,
resulting in #if defined(1) for defined options, which failed
the compilation with the following error:

error: operator "defined" requires an identifier

Backport IS_ENABLED from the current kernel instead.

Signed-off-by: Eliad Peller <eliad@wizery.com>
---
 include/linux/compat-3.1.h |   23 +++++++++++++++++++++--
 1 files changed, 21 insertions(+), 2 deletions(-)

diff --git a/include/linux/compat-3.1.h b/include/linux/compat-3.1.h
index 1e8e05e..3fdcbf8 100644
--- a/include/linux/compat-3.1.h
+++ b/include/linux/compat-3.1.h
@@ -18,10 +18,29 @@ static inline struct sk_buff *__netdev_alloc_skb_ip_align(struct net_device *dev
 	return skb;
 }
 
-#define IS_ENABLED(option) defined(option)
-
+/*
+ * Getting something that works in C and CPP for an arg that may or may
+ * not be defined is tricky.  Here, if we have "#define CONFIG_BOOGER 1"
+ * we match on the placeholder define, insert the "0," for arg1 and generate
+ * the triplet (0, 1, 0).  Then the last step cherry picks the 2nd arg (a one).
+ * When CONFIG_BOOGER is not defined, we generate a (... 1, 0) pair, and when
+ * the last step cherry picks the 2nd arg, we get a zero.
+ */
+#define __ARG_PLACEHOLDER_1 0,
+#define config_enabled(cfg) _config_enabled(cfg)
+#define _config_enabled(value) __config_enabled(__ARG_PLACEHOLDER_##value)
+#define __config_enabled(arg1_or_junk) ___config_enabled(arg1_or_junk 1, 0)
+#define ___config_enabled(__ignored, val, ...) val
 #define genl_dump_check_consistent(cb, user_hdr, family)
 
+/*
+ * IS_ENABLED(CONFIG_FOO) evaluates to 1 if CONFIG_FOO is set to 'y' or 'm',
+ * 0 otherwise.
+ *
+ */
+#define IS_ENABLED(option) \
+        (config_enabled(option) || config_enabled(option##_MODULE))
+
 #define IFF_TX_SKB_SHARING	0x10000	/* The interface supports sharing
 					 * skbs on transmit */
 
-- 
1.7.6.401.g6a319


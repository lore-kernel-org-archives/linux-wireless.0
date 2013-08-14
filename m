Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:57067 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754723Ab3HNHsS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Aug 2013 03:48:18 -0400
Received: by mail-ee0-f46.google.com with SMTP id c13so4654907eek.5
        for <linux-wireless@vger.kernel.org>; Wed, 14 Aug 2013 00:48:17 -0700 (PDT)
From: Arik Nemtsov <arik@wizery.com>
To: <linux-wireless@vger.kernel.org>, mcgrof@kernel.org
Cc: Arik Nemtsov <arik@wizery.com>
Subject: [PATCH] backports: rename some mem functions to not break custom kernels
Date: Wed, 14 Aug 2013 10:48:05 +0300
Message-Id: <1376466485-25796-1-git-send-email-arik@wizery.com> (sfid-20130814_094826_146710_A7E5ABFB)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When custom patches are cherry-picked to a kernel, some symbols exported
by backports may clash with the built-in ones. Rename the backports
symbols using the standard backport_ prefix to prevent that.

The offending symbols were exported by the patch below:

commit 2ce5c22448bb45998318267c00b5d6ef9cff3170
Author: Hauke Mehrtens <hauke@hauke-m.de>
Date:   Thu Jun 6 13:48:04 2013 +0200

    backports: backport some memory functions

Signed-off-by: Arik Nemtsov <arik@wizery.com>
---
 backport/backport-include/asm/mtrr.h | 1 +
 backport/backport-include/linux/io.h | 3 +++
 2 files changed, 4 insertions(+)

diff --git a/backport/backport-include/asm/mtrr.h b/backport/backport-include/asm/mtrr.h
index cf0f6fd..861438a 100644
--- a/backport/backport-include/asm/mtrr.h
+++ b/backport/backport-include/asm/mtrr.h
@@ -7,6 +7,7 @@
  * The following functions are for use by other drivers that cannot use
  * arch_phys_wc_add and arch_phys_wc_del.
  */
+#define phys_wc_to_mtrr_index LINUX_BACKPORT(phys_wc_to_mtrr_index)
 #ifdef CONFIG_MTRR
 extern int phys_wc_to_mtrr_index(int handle);
 #else
diff --git a/backport/backport-include/linux/io.h b/backport/backport-include/linux/io.h
index 9a5b308..5447df8 100644
--- a/backport/backport-include/linux/io.h
+++ b/backport/backport-include/linux/io.h
@@ -13,6 +13,9 @@
  * arch_phys_del_wc(0) or arch_phys_del_wc(any error code) is guaranteed
  * to have no effect.
  */
+#define arch_phys_wc_add LINUX_BACKPORT(arch_phys_wc_add)
+#define arch_phys_wc_del LINUX_BACKPORT(arch_phys_wc_del)
+
 #ifndef arch_phys_wc_add
 #ifdef CONFIG_MTRR
 extern int __must_check arch_phys_wc_add(unsigned long base,
-- 
1.8.1.2


Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:55794 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752438Ab2HDP61 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 4 Aug 2012 11:58:27 -0400
Message-ID: <1344095900.5982.0.camel@jlt3.sipsolutions.net> (sfid-20120804_175853_265949_A1686538)
Subject: [PATCH] compat: deal with backported codel
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: Hauke Mehrtens <hauke@hauke-m.de>,
	linux-wireless <linux-wireless@vger.kernel.org>
Date: Sat, 04 Aug 2012 17:58:20 +0200
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Some distro kernels (in particular the Debian 3.2.0-3
kernel I'm running) backport codel already, so trying
to backport it again causes issues. Protect the compat
backport with #ifdef TCA_CODEL_MAX.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 include/linux/compat-3.5.h |    2 ++
 include/net/codel.h        |    3 ++-
 2 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/include/linux/compat-3.5.h b/include/linux/compat-3.5.h
index 6bb450d..7fadbf2 100644
--- a/include/linux/compat-3.5.h
+++ b/include/linux/compat-3.5.h
@@ -147,6 +147,7 @@ static inline int compat_vga_switcheroo_register_client(struct pci_dev *dev,
  *   Subject: [PATCH] codel: Controlled Delay AQM
  */
 
+#ifndef TCA_CODEL_MAX
 /* CODEL */
 
 enum {
@@ -234,6 +235,7 @@ struct tc_fq_codel_xstats {
 		struct tc_fq_codel_cl_stats class_stats;
 	};
 };
+#endif /* TCA_CODEL_MAX */
 
 
 /* Backports tty_lock: Localise the lock */
diff --git a/include/net/codel.h b/include/net/codel.h
index 128082e..ab901c5 100644
--- a/include/net/codel.h
+++ b/include/net/codel.h
@@ -1,6 +1,7 @@
 #include <linux/version.h>
+#include <linux/pkt_sched.h>
 
-#if (LINUX_VERSION_CODE >= KERNEL_VERSION(3,5,0))
+#if (LINUX_VERSION_CODE >= KERNEL_VERSION(3,5,0)) || defined(TCA_CODEL_MAX)
 #include_next <net/codel.h>
 #else
 
-- 
1.7.10.4




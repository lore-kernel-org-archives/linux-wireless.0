Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:58536 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754333Ab2HEK3q (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 5 Aug 2012 06:29:46 -0400
Message-ID: <1344162581.4513.1.camel@jlt3.sipsolutions.net> (sfid-20120805_122951_396232_17CB9F65)
Subject: [PATCH v2] compat: deal with backported codel
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: Hauke Mehrtens <hauke@hauke-m.de>,
	linux-wireless <linux-wireless@vger.kernel.org>
Date: Sun, 05 Aug 2012 12:29:41 +0200
In-Reply-To: <1344095900.5982.0.camel@jlt3.sipsolutions.net> (sfid-20120804_175853_265949_A1686538)
References: <1344095900.5982.0.camel@jlt3.sipsolutions.net>
	 (sfid-20120804_175853_265949_A1686538)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Some distro kernels (in particular the Debian 3.2.0-3
kernel I'm running) backport codel already, so trying
to backport it again causes issues. Protect the compat
backport with #ifdef TCA_CODEL_MAX.

Also link the flow_dissector code into the codel module
which then won't be loaded on kernels that already have
codel backported.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 compat/Makefile                                |    6 ++++--
 compat/flow_dissector.c                        |    1 -
 compat/{sch_fq_codel.c => sch_fq_codel_core.c} |    0
 include/linux/compat-3.5.h                     |    2 ++
 include/net/codel.h                            |    3 ++-
 5 files changed, 8 insertions(+), 4 deletions(-)
 rename compat/{sch_fq_codel.c => sch_fq_codel_core.c} (100%)

diff --git a/compat/Makefile b/compat/Makefile
index c661f5d..23c1296 100644
--- a/compat/Makefile
+++ b/compat/Makefile
@@ -3,6 +3,9 @@ obj-m += compat.o
 
 obj-$(CONFIG_COMPAT_FIRMWARE_CLASS) += compat_firmware_class.o
 obj-$(CONFIG_COMPAT_NET_SCH_CODEL) += sch_codel.o
+
+sch_fq_codel-y = sch_fq_codel_core.o flow_dissector.o
+
 obj-$(CONFIG_COMPAT_NET_SCH_FQ_CODEL) += sch_fq_codel.o
 
 compat-y += main.o
@@ -40,8 +43,7 @@ compat-$(CONFIG_COMPAT_KERNEL_3_0) += compat-3.0.o
 compat-$(CONFIG_COMPAT_KERNEL_3_1) += compat-3.1.o
 compat-$(CONFIG_COMPAT_KERNEL_3_2) += compat-3.2.o
 compat-$(CONFIG_COMPAT_KERNEL_3_3) += \
-	compat-3.3.o \
-	flow_dissector.o
+	compat-3.3.o
 compat-$(CONFIG_COMPAT_KERNEL_3_4) += compat-3.4.o
 
 compat-$(CONFIG_COMPAT_CORDIC) += cordic.o
diff --git a/compat/flow_dissector.c b/compat/flow_dissector.c
index 8affda0..7dd7ec1 100644
--- a/compat/flow_dissector.c
+++ b/compat/flow_dissector.c
@@ -141,4 +141,3 @@ ipv6:
 
 	return true;
 }
-EXPORT_SYMBOL_GPL(skb_flow_dissect);
diff --git a/compat/sch_fq_codel.c b/compat/sch_fq_codel_core.c
similarity index 100%
rename from compat/sch_fq_codel.c
rename to compat/sch_fq_codel_core.c
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




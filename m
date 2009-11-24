Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw0-f182.google.com ([209.85.211.182]:46844 "EHLO
	mail-yw0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757802AbZKXC0r (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Nov 2009 21:26:47 -0500
Received: by mail-yw0-f182.google.com with SMTP id 12so5947609ywh.21
        for <linux-wireless@vger.kernel.org>; Mon, 23 Nov 2009 18:26:53 -0800 (PST)
Message-ID: <4B0B442C.8090801@gmail.com>
Date: Mon, 23 Nov 2009 21:25:48 -0500
From: Arnaud Lacombe <lacombar@gmail.com>
MIME-Version: 1.0
To: mcgrof@bombadil.infradead.org
CC: linux-wireless@vger.kernel.org, lrodriguez@atheros.com
Subject: [PATCH 13/13] Trailing space nits
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Arnaud Lacombe <lacombar@gmail.com>
---
 Makefile        |    4 ++--
 compat-2.6.23.c |    6 +++---
 compat-2.6.23.h |    2 +-
 compat-2.6.24.h |    2 +-
 compat-2.6.25.c |    2 +-
 compat-2.6.25.h |    2 +-
 compat-2.6.26.h |   16 ++++++++--------
 7 files changed, 17 insertions(+), 17 deletions(-)

diff --git a/Makefile b/Makefile
index 1677589..d2c08d1 100644
--- a/Makefile
+++ b/Makefile
@@ -38,8 +38,8 @@ compat-$(CONFIG_COMPAT_KERNEL_30) += compat-2.6.30.o
 compat-$(CONFIG_COMPAT_KERNEL_31) += compat-2.6.31.o
 compat-$(CONFIG_COMPAT_KERNEL_32) += compat-2.6.32.o

-modules:
-	$(MAKE) -C $(KLIB_BUILD) M=$(PWD) modules
+modules:
+	$(MAKE) -C $(KLIB_BUILD) M=$(PWD) modules
 install: modules
 	$(MAKE) -C $(KLIB_BUILD) M=$(PWD) $(KMODDIR_ARG) $(KMODPATH_ARG) \
 		modules_install
diff --git a/compat-2.6.23.c b/compat-2.6.23.c
index 9845b82..d232b1a 100644
--- a/compat-2.6.23.c
+++ b/compat-2.6.23.c
@@ -14,7 +14,7 @@
 #if (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,23))

 /* Part of net/core/dev_mcast.c as of 2.6.23. This is a slightly
different version.
- * Since da->da_synced is not part of 2.6.22 we need to take longer
route when
+ * Since da->da_synced is not part of 2.6.22 we need to take longer
route when
  * syncing */

 /**
@@ -70,8 +70,8 @@ int dev_mc_sync(struct net_device *to, struct
net_device *from)
 EXPORT_SYMBOL(dev_mc_sync);


-/* Part of net/core/dev_mcast.c as of 2.6.23. This is a slighty
different version.
- * Since da->da_synced is not part of 2.6.22 we need to take longer
route when
+/* Part of net/core/dev_mcast.c as of 2.6.23. This is a slighty
different version.
+ * Since da->da_synced is not part of 2.6.22 we need to take longer
route when
  * unsyncing */

 /**
diff --git a/compat-2.6.23.h b/compat-2.6.23.h
index 5eb6dbf..c36f90d 100644
--- a/compat-2.6.23.h
+++ b/compat-2.6.23.h
@@ -70,7 +70,7 @@ static inline void tcf_destroy_chain_compat(struct
tcf_proto **fl)
 #define da_users	dmi_users
 #define da_gusers	dmi_gusers

-/* dev_set_promiscuity() was moved to __dev_set_promiscuity() on 2.6.23
and
+/* dev_set_promiscuity() was moved to __dev_set_promiscuity() on 2.6.23 and
  * dev_set_promiscuity() became a wrapper. */
 #define __dev_set_promiscuity dev_set_promiscuity

diff --git a/compat-2.6.24.h b/compat-2.6.24.h
index 68d33c7..43e6302 100644
--- a/compat-2.6.24.h
+++ b/compat-2.6.24.h
@@ -148,7 +148,7 @@ struct header_ops {
 		unsigned char *haddr);
 };

-/* net/ieee80211/ieee80211_crypt_tkip uses sg_init_table. This was
added on
+/* net/ieee80211/ieee80211_crypt_tkip uses sg_init_table. This was added on
  * 2.6.24. CONFIG_DEBUG_SG was added in 2.6.24 as well, so lets just ignore
  * the debug stuff. Note that adding this required changes to the struct
  * scatterlist on include/asm/scatterlist*, so the right way to port this
diff --git a/compat-2.6.25.c b/compat-2.6.25.c
index e39971a..e872447 100644
--- a/compat-2.6.25.c
+++ b/compat-2.6.25.c
@@ -15,7 +15,7 @@

 /* Backport work for QoS dependencies (kernel/pm_qos_params.c)
  * ipw2100 now makes use of
- * pm_qos_add_requirement(),
+ * pm_qos_add_requirement(),
  * pm_qos_update_requirement() and
  * pm_qos_remove_requirement() from it
  *
diff --git a/compat-2.6.25.h b/compat-2.6.25.h
index fa42fd9..23cf487 100644
--- a/compat-2.6.25.h
+++ b/compat-2.6.25.h
@@ -82,7 +82,7 @@ static inline void be64_add_cpu(__be64 *var, u64 val)
 	*var = cpu_to_be64(v + val);
 }

-/* 2.6.25 changes hwrng_unregister()'s behaviour by supporting
+/* 2.6.25 changes hwrng_unregister()'s behaviour by supporting
  * suspend of its parent device (the misc device, which is itself the
  * hardware random number generator). It does this by passing a
parameter to
  * unregister_miscdev() which is not supported in older kernels. The
suspend
diff --git a/compat-2.6.26.h b/compat-2.6.26.h
index 7f1a9f1..b7c3b05 100644
--- a/compat-2.6.26.h
+++ b/compat-2.6.26.h
@@ -88,19 +88,19 @@ static inline const char *dev_name(struct device *dev)
 	return dev->bus_id;
 }

-/* This is from include/linux/kernel.h, which was added as of 2.6.26 */
+/* This is from include/linux/kernel.h, which was added as of 2.6.26 */

 /**
  * clamp_val - return a value clamped to a given range using val's type
  * @val: current value
  * @min: minimum allowable value
  * @max: maximum allowable value
- *
+ *
  * This macro does no typechecking and uses temporary variables of whatever
  * type the input argument 'val' is.  This is useful when val is an
unsigned
  * type and min and max are literals that will otherwise be assigned a
signed
  * integer type.
- */
+ */

 #define clamp_val(val, min, max) ({             \
 	typeof(val) __val = (val);              \
@@ -193,10 +193,10 @@ struct net *dev_net(const struct net_device *dev)
  * implementation.  The AVR32 AP implementation can handle unaligned
  * words, but halfwords must be halfword-aligned, and doublewords must
  * be word-aligned.
- *
+ *
  * However, swapped word loads must be word-aligned so we can't
  * optimize word loads in general.
- */
+ */

 #include <linux/unaligned/be_struct.h>
 #include <linux/unaligned/le_byteshift.h>
@@ -213,7 +213,7 @@ struct net *dev_net(const struct net_device *dev)
 #ifdef CONFIG_CRIS

 /*
- * CRIS can do unaligned accesses itself.
+ * CRIS can do unaligned accesses itself.
  */
 #include <linux/unaligned/access_ok.h>
 #include <linux/unaligned/generic.h>
@@ -300,7 +300,7 @@ struct net *dev_net(const struct net_device *dev)
 #ifdef CONFIG_PPC
 /*
  * The PowerPC can do unaligned accesses itself in big endian mode.
- */
+ */
 #include <linux/unaligned/access_ok.h>
 #include <linux/unaligned/generic.h>

@@ -308,7 +308,7 @@ struct net *dev_net(const struct net_device *dev)
 #ifdef CONFIG_S390

 /*
- * The S390 can do unaligned accesses itself.
+ * The S390 can do unaligned accesses itself.
  */
 #include <linux/unaligned/access_ok.h>
 #include <linux/unaligned/generic.h>
-- 
1.6.3.3.385.g60647.dirty


Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:56770 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752659AbYFDP0R (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Jun 2008 11:26:17 -0400
Subject: Re: [PATCH] wireless.h: improve userland include-ability
From: David Woodhouse <dwmw2@infradead.org>
To: David Miller <davem@davemloft.net>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	kirill@shutemov.name
In-Reply-To: <20080604.080237.66646394.davem@davemloft.net>
References: <1212515497-21578-1-git-send-email-linville@tuxdriver.com>
	 <20080603.120515.193703574.davem@davemloft.net>
	 <1212587529.32207.82.camel@pmac.infradead.org>
	 <20080604.080237.66646394.davem@davemloft.net>
Content-Type: text/plain
Date: Wed, 04 Jun 2008 16:26:12 +0100
Message-Id: <1212593172.32207.114.camel@pmac.infradead.org> (sfid-20080604_172621_306587_54BB13D2)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2008-06-04 at 08:02 -0700, David Miller wrote:
> You will need to find a way to make it work cleanly if you want
> me to take the change in :-)

I believe the fundamental issue is that we have to include <features.h>
before we include <linux/types.h>, because of the way that
__KERNEL_STRICT_NAMES is handled.

Since fairly much any userspace header will include the former, while
fairly much any kernel header will include the latter, that basically
means the rule is "include some userspace header before kernel headers".

If we really want to fix _that_, perhaps we could observe that glibc's
<features.h> actually has the following construct:

	#undef  __KERNEL_STRICT_NAMES
	/* Suppress kernel-name space pollution unless user expressedly
	   asks for it.  */
	#ifndef _LOOSE_KERNEL_NAMES
	# define __KERNEL_STRICT_NAMES
	#endif

... and we could make the kernel's own headers act on
_LOOSE_KERNEL_NAMES directly, instead of the absence of
__KERNEL_STRICT_NAMES?

We also have both <linux/if.h> and <net/if.h> defining struct ifmap,
struct ifreq and struct ifconf. Should those be hidden in #ifdef
__KERNEL__ (or _LOOSE_KERNEL_NAMES) too?

diff --git a/include/linux/types.h b/include/linux/types.h
index d4a9ce6..3edcda5 100644
--- a/include/linux/types.h
+++ b/include/linux/types.h
@@ -11,7 +11,7 @@
 #include <linux/posix_types.h>
 #include <asm/types.h>
 
-#ifndef __KERNEL_STRICT_NAMES
+#if defined(__KERNEL__) || defined(_LOOSE_KERNEL_NAMES)
 
 typedef __u32 __kernel_dev_t;
 
@@ -159,7 +159,7 @@ typedef unsigned long blkcnt_t;
 #define pgoff_t unsigned long
 #endif
 
-#endif /* __KERNEL_STRICT_NAMES */
+#endif /* !_LOOSE_KERNEL_NAMES */
 
 /*
  * Below are truly Linux-specific types that should never collide with
diff --git a/include/asm-arm/statfs.h b/include/asm-arm/statfs.h
index a02e6a8..9e54d51 100644
--- a/include/asm-arm/statfs.h
+++ b/include/asm-arm/statfs.h
@@ -1,7 +1,7 @@
 #ifndef _ASMARM_STATFS_H
 #define _ASMARM_STATFS_H
 
-#ifndef __KERNEL_STRICT_NAMES
+#if defined(__KERNEL__) || defined(_LOOSE_KERNEL_NAMES)
 # include <linux/types.h>
 typedef __kernel_fsid_t	fsid_t;
 #endif
diff --git a/include/asm-generic/statfs.h b/include/asm-generic/statfs.h
index 1d01043..bb7195a 100644
--- a/include/asm-generic/statfs.h
+++ b/include/asm-generic/statfs.h
@@ -1,7 +1,7 @@
 #ifndef _GENERIC_STATFS_H
 #define _GENERIC_STATFS_H
 
-#ifndef __KERNEL_STRICT_NAMES
+#if defined(__KERNEL__) || defined(_LOOSE_KERNEL_NAMES)
 # include <linux/types.h>
 typedef __kernel_fsid_t	fsid_t;
 #endif
diff --git a/include/asm-ia64/statfs.h b/include/asm-ia64/statfs.h
index 8110979..0f340c0 100644
--- a/include/asm-ia64/statfs.h
+++ b/include/asm-ia64/statfs.h
@@ -8,7 +8,7 @@
  *	David Mosberger-Tang <davidm@hpl.hp.com>, Hewlett-Packard Co
  */
 
-#ifndef __KERNEL_STRICT_NAMES
+#if defined(__KERNEL__) || defined(_LOOSE_KERNEL_NAMES)
 # include <linux/types.h>
 typedef __kernel_fsid_t	fsid_t;
 #endif
diff --git a/include/asm-mips/statfs.h b/include/asm-mips/statfs.h
index c3ddf97..d82a9a8 100644
--- a/include/asm-mips/statfs.h
+++ b/include/asm-mips/statfs.h
@@ -11,7 +11,7 @@
 #include <linux/posix_types.h>
 #include <asm/sgidefs.h>
 
-#ifndef __KERNEL_STRICT_NAMES
+#if defined(__KERNEL__) || defined(_LOOSE_KERNEL_NAMES)
 
 #include <linux/types.h>
 
diff --git a/include/asm-parisc/statfs.h b/include/asm-parisc/statfs.h
index 1d2b813..734acd5 100644
--- a/include/asm-parisc/statfs.h
+++ b/include/asm-parisc/statfs.h
@@ -1,7 +1,7 @@
 #ifndef _PARISC_STATFS_H
 #define _PARISC_STATFS_H
 
-#ifndef __KERNEL_STRICT_NAMES
+#if defined(__KERNEL__) || defined(_LOOSE_KERNEL_NAMES)
 
 #include <linux/types.h>
 
diff --git a/include/asm-powerpc/statfs.h b/include/asm-powerpc/statfs.h
index 6702402..aa160a0 100644
--- a/include/asm-powerpc/statfs.h
+++ b/include/asm-powerpc/statfs.h
@@ -7,7 +7,7 @@
 #include <asm-generic/statfs.h>
 #else
 
-#ifndef __KERNEL_STRICT_NAMES
+#if defined(__KERNEL__) || defined(_LOOSE_KERNEL_NAMES)
 #include <linux/types.h>
 typedef __kernel_fsid_t	fsid_t;
 #endif
diff --git a/include/asm-s390/statfs.h b/include/asm-s390/statfs.h
index 099a455..3ba543f 100644
--- a/include/asm-s390/statfs.h
+++ b/include/asm-s390/statfs.h
@@ -13,7 +13,7 @@
 #include <asm-generic/statfs.h>
 #else
 
-#ifndef __KERNEL_STRICT_NAMES
+#if defined(__KERNEL__) || defined(_LOOSE_KERNEL_NAMES)
 
 #include <linux/types.h>
 
diff --git a/include/asm-sparc64/statfs.h b/include/asm-sparc64/statfs.h
index 79b3c89..70d994c 100644
--- a/include/asm-sparc64/statfs.h
+++ b/include/asm-sparc64/statfs.h
@@ -1,7 +1,7 @@
 #ifndef _SPARC64_STATFS_H
 #define _SPARC64_STATFS_H
 
-#ifndef __KERNEL_STRICT_NAMES
+#if defined(__KERNEL__) || defined(_LOOSE_KERNEL_NAMES)
 
 #include <linux/types.h>
 
diff --git a/include/asm-x86/statfs.h b/include/asm-x86/statfs.h
index 7c651aa..2615eed 100644
--- a/include/asm-x86/statfs.h
+++ b/include/asm-x86/statfs.h
@@ -5,7 +5,7 @@
 #include <asm-generic/statfs.h>
 #else
 
-#ifndef __KERNEL_STRICT_NAMES
+#if defined(__KERNEL__) || defined(_LOOSE_KERNEL_NAMES)
 
 #include <linux/types.h>
 

-- 
dwmw2


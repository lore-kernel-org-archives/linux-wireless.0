Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:61618 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755013Ab0KKRnw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Nov 2010 12:43:52 -0500
Date: Thu, 11 Nov 2010 11:44:32 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
To: John W Linville <linville@tuxdriver.com>
Cc: b43-dev@lists.infradead.org, linux-wireless@vger.kernel.org,
	arnd@arndnet.de
Subject: [PATCH] b43legacy: Fix compile on ARM architecture
Message-ID: <4cdc2b80.RuMMb1PuVmklU3JJ%Larry.Finger@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Arnd Hannemann <arnd@arndnet.de>

When b43legacy is compiled on the arm platform, the following errors are seen:

  CC [M]  drivers/net/wireless/b43legacy/xmit.o
In file included from include/net/dst.h:11,
from drivers/net/wireless/b43legacy/xmit.c:31:
include/net/dst_ops.h:28: error: expected ':', ',', ';', '}' or '__attribute__'
   before '____cacheline_aligned_in_smp'
include/net/dst_ops.h: In function 'dst_entries_get_fast':
include/net/dst_ops.h:33: error: 'struct dst_ops' has no member named
   'pcpuc_entries'
include/net/dst_ops.h: In function 'dst_entries_get_slow':
include/net/dst_ops.h:41: error: 'struct dst_ops' has no member named
   'pcpuc_entries'
include/net/dst_ops.h: In function 'dst_entries_add':
include/net/dst_ops.h:49: error: 'struct dst_ops' has no member named
   'pcpuc_entries'
include/net/dst_ops.h: In function 'dst_entries_init':
include/net/dst_ops.h:55: error: 'struct dst_ops' has no member named
   'pcpuc_entries'
include/net/dst_ops.h: In function 'dst_entries_destroy':
include/net/dst_ops.h:60: error: 'struct dst_ops' has no member named
   'pcpuc_entries'
make[4]: *** [drivers/net/wireless/b43legacy/xmit.o] Error 1
make[3]: *** [drivers/net/wireless/b43legacy] Error 2
make[2]: *** [drivers/net/wireless] Error 2
make[1]: *** [drivers/net] Error 2
make: *** [drivers] Error 2

The cause is a missing include of <linux/cache.h>, which is present for
i386 and x86_64 architectures, but not for arm.

Signed-off-by: Arnd Hannemann <arnd@arndnet.de>
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Stable <stable@kernel.org>
---

John,

Once I get the ability to cross-compile ARM architecture, I will check to
see if the equivalent patch is needed for b43.

Larry
---

Index: linux-2.6/include/net/dst_ops.h
===================================================================
--- linux-2.6.orig/include/net/dst_ops.h
+++ linux-2.6/include/net/dst_ops.h
@@ -2,6 +2,7 @@
 #define _NET_DST_OPS_H
 #include <linux/types.h>
 #include <linux/percpu_counter.h>
+#include <linux/cache.h>
 
 struct dst_entry;
 struct kmem_cachep;

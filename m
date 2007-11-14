Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fencepost.gnu.org ([140.186.70.10]:49878 "EHLO
	fencepost.gnu.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751444AbXKNSCH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Nov 2007 13:02:07 -0500
Received: from proski by fencepost.gnu.org with local (Exim 4.60)
	(envelope-from <proski@gnu.org>)
	id 1IsMYw-0005hI-TX
	for linux-wireless@vger.kernel.org; Wed, 14 Nov 2007 13:02:07 -0500
Subject: Re: Linux wireless compatibility package for kernels >= 2.6.22
From: Pavel Roskin <proski@gnu.org>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: wireless <linux-wireless@vger.kernel.org>,
	ath5k-devel@lists.ath5k.org
In-Reply-To: <43e72e890711131510v2189669di962214c46a2e96de@mail.gmail.com>
References: <43e72e890711101953w6e046b82j6b9087d30c8195b2@mail.gmail.com>
	 <1194841658.2276.8.camel@dv>
	 <43e72e890711131510v2189669di962214c46a2e96de@mail.gmail.com>
Content-Type: text/plain
Date: Wed, 14 Nov 2007 13:02:04 -0500
Message-Id: <1195063324.1739.9.camel@dv> (sfid-20071114_180214_053293_6FBE220C)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello, Luis!

On Tue, 2007-11-13 at 18:10 -0500, Luis R. Rodriguez wrote:

> I ran into to this but I had fixed it in compat.diff. Anyway, this
> won't be necessary anymore as the directories match the kernel's now.

OK, that's much better now.

> > After some hack to make it compile, I still get:
> >
> >   CC [M]  /home/proski/src/compat-wireless-2.6/mac80211/ieee80211.o
> > /home/proski/src/compat-wireless-2.6/mac80211/ieee80211.c:24:6: warning:
> > "LINUX_VERSION_CODE" is not defined
> > /home/proski/src/compat-wireless-2.6/mac80211/ieee80211.c:24:28:
> > warning: "KERNEL_VERSION" is not defined
> > /home/proski/src/compat-wireless-2.6/mac80211/ieee80211.c:24:42: error:
> > missing binary operator before token "("
> 
> I'm not sure what happened here as <linux/version.h> should have been
> included in mac80211.h. Anyway, to be sure we won't run into these
> I've added <net/compat.h> to <net/cfg80211.h> which much of the
> wireless subsystem uses.

This problem is still there.  I think the best approach would be to
"force-feed" compat.h to the compiler.  It already includes
linux/version.h, but since it's the first header, it needs
linux/autoconf.h.

The following patch works for me.  The compat.diff patch can be cleaned
up, but it's a separate issue.


Force inclusion of compat.h first.

Include linux/autoconf.h before other headers.

Signed-off-by: Pavel Roskin <proski@gnu.org>
---

 Makefile        |    2 +-
 compat/compat.h |    1 +
 2 files changed, 2 insertions(+), 1 deletions(-)


diff --git a/Makefile b/Makefile
index af1e02f..f1c39a9 100644
--- a/Makefile
+++ b/Makefile
@@ -13,7 +13,7 @@ ifneq ($(KERNELRELEASE),)
 -include $(src)/config.mk
 
 # This is a hack! But hey.. it works, got any better ideas, send a patch ;)
-NOSTDINC_FLAGS := -I$(PWD)/include/ $(CFLAGS)
+NOSTDINC_FLAGS := -I$(PWD)/include/ -include $(M)/compat/compat.h $(CFLAGS)
 
 obj-y := net/wireless/ net/mac80211/  \
 	drivers/net/wireless/ath5k/ \
diff --git a/compat/compat.h b/compat/compat.h
index 6ae32ef..05995f2 100644
--- a/compat/compat.h
+++ b/compat/compat.h
@@ -1,6 +1,7 @@
 #ifndef LINUX_26_COMPAT_H
 #define LINUX_26_COMPAT_H
 
+#include <linux/autoconf.h>
 #include <linux/kernel.h>
 #include <linux/netdevice.h>
 #include <linux/genetlink.h>


-- 
Regards,
Pavel Roskin


Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:63214 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751028AbYIPUIb (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Sep 2008 16:08:31 -0400
From: Pavel Roskin <proski@gnu.org>
Subject: [PATCH] Use the kernel source tree for includes,
	not the kernel build tree
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Date: Tue, 16 Sep 2008 16:08:29 -0400
Message-ID: <20080916200828.13928.55864.stgit@dv.roinet.com> (sfid-20080916_220835_875694_2074F537)
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

If the build is done outside the source tree, nl80211.h won't be in the
build tree.  We only need only definitions from the sources, not the
kernel configuration.

Signed-off-by: Pavel Roskin <proski@gnu.org>
---
 Makefile  |    2 +-
 defconfig |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/Makefile b/Makefile
index 74cb1e1..9e79381 100644
--- a/Makefile
+++ b/Makefile
@@ -6,7 +6,7 @@ INSTALL ?= install
 PREFIX ?= /usr
 CC ?= "gcc"
 CFLAGS += -Wall -Wundef -Wstrict-prototypes -Wno-trigraphs -fno-strict-aliasing -fno-common -Werror-implicit-function-declaration
-CFLAGS += -I/lib/modules/`uname -r`/build/include
+CFLAGS += -I/lib/modules/`uname -r`/source/include
 CFLAGS += -O2 -g
 LDFLAGS += -lnl
 
diff --git a/defconfig b/defconfig
index 346f699..0081911 100644
--- a/defconfig
+++ b/defconfig
@@ -11,7 +11,7 @@
 
 # Kernel location for GIT NL80211 kernel code (assumed to be running,
 # by default); only required if your installed nl80211.h is out of date.
-CONFIG_KERNEL_LOC = /lib/modules/`uname -r`/build/
+CONFIG_KERNEL_LOC = /lib/modules/`uname -r`/source/
 CFLAGS += -I$(CONFIG_KERNEL_LOC)/include
 
 # LibNL location

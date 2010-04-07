Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:34604 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751313Ab0DGFaw (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 Apr 2010 01:30:52 -0400
Subject: [PATCH 1/4] compat-wireless: remove patch part dealing with
 net/net_namespace.h
To: "Luis R. Rodriguez" <mcgrof@gmail.com>,
	linux-wireless@vger.kernel.org
From: Pavel Roskin <proski@gnu.org>
Date: Wed, 07 Apr 2010 01:30:51 -0400
Message-ID: <20100407053051.23575.94594.stgit@mj.roinet.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

net/net_namespace.h stub is now provided by compat

Signed-off-by: Pavel Roskin <proski@gnu.org>
---
 patches/06-header-changes.patch |   60 ---------------------------------------
 1 files changed, 0 insertions(+), 60 deletions(-)

diff --git a/patches/06-header-changes.patch b/patches/06-header-changes.patch
index 2fcf7a5..b3c71fb 100644
--- a/patches/06-header-changes.patch
+++ b/patches/06-header-changes.patch
@@ -64,63 +64,3 @@ cases.
  
  /**
   * DOC: Key handling basics
---- a/net/mac80211/main.c
-+++ b/net/mac80211/main.c
-@@ -20,7 +20,9 @@
- #include <linux/rtnetlink.h>
- #include <linux/bitmap.h>
- #include <linux/pm_qos_params.h>
-+#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,24))
- #include <net/net_namespace.h>
-+#endif
- #include <net/cfg80211.h>
- 
- #include "ieee80211_i.h"
---- a/net/mac80211/cfg.c
-+++ b/net/mac80211/cfg.c
-@@ -10,7 +10,9 @@
- #include <linux/nl80211.h>
- #include <linux/rtnetlink.h>
- #include <linux/slab.h>
-+#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,24))
- #include <net/net_namespace.h>
-+#endif
- #include <linux/rcupdate.h>
- #include <net/cfg80211.h>
- #include "ieee80211_i.h"
---- a/net/mac80211/tx.c
-+++ b/net/mac80211/tx.c
-@@ -18,7 +18,9 @@
- #include <linux/etherdevice.h>
- #include <linux/bitmap.h>
- #include <linux/rcupdate.h>
-+#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,24))
- #include <net/net_namespace.h>
-+#endif
- #include <net/ieee80211_radiotap.h>
- #include <net/cfg80211.h>
- #include <net/mac80211.h>
---- a/net/mac80211/util.c
-+++ b/net/mac80211/util.c
-@@ -20,7 +20,9 @@
- #include <linux/if_arp.h>
- #include <linux/bitmap.h>
- #include <linux/crc32.h>
-+#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,24))
- #include <net/net_namespace.h>
-+#endif
- #include <net/cfg80211.h>
- #include <net/rtnetlink.h>
- 
---- a/net/wireless/nl80211.c
-+++ b/net/wireless/nl80211.c
-@@ -15,7 +15,9 @@
- #include <linux/rtnetlink.h>
- #include <linux/netlink.h>
- #include <linux/etherdevice.h>
-+#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,24))
- #include <net/net_namespace.h>
-+#endif
- #include <net/genetlink.h>
- #include <net/cfg80211.h>
- #include <net/sock.h>

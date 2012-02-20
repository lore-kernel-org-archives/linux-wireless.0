Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:58635 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752222Ab2BTKip (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Feb 2012 05:38:45 -0500
Subject: [PATCH] mac80211: clean up asm/unaligned.h inclusion
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 20 Feb 2012 11:38:41 +0100
Message-ID: <1329734321.3458.5.camel@jlt3.sipsolutions.net> (sfid-20120220_113847_962256_442E097C)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Some files implicitly get this via mesh.h
which itself doesn't need it, so move the
inclusion into the right files. Some other
files don't need it at all but include it,
so remove it from there.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/ibss.c      |    1 -
 net/mac80211/key.c       |    1 +
 net/mac80211/mesh.h      |    1 -
 net/mac80211/mesh_hwmp.c |    1 +
 net/mac80211/rx.c        |    1 +
 net/mac80211/status.c    |    1 +
 6 files changed, 4 insertions(+), 2 deletions(-)

--- a/net/mac80211/ibss.c	2012-02-16 09:41:51.000000000 +0100
+++ b/net/mac80211/ibss.c	2012-02-20 11:35:19.000000000 +0100
@@ -20,7 +20,6 @@
 #include <linux/etherdevice.h>
 #include <linux/rtnetlink.h>
 #include <net/mac80211.h>
-#include <asm/unaligned.h>
 
 #include "ieee80211_i.h"
 #include "driver-ops.h"
--- a/net/mac80211/key.c	2012-02-16 09:41:51.000000000 +0100
+++ b/net/mac80211/key.c	2012-02-20 11:36:34.000000000 +0100
@@ -17,6 +17,7 @@
 #include <linux/slab.h>
 #include <linux/export.h>
 #include <net/mac80211.h>
+#include <asm/unaligned.h>
 #include "ieee80211_i.h"
 #include "driver-ops.h"
 #include "debugfs_key.h"
--- a/net/mac80211/mesh.h	2012-01-11 17:59:31.000000000 +0100
+++ b/net/mac80211/mesh.h	2012-02-20 11:35:37.000000000 +0100
@@ -13,7 +13,6 @@
 
 #include <linux/types.h>
 #include <linux/jhash.h>
-#include <asm/unaligned.h>
 #include "ieee80211_i.h"
 
 
--- a/net/mac80211/mesh_hwmp.c	2012-02-03 07:24:21.000000000 +0100
+++ b/net/mac80211/mesh_hwmp.c	2012-02-20 11:36:34.000000000 +0100
@@ -8,6 +8,7 @@
  */
 
 #include <linux/slab.h>
+#include <asm/unaligned.h>
 #include "wme.h"
 #include "mesh.h"
 
--- a/net/mac80211/rx.c	2012-02-16 09:41:51.000000000 +0100
+++ b/net/mac80211/rx.c	2012-02-20 11:36:09.000000000 +0100
@@ -19,6 +19,7 @@
 #include <linux/export.h>
 #include <net/mac80211.h>
 #include <net/ieee80211_radiotap.h>
+#include <asm/unaligned.h>
 
 #include "ieee80211_i.h"
 #include "driver-ops.h"
--- a/net/mac80211/status.c	2012-02-01 05:34:47.000000000 +0100
+++ b/net/mac80211/status.c	2012-02-20 11:35:51.000000000 +0100
@@ -11,6 +11,7 @@
 
 #include <linux/export.h>
 #include <net/mac80211.h>
+#include <asm/unaligned.h>
 #include "ieee80211_i.h"
 #include "rate.h"
 #include "mesh.h"



Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:49020 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754107AbYDCNRg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Apr 2008 09:17:36 -0400
Subject: [PATCH] mac80211: clean up IEEE80211_FC use
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Thu, 03 Apr 2008 15:17:31 +0200
Message-Id: <1207228651.3636.71.camel@johannes.berg> (sfid-20080403_141738_236384_8A1C2D9E)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Really doesn't need to be defined four times.

Also, while at it, remove a useless macro (IEEE80211_ALIGN32_PAD)
and a function prototype for a function we don't actually have
(ieee80211_set_compression.)

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 net/mac80211/ieee80211_i.h   |    7 ++-----
 net/mac80211/ieee80211_sta.c |    2 --
 net/mac80211/mesh_hwmp.c     |    2 --
 net/mac80211/mesh_plink.c    |    1 -
 4 files changed, 2 insertions(+), 10 deletions(-)

--- everything.orig/net/mac80211/ieee80211_i.h	2008-04-03 15:15:53.000000000 +0200
+++ everything/net/mac80211/ieee80211_i.h	2008-04-03 15:15:56.000000000 +0200
@@ -35,9 +35,9 @@
 
 #define WLAN_FC_DATA_PRESENT(fc) (((fc) & 0x4c) == 0x08)
 
-struct ieee80211_local;
+#define IEEE80211_FC(type, subtype) cpu_to_le16(type | subtype)
 
-#define IEEE80211_ALIGN32_PAD(a) ((4 - ((a) & 3)) & 3)
+struct ieee80211_local;
 
 /* Maximum number of broadcast/multicast frames to buffer when some of the
  * associated stations are using power saving. */
@@ -902,11 +902,8 @@ extern const struct iw_handler_def ieee8
 
 
 /* ieee80211_ioctl.c */
-int ieee80211_set_compression(struct ieee80211_local *local,
-			      struct net_device *dev, struct sta_info *sta);
 int ieee80211_set_freq(struct ieee80211_local *local, int freq);
 /* ieee80211_sta.c */
-#define IEEE80211_FC(type, stype) cpu_to_le16(type | stype)
 void ieee80211_sta_timer(unsigned long data);
 void ieee80211_sta_work(struct work_struct *work);
 void ieee80211_sta_scan_work(struct work_struct *work);
--- everything.orig/net/mac80211/ieee80211_sta.c	2008-04-03 15:15:54.000000000 +0200
+++ everything/net/mac80211/ieee80211_sta.c	2008-04-03 15:15:56.000000000 +0200
@@ -58,8 +58,6 @@
 #define IEEE80211_IBSS_MAX_STA_ENTRIES 128
 
 
-#define IEEE80211_FC(type, stype) cpu_to_le16(type | stype)
-
 #define ERP_INFO_USE_PROTECTION BIT(1)
 
 /* mgmt header + 1 byte action code */
--- everything.orig/net/mac80211/mesh_hwmp.c	2008-04-03 15:15:53.000000000 +0200
+++ everything/net/mac80211/mesh_hwmp.c	2008-04-03 15:15:56.000000000 +0200
@@ -10,8 +10,6 @@
 #include <asm/unaligned.h>
 #include "mesh.h"
 
-#define IEEE80211_FC(type, stype) cpu_to_le16(type | stype)
-
 #define TEST_FRAME_LEN	8192
 #define MAX_METRIC	0xffffffff
 #define ARITH_SHIFT	8
--- everything.orig/net/mac80211/mesh_plink.c	2008-04-03 15:15:54.000000000 +0200
+++ everything/net/mac80211/mesh_plink.c	2008-04-03 15:15:56.000000000 +0200
@@ -18,7 +18,6 @@
 #define mpl_dbg(fmt, args...)	do { (void)(0); } while (0)
 #endif
 
-#define IEEE80211_FC(type, stype) cpu_to_le16(type | stype)
 #define PLINK_GET_FRAME_SUBTYPE(p) (p)
 #define PLINK_GET_LLID(p) (p + 1)
 #define PLINK_GET_PLID(p) (p + 3)



Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:53574 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752152AbYLILk0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Dec 2008 06:40:26 -0500
Subject: [PATCH] mac80211/cfg80211: check endianness in sparse runs
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Sam Ravnborg <sam@ravnborg.org>
Content-Type: text/plain
Date: Tue, 09 Dec 2008 12:39:52 +0100
Message-Id: <1228822793.22164.210.camel@johannes.berg> (sfid-20081209_124030_201406_D7FD6C5C)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Make sure sparse checks endianness when run on mac80211/cfg80211.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
Cc: Sam Ravnborg <sam@ravnborg.org>
---
It doesn't hurt setting this for the compiler as well.

 net/mac80211/Makefile |    2 ++
 net/wireless/Makefile |    2 ++
 2 files changed, 4 insertions(+)

--- everything.orig/net/mac80211/Makefile	2008-12-08 21:53:02.000000000 +0100
+++ everything/net/mac80211/Makefile	2008-12-08 21:54:02.000000000 +0100
@@ -46,3 +46,5 @@ rc80211_minstrel-$(CONFIG_MAC80211_DEBUG
 
 mac80211-$(CONFIG_MAC80211_RC_PID) += $(rc80211_pid-y)
 mac80211-$(CONFIG_MAC80211_RC_MINSTREL) += $(rc80211_minstrel-y)
+
+ccflags-y += -D__CHECK_ENDIAN__
--- everything.orig/net/wireless/Makefile	2008-12-08 21:53:02.000000000 +0100
+++ everything/net/wireless/Makefile	2008-12-08 21:54:02.000000000 +0100
@@ -8,3 +8,5 @@ obj-$(CONFIG_LIB80211_CRYPT_TKIP) += lib
 cfg80211-y += core.o sysfs.o radiotap.o util.o reg.o
 cfg80211-$(CONFIG_WIRELESS_EXT) += wext-compat.o
 cfg80211-$(CONFIG_NL80211) += nl80211.o
+
+ccflags-y += -D__CHECK_ENDIAN__



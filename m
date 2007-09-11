Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:60560 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755310AbXIKKtI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Sep 2007 06:49:08 -0400
Subject: [PATCH] mac80211: fix initialisation when built-in
From: Johannes Berg <johannes@sipsolutions.net>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Michael Wu <flamingice@sourmilk.net>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain
Date: Tue, 11 Sep 2007 12:50:32 +0200
Message-Id: <1189507832.6161.16.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When mac80211 is built into the kernel it needs to init earlier
so that device registrations are run after it has initialised.
The same applies to rate control algorithms.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>

---
 net/mac80211/ieee80211.c      |    2 +-
 net/mac80211/rc80211_simple.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

--- wireless-dev.orig/net/mac80211/ieee80211.c	2007-09-11 12:48:01.272841092 +0200
+++ wireless-dev/net/mac80211/ieee80211.c	2007-09-11 12:48:06.232834148 +0200
@@ -1501,7 +1501,7 @@ static void __exit ieee80211_exit(void)
 }
 
 
-module_init(ieee80211_init);
+subsys_initcall(ieee80211_init);
 module_exit(ieee80211_exit);
 
 MODULE_DESCRIPTION("IEEE 802.11 subsystem");
--- wireless-dev.orig/net/mac80211/rc80211_simple.c	2007-09-11 12:48:11.502839735 +0200
+++ wireless-dev/net/mac80211/rc80211_simple.c	2007-09-11 12:48:17.552835992 +0200
@@ -423,7 +423,7 @@ static void __exit rate_control_simple_e
 }
 
 
-module_init(rate_control_simple_init);
+subsys_initcall(rate_control_simple_init);
 module_exit(rate_control_simple_exit);
 
 MODULE_DESCRIPTION("Simple rate control algorithm for ieee80211");



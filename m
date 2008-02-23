Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:42870 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755479AbYBWOVo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 23 Feb 2008 09:21:44 -0500
Message-Id: <20080223142018.468705000@sipsolutions.net> (sfid-20080223_142147_964254_BDDDF6AB)
References: <20080223141703.194775000@sipsolutions.net>
Date: Sat, 23 Feb 2008 15:17:21 +0100
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org,
	Luis Carlos Cobo <luisca@cozybit.com>
Subject: [PATCH 18/18] mac80211: enable mesh in Kconfig
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Currently marked BROKEN because of endianness problems.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
See huge sparse output...

 net/mac80211/Kconfig  |   15 +++++++++++++++
 net/mac80211/Makefile |    6 ++++++
 2 files changed, 21 insertions(+)

--- everything.orig/net/mac80211/Kconfig	2008-02-23 14:57:44.000000000 +0100
+++ everything/net/mac80211/Kconfig	2008-02-23 15:00:57.000000000 +0100
@@ -81,6 +81,14 @@ config MAC80211_RC_SIMPLE
 	  Say N unless you know what you are doing.
 endmenu
 
+config MAC80211_MESH
+	bool "Enable mac80211 mesh networking (pre-802.11s) support"
+	depends on MAC80211 && EXPERIMENTAL && BROKEN
+	---help---
+	 This options enables support of pre-802.11s mesh interfaces.
+	 For more information visit http://o11s.org
+
+
 config MAC80211_LEDS
 	bool "Enable LED triggers"
 	depends on MAC80211 && LEDS_TRIGGERS
@@ -166,3 +174,10 @@ config MAC80211_VERBOSE_PS_DEBUG
 	---help---
 	  Say Y here to print out verbose powersave
 	  mode debug messages.
+
+config MAC80211_VERBOSE_MPL_DEBUG
+	bool "Verbose mesh peer link debugging"
+	depends on MAC80211_DEBUG && MAC80211_MESH
+	---help---
+	  Say Y here to print out verbose mesh peer link
+	  debug messages.
--- everything.orig/net/mac80211/Makefile	2008-02-23 14:57:44.000000000 +0100
+++ everything/net/mac80211/Makefile	2008-02-23 15:00:57.000000000 +0100
@@ -36,6 +36,12 @@ mac80211-$(CONFIG_MAC80211_DEBUGFS) += \
 	debugfs_netdev.o \
 	debugfs_key.o
 
+mac80211-$(CONFIG_MAC80211_MESH) += \
+	mesh.o \
+	mesh_pathtbl.o \
+	mesh_plink.o \
+	mesh_hwmp.o
+
 
 # Build rate control algorithm(s)
 CFLAGS_rc80211_simple.o += -DRC80211_SIMPLE_COMPILE

-- 


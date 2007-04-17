Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc11.worldnet.att.net ([204.127.131.115]:64772 "EHLO
	mtiwmhc11.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1031098AbXDQPx6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Apr 2007 11:53:58 -0400
Message-ID: <4624EE01.4020808@lwfinger.net>
Date: Tue, 17 Apr 2007 10:55:45 -0500
From: Larry Finger <larry.finger@lwfinger.net>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: [PATCH] ieee80211: Fix missing global needed for IEEE80211_DEBUG_XX  macros in ieee80211_crypt
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Using any of the IEEE80211_DEBUG_XXXX macros in any ieee80211_crypt routine
built as a module results in a missing global for 'ieee80211_debug_level'.
The fix is to export the symbol in ieee80211.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---

Index: wireless-2.6/net/ieee80211/ieee80211_module.c
===================================================================
--- wireless-2.6.orig/net/ieee80211/ieee80211_module.c
+++ wireless-2.6/net/ieee80211/ieee80211_module.c
@@ -229,6 +229,7 @@ void free_ieee80211(struct net_device *d

  static int debug = 0;
  u32 ieee80211_debug_level = 0;
+EXPORT_SYMBOL_GPL(ieee80211_debug_level);
  static struct proc_dir_entry *ieee80211_proc = NULL;

  static int show_debug_level(char *page, char **start, off_t offset,


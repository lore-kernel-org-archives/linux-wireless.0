Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc11.worldnet.att.net ([204.127.131.115]:33516 "EHLO
	mtiwmhc11.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754171AbXDPSsH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Apr 2007 14:48:07 -0400
Message-ID: <4623C561.4030201@lwfinger.net>
Date: Mon, 16 Apr 2007 13:50:09 -0500
From: Larry Finger <larry.finger@lwfinger.net>
MIME-Version: 1.0
To: Andreas Schwab <schwab@suse.de>
CC: John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, Bcm43xx-dev@lists.berlios.de,
	Michael Buesch <mb@bu3sch.de>
Subject: Re: [PATCH] ieee80211-crypt: Make some TKIP and CCMP error logging  conditional on IEEE80211_DEBUG_DROP
References: <461a68c9.Nx0/XQSxDR1PJhM4%Larry.Finger@lwfinger.net> <jeirbwfb55.fsf@sykes.suse.de>
In-Reply-To: <jeirbwfb55.fsf@sykes.suse.de>
Content-Type: multipart/mixed;
 boundary="------------060403030808010702070102"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is a multi-part message in MIME format.
--------------060403030808010702070102
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Andreas Schwab wrote:
> 
> This is causing an undefined refrence to ieee80211_debug_level with
> CONFIG_IEEE80211_DEBUG=y and CONFIG_IEEE80211_CRYPT_CCMP=m and/or
> CONFIG_IEEE80211_CRYPT_TKIP=m.
> 
> WARNING: "ieee80211_debug_level" [net/ieee80211/ieee80211_crypt_tkip.ko] undefined!
> WARNING: "ieee80211_debug_level" [net/ieee80211/ieee80211_crypt_ccmp.ko] undefined!
> 
> Andreas.

The missing symbol was not exported by ieee80211_module.c. Sorry for not testing enough. The fix is 
as follows:

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



--------------060403030808010702070102
Content-Type: text/plain;
 name="missing_debug"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="missing_debug"

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


--------------060403030808010702070102--
-: 
To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
the body of a message to majordomo@vger.kernel.org: 
More majordomo info at  http: //vger.kernel.org/majordomo-info.html

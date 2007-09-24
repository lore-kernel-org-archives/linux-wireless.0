Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:33037
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763375AbXIXQmZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Sep 2007 12:42:25 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Michael Wu <flamingice@sourmilk.net>
Subject: Re: zd1211 config operation problem
Date: Mon, 24 Sep 2007 18:41:49 +0200
Cc: Ulrich Kunitz <kune@deine-taler.de>, Daniel Drake <dsd@gentoo.org>,
	linux-wireless@vger.kernel.org,
	John Linville <linville@tuxdriver.com>
References: <200709231648.17107.mb@bu3sch.de> <200709231348.30055.flamingice@sourmilk.net>
In-Reply-To: <200709231348.30055.flamingice@sourmilk.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200709241841.50232.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sunday 23 September 2007, Michael Wu wrote:
> On Sunday 23 September 2007 10:48, Michael Buesch wrote:
> > The zd1211 driver has a bug in the ieee80211 config callback.
> > It currently unconditionally calls the set_channel() function,
> > whether the device is running or not. This causes a failed
> > bus access, if we set some config while the device is down.
> > The driver must check if the device is running before setting
> > any config on it (usb->initialized?).
> Hm, that sounds pretty terrible. mac80211 should check if the device was 
> started before trying to run any configure callbacks.

Something like that?




Subject: mac80211: Check open_count before calling config callback.

Also remove the check for ops->config!=NULL, as it can never be NULL.

Signed-off-by: Michael Buesch <mb@bu3sch.de>

Index: wireless-dev/net/mac80211/ieee80211.c
===================================================================
--- wireless-dev.orig/net/mac80211/ieee80211.c	2007-09-24 18:29:54.000000000 +0200
+++ wireless-dev/net/mac80211/ieee80211.c	2007-09-24 18:36:11.000000000 +0200
@@ -722,7 +722,7 @@ int ieee80211_hw_config(struct ieee80211
 	       local->hw.conf.phymode);
 #endif /* CONFIG_MAC80211_VERBOSE_DEBUG */
 
-	if (local->ops->config)
+	if (local->open_count)
 		ret = local->ops->config(local_to_hw(local), &local->hw.conf);
 
 	return ret;

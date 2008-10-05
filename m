Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:35383 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752581AbYJEATU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 4 Oct 2008 20:19:20 -0400
Subject: Re: Infinite loop in sta_info_debugfs_add_work().
From: Johannes Berg <johannes@sipsolutions.net>
To: Robin Holt <holt@sgi.com>
Cc: linux-wireless@vger.kernel.org, Jiri Slaby <jirislaby@gmail.com>,
	Michael Wu <flamingice@sourmilk.net>, Jiri Benc <jbenc@suse.cz>
In-Reply-To: <20081004103144.GI8534@sgi.com>
References: <20081004103144.GI8534@sgi.com>
Content-Type: text/plain
Date: Sun, 05 Oct 2008 02:19:16 +0200
Message-Id: <1223165956.24551.76.camel@johannes.berg> (sfid-20081005_021943_155021_DBEA4101)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 2008-10-04 at 05:31 -0500, Robin Holt wrote:
> I have been ignoring a hang/pause on my machine running an iwl3945
> adapter following a suspend/resume cycle.   I finally decided to start
> hunting it down.  This started with an Ubuntu kernel update to the Ubuntu
> 8.04 dist.  I don't recall seeing the hangs when I was running 7.10.
> It continued when I was testing the community 2.6.27-rc1-8 kernels.
> KDB helped me track it to one cpu's event thread infinitely looping.

[...]

> This resulted in dmesg output of:
> 656: Got sta = 0xef747270, stations = 0x0
> 658: Got sta = 0xef747270, debugfs.dir = 0x0
> 662: Got sta = 0x0
> 656: Got sta = 0xef747270, stations = 0x0
> 658: Got sta = 0xef747270, debugfs.dir = 0x0
> 662: Got sta = 0x0
> 656: Got sta = 0xef747270, stations = 0x0
> 658: Got sta = 0xef747270, debugfs.dir = 0x0
> 662: Got sta = 0x0
> 656: Got sta = 0xef747270, stations = 0x0
> 658: Got sta = 0xef747270, debugfs.dir = 0x0
> 662: Got sta = 0x0
> 
> I made up the 0xef747270 as the battery died before I had it written
> down.  The idea is correct even if the address is not.
> 
> I have no idea what this code is trying to accomplish.  I assume it is
> not corrrectly handling the case where sta->local->debugfs.stations is
> NULL.

The code's trying to add debugfs entries for all STAs that don't have
any yet. I suspect that maybe you don't have debugfs configured into
your kernel or something is wrong; anyway, the code is really abusing
the debugfs.dir as a flag "need to run ieee80211_sta_debugfs_add"; the
problem is that ieee80211_sta_debugfs_add() doesn't necessarily set
debugfs.dir to != NULL under all circumstances.

I think we'll have to add a flag, do you have a way to reproduce this?
Can you try this patch?

johannes

--- everything.orig/net/mac80211/debugfs_sta.c	2008-10-05 02:16:51.000000000 +0200
+++ everything/net/mac80211/debugfs_sta.c	2008-10-05 02:17:06.000000000 +0200
@@ -249,6 +249,8 @@ void ieee80211_sta_debugfs_add(struct st
 	DECLARE_MAC_BUF(mbuf);
 	u8 *mac;
 
+	sta->debugfs.add_has_run = true;
+
 	if (!stations_dir)
 		return;
 
--- everything.orig/net/mac80211/sta_info.c	2008-10-05 02:16:06.000000000 +0200
+++ everything/net/mac80211/sta_info.c	2008-10-05 02:18:12.000000000 +0200
@@ -635,7 +635,12 @@ static void sta_info_debugfs_add_work(st
 
 		spin_lock_irqsave(&local->sta_lock, flags);
 		list_for_each_entry(tmp, &local->sta_list, list) {
-			if (!tmp->debugfs.dir) {
+			/*
+			 * debugfs.add_has_run will be set by
+			 * ieee80211_sta_debugfs_add regardless
+			 * of what else it does.
+			 */
+			if (!tmp->debugfs.add_has_run) {
 				sta = tmp;
 				__sta_info_pin(sta);
 				break;
--- everything.orig/net/mac80211/sta_info.h	2008-10-05 02:16:09.000000000 +0200
+++ everything/net/mac80211/sta_info.h	2008-10-05 02:17:13.000000000 +0200
@@ -312,6 +312,7 @@ struct sta_info {
 		struct dentry *wme_tx_queue;
 #endif
 		struct dentry *agg_status;
+		bool add_has_run;
 	} debugfs;
 #endif
 



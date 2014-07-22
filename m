Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp-out04.msg.oleane.net ([62.161.7.2]:58503 "EHLO
	smtp-out04.msg.oleane.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753509AbaGVJwI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 22 Jul 2014 05:52:08 -0400
Received: from smtp27.msg.oleane.net (smtp27.mail.priv [172.17.20.149])
	by smtp-out04.msg.oleane.net with ESMTP id s6M9Vjhm004268
	for <linux-wireless@vger.kernel.org>; Tue, 22 Jul 2014 11:31:45 +0200
Received: from RD9 ([195.6.104.67]) (authenticated)
	by smtp27.msg.oleane.net (MSA) with ESMTP id s6M9B9Gv024041
	for <linux-wireless@vger.kernel.org>; Tue, 22 Jul 2014 11:11:10 +0200
From: "Jean-Pierre Tosoni" <jp.tosoni@acksys.fr>
To: <linux-wireless@vger.kernel.org>
Subject: get_expected_throughput introduces a kernel oops on sta_set_sinfo calls
Date: Tue, 22 Jul 2014 11:11:07 +0200
Message-ID: <004101cfa58c$e0ccb3f0$a2661bd0$@acksys.fr> (sfid-20140722_115212_527421_1611CD6B)
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi list,

I am using compat-wireless-20132-04-16 with kernel 3.3.8.
I experienced a kernel oops after applying the "get_expected_throughput"
patches series from Antonio Quartulli.
It happens when a station_dump is issued from userspace while an association
has begun but does not complete immediately due to bad channel.
After some debugging I made this patch which solves the issue:
===========================================================================
--- a/net/mac80211/rc80211_minstrel.c
+++ b/net/mac80211/rc80211_minstrel.c
@@@ -708,6 +708,15 @@ static u32 minstrel_get_expected_throughput(
 	struct minstrel_sta_info *mi = priv_sta;
 	int idx = mi->max_tp_rate[0];
 
+	if (!mi->r) {
+		/*
+		 * Happens if get_expected_throughput() is called by
+		 * ieee80211_dump_station during association from HT
+		 * client to AP, before getting the HT IE from the AP
+		 */
+		printk(KERN_ERR "minstrel: uninitialized station rates");
+		return 0; /* value suggested by J. Berg 25-apr-2014 */
+	}
 	/* convert pkt per sec in kbps (1200 is the average pkt size used
for
 	 * computing cur_tp
 	 */
===========================================================================

With this patch I get this trace (the timeout is expected, since the SNR is
very low):

[  359.798796] wlan0: authenticate with 92:a4:de:21:4f:85

[  359.813180] wlan0: direct probe to 92:a4:de:21:4f:85 (try 1/3)

[  359.922306] wlan0: direct probe to 92:a4:de:21:4f:85 (try 2/3)

[  360.005424] minstrel: uninitialized station rates

[  360.030318] wlan0: direct probe to 92:a4:de:21:4f:85 (try 3/3)

[  360.138294] wlan0: authentication with 92:a4:de:21:4f:85 timed out

Maybe station_dump should not dump the stations just created by an
yet-unanswered authentication request?
Or is my patch the right thing to do?

Regards
Jean-Pierre Tosoni


Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp02.msg.oleane.net ([62.161.4.2]:34487 "EHLO
	smtp02.msg.oleane.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752132Ab2EaQjy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 31 May 2012 12:39:54 -0400
Received: from acksys.fr ([195.6.104.67]) (authenticated)
	by smtp02.msg.oleane.net (MTA) with ESMTP id q4VGdqA4030534
	for <linux-wireless@vger.kernel.org>; Thu, 31 May 2012 18:39:52 +0200
MIME-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Subject: mac80211/scan.c: scanning ceases after a double rescheduling
Date: Thu, 31 May 2012 18:39:51 +0200
Message-ID: <773DB8A82AB6A046AE0195C68612A319012CA1B7@sbs2003.acksys.local> (sfid-20120531_184004_280948_42581D0B)
From: "Jean-Pierre TOSONI" <jp.tosoni@acksys.fr>
To: <linux-wireless@vger.kernel.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello all,

I am using compat-wireless-2012-04-17 in a OpenWrt box, client mode,
kernel 2.6.33.
I arrange to run an active background scan every second under some load
(iperf UDP 40 Mbps).

I observed that the probes can be delayed due to two events flagged as
IEEE80211_STA_BEACON_POLL and IEEE80211_STA_CONNECTION_POLL. They make
__ieee80211_start_scan() return early in mac80211/scan.c when it is
called by ieee80211_request_scan().

When one of these events occurs, the function returns and
__ieee80211_start_scan() is reentered later, called this time by
ieee80211_scan_work(). Now if it finds the other event flagged, it
returns early but will never be called again. As a result later scan
requests result in a "EBUSY" error.

I made a workaround by always returning an error, but I am pretty sure
this is a wrong solution. I wonder if scan_work should not be
rescheduled in this case.

Here is my try:
==================
--- a/mac80211/scan.c   2012-05-31 18:37:41.000000000 +0200
+++ b/mac80211/scan.c   2012-05-31 18:37:48.000000000 +0200
@@ -413,10 +413,7 @@
                return -EBUSY;

        if (!ieee80211_can_scan(local, sdata)) {
-               /* wait for the work to finish/time out */
-               local->scan_req = req;
-               local->scan_sdata = sdata;
-               return 0;
+               return -EAGAIN;
        }

        if (local->ops->hw_scan) {
==================

Any thoughts / suggestions ?

Thanks,

Jean-Pierre Tosoni


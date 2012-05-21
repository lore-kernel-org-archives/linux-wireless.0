Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qc0-f174.google.com ([209.85.216.174]:35139 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751061Ab2EUW3b convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 May 2012 18:29:31 -0400
Received: by qcro28 with SMTP id o28so3581733qcr.19
        for <linux-wireless@vger.kernel.org>; Mon, 21 May 2012 15:29:30 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CADfcX6r=GuQh2kdC_OEX9fvfGjWXeGwFKGTfFWs-88nqgGNF_Q@mail.gmail.com>
References: <20120521190547.3E23A8061C@gary-pc2.mtv.corp.google.com>
	<1337628372.11626.0.camel@jlt3.sipsolutions.net>
	<CADfcX6r=GuQh2kdC_OEX9fvfGjWXeGwFKGTfFWs-88nqgGNF_Q@mail.gmail.com>
Date: Mon, 21 May 2012 15:29:30 -0700
Message-ID: <CADfcX6pjFEWyxd5o-t7yPdr+6MkB+7ZvQ-TgAe1A894h7C5vTw@mail.gmail.com> (sfid-20120522_002940_355829_8018E27C)
Subject: [PATCH] CHROMIUMOS: mac80211: Increase retry attempts for nullfunc probes
From: Gary Morain <gmorain@chromium.org>
To: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes@sipsolutions.net>
Cc: pstew@chromium.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

[resending in plan text]

On Mon, May 21, 2012 at 12:26 PM, Johannes Berg <johannes@sipsolutions.net>
wrote:
>
> On Fri, 2012-05-18 at 13:49 -0700, Gary Morain wrote:
> > When a nullfunc probe fails for lack of an ACK, it is retried
> > almost immediately.  The current setting of 2 retries completes
> > in about 4 ms.  If an AP is off-channel scanning, this is not
> > enough time for the AP to return to the operating channel and
> > ACK the nullfunc.  As a result, the client disconnects when the
> > AP is still there and operating.
>
> AP is off-channel, scanning? It can't be unless it's a GO and then you
> have GO powersave, right?

Scenario:
1.  Client connects to a managed AP.
2.  Client goes off-channel to scan for APs.
3.  AP goes off-channel to scan for rogue APs.  The client misses any
signaling the AP may have sent.
4.  The client returns to its home channel before the AP does.
5.  The client immediately probes the AP with a nullfunc.
(ieee80211_mlme_notify_scan_completed()).
6.  The AP does not respond to the nullfunc because it is off-channel.
7.  The client retries the nullfunc, which also does not get an ACK, and the
client disconnects from the AP (ieee80211_sta_work).

It's worth noticing that the client never detects beacon loss because the AP
is not off-channel long enough to miss sending multiple beacons.


>
>
> > -static int max_nullfunc_tries = 2;
> > +static int max_nullfunc_tries = 100;
>
> 100? That seems insanely high compared to the other one.


100 retries take about 200 ms.  In my testing, the range of time that the AP
was off-channel after the client returned home ranged from 20 to 104 ms.  I
did a test with the retry set to 50, but it was too low some of the time.
 100 gives plenty of headroom.

>
>
> johannes
>

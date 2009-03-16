Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:24428 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751112AbZCPE5r (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Mar 2009 00:57:47 -0400
Received: from mail.atheros.com ([10.10.20.86])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Sun, 15 Mar 2009 21:57:46 -0700
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <18877.56125.181203.703218@gargle.gargle.HOWL> (sfid-20090316_055750_515539_05E8AF65)
Date: Mon, 16 Mar 2009 10:23:17 +0530
To: Bob Copeland <me@bobcopeland.com>
CC: Johannes Berg <johannes@sipsolutions.net>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	<Jouni.Malinen@Atheros.com>
Subject: Re: [PATCH] mac80211: Tear down aggregation sessions for suspend/resume
In-Reply-To: <b6c5339f0903151828m4e5b3d2dg5ae03bbed5538bd4@mail.gmail.com>
References: <18876.41851.397740.847705@gargle.gargle.HOWL>
	<1237140134.24621.0.camel@johannes.local>
	<b6c5339f0903151828m4e5b3d2dg5ae03bbed5538bd4@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Bob Copeland wrote:
> On Sun, Mar 15, 2009 at 2:02 PM, Johannes Berg
> <johannes@sipsolutions.net> wrote:
> > On Sun, 2009-03-15 at 12:13 +0530, Sujith wrote:
> >> When the driver has been notified with a STA_REMOVE, it tears down
> >> the internal ADDBA state. On resume, trying to initiate aggregation would
> >> fail because mac80211 has not cleared the operational state for that <TID,STA>.
> >> This can be fixed by tearing down the existing sessions on a suspend.
> >
> > Agreed, but Bob said there were some deadlocks with this?
> 
> I think the deadlock went away, not sure what fixed it but I guess
> the HT rework.  I tested it a couple of weeks ago on ath5k and Luis
> did on ath9k so I say let's go ahead and apply the patch... in the
> meantime I'll try again on ath5k just to be sure.

There is a window for a race. Something like this:

>From mac80211:

__ieee80211_suspend()
     tear_down_BA_sessions(TX, RX)
          ampdu_action(STOP)
               remove_vifs()

At this point, the driver executes its remove_interface routine.
While we are doing this, a TX completion interrupt could be raised,
(HW hasn't been stopped yet) and nothing stops the driver from calling
ieee80211_start_tx_ba_session().

So the question is: should mac80211 deny ADDBA requests in this case ?

Sujith

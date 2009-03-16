Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:17368 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751629AbZCPHne (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Mar 2009 03:43:34 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 16 Mar 2009 00:43:33 -0700
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <18878.551.886600.777650@gargle.gargle.HOWL> (sfid-20090316_084341_295452_62AB83A0)
Date: Mon, 16 Mar 2009 13:09:19 +0530
To: Johannes Berg <johannes@sipsolutions.net>
CC: Bob Copeland <me@bobcopeland.com>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Jouni Malinen <Jouni.Malinen@Atheros.com>
Subject: Re: [PATCH] mac80211: Tear down aggregation sessions for
 suspend/resume
In-Reply-To: <1237187728.27769.2.camel@johannes.local>
References: <18876.41851.397740.847705@gargle.gargle.HOWL>
	<1237140134.24621.0.camel@johannes.local>
	<b6c5339f0903151828m4e5b3d2dg5ae03bbed5538bd4@mail.gmail.com>
	<18877.56125.181203.703218@gargle.gargle.HOWL>
	<1237187728.27769.2.camel@johannes.local>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg wrote:
> > There is a window for a race. Something like this:
> > 
> > From mac80211:
> > 
> > __ieee80211_suspend()
> >      tear_down_BA_sessions(TX, RX)
> >           ampdu_action(STOP)
> >                remove_vifs()
> > 
> > At this point, the driver executes its remove_interface routine.
> > While we are doing this, a TX completion interrupt could be raised,
> > (HW hasn't been stopped yet) and nothing stops the driver from calling
> > ieee80211_start_tx_ba_session().
> > 
> > So the question is: should mac80211 deny ADDBA requests in this case ?
> 
> Interesting observation. We probably should indeed reject that, and also
> if the peer asks for sending aggregation again right away like some
> Broadcom APs will.

Yep, both TX and RX aggregation requests have to be denied.
And this patch would be incomplete without handling this case.
Will send a v2.

Sujith

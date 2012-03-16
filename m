Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:57496 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753171Ab2CPNB2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Mar 2012 09:01:28 -0400
Subject: RE: mac80211 20/40 coexist
From: Johannes Berg <johannes@sipsolutions.net>
To: "Manoharan, Rajkumar" <rmanohar@qca.qualcomm.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <8F3AF1C9F856774F8C8D67AA7EDFEC8801E3005E@aphydexd01b>
References: <1331818214.3432.12.camel@jlt3.sipsolutions.net>
	 <8F3AF1C9F856774F8C8D67AA7EDFEC8801E3005E@aphydexd01b>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 16 Mar 2012 14:01:25 +0100
Message-ID: <1331902885.6753.10.camel@jlt3.sipsolutions.net> (sfid-20120316_140157_658300_7E065B29)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

[I'll also fold in your other email]

> Not calling hw_config could affect drivers like ath9k_htc where the rate control runs in the firmware.
> Those drivers will update the rate control based on CHANGED_HT flag.

Yeah that's actually an interesting point -- but we have it wrong right
now I think. Did you see Paul's recent patch? We really shouldn't be
reconfiguring the channel if all we want is to stop transmitting 40 MHz,
we should just update rate control only. Now for in-device rate control
that isn't really possible today since they can't get rate_update(), but
that means we should add a separate callback, I think?

> > If we do that, is it still necessary to stop the queues for it? It seems
> > like it shouldn't.
> 
> Actually the queue stop was added to avoid mismatches b/w hw and rate control. But If you dont stop the queues
> before the rate control change, the station might send the frames in different ht mode (for example ht40) wrt AP's ht mode (ht20).

Yes, but that's probably OK. It's going to do that anyway since there
are still frames in the hardware queues, and those will go out without
updated rate information. There can be no guarantee (without having some
form of hardware assist) that from the point we receive a 20/40
notification we'll send the right bandwidth.


In the other mail you said almost the same thing:

> The queue stop was added to avoid sending frames while the hw
> reconfigure is in progress.
> So that we can prevent differences b/w hw and rate control ht mode.
> But I doubt that hw_reconfig
> removal could not affect split drivers where the rc is offloaded.

Like above, I think we need a new callback for rc offloaded drivers so
that they can update when the bandwidth changes -- I do remove the
bandwidth update after all, i.e. we no longer reconfigure the channel
when it's desired to no longer TX 40 MHz.

I'll think about offloaded rate control a bit more.

johannes


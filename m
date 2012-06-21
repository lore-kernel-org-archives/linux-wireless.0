Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:49001 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758753Ab2FUI0z (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Jun 2012 04:26:55 -0400
Message-ID: <1340267205.4489.4.camel@jlt3.sipsolutions.net> (sfid-20120621_102700_636990_8B1E6AC4)
Subject: Re: [PATCH 1/2] cfg80211: Support for automatic channel selection
 in AP mode
From: Johannes Berg <johannes@sipsolutions.net>
To: Michal Kazior <michal.kazior@tieto.com>
Cc: Vivek Natarajan <vivek.natraj@gmail.com>,
	Vivek Natarajan <nataraja@qca.qualcomm.com>,
	"jouni@qca.qualcomm.com" <jouni@qca.qualcomm.com>,
	"kvalo@qca.qualcomm.com" <kvalo@qca.qualcomm.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Thu, 21 Jun 2012 10:26:45 +0200
In-Reply-To: <4FE2BD58.60805@tieto.com>
References: <1340017242-6436-1-git-send-email-nataraja@qca.qualcomm.com>
	  <1340182500.4655.47.camel@jlt3.sipsolutions.net>
	  <CAJqpcCQ34PFxAapy0q1WCQQO8NehV+niwEHpbbTDL+e=rJ7X=w@mail.gmail.com>
	  (sfid-20120620_114256_209959_B1E0B5E9) <1340206900.4655.77.camel@jlt3.sipsolutions.net>
	 <4FE2BD58.60805@tieto.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2012-06-21 at 08:21 +0200, Michal Kazior wrote:

> > The reason I'm talking about this is the channel concurrency framework
> > that Michal is working on, which would conflict somehow with this I
> > think.
> 
> Hmm.. we should be able to deal with it. I have a couple of ideas:
> 
>   a) treat ACS AP as a non-fixed channel IBSS (i.e. reserve a single
>      channel resource); once channel notifications comes in we'd drop
>      the behaviour
> 
>   b) trust the driver it won't do anything funny (we already trust it
>      with channel switch notification)
> 
> 
> The a) requires more tricks to be done. Once we run out of channels to 
> run on we need to either:
> 
>   1) reject it and leave it to userspace to handle (i.e. retry .start_ap
>      without ACS)
> 
>   2) disable ACS implicitly and pick a channel ourselves (we'd need to
>      do a synthetic channel switch notification to userspace)
> 
>   3) extend ACS to accept channel list, so we could implicitly reduce it
>      to channels we're already on (probably involves some nice hackery)
> 

Seems tricky :-)

> The b) seems to have an issue. Consider the following scenario:
> 
>      [ no channels are used, max 1 channel concurrency, max 2 APs ]
>   1. wlan0: .start_ap with ACS
>      [ driver is starting ACS AP.. ]
>   2. wlan1: .start_ap on channel 1
>      [ the driver is probably locked right now
>        as it needs to complete (1); even if it's not locked
>        (1) probably can't be influenced by (2) anymore.
>        once it completes (1) it might end up on channel 6 on wlan0.
>        this means (2) fails kind of unexpectedly ]

I suspect that in this case the driver would have to fail the
second .start_ap though, since it's actually doing ACS at that time ...


johannes


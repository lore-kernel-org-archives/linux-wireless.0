Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:54524 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763241AbYBZPob (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Feb 2008 10:44:31 -0500
Subject: Re: mesh beaconing questions
From: Dan Williams <dcbw@redhat.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Luis Carlos Cobo <luisca@cozybit.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Javier Cardona <javier@cozybit.com>
In-Reply-To: <1204034825.13162.233.camel@johannes.berg>
References: <1204034825.13162.233.camel@johannes.berg>
Content-Type: text/plain
Date: Tue, 26 Feb 2008 10:42:08 -0500
Message-Id: <1204040528.30146.44.camel@localhost.localdomain> (sfid-20080226_154508_024531_7A859FA3)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2008-02-26 at 15:07 +0100, Johannes Berg wrote:
> Hi,
> 
> The Draft states that beacons may be sent either as defined for IBSS or
> as defined for infrastructure mode.
> 
> I have a few questions, some of which are related to our implementation
> and others which are related to the Draft.
> 
> 1. Are we going to let drivers choose which mode to use? Should they
> indicate that somehow so userspace knows? Or are we going to make this
> configurable? Can all hardware support both modes? (the last question
> probably ties in with the next)
> 
> 2. The Draft states to use either procedures 11.1.2.2 (IBSS) or 11.1.2.1
> (infrastructure). It is easy to "port" 11.1.2.1 to mesh, but 11.1.2.2
> reads like this:

Next question, more relevant to how this affects the user:

What's the meaningful difference between these two choices?  When would
you use one and when would you use the other?  Should the user (ie, a
user of something like NetworkManager) care whether a particular node is
doing IBSS or infrastructure beacons?

Dan

> --- >% ---
> [...]
> 
> At each TBTT, the STA shall:
> 
> [...]
> 
>  (d) Cancel the remaining random delay and the pending beacon
>      transmission, if a beacon arrives from the IBSS of which the STA is
>      a member before the random delay timer has expired, at which time
>      the ATIM backoff timer shall resume decrementing.
> [...]
> --- %< ---
> 
> However, I feel that pointing from the mesh amendement to something
> rather IBSS specific is not well defined. This clause doesn't
> "obviously" port to mesh since the BSSID is left zeroed in mesh! But the
> draft doesn't change 11.1.2.2 either to adjust for this difference.
> 
> Hence, I think the draft needs to be expanded to modify 11.1.2.2 to
> explain under which circumstances an MP shall cancel its beacon if it
> opts to use IBSS-like beaconing.
> 
> I think the only useful thing is to require it to look at the mesh IEs,
> but that is not implementable with existing hardware, at least not
> without firmware changes. I could probably do it in Broadcom firmware
> fairly easily...
> 
> So now I've probably answered my first question implicitly because I
> pointed out how I think using IBSS-like beaconing isn't even
> well-defined ;)
> 
> johannes


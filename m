Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:63964 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751910Ab1AGUJO (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Jan 2011 15:09:14 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Fri, 07 Jan 2011 12:08:57 -0800
Date: Fri, 7 Jan 2011 12:09:13 -0800
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Ben Greear <greearb@candelatech.com>
CC: Johannes Berg <johannes@sipsolutions.net>,
	"ath9k-devel@venema.h4ckr.net" <ath9k-devel@venema.h4ckr.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: [ath9k-devel] [PATCH 1/3] ath9k: Decrease skb size to fit into
 one page.
Message-ID: <20110107200913.GF21588@tux>
References: <1294361165-15308-1-git-send-email-greearb@candelatech.com>
 <1294397880.3467.1.camel@jlt3.sipsolutions.net>
 <4D275CCC.90905@candelatech.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <4D275CCC.90905@candelatech.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jan 07, 2011 at 10:34:52AM -0800, Ben Greear wrote:
> On 01/07/2011 02:58 AM, Johannes Berg wrote:
> > On Thu, 2011-01-06 at 16:46 -0800, greearb@candelatech.com wrote:
> >> From: Ben Greear<greearb@candelatech.com>
> >>
> >> Patch is from Eric Dumazet, as described here:
> >> https://patchwork.kernel.org/patch/104271/
> >>
> >> Reported-by: Michael Guntsche<mike@it-loops.com>
> >> Signed-off-by: Eric Dumazet<eric.dumazet@gmail.com>
> >> Signed-off-by: Ben Greear<greearb@candelatech.com>
> >> ---
> >>
> >> NOTE:  This needs review by ath9k and/or other informed
> >> people.
> >
> > This doesn't make sense. It might help, but it'll probably lead to not
> > being able to receive all frames off the air.
> >
> > If this is an issue, ath9k should do paged RX like iwlwifi.
> 
> Ok, I backed this out..but now I'm back to getting buffer allocation
> failures (and this is on a system with 2GB RAM).
> 
> Seems it's coming from mac80211 instead of ath9k, at least most of
> the time (I'm using 60 stations, so it probably needs to make lots of
> copies in the rx path).  The traffic I'm generating/receiving is 1024 byte UDP
> payloads.
> 
> Does this mean I really received a packet that was 3872 bytes long,
> or is the skb_copy allocating/copying empty data?

Good question. The buffer we setup for DMA should be large since we
need to support AMSDU RX up to a certain bytes of RX data for the frame.
Harwdware should tell us the right size for the RX'd data and the skb
should be set with that size, respectively. Following this logic,
skb_copy() should only allocate on the order of the required skb->len.

Remember that trick we did to force the older memory leak issues by
forcing an skb_copy() on every RX'd frame and then just discarding that
buffer immediately? You can try to do the same and print the skb->len
there, just to check what's going on.

  Luis

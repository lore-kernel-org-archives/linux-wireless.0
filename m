Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:34004 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755077AbbCRUHZ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Mar 2015 16:07:25 -0400
Message-ID: <1426709222.3001.42.camel@sipsolutions.net> (sfid-20150318_210732_129260_4451022D)
Subject: Re: [PATCH v4] mac80211: add an intermediate software queue
 implementation
From: Johannes Berg <johannes@sipsolutions.net>
To: Felix Fietkau <nbd@openwrt.org>
Cc: linux-wireless@vger.kernel.org
Date: Wed, 18 Mar 2015 21:07:02 +0100
In-Reply-To: <5509DA00.6030002@openwrt.org>
References: <1426609283-83954-1-git-send-email-nbd@openwrt.org>
	 <1426707672.3001.39.camel@sipsolutions.net> <5509DA00.6030002@openwrt.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2015-03-18 at 21:03 +0100, Felix Fietkau wrote:
> On 2015-03-18 20:41, Johannes Berg wrote:
> >> + * The driver is expected to release its own buffered frames and also call
> >> + * ieee80211_tx_dequeue() within that callback.
> > 
> > Perhaps that should read
> > "The driver is expected to release its own buffered frames (if any) and
> > request the remaining dequeued frames by calling
> > ieee80211_tx_dequeue()."
> > 
> > I'm not really sure it needs to be within that callback? I see no
> > particular reason for that.
> Releasing multiple packets works, even if there is only one packet
> buffered in the driver and the rest in the txq. It also keeps the code
> more consistent.

Right. I still phrased that badly. I meant that the "also" should be
limited by the number of frames really needed, i.e. use driver-buffered
first and fill up with any mac80211-buffered by dequeuing. That's
probably obvious enough though.

Anyway - not sure it needs to be in the callback?

> Now that I'm thinking about this some more, it might even make sense to
> skip the sta PS queue for txq-enabled drivers. That would allow all sta
> data frames to either go through driver scheduling or
> release_buffered_frames.

Well, it's slightly more complicated due to the filtered queue. Not sure
you want to 'pollute' the TXQ abstraction with that?

> If I don't lock here, one last dequeue call might still be running on
> another CPU. This would produce a theoretical race in accessing the
> sequence number, which the caller of this function reads before setting
> up the BA request.
> Dequeueing happens outside of the normal network stack tx context, so
> synchronize_net is not enough.

Ah, makes sense, I didn't think of the seqno. Can you please put that in
a comment somewhere? :)

johannes


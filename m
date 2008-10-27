Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.237]:28612 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750784AbYJ0ON7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Oct 2008 10:13:59 -0400
Received: by rv-out-0506.google.com with SMTP id k40so2152958rvb.1
        for <linux-wireless@vger.kernel.org>; Mon, 27 Oct 2008 07:13:58 -0700 (PDT)
From: Sujith <m.sujith@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <18693.52244.207787.514254@localhost.localdomain> (sfid-20081027_151403_958679_6F99B64C)
Date: Mon, 27 Oct 2008 19:41:32 +0530
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Luis Rodriguez <Luis.Rodriguez@Atheros.com>,
	"tomasw@gmail.com" <tomasw@gmail.com>
Subject: Re: [RFC] mac80211: Re-enable aggregation
In-Reply-To: <1224773124.6002.32.camel@johannes.berg>
References: <18684.16351.638713.791015@gargle.gargle.HOWL>
	<1224491480.18024.32.camel@johannes.berg>
	<18684.18492.94865.480736@gargle.gargle.HOWL>
	<1224493957.18024.47.camel@johannes.berg>
	<18684.20459.335157.171344@gargle.gargle.HOWL>
	<1224495531.18024.55.camel@johannes.berg>
	<18684.24323.743610.871307@gargle.gargle.HOWL>
	<1224505349.27899.17.camel@johannes.berg>
	<18684.51206.771543.514682@localhost.localdomain>
	<1224669612.28639.49.camel@johannes.berg>
	<18688.17545.136327.991699@gargle.gargle.HOWL>
	<1224773124.6002.32.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg wrote:
> If that was done in the RC at least (could easily be moved I suppose)
> and you cleaned up the RC, then surely nbd would play with porting
> minstrel and making it aware of such things, which probably makes for a
> better RC... And since you have to clean up the RC anyway :)
> 

Sure, just migrating to minstrel would be the better option. It would
probably need to be spruced up a bit to accommodate aggregation specific
data.

> > I was talking about this:
> > (txq->axq_depth < ATH_AGGR_MIN_QDEPTH) in ath_tx_sched_aggr()@xmit.c
> 
> But what does this invariant mean? ATH_AGGR_MIN_QDEPTH is 2.
> 

Well, this is not relevant when frames are aggregated and sent down
by mac80211. That check was present because frames were being created and
sent in the TX tasklet.

> > How would mac80211 buffer frames ? 
> 
> Well I suppose it would just put them on a list in the sta_info struct.
> 

A list for each TID, no ?

> > Would it wait for enough sub-frames
> > to fill an A-MPDU ?
> 
> It should, no? And if for some reason that doesn't happen fast enough it
> can send them out anyway, it'll just be a shorter A-MPDU, no?
> 
> >  When does it decide that buffered frames have to
> > be pushed down to the driver ?
> 
> When the A-MPDU is full, subject to the TX and RX constraints, or when
> too much time has passed maybe?
> 
> I really don't know. But I'd like to get to a model where we can
> implement other drivers without having to keep track of all this like
> ath9k does.

To summarize a bit about the state/control information that mac80211 needs
to maintain for an aggregation session:

* Block Ack state for each TID (sequence numbers, BA window etc.)
* Maintain a list of buffers for each <RA,TID> (setup, teardown etc.)
* Handle retransmission of unacked frames.

Forming an aggregate would involve the following.
( These might depend on HW caps as well as the recipient STA's caps)

* Aggregate length
* Delimiters
* Padding of sub-frames

TX control information will probably need to pass aggr. specific information
(number of delimiters etc.)

The API for aggregation can extend the ampdu_action() callback.
Adding a few more states can probably suffice initially.

We'll work on this and come up with an RFC.

Sujith

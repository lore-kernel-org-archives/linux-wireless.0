Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:57108 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751032AbYJWI7o (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Oct 2008 04:59:44 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Thu, 23 Oct 2008 01:59:44 -0700
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <18688.15460.336059.400706@gargle.gargle.HOWL> (sfid-20081023_105949_709705_A7925F01)
Date: Thu, 23 Oct 2008 14:27:08 +0530
To: Johannes Berg <johannes@sipsolutions.net>
CC: Tomas Winkler <tomasw@gmail.com>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Luis Rodriguez <Luis.Rodriguez@Atheros.com>
Subject: Re: [RFC] mac80211: Re-enable aggregation
In-Reply-To: <1224696170.30459.12.camel@johannes.berg>
References: <18684.16351.638713.791015@gargle.gargle.HOWL>
	<18684.18492.94865.480736@gargle.gargle.HOWL>
	<1224493957.18024.47.camel@johannes.berg>
	<18684.20459.335157.171344@gargle.gargle.HOWL>
	<1224495531.18024.55.camel@johannes.berg>
	<18684.24323.743610.871307@gargle.gargle.HOWL>
	<1224505349.27899.17.camel@johannes.berg>
	<18684.51206.771543.514682@localhost.localdomain>
	<1ba2fa240810201446x429e0b5aud3f20e2fadb19f1@mail.gmail.com>
	<1224669827.28639.54.camel@johannes.berg>
	<1ba2fa240810220459m1dcffd24k58cf6b72c688913c@mail.gmail.com>
	<1224696170.30459.12.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg wrote:
> On Wed, 2008-10-22 at 13:59 +0200, Tomas Winkler wrote:
> 
> > It answers BA i n RX path and interpret BA in TX Scheduling
> > retransmission of not acked frames is done in HW (not firmware) no
> > need to requeue them. In corner case when retries are exhausted  BA
> > request is issued from mac80211 to advance RX side window.
> 
> Ok, but if we do both of that in mac80211, it wouldn't really matter
> since we never see the relevant frames, right? Or we can add a flag to
> ignore them.
> 
> > > Like I said, from what I can tell bcom is really similar, and I'd like
> > > to not have to re-implement all this first. mac80211 used to have a more
> > > push-model, which we've deviated from with the HT stuff you did, but for
> > > most hardware the push-model is still appropriate, so imho we should try
> > > to go to one even with HT and then see.
> > 
> > Works for me. What I stumble upon is retransmission from within TX
> > response  path
> > how this go together with context of regular TX path. Even in iwlwifi
> > we need to be able to kick/start the internal aggregation queue?
> 
> Yeah, this is something we definitely need to work out. We haven't even
> managed to decide yet how aggregated packets are given to the driver :)
> I think for atheros and bcom a model where mac80211 decides pretty much
> everything and hands the driver a list of skbs to aggregate would work
> best, but then I think that wouldn't work with your hw at all.
> 

Retransmission of unacked frames is done within the driver, in ath9k.
In case of retry exhaustion (failed transmission), we do what Intel does,
i.e, request for a BAR to be sent out.

Sujith

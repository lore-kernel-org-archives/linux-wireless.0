Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:16225 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752048Ab0H0Sad (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Aug 2010 14:30:33 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Fri, 27 Aug 2010 11:30:28 -0700
Date: Fri, 27 Aug 2010 11:30:31 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Johannes Berg <johannes@sipsolutions.net>
CC: Luis Rodriguez <Luis.Rodriguez@Atheros.com>,
	Jouni Malinen <j@w1.fi>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Kalle Valo <kvalo@adurom.com>,
	Amod Bodas <Amod.Bodas@Atheros.com>
Subject: Re: [RFT] mac80211: fix broadcast/multicast data drop on scan
Message-ID: <20100827183031.GB7317@tux>
References: <1282887527-23259-1-git-send-email-lrodriguez@atheros.com>
 <20100827090655.GA15873@jm.kir.nu>
 <AANLkTimw1MpiKM=rCfp_zxkw855SyaoZg6m1oB354tCF@mail.gmail.com>
 <1282923444.4377.13.camel@jlt3.sipsolutions.net>
 <AANLkTi=qWjhwo50hg8HB1wtsyUizAi55SEK9EW0Udckv@mail.gmail.com>
 <1282923799.4377.14.camel@jlt3.sipsolutions.net>
 <AANLkTinP7Mzk6gNL3DZaByOj5DZG=nCo2s_ne3WeN0+p@mail.gmail.com>
 <1282924294.4377.15.camel@jlt3.sipsolutions.net>
 <AANLkTikkemr390C4N2bPivp9rZhbdSpUw9=+uvS=y-Mq@mail.gmail.com>
 <1282924722.4377.17.camel@jlt3.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <1282924722.4377.17.camel@jlt3.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Aug 27, 2010 at 08:58:42AM -0700, Johannes Berg wrote:
> On Fri, 2010-08-27 at 08:55 -0700, Luis R. Rodriguez wrote:
> > On Fri, Aug 27, 2010 at 8:51 AM, Johannes Berg
> > <johannes@sipsolutions.net> wrote:
> > > On Fri, 2010-08-27 at 08:48 -0700, Luis R. Rodriguez wrote:
> > >
> > >> > Well, there's no way we can reliably wake up exactly before a beacon by
> > >> > implementing that in software, hard real-time hasn't been achieved in
> > >> > Linux yet :-)
> > >>
> > >> Keyword here is *exactly*. I don't want to wake up *exactly* at DTIM,
> > >> only ensure we don't sleep during it and the send buffered frames and
> > >> multicast traffic data. Why can we not implement this on mac80211?
> > >
> > > Well, how long before the beacon do you want to wake up to catch it?
> > > 1ms? 10ms? 100ms? 1000ms? What if the system is busy?
> > 
> > I cannot say what would work best, how about half a beacon interval early?
> 
> Why are we even discussing this anyway? It doesn't matter for a power
> save implementation since you better offload it to the device so you get
> as exact timing as you can?

ath9k hardware does not have a CPU to offload this. I just noticed we do
however already wait for the dtim count to go to 0 and also all RX'd buffered
data through ath_rx_ps() but even if then it seems we need and API to enable
drivers to flag when they want to disallow scanning (dynamic power save can be
disabled already by the driver at will I think). Otherwise we would have to
use something like the patch I'm going to send, which is fine for now.

 Luis

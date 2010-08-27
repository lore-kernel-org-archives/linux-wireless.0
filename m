Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:56822 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751597Ab0H0P6p (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Aug 2010 11:58:45 -0400
Subject: Re: [RFT] mac80211: fix broadcast/multicast data drop on scan
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: Jouni Malinen <j@w1.fi>, linux-wireless@vger.kernel.org,
	Kalle Valo <kvalo@adurom.com>,
	Amod Bodas <Amod.Bodas@atheros.com>
In-Reply-To: <AANLkTikkemr390C4N2bPivp9rZhbdSpUw9=+uvS=y-Mq@mail.gmail.com>
References: <1282887527-23259-1-git-send-email-lrodriguez@atheros.com>
	 <20100827090655.GA15873@jm.kir.nu>
	 <AANLkTimw1MpiKM=rCfp_zxkw855SyaoZg6m1oB354tCF@mail.gmail.com>
	 <1282923444.4377.13.camel@jlt3.sipsolutions.net>
	 <AANLkTi=qWjhwo50hg8HB1wtsyUizAi55SEK9EW0Udckv@mail.gmail.com>
	 <1282923799.4377.14.camel@jlt3.sipsolutions.net>
	 <AANLkTinP7Mzk6gNL3DZaByOj5DZG=nCo2s_ne3WeN0+p@mail.gmail.com>
	 <1282924294.4377.15.camel@jlt3.sipsolutions.net>
	 <AANLkTikkemr390C4N2bPivp9rZhbdSpUw9=+uvS=y-Mq@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 27 Aug 2010 17:58:42 +0200
Message-ID: <1282924722.4377.17.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2010-08-27 at 08:55 -0700, Luis R. Rodriguez wrote:
> On Fri, Aug 27, 2010 at 8:51 AM, Johannes Berg
> <johannes@sipsolutions.net> wrote:
> > On Fri, 2010-08-27 at 08:48 -0700, Luis R. Rodriguez wrote:
> >
> >> > Well, there's no way we can reliably wake up exactly before a beacon by
> >> > implementing that in software, hard real-time hasn't been achieved in
> >> > Linux yet :-)
> >>
> >> Keyword here is *exactly*. I don't want to wake up *exactly* at DTIM,
> >> only ensure we don't sleep during it and the send buffered frames and
> >> multicast traffic data. Why can we not implement this on mac80211?
> >
> > Well, how long before the beacon do you want to wake up to catch it?
> > 1ms? 10ms? 100ms? 1000ms? What if the system is busy?
> 
> I cannot say what would work best, how about half a beacon interval early?

Why are we even discussing this anyway? It doesn't matter for a power
save implementation since you better offload it to the device so you get
as exact timing as you can?

johannes


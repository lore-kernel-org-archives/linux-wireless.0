Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:44710 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752085Ab0H0PnW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Aug 2010 11:43:22 -0400
Subject: Re: [RFT] mac80211: fix broadcast/multicast data drop on scan
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: Jouni Malinen <j@w1.fi>, linux-wireless@vger.kernel.org,
	Kalle Valo <kvalo@adurom.com>,
	Amod Bodas <Amod.Bodas@atheros.com>
In-Reply-To: <AANLkTi=qWjhwo50hg8HB1wtsyUizAi55SEK9EW0Udckv@mail.gmail.com>
References: <1282887527-23259-1-git-send-email-lrodriguez@atheros.com>
	 <20100827090655.GA15873@jm.kir.nu>
	 <AANLkTimw1MpiKM=rCfp_zxkw855SyaoZg6m1oB354tCF@mail.gmail.com>
	 <1282923444.4377.13.camel@jlt3.sipsolutions.net>
	 <AANLkTi=qWjhwo50hg8HB1wtsyUizAi55SEK9EW0Udckv@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 27 Aug 2010 17:43:19 +0200
Message-ID: <1282923799.4377.14.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2010-08-27 at 08:40 -0700, Luis R. Rodriguez wrote:
> On Fri, Aug 27, 2010 at 8:37 AM, Johannes Berg
> <johannes@sipsolutions.net> wrote:
> > On Fri, 2010-08-27 at 08:28 -0700, Luis R. Rodriguez wrote:
> >
> >> Indeed... I do not see where we keep track of the DTIM count and was
> >> afraid this was not sufficient. I had not thought about the last
> >> received multicast / broadcast frame, that will require some more
> >> work. But I also noticed even ieee80211_recalc_ps() does not take this
> >> into account when computing the max_sleep_period ieee80211_enable_ps()
> >> for dynamic power save, it only considers the DTIM period. We send the
> >> nullfunc frame for dynamic power save and it does not seem we take
> >> into consideration the DTIM count and last RX's broadcast / multicast
> >> data prior to sending the nullfunc to go into power save. So it seems
> >> to me dynamic power save would also loses broadcast / multicast data
> >> frames.
> >
> > No, the max sleep period is just a helper variable for device
> > implementation of sleep -- the actual alignment of it with DTIM beacons
> > etc. has to be done by the device. Therefore, it isn't so :-)
> 
> I noticed the comment on the PS documentation that the reason for this
> is that mac80211 is too slow, is that right?

Well, there's no way we can reliably wake up exactly before a beacon by
implementing that in software, hard real-time hasn't been achieved in
Linux yet :-)

johannes


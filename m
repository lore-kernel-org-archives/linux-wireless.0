Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rv-out-0910.google.com ([209.85.198.188]:40168 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752664AbYA0R0x (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 27 Jan 2008 12:26:53 -0500
Received: by rv-out-0910.google.com with SMTP id k20so1428396rvb.1
        for <linux-wireless@vger.kernel.org>; Sun, 27 Jan 2008 09:26:52 -0800 (PST)
Message-ID: <c85cb4470801270926g1f84fc8t5905b458b4eee012@mail.gmail.com> (sfid-20080127_172655_676465_47F33706)
Date: Sun, 27 Jan 2008 19:26:52 +0200
From: "Ron Rindjunsky" <rindjon@googlemail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: [PATCH 06/12] mac80211: A-MPDU Tx adding qdisc support
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	flamingice@sourmilk.net, tomas.winkler@intel.com, yi.zhu@intel.com
In-Reply-To: <1201167778.3454.75.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <12009163321727-git-send-email-ron.rindjunsky@intel.com>
	 <12009163392546-git-send-email-ron.rindjunsky@intel.com>
	 <1201167778.3454.75.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> > +#define IEEE80211_TXCTL_AMPDU                (1<<13) /* this frame should be sent
> > +                                              * as part of an A-MPDU */
>
> Broadcom hardware will want to know
>  (a) is this part of an A-MPDU
>  (b) if so, is it
>     (i) the first mpdu
>     (ii) an intermediate mpdu
>     (iii) the last mpdu
>
> Can we provide that easily and avoid the driver having to keep track?

well, this bit just tells the driver that this frame should be
aggregated. it does not, in any case, determines to low-level driver
what will be be distribution of frames per A-MPDU or the order of
them, as this is the low-level's driver/HW job. so i believe Braodcom
can do what iwlwifi do, just check this bit and decide if they
aggregate the frame or not, and in which A-MPDU. the rest of the
information needed can be extracted easily from start/stop aggregation
flows.

>
> >  struct ieee80211_sched_data
> >  {
> > +     unsigned long qdisc_pool;
>
> If we ever have hw with many more queues we may want to increase
> NUM_TX_DATA_QUEUES_AMPDU, so if I understand the code correctly should
> be an array sized something like BITS_TO_LONGS(NUM_TX_...)
>

I can change this book keeping, though current solution provides us up
to 32 HW queues, which is really a huge amout of queues in terms of
HW. if needed after all, i would prefer to do it on top of this
series.

> johannes
>
>

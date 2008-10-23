Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:44033 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757337AbYJWSHw (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Oct 2008 14:07:52 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Thu, 23 Oct 2008 11:07:52 -0700
Date: Thu, 23 Oct 2008 04:07:46 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Benoit PAPILLAULT <benoit.papillault@free.fr>
CC: Luis Rodriguez <Luis.Rodriguez@Atheros.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Luis R. Rodriguez" <mcgrof@gmail.com>,
	Jean Tourrilhes <jt@hpl.hp.com>
Subject: Re: [PATCH 4/5] crda: Updated regulatory information for France
	(FR)
Message-ID: <20081023110746.GA5979@tesla> (sfid-20081023_200759_641820_AEFA61AC)
References: <cover.1223583376.git.benoit.papillault@free.fr> <48FE399E.6050907@free.fr> <20081022150323.GO6190@tesla> <49000C21.2010808@free.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <49000C21.2010808@free.fr>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Oct 22, 2008 at 10:31:13PM -0700, Benoit PAPILLAULT wrote:
> >> +# Data from http://www.arcep.fr/index.php?id=9272#12931
> >> +# Updated 2008-10-04
> >> +# 1W => 30dBm, 200mW => 23dBm, 100mW => 20dBm, 10mW => 10dBm
> >> +# TPC is needed for 5250-5350 and 5470-5725, which flag to use?
> >>  country FR:
> >> -       (2402 - 2482 @ 40), (N/A, 20)
> >> -       (5170 - 5250 @ 40), (N/A, 20)
> >> -       (5250 - 5330 @ 40), (N/A, 20), DFS
> >> -       (5490 - 5710 @ 40), (N/A, 27), DFS
> >> +       (2400 - 2454 @ 40), (N/A, 20)
> >> +       (2454 - 2483.5 @ 40), (N/A, 20), NO-OUTDOOR
> >
> > 2483.5 - 2454 = 29.5 so 29.5 should be the max bandwidth.
> 
> Not exactly. The maximum power in this band depends on whether we are
> indoor or outdoor. If we are indoor, we are allowed to have 20dBm in the
> whole 2400 - 2454 MHz band and can still use 40MHz bandwidth. Maybe I
> should describe that different?
> 
>         (2412 - 2483.5 @ 40), (N/A, 20), NO-OUTDOOR
>         (2412 - 2454 @ 40), (N/A, 20), NO-INDOOR
>         (2454 - 2483.5 @ 40) (N/A, 10), NO-INDOOR
> 
> In fact, this depends on the indoor/outdoor flags issue which can be
> resolved later.

But I wasn't speaking about power, I was speaking about channel
bandwidth. You cannot fit a 40 MHz channel into the freq range
2483.5 - 2454.

> >> +       (2454 - 2483.5 @ 40), (N/A, 10), NO-INDOOR
> >
> > Same here.
> >
> >> +       (5150 - 5250 @ 40), (N/A, 23), NO-OUTDOOR
> >> +       (5250 - 5350 @ 40), (N/A, 23), NO-OUTDOOR, DFS, PASSIVE-SCAN
> >> +       (5470 - 5725 @ 40), (N/A, 30), DFS, PASSIVE-SCAN
> >
> > Hm, actually so I had removed PASSIVE-SCAN from all entries
> > as I had determined that this was only used for DFS purposes.
> > As you can see in your case both have DFS so I'd leave only DFS.
> > So essentially we can get rid of these:
> >
> >         RRF_PASSIVE_SCAN        = 1<<7, /* passive scan is required */
> >         RRF_NO_IBSS             = 1<<8, /* IBSS is not allowed */
> >
> > What I noted was that PASSIVE-SCAN for example was only used for when
> > we don't have DFS in STA and NO_IBSS when we don't have DFS in IBSS.
> >
> > So we can just stick to DFS flag, unless you are aware of other
> > considerations for them. Thoughts?
> 
> If it's documented that the DFS flag implies PASSIVE_SCAN, that's fine
> with me.

We'll have to add the docs, this is just what what I determined from my
own review on regulatory, with regulatory folks. I asked a "why" for
each flag.

  Luis

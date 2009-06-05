Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:26849 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754580AbZFEHyK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 5 Jun 2009 03:54:10 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Fri, 05 Jun 2009 00:54:13 -0700
Date: Fri, 5 Jun 2009 13:22:52 +0530
From: Vasanthakumar Thiagarajan <vasanth@atheros.com>
To: Luis Rodriguez <lrodriguez@atheros.com>
CC: Vasanth Thiagarajan <Vasanth.Thiagarajan@Atheros.com>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"johannes@sipsolutions.net" <johannes@sipsolutions.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ath9k-devel@lists.ath9k.org" <ath9k-devel@lists.ath9k.org>,
	Luis Rodriguez <Luis.Rodriguez@Atheros.com>
Subject: Re: [PATCH 01/15] ath9k: fix oops by downgrading assert in rc.c
Message-ID: <20090605075252.GG17632@vasanth-laptop>
References: <1244180502-4323-1-git-send-email-lrodriguez@atheros.com> <1244180502-4323-2-git-send-email-lrodriguez@atheros.com> <20090605063059.GF17632@vasanth-laptop> <43e72e890906050047w71f8e691g479797a54f5fb9a0@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <43e72e890906050047w71f8e691g479797a54f5fb9a0@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jun 05, 2009 at 01:17:16PM +0530, Luis Rodriguez wrote:
> On Thu, Jun 4, 2009 at 11:30 PM, Vasanthakumar
> Thiagarajan<vasanth@atheros.com> wrote:
> >
> >> +
> >> +       /*
> >> +        * Fine tuning for when no decent rate was found, the
> >> +        * lowest should *not* be used under normal circumstances.
> >> +        */
> >> +       if (rix == ath_rc_priv->valid_rate_index[0]) {
> >> +               DPRINTF(sc, ATH_DBG_RATE, "lowest rate being used, "
> >> +                       "disabling MRR\n");
> >> +               rates[0].idx = rate_lowest_index(sband, sta);
> >> +               /* Disable MRR when ath_rc_ratefind_ht() found rate 0 */
> >> +               rates[1].idx = -1;
> >> +       }
> >
> > I think we can still fill other rates (1..3) with the lowest rate
> > index as we dont differentiate the situation where the lowest rate
> > is chosen truely by the algorithm from this particular case.
> 
> I thought about that as well, but does it really make sense for us to
> use MRR with the same lowest rate? That's why I just used one segment.
> Thoughts?

or we can try for max_retry (4) times. In that case the rate indices of
other rates (just not 1) should be made -1 or this segment should be
moved just below the rate find.

Vasanth

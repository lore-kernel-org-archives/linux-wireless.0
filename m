Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:49546 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751284Ab2BXQod (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 24 Feb 2012 11:44:33 -0500
Subject: Re: [PATCH] {nl,cfg,mac}80211: Enable control quality monitoring
 for mesh
From: Johannes Berg <johannes@sipsolutions.net>
To: Javier Cardona <javier@cozybit.com>
Cc: Ashok Nagarajan <ashok@cozybit.com>, linux-wireless@vger.kernel.org
In-Reply-To: <CAPjQAd9ezrXpNSQUTy5FE5x57DdRTJCi7OVH98cXUBhUMfea4Q@mail.gmail.com> (sfid-20120224_174111_118939_FDE573EF)
References: <1330050621-8955-1-git-send-email-ashok@cozybit.com>
	 <1330067955.3426.3.camel@jlt3.sipsolutions.net>
	 <CAPjQAd9ezrXpNSQUTy5FE5x57DdRTJCi7OVH98cXUBhUMfea4Q@mail.gmail.com>
	 (sfid-20120224_174111_118939_FDE573EF)
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 24 Feb 2012 17:44:32 +0100
Message-ID: <1330101872.3426.32.camel@jlt3.sipsolutions.net> (sfid-20120224_174436_961334_D911CBD5)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2012-02-24 at 08:40 -0800, Javier Cardona wrote:
> Hi Johannes,
> 
> On Thu, Feb 23, 2012 at 11:19 PM, Johannes Berg
> <johannes@sipsolutions.net> wrote:
> > On Thu, 2012-02-23 at 18:30 -0800, Ashok Nagarajan wrote:
> >
> >> +/*
> >> + * NOTE: Mesh peer links are established only if average rssi of the peer
> >> + * candidate satisfies the threshold. sta_meets_rssi_treshold doesn't use
> >> + * hysteresis as fluctuations around threshold have no adverse effects.
> >> + */
> >> +
> >> +#define sta_meets_rssi_threshold(sta, sdata) \
> >> +             (sdata->vif.bss_conf.cqm_rssi_thold == 0 || \
> >> +             ((s8) -ewma_read(&sta->avg_signal)) > \
> >> +              sdata->vif.bss_conf.cqm_rssi_thold)
> >
> > This also isn't right, you're using a value (bss_conf.cqm_rssi_thold)
> > intended for *signalling* for actual *decision making*.
> 
> Isn't that value used for making the decision (in userspace) on
> whether a signal is good enough to associate?

I don't think so, and if it happens to be the same value, that's still
not encoded in the API -- this value is really meant to be only for the
signalling in the API.

> On an open mesh this
> decision takes place in the kernel.  It made more sense to us to reuse
> that parameter for mesh than to introduce a new one.  Would you rather
> see a separate mesh parameter for this?

Yes, I think that makes more sense.

johannes


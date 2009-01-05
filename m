Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:37445 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751956AbZAENpO (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 Jan 2009 08:45:14 -0500
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 05 Jan 2009 05:45:13 -0800
Date: Mon, 5 Jan 2009 19:15:01 +0530
From: Vasanthakumar Thiagarajan <vasanth@atheros.com>
To: Johannes Berg <johannes@sipsolutions.net>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] mac80211: Handle power constraint level advertised in
	11d+h beacon
Message-ID: <20090105134501.GB21471@vasanth-laptop> (sfid-20090105_144518_160558_842C4AD3)
References: <1231148165-10529-1-git-send-email-vasanth@atheros.com> <1231153954.3334.4.camel@johannes> <20090105133738.GA21471@vasanth-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <20090105133738.GA21471@vasanth-laptop>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Oops, i mistakenly sent as attachment, please see my comments below.

On Mon, Jan 05, 2009 at 04:42:34PM +0530, Johannes Berg wrote:
>
> I think I'd prefer that to be written as
>
> if (!scanning && power_constr_level)
>       power = ... - ...
> else
>       power = chan->max_power;
>
> Also, I don't understand the subtraction? And why are you checking
> only
> for sw scanning and not hw scanning?

I think driver should handle in case of hw_scanning.

> > +
> > +   if ((*pwr_constr_elem <= conf->channel->max_power) &&
> > +       (*pwr_constr_elem != conf->power_constr_level)) {
> > +           conf->power_constr_level = *pwr_constr_elem;
> > +           ieee80211_hw_config(sdata->local, 0);
>
> That needs a changed flag, no?

No, ieee80211_hw_config() will take care.

>And how does the subtraction make sense
> like this? The spec talks about the country element's max power,
> and
> then subtracting this, to get the local power, but if the local
> power
> was set lower than that then we shouldn't subtract even more, no?


This is more concervative way of processing power constraint.  Yeah,
you are correct
that we might be setting lower tx power than the allowed one when we
subtract power
constraint from already min power (of reg data base and 11d ie)
instead of only power
limit advertised in 11d ie, but this situation is uncommon.

Vasanth


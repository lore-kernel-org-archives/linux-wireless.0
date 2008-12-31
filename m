Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ti-out-0910.google.com ([209.85.142.186]:58769 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751452AbYLaKnt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 31 Dec 2008 05:43:49 -0500
Received: by ti-out-0910.google.com with SMTP id b6so8331962tic.23
        for <linux-wireless@vger.kernel.org>; Wed, 31 Dec 2008 02:43:47 -0800 (PST)
From: Sujith <m.sujith@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <18779.19560.719396.912447@localhost.localdomain> (sfid-20081231_114353_963955_C881CEAC)
Date: Wed, 31 Dec 2008 16:11:44 +0530
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	Jouni.Malinen@Atheros.com
Subject: Re: [PATCH] mac80211: Add 802.11h CSA support
In-Reply-To: <1230718812.4065.7.camel@johannes>
References: <18779.17630.122619.462997@gargle.gargle.HOWL>
	<1230718812.4065.7.camel@johannes>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg wrote:
> On Wed, 2008-12-31 at 15:39 +0530, Sujith wrote:
> > Move to the advertised channel on reception of
> > a CSA element. This is needed for 802.11h compliance.
> > 
> > Signed-off-by: Sujith <Sujith.Manoharan@atheros.com>
> 
> One thing I've been wondering about though, should we have a hook into
> the driver to actually stop transmit at a lower level, where possible?
> For example Broadcom hardware we can actually set some value on the chip
> and then let it reject all frames, drain its FIFOs, and then in the
> driver we could schedule those frames again for afterwards.

I think that is needed only when handling Quiet IE, which I was planning to work
on separately, with a notification to the driver to stop transmission completely for a period of time.

> > +	sdata->local->oper_channel = new_ch;
> 
> Here you're setting oper_channel, but is that really the right thing to
> do? That means any hw config call that comes in between this and later
> will already switch to that channel, and hw config can happen for
> various other reasons, for instance PS mode stuff. I think we may need
> to have a separate variable?

Right, a *switch_to in sdata would suffice, I guess.
I'll send an updated patch.

Sujith

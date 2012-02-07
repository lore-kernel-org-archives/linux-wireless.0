Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog117.obsmtp.com ([74.125.149.242]:39094 "EHLO
	na3sys009aog117.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755357Ab2BGQLr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Feb 2012 11:11:47 -0500
Received: by mail-lpp01m020-f182.google.com with SMTP id gj3so3004029lbb.27
        for <linux-wireless@vger.kernel.org>; Tue, 07 Feb 2012 08:11:43 -0800 (PST)
Message-ID: <1328631100.7324.272.camel@cumari> (sfid-20120207_171151_819428_85A936A7)
Subject: Re: [PATCH v2 5/7] wl12xx: add RX data filter ACX commands
From: Luciano Coelho <coelho@ti.com>
To: Kalle Valo <kvalo@adurom.com>
Cc: Eliad Peller <eliad@wizery.com>, eyal@wizery.com,
	linux-wireless@vger.kernel.org
Date: Tue, 07 Feb 2012 18:11:40 +0200
In-Reply-To: <8739amd3xl.fsf@purkki.adurom.net>
References: <1328021048-8944-1-git-send-email-eliad@wizery.com>
	 <1328021048-8944-6-git-send-email-eliad@wizery.com>
	 <1328170983.3626.265.camel@cumari> <877h00cay9.fsf@purkki.adurom.net>
	 <1328538734.7324.139.camel@cumari> <8739amd3xl.fsf@purkki.adurom.net>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2012-02-07 at 18:05 +0200, Kalle Valo wrote: 
> Luciano Coelho <coelho@ti.com> writes:
> 
> > On Mon, 2012-02-06 at 16:07 +0200, Kalle Valo wrote: 
> >> Luciano Coelho <coelho@ti.com> writes:
> >> 
> >> >> +	if (index >= WL1271_MAX_RX_DATA_FILTERS) {
> >> >> +		wl1271_warning("acx_set_rx_data_filter: invalid filter idx(%d)",
> >> >> +			       index);
> >> >> +		return -EINVAL;
> >> >> +	}
> >> >
> >> > Should we use BUG_ON instead? This is only used internally in the
> >> > driver, so if it get here, it's a bug.  And if the filters come from
> >> > userspace, we should validate them before continuing anyway.
> >> 
> >> BUG_ON() is evil and wireless drivers should really not use it,
> >> WARN_ON_ONCE() and return with an error is much more user friendly.
> >
> > Yeah, BUG_ON() is evil, but sometimes it can be good to have.
> 
> What good does BUG_ON() bring compared to WARN_ON_ONCE()? For example,
> does BUG_ON() even get logged to disk? Most likely not, so
> WARN_ON_ONCE() is much easier to report by the users.
> 
> > I don't agree with "wireless drivers should really not use it". There
> > are 181 occurrences in wireless-testing/master right now[1].
> 
> Then there are 181 misuses of BUG_ON() ;)

:D


> > I'm not saying this measure is either accurate or an excuse to use it
> > where we shouldn't, but it shows that it really has widespread usage
> > in wireless drivers.
> 
> Yes, and that's why I have started a war against misuse of BUG_ON() :)

Okay, I will definitely not be in the frontline against you in this
war. :)


-- 
Cheers,
Luca.


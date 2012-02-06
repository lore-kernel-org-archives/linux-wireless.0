Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog109.obsmtp.com ([74.125.149.201]:49352 "EHLO
	na3sys009aog109.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753428Ab2BFOcS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Feb 2012 09:32:18 -0500
Received: by mail-lpp01m020-f172.google.com with SMTP id gk8so1016451lbb.3
        for <linux-wireless@vger.kernel.org>; Mon, 06 Feb 2012 06:32:17 -0800 (PST)
Message-ID: <1328538734.7324.139.camel@cumari> (sfid-20120206_153221_616826_31862621)
Subject: Re: [PATCH v2 5/7] wl12xx: add RX data filter ACX commands
From: Luciano Coelho <coelho@ti.com>
To: Kalle Valo <kvalo@adurom.com>
Cc: Eliad Peller <eliad@wizery.com>, eyal@wizery.com,
	linux-wireless@vger.kernel.org
Date: Mon, 06 Feb 2012 16:32:14 +0200
In-Reply-To: <877h00cay9.fsf@purkki.adurom.net>
References: <1328021048-8944-1-git-send-email-eliad@wizery.com>
	 <1328021048-8944-6-git-send-email-eliad@wizery.com>
	 <1328170983.3626.265.camel@cumari> <877h00cay9.fsf@purkki.adurom.net>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2012-02-06 at 16:07 +0200, Kalle Valo wrote: 
> Luciano Coelho <coelho@ti.com> writes:
> 
> >> +	if (index >= WL1271_MAX_RX_DATA_FILTERS) {
> >> +		wl1271_warning("acx_set_rx_data_filter: invalid filter idx(%d)",
> >> +			       index);
> >> +		return -EINVAL;
> >> +	}
> >
> > Should we use BUG_ON instead? This is only used internally in the
> > driver, so if it get here, it's a bug.  And if the filters come from
> > userspace, we should validate them before continuing anyway.
> 
> BUG_ON() is evil and wireless drivers should really not use it,
> WARN_ON_ONCE() and return with an error is much more user friendly.

Yeah, BUG_ON() is evil, but sometimes it can be good to have.  I don't
agree with "wireless drivers should really not use it".  There are 181
occurrences in wireless-testing/master right now[1].  I'm not saying
this measure is either accurate or an excuse to use it where we
shouldn't, but it shows that it really has widespread usage in wireless
drivers.

My point was that this can only happen very early, when the driver is
being initialized.  But this is not exactly this case, it only happens
when we suspend or resume, so you're right here.

Maybe in this case we should check with a BUILD_BUG_ON somehow.

And actually, I nacked this part of the patchset, they definitely need
to be reworked.  Eliad already sent v2 of the first 4, leaving 5/6/7
out.

In any case, thanks a lot for your comment, Kalle! :)


[1]
luca@cumari:~/kernel/wl12xx$ find drivers/net/wireless/ -name '*.[ch]' -exec grep -e '\<BUG_ON\>' {} \;|wc -l
181


-- 
Cheers,
Luca.


Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dedo.coelho.fi ([88.198.205.34]:56112 "EHLO dedo.coelho.fi"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751088AbaFIHVN (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Jun 2014 03:21:13 -0400
Message-ID: <1402298460.2004.34.camel@dubbel> (sfid-20140609_092116_729170_4DEF48EA)
From: Luca Coelho <luca@coelho.fi>
To: Michal Kazior <michal.kazior@tieto.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless <linux-wireless@vger.kernel.org>
Date: Mon, 09 Jun 2014 10:21:00 +0300
In-Reply-To: <CA+BoTQkX=ZpDc=R+nWxsrj026XyaaEiwrosaB2buRVif2aOnxQ@mail.gmail.com>
References: <1402068423-23359-1-git-send-email-luca@coelho.fi>
	 <1402080365-15462-1-git-send-email-luca@coelho.fi>
	 <CA+BoTQkX=ZpDc=R+nWxsrj026XyaaEiwrosaB2buRVif2aOnxQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Subject: Re: [RFC option 2] mac80211: introduce refcount for
 queue_stop_reasons
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2014-06-09 at 07:34 +0200, Michal Kazior wrote:
> On 6 June 2014 20:46, Luca Coelho <luca@coelho.fi> wrote:
> > From: Luciano Coelho <luciano.coelho@intel.com>
> >
> > Sometimes different vifs may be stopping the queues for the same
> > reason (e.g. when several interfaces are performing a channel switch).
> > Instead of using a bitmask for the reasons, use an integer that holds
> > a refcount instead.
> >
> > Signed-off-by: Luciano Coelho <luciano.coelho@intel.com>
> > ---
> >
> > This looks much simpler now.  The only thing is that we need to make
> > sure the bitmask never gets out of sync with the refcounts, which
> > shouldn't be too difficult, as long as we keep the refcounts usage
> > restricted to the queues start/stopping functions.
> 
> I think you need to make sure all stop/wake calls are balanced
> everywhere (including device drivers). Otherwise you risk breaking
> things silently in some cases.
> 
> It might also be worth to update exported stop/wake symbol documentation too.

Good point, I'll look into that.

My original idea was to mark the queues as stopped in the sdata so we
would at least clean things up when the vif is stopped, but that would
be a bit slow if we had to traverse them all the time.

Checking this might be tricky, actually, since I think there are some
assumptions that stopping a queue that is already stopped is a NOP, but
now we add to the refcount...

--
Luca.


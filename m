Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog134.obsmtp.com ([74.125.149.83]:39207 "EHLO
	na3sys009aog134.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750788Ab2F2EH6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 29 Jun 2012 00:07:58 -0400
Received: by lbbgm6 with SMTP id gm6so4479208lbb.5
        for <linux-wireless@vger.kernel.org>; Thu, 28 Jun 2012 21:07:55 -0700 (PDT)
Message-ID: <1340942872.1631.678.camel@cumari.coelho.fi> (sfid-20120629_060802_838927_D841D04C)
Subject: Re: [PATCH] wlcore: implement .flush callback
From: Luciano Coelho <coelho@ti.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Arend van Spriel <arend@broadcom.com>,
	Arik Nemtsov <arik@wizery.com>,
	Eliad Peller <eliad@wizery.com>, linux-wireless@vger.kernel.org
Date: Fri, 29 Jun 2012 07:07:52 +0300
In-Reply-To: <1340909292.4491.51.camel@jlt3.sipsolutions.net>
References: <1340813387-18407-1-git-send-email-coelho@ti.com>
	 <4FEC3B0E.3040001@broadcom.com>
	 <CAB3XZEeJrX4AoFqMtSOF3BFEV-s5WOhAXHnVwb6_5O5bNXWkUQ@mail.gmail.com>
	 <CA+XVXfeqQFd+raZeBEB+ct5mHLJfEPst1Bop0RUui6gN9=9jow@mail.gmail.com>
	 <4FECA5FB.30902@broadcom.com>
	 <1340909292.4491.51.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2012-06-28 at 20:48 +0200, Johannes Berg wrote:
> On Thu, 2012-06-28 at 20:44 +0200, Arend van Spriel wrote:
> 
> > >>> So not taking the drop flag into account? Any plan to change that?
> > >>>
> > >> yeah, good point...
> > >> i guess we'll want to add support for the drop flag as well.
> > >>
> > >> Luca - you can either drop this patch, or apply it for now and i'll
> > >> send another patch later on.
> > > 
> > > Currently we drop all the packets if we can't flush them within a
> > > reasonable time. We always do this right now. I think that's good
> > > enough?
> > > 
> > 
> > Hard to say as I am working mostly on your side of this API. However,
> > the drop flag is part of the API so there is probably a reason for
> > having it. Johannes?
> 
> The drop never actually used today... but we had plans to use it in some
> cases I think.

I have just grepped the code and I also see that drop is always false as
it is.

Of course, the API specifies this drop parameter and how it should be
handled, so we should treat it too, so nothing breaks if mac80211
changes.

But, as defined in the API documentation:

 * @flush: Flush all pending frames from the hardware queue, making sure
 *	that the hardware queues are empty. If the parameter @drop is set
 *	to %true, pending frames may be dropped. The callback can sleep.

Frames *may* be dropped if drop is set to true.  We don't *have* to drop
them, so it should be fine to ignore it and remain true to the API
specification.

--
Luca.


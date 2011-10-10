Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog116.obsmtp.com ([74.125.149.240]:56300 "EHLO
	na3sys009aog116.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754583Ab1JJTrR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Oct 2011 15:47:17 -0400
Received: by bkbzu5 with SMTP id zu5so9187242bkb.7
        for <linux-wireless@vger.kernel.org>; Mon, 10 Oct 2011 12:47:14 -0700 (PDT)
Subject: Re: [PATCH 09/29] wl12xx: make event handling support multirole
From: Luciano Coelho <coelho@ti.com>
To: Eliad Peller <eliad@wizery.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <CAB3XZEc9DcYHmph9wH=+8jQkjBPAiGqHW7P-oVcQJcBHeONNWQ@mail.gmail.com>
References: <1318234397-21081-1-git-send-email-eliad@wizery.com>
	 <1318234397-21081-10-git-send-email-eliad@wizery.com>
	 <1318273094.9690.385.camel@cumari>
	 <CAB3XZEc9DcYHmph9wH=+8jQkjBPAiGqHW7P-oVcQJcBHeONNWQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 10 Oct 2011 22:47:11 +0300
Message-ID: <1318276031.9690.415.camel@cumari> (sfid-20111010_214720_561431_3BA9D536)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2011-10-10 at 21:36 +0200, Eliad Peller wrote: 
> On Mon, Oct 10, 2011 at 8:58 PM, Luciano Coelho <coelho@ti.com> wrote:
> > On Mon, 2011-10-10 at 10:12 +0200, Eliad Peller wrote:
> >> Some events don't indicate the role they are intended for.
> >> In these cases, iterate through all the relevant vifs,
> >> and pass the event to each one of them.
> >>
> >> This is only a workaround. future fw releases should indicate
> >> the relevant role_id for such events.
> >>
> >> Signed-off-by: Eliad Peller <eliad@wizery.com>
> >> ---
> >
> > Is this workaround really necessary? Are we going to have a firmware
> > that supports multi-role but does *not* pass the role_id for these
> > events?
> >
> i hope not. :)
> but in the meantime, we use this workaround to keep compatibility with
> the current (single-role) fw.

What I meant is that you could keep this global, without moving it
temporarily to the wlvif and traversing the list, which has always only
a single element anyway.  But now I see that you want to get rid of the
global wl->vif, so it's fine.  It's only the list traversal that is
actually a workaround, the rest of the changes are actually fine.

-- 
Cheers,
Luca.


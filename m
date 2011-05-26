Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog110.obsmtp.com ([74.125.149.203]:39599 "EHLO
	na3sys009aog110.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751054Ab1EZEvO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 May 2011 00:51:14 -0400
Received: by mail-ey0-f170.google.com with SMTP id 5so165852eyf.29
        for <linux-wireless@vger.kernel.org>; Wed, 25 May 2011 21:51:12 -0700 (PDT)
Subject: Re: [PATCH 2.6.40] wl12xx: fix oops in sched_scan when forcing a
 passive scan
From: Luciano Coelho <coelho@ti.com>
To: Eliad Peller <eliad@wizery.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <BANLkTim4Gf8GVTqj7wcZrdGG6MM0mpTEvw@mail.gmail.com>
References: <1306340205-30758-1-git-send-email-coelho@ti.com>
	 <BANLkTim4Gf8GVTqj7wcZrdGG6MM0mpTEvw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 26 May 2011 07:51:09 +0300
Message-ID: <1306385469.12586.2403.camel@cumari> (sfid-20110526_065118_206466_023834DC)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2011-05-26 at 02:08 +0300, Eliad Peller wrote:
> hi Luca,
> 
> On Wed, May 25, 2011 at 7:16 PM, Luciano Coelho <coelho@ti.com> wrote:
> > Fix kernel oops when trying to use passive scheduled scans.  The
> > reason was that in passive scans there are no SSIDs, so there was a
> > NULL pointer dereference.
> >
> > To solve the problem, we now check the number of SSIDs provided in the
> > sched_scan request and only access the list if there's one or more
> > (ie. passive scan is not forced).  We also move the channels from
> > active to passive if passive scanning is forced.  For this to work,
> > it's necessary to set both active and passive dwell times for all
> > channels.
> >
> > Signed-off-by: Luciano Coelho <coelho@ti.com>
> > ---
> [...]
> 
> why does sched scan without ssids means passive scan? can't we just do
> active sched scan without ssids?

This is how normal scans also work.  If you want a broadcast scan, you
pass a wildcard SSID (ie. one with zero length), if you want to force
the scan to be passive, you don't pass any SSIDs in the request.
Basically it means that if there is not SSID, we cannot send probe_req
(even broadcast probe_reqs need an SSID, an empty one).


> > +       if (force_passive) {
> > +               /* move active channels to passive lists */
> > +               cfg->passive[0] += cfg->active[0] - 1;
> > +               cfg->active[0] = 1;
> looks like a potential integer underflow.
> 
> if you're forcing a passive scan, why do you need to set an active channel?

Argh! This was from a test I was doing and is totally wrong.  The idea
is to transfer all the active channels to the passive list.  Thanks for
noticing this, I'll fix it.


> anyway, this seems a bit wrong.
>
> i don't think you can just do "arbitrary transfers" of the channel
> counts, as their order seem to matter (i.e. the order of elements in
> the channel array is passive[0],passive[1],..,active[0],active[1]...,
> so you actually need to shift all the elements)

Hmmm... Good point.  I don't know why the order would actually matter,
but in this case the way the channels are scanned will be hard to
predict.  We're doing something that is not specified or requested
anywhere.

This seemed to be the simplest way to do it, but indeed it's not very
good.  I'll have to do something so that it already sets all the
channels as passive when it generates the list, so no reordering or
hacking the channel numbers will be necessary.

Thanks for the review!

-- 
Cheers,
Luca.


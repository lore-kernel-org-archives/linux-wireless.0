Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.24]:47318 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751686AbZEEIeW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 May 2009 04:34:22 -0400
Received: by ey-out-2122.google.com with SMTP id 9so1154021eyd.37
        for <linux-wireless@vger.kernel.org>; Tue, 05 May 2009 01:34:21 -0700 (PDT)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: Alexandre Becholey <alexandre@shockfish.com>
Subject: Re: IEEE80211 Acknowledgement
Date: Tue, 5 May 2009 10:34:19 +0200
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
References: <49FF06BB.2090106@shockfish.com> <200905041905.44646.IvDoorn@gmail.com> <49FFEE42.3080102@shockfish.com>
In-Reply-To: <49FFEE42.3080102@shockfish.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200905051034.19820.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tuesday 05 May 2009, Alexandre Becholey wrote:
> Ivo van Doorn wrote:
> > On Monday 04 May 2009, Johannes Berg wrote:
> >   
> >> On Mon, 2009-05-04 at 18:55 +0200, Ivo van Doorn wrote:
> >>     
> >>> On Monday 04 May 2009, Johannes Berg wrote:
> >>>       
> >>>> On Mon, 2009-05-04 at 18:35 +0200, Ivo van Doorn wrote:
> >>>>
> >>>>         
> >>>>> Well I believe the idea would be that (I'll see if I can dig up a reference
> >>>>> to the initial discussion about this feature on this list) the driver sets a flag
> >>>>> that mac80211 needs to keep a list of all frames send out to the driver and
> >>>>> listens for ACK's.
> >>>>>
> >>>>> As soon as a ACK was passed from driver to mac80211 it could check if
> >>>>> the corresponding frame 
> >>>>>           
> >>>>       ^^^^^^^^^^^^^^^^^^^
> >>>>
> >>>> Here's the problem. What I'm saying is that there's no way to knowing
> >>>> what the "corresponding frame" is.
> >>>>         
> >>> Hmm, so would there be any alternatives of fixing this problem?
> >>>       
> >> The proper way of fixing this would be a firmware upgrade ;)
> >>
> >> Working around it would be possible if the driver queued only a single
> >> frame to the hardware, when it knew the frame needed ACK status, and
> >> flushed all queues before that frame, so it knows exactly about the
> >> frame... This has HUGE overhead and performance impact though, and
> >> requires lots of work in mac80211 to not request status for every frame
> >> to start with.
> >>
> >> Since this breaks hostapd operation quite significantly, and I don't see
> >> hostapd changing to accommodate this since that essentially breaks the
> >> ability to be spec compliant (I'm fairly certain some places require
> >> checking for ACK).
> >>
> >> An easier way would be to fake a ACK reception in the driver for every
> >> frame...
> >>     
> >
> > Ok, well I'll go with this route then. Since firmware upgrades for
> > older hardware like rt73usb sounds very unlikely. And for rt2500usb
> > it is plain impossible (no firmware ;))
> >
> > Alexandre: Well that seems to make your project a lot easier...
> >
> > Ivo
> >   
> 
> 
> Thanks for your answers! I'm gonna try it that way :)

Just as a hint, please do not replace all instances of TXDONE_UNKNOWN
with TXDONE_SUCCESS. I rather see the driver report TXDONE_UNKNOWN to
rt2x00lib, and the decision to report that state as success should be done there.

Ivo

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from py-out-1112.google.com ([64.233.166.176]:25971 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751090AbYATIqH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 20 Jan 2008 03:46:07 -0500
Received: by py-out-1112.google.com with SMTP id u52so2300634pyb.10
        for <linux-wireless@vger.kernel.org>; Sun, 20 Jan 2008 00:46:06 -0800 (PST)
Message-ID: <43e72e890801200046n2c858c97k3506664431b937e6@mail.gmail.com> (sfid-20080120_084619_992727_4DA10FBC)
Date: Sun, 20 Jan 2008 03:46:05 -0500
From: "Luis R. Rodriguez" <mcgrof@winlab.rutgers.edu>
To: "bruno randolf" <br1@einfach.org>
Subject: Re: [ath5k-devel] [PATCH 2/4] ath5k: always extend rx timestamp with tsf
Cc: "Derek Smithies" <derek@indranet.co.nz>, jirislaby@gmail.com,
	"Michael Wu" <flamingice@sourmilk.net>,
	ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org,
	linville@tuxdriver.com, "Johannes Berg" <johannes@sipsolutions.net>
In-Reply-To: <46274.61.115.136.26.1200807429.squirrel@webmail.einfach.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <46274.61.115.136.26.1200807429.squirrel@webmail.einfach.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Jan 20, 2008 12:37 AM, bruno randolf <br1@einfach.org> wrote:
> On Sunday 20 January 2008 11:12:11 Derek Smithies wrote:
> > On Sat, 19 Jan 2008, Luis R. Rodriguez wrote:
> > > On Jan 18, 2008 7:50 AM, Bruno Randolf <bruno@thinktube.com> wrote:
> > > > + * always extend the mac timestamp, since this
> > > > information is + * also needed for proper IBSS merging.
> > > > + *
> > > > + * XXX: it might be too late to do it here, since
> > > > rs_tstamp is + * 15bit only. that means TSF extension
> > > > has to be done within + * 32.768usec = 32ms. it might be
> > > > necessary to move this to the + * interrupt handler,
> > > > like it is done in madwifi. + */
> > >
> > > I'm trying to understand this a bit more and am confused. The TSF
> > > timer is based on 1MHz clock so it has a resolution of 1 microsecond
> > > (us). For 15 bits that would mean 32768 us so don't you mean it should
> > > be done within 32.768 ms instead of usec (or us)?
> >
> > Hi,
> > it is a typo.
>
> it's just a different way to use a "." to denote 1000. americans might
> write 32,768usec, im not sure, different styles worldwide...

Yes, that is the 'american' way, not that it is correct.

> what i mean
> is 32768us equals about 32ms. i'll remove that dot to make it unambigous.

Yeah thanks, might be more clear for those of us not used to that
convention, I didn't even know it existed. Where is this "." for 1000
notation convention used, just so I know :) ?

> > You are correct. It should be done within 32.768 ms. On a high end laptop,
> > it is almost guaranteed that the bottom half will process the packet
> > within 32 ms. However, on an embedded box (low spec cpu) that has a
> > temporarily high load, 32 ms is a short time, and the timestamp may have
> > wrapped around. this is unfortunate.
>
> i know that this might happen, and that's why i included this comment. i
> was just too lazy to make the same act as is done in madwifi (lopping thru
> all rx descriptors in the interrupt handler). the current code is
> sufficient for IBSS testing right now.

Thanks for the explanation.

BTW while on the topic of TSF extension, anyone get why we do the tsf
-= 0x8000 if the hw's tsf's 15 bits value is < the rx descriptor's
rstamp? This is what ath5k_extend_tsf() does right before the (tsf &
~0x7fff) | rstamp.

> also even if we move TSF extension into the interrupt handler this will
> not help in all cases. there are situations in IBSS mode - when a HW merge
> (= automatic HW TSF update upon receipt of a beacon with a higherr TSF and
> the same BSSID) happens - where the rx timestamp is apparently based on
> the old TSF, before the HW TSF is updated. in that case we cannot extend
> the timestamp in any meaningful way. i'm not sure how we should handle
> this.

Hmm.. have you seen this with madwifi driver? What do you think is the
cause? If we don't do proper locking I can see this being an issue on
the driver side unless this is specifically a hardware issue.

> > On Sat, 19 Jan 2008, Luis R. Rodriguez wrote:
> > Right now we only use mactime and even RX_FLAG_TSFT within mac80211 in
> > rx.c on ieee80211_rx_monitor() for IEEE80211_RADIOTAP_TSFT so right
> > now these changes would seem to do nothing. Should we be using this
> > for something else -- if so what is it?
>
> see my "[PATCH] mac80211: enable IBSS merging". it is used there to decide
> wether we have to merge IBSS on receipt of a beacon.

Thanks, I have started to review it.

> strictly speaking it
> would be sufficient to extend the rxstamp only for beacons and in monitor
> mode, but i thought checking for these cases is more overhead, so why not
> extend TSF all the time...

Well sure, and also what's the point in updating mactime with 15-bit
value? So yes, sure, lets just keep it. Monitor mode and promiscuous
mode could use it as well. The only real penalty is in STA for
non-beacon frames and that is a matter of how expensive
ath5k_hw_get_tsf64() is and that's just two register reads.

  Luis

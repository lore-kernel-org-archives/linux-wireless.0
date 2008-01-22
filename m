Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.185]:22016 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751702AbYAVXZM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 22 Jan 2008 18:25:12 -0500
Received: by nf-out-0910.google.com with SMTP id g13so536377nfb.21
        for <linux-wireless@vger.kernel.org>; Tue, 22 Jan 2008 15:25:09 -0800 (PST)
To: Adam Baker <linux@baker-net.org.uk>
Subject: Re: [PATCH] mac80211: enable IBSS merging
Date: Wed, 23 Jan 2008 00:25:02 +0100
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <mcgrof@gmail.com>
References: <20080118125252.6455.41047.stgit@one> <200801222054.23433.IvDoorn@gmail.com> <loom.20080122T230306-543@post.gmane.org>
In-Reply-To: <loom.20080122T230306-543@post.gmane.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200801230025.02550.IvDoorn@gmail.com> (sfid-20080122_232516_708734_910B6DFD)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

> > > > > > Then there is a problem for rt2x00. Since the mactime isn't known.
> > > > > > rt2400pci is the _only_ device which has a RX_END_TIME field in the
> > > > > > RX descriptor.
> > > > >
> > > > > one workaround could be to simply use the current TSF at the time in
> > > > > the tasklet or interrupt handler (to be more close to the actual rx 
> > > > > time). this should be sufficient to catch most cases where an IBSS 
> > > > > merge is necessary - usually the beacon's TSF will be much higher
> > > > > than the local TSF.
> > > >
> > > > Should the driver to this, or should mac80211 handle that?
> > > 
> > > The driver should if it has access to some the mactime of the received
> > > packet otherwise yes -- I think mac80211 can handle this using the
> > > supplied get_tsf().
> > > 
> > > > Personally I think it is something for the mac80211 layer since the
> > > > driver will give what it can, and can be sure that it is what mac80211 
> > > > expects instead of drivers interpreting what mac80211 might want as 
> > > > replacement. If mac80211 needs the TSF value when no mac time is 
> > > > given, it could just use the get_tsf() callback function to the driver
> > > >  to get the substitute. When the get_tsf() callback is not provided,
> > > >  then mac80211 can complain about missing information.
> > > 
> >
> 
> I see one problem with this. At the moment rt2x00 doesn't implement get_tsf
> for USB devices. In the case of RT73 this is because mac80211 requires
> get_tsf to be atomic which precludes waiting for a USB device to reply
> to a request. Ivo has got an implementation in the code but it is disabled
> as the fact it sleeps was causing bugs. Presumably other USB devices would
> have the same problem.

Oops, I really should have checked it, I thought the other tsf handler was disabled
and only get_tsf was implemented. Apparently rt73usb only has reset_tsf(). :S

For rt2500usb the problem is that it contains no TSF registers at all
(at least I never found an offset which contained something looking like a TSF).

> I'm not sure if the code path for IBSS merging would require an atomic
> version, I'm guessing it wouldn't. If so do we need to consider whether 
> to either have both get_tsf and get_tsf_atomic or have a flag to get_tsf
> indicating if it can sleep if it needs to?

The new patch has get_tsf() in normal context, I think the best thing would
be moving all remaining atomic get_tsf() calls out of that context. But last time
I checked that wouldn't be too easy. :(

Ivo

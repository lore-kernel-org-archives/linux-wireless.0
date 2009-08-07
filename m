Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.26]:14031 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754784AbZHGSVz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Aug 2009 14:21:55 -0400
Received: by ey-out-2122.google.com with SMTP id 9so562801eyd.37
        for <linux-wireless@vger.kernel.org>; Fri, 07 Aug 2009 11:21:55 -0700 (PDT)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH] mac80211: allow DMA optimisation
Date: Fri, 7 Aug 2009 20:21:52 +0200
Cc: John Linville <linville@tuxdriver.com>,
	"linux-wireless" <linux-wireless@vger.kernel.org>
References: <1249656135.7194.6.camel@johannes.local> <200908071855.38921.IvDoorn@gmail.com> <1249668106.7194.10.camel@johannes.local>
In-Reply-To: <1249668106.7194.10.camel@johannes.local>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200908072021.53221.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Friday 07 August 2009, Johannes Berg wrote:
> On Fri, 2009-08-07 at 18:55 +0200, Ivo van Doorn wrote:
> 
> > > If we have a lot of frames to transmit at once, for
> > > instance with fragmentation, it can be an optimisation
> > > to only tell the DMA engine about them on the last
> > > fragment/frame to avoid banging the IO too much. This
> > > patch allows implementation such an optimisation by
> > > telling the driver when more frames can be expected.
> > 
> > Wouldn't this be the same as the
> > 	if (ieee80211_has_morefrags())
> > 		.. kick queue ...
> 
> Initially, yes, but I think we should eventually use it for sending out
> multiple frames after restarting queues etc. For instance after
> scanning, we could send out a bunch of frames at once.

This would work for PCI devices, but USB devices can spoil the
fun (as usual) because those devices use the queue in the hardware
and you can't control the actual "kick".

> > > Currently, this is used by mac80211 only on fragmented
> > > frames, but could also be used in the future on other
> > > frames when the queue was full and there are multiple
> > > frames pending.
> > >
> > > Note that drivers need to be careful when using this
> > > flag, they need to kick their DMA engines not just
> > > when this flag is clear, but also when the queue gets
> > > full so that progress can be made.
> > 
> > What would a good value be for the threshold?
> > rt2x00 currently uses 10% of the queue, which means that
> > 2 or 3 entries are kept available at all times.
> 
> Well, for fragmentation I think the maximum number of fragments is 9.

Ok, I'll look into increasing the queue size and theshold to something
closer to 9. :)

Ivo

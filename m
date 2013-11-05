Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from packetmixer.de ([83.151.30.3]:51289 "EHLO m25s01.vlinux.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754112Ab3KEOBB (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Nov 2013 09:01:01 -0500
From: Simon Wunderlich <sw@simonwunderlich.de>
To: "Coelho, Luciano" <luciano.coelho@intel.com>
Subject: Re: [RFC] mac80211: don't transmit beacon with CSA count 0
Date: Tue, 5 Nov 2013 15:00:58 +0100
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"johannes@sipsolutions.net" <johannes@sipsolutions.net>
References: <1383569955-13236-1-git-send-email-luciano.coelho@intel.com> <1383640077.579.14.camel@porter.coelho.fi> <1383645950.579.26.camel@porter.coelho.fi>
In-Reply-To: <1383645950.579.26.camel@porter.coelho.fi>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Message-Id: <201311051500.58913.sw@simonwunderlich.de> (sfid-20131105_150106_019568_9FF6CBF3)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> On Tue, 2013-11-05 at 10:27 +0200, Luciano Coelho wrote:
> > On Mon, 2013-11-04 at 15:31 +0100, Simon Wunderlich wrote:
> > > > > Thanks for checking back - I've read the part in the spec again
> > > > > [1], and appearently you are right.
> > > > > 
> > > > > With your proposed change, shouldn't we also change the behaviour
> > > > > if the userspace requests a channel switch with count = 0? I guess
> > > > > we should immediately change the channel then without waiting for
> > > > > beacons? I don't see the point in changing the beacons if we don't
> > > > > send them, after all.
> > > > 
> > > > You're right, changing the beacons doesn't make sense in this case.
> > > > I'll change that and send v2.
> > > > 
> > > > Another thing is that we are missing the action frames.  The idea
> > > > with the count == 0 is that the STA's should start listening on the
> > > > other channel immediately after receiving the action frame (because
> > > > the switch will happen at any time).
> > > > 
> > > > If we don't send the action frame, passing context == 0 from the
> > > > userspace doesn't much make sense, because the clients won't know
> > > > we're switching.  Well, maybe it makes a bit of sense, if there are
> > > > no clients connected, but nevertheless.
> > > 
> > > Yeah, switching without actionframe and count == 0 is pretty useless.
> > 
> > Actually, if the userspace requests count == 1, we won't have any
> > beacons either, because 1 means "just before the next TBTT".  So for
> > count == 1 (coming from the userspace) we shouldn't configure the
> > beacon, since we won't send it.  We need the action frame for this case
> > too.
> 
> Hmmm... Now there's something that is a bit unclear to me in the specs:
> 
> "For nonmesh STAs, the Channel Switch Count field either is set to the
> number of TBTTs until the STA sending the Channel Switch Announcement
> element switches to the new channel or is set to 0."
> 
> There's nothing specifying exactly when, relative to the beacon, the
> switch actually happens.  Just before? Just after? Is the beacon that
> matches that TBTT transmitted in the current or in the next channel?
> 
> For a value of 1, it's pretty clear:
> 
> "A value of 1 indicates that the switch occurs immediately before the
> next TBTT."

If it says for 1 "just before the next TBTT", then this would mean the next 
beacon is on the next channel. I'd interpret then that for count=0, the 
channel switch happens as soon as possible, and may happen any time before the 
next TBTT.
> 
> I don't think we're doing that now.  At least in the ath9k case, you
> switch the channel immediately after the beacon with count == 1, by
> calling ieee80211_csa_finish().  The correct would be just before the
> next beacon is sent.

Hm, I think you are right, although I'm not sure how easy that would be 
implementation-wise.

BTW, for that case I think we also have to fix the client side, which is 
currently switching immediately for count = 1 and not waiting for the next 
TBTT. (see end of ieee80211_sta_process_chanswitch(), the rest appears correct 
though).

> 
> A value of 0 is also unclear, because it doesn't refer to any TBTTs at
> all.  So if you read it literally, the following would mean that it
> could at *any* time in the future:
> 
> "A value of 0 indicates that the switch occurs at any time after the
> frame containing the element is transmitted."
> 
> Am I missing something? What do you think?

As said above, I'd interpret it as the change should happen as soon as 
possible. If count = 1 means the change will happen "immediately before the 
next TBTT", I would guess 0 would mean even before that, or at least not after 
the "before the next TBTT".

I agree that the spec is not perfectly clear about that, but I currently don't 
see any other reasonable interpretation here ...

Cheers,
    Simon

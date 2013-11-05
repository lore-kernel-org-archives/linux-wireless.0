Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from packetmixer.de ([83.151.30.3]:48563 "EHLO m25s01.vlinux.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754835Ab3KENgP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Nov 2013 08:36:15 -0500
From: Simon Wunderlich <sw@simonwunderlich.de>
To: "Coelho, Luciano" <luciano.coelho@intel.com>
Subject: Re: [RFC] mac80211: don't transmit beacon with CSA count 0
Date: Tue, 5 Nov 2013 14:36:13 +0100
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"johannes@sipsolutions.net" <johannes@sipsolutions.net>
References: <1383569955-13236-1-git-send-email-luciano.coelho@intel.com> <201311041531.56693.sw@simonwunderlich.de> <1383640077.579.14.camel@porter.coelho.fi>
In-Reply-To: <1383640077.579.14.camel@porter.coelho.fi>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Message-Id: <201311051436.13222.sw@simonwunderlich.de> (sfid-20131105_143618_991472_A05BD8F6)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> On Mon, 2013-11-04 at 15:31 +0100, Simon Wunderlich wrote:
> > > > Thanks for checking back - I've read the part in the spec again [1],
> > > > and appearently you are right.
> > > > 
> > > > With your proposed change, shouldn't we also change the behaviour if
> > > > the userspace requests a channel switch with count = 0? I guess we
> > > > should immediately change the channel then without waiting for
> > > > beacons? I don't see the point in changing the beacons if we don't
> > > > send them, after all.
> > > 
> > > You're right, changing the beacons doesn't make sense in this case.
> > > I'll change that and send v2.
> > > 
> > > Another thing is that we are missing the action frames.  The idea with
> > > the count == 0 is that the STA's should start listening on the other
> > > channel immediately after receiving the action frame (because the
> > > switch will happen at any time).
> > > 
> > > If we don't send the action frame, passing context == 0 from the
> > > userspace doesn't much make sense, because the clients won't know we're
> > > switching.  Well, maybe it makes a bit of sense, if there are no
> > > clients connected, but nevertheless.
> > 
> > Yeah, switching without actionframe and count == 0 is pretty useless.
> 
> Actually, if the userspace requests count == 1, we won't have any
> beacons either, because 1 means "just before the next TBTT".  So for
> count == 1 (coming from the userspace) we shouldn't configure the
> beacon, since we won't send it.  We need the action frame for this case
> too.
> 

Hmm, right, we will decrement the counter before sending it out ...

> > For AP mode, I guess the right place to implement the action frames would
> > be hostap? This would at least allow great flexibility with CSA, ECSA
> > and all the new channel switch IEs coming now. The beacons are also
> > generated in userspace, after all.
> 
> What new channel channel switch IEs?

Right now we also have extendended channel switch announcements (ECSA), and 
secondary channel offset, and there are more to come with 802.11ac I think. I 
have not studied it yet (and I don't have access to 802.11 drafts), but have a 
look at that:

https://mentor.ieee.org/802.11/dcn/13/11-13-0105-00-00ac-lb190-proposed-
resolution-on-cid-7367-and-7368.docx&ei=T_N4UuHWGcmt4ATQj4DwBg&usg=AFQjCNE5E-
bpqRGQM7-QwG0L4TiU3OOLig&bvm=bv.55980276,d.bGE&cad=rja

(not only the .doc format is ugly)

> 
> You're right that it might make sense to implement the action frames in
> hostap.  But OTOH, the action frame is quite simple and mac80211 should
> have all the information needed to send it out.
> 
> > BTW, I've just checked and the WiFi Alliance requires at least 5 beacons
> > with CSA-IEs to pass the 802.11h test. :)
> 
> Do you mean that the tests only check when count starts as > 5?
> 

It checks if the last beacon hast a CSA IE in the beacon, and also if there 
are 4 beacons before that including a CSA IE. It does not check for the count 
though, but that's implicitly given ...

Cheers,
   Simon

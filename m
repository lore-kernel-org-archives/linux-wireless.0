Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:52010 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754745Ab3ADNVM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 4 Jan 2013 08:21:12 -0500
Message-ID: <1357305685.11302.17.camel@jlt4.sipsolutions.net> (sfid-20130104_142119_137147_FCF9B35F)
Subject: Re: [PATCHv5 0/8] Add DFS master ability
From: Johannes Berg <johannes@sipsolutions.net>
To: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
Cc: linux-wireless@vger.kernel.org, victorg@ti.com,
	linville@tuxdriver.com, kgiori@qca.qualcomm.com,
	zefir.kurtisi@neratec.com, adrian@freebsd.org, j@w1.fi,
	coelho@ti.com, igalc@ti.com, nbd@nbd.name,
	mathias.kretschmer@fokus.fraunhofer.de,
	Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Date: Fri, 04 Jan 2013 14:21:25 +0100
In-Reply-To: <20130102144416.GA7794@pandem0nium>
References: <1355407113-27006-1-git-send-email-siwu@hrz.tu-chemnitz.de>
	 <1357134823.9839.41.camel@jlt4.sipsolutions.net>
	 <20130102144416.GA7794@pandem0nium>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2013-01-02 at 15:44 +0100, Simon Wunderlich wrote:

> > To me, the open questions are:
> >  * Should switching to a DFS channel be allowed at all? How so, if radar
> >    can't be tested before? You just stop the AP instead but userspace
> >    can do that just as well.
> 
> The idea was to allow counting down the TBTT/count field of the CSA IE within
> the driver - this can't be done properly by userspace.

What if the driver doesn't do it either, say with ath9k it seems
mac80211 would have to do it and also switch the channel later. (That's
essentially what I was referring to when I said we might need a
"software implementation" on patch 7)

> Also, the transmission must be stopped on the new channel, so the idea was
> to do this in kernel space right after the counting is finished. The idea
> was to skip the additional enable_tx call which was originally proposed,
> but it seems to create more troubles than it saves.

I guess it depends on whether we switch to a radar channel or not.
However I'm not convinced that switching to a radar channel makes sense
at all -- it basically means the AP is dead for the clients.
Disconnecting all the clients instead would make more sense, it seems?
And in order to do that, we either just send each one a unicast deauth,
but if that keeps too much traffic active we might have to announce a
switch and then send deauth to everyone I guess anyway. But such a
switch could go to a non-radar channel, or we could even switch to a
non-radar channel first and then deauth all stations afterwards ...

All of that can be implemented without the ability to directly switch to
a radar channel though.

> >  * What happens with multiple virtual interfaces? You allow a single
> >    channel context only which makes sense, but that doesn't disallow
> >    things like having a client + AP, and then the client switching away
> >    because the P2P GO it was connected to randomly decided to switch.
> >    This would break radar detection. (1) What should happen in this
> >    case?
> 
> Actually I thought I had succesfully disabled multiple interfaces in general
> when DFS channels are used. Maybe I missed something?

As we discussed, you missed actually locking the interface into CAC mode
so none of this ever happened -- see cfg80211_get_chan_state().

> For now, I'd prefer having only a single interface when doing DFS.
> 
> >  * To avoid that problem, could restrict to a single virtual interface.
> >    However, that's unlikely to be sufficient -- you'd want to still be
> >    able to implement multi-BSSID APs which then switch together etc.
> 
> Agreed. In the first step, we could allow multi-BSSID APs. When one hostapd
> instance controls these APs, it should have enough information to coordinate
> the CSAs on all APs. 

Yes. The question is what APIs it should use. Or maybe, with channel
contexts, the multiple BSSIDs could switch to different channels even?!
I don't think that makes sense, but hey...

> >  * That raises another interesting question -- should multiple BSSIDs on
> >    the same channel really *all* call the driver's ap_channel_switch()
> >    callback? That seems ... strange!
> 
> Hmm, the channel should only be switched once, that's right.
> 
> What about:
>  * set CSA IEs in the beacons of all APs
>  * call ap_channel_switch once for all APs on the phy
>  * report switched channel back for all APs
>  * remove CSA IEs

Hmm ok with this approach it'd be problematic to set the
pre-/post-chanswitch beacon IEs in the command. We may have to allow the
command to affect a list of interfaces with some nested netlink
attributes.

Then you'd basically have
AP_CHANSWITCH
  - interfaces:
    - wlan0:
      - pre-switch beacon
      - post-switch beacon
      - new chandef (for width etc.)
    - wlan1: ...
    - ...

We'd have to make sure all those interfaces are on the same channel
context when this happens, but that seems doable. Oh and all interfaces
have to be on the same wiphy as well, of course.

That needs to be reflected in all the various APIs too.


> >  * Do we need any software channel switch handling?
> 
> Don't know what you specifically mean.

(see above)

johannes


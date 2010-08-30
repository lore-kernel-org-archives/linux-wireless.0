Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:47781 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755765Ab0H3Psh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Aug 2010 11:48:37 -0400
Subject: Re: [RFC 0/3] mac80211: new API for handling broadcast / multicast
 on sw scan
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	amod.bodas@atheros.com
In-Reply-To: <AANLkTinOzTHn4okTdm=321sdAKy8z1ji_1K_SsDd_dH2@mail.gmail.com>
References: <1282979590-31113-1-git-send-email-lrodriguez@atheros.com>
	 <1283177949.3691.72.camel@jlt3.sipsolutions.net>
	 <AANLkTinOzTHn4okTdm=321sdAKy8z1ji_1K_SsDd_dH2@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 30 Aug 2010 17:47:59 +0200
Message-ID: <1283183279.3691.82.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2010-08-30 at 08:37 -0700, Luis R. Rodriguez wrote:

> > Also, some of your comments seem like you're confused about being an AP
> > vs. being associated to one?
> 
> Like?

Like doing CAB stuff, or saying that drivers need to keep track of DTIM
count, that seems more AP related to me, but maybe I'm not understanding
you correctly.

> > What are you actually trying to achieve?
> 
> The current sw code simply follows the listen interval, it in no way
> respect the DTIM. What this means is you loose the buffered multicast
> and broadcast frames the AP saves up for you after the DTIM beacon.

Right, I don't deny that this is an issue.

> Apart from ensuring you awake at the DTIM count you then also have to
> ensure you stay awake for all the multicast / broadcast data after the
> DTIM. It was my understanding you were postulating that all this is a
> requirement for the drivers to do properly given that mac80211 is too
> slow to do it properly.

No, I was mostly speaking about the powersave case, where for maximum
power saving and correctness you need to wake up right before the
beacon. Going offchannel only _after_ a DTIM beacon and associated
multicast traffic seems unrelated to that?

> > It seems mac80211 can, no
> > matter what the driver is
> >  - wait for DTIM beacons, and the end of mcast traffic, before going off
> >   channel (should be relevant for p2p as well)
> 
> I do not deny this is not possible, I was following your statements
> about mac80211 being too slow to handle this, so was relying more on
> the driver to achieve this.

I believe we just misunderstood each other in that other thread, which
is probably mostly my fault since I started talking about powersave when
you were concerned about scan only.

>  I actually believe this should go into
> mac80211 but its not there yet. ath9k also has its own nullfunc
> requirements handled for the ath9k vritual wiphy stuff so either way
> you still have some private uses for the nullfunc frames. I rather
> take this up in steps in mac80211.

Right, I agree, let's tackle the issue step by step :) I guess we
disagree on what the steps should be and what order they should be in,
though.

> >  - attempt to do better wrt. scheduling between DTIM, by scheduling
> >   closer (but if DTIM period is 1, this may fail)
> 
> To do this you still need to handle all the different sorts of code
> paths for nullfuncs and ensure they are ACK'd. You have the private
> ath9k virtual wiphy too.. which I rather see removed but we have no
> alternative to replace it yet do we?

We're going to discuss multi-channel operation next week, and I believe
then we can remove it. We're mostly there, I believe, just some mac80211
internal re-design will be needed (with driver changes, obviously).

> >  - subject to the driver advertising guaranteed TX status, it can also
> >   wait for the nullfunc ACK -- you should also implement flush which
> >   will probably improve things by itself for ath9k
> 
> Sure, I have some patches for that as well. The nullfunc ACK wait for
> the offchannel operation *can* be handled indeed by mac80211, as my
> latest comments indicate. But note we'd have to categorize the
> different types of uses for the nullfuncs. We also have some private
> driver uses of nullfuncs such as the ath9k virtual wiphy.

Well those seem like a corner case though, let's not let the design be
impacted by something we're going to get rid of in the fairly short
term.

> Then -- you also have other synch wait considerations to address which
> are also currently only private to the driver. ath9k has these:
> 
> +       wait_for = PS_WAIT_FOR_BEACON |
> +                  PS_BEACON_SYNC |
> +                  PS_WAIT_FOR_CAB |
> +                  PS_WAIT_FOR_PSPOLL_DATA |
> +                  PS_WAIT_FOR_TX_ACK |
> +                  PS_NULLFUNC_COMPLETED;
> 
> Of those I see an easy way to move to mac80211 the
> PS_NULLFUNC_COMPLETED except for the private driver usage for
> ath9k_send_nullfunc().

 - wait for beacon: can be moved, if that's waiting for DTIM + traffic?
 - beacon sync:     no idea what this is?
 - wait for cab:    seems AP related? we turn off beaconing when
                    scanning on APs
 - pspoll:          seems like it could be done in mac80211, though
                    I guess it shouldn't matter if our nullfunc was
                    ACKed
 - tx ack:          no idea what this is about?
 - nullfunc:        can be moved

> The others require either some new API or as I
> put it, a driver callback for wait constraints. As I see it, I think
> these all of these *should* be moved to mac80211, but I don't expect
> to do this all in one shot and think its better to do address them one
> at a time.

Well, the other major issue with this is that you basically poll the
driver until those constraints no longer exist, and the polling interval
of 200ms is rather strange. So I suspect this really needs to be more of
an event based API.

johannes


Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:41077 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757414Ab0HaOgn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 31 Aug 2010 10:36:43 -0400
Subject: Re: [RFC 0/3] mac80211: new API for handling broadcast / multicast
 on sw scan
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	amod.bodas@atheros.com, Matt Smith <Matt.Smith@atheros.com>,
	Kevin Hayes <kevin@atheros.com>
In-Reply-To: <AANLkTin9KBUTZSkiL-qMnToaMjXS9S3j3PzV-AZWa_9U@mail.gmail.com>
References: <1282979590-31113-1-git-send-email-lrodriguez@atheros.com>
	 <1283177949.3691.72.camel@jlt3.sipsolutions.net>
	 <AANLkTinOzTHn4okTdm=321sdAKy8z1ji_1K_SsDd_dH2@mail.gmail.com>
	 <1283183279.3691.82.camel@jlt3.sipsolutions.net>
	 <AANLkTi=bVRaDs6z6EavxCLFdMeNRhB=85yKtaHr-_hL-@mail.gmail.com>
	 <1283191837.3694.13.camel@jlt3.sipsolutions.net>
	 <AANLkTin9KBUTZSkiL-qMnToaMjXS9S3j3PzV-AZWa_9U@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 31 Aug 2010 16:36:39 +0200
Message-ID: <1283265399.3733.18.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2010-08-30 at 12:20 -0700, Luis R. Rodriguez wrote:

> >> > Going offchannel only _after_ a DTIM beacon and associated
> >> > multicast traffic seems unrelated to that?
> >>
> >> Yes. What you note seems to be another challenge.
> >
> > I thought you set out to solve that bit. Now I'm confused.
> 
> Hm yeah this came out wrong in this context, I meant about you
> pointing out we want to *wake* up at the right time. What my patches
> do is prevent us from going to sleep at the wrong times, it does not
> address we ensure we *wake* up at the right time. 

We're not even really going to sleep, when we scan. It would be
interesting to try to be back on the channel in time, but I believe we
can either make it easily, or for passive scanning basically always miss
it if the DTIM period is 1.

> The existing code
> addresses the waking up part by ensuring we don't go off channel for
> more than the listen interval. My additions push this further to
> ensure we don't also going to sleep when waiting for DTIM / CAB crap /
> PS-Poll / first TX ACK from AP.

Go offchannel, not to sleep.

> I haven't yet considered how we can guarantee we will be awake at the
> right time though. If you think about it the driver wait constraint
> callback I provide simply prevents us from scanning off channel when
> our driver knows we should not soon. That soon is obviously relative
> to where and how the ath9k wait flags are set.

I still don't quite believe that. The wait flags seem to be mostly
related to powersave, but for scan we really only have to wait for DTIM
+traffic plus all the other stuff we talked about.

> In practice my patches are working swell though but I do believe we
> need to consider both requirements to make this work perfectly:
> prevent going off channel for wait constraints

Yes, but we don't need ath9k's wait constraints for this. All of the
stuff you've really implemented, apart from virtual wiphys, can also be
implemented in mac80211.

> >> a. Sync TSF if it does not look correct against the AP's TSF, so we
> >> wait until the next AP's beacon prior to going to sleep. We ask the
> >> driver to wait for the next beacon but also set the beacon synch flag
> >> so we can sync up the TSF.
> >
> > But if we're doing a sleep for scan, we don't really care all that much
> > about TSF sync, since we're going to be awake anyway.
> 
> The TSF synch will help us more accurately set the other flags though,
> if we ignore it by the time we come back to our home channel we likely
> would be out of synch with the AP's beacons. It makes sense to me to
> wait to be in synch with the AP's beacons before going off channel,
> otherwise our other wait constraints would be off. Let alone
> calculating the time we do need to be awake for.

I don't think I can parse this. But does it matter? If we're going to
wait for a DTIM beacon in mac80211, we should have TSF sync anyway. And
after you go back to the operating channel, it seems likely that you'd
want to re-sync anyway.

> >> >  - tx ack:          no idea what this is about?
> >>
> >> This is used by ath9k to avoid putting the chip to sleep if we are
> >> waking up and want to wait for the first ACK from the AP. When we wake
> >> up from sleep mac80211 will typically send a ps-poll to the AP so we
> >> can pick up any buffered frames, but there are other cases when we may
> >> not send the ps-poll, so we need at least an ACK from the AP to ensure
> >> we are communicating with it. I am not sure of the history of this,
> >> and will need to print here to see when this occurs exactly.
> >
> > Ok, but if it is as you say, then we don't need this for scan?
> 
> It is a good question, can we be relying on on ACK from the AP other
> than PS-poll data after coming out of sleep? I am not sure.

?
The AP will ACK the nullfunc frame when you wake up, that should be
sufficient to know that the AP knows you've woken up. Or returned to the
operating channel, in the context of this discussion.

> Truth be told I think all this is just hackery to get this stuff
> working, the real work needed is to move more checks from ath9k into
> mac80211, but as I see it, this should be done in steps and I
> currently cannot guarantee proper functionality without this API since
> drivers which do sw can *are* dealing with these synch issues. The
> problem lies in that until we don't get *all* of them dealt with in
> mac80211 we'll need this temporary API. I am 100% reluctant to add
> bloat to mac80211 but I am also more reluctant to prevent proper
> functionality with only a high requirement on code changes.
> 
> Not sure how else to deal with this. Please let me know if you can
> think of a better way.

I dunno, why do you need this solved yesterday if you didn't care about
it all along? :-)

I guess I'd suggest to just start doing it in mac80211 where it helps
all other drivers more? Like for example just implementing waiting for
DTIM (traffic), that should be simple -- at the beginning of scan you
just wake up the HW, wait for a (any) beacon, calculate if you can fit
off-channel time before DTIM, and either wait for DTIM beacon+traffic or
squeeze off-channel time before it... Seems simple enough?

johannes


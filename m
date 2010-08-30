Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:35228 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755530Ab0H3SA2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Aug 2010 14:00:28 -0400
Received: by iwn5 with SMTP id 5so5076668iwn.19
        for <linux-wireless@vger.kernel.org>; Mon, 30 Aug 2010 11:00:27 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1283183279.3691.82.camel@jlt3.sipsolutions.net>
References: <1282979590-31113-1-git-send-email-lrodriguez@atheros.com>
 <1283177949.3691.72.camel@jlt3.sipsolutions.net> <AANLkTinOzTHn4okTdm=321sdAKy8z1ji_1K_SsDd_dH2@mail.gmail.com>
 <1283183279.3691.82.camel@jlt3.sipsolutions.net>
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Date: Mon, 30 Aug 2010 11:00:06 -0700
Message-ID: <AANLkTi=bVRaDs6z6EavxCLFdMeNRhB=85yKtaHr-_hL-@mail.gmail.com>
Subject: Re: [RFC 0/3] mac80211: new API for handling broadcast / multicast on
 sw scan
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	amod.bodas@atheros.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Aug 30, 2010 at 8:47 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Mon, 2010-08-30 at 08:37 -0700, Luis R. Rodriguez wrote:
>
>> > Also, some of your comments seem like you're confused about being an AP
>> > vs. being associated to one?
>>
>> Like?
>
> Like doing CAB stuff, or saying that drivers need to keep track of DTIM
> count, that seems more AP related to me, but maybe I'm not understanding
> you correctly.

Well say you want to go to sleep for a sw scan. You not only have to
wait for the DTIM beacon prior to going to sleep but you also have to
wait so that all multicast and broadcast traffice get spit out by the
AP, right?

>> > What are you actually trying to achieve?
>>
>> The current sw code simply follows the listen interval, it in no way
>> respect the DTIM. What this means is you loose the buffered multicast
>> and broadcast frames the AP saves up for you after the DTIM beacon.
>
> Right, I don't deny that this is an issue.

OK what I'm saying is I realized that simply taking into consideration
the DTIM interval is not enough. We also have to ensure we receive all
the multicast and broadcast data prior to going to sleep. Then, there
are the other wait constraints, and handling of the different types of
nullfuncs.

>> Apart from ensuring you awake at the DTIM count you then also have to
>> ensure you stay awake for all the multicast / broadcast data after the
>> DTIM. It was my understanding you were postulating that all this is a
>> requirement for the drivers to do properly given that mac80211 is too
>> slow to do it properly.
>
> No, I was mostly speaking about the powersave case, where for maximum
> power saving and correctness you need to wake up right before the
> beacon.

Ah, I see.

> Going offchannel only _after_ a DTIM beacon and associated
> multicast traffic seems unrelated to that?

Yes. What you note seems to be another challenge.

>> > It seems mac80211 can, no
>> > matter what the driver is
>> >  - wait for DTIM beacons, and the end of mcast traffic, before going off
>> >   channel (should be relevant for p2p as well)
>>
>> I do not deny this is not possible, I was following your statements
>> about mac80211 being too slow to handle this, so was relying more on
>> the driver to achieve this.
>
> I believe we just misunderstood each other in that other thread, which
> is probably mostly my fault since I started talking about powersave when
> you were concerned about scan only.

OK -- I do also think it would be nice then to ensure mac80211 keeps
us up until DTIM / mcast/bcast frames are RX'd, but think this can be
done in steps. More on this below.

>>  I actually believe this should go into
>> mac80211 but its not there yet. ath9k also has its own nullfunc
>> requirements handled for the ath9k vritual wiphy stuff so either way
>> you still have some private uses for the nullfunc frames. I rather
>> take this up in steps in mac80211.
>
> Right, I agree, let's tackle the issue step by step :) I guess we
> disagree on what the steps should be and what order they should be in,
> though.

I don't think we disagree, I think we just need to review this
carefully and decide what is best.

>> >  - attempt to do better wrt. scheduling between DTIM, by scheduling
>> >   closer (but if DTIM period is 1, this may fail)
>>
>> To do this you still need to handle all the different sorts of code
>> paths for nullfuncs and ensure they are ACK'd. You have the private
>> ath9k virtual wiphy too.. which I rather see removed but we have no
>> alternative to replace it yet do we?
>
> We're going to discuss multi-channel operation next week, and I believe
> then we can remove it. We're mostly there, I believe, just some mac80211
> internal re-design will be needed (with driver changes, obviously).

offchannel.c will eventually be removed?

>> >  - subject to the driver advertising guaranteed TX status, it can also
>> >   wait for the nullfunc ACK -- you should also implement flush which
>> >   will probably improve things by itself for ath9k
>>
>> Sure, I have some patches for that as well. The nullfunc ACK wait for
>> the offchannel operation *can* be handled indeed by mac80211, as my
>> latest comments indicate. But note we'd have to categorize the
>> different types of uses for the nullfuncs. We also have some private
>> driver uses of nullfuncs such as the ath9k virtual wiphy.
>
> Well those seem like a corner case though, let's not let the design be
> impacted by something we're going to get rid of in the fairly short
> term.

Sure :) but we still do need to take into consideration the other
valid uses of nulfuncs in mac80211. The offchannel case is not handled
properly right now.

>> Then -- you also have other synch wait considerations to address which
>> are also currently only private to the driver. ath9k has these:
>>
>> +       wait_for = PS_WAIT_FOR_BEACON |
>> +                  PS_BEACON_SYNC |
>> +                  PS_WAIT_FOR_CAB |
>> +                  PS_WAIT_FOR_PSPOLL_DATA |
>> +                  PS_WAIT_FOR_TX_ACK |
>> +                  PS_NULLFUNC_COMPLETED;
>>
>> Of those I see an easy way to move to mac80211 the
>> PS_NULLFUNC_COMPLETED except for the private driver usage for
>> ath9k_send_nullfunc().
>
>  - wait for beacon: can be moved, if that's waiting for DTIM + traffic?

This is used for:

a. Sync TSF if it does not look correct against the AP's TSF, so we
wait until the next AP's beacon prior to going to sleep. We ask the
driver to wait for the next beacon but also set the beacon synch flag
so we can sync up the TSF.

b. When we get a DTIM and it notes we have mcast/bcast (CAB) crap to
wait for. What this does is it makes us wait until the next beacon in
case we miss the last broadcast / mcast frame. The next beacon will
serve as a backup trigger for returning to to network sleep mode.

>  - beacon sync:     no idea what this is?

This is used in combination with the above. It forces us to
reconfigure our beacon timers, essentially we run
ath_beacon_config(sc, NULL); on the next beacon we get from the AP.
This sets up the beacon timers according to the timestamp of the last
received beacon and the current TSF, configures PCF, DTIM handling,
programs the sleep registers so the hardware will wake up in time to
receive beacons, and configures the beacon miss interrupt to alert us
when we've stop seeing beacons from the AP we have associated with.

>  - wait for cab:    seems AP related? we turn off beaconing when
>                    scanning on APs

No, we use this to annotate to the driver it needs to sit and wait
until all mcast / bcast frames have been received. We do this in
combination with the beacon wait flag in case we miss the last bcast /
mcast frame or if the AP fails to send a frame indicating that all CAB
frames have been delivered.

>  - pspoll:          seems like it could be done in mac80211, though
>                    I guess it shouldn't matter if our nullfunc was
>                    ACKed

Right.

>  - tx ack:          no idea what this is about?

This is used by ath9k to avoid putting the chip to sleep if we are
waking up and want to wait for the first ACK from the AP. When we wake
up from sleep mac80211 will typically send a ps-poll to the AP so we
can pick up any buffered frames, but there are other cases when we may
not send the ps-poll, so we need at least an ACK from the AP to ensure
we are communicating with it. I am not sure of the history of this,
and will need to print here to see when this occurs exactly.

>  - nullfunc:        can be moved

Heh... not yet. That was done because we ended up looping trying to
send nullfuncs because we never waited for the nullfunc to be ACK'd. I
believe the issue was caused by the fact that mac80211 only keeps
track of nullfunc ACKs for PS but not for when we go off channel. I
could be wrong though. Anyway, if we remove considerations for the
ath9k virtual wiphy then I think we can move this into mac80211 as I
noted in my last set of hunks, the code that checks for the type of
nullfunc is still missing and obviously this would need testing.

>> The others require either some new API or as I
>> put it, a driver callback for wait constraints. As I see it, I think
>> these all of these *should* be moved to mac80211, but I don't expect
>> to do this all in one shot and think its better to do address them one
>> at a time.
>
> Well, the other major issue with this is that you basically poll the
> driver until those constraints no longer exist, and the polling interval
> of 200ms is rather strange.

Agreed -- I noted this needs review :)

> So I suspect this really needs to be more of
> an event based API.

Agreed, also I believe the wait constraint state machine should be
handled in mac80211 for drivers which require sw scan. But I'd like to
start off with the simple items and fix the driver with as little work
as possible first. Then slowly move crap over to mac80211 and replace
ath9k code with its mac80211 equivalent.

  Luis

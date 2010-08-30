Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:36545 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753946Ab0H3TU4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Aug 2010 15:20:56 -0400
Received: by iwn5 with SMTP id 5so5115005iwn.19
        for <linux-wireless@vger.kernel.org>; Mon, 30 Aug 2010 12:20:56 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1283191837.3694.13.camel@jlt3.sipsolutions.net>
References: <1282979590-31113-1-git-send-email-lrodriguez@atheros.com>
 <1283177949.3691.72.camel@jlt3.sipsolutions.net> <AANLkTinOzTHn4okTdm=321sdAKy8z1ji_1K_SsDd_dH2@mail.gmail.com>
 <1283183279.3691.82.camel@jlt3.sipsolutions.net> <AANLkTi=bVRaDs6z6EavxCLFdMeNRhB=85yKtaHr-_hL-@mail.gmail.com>
 <1283191837.3694.13.camel@jlt3.sipsolutions.net>
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Date: Mon, 30 Aug 2010 12:20:32 -0700
Message-ID: <AANLkTin9KBUTZSkiL-qMnToaMjXS9S3j3PzV-AZWa_9U@mail.gmail.com>
Subject: Re: [RFC 0/3] mac80211: new API for handling broadcast / multicast on
 sw scan
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	amod.bodas@atheros.com, Matt Smith <Matt.Smith@atheros.com>,
	Kevin Hayes <kevin@atheros.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Note: this e-mail is on a public mailing list.

On Mon, Aug 30, 2010 at 11:10 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Mon, 2010-08-30 at 11:00 -0700, Luis R. Rodriguez wrote:
>
>> > Like doing CAB stuff, or saying that drivers need to keep track of DTIM
>> > count, that seems more AP related to me, but maybe I'm not understanding
>> > you correctly.
>>
>> Well say you want to go to sleep for a sw scan. You not only have to
>> wait for the DTIM beacon prior to going to sleep but you also have to
>> wait so that all multicast and broadcast traffice get spit out by the
>> AP, right?
>
> Yeah, ok, I was thinking of these terms (CAB, DTIM count) as being AP
> specific -- the client just waits for the right beacon, it doesn't
> really need to count etc. But ok, just a misunderstanding then.
>
>> > Going offchannel only _after_ a DTIM beacon and associated
>> > multicast traffic seems unrelated to that?
>>
>> Yes. What you note seems to be another challenge.
>
> I thought you set out to solve that bit. Now I'm confused.

Hm yeah this came out wrong in this context, I meant about you
pointing out we want to *wake* up at the right time. What my patches
do is prevent us from going to sleep at the wrong times, it does not
address we ensure we *wake* up at the right time. The existing code
addresses the waking up part by ensuring we don't go off channel for
more than the listen interval. My additions push this further to
ensure we don't also going to sleep when waiting for DTIM / CAB crap /
PS-Poll / first TX ACK from AP.

I haven't yet considered how we can guarantee we will be awake at the
right time though. If you think about it the driver wait constraint
callback I provide simply prevents us from scanning off channel when
our driver knows we should not soon. That soon is obviously relative
to where and how the ath9k wait flags are set.

In practice my patches are working swell though but I do believe we
need to consider both requirements to make this work perfectly:
prevent going off channel for wait constraints, and ensuring we wake
up. I see we program beacon timers for this on ath9k though but not
sure what happens when we go off channel.

>> > We're going to discuss multi-channel operation next week, and I believe
>> > then we can remove it. We're mostly there, I believe, just some mac80211
>> > internal re-design will be needed (with driver changes, obviously).
>>
>> offchannel.c will eventually be removed?
>
> I don't think so, why? Oh, no, I meant virtual wiphys can be removed.

Ah OK.

>> >> Then -- you also have other synch wait considerations to address which
>> >> are also currently only private to the driver. ath9k has these:
>> >>
>> >> +       wait_for = PS_WAIT_FOR_BEACON |
>> >> +                  PS_BEACON_SYNC |
>> >> +                  PS_WAIT_FOR_CAB |
>> >> +                  PS_WAIT_FOR_PSPOLL_DATA |
>> >> +                  PS_WAIT_FOR_TX_ACK |
>> >> +                  PS_NULLFUNC_COMPLETED;
>> >>
>> >> Of those I see an easy way to move to mac80211 the
>> >> PS_NULLFUNC_COMPLETED except for the private driver usage for
>> >> ath9k_send_nullfunc().
>> >
>> >  - wait for beacon: can be moved, if that's waiting for DTIM + traffic?
>>
>> This is used for:
>>
>> a. Sync TSF if it does not look correct against the AP's TSF, so we
>> wait until the next AP's beacon prior to going to sleep. We ask the
>> driver to wait for the next beacon but also set the beacon synch flag
>> so we can sync up the TSF.
>
> But if we're doing a sleep for scan, we don't really care all that much
> about TSF sync, since we're going to be awake anyway.

The TSF synch will help us more accurately set the other flags though,
if we ignore it by the time we come back to our home channel we likely
would be out of synch with the AP's beacons. It makes sense to me to
wait to be in synch with the AP's beacons before going off channel,
otherwise our other wait constraints would be off. Let alone
calculating the time we do need to be awake for.

>> b. When we get a DTIM and it notes we have mcast/bcast (CAB) crap to
>> wait for. What this does is it makes us wait until the next beacon in
>> case we miss the last broadcast / mcast frame. The next beacon will
>> serve as a backup trigger for returning to to network sleep mode.
>
> Ok, this is OK I guess, it seems to be an artifact of your powersave
> implementation. I was thinking it was AP related.

Right -- its all software, I guess hardware could be improved to
handle this but then it means more registers and state machines. I'll
check for future hardware.

>> >  - beacon sync:     no idea what this is?
>>
>> This is used in combination with the above. It forces us to
>> reconfigure our beacon timers, essentially we run
>> ath_beacon_config(sc, NULL); on the next beacon we get from the AP.
>> This sets up the beacon timers according to the timestamp of the last
>> received beacon and the current TSF, configures PCF, DTIM handling,
>> programs the sleep registers so the hardware will wake up in time to
>> receive beacons, and configures the beacon miss interrupt to alert us
>> when we've stop seeing beacons from the AP we have associated with.
>
> Ok but then why do we care for a scan case?

To wake up at the right time, to be in synch with the AP's beacons
after we have gone off channel, and come back home. To be honest the
ath_beacon_config_sta() seems a little fishy to me. The beacon config
is picked up from &sc->cur_beacon_conf but I do not see that ever
being set from beacon data. The only use I see for
ath_beacon_config_sta() is the TSF sync and computing our next wake up
time, and beacon miss timers.

>> >  - wait for cab:    seems AP related? we turn off beaconing when
>> >                    scanning on APs
>>
>> No, we use this to annotate to the driver it needs to sit and wait
>> until all mcast / bcast frames have been received. We do this in
>> combination with the beacon wait flag in case we miss the last bcast /
>> mcast frame or if the AP fails to send a frame indicating that all CAB
>> frames have been delivered.
>
> Gotcha. But that's easy to implement in mac80211.

Sure. Agreed.

>> >  - tx ack:          no idea what this is about?
>>
>> This is used by ath9k to avoid putting the chip to sleep if we are
>> waking up and want to wait for the first ACK from the AP. When we wake
>> up from sleep mac80211 will typically send a ps-poll to the AP so we
>> can pick up any buffered frames, but there are other cases when we may
>> not send the ps-poll, so we need at least an ACK from the AP to ensure
>> we are communicating with it. I am not sure of the history of this,
>> and will need to print here to see when this occurs exactly.
>
> Ok, but if it is as you say, then we don't need this for scan?

It is a good question, can we be relying on on ACK from the AP other
than PS-poll data after coming out of sleep? I am not sure.

>> >  - nullfunc:        can be moved
>>
>> Heh... not yet. That was done because we ended up looping trying to
>> send nullfuncs because we never waited for the nullfunc to be ACK'd. I
>> believe the issue was caused by the fact that mac80211 only keeps
>> track of nullfunc ACKs for PS but not for when we go off channel. I
>> could be wrong though. Anyway, if we remove considerations for the
>> ath9k virtual wiphy then I think we can move this into mac80211 as I
>> noted in my last set of hunks, the code that checks for the type of
>> nullfunc is still missing and obviously this would need testing.
>
> Right ... the virtual wiphy case is a special case, but I'd rather
> disregard it for a while. If you implement flush(), then waiting for the
> nullfunc (and potentially retrying, which we don't do right now since
> it's a unicast frame and really shouldn't get lost) should be simple.

Agreed, in theory. We'll see in practice.

>> Agreed, also I believe the wait constraint state machine should be
>> handled in mac80211 for drivers which require sw scan. But I'd like to
>> start off with the simple items and fix the driver with as little work
>> as possible first. Then slowly move crap over to mac80211 and replace
>> ath9k code with its mac80211 equivalent.
>
> I just don't like the need to have this API. Nothing here so far seems
> to really need new API between the driver and mac80211, with the
> possible exception of the driver saying that it has reliable TX status.
> Or so I believe?

Truth be told I think all this is just hackery to get this stuff
working, the real work needed is to move more checks from ath9k into
mac80211, but as I see it, this should be done in steps and I
currently cannot guarantee proper functionality without this API since
drivers which do sw can *are* dealing with these synch issues. The
problem lies in that until we don't get *all* of them dealt with in
mac80211 we'll need this temporary API. I am 100% reluctant to add
bloat to mac80211 but I am also more reluctant to prevent proper
functionality with only a high requirement on code changes.

Not sure how else to deal with this. Please let me know if you can
think of a better way.

  Luis

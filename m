Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:56901 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932343Ab0HaPbL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 31 Aug 2010 11:31:11 -0400
Received: by iwn5 with SMTP id 5so5946810iwn.19
        for <linux-wireless@vger.kernel.org>; Tue, 31 Aug 2010 08:31:10 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1283265399.3733.18.camel@jlt3.sipsolutions.net>
References: <1282979590-31113-1-git-send-email-lrodriguez@atheros.com>
 <1283177949.3691.72.camel@jlt3.sipsolutions.net> <AANLkTinOzTHn4okTdm=321sdAKy8z1ji_1K_SsDd_dH2@mail.gmail.com>
 <1283183279.3691.82.camel@jlt3.sipsolutions.net> <AANLkTi=bVRaDs6z6EavxCLFdMeNRhB=85yKtaHr-_hL-@mail.gmail.com>
 <1283191837.3694.13.camel@jlt3.sipsolutions.net> <AANLkTin9KBUTZSkiL-qMnToaMjXS9S3j3PzV-AZWa_9U@mail.gmail.com>
 <1283265399.3733.18.camel@jlt3.sipsolutions.net>
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Date: Tue, 31 Aug 2010 08:30:50 -0700
Message-ID: <AANLkTi=yRnMwTBq1ze8LaMCO521YutrtxJpBS0rGuvhJ@mail.gmail.com>
Subject: Re: [RFC 0/3] mac80211: new API for handling broadcast / multicast on
 sw scan
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	amod.bodas@atheros.com, Matt Smith <Matt.Smith@atheros.com>,
	Kevin Hayes <kevin@atheros.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Aug 31, 2010 at 7:36 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Mon, 2010-08-30 at 12:20 -0700, Luis R. Rodriguez wrote:
>
>> >> > Going offchannel only _after_ a DTIM beacon and associated
>> >> > multicast traffic seems unrelated to that?
>> >>
>> >> Yes. What you note seems to be another challenge.
>> >
>> > I thought you set out to solve that bit. Now I'm confused.
>>
>> Hm yeah this came out wrong in this context, I meant about you
>> pointing out we want to *wake* up at the right time. What my patches
>> do is prevent us from going to sleep at the wrong times, it does not
>> address we ensure we *wake* up at the right time.
>
> We're not even really going to sleep, when we scan. It would be
> interesting to try to be back on the channel in time, but I believe we
> can either make it easily, or for passive scanning basically always miss
> it if the DTIM period is 1.

What do you mean by always miss if the DTIM period is 1?

>> The existing code
>> addresses the waking up part by ensuring we don't go off channel for
>> more than the listen interval. My additions push this further to
>> ensure we don't also going to sleep when waiting for DTIM / CAB crap /
>> PS-Poll / first TX ACK from AP.
>
> Go offchannel, not to sleep.

Sure, now re-read the above with "go offchannel".

>> I haven't yet considered how we can guarantee we will be awake at the
>> right time though. If you think about it the driver wait constraint
>> callback I provide simply prevents us from scanning off channel when
>> our driver knows we should not soon. That soon is obviously relative
>> to where and how the ath9k wait flags are set.
>
> I still don't quite believe that. The wait flags seem to be mostly
> related to powersave,

This is true, but why would they not be important for going off
channel ? The TSF sync seems just as important as waiting for the ACK
for the nullfunc from the AP.

> but for scan we really only have to wait for DTIM
> +traffic plus all the other stuff we talked about.

Can you be more specific, we spoke about quite a few things.
Specifically I mentioned all possible wait constraints.

>> In practice my patches are working swell though but I do believe we
>> need to consider both requirements to make this work perfectly:
>> prevent going off channel for wait constraints
>
> Yes, but we don't need ath9k's wait constraints for this. All of the
> stuff you've really implemented, apart from virtual wiphys, can also be
> implemented in mac80211.

And I agree... however its a good chunk of work to get it all done in
mac80211 in one shot so I am looking for a way to put us on that path.

>> >> a. Sync TSF if it does not look correct against the AP's TSF, so we
>> >> wait until the next AP's beacon prior to going to sleep. We ask the
>> >> driver to wait for the next beacon but also set the beacon synch flag
>> >> so we can sync up the TSF.
>> >
>> > But if we're doing a sleep for scan, we don't really care all that much
>> > about TSF sync, since we're going to be awake anyway.
>>
>> The TSF synch will help us more accurately set the other flags though,
>> if we ignore it by the time we come back to our home channel we likely
>> would be out of synch with the AP's beacons. It makes sense to me to
>> wait to be in synch with the AP's beacons before going off channel,
>> otherwise our other wait constraints would be off. Let alone
>> calculating the time we do need to be awake for.
>
> I don't think I can parse this. But does it matter? If we're going to
> wait for a DTIM beacon in mac80211, we should have TSF sync anyway. And
> after you go back to the operating channel, it seems likely that you'd
> want to re-sync anyway.

I don't understand, you first say it doesn't matter and then you end
up suggesting to actually do a TSF sync prior to going off channel and
then when coming back. It seems to me you do get it.

>> >> >  - tx ack:          no idea what this is about?
>> >>
>> >> This is used by ath9k to avoid putting the chip to sleep if we are
>> >> waking up and want to wait for the first ACK from the AP. When we wake
>> >> up from sleep mac80211 will typically send a ps-poll to the AP so we
>> >> can pick up any buffered frames, but there are other cases when we may
>> >> not send the ps-poll, so we need at least an ACK from the AP to ensure
>> >> we are communicating with it. I am not sure of the history of this,
>> >> and will need to print here to see when this occurs exactly.
>> >
>> > Ok, but if it is as you say, then we don't need this for scan?
>>
>> It is a good question, can we be relying on on ACK from the AP other
>> than PS-poll data after coming out of sleep? I am not sure.
>
> ?
> The AP will ACK the nullfunc frame when you wake up, that should be
> sufficient to know that the AP knows you've woken up. Or returned to the
> operating channel, in the context of this discussion.

Yes, but my point was that right now we don't check for this in
mac80211 but that code does exist in ath9k to wait for an ACK from the
AP. I was explaining when I see PS_WAIT_FOR_TX_ACK used, I noted that
ath9k has code that checks for an ACK from the AP prior to letting us
go to sleep, we force this upon ourselves when first frame we send out
to the AP is not a PS-POLL. I was wondering when this could possibly
happen.

>> Truth be told I think all this is just hackery to get this stuff
>> working, the real work needed is to move more checks from ath9k into
>> mac80211, but as I see it, this should be done in steps and I
>> currently cannot guarantee proper functionality without this API since
>> drivers which do sw can *are* dealing with these synch issues. The
>> problem lies in that until we don't get *all* of them dealt with in
>> mac80211 we'll need this temporary API. I am 100% reluctant to add
>> bloat to mac80211 but I am also more reluctant to prevent proper
>> functionality with only a high requirement on code changes.
>>
>> Not sure how else to deal with this. Please let me know if you can
>> think of a better way.
>
> I dunno, why do you need this solved yesterday if you didn't care about
> it all along? :-)

Our users who care for bcast / mcast do want it solved.

> I guess I'd suggest to just start doing it in mac80211 where it helps
> all other drivers more?

And what is exactly what I'm trying to do. I provided a path to move
code from ath9k to mac80211.

> Like for example just implementing waiting for
> DTIM (traffic), that should be simple -- at the beginning of scan you
> just wake up the HW, wait for a (any) beacon, calculate if you can fit
> off-channel time before DTIM, and either wait for DTIM beacon+traffic or
> squeeze off-channel time before it... Seems simple enough?

And I'm saying its not. To wait for the DTIM you need to know the DTIM
count, and you could also miss a few DTIM beacons. Then you also need
to keep track of the mcast / bcast data after the DTIM beacon. I noted
how ath9k already does all this and we use flags to annotate these
things to help avoid putting our chip to sleep. My patches make use of
these flags from ath9k to prevent us from going offchannel, and what
I'd like to do is to start offloading some of these flags one by one
to mac80211 to make them generic for all mac80211 drivers that use sw
scan.

  Luis

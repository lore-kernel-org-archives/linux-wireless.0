Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.171]:35207 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755853AbZCVWwn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 22 Mar 2009 18:52:43 -0400
Received: by wf-out-1314.google.com with SMTP id 29so2509587wff.4
        for <linux-wireless@vger.kernel.org>; Sun, 22 Mar 2009 15:52:41 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1237757583.19647.50.camel@johannes.local>
References: <1237712542.5100.766.camel@johannes.local> <43e72e890903221348q3db85b30k7975d996c5269c28@mail.gmail.com>
	<1237757583.19647.50.camel@johannes.local>
Date: Sun, 22 Mar 2009 15:52:26 -0700
Message-ID: <43e72e890903221552h56bbf914icc79dcfed46e0d59@mail.gmail.com> (sfid-20090322_235246_845686_F9C3BDDB)
Subject: Re: [RFC] regulatory information interpretation rules
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Michael Green <Michael.Green@atheros.com>,
	Jouni Malinen <j@w1.fi>,
	"John W. Linville" <linville@tuxdriver.com>,
	David Quan <David.Quan@atheros.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Mar 22, 2009 at 2:33 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Sun, 2009-03-22 at 13:48 -0700, Luis R. Rodriguez wrote:
>
>> > =C2=A01) MIN values are really something like MIN+, i.e. approachi=
ng the MIN
>> > =C2=A0 =C2=A0from above, that means that the value "2452 MHz" fall=
s into the
>> > =C2=A0 =C2=A0first of the ranges, not the second [3]
>>
>> I rather be more exact. Can you elaborate a little more on this?
>
> Hmm, ok, well, let me put it this way:
>
> Given
>
> =C2=A0 =C2=A0 =C2=A0 =C2=A0MIN - MAX @ ...
>
> and centre =3D MIN, we do not say that centre falls into that range.
>
> Basically we do "MIN < freq <=3D MAX" rather than "MIN <=3D freq <=3D=
 MAX" to
> avoid problems with
> =C2=A0 =C2=A0 =C2=A0 =C2=A0A - B @ ...
> =C2=A0 =C2=A0 =C2=A0 =C2=A0B - C @ ...
> and then determining which range "B" falls into. My interpretation sa=
ys
> that it belongs into the _first_ rather than the second range.

Hm, it changes the way we think about the regulatory rules
considerably. For example, if a regulatory domain is defined with only
one rule as:

2412 - 2462 @ 40

It would imply that a regular (20 MHz wide) channel 1 with a center of
freq 2412 MHz would not be allowed while a regular (20 MHz wide)
channel 11 with a center of freq 2462 MHz would be allowed. It means
that to the regulatory rule patcher/contributor they would have to
think of the first value used as the center of freq -1 at least, while
the end freq can be equal to the max center of freq allowed.

Would this also mean a channel who's center of freq is 2413 (although
bogus) is allowed?

>> > "Channels 1-11 allow 40 width channels, so HT40 is allowed."
>> >
>> > =C2=A0 =C2=A0 =C2=A0 =C2=A0Channel 11 has center frequency 2462, b=
ut when used with HT40
>> > =C2=A0 =C2=A0 =C2=A0 =C2=A0the center of the used bandwidth falls =
to 2452 or 2472.
>>
>> > =C2=A0 =C2=A0 =C2=A0 =C2=A02452 falls into the first range, so can=
 use 40 MHz,
>>
>> Hm, so the two modified rules that we should look at for a channel
>> who's center freq is 2452 MHz are:
>>
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 ( 2402.000 - *2452.000 @ 40.000), (N/A, =
20.00)
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 (*2452.000 - =C2=A02482.000 @ 20.000), (=
N/A, 20.00)
>>
>> I cannot clearly see how a 40 MHz width channel would be allowed her=
e
>> if its center of freq is 2452 MHz given the interpretation rules
>> above.
>
> This is why I needed the rule 1), to specify that 2452 falls into the
> first range which specifies @40.

I see, thanks for the clarification.

>> It would seem to me the two regulatory rules would be required
>> to make that determination since the start freq and end freq of the
>> HT40 channel would only fit when considering both rules. Why would w=
e
>> determine we can use 40 MHz on this HT40 channel? What if the allowe=
d
>> bandwidth for the second rule was 10 MHz instead of 20 MHz?
>
> That seems irrelevant -- I said that the maximum usable bandwidth
> depends on the range the centre frequency falls into, and all the ran=
ges
> we've defined.

I understand the proposal better now.

> Maybe I should clarify some things more -- it was obvious to me after
> thinking about it, but I suppose I formulated it more as a mathematic=
ian
> than a recipe for an engineer ;)

Heh, thanks yeah the above helps a lot.

>> The overlapping suggestions make sense.
>>
>> Apart from creating a clarification on how we would deal with
>> overlapping regulatory rules this also clarifies the way we should
>> logically think of channels in terms of regulatory for our
>> infrastructure. 802.11 HT40 channels are now viewed as a singular
>> channel with its own center of frequency and the question that is
>> asked is:
>>
>> "is this HT40 channel allowed?"
>
> Right. It's also a clarification that overlapping ranges should not b=
e
> allowed (and we should thus check for that somewhere), and how to han=
dle
> all the possible cases without overlapping ranges, mostly due to 2).
>
>> The notion of the two channels involved required to make use of HT40
>> work is ignored and while this works it should be considered for
>> implementation.
>
> Indeed, this is first and foremost a definition of how to interpret t=
he
> database that we have, and not how to implement it.

Right so reason I mentioned this is because ultimately I'm in favor
for choosing the interpretation and implementation which is easiest,
fastest and will also cause less pain for users of the old style reg
rules.

>> For example we want to allow a channel change to occur
>> as quickly as possible so if the above regulatory questions can be
>> saved into flag form to avoid a direct regulatory rule lookup during
>> channel change I think it would be great. How would we cache the
>> answer to the HT40 question on the channel?
>
> Yeah, I need to think about this. We also need to think about 5/10 MH=
z
> channels. I'm thinking that maybe the best way to do that is to add a
> "supported channel types" bitmap to each channel, which we could then
> modify to include HT40+/- as appropriate as well. Something like we h=
ave
> with orig_flags and flags already.

Yeah I think that would make sense. BTW so one way to deal with this
is to keep the channel.bandwidth and to simply think about it as the
max allowed bandwidth _per_channel_. Technically if this is =3D=3D 20 t=
hen
it is implied channels with custom bandwidths smaller than this would
be allowed. Of course then its a matter of what the device and its
device driver actually supports. As for HT40 the bandwidth required
would be 20 per channel but you'd also need to ensure the channel doe
snot have the NO_HT40 flag set which would have been propagated down
from the regulatory rule.

>> The same HT40 question could be made but instead of looking at the
>> HT40 channel as an individual channel we'd be trying to answer this =
by
>> looking at the two channels involved to make the HT40 channel happen=
=2E
>
> I kinda disagree here. How should we know whether 20+20 is allowed or
> not if we don't treat it as 40?

As of right now the assumption in our code is to disable a channel if
we cannot use at least 20 MHz on it. Therefore if the channel is not
disabled we _know_ we can use 20 MHz on it. If the primary and
secondary channel exists on the device and are enabled then we can
potentially use HT40. The only other question missing is whether or
not the regulatory domain allows for it. We would know whether both
channels' regulatory rule supports HT40 by looking at their respective
freq_range->max_bandiwdth, this would have to be >=3D 40 MHz. Otherwise
we can set a NO_HT40 flag on the channel. We'd then only allow HT40 if
both channels' rules enable it.

>> We'd know if HT40 is allowed by the allowed bandwidth in the given
>> regulatory domain, we'd still have to find out whether or not HT40- =
or
>> HT40+ is allowed but to answer this we first need to know on which
>> channels HT40 is allowed and which channels are disabled. The
>> assumption is if a channel is allowed then the channel can use 20 MH=
z.
>
> Not exactly -- we could have pure 10 MHz bands in the regdb in the
> future.

Agreed, the above was describing how we currently implement this. If
10 Mhz channels are enabled later then the channel's max_bandwidth
would be set to 10 MHz and we'd then add a check to ensure for HT40
both channels support at least 20 MHz.

>> For example to find out whether or not HT40- is allowed we'd first
>> check if the control channel (aka primary channel):
>>
>> =C2=A0 o exists
>> =C2=A0 o allowed
>> =C2=A0 o allows HT40
>>
>> We'd then check if the same for the extension channel (aka secondary
>> channel) exists. If both of these channel checks check out OK then
>> HT40- can be marked as allowed on the primary channel. The answer th=
en
>> becomes cached for later lookups upon channel change.
>
> Ok, yes, we could do that, but it would be disregarding the MAXBW, no=
?
> Or rather, how do you define "allows HT40"?

Nope, the trick is to also rely on the regulatory rule's max bandwidth
to determine whether or not HT40 is allowed or not. For example if you
look at the wireless-regdb and find regulatory rules with a frequency
range marked with a max bandwidth of 20 MHz you'd know the channels
that are being queried that fit into those rules would not allow HT40,
so you set a NO_HT40 flag on the channel.

>> How would we go about this with the proposed changes on considering
>> HT40- upon a channel change?
>
> ?

I was asking specifically how this would be implemented. I was curious
for example if you'd cache or not whether HT40- would be allowed
somehow and if so where.

> Anyhow, yes, there are different ways to implement this, but then it
> seems we'd need more regulatory flags, and I don't see a reason for t=
hat
> given the information we have -- which is only a little quirky for JP
> and KP.

Depends on what you mean by needing more regulatory flags. We would
certainly not require more regulatory flags in the wireless-regdb or
crda, nor to interpret them in the kernel. We would however need them
for the 802.11 code to help cache the answer to these questions. We'd
need the NO_HT40 flag to cache whether or not a regulatory rule's max
bandwidth allows HT40 or not, then we could end up re-using the FAT
above and FAT below flags to indicate NO_HT40MINUS and NO_HT40PLUS. So
technically we wouldn't be adding any other flag other than a NO_HT40
flag just to indicate the regulatory domain's HT40 preferences.

Something we should also take into consideration is the changes
required to the wireless-regdb and what this would imply for users of
kernel code which interpret it differently. This could potentially
mean we'd then have to release two different wireless-regdb files per
release but I think it'd be nice to avoid that if possible

An alternative to this proposal is to clarify how overlapping
regulatory rules should be considered (which is how it works anyway).
Here's my take on it:

If you have overlapping rules you simply apply the first rule which
fits your desired bandwidth and modulation type. Right now we only pay
attention to the desired bandwidth, but we could add things like "OFMD
required" and only return the first rule that allows OFDM for example
for the given bandwidth.

This allows you to be very specific about your requirements.
Technically we wouldn't have to re-run these checks unless the user
changes the target bandwidth to something smaller than the default of
20 MHz.

  Luis
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

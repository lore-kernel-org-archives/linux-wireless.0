Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:59374 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755673Ab2K1WCO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Nov 2012 17:02:14 -0500
Received: by mail-ee0-f46.google.com with SMTP id e53so6042956eek.19
        for <linux-wireless@vger.kernel.org>; Wed, 28 Nov 2012 14:02:13 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <50B62317.1090001@think.ch>
References: <50B470CE.8070402@think.ch> <CAGRGNgVT-Yru2ti9CWgwS5H2cfW=RTeL144zsdAmSRCAsLwOsg@mail.gmail.com>
 <50B4B7B6.7020205@think.ch> <CAGRGNgXz9L+DBuxii7p+r0m2SEa0Xy1JgDZqGf2-8xWuHBYdfQ@mail.gmail.com>
 <50B5B915.2030706@think.ch> <CAGRGNgUzQk=m1vzp2+LbosDaddGnhwJC2P0cJHTW57EemNus+w@mail.gmail.com>
 <50B62317.1090001@think.ch>
From: Julian Calaby <julian.calaby@gmail.com>
Date: Thu, 29 Nov 2012 09:01:52 +1100
Message-ID: <CAGRGNgUZSmfJ91QtQOCmAn_3R8dsUerM6NwKPXwig_L1YsnZuw@mail.gmail.com> (sfid-20121128_230219_348835_D1B4E599)
Subject: Re: regulatory domain settings overwritten
To: Erich Titl <erich.titl@think.ch>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Erich,

The rule for dealing with invalid or default regulatory data in
Atheros cards is to use the US region.

This is specified in Atheros' documentation for the EEPROM format.

The code is working as designed, to the specification for the chipset
and as close as we can be certain to compliance with all applicable
laws.

The fact that your cards are using the defaults indicates that
somewhere between the factory and your hands someone isn't testing the
cards to verify them against a set of regulatory rules.

As far as I'm concerned, this matter is closed. The issue has been
explained to you repeatedly and in detail. Arguing with me won't
change the specification, won't change the code, and won't change the
fact that the device and driver are working exactly as they are
supposed to.

On Thu, Nov 29, 2012 at 1:43 AM, Erich Titl <erich.titl@think.ch> wrote:
> Hi Julian
>
> on 28.11.2012 09:18, Julian Calaby wrote:
>> Hi Erich,
>>
>> On Wed, Nov 28, 2012 at 6:11 PM, Erich Titl <erich.titl@think.ch> wrote:
>>> Hi Julian
>>>
> ...
>
>>
>> So it's unlikely to have been tested to comply with Swiss regulations,
>> therefore the EEPROM is set to use the defaults.
>
> It is pretty unlikely to have been tested against US regulations either.

Yes, which indicates to me that someone between the factory and you
hasn't been checking that the cards comply before selling them on.

>> It's no different. In this case, the card saying "I don't know what I
>> am" is specified to be equivalent to it saying "I'm a US card".
>
> You don't really want to say that anyone who does not know better is a
> US citizen ;-)

This has nothing to do with nationality.

>>>> The card is not "open", it's using the default configuration. The
>>>> default configuration is that it's configured for US operation.
>>>
>>> No, it is not, the card pretends nothing, the driver does.
>>
>> The card says to use the default, the default is US.
>
> And this IMHO is just plain wrong. US is not the navel of the world, if
> there is one at all.

Again, this has nothing to do with nationality. Would you complain as
much if the default was England? Spain? Afganistan?

>> We are required by law to do our best to ensure that the card complies
>> with whatever regulations are in force, wherever we are in the world.
>> The simplest way to do this is to ensure that we comply with every
>> piece of information we have. If the card says that we're in the US
>> and the user says we're in Switzerland, then we restrict it to the
>> minimum of both sets of regulatory rules so that we can be sure that
>> the card is, to the best of our knowledge, complying with the rules.
>
> I know now, by inspecting the code that this is exactly what happens. I
> agree with you that if the card says 'I am a US branded card' this is
> the right thing to do.
> I disagree though that for a card that says 'Never mind, just specify
> your location' US is the right choice.
>
> I believe instead of using
>
> reg->country_code = CTRY_UNITED_STATES;
>
> should be something like
>
> reg->country_code = CTRY_NEUTRAL;

The "neutral" regulatory rules are the "world" regulatory rules which
comply with every set of regulations out there. It is even more
restricted than the US regulatory rules.

>> On the other hand, some cheaper manufacturers use reference designs
>> and keep things default to cut costs. Therefore the manufacturer of
>> the chip specifies a default which is hard coded in the driver.
>
> Yes, but the hard coded regdomain US is doubtful.

It's specified by Atheros, the company that makes the chips, as the
domain to use when there is none set.

>>> It's also
>>>> possible that it can comply with the regulations perfectly, but has
>>>> never been tested and had the EEPROM set to indicate that it can
>>>> comply with them.
>>>
>>> Yes of course, it could be that way, but my past experience in IT leads
>>> me to believe that manufacturers shy away from market specific hardware
>>> design. This is why the CM9 does not specify a country code, but a
>>> 'default' setting.
>>
>> CM9 is getting rather old now and there are now facilities in the
>> kernel to detect which region we're in from the information the phone
>> would get from a cell phone tower, I don't know for sure, but I'd
>> expect that this will be used in the future to ensure that we comply
>> where possible.
>
> For phones that may be a good thing, though I would not want my phone
> somehow to sample my position without asking me. For things that don't
> depend on the public telephone system this method is unsafe at best.

Personally, if I were designing code that could interact with laws in
a way that could potentially get users of that code in legal trouble,
I'd take every precaution to ensure that this didn't happen. This code
is designed with that in mind.

>> The default is not imposed by some midwest driver author, the default
>> is imposed by the manufacturer of the chip as a default when the
>> regulatory information is incorrect or unavailable.
>
> Right, in EEPROM this is unavailable, but now the driver translates this
> to a hardly comprehensible region which apparently is somehow restricted.

Yes, by following the specification specified by the manufacturer of
the chipset.

>> And this will be trying to use the card against it's specifications
>> and will probably be rejected because of that.
>
> That my or may not be the case. Anyway, cfg80211 can set the card to the
> world domain and can also set it to country code CH. Unfortunately the
> driver is overlaying this.

As explained previously, you are saying that you're in Switzerland, we
have information that indicates that we may be in the USA so we use a
set of rules that comply with both.

> I tried several CTRY settings, as I don't want to mess up unnecessarily.
> CRTY_DEFAUT just makes it cough.
>
> What is a usable CTRY code to cover the broadest possible country range,
> which can then be controlled through the correct country code. I could
> use something like CTRY_AUSTRALIA but then that would be as bad as
> CRTY_UNITED_STATES as it is not a neutral setting.
>
> Is there a neutral CTRY value which does not mess up the worldwide settings?

You could use the world regulatory domain, but it's even more
restricted as it complies with _every_ set of rules.

Thanks,

-- 
Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
.Plan: http://sites.google.com/site/juliancalaby/

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:48230 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752797Ab2K1ISu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Nov 2012 03:18:50 -0500
Received: by mail-ee0-f46.google.com with SMTP id e53so5572164eek.19
        for <linux-wireless@vger.kernel.org>; Wed, 28 Nov 2012 00:18:49 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <50B5B915.2030706@think.ch>
References: <50B470CE.8070402@think.ch> <CAGRGNgVT-Yru2ti9CWgwS5H2cfW=RTeL144zsdAmSRCAsLwOsg@mail.gmail.com>
 <50B4B7B6.7020205@think.ch> <CAGRGNgXz9L+DBuxii7p+r0m2SEa0Xy1JgDZqGf2-8xWuHBYdfQ@mail.gmail.com>
 <50B5B915.2030706@think.ch>
From: Julian Calaby <julian.calaby@gmail.com>
Date: Wed, 28 Nov 2012 19:18:28 +1100
Message-ID: <CAGRGNgUzQk=m1vzp2+LbosDaddGnhwJC2P0cJHTW57EemNus+w@mail.gmail.com> (sfid-20121128_091855_678401_56763A85)
Subject: Re: regulatory domain settings overwritten
To: Erich Titl <erich.titl@think.ch>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Erich,

On Wed, Nov 28, 2012 at 6:11 PM, Erich Titl <erich.titl@think.ch> wrote:
> Hi Julian
>
> on 27.11.2012 23:55, Julian Calaby wrote:
>> Hi Erich,
>>
>> On Tue, Nov 27, 2012 at 11:53 PM, Erich Titl <erich.titl@think.ch> wrote:
>>> Hi Julian
>>>
> ...
>
>>
>> Sorry about that, the last time I explained this, it was for a Chinese
>> resident, and I got the codes mixed up.
>>
>> This "default" is part of the specification of how the hardware
>> operates. If it hasn't been configured otherwise, it defaults to US
>> operation. I'm sure that the Windows driver behaves in exactly the
>> same way - this isn't some feature of the Linux driver, it's how the
>> card is supposed to work.
>
> I understand that well, but how is the driver supposed to know what the
> default is?

Because the specification of the EEPROM format says that it's US.

> In my case I got a card imported by a local OEM which gets them from
> Taiwan directly.

So it's unlikely to have been tested to comply with Swiss regulations,
therefore the EEPROM is set to use the defaults.

>> Laws say otherwise. Each country has a different set of regulations
>> for how they expect a WiFi card to operate. To make a card that is
>> fully compliant with all these sets of regulations would require it to
>> be tested against in a way which can prove that it complies with all
>> those regulations. In general, as I understand it, cards are usually
>> built for a particular market, and tested that they comply with that
>> market's regulations, usually then ignoring any other country's
>> regulations. Cheaper manufacturers may just use a reference design,
>> which is probably built to comply with US regulations, and then just
>> use the defaults.
>
> Yes, but in my case the card says 'OK, use the default' and then the
> default happens to be hard coded as US in he driver. In my book this is
> different from a card saying, 'OH, I believe I am a US card, so please
> behave US conformant'.

It's no different. In this case, the card saying "I don't know what I
am" is specified to be equivalent to it saying "I'm a US card".

>> The card is not "open", it's using the default configuration. The
>> default configuration is that it's configured for US operation.
>
> No, it is not, the card pretends nothing, the driver does.

The card says to use the default, the default is US.

>>> I could (and will probably have to) recompile the driver using another
>>> regdomain file, but this is not really satisfactory either. IMHO the
>>> regdomain should be chosen as seen fit and not imposed by hard coded
>>> limits in the driver.
>>
>> You could recompile the driver to use the Swiss country code as the
>> default, however then you'd be using the card in a way which is
>> outside of it's specification.
>>
>> It is possible that your particular card cannot work predictably
>> enough on channels 12 and 13 to comply with the Swiss regulations
>> which is why it's been left at the default configuration.
>
> The driver itself cannot be made responsible for the malfunction of the
> card. If the card was restricted in any way, the manufacturer can and
> IMHO _must_ use the EEPROM value to restrict it's use. This was _not_
> done here, as the manufacturer cannot know what the driver author thinks
> is the default.

We are required by law to do our best to ensure that the card complies
with whatever regulations are in force, wherever we are in the world.
The simplest way to do this is to ensure that we comply with every
piece of information we have. If the card says that we're in the US
and the user says we're in Switzerland, then we restrict it to the
minimum of both sets of regulatory rules so that we can be sure that
the card is, to the best of our knowledge, complying with the rules.

On the other hand, some cheaper manufacturers use reference designs
and keep things default to cut costs. Therefore the manufacturer of
the chip specifies a default which is hard coded in the driver.

> It's also
>> possible that it can comply with the regulations perfectly, but has
>> never been tested and had the EEPROM set to indicate that it can
>> comply with them.
>
> Yes of course, it could be that way, but my past experience in IT leads
> me to believe that manufacturers shy away from market specific hardware
> design. This is why the CM9 does not specify a country code, but a
> 'default' setting.

CM9 is getting rather old now and there are now facilities in the
kernel to detect which region we're in from the information the phone
would get from a cell phone tower, I don't know for sure, but I'd
expect that this will be used in the future to ensure that we comply
where possible.

Also, CM9 is a custom ROM and may simply not have bothered where
manufacturer ROMs might have.

>> The simple fact of the matter is that the card is set to use the
>> default configuration. The default configuration is for US operation,
>> simple as that. This isn't short sighted Linux developers assuming
>> that everyone is in the US, this is a design decision by the company
>> that produced the card to give it a sensible default it can comply
>> with.
>
> Oh, I don't pretend the developers are short sighted, just that the
> person writing the code sat possibly somewhere in the US midwest and his
> perception of the world might be restricted to the county border, been
> there, seen it. The driver IMHO should be written in a way that it can
> meet the local regulatory law, and the default should not be US imposed
> by the driver.

The default is not imposed by some midwest driver author, the default
is imposed by the manufacturer of the chip as a default when the
regulatory information is incorrect or unavailable.

> Nevertheless, I have patched the driver to do exactly that, if there is
> no regdom specified in the EEPROM then use the one specified in the
> cfg80211 options. The behaviour of the driver can be controlled right
> now by a compile time flag, I might even turn that into a flag passed as
> an option at load time.

And this will be trying to use the card against it's specifications
and will probably be rejected because of that.

Thanks,

-- 
Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
.Plan: http://sites.google.com/site/juliancalaby/

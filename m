Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:61126 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755400Ab2K0Wz1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Nov 2012 17:55:27 -0500
Received: by mail-ee0-f46.google.com with SMTP id e53so5431085eek.19
        for <linux-wireless@vger.kernel.org>; Tue, 27 Nov 2012 14:55:25 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <50B4B7B6.7020205@think.ch>
References: <50B470CE.8070402@think.ch> <CAGRGNgVT-Yru2ti9CWgwS5H2cfW=RTeL144zsdAmSRCAsLwOsg@mail.gmail.com>
 <50B4B7B6.7020205@think.ch>
From: Julian Calaby <julian.calaby@gmail.com>
Date: Wed, 28 Nov 2012 09:55:05 +1100
Message-ID: <CAGRGNgXz9L+DBuxii7p+r0m2SEa0Xy1JgDZqGf2-8xWuHBYdfQ@mail.gmail.com> (sfid-20121127_235530_964114_8DA20A27)
Subject: Re: regulatory domain settings overwritten
To: Erich Titl <erich.titl@think.ch>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Erich,

On Tue, Nov 27, 2012 at 11:53 PM, Erich Titl <erich.titl@think.ch> wrote:
> Hi Julian
>
> Thank you for the quick reply and the link
>
> on 27.11.2012 10:55, Julian Calaby wrote:
>> Hi Erich,
>>
> ...
>
>
>>
>> It's not being completely overridden and it is working as designed.
>>
>> Firstly, the default country code for all Atheros chips is the USA.
>> This is most likely because that's where the company is based.
>>
>> Secondly, your choice, China, is not being overridden. As the card is
>> saying that it's configured for the USA, and you're saying that it's
>> in China, the regulatory framework is using the intersection of the US
>> and Chinese rules to govern it's output, thereby ensuring that the
>> operation of the card complies with all the information it has about
>> it's location.
>>
>> This has been explained in more detail in this thread:
>>
>> http://www.spinics.net/lists/linux-wireless/msg92420.html
>>
>> If you want to have the complete set of frequencies as specified by
>> the Chinese rules, you will need to obtain a card which has been
>> configured for Chinese operation.
>
> Actually the country code CH should stand for Switzerland and I am
> surprised a default for the US should be hard coded into the driver

Sorry about that, the last time I explained this, it was for a Chinese
resident, and I got the codes mixed up.

This "default" is part of the specification of how the hardware
operates. If it hasn't been configured otherwise, it defaults to US
operation. I'm sure that the Windows driver behaves in exactly the
same way - this isn't some feature of the Linux driver, it's how the
card is supposed to work.

> Anyway, I am located in Switzerland and I saw similar threads from a few
> people on the net. Today's mobile society demands that equipment can be
> reconfigured freely to accommodate the local regulatory limits. This can
> be achieved at will with an open card, which just gets crippled by the
> hard coded limits set here.

Laws say otherwise. Each country has a different set of regulations
for how they expect a WiFi card to operate. To make a card that is
fully compliant with all these sets of regulations would require it to
be tested against in a way which can prove that it complies with all
those regulations. In general, as I understand it, cards are usually
built for a particular market, and tested that they comply with that
market's regulations, usually then ignoring any other country's
regulations. Cheaper manufacturers may just use a reference design,
which is probably built to comply with US regulations, and then just
use the defaults.

The card is not "open", it's using the default configuration. The
default configuration is that it's configured for US operation.

> So under the worst thinkable circumstances this code won't work for my
> environment as, for example, the intersection of the world regdomain and
> the US regdomain would AFAIK cut away channels 12 and 13, which are
> perfectly legal at my domicile and are used by some AP's.

If you're using access points on channels 12 and 13, then yeah, using
a card that is configured for US operation won't work for you.

> I could (and will probably have to) recompile the driver using another
> regdomain file, but this is not really satisfactory either. IMHO the
> regdomain should be chosen as seen fit and not imposed by hard coded
> limits in the driver.

You could recompile the driver to use the Swiss country code as the
default, however then you'd be using the card in a way which is
outside of it's specification.

It is possible that your particular card cannot work predictably
enough on channels 12 and 13 to comply with the Swiss regulations
which is why it's been left at the default configuration. It's also
possible that it can comply with the regulations perfectly, but has
never been tested and had the EEPROM set to indicate that it can
comply with them.

The simple fact of the matter is that the card is set to use the
default configuration. The default configuration is for US operation,
simple as that. This isn't short sighted Linux developers assuming
that everyone is in the US, this is a design decision by the company
that produced the card to give it a sensible default it can comply
with.

Thanks,

-- 
Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
.Plan: http://sites.google.com/site/juliancalaby/

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from khc.piap.pl ([195.187.100.11]:39677 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752034Ab0C2UsU (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Mar 2010 16:48:20 -0400
From: Krzysztof Halasa <khc@pm.waw.pl>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: CRDA and ath5k with no country code in EEPROM
References: <m3tys0tbhk.fsf@intrepid.localdomain>
	<43e72e891003281645m1da47a1en882df4432733977d@mail.gmail.com>
	<m3eij3ym5k.fsf@intrepid.localdomain>
	<43e72e891003291222n5e72a0a5m31dddf2bbf6e06ab@mail.gmail.com>
	<m339zizz4o.fsf@intrepid.localdomain>
	<43e72e891003291256t7f53dcfck5f8c8cf94128eeb3@mail.gmail.com>
Date: Mon, 29 Mar 2010 22:48:18 +0200
In-Reply-To: <43e72e891003291256t7f53dcfck5f8c8cf94128eeb3@mail.gmail.com>
	(Luis R. Rodriguez's message of "Mon, 29 Mar 2010 12:56:50 -0700")
Message-ID: <m3y6hayhv1.fsf@intrepid.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

"Luis R. Rodriguez" <mcgrof@gmail.com> writes:

>> But... isn't the modifying of the regulatory.bin (the US part of it)
>> to include channels valid in e.g. Europe breaking the (US) rules?
>
> Not if you sign off on it, which is exactly why the whole singing
> thing was invented. You would do this if say, you sell an AP and you
> verify and tested regulatory compliance against a different regulatory
> region.

So what exactly do I change? Can the regulatory.bin change the default
country?

Remember I need to be compliant to the US freq sets as well - when the
regdomain is set to US. IOW I can't allow the user operating the device
to set e.g. channel 12 when the user selects country=US (so there is a
big difference between country 0=US and the real country=US).

> country code programmed to 0 is defined by Atheros documentation to be
> in the "US".

But the driver says:
ath: EEPROM regdomain: 0x0
ath: EEPROM indicates default country code should be used
ath: doing EEPROM country->regdmn map search
ath: country maps to regdmn code: 0x3a
ath: Country alpha2 being used: US
ath: Regpair used: 0x3a

At least for the driver 0 doesn't mean US, it means "default country".
Perhaps the meaning of "default country" depends on maybe location of
the hw and/or sw manufacturer?
Then maybe what I really need to do is substituting "EU" as the default
country and enforcing EU restrictions, even when the country selected by
the user is outside EU (e.g. enforcing EU+US in US)?
And when the user gets a card with country=US (not 0), the EU
restictions would be dropped (when physically in USA)?

I think this all reduces to the meaning of country=0 for cards sold (in
this case) in Europe (and maybe manufactured here).


If the driver said "EEPROM regdomain: 0x0 = US" I'd return the cards to
the manufacturer, simple (realistically they'd fix the EEPROM instead).
-- 
Krzysztof Halasa

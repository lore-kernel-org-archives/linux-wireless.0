Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from khc.piap.pl ([195.187.100.11]:48596 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756551Ab0CaA0T (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 30 Mar 2010 20:26:19 -0400
From: Krzysztof Halasa <khc@pm.waw.pl>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: Christian Lamparter <chunkeey@googlemail.com>,
	linux-wireless@vger.kernel.org
Subject: Re: CRDA and ath5k with no country code in EEPROM
References: <m3tys0tbhk.fsf@intrepid.localdomain>
	<43e72e891003300928qdd70de4vc7585d7e19d36dca@mail.gmail.com>
	<m3wrwtoekv.fsf@intrepid.localdomain>
	<201003302049.24231.chunkeey@googlemail.com>
	<m3mxxpo8h6.fsf@intrepid.localdomain>
	<n2r43e72e891003301507wb3359afcvd2e3656bc70e431c@mail.gmail.com>
Date: Wed, 31 Mar 2010 02:26:15 +0200
In-Reply-To: <n2r43e72e891003301507wb3359afcvd2e3656bc70e431c@mail.gmail.com>
	(Luis R. Rodriguez's message of "Tue, 30 Mar 2010 15:07:14 -0700")
Message-ID: <m3634dnxp4.fsf@intrepid.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

"Luis R. Rodriguez" <lrodriguez@atheros.com> writes:

>> Then again: does the regdomain = 0 means "US" or "default country" (or
>> something completely different), according to Atheros' docs?
>
> As per Atheros documentation 0x0 means "US". I've already provided
> links for you. I'm sending this from an Atheros e-mail address, not
> sure if this helps get this through to you or not.

Why are you writing like this? Christian noted there is a difference
between regdomain and country, and you (sort of) confirmed it. This
doesn't seem to be that black and white as you say it is, and it has
nothing to do with you working for Atheros.

BTW is this documentation publicly available? Or perhaps the fragment
listing the possible regdomains? Are the docs limited to specific chips
only? Did the previous versions of the docs, if any, differ in this
matter?

Obviously I'm not saying the following has any authority, and I assume
it may have changed:

http://madwifi-project.org/wiki/UserDocs/CountryCode

This is a preliminary list of regdomains for people who want to play
with changing their regdomain using the ar5k utility

 0x00 (wildcarded)
 0x10 (FCC)
 0x20 (DOC)
 0x30 (ETSI)
 0x31 (Spain)
 0x32 (France)
 0x37 (South Africa)
 0x40 (MKK-Japan)
 0xFF (debug)
 Most "universal/worldwide" cards use zero as the value, some 0xFF

I don't know what the binary HAL did, but this regdomain thing is at
least confusing, not only for me, but apparently also for card
manufacturers with access to the current (and maybe previous) Atheros
docs (and no, this isn't only about Mikrotik).

Unfortunately this confusion makes it easy for the following to not
happen (though probably only outside USA):

    * Average users should not accidentally fail to comply with
      regulations if at all possible;
    * The Linux kernel should offer necessary and reasonable regulatory
      enforcement mechanisms in order to facilitate implementation of a
      broad variety of regulatory policies;
    * Options to disable or circumvent regulatory enforcement should not
      be included in kernels from any public source; and,
    * It is unacceptable for either distributions or community
      developers to knowingly violate the principles stated above.

You also wrote:

> My point was that this is not something meant to be interpreted by
> anyone for what "default country" means, the documentation I pointed
> out clearly states that 0x0 is designed to mean to match the "US" by
> Atheros hardware as per hardware documentation provided to ODMs.

Is the documentation you pointed out more verbose than the following?
http://wireless.kernel.org/en/users/Drivers/ath/#The_0x0_regulatory_domain

> So be aware, 0x0 will always map to the US. If the manufacturer did
> not intend to do that they can provide their own regulatory.bin to
> customers where they can map "US" to their own defined regulatory
> domain.

Could you please show some short example how to do that, according to
the four rules?

Do you mean changing the mapping regdomain 0 -> "US" to another country,
or simply overriding the following:

country US:
        (2402 - 2472 @ 40), (3, 27)
        (5170 - 5250 @ 40), (3, 17)
        (5250 - 5330 @ 40), (3, 20), DFS
        (5490 - 5600 @ 40), (3, 20), DFS
        (5650 - 5710 @ 40), (3, 20), DFS
        (5735 - 5835 @ 40), (3, 30)

(IOW, including frequencies which are not legal in US under the "country
US", thus violating the 4 and other rules)?

Still confused,
-- 
Krzysztof Halasa

(and yes, changing anything in the EEPROM is trivial for me - am I wrong
that I wish this cleared without doing this?).

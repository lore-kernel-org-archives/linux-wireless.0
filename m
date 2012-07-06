Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from narfation.org ([79.140.41.39]:60449 "EHLO v3-1039.vlinux.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750906Ab2GFPNp (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Jul 2012 11:13:45 -0400
From: Sven Eckelmann <sven@narfation.org>
To: Mohammed Shafi <shafi.wireless@gmail.com>
Cc: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>,
	ath9k-devel@lists.ath9k.org,
	Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>,
	Adrian Chadd <adrian@freebsd.org>,
	Marek Lindner <lindner_marek@yahoo.de>,
	linux-wireless@vger.kernel.org, Gabor Juhos <juhosg@openwrt.org>
Subject: Re: ath9k: Problems with diversity on AR9330
Date: Fri, 06 Jul 2012 17:13:42 +0200
Message-ID: <5244861.J1Tyef1FCX@bentobox> (sfid-20120706_171349_787066_EDE2596E)
In-Reply-To: <CAD2nsn1=PDBTRXumDh93DzvmFcBnyFeLD-5c5oSJmv3OO6LWGw@mail.gmail.com>
References: <20120706125043.GA23189@pandem0nium> <CAD2nsn1=PDBTRXumDh93DzvmFcBnyFeLD-5c5oSJmv3OO6LWGw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart1977207.R232PZQPUF"; micalg="pgp-sha512"; protocol="application/pgp-signature"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--nextPart1977207.R232PZQPUF
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"

On Friday 06 July 2012 19:32:41 Mohammed Shafi wrote:
> Hi Simon,
> 
> On Fri, Jul 6, 2012 at 6:20 PM, Simon Wunderlich
> 
> <simon.wunderlich@s2003.tu-chemnitz.de> wrote:
> > Hey,
> > 
> > we have trouble with an AR9330 (Hornet) based AP. This device has 2
> > antennas, and is supposed to support diversity (2 RX, 1 TX). However,
> > diversity is not really enabled because the "alternative" antenna is not
> > considered as "good", because not enough frames are received. It seems
> > that at 99% of the time, alt_rssi (read from rs->rs_rssi_ctl1) is invalid
> > (set to ATH9K_RSSI_BAD, -128), while main_rssi (read from
> > rs->rs_rssi_ctl0) usually has sane values.
> its been some good amount of time i had taken/tested take a look at
> this. actually Gabor Juhos added the support for AR9330.
> seems AR9003 family chipsets can exhibit this behaviour. i quickly
> checked with AR9285(AR9002) which seems to have a positive RSSI
> regulary in ctl0/ctl1.
> i also have a AR9485(AR9003 family) which might be similar to AR9330.
> just checked with removing the antenna in chain0 seems to bring
> positive values in rssi_ctl1.
> I just also observer the chain0 is "preferred" unless the RSSI is so
> poor in it so chain1 is taken.
> Please check if this work out for your case too.

Removing the antenna on chain0 doesn't change the alt_rssi value for us. We 
only noticed that frames with alt_rssi != -128 have  the value rx_ant_conf == 
1 (LNA2) when only chain1 is attached and rx_ant_conf == 2 (LNA1) when 
both/chain0-only are attached. Still most of the packets had alt_rssi == -128 
and we saw changes in curr_main_set and curr_alt_set (after lot of data was 
sent).

> also please see the throughput difference with/without antenna
> diversity with one antenna broken.

We (Simon and me) tried to play with the antennas and came to following 
results:

* Both attached: 45 Mibit/s
* chain0 attached: 45 Mibit/s
* chain1 attached: 15 seconds nearly nothing, after that 25 Mibit/s

> I will check out the proper technical reason for such a
> preference/compare with AR9285 (or) if its a bug in the code itself.
> thanks for looking into this feature!

Thanks

Kind regards,
	Sven
--nextPart1977207.R232PZQPUF
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABCgAGBQJP9wCmAAoJEF2HCgfBJntGTwEQAJc4/wxwNRew4cmBHCBFZfqB
mpjB9rMwiOmRoalGJZ36PsUMMmgvGWZst9lOMsA135zc7BgufFqdZ2GT59gzFQNx
8DQ/qIX9pihfDAqfmafCxU7g3OO0GlCqi76KC6QGozpqBa7Yf4b8QXE2jBpLyrJS
pz+dUCFHEXoHL/0GgE0s9OHGlzpsZTjLbCLCgwxxInNOdcg13G3iMDJ0w3xOPc/Y
jwRxjt6/jEBFiP/1/fC+bNnqi4PUUT6wZYhXAGJ7JxmcsDZDBwwiyfwruJfFnAH4
OjoCktZKjXcvOq4Wvi6qb9q7VrHrWd6esG9Cp4wu8q9oyduX54MWWFi/mCVzFV5U
Y+MBB3FbuIVFhIDOVEDQJvtVLEcDL4VCEm7MNegI/MHEKAXxi3MZyDI3jNL5VWMU
a0xVMdBIhyPUoDZE4ux3+PUg1O7QYcJjuixzNxcAT2o5M7km4XIL6cOGQDijblMv
1lCO2ooY2e3k4A6OzYtAptBqPmF8zCUFcaDcCNM9in1FPdlM3TQ39V6dEHrfwsAj
qC4z8etfWR+M06c7UWgT9l7w2L+t0R2Ku8HK5XZlYz52r2HlY7t0g1o2XvU7fNbe
u3ekJGWtLiIHIo/NPqN7CkT7vXs6VTFxPAwDBsEh2apvjj8mvKB+a5zWS6JzLkc9
hpWXN08/jwxNUs5ixcQf
=pHmo
-----END PGP SIGNATURE-----

--nextPart1977207.R232PZQPUF--


Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from yw-out-2324.google.com ([74.125.46.30]:51708 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753178AbZDHRnc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Apr 2009 13:43:32 -0400
Received: by yw-out-2324.google.com with SMTP id 5so232231ywb.1
        for <linux-wireless@vger.kernel.org>; Wed, 08 Apr 2009 10:43:31 -0700 (PDT)
Message-ID: <49DCE23B.7010400@gmail.com> (sfid-20090408_194337_156312_7FC0DDE5)
Date: Wed, 08 Apr 2009 13:43:23 -0400
From: Will Keaney <keaneyw@gmail.com>
MIME-Version: 1.0
To: Bob Copeland <me@bobcopeland.com>
CC: Linux Wireless <linux-wireless@vger.kernel.org>
Subject: Re: [Fwd: Re: Trouble Associating with ath5k on AR5212]
References: <49DCA8E3.3060603@gmail.com>	 <b6c5339f0904080758k2be9ae3dm1a98b564f3b10867@mail.gmail.com>	 <49DCC641.4010405@gmail.com> <b6c5339f0904080920q47a33315j127a0aa2eca84444@mail.gmail.com> <49DCD05B.9050802@gmail.com>
In-Reply-To: <49DCD05B.9050802@gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigB533083BD219DD48C955BED2"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigB533083BD219DD48C955BED2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Will Keaney wrote:
> Bob Copeland wrote:
>  =20
>>> I also have to manually set the reg domain to US every time I load th=
e
>>> ath5k module. =EF=BF=BDI tried configuring wpa_supplicant.conf to do =
this
>>> itself, but that doesn't seem to work. =EF=BF=BDIt would be nice to h=
ave a
>>> module parameter for setting this at load time.
>>>    =20
>>>      =20
>> I may be wrong but I think that only works in wpa_supplicant if you
>> use -Dnl80211 (instead of -Dwext).
>>
>> FWIW in the default world roaming domain you can still connect to most=

>> APs.  Besides iw/wpa_supplicant, pending patches to ath5k will set the=

>> default regdomain automatically based on the value stored in the eepro=
m.
>>  =20
>>    =20
> Ahh, interesting.  I didn't see nl80211 documented in the wpa_supplican=
t
> example configs or man page. I'll give that a shot.
> I seem to get much better scanning results with the region set properly=
,
> than on the world roaming domain.
>  =20
I don't know if it's relevant or not, but when using -Dnl80211 I see a
bit of odd behavior:
- wpa_supplicant is able to set the region automatically. Yay!
- scanning produces quite an extensive list of APs, but most of them
don't have SSIDs listed.  This isn't in itself too strange, since I know
that there are 2 networks nearby each with several repeaters that do not
broadcast SSID.  However, one of them (chmc_guest) is identified in the
scanning output when using -Dwext.
- All of the networks show a signal strength of 0.  -Dwext shows varying
signal strengths for each network.  Considering that I am unable to
associate with any of them, I have to wonder which driver is producing
spurious output.

I would also like to note that the maximum Tx Power of the card is
significantly different between madwifi and ath5k.  In madwifi, it maxes
at 17dBm; in ath5k, it maxes at 27dBm.  I don't know if it actually is
using these values, or if one or both drivers are reporting Tx power
incorrectly.

Will


--------------enigB533083BD219DD48C955BED2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.11 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iEYEARECAAYFAknc4j8ACgkQjfayWCA8dDG4jgCdFQjKv/20OAK/U4paSygdgU7U
BAoAnRF6tAXEBGifUeyslXqkcOA+E+oY
=irKZ
-----END PGP SIGNATURE-----

--------------enigB533083BD219DD48C955BED2--

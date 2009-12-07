Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.klingt.org ([86.59.21.178]:34247 "EHLO klingt.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934873AbZLGJc2 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 Dec 2009 04:32:28 -0500
Message-ID: <4B1CCB81.5060104@klingt.org>
Date: Mon, 07 Dec 2009 10:31:45 +0100
From: Tim Blechmann <tim@klingt.org>
MIME-Version: 1.0
To: Gertjan van Wingerde <gwingerde@gmail.com>
CC: Andi Kleen <andi@firstfloor.org>, rjw@sisk.pl, IvDoorn@gmail.com,
	linville@tuxdriver.com, linux-wireless@vger.kernel.org
Subject: Re: regression: rt2561 frequent "Arrived at non-free entry" errors
 in	2.6.32
References: <20091204233202.GA13658@basil.fritz.box> <4B1BB44E.90706@gmail.com>
In-Reply-To: <4B1BB44E.90706@gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigE4600044CA413AFFC818098B"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigE4600044CA413AFFC818098B
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On 12/06/2009 02:40 PM, Gertjan van Wingerde wrote:
> On 12/05/09 00:32, Andi Kleen wrote:
>> [Rafael, something for your regression list]
>>
>> I upgraded a system which was running 2.6.30 to 2.6.32.
>> It has a=20
>>
>> 06:02.0 Network controller: RaLink RT2561/RT61 802.11g PCI
>>
>> wireless PCI card. Now regularly even under moderate traffic
>> I see messages like
>>
>> phy0 -> rt2x00queue_write_tx_frame: Error - Arrived at non-free entry =
in the non-full queue 2.
>> Please file bug report to http://rt2x00.serialmonkey.com.
>>
>> and loss of connectivity, often until the wireless connection
>> is restarted. This wasn't the case in 2.6.30, there the driver
>> ran stable without any problems. The problem currently
>> happens every few minutes.
>>
>=20
> Andi, Tim,
>=20
> Both of you have reported this problem on 2.6.32.
>=20
> In the past this always has occurred due to queue locking problems. Thi=
s led me
> to audit the queue locking code, and that certainly looked suspicious t=
o me.
>=20
> Would you be able to test whether the attached test patch fixes the pro=
blem for
> you. The patch basically applies proper queue locking to the code, alth=
ough in=20
> a very course manner. The patch is relative to 2.6.32.
>=20
> Note: I am not 100% sure that this is where the problem is, but at leas=
t the test
> patch should confirm whether I am searching in the right direction.

the patch didn't cleanly apply to v2.6.32 and the patched kernel didn't
boot ... which tree should it be applied on?

tim

--=20
tim@klingt.org
http://tim.klingt.org

Im =C3=BCbrigen ist es gescheiter, sich warm zuzudecken als sich zu
betrinken.
  Werner Schwab


--------------enigE4600044CA413AFFC818098B
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkscy4UACgkQdL+4qsZfVsta/QCeOOTc/lP7Rz0AIywd0BfQLoey
fsAAnAvv1KMkd05OnVbQSKJ1OQY4HToN
=TtYp
-----END PGP SIGNATURE-----

--------------enigE4600044CA413AFFC818098B--

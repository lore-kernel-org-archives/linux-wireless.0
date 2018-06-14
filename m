Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([217.72.192.74]:38135 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754784AbeFNTTZ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 14 Jun 2018 15:19:25 -0400
Subject: Re: b43 crashes on rmmod (bcm4331)
To: =?UTF-8?Q?Michael_B=c3=bcsch?= <m@bues.ch>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
        b43-dev@lists.infradead.org, Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        linux-crypto@vger.kernel.org
References: <75e4b424-4c75-5abd-1ef0-c2537d329b10@lukas-wirz.de>
 <d9896c10-87bb-8362-f302-8b1888c3421c@lukas-wirz.de>
 <20180609171159.59b5209c@wiggum>
 <6a78c68e-1062-5ad8-876c-f7d4c49ea492@lukas-wirz.de>
 <20180609220130.3ceb834f@wiggum>
 <e72be8db-77ba-408c-c5e5-351d722e09e8@lukas-wirz.de>
 <20180611224634.28ccd288@wiggum>
 <7d564b8b-2b71-73f6-3ae7-ede0187a4151@lukas-wirz.de>
 <20180613122751.2fe89737@wiggum>
 <538cd7b7-8d63-1795-7bfc-69231d2bf3c0@lukas-wirz.de>
 <20180613130905.420695e7@wiggum> <20180613140148.1b57a566@wiggum>
 <6b84a788-e11f-91db-309c-4ff79fdcad66@lukas-wirz.de>
 <20180613152812.5596b460@wiggum>
 <6bef30e0-9405-2ddd-d1eb-612b4d4e3382@lukas-wirz.de>
 <20180614182636.1b92d7df@wiggum>
From: Wirz <spam@lukas-wirz.de>
Message-ID: <c0f833ab-d727-6d56-c252-58a209e1c459@lukas-wirz.de> (sfid-20180614_211931_439508_B2DA7C6F)
Date: Thu, 14 Jun 2018 22:18:52 +0300
MIME-Version: 1.0
In-Reply-To: <20180614182636.1b92d7df@wiggum>
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="oFafDZpxYbiMwKH6asEt3J9VeWxSNUk9g"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--oFafDZpxYbiMwKH6asEt3J9VeWxSNUk9g
Content-Type: multipart/mixed; boundary="601FGFCQ9tt6OIg7TAJHXoK0ArE1U8fCC";
 protected-headers="v1"
From: Wirz <spam@lukas-wirz.de>
To: =?UTF-8?Q?Michael_B=c3=bcsch?= <m@bues.ch>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
 b43-dev@lists.infradead.org, Matt Mackall <mpm@selenic.com>,
 Herbert Xu <herbert@gondor.apana.org.au>, linux-crypto@vger.kernel.org
Message-ID: <c0f833ab-d727-6d56-c252-58a209e1c459@lukas-wirz.de>
Subject: Re: b43 crashes on rmmod (bcm4331)
References: <75e4b424-4c75-5abd-1ef0-c2537d329b10@lukas-wirz.de>
 <d9896c10-87bb-8362-f302-8b1888c3421c@lukas-wirz.de>
 <20180609171159.59b5209c@wiggum>
 <6a78c68e-1062-5ad8-876c-f7d4c49ea492@lukas-wirz.de>
 <20180609220130.3ceb834f@wiggum>
 <e72be8db-77ba-408c-c5e5-351d722e09e8@lukas-wirz.de>
 <20180611224634.28ccd288@wiggum>
 <7d564b8b-2b71-73f6-3ae7-ede0187a4151@lukas-wirz.de>
 <20180613122751.2fe89737@wiggum>
 <538cd7b7-8d63-1795-7bfc-69231d2bf3c0@lukas-wirz.de>
 <20180613130905.420695e7@wiggum> <20180613140148.1b57a566@wiggum>
 <6b84a788-e11f-91db-309c-4ff79fdcad66@lukas-wirz.de>
 <20180613152812.5596b460@wiggum>
 <6bef30e0-9405-2ddd-d1eb-612b4d4e3382@lukas-wirz.de>
 <20180614182636.1b92d7df@wiggum>
In-Reply-To: <20180614182636.1b92d7df@wiggum>

--601FGFCQ9tt6OIg7TAJHXoK0ArE1U8fCC
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: quoted-printable

On 14/06/18 19:26, Michael B=C3=BCsch wrote:
> On Thu, 14 Jun 2018 12:47:19 +0300
> Wirz <spam@lukas-wirz.de> wrote:
>=20
>>>>>> You can edit drivers/net/wireless/broadcom/b43/Kconfig
>>>>>> go to the section config B43_HWRNG
>>>>>> and change 'default y' to 'default n'
>>>>>>
>>>>>> That should disable it.   =20
>>>>>
>>>>>
>>>>>
>>>>> Could you please also try the attached patch?
>>>>> There seems to be a problem in hwrng core in that it does not disab=
le
>>>>> the current RNG, if the new RNG fails to initialize.
>>>>> I don't know if that's the problem here, though.   =20
>>>>
>>>> Ok. Do I apply your patch to the first version that fails for me, an=
d
>>>> revert my change to Kconfig? =20
>>>
>>>
>>> Yes, please test the patch with a version that would otherwise fail.
>>> You can use 4.16 or the latest kernel for that. I created it with lat=
est
>>> linus' version. =20
>>
>> I tested both suggested cases.  When I disable B43_HWRNG by editing
>> Kconfig, 'rmmod b43' succeeds in the first version where it previously=

>> failed.  When I apply your patch on top of an unmodified 4.16 it also
>> succeeds.
>=20
>=20
> Thank you _very_ much for testing.
>=20
> I will submit this patch to the hw_random maintainers.

Great, thank you!  I look forward to using a current kernel again.

cheers, lukas


--=20
Do not believe the naysayers who say it cannot be done.


--601FGFCQ9tt6OIg7TAJHXoK0ArE1U8fCC--

--oFafDZpxYbiMwKH6asEt3J9VeWxSNUk9g
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EARECAB0WIQQfsLWbEt//FEFwBMDWbaSYbwIjLQUCWyK/ogAKCRDWbaSYbwIj
LZ0VAJ9RFjKriOp++NU0rgLzJ0ZW03ZSHwCeP/uiUUWaOXX1WhjotWXsmOMMmDw=
=hrLf
-----END PGP SIGNATURE-----

--oFafDZpxYbiMwKH6asEt3J9VeWxSNUk9g--

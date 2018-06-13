Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([217.72.192.73]:46009 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934968AbeFMLCM (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 13 Jun 2018 07:02:12 -0400
Subject: Re: b43 crashes on rmmod (bcm4331)
To: =?UTF-8?Q?Michael_B=c3=bcsch?= <m@bues.ch>
Cc: b43-dev@lists.infradead.org,
        linux-wireless <linux-wireless@vger.kernel.org>
References: <75e4b424-4c75-5abd-1ef0-c2537d329b10@lukas-wirz.de>
 <d9896c10-87bb-8362-f302-8b1888c3421c@lukas-wirz.de>
 <20180609171159.59b5209c@wiggum>
 <6a78c68e-1062-5ad8-876c-f7d4c49ea492@lukas-wirz.de>
 <20180609220130.3ceb834f@wiggum>
 <e72be8db-77ba-408c-c5e5-351d722e09e8@lukas-wirz.de>
 <20180611224634.28ccd288@wiggum>
 <7d564b8b-2b71-73f6-3ae7-ede0187a4151@lukas-wirz.de>
 <20180613122751.2fe89737@wiggum>
From: Wirz <spam@lukas-wirz.de>
Message-ID: <538cd7b7-8d63-1795-7bfc-69231d2bf3c0@lukas-wirz.de> (sfid-20180613_130232_365211_C9BC5C7D)
Date: Wed, 13 Jun 2018 14:01:53 +0300
MIME-Version: 1.0
In-Reply-To: <20180613122751.2fe89737@wiggum>
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="ODNKjG8uHLjsTEpTPbgGwAILERfqJei3X"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--ODNKjG8uHLjsTEpTPbgGwAILERfqJei3X
Content-Type: multipart/mixed; boundary="j1S88DBBLIG2MH7JzLZLU5MLWHlxXYYv3";
 protected-headers="v1"
From: Wirz <spam@lukas-wirz.de>
To: =?UTF-8?Q?Michael_B=c3=bcsch?= <m@bues.ch>
Cc: b43-dev@lists.infradead.org,
 linux-wireless <linux-wireless@vger.kernel.org>
Message-ID: <538cd7b7-8d63-1795-7bfc-69231d2bf3c0@lukas-wirz.de>
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
In-Reply-To: <20180613122751.2fe89737@wiggum>

--j1S88DBBLIG2MH7JzLZLU5MLWHlxXYYv3
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: quoted-printable

On 13/06/18 13:27, Michael B=C3=BCsch wrote:
> On Wed, 13 Jun 2018 12:25:16 +0300
> Wirz <spam@lukas-wirz.de> wrote:
>=20
>>> This commit introduces a bug, if b43 is the only RNG in the system. B=
ut
>>> that is unlikely on modern systems and it's fixed by
>>> 0e4b52942b1c76f89e0dcb829f72e123d0678f54, which is in 4.16.
>>>
>>> Other than that I currently can't see why this crashes.
>>>
>>> But the crash should go away, if you disable CONFIG_B43_HWRNG.
>>> That's not a solution, but it may help, if you would like to get rid =
of
>>> the crashes.
>>> Could you please verify whether disabling CONFIG_B43_HWRNG avoids the=

>>> crash, just to make sure we are not after a red herring here? =20
>>
>> It seems the bug I'm seeing is separate from the one you are describin=
g.
>>  The 4.16 kernels that ship with debian testing crash for me as well. =
 I
>> tested the 142a27f0a version with CONFIG_B43_HWRNG switched off
>> (manually in the .config): it still crashes is the same way.  I also
>> just verified that the version one before that really is good.
>=20
>=20
> CONFIG_B43_HWRNG completely switches off hwrng support in b43.
> I don't see how a change in hwrng core could still lead to a crash in
> b43 with this option switched off.
>=20
> What do you mean by "manually in the .config"?

What I meant is, that I have outcommented the line 'CONFIG_B43_HWRNG=3Dy'=

in .config.

> Can you try to properly switch off the setting with make menuconfig and=

> then recompile everything from scratch (make clean)?

I was intending to do that before, but I cannot find the option for
that.  Searching for b43_hwrng in menuconfig only shows the dependencies
of that option, and the Kconfig file where it is defined, but not the
path in menuconfig.  Do I indirectly set CONFIG_B43_HWRNG through the
parameters it depends on?  I'm sorry, but this is obviously above my
level of expertise ...

cheers, lukas


--=20
Do not believe the naysayers who say it cannot be done.


--j1S88DBBLIG2MH7JzLZLU5MLWHlxXYYv3--

--ODNKjG8uHLjsTEpTPbgGwAILERfqJei3X
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EARECAB0WIQQfsLWbEt//FEFwBMDWbaSYbwIjLQUCWyD5oQAKCRDWbaSYbwIj
LVlGAJwMAntoK1mwAaFXpTvGskgZQOC5ewCfQw5zZ0xg/VSPcQ5nCoeh9upui3o=
=yH9l
-----END PGP SIGNATURE-----

--ODNKjG8uHLjsTEpTPbgGwAILERfqJei3X--

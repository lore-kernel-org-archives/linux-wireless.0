Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from james.theweblords.de ([217.11.55.87]:37245 "EHLO
        james.theweblords.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752369AbdK0PHe (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 27 Nov 2017 10:07:34 -0500
Date: Mon, 27 Nov 2017 16:07:22 +0100
From: Peter =?UTF-8?B?R3Jvw59l?= <pegro@friiks.de>
To: linux-wireless@vger.kernel.org
Subject: Re: Setting TX power on a monitoring interface
Message-ID: <20171127160722.4969cd23@friiks.de> (sfid-20171127_160737_710701_E5B0F542)
In-Reply-To: <1511782993.5456.6.camel@sipsolutions.net>
References: <20171120173415.1ae44829@fem-net.de>
        <1511782993.5456.6.camel@sipsolutions.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/0XjPkdf5iMa=sXmaIfCP1po"; protocol="application/pgp-signature"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--Sig_/0XjPkdf5iMa=sXmaIfCP1po
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 27 Nov 2017 12:43:13 +0100
Johannes Berg <johannes-cdvu00un1VgdHxzADdlk8Q@public.gmane.org> wrote:

> > What would be the correct way of fixing it? Maybe I can provide a patch=
. =20
>=20
> That's a really good question :-)
>=20
> I think if the driver has WANT_MONITOR_VIF, then we can pass that
> through and let the driver sort it out.
>
> But if not, we probably just have to reject the configuration?

With passing through you mean calling bss_info_changed on the driver for the
monitor interface?

Are monitor interfaces allowed to exist when WANT_MONITOR_VIF is not set?
I ask, whether I would have to check=20
  sdata->vif.type =3D=3D NL80211_IFTYPE_MONITOR
_and_ also
  ieee80211_hw_check(&local->hw, WANT_MONITOR_VIF)
?

Regards
Peter

--Sig_/0XjPkdf5iMa=sXmaIfCP1po
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEFBMm5T0HjV/btb+Q2Ws8k4f65hoFAlocKioACgkQ2Ws8k4f6
5hpmCAf9EZfWIoLR8E+9n9MJnWqeoxcAQu/8tH2Z4O4F+owA/Fy+S+imkuUedGjO
K+fbOL1pCYKa3yJSqGPlUaaU/a0krK7MTEw7r440/KQOw1dsnxIUl8KtrCxU9t9V
2Nhpc/ifxecrAt483K9NVR4hyzOpY4lT+t4/Uxl83b0hw7/YRks5MrE5u17sj83S
R+XizWc1IteHeDndJvKGNFc6wolILq8PtgTFfpG6CAn4CUxbGG7zadZih+0Cs/bt
KViFBIUggDk31qeKQAAKQNQ/5ZDwKDneVxfs0Cw9Y5k2xtGmie4odw5+aZCRH2lk
QUUmR7qxhxQ9ZhTUUBi7BaIUtxVE4A==
=sCrn
-----END PGP SIGNATURE-----

--Sig_/0XjPkdf5iMa=sXmaIfCP1po--

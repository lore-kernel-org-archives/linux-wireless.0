Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.21]:52394 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752320AbcIUEbD (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 21 Sep 2016 00:31:03 -0400
Subject: Re: ath9k_htc kernel driver regression affecting throughput
To: bruce m beach <brucembeach@gmail.com>,
        linux-wireless@vger.kernel.org
References: <CAArymCks5NN=09EdJ4uaoRrHZciYAkYTES+i62BkfZ4R-W30HQ@mail.gmail.com>
From: Oleksij Rempel <linux@rempel-privat.de>
Message-ID: <96b0636d-1171-5830-6481-edb991ca8e1a@rempel-privat.de> (sfid-20160921_063107_722573_2F3CD05F)
Date: Wed, 21 Sep 2016 06:30:44 +0200
MIME-Version: 1.0
In-Reply-To: <CAArymCks5NN=09EdJ4uaoRrHZciYAkYTES+i62BkfZ4R-W30HQ@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="EwcRU0vfqQt2i0NWqQq6vxnLMbeEgf6hK"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--EwcRU0vfqQt2i0NWqQq6vxnLMbeEgf6hK
Content-Type: multipart/mixed; boundary="kApr5qso1c32qPRDjeK8Eh077s737BgPC";
 protected-headers="v1"
From: Oleksij Rempel <linux@rempel-privat.de>
To: bruce m beach <brucembeach@gmail.com>, linux-wireless@vger.kernel.org
Message-ID: <96b0636d-1171-5830-6481-edb991ca8e1a@rempel-privat.de>
Subject: Re: ath9k_htc kernel driver regression affecting throughput
References: <CAArymCks5NN=09EdJ4uaoRrHZciYAkYTES+i62BkfZ4R-W30HQ@mail.gmail.com>
In-Reply-To: <CAArymCks5NN=09EdJ4uaoRrHZciYAkYTES+i62BkfZ4R-W30HQ@mail.gmail.com>

--kApr5qso1c32qPRDjeK8Eh077s737BgPC
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Am 21.09.2016 um 05:43 schrieb bruce m beach:
> Oleksij
>=20
> I looked at
> https://unix.stackexchange.com/questions/122050/
>       send-traffic-to-self-over-physical-network-on-ubuntu
>=20
> It appearred to too complicated but
>=20
> https://unix.stackexchange.com/questions/122050/
>         send-traffic-to-self-over-physical-network-on-ubuntu
> with:
>     # Create a network namespace and move one of interfaces into it:
>       ip netns add test2
>       ip link set wlan0 netns test2
>     # Start a shell in the new namespace:
>        ip netns exec test2 bash
>     # Then proceed as if you had two machines. When finished exit the s=
hell and
>     # delete the namespace:
>        ip netns del test2
> Certainly looks interesting but after I got a
>  RTNETLINK answers: Invalid argument
> I lost interest. My heart isn't in it. I'm still working on the firmwar=
e.  I
> have started a new tree (tree #3) that consists of a userland firmware =
uploader
> and until recently the following firmware:
>=20
> app_start( void ) {}
>=20
> i.e a lable that the code jumps to and nothing else. At this point I ha=
ve
> added VendorCommand(), and a debugger via ep0. ( ep0 is a good choice
> since it is available a boot, no matter what) and over the next few
> months I am going to move ->all<- the rom code into ram starting with
> the USB subsystem.
>=20
> Bruce
>=20


Wow, this sounds interesting :)
We recently updated FW to GCC 6.2 which can detect more problems. So it
will be probably interesting for you to pick this patch out.

--=20
Regards,
Oleksij


--kApr5qso1c32qPRDjeK8Eh077s737BgPC--

--EwcRU0vfqQt2i0NWqQq6vxnLMbeEgf6hK
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iF0EAREIAAYFAlfiDPQACgkQHwImuRkmbWkKbAD/YnZ8ymx5+q/gl6c+DqHzNfl2
vs4b0plDfdi5jG3BZEEA906vrZJAulpj7Vr6Q+6R2MGbAa6Exs2nigTP4w7Vhf8=
=qxVL
-----END PGP SIGNATURE-----

--EwcRU0vfqQt2i0NWqQq6vxnLMbeEgf6hK--

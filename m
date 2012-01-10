Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cora.hrz.tu-chemnitz.de ([134.109.228.40]:41082 "EHLO
	cora.hrz.tu-chemnitz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751945Ab2AJWZa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Jan 2012 17:25:30 -0500
Date: Tue, 10 Jan 2012 23:25:24 +0100
From: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
To: "Goldenshtein, Victor" <victorg@ti.com>
Cc: linux-wireless@vger.kernel.org, hostap@lists.shmoo.com,
	kgiori@qca.qualcomm.com, mcgrof@frijolero.org,
	zefir.kurtisi@neratec.com, adrian.chadd@gmail.com, j@w1.fi,
	Johannes Berg <johannes@sipsolutions.net>,
	Luciano Coelho <coelho@ti.com>, Assaf Azulay <assaf@ti.com>,
	"Divinsky, Yonatan" <yoni.divinsky@ti.com>,
	Igal Chernobelsky <igalc@ti.com>, adrian@freebsd.org,
	nbd@nbd.name
Subject: Re: DFS implementation status update
Message-ID: <20120110222524.GF19790@pandem0nium> (sfid-20120110_232534_154387_D7F92195)
References: <CAK80WHZZp=NxVigOZWgECF6Z1Apdzc3dPCXyYRn98QizALTh=g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="SxgehGEc6vB0cZwN"
In-Reply-To: <CAK80WHZZp=NxVigOZWgECF6Z1Apdzc3dPCXyYRn98QizALTh=g@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--SxgehGEc6vB0cZwN
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hello Victor,

thank you for the update, it is nice to hear that you're working on this!

I have a few questions regarding your implementation and whether you have
some features on your list for possible future extensions, please see below.
If you don't have them on your list, I could work on some of them too, plea=
se
don't take this as if I'd expect that you need to do that. ;)

On Tue, Jan 10, 2012 at 10:22:44AM +0200, Goldenshtein, Victor wrote:
> Main DFS procedures
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>=20
> 1. Hostapd gets driver's DFS capabilities.

Do you plan to support IBSS/Ad-Hoc as well?

>=20
> 2. If 80211h is enabled in the hostapd.conf and the driver supports
> one of the above radar detection techniques, hostapd may use DFS
> channels.

I guess you're implementing the channel switch part for now, any plans
on the rest of 802.11h? (station measurement, TPC, etc).=20

>=20
> 3. Hostapd selects an operational channel (default from hostapd.conf),
> if selected channel is a DFS channel, hostapd sends
> start_radar_detection command to the device/driver which starts
> monitoring for radar interference while hostapd sets a timer for a CAC
> (Channel Availability Check) time, which is 60 seconds (DFS spec).
>=20
> 4. As CAC timer expires and no radar has been detected, hostapd may
> continue with the init flow, otherwise if interference is detected
> hostapd randomly selects another channel (later on this can be changed
> to ACS). If the new channel is also a DFS channel hostapd performs CAC
> once again, while the original channel is added to a "black list" for
> a period of ''No-Occupancy'' time (time that the channel can't be
> used/selected).

Do you plan to allow band selection or channel selection? For example,
it would be desirable to only select indoor channels or outdoor channels,
exclude weather channels (5600-5650 MHz) or only select a specific subband =
where
high tx power is allowed.

I'm also not sure if pre-selecting a start channel is conforming to=20
ETSI EN 301 893 V1.5.1 - as I'd interpret it (but I might be wrong), a
channel should always be randomly selected from the available channel list
(4.7.2.6 Uniform Spreading) - there is not test specified for this though (=
Annex A).

I'm also missing the channel switch announcement for associated clients in =
your
flow chart, but maybe you skipped this to keep it simple. It looks like a g=
ood approach,=20
I'm really looking forward to your patchset.

Cheers,
	Simon

--SxgehGEc6vB0cZwN
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAk8MutQACgkQrzg/fFk7axYcwACg48q0fMXWx7saVJiaNZi13KRQ
cb4AoI1DJAvlNggFeUXX0pyzk08lSOs6
=AhDA
-----END PGP SIGNATURE-----

--SxgehGEc6vB0cZwN--

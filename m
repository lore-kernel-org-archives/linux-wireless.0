Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cora.hrz.tu-chemnitz.de ([134.109.228.40]:56576 "EHLO
	cora.hrz.tu-chemnitz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757888Ab1KPPVV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Nov 2011 10:21:21 -0500
Date: Wed, 16 Nov 2011 16:21:17 +0100
From: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
To: Helmut Schaa <helmut.schaa@googlemail.com>
Cc: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>,
	linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	Johannes Berg <johannes@sipsolutions.net>,
	Simon Wunderlich <siwu@hrz.tu-chemnitz.de>,
	Mathias Kretschmer <mathias.kretschmer@fokus.fraunhofer.de>
Subject: Re: [PATCH] mac80211: Add NoAck per WMM Queue Support
Message-ID: <20111116152117.GB10956@pandem0nium> (sfid-20111116_162124_953275_45E019DF)
References: <1321399276-3585-1-git-send-email-siwu@hrz.tu-chemnitz.de>
 <CAGXE3d-Q_8zXX7dHp=eK=wnK7b_AZ3M+fZNekzu50ZOpJoQ9Rw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="+g7M9IMkV8truYOl"
In-Reply-To: <CAGXE3d-Q_8zXX7dHp=eK=wnK7b_AZ3M+fZNekzu50ZOpJoQ9Rw@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--+g7M9IMkV8truYOl
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hello Helmut,

thanks for pointing that out!

As far as I understand minstrel, it is using sent packets and ack statistics
to find out the percentage of successfulness. Therefore, minstrel should
probably not consider NOACK frames for its statistics.

If there are only AC_VO frames, there would not really be any data for
minstrel to build its statistics, so one could either rely on the
control traffic which may go over another queue or use fixed rates.
For example, SIP uses RTP for the voice data and SIP packets for
session control ...

best regards,
        Simon

[Helmut, sorry for the resend, I accidently replied personally to only you =
first]

On Wed, Nov 16, 2011 at 02:58:18PM +0100, Helmut Schaa wrote:
> On Wed, Nov 16, 2011 at 12:21 AM, Simon Wunderlich
> <simon.wunderlich@s2003.tu-chemnitz.de> wrote:
> > This patch adds support for NoAck per WMM Queue. The Unicast QoS
> > Header is adapted accordingly for each outgoing frame.
> > The support is turned on and off through nl80211 by extending
> > the WMM TX Queue Parameters, but can be triggered separately.
>=20
> Just a thought: Assuming you've configured AC_VO to use NoAck and
> you've only got VO traffic going on, is minstrel still able to collect en=
ough
> statistics to do proper rate selection?
>=20
> Thanks,
> Helmut
>=20

--+g7M9IMkV8truYOl
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAk7D1O0ACgkQrzg/fFk7axb25ACfRC6Jt+r0OF5yzYpWHzFHzm89
B1EAn0PmA2jiEnrXLBOnDIGwosmW1bt6
=CqJE
-----END PGP SIGNATURE-----

--+g7M9IMkV8truYOl--

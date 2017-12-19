Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from james.theweblords.de ([217.11.55.87]:47995 "EHLO
        james.theweblords.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752621AbdLSTZk (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 19 Dec 2017 14:25:40 -0500
Date: Tue, 19 Dec 2017 20:25:26 +0100
From: Peter =?UTF-8?B?R3Jvw59l?= <pegro@friiks.de>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Peter =?UTF-8?B?R3Jvw59l?= <pegro@friiks.de>,
        linux-wireless@vger.kernel.org
Subject: Re: [PATCH] mac80211: Fix setting TX power on monitor interfaces
Message-ID: <20171219202526.5bd4568c@fem-net.de> (sfid-20171219_202550_432046_ADE387CB)
In-Reply-To: <1513677210.26145.10.camel@sipsolutions.net>
References: <1512849236.26976.43.camel@sipsolutions.net>
        <20171213172946.19976-1-pegro@friiks.de>
        <1513677210.26145.10.camel@sipsolutions.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/vMzBpRKuJWVn2Z+A9R_ACUa"; protocol="application/pgp-signature"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--Sig_/vMzBpRKuJWVn2Z+A9R_ACUa
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 19 Dec 2017 10:53:30 +0100
Johannes Berg <johannes@sipsolutions.net> wrote:

> > +	if (has_monitor) {
> > +		sdata =3D rtnl_dereference(local->monitor_sdata);
> > +		if (sdata) {
> > +			sdata->user_power_level =3D local->user_power_level;
> > +			if (txp_type !=3D sdata->vif.bss_conf.txpower_type)
> > +				update_txp_type =3D true;
> > +			sdata->vif.bss_conf.txpower_type =3D txp_type;
> > +
> > +			ieee80211_recalc_txpower(sdata, update_txp_type);
> > +		}
> > +	} =20
>=20
> But do we really need this? I think we can probably live with just not
> having monitor handled here, i.e. only have the "if monitor continue;"
> part?

I don't mind. I just thought, if I call ieee80211_recalc_txpower on the
monitor_sdata interface when called explicitly, I would also do it when
iterating over all interfaces, just to be consistent. I don't know, whether
there are drivers out there, that store power limits on monitor interfaces
separately for injection or whatever.

I can send a patch without the quoted part.

Regards
Peter

--Sig_/vMzBpRKuJWVn2Z+A9R_ACUa
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEFBMm5T0HjV/btb+Q2Ws8k4f65hoFAlo5Z6YACgkQ2Ws8k4f6
5hq2FQf9EmZAVhmPM5wTrHMfnC/2pBWFeHMSmHjoaznGb6umM2PHHFoR2/nW1MHN
/U6ug9DaqQESCATLwNCCrwEstPHExpcSLYg/hTh+8fXqrGzuW6tw3nGsbo3Q0JEx
wbPkAcFpSb80R1UecINuRL9NTBIIywYCVEZD5MAnAXgcQqwLzJrPuNW4yJnE7nKQ
ZBD0pThx4nLT3D06Dnkj6g1h92ZR2TSV43EQ7SuhdeZoak3PEeI7bhguwso+TiVB
vRjdqqPEcWuUfXNrHGJxxdjniOEJB2yVrADPsVW7S94aJJD7rO1Y8KB/+a/dAWew
xVnQkFjFWkIJjf7NKAAsCspNcsxT5A==
=w91O
-----END PGP SIGNATURE-----

--Sig_/vMzBpRKuJWVn2Z+A9R_ACUa--

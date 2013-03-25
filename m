Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nick.hrz.tu-chemnitz.de ([134.109.228.11]:58766 "EHLO
	nick.hrz.tu-chemnitz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758415Ab3CYOnl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Mar 2013 10:43:41 -0400
Date: Mon, 25 Mar 2013 15:43:32 +0100
From: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
To: Zefir Kurtisi <zefir.kurtisi@neratec.com>
Cc: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>,
	Adrian Chadd <adrian@freebsd.org>,
	Felix Fietkau <nbd@openwrt.org>,
	Antonio Quartulli <antonio@open-mesh.com>,
	linux-wireless@vger.kernel.org,
	Thomas Pedersen <thomas@cozybit.com>,
	johannes@sipsolutions.net, Marek Lindner <marek@open-mesh.com>,
	Mathias Kretschmer <mathias.kretschmer@fokus.fraunhofer.de>
Subject: Re: [RFC] design discussion: Collecting information for (non-peer)
 stations
Message-ID: <20130325144332.GA11701@pandem0nium> (sfid-20130325_154344_966792_3FB3CD9D)
References: <20130215171938.GA4140@pandem0nium>
 <51279AFA.3000608@openwrt.org>
 <20130222163643.GB3757@open-mesh.com>
 <5127A4E0.8080101@openwrt.org>
 <CAJ-Vmo=zj19mxK7aK28NkGq_KWdQtn2SYPMvdvrsd9i4-H6GPw@mail.gmail.com>
 <20130225102817.GA2069@pandem0nium>
 <20130308141327.GA3363@pandem0nium>
 <19067804.31217.1363003263903.JavaMail.root@neratec.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="OgqxwSJOaUobr8KG"
In-Reply-To: <19067804.31217.1363003263903.JavaMail.root@neratec.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--OgqxwSJOaUobr8KG
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hey Zefir,

On Mon, Mar 11, 2013 at 01:01:03PM +0100, Zefir Kurtisi wrote:
> Hello Simon,
>=20
> tested and looks good.

thanks for the feedback!

>=20
> I had to apply below patch to make it compile on latest
> compat-drivers (hlist_for_each_entry_* API changed in 3.9).

I've adopted your changes and added some compat code.

>=20
> It is definitively useful and I will start on top of it
> when I get back to work on our statistics module.
>=20
> I have no preferences whether to keep it separated or
> integrate it upstream. If statistics are required for
> mesh, there's maybe no choice other than integrating.

Thanks for sharing your thoughts!

As far as I understood from Thomas, we should not consider
the mesh case too much for now. Also I don't know if this
implementation is very useful for him/802.11s

I'll need to put some more effort in this module first
(its more a proof of concept for now). Maybe we propose it
for integration later. But I'm grateful for any patches like the
one you sent with this mail. ;)

>=20
> As for the API, I'd propose to leave it as simple as it is
> now, i.e. whoever needs more / different statistics hooks
> into ws_handle_frame() and adds his handlers after
> ws_sta_parse_ieee80211_hdr().

Yeah maybe you are right, it's the best to keep it as simple
as it is.

Thanks again,
	Simon

--OgqxwSJOaUobr8KG
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAlFQYpQACgkQrzg/fFk7axb9GgCfQUaa33GxlVWWr9OF3ELS1F2p
ydgAoM+8nC9ZIdt8RHrkMTMt7CLQF5ZU
=HIa9
-----END PGP SIGNATURE-----

--OgqxwSJOaUobr8KG--

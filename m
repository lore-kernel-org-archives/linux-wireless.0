Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cora.hrz.tu-chemnitz.de ([134.109.228.40]:48278 "EHLO
	cora.hrz.tu-chemnitz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758285Ab3BYK2Z (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Feb 2013 05:28:25 -0500
Date: Mon, 25 Feb 2013 11:28:17 +0100
From: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
To: Adrian Chadd <adrian@freebsd.org>
Cc: Felix Fietkau <nbd@openwrt.org>,
	Antonio Quartulli <antonio@open-mesh.com>,
	Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Thomas Pedersen <thomas@cozybit.com>,
	"johannes@sipsolutions.net" <johannes@sipsolutions.net>,
	Marek Lindner <marek@open-mesh.com>,
	Mathias Kretschmer <mathias.kretschmer@fokus.fraunhofer.de>
Subject: Re: [RFC] design discussion: Collecting information for (non-peer)
 stations
Message-ID: <20130225102817.GA2069@pandem0nium> (sfid-20130225_112835_104290_AA17C440)
References: <20130215171938.GA4140@pandem0nium>
 <51279AFA.3000608@openwrt.org>
 <20130222163643.GB3757@open-mesh.com>
 <5127A4E0.8080101@openwrt.org>
 <CAJ-Vmo=zj19mxK7aK28NkGq_KWdQtn2SYPMvdvrsd9i4-H6GPw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ibTvN161/egqYuK8"
In-Reply-To: <CAJ-Vmo=zj19mxK7aK28NkGq_KWdQtn2SYPMvdvrsd9i4-H6GPw@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--ibTvN161/egqYuK8
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Feb 22, 2013 at 09:42:43AM -0800, Adrian Chadd wrote:
> .. considering I do radiotap inspection in promiscuous mode all the
> time (on laptops and embedded MIPS boards alike), I'm kinda interested
> in why you're seeing such high CPU utilisation.
>=20
> Are you trying to capture the whole frame? Or are you only capturing
> the header? It sounds like you only need the header, right?

Yup, we capture the whole frame, but as far as I understand the main
problem are the syscalls to receive each frame individually.

We had a similar interesting experience in batman-adv, operating with
raw sockets and send/recv and could do more than 10 Mbit/s, and after
moving to kernel space we could do several hundred Mbit/s - on the same
platform (AMD Geode based boards).

>=20
> I agree with Felix - this is the kind of thing that it makes sense to
> define an API for so you can write in-kernel monitoring plugins. Then
> your monitoring plugin can decide how to aggregate and pass up the
> data.

Yeah, maybe ... I mean, I understand that our application is quite "special"
and 99% of the mac80211 users (think laptop, android users etc) won't use
it.

OTOH there are at least some who have similar interest, so it's good to
see who wants what. If many people want the same thing, we might be able
to share the maintainance overhead among them. :)

But if the goals are very different, it might be better as Felix suggested
to just keep it out of mac80211 and everyone writes their own modules, or
we create a shared base where everyone can attach code for their special
needs.

Anyway, I'll look at the rx_handler stuff what Felix suggested and see
if this could work out. :)

Cheers,
	Simon

--ibTvN161/egqYuK8
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAlErPMEACgkQrzg/fFk7axZLWACg83rimvGkFAmn+VYEuKVbvMwH
pvsAoMegYa70z5vq2gkDYwIvf6OzI0AT
=YH28
-----END PGP SIGNATURE-----

--ibTvN161/egqYuK8--

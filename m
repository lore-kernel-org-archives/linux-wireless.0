Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s2.neomailbox.net ([5.148.176.60]:2950 "EHLO s2.neomailbox.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S934306AbcJXNfz (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 24 Oct 2016 09:35:55 -0400
Date: Mon, 24 Oct 2016 21:35:10 +0800
From: Antonio Quartulli <a@unstable.cc>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
        Simon Wunderlich <sw@simonwunderlich.de>
Subject: Re: [PATCH v2 2/2] mac80211: passively scan DFS channels if requested
Message-ID: <20161024133510.GD8925@prodigo.lan> (sfid-20161024_153558_840649_259CC484)
References: <1447464560-28104-1-git-send-email-antonio@meshcoding.com>
 <1447464560-28104-2-git-send-email-antonio@meshcoding.com>
 <1448016547.3141.4.camel@sipsolutions.net>
 <564F1790.7030309@open-mesh.com>
 <20161024121129.GA8925@prodigo.lan>
 <1477316004.4085.17.camel@sipsolutions.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="eAbsdosE1cNLO4uF"
In-Reply-To: <1477316004.4085.17.camel@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--eAbsdosE1cNLO4uF
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Oct 24, 2016 at 03:33:24PM +0200, Johannes Berg wrote:
>=20
> > > I think it would be reasonable only if the target channel is the
> > > one we are using and we have done CSA. But when scanning non-
> > > operative channels I don't think this could work.
>=20
> > this has been sleeping for a while.. :)
> > Would it make sense to rebase it and resubmit it for inclusion?
> >=20
> > Given the previous discussion we could change the logic as:
> > * always passively scan DFS channels that are not usable
> > * always actively scan DFS channels that are usable (i.e. CAC was
> > performed).
>=20
> Doesn't that contradict what you said above?
>=20
> If we scan, don't we possibly lose our CAC result anyway, since we went
> off-channel? In FCC at least? In ETSI I think we're allowed to do that
> for a bit?

argh. ok, I think I had forgotten about this detail.

>=20
> Anyway, why not just always scan passively, to simplify?
>=20

Probably better..ok let's do it this way.

Thanks !


--=20
Antonio Quartulli

--eAbsdosE1cNLO4uF
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----

iQIcBAEBCAAGBQJYDg4LAAoJEJ6F1zG2JyOsOf4QAKhVDk67tINEQjgwiWRYSoE4
iU341ybeGoAXRZgu5dKJhoRHIK+BiU6e+X52GcZ/SiUxuWkqcXm1D0q0xOs9egMj
4YcI95ENpLM+1qrrG97jyJ6CFBGk1eHuvfijwEmahwURfoiHmklQG+UOPJAIlccD
NQaB/kaQrpZcIo3EZkvM5327NXyNTIPAQZ/i4YjEKJ/6YLRYSYpUbOv6/yZ32nPo
KmncM3vV10hgcwMtwyPFT/HqvWp/7mWMya/eqCaYCtzSVEMKAkAq+eoy7l7lFV1H
toPHlVYWwDngYie+Q35Dfy77HLj1Dnu/9P7rTpqZPK1yfcTOVDnbzx8b35BXMhoi
bAfZjJE7jrf+n2mdwuwttDLQ/URlt87/Rl9Y9AWFq6Atlhxi+6sptCohxqowfOtM
7kBiJx5bGGcX8zKhJVIujWF+emkXd29mM6Abw2CZ8HE07FMaFfdtF8VoLjLqfqSn
WWRbKZr6qgTfWw4a/hS+m0DR0CSjfay2IrHY9jQrMF7svylBveErx7Dq88DVv19i
d6HFJahL6yoBbyXFKeYyRy/e/uqY4t0XtPplgqVldn8yCq8NrkDb3Hyt+EsHkzmh
SPzhwVKocPyCT+1kI9Tnu18umVFJ1jzPtCxugfAjIV2rNlhAFF/yWvZi3vlB+Uo7
esKgf23qI+j8sqtqzRHe
=lW/A
-----END PGP SIGNATURE-----

--eAbsdosE1cNLO4uF--

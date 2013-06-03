Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from contumacia.investici.org ([178.255.144.35]:56498 "EHLO
	contumacia.investici.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759434Ab3FCRQY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Jun 2013 13:16:24 -0400
Date: Mon, 3 Jun 2013 19:14:30 +0200
From: Antonio Quartulli <ordex@autistici.org>
To: Nicolas Cavallari <Nicolas.Cavallari@lri.fr>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org,
	Antonio Quartulli <antonio@open-mesh.com>,
	Kalle Valo <kvalo@qca.qualcomm.com>
Subject: ath6kl_mgmt_tx with NULL chan (was Re: [PATCH 1/2] nl80211: allow
 sending CMD_FRAME without specifying any frequency)
Message-ID: <20130603171430.GE1226@ritirata.org> (sfid-20130603_191636_945457_F5ECC3BF)
References: <1370241587-2609-1-git-send-email-ordex@autistici.org>
 <1370271547.8227.16.camel@jlt4.sipsolutions.net>
 <51ACB068.8070006@lri.fr>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="SNIs70sCzqvszXB4"
In-Reply-To: <51ACB068.8070006@lri.fr>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--SNIs70sCzqvszXB4
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jun 03, 2013 at 05:04:08PM +0200, Nicolas Cavallari wrote:
> On 03/06/2013 16:59, Johannes Berg wrote:
> > On Mon, 2013-06-03 at 08:39 +0200, Antonio Quartulli wrote:
> >> From: Antonio Quartulli <antonio@open-mesh.com>
> >>
> >> Users may want to send a frame on the current channel
> >> without specifying it.
> >>
> >> Make mgmt_tx pass a NULL channel to mac80211 if none has
> >> been specified by the user.
> >=20
> > cfg80211 isn't just a mac80211 frontend ... ;-)
> >=20
> > Also, as Nicolas said, ath6kl_mgmt_tx() will crash after this patch if
> > it's called in AP mode w/o a channel, so you need to think about that.
>=20
> It will crash unconditionally. All ath6kl_mgmt_tx()'s code paths access
> chan->center_freq at some point.

Hello Nicolas,
I'm also CCing Kalle Valo since get_maintainer.pl told me he is the guy for
these kind of questions :-)

I'm looking at ath6kl_mgmt_tx() in ath6kl/cfg80211.c and I've seen that the
currently "configured" frequency can be obtained by reading the
ath6kl_vif->ch_hint field.

But, is this correct? I couldn't see any real relation between the ch_hint =
field
and the real frequency (probably because a lot of logic is hidden to the
driver).
I could only understand that the ch_hint field stores the frequency passed =
as
parameter during the connection, but I have found no guarantee that this is=
 the
really used one.

Can someone please clarify on this?

Cheers,

--=20
Antonio Quartulli

=2E.each of us alone is worth nothing..
Ernesto "Che" Guevara

--SNIs70sCzqvszXB4
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBCAAGBQJRrM72AAoJEADl0hg6qKeOQRAP/j6R466TfHz3+uPYc5UfPOOZ
20LdyLlERcCzRPgKoPlgnV3I4A6alcY9u06OHJBzJsGXibzcKkNPNp52LrqQRLwa
BtiBdGQ1qpYBLRPWufsY7afO47mkdzZgxgTn6USG1Z/w2S+YLCGO05J+7FBoN2zl
HqQLc89yoERYxfGXt9VXfZTN5FXgyPQW/QlJ21sw128I638RKacurGsFyQh7SzNZ
oybkisgq+/GnlFphe5KFr/FlJB3iSxLaIqtBWys2Gj8ABsVXJrbn2wGKkmGxeY6F
THvaps9pHJ0A6wUKBuoipyXr1aMmjnbXNZNuBTgdm6cjTy3q9v1j5+O3vsZtujKB
RqPulxt2zsiZ3wx0OlbEgP5Gl84ONE4oR68mVdYSMY7MpJFU+RusaHiTv36P8omy
Qh9DtmMxyG5q5kct4VUMezvZOfIgKnBWKX1TS576xl+4h2LxfCeEtNpxF/36nKNe
NEpUJtzAiNPfYDcZ+4jWSlGclu+q10QmzpXlj+AN7tSgBCcdT+vW0Y0J3X2OS+SQ
bkUVY4Go93ypKS/yAH7ZxjUG9FpPGNJo9E3yCmAbA3LAhjf0APdjOQdxxBazRMPp
0Xl8b3OzvyJo0DIXbxAkAaf3Qb3OKpwwAwzR7+/jHVTttQPXHbP90xEQSyPDE71Z
XAz4+u5YG6a40fdz+me1
=J+v4
-----END PGP SIGNATURE-----

--SNIs70sCzqvszXB4--

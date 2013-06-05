Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ht2.myhostedexchange.com ([69.50.2.38]:12461 "EHLO
	ht1.hostedexchange.local" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752699Ab3FEKF2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Jun 2013 06:05:28 -0400
Date: Wed, 5 Jun 2013 12:03:32 +0200
From: Antonio Quartulli <antonio@open-mesh.com>
To: Kalle Valo <kvalo@qca.qualcomm.com>
CC: Antonio Quartulli <ordex@autistici.org>,
	Nicolas Cavallari <Nicolas.Cavallari@lri.fr>,
	Johannes Berg <johannes@sipsolutions.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ath6kl-devel@qca.qualcomm.com" <ath6kl-devel@qca.qualcomm.com>
Subject: Re: ath6kl_mgmt_tx with NULL chan
Message-ID: <20130605100332.GB2349@open-mesh.com> (sfid-20130605_120531_259123_1A7611E6)
References: <1370241587-2609-1-git-send-email-ordex@autistici.org>
 <1370271547.8227.16.camel@jlt4.sipsolutions.net>
 <51ACB068.8070006@lri.fr>
 <20130603171430.GE1226@ritirata.org>
 <8738swkhho.fsf@kamboji.qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="7ZAtKRhVyVSsbBD2"
In-Reply-To: <8738swkhho.fsf@kamboji.qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--7ZAtKRhVyVSsbBD2
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jun 05, 2013 at 02:57:07AM -0700, Kalle Valo wrote:
> Antonio Quartulli <ordex@autistici.org> writes:
>=20
> > On Mon, Jun 03, 2013 at 05:04:08PM +0200, Nicolas Cavallari wrote:
> >> On 03/06/2013 16:59, Johannes Berg wrote:
> >> > On Mon, 2013-06-03 at 08:39 +0200, Antonio Quartulli wrote:
> >> >> From: Antonio Quartulli <antonio@open-mesh.com>
> >> >>
> >> >> Users may want to send a frame on the current channel
> >> >> without specifying it.
> >> >>
> >> >> Make mgmt_tx pass a NULL channel to mac80211 if none has
> >> >> been specified by the user.
> >> >=20
> >> > cfg80211 isn't just a mac80211 frontend ... ;-)
> >> >=20
> >> > Also, as Nicolas said, ath6kl_mgmt_tx() will crash after this patch =
if
> >> > it's called in AP mode w/o a channel, so you need to think about tha=
t.
> >>=20
> >> It will crash unconditionally. All ath6kl_mgmt_tx()'s code paths access
> >> chan->center_freq at some point.
> >
> > Hello Nicolas,
> > I'm also CCing Kalle Valo since get_maintainer.pl told me he is the guy=
 for
> > these kind of questions :-)
> >
> > I'm looking at ath6kl_mgmt_tx() in ath6kl/cfg80211.c and I've seen that=
 the
> > currently "configured" frequency can be obtained by reading the
> > ath6kl_vif->ch_hint field.
> >
> > But, is this correct?
>=20
> I did a quick look. To me using ch_hint looks correct.
>=20
> > I couldn't see any real relation between the ch_hint field and the
> > real frequency (probably because a lot of logic is hidden to the
> > driver). I could only understand that the ch_hint field stores the
> > frequency passed as parameter during the connection, but I have found
> > no guarantee that this is the really used one.
>=20
> Can you be more specific, please?
>=20
> To me it looks that ch_hint is used both with ath6kl_wmi_reconnect_cmd()
> and ath6kl_wmi_connect_cmd() commands, which both are used to connect to
> a network. I don't see any other variables used for specifying the
> frequency to the firmware. But I could just be blind...

I agree with your analysis. My doubt came from the fact that I don't know w=
hat
the firmware does and I was wondering whether it could ignore the channel p=
assed
as argument on connect for some reason.

Actually the doubt was raised due to the variable name "ch_HINT".
But you are the ath6k expert :-) Therefore I guess this can work.

Thanks a lot!

Cheers,

--=20
Antonio Quartulli

=2E.each of us alone is worth nothing..
Ernesto "Che" Guevara

--7ZAtKRhVyVSsbBD2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBCAAGBQJRrwz0AAoJEADl0hg6qKeOuvUP+weEtXb21RhaaFeY4KL16RVk
CVxUxfdmbryeFX1wSxxDQ4uv9SpV7AikwuvOs9xbA8OkrBdx5T1vwEV09q6U8GZU
ujcfe5y/TA8i/VzHsFHLZAc6w3N6/FGtIQPPDdHZkKR3XorTcQ1gyjP43QgTb6nh
nD5sdMp/IS+B1f+AT3BFqE9L9+sfJWAWvh+awUtsV2/rKy9RZyjPBm8hdr8w1FxK
DW8uhPbN0Omwh+SmA/k+cf2hPCXPQmPtJ4O2OfevF0x9m9tcJOMwAhCoK3RJik7x
z5aVWT/BrIDmbhVTRJtx7Yf9GA6u7gaBKEy3C+7Wk1vNMQUx2GefTF0/hZO0A5/S
lzyZvzOgBqeBzDwxdC1nOFrHuXhO+d/23CE2DGc/dDHkc9IYEhwR/b9XqaV5KdeQ
iVk582COYtpRqp6+Nw/Nm2J3plfjIMkWKWh3sxSqROWeiQQWEP39c6A9w6v/tEto
+KZZ+dbZlMUhUT/YfXk2PhBfIba3D1Brp8NNNiTq6IGHbtggaNcD4MnddBlO4LGv
EGVxpVBHxC+pU+NM29OzFryIn4N0kVneYJ8X1CpnbEvPnLjUswwGYbYj3KRnPQJA
q/r2HKdik6dwxdlpslZhF+vqoAssFa9eIjnvuHHm4zQ+FfB7XowECrL5PQnXywME
0t9K+dEdVNynWbiWo4yJ
=IrVk
-----END PGP SIGNATURE-----

--7ZAtKRhVyVSsbBD2--

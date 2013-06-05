Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ht1.myhostedexchange.com ([69.50.2.37]:36904 "EHLO
	ht1.hostedexchange.local" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755451Ab3FEOxy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Jun 2013 10:53:54 -0400
Date: Wed, 5 Jun 2013 16:51:57 +0200
From: Antonio Quartulli <antonio@open-mesh.com>
To: Kalle Valo <kvalo@qca.qualcomm.com>
CC: Antonio Quartulli <ordex@autistici.org>,
	Johannes Berg <johannes@sipsolutions.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Nicolas Cavallari <Nicolas.Cavallari@lri.fr>,
	"ath6kl-devel@qca.qualcomm.com" <ath6kl-devel@qca.qualcomm.com>
Subject: Re: [PATCHv3 3/4] ath6kl: make mgmt_tx accept a NULL channel
Message-ID: <20130605145157.GH2349@open-mesh.com> (sfid-20130605_165406_597882_C680D210)
References: <1370442893-1687-1-git-send-email-ordex@autistici.org>
 <1370442893-1687-3-git-send-email-ordex@autistici.org>
 <87r4ggy5ow.fsf@kamboji.qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="Fnm8lRGFTVS/3GuM"
In-Reply-To: <87r4ggy5ow.fsf@kamboji.qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--Fnm8lRGFTVS/3GuM
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jun 05, 2013 at 07:48:15AM -0700, Kalle Valo wrote:
> Antonio Quartulli <ordex@autistici.org> writes:
>=20
> > From: Antonio Quartulli <antonio@open-mesh.com>
> >
> > cfg80211 passes a NULL channel to mgmt_tx if the frame has
> > to be sent on the one currently in use by the device.
> > Make the implementation of mgmt_tx correctly handle this
> > case
> >
> > Cc: Kalle Valo <kvalo@qca.qualcomm.com>
> > Cc: Nicolas Cavallari <Nicolas.Cavallari@lri.fr>
> > Signed-off-by: Antonio Quartulli <antonio@open-mesh.com>
>=20
> [...]
>=20
> > @@ -3175,10 +3175,17 @@ static int ath6kl_mgmt_tx(struct wiphy *wiphy, =
struct wireless_dev *wdev,
> >  {
> >  	struct ath6kl_vif *vif =3D ath6kl_vif_from_wdev(wdev);
> >  	struct ath6kl *ar =3D ath6kl_priv(vif->ndev);
> > -	u32 id;
> > +	u32 id, freq;
> >  	const struct ieee80211_mgmt *mgmt;
> >  	bool more_data, queued;
> > =20
> > +	/* default to the current channel, but use the one specified as argum=
ent
> > +	 * if any
> > +	 */
> > +	freq =3D vif->ch_hint;
> > +	if (chan)
> > +		freq =3D chan->center_freq;
>=20
> Can you please add a check here:
>=20
> if (WARN_ON(chan =3D=3D 0))
>    return -EINVAL;

I think you meant (freq =3D=3D 0) ?

>=20
> Just like Arend, I want to be sure that we don't submit value 0 to the
> firmware.

Yeah ok. In ath6kl, are you aware of any "firmware command" to get the chan=
nel
=66rom the device like I did for brcmfmac ?

I couldn't find any define matching *GET*CHAN*

Regards,

--=20
Antonio Quartulli

=2E.each of us alone is worth nothing..
Ernesto "Che" Guevara

--Fnm8lRGFTVS/3GuM
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBCAAGBQJRr1CNAAoJEADl0hg6qKeOY4cQAJJ6X9lTFYOo/h0R4tU5K14T
cxIS2gzdzJ924ob6dmDBxcBh+PvB5DeUbheAUYcoHxnZFGPrQi6wC3TkeJzVWKS0
qxJiplcPV97DZgBAB31mmKRCkVkzwxaOSc9Si2gHGIb7HtZTvQx3V4Xer9Z2Q1DJ
V+xMFj/nL+fsh2JJpPCqWANLSsUE8F2Eny5r1ygJ33eOeYhnyi4aImqHVJ3Vjz7B
dCSHmUtfKmQ+YTkScP/aAQ5oLZMZ7VPjmcK7pAhYUA/PwshrHVST/5sPF+IaQUwb
fEoaXPUeJu10nnsfL6QZPUvKdNOPouidF2Swj08rsu/GgIITkB0Evl56UWezwrG/
RUDg0nZosIzyzjtyLt1BOtkVDl1WnXtoYLGIcHqVrQZdLKo/FqBdbP5rOAsyH33E
EGRzRvfRI8JgRUSfRbYEP5upTz1ZnIZF+RmzUZxGBC0/45puxeGJzjEt017UX2kT
N8DhUB02CVCmZr0YHUQnbC2mmR094aN2h+OPfsF1AdTf+yYtRH4uOwF8JqyARrso
ppcws4cvLOpYJZTbtLRaoDocqNoP8I0rTGzOQzbFvuFMVmdj9SUVoeOj9u4uvY++
uz2YS/1lkCcVjGa2cFdty1aT7co4lCmGidlABa0N5PJNt3AA8jBkSvZP6ncoMEYk
IiQJPSTTg31T+hbSmvt7
=Fr4r
-----END PGP SIGNATURE-----

--Fnm8lRGFTVS/3GuM--

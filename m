Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ht1.myhostedexchange.com ([69.50.2.37]:31626 "EHLO
	ht1.hostedexchange.local" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756064Ab3FEOTQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Jun 2013 10:19:16 -0400
Date: Wed, 5 Jun 2013 16:17:18 +0200
From: Antonio Quartulli <antonio@open-mesh.com>
To: Arend van Spriel <arend@broadcom.com>
CC: Antonio Quartulli <ordex@autistici.org>,
	Johannes Berg <johannes@sipsolutions.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"brcm80211-dev-list@broadcom.com" <brcm80211-dev-list@broadcom.com>
Subject: Re: [PATCHv2 3/4] brcm80211: make mgmt_tx in brcmfmac accept a NULL
 channel
Message-ID: <20130605141718.GG2349@open-mesh.com> (sfid-20130605_161944_179638_DFBEE6FC)
References: <1370433187-1337-1-git-send-email-ordex@autistici.org>
 <1370433187-1337-3-git-send-email-ordex@autistici.org>
 <51AF42DC.3000001@broadcom.com>
 <20130605135757.GF2349@open-mesh.com>
 <51AF47AF.9060802@broadcom.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="FeAIMMcddNRN4P4/"
In-Reply-To: <51AF47AF.9060802@broadcom.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--FeAIMMcddNRN4P4/
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jun 05, 2013 at 07:14:07AM -0700, Arend van Spriel wrote:
> On 06/05/2013 03:57 PM, Antonio Quartulli wrote:
> > On Wed, Jun 05, 2013 at 06:53:32AM -0700, Arend van Spriel wrote:
> >
> > [...]
> >
> >>> +		freq =3D cfg->channel;
> >>> +		if (chan)
> >>> +			freq =3D chan->center_freq;
> >>> +		chan_nr =3D ieee80211_frequency_to_channel(freq);
> >>
> >> Could you get rid of 'freq' variable and use
> >> ieee80211_frequency_to_channel() on cfg->channel or chan->center_freq.
> >>
> >
> > I tried that, but the line indented below the if would be longer than 8=
0 chars
> > and breaking it is quite ugly.
> >
> >> Another thing is that cfg->channel can be zero resulting in chan_nr
> >> being zero. I had a quick look whether the device firmware can handle
> >> this. I suspect not, but I will need to ask to be sure.
> >>
> >
> > ok. But when cfg->channel is zero, where is the current freq stored?
>=20
> It is not. The rf on the device is set to a certain channel so it can be=
=20
> retrieved from the device:
>=20
> brcmf_fil_cmd_int_get(vif->ifp, BRCMF_C_GET_CHANNEL, &freq);
>=20
> The vif pointer can be obtained using container_of() on the wdev. That=20
> is done in mgmt_tx() already some lines above. May you should move=20
> determining the vif pointer and do it unconditional.
>=20

Yeah, I like this approach.

I'll send v3 of this patchset with this change in it.
@johannes: I'll also revert the order of the patches.

Thanks a lot Arend.

Regards,

--=20
Antonio Quartulli

=2E.each of us alone is worth nothing..
Ernesto "Che" Guevara

--FeAIMMcddNRN4P4/
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBCAAGBQJRr0huAAoJEADl0hg6qKeOrtoP/0dO487snt3ehbxblLykjnuk
cHZuZ0dfnUhf2iZBy/XxuJbFXgyWbuD/RwileZTkbR4XsYjT9/i+zJiuWM5Cbo0h
4KKTqkOCN32Ut1106M/7kfGwgo0Q6HjNkQmyz08yDfdx9zjdnhJWv3WYDigsWFat
nH4owSqyNmUB9J0uNAej7rd4soPe+OCLYdb6aUj5O8BC7e7SU5ZKtczH5wiiXBxM
sJOhNAtspiDma/JEcE1wNDVdCnXJPWDXigZXtDafn1coZa/YKYM3rj9/E/UoAhBh
bGb7v3Xjq13EknQ3rjW0fkSS/YUXabbzjH9+yZ4yPGqT4M5MgGwiv3Fws67JuYVv
eUyWEOsWLXFtIz228JhXsVVRoJKskVZ79rBvVP4NQJ9KYuPmQm6KQ0qL1HzklmLI
HJqtPSh+0ULJ0lu9xaNqg+OG84H1RMEUbKxMGovK6uGkUo6opHsbrYtMkYB3bnQ4
jQ+avlzl7Pg27NfmzkmOFYduKvdMRlITUM0Fhln05WrWVdLzPOvvFo1DpHvJI3gG
qOULB514SNcACxAyqyl1w7Cv0Mk2IF8erbdl8OuDyOtQTGDZGh3BsO+ROtNNvpyh
urtAzcynbLCAzncO5UwISiYUzB0xLBdpyhQbVJ2ZPVma3amAhAplWjrB8LyDeOjF
/82fSGIyPnqPbTolABUG
=divZ
-----END PGP SIGNATURE-----

--FeAIMMcddNRN4P4/--

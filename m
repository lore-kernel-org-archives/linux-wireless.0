Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ht1.myhostedexchange.com ([69.50.2.37]:59774 "EHLO
	ht1.hostedexchange.local" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S934175Ab3FSL3U (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Jun 2013 07:29:20 -0400
Date: Wed, 19 Jun 2013 13:27:11 +0200
From: Antonio Quartulli <antonio@open-mesh.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"brcm80211-dev-list@broadcom.com" <brcm80211-dev-list@broadcom.com>
Subject: Re: brcm80211: make mgmt_tx in brcmfmac accept a NULL channel
Message-ID: <20130619112537.GA1738@open-mesh.com> (sfid-20130619_132924_440066_E05E1B1B)
References: <20130619111620.GA969@elgon.mountain>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="f2QGlHpHGjS2mn6Y"
In-Reply-To: <20130619111620.GA969@elgon.mountain>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--f2QGlHpHGjS2mn6Y
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hello Dan,

On Wed, Jun 19, 2013 at 04:16:27AM -0700, Dan Carpenter wrote:
> Hello Antonio Quartulli,
>=20
> This is a semi-automatic email about new static checker warnings.
>=20
> The patch c2ff8cad6423: "brcm80211: make mgmt_tx in brcmfmac accept a
> NULL channel" from Jun 11, 2013, leads to the following Smatch
> complaint:
>=20
> drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c:4052 brcmf_cfg80211=
_mgmt_tx()
> 	 error: we previously assumed 'chan' could be null (see line 4041)
>=20
> drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
>   4040			 */
>   4041			if (chan)
>                             ^^^^
> New check reflects that "chan" can now be NULL.
>=20
>   4042				freq =3D chan->center_freq;
>   4043			else
>   4044				brcmf_fil_cmd_int_get(vif->ifp, BRCMF_C_GET_CHANNEL,
>   4045						      &freq);
>   4046			chan_nr =3D ieee80211_frequency_to_channel(freq);
>   4047			af_params->channel =3D cpu_to_le32(chan_nr);
>   4048=09
>   4049			memcpy(action_frame->data, &buf[DOT11_MGMT_HDR_LEN],
>   4050			       le16_to_cpu(action_frame->len));
>   4051=09
>   4052			brcmf_dbg(TRACE, "Action frame, cookie=3D%lld, len=3D%d, freq=3D=
%d\n",
>   4053				  *cookie, le16_to_cpu(action_frame->len),
>   4054				  chan->center_freq);
>                                   ^^^^^^
> This needs to be updated as well.
>=20

Thank you very much for spotting this. I'm going to send a patch fixing it.
(however the line numbers were shifted..)

Regards,

--=20
Antonio Quartulli

=2E.each of us alone is worth nothing..
Ernesto "Che" Guevara

--f2QGlHpHGjS2mn6Y
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBCAAGBQJRwZWPAAoJEADl0hg6qKeO3n0P/1RmBOM8ww7703VzpgwPuMHp
rMYQyz9EUJX0MrsSTFpsGnemS+mTSSym9S4fVtc6wMllTXRvYNwz69lyrsgS6HQE
IMhoBUV3NcL8dtZwPVkez4jPza+0drOTOvAF5/qWL9flNMzhLNBVsYP1gXV+7GZ1
FjRCGgH0Zm9g3LJllIFc+ayU1dkSSjkyOS7CEmsZMS5Bci6ZeCYfpy+xmF78uD/y
6YLa15DlmeHKq4/z4IAfbr/hSHIe9rTvUKmGzyC2TRZ4gOovnhNVctyQxNUWm3fp
admoUo5txv0Zd9zQDpxUA0gMfkhntLz5iCBAb1MHoUUpHQgAkgkINCKxKWSaUJlD
pkp1hPlPVpoDT7dcus2jvBlAJo9twq2W0e7/DVUhRbYUa5KMyRBfYxZqzqKscezT
SaVE8VKk2Hgo3opI+35xfmP4jxX0XPJmJEPfzgQs/URXyElAr9RPDezaD+DV+Ucw
tachI+nliW73Fn6adHLGn5paG+pIR0zGuyf5EMJEpTCFh5j8mEYtvjutmbm/jUIA
GnIwKoQnGa1dzgKuT6PRm75Hlkrqv559/QavFraN81ps09TThZh3cFYu7cMEvQy2
vDPqC4iqRkG6bm2HSit6PVYXpKp0Q0nNQQIOkqb2t5yEatUw+5vCSKgq2VJtPHCL
/QjDyFJHInz39qz2MDlD
=8kOd
-----END PGP SIGNATURE-----

--f2QGlHpHGjS2mn6Y--

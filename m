Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from orthanc.universe-factory.net ([104.238.176.138]:48620 "EHLO
        orthanc.universe-factory.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751509AbeAZW0y (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 26 Jan 2018 17:26:54 -0500
Subject: Re: [PATCH 1/2] wireless: set correct mandatory rate flags
To: =?UTF-8?Q?Richard_Sch=c3=bctz?= <rschuetz@uni-koblenz.de>,
        Johannes Berg <johannes@sipsolutions.net>
References: <20170907154744.28357-1-rschuetz@uni-koblenz.de>
Cc: linux-wireless@vger.kernel.org
From: Matthias Schiffer <mschiffer@universe-factory.net>
Message-ID: <2f3b9bd7-f083-f46c-8c47-051019a6f495@universe-factory.net> (sfid-20180126_232658_364993_BD328A0D)
Date: Fri, 26 Jan 2018 23:17:24 +0100
MIME-Version: 1.0
In-Reply-To: <20170907154744.28357-1-rschuetz@uni-koblenz.de>
Content-Type: multipart/signed; micalg=pgp-sha512;
 protocol="application/pgp-signature";
 boundary="MoxVCABf2F429fyxa4XuuuWS1ui9s1Tjl"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--MoxVCABf2F429fyxa4XuuuWS1ui9s1Tjl
Content-Type: multipart/mixed; boundary="4GTVpdpjtfavVn6M5UVVFvFYV7tCAJ4eE";
 protected-headers="v1"
From: Matthias Schiffer <mschiffer@universe-factory.net>
To: =?UTF-8?Q?Richard_Sch=c3=bctz?= <rschuetz@uni-koblenz.de>,
 Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Message-ID: <2f3b9bd7-f083-f46c-8c47-051019a6f495@universe-factory.net>
Subject: Re: [PATCH 1/2] wireless: set correct mandatory rate flags
References: <20170907154744.28357-1-rschuetz@uni-koblenz.de>
In-Reply-To: <20170907154744.28357-1-rschuetz@uni-koblenz.de>

--4GTVpdpjtfavVn6M5UVVFvFYV7tCAJ4eE
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 09/07/2017 05:47 PM, Richard Sch=C3=BCtz wrote:
> According to IEEE Std 802.11-2016 (16.2.3.4 Long PHY SIGNAL field) all =
of
> the following rates are mandatory for a HR/DSSS PHY: 1 Mb/s, 2 Mb/s,
> 5.5 Mb/s and 11 Mb/s. Set IEEE80211_RATE_MANDATORY_B flag for all of th=
ese
> instead of just 1 Mb/s to correctly reflect this.
>=20
> Signed-off-by: Richard Sch=C3=BCtz <rschuetz@uni-koblenz.de>

We've noticed that this is breaking interoperability of 11s nodes in
OpenWrt: association is only possible when neither or both peers have thi=
s
patch. I have not tested interop with non-Linux 11s peers.

I propose to revert this for now (I assume it's too late for 4.15, but
hopefully the regression can be fixed in 4.15.1).

Regards,
Matthias


> ---
>  net/wireless/util.c | 22 +++++++++-------------
>  1 file changed, 9 insertions(+), 13 deletions(-)
>=20
> diff --git a/net/wireless/util.c b/net/wireless/util.c
> index bcb1284c3415..c69b5c31caf8 100644
> --- a/net/wireless/util.c
> +++ b/net/wireless/util.c
> @@ -157,32 +157,28 @@ static void set_mandatory_flags_band(struct ieee8=
0211_supported_band *sband)
>  	case NL80211_BAND_2GHZ:
>  		want =3D 7;
>  		for (i =3D 0; i < sband->n_bitrates; i++) {
> -			if (sband->bitrates[i].bitrate =3D=3D 10) {
> +			if (sband->bitrates[i].bitrate =3D=3D 10 ||
> +			    sband->bitrates[i].bitrate =3D=3D 20 ||
> +			    sband->bitrates[i].bitrate =3D=3D 55 ||
> +			    sband->bitrates[i].bitrate =3D=3D 110) {
>  				sband->bitrates[i].flags |=3D
>  					IEEE80211_RATE_MANDATORY_B |
>  					IEEE80211_RATE_MANDATORY_G;
>  				want--;
> +			} else {
> +				sband->bitrates[i].flags |=3D
> +					IEEE80211_RATE_ERP_G;
>  			}
> =20
> -			if (sband->bitrates[i].bitrate =3D=3D 20 ||
> -			    sband->bitrates[i].bitrate =3D=3D 55 ||
> -			    sband->bitrates[i].bitrate =3D=3D 110 ||
> -			    sband->bitrates[i].bitrate =3D=3D 60 ||
> +			if (sband->bitrates[i].bitrate =3D=3D 60 ||
>  			    sband->bitrates[i].bitrate =3D=3D 120 ||
>  			    sband->bitrates[i].bitrate =3D=3D 240) {
>  				sband->bitrates[i].flags |=3D
>  					IEEE80211_RATE_MANDATORY_G;
>  				want--;
>  			}
> -
> -			if (sband->bitrates[i].bitrate !=3D 10 &&
> -			    sband->bitrates[i].bitrate !=3D 20 &&
> -			    sband->bitrates[i].bitrate !=3D 55 &&
> -			    sband->bitrates[i].bitrate !=3D 110)
> -				sband->bitrates[i].flags |=3D
> -					IEEE80211_RATE_ERP_G;
>  		}
> -		WARN_ON(want !=3D 0 && want !=3D 3 && want !=3D 6);
> +		WARN_ON(want !=3D 0 && want !=3D 3);
>  		break;
>  	case NL80211_BAND_60GHZ:
>  		/* check for mandatory HT MCS 1..4 */
>=20



--4GTVpdpjtfavVn6M5UVVFvFYV7tCAJ4eE--

--MoxVCABf2F429fyxa4XuuuWS1ui9s1Tjl
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEEZmTnvaa2aYgexS51Fu8/ZMsgHZwFAlprqPUACgkQFu8/ZMsg
HZz/ZxAA2uHJqwi6HVgPIU1sryUqBkKBanL2EhGxLEacuVlcuNO0D/9kXZt/8+gu
rZgudRwDNMZhyJfJRarrenViKIkoKQSUhGppzBrFA8hSBBSmvoXIEoO3XsnstMwt
Xib+ma3261kR64Ld21QnD3W2PmUDZ4y6iRoFRv9a4M3SWytdOb0W+92U/SkGHOou
ozzz/MhBHBw+HtQzZzAsWTe5N0fU/wj8UkKx4XvNh/HPMGFI4CkaH0QkkONpEwme
deByyQf3hQ0rAB9u+MBwhCNR3hzxkTGLjx4n3PCsMJTSkmhWCY4Hfg/TBFs2PkO/
Q8aF7q6GgMUIkDJBJwf286SMvT4M6LInBA3/Cgo82Za+qFLw+uLu6kTuThut5XlU
f1gdiuVmJspBrBg5vZR7KdwJjP8OJNMHgm9VNfTWStE8Smf6jOSkbskHS6ut/eeO
lEm33yKjtPabtfVXAWbJkAXSuDf9ZjkCNNmEY2KAz1myvnJ+w1BuoZPbUFGjUf3P
xP98OVLTl7MqMj8wjKP9xxwzGpOlDfe7ap0mJQT/HqfjmRgCKrqxXLPYe+x7Sp4Z
Cy6imxS0fdna7NXNA9wYT0Sh7f3V+wBpQNH/f/u8qlCdylmuOLJZDWqV2DgTLdZ1
Br20kXdNCoCsWjJg/YB26PK1UXLAly/NysgZ8cKA7y8ASauChBE=
=mPK4
-----END PGP SIGNATURE-----

--MoxVCABf2F429fyxa4XuuuWS1ui9s1Tjl--

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from orthanc.universe-factory.net ([104.238.176.138]:52070 "EHLO
        orthanc.universe-factory.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751464AbeA3KrN (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 30 Jan 2018 05:47:13 -0500
Subject: Re: [PATCH 1/2] wireless: set correct mandatory rate flags
To: Johannes Berg <johannes@sipsolutions.net>
Cc: =?UTF-8?Q?Richard_Sch=c3=bctz?= <rschuetz@uni-koblenz.de>,
        linux-wireless@vger.kernel.org
References: <20170907154744.28357-1-rschuetz@uni-koblenz.de>
 <2f3b9bd7-f083-f46c-8c47-051019a6f495@universe-factory.net>
 <1517298191.2189.33.camel@sipsolutions.net>
From: Matthias Schiffer <mschiffer@universe-factory.net>
Message-ID: <82352a08-9002-e257-9721-30b7efc90a34@universe-factory.net> (sfid-20180130_114717_226273_906901FA)
Date: Tue, 30 Jan 2018 11:47:10 +0100
MIME-Version: 1.0
In-Reply-To: <1517298191.2189.33.camel@sipsolutions.net>
Content-Type: multipart/signed; micalg=pgp-sha512;
 protocol="application/pgp-signature";
 boundary="i7bGOTypSrrMZJieRTmsp88U6FsiatY1q"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--i7bGOTypSrrMZJieRTmsp88U6FsiatY1q
Content-Type: multipart/mixed; boundary="r83X3GjL0QiyGnIWTMtgPCvQ05SuHSKCO";
 protected-headers="v1"
From: Matthias Schiffer <mschiffer@universe-factory.net>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: =?UTF-8?Q?Richard_Sch=c3=bctz?= <rschuetz@uni-koblenz.de>,
 linux-wireless@vger.kernel.org
Message-ID: <82352a08-9002-e257-9721-30b7efc90a34@universe-factory.net>
Subject: Re: [PATCH 1/2] wireless: set correct mandatory rate flags
References: <20170907154744.28357-1-rschuetz@uni-koblenz.de>
 <2f3b9bd7-f083-f46c-8c47-051019a6f495@universe-factory.net>
 <1517298191.2189.33.camel@sipsolutions.net>
In-Reply-To: <1517298191.2189.33.camel@sipsolutions.net>

--r83X3GjL0QiyGnIWTMtgPCvQ05SuHSKCO
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 01/30/2018 08:43 AM, Johannes Berg wrote:
> On Fri, 2018-01-26 at 23:17 +0100, Matthias Schiffer wrote:
>>
>> I propose to revert this for now (I assume it's too late for 4.15, but=

>> hopefully the regression can be fixed in 4.15.1).
>=20
> I really don't think we should revert this, it fixes a real bug.
>=20
> We can easily switch the default though, would something like this
> help?

Working perfectly.

Tested-by: Matthias Schiffer <mschiffer@universe-factory.net>


>=20
> diff --git a/net/wireless/mesh.c b/net/wireless/mesh.c
> index 51aa55618ef7..b12da6ef3c12 100644
> --- a/net/wireless/mesh.c
> +++ b/net/wireless/mesh.c
> @@ -170,9 +170,28 @@ int __cfg80211_join_mesh(struct cfg80211_registere=
d_device *rdev,
>  		enum nl80211_bss_scan_width scan_width;
>  		struct ieee80211_supported_band *sband =3D
>  				rdev->wiphy.bands[setup->chandef.chan->band];
> -		scan_width =3D cfg80211_chandef_to_scan_width(&setup->chandef);
> -		setup->basic_rates =3D ieee80211_mandatory_rates(sband,
> -							       scan_width);
> +
> +		if (setup->chandef.chan->band =3D=3D NL80211_BAND_2GHZ) {
> +			int i;
> +
> +			/*
> +			 * Older versions selected the mandatory rates for
> +			 * 2.4 GHz as well, but were broken in that only
> +			 * 1 Mbps was regarded as a mandatory rate. Keep
> +			 * using just 1 Mbps as the default basic rate for
> +			 * mesh to be interoperable with older versions.
> +			 */
> +			for (i =3D 0; i < sband->n_bitrates; i++) {
> +				if (sband->bitrates[i].bitrate =3D=3D 10) {
> +					setup->basic_rates =3D BIT(i);
> +					break;
> +				}
> +			}
> +		} else {
> +			scan_width =3D cfg80211_chandef_to_scan_width(&setup->chandef);
> +			setup->basic_rates =3D ieee80211_mandatory_rates(sband,
> +								       scan_width);
> +		}
>  	}
> =20
>  	err =3D cfg80211_chandef_dfs_required(&rdev->wiphy,
>=20
> johannes
>=20



--r83X3GjL0QiyGnIWTMtgPCvQ05SuHSKCO--

--i7bGOTypSrrMZJieRTmsp88U6FsiatY1q
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEEZmTnvaa2aYgexS51Fu8/ZMsgHZwFAlpwTS4ACgkQFu8/ZMsg
HZzwbA/6A6SGammbchNy9L0dhcAtWwkuEuT9f98S3Bf2BB2HseBNgOmemn0HdK6x
P5otBgR83DJ1hWhwYqFlgNtVw56xcdsXhkgH0QhTUcN4F8xlZxSR7B3Rnl3bw16K
bzsYhx/7/G6oOvE98BgEhYx1Jt2XAFiMvfv0MVP1o/CSTMJeIT52H4WXqbywbFPv
uPX/aTXeVC4YBNtzILUrAPEav42S+SZkR0+1SYwgPKfTf+oOJYt7PEACA+bEglub
HN7ugdLSgaSVlwprNEnPtGnZkeZs07dwZIesDWcI/8OxCSkMqXDI+9HIQdQNe5Ve
rqEsBH3G+T0TawRHCQCaxJNcNNQzOVf1pTa9cXJG/aDvDar8B1ItJRj6IHgJ4L6u
/zR7abGR700V8iWdL/aspGmux9E68iFFI5bje5I7hOSwkSvwVBreLwY0C7i/+YU3
mEBP3NBC6cz9vDUa+c9odnUbds0stJJMZQQzz+un069pKnbntpvAFxuRoCl8Uien
XsTVuj29I2+5isqbfh+0+y5q0c7uI1wHN4qokPJVwNsyNNj8D5+rie7otCPLkNHZ
l4DV2QkpKNWi9lT0kuGPDvqldx0eDPjzH86qCfKo3A7jwlqxacH6O3KZVrcIgTKQ
o+/7rU5sFiET+TrcLDpE80gfyHgPO3jmdw5IQJNhj4YMt69nUYo=
=WQYh
-----END PGP SIGNATURE-----

--i7bGOTypSrrMZJieRTmsp88U6FsiatY1q--

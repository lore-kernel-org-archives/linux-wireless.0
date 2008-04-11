Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:44864 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757321AbYDKTnt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 11 Apr 2008 15:43:49 -0400
Subject: Re: [PATCH RFC] mac80211: Fixes n-band association problem with
	certain APs
From: Johannes Berg <johannes@sipsolutions.net>
To: Reinette Chatre <reinette.chatre@intel.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Abhijeet Kolekar <abhijeet.kolekar@intel.com>
In-Reply-To: <1207867745-26538-1-git-send-email-reinette.chatre@intel.com>
References: <1207867745-26538-1-git-send-email-reinette.chatre@intel.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-/dJk8pxzlI/OwbYkJi24"
Date: Fri, 11 Apr 2008 21:43:41 +0200
Message-Id: <1207943021.13354.76.camel@johannes.berg> (sfid-20080411_204357_890923_80FD6552)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-/dJk8pxzlI/OwbYkJi24
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On Thu, 2008-04-10 at 15:49 -0700, Reinette Chatre wrote:
> From: Abhijeet Kolekar <abhijeet.kolekar@intel.com>
>=20
> For WME(221) tag in beacon frames from certain n-only aps=C2=B7
> 5th bit is not set.So while parsing the beacon frame the wmm_info=C2=B7
> structure is used instead of wmm_param. wmm_info structure is=C2=B7
> never used to set bss->wmm_ie. While sending the association request to
> n-only ap it checks for wmm_ie. If it is set then only ieee80211_ht_cap
> is sent during association request.So n-only association fails.
> This patch fixes this problem by copying the WME information from wmm_inf=
o
> to bss->wmm_ie and thus enabling n-band association.

I haven't got a clue. I didn't even know there where two things,
wmm_param and wmm_info.

> Signed-off-by: Abhijeet Kolekar <abhijeet.kolekar@intel.com>
> Acked-by: Ron Rindjunsky <ron.rindjunsky@intel.com>
> ---
>  net/mac80211/mlme.c |   13 ++++++++++++-
>  1 files changed, 12 insertions(+), 1 deletions(-)
>=20
> diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
> index 83e8b49..ec2f722 100644
> --- a/net/mac80211/mlme.c
> +++ b/net/mac80211/mlme.c
> @@ -2668,7 +2668,18 @@ static void ieee80211_rx_bss_info(struct net_devic=
e *dev,
>  			bss->wmm_ie_len =3D elems.wmm_param_len + 2;
>  		} else
>  			bss->wmm_ie_len =3D 0;
> -	} else if (!elems.wmm_param && bss->wmm_ie) {
> +	} else if (elems.wmm_info &&
> +		    (!bss->wmm_ie || bss->wmm_ie_len !=3D elems.wmm_info_len ||
> +		     memcmp(bss->wmm_ie, elems.wmm_info,elems.wmm_info_len))) {
> +		kfree(bss->wmm_ie);
> +		bss->wmm_ie =3D kmalloc(elems.wmm_info_len + 2, GFP_ATOMIC);
> +		if (bss->wmm_ie) {
> +			memcpy(bss->wmm_ie, elems.wmm_info - 2,
> +			       elems.wmm_info_len + 2);
> +			bss->wmm_ie_len =3D elems.wmm_info_len + 2;
> +		} else
> +			bss->wmm_ie_len =3D 0;
> +	} else if (!elems.wmm_param && !elems.wmm_info && bss->wmm_ie) {
>  		kfree(bss->wmm_ie);
>  		bss->wmm_ie =3D NULL;
>  		bss->wmm_ie_len =3D 0;

--=-/dJk8pxzlI/OwbYkJi24
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR/+/bKVg1VMiehFYAQIR+A/+KKZy9G7AiL8P4c3QnEyXlC6Uql0KS6jc
+D9tel22Dqbs4zyRlcoWuZ6KfRlyvvgvx3z/UY6CLeqyewZDiW+W1t1b/2JE8cQh
8E/6HdEH3L6UOse4HR3SN2m6kj+yfsU9C0lYT4IkpvguL7deD0hGfe4ptn7MBNG7
YPFteq11Wrmi+3QkkIwXVzVzjrxP1HaiV8hCoWl1BCYCJ3VC/L2aI2haF+NW6I9E
B5LeZbkRMIwTAoeJecsmGxZRrPOL0IXKwahGW2KwQJbtuxsfOsIIfGMaUXapYQ0D
nM/ICZdlfy5g2mu+Dop8gj2MIryfsGjHWCM7b3wnhFUvWhIps9sAoQkOoys4VTwu
/J6LNRaA5pEl1BwmnHqzHkOsNg/ENmZB5s0fdaa4P9MbdgC6eM5iHVR07z35j5Pi
Rs8L0bh0v2YFKSRfJctWkJXRdxpCvXHwjaZ2cVrHqlK7b65bHi+u9WRQj6RFIly9
wDOWWOosiATdndcq/wKmyhuw+J6tMb05Faz5OWAESSEm0GqbsJHlqWncsdQlRmjg
+1/ruWHvckXLprAWZPMwquK66zcTiOBywUXoX25br8J/M8kn7dnVHXHdpll6IqgB
pHDd+yW8BhPGh+wqoURJl0YtdtIeXQfcU8yUO7PPWCwBtbtqKDCMqwjqJcNWKMpT
paWIeyDjY/w=
=/Mio
-----END PGP SIGNATURE-----

--=-/dJk8pxzlI/OwbYkJi24--


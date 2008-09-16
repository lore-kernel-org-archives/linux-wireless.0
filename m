Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:40555 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751141AbYIPGiT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Sep 2008 02:38:19 -0400
Subject: Re: [PATCH v2] mac80211: re-enable aggregation
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
In-Reply-To: <1221535073-6937-1-git-send-email-lrodriguez@atheros.com>
References: <1221535073-6937-1-git-send-email-lrodriguez@atheros.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-O3oZPPvsgh4zcQogacec"
Date: Tue, 16 Sep 2008 08:37:16 +0200
Message-Id: <1221547036.8916.1.camel@johannes.berg> (sfid-20080916_083823_606337_AC2CCBC3)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-O3oZPPvsgh4zcQogacec
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2008-09-15 at 20:17 -0700, Luis R. Rodriguez wrote:

> +/**
> + * is_part_ampdu - tells us whether this buffer is part of an AMPDU
> + *
> + * @skb: the buffer we want to check
> + * @hw: the &struct ieee80211_hw to check the queue mapping on
> + */
> +static inline bool is_part_ampdu(struct sk_buff *skb, struct ieee80211_h=
w *hw)
> +{
> +	return (skb_get_queue_mapping(skb) >=3D
> +		ieee80211_num_regular_queues(hw));
> +}
> +

This is making the patch needlessly large and makes it change drivers
etc, please just keep the flag and set it based on this in master xmit
after we've cleared the info.

johannes

--=-O3oZPPvsgh4zcQogacec
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIbBAABAgAGBQJIz1QYAAoJEKVg1VMiehFYSVMP+NbM4/idFlnAPKN/6fRKselu
/aY+vc7G95RIF7NctHeLXEutTzgc/0hYOwDxhFNsDEsQo3KsaD8ohh2UZ0ndzMmW
toOB9KiJhUcCRQai28w2SXyxfR+tq4VWZJGkQFPEq07HlGstQ3w9aLqxXRioIGbV
Vjr0PwpowAXf7RIoIcY6Wui0C2UKarOqejnfsWuVwf4x4/iqgoVONiGkw/q7bBFs
ODpA1cAuIvXP8UpFkVgh8AvQ1D/YFI5rzRj7rnJwRsGT1YZ3JK6djbxqygQHHvt0
MOZOq0SJSDcsoSViLQTMWcWqAg+yCdha+lzNcESMqeUN9OYH+auWykfA9LpcVedI
3aKFpcmtebcfNJLpN4pwSCElHicxKhu6NU0y5s0Vo0ZFqS9efgS+csd/aK7+zLOD
TH62gV5+BbaPREjxkl6XFGm3p/wgSbAEVajYeJkK/hIfDf+FemFMdQf6iK5uWQ1P
eSdaJL7QZ27v6L3iiaFfmr/8w9Ff+t2hxbC3b9jKDS3RaNbPBVRWGI+zYWl/djXd
6+MVMke7+TBVCXjkwnHVj4UcKv6ast1zfacPzt6eKBsJKpHeFzlw2s/0BTYhTFn1
5dX02AHL3twVXOGlvEy9u6QlZpbmeioWYeymFNjLTKrRYgS+uN1tj/ytwWey0tkX
OF788DWgc66dHS9UuCY=
=QHNZ
-----END PGP SIGNATURE-----

--=-O3oZPPvsgh4zcQogacec--


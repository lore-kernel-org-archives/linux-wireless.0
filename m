Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:44264 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755826AbZHEPlv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Aug 2009 11:41:51 -0400
Subject: Re: [PATCH] nl80211: fix attrtype and value for
 NL80211_ATTR_SUPPORTED_COMMANDS
From: Johannes Berg <johannes@sipsolutions.net>
To: Zhu Yi <yi.zhu@intel.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
In-Reply-To: <1249464510-21539-1-git-send-email-yi.zhu@intel.com>
References: <1249464510-21539-1-git-send-email-yi.zhu@intel.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-xNd9h+vQjphXSvThCiW7"
Date: Wed, 05 Aug 2009 17:41:41 +0200
Message-Id: <1249486901.6902.6.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-xNd9h+vQjphXSvThCiW7
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2009-08-05 at 17:28 +0800, Zhu Yi wrote:
> The patch fixes the misuse between attrtype and value for the
> CMD list nested in NL80211_ATTR_SUPPORTED_COMMANDS attribute.

No? It was this way intentionally.

> --- a/net/wireless/nl80211.c
> +++ b/net/wireless/nl80211.c
> @@ -520,7 +520,7 @@ static int nl80211_send_wiphy(struct sk_buff *msg, u3=
2 pid, u32 seq, int flags,
>  	 do {							\
>  		if (dev->ops->op) {				\
>  			i++;					\
> -			NLA_PUT_U32(msg, i, NL80211_CMD_ ## n);	\
> +			NLA_PUT_U32(msg, NL80211_CMD_ ## n, i);	\

This is an array, the index doesn't matter, and the value is the
supported command. You parse it with nla_for_each_nested()

johannes

--=-xNd9h+vQjphXSvThCiW7
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKeagxAAoJEODzc/N7+QmaLDoP/RLTeHAi8CMO1MvzHX7/8IJs
NtIDQrUstdiBfPSqX/jNX2Kg+i4FKsnlKsFvJjBsLZ7pIceXAzmF9DBDtO+YxSeX
mO1DMHlzQji2YhOcT2a+dT+2yV6Qq3kJ1a2SnR2ejIvHcajTdGePVZG5G9A04fcl
5hwEd+w6SZCL7B5gDDJWpbLrQsj3ohJePbqMHE4k0QAdvStRAm+uBm4RwDHzLFhw
voVD0tqeQevEWsLqtHkvP6R9qaaYo4ELfZtQgEM/iRqebOWuJhnRmsOuQKgt7kow
LsAmT3sBSuJsIx9LZdeM9jLqDYf+4D4AJ4pXluzXwixa2iVc0EUPOd3dYu3vVzTZ
MYak+knH6O2BQ1SabvfQz0YrWFz4NgdzktDG7AFASXhSsVzKcMPE2tsQ2Li7OC8v
O8xzVYoKDkQc/Hb4SB3ul29zn6t790pfLTAtluyY64qIDMajUmcf2YZ7QrDfIIGf
g/bFIAZSDcv/Pt9t2TLyIAbb/GGVyudhPPJR2hjVLLGr6u/f9Q0FruGnxPX66lFP
TSMQpNzVwPZmQlO+zdYmyQ6gDOHk7JFsOFfxrmxpMEwSShYSn/MEOYpo+fTYcQAz
636X+y/F4UDo0GwVCF4X9Xr8V0rbRmlyrgxaGVIDT3gfy194J//nWdIUtdiHmFn9
yeQgx+0KVH+GwW9IY9am
=PtQk
-----END PGP SIGNATURE-----

--=-xNd9h+vQjphXSvThCiW7--


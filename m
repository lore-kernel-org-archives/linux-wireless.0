Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:45133 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757411AbYFII65 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Jun 2008 04:58:57 -0400
Subject: Re: [PATCH 1/7] mac80211: add helpers for frame control testing
From: Johannes Berg <johannes@sipsolutions.net>
To: Harvey Harrison <harvey.harrison@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1212774671.6340.75.camel@brick> (sfid-20080606_195944_782545_6A2B1449)
References: <1212774671.6340.75.camel@brick>
	 (sfid-20080606_195944_782545_6A2B1449)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-hXYrenMkWcE9KAAFbsTT"
Date: Mon, 09 Jun 2008 09:41:05 +0200
Message-Id: <1212997265.698.55.camel@johannes.berg> (sfid-20080609_105901_710828_95D27153)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-hXYrenMkWcE9KAAFbsTT
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> +static inline int ieee80211_data_has_qos(__le16 fc)
> +{
> +	/*
> +	 * mask with QOS_DATA rather than IEEE80211_FCTL_STYPE as we just need
> +	 * to check the one bit
> +	 */
> +	return (fc &
> +	       cpu_to_le16(IEEE80211_FCTL_FTYPE | IEEE80211_STYPE_QOS_DATA)) =
=3D=3D
> +	       cpu_to_le16(IEEE80211_FTYPE_DATA | IEEE80211_STYPE_QOS_DATA);
> +}

Shouldn't that rather be _is_qos_data?

johannes

--=-hXYrenMkWcE9KAAFbsTT
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJITN6NAAoJEKVg1VMiehFYKdgP/1XSgyyLbSKG1q+mU0M2jXpE
hIjVLQhe3vXH9SjidLSvK/sCbw5LlDQNKD1hwJYt+wxEQBcK/gBtnzRTFadOPnSY
fOwAFqmnxIwIoCYGBewU7Lx3UKBCsR8dYepbkhu2umhpnCGyr1chMICNSrvwDJVH
xo3gTBVZLXFeJG1oBZ73ypfXIodHlWaQJcBu4nfworpUuQcRmCYZy+tMEzWz9Fxo
fgg26Ye9dkIX5vEI13htrH5z7YjIXPNen7jmV++yAgyt54q1C5ZFDF/IvqDPlGsX
8nzFKG+urcFsTmRwXbWosVCsmJrFz63ALgy04aYjUjwpmRrgyi7KFtW5K/qA4e8o
/SKH2rCgpuKOJ9pwRbyxkhaX0OblUv0g7v5GJ+4bkKM7UmQfnWJELcfpYkETOEzf
P+QzUCcQFBzV/vYOhfC5XpzfPXi2wH29Aa1ax9nv9R4yOgy3r356VqgWgdthk5dg
lLn19IEOp2CKWsK2wTJnZVDyYC7TmEmOjRqq0+RAop7DXhn66CH3+K+8ZuhTod4e
NDKZwjkAzR9wdI7LGzsEBaggUGnnernPuG+HBPRrh4ixzGWmsKygWNyocWfLzyA0
cY7Tim9EpkYQUiDzvT6Y/3ETwBqd1KOcgNGA7tf93qxlkw6GQYnzRuK8C40CTGYT
TVSRUKG5meuV5AQo1NRg
=/LM6
-----END PGP SIGNATURE-----

--=-hXYrenMkWcE9KAAFbsTT--


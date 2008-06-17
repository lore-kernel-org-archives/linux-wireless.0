Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:48707 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753754AbYFQQ4C (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Jun 2008 12:56:02 -0400
Subject: Re: [RFC PATCH 3/7] 802.11w: Add BIP (AES-128-CMAC)
From: Johannes Berg <johannes@sipsolutions.net>
To: Jouni Malinen <j@w1.fi>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <20080617155904.082926456@localhost>
References: <20080617154008.883383150@localhost>
	 <20080617155904.082926456@localhost>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-CC9/GNwlKhDzhdFCV/bV"
Date: Tue, 17 Jun 2008 18:55:14 +0200
Message-Id: <1213721714.3803.83.camel@johannes.berg> (sfid-20080617_185607_533469_6BF9CA00)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-CC9/GNwlKhDzhdFCV/bV
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> +/* Management MIC information element (IEEE 802.11w) */
> +struct ieee80211_mmie {
> +	u8 element_id;
> +	u8 length;
> +	u8 key_id[2]; /* little endian, but may be unaligned */

Since you say the struct is packed you should be able to use __le16 just
fine.

> +	if ((tx->key->flags & KEY_FLAG_UPLOADED_TO_HARDWARE)) {

I think one set of parentheses suffices ;)

> +	if (skb_tailroom(skb) < sizeof(*mmie)) {
> +		if (pskb_expand_head(skb, skb_headroom(skb),
> +				     skb_tailroom(skb) + sizeof((*mmie)),
> +				     GFP_ATOMIC) < 0)
> +			return TX_DROP;
> +	}

I tried ensure pskb_expand_head is only called at most once when the
frame is handed to master_start_xmit to avoid problems with skb truesize
and such. Could you add the necessary space at that point already,
possibly simply reserving max(mmic-len, mmie-len) or so instead of the
current mmic-len (I think)? I'd hate to add back calls to
pskb_expand_head at other places, and it's only 18 bytes so not really
huge.

> +	if ((rx->fc & IEEE80211_FCTL_FTYPE) !=3D IEEE80211_FTYPE_MGMT)
> +		return RX_CONTINUE;

Harvey just added a bunch of helper inlines to include/linux/ieee80211.h
for stuff like that, I think you could use one of them here.

> +       mmie =3D (struct ieee80211_mmie *)
> +               (skb->data + skb->len - sizeof(*mmie));
> +       if (mmie->element_id !=3D WLAN_EID_MMIE ||
> +           mmie->length !=3D sizeof(*mmie) - 2)
> +               return RX_DROP_UNUSABLE; /* Invalid MMIE */

Is that what the draft says? Because iterating the IEs would be
different, this means you could potentially have something like a vendor
IE last that encapsulates the MMIE including type/len fields, which
should probably not be used?

> +	/* Remove MMIE */
> +	skb_trim(skb, skb->len - sizeof(*mmie));

Is that actually necessary? Since it's an IE, it should be ignored by
all other code, no? Not that it matters though.

johannes

--=-CC9/GNwlKhDzhdFCV/bV
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJIV+xsAAoJEKVg1VMiehFYFhkP/1fo3bpdZWrDdNzQYwrlFRTA
4tUFR5pDZk+45yC94+HqfOw5AxjlZ8Rnt3JN7zK1BewQQTMQ3kgEL9+JJcntKVx/
an4Vu90p0NqVI91D9wYh9q+0uyM/v9zlUNE+glCXOzYI4gQpk0Hmlw5j9r23pnJa
CVcBhr65LCHMpCGhhsW0xzNwGdQgn+tb/V/kojcmIkCOqCuE9xDV5zKYMGCgUMdT
OWse8Lu5/vT0VF3J6CA8Z0HY6eO3PDNl3bBAbap+N2FiUvAA9c0aR1SySnOryWow
Vw0CZnshsAEMxbYQgyHkkSrQgAcA+7+MMFTnEwUVh6StoTBqV0BMHz7J10YcdIKU
mi6008ffDSszpdHX2LuHnIVt67qlrdKVLI+0sLtq7onttWexDYOvSHBWJwU7Oqg/
M/IgVDSyeHxW3EeGjYSZr0ekObB2WcqHo9HsUM87X8pSxUVghseFqJPFrpp8bN1g
5NCe6jx8uUpgBF3NFTAGHNUkqV5XCeXlTDyqtfGLfvZ+r2ilYVjGAka6RWvFNeNE
wKgRZq7pEKUSy/OFotUA+mbIW+/lixNkkchnillUa/fwl7/08cBYw95vpVd5lXeP
HMsVYY2LycqLHDOtpDwIjOQBh7ZkZew9Aj1AqETmlEPwxNFWzIMDlut+UmN1cmeu
wCKv0F3tQGNfCqcx6CcE
=lRCQ
-----END PGP SIGNATURE-----

--=-CC9/GNwlKhDzhdFCV/bV--


Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:54800 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750986AbYFTGne (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 Jun 2008 02:43:34 -0400
Subject: Re: [RFC-PATCH] mac80211: add helpers for skb manipulation
From: Johannes Berg <johannes@sipsolutions.net>
To: Harvey Harrison <harvey.harrison@gmail.com>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1213939944.6591.13.camel@brick> (sfid-20080620_073239_646166_FB02DC7B)
References: <1213939944.6591.13.camel@brick>
	 (sfid-20080620_073239_646166_FB02DC7B)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-Yn+uIw/kXYoQLHyeQrUJ"
Date: Fri, 20 Jun 2008 08:42:54 +0200
Message-Id: <1213944174.8967.124.camel@johannes.berg> (sfid-20080620_084337_814933_7EB099A5)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-Yn+uIw/kXYoQLHyeQrUJ
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> +	/* Remove QOS if present */
> +	hdr =3D (struct ieee80211_hdr *)skb->data;
> +	if (ieee80211_is_data_qos(hdr->frame_control)) {
> +		hdr->frame_control &=3D ~cpu_to_le16(IEEE80211_STYPE_QOS_DATA);
> +		ieee80211_skb_trim_iv_icv(skb, IEEE80211_QOS_CTL_LEN, 0);

Maybe you should rename that if you're going to use it for something
other than IV/ICV :)

And wouldn't it actually be more efficient in this case to just
calculate hdrlen once?

johannes

--=-Yn+uIw/kXYoQLHyeQrUJ
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJIW1FpAAoJEKVg1VMiehFYqNYP/jeM6EosEIliBQZOl2fl4MtZ
ECEn4SjACX78Y4FTP2GOkgxuJPY3qSlSzDH6Y3rkD8HXtHojx7Fci+6+L3b5JRsn
U0DO5+BeQwbBvlO/sPMYbvijVc7FA5LQoIdnQSz1+OkMDsTW6hxe8M90smUsVWBg
fB/b+IDtlGCgijwP8zGlGkYnVP2OyVnz01huYks9hIbAfwLknJaD893Sako48mFN
DWyqFPWqWs/4rTP1T0YMhBp9F/JE3i8lM0oeonEg8tbuM8ovDesq/UKjhqg5vJM4
1oLof1Qih1vn/s2nWitbvAHzQGTH3iOQzMz/YkJ/L5ur1c3dDz0XyBpAOFT5+ZNk
75P2cj7+Ye4OvrzUMG4XGsKErT22pc8qhC1xjRnLt+8G5/vtx/Tza/RLxUKY89Iv
MFzN4bsHmAwvKJ8C/HRwj8ZN/mF2oqkNRtu8uc8r3VFWbXF+ZVBU3hxSwyMfn3n3
bvY1573BZ4U7M+tzgoHZ+swFwc46xDIuqdq/gVScZowkqEjs2aYp/S0CycVfXAiB
Yl5r+4gMsgSI+fTPMMMwd4q5+BE4FM+HXka7iXIzygovilL5dj72a28Ct0OrTVZX
1rqtSL0pmD7RBM2x6mbW+aCYqqM+Opg5DGeDhIqOEE0broEUOhOt0Q/b3pHXsFDO
tcTj53Jnp9EuxkFR637V
=IT8z
-----END PGP SIGNATURE-----

--=-Yn+uIw/kXYoQLHyeQrUJ--


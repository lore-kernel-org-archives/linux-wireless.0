Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:60456 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932369AbZHVHpn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 22 Aug 2009 03:45:43 -0400
Subject: Re: [PATCH] mac80211 : fix a race with update_tkip_key
From: Johannes Berg <johannes@sipsolutions.net>
To: gregor kowski <gregor.kowski@gmail.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <83a869cd0908211513k2e14ba40k251aa8a1e7393a77@mail.gmail.com>
References: <83a869cd0908211513k2e14ba40k251aa8a1e7393a77@mail.gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-ZpldJLr5on3oeKXVlnRM"
Date: Sat, 22 Aug 2009 09:45:41 +0200
Message-Id: <1250927141.23605.3.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-ZpldJLr5on3oeKXVlnRM
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sat, 2009-08-22 at 00:13 +0200, gregor kowski wrote:
> The mac80211 tkip code won't call update_tkip_key, if some rx packets

s/,// s/rx //

> get received without KEY_FLAG_UPLOADED_TO_HARDWARE. This can happen on

s/get/are/

> first packet because the hardware key stuff is called asynchronously with
> todo workqueue.
>=20
> This patch workaround that by tracking if we send the key to hardware.

s/send/sent/, s/hardware/the driver/


> +enum ieee80211_internal_tkip_initialized {
> +	TKIP_INITIALIZED_NONE,
> +	TKIP_INITIALIZED_PHASE1,
> +	TKIP_INITIALIZED_UPDATE_KEY,
> +};

Those constants and the enum itself really need better names. This way,
there's no way to understand what it means without reading all the code.

johannes

--=-ZpldJLr5on3oeKXVlnRM
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKj6IiAAoJEODzc/N7+Qmax7IP/RqVln6JBWQTVl+5Zim79e1W
uhBjIkBd4UPcK8uIsrEHciXJRuiX30fZIRk3j9TmXbPPy6o2Y6xaIvMneOFqDAXq
+oc5T5XOgByXbf3wpniaKeeiAg1zbe6CHZ6YWOY1kLDwixRg+uFDDyNRGmCTmBcI
WVMsREXHSLgJQ1J058+v+bzfbTY1FO3WNbTramlx+ABbncVfRV9chsCIwLPT2i+W
GoAuWgFKnFwg52LYh9ASy3PTAO5B+urLfEkZYPRr6VqMiCZIcEWNB/SDec4xtaIa
KCVY/UvCJTNd1LgKly0qr0CJXxL9MsxP8dhIEwklMg5e+B6+7/oUWjki9DlNnAtf
scnSKNqz4sVchPEK3QwIFRaF7qoh8wG2ByGqlpWhcKEjF/yqC8/MwRRVOW4tExKC
Dgs3zXlYgNqNuhIfq0JwLwdZZKkrvMlwePT2C9W12BU2jlVj74AWkA9jS08YwrpV
/zrRVGEIVYoJ9Ym+MKDrcyAogfAaA/d8pnAA8Fbd7fB1rgapJ7hlwFu4olGNnE98
zMIlvNcHaGpsVsjJenu9voWHHiKLfS9yjZ+F+1PyfbY324oZZphW1tROw4Vh5Xj7
RBnUg1SRf36mqQqn2+Uc5BHLsaJjekEsMo4XIxshFJvWF+/0RSPui/0Jro8C4TSi
a2P95QJkHDBjTMIe0uiY
=eBhd
-----END PGP SIGNATURE-----

--=-ZpldJLr5on3oeKXVlnRM--


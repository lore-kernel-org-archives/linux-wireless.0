Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:46836 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752880AbYGHXFX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Jul 2008 19:05:23 -0400
Subject: Re: [PATCH 5/6v2] mac80211: rx.c/tx.c remove more users of
	tx/rx_data->fc
From: Johannes Berg <johannes@sipsolutions.net>
To: Harvey Harrison <harvey.harrison@gmail.com>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <1215555934.476.52.camel@brick> (sfid-20080709_002538_307988_869EF96A)
References: <1215550044.476.43.camel@brick>
	 (sfid-20080708_224734_565441_65F98FD9)  <1215552534.3670.20.camel@johannes.berg>
	 <1215553540.476.49.camel@brick>
	 (sfid-20080708_234544_948979_2D1B0842)  <1215554768.3670.22.camel@johannes.berg>
	 <1215555934.476.52.camel@brick> (sfid-20080709_002538_307988_869EF96A)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-ZCrZ6um2sKbwc8gIyM2N"
Date: Wed, 09 Jul 2008 01:04:37 +0200
Message-Id: <1215558277.3670.24.camel@johannes.berg> (sfid-20080709_010526_915968_1F81FE58)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-ZCrZ6um2sKbwc8gIyM2N
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2008-07-08 at 15:25 -0700, Harvey Harrison wrote:
> Those functions that still use ieee80211_get_hdrlen are moved over
> to use the little endian frame control.

> -	switch (fc & (IEEE80211_FCTL_TODS | IEEE80211_FCTL_FROMDS)) {
> -	case IEEE80211_FCTL_TODS:
> -		/* BSSID SA DA */
> -		memcpy(dst, hdr->addr3, ETH_ALEN);
> -		memcpy(src, hdr->addr2, ETH_ALEN);
> -
> +	switch (hdr->frame_control &
> +		cpu_to_le16(IEEE80211_FCTL_TODS | IEEE80211_FCTL_FROMDS)) {
> +	case __constant_cpu_to_le16(IEEE80211_FCTL_TODS):
>  		if (unlikely(sdata->vif.type !=3D IEEE80211_IF_TYPE_AP &&
>  			     sdata->vif.type !=3D IEEE80211_IF_TYPE_VLAN))
>  			return -1;
>  		break;

Looks good, but didn't you just lose all the memcpys?

johannes

--=-ZCrZ6um2sKbwc8gIyM2N
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJIc/KBAAoJEKVg1VMiehFYza8P/3kzKAgK7m1WDsJ0fTbtEdhe
B+6bi2581Po3MPCVd82qZ12eE+VrglHi8yNhT3MJeyIoXkiwJAPyBYOnym9exVbm
zLtsrenS8uEkdlY0RAlXvzFBXZXhe5st3Bjk1VBt1KLZXgLj9MwEE0tP2O+X6WRZ
QflVtlsJvWIALxoH7eOeKoOKiJ3+LsbIuWgF2OYc6jBEwp0nJcxn0q8LwNAkE/nz
9Ifi8U1tBQnbhXVeVSQyhvvE8p5q/Ld341Oex98IE+2Nop5ypcxiHB50BFqO2U4U
dXmhmzGvjlhjV4FjdTPo0hWxOChJkhes4+ISeLMDsoXmeZeyh2oOVh8hRmjncUw8
UHTn75wbnoRtjsGq6zn+5/kKUM51nhLpiOt1kijm/gIJtQChV5i+OQvfQv3KXsb9
x08zoCEGrfAXPUqZOVnnrU+3D8cGDTMKuXtERo319aMIGPR6aH1XgER1YLri/fmH
SnuHlK7Wi2YZ6H93IW6Sl8olGi2LbFAETZs2wjyh70mGwtyM2wKAMzspk90mySyd
ZC85ml+oJQb5rjuxfiCdE+SHIbIzBZy66+a7JyXzZN7KHIq8EdWoZDttmSg9wCbL
RgUgQvNwIt4feNn3D+sWKPtxaqpKoqT72ohSiFLYz3ocfyYsR+uhIVGDqvaE8BHS
qc/oG47ENbt11e8TSNGD
=XwqU
-----END PGP SIGNATURE-----

--=-ZCrZ6um2sKbwc8gIyM2N--


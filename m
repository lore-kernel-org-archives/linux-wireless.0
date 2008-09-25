Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:51124 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751556AbYIYErK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 25 Sep 2008 00:47:10 -0400
Subject: Re: [PATCH] wireless: consolidate on a single escape_essid
	implementation
From: Johannes Berg <johannes@sipsolutions.net>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1222294536-24367-1-git-send-email-linville@tuxdriver.com> (sfid-20080925_010455_582253_D66BE03B)
References: <>  <1222294536-24367-1-git-send-email-linville@tuxdriver.com>
	 (sfid-20080925_010455_582253_D66BE03B)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-eO5pxeOY4qUVuNxXQt8+"
Date: Thu, 25 Sep 2008 06:46:23 +0200
Message-Id: <1222317983.10563.20.camel@johannes.berg> (sfid-20080925_064714_797821_C549800C)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-eO5pxeOY4qUVuNxXQt8+
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2008-09-24 at 18:15 -0400, John W. Linville wrote:
> This is also an excuse to create the long rumored lib80211 module...

Let's also take the chance to clean up the mess Intel has, once again,
created here.

>  		switch (info_element->id) {
>  		case MFIE_TYPE_SSID:
> -			if (ieee80211_is_empty_essid(info_element->data,
> -						     info_element->len)) {
> +			if (is_empty_essid(info_element->data,
> +					   info_element->len)) {
>  				network->flags |=3D NETWORK_EMPTY_ESSID;
>  				break;
>  			}

You can remove the whole NETWORK_EMPTY_ESSID flag and this whole test;
the code slightly below needs to take care to actually escape the SSID
for the debug output.

> @@ -1411,7 +1412,7 @@ static int ieee80211_handle_assoc_resp(struct ieee8=
0211_device *ieee, struct iee
>  			network->mode |=3D IEEE_B;
>  	}
> =20
> -	if (ieee80211_is_empty_essid(network->ssid, network->ssid_len))
> +	if (is_empty_essid(network->ssid, network->ssid_len))
>  		network->flags |=3D NETWORK_EMPTY_ESSID;

drop the whole if
=20
> =20
> -	if (ieee80211_is_empty_essid(network->ssid, network->ssid_len))
> +	if (is_empty_essid(network->ssid, network->ssid_len))
>  		network->flags |=3D NETWORK_EMPTY_ESSID;

ditto.

that leaves once place using the NETWORK_EMPTY_ESSID flag, in
ieee80211_wx.c:

        /* Add the ESSID */
        iwe.cmd =3D SIOCGIWESSID;
        iwe.u.data.flags =3D 1;
        if (network->flags & NETWORK_EMPTY_ESSID) {
                iwe.u.data.length =3D sizeof("<hidden>");
                start =3D iwe_stream_add_point(info, start, stop,
                                             &iwe, "<hidden>");
        } else {
                iwe.u.data.length =3D min(network->ssid_len, (u8) 32);
                start =3D iwe_stream_add_point(info, start, stop,
                                             &iwe, network->ssid);
        }

which is of course *completely* *wrong*. There's no excuse for messing
up the values passed to userspace like that.

> +const char *escape_essid(const char *essid, u8 essid_len)
> +{
> +	static char escaped[IW_ESSID_MAX_SIZE * 2 + 1];
> +	const char *s =3D essid;
> +	char *d =3D escaped;
> +
> +	if (is_empty_essid(essid, essid_len)) {
> +		memcpy(escaped, "<hidden>", sizeof("<hidden>"));
> +		return escaped;
> +	}

Once you've done the above, is_empty_essid is only used here. I'll leave
it to you whether you want to print <hidden> or not, I'd prefer if the
function was to just escape the ASCII-NULs as normal since then you can
actually distinguish the various forms of hidden SSIDs which might help.
Maybe that needs quotes around the escaped SSID then.

> +	essid_len =3D min(essid_len, (u8) IW_ESSID_MAX_SIZE);
> +	while (essid_len--) {
> +		if (*s =3D=3D '\0') {
> +			*d++ =3D '\\';
> +			*d++ =3D '0';
> +			s++;
> +		} else {
> +			*d++ =3D *s++;
> +		}
> +	}
> +	*d =3D '\0';
> +	return escaped;
> +}
> +EXPORT_SYMBOL(escape_essid);

Also, we could take the chance to stop making Jean's mistake in calling
this thing the _E_SSID, there's no such thing, it's Jean's invention,
based on his misguided thought that this might somehow be less confusing
to the user.

johannes

--=-eO5pxeOY4qUVuNxXQt8+
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJI2xebAAoJEKVg1VMiehFYySUP/2LDuuM1RK0Jk0kAgW10NvNk
kLMs4f6RK5lpXdiKyo/EPn0PoisGsuZKeDi9bZfRqko3kjwePngFRsNXDKRJHH1i
ufgOC6VE0oBjjupG8Z65YcVf3L83X3IW381VOIOWUmMf2RKaqG66J28sn8D8u5fu
3e+JT1vpE9+JyuLDxj58aK8VHZe0PC6z2kEokaBuxSN1l7bUV8X6b0druRqHSFN/
KhyTGpJoOA+oZFR1ucPJKbqasykOyAdblNe0Np1afo0tZDQlxw7+movguuGd2vJs
WKBKGpOo8Jt/ETdCDQUPt4ALyVfMegGdfhpUAT7iiS0ppZ7eSDLdGLrPrvyzM074
h+44YT9PfTa4WK3JEs+gZ31mcbda1I7zJ0mZVbUwsY1YTFFuHbNwda1WX2hfIKG5
CJyeX0Wh40sjyDubm6rgG/unsSM1ktpu9uKjXDtbgiRaSDcI1EV+R4ZXTUoECZgu
u+imzWFE2mrGrLKZPijlptM51P1VutPXYPdHQJ7EdK8tRKVKzknQJYqD8a7ZZgww
9CD1slGm0VchH1vScVbxL3af9GX4JcuMZyQySHZ8EZbWfBvwwg8xEBDxRVwrB0wm
qR2gHfJJe72pAi/7EjPVv0SqLSQQ/X1f/jpCOx/QPnoVYoButQRE9YT8c1AT6wYj
O4tGFmjZVrhRv02zSOrv
=aKDt
-----END PGP SIGNATURE-----

--=-eO5pxeOY4qUVuNxXQt8+--


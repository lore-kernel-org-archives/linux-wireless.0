Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:35195 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760693AbZANRbN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Jan 2009 12:31:13 -0500
From: Michael Buesch <mb@bu3sch.de>
To: Larry Finger <Larry.Finger@lwfinger.net>
Subject: Re: [PATCH V2] b43: Eliminate compilation warning in b43_op_set_key
Date: Wed, 14 Jan 2009 18:30:58 +0100
Cc: John W Linville <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
References: <496e1dad.5mYJIKpzG2eoWa+t%Larry.Finger@lwfinger.net>
In-Reply-To: <496e1dad.5mYJIKpzG2eoWa+t%Larry.Finger@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Message-Id: <200901141830.58641.mb@bu3sch.de> (sfid-20090114_183118_290720_4A62A524)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wednesday 14 January 2009 18:15:25 Larry Finger wrote:
> A recent pull from wireless testing generates the following warning:
> =20
>    CC [M]  drivers/net/wireless/b43/main.o
>  drivers/net/wireless/b43/main.c: In function =E2=80=98b43_op_set_key=
=E2=80=99:
>  drivers/net/wireless/b43/main.c:3636: warning: pointer type mismatch
>  in conditional expression
>=20
> This fix was suggested by Johannes Berg <johannes@sipsolutions.net>.
>=20
> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>

ACK

> ---
>=20
> Index: wireless-testing/drivers/net/wireless/b43/main.c
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- wireless-testing.orig/drivers/net/wireless/b43/main.c
> +++ wireless-testing/drivers/net/wireless/b43/main.c
> @@ -3535,6 +3535,9 @@ static int b43_op_set_key(struct ieee802
>  	u8 algorithm;
>  	u8 index;
>  	int err;
> +#if B43_DEBUG
> +	static const u8 bcast_addr[ETH_ALEN] =3D {0xff, 0xff, 0xff, 0xff, 0=
xff, 0xff};
> +#endif
> =20
>  	if (modparam_nohwcrypt)
>  		return -ENOSPC; /* User disabled HW-crypto */
> @@ -3633,7 +3636,7 @@ out_unlock:
>  		b43dbg(wl, "%s hardware based encryption for keyidx: %d, "
>  		       "mac: %pM\n",
>  		       cmd =3D=3D SET_KEY ? "Using" : "Disabling", key->keyidx,
> -		       sta ? sta->addr : "<group key>");
> +		       sta ? sta->addr : bcast_addr);
>  		b43_dump_keymemory(dev);
>  	}
>  	write_unlock(&wl->tx_lock);
>=20
>=20



--=20
Greetings, Michael.
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

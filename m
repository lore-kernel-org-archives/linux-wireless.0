Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:56061 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754509AbZANNhe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Jan 2009 08:37:34 -0500
Date: Wed, 14 Jan 2009 08:34:18 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Michael Buesch <mb@bu3sch.de>,
	Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH] b43: Eliminate compilation warning in b43_op_set_key
Message-ID: <20090114133417.GB18634@tuxdriver.com> (sfid-20090114_143738_934897_D3E0D8BB)
References: <496d2fc9.UiHMYJR2melvWyoO%Larry.Finger@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <496d2fc9.UiHMYJR2melvWyoO%Larry.Finger@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jan 13, 2009 at 06:20:25PM -0600, Larry Finger wrote:
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
> ---
>=20
> Index: wireless-testing/drivers/net/wireless/b43/main.c
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- wireless-testing.orig/drivers/net/wireless/b43/main.c
> +++ wireless-testing/drivers/net/wireless/b43/main.c
> @@ -3630,10 +3630,12 @@ static int b43_op_set_key(struct ieee802
> =20
>  out_unlock:
>  	if (!err) {
> +		u8 bcast[ETH_ALEN];
> +		memset(bcast, 0xff, ETH_ALEN);

Isn't there a statically-allocated array w/ the broadcast MAC in it
somewhere already?

>  		b43dbg(wl, "%s hardware based encryption for keyidx: %d, "
>  		       "mac: %pM\n",
>  		       cmd =3D=3D SET_KEY ? "Using" : "Disabling", key->keyidx,
> -		       sta ? sta->addr : "<group key>");
> +		       sta ? sta->addr : bcast);
>  		b43_dump_keymemory(dev);
>  	}
>  	write_unlock(&wl->tx_lock);
>=20

--=20
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

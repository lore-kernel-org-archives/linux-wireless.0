Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from web23104.mail.ird.yahoo.com ([217.146.189.44]:30122 "HELO
	web23104.mail.ird.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750899AbZA0IjT convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Jan 2009 03:39:19 -0500
Date: Tue, 27 Jan 2009 08:39:17 +0000 (GMT)
From: Hin-Tak Leung <htl10@users.sourceforge.net>
Reply-To: htl10@users.sourceforge.net
Subject: Re: [PATCH] rtl8187: Fix error in setting OFDM power settings for RTL8187L
To: John W Linville <linville@tuxdriver.com>,
	Larry Finger <Larry.Finger@lwfinger.net>
Cc: barreyromartin@gmail.com,
	Herton Ronaldo Krzesinski <herton@mandriva.com.br>,
	linux-wireless@vger.kernel.org
In-Reply-To: <497e7ab0.kLnSOwAkXc2Qgtkb%Larry.Finger@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Message-ID: <117528.49182.qm@web23104.mail.ird.yahoo.com> (sfid-20090127_093924_176215_03FA07E7)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--- On Tue, 27/1/09, Larry Finger <Larry.Finger@lwfinger.net> wrote:

> After reports of poor performance, a review of the latest
> vendor driver
> (rtl8187_linux_26.1025.0328.2007) for RTL8187L devices was
> undertaken.
>=20
> A difference was found in the code used to index the OFDM
> power tables. When
> the Linux driver was changed, my unit works at a much
> greater range than
> before. I think this fixes Bugzilla #12380 and has been
> tested by at least
> two other users.

What exactly does this change do? it seems to just bias the value of of=
dm into higher values:

0-15 -> 10-25
15-  -> 25

Also, the first "ofdm_power =3D min(ofdm_power, (u8)35);" after the cha=
nge chunk has no effect, since the value from the changed code would cl=
ip at 25. You could remove that line...


>=20
> Signed-off-by: Larry Finger
> <Larry.Finger@lwfinger.net>
> Tested-by: Mart=EDn Ernesto Barreyro
> <barreyromartin@gmail.com>
> Cc: Stable <stable@kernel.org>

Acked-by: Hin-Tak Leung <htl10@users.sourceforge.net>


> ---
>=20
> John,
>=20
> This material should be included in 2.6.29. Although I have
> Cc'd stable, the
> patch will need to be respun due to the file renaming.
>=20
> Larry
> ---
>=20
> Index:
> wireless-testing/drivers/net/wireless/rtl818x/rtl8187_rtl8225.c
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> ---
> wireless-testing.orig/drivers/net/wireless/rtl818x/rtl8187_rtl8225.c
> +++
> wireless-testing/drivers/net/wireless/rtl818x/rtl8187_rtl8225.c
> @@ -285,6 +285,10 @@ static void
> rtl8225_rf_set_tx_power(stru
>  	ofdm_power =3D priv->channels[channel - 1].hw_value
> >> 4;
> =20
>  	cck_power =3D min(cck_power, (u8)11);
> +	if (ofdm_power > (u8)15)
> +		ofdm_power =3D 25;
> +	else
> +		ofdm_power +=3D 10;
>  	ofdm_power =3D min(ofdm_power, (u8)35);
> =20
>  	rtl818x_iowrite8(priv, &priv->map->TX_GAIN_CCK,
> @@ -536,7 +540,10 @@ static void
> rtl8225z2_rf_set_tx_power(st
>  	cck_power +=3D priv->txpwr_base & 0xF;
>  	cck_power =3D min(cck_power, (u8)35);
> =20
> -	ofdm_power =3D min(ofdm_power, (u8)15);
> +	if (ofdm_power > (u8)15)
> +		ofdm_power =3D 25;
> +	else
> +		ofdm_power +=3D 10;
>  	ofdm_power +=3D priv->txpwr_base >> 4;
>  	ofdm_power =3D min(ofdm_power, (u8)35);
> =20
> ---


     =20
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

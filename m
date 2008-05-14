Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:2583 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751245AbYENUUk (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 May 2008 16:20:40 -0400
Date: Wed, 14 May 2008 16:08:11 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Andrea Merello <andrea.merello@gmail.com>
Cc: linux-wireless@vger.kernel.org,
	Alessandro Di Marco <dmr@c0nc3pt.com>
Subject: Re: [PATCH] Rtl8180 grf5101 ch14
Message-ID: <20080514200811.GB15712@tuxdriver.com> (sfid-20080514_222105_324434_C4425F21)
References: <c68f135e0805100434h241995fqc89f1acfc5746bc1@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <c68f135e0805100434h241995fqc89f1acfc5746bc1@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, May 10, 2008 at 01:34:16PM +0200, Andrea Merello wrote:
> Rtl8180: fix wrong parameter in RF code function invokation for gct r=
adio
>=20
> The grf5101 RF code needs to invoke grf5101_write_phy_antenna every t=
ime the
> channel is being switch.
>=20
> This should be done passing the channel number to that function.
> Incorrectly we were passing the same value that is written on the
> channel RF register.
> This may cause problems when operating on ch 14.
>=20
> This patch fixes it.
>=20
> Thanks to Alessandro Di Marco who found this issue!
>=20
>=20
> signed-off-by: Andrea Merello <andreamrl@tiscali.it>
> ---
>=20
> --- a/drivers/net/wireless/rtl8180_grf5101.c    2008-02-02
> 14:48:52.000000000 +0100
> +++ b/drivers/net/wireless/rtl8180_grf5101.c    2008-02-02
> 14:52:59.000000000 +0100
> @@ -87,7 +87,7 @@ static void grf5101_rf_set_channel(struc
>         write_grf5101(dev, 0x0B, chan);
>         write_grf5101(dev, 0x07, 0x1000);
>=20
> -       grf5101_write_phy_antenna(dev, chan);
> +       grf5101_write_phy_antenna(dev, conf->channel);
>  }
>=20
>  static void grf5101_rf_stop(struct ieee80211_hw *dev)

  CC [M]  drivers/net/wireless/rtl8180_grf5101.o
drivers/net/wireless/rtl8180_grf5101.c: In function =E2=80=98grf5101_rf=
_set_channel=E2=80=99:
drivers/net/wireless/rtl8180_grf5101.c:91: warning: passing argument 2 =
of =E2=80=98grf5101_write_phy_antenna=E2=80=99 makes integer from point=
er without a cast

This one is also whitespace-damaged...

John
--=20
John W. Linville
linville@tuxdriver.com
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

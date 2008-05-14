Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:2585 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751433AbYENUUn (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 May 2008 16:20:43 -0400
Date: Wed, 14 May 2008 16:07:29 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Andrea Merello <andreamrl@tiscali.it>
Cc: linux-wireless@vger.kernel.org,
	Alessandro Di Marco <dmr@c0nc3pt.com>
Subject: Re: [PATCH] Rtl8180 sa2400 ch14
Message-ID: <20080514200729.GA15712@tuxdriver.com> (sfid-20080514_222104_601830_4F4DAB57)
References: <c68f135e0805100430s668492b0l56107f1fa4fc4ff7@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <c68f135e0805100430s668492b0l56107f1fa4fc4ff7@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, May 10, 2008 at 01:30:12PM +0200, Andrea Merello wrote:
> Rtl8180: fix wrong parameter in RF code funcion invokation for philip=
s radio
>=20
> The sa2400 RF code needs to invoke sa2400_write_phy_antenna every tim=
e the
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
> --- a/drivers/net/wireless/rtl8180_sa2400.c     2008-02-02
> 14:48:52.000000000 +0100
> +++ b/drivers/net/wireless/rtl8180_sa2400.c     2008-02-02
> 14:49:44.000000000 +0100
> @@ -85,7 +85,7 @@ static void sa2400_rf_set_channel(struct
>=20
>         write_sa2400(dev, 7, txpw);
>=20
> -       sa2400_write_phy_antenna(dev, chan);
> +       sa2400_write_phy_antenna(dev, conf->channel);
>=20
>         write_sa2400(dev, 0, chan);
>         write_sa2400(dev, 1, 0xbb50);

  CC [M]  drivers/net/wireless/rtl8180_sa2400.o
drivers/net/wireless/rtl8180_sa2400.c: In function =E2=80=98sa2400_rf_s=
et_channel=E2=80=99:
drivers/net/wireless/rtl8180_sa2400.c:89: warning: passing argument 2 o=
f =E2=80=98sa2400_write_phy_antenna=E2=80=99 makes integer from pointer=
 without a cast

Also, the patch is whitespace-damaged and it should be "Signed-off-by"
(note the capital letter) if you don't mind. :-)

Thanks,

John
--=20
John W. Linville
linville@tuxdriver.com
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

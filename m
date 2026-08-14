Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2075936308E;
	Fri, 14 Aug 2026 06:42:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786689732; cv=none; b=Ez8QCz8G0KC1VcWTKxX6AN+CbvysFnHp+Bt/JJHQJBME71WUbfzADT24tEvuVRB+JdNUroLeCANzM7f4hCeDN/4+vmVo+0mVbUBNgqNvcCzVge4DD7/TpuOgUY9kEWMyZqNzaaTeG83PyRUmf3qB35mtojGDPOAUv67c1aQx1VU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786689732; c=relaxed/simple;
	bh=FBN5feYiKw/FhliGFm3SU+imviEqiPxEDl8EW6Uezmc=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=XPLZ5m41+AaGBVaa+7pP13Go7rO0jeQ0Kz+5Wt4G/0Xe4Oe50AVcNF5iRRHYdSTOqk30oejPjEL27z4eZLPafVQXWZb+3sMCCKomLeIBIJSh2TQGM7nJnplTFPrKaykibIpksZlAidBtfVbT6YGeX0qxy9+2+Z9VrFo/x4JiNCM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=iTXJtab4; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="iTXJtab4"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 67E6ftVI31043991, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1786689715; bh=1cbmFOhIHfPC7z6RoxEqUs9Qaa1Bb5L5VH045wqu8Eg=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:MIME-Version;
	b=iTXJtab4ZJHYx223NMYWRQRmoYYbkDIvyXR0aSlhIZqmo6b3dkbNTv0fLmY3z4wWM
	 Y6yGb8i4EE27vOla7FHaC21iZtBYO2L9o9MuPCBwG/Y6jeLga5hzzJ8KtTSJ5JMqxh
	 V6dO4iEfv07wmuHX6pfGV+6tDcb2yywtUFiFy+3g1pzux4Ag6UrbtW4u9IbTDZn5jr
	 AqrQeJipLVbl2xjjQZudwJxGDeljrK1BuzpcSTHryGzo3uBPA9yO6DXPHFsc4/Oh04
	 /2GmT1uSLbhg5h2rnlz9B2JdLP09watS59kMV6e8MryRIAEMZZ//upwHkEi96PMjoi
	 doWdAU2cHAcXw==
Received: from mail.realtek.com (rtkexhmbs02.realtek.com.tw[172.21.6.41])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 67E6ftVI31043991
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Fri, 14 Aug 2026 14:41:55 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS02.realtek.com.tw (172.21.6.41) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Fri, 14 Aug 2026 14:41:56 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS06.realtek.com.tw (10.21.1.56) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Fri, 14 Aug 2026 14:41:56 +0800
Received: from RTKEXHMBS06.realtek.com.tw ([::1]) by
 RTKEXHMBS06.realtek.com.tw ([fe80::126f:59ad:658:674d%10]) with mapi id
 15.02.2562.043; Fri, 14 Aug 2026 14:41:56 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: "luka.gejak@linux.dev" <luka.gejak@linux.dev>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Michael
 Straube" <straube.linux@gmail.com>, Bitterblue Smith
	<rtl8821cerfe2@gmail.com>, Peter Robinson <pbrobinson@gmail.com>, "Hans de
 Goede" <johannes.goede@oss.qualcomm.com>
Subject: RE: [PATCH v4 6/7] wifi: rtw88: sdio: set up RX aggregation and
 interrupts for RTL8723BS
Thread-Topic: [PATCH v4 6/7] wifi: rtw88: sdio: set up RX aggregation and
 interrupts for RTL8723BS
Thread-Index: AQHdKXGr1EoqvK3Cmk6qLsvzCuhn1badGtCw
Date: Fri, 14 Aug 2026 06:41:55 +0000
Message-ID: <433435852a3d4dd898f20974928b4551@realtek.com>
References: <20260811091203.26841-1-luka.gejak@linux.dev>
 <20260811091203.26841-7-luka.gejak@linux.dev>
In-Reply-To: <20260811091203.26841-7-luka.gejak@linux.dev>
Accept-Language: en-US, zh-TW
Content-Language: zh-TW
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

luka.gejak@linux.dev <luka.gejak@linux.dev> wrote:
> From: Luka Gejak <luka.gejak@linux.dev>
>=20
> Enable the existing RX aggregation setup for this chip and select the
> larger DMA burst count it needs. The RTL8723BS does not raise CPWM1, so
> leave that source out of its interrupt mask, and set the SDIO TX control
> bit the vendor driver uses to have transfers always recognised.
>=20
> The chip also keeps raising the interrupt after resume if undefined
> status bits are written back when acknowledging, so acknowledge only the
> defined and unmasked bits. That is scoped to this chip; the other SDIO
> parts keep writing the status word back unchanged.
>=20
> Signed-off-by: Luka Gejak <luka.gejak@linux.dev>

[...]

> @@ -967,12 +974,22 @@ static void rtw_sdio_8723bs_check_rqpn(struct rtw_d=
ev *rtwdev)
>=20
>  static int rtw_sdio_start(struct rtw_dev *rtwdev)
>  {
> +       u32 clear;
> +
>         if (rtw_is_8723bs(rtwdev)) {
>                 rtw_sdio_8723bs_check_rqpn(rtwdev);
>                 rtw_sdio_8723bs_init_free_txpg(rtwdev);
>         }
>=20
>         rtw_sdio_enable_rx_aggregation(rtwdev);
> +
> +       if (rtw_is_8723bs(rtwdev)) {
> +               clear =3D rtw_read32(rtwdev, REG_SDIO_HISR) &
> +                       RTW_SDIO_HISR_CLEAR_MASK;

Though it is little over 80 characters, straightening it will be more reada=
ble.=20

> +               if (clear)
> +                       rtw_write32(rtwdev, REG_SDIO_HISR, clear);
> +       }
> +
>         rtw_sdio_enable_interrupt(rtwdev);
>=20
>         return 0;
> @@ -1052,6 +1069,8 @@ static void rtw_sdio_interface_cfg(struct rtw_dev *=
rtwdev)
>=20
>         val =3D rtw_read32(rtwdev, REG_SDIO_TX_CTRL);
>         val &=3D 0xfff8;
> +       if (rtw_is_8723bs(rtwdev))
> +               val |=3D BIT_SDIO_TX_CTRL_ALWAYS_RECOGNIZE;
>         rtw_write32(rtwdev, REG_SDIO_TX_CTRL, val);
>  }
>=20
> @@ -1316,6 +1335,14 @@ static void rtw_sdio_handle_interrupt(struct sdio_=
func *sdio_func)
>                 rtw_sdio_rx_isr(rtwdev);
>         }
>=20
> +       /*
> +        * RTL8723BS keeps raising the interrupt after resume if undefine=
d
> +        * status bits are written back, so acknowledge only the bits tha=
t are
> +        * both defined and unmasked. Other chips keep the existing behav=
iour.
> +        */
> +       if (rtw_is_8723bs(rtwdev))
> +               hisr &=3D rtwsdio->irq_mask & RTW_SDIO_HISR_CLEAR_MASK;
> +

I'm not sure if I read something wrong...

rtwsdio->irq_mask =3D REG_SDIO_HIMR_RX_REQUEST;  // BIT(0)
RTW_SDIO_HISR_CLEAR_MASK // BIT(2-7, 17-24)

So, (rtwsdio->irq_mask & RTW_SDIO_HISR_CLEAR_MASK) =3D=3D 0
Then, hisr &=3D 0  --> hisr =3D 0.=20

Which point is wrong to me?

>         rtw_write32(rtwdev, REG_SDIO_HISR, hisr);
>=20
>         rtwsdio->irq_thread =3D NULL;

[...]


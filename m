Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D3E424E4B5;
	Mon, 27 Jul 2026 08:59:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785142795; cv=none; b=bIcymQAct0nGHlZmfQFt9XaE0JWBkcRyzgNlTZpn2AG4NIU4h+fhiWK3MnY0ZXE08rJFe+fTyTyK9r+mVUOxdk1yXqejkr2MgiWuDWkq5gg8BRV2Lz5uTObf982UtiSSF0SbztbUXr+tG2nVWIWAK9+VlnNUZr/ph+vcrqoZA14=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785142795; c=relaxed/simple;
	bh=O0+GJZTELRt5/FKtFOiBUAPtt4D6K1YMO4yZrVTd1RI=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=l+KCLK0u87IZ6pcNtbpzBtLfWDYg6B56x9jW0732cv56WsdcjkDLux9KqhZiHtWXfAsJF5nm21KIjrxRzNpR/8uwNIoLmZHMqUblOqZwovFPgucrD/drZ6ahcI4IQ+NfSgqz74UwaEOykQ2zclGFN5kVGvjEgi2IKRDp7JzmT6g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=ashuHPXW; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="ashuHPXW"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 66R8xheD72981471, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1785142783; bh=+ANnELhA/qMJxdl1v3PakJaekUzlEjSma+zs8Xd8p8Q=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:MIME-Version;
	b=ashuHPXWxDSHRTFWaxEC0EG/pzwHolgI9cXAo1yAxLR2AO5DagEK0y3Y4nV1LIgfp
	 Z9/HOFFEHFi+FBdZXqXy8CQEFaaiH8/KIrEEyHyfhPk40QpiGkCkRzM1Sl6/OJ5SAl
	 Du/6bgxv5QtFAFRzulETQzCp/Ag+b6TDRa7MkK1Rsb8CyMBQ3Q0Ur2iGRki01iANw6
	 43pTaExX2Vi343ar+mMZBs7WYsC6tl1B6ZsAXhJ3bM9g3aFpxFAKXvjP1eHNOpY2AY
	 XQBYyesIpkT/u6ObvKJwhADF2qZ55lxYPC+bnjwlbXzFBxC5XO75aRXjhaGlnJ69ix
	 CzYp/LMB31JwQ==
Received: from mail.realtek.com (rtkexhmbs02.realtek.com.tw[172.21.6.41])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 66R8xheD72981471
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Mon, 27 Jul 2026 16:59:43 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS02.realtek.com.tw (172.21.6.41) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Mon, 27 Jul 2026 16:59:43 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS06.realtek.com.tw (10.21.1.56) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Mon, 27 Jul 2026 16:59:43 +0800
Received: from RTKEXHMBS06.realtek.com.tw ([::1]) by
 RTKEXHMBS06.realtek.com.tw ([fe80::e6fd:5a3f:8946:92c4%10]) with mapi id
 15.02.2562.017; Mon, 27 Jul 2026 16:59:43 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: "luka.gejak@linux.dev" <luka.gejak@linux.dev>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Michael
 Straube" <straube.linux@gmail.com>, Peter Robinson <pbrobinson@gmail.com>,
	Bitterblue Smith <rtl8821cerfe2@gmail.com>
Subject: RE: [PATCH v2 08/11] wifi: rtw88: sdio: set up RX aggregation and
 interrupts for RTL8723BS
Thread-Topic: [PATCH v2 08/11] wifi: rtw88: sdio: set up RX aggregation and
 interrupts for RTL8723BS
Thread-Index: AQHdHEb8zKSybwnDLUOFE+V39aHJ2baBEhsQ
Date: Mon, 27 Jul 2026 08:59:42 +0000
Message-ID: <2d3e396f1e184e6eac0a232578d0761c@realtek.com>
References: <20260725150427.93887-1-luka.gejak@linux.dev>
 <20260725150427.93887-9-luka.gejak@linux.dev>
In-Reply-To: <20260725150427.93887-9-luka.gejak@linux.dev>
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
> larger DMA aggregation mode it needs. The RTL8723BS does not raise
> CPWM1, so leave that source out of its interrupt mask, and set the SDIO
> TX control bit the vendor driver uses to have transfers always
> recognised.
>=20
> The chip also keeps raising the interrupt after resume if undefined
> status bits are written back when acknowledging, so acknowledge only the
> defined and unmasked bits. That is scoped to this chip; the other SDIO
> parts keep writing the status word back unchanged.
>=20
> Signed-off-by: Luka Gejak <luka.gejak@linux.dev>
> ---
>  drivers/net/wireless/realtek/rtw88/sdio.c | 28 ++++++++++++++++++++++-
>  drivers/net/wireless/realtek/rtw88/sdio.h |  9 ++++++++
>  2 files changed, 36 insertions(+), 1 deletion(-)
>=20
> diff --git a/drivers/net/wireless/realtek/rtw88/sdio.c b/drivers/net/wire=
less/realtek/rtw88/sdio.c
> index adf0b509e2cc..37d1d58fa55e 100644
> --- a/drivers/net/wireless/realtek/rtw88/sdio.c
> +++ b/drivers/net/wireless/realtek/rtw88/sdio.c
> @@ -844,7 +844,11 @@ static void rtw_sdio_init(struct rtw_dev *rtwdev)
>  {
>         struct rtw_sdio *rtwsdio =3D (struct rtw_sdio *)rtwdev->priv;
>=20
> -       rtwsdio->irq_mask =3D REG_SDIO_HIMR_RX_REQUEST | REG_SDIO_HIMR_CP=
WM1;
> +       if (rtw_is_8723bs(rtwdev))
> +               rtwsdio->irq_mask =3D REG_SDIO_HIMR_RX_REQUEST;
> +       else
> +               rtwsdio->irq_mask =3D REG_SDIO_HIMR_RX_REQUEST |
> +                                      REG_SDIO_HIMR_CPWM1;

align the REG_*

>  }
>=20
>  static void rtw_sdio_enable_rx_aggregation(struct rtw_dev *rtwdev)
> @@ -852,6 +856,7 @@ static void rtw_sdio_enable_rx_aggregation(struct rtw=
_dev *rtwdev)
>         u8 size, timeout;
>=20
>         switch (rtwdev->chip->id) {
> +       case RTW_CHIP_TYPE_8723B:
>         case RTW_CHIP_TYPE_8703B:
>         case RTW_CHIP_TYPE_8821A:
>         case RTW_CHIP_TYPE_8812A:
> @@ -879,6 +884,8 @@ static void rtw_sdio_enable_rx_aggregation(struct rtw=
_dev *rtwdev)
>                     FIELD_PREP(BIT_DMA_AGG_TO_V1, timeout));
>=20
>         rtw_write8_set(rtwdev, REG_RXDMA_MODE, BIT_DMA_MODE);
> +       if (rtw_is_8723bs(rtwdev))
> +               rtw_write8_set(rtwdev, REG_RXDMA_MODE, 3 << 2);

I think you are setting burst count?  rtw_write8_mask()?

#define BIT_DMA_BURST_CNT	GENMASK(3, 2)

>  }
>=20
>  static void rtw_sdio_enable_interrupt(struct rtw_dev *rtwdev)
> @@ -947,9 +954,19 @@ static void rtw_sdio_8723bs_check_rqpn(struct rtw_de=
v *rtwdev)
>=20
>  static int rtw_sdio_start(struct rtw_dev *rtwdev)
>  {
> +       u32 clear;
> +
>         rtw_sdio_8723bs_check_rqpn(rtwdev);
>         rtw_sdio_init_free_txpg(rtwdev);
>         rtw_sdio_enable_rx_aggregation(rtwdev);
> +
> +       if (rtw_is_8723bs(rtwdev)) {
> +               clear =3D rtw_read32(rtwdev, REG_SDIO_HISR) &
> +                       RTW_SDIO_HISR_CLEAR_MASK;
> +               if (clear)
> +                       rtw_write32(rtwdev, REG_SDIO_HISR, clear);
> +       }
> +
>         rtw_sdio_enable_interrupt(rtwdev);
>=20
>         return 0;
> @@ -1029,6 +1046,8 @@ static void rtw_sdio_interface_cfg(struct rtw_dev *=
rtwdev)
>=20
>         val =3D rtw_read32(rtwdev, REG_SDIO_TX_CTRL);
>         val &=3D 0xfff8;
> +       if (rtw_is_8723bs(rtwdev))
> +               val |=3D BIT_SDIO_TX_CTRL_ALWAYS_RECOGNIZE;
>         rtw_write32(rtwdev, REG_SDIO_TX_CTRL, val);
>  }
>=20
> @@ -1293,6 +1312,13 @@ static void rtw_sdio_handle_interrupt(struct sdio_=
func *sdio_func)
>                 rtw_sdio_rx_isr(rtwdev);
>         }
>=20
> +       /* RTL8723BS keeps raising the interrupt after resume if undefine=
d
> +        * status bits are written back, so acknowledge only the bits tha=
t are
> +        * both defined and unmasked. Other chips keep the existing behav=
iour.
> +        */

comment style

> +       if (rtw_is_8723bs(rtwdev))
> +               hisr &=3D rtwsdio->irq_mask & RTW_SDIO_HISR_CLEAR_MASK;
> +
>         rtw_write32(rtwdev, REG_SDIO_HISR, hisr);
>=20
>         rtwsdio->irq_thread =3D NULL;

[...]


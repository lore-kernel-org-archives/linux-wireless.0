Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3D8925524C;
	Fri, 14 Aug 2026 05:44:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786686271; cv=none; b=EOaMmjmcU5S42abgu8e6BYmzMvyjH56FHAOokqAQQoOayZB8ll2ibbX2lma7eNbQZ5f0MIRvuN11e/WfNQKg8sRWOGWsaS8EooxT4vqQ+rvg+SoyprZnkUjKez32GHcYDgUHE5lvBWZ2pt77kVKs2jlrpB4/ZETVButE4kZnQEo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786686271; c=relaxed/simple;
	bh=6Qegz5BlEPX67vXcdOIowk/KXBydcQ2qzFz5hWW+6Tg=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=LK4HXSi+fiMtcwifmiK+JyD+YyNRz2AuOlZgH4oFwVc11qSp5N0LDKbl+k/2FSlwZe4yuPjaU62nKxR4SRNgSer+Y76K69nRGIC59r5M+eDZU4EQArqSmkYEGP9Uk06a413QbA7aYpyEROuA+IwZvtFF1ENtI0m2sD6ZvEHcb5A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=GA4wjgMc; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="GA4wjgMc"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 67E5iEbD5996936, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1786686254; bh=9UaHUAw0xVs6HSglKvatTeAsr+8QuqFhlUDWFxfP15E=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:MIME-Version;
	b=GA4wjgMcERoaI81Hyu7yY3Pjip0tLL6tCCajG93CRHHaHrW40zPBt5j5jp4Ps9XRC
	 9TgS8ZA2DHUNffxsNQkWUevYzzFkoRNDKDPGwft1D790R/z4x29MLqlzb0/idmY5RX
	 IWzpX8O60/NP1biowE4EtEkjdGnLBlAWXoyw9uGB/pY6J/f3pWFfyxMW6yqZSHbRRp
	 a0/pHsdvxuVyhT2ffd6ODf5a7Em9fCHaBePuDLMkQnx3j+jPRT122Xq7o9q8eUL38E
	 QkaSWKwynCt1H9tS47oO+p5L9pOagGo4XtDDEW7BHPsc8PBRpaN14nHakyB6UbYBj3
	 jOovJNQ6pXQ+g==
Received: from mail.realtek.com (rtkexhmbs03.realtek.com.tw[10.21.1.53])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 67E5iEbD5996936
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Fri, 14 Aug 2026 13:44:14 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS03.realtek.com.tw (10.21.1.53) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Fri, 14 Aug 2026 13:44:13 +0800
Received: from RTKEXHMBS06.realtek.com.tw ([::1]) by
 RTKEXHMBS06.realtek.com.tw ([fe80::126f:59ad:658:674d%10]) with mapi id
 15.02.2562.043; Fri, 14 Aug 2026 13:44:13 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: "luka.gejak@linux.dev" <luka.gejak@linux.dev>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Michael
 Straube" <straube.linux@gmail.com>, Bitterblue Smith
	<rtl8821cerfe2@gmail.com>, Peter Robinson <pbrobinson@gmail.com>, "Hans de
 Goede" <johannes.goede@oss.qualcomm.com>
Subject: RE: [PATCH v4 2/7] wifi: rtw88: rx: mark zero length packets on
 RTL8723BS
Thread-Topic: [PATCH v4 2/7] wifi: rtw88: rx: mark zero length packets on
 RTL8723BS
Thread-Index: AQHdKXGmGZ/52bnHjEeR6fBuPktZYbadC+tQ
Date: Fri, 14 Aug 2026 05:44:13 +0000
Message-ID: <203b96ad48eb47ce9411fa57a73ac0a2@realtek.com>
References: <20260811091203.26841-1-luka.gejak@linux.dev>
 <20260811091203.26841-3-luka.gejak@linux.dev>
In-Reply-To: <20260811091203.26841-3-luka.gejak@linux.dev>
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
> Like the RTL8703B, the RTL8723BS reports receive descriptors with a zero
> packet length, which the vendor driver drops outright. rtw88 already
> flags these as having no PSDU for the RTL8703B, so extend the same
> handling rather than passing an empty frame up.
>=20
> This is gated on the SDIO interface rather than the chip id, because it
> has only been observed there; the USB variant is not known to do it.
>=20
> Co-developed-by: Michael Straube <straube.linux@gmail.com>
> Signed-off-by: Michael Straube <straube.linux@gmail.com>
> Signed-off-by: Luka Gejak <luka.gejak@linux.dev>
> ---
>  drivers/net/wireless/realtek/rtw88/rx.c | 8 +++++---
>  1 file changed, 5 insertions(+), 3 deletions(-)
>=20
> diff --git a/drivers/net/wireless/realtek/rtw88/rx.c b/drivers/net/wirele=
ss/realtek/rtw88/rx.c
> index 01fd299abb7f..a9361ef4b93c 100644
> --- a/drivers/net/wireless/realtek/rtw88/rx.c
> +++ b/drivers/net/wireless/realtek/rtw88/rx.c
> @@ -253,10 +253,12 @@ static void rtw_rx_fill_rx_status(struct rtw_dev *r=
twdev,
>=20
>         rtw_rx_addr_match(rtwdev, pkt_stat, hdr);
>=20
> -       /* Rtl8723cs driver checks for size < 14 or size > 8192 and
> -        * simply drops the packet.
> +       /*
> +        * Rtl8723cs and rtl8723bs drivers check for size < 14 or size > =
8192
> +        * and simply drop the packet.
>          */
> -       if (rtwdev->chip->id =3D=3D RTW_CHIP_TYPE_8703B && pkt_stat->pkt_=
len =3D=3D 0) {
> +       if ((rtwdev->chip->id =3D=3D RTW_CHIP_TYPE_8703B || rtw_is_8723bs=
(rtwdev)) &&
> +           pkt_stat->pkt_len =3D=3D 0) {

I think we can evaluate ` pkt_stat->pkt_len =3D=3D 0` first, because it is =
an
unlikely case and we can save a little time.

>                 rx_status->flag |=3D RX_FLAG_NO_PSDU;
>                 rtw_dbg(rtwdev, RTW_DBG_RX, "zero length packet");
>         }
> --
> 2.53.0


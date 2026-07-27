Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 083AB3DC4D8;
	Mon, 27 Jul 2026 07:15:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785136508; cv=none; b=rWdJB26zSkq8en6ZsCl0oXCl1rF5DpRdVytvrucvBnI4ZBXzwxfskgGZH0R2qHL/2ZiGhF1N8FreY2Q3NnLS/J3c9W1g575dph6dAZaGe7u2IBABTpjfmxQFSPA+2C4PxAP9tfr55UqnYAODAN7oEUf00EzMNj7DdG5WrJ0SSEM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785136508; c=relaxed/simple;
	bh=C0Pu5qDZ3brGKVNezD2P21OsUkwwTIMl6mQaTOKCECY=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=T8i+/NqgxdeoS1kg1T+lbwP0vU/W2xIvuS7vt4axoCmm0ZVJWmbgNzwwtPTiUeivwUJzdcuxz6zqiP9kwQjNy9+qP6dyyNj1CIYMhjpy3OnTjlQNPsImpuXoqciz0Z4cT/YhVf9wU8uJnkDdsC62/7gW33iyRlF7fJcmgzC3CP8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=ZogBJadc; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="ZogBJadc"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 66R7Ew2B22923435, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1785136498; bh=Bh6Z/8NMzvOOgCKcSF29u586PUWFcZbokvQtLSYYfTg=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:MIME-Version;
	b=ZogBJadcPcIZKX9vc8ty1QExO2fNs8y1l0tCGCgYweXy8g0EkglmeOT/k/uCXV7SJ
	 lPrkEI3gpKmV0Mq8wPxmLQ1BmzkWiEmafsqMlZJ3fu7hF6i89bxPSMqFfPNhOMFvYu
	 a02SZezSiKmPA2+Jl84upskj1RRthTmZT1FFS9WW+lLNkc1XSeWuJBeBfWtKBhDrNV
	 xQxxx5qgAUPAr/hT21jwTfYb4kZqTVp/mYeP3MbD3NME2zqbUjlJsmrUr8frLjtg5n
	 0SRg7mZhpwB1A039mNcAUV2U4yWsC1Tmmy9sMbC/LJJ9bgVeGo2ITAzQHpBQ9D5Ur3
	 HOgfxqrKMYlAw==
Received: from mail.realtek.com (rtkexhmbs02.realtek.com.tw[172.21.6.41])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 66R7Ew2B22923435
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Mon, 27 Jul 2026 15:14:58 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS02.realtek.com.tw (172.21.6.41) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Mon, 27 Jul 2026 15:14:58 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS06.realtek.com.tw (10.21.1.56) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Mon, 27 Jul 2026 15:14:57 +0800
Received: from RTKEXHMBS06.realtek.com.tw ([::1]) by
 RTKEXHMBS06.realtek.com.tw ([fe80::e6fd:5a3f:8946:92c4%10]) with mapi id
 15.02.2562.017; Mon, 27 Jul 2026 15:14:57 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: "luka.gejak@linux.dev" <luka.gejak@linux.dev>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Michael
 Straube" <straube.linux@gmail.com>, Peter Robinson <pbrobinson@gmail.com>,
	Bitterblue Smith <rtl8821cerfe2@gmail.com>
Subject: RE: [PATCH v2 02/11] wifi: rtw88: rx: mark zero length packets on
 RTL8723BS
Thread-Topic: [PATCH v2 02/11] wifi: rtw88: rx: mark zero length packets on
 RTL8723BS
Thread-Index: AQHdHEb40ZiroQG7jkedB9GpPuQC97aA9nAg
Date: Mon, 27 Jul 2026 07:14:57 +0000
Message-ID: <e0ba8a366df54843a8d9f65bbc028b41@realtek.com>
References: <20260725150427.93887-1-luka.gejak@linux.dev>
 <20260725150427.93887-3-luka.gejak@linux.dev>
In-Reply-To: <20260725150427.93887-3-luka.gejak@linux.dev>
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
> Signed-off-by: Luka Gejak <luka.gejak@linux.dev>
> ---
>  drivers/net/wireless/realtek/rtw88/rx.c | 8 +++++---
>  1 file changed, 5 insertions(+), 3 deletions(-)
>=20
> diff --git a/drivers/net/wireless/realtek/rtw88/rx.c b/drivers/net/wirele=
ss/realtek/rtw88/rx.c
> index 01fd299abb7f..5303975d00a2 100644
> --- a/drivers/net/wireless/realtek/rtw88/rx.c
> +++ b/drivers/net/wireless/realtek/rtw88/rx.c
> @@ -253,10 +253,12 @@ static void rtw_rx_fill_rx_status(struct rtw_dev *r=
twdev,
>=20
>         rtw_rx_addr_match(rtwdev, pkt_stat, hdr);
>=20
> -       /* Rtl8723cs driver checks for size < 14 or size > 8192 and
> -        * simply drops the packet.
> +       /* Rtl8723cs and rtl8723bs drivers check for size < 14 or size > =
8192
> +        * and simply drop the packet.
>          */
> -       if (rtwdev->chip->id =3D=3D RTW_CHIP_TYPE_8703B && pkt_stat->pkt_=
len =3D=3D 0) {
> +       if ((rtwdev->chip->id =3D=3D RTW_CHIP_TYPE_8703B ||
> +            rtw_is_8723bs(rtwdev)) &&

Straighten it. Though it is over 80 characters, but still acceptable.=20

> +           pkt_stat->pkt_len =3D=3D 0) {
>                 rx_status->flag |=3D RX_FLAG_NO_PSDU;
>                 rtw_dbg(rtwdev, RTW_DBG_RX, "zero length packet");
>         }
> --
> 2.55.0


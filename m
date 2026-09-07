Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABC2F23D7E3
	for <linux-wireless@vger.kernel.org>; Mon,  7 Sep 2026 05:55:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788760521; cv=none; b=pNouYbY5ULNVbEXRpWqtVFoS4DkpbSlbTO5qFwRbs72LVR24TrtP7Ia5uWIWOk7+K/lKs4qgaRMhrtZZSE+8qVqB63Ul5APVWJ/uN0QmXwSHZaLkTJPRTy0iPUOiK7X618HXdC9R1elEUXp+fFS/Zdl1AwoCw2vWCExJpRdu6lI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788760521; c=relaxed/simple;
	bh=uLy/dtuESn1fCQ2inTP6gYO+mf58UuPJErb0jvBFhEA=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=pf2qP77WN8ntK9R82MK+XZMo+9rE1NcBzAdjfcciL88ZjlqyLuyoeDmUMFX+NmkGly0s/WTXOmjE62e3ur2GXkp1i8i4P2R/i7+QINPqWWR2QJIp9Vv3aM/FrqDf0zHGAW4yJ/iLcYWe8QkwyAjwbw0VtUBrGhS0ZPHbCvB72nc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=PRJJTjRq; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="PRJJTjRq"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 6875tFB112534814, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1788760515; bh=qAv75nxu8zaR6uswNCGINFjPk8j53owti+Sbfz7ZRKY=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:MIME-Version;
	b=PRJJTjRqFAlFXSgITkB6Qq8t16Kr5Cx5c5Xzp4yBn+KnPpxOd0ketwSih8lE3beVL
	 0bPK5Aeci7XtG/eVSxJdQDbrYrLwicH0J4rNHHKEE4kk4rQVhJdRkwwDjM8WJbTLGP
	 Jk9JDaDwg/HNCdYvbz9QdE7QagSy0dd2sN8UNZ07xKiqEEY3879UEkaMy6qLnEPDBA
	 O8r0W1JXsmS4XKAGp2AHZ3/LIrW5kzDqq/7sgg8Q8lHNNpIbCImZiVOV7MWdG9j1qv
	 7385TRJimDb8AvcE7QJ/ZG/+Lkbxv4gEgLOm8/y+3pztHfv/BFC55RYCFD4eNLboUB
	 uqlm3gNmB2/2Q==
Received: from mail.realtek.com (rtkexhmbs04.realtek.com.tw[10.21.1.54])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 6875tFB112534814
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Mon, 7 Sep 2026 13:55:15 +0800
Received: from RTKEXHMBS01.realtek.com.tw (172.21.6.40) by
 RTKEXHMBS04.realtek.com.tw (10.21.1.54) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Mon, 7 Sep 2026 13:55:15 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS01.realtek.com.tw (172.21.6.40) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Mon, 7 Sep 2026 13:55:15 +0800
Received: from RTKEXHMBS06.realtek.com.tw ([::1]) by
 RTKEXHMBS06.realtek.com.tw ([fe80::126f:59ad:658:674d%10]) with mapi id
 15.02.2562.043; Mon, 7 Sep 2026 13:55:15 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: Dan Carpenter <error27@gmail.com>, DeanKu <ku920601@realtek.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: RE: [bug report] wifi: rtw89: coex: Add Bluetooth binding for
 Bluetooth RX gain setting
Thread-Topic: [bug report] wifi: rtw89: coex: Add Bluetooth binding for
 Bluetooth RX gain setting
Thread-Index: AQHdMAKOLFxOWIt8g0W81afUlDEL27bCupCA
Date: Mon, 7 Sep 2026 05:55:15 +0000
Message-ID: <127ea263db1d4923a58c05f533f81934@realtek.com>
References: <aoXrgwyFu851qVNV@stanley.mountain>
In-Reply-To: <aoXrgwyFu851qVNV@stanley.mountain>
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

Dan Carpenter <error27@gmail.com> wrote:
> Hello Ching-Te Ku,
>=20
> Commit fe8f6ddb9095 ("wifi: rtw89: coex: Add Bluetooth binding for
> Bluetooth RX gain setting") from Jul 6, 2026 (linux-next), leads to
> the following Smatch static checker warning:
>=20
>         drivers/net/wireless/realtek/rtw89/coex.c:3943 _set_bt_rx_gain()
>         warn: duplicate check 'rf_band' (previous on line 3927)
>=20
> drivers/net/wireless/realtek/rtw89/coex.c
>     3914 static void _set_bt_rx_gain(struct rtw89_dev *rtwdev, bool force=
_exec, u8 bid,
>     3915                             u8 rf_band, u8 level)
>     3916 {
>     3917         struct rtw89_btc *btc =3D &rtwdev->btc;
>     3918         struct rtw89_btc_cx *cx =3D &btc->cx;
>     3919         struct rtw89_btc_bt_info *bt =3D &cx->bt0;
>     3920         u8 h2c_func =3D SET_BT_LNA_CONSTRAIN;
>     3921         u8 i, id_start, id_stop;
>     3922         bool state =3D false;
>     3923         u32 scbd_bit =3D 0;
>     3924         u8 buf[2] =3D {};
>     3925         u8 len =3D sizeof(*buf);
>     3926
>     3927         if (bt->bcnt[BTC_BCNT_INFOUPDATE] =3D=3D 0 || !rf_band)
>                                                             ^^^^^^^
> The patch adds a check here

Thanks for the report. We will remove the rf_band checking here.

Ping-Ke



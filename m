Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A155B25B08B;
	Tue, 18 Aug 2026 07:47:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787039278; cv=none; b=UUj+piDKAEFKM5VsZRAaHP6RZHYyHTM/rsQ9C7WvvfirlUYy7GmS2UCFHWtwW+B9GgBfaXrxup8WyXygv6Qqor6P6f5lr9Z/qjpSGfaxP2wRlvxhPjmvOrzrejMraTimt7wkP+TN2TIAVZb+t8G8atNY9VXz1pXzgPkfNWonY1M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787039278; c=relaxed/simple;
	bh=PBz9Sm98A0lgN907ksAucq+xb0NFcfSj4OuJJXbloAQ=;
	h=From:To:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=m7iUuWdE3znbOz6/Makx563LkpzbLO19nO27qXjMZzSbRrdJ9YePdZIcbbwmFUbj6VG4qaM8ZuUeAl3/er3vrWdN/Y11AosHO2BlZrmWusNTcfGQB3SEow4MI3xf36rVnAdwiSpTjZN6b6h3XCogVbNT7kD0lJOVAZn9qtxwsp8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=iWHAv0/v; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="iWHAv0/v"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 67I7llzlF879334, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1787039267; bh=yhK/HZZltisncbC5RLtue2GVy2/4J0W/zClDdeUAzfo=;
	h=From:To:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:MIME-Version;
	b=iWHAv0/vsfyZSEymclmbbJfiNpSFm4bMkU92yIS2VohS9AX8MTI1E7jQUA05LxpJ1
	 kQQ44tfWnotLPqDUF4MCVy/v/p53V8u44sj4hW6KyzV0pbcONzvLKZV6589UQNbmYl
	 drF3+a1pAoosI0WM8QRH4xkRekWzBk14qWqa44Xp21FONpBgJE/W3DC/JLBNH/x0r3
	 nUnQAA3OgPHNCxu61E3GJpt1S7xoa4x/2R5ykwHmBFwOzCEmrjNKaAod91i1NxHXsA
	 RhgPbuQmYviTnqwV+mJMgkA1IQFIWE09qsD86BvX+0enPYKqsrHEPE/0MquUB54fsJ
	 rhoQWyVY3EJIw==
Received: from mail.realtek.com (rtkexhmbs02.realtek.com.tw[172.21.6.41])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 67I7llzlF879334
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Tue, 18 Aug 2026 15:47:47 +0800
Received: from RTKEXHMBS01.realtek.com.tw (172.21.6.40) by
 RTKEXHMBS02.realtek.com.tw (172.21.6.41) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Tue, 18 Aug 2026 15:47:46 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS01.realtek.com.tw (172.21.6.40) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Tue, 18 Aug 2026 15:47:46 +0800
Received: from RTKEXHMBS06.realtek.com.tw ([::1]) by
 RTKEXHMBS06.realtek.com.tw ([fe80::126f:59ad:658:674d%10]) with mapi id
 15.02.2562.043; Tue, 18 Aug 2026 15:47:46 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: rafad900 <rafad900@gmail.com>, "Jes.Sorensen@gmail.com"
	<Jes.Sorensen@gmail.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "linux-wireless@vger.kernel.org"
	<linux-wireless@vger.kernel.org>
Subject: RE: [PATCH rtw-next v4] wifi: rtl8xxxu: Use local 'dev' variable for
 dev_warn()
Thread-Topic: [PATCH rtw-next v4] wifi: rtl8xxxu: Use local 'dev' variable for
 dev_warn()
Thread-Index: AQHdLtHrsuO3z9gvnEWmstQb02jBDrajbTRQ
Date: Tue, 18 Aug 2026 07:47:46 +0000
Message-ID: <f69bdcc116f04c3c865235873827abf9@realtek.com>
References: <20260818052441.1651077-1-rafad900@gmail.com>
In-Reply-To: <20260818052441.1651077-1-rafad900@gmail.com>
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

rafad900 <rafad900@gmail.com> wrote:

> @@ -2241,7 +2242,7 @@ int rtl8xxxu_init_phy_regs(struct rtl8xxxu_priv *pr=
iv,
>=20
>                 ret =3D rtl8xxxu_write32(priv, reg, val);
>                 if (ret !=3D sizeof(val)) {
> -                       dev_warn(&priv->udev->dev,
> +                       dev_warn(dev,
>                                  "Failed to initialize PHY\n");

Strighten

>                         return -EAGAIN;
>                 }

[...]

> @@ -5869,6 +5872,7 @@ static void rtl8xxxu_rx_urb_work(struct work_struct=
 *work)
>         int ret;
>=20
>         priv =3D container_of(work, struct rtl8xxxu_priv, rx_urb_wq);
> +       struct device *dev =3D &priv->udev->dev;

Don't put declaration in the middle.

>         INIT_LIST_HEAD(&local);
>=20
>         spin_lock_irqsave(&priv->rx_urb_lock, flags);

[...]


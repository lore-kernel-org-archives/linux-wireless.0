Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3B98352C54;
	Mon, 12 Oct 2026 02:28:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791772116; cv=none; b=aCctzdux4Ib0bY/QFDgVECkDzEu0rOfauFeFeYok7mQ1DM9CCv5uxmOFLFPrylh1KdZQzGb6amxuDdD0x2nzIUyOhpT1g3yPdKqryary+4vWd2tGE1aAeXEqY0LjIozH+maCMcYs9U5uNLdH4JjFYk82RsqG+dNRjFjLMOfKcjE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791772116; c=relaxed/simple;
	bh=zY9BHHSzwwt4KjZhmqV6rcmpH/tSF0SIHOYQi6OAukw=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=Qw3KtMyr17VnFMHg34n1AOJaAFwrrcB4/BOF8BjpLn0xvG6HknyLD16XmDa3LMPcrjKM3YHfeshfb7LlyEmslcTXooPKwSs69UzLjs9H+nNb8O+DOl3OdFcPXBxzTGFZEBORjB8nplnThetYfeG70/gpF9t4gKwh4CAvT4/w5tA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=JiTf0fEC; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="JiTf0fEC"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 69C2SNWS03453551, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1791772103; bh=VykuBYPEDqyCk7vwbC+T9UweQm2nZymqGpSEYUIZXcY=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:MIME-Version;
	b=JiTf0fECyHQfp2zT2pACYWAYRQ9RV1dF7kgkhJP3o/5NAfyxVPZoxREing7SOAvEh
	 Q7dkhSyUm4z4h67rWu4VGdUr4CgW3GeI4Fgkdpx/pHhDeo+2CRXYm0c4UN/6ZuL4Vc
	 KaOkmPGxOS1XOrGx9pG0OQQq3Kise5GizAuGveLeLgi2NL8Z3SKw9mhRj1gi2uhluu
	 UCl/uoN7XGczCyrnIZvWgodyOWVy4UUQCTK3FVAWJFdq23NqO4YF8tLIGFGJ+xcFGa
	 nQVvOSZ0rrGmy+rceJbP1D+DM7bRteBuxVTn9M8A5Ji/KnMTiq6K4pNlBX5ReSuwDo
	 ww9fR5N9SOF0g==
Received: from mail.realtek.com (rtkexhmbs04.realtek.com.tw[10.21.1.54])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 69C2SNWS03453551
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Mon, 12 Oct 2026 10:28:23 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS04.realtek.com.tw (10.21.1.54) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Mon, 12 Oct 2026 10:28:29 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS06.realtek.com.tw (10.21.1.56) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Mon, 12 Oct 2026 10:28:28 +0800
Received: from RTKEXHMBS06.realtek.com.tw ([::1]) by
 RTKEXHMBS06.realtek.com.tw ([fe80::b3cc:c263:b82d:e87c%10]) with mapi id
 15.02.2562.049; Mon, 12 Oct 2026 10:28:28 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: Jeremy Fareau <jeremy.fareau@gmail.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Kalle Valo
	<kvalo@kernel.org>, Brian Norris <briannorris@chromium.org>
Subject: RE: [PATCH wireless 2/2] wifi: rtw88: restore the control frame
 filter when the device is started
Thread-Topic: [PATCH wireless 2/2] wifi: rtw88: restore the control frame
 filter when the device is started
Thread-Index: AQHdVjwePr+h2BpVHUOerR9jRc5abrb5MP0w
Date: Mon, 12 Oct 2026 02:28:28 +0000
Message-ID: <87ffcecc1de34fbfa1a59a4013ee29ed@realtek.com>
References: <20261007091225.413-1-jeremy.fareau@gmail.com>
 <20261007091225.413-3-jeremy.fareau@gmail.com>
In-Reply-To: <20261007091225.413-3-jeremy.fareau@gmail.com>
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

Jeremy Fareau <jeremy.fareau@gmail.com> wrote:
> Commit ed51a86b787f ("wifi: rtw88: Enable receiving control frames in
> monitor mode") writes REG_RXFLTMAP1 from configure_filter(),

Using LLM is okay, but please reword yourself. I don't think this sentence
is necessary.

> but that
> register is reset to the chip default by the chip's mac_init() during
> power_on().

Maybe the default value of rtwdev->hal.rxfltmap1 should be set at
rtw_core_init()? But I don't have clear thought how to switch between
normal and monitor modes (or even sta + monitor mode).=20

>  mac80211 only calls ieee80211_ops::configure_filter() when
> its own filter flags change, so after a stop/start cycle the flags are
> unchanged and the control frame filter silently reverts: monitor mode
> stops delivering control frames again.

This problem is also only encountered in monitor mode, right?
Let's do it under monitor mode condition?

>=20
> Keep track of the value configure_filter() last asked for and restore
> it in rtw_core_start(), next to the RCR restore, which exists for the
> same reason.
>=20
> Measured on an RTL8814AU and an RTL8812AU in monitor mode on channel 6,
> 40 s captures taken after a down/up cycle.  Control frames go from 0 to
> 23184 and from 0 to 483 respectively; without this change both are 0.
>=20
> Fixes: ed51a86b787f ("wifi: rtw88: Enable receiving control frames in mon=
itor mode")
> Assisted-by: LLM
> Signed-off-by: Jeremy Fareau <jeremy.fareau@gmail.com>
> ---
>  drivers/net/wireless/realtek/rtw88/mac80211.c | 5 +++--
>  drivers/net/wireless/realtek/rtw88/main.c     | 8 ++++++++
>  drivers/net/wireless/realtek/rtw88/main.h     | 1 +
>  3 files changed, 12 insertions(+), 2 deletions(-)
>=20
> diff --git a/drivers/net/wireless/realtek/rtw88/mac80211.c
> b/drivers/net/wireless/realtek/rtw88/mac80211.c
> index 827f38390969..84d869f1efe0 100644
> --- a/drivers/net/wireless/realtek/rtw88/mac80211.c
> +++ b/drivers/net/wireless/realtek/rtw88/mac80211.c
> @@ -300,9 +300,10 @@ static void rtw_ops_configure_filter(struct ieee8021=
1_hw *hw,
>=20
>         if (changed_flags & FIF_CONTROL) {
>                 if (*new_flags & FIF_CONTROL)
> -                       rtw_write16(rtwdev, REG_RXFLTMAP1, 0xffff);

REG_RXFLTMAP1 should be 0xffff in monitor mode, right?
Maybe, just set the value in monitor mode. No need rxfltmap1_cur to store
current value. Maintaining two variables is hard and confusing...

> +                       rtwdev->hal.rxfltmap1_cur =3D 0xffff;
>                 else
> -                       rtw_write16(rtwdev, REG_RXFLTMAP1, rtwdev->hal.rx=
fltmap1);
> +                       rtwdev->hal.rxfltmap1_cur =3D rtwdev->hal.rxfltma=
p1;
> +               rtw_write16(rtwdev, REG_RXFLTMAP1, rtwdev->hal.rxfltmap1_=
cur);
>         }
>         if (changed_flags & FIF_ALLMULTI) {
>                 if (*new_flags & FIF_ALLMULTI)



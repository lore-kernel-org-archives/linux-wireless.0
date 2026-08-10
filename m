Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7471C346A0C
	for <linux-wireless@vger.kernel.org>; Mon, 10 Aug 2026 03:06:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786331197; cv=none; b=WZlcIzXiV17dnHtiWBpaY6CdzB05XyyOueafazz72r4MvVkqubsO3ivQPOVtV7FcQJIgZsgsjhODv2V744HCSNC1E50ii/8G5OyKmVOzt1QcuGmWU8Xt84RTMQ/cKcQ4LOl/ip/E4cGE01oQyFiv9kjgsPldg7fS21Emh7/VMIw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786331197; c=relaxed/simple;
	bh=LsyXL7RgGtQvl20DDMvkpyVP0X9pVde8neLnKbBErVA=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=Mfhnxq3q+CY5XAOmMyXkVyjanU5TbiEiIl+zdwwowmurXLyUjTjleDkgydeErvgHtA/q5cq/uNP9H1rxjNpMzrCDGIdDnlRH2g0CD00Wf1+Y4/fynh4PbNDW0Efy3fJE4l7u7bAZ3z2fj6spmxzOUa2PM7+lxh5s6RR7SacLgsI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=HMeVJhY4; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="HMeVJhY4"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 67A36QQ401417485, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1786331186; bh=FwBZJZYNkP31oFdNSPiNa1YPQRPrhuwIoTdfIJ6aS+A=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:MIME-Version;
	b=HMeVJhY43Y78yMXbLhWHczPcQ62cUxIRoZrkPDHiCnaCqgJCr5upeaUKALxiFhm+0
	 DpmS4KYXJq7/8O15kXEvUjxgo1CVzHoB5F/9DMxh/LxTzdcdnjZOhWykiLDoBI5/l6
	 Sd042ULuYgjbQ46/mc8LycL/b6DhAI7ArrdvRtals5iFjt6IIANmyWs5BoJ8MUE77d
	 iN3XW0IvMUjDnN8TL3sMk9YOl2uTCF5pnd5TLqZvsDJ2mg8Cd1nGbe8v5hCMX1przu
	 cOl+aOk6khLKFX99wr8u0MTm6Lw+3zgP+toQ1Q7i4jV4QKYOp44SGwhAFvy/QJWoyQ
	 QPDgk2PH4Pqzw==
Received: from mail.realtek.com (rtkexhmbs04.realtek.com.tw[10.21.1.54])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 67A36QQ401417485
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Mon, 10 Aug 2026 11:06:26 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS04.realtek.com.tw (10.21.1.54) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Mon, 10 Aug 2026 11:06:26 +0800
Received: from RTKEXHMBS06.realtek.com.tw ([::1]) by
 RTKEXHMBS06.realtek.com.tw ([fe80::126f:59ad:658:674d%10]) with mapi id
 15.02.2562.043; Mon, 10 Aug 2026 11:06:26 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: Chelsy Ratnawat <chelsyratnawat2001@gmail.com>
CC: "hvilleneuve@dimonoff.com" <hvilleneuve@dimonoff.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: RE: [PATCH] wifi: rtlwifi: remove dead mimo_ps handling from rate
 update code
Thread-Topic: [PATCH] wifi: rtlwifi: remove dead mimo_ps handling from rate
 update code
Thread-Index: AQHdJLNlUhyjv5sGB0iJM1ytHHgSCLaWoEgw
Date: Mon, 10 Aug 2026 03:06:26 +0000
Message-ID: <eec7b92d15f74510abd5898091e7067b@realtek.com>
References: <20260805082004.608667-1-chelsyratnawat2001@gmail.com>
In-Reply-To: <20260805082004.608667-1-chelsyratnawat2001@gmail.com>
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

Chelsy Ratnawat <chelsyratnawat2001@gmail.com> wrote:
> diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192d/hw_common.c
> b/drivers/net/wireless/realtek/rtlwifi/rtl8192d/hw_common.c
> index 97e0d9c01e0a..6d8b39174bb6 100644
> --- a/drivers/net/wireless/realtek/rtlwifi/rtl8192d/hw_common.c
> +++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192d/hw_common.c
> @@ -775,7 +775,6 @@ static void rtl92d_update_hal_rate_table(struct ieee8=
0211_hw *hw,
>         struct rtl_priv *rtlpriv =3D rtl_priv(hw);
>         struct rtl_phy *rtlphy =3D &rtlpriv->phy;
>         enum wireless_mode wirelessmode;
> -       u8 mimo_ps =3D IEEE80211_SMPS_OFF;
>         u8 curtxbw_40mhz =3D mac->bw_40;
>         u8 nmode =3D mac->ht_enable;
>         u8 curshortgi_40mhz;

This was done by previous patch:
d4157cd3aeab ("wifi: rtlwifi: rtl8192d: remove dead SMPS rate mask code")

Please respin your patch based on https://github.com/pkshih/rtw.git rtw-nex=
t branch.

Ping-Ke



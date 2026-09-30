Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D226547060;
	Wed, 30 Sep 2026 00:28:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790728115; cv=none; b=Ylm82ewBWroBKmVpDYZFdGjHLX1HsQJK5ZhF57VNh17y/SgCEhHDDW0Z3axw4ctedJkTEnRPf8N6cpHmwkZUMoM9oDN2VMAk8E1M3kHJzvOSQOO+VPa52ZHkl/ns/qrRPk1j1NtXcAKftko7de/RNtaCIthsPqmGbxMBvHPQ8mw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790728115; c=relaxed/simple;
	bh=bn5BM88IqhxyYWQIrR8H3oJUeo3800OHPMfxgxHNSgg=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=ZfOqhpdtauosMoLpnsIse/SkVXz98zZFhj9XZ+N2tL8QfgRy8mEUscUQ2ZABsUnicQdT+QcPBftI4iKomTVp5yUWKrzb7yVN9QJg6qACo2yDgKc7DNsz4usS6ah1al2xAiXxSUoW4i/tnxRfoYGKnaz77v5IAnEeft9pQK7koJk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=NyzbsZcx; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="NyzbsZcx"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 68U0S5xI41717719, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1790728085; bh=UVbxKIrRHY3UU0zg2IgJRNIu0MpqTRcgLCgmmFCJVB8=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:MIME-Version;
	b=NyzbsZcx+HIz7QToMTm5V+rJK+HKkET8cBJ6l2m2Bp6LCl2A5UCuqtWjhz76uBBKg
	 OEqD73ok2Nithduga62SsdPdg6cdmjd2NmxE+HMiGoUH3N2pYXbh1mmMsoekNfhngG
	 D2YgXCfH49OeiPqpMdEzsHL1yd7yY2oVTmDPeynSm7bs0FEthZLuDdmMljgJQbLBeb
	 rvZ9FRyu0y01ydBj3PtwKyepQ5tZYlo8MI33Xi2xEA2Y54r08d24fChX1pET28WE4h
	 7EzOziPDJioemnV9XvDlKJllkwW/P6wx0zz/dzCVmISzZtjjWs4UiRVRrEVDTQvDqD
	 5dJdedf7ZSEHA==
Received: from mail.realtek.com (rtkexhmbs03.realtek.com.tw[10.21.1.53])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 68U0S5xI41717719
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Wed, 30 Sep 2026 08:28:05 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS03.realtek.com.tw (10.21.1.53) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Wed, 30 Sep 2026 08:28:05 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS06.realtek.com.tw (10.21.1.56) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Wed, 30 Sep 2026 08:28:05 +0800
Received: from RTKEXHMBS06.realtek.com.tw ([::1]) by
 RTKEXHMBS06.realtek.com.tw ([fe80::b3cc:c263:b82d:e87c%10]) with mapi id
 15.02.2562.049; Wed, 30 Sep 2026 08:28:05 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: Arnd Bergmann <arnd@kernel.org>, Johnson Tsai <wenjie.tsai@realtek.com>
CC: Arnd Bergmann <arnd@arndb.de>, Bitterblue Smith <rtl8821cerfe2@gmail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] wifi: rtw89: fix LED dependencies
Thread-Topic: [PATCH] wifi: rtw89: fix LED dependencies
Thread-Index: AQHdT/8uPx21cNsIcEC+oww+Nsu2prbmQl0w
Date: Wed, 30 Sep 2026 00:28:05 +0000
Message-ID: <1bde7ea5999c4915b184bf2fcb904901@realtek.com>
References: <20260929104159.3236854-1-arnd@kernel.org>
In-Reply-To: <20260929104159.3236854-1-arnd@kernel.org>
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

Arnd Bergmann <arnd@kernel.org> wrote:
> From: Arnd Bergmann <arnd@arndb.de>
>=20
> The rtw89 driver fails to build when multicolor LED support is in
> a loadable module but the rtw89 driver is built-in:
>=20
> aarch64-linux-ld: drivers/net/wireless/realtek/rtw89/led_mc.o: in functio=
n
> `rtw89_led_mc_brightness_set':
> led_mc.c:(.text+0x50): undefined reference to `led_mc_calc_color_componen=
ts'
> aarch64-linux-ld: drivers/net/wireless/realtek/rtw89/led_mc.o: in functio=
n `rtw89_led_mc_init':
> led_mc.c:(.text+0x434): undefined reference to `led_classdev_multicolor_r=
egister_ext'

This was also found by kernel test robot [1], and addressed by patch [2].

[1] https://lore.kernel.org/oe-kbuild-all/202609172315.ZYoKvKBS-lkp@intel.c=
om/
[2] https://patch.msgid.link/20260918021113.25481-1-pkshih@realtek.com

>=20
> The problem is a misunderstanding of how Kconfig dependencies
> work, as the 'imply' keyword is not sufficient to enable a
> a user-visible dependency, and the boolean 'RTW89_LEDS_MC'
> symbol cannot determine whether linking against the MC code is
> valid.

People intend to weakly select the dependency. I think keeping
'imply' is harmless.

>=20
> Address this by using the correct construct to determing whether
> linking agains the MAC80211_LEDS and LEDS_CLASS_MULTICOLOR
> code is possible, respectively.
>=20
> Fixes: d910631ff352 ("wifi: rtw89: add LED support to reflect the wireles=
s association status")
> Fixes: 721d90c8509a ("wifi: rtw89: add multicolor LED support for RTL8852=
CU valve board")
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
>  drivers/net/wireless/realtek/rtw89/Kconfig | 6 ++----
>  1 file changed, 2 insertions(+), 4 deletions(-)
>=20
> diff --git a/drivers/net/wireless/realtek/rtw89/Kconfig
> b/drivers/net/wireless/realtek/rtw89/Kconfig
> index 7c678dd1f6b3..4000ae344544 100644
> --- a/drivers/net/wireless/realtek/rtw89/Kconfig
> +++ b/drivers/net/wireless/realtek/rtw89/Kconfig
> @@ -208,15 +208,13 @@ config RTW89_DEBUGFS
>  config RTW89_LEDS
>         bool
>         depends on RTW89_CORE
> -       depends on LEDS_CLASS=3Dy || LEDS_CLASS=3DMAC80211

I remember we fixed to this style years ago by imitating ath10k and iwlwifi=
,
which they look like that still.=20

> -       imply MAC80211_LEDS
> +       depends on MAC80211_LEDS=3Dy || MAC80211_LEDS=3DRTW89_CORE
>         default y
>=20
>  config RTW89_LEDS_MC
>         bool
>         depends on RTW89_LEDS
> -       depends on LEDS_CLASS_MULTICOLOR
> -       imply LEDS_TRIGGER_TIMER
> +       depends on LEDS_CLASS_MULTICOLOR=3Dy || LEDS_CLASS_MULTICOLOR=3DR=
TW89_CORE
>         default y
>=20
>  endif
> --
> 2.53.0


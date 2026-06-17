Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A33838332F;
	Wed, 17 Jun 2026 08:24:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781684685; cv=none; b=Pg7XqSPdZu0Xyy/GIByoGqdc/TDpy4kprK5Y1yEizcHIvXQUa2C+Tf0SsTXhf6ibL1ZWcCQW+IjL1MnQdumvDk3+m5qqQgw3Oe573SAR4452nZxgXvONxnpYirqSCWnxvwVc9PoTMgFqeb0SUpNvGUc2sH8iCVknoh7556knh8E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781684685; c=relaxed/simple;
	bh=M0ovN8tbFJFzWAIXj7A1YsnjDyHU9EFSVp6FvawceNQ=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=RV0AV4lgSjwWBLfupztnDQZvuMA0CQajzWtB4oAPIlubZeIBGAxqvDX+xEYorw8PeSQSHuYdkHM+KWPH5k0IrPpK4V3Nl/MhAwel3g0ypazJnWHPPwF0ygxOWZGmry3usmBXqQ2Z1ZzKfqBLOMAv6PdHeChJO0eG/HkjkJ7lKCI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=HPg7P4v9; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="HPg7P4v9"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 65H8Oe8X22576250, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1781684680; bh=QF+OT2kwUwKJjZqwzq1+stxB7tI8z8ACws+ArHOFcKo=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:MIME-Version;
	b=HPg7P4v9R+1L1el/tdGak/o+N9R9pErExt2sNOeH7JB7ypDRqY2wEvc+uKukMxzEr
	 YwkiihxlYk42YOs++jm1B10RewSdVuECPeqv+cyo8i1gXlswCO9OS+8Svjezm0xvkQ
	 hshVo4R3M8L8YeTAPZ1VKqs36LqEqagfwMWnXd3NxDXBe5OnIZJ8yvAlJNt+Dn8h9s
	 0+Unfn3iTWGcjfh4bXaRuRdQZIyBbczOrzc1Qr8EATp50KZoewDyHc+zcOnndg6Iaf
	 3wHx4CSZ9gAtRQS7ZBLCMG8fbfjBj521F/ZAMlJzgER86MgCugzbjNKei/8tU8an3H
	 H5yzDFtRZSvnw==
Received: from mail.realtek.com (rtkexhmbs02.realtek.com.tw[172.21.6.41])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 65H8Oe8X22576250
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Wed, 17 Jun 2026 16:24:40 +0800
Received: from RTKEXHMBS01.realtek.com.tw (172.21.6.40) by
 RTKEXHMBS02.realtek.com.tw (172.21.6.41) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Wed, 17 Jun 2026 16:24:39 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS01.realtek.com.tw (172.21.6.40) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Wed, 17 Jun 2026 16:24:39 +0800
Received: from RTKEXHMBS06.realtek.com.tw ([::1]) by
 RTKEXHMBS06.realtek.com.tw ([fe80::e6fd:5a3f:8946:92c4%10]) with mapi id
 15.02.2562.017; Wed, 17 Jun 2026 16:24:39 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: William Hansen-Baird <william.hansen.baird@gmail.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH rtw-next v2 3/3] wifi: rtlwifi: disable ASPM for RTL8723BE
 with subsystem ID 17aa:b736
Thread-Topic: [PATCH rtw-next v2 3/3] wifi: rtlwifi: disable ASPM for
 RTL8723BE with subsystem ID 17aa:b736
Thread-Index: AQHc/ZrMmC1pAPgfvkSS9BhA/bWtqbZCaekw
Date: Wed, 17 Jun 2026 08:24:39 +0000
Message-ID: <11f9f9bf0d614897a3bff56e12bb1247@realtek.com>
References: <20260614135508.70307-1-william.hansen.baird@gmail.com>
 <20260616141620.91081-1-william.hansen.baird@gmail.com>
 <20260616141620.91081-4-william.hansen.baird@gmail.com>
In-Reply-To: <20260616141620.91081-4-william.hansen.baird@gmail.com>
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

William Hansen-Baird <william.hansen.baird@gmail.com> wrote:
> RTL8723BE outputs a large amount of PCIe AER errors during and
> after boot, even before probe and when driver is never loaded.
> This causes significant system slowdown.
>=20
> The errors are the same as reported by
> commit 77a6407c6ab2 ("wifi: rtlwifi: disable ASPM for RTL8723BE with subs=
ystem ID 11ad:1723")
>=20
> Add the RTL8723BE with subsystem ID 17aa:b736 to the rtl_aspm_quirks
> table to stop the AER errors. AER errors can still be present prior to
> pci probe, as the device by default may have ASPM enabled.
>=20
> Testing on a Razer Blade 14 2017 which shipped from the
> OEM equipped with an RTL8723BE card with this subsystem ID
> confirms that this patch resolves the AER flood and allows the
> wireless card to function normally once the driver takes over.
>=20
> Signed-off-by: William Hansen-Baird <william.hansen.baird@gmail.com>

Only minor suggestion, so

Acked-by: Ping-Ke Shih <pkshih@realtek.com>

> ---
>  drivers/net/wireless/realtek/rtlwifi/pci.c | 1 +
>  1 file changed, 1 insertion(+)
>=20
> diff --git a/drivers/net/wireless/realtek/rtlwifi/pci.c
> b/drivers/net/wireless/realtek/rtlwifi/pci.c
> index 9de396879806..9919c8588cbd 100644
> --- a/drivers/net/wireless/realtek/rtlwifi/pci.c
> +++ b/drivers/net/wireless/realtek/rtlwifi/pci.c
> @@ -33,6 +33,7 @@ static const u8 ac_to_hwq[] =3D {
>=20
>  static const struct pci_device_id rtl_aspm_quirks[] =3D {
>         { PCI_DEVICE_SUB(PCI_VENDOR_ID_REALTEK, 0xb723, 0x11ad, 0x1723) }=
,
> +       { PCI_DEVICE_SUB(PCI_VENDOR_ID_REALTEK, 0xb723, 0x17aa, 0xb736) }=
,

Would you like a comment "Razer Blade 14 2017"?

>         { 0 }
>  };
>=20
> --
> 2.54.0


Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BECD259C80
	for <linux-wireless@vger.kernel.org>; Sun, 13 Sep 2026 02:15:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789265760; cv=none; b=ZFE24vWEOMBKx/2bUIG9p+04EezvdCftNHlKikfGqn5r2L8v3G/MzPQhkMHrQR94CVPUv9luuMtPpt7HLLlbXjryXwTEL+oCGqjt5+JvF2sVy/cibuG9zSLVfUzXQJiwoGBqvMmZ6u+e2ds/i0FdN5k3nrnw88UtsowiUMDm42g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789265760; c=relaxed/simple;
	bh=XdJyUrppwbELRVCTSr7a+rxEUqrAmtvqwfpWEDkPwFk=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=ck9b4dBSSaf9kYekVT46pWZ/R1iRvAEIVIhVyBrl1cpqeBCCkwQM/5X24sbLWN0Yc0N87N2Jryi9b3sPmerL2nDUmU4XC7uwko/ISfVsb5QzBwvPudESlqw0978zkFTZEDeEHNtWc7JTK9zAD9NEb155GhdBGieHUwckhZ/q1tc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=ZlD09nrt; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="ZlD09nrt"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 68D2FoB523599500, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1789265750; bh=NTzJnn1ujsnBY4OR8A2nLr4ljoua0DX0tKHDa/vZi64=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:MIME-Version;
	b=ZlD09nrtTDX81lIYQeTETmwhUqwPDrpAZ0/wL2gemZjeFJhYFBZz+289lIljteXE0
	 aW9YkXFTOpTnTrsO9xDW/ds8eaLn/53IrbiZQ4nNt9+IfWlxGF2abBIzRjzEQrR8M3
	 eOy2poekOAEK4PHE1pnwZ+frVXkIrOZ4A+W7nZS/0qIkYn1syLJj4VUQRbxpELQLYq
	 d4iSbLX83JJ1DQ+Kl5qS8MRqizRp/jBVZXrNekCMIqBDOvNJgeSJaHbCP/otghhy3D
	 vxB76PGrDfesUPOoVp0cvllRjrAW9FChTkB+EQfZo9gxOz/rb0pgk3iJpeob7/6/o2
	 QOwNw5Od03rNQ==
Received: from mail.realtek.com (rtkexhmbs02.realtek.com.tw[172.21.6.41])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 68D2FoB523599500
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Sun, 13 Sep 2026 10:15:50 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS02.realtek.com.tw (172.21.6.41) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Sun, 13 Sep 2026 10:15:50 +0800
Received: from RTKEXHMBS06.realtek.com.tw ([::1]) by
 RTKEXHMBS06.realtek.com.tw ([fe80::b3cc:c263:b82d:e87c%10]) with mapi id
 15.02.2562.049; Sun, 13 Sep 2026 10:15:50 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: not-eexto <eexto@aol.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: RE: [PATCH] wifi: rtw88: 8821c: Add HP single-antenna quirk
Thread-Topic: [PATCH] wifi: rtw88: 8821c: Add HP single-antenna quirk
Thread-Index: AQHdQdWXUlvmBxMEWUiMWC9yQBgQJLbLu3PQ
Date: Sun, 13 Sep 2026 02:15:50 +0000
Message-ID: <3b3788a7c4f240899e630938a6c7b472@realtek.com>
References: <20260911100904.50320-1-eexto.ref@aol.com>
 <20260911100904.50320-1-eexto@aol.com>
In-Reply-To: <20260911100904.50320-1-eexto@aol.com>
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

not-eexto <eexto@aol.com> wrote:
> Certain HP laptop platforms with RTL8821CE (PCI ID 10ec:c821, subsystem
> 103c:831a) are manufactured with only a single physical antenna wire
> connected to the Aux/S1 port (Port 2). As documented in the OEM Windows
> INF file (netrtwlane.inf):
>   "single ant(connect to right one S1)"
>=20
> However, the eFuse on these chipsets reports RFE Type 2 (Main antenna,
> Port 1), causing the hardware SPDT RF switch to route to an unconnected
> port under Linux. This leads to severe signal attenuation (~ -86 dBm)
> and frequent beacon-loss disconnections.
>=20
> Add an automatic quirk in rtw8821c_read_efuse() for HP subsystem
> 10ec:c821 [103c:831a] that overrides efuse->rfe_option and
> efuse->rfe_option_full to 4 (Aux), routing the RF path to the physically
> connected antenna.
>=20
> Signed-off-by: not-eexto <eexto@aol.com>

Should use your full real name.

You sent the same patch by different mail address. I'll drop previous one.

> ---
>  rtw8821c.c | 18 ++++++++++++++++++
>  1 file changed, 18 insertions(+)
>=20
> diff --git a/drivers/net/wireless/realtek/rtw88/rtw8821c.c
> b/drivers/net/wireless/realtek/rtw88/rtw8821c.c
> index 9f0964d..32c7de5 100644
> --- a/drivers/net/wireless/realtek/rtw88/rtw8821c.c
> +++ b/drivers/net/wireless/realtek/rtw88/rtw8821c.c
> @@ -15,6 +15,9 @@
>  #include "debug.h"
>  #include "bf.h"
>  #include "regd.h"
> +#if IS_ENABLED(CONFIG_PCI)
> +#include <linux/pci.h>
> +#endif

If this is the only one platform which needs this kind of quirk. Add an ent=
ry
to rtw_pci_quirks[].

>=20
>  static const s8 lna_gain_table_0[8] =3D {22, 8, -6, -22, -31, -40, -46, =
-52};
>  static const s8 lna_gain_table_1[16] =3D {10, 6, 2, -2, -6, -10, -14, -1=
7,
> @@ -56,6 +59,21 @@ static int rtw8821c_read_efuse(struct rtw_dev *rtwdev,=
 u8 *log_map)
>=20
>         efuse->rfe_option =3D map->rfe_option & 0x1f;
>         efuse->rfe_option_full =3D map->rfe_option;
> +
> +#if IS_ENABLED(CONFIG_PCI)
> +       if (rtw_hci_type(rtwdev) =3D=3D RTW_HCI_TYPE_PCIE && dev_is_pci(r=
twdev->dev)) {
> +               struct pci_dev *pdev =3D to_pci_dev(rtwdev->dev);
> +
> +               if (pdev->vendor =3D=3D PCI_VENDOR_ID_REALTEK &&
> +                   pdev->device =3D=3D 0xc821 &&
> +                   pdev->subsystem_vendor =3D=3D 0x103c &&
> +                   pdev->subsystem_device =3D=3D 0x831a) {
> +                       efuse->rfe_option =3D 4;
> +                       efuse->rfe_option_full =3D 4;

I don't see rtw88 has ' rfe_option_full' ?

> +                       rtw_info(rtwdev, "HP quirk auto-detected (10ec:c8=
21 [103c:831a]): forced RFE
> option 4 (Aux antenna S1)\n");
> +               }
> +       }
> +#endif
>         efuse->rf_board_option =3D map->rf_board_option;
>         efuse->crystal_cap =3D map->xtal_k;
>         efuse->pa_type_2g =3D map->pa_type;
> --
> 2.43.0


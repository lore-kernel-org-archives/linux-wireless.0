Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7B33311C11
	for <linux-wireless@vger.kernel.org>; Thu, 26 Mar 2026 06:26:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774506389; cv=none; b=N9oviRF9PENcS9amAsK0Y88nEqR6CCJ0T37/dxHy1hBR/7NxV44YcXhnzYJlNxhZwc56tnqV9uqfDv/6KHcBKTosV5vai62EyCHPYjw3QaxMIgKDmsuvznyVrZy5LTgbqIySVmp2eXQwPtR0XVz4yc2mOz5ET2kL6bfaD6ZhlOI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774506389; c=relaxed/simple;
	bh=PONUkDK5Nxfv+FEOSWCheKX6fc5iX8BXeD7AcKEe1tc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=tnUJY43leaf/3PhXDiIvqaS+u5U6FAgGSAd0IVxfFgH88brAvJOIaSGki77Z7c1OT0sh7rwSgDtp3cNE57PTryZG10GUlWUkqMAMnVSSNJ1NZLv3n67qFEgrPSevr473ulN7jEXChQEO3IlL0HWRuqjYiEemB+59XW33MQTDRFc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dlyOxobO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dlyOxobO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 914F9C2BCF4
	for <linux-wireless@vger.kernel.org>; Thu, 26 Mar 2026 06:26:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774506388;
	bh=PONUkDK5Nxfv+FEOSWCheKX6fc5iX8BXeD7AcKEe1tc=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=dlyOxobOD7/nYy9+GasYYrE2iASEDUSRxFdWw1g0dcvJ4AsHzlIvOXc3dyxqz6OGe
	 iePLcbc3KY61fK+dGD0uWopqKF+KDAXk31JmHENFOHpPn2RB6Y4RV38PPmSweUxx7u
	 TG/FaySOkJSwu0+G9SHUuAeoUJVS3i+dOiTEIJvjunaJBJ3jAPmje6cUajjXedI1GY
	 vlDC+bfj0EBGstW5vD9jBTCyfu42HYpK9w7ilvWyGSya0GPpymj10n7HBWRCOJepdf
	 MN9gvYuix0F5WM9Mbvss+cJ80ACOdCxo47rIXLrykg/HulJ01EL1IT+5WnGpw/9fC+
	 Md+/8dUSc4T0A==
Received: by mail-lj1-f170.google.com with SMTP id 38308e7fff4ca-38bd15d82bdso4447831fa.2
        for <linux-wireless@vger.kernel.org>; Wed, 25 Mar 2026 23:26:28 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCWuip5LxCeTI+TMTzvlRvrnLhXsbVgRNERwWf0SqS/Pma3PAptSrTjmryfp7UhnrI5SYlxNRvtqkh18V0VCpQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YwyzZ4sqXQhwyF7853QhKDG0AGIeOxj8UxdU4I1RhY8W69hw1hG
	G0uhqwjy805x2B147asgj92gFuyhJEcQrKQYU4dZ0Bbotfl+bECaArcHqlHPUkx+PYpy34unXv+
	s+TRpsyrO9Xl8HlxAtlNtEWuu3pNGpWc=
X-Received: by 2002:a05:651c:4406:20b0:38a:8b97:7e9c with SMTP id
 38308e7fff4ca-38c4309e800mr18002601fa.11.1774506386686; Wed, 25 Mar 2026
 23:26:26 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260325-mt7927-wifi-support-v2-v3-0-5ca66c97a755@jetm.me> <20260325-mt7927-wifi-support-v2-v3-13-5ca66c97a755@jetm.me>
In-Reply-To: <20260325-mt7927-wifi-support-v2-v3-13-5ca66c97a755@jetm.me>
From: Sean Wang <sean.wang@kernel.org>
Date: Thu, 26 Mar 2026 01:26:17 -0500
X-Gmail-Original-Message-ID: <CAGp9LzpZy70T61o7q0t5AAYQwBK+ywp_zbLGw=4SD5Ga_gxmmQ@mail.gmail.com>
X-Gm-Features: AQROBzBJ6-X-H7xt9CpRo8Vppnuc0zRH3pX-AHj4xX39HuOpZCQktesCUmP5MEQ
Message-ID: <CAGp9LzpZy70T61o7q0t5AAYQwBK+ywp_zbLGw=4SD5Ga_gxmmQ@mail.gmail.com>
Subject: Re: [PATCH v3 13/13] wifi: mt76: mt7925: enable MT7927 PCI device IDs
To: Javier Tia <floss@jetm.me>
Cc: Felix Fietkau <nbd@nbd.name>, Lorenzo Bianconi <lorenzo@kernel.org>, Ryder Lee <ryder.lee@mediatek.com>, 
	Shayne Chen <shayne.chen@mediatek.com>, Sean Wang <sean.wang@mediatek.com>, 
	Matthias Brugger <matthias.bgg@gmail.com>, 
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>, 
	Ming Yen Hsieh <mingyen.hsieh@mediatek.com>, Deren Wu <deren.wu@mediatek.com>, 
	linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, linux-mediatek@lists.infradead.org, 
	Marcin FM <marcin@lgic.pl>, Cristian-Florin Radoi <radoi.chris@gmail.com>, 
	George Salukvadze <giosal90@gmail.com>, Evgeny Kapusta <3193631@gmail.com>, 
	Samu Toljamo <samu.toljamo@gmail.com>, Ariel Rosenfeld <ariel.rosenfeld.750@gmail.com>, 
	Chapuis Dario <chapuisdario4@gmail.com>, =?UTF-8?Q?Thibaut_Fran=C3=A7ois?= <tibo@humeurlibre.fr>, 
	=?UTF-8?B?5byg5pet5ra1?= <Loong.0x00@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi, Javier

On Wed, Mar 25, 2026 at 5:14=E2=80=AFPM Javier Tia <floss@jetm.me> wrote:
>
> Add PCI device table entries for MT7927 hardware variants:
>   - 14c3:7927 (ASUS ROG Crosshair X870E Hero, Lenovo Legion Pro 7)
>   - 14c3:6639 (Foxconn/Azurewave modules)
>   - 14c3:0738 (AMD RZ738 / MediaTek MT7927)
>
> This is the final patch in the series, enabling MT7927 device
> enumeration after all infrastructure (DMA, IRQ, HW init, band index,
> power management) is in place.
>
> Tested-by: Marcin FM <marcin@lgic.pl>
> Tested-by: Cristian-Florin Radoi <radoi.chris@gmail.com>
> Tested-by: George Salukvadze <giosal90@gmail.com>
> Tested-by: Evgeny Kapusta <3193631@gmail.com>
> Tested-by: Samu Toljamo <samu.toljamo@gmail.com>
> Tested-by: Ariel Rosenfeld <ariel.rosenfeld.750@gmail.com>
> Tested-by: Chapuis Dario <chapuisdario4@gmail.com>
> Tested-by: Thibaut Fran=C3=A7ois <tibo@humeurlibre.fr>
> Tested-by: =E5=BC=A0=E6=97=AD=E6=B6=B5 <Loong.0x00@gmail.com>
> Signed-off-by: Javier Tia <floss@jetm.me>
> ---
>  drivers/net/wireless/mediatek/mt76/mt7925/pci.c | 29 +++++++++++++++----=
------
>  1 file changed, 18 insertions(+), 11 deletions(-)
>
> diff --git a/drivers/net/wireless/mediatek/mt76/mt7925/pci.c b/drivers/ne=
t/wireless/mediatek/mt76/mt7925/pci.c
> index 693e08f35d68..00c3601f14ff 100644
> --- a/drivers/net/wireless/mediatek/mt76/mt7925/pci.c
> +++ b/drivers/net/wireless/mediatek/mt76/mt7925/pci.c
> @@ -16,6 +16,12 @@ static const struct pci_device_id mt7925_pci_device_ta=
ble[] =3D {
>                 .driver_data =3D (kernel_ulong_t)MT7925_FIRMWARE_WM },
>         { PCI_DEVICE(PCI_VENDOR_ID_MEDIATEK, 0x0717),
>                 .driver_data =3D (kernel_ulong_t)MT7925_FIRMWARE_WM },
> +       { PCI_DEVICE(PCI_VENDOR_ID_MEDIATEK, 0x7927),
> +               .driver_data =3D (kernel_ulong_t)MT7927_FIRMWARE_WM },
> +       { PCI_DEVICE(PCI_VENDOR_ID_MEDIATEK, 0x6639),
> +               .driver_data =3D (kernel_ulong_t)MT7927_FIRMWARE_WM },
> +       { PCI_DEVICE(PCI_VENDOR_ID_MEDIATEK, 0x0738),
> +               .driver_data =3D (kernel_ulong_t)MT7927_FIRMWARE_WM },
>         { },
>  };
>
> @@ -530,7 +536,8 @@ static int mt7925_pci_probe(struct pci_dev *pdev,
>         if (ret)
>                 goto err_free_pci_vec;
>
> -       is_mt7927_hw =3D (pdev->device =3D=3D 0x6639 || pdev->device =3D=
=3D 0x7927);
> +       is_mt7927_hw =3D (pdev->device =3D=3D 0x6639 || pdev->device =3D=
=3D 0x7927 ||
> +                       pdev->device =3D=3D 0x0738);
>
>         /* MT7927: CONNINFRA power domain and WFDMA register access are
>          * unreliable with PCIe L1 active, causing throughput to drop
> @@ -546,16 +553,16 @@ static int mt7925_pci_probe(struct pci_dev *pdev,
>                 goto err_free_pci_vec;
>         }
>
> -       /* MT7927 firmware lacks the connac2 feature trailer, so
> -        * mt792x_get_mac80211_ops() can't detect CNM support and
> -        * replaces chanctx/ROC/mgd_prepare_tx ops with stubs.
> -        * Force CNM and restore the original mt7925 ops.
> -        */
> -       if ((pdev->device =3D=3D 0x6639 || pdev->device =3D=3D 0x7927) &&
> -           !(features & MT792x_FW_CAP_CNM)) {
> -               features |=3D MT792x_FW_CAP_CNM;
> -               memcpy(ops, &mt7925_ops, sizeof(*ops));
> -       }
> +               /* MT7927 firmware lacks the connac2 feature trailer, so
> +                * mt792x_get_mac80211_ops() can't detect CNM support and
> +                * replaces chanctx/ROC/mgd_prepare_tx ops with stubs.
> +                * Force CNM and restore the original mt7925 ops.
> +                */
> +               if ((pdev->device =3D=3D 0x6639 || pdev->device =3D=3D 0x=
7927 ||
> +                    pdev->device =3D=3D 0x0738) && !(features & MT792x_F=
W_CAP_CNM)) {
> +                       features |=3D MT792x_FW_CAP_CNM;
> +                       memcpy(ops, &mt7925_ops, sizeof(*ops));
> +               }

I think the quirk should be applied before the CNM check in
mt792x_get_mac80211_ops().

That helper already owns the fw_features detection and the ops rewrite,
so adding another memcpy() later to restore mt7925_ops feels fragile.
The final ops selection is no longer decided in one place, and the extra
full memcpy() depends on the current call flow and implementation
details of mt792x_get_mac80211_ops().

If MT7927 should force MT792x_FW_CAP_CNM despite the missing trailer,
please fold that into mt792x_get_mac80211_ops() and keep the ops
selection in one place.

>
>         mdev =3D mt76_alloc_device(&pdev->dev, sizeof(*dev), ops, &drv_op=
s);
>         if (!mdev) {
>
> --
> 2.53.0
>
>

Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99B242BEC5E
	for <linux-wireless@vger.kernel.org>; Tue, 12 May 2026 21:30:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778621453; cv=none; b=hoIwTDmFSSO6Kc3i2nU41xbMZMu8QxEo1WulKna1NSP86FDFHirxxiRZtW1ZfxGBNoo6UL4A2i90a/jlU8S6jtOAQO7MWnMTV6xk2v+XK4mE9X9DHOzO6hCoY9/mak/X5/aHjvN7uei8nfuf9Ch7wLRiH/pXHV6aKnuIoq2gC4k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778621453; c=relaxed/simple;
	bh=E4de2yJLbPlG+G4Xke/Sqplwk8ZyhA8kD3ynAicpMcY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=LOZ/fBAddfdtZooCK4H+vUhyj6WEy0RXEmvEAumufo5qMRXiRp123ZmI/Vy1KYC52XdPgO5SDYmBn54/8Fg0JhIQbA0NOUGD0uRpCcJrWGjGwAcY+a/3x4U1RiiNBCH3DUskgUvCAZymo6k5DEt4uHHpQA7qRZQvok3Hn37QZh0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=poCD6UHQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="poCD6UHQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38ADEC2BCB0
	for <linux-wireless@vger.kernel.org>; Tue, 12 May 2026 21:30:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778621453;
	bh=E4de2yJLbPlG+G4Xke/Sqplwk8ZyhA8kD3ynAicpMcY=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=poCD6UHQSQ0V1KWO1+D0bqL36p1rxQceY6vzgw3Nterodo1SakAgvi7SlkyxTnxyd
	 1bSoRwGoDntmuHXyyYxrGwXWuwj/n64/Napoc3FK9QyHj2sUaMENwhXrY1UvgOaJNp
	 EqStv5QDmT1bWunICSRdkdQ0ojoYgkmmxH/Zi5rSWpER/hhnkOMWn3N4YGV9oFiXIm
	 xjpOfwpt8lUUldBnxDQb+Rn7W/xfVwYTEM0umseXuJDDM4Nff+dHw+f92bIWhtJ1WV
	 6IskvCwsQIT/1f2X3sDubwQ+UBwd3PpArxm0XctFsWFxOTvQhC8DbVNIxdKwcDL9SV
	 1S51jIbJB4BLA==
Received: by mail-lj1-f173.google.com with SMTP id 38308e7fff4ca-393c40246afso62900171fa.1
        for <linux-wireless@vger.kernel.org>; Tue, 12 May 2026 14:30:53 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ+D0W5PFHyPiyGQ7XmHV8ZFpZF6QTZiw79KuJHbMPAVctL1JYva8LWQSBMzReTpe61DFirVNu505M55bTXICA==@vger.kernel.org
X-Gm-Message-State: AOJu0Yy6t6k1RkGxYQ0BdHxVqVf2XcIJGPZPLOcEeCjU4C1wSDoCEHbN
	LITYKxLtx9toK2zr2Ri454nJncEXeIe45XWutFlX5bYkdTeh0JYaNf4jn+3JjeetwdjudIjmKSQ
	l/Ctp/7ovRqGvNZMV+weCL6PiRbl4vMI=
X-Received: by 2002:a05:651c:41ca:b0:38e:af87:8dee with SMTP id
 38308e7fff4ca-3944b5e861amr1589261fa.22.1778621451654; Tue, 12 May 2026
 14:30:51 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260505055252.2558613-1-jb.tsai@mediatek.com>
In-Reply-To: <20260505055252.2558613-1-jb.tsai@mediatek.com>
From: Sean Wang <sean.wang@kernel.org>
Date: Tue, 12 May 2026 16:30:39 -0500
X-Gmail-Original-Message-ID: <CAGp9LzpTJLsU_TB+6Cvm1Nhdqkpb7fR0x2WvFBuJMx=M4YrOew@mail.gmail.com>
X-Gm-Features: AVHnY4Lu3a-eF3cWb90dimr7Dumz8Hes-hAWpwnScfeLfC8Xde4ar-Ji9XMwUk0
Message-ID: <CAGp9LzpTJLsU_TB+6Cvm1Nhdqkpb7fR0x2WvFBuJMx=M4YrOew@mail.gmail.com>
Subject: Re: [PATCH] wifi: mt76: mt7925: Add coredump callback in pci_driver
To: JB Tsai <jb.tsai@mediatek.com>
Cc: nbd@nbd.name, lorenzo@kernel.org, linux-wireless@vger.kernel.org, 
	linux-mediatek@lists.infradead.org, Deren.Wu@mediatek.com, 
	Sean.Wang@mediatek.com, Quan.Zhou@mediatek.com, Ryder.Lee@mediatek.com, 
	Leon.Yen@mediatek.com, litien.chang@mediatek.com, jeff.hsu@mediatek.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi,

On Tue, May 5, 2026 at 12:53=E2=80=AFAM JB Tsai <jb.tsai@mediatek.com> wrot=
e:
>
> From: Jeff Hsu <Jeff.Hsu@mediatek.com>
>
> Register coredump callback(mt7925_coredump) in pci_driver,
> it can let platform can trigger core dump to collect the
> log and recover back after coredump complete without debugfs
>
> Some platform not have debugfs
>
> Signed-off-by: Jeff Hsu <Jeff.Hsu@mediatek.com>
> ---
>  drivers/net/wireless/mediatek/mt76/mt7925/mcu.c |  1 +
>  drivers/net/wireless/mediatek/mt76/mt7925/pci.c | 12 ++++++++++++
>  2 files changed, 13 insertions(+)
>
> diff --git a/drivers/net/wireless/mediatek/mt76/mt7925/mcu.c b/drivers/ne=
t/wireless/mediatek/mt76/mt7925/mcu.c
> index 37cdf3e8a067..cd502166a7f9 100644
> --- a/drivers/net/wireless/mediatek/mt76/mt7925/mcu.c
> +++ b/drivers/net/wireless/mediatek/mt76/mt7925/mcu.c
> @@ -1014,6 +1014,7 @@ int mt7925_mcu_chip_config(struct mt792x_dev *dev, =
const char *cmd)
>         return mt76_mcu_send_msg(&dev->mt76, MCU_UNI_CMD(CHIP_CONFIG),
>                                  &req, sizeof(req), false);
>  }
> +EXPORT_SYMBOL_GPL(mt7925_mcu_chip_config);
>
>  int mt7925_mcu_set_deep_sleep(struct mt792x_dev *dev, bool enable)
>  {
> diff --git a/drivers/net/wireless/mediatek/mt76/mt7925/pci.c b/drivers/ne=
t/wireless/mediatek/mt76/mt7925/pci.c
> index c4161754c01d..5b3e62e5f157 100644
> --- a/drivers/net/wireless/mediatek/mt76/mt7925/pci.c
> +++ b/drivers/net/wireless/mediatek/mt76/mt7925/pci.c
> @@ -610,6 +610,17 @@ static int mt7925_pci_restore(struct device *device)
>         return _mt7925_pci_resume(device, true);
>  }
>
> +static void mt7925_coredump(struct device *dev)
> +{
> +       struct pci_dev *pdev =3D to_pci_dev(device);

There is a build error on this line.

../drivers/net/wireless/mediatek/mt76/mt7925/pci.c: In function
=E2=80=98mt7925_coredump=E2=80=99:
../drivers/net/wireless/mediatek/mt76/mt7925/pci.c:682:43: error:
=E2=80=98device=E2=80=99 undeclared (first use in this function)
  682 |         struct pci_dev *pdev =3D to_pci_dev(device);
      |                                           ^~~~~~
../include/linux/container_of.h:20:33: note: in definition of macro
=E2=80=98container_of=E2=80=99
   20 |         void *__mptr =3D (void *)(ptr);
         \
      |                                 ^~~
../drivers/net/wireless/mediatek/mt76/mt7925/pci.c:682:32: note: in
expansion of macro =E2=80=98to_pci_dev=E2=80=99
  682 |         struct pci_dev *pdev =3D to_pci_dev(device);
      |                                ^~~~~~~~~~
../drivers/net/wireless/mediatek/mt76/mt7925/pci.c:682:43: note: each
undeclared identifier is reported only once for each function it
appears in
  682 |         struct pci_dev *pdev =3D to_pci_dev(device);
      |                                           ^~~~~~
../include/linux/container_of.h:20:33: note: in definition of macro
=E2=80=98container_of=E2=80=99
   20 |         void *__mptr =3D (void *)(ptr);

> +       struct mt76_dev *mdev =3D pci_get_drvdata(pdev);
> +       struct mt792x_dev *dev_792x =3D container_of(mdev, struct mt792x_=
dev, mt76);
> +
> +       mt792x_mutex_acquire(dev_792x);
> +       mt7925_mcu_chip_config(dev_792x, "assert");
> +       mt792x_mutex_release(dev_792x);
> +}
> +
>  static const struct dev_pm_ops mt7925_pm_ops =3D {
>         .suspend =3D pm_sleep_ptr(mt7925_pci_suspend),
>         .resume  =3D pm_sleep_ptr(mt7925_pci_resume),
> @@ -626,6 +637,7 @@ static struct pci_driver mt7925_pci_driver =3D {
>         .remove         =3D mt7925_pci_remove,
>         .shutdown       =3D mt7925_pci_shutdown,
>         .driver.pm      =3D pm_sleep_ptr(&mt7925_pm_ops),
> +       .driver.coredump =3D mt7925_coredump,
>  };
>
>  module_pci_driver(mt7925_pci_driver);
> --
> 2.45.2
>
>

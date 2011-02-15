Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.deathmatch.net ([72.66.92.28]:1109 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752531Ab1BOOov (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Feb 2011 09:44:51 -0500
Date: Tue, 15 Feb 2011 09:44:45 -0500
From: me@bobcopeland.com
To: =?utf-8?B?0J3QuNC60L7Qu9Cw0Lkg0JvQtdC00L7QstGB0LrQuNGF?=
	<nledovskikh@gmail.com>
Cc: linville@tuxdriver.com, ath5k-devel@lists.ath5k.org,
	linux-wireless@vger.kernel.org, lrodriguez@atheros.com,
	mickflemm@gmail.com, jirislaby@gmail.com
Subject: Re: [PATCH] ath5k: Use mips generic dma-mapping functions to avoid
	seqfault on AHB chips
Message-ID: <20110215144445.GA6066@hash.localnet>
References: <AANLkTinqN4MjWz4y5D195f9J8vob42GsG9u39xX-RuJf@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <AANLkTinqN4MjWz4y5D195f9J8vob42GsG9u39xX-RuJf@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Feb 15, 2011 at 02:29:13PM +0000, Николай Ледовских wrote:
> This patch fixes seqfault on ar2316 and other AHB based chips.

Ok, but I'm guessing it also breaks PCI functionality?

>      struct ath5k_softc *sc = common->priv;
> -    struct platform_device *pdev = to_platform_device(sc->dev);
> +    struct platform_device *pdev =
> to_platform_device(wiphy_dev(sc->hw->wiphy));

Your patch got wrapped strangely here...

> -    mem = ioremap_nocache(res->start, res->end - res->start + 1);
> +    mem = res->start;

Won't this break iommu platforms?

> +    SET_IEEE80211_DEV(hw, &pdev->dev);
> 
> -    sc->dev = &pdev->dev;
> +    sc->dev = NULL;

>      /* Initialize driver private data */
> -    SET_IEEE80211_DEV(hw, sc->dev);

> @@ -216,6 +216,7 @@ ath5k_pci_probe(struct pci_dev *pdev,
>          ret = -ENOMEM;
>          goto err_map;
>      }
> +    SET_IEEE80211_DEV(hw, &pdev->dev);

This set of changes needs some rationale...  in other words, what is
the real problem the patch fixes?

-- 
Bob Copeland %% www.bobcopeland.com


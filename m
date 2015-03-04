Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ie0-f171.google.com ([209.85.223.171]:33516 "EHLO
	mail-ie0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752642AbbCDWXd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Mar 2015 17:23:33 -0500
MIME-Version: 1.0
In-Reply-To: <BLU436-SMTP3656F4A0610686DAE30BA1B9110@phx.gbl>
References: <BLU436-SMTP3656F4A0610686DAE30BA1B9110@phx.gbl>
Date: Wed, 4 Mar 2015 23:23:32 +0100
Message-ID: <CACna6rw03OfforxrV5nWLYTUW64BQ-vvH9TuZqK2q9__2Y0edA@mail.gmail.com> (sfid-20150304_232350_199915_64F5DDA8)
Subject: Re: [PATCH] bcma: Kconfig: Let it depend on PCI
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Chen Gang <xili_gchen_5257@hotmail.com>,
	Kalle Valo <kvalo@codeaurora.org>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	Hauke Mehrtens <hauke@hauke-m.de>,
	Arnd Bergmann <arnd@arndb.de>, Jim Davis <jim.epost@gmail.com>,
	=?UTF-8?Q?Michael_B=C3=BCsch?= <m@bues.ch>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 3 March 2015 at 22:16, Chen Gang <xili_gchen_5257@hotmail.com> wrote:
> bcma also needs PCI, just like IOMEM and DMA, so let it depend on PCI,
> or will cause building break for allmodconfig under c6x:
>
>     CC [M]  drivers/bcma/driver_pcie2.o
>   drivers/bcma/driver_pcie2.c: In function 'bcma_core_pcie2_up':
>   drivers/bcma/driver_pcie2.c:196:8: error: implicit declaration of function 'pcie_set_readrq' [-Werror=implicit-function-declaration]
>     err = pcie_set_readrq(dev, pcie2->reqsize);
>           ^
>
> Signed-off-by: Chen Gang <gang.chen.5i5j@gmail.com>
> ---
>  drivers/bcma/Kconfig | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/bcma/Kconfig b/drivers/bcma/Kconfig
> index 0ee48be..8be284e 100644
> --- a/drivers/bcma/Kconfig
> +++ b/drivers/bcma/Kconfig
> @@ -1,6 +1,6 @@
>  config BCMA_POSSIBLE
>         bool
> -       depends on HAS_IOMEM && HAS_DMA
> +       depends on HAS_IOMEM && HAS_DMA && PCI
>         default y
>
>  menu "Broadcom specific AMBA"
> --
> 1.9.3

Kalle, I guess the recent discussion and work on this problem could be
confusing, so let me try to sum it up it a bit.

First of all, please note there are 3 awaiting bcma patches that
should be applied independently of what we decide to do with this
patch. They are of course inspired by the recent building problems.
List of these patches:
[PATCH next] bcma: make bcma_host_pci_(up|down) calls safe for every config
[PATCH next] bcma: move internal function declarations to private header
[PATCH next] bcma: prepare Kconfig symbol for PCI driver

Now, the building problem is obviously caused by me, my work on
driver_pcie2.c and using pcie_set_readrq there without making sure
that is PCI available. I'm sorry for that.

All 3 above patches are moving us toward the the most optimal solution
of this problem. Depending on PCI only when it's really required.
There is still one more change missing that I'm working on. It'll take
me about 2 more days to get the last patch.
On the other way, patch proposed by Chen fixes building problem right
now. It's much simpler but bumps bcma requirements a bit too high.
bcma doesn't really have to depend on PCI.

So you have 2 options there and I'll be happy with whatever you choose to do:
1) Pick Chen patch now and in ~2 days apply my final fix + revert Chen patch.
2) Wait 2 days for the final fix from me.

-- 
Rafał

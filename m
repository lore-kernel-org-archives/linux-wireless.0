Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.nanl.de ([217.115.11.12]:40814 "EHLO mail.nanl.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750971Ab3FYSBg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Jun 2013 14:01:36 -0400
Received: from mail-ve0-x22a.google.com (mail-ve0-x22a.google.com [IPv6:2607:f8b0:400c:c01::22a])
	by mail.nanl.de (Postfix) with ESMTPSA id D051645FB6
	for <linux-wireless@vger.kernel.org>; Tue, 25 Jun 2013 18:01:25 +0000 (UTC)
Received: by mail-ve0-f170.google.com with SMTP id 14so10495173vea.1
        for <linux-wireless@vger.kernel.org>; Tue, 25 Jun 2013 11:01:28 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1372174495-14471-1-git-send-email-zajec5@gmail.com>
References: <1372174495-14471-1-git-send-email-zajec5@gmail.com>
From: Jonas Gorski <jogo@openwrt.org>
Date: Tue, 25 Jun 2013 20:01:08 +0200
Message-ID: <CAOiHx=mHVhg93pRyq7Qg1H9iTnScGtCUeOoxBxpeHuH6pW2XYQ@mail.gmail.com> (sfid-20130625_200139_828445_330ADEF2)
Subject: Re: [RFC][PATCH] b43: replace B43_BCMA_EXTRA with modparam allhwsupport
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Cc: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	b43-dev@lists.infradead.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jun 25, 2013 at 5:34 PM, Rafał Miłecki <zajec5@gmail.com> wrote:
> This allows enabling support for extra hardware with just a module
> param, without kernel/module recompilation.
>
> Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
> ---
>  drivers/net/wireless/b43/Kconfig |    6 ------
>  drivers/net/wireless/b43/main.c  |   16 ++++++++++++++--
>  2 files changed, 14 insertions(+), 8 deletions(-)
>
> diff --git a/drivers/net/wireless/b43/Kconfig b/drivers/net/wireless/b43/Kconfig
> index 3f21e0b..51ff0b1 100644
> --- a/drivers/net/wireless/b43/Kconfig
> +++ b/drivers/net/wireless/b43/Kconfig
> @@ -31,12 +31,6 @@ config B43_BCMA
>         depends on B43 && (BCMA = y || BCMA = B43)
>         default y
>
> -config B43_BCMA_EXTRA
> -       bool "Hardware support that overlaps with the brcmsmac driver"
> -       depends on B43_BCMA
> -       default n if BRCMSMAC
> -       default y
> -
>  config B43_SSB
>         bool
>         depends on B43 && (SSB = y || SSB = B43)
> diff --git a/drivers/net/wireless/b43/main.c b/drivers/net/wireless/b43/main.c
> index a95b77a..583993c 100644
> --- a/drivers/net/wireless/b43/main.c
> +++ b/drivers/net/wireless/b43/main.c
> @@ -113,13 +113,19 @@ static int b43_modparam_pio = 0;
>  module_param_named(pio, b43_modparam_pio, int, 0644);
>  MODULE_PARM_DESC(pio, "Use PIO accesses by default: 0=DMA, 1=PIO");
>
> +#ifdef CONFIG_BRCMSMAC

This is only defined if BRCMSMAC is built-in, but not if it is built
as a module; then it's CONFIG_BRCMSMAC_MODULE, which is probably not
what you want. To easily catch both, use IS_ENABLED(CONFIG_BRCMSMAC).

> +static int modparam_allhwsupport;
> +#else
> +static int modparam_allhwsupport = 1;
> +#endif

And since IS_ENABLED returns 0 or 1 you should be able to reduce it to one line:

static int modparam_allhwsupport = !IS_ENABLED(CONFIG_BRCMSMAC);


Jonas

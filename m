Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f174.google.com ([209.85.217.174]:42700 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750889Ab2DXFBC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Apr 2012 01:01:02 -0400
Received: by lbbgf7 with SMTP id gf7so256628lbb.19
        for <linux-wireless@vger.kernel.org>; Mon, 23 Apr 2012 22:01:00 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAJe1HzND5WO9i2dJt41WP6VPax9=yAjvoENdROLDxo2g4QVm_A@mail.gmail.com>
References: <CAJe1HzND5WO9i2dJt41WP6VPax9=yAjvoENdROLDxo2g4QVm_A@mail.gmail.com>
From: Julian Calaby <julian.calaby@gmail.com>
Date: Tue, 24 Apr 2012 15:00:40 +1000
Message-ID: <CAGRGNgWtM4HgLmfNx9ZQU3xEejiRWhQO=jJfFo2-PEeLjmBOnw@mail.gmail.com> (sfid-20120424_070107_311372_2EE37247)
Subject: Re: [PATCH 3.4-rc4 1/1] mwifiex: add support for SD8786 sdio
To: Jason Plum <max@warheads.net>
Cc: Bing Zhao <bzhao@marvell.com>, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Jason,

On Tue, Apr 24, 2012 at 14:41, Jason Plum <max@warheads.net> wrote:
> From: Jason Plum <max@warheads.net>
>
> Date:   Mon Apr 23 23:54:47 2012 -0400
>
>    mwifiex: add support for SD8786 sdio

> diff --git a/drivers/net/wireless/mwifiex/Kconfig
> b/drivers/net/wireless/mwifiex/Kconfig
> index 2a078ce..48c4c32 100644
> --- a/drivers/net/wireless/mwifiex/Kconfig
> +++ b/drivers/net/wireless/mwifiex/Kconfig
> @@ -10,12 +10,12 @@ config MWIFIEX
>          mwifiex.
>
>  config MWIFIEX_SDIO
> -       tristate "Marvell WiFi-Ex Driver for SD8787/SD8797"
> +       tristate "Marvell WiFi-Ex Driver for SD8786/SD8787/SD8797"
>        depends on MWIFIEX && MMC
>        select FW_LOADER
>        ---help---
>          This adds support for wireless adapters based on Marvell
> -         8787/8797 chipsets with SDIO interface.
> +         8786/8787/8797 chipsets with SDIO interface.
>
>          If you choose to build it as a module, it will be called
>          mwifiex_sdio.
> diff --git a/drivers/net/wireless/mwifiex/sdio.c
> b/drivers/net/wireless/mwifiex/sdio.c
> index f8012e2..74981ab 100644
> --- a/drivers/net/wireless/mwifiex/sdio.c
> +++ b/drivers/net/wireless/mwifiex/sdio.c
> @@ -250,6 +250,8 @@ static int mwifiex_sdio_resume(struct device *dev)
>        return 0;
>  }
>
> +/* Device ID for SD8786 */
> +#define SDIO_DEVICE_ID_MARVELL_8786   (0x9116)
>  /* Device ID for SD8787 */
>  #define SDIO_DEVICE_ID_MARVELL_8787   (0x9119)
>  /* Device ID for SD8797 */
> @@ -257,6 +259,7 @@ static int mwifiex_sdio_resume(struct device *dev)

The rest of the patch doesn't seem to have made it to the list.

Do you want to resend it?

Thanks,

-- 
Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
.Plan: http://sites.google.com/site/juliancalaby/

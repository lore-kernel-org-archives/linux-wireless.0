Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ig0-f194.google.com ([209.85.213.194]:35760 "EHLO
	mail-ig0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752660AbcALXSe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Jan 2016 18:18:34 -0500
Received: by mail-ig0-f194.google.com with SMTP id mw1so16088284igb.2
        for <linux-wireless@vger.kernel.org>; Tue, 12 Jan 2016 15:18:33 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1452584395-24910-10-git-send-email-glen.lee@atmel.com>
References: <1452584395-24910-1-git-send-email-glen.lee@atmel.com> <1452584395-24910-10-git-send-email-glen.lee@atmel.com>
From: Julian Calaby <julian.calaby@gmail.com>
Date: Wed, 13 Jan 2016 10:18:14 +1100
Message-ID: <CAGRGNgXMezjrT3Uec_MMQ0goCHyPjhDF4OjD=kJ-ukeCiTARGg@mail.gmail.com> (sfid-20160113_001843_686177_244ABB50)
Subject: Re: [PATCH 09/26] staging: wilc1000: use unified firmware
To: Glen Lee <glen.lee@atmel.com>
Cc: Greg KH <gregkh@linuxfoundation.org>,
	"devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Tony Cho <tony.cho@atmel.com>, leo.kim@atmel.com,
	Austin Shin <austin.shin@atmel.com>, adel.noureldin@atmel.com,
	adham.abozaeid@atmel.com, Nicolas.FERRE@atmel.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Glen,

On Tue, Jan 12, 2016 at 6:39 PM, Glen Lee <glen.lee@atmel.com> wrote:
> Use a unified firmware for all mode of operations which are station, ap and
> p2p. Two firmware are introduced for 1002 and 1003 chipset.
>
> Signed-off-by: Glen Lee <glen.lee@atmel.com>
> ---
>  drivers/staging/wilc1000/Makefile     |  5 ++---
>  drivers/staging/wilc1000/linux_wlan.c | 18 +++++++++---------
>  2 files changed, 11 insertions(+), 12 deletions(-)
>
> diff --git a/drivers/staging/wilc1000/Makefile b/drivers/staging/wilc1000/Makefile
> index 20a5cb9..90c3760 100644
> --- a/drivers/staging/wilc1000/Makefile
> +++ b/drivers/staging/wilc1000/Makefile
> @@ -1,8 +1,7 @@
>  obj-$(CONFIG_WILC1000) += wilc1000.o
>
> -ccflags-y += -DSTA_FIRMWARE=\"atmel/wilc1000_fw.bin\" \
> -               -DAP_FIRMWARE=\"atmel/wilc1000_ap_fw.bin\" \
> -               -DP2P_CONCURRENCY_FIRMWARE=\"atmel/wilc1000_p2p_fw.bin\"
> +ccflags-y += -DFIRMWARE_1002=\"atmel/wilc1002_firmware.bin\" \
> +               -DFIRMWARE_1003=\"atmel/wilc1003_firmware.bin\"

You can probably put these defines in a header somewhere instead of here.

Also, are these firmwares publicly available and have they been
submitted to linux-firmware?

Thanks,

-- 
Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/

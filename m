Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wr1-f68.google.com ([209.85.221.68]:42301 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753635AbeGEOuX (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 5 Jul 2018 10:50:23 -0400
Received: by mail-wr1-f68.google.com with SMTP id p1-v6so1332395wrs.9
        for <linux-wireless@vger.kernel.org>; Thu, 05 Jul 2018 07:50:23 -0700 (PDT)
Date: Thu, 5 Jul 2018 16:50:19 +0200
From: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: linux-wireless@vger.kernel.org, Felix Fietkau <nbd@nbd.name>,
        Hans Ulli Kroll <ulli.kroll@googlemail.com>,
        Jakub Kicinski <kubakici@wp.pl>,
        Michal Schmidt <mschmidt@redhat.com>,
        linux-mediatek@lists.infradead.org
Subject: Re: [PATCH 11/11] mt76: Kconfig and Makefile for mt76x0 driver
Message-ID: <20180705145018.GA17524@localhost.localdomain> (sfid-20180705_165228_392653_68F4895B)
References: <1530771142-4118-1-git-send-email-sgruszka@redhat.com>
 <1530771142-4118-12-git-send-email-sgruszka@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1530771142-4118-12-git-send-email-sgruszka@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Jul 05, Stanislaw Gruszka wrote:
> Add Kconfig and Makefiles for mt76x0 driver. Now the driver
> can be build.
> 
> Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
> ---
>  drivers/net/wireless/mediatek/mt76/Kconfig         | 7 +++++++
>  drivers/net/wireless/mediatek/mt76/Makefile        | 1 +
>  drivers/net/wireless/mediatek/mt76/mt76x0/Makefile | 7 +++++++
>  3 files changed, 15 insertions(+)
>  create mode 100644 drivers/net/wireless/mediatek/mt76/mt76x0/Makefile
> 
> diff --git a/drivers/net/wireless/mediatek/mt76/Kconfig b/drivers/net/wireless/mediatek/mt76/Kconfig
> index fc05d79c80d0..84854736809a 100644
> --- a/drivers/net/wireless/mediatek/mt76/Kconfig
> +++ b/drivers/net/wireless/mediatek/mt76/Kconfig
> @@ -1,6 +1,13 @@
>  config MT76_CORE
>  	tristate
>  
> +config MT76x0U
> +	tristate "MediaTek MT76x0U (USB) support"
> +	depends on MAC80211
> +	depends on USB
> +	help
> +	  This adds support for MT7610U-based wireless USB dongles.
> +
>  config MT76x2E
>  	tristate "MediaTek MT76x2E (PCIe) support"
>  	select MT76_CORE
> diff --git a/drivers/net/wireless/mediatek/mt76/Makefile b/drivers/net/wireless/mediatek/mt76/Makefile
> index a0156bc01dea..08f93127e9e7 100644
> --- a/drivers/net/wireless/mediatek/mt76/Makefile
> +++ b/drivers/net/wireless/mediatek/mt76/Makefile
> @@ -1,4 +1,5 @@
>  obj-$(CONFIG_MT76_CORE) += mt76.o
> +obj-$(CONFIG_MT76x0U) += mt76x0/
>  obj-$(CONFIG_MT76x2E) += mt76x2e.o
>  
>  mt76-y := \
> diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/Makefile b/drivers/net/wireless/mediatek/mt76/mt76x0/Makefile
> new file mode 100644
> index 000000000000..7843908261ba
> --- /dev/null
> +++ b/drivers/net/wireless/mediatek/mt76/mt76x0/Makefile
> @@ -0,0 +1,7 @@
> +obj-$(CONFIG_MT76x0U)    += mt76x0.o
> +
> +mt76x0-objs	= \
> +	usb.o init.o main.o mcu.o trace.o dma.o eeprom.o phy.o \

There is no main.c source file, is it a leftover from previous implementation?
Moreover compiling the driver (and fixing conflicts with mt76x2u) I have:

ERROR: "mt76x0_ops" [drivers/net/wireless/mediatek/mt76/mt76x0/mt76x0.ko] undefined!

Regards,
Lorenzo

> +	mac.o util.o debugfs.o tx.o core.o
> +# ccflags-y := -DDEBUG
> +CFLAGS_trace.o := -I$(src)
> -- 
> 1.9.3
> 

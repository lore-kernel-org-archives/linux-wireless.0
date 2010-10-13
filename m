Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:36099 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752286Ab0JMLyv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Oct 2010 07:54:51 -0400
MIME-Version: 1.0
In-Reply-To: <1286967439-705-1-git-send-email-csanjay@mistralsolutions.com>
References: <1286967439-705-1-git-send-email-csanjay@mistralsolutions.com>
From: Ohad Ben-Cohen <ohad@wizery.com>
Date: Wed, 13 Oct 2010 13:54:30 +0200
Message-ID: <AANLkTinusH4eA1DsUekuA17GRkyy9TK14JJQcZfz4wqk@mail.gmail.com>
Subject: Re: [RFC: WL1271 DC supprot on OMAP3EVM 0/5]
To: csanjay@mistralsolutions.com
Cc: linux-omap@vger.kernel.org, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Sanjay,

On Wed, Oct 13, 2010 at 12:57 PM,  <csanjay@mistralsolutions.com> wrote:
> Sanjay Kumar Champati (5):
>  ARM: Supported MMC 2 features for OMAP3EVM
>  ARM: Supported for Standard SDIO driver on OMAP3EVM for WL1271 DC
>  ARM: Supported for BT enable on OMAP3EVM for WL1271 DC
>  ARM: Added ALSA audio support for WL1271 DC over the PCM interface
>    (OMAP37XX)
>  Supported BT and WLAN configuration for WL1271 over the OMAP37XX

There are many things to say here but maybe the most important one is
that it seems you are trying to push changes that are only relevant
for an out-of-tree driver, and such changes will never be accepted.

Why don't you try out the mainline wl1271 driver on your board and
come back with the necessary changes for that ?

Thanks,
Ohad.


>
>  arch/arm/configs/omap3_evm_defconfig |   27 +++++++-
>  arch/arm/mach-omap2/board-omap3evm.c |   28 ++++++++-
>  arch/arm/mach-omap2/mmc-twl4030.c    |    1 +
>  arch/arm/mach-omap2/mmc-twl4030.h    |    2 +
>  drivers/bluetooth/Kconfig            |    7 ++
>  drivers/char/tty_io.c                |  110 ++++++++++++++++++++++++++++++++++
>  drivers/mmc/core/sdio_ops.c          |    7 ++-
>  drivers/net/wireless/Kconfig         |   11 ++++
>  sound/soc/omap/Kconfig               |    6 ++
>  sound/soc/omap/Makefile              |    2 +
>  sound/soc/omap/omap3evm.c            |   81 ++++++++++++++++++++++++-
>  sound/soc/omap/wl1271bt.c            |   59 ++++++++++++++++++
>  sound/soc/omap/wl1271bt.h            |   16 +++++
>  13 files changed, 350 insertions(+), 7 deletions(-)
>  create mode 100644 sound/soc/omap/wl1271bt.c
>  create mode 100644 sound/soc/omap/wl1271bt.h
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-omap" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arrakis.dune.hu ([78.24.191.176]:51623 "EHLO arrakis.dune.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750844AbbGEI76 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 5 Jul 2015 04:59:58 -0400
Received: from localhost (localhost [127.0.0.1])
	by arrakis.dune.hu (Postfix) with ESMTP id 2193B280091
	for <linux-wireless@vger.kernel.org>; Sat,  4 Jul 2015 12:40:49 +0200 (CEST)
Received: from mail-qk0-f179.google.com (mail-qk0-f179.google.com [209.85.220.179])
	by arrakis.dune.hu (Postfix) with ESMTPSA id 85338280631
	for <linux-wireless@vger.kernel.org>; Sat,  4 Jul 2015 12:40:35 +0200 (CEST)
Received: by qkbp125 with SMTP id p125so87453275qkb.2
        for <linux-wireless@vger.kernel.org>; Sat, 04 Jul 2015 03:40:41 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <92d77d0990b94d23ae66fb69fb55a6fb@SC-EXCH02.marvell.com>
References: <92d77d0990b94d23ae66fb69fb55a6fb@SC-EXCH02.marvell.com>
From: Jonas Gorski <jogo@openwrt.org>
Date: Sat, 4 Jul 2015 12:40:21 +0200
Message-ID: <CAOiHx=ncv=N33-CC-F0=_dovJ=PGsi3MBB3SEMg51fWcyuMmPg@mail.gmail.com> (sfid-20150705_110002_388645_2C89C6D5)
Subject: Re: [PATCH v5] Add new mac80211 driver mwlwifi.
To: David Lin <dlin@marvell.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Chor Teck Law <ctlaw@marvell.com>,
	Pete Hsieh <peteh@marvell.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

On Fri, Jul 3, 2015 at 8:10 AM, David Lin <dlin@marvell.com> wrote:
> The Linux driver for WRT1900AC. The work was initially developed as part of
> openwrt effort and maintained on https://github.com/kaloz/mwlwifi.
>
> This is still work in progress, with 8864 chipset more mature and tested,
> while 8897 for the similar use case is added recently.
>
> Signed-off-by: David Lin <dlin@marvell.com>
> ---
>  drivers/net/wireless/Kconfig             |    1 +
>  drivers/net/wireless/Makefile            |    2 +
>  drivers/net/wireless/mwlwifi/Kconfig     |   24 +
>  drivers/net/wireless/mwlwifi/MAINTAINERS |    5 +
>  drivers/net/wireless/mwlwifi/Makefile    |   11 +
>  drivers/net/wireless/mwlwifi/dev.h       |  435 ++++++
>  drivers/net/wireless/mwlwifi/fwcmd.c     | 2278 ++++++++++++++++++++++++++++++
>  drivers/net/wireless/mwlwifi/fwcmd.h     |  175 +++
>  drivers/net/wireless/mwlwifi/fwdl.c      |  183 +++
>  drivers/net/wireless/mwlwifi/fwdl.h      |   27 +
>  drivers/net/wireless/mwlwifi/hostcmd.h   |  753 ++++++++++
>  drivers/net/wireless/mwlwifi/isr.c       |  148 ++
>  drivers/net/wireless/mwlwifi/isr.h       |   26 +
>  drivers/net/wireless/mwlwifi/mac80211.c  |  739 ++++++++++
>  drivers/net/wireless/mwlwifi/mac80211.h  |   25 +
>  drivers/net/wireless/mwlwifi/main.c      |  856 +++++++++++
>  drivers/net/wireless/mwlwifi/rx.c        |  519 +++++++
>  drivers/net/wireless/mwlwifi/rx.h        |   25 +
>  drivers/net/wireless/mwlwifi/sysadpt.h   |   67 +
>  drivers/net/wireless/mwlwifi/tx.c        |  834 +++++++++++
>  drivers/net/wireless/mwlwifi/tx.h        |   28 +
>  21 files changed, 7161 insertions(+)
>  create mode 100644 drivers/net/wireless/mwlwifi/Kconfig
>  create mode 100644 drivers/net/wireless/mwlwifi/MAINTAINERS
>  create mode 100644 drivers/net/wireless/mwlwifi/Makefile
>  create mode 100644 drivers/net/wireless/mwlwifi/dev.h
>  create mode 100644 drivers/net/wireless/mwlwifi/fwcmd.c
>  create mode 100644 drivers/net/wireless/mwlwifi/fwcmd.h
>  create mode 100644 drivers/net/wireless/mwlwifi/fwdl.c
>  create mode 100644 drivers/net/wireless/mwlwifi/fwdl.h
>  create mode 100644 drivers/net/wireless/mwlwifi/hostcmd.h
>  create mode 100644 drivers/net/wireless/mwlwifi/isr.c
>  create mode 100644 drivers/net/wireless/mwlwifi/isr.h
>  create mode 100644 drivers/net/wireless/mwlwifi/mac80211.c
>  create mode 100644 drivers/net/wireless/mwlwifi/mac80211.h
>  create mode 100644 drivers/net/wireless/mwlwifi/main.c
>  create mode 100644 drivers/net/wireless/mwlwifi/rx.c
>  create mode 100644 drivers/net/wireless/mwlwifi/rx.h
>  create mode 100644 drivers/net/wireless/mwlwifi/sysadpt.h
>  create mode 100644 drivers/net/wireless/mwlwifi/tx.c
>  create mode 100644 drivers/net/wireless/mwlwifi/tx.h
>
> diff --git a/drivers/net/wireless/Kconfig b/drivers/net/wireless/Kconfig
> index a63ab2e..1c60845 100644
> --- a/drivers/net/wireless/Kconfig
> +++ b/drivers/net/wireless/Kconfig
> @@ -284,5 +284,6 @@ source "drivers/net/wireless/zd1211rw/Kconfig"
>  source "drivers/net/wireless/mwifiex/Kconfig"
>  source "drivers/net/wireless/cw1200/Kconfig"
>  source "drivers/net/wireless/rsi/Kconfig"
> +source "drivers/net/wireless/mwlwifi/Kconfig"
>
>  endif # WLAN
> diff --git a/drivers/net/wireless/Makefile b/drivers/net/wireless/Makefile
> index 6b9e729..1fe0f0d 100644
> --- a/drivers/net/wireless/Makefile
> +++ b/drivers/net/wireless/Makefile
> @@ -62,3 +62,5 @@ obj-$(CONFIG_BRCMSMAC)        += brcm80211/
>
>  obj-$(CONFIG_CW1200)   += cw1200/
>  obj-$(CONFIG_RSI_91X)  += rsi/
> +
> +obj-$(CONFIG_MWLWIFI)  += mwlwifi/
> diff --git a/drivers/net/wireless/mwlwifi/Kconfig b/drivers/net/wireless/mwlwifi/Kconfig
> new file mode 100644
> index 0000000..3732223
> --- /dev/null
> +++ b/drivers/net/wireless/mwlwifi/Kconfig
> @@ -0,0 +1,24 @@
> +config MWLWIFI
> +       tristate "Marvell Wireless Wi-Fi driver (mwlwifi)"

Do you also have wired Wi-Fi cards? ;P

The description seems very generic despite only supporting two chips.
Currently we already have two other marvell drivers claiming to
support "marvell" wireless:

config MWL8K
        tristate "Marvell 88W8xxx PCI/PCIe Wireless support"

config MWIFIEX
        tristate "Marvell WiFi-Ex Driver"

I think it would be good to have some more precise description here
(something like "Marvell 88W8864/8897 PCIe driver with AP support").

> +       depends on PCI && MAC80211
> +       select FW_LOADER
> +       select OF

Please depend on OF instead of selecting it. Unless something changed
recently, forcing OF to y will cause build failures for arches that do
not support OF yet, breaking e.g. allmodconfigs build tests.

> +       ---help---
> +               Select to build the driver supporting the:
> +
> +               Marvell Wireless Wi-Fi 88W8864 modules
> +               Marvell Wireless Wi-Fi 88W8897 modules
> +
> +               This driver uses the kernel's mac80211 subsystem.
> +
> +               If you want to compile the driver as a module (= code which can be
> +               inserted in and removed from the running kernel whenever you want),
> +               say M here and read <file:Documentation/kbuild/modules.txt>.  The
> +               module will be called mwlwifi.
> +
> +               NOTE: Selecting this driver may cause conflict with MWIFIEX driver
> +               that also operates on the same part number 88W8897. Users should
> +               select either MWIFIEX or MWLWIFI, not both. MWIFIEX is fullmac,
> +               supporting more comprehensive client functions for laptops/embedded
> +               devices. MWLWIFI is mac80211-based for full AP/Wireless Bridge.
> +
> diff --git a/drivers/net/wireless/mwlwifi/MAINTAINERS b/drivers/net/wireless/mwlwifi/MAINTAINERS
> new file mode 100644
> index 0000000..5706ce9
> --- /dev/null
> +++ b/drivers/net/wireless/mwlwifi/MAINTAINERS
> @@ -0,0 +1,5 @@
> +MARVELL MWLWIFI WIRELESS DRIVER
> +M:     David Lin <dlin@marvell.com>
> +L:     linux-wireless@vger.kernel.org
> +S:     Maintained
> +F:     drivers/net/wireless/mwlwifi/

Please add this to the top directory MAINTAINERS instead of adding a
separate file (unless adding your own MAINTAINERS is the new thing).


Regards
Jonas

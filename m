Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from coyote.holtmann.net ([212.227.132.17]:33104 "EHLO
        mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932406AbeCOPua (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 15 Mar 2018 11:50:30 -0400
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 11.2 \(3445.5.20\))
Subject: Re: [PATCH] Bluetooth: btrsi: rework dependencies
From: Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <20180315154312.3941446-1-arnd@arndb.de>
Date: Thu, 15 Mar 2018 16:50:27 +0100
Cc: Johan Hedberg <johan.hedberg@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Linux Bluetooth mailing list
        <linux-bluetooth@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        netdev@vger.kernel.org
Message-Id: <EE0D5CBE-0867-4FE0-B157-CA4086C84233@holtmann.org> (sfid-20180315_165046_853708_BED499C5)
References: <20180315154312.3941446-1-arnd@arndb.de>
To: Arnd Bergmann <arnd@arndb.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Arnd,

> The linkage between the bluetooth driver and the wireless
> driver is not defined properly, leading to build problems
> such as:
> 
> warning: (BT_HCIRSI) selects RSI_COEX which has unmet direct dependencies (NETDEVICES && WLAN && WLAN_VENDOR_RSI && BT_HCIRSI && RSI_91X)
> drivers/net/wireless/rsi/rsi_91x_main.o: In function `rsi_read_pkt':
> (.text+0x205): undefined reference to `rsi_bt_ops'
> 
> To actually make it work, we need the following steps:
> 
> - remove the bogus 'select RSI_COEX', this is already covered
>  by the default
> - change RSI_COEX to a 'bool' symbol so that the #ifdefs work
>  all the time
> - ensure that BT_HCIRSI is built-in whenever RSI_91X is built-in
> - prevent BT_HCIRSI from being enabled when CONFIG_BT=m and
>  RSI_91X=y, as this cannot work
> 
> Fixes: 38aa4da50483 ("Bluetooth: btrsi: add new rsi bluetooth driver")
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
> drivers/bluetooth/Kconfig        | 9 ++++++++-
> drivers/bluetooth/Makefile       | 2 +-
> drivers/net/wireless/rsi/Kconfig | 6 +-----
> 3 files changed, 10 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/bluetooth/Kconfig b/drivers/bluetooth/Kconfig
> index d8bbd661dbdb..6b3e8bf69d07 100644
> --- a/drivers/bluetooth/Kconfig
> +++ b/drivers/bluetooth/Kconfig
> @@ -394,8 +394,9 @@ config BT_QCOMSMD
> 
> config BT_HCIRSI
> 	tristate "Redpine HCI support"
> +	depends on RSI_91X
> +	depends on !(BT=m && RSI_91X=y)
> 	default n
> -	select RSI_COEX
> 	help
> 	  Redpine BT driver.
> 	  This driver handles BT traffic from upper layers and pass
> @@ -404,4 +405,10 @@ config BT_HCIRSI
> 	  Say Y here to compile support for HCI over Redpine into the
> 	  kernel or say M to compile as a module.
> 
> +config BT_HCIRSI_MODULE
> +	tristate
> +	# ensure that the BT_HCIRSI driver is visible to the core
> +	default y if BT_HCIRSI=m && RSI_91X=y
> +	default BT_HCIRSI
> +
> endmenu
> diff --git a/drivers/bluetooth/Makefile b/drivers/bluetooth/Makefile
> index 03cfc1b20c4a..9e8d22712ff3 100644
> --- a/drivers/bluetooth/Makefile
> +++ b/drivers/bluetooth/Makefile
> @@ -28,7 +28,7 @@ obj-$(CONFIG_BT_QCA)		+= btqca.o
> 
> obj-$(CONFIG_BT_HCIUART_NOKIA)	+= hci_nokia.o
> 
> -obj-$(CONFIG_BT_HCIRSI)		+= btrsi.o
> +obj-$(CONFIG_BT_HCIRSI_MODULE)	+= btrsi.o

do we need this new option? I have avoided these kind of complex things multi config entries. Can we not just select the RSI_91X?

Regards

Marcel

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:44836 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751119AbeBAHKg (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 1 Feb 2018 02:10:36 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: Amitkumar Karwar <amitkarwar@gmail.com>
Cc: marcel@holtmann.org, linux-wireless@vger.kernel.org,
        Amitkumar Karwar <amit.karwar@redpinesignals.com>,
        Prameela Rani Garnepudi <prameela.j04cs@gmail.com>,
        linux-bluetooth@vger.kernel.org,
        Siva Rebbagondla <siva.rebbagondla@redpinesignals.com>
Subject: Re: [v5 6/8] rsi: handle BT traffic in driver
References: <1513168977-2121-1-git-send-email-amitkarwar@gmail.com>
        <1513168977-2121-7-git-send-email-amitkarwar@gmail.com>
Date: Thu, 01 Feb 2018 09:10:31 +0200
In-Reply-To: <1513168977-2121-7-git-send-email-amitkarwar@gmail.com>
        (Amitkumar Karwar's message of "Wed, 13 Dec 2017 18:12:55 +0530")
Message-ID: <87efm5mbh4.fsf@purkki.adurom.net> (sfid-20180201_081040_405254_371231D5)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Amitkumar Karwar <amitkarwar@gmail.com> writes:

> From: Siva Rebbagondla <siva.rebbagondla@redpinesignals.com>
>
> BT frames are passed through coex and hal modules to BUS.
> After firmware is loaded, based on the operating mode CARD
> READY frame comes for each protocol. When BT card ready is
> received, BT attach is called.
> Protocol operations are exchanged between the modules
> at initialization time.
>
> Signed-off-by: Siva Rebbagondla <siva.rebbagondla@redpinesignals.com>
> Signed-off-by: Prameela Rani Garnepudi <prameela.j04cs@gmail.com>
> Signed-off-by: Amitkumar Karwar <amit.karwar@redpinesignals.com>
> ---
> v5: Same as v3, v4
> v3: bt_ops need not be present structure g_proto_ops. It is removed.
> v2: WLAN module depends on BT module. Updated in Kconfig
> ---
>  drivers/net/wireless/rsi/Kconfig            |  2 +-
>  drivers/net/wireless/rsi/rsi_91x_coex.c     |  4 ++-
>  drivers/net/wireless/rsi/rsi_91x_core.c     | 16 ++++++++----
>  drivers/net/wireless/rsi/rsi_91x_hal.c      | 39 +++++++++++++++++++++++++++++
>  drivers/net/wireless/rsi/rsi_91x_main.c     | 31 +++++++++++++++++++++++
>  drivers/net/wireless/rsi/rsi_91x_sdio_ops.c |  1 +
>  drivers/net/wireless/rsi/rsi_common.h       |  1 +
>  drivers/net/wireless/rsi/rsi_hal.h          | 10 ++++++++
>  drivers/net/wireless/rsi/rsi_main.h         |  3 +++
>  9 files changed, 100 insertions(+), 7 deletions(-)
>
> diff --git a/drivers/net/wireless/rsi/Kconfig b/drivers/net/wireless/rsi/Kconfig
> index 7c5e4ca..ad72c80 100644
> --- a/drivers/net/wireless/rsi/Kconfig
> +++ b/drivers/net/wireless/rsi/Kconfig
> @@ -13,7 +13,7 @@ if WLAN_VENDOR_RSI
>  
>  config RSI_91X
>  	tristate "Redpine Signals Inc 91x WLAN driver support"
> -	depends on MAC80211
> +	depends on MAC80211 && BT_RSI

I think this is evil, now the wlan driver cannot be enabled unless the
bluetooth driver is enabled. And if I'm understanding correctly it won't
even show up in the menuconfig. A much nicer approach would be that
btcoex is just disabled in the wlan driver if BT_RSI is disabled.

-- 
Kalle Valo

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:44576 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934122AbdIZKAA (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 26 Sep 2017 06:00:00 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Amitkumar Karwar <amitkarwar@gmail.com>
Cc: linux-wireless@vger.kernel.org,
        Amitkumar Karwar <amit.karwar@redpinesignals.com>,
        Prameela Rani Garnepudi <prameela.j04cs@gmail.com>,
        Karun Eagalapati <karun256@gmail.com>
Subject: Re: [PATCH 1/3] rsi: sdio: add WOWLAN support for S3 suspend state
References: <1506345695-4654-1-git-send-email-amitkarwar@gmail.com>
Date: Tue, 26 Sep 2017 12:59:54 +0300
In-Reply-To: <1506345695-4654-1-git-send-email-amitkarwar@gmail.com>
        (Amitkumar Karwar's message of "Mon, 25 Sep 2017 18:51:35 +0530")
Message-ID: <87shf96aqt.fsf@kamboji.qca.qualcomm.com> (sfid-20170926_120015_939687_EAD60E5B)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Amitkumar Karwar <amitkarwar@gmail.com> writes:

> From: Karun Eagalapati <karun256@gmail.com>
>
> WoWLAN is supported in RS9113 device through GPIO pin2.
> wowlan config frame is internally sent to firmware in mac80211
> suspend handler. Also beacon miss threshold and keep-alive time
> values are increased to avoid un-necessary disconnection with AP.
>
> Signed-off-by: Karun Eagalapati <karun256@gmail.com>
> Signed-off-by: Amitkumar Karwar <amit.karwar@redpinesignals.com>
> ---
>  drivers/net/wireless/rsi/Kconfig            |   7 ++
>  drivers/net/wireless/rsi/rsi_91x_core.c     |   9 +-
>  drivers/net/wireless/rsi/rsi_91x_mac80211.c | 125 ++++++++++++++++++++++++++++
>  drivers/net/wireless/rsi/rsi_91x_mgmt.c     |  66 +++++++++++++--
>  drivers/net/wireless/rsi/rsi_91x_sdio.c     |  11 +++
>  drivers/net/wireless/rsi/rsi_common.h       |   3 +
>  drivers/net/wireless/rsi/rsi_main.h         |  12 ++-
>  drivers/net/wireless/rsi/rsi_mgmt.h         |  37 +++++++-
>  8 files changed, 258 insertions(+), 12 deletions(-)
>
> diff --git a/drivers/net/wireless/rsi/Kconfig b/drivers/net/wireless/rsi/Kconfig
> index 7c5e4ca..0882b4e 100644
> --- a/drivers/net/wireless/rsi/Kconfig
> +++ b/drivers/net/wireless/rsi/Kconfig
> @@ -42,4 +42,11 @@ config RSI_USB
>  	  This option enables the USB bus support in rsi drivers.
>  	  Select M (recommended), if you have a RSI 1x1 wireless module.
>  
> +config RSI_WOW
> +	bool "Redpine Signals WOWLAN support"
> +	depends on RSI_SDIO && RSI_91X
> +	default y
> +	---help---
> +	 Say Y, if you would like to enable wowlan support for RSI module.

This adds a lot of ifdefs to the code. Is the Kconfig option really
needed?

-- 
Kalle Valo

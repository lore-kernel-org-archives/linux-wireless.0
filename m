Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:35004 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751520AbcDRPpP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Apr 2016 11:45:15 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Lauri Kasanen <cand@gmx.com>
Cc: Christian Lamparter <chunkeey@googlemail.com>,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] carl9170: Clarify kconfig text
References: <20160416113312.8de2266358165182bb4b4a15@gmx.com>
	<1466768.7dLuLFSDol@debian64>
	<20160416171856.1769c0e16bcc75372407e06f@gmx.com>
Date: Mon, 18 Apr 2016 18:45:09 +0300
In-Reply-To: <20160416171856.1769c0e16bcc75372407e06f@gmx.com> (Lauri
	Kasanen's message of "Sat, 16 Apr 2016 17:18:56 +0300")
Message-ID: <87shyiyl8a.fsf@purkki.adurom.net> (sfid-20160418_174534_163276_07EA1C4A)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Lauri Kasanen <cand@gmx.com> writes:

> The previous text was confusing, leading readers to think this
> driver was a duplicate, and so didn't need to be enabled.
>
> After the removal of the older staging driver, this is the only
> driver in mainline for these devices.
>
> Signed-off-by: Lauri Kasanen <cand@gmx.com>
> ---
> v2: Remove the mention of the previous driver, suggested by Christian.
>
>  drivers/net/wireless/ath/carl9170/Kconfig | 8 +++-----
>  1 file changed, 3 insertions(+), 5 deletions(-)
>
> diff --git a/drivers/net/wireless/ath/carl9170/Kconfig b/drivers/net/wireless/ath/carl9170/Kconfig
> index 1a796e5..2e34bae 100644
> --- a/drivers/net/wireless/ath/carl9170/Kconfig
> +++ b/drivers/net/wireless/ath/carl9170/Kconfig
> @@ -5,12 +5,10 @@ config CARL9170
>  	select FW_LOADER
>  	select CRC32
>  	help
> -	  This is another driver for the Atheros "otus" 802.11n USB devices.
> +	  This is the mainline driver for the Atheros "otus" 802.11n USB devices.
>  
> -	  This driver provides more features than the original,
> -	  but it needs a special firmware (carl9170-1.fw) to do that.
> -
> -	  The firmware can be downloaded from our wiki here:
> +	  It needs a special firmware (carl9170-1.fw), which can be downloaded
> +	  from our wiki here:
>  	  <http://wireless.kernel.org/en/users/Drivers/carl9170>

Why even mention anything about a "special firmware" as the firmware is
already available from linux-firmware.git? That's default location for
all firmware images and I think most, if not all, distros should have it
available. So wouldn't it be better not to mention anything about
firmware at all?

-- 
Kalle Valo

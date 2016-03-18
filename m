Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f67.google.com ([209.85.218.67]:33572 "EHLO
	mail-oi0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750753AbcCRCiM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Mar 2016 22:38:12 -0400
Received: by mail-oi0-f67.google.com with SMTP id e22so2021386oib.0
        for <linux-wireless@vger.kernel.org>; Thu, 17 Mar 2016 19:38:11 -0700 (PDT)
Subject: Re: [PATCH MOREWORK 16/19] rtlwifi: Implement 'rtl_addr_delay()' with
 a switch statement
To: Julian Calaby <julian.calaby@gmail.com>,
	Kalle Valo <kvalo@codeaurora.org>
References: <cover.1458262312.git.julian.calaby@gmail.com>
 <bc393706a087bf9746d7e91963e11819a854c4f7.1458262312.git.julian.calaby@gmail.com>
Cc: Chaoming Li <chaoming_li@realsil.com.cn>,
	Johannes Berg <johannes.berg@intel.com>,
	Byeoungwook Kim <quddnr145@gmail.com>,
	Markus Elfring <elfring@users.sourceforge.net>,
	Sara Sharon <sarasharon1@gmail.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Luis Felipe Dominguez Vega <lfdominguez@nauta.cu>,
	linux-wireless@vger.kernel.org
From: Larry Finger <Larry.Finger@lwfinger.net>
Message-ID: <56EB6A10.5030900@lwfinger.net> (sfid-20160318_033815_609327_E965D352)
Date: Thu, 17 Mar 2016 21:38:08 -0500
MIME-Version: 1.0
In-Reply-To: <bc393706a087bf9746d7e91963e11819a854c4f7.1458262312.git.julian.calaby@gmail.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 03/17/2016 09:28 PM, Julian Calaby wrote:
> From: Byeoungwook Kim <quddnr145@gmail.com>
>
> Doing it this way improves readability.
>
> Signed-off-by: Byeoungwook Kim <quddnr145@gmail.com>
> [Rewrote commit message]
> Signed-off-by: Julian Calaby <julian.calaby@gmail.com>
>
> ---
>
> ... or does it.
>
> Honesltly, this is only in this list as Byeoungwook asked about it and I
> can see _some_ sort of reason why it exists.
>
> Larry, if you don't like this, please NACK it and we'll never speak of it
> again.
>
> Thanks,
>
> Julian Calaby
> ---
>   drivers/net/wireless/realtek/rtlwifi/core.c | 20 ++++++++++++++------
>   1 file changed, 14 insertions(+), 6 deletions(-)

I thought I had already NACKed it, but just in case:

NACK.

Larry

>
> diff --git a/drivers/net/wireless/realtek/rtlwifi/core.c b/drivers/net/wireless/realtek/rtlwifi/core.c
> index 0f48048..1cf367f 100644
> --- a/drivers/net/wireless/realtek/rtlwifi/core.c
> +++ b/drivers/net/wireless/realtek/rtlwifi/core.c
> @@ -53,18 +53,26 @@ EXPORT_SYMBOL(channel5g_80m);
>
>   void rtl_addr_delay(u32 addr)
>   {
> -	if (addr == 0xfe)
> +	switch (addr) {
> +	case 0xfe:
>   		msleep(50);
> -	else if (addr == 0xfd)
> +		break;
> +	case 0xfd:
>   		msleep(5);
> -	else if (addr == 0xfc)
> +		break;
> +	case 0xfc:
>   		msleep(1);
> -	else if (addr == 0xfb)
> +		break;
> +	case 0xfb:
>   		usleep_range(50, 100);
> -	else if (addr == 0xfa)
> +		break;
> +	case 0xfa:
>   		usleep_range(5, 10);
> -	else if (addr == 0xf9)
> +		break;
> +	case 0xf9:
>   		usleep_range(1, 2);
> +		break;
> +	}
>   }
>   EXPORT_SYMBOL(rtl_addr_delay);
>
>


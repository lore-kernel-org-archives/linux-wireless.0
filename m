Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw0-f193.google.com ([209.85.161.193]:33790 "EHLO
	mail-yw0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750990AbcCRCpC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Mar 2016 22:45:02 -0400
Received: by mail-yw0-f193.google.com with SMTP id g6so8586775ywb.0
        for <linux-wireless@vger.kernel.org>; Thu, 17 Mar 2016 19:45:01 -0700 (PDT)
Subject: Re: [PATCH 05/19] rtlwifi: use to_delayed_work()
To: Julian Calaby <julian.calaby@gmail.com>,
	Kalle Valo <kvalo@codeaurora.org>
References: <cover.1458262312.git.julian.calaby@gmail.com>
 <1d07f186a933c2d1f0bf1780ab1dcb50d3a808aa.1458262312.git.julian.calaby@gmail.com>
Cc: Chaoming Li <chaoming_li@realsil.com.cn>,
	Geliang Tang <geliangtang@163.com>,
	Hans Ulli Kroll <ulli.kroll@googlemail.com>,
	Colin Ian King <colin.king@canonical.com>,
	linux-wireless@vger.kernel.org
From: Larry Finger <Larry.Finger@lwfinger.net>
Message-ID: <56EB6BAB.5080800@lwfinger.net> (sfid-20160318_034506_344280_A58139E8)
Date: Thu, 17 Mar 2016 21:44:59 -0500
MIME-Version: 1.0
In-Reply-To: <1d07f186a933c2d1f0bf1780ab1dcb50d3a808aa.1458262312.git.julian.calaby@gmail.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 03/17/2016 09:22 PM, Julian Calaby wrote:
> From: Geliang Tang <geliangtang@163.com>
>
> Use to_delayed_work() instead of open-coding it.
>
> Signed-off-by: Geliang Tang <geliangtang@163.com>
> [Update commit message]
> Signed-off-by: Julian Calaby <julian.calaby@gmail.com>

Acked-by: Larry Finger <Larry.Finger@lwfinger.net>

Larry

> ---
>   drivers/net/wireless/realtek/rtlwifi/wifi.h | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/net/wireless/realtek/rtlwifi/wifi.h b/drivers/net/wireless/realtek/rtlwifi/wifi.h
> index 554d814..edece53 100644
> --- a/drivers/net/wireless/realtek/rtlwifi/wifi.h
> +++ b/drivers/net/wireless/realtek/rtlwifi/wifi.h
> @@ -2867,7 +2867,7 @@ value to host byte ordering.*/
>   	(ppsc->cur_ps_level |= _ps_flg)
>
>   #define container_of_dwork_rtl(x, y, z) \
> -	container_of(container_of(x, struct delayed_work, work), y, z)
> +	container_of(to_delayed_work(x), y, z)
>
>   #define FILL_OCTET_STRING(_os, _octet, _len)	\
>   		(_os).octet = (u8 *)(_octet);		\
>


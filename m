Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f173.google.com ([209.85.217.173]:33065 "EHLO
	mail-lb0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752827AbbARLrN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 18 Jan 2015 06:47:13 -0500
Received: by mail-lb0-f173.google.com with SMTP id p9so1054696lbv.4
        for <linux-wireless@vger.kernel.org>; Sun, 18 Jan 2015 03:47:12 -0800 (PST)
Message-ID: <54BB9D3C.90306@cogentembedded.com> (sfid-20150118_124720_838505_98F9EBED)
Date: Sun, 18 Jan 2015 14:47:08 +0300
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
MIME-Version: 1.0
To: Andy Green <andy.green@linaro.org>,
	Kalle Valo <kvalo@codeaurora.org>,
	Eugene Krasnikov <k.eugene.e@gmail.com>
CC: wcn36xx@lists.infradead.org, linux-wireless@vger.kernel.org,
	netdev@vger.kernel.org
Subject: Re: [PATCH 5/7] net: wireless: wcn36xx: swallow two wcn3620 IND messages
References: <20150118050741.31866.36490.stgit@114-36-241-182.dynamic.hinet.net> <20150118051105.31866.43889.stgit@114-36-241-182.dynamic.hinet.net>
In-Reply-To: <20150118051105.31866.43889.stgit@114-36-241-182.dynamic.hinet.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello.

On 1/18/2015 8:11 AM, Andy Green wrote:

> WCN3620 can asynchronously send two new kinds of indication message,
> since we can't handle them just accept them quietly.

> Signed-off-by: Andy Green <andy.green@linaro.org>
> ---
>   drivers/net/wireless/ath/wcn36xx/smd.c |    6 ++++++
>   1 file changed, 6 insertions(+)

> diff --git a/drivers/net/wireless/ath/wcn36xx/smd.c b/drivers/net/wireless/ath/wcn36xx/smd.c
> index 6398693..819741c 100644
> --- a/drivers/net/wireless/ath/wcn36xx/smd.c
> +++ b/drivers/net/wireless/ath/wcn36xx/smd.c
[...]
> @@ -2107,6 +2109,10 @@ static void wcn36xx_ind_smd_work(struct work_struct *work)
>   	msg_header = (struct wcn36xx_hal_msg_header *)hal_ind_msg->msg;
>
>   	switch (msg_header->msg_type) {
> +	case WCN36XX_HAL_COEX_IND:
> +		break;
> +	case WCN36XX_HAL_AVOID_FREQ_RANGE_IND:
> +		break;

    Can't you merge these 2 cases, so that there's only one *break*?

[...]

WBR, Sergei


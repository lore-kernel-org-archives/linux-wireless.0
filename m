Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qt0-f171.google.com ([209.85.216.171]:43880 "EHLO
        mail-qt0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756635AbdKOI4f (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 15 Nov 2017 03:56:35 -0500
Received: by mail-qt0-f171.google.com with SMTP id r58so8777987qtc.0
        for <linux-wireless@vger.kernel.org>; Wed, 15 Nov 2017 00:56:34 -0800 (PST)
Subject: Re: [PATCH 7/8] rsi: add module parameter operating mode
To: Amitkumar Karwar <amitkarwar@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>, marcel@holtmann.org
References: <1510730444-3237-1-git-send-email-amitkarwar@gmail.com>
 <1510730444-3237-8-git-send-email-amitkarwar@gmail.com>
Cc: linux-wireless@vger.kernel.org,
        Amitkumar Karwar <amit.karwar@redpinesignals.com>,
        Prameela Rani Garnepudi <prameela.j04cs@gmail.com>,
        linux-bluetooth@vger.kernel.org,
        Siva Rebbagondla <siva.rebbagondla@redpinesignals.com>
From: Arend van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <5A0C013F.2080103@broadcom.com> (sfid-20171115_095843_246278_D2CA17A1)
Date: Wed, 15 Nov 2017 09:56:31 +0100
MIME-Version: 1.0
In-Reply-To: <1510730444-3237-8-git-send-email-amitkarwar@gmail.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11/15/2017 8:20 AM, Amitkumar Karwar wrote:
> From: Prameela Rani Garnepudi <prameela.j04cs@gmail.com>
>
> Operating mode determines the support for other protocols.
> This is made as module parameter for better usage.
>
> Signed-off-by: Prameela Rani Garnepudi <prameela.j04cs@gmail.com>
> Signed-off-by: Siva Rebbagondla <siva.rebbagondla@redpinesignals.com>
> Signed-off-by: Amitkumar Karwar <amit.karwar@redpinesignals.com>
> ---

[...]

> -struct rsi_hw *rsi_91x_init(void)
> +struct rsi_hw *rsi_91x_init(u16 oper_mode)
>   {
>   	struct rsi_hw *adapter = NULL;
>   	struct rsi_common *common = NULL;
> @@ -320,11 +336,34 @@ struct rsi_hw *rsi_91x_init(void)
>   	spin_lock_init(&adapter->ps_lock);
>   	timer_setup(&common->roc_timer, rsi_roc_timeout, 0);
>   	init_completion(&common->wlan_init_completion);
> +	common->oper_mode = oper_mode;
>   	common->init_done = true;
> -
> -	common->coex_mode = RSI_DEV_COEX_MODE_WIFI_ALONE;
> -	common->oper_mode = RSI_DEV_OPMODE_WIFI_ALONE;
>   	adapter->device_model = RSI_DEV_9113;

Seems there are definitions for coex_mode....
> +
> +	/* Determine coex mode */
> +	switch (common->oper_mode) {
> +	case DEV_OPMODE_STA_BT_DUAL:
> +	case DEV_OPMODE_STA_BT:
> +	case DEV_OPMODE_STA_BT_LE:
> +	case DEV_OPMODE_BT_ALONE:
> +	case DEV_OPMODE_BT_LE_ALONE:
> +	case DEV_OPMODE_BT_DUAL:
> +		common->coex_mode = 2;

... why use magic values here ?

> +		break;
> +	case DEV_OPMODE_AP_BT_DUAL:
> +	case DEV_OPMODE_AP_BT:
> +		common->coex_mode = 4;
> +		break;
> +	case DEV_OPMODE_WIFI_ALONE:
> +		common->coex_mode = 1;
> +		break;
> +	default:
> +		common->oper_mode = 1;
> +		common->coex_mode = 1;
> +	}
> +	rsi_dbg(INFO_ZONE, "%s: oper_mode = %d, coex_mode = %d\n",
> +		__func__, common->oper_mode, common->coex_mode);
> +
>   	if (common->coex_mode > 1) {
>   		if (rsi_coex_attach(common)) {
>   			rsi_dbg(ERR_ZONE, "Failed to init coex module\n");
> @@ -359,10 +398,13 @@ void rsi_91x_deinit(struct rsi_hw *adapter)
>   	for (ii = 0; ii < NUM_SOFT_QUEUES; ii++)
>   		skb_queue_purge(&common->tx_queue[ii]);
>
> -	common->init_done = false;
> -
> -	if (common->coex_mode > 1)
> +	if (common->coex_mode > 1) {
>   		rsi_coex_detach(common);
> +		if (g_proto_ops.bt_ops->detach)
> +			g_proto_ops.bt_ops->detach(common->bt_adapter);
> +	}
> +
> +	common->init_done = false;

Regards,
Arend

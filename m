Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:31287 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751126Ab0EJEir (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 May 2010 00:38:47 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Sun, 09 May 2010 21:38:47 -0700
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <19431.36325.489713.540417@gargle.gargle.HOWL>
Date: Mon, 10 May 2010 10:09:01 +0530
To: Dan Carpenter <error27@gmail.com>
CC: Luis Rodriguez <Luis.Rodriguez@Atheros.com>,
	Jouni Malinen <Jouni.Malinen@Atheros.com>,
	Vasanth Thiagarajan <Vasanth.Thiagarajan@Atheros.com>,
	Senthilkumar Balasubramanian
	<Senthilkumar.Balasubramanian@Atheros.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	Vivek Natarajan <Vivek.Natarajan@Atheros.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ath9k-devel@lists.ath9k.org" <ath9k-devel@lists.ath9k.org>
Subject: [patch 5/9] ath9k/htc_drv_main: off by one error
In-Reply-To: <20100508162402.GQ27064@bicker>
References: <20100508162402.GQ27064@bicker>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Dan Carpenter wrote:
> I changed "> ATH9K_HTC_MAX_TID" to ">= ATH9K_HTC_MAX_TID" to avoid a
> potential overflow.
> 
> Signed-off-by: Dan Carpenter <error27@gmail.com>

Thanks.

Acked-by: Sujith <Sujith.Manoharan@atheros.com>

> diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_main.c b/drivers/net/wireless/ath/ath9k/htc_drv_main.c
> index e75db06..6c386da 100644
> --- a/drivers/net/wireless/ath/ath9k/htc_drv_main.c
> +++ b/drivers/net/wireless/ath/ath9k/htc_drv_main.c
> @@ -465,7 +465,7 @@ static int ath9k_htc_aggr_oper(struct ath9k_htc_priv *priv,
>  	int ret = 0;
>  	u8 cmd_rsp;
>  
> -	if (tid > ATH9K_HTC_MAX_TID)
> +	if (tid >= ATH9K_HTC_MAX_TID)
>  		return -EINVAL;
>  
>  	memset(&aggr, 0, sizeof(struct ath9k_htc_target_aggr));

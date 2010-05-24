Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:30364 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750699Ab0EXEN4 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 May 2010 00:13:56 -0400
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <19449.64821.650046.601383@gargle.gargle.HOWL>
Date: Mon, 24 May 2010 09:44:45 +0530
To: Dan Carpenter <error27@gmail.com>
CC: Luis Rodriguez <Luis.Rodriguez@Atheros.com>,
	Jouni Malinen <Jouni.Malinen@Atheros.com>,
	Vasanth Thiagarajan <Vasanth.Thiagarajan@Atheros.com>,
	Senthilkumar Balasubramanian
	<Senthilkumar.Balasubramanian@Atheros.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	Ming Lei <tom.leiming@gmail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ath9k-devel@lists.ath9k.org" <ath9k-devel@lists.ath9k.org>,
	"kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>
Subject: [patch] ath9k: cleanup: remove unneeded null check
In-Reply-To: <20100522203311.GR22515@bicker>
References: <20100522203311.GR22515@bicker>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Dan Carpenter wrote:
> We dereference "wmi" on the line before and also when we initialize "ah".
> This check has always been after a dereference since the first commit a
> couple months ago.  Looking through the code, it looks like "wmi" can't 
> actually be null here so I just removed the check.
> 
> Signed-off-by: Dan Carpenter <error27@gmail.com>

Thanks.

Acked-by: Sujith <Sujith.Manoharan@atheros.com>

> diff --git a/drivers/net/wireless/ath/ath9k/wmi.c b/drivers/net/wireless/ath/ath9k/wmi.c
> index e23172c..6260faa 100644
> --- a/drivers/net/wireless/ath/ath9k/wmi.c
> +++ b/drivers/net/wireless/ath/ath9k/wmi.c
> @@ -279,9 +279,6 @@ int ath9k_wmi_cmd(struct wmi *wmi, enum wmi_cmd_id cmd_id,
>  	if (wmi->drv_priv->op_flags & OP_UNPLUGGED)
>  		return 0;
>  
> -	if (!wmi)
> -		return -EINVAL;
> -
>  	skb = alloc_skb(headroom + cmd_len, GFP_ATOMIC);
>  	if (!skb)
>  		return -ENOMEM;

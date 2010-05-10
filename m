Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:31284 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751126Ab0EJEiS (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 May 2010 00:38:18 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Sun, 09 May 2010 21:38:18 -0700
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <19431.36295.30703.603205@gargle.gargle.HOWL>
Date: Mon, 10 May 2010 10:08:31 +0530
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
Subject: [patch 4/9] ath9k/htc_drv_main: null dereference typo
In-Reply-To: <20100508162320.GP27064@bicker>
References: <20100508162320.GP27064@bicker>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Dan Carpenter wrote:
> This is a stray null dereference.  We initialize "ista" properly later on.
> 
> Signed-off-by: Dan Carpenter <error27@gmail.com>

Thanks.

Acked-by: Sujith <Sujith.Manoharan@atheros.com>

> diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_main.c b/drivers/net/wireless/ath/ath9k/htc_drv_main.c
> index f503586..e75db06 100644
> --- a/drivers/net/wireless/ath/ath9k/htc_drv_main.c
> +++ b/drivers/net/wireless/ath/ath9k/htc_drv_main.c
> @@ -461,7 +461,7 @@ static int ath9k_htc_aggr_oper(struct ath9k_htc_priv *priv,
>  	struct ath_common *common = ath9k_hw_common(priv->ah);
>  	struct ath9k_htc_target_aggr aggr;
>  	struct ieee80211_sta *sta = NULL;
> -	struct ath9k_htc_sta *ista = (struct ath9k_htc_sta *) sta->drv_priv;
> +	struct ath9k_htc_sta *ista;
>  	int ret = 0;
>  	u8 cmd_rsp;
>  

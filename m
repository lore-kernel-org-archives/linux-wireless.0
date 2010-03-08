Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f219.google.com ([209.85.220.219]:54340 "EHLO
	mail-fx0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755185Ab0CHPWm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Mar 2010 10:22:42 -0500
Received: by fxm19 with SMTP id 19so6432051fxm.21
        for <linux-wireless@vger.kernel.org>; Mon, 08 Mar 2010 07:22:41 -0800 (PST)
From: Christian Lamparter <chunkeey@googlemail.com>
To: Senthil Balasubramanian <senthilkumar@atheros.com>
Subject: Re: [PATCH] ar9170: Fix illegal kfree_skb
Date: Mon, 8 Mar 2010 16:22:38 +0100
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
References: <1267709313-2222-1-git-send-email-senthilkumar@atheros.com>
In-Reply-To: <1267709313-2222-1-git-send-email-senthilkumar@atheros.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Message-Id: <201003081622.38911.chunkeey@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thursday 04 March 2010 14:28:33 Senthil Balasubramanian wrote:
> Signed-off-by: Senthil Balasubramanian <senthilkumar@atheros.com>
> ---
>  drivers/net/wireless/ath/ar9170/main.c |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/net/wireless/ath/ar9170/main.c b/drivers/net/wireless/ath/ar9170/main.c
> index f4650fc..d47450a 100644
> --- a/drivers/net/wireless/ath/ar9170/main.c
> +++ b/drivers/net/wireless/ath/ar9170/main.c
> @@ -2517,7 +2517,7 @@ void *ar9170_alloc(size_t priv_size)
>  
>  	skb = __dev_alloc_skb(AR9170_MAX_RX_BUFFER_SIZE, GFP_KERNEL);
>  	if (!skb)
> -		goto err_nomem;
> +		goto err_out;
>  
>  	hw = ieee80211_alloc_hw(priv_size, &ar9170_ops);
>  	if (!hw)
> @@ -2574,6 +2574,7 @@ void *ar9170_alloc(size_t priv_size)
>  
>  err_nomem:
>  	kfree_skb(skb);
> +err_out:
>  	return ERR_PTR(-ENOMEM);
>  }

err, wait. It's perfectly legal to call kfree_skb(NULL). This is
also true for most other kfree* functions. 

But, if you can't stand this freeing NULL business (e.g.: prop. mem checker?),
then why not got the direct path and replace "goto err_nomem" with 
"return ERR_PTR(-ENOMEM)"?

Regards,
	Chr

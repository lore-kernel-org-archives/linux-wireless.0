Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:22649 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755861Ab1EXJlV (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 May 2011 05:41:21 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Tue, 24 May 2011 02:40:50 -0700
Message-ID: <4DDB7D2A.2030602@atheros.com> (sfid-20110524_114131_894196_DA5AE3DB)
Date: Tue, 24 May 2011 15:10:58 +0530
From: Mohammed Shafi <mshajakhan@atheros.com>
MIME-Version: 1.0
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC: "linville@tuxdriver.com" <linville@tuxdriver.com>,
	Senthilkumar Balasubramanian
	<Senthilkumar.Balasubramanian@Atheros.com>,
	Vivek Natarajan <Vivek.Natarajan@Atheros.com>,
	Luis Rodriguez <Luis.Rodriguez@Atheros.com>
Subject: Re: [PATCH v2] ath9k: wake up chip before initializing PAPRD table
References: <1306229170-18368-1-git-send-email-mshajakhan@atheros.com>
In-Reply-To: <1306229170-18368-1-git-send-email-mshajakhan@atheros.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tuesday 24 May 2011 02:56 PM, Mohammed Shajakhan wrote:
> From: Mohammed Shafi Shajakhan<mshajakhan@atheros.com>
>
> In PAPRD table initialization path we do some register read, so
> make sure the chip is awake during that. Currently PAPRD is disabled.
>
> Signed-off-by: Mohammed Shafi Shajakhan<mshajakhan@atheros.com>
> ---
>   drivers/net/wireless/ath/ath9k/main.c |    5 +++--
>   1 files changed, 3 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
> index a198ee3..4a71f4e 100644
> --- a/drivers/net/wireless/ath/ath9k/main.c
> +++ b/drivers/net/wireless/ath/ath9k/main.c
> @@ -394,8 +394,10 @@ void ath_paprd_calibrate(struct work_struct *work)
>   	if (!caldata)
>   		return;
>
> +	ath9k_ps_wakeup(sc);
> +
>   	if (ar9003_paprd_init_table(ah)<  0)
> -		return;
> +		goto fail_paprd;
>
>   	skb = alloc_skb(len, GFP_KERNEL);
>   	if (!skb)

need to handle this case of skb_allocation failure :(, will send a v3. 
thanks to Vivek.

> @@ -411,7 +413,6 @@ void ath_paprd_calibrate(struct work_struct *work)
>   	memcpy(hdr->addr2, hw->wiphy->perm_addr, ETH_ALEN);
>   	memcpy(hdr->addr3, hw->wiphy->perm_addr, ETH_ALEN);
>
> -	ath9k_ps_wakeup(sc);
>   	for (chain = 0; chain<  AR9300_MAX_CHAINS; chain++) {
>   		if (!(common->tx_chainmask&  BIT(chain)))
>   			continue;

-- 
thanks,
shafi

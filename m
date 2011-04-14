Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:58948 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752090Ab1DNPUH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Apr 2011 11:20:07 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Thu, 14 Apr 2011 08:19:41 -0700
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Message-ID: <19879.4406.352934.381220@gargle.gargle.HOWL>
Date: Thu, 14 Apr 2011 20:52:30 +0530
To: "John W. Linville" <linville@tuxdriver.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Sujith Manoharan <Sujith.Manoharan@Atheros.com>
Subject: [PATCH] ath9k: avoid using trinary operator w/ TX_STAT_INC
In-Reply-To: <1302792094-13770-1-git-send-email-linville@tuxdriver.com>
References: <1302792094-13770-1-git-send-email-linville@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

John W. Linville wrote:
> Otherwise, you get this:
> 
>   CC [M]  drivers/net/wireless/ath/ath9k/hif_usb.o
> drivers/net/wireless/ath/ath9k/hif_usb.c: In function ‘ath9k_skb_queue_complete’:
> drivers/net/wireless/ath/ath9k/hif_usb.c:230:12: error: expected expression before ‘do’
> make[2]: *** [drivers/net/wireless/ath/ath9k/hif_usb.o] Error 1
> make[1]: *** [drivers/net/wireless/ath/ath9k] Error 2
> make: *** [drivers/net/wireless/ath/] Error 2
> 
> The TX_STAT_INC macro should probably be changed to accomodate such
> usage, although using a trinary operator in place of an if-else seems
> questionable to me anyway.
> 
> Signed-off-by: John W. Linville <linville@tuxdriver.com>
> ---
>  drivers/net/wireless/ath/ath9k/hif_usb.c |    5 ++++-
>  1 files changed, 4 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/net/wireless/ath/ath9k/hif_usb.c b/drivers/net/wireless/ath/ath9k/hif_usb.c
> index 5686711..2e3a33a 100644
> --- a/drivers/net/wireless/ath/ath9k/hif_usb.c
> +++ b/drivers/net/wireless/ath/ath9k/hif_usb.c
> @@ -227,7 +227,10 @@ static inline void ath9k_skb_queue_complete(struct hif_device_usb *hif_dev,
>  	while ((skb = __skb_dequeue(queue)) != NULL) {
>  		ath9k_htc_txcompletion_cb(hif_dev->htc_handle,
>  					  skb, txok);
> -		(txok) ? TX_STAT_INC(skb_success) : TX_STAT_INC(skb_failed);
> +		if (txok)
> +			TX_STAT_INC(skb_success);
> +		else
> +			TX_STAT_INC(skb_failed);
>  	}

Aargh, I forgot about this one. Thanks for fixing this.

Acked-by: Sujith Manoharan <Sujith.Manoharan@Atheros.com>

Sujith

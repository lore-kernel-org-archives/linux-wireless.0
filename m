Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f179.google.com ([209.85.221.179]:44015 "EHLO
	mail-qy0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755908Ab0DFNq4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Apr 2010 09:46:56 -0400
Received: by qyk9 with SMTP id 9so2175658qyk.1
        for <linux-wireless@vger.kernel.org>; Tue, 06 Apr 2010 06:46:56 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <19387.1463.310224.890658@gargle.gargle.HOWL>
References: <19387.1463.310224.890658@gargle.gargle.HOWL>
Date: Tue, 6 Apr 2010 21:46:55 +0800
Message-ID: <r2id82e647a1004060646ja618eaecye10b08f05d837e2d@mail.gmail.com>
Subject: Re: [PATCH 3/5] ath9k_htc: Fix module unloading issue
From: Ming Lei <tom.leiming@gmail.com>
To: Sujith <Sujith.Manoharan@atheros.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2010/4/6 Sujith <Sujith.Manoharan@atheros.com>:
> The maximum number of packets in a single buffer in
> stream mode is 10. The driver currently uses 8 - which
> caused stack corruption, in the absence of any kind
> of OOB checking.
>
> Fixing this to the correct value of 10 fixes the module
> unload issue.

Great,  the patch fixes the issue of destruction of urb->use_count,
which caused to sleep forever of usb_kill_urb().

For this kind of dark issue, it is better to add check for 'pool_index'.

Tested-by: Ming Lei <tom.leiming@gmail.com>

>
> Signed-off-by: Sujith <Sujith.Manoharan@atheros.com>
> ---
>  drivers/net/wireless/ath/ath9k/hif_usb.c |    2 +-
>  drivers/net/wireless/ath/ath9k/hif_usb.h |    1 +
>  2 files changed, 2 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/net/wireless/ath/ath9k/hif_usb.c b/drivers/net/wireless/ath/ath9k/hif_usb.c
> index 4528df4..69bef1d 100644
> --- a/drivers/net/wireless/ath/ath9k/hif_usb.c
> +++ b/drivers/net/wireless/ath/ath9k/hif_usb.c
> @@ -324,7 +324,7 @@ static struct ath9k_htc_hif hif_usb = {
>  static void ath9k_hif_usb_rx_stream(struct hif_device_usb *hif_dev,
>                                    struct sk_buff *skb)
>  {
> -       struct sk_buff *nskb, *skb_pool[8];
> +       struct sk_buff *nskb, *skb_pool[MAX_PKT_NUM_IN_TRANSFER];
>        int index = 0, i = 0, chk_idx, len = skb->len;
>        int rx_remain_len = 0, rx_pkt_len = 0;
>        u16 pkt_len, pkt_tag, pool_index = 0;
> diff --git a/drivers/net/wireless/ath/ath9k/hif_usb.h b/drivers/net/wireless/ath/ath9k/hif_usb.h
> index ed9708c..179cea4 100644
> --- a/drivers/net/wireless/ath/ath9k/hif_usb.h
> +++ b/drivers/net/wireless/ath/ath9k/hif_usb.h
> @@ -34,6 +34,7 @@
>
>  #define MAX_RX_URB_NUM  8
>  #define MAX_RX_BUF_SIZE 16384
> +#define MAX_PKT_NUM_IN_TRANSFER 10
>
>  #define MAX_REG_OUT_URB_NUM  1
>  #define MAX_REG_OUT_BUF_NUM  8
> --
> 1.7.0.3
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>



-- 
Lei Ming

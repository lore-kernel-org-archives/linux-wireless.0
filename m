Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-io0-f193.google.com ([209.85.223.193]:42221 "EHLO
        mail-io0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750752AbeCLJiT (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 12 Mar 2018 05:38:19 -0400
From: "<Hariprasath Elango>" <hariprasath.elango@gmail.com>
Date: Mon, 12 Mar 2018 15:08:08 +0530
To: hariprasath.elango@gmail.com
Cc: aditya.shankar@microchip.com, vbabu3@visteon.com,
        Hari Prasath <hgujulan@visteon.com>,
        Ganesh Krishna <ganesh.krishna@microchip.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: wilc1000: use pre-defined macro
 is_broadcast_ether_addr
Message-ID: <20180312093808.GA9044@hariprasath> (sfid-20180312_103835_711505_62229C3D)
References: <20180312084715.30103-1-hariprasath.elango@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180312084715.30103-1-hariprasath.elango@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Mar 12, 2018 at 02:17:15PM +0530, hariprasath.elango@gmail.com wrote:
> From: Hari Prasath <hgujulan@visteon.com>
> 
> Use the kernel pre-defined macro is_broadcast_ether_addr() instead of
> doing a memcmp here.
> 
> Signed-off-by: Hari Prasath <hgujulan@visteon.com>
> ---
>  drivers/staging/wilc1000/linux_mon.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/drivers/staging/wilc1000/linux_mon.c b/drivers/staging/wilc1000/linux_mon.c
> index bbdfc7a..f93f411 100644
> --- a/drivers/staging/wilc1000/linux_mon.c
> +++ b/drivers/staging/wilc1000/linux_mon.c
> @@ -27,7 +27,6 @@ static struct net_device *wilc_wfi_mon; /* global monitor netdev */
>  
>  static u8 srcadd[6];
>  static u8 bssid[6];
> -static u8 broadcast[] = {0xff, 0xff, 0xff, 0xff, 0xff, 0xff};
>  /**
>   *  @brief      WILC_WFI_monitor_rx
>   *  @details
> @@ -193,7 +192,7 @@ static netdev_tx_t WILC_WFI_mon_xmit(struct sk_buff *skb,
>  
>  	skb_pull(skb, rtap_len);
>  
> -	if (skb->data[0] == 0xc0 && (!(memcmp(broadcast, &skb->data[4], 6)))) {
> +	if (skb->data[0] == 0xc0 && is_broadcast_ether_addr(&skb->data[4])) {
>  		skb2 = dev_alloc_skb(skb->len + sizeof(struct wilc_wfi_radiotap_cb_hdr));
>  		if (!skb2)
>  			return -ENOMEM;
> -- 
> 2.10.0.GIT
> 

Kindly discard this patch. I will send a v2 as sent mail ID and
signed-off are not matching

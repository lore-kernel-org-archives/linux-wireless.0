Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pl0-f66.google.com ([209.85.160.66]:33580 "EHLO
        mail-pl0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756955AbdLPMIH (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 16 Dec 2017 07:08:07 -0500
Received: by mail-pl0-f66.google.com with SMTP id 1so575004plv.0
        for <linux-wireless@vger.kernel.org>; Sat, 16 Dec 2017 04:08:07 -0800 (PST)
Date: Sat, 16 Dec 2017 17:38:00 +0530
From: Morgan Freeman <morganfreeman6991@gmail.com>
To: Aditya Shankar <aditya.shankar@microchip.com>
Cc: linux-wireless@vger.kernel.org, ganesh.krishna@microchip.com,
        gregkh@linuxfoundation.org, devel@driverdev.osuosl.org,
        Claudiu.Beznea@microchip.com
Subject: Re: [PATCH v2] staging: wilc1000: Fix problems reported by checkpatch
Message-ID: <20171216120800.GA4457@himanshu-Vostro-3559> (sfid-20171216_130816_305154_7B2621F2)
References: <1513410864-6566-1-git-send-email-aditya.shankar@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1513410864-6566-1-git-send-email-aditya.shankar@microchip.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Aditya,

On Sat, Dec 16, 2017 at 01:24:24PM +0530, Aditya Shankar wrote:
> This commit fixes below style problems in multiple lines
> Fix checkpatch WARNING: line over 80 characters
> 
> Signed-off-by: Aditya Shankar <aditya.shankar@microchip.com>
> ---

The patch subject is not correct!
I'm pretty sure checkpatch will complain if you run it through:

WARNING: A patch subject line should describe the change not the tool
that found it

Take a look at:
https://www.kernel.org/doc/html/latest/process/submitting-patches.html#describe-your-changes


Thanks
Himanshu Jha

>  drivers/staging/wilc1000/linux_mon.c | 18 ++++++++++++------
>  1 file changed, 12 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/staging/wilc1000/linux_mon.c b/drivers/staging/wilc1000/linux_mon.c
> index 91d49c4..1c740af 100644
> --- a/drivers/staging/wilc1000/linux_mon.c
> +++ b/drivers/staging/wilc1000/linux_mon.c
> @@ -69,7 +69,8 @@ void WILC_WFI_monitor_rx(u8 *buff, u32 size)
>  	if (pkt_offset & IS_MANAGMEMENT_CALLBACK) {
>  		/* hostapd callback mgmt frame */
>  
> -		skb = dev_alloc_skb(size + sizeof(struct wilc_wfi_radiotap_cb_hdr));
> +		skb = dev_alloc_skb(size +
> +				    sizeof(struct wilc_wfi_radiotap_cb_hdr));
>  		if (!skb)
>  			return;
>  
> @@ -80,7 +81,8 @@ void WILC_WFI_monitor_rx(u8 *buff, u32 size)
>  
>  		cb_hdr->hdr.it_version = 0; /* PKTHDR_RADIOTAP_VERSION; */
>  
> -		cb_hdr->hdr.it_len = cpu_to_le16(sizeof(struct wilc_wfi_radiotap_cb_hdr));
> +		cb_hdr->hdr.it_len =
> +			cpu_to_le16(sizeof(struct wilc_wfi_radiotap_cb_hdr));
>  
>  		cb_hdr->hdr.it_present = cpu_to_le32(
>  				(1 << IEEE80211_RADIOTAP_RATE) |
> @@ -96,7 +98,8 @@ void WILC_WFI_monitor_rx(u8 *buff, u32 size)
>  		}
>  
>  	} else {
> -		skb = dev_alloc_skb(size + sizeof(struct wilc_wfi_radiotap_hdr));
> +		skb = dev_alloc_skb(size +
> +				    sizeof(struct wilc_wfi_radiotap_hdr));
>  
>  		if (!skb)
>  			return;
> @@ -105,7 +108,8 @@ void WILC_WFI_monitor_rx(u8 *buff, u32 size)
>  		hdr = skb_push(skb, sizeof(*hdr));
>  		memset(hdr, 0, sizeof(struct wilc_wfi_radiotap_hdr));
>  		hdr->hdr.it_version = 0; /* PKTHDR_RADIOTAP_VERSION; */
> -		hdr->hdr.it_len = cpu_to_le16(sizeof(struct wilc_wfi_radiotap_hdr));
> +		hdr->hdr.it_len =
> +			cpu_to_le16(sizeof(struct wilc_wfi_radiotap_hdr));
>  		hdr->hdr.it_present = cpu_to_le32
>  				(1 << IEEE80211_RADIOTAP_RATE); /* | */
>  		hdr->rate = 5; /* txrate->bitrate / 5; */
> @@ -197,7 +201,8 @@ static netdev_tx_t WILC_WFI_mon_xmit(struct sk_buff *skb,
>  	skb_pull(skb, rtap_len);
>  
>  	if (skb->data[0] == 0xc0 && (!(memcmp(broadcast, &skb->data[4], 6)))) {
> -		skb2 = dev_alloc_skb(skb->len + sizeof(struct wilc_wfi_radiotap_cb_hdr));
> +		skb2 = dev_alloc_skb(skb->len +
> +				     sizeof(struct wilc_wfi_radiotap_cb_hdr));
>  		if (!skb2)
>  			return -ENOMEM;
>  
> @@ -208,7 +213,8 @@ static netdev_tx_t WILC_WFI_mon_xmit(struct sk_buff *skb,
>  
>  		cb_hdr->hdr.it_version = 0; /* PKTHDR_RADIOTAP_VERSION; */
>  
> -		cb_hdr->hdr.it_len = cpu_to_le16(sizeof(struct wilc_wfi_radiotap_cb_hdr));
> +		cb_hdr->hdr.it_len =
> +			cpu_to_le16(sizeof(struct wilc_wfi_radiotap_cb_hdr));
>  
>  		cb_hdr->hdr.it_present = cpu_to_le32(
>  				(1 << IEEE80211_RADIOTAP_RATE) |
> -- 
> 2.7.4
> 
> 

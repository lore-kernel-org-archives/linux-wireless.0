Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from pne-smtpout3-sn2.hy.skanova.net ([81.228.8.111]:42276 "EHLO
	pne-smtpout3-sn2.hy.skanova.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751658AbYBPKGU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 16 Feb 2008 05:06:20 -0500
Subject: Re: [PATCH] rndis_wlan: enable stall workaround by link quality
	instead of link speed
From: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
To: linux-wireless <linux-wireless@vger.kernel.org>
Cc: linville@tuxdriver.com
In-Reply-To: <20080206133609.12743.17426.stgit@fate.lan>
References: <20080206133609.12743.17426.stgit@fate.lan>
Content-Type: text/plain
Date: Sat, 16 Feb 2008 12:06:16 +0200
Message-Id: <1203156376.7931.5.camel@localhost> (sfid-20080216_100625_312794_016CA123)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,

Did I send this patch to right person/place, I hope this gets on 2.6.25.

 - Jussi

On Wed, 2008-02-06 at 15:36 +0200, Jussi Kivilinna wrote:
> Enable workaround for poor link stalls by link quality instead of link
> speed. Using link speed caused workaround be active always on 802.11b
> networks which reduced performance and not even catch all stalls.
> 
> Signed-off-by: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
> ---
> 
>  drivers/net/wireless/rndis_wlan.c |   14 +++++---------
>  1 files changed, 5 insertions(+), 9 deletions(-)
> 
> diff --git a/drivers/net/wireless/rndis_wlan.c b/drivers/net/wireless/rndis_wlan.c
> index d3ecf89..8ce2ddf 100644
> --- a/drivers/net/wireless/rndis_wlan.c
> +++ b/drivers/net/wireless/rndis_wlan.c
> @@ -2300,7 +2300,7 @@ static void rndis_update_wireless_stats(struct work_struct *work)
>  	struct usbnet *usbdev = priv->usbdev;
>  	struct iw_statistics iwstats;
>  	__le32 rssi, tmp;
> -	int len, ret, bitrate, j;
> +	int len, ret, j;
>  	unsigned long flags;
>  	int update_jiffies = STATS_UPDATE_JIFFIES;
>  	void *buf;
> @@ -2352,14 +2352,10 @@ static void rndis_update_wireless_stats(struct work_struct *work)
>  	if (ret == 0)
>  		iwstats.discard.misc += le32_to_cpu(tmp);
>  
> -	/* Workaround transfer stalls on poor quality links. */
> -	len = sizeof(tmp);
> -	ret = rndis_query_oid(usbdev, OID_GEN_LINK_SPEED, &tmp, &len);
> -	if (ret == 0) {
> -		bitrate = le32_to_cpu(tmp) * 100;
> -		if (bitrate > 11000000)
> -			goto end;
> -
> +	/* Workaround transfer stalls on poor quality links.
> +	 * TODO: find right way to fix these stalls (as stalls do not happen
> +	 * with ndiswrapper/windows driver). */
> +	if (iwstats.qual.qual <= 25) {
>  		/* Decrease stats worker interval to catch stalls.
>  		 * faster. Faster than 400-500ms causes packet loss,
>  		 * Slower doesn't catch stalls fast enough.
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 


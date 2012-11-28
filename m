Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog109.obsmtp.com ([74.125.149.201]:45521 "EHLO
	na3sys009aog109.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754831Ab2K1Ve1 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Nov 2012 16:34:27 -0500
From: Bing Zhao <bzhao@marvell.com>
To: Johannes Berg <johannes@sipsolutions.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC: Johannes Berg <johannes.berg@intel.com>
Date: Wed, 28 Nov 2012 13:32:59 -0800
Subject: RE: [PATCH] mwifiex: fix struct member mismatch
Message-ID: <477F20668A386D41ADCC57781B1F70430D1367CDBE@SC-VEXCH1.marvell.com> (sfid-20121128_223431_274971_25809DFA)
References: <1354136025-21915-1-git-send-email-johannes@sipsolutions.net>
In-Reply-To: <1354136025-21915-1-git-send-email-johannes@sipsolutions.net>
Content-Type: text/plain; charset=US-ASCII
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Johannes,

Thanks for the patch.

> From: Johannes Berg <johannes.berg@intel.com>
> 
> Using bss->information_elements and treating
> bss->len_beacon_ies as its size is wrong, the
> real size is len_information_elements.
> 
> Found while I was reviewing the use of this
> cfg80211 API (as it is actually potentially
> broken due to races.)
> 
> Signed-off-by: Johannes Berg <johannes.berg@intel.com>

Acked-by: Bing Zhao <bzhao@marvell.com>

Thanks,
Bing

> ---
>  drivers/net/wireless/mwifiex/sta_ioctl.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/wireless/mwifiex/sta_ioctl.c b/drivers/net/wireless/mwifiex/sta_ioctl.c
> index 24af6ba..f92047d 100644
> --- a/drivers/net/wireless/mwifiex/sta_ioctl.c
> +++ b/drivers/net/wireless/mwifiex/sta_ioctl.c
> @@ -161,8 +161,9 @@ int mwifiex_fill_new_bss_desc(struct mwifiex_private *priv,
>  	int ret;
>  	u8 *beacon_ie;
>  	struct mwifiex_bss_priv *bss_priv = (void *)bss->priv;
> +	size_t beacon_ie_len = bss->len_information_elements;
> 
> -	beacon_ie = kmemdup(bss->information_elements, bss->len_beacon_ies,
> +	beacon_ie = kmemdup(bss->information_elements, beacon_ie_len,
>  			    GFP_KERNEL);
>  	if (!beacon_ie) {
>  		dev_err(priv->adapter->dev, " failed to alloc beacon_ie\n");
> @@ -172,7 +173,7 @@ int mwifiex_fill_new_bss_desc(struct mwifiex_private *priv,
>  	memcpy(bss_desc->mac_address, bss->bssid, ETH_ALEN);
>  	bss_desc->rssi = bss->signal;
>  	bss_desc->beacon_buf = beacon_ie;
> -	bss_desc->beacon_buf_size = bss->len_beacon_ies;
> +	bss_desc->beacon_buf_size = beacon_ie_len;
>  	bss_desc->beacon_period = bss->beacon_interval;
>  	bss_desc->cap_info_bitmap = bss->capability;
>  	bss_desc->bss_band = bss_priv->band;
> --
> 1.8.0
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

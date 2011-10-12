Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:51232 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753450Ab1JLSpr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Oct 2011 14:45:47 -0400
Date: Wed, 12 Oct 2011 14:32:53 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Chaoming Li <chaoming_li@realsil.com.cn>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH 4/5 V2] rtlwifi: rtl8192se: Updates from latest Realtek
 driver version - Part II
Message-ID: <20111012183252.GE18764@tuxdriver.com> (sfid-20111012_204552_374316_027249F9)
References: <1318386531-5859-1-git-send-email-Larry.Finger@lwfinger.net>
 <1318386531-5859-5-git-send-email-Larry.Finger@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1318386531-5859-5-git-send-email-Larry.Finger@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Oct 11, 2011 at 09:28:50PM -0500, Larry Finger wrote:
> From: Chaoming Li <chaoming_li@realsil.com.cn>
> 
> This patch incorporate the differences between the 06/20/2011 and
> 08/16/2011 Realtek releases of the rtl8192se driver.
> 
> The changes include:
> 
> 1. Fixing some typos in register usage.
> 2. A change in the handling of decryption status for 802.11w packets.
> 
> Signed-off-by: Chaoming Li <chaoming_li@realsil.com.cn>
> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>

> Index: wireless-testing-new/drivers/net/wireless/rtlwifi/rtl8192se/trx.c
> ===================================================================
> --- wireless-testing-new.orig/drivers/net/wireless/rtlwifi/rtl8192se/trx.c
> +++ wireless-testing-new/drivers/net/wireless/rtlwifi/rtl8192se/trx.c

> @@ -539,29 +540,39 @@ bool rtl92se_rx_query_desc(struct ieee80
>  	rx_status->freq = hw->conf.channel->center_freq;
>  	rx_status->band = hw->conf.channel->band;
>  
> -	if (GET_RX_STATUS_DESC_CRC32(pdesc))
> -		rx_status->flag |= RX_FLAG_FAILED_FCS_CRC;
> +	hdr = (struct ieee80211_hdr *)(skb->data + stats->rx_drvinfo_size
> +	      + stats->rx_bufshift);
>  
> -	if (!GET_RX_STATUS_DESC_SWDEC(pdesc))
> -		rx_status->flag |= RX_FLAG_DECRYPTED;
> +	if (stats->crc)
> +		rx_status->flag |= RX_FLAG_FAILED_FCS_CRC;
>  
> -	if (GET_RX_STATUS_DESC_BW(pdesc))
> +	if (stats->rx_is40Mhzpacket)
>  		rx_status->flag |= RX_FLAG_40MHZ;
>  
> -	if (GET_RX_STATUS_DESC_RX_HT(pdesc))
> +	if (stats->is_ht)
>  		rx_status->flag |= RX_FLAG_HT;
>  
>  	rx_status->flag |= RX_FLAG_MACTIME_MPDU;
>  
> -	if (stats->decrypted)
> -		rx_status->flag |= RX_FLAG_DECRYPTED;
> +	/* hw will set stats->decrypted true, if it finds the
> +	 * frame is open data frame or mgmt frame,
> +	 * hw will not decrypt robust managment frame
> +	 * for IEEE80211w but still set stats->decrypted
> +	 * true, so here we should set it back to undecrypted
> +	 * for IEEE80211w frame, and mac80211 sw will help
> +	 * to decrypt it */
> +	if (stats->decrypted) {
> +		if ((ieee80211_is_robust_mgmt_frame(hdr)) &&
> +			(ieee80211_has_protected(hdr->frame_control)))
> +			rx_status->flag &= ~RX_FLAG_DECRYPTED;
> +		else
> +			rx_status->flag |= RX_FLAG_DECRYPTED;
> +	}
>  
>  	rx_status->rate_idx = rtlwifi_rate_mapping(hw,
> -				(bool)GET_RX_STATUS_DESC_RX_HT(pdesc),
> -				(u8)GET_RX_STATUS_DESC_RX_MCS(pdesc));
> -
> +			     stats->is_ht, stats->rate);
>  
> -	rx_status->mactime = GET_RX_STATUS_DESC_TSFL(pdesc);
> +	rx_status->mactime = stats->timestamp_low;
>  	if (phystatus) {
>  		p_drvinfo = (struct rx_fwinfo *)(skb->data +
>  						 stats->rx_bufshift);

The above hunk doesn't apply, because I have this:

        rx_status->rate_idx = rtlwifi_rate_mapping(hw,
                                (bool)GET_RX_STATUS_DESC_RX_HT(pdesc),
                                (u8)GET_RX_STATUS_DESC_RX_MCS(pdesc),
                                (bool)GET_RX_STATUS_DESC_PAGGR(pdesc));

Do you perhaps have another patch applied which you haven't sent?

John

P.S.  Please note that my trees are still on infradead -- be sure to
pull the latest from there.
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.

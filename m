Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:33658 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753166Ab0LaRTw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 31 Dec 2010 12:19:52 -0500
Message-ID: <4D1E10AD.4090703@candelatech.com>
Date: Fri, 31 Dec 2010 09:19:41 -0800
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Senthil Balasubramanian <senthilkumar@atheros.com>
CC: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	Stable <stable@kernel.org>
Subject: Re: [PATCH v3 2/2] ath9k: Fix STA disconnect issue due to received
 MIC failed bcast frames
References: <1291642767-11939-1-git-send-email-senthilkumar@atheros.com>
In-Reply-To: <1291642767-11939-1-git-send-email-senthilkumar@atheros.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 12/06/2010 05:39 AM, Senthil Balasubramanian wrote:
> AR_RxKeyIdxValid will not be set for bcast/mcast frames and so relying
> this status for MIC failed frames is buggy.
>
> Due to this, MIC failure events for broadcast frames are not sent to
> supplicant resulted in AP disconnecting the STA.
>
> Able to pass Wifi Test case 5.2.18 with this fix.

Did this ever make it into wireless-testing?  I just did
a rebase, and I notice I'm still carrying this patch in my
local tree?

Thanks,
Ben

>
> Cc: Stable<stable@kernel.org>  (2.6.36+)
> Signed-off-by: Senthil Balasubramanian<senthilkumar@atheros.com>
> ---
> v2 -- addressed invalid keyix overrun in tkip_keymap.
> v3 -- fixed setting of rx decrypted flag in case of s/w crypto.
>
>   drivers/net/wireless/ath/ath9k/mac.c  |    3 +--
>   drivers/net/wireless/ath/ath9k/recv.c |    9 ++++++++-
>   2 files changed, 9 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/net/wireless/ath/ath9k/mac.c b/drivers/net/wireless/ath/ath9k/mac.c
> index b04b37b..7978b27 100644
> --- a/drivers/net/wireless/ath/ath9k/mac.c
> +++ b/drivers/net/wireless/ath/ath9k/mac.c
> @@ -702,8 +702,7 @@ int ath9k_hw_rxprocdesc(struct ath_hw *ah, struct ath_desc *ds,
>   			rs->rs_phyerr = phyerr;
>   		} else if (ads.ds_rxstatus8&  AR_DecryptCRCErr)
>   			rs->rs_status |= ATH9K_RXERR_DECRYPT;
> -		else if ((ads.ds_rxstatus8&  AR_MichaelErr)&&
> -		         rs->rs_keyix != ATH9K_RXKEYIX_INVALID)
> +		else if (ads.ds_rxstatus8&  AR_MichaelErr)
>   			rs->rs_status |= ATH9K_RXERR_MIC;
>   		else if (ads.ds_rxstatus8&  AR_KeyMiss)
>   			rs->rs_status |= ATH9K_RXERR_DECRYPT;
> diff --git a/drivers/net/wireless/ath/ath9k/recv.c b/drivers/net/wireless/ath/ath9k/recv.c
> index 262c815..876aa8f 100644
> --- a/drivers/net/wireless/ath/ath9k/recv.c
> +++ b/drivers/net/wireless/ath/ath9k/recv.c
> @@ -840,6 +840,10 @@ static bool ath9k_rx_accept(struct ath_common *common,
>   			    struct ath_rx_status *rx_stats,
>   			    bool *decrypt_error)
>   {
> +#define is_mc_or_valid_tkip_keyix ((is_mc ||			\
> +		(rx_stats->rs_keyix != ATH9K_RXKEYIX_INVALID&&  \
> +		test_bit(rx_stats->rs_keyix, common->tkip_keymap))))
> +
>   	struct ath_hw *ah = common->ah;
>   	__le16 fc;
>   	u8 rx_status_len = ah->caps.rx_status_len;
> @@ -881,15 +885,18 @@ static bool ath9k_rx_accept(struct ath_common *common,
>   		if (rx_stats->rs_status&  ATH9K_RXERR_DECRYPT) {
>   			*decrypt_error = true;
>   		} else if (rx_stats->rs_status&  ATH9K_RXERR_MIC) {
> +			bool is_mc;
>   			/*
>   			 * The MIC error bit is only valid if the frame
>   			 * is not a control frame or fragment, and it was
>   			 * decrypted using a valid TKIP key.
>   			 */
> +			is_mc = !!is_multicast_ether_addr(hdr->addr1);
> +
>   			if (!ieee80211_is_ctl(fc)&&
>   			!ieee80211_has_morefrags(fc)&&
>   			!(le16_to_cpu(hdr->seq_ctrl)&  IEEE80211_SCTL_FRAG)&&
> -			    test_bit(rx_stats->rs_keyix, common->tkip_keymap))
> +			    is_mc_or_valid_tkip_keyix)
>   				rxs->flag |= RX_FLAG_MMIC_ERROR;
>   			else
>   				rx_stats->rs_status&= ~ATH9K_RXERR_MIC;


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com


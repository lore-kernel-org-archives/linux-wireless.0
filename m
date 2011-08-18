Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:53002 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751503Ab1HRAwv (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Aug 2011 20:52:51 -0400
Message-ID: <4E4C6258.1030409@openwrt.org> (sfid-20110818_025254_954330_64A3FB9C)
Date: Wed, 17 Aug 2011 17:52:40 -0700
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Bill Jordan <bjordan@rajant.com>
CC: ath9k-devel@lists.ath9k.org, linux-wireless@vger.kernel.org,
	linville@tuxdriver.com
Subject: Re: [PATCH] ath9k: fix MGMT packets when using TKIP
References: <4E4AF4A4.9090404@openwrt.org> <1313611597-17662-1-git-send-email-bjordan@rajant.com>
In-Reply-To: <1313611597-17662-1-git-send-email-bjordan@rajant.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2011-08-17 1:06 PM, Bill Jordan wrote:
> Prevent 8 bytes from being truncated from MGMT packets
> when using TKIP.
>
> Signed-off-by: Bill Jordan<bjordan@rajant.com>
> ---
>   drivers/net/wireless/ath/ath9k/recv.c |    3 ++-
>   1 files changed, 2 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/net/wireless/ath/ath9k/recv.c b/drivers/net/wireless/ath/ath9k/recv.c
> index 7409402..d8737f2 100644
> --- a/drivers/net/wireless/ath/ath9k/recv.c
> +++ b/drivers/net/wireless/ath/ath9k/recv.c
> @@ -824,7 +824,8 @@ static bool ath9k_rx_accept(struct ath_common *common,
>   	is_mc = !!is_multicast_ether_addr(hdr->addr1);
>   	is_valid_tkip = rx_stats->rs_keyix != ATH9K_RXKEYIX_INVALID&&
>   		test_bit(rx_stats->rs_keyix, common->tkip_keymap);
> -	strip_mic = is_valid_tkip&&  !(rx_stats->rs_status&
> +	strip_mic = is_valid_tkip&&  !ieee80211_is_mgmt(fc)&&
> +		!(rx_stats->rs_status&
>   		(ATH9K_RXERR_DECRYPT | ATH9K_RXERR_CRC | ATH9K_RXERR_MIC));
>
>   	if (!rx_stats->rs_datalen)
Maybe it would be a better idea to check for ieee80211_is_data(fc) 
instead of !ieee80211_is_mgmt(fc) - just to avoid more potential corner 
cases.

- Felix

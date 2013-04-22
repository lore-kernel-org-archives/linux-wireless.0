Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:40246 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753348Ab3DVVYh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Apr 2013 17:24:37 -0400
Message-ID: <5175AA87.5020008@candelatech.com> (sfid-20130422_233203_397300_72C837B0)
Date: Mon, 22 Apr 2013 14:24:23 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Felix Fietkau <nbd@openwrt.org>
CC: linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	mcgrof@qca.qualcomm.com
Subject: Re: [PATCH 2/2] ath9k: add support for the new rate control API
References: <1366665104-28737-1-git-send-email-nbd@openwrt.org> <1366665104-28737-2-git-send-email-nbd@openwrt.org>
In-Reply-To: <1366665104-28737-2-git-send-email-nbd@openwrt.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 04/22/2013 02:11 PM, Felix Fietkau wrote:
> Signed-off-by: Felix Fietkau <nbd@openwrt.org>
> ---
>   drivers/net/wireless/ath/ath9k/ath9k.h |  1 +
>   drivers/net/wireless/ath/ath9k/init.c  |  3 ++-
>   drivers/net/wireless/ath/ath9k/xmit.c  | 23 ++++++++++++++++-------
>   3 files changed, 19 insertions(+), 8 deletions(-)
>
> diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
> index 1915f12..8a1888d 100644
> --- a/drivers/net/wireless/ath/ath9k/ath9k.h
> +++ b/drivers/net/wireless/ath/ath9k/ath9k.h
> @@ -234,6 +234,7 @@ struct ath_buf {
>   	dma_addr_t bf_daddr;		/* physical addr of desc */
>   	dma_addr_t bf_buf_addr;	/* physical addr of data buffer, for DMA */
>   	bool bf_stale;
> +	struct ieee80211_tx_rate rates[4];

Maybe that should be some #define instead of [4]?

Or at least a comment describing where 4 came from?

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com


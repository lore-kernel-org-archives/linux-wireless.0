Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from caladan.dune.hu ([78.24.191.180]:48176 "EHLO arrakis.dune.hu"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753689AbcCAN5v (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Mar 2016 08:57:51 -0500
Subject: Re: [PATCH] ath10k: Fix mgmt tx status for 10.4.3 firmware.
To: greearb@candelatech.com, ath10k@lists.infradead.org
References: <1456782654-24723-1-git-send-email-greearb@candelatech.com>
Cc: linux-wireless@vger.kernel.org
From: Felix Fietkau <nbd@openwrt.org>
Message-ID: <56D56052.2010007@openwrt.org> (sfid-20160301_145754_226064_92D3BEC4)
Date: Tue, 1 Mar 2016 10:26:42 +0100
MIME-Version: 1.0
In-Reply-To: <1456782654-24723-1-git-send-email-greearb@candelatech.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2016-02-29 22:50, greearb@candelatech.com wrote:
> From: Ben Greear <greearb@candelatech.com>
> 
> When testing a 10.4.3 firmware in station mode, I notice that
> when the AP is powered down, the ath10k does not notice AP is gone
> because mgt frames get tx status of 3, which is not handled.
> 
> It appears that status 3 means something similar to failed-retry.
> 
> Treating it thus lets the station disconnect properly.
> 
> Tested against a non-stock 10.4.3 firmware, but likely upstream
> firmware acts similarly in this case.
> 
> Signed-off-by: Ben Greear <greearb@candelatech.com>
> ---
> 
> This patch is against a heavily patched tree based on 4.4, hopefully
> it can be applied to upstream code w/out too much trouble.
> 
> Someone should verify this on stock 10.4-ish firmware before applying.
> 
>  drivers/net/wireless/ath/ath10k/htt.h    |  4 +++-
>  drivers/net/wireless/ath/ath10k/htt_rx.c | 11 +++++++++--
>  2 files changed, 12 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/net/wireless/ath/ath10k/htt.h b/drivers/net/wireless/ath/ath10k/htt.h
> index c31a31f..de663a6 100644
> --- a/drivers/net/wireless/ath/ath10k/htt.h
> +++ b/drivers/net/wireless/ath/ath10k/htt.h
> @@ -309,7 +309,9 @@ struct htt_mgmt_tx_desc {
>  enum htt_mgmt_tx_status {
>  	HTT_MGMT_TX_STATUS_OK    = 0,
>  	HTT_MGMT_TX_STATUS_RETRY = 1,
> -	HTT_MGMT_TX_STATUS_DROP  = 2
> +	HTT_MGMT_TX_STATUS_DROP  = 2,
> +	HTT_MGMT_TX_STATUS_TXFILT = 3 /* Seems to be logically similar to
> +					 RETRY failure. */
In that case the driver should probably set IEEE80211_TX_STAT_TX_FILTERED

- Felix

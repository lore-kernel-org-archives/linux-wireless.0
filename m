Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:43098 "EHLO
	mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751359AbcCaQ57 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 31 Mar 2016 12:57:59 -0400
Subject: Re: [PATCH 2/3] ath10k: remove unnecessary warning for probe response
 drops
To: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>,
	ath10k@lists.infradead.org
References: <1459352551-11773-1-git-send-email-rmanohar@qti.qualcomm.com>
 <1459352551-11773-2-git-send-email-rmanohar@qti.qualcomm.com>
Cc: linux-wireless@vger.kernel.org, rmanohar@codeaurora.org
From: Ben Greear <greearb@candelatech.com>
Message-ID: <56FD5716.6030406@candelatech.com> (sfid-20160331_185804_367976_A09128D4)
Date: Thu, 31 Mar 2016 09:57:58 -0700
MIME-Version: 1.0
In-Reply-To: <1459352551-11773-2-git-send-email-rmanohar@qti.qualcomm.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 03/30/2016 08:42 AM, Rajkumar Manoharan wrote:
> qca99x0 and qca4019 solutions limit probe responses transmissions.
> Logging warning message for each probe response drop is flooding
> kernel log unnecessary with " failed to increase tx mgmt pending
> count: -16, dropping". Hence reducing log level to debug.

Is there any realistic way to see this message if we are not running
many vAP on one radio?

I guess many probe requests or other management frames could also
cause this problem?

Thanks,
Ben

> Reported-by: Sebastian Gottschall <s.gottschall@dd-wrt.com>
> Signed-off-by: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
> ---
>   drivers/net/wireless/ath/ath10k/mac.c | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
> index ed00853..a7aafb35c 100644
> --- a/drivers/net/wireless/ath/ath10k/mac.c
> +++ b/drivers/net/wireless/ath/ath10k/mac.c
> @@ -3994,8 +3994,8 @@ static void ath10k_mac_op_tx(struct ieee80211_hw *hw,
>
>   		ret = ath10k_htt_tx_mgmt_inc_pending(htt, is_mgmt, is_presp);
>   		if (ret) {
> -			ath10k_warn(ar, "failed to increase tx mgmt pending count: %d, dropping\n",
> -				    ret);
> +			ath10k_dbg(ar, ATH10K_DBG_MAC, "failed to increase tx mgmt pending count: %d, dropping\n",
> +				   ret);
>   			ath10k_htt_tx_dec_pending(htt);
>   			spin_unlock_bh(&ar->htt.tx_lock);
>   			ieee80211_free_txskb(ar->hw, skb);
>


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com


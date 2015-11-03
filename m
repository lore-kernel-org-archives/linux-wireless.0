Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:34922 "EHLO
	mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752734AbbKCGcG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Nov 2015 01:32:06 -0500
Message-ID: <563854E5.4010508@candelatech.com> (sfid-20151103_073501_503049_2904931D)
Date: Mon, 02 Nov 2015 22:32:05 -0800
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>,
	ath10k@lists.infradead.org
CC: linux-wireless@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] ath10k: fix invalid NSS for 4x4 devices
References: <1446531693-23453-1-git-send-email-rmanohar@qti.qualcomm.com>
In-Reply-To: <1446531693-23453-1-git-send-email-rmanohar@qti.qualcomm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I'm a bit embarrassed about that 0x15..thanks for catching that!

Ben

On 11/02/2015 10:21 PM, Rajkumar Manoharan wrote:
> The number of spatial streams that are derived from chain mask
> for 4x4 devices is using wrong bitmask and conditional check.
> This is affecting downlink throughput for QCA99x0 devices. Earlier
> cfg_tx_chainmask is not filled by default until user configured it
> and so get_nss_from_chainmask never be called. This issue is exposed
> by recent commit 166de3f1895d ("ath10k: remove supported chain mask").
> By default maximum supported chain mask is filled in cfg_tx_chainmask.
>
> Cc: stable@vger.kernel.org
> Fixes: 5572a95b4b ("ath10k: apply chainmask settings to vdev on
> creation")
> Signed-off-by: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
> ---
>   drivers/net/wireless/ath/ath10k/mac.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
> index a7411fe..95a55405 100644
> --- a/drivers/net/wireless/ath/ath10k/mac.c
> +++ b/drivers/net/wireless/ath/ath10k/mac.c
> @@ -4225,7 +4225,7 @@ static int ath10k_config(struct ieee80211_hw *hw, u32 changed)
>
>   static u32 get_nss_from_chainmask(u16 chain_mask)
>   {
> -	if ((chain_mask & 0x15) == 0x15)
> +	if ((chain_mask & 0xf) == 0xf)
>   		return 4;
>   	else if ((chain_mask & 0x7) == 0x7)
>   		return 3;
>

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

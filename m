Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:33546 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751522Ab2EVHZU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 22 May 2012 03:25:20 -0400
Message-ID: <4FBB3F58.2080104@qca.qualcomm.com> (sfid-20120522_092524_517887_507CFF83)
Date: Tue, 22 May 2012 12:55:12 +0530
From: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
MIME-Version: 1.0
To: <kvalo@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>, <ath6kl-devel@qualcomm.com>
Subject: Re: [PATCH 2/2] ath6kl: Complete failed tx packet in ath6kl_htc_tx_from_queue()
References: <1337671370-32519-1-git-send-email-vthiagar@qca.qualcomm.com> <1337671370-32519-3-git-send-email-vthiagar@qca.qualcomm.com>
In-Reply-To: <1337671370-32519-3-git-send-email-vthiagar@qca.qualcomm.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Oops, please forget this crap, mistakenly sent the older patches.
I'm really sorry.

Vasanth

On Tuesday 22 May 2012 12:52 PM, Vasanthakumar Thiagarajan wrote:
> Return status of ath6kl_htc_tx_issue() is ignored in
> ath6kl_htc_tx_from_queue(), but failed tx packet is
> is not cleaned up. To fix memory leak in this case, call
> completion with error. Also, throw an error debug message
> when tx fails in ath6kl_sdio_write_async() due to shortage
> in bus request buffer.
>
> Signed-off-by: Vasanthakumar Thiagarajan<vthiagar@qca.qualcomm.com>
> ---
>   drivers/net/wireless/ath/ath6kl/htc_mbox.c |    8 +++++++-
>   drivers/net/wireless/ath/ath6kl/sdio.c     |    4 +++-
>   2 files changed, 10 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/net/wireless/ath/ath6kl/htc_mbox.c b/drivers/net/wireless/ath/ath6kl/htc_mbox.c
> index 65310d5..8729803 100644
> --- a/drivers/net/wireless/ath/ath6kl/htc_mbox.c
> +++ b/drivers/net/wireless/ath/ath6kl/htc_mbox.c
> @@ -850,6 +850,7 @@ static void ath6kl_htc_tx_from_queue(struct htc_target *target,
>   	int bundle_sent;
>   	int n_pkts_bundle;
>   	u8 ac = WMM_NUM_AC;
> +	int status;
>
>   	spin_lock_bh(&target->tx_lock);
>
> @@ -911,7 +912,12 @@ static void ath6kl_htc_tx_from_queue(struct htc_target *target,
>
>   			ath6kl_htc_tx_prep_pkt(packet, packet->info.tx.flags,
>   					       0, packet->info.tx.seqno);
> -			ath6kl_htc_tx_issue(target, packet);
> +			status = ath6kl_htc_tx_issue(target, packet);
> +
> +			if (status) {
> +				packet->status = status;
> +				packet->completion(packet->context, packet);
> +			}
>   		}
>
>   		spin_lock_bh(&target->tx_lock);
> diff --git a/drivers/net/wireless/ath/ath6kl/sdio.c b/drivers/net/wireless/ath/ath6kl/sdio.c
> index 0384a0f..efe083f 100644
> --- a/drivers/net/wireless/ath/ath6kl/sdio.c
> +++ b/drivers/net/wireless/ath/ath6kl/sdio.c
> @@ -552,8 +552,10 @@ static int ath6kl_sdio_write_async(struct ath6kl *ar, u32 address, u8 *buffer,
>
>   	bus_req = ath6kl_sdio_alloc_busreq(ar_sdio);
>
> -	if (!bus_req)
> +	if (!bus_req) {
> +		ath6kl_err("Ran out of bus request buffer for tx\n");
>   		return -ENOMEM;
> +	}
>
>   	bus_req->address = address;
>   	bus_req->buffer = buffer;

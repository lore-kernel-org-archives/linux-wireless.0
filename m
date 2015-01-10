Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:40410 "EHLO
	mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758542AbbAJAgt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 9 Jan 2015 19:36:49 -0500
Message-ID: <54B07420.8090600@candelatech.com> (sfid-20150110_013701_347340_242D9A5F)
Date: Fri, 09 Jan 2015 16:36:48 -0800
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Vasanthakumar Thiagarajan <vthiagar@qti.qualcomm.com>
CC: ath10k@lists.infradead.org, linux-wireless@vger.kernel.org
Subject: Re: [PATCH RESEND] ath10k: Fix potential Rx ring corruption
References: <1420823986-29503-1-git-send-email-vthiagar@qti.qualcomm.com>
In-Reply-To: <1420823986-29503-1-git-send-email-vthiagar@qti.qualcomm.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I added this to my tree (and a bunch more debug stuff to track
CE transport-ids), and I've done about 4500 station reconnects over
the last 2 hours and no tx-credits hang issue so far.

Could be my debugging code or that I'm getting lucky, but I'm hopeful
that your patch actually fixed the problem I was seeing!

Thanks,
Ben


On 01/09/2015 09:19 AM, Vasanthakumar Thiagarajan wrote:
> When replenishing Rx buffers driver updates the address of the
> buffer and the index of rx buffer in rx ring to the firmware.
> Change in order by CPU can cause rx ring corruption. Add memory
> barrier before updating rx buffer index to guarantee the order.
> 
> This could fix some instances of rx ring corruption due to done
> bit in rx attention flag not set.
> 
> Signed-off-by: Vasanthakumar Thiagarajan <vthiagar@qti.qualcomm.com>
> ---
>  drivers/net/wireless/ath/ath10k/htt_rx.c |    5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/drivers/net/wireless/ath/ath10k/htt_rx.c b/drivers/net/wireless/ath/ath10k/htt_rx.c
> index 9c782a4..baa1c44 100644
> --- a/drivers/net/wireless/ath/ath10k/htt_rx.c
> +++ b/drivers/net/wireless/ath/ath10k/htt_rx.c
> @@ -97,6 +97,11 @@ static int __ath10k_htt_rx_ring_fill_n(struct ath10k_htt *htt, int num)
>  	}
>  
>  fail:
> +	/*
> +	 * Make sure the rx buffer is updated before available buffer
> +	 * index to avoid any potential rx ring corruption.
> +	 */
> +	mb();
>  	*htt->rx_ring.alloc_idx.vaddr = __cpu_to_le32(idx);
>  	return ret;
>  }
> 


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com


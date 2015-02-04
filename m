Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f177.google.com ([74.125.82.177]:45636 "EHLO
	mail-we0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932787AbbBDADE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Feb 2015 19:03:04 -0500
Received: by mail-we0-f177.google.com with SMTP id l61so47887435wev.8
        for <linux-wireless@vger.kernel.org>; Tue, 03 Feb 2015 16:03:03 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1420811846-20660-1-git-send-email-vthiagar@qti.qualcomm.com>
References: <1420811846-20660-1-git-send-email-vthiagar@qti.qualcomm.com>
From: Pushpal Sidhu <psidhu@gateworks.com>
Date: Tue, 3 Feb 2015 16:02:32 -0800
Message-ID: <CAD1M062adaV6Qr0J6V5M5xoZsgMiRU9rT8S8E3kZDqi8m9cV4Q@mail.gmail.com> (sfid-20150204_010313_476828_49D33927)
Subject: Re: [PATCH] ath10k: Fix potential Rx ring corruption
To: Vasanthakumar Thiagarajan <vthiagar@qti.qualcomm.com>
Cc: linux-wireless@vger.kernel.org, ath10k-devel@qca.qualcomm.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Just letting you know that this patch seems to have resolved an rx
corruption I was seeing when cpu went 100% sirq constantly for several
seconds. I have tested now for about an hour and have not been able to
reproduce the corruption so it seems very promising. I should note
that this is on an ARMv8 processor in case you're interested.

Thanks,
Pushpal

On Fri, Jan 9, 2015 at 5:57 AM, Vasanthakumar Thiagarajan
<vthiagar@qti.qualcomm.com> wrote:
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
>         }
>
>  fail:
> +       /*
> +        * Make sure the rx buffer is updated before available buffer
> +        * index to avoid any potential rx ring corruption.
> +        */
> +       mb();
>         *htt->rx_ring.alloc_idx.vaddr = __cpu_to_le32(idx);
>         return ret;
>  }
> --
> 1.7.9.5
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

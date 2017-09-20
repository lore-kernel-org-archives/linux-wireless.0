Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:41820 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751626AbdITMNK (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 20 Sep 2017 08:13:10 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Ganapathi Bhat <gbhat@marvell.com>
Cc: <linux-wireless@vger.kernel.org>, Cathy Luo <cluo@marvell.com>,
        Xinming Hu <huxm@marvell.com>,
        Zhiyuan Yang <yangzy@marvell.com>,
        James Cao <jcao@marvell.com>,
        Mangesh Malusare <mmangesh@marvell.com>
Subject: Re: [PATCH 1/2] mwifiex: resubmit failed to submit RX URBs in main thread
References: <1504122674-3379-1-git-send-email-gbhat@marvell.com>
        <1504122674-3379-2-git-send-email-gbhat@marvell.com>
Date: Wed, 20 Sep 2017 15:13:05 +0300
In-Reply-To: <1504122674-3379-2-git-send-email-gbhat@marvell.com> (Ganapathi
        Bhat's message of "Thu, 31 Aug 2017 01:21:13 +0530")
Message-ID: <8760cdzhym.fsf@purkki.adurom.net> (sfid-20170920_141313_342227_0242D0F2)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Ganapathi Bhat <gbhat@marvell.com> writes:

> From: James Cao <jcao@marvell.com>
>
> Current driver has 6 Rx data URBs. Once any packet received
> kernel calls our callback, in which the same URB will be
> resubmitted after Rx indication. In URB submission function a new
> skb will be allocated since the previous one is passed to upper
> layer (freed later). Since the skb is from a special pool (not
> regular memory), skb allocation may fail when kernel holds a lot
> of Rx packets on some low resource platforms.

The special pool being GFP_ATOMIC allocations or what?

> The URB will not be resubmitted in this no free skb case. If driver
> fails to resubmit all 6 URBs, Rx will stop. To cover this scenario
> check and resubmit Rx URBs in main thread.
>
> Signed-off-by: James Cao <jcao@marvell.com>
> Signed-off-by: Cathy Luo <cluo@marvell.com>
> Signed-off-by: Ganapathi Bhat <gbhat@marvell.com>

[...]

> @@ -278,6 +279,16 @@ int mwifiex_main_process(struct mwifiex_adapter *adapter)
>  			break;
>  		}
>  
> +		/* Try to resubmit RX URB if sunmission failed earlier */
> +		if (!atomic_read(&adapter->rx_pending) &&
> +		    adapter->iface_type == MWIFIEX_USB) {
> +			usb_card = adapter->card;
> +			if (atomic_read(&usb_card->rx_data_urb_pending) <
> +			    MWIFIEX_RX_DATA_URB &&
> +			    adapter->if_ops.submit_rem_rx_urbs)
> +				adapter->if_ops.submit_rem_rx_urbs(adapter);
> +		}

To me this just feels wrong. Normally the proceduce is to drop the frame
if allocations fail, not try to reallocate. I need more convincing that
this really is the right approach.

-- 
Kalle Valo

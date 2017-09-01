Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtprelay0225.hostedemail.com ([216.40.44.225]:34471 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1750707AbdIAEFb (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 1 Sep 2017 00:05:31 -0400
Message-ID: <1504238727.2361.1.camel@perches.com> (sfid-20170901_060534_501709_7DF15A2A)
Subject: Re: [PATCH 2/2] mwifiex: print URB submit failure error after
 threshold attemtps
From: Joe Perches <joe@perches.com>
To: Ganapathi Bhat <gbhat@marvell.com>, linux-wireless@vger.kernel.org
Cc: Cathy Luo <cluo@marvell.com>, Xinming Hu <huxm@marvell.com>,
        Zhiyuan Yang <yangzy@marvell.com>,
        James Cao <jcao@marvell.com>,
        Mangesh Malusare <mmangesh@marvell.com>
Date: Thu, 31 Aug 2017 21:05:27 -0700
In-Reply-To: <1504122674-3379-3-git-send-email-gbhat@marvell.com>
References: <1504122674-3379-1-git-send-email-gbhat@marvell.com>
         <1504122674-3379-3-git-send-email-gbhat@marvell.com>
Content-Type: text/plain; charset="ISO-8859-1"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2017-08-31 at 01:21 +0530, Ganapathi Bhat wrote:
> Current driver prints dev_alloc_skb failures everytime while
> submitting RX URBs. This failure might be frequent in some
> low resource platforms. So, wait for a threshold failure
> count before start priting the error. This change is a follow
> up for the 'commit 7b368e3d15c3
> ("mwifiex: resubmit failed to submit RX URBs in main thread")'

[]

> diff --git a/drivers/net/wireless/marvell/mwifiex/usb.c b/drivers/net/wireless/marvell/mwifiex/usb.c
[]
> @@ -300,9 +300,16 @@ static int mwifiex_usb_submit_rx_urb(struct urb_context *ctx, int size)
>  	if (card->rx_cmd_ep != ctx->ep) {
>  		ctx->skb = dev_alloc_skb(size);
>  		if (!ctx->skb) {
> -			mwifiex_dbg(adapter, ERROR,
> -				    "%s: dev_alloc_skb failed\n", __func__);
> +			if (++card->rx_urb_failure_count >
> +			    MWIFIEX_RX_URB_FAILURE_THRESHOLD) {
> +				mwifiex_dbg(adapter, ERROR,
> +					    "%s: dev_alloc_skb failed, failure count = %u\n",
> +					    __func__,
> +					    card->rx_urb_failure_count);
> +			}
>  			return -ENOMEM;

Why not use a ratelimit?

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:51804 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755168Ab2DZSVq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Apr 2012 14:21:46 -0400
Message-ID: <4F999235.3060007@qca.qualcomm.com> (sfid-20120426_202150_171596_248CCD5F)
Date: Thu, 26 Apr 2012 21:21:41 +0300
From: Kalle Valo <kvalo@qca.qualcomm.com>
MIME-Version: 1.0
To: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>, <ath6kl-devel@qualcomm.com>
Subject: Re: [PATCH 2/2] ath6kl: Complete failed tx packet in ath6kl_htc_tx_from_queue()
References: <1335452174-7093-1-git-send-email-vthiagar@qca.qualcomm.com> <1335452174-7093-2-git-send-email-vthiagar@qca.qualcomm.com>
In-Reply-To: <1335452174-7093-2-git-send-email-vthiagar@qca.qualcomm.com>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 04/26/2012 05:56 PM, Vasanthakumar Thiagarajan wrote:
> Return status of ath6kl_htc_tx_issue() is ignored in
> ath6kl_htc_tx_from_queue(), but failed tx packet is
> is not cleaned up. To fix memory leak in this case, call
> completion with error. Also, throw an error debug message
> when tx fails in ath6kl_sdio_write_async() due to shortage
> in bus request buffer.
> 
> Signed-off-by: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>

[...]

>  	bus_req = ath6kl_sdio_alloc_busreq(ar_sdio);
>  
> -	if (!bus_req)
> +	if (!bus_req) {
> +		ath6kl_err("Ran out of bus request buffer for tx\n");
>  		return -ENOMEM;
> +	}

I'm not sure about this one. There's a risk that this will spam the log.
Should it be a debug message instead? Or should we have instead
ath6kl_err_ratelimit()?

Kalle

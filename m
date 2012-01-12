Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:42918 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751937Ab2ALLlZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Jan 2012 06:41:25 -0500
Message-ID: <4F0EC61C.5090608@qca.qualcomm.com> (sfid-20120112_124149_870564_6F54442F)
Date: Thu, 12 Jan 2012 13:38:04 +0200
From: Kalle Valo <kvalo@qca.qualcomm.com>
MIME-Version: 1.0
To: Sujith Manoharan <c_manoha@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 3/4] ath6kl: Initialize a variable properly
References: <20235.48473.693136.780100@gargle.gargle.HOWL>
In-Reply-To: <20235.48473.693136.780100@gargle.gargle.HOWL>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 01/10/2012 06:23 AM, Sujith Manoharan wrote:
> This prevents 'comp_pktq' from being used in an
> incorrect manner.
> 
> Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
> ---
>  drivers/net/wireless/ath/ath6kl/htc.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/net/wireless/ath/ath6kl/htc.c b/drivers/net/wireless/ath/ath6kl/htc.c
> index b017022..2d72190 100644
> --- a/drivers/net/wireless/ath/ath6kl/htc.c
> +++ b/drivers/net/wireless/ath/ath6kl/htc.c
> @@ -2062,6 +2062,7 @@ int ath6kl_htc_rxmsg_pending_handler(struct htc_target *target,
>  	enum htc_endpoint_id id;
>  	int n_fetched = 0;
>  
> +	INIT_LIST_HEAD(&comp_pktq);


But there's also the same init later in the function, inside the while loop:

		INIT_LIST_HEAD(&rx_pktq);
		INIT_LIST_HEAD(&comp_pktq);

Is this intentional?

Kalle

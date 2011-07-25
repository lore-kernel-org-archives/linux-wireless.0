Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:34874 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752478Ab1GYTk4 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Jul 2011 15:40:56 -0400
Subject: Re: [PATCH] iwlagn: check for !priv->txq in
 iwlagn_wait_tx_queue_empty
From: wwguy <wey-yi.w.guy@intel.com>
To: Keith Packard <keithp@keithp.com>
Cc: Intel Linux Wireless <ilw@linux.intel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <1311622702-4807-1-git-send-email-keithp@keithp.com>
References: <1311622702-4807-1-git-send-email-keithp@keithp.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 25 Jul 2011 12:36:34 -0700
Message-ID: <1311622594.3431.0.camel@wwguy-ubuntu> (sfid-20110725_214101_164389_35FB3D15)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2011-07-25 at 12:38 -0700, Keith Packard wrote:
> If the interface is down, txq is NULL. iwlagn_wait_tx_queue_empty
> needs to check for this case to avoid dereferencing that pointer.
> 
> Signed-off-by: Keith Packard <keithp@keithp.com>
> ---
> 
> This is on top of v3.0
> 
>  drivers/net/wireless/iwlwifi/iwl-agn-lib.c |    3 +++
>  1 files changed, 3 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
> index f803fb6..d6ae444 100644
> --- a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
> +++ b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
> @@ -1487,6 +1487,9 @@ int iwlagn_wait_tx_queue_empty(struct iwl_priv *priv)
>  	unsigned long now = jiffies;
>  	int ret = 0;
>  
> +	if (!priv->txq)
> +		return 0;
> +
>  	/* waiting for all the tx frames complete might take a while */
>  	for (cnt = 0; cnt < priv->hw_params.max_txq_num; cnt++) {
>  		if (cnt == priv->cmd_queue)

is this against any bug in bugzilla? please include the information in
description

Thanks
Wey 


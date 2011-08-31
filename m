Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:20209 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752264Ab1HaKSQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 31 Aug 2011 06:18:16 -0400
Subject: Re: [patch -next 2/2] iwlwifi: signedness bug in
 iwl_trans_pcie_tx_agg_alloc()
From: "Guy, Wey-Yi" <wey-yi.w.guy@intel.com>
To: Dan Carpenter <error27@gmail.com>
Cc: "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>,
	Intel Linux Wireless <ilw@linux.intel.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	"open list:INTEL WIRELESS WI..." <linux-wireless@vger.kernel.org>,
	"kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>
In-Reply-To: <20110831063830.GD3705@shale.localdomain>
References: <20110831063830.GD3705@shale.localdomain>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 31 Aug 2011 02:35:36 -0700
Message-ID: <1314783336.26890.4.camel@wwguy-huron> (sfid-20110831_121820_730286_69E4A0C7)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2011-08-30 at 23:38 -0700, Dan Carpenter wrote:
> unsigned shorts and unsigned chars are never == -1.
> 
> Signed-off-by: Dan Carpenter <error27@gmail.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
> 
> diff --git a/drivers/net/wireless/iwlwifi/iwl-trans-tx-pcie.c b/drivers/net/wireless/iwlwifi/iwl-trans-tx-pcie.c
> index 5dd6a6d..ea6a0bc 100644
> --- a/drivers/net/wireless/iwlwifi/iwl-trans-tx-pcie.c
> +++ b/drivers/net/wireless/iwlwifi/iwl-trans-tx-pcie.c
> @@ -535,7 +535,7 @@ int iwl_trans_pcie_tx_agg_alloc(struct iwl_trans *trans,
>  	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
>  	struct iwl_tid_data *tid_data;
>  	unsigned long flags;
> -	u16 txq_id;
> +	int txq_id;
>  	struct iwl_priv *priv = priv(trans);
>  
>  	txq_id = iwlagn_txq_ctx_activate_free(trans);

True

Wey



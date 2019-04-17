Return-Path: <SRS0=eC3p=ST=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C2311C282DA
	for <linux-wireless@archiver.kernel.org>; Wed, 17 Apr 2019 07:14:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8F10D2176F
	for <linux-wireless@archiver.kernel.org>; Wed, 17 Apr 2019 07:14:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731112AbfDQHOL (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 17 Apr 2019 03:14:11 -0400
Received: from mga02.intel.com ([134.134.136.20]:5550 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727013AbfDQHOL (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 17 Apr 2019 03:14:11 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga101.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 17 Apr 2019 00:14:10 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.60,361,1549958400"; 
   d="scan'208";a="316655035"
Received: from dfava-mobl.ger.corp.intel.com ([10.252.1.108])
  by orsmga005.jf.intel.com with ESMTP; 17 Apr 2019 00:14:07 -0700
Message-ID: <cb50133154f8b8913dfe00231eeef77b3f650955.camel@intel.com>
Subject: Re: [PATCH] iwlwifi: Use correct channel_profile iniwl_get_nvm
From:   Luciano Coelho <luciano.coelho@intel.com>
To:     Yue Haibing <yuehaibing@huawei.com>, johannes.berg@intel.com,
        emmanuel.grumbach@intel.com, linuxwifi@intel.com,
        kvalo@codeaurora.org
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-wireless@vger.kernel.org, davem@davemloft.net
Date:   Wed, 17 Apr 2019 10:14:06 +0300
In-Reply-To: <20190417032409.23924-1-yuehaibing@huawei.com>
References: <20190417032409.23924-1-yuehaibing@huawei.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.30.5-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Wed, 2019-04-17 at 11:24 +0800, Yue Haibing wrote:
> From: YueHaibing <yuehaibing@huawei.com>
> 
> commit 2785ce008e3b ("iwlwifi: support new NVM response API")
> seems forgot use correct channel_profile in iwl_get_nvm when call
> iwl_init_sbands().
> 
> Fixes: 2785ce008e3b ("iwlwifi: support new NVM response API")
> Signed-off-by: YueHaibing <yuehaibing@huawei.com>
> ---
>  drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.c
> b/drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.c
> index 40985dc..d87a6bb 100644
> --- a/drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.c
> +++ b/drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.c
> @@ -1496,7 +1496,7 @@ struct iwl_nvm_data *iwl_get_nvm(struct
> iwl_trans *trans,
>  			  (void *)rsp_v3->regulatory.channel_profile;
>  
>  	iwl_init_sbands(trans->dev, trans->cfg, nvm,
> -			rsp->regulatory.channel_profile,
> +			channel_profile,
>  			nvm->valid_tx_ant & fw->valid_tx_ant,
>  			nvm->valid_rx_ant & fw->valid_rx_ant,
>  			sbands_flags, v4);

Thanks!

This was a rebase damage I made when sending this upstream.  I've
applied this directly to our upstream feeding tree because it's not
wrong in our internal tree.

--
Cheers,
Luca.


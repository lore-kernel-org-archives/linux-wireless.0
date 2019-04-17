Return-Path: <SRS0=eC3p=ST=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CB976C10F12
	for <linux-wireless@archiver.kernel.org>; Wed, 17 Apr 2019 10:17:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A44722073F
	for <linux-wireless@archiver.kernel.org>; Wed, 17 Apr 2019 10:17:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731574AbfDQKRR (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 17 Apr 2019 06:17:17 -0400
Received: from paleale.coelho.fi ([176.9.41.70]:53590 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726695AbfDQKRR (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 17 Apr 2019 06:17:17 -0400
Received: from 91-156-6-193.elisa-laajakaista.fi ([91.156.6.193] helo=redipa)
        by farmhouse.coelho.fi with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.91)
        (envelope-from <luca@coelho.fi>)
        id 1hGhcu-0006lb-BF; Wed, 17 Apr 2019 13:17:12 +0300
Message-ID: <3c1cb224613ac2cc3b20bfcf0c47e0df584c4e31.camel@coelho.fi>
From:   Luca Coelho <luca@coelho.fi>
To:     Michal Hocko <mhocko@kernel.org>
Cc:     kvalo@codeaurora.org, johannes@sipsolutions.net,
        emmanuel.grumbach@intel.com, linuxwifi@intel.com,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        Shahar S Matityahu <shahar.s.matityahu@intel.com>
Date:   Wed, 17 Apr 2019 13:17:10 +0300
In-Reply-To: <20190417101102.GA5878@dhcp22.suse.cz>
References: <748205b02961167b0926d4afe8d9ad9cb37bf6ef.camel@coelho.fi>
         <20190417073516.24250-1-luca@coelho.fi>
         <20190417101102.GA5878@dhcp22.suse.cz>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.30.5-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] iwlwifi: don't panic in error path on non-msix systems
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Wed, 2019-04-17 at 12:11 +0200, Michal Hocko wrote:
> Hi,
> which tree is this supposed to be applied on? It doesn't do apply on
> top
> of v5.1-rc4-3-gfd008d1a7a20. iwl_trans_pcie_sync_nmi doesn't exist in
> drivers/net/wireless/intel/iwlwifi/pcie/trans.c. iwl_trans_sync_nmi
> looks pretty similar. My patch massaging ended up with this. Please
> double check. It compiles and even boots.

Ah, sorry, I didn't mention that that patch was supposed to apply on
top of wireless-drivers-next, which is on its way to v5.2.  We have
other patches touching this function there, thus the conflict.

> diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
> b/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
> index fe8269d023de..1f3969e2bcac 100644
> --- a/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
> +++ b/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
> @@ -3639,20 +3639,27 @@ struct iwl_trans *iwl_trans_pcie_alloc(struct
> pci_dev *pdev,
>  
>  void iwl_trans_sync_nmi(struct iwl_trans *trans)
>  {
> +	struct iwl_trans_pcie *trans_pcie =
> IWL_TRANS_GET_PCIE_TRANS(trans);
>  	unsigned long timeout = jiffies + IWL_TRANS_NMI_TIMEOUT;
> +	u32 inta_addr, sw_err_bit;
> +
> +	if (trans_pcie->msix_enabled) {
> +		inta_addr = CSR_MSIX_HW_INT_CAUSES_AD;
> +		sw_err_bit = MSIX_HW_INT_CAUSES_REG_SW_ERR;
> +	} else {
> +		inta_addr = CSR_INT;
> +		sw_err_bit = CSR_INT_BIT_SW_ERR;
> +	}
>  
>  	iwl_disable_interrupts(trans);
>  	iwl_force_nmi(trans);
>  	while (time_after(timeout, jiffies)) {
> -		u32 inta_hw = iwl_read32(trans,
> -					 CSR_MSIX_HW_INT_CAUSES_AD);
> +		u32 inta_hw = iwl_read32(trans, inta_addr);
>  
>  		/* Error detected by uCode */
> -		if (inta_hw & MSIX_HW_INT_CAUSES_REG_SW_ERR) {
> +		if (inta_hw & sw_err_bit) {
>  			/* Clear causes register */
> -			iwl_write32(trans, CSR_MSIX_HW_INT_CAUSES_AD,
> -				    inta_hw &
> -				    MSIX_HW_INT_CAUSES_REG_SW_ERR);
> +			iwl_write32(trans, inta_addr, inta_hw &
> sw_err_bit);
>  			break;
>  		}

This looks good! So it fixed the problem you were having now?


--
Cheers,
Luca.


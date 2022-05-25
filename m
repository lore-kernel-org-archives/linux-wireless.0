Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 40E42C433EF
	for <linux-wireless@archiver.kernel.org>; Wed, 25 May 2022 18:52:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343857AbiEYSwT (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 25 May 2022 14:52:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233736AbiEYSwS (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 25 May 2022 14:52:18 -0400
X-Greylist: delayed 329 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 25 May 2022 11:52:16 PDT
Received: from ns.iliad.fr (ns.iliad.fr [212.27.33.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35E62B41F9;
        Wed, 25 May 2022 11:52:15 -0700 (PDT)
Received: from ns.iliad.fr (localhost [127.0.0.1])
        by ns.iliad.fr (Postfix) with ESMTP id 1735520041;
        Wed, 25 May 2022 20:46:44 +0200 (CEST)
Received: from sakura (freebox.vlq16.iliad.fr [213.36.7.13])
        by ns.iliad.fr (Postfix) with ESMTP id 121931FFE1;
        Wed, 25 May 2022 20:46:44 +0200 (CEST)
Message-ID: <bd6d97a4cc6665d0ee632444f75e3480160387ec.camel@freebox.fr>
Subject: Re: [PATCH v7 4/9] ath11k: Add register access logic for WCN6750
From:   Maxime Bizon <mbizon@freebox.fr>
Reply-To: mbizon@freebox.fr
To:     Manikanta Pubbisetty <quic_mpubbise@quicinc.com>,
        ath11k@lists.infradead.org
Cc:     linux-wireless@vger.kernel.org, devicetree@vger.kernel.org,
        robh@kernel.org, mka@chromium.org
Date:   Wed, 25 May 2022 20:46:43 +0200
In-Reply-To: <20220429170502.20080-5-quic_mpubbise@quicinc.com>
References: <20220429170502.20080-1-quic_mpubbise@quicinc.com>
         <20220429170502.20080-5-quic_mpubbise@quicinc.com>
Organization: Freebox
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Virus-Scanned: ClamAV using ClamSMTP ; ns.iliad.fr ; Wed May 25 20:46:44 2022 +0200 (CEST)
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org


On Fri, 2022-04-29 at 22:34 +0530, Manikanta Pubbisetty wrote:

Hello Manikanta,

> Tested-on: QCN9074 hw1.0 PCI WLAN.HK.2.5.0.1-01100-
> QCAHKSWPL_SILICONZ-1

Nope your patch breaks QCN9074:

[   13.660963] ath11k_pci 0000:03:00.0: failed to set pcie link register 0x01e0e0a8: 0xffffffff != 0x00000010
[   13.675994] ath11k_pci 0000:03:00.0: failed to set sysclk: -110

device still seem to work though

> @@ -134,16 +134,13 @@ EXPORT_SYMBOL(ath11k_pcic_init_msi_config);
>  static inline u32 ath11k_pcic_get_window_start(struct ath11k_base *ab,
>  					       u32 offset)
>  {
> -	u32 window_start;
> +	u32 window_start = 0;
>  
> -	/* If offset lies within DP register range, use 3rd window */
>  	if ((offset ^ HAL_SEQ_WCSS_UMAC_OFFSET) < ATH11K_PCI_WINDOW_RANGE_MASK)
> -		window_start = 3 * ATH11K_PCI_WINDOW_START;
> -	/* If offset lies within CE register range, use 2nd window */
> -	else if ((offset ^ HAL_CE_WFSS_CE_REG_BASE) < ATH11K_PCI_WINDOW_RANGE_MASK)
> -		window_start = 2 * ATH11K_PCI_WINDOW_START;
> -	else
> -		window_start = ATH11K_PCI_WINDOW_START;
> +		window_start = ab->hw_params.dp_window_idx * ATH11K_PCI_WINDOW_START;
> +	else if ((offset ^ HAL_SEQ_WCSS_UMAC_CE0_SRC_REG(ab)) <
> +		 ATH11K_PCI_WINDOW_RANGE_MASK)
> +		window_start = ab->hw_params.ce_window_idx * ATH11K_PCI_WINDOW_START;
>  
>  	return window_start;
>  }


for some offsets, previous code could return ATH11K_PCI_WINDOW_START,
whereas new code now returns 0


> @@ -162,19 +159,12 @@ void ath11k_pcic_write32(struct ath11k_base *ab, u32 offset, u32 value)
>  
>  	if (offset < ATH11K_PCI_WINDOW_START) {
>  		iowrite32(value, ab->mem  + offset);
> -	} else {
> -		if (ab->hw_params.static_window_map)
> -			window_start = ath11k_pcic_get_window_start(ab, offset);
> -		else
> -			window_start = ATH11K_PCI_WINDOW_START;
> -
> -		if (window_start == ATH11K_PCI_WINDOW_START &&
> -		    ab->pci.ops->window_write32) {
> -			ab->pci.ops->window_write32(ab, offset, value);
> -		} else {
> -			iowrite32(value, ab->mem + window_start +
> -				  (offset & ATH11K_PCI_WINDOW_RANGE_MASK));
> -		}
> +	} else if (ab->hw_params.static_window_map) {
> +		window_start = ath11k_pcic_get_window_start(ab, offset);
> +		iowrite32(value, ab->mem + window_start +
> +			  (offset & ATH11K_PCI_WINDOW_RANGE_MASK));
> +	} else if (ab->pci.ops->window_write32) {
> +		ab->pci.ops->window_write32(ab, offset, value);
>  	}
> 

with previous code on QCN9074, when ath11k_pcic_get_window_start()
returned ATH11K_PCI_WINDOW_START, then it would call window_write32()

with new code on QCN9074, static_window_map is true, so window_write32
will never be called.

>  u32 ath11k_pcic_read32(struct ath11k_base *ab, u32 offset)

ditto here

-- 
Maxime




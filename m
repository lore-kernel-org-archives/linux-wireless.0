Return-Path: <SRS0=2I9a=RX=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6EF96C43381
	for <linux-wireless@archiver.kernel.org>; Wed, 20 Mar 2019 15:12:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3BBC32184D
	for <linux-wireless@archiver.kernel.org>; Wed, 20 Mar 2019 15:12:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=candelatech.com header.i=@candelatech.com header.b="ITNQXz15"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727358AbfCTPMR (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 20 Mar 2019 11:12:17 -0400
Received: from [208.74.158.174] ([208.74.158.174]:40080 "EHLO
        mail3.candelatech.com" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1726169AbfCTPMR (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 20 Mar 2019 11:12:17 -0400
Received: from [192.168.100.195] (50-251-239-81-static.hfc.comcastbusiness.net [50.251.239.81])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail3.candelatech.com (Postfix) with ESMTPSA id 87516114B47;
        Wed, 20 Mar 2019 08:12:16 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mail3.candelatech.com 87516114B47
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=candelatech.com;
        s=default; t=1553094736;
        bh=edk7KYq1srgFs6i5Duvcm+oGY3hT3mf5OgvmGvgfLCk=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=ITNQXz15CJesCHr3UcGv4kfPJbJhePNpMwL5n1dPcP7ubjG+nu3wyQzbAC3E8KA1u
         9Hd0NAijO1MTQ+W2zUKXfc2T2iWjX+187bUKUKUV0VuQ1S+MKFAVGpMu5zWqXAwd+m
         w2ndHg1dHKNMs9g7VwZCKxwPFGJ3AhxWivVjisng=
Subject: Re: [PATCH] ath10k: Fix ASPM L1 state on QCA988X
To:     =?UTF-8?Q?Tomislav_Po=c5=beega?= <pozega.tomislav@gmail.com>,
        linux-wireless@vger.kernel.org
Cc:     kvalo@codeaurora.org, Sujith Manoharan <c_manoha@qca.qualcomm.com>
References: <1553025580-6118-1-git-send-email-pozega.tomislav@gmail.com>
From:   Ben Greear <greearb@candelatech.com>
Organization: Candela Technologies
Message-ID: <2715bcef-5b03-fc19-e665-3c6f90a7d123@candelatech.com>
Date:   Wed, 20 Mar 2019 08:12:16 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <1553025580-6118-1-git-send-email-pozega.tomislav@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On 3/19/19 12:59 PM, Tomislav Požega wrote:
> On some systems there are heavy crashes if the kernel config
> option CONFIG_PCIEASPM_PERFORMANCE is not set. Patch provided by
> Sujith for ath9k fixes this issue and the card operates without
> crashes with kernel default CONFIG_PCIEASPM_DEFAULT option that uses
> BIOS provided ASPM settings. Tested with QCA9862 mPCIe card.

Hello,

Were these firmware crashes or system crashes or both?  Can you
describe that a bit more so we can better understand what bugs this
is fixing?


Thanks,
Ben

> 
> Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
> Signed-off-by: Tomislav Požega <pozega.tomislav@gmail.com>
> ---
>   drivers/net/wireless/ath/ath10k/pci.c |   15 +++++++++++++--
>   1 files changed, 13 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/wireless/ath/ath10k/pci.c b/drivers/net/wireless/ath/ath10k/pci.c
> index 271f92c..e24403c 100644
> --- a/drivers/net/wireless/ath/ath10k/pci.c
> +++ b/drivers/net/wireless/ath/ath10k/pci.c
> @@ -2787,14 +2787,25 @@ static int ath10k_pci_hif_power_up(struct ath10k *ar,
>   				   enum ath10k_firmware_mode fw_mode)
>   {
>   	struct ath10k_pci *ar_pci = ath10k_pci_priv(ar);
> +	struct pci_dev *pdev = ar_pci->pdev;
>   	int ret;
> +	u32 val;
>   
>   	ath10k_dbg(ar, ATH10K_DBG_BOOT, "boot hif power up\n");
>   
> -	pcie_capability_read_word(ar_pci->pdev, PCI_EXP_LNKCTL,
> +	if (ar->dev_id == QCA988X_2_0_DEVICE_ID) {
> +		pci_read_config_dword(pdev, 0x70c, &val);
> +		if ((val & 0xff000000) == 0x17000000) {
> +			val &= 0x00ffffff;
> +			val |= 0x27000000;
> +			pci_write_config_dword(pdev, 0x570c, val);
> +		}
> +	} else {
> +		pcie_capability_read_word(ar_pci->pdev, PCI_EXP_LNKCTL,
>   				  &ar_pci->link_ctl);
> -	pcie_capability_write_word(ar_pci->pdev, PCI_EXP_LNKCTL,
> +		pcie_capability_write_word(ar_pci->pdev, PCI_EXP_LNKCTL,
>   				   ar_pci->link_ctl & ~PCI_EXP_LNKCTL_ASPMC);
> +	}
>   
>   	/*
>   	 * Bring the target up cleanly.
> 


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com


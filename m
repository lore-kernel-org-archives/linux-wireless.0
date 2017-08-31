Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:28019 "EHLO
        sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750942AbdHaMxB (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 31 Aug 2017 08:53:01 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [v3,1/2] ath10k: add the PCI PM core suspend/resume ops
From: Kalle Valo <kvalo@qca.qualcomm.com>
In-Reply-To: <1503438455-6133-1-git-send-email-ryanhsu@qti.qualcomm.com>
References: <1503438455-6133-1-git-send-email-ryanhsu@qti.qualcomm.com>
To: <ryanhsu@qti.qualcomm.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>,
        <ryanhsu@qti.qualcomm.com>
Message-ID: <f4652c401e1f462d89b4611afe9bd623@euamsexm01a.eu.qualcomm.com> (sfid-20170831_145304_939567_72F339CD)
Date: Thu, 31 Aug 2017 14:52:54 +0200
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

ryanhsu@qti.qualcomm.com wrote:

> The actual PCI suspend/resume in ath10k has been handled in wow.c,
> but in the case of the device doesn't support remote wakeup,
> the .hif_suspend() and .hif_resume() will never be handled.
> 
>   ath10k_wow_op_suspend()
>   {
> 	if (WARN_ON(!test_bit(ATH10K_FW_FEATURE_WOWLAN_SUPPORT,
> 		    ar->running_fw->fw_file.fw_features))) {
> 		ret = 1;
> 		goto exit;
> 	}
> 
> 	....
> 
> 	ret = ath10k_hif_suspend(ar);
>   }
> 
> So register the PCI PM core to support the suspend/resume if the device
> doesn't support remote wakeup.
> 
> Signed-off-by: Ryan Hsu <ryanhsu@qti.qualcomm.com>
> Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>

This had a warning:

drivers/net/wireless/ath/ath10k/pci.c:3651:1: warning: symbol 'ath10k_pci_pm_ops' was not declared. Should it be static?

I fixed it in the pending branch by making it static:

static SIMPLE_DEV_PM_OPS(ath10k_pci_pm_ops,
			 ath10k_pci_pm_suspend,
			 ath10k_pci_pm_resume);

Please review.

-- 
https://patchwork.kernel.org/patch/9916215/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:61445 "EHLO
        sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750911AbdHaSSQ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 31 Aug 2017 14:18:16 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [v3,1/2] ath10k: add the PCI PM core suspend/resume ops
From: Kalle Valo <kvalo@qca.qualcomm.com>
In-Reply-To: <1503438455-6133-1-git-send-email-ryanhsu@qti.qualcomm.com>
References: <1503438455-6133-1-git-send-email-ryanhsu@qti.qualcomm.com>
To: <ryanhsu@qti.qualcomm.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>,
        <ryanhsu@qti.qualcomm.com>
Message-ID: <ebaaabc57ae441ee8707a9f7f5b0199e@euamsexm01a.eu.qualcomm.com> (sfid-20170831_201819_877935_EBC52CB7)
Date: Thu, 31 Aug 2017 20:18:09 +0200
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

2 patches applied to ath-next branch of ath.git, thanks.

32faa3f0ee50 ath10k: add the PCI PM core suspend/resume ops
393b706cf20c ath10k: configure and enable the wakeup capability

-- 
https://patchwork.kernel.org/patch/9916215/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

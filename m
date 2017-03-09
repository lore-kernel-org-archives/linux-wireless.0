Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:47048 "EHLO
        wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753709AbdCIIBD (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 9 Mar 2017 03:01:03 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [v2,1/2] ath10k: improve the firmware download time for QCA6174
From: Kalle Valo <kvalo@qca.qualcomm.com>
In-Reply-To: <1487205210-17112-1-git-send-email-ryanhsu@qca.qualcomm.com>
References: <1487205210-17112-1-git-send-email-ryanhsu@qca.qualcomm.com>
To: Ryan Hsu <ryanhsu@qca.qualcomm.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>,
        <ryanhsu@qca.qualcomm.com>, <lenb@kernel.org>
Message-ID: <5a88a04633554a27a30fbd7f4dad1af7@euamsexm01a.eu.qualcomm.com> (sfid-20170309_090310_252026_DDD7949A)
Date: Thu, 9 Mar 2017 08:57:32 +0100
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Ryan Hsu <ryanhsu@qca.qualcomm.com> wrote:
> From: Ryan Hsu <ryanhsu@qca.qualcomm.com>
> 
> Len Brown reported the system resume time is taking more than 2 seconds in
> bug - https://bugzilla.kernel.org/show_bug.cgi?id=185621.
> 
> The reason of the 2 seconds is due to the firmware download time.
> 
> The chip is booted up in the default reference clock speed to handle the
> firmware download to chip memory and advanced to the support higher speed
> clock to run the firmware after all. The default reference clock in the
> hardware is slow so that the firmware download time is taking up to 2
> seconds for a 600KB firmware file.
> 
> 	[76796.349701] ath10k_pci : boot uploading firmware image len 688691
> 	[76798.334612] ath10k_pci : htt tx max num pending tx 1056
> 
> The resolution here is to enable the higher speed clock if the hardware
> supported before the firmware download at BMI stage, so that the hardware
> can handle the firmare download in a more efficient way. This can help to
> improve the firmware download time from 2 seconds to around 500ms for the
> same 600KB firmware file.
> 
> 	[322858.577919] ath10k_pci boot uploading firmware image len 688691
> 	[322859.093094] ath10k_pci htt tx max num pending tx 1056
> 
> The steps to advance to the higher speed clock is very hardware specific,
> so adding the hardware ops for the hardware that can support this.
> 
> Reported-by: Len Brown <lenb@kernel.org>
> Signed-off-by: Ryan Hsu <ryanhsu@qca.qualcomm.com>

2 patches applied to ath-next branch of ath.git, thanks.

583a6629432c ath10k: improve the firmware download time for QCA6174
912b6e8850a5 ath10k: improve the firmware download time for QCA9377

-- 
https://patchwork.kernel.org/patch/9576081/

Documentation about submitting wireless patches and checking status
from patchwork:

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

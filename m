Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from alexa-out.qualcomm.com ([129.46.98.28]:8851 "EHLO
        alexa-out-lv-02.qualcomm.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1750938AbdHaMPs (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 31 Aug 2017 08:15:48 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: ath10k: activate user space firmware loading again
From: Kalle Valo <kvalo@qca.qualcomm.com>
In-Reply-To: <20170824210641.19595-1-hauke@hauke-m.de>
References: <20170824210641.19595-1-hauke@hauke-m.de>
To: Hauke Mehrtens <hauke@hauke-m.de>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>,
        "Hauke Mehrtens" <hauke@hauke-m.de>,
        Michal Kazior <michal.kazior@tieto.com>
Message-ID: <9a6c90a6d5dd431d8e940f619baf7b0c@euamsexm01a.eu.qualcomm.com> (sfid-20170831_141551_299578_BDA5E62C)
Date: Thu, 31 Aug 2017 14:15:41 +0200
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hauke Mehrtens <hauke@hauke-m.de> wrote:

> In commit 9f5bcfe93315 ("ath10k: silence firmware file probing
> warnings") the firmware loading was changed from request_firmware() to
> request_firmware_direct() to silence some warnings in case it fails.
> request_firmware_direct() directly searches in the file system only and
> does not send a hotplug event to user space in case it could not find
> the firmware directly.
> In LEDE we use a user space script to extract the calibration data from
> the flash memory which gets triggered by the hotplug event. This way the
> firmware gets extracted from some vendor specific partition when the
> driver requests this firmware. This mechanism does not work any more
> after this change.
> 
> Fixes: 9f5bcfe93315 ("ath10k: silence firmware file probing warnings")
> Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
> Cc: Michal Kazior <michal.kazior@tieto.com>
> Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>

Patch applied to ath-next branch of ath.git, thanks.

c0cc00f250e1 ath10k: activate user space firmware loading again

-- 
https://patchwork.kernel.org/patch/9920973/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from alexa-out.qualcomm.com ([129.46.98.28]:44971 "EHLO
        alexa-out.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751480AbdJMLhq (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 13 Oct 2017 07:37:46 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: ath10k: fix core PCI suspend when WoWLAN is supported but disabled
From: Kalle Valo <kvalo@qca.qualcomm.com>
In-Reply-To: <20170919232416.108247-1-briannorris@chromium.org>
References: <20170919232416.108247-1-briannorris@chromium.org>
To: Brian Norris <briannorris@chromium.org>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>,
        "Grant Grundler" <grundler@chromium.org>,
        <linux-kernel@vger.kernel.org>,
        "Brian Norris" <briannorris@chromium.org>,
        Ryan Hsu <ryanhsu@qti.qualcomm.com>,
        Michal Kazior <michal.kazior@tieto.com>
Message-ID: <2809b2cf512d4c198d3cef3f5e468c3c@euamsexm01e.eu.qualcomm.com> (sfid-20171013_133815_281978_9221C3F6)
Date: Fri, 13 Oct 2017 13:37:37 +0200
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Brian Norris <briannorris@chromium.org> wrote:

> For devices where the FW supports WoWLAN but user-space has not
> configured it, we don't do any PCI-specific suspend/resume operations,
> because mac80211 doesn't call drv_suspend() when !wowlan. This has
> particularly bad effects for some platforms, because we don't stop the
> power-save timer, and if this timer goes off after the PCI controller
> has suspended the link, Bad Things will happen.
> 
> Commit 32faa3f0ee50 ("ath10k: add the PCI PM core suspend/resume ops")
> got some of this right, in that it understood there was a problem on
> non-WoWLAN firmware. But it forgot the $subject case.
> 
> Fix this by moving all the PCI driver suspend/resume logic exclusively
> into the driver PM hooks. This shouldn't affect WoWLAN support much
> (this just gets executed later on).
> 
> I would just as well kill the entirety of ath10k_hif_suspend(), as it's
> not even implemented on the USB or SDIO drivers. I expect that we don't
> need the callback, except to return "supported" (i.e., 0) or "not
> supported" (i.e., -EOPNOTSUPP).
> 
> Fixes: 32faa3f0ee50 ("ath10k: add the PCI PM core suspend/resume ops")
> Fixes: 77258d409ce4 ("ath10k: enable pci soc powersaving")
> Signed-off-by: Brian Norris <briannorris@chromium.org>
> Cc: Ryan Hsu <ryanhsu@qti.qualcomm.com>
> Cc: Kalle Valo <kvalo@qca.qualcomm.com>
> Cc: Michal Kazior <michal.kazior@tieto.com>
> Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>

Patch applied to ath-next branch of ath.git, thanks.

96378bd2c6cd ath10k: fix core PCI suspend when WoWLAN is supported but disabled

-- 
https://patchwork.kernel.org/patch/9960481/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

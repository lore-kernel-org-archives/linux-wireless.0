Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:35452 "EHLO
        sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754930AbdJSOcs (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 19 Oct 2017 10:32:48 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Brian Norris <briannorris@chromium.org>
CC: Ryan Hsu <ryanhsu@qti.qualcomm.com>,
        Grant Grundler <grundler@chromium.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>
Subject: Re: ath10k: fix core PCI suspend when WoWLAN is supported but
 disabled
Date: Thu, 19 Oct 2017 14:32:45 +0000
Message-ID: <87vajbgqcz.fsf@kamboji.qca.qualcomm.com> (sfid-20171019_163336_469880_2854D56B)
References: <20170919232416.108247-1-briannorris@chromium.org>
        <2809b2cf512d4c198d3cef3f5e468c3c@euamsexm01e.eu.qualcomm.com>
In-Reply-To: <2809b2cf512d4c198d3cef3f5e468c3c@euamsexm01e.eu.qualcomm.com>
        (Kalle Valo's message of "Fri, 13 Oct 2017 13:37:37 +0200")
Content-Type: text/plain; charset="iso-8859-1"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Kalle Valo <kvalo@qca.qualcomm.com> writes:

> Brian Norris <briannorris@chromium.org> wrote:
>
>> For devices where the FW supports WoWLAN but user-space has not
>> configured it, we don't do any PCI-specific suspend/resume operations,
>> because mac80211 doesn't call drv_suspend() when !wowlan. This has
>> particularly bad effects for some platforms, because we don't stop the
>> power-save timer, and if this timer goes off after the PCI controller
>> has suspended the link, Bad Things will happen.
>>=20
>> Commit 32faa3f0ee50 ("ath10k: add the PCI PM core suspend/resume ops")
>> got some of this right, in that it understood there was a problem on
>> non-WoWLAN firmware. But it forgot the $subject case.
>>=20
>> Fix this by moving all the PCI driver suspend/resume logic exclusively
>> into the driver PM hooks. This shouldn't affect WoWLAN support much
>> (this just gets executed later on).
>>=20
>> I would just as well kill the entirety of ath10k_hif_suspend(), as it's
>> not even implemented on the USB or SDIO drivers. I expect that we don't
>> need the callback, except to return "supported" (i.e., 0) or "not
>> supported" (i.e., -EOPNOTSUPP).
>>=20
>> Fixes: 32faa3f0ee50 ("ath10k: add the PCI PM core suspend/resume ops")
>> Fixes: 77258d409ce4 ("ath10k: enable pci soc powersaving")
>> Signed-off-by: Brian Norris <briannorris@chromium.org>
>> Cc: Ryan Hsu <ryanhsu@qti.qualcomm.com>
>> Cc: Kalle Valo <kvalo@qca.qualcomm.com>
>> Cc: Michal Kazior <michal.kazior@tieto.com>
>> Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
>
> Patch applied to ath-next branch of ath.git, thanks.
>
> 96378bd2c6cd ath10k: fix core PCI suspend when WoWLAN is supported but di=
sabled

Kbuild found a build problem, I suspect it's caused by this patch:

drivers/net/wireless/ath/ath10k/pci.c:3416:8: error: implicit
declaration of function 'ath10k_pci_suspend'
[-Werror=3Dimplicit-function-declaration]

drivers/net/wireless/ath/ath10k/pci.c:3428:8: error: implicit
declaration of function 'ath10k_pci_resume'
[-Werror=3Dimplicit-function-declaration]

http://lists.infradead.org/pipermail/ath10k/2017-October/010269.html

The .config.gz there doesn't have CONFIG_PM set, maybe that's the
problem?

--=20
Kalle Valo=

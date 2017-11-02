Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ot0-f195.google.com ([74.125.82.195]:45204 "EHLO
        mail-ot0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933567AbdKBPk6 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 2 Nov 2017 11:40:58 -0400
MIME-Version: 1.0
In-Reply-To: <87mv44ln5v.fsf@qca.qualcomm.com>
References: <20171102110903.2886660-1-arnd@arndb.de> <87mv44ln5v.fsf@qca.qualcomm.com>
From: Arnd Bergmann <arnd@arndb.de>
Date: Thu, 2 Nov 2017 16:40:57 +0100
Message-ID: <CAK8P3a2xkh19gocctXf4gv1Km_SaYJPbSC5QkkZ0WMQQAXp83Q@mail.gmail.com> (sfid-20171102_164117_148010_E9405ED5)
Subject: Re: [PATCH] ath10k: move pci suspend/resume functions
To: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: Ryan Hsu <ryanhsu@qti.qualcomm.com>,
        Govind Singh <govinds@qti.qualcomm.com>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Ashok Raj Nagarajan <arnagara@qti.qualcomm.com>,
        Ben Greear <greearb@candelatech.com>,
        Brian Norris <briannorris@chromium.org>,
        Colin Ian King <colin.king@canonical.com>,
        "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Nov 2, 2017 at 4:23 PM, Kalle Valo <kvalo@qca.qualcomm.com> wrote:
> Arnd Bergmann <arnd@arndb.de> writes:
>
>> The combination of two patches has led to a build failure:
>>
>> drivers/net/wireless/ath/ath10k/pci.c: In function 'ath10k_pci_pm_suspend':
>> drivers/net/wireless/ath/ath10k/pci.c:3416:8: error: implicit declaration of function 'ath10k_pci_suspend'; did you mean 'ath10k_pci_pm_suspend'? [-Werror=implicit-function-declaration]
>> drivers/net/wireless/ath/ath10k/pci.c: In function 'ath10k_pci_pm_resume':
>> drivers/net/wireless/ath/ath10k/pci.c:3428:8: error: implicit declaration of function 'ath10k_pci_resume'; did you mean 'ath10k_pci_pm_resume'? [-Werror=implicit-function-declaration]
>>
>> This moves the functions outside of the now incorrect #ifdef.
>>
>> Fixes: 96378bd2c6cd ("ath10k: fix core PCI suspend when WoWLAN is supported but disabled")
>> Fixes: 6af1de2e4ec4 ("ath10k: mark PM functions as __maybe_unused")
>> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
>
> Brian has already fixed this, please check that:
>
> https://git.kernel.org/pub/scm/linux/kernel/git/kvalo/ath.git/commit/?h=ath-next&id=20665a9076d48e9abd9a2db13d307f58f7ef6647
>
> But apparently I forgot to merge ath-next to wireless-drivers-next, will
> do that soon.

Yes, Brian's version is better. I considered the same, but wasn't sure
it was safe.

      Arnd

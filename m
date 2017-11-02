Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:46704 "EHLO
        sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933418AbdKBPXp (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 2 Nov 2017 11:23:45 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Arnd Bergmann <arnd@arndb.de>
CC: Ryan Hsu <ryanhsu@qti.qualcomm.com>,
        Govind Singh <govinds@qti.qualcomm.com>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Ashok Raj Nagarajan <arnagara@qti.qualcomm.com>,
        Ben Greear <greearb@candelatech.com>,
        "Brian Norris" <briannorris@chromium.org>,
        Colin Ian King <colin.king@canonical.com>,
        "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ath10k: move pci suspend/resume functions
Date: Thu, 2 Nov 2017 15:23:42 +0000
Message-ID: <87mv44ln5v.fsf@qca.qualcomm.com> (sfid-20171102_162357_643339_372D1884)
References: <20171102110903.2886660-1-arnd@arndb.de>
In-Reply-To: <20171102110903.2886660-1-arnd@arndb.de> (Arnd Bergmann's message
        of "Thu, 2 Nov 2017 12:08:53 +0100")
Content-Type: text/plain; charset="iso-8859-1"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Arnd Bergmann <arnd@arndb.de> writes:

> The combination of two patches has led to a build failure:
>
> drivers/net/wireless/ath/ath10k/pci.c: In function 'ath10k_pci_pm_suspend=
':
> drivers/net/wireless/ath/ath10k/pci.c:3416:8: error: implicit declaration=
 of function 'ath10k_pci_suspend'; did you mean 'ath10k_pci_pm_suspend'? [-=
Werror=3Dimplicit-function-declaration]
> drivers/net/wireless/ath/ath10k/pci.c: In function 'ath10k_pci_pm_resume'=
:
> drivers/net/wireless/ath/ath10k/pci.c:3428:8: error: implicit declaration=
 of function 'ath10k_pci_resume'; did you mean 'ath10k_pci_pm_resume'? [-We=
rror=3Dimplicit-function-declaration]
>
> This moves the functions outside of the now incorrect #ifdef.
>
> Fixes: 96378bd2c6cd ("ath10k: fix core PCI suspend when WoWLAN is support=
ed but disabled")
> Fixes: 6af1de2e4ec4 ("ath10k: mark PM functions as __maybe_unused")
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

Brian has already fixed this, please check that:

https://git.kernel.org/pub/scm/linux/kernel/git/kvalo/ath.git/commit/?h=3Da=
th-next&id=3D20665a9076d48e9abd9a2db13d307f58f7ef6647

But apparently I forgot to merge ath-next to wireless-drivers-next, will
do that soon.

--=20
Kalle Valo=

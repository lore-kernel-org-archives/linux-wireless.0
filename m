Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:23087 "EHLO
        sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752430AbdJ0Noy (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 27 Oct 2017 09:44:54 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: ath10k: fix build errors with !CONFIG_PM
From: Kalle Valo <kvalo@qca.qualcomm.com>
In-Reply-To: <20171019184517.GA76422@google.com>
References: <20171019184517.GA76422@google.com>
To: Brian Norris <briannorris@chromium.org>
CC: Ryan Hsu <ryanhsu@qti.qualcomm.com>,
        Grant Grundler <grundler@chromium.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
        Arnd Bergmann <arnd@arndb.de>
Message-ID: <1444f65cd21b474f808e370a9f831d5e@euamsexm01a.eu.qualcomm.com> (sfid-20171027_154623_398019_0F3AED57)
Date: Fri, 27 Oct 2017 15:44:46 +0200
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Brian Norris <briannorris@chromium.org> wrote:

> Build errors have been reported with CONFIG_PM=n:
> 
> drivers/net/wireless/ath/ath10k/pci.c:3416:8: error: implicit
> declaration of function 'ath10k_pci_suspend'
> [-Werror=implicit-function-declaration]
> 
> drivers/net/wireless/ath/ath10k/pci.c:3428:8: error: implicit
> declaration of function 'ath10k_pci_resume'
> [-Werror=implicit-function-declaration]
> 
> These are caused by the combination of the following two commits:
> 
> 6af1de2e4ec4 ("ath10k: mark PM functions as __maybe_unused")
> 96378bd2c6cd ("ath10k: fix core PCI suspend when WoWLAN is supported but
> disabled")
> 
> Both build fine on their own.
> 
> But now that ath10k_pci_pm_{suspend,resume}() is compiled
> unconditionally, we should also compile ath10k_pci_{suspend,resume}()
> unconditionally.
> 
> And drop the #ifdef around ath10k_pci_hif_{suspend,resume}() too; they
> are trivial (empty), so we're not saving much space by compiling them
> out. And the alternatives would be to sprinkle more __maybe_unused, or
> spread the #ifdef's further.
> 
> Build tested with the following combinations:
> CONFIG_PM=y && CONFIG_PM_SLEEP=y
> CONFIG_PM=y && CONFIG_PM_SLEEP=n
> CONFIG_PM=n
> 
> Fixes: 96378bd2c6cd ("ath10k: fix core PCI suspend when WoWLAN is supported but disabled")
> Fixes: 096ad2a15fd8 ("Merge branch 'ath-next'")
> Signed-off-by: Brian Norris <briannorris@chromium.org>
> Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>

Patch applied to ath-next branch of ath.git, thanks.

20665a9076d4 ath10k: fix build errors with !CONFIG_PM

-- 
https://patchwork.kernel.org/patch/10018169/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

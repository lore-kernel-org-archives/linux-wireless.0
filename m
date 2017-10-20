Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from alexa-out.qualcomm.com ([129.46.98.28]:23214 "EHLO
        alexa-out.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751061AbdJTG3Y (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 20 Oct 2017 02:29:24 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Brian Norris <briannorris@chromium.org>
CC: Ryan Hsu <ryanhsu@qti.qualcomm.com>,
        Grant Grundler <grundler@chromium.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
        Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH] ath10k: fix build errors with !CONFIG_PM
Date: Fri, 20 Oct 2017 06:29:21 +0000
Message-ID: <87efpyfi2n.fsf@kamboji.qca.qualcomm.com> (sfid-20171020_082940_526723_B6005457)
References: <20170919232416.108247-1-briannorris@chromium.org>
        <2809b2cf512d4c198d3cef3f5e468c3c@euamsexm01e.eu.qualcomm.com>
        <87vajbgqcz.fsf@kamboji.qca.qualcomm.com>       <20171019171224.GA46096@google.com>
        <20171019184517.GA76422@google.com>
In-Reply-To: <20171019184517.GA76422@google.com> (Brian Norris's message of
        "Thu, 19 Oct 2017 11:45:19 -0700")
Content-Type: text/plain; charset="iso-8859-1"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Brian Norris <briannorris@chromium.org> writes:

> Build errors have been reported with CONFIG_PM=3Dn:
>
> drivers/net/wireless/ath/ath10k/pci.c:3416:8: error: implicit
> declaration of function 'ath10k_pci_suspend'
> [-Werror=3Dimplicit-function-declaration]
>
> drivers/net/wireless/ath/ath10k/pci.c:3428:8: error: implicit
> declaration of function 'ath10k_pci_resume'
> [-Werror=3Dimplicit-function-declaration]
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
> CONFIG_PM=3Dy && CONFIG_PM_SLEEP=3Dy
> CONFIG_PM=3Dy && CONFIG_PM_SLEEP=3Dn
> CONFIG_PM=3Dn
>
> Fixes: 96378bd2c6cd ("ath10k: fix core PCI suspend when WoWLAN is
> supported but disabled")
> Fixes: 096ad2a15fd8 ("Merge branch 'ath-next'")
> Signed-off-by: Brian Norris <briannorris@chromium.org>
> ---
>  drivers/net/wireless/ath/ath10k/pci.c | 5 -----
>  1 file changed, 5 deletions(-)
>
> On Thu, Oct 19, 2017 at 10:12:25AM -0700, Brian Norris wrote:
>> The solution would seem to be either to kill the #ifdefs around
>> ath10k_pci_{suspend,resume}() and friends (and use __maybe_unused
>> instead, to further extend Arnd's patch), or else revert Arnd's stuff
>> and go with CONFIG_PM_SLEEP everywhere, which would resolve the original
>> warning (promoted to error) that Arnd was resolving.
>>=20
>> I can send out one of these if you'd like.
>
> Here you go :)

Thanks! As this an unusual merge problem between two branches I applied
this manually to ath.git master-pending branch for now. Let's see if
kbuild bot is happy now.

--=20
Kalle Valo=

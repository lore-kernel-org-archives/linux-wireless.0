Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from alexa-out.qualcomm.com ([129.46.98.28]:5602 "EHLO
        alexa-out.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750927AbdJTGYx (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 20 Oct 2017 02:24:53 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Brian Norris <briannorris@chromium.org>
CC: Ryan Hsu <ryanhsu@qti.qualcomm.com>,
        Grant Grundler <grundler@chromium.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
        Arnd Bergmann <arnd@arndb.de>
Subject: Re: ath10k: fix core PCI suspend when WoWLAN is supported but
 disabled
Date: Fri, 20 Oct 2017 06:24:31 +0000
Message-ID: <87infafiao.fsf@kamboji.qca.qualcomm.com> (sfid-20171020_082511_986179_3FF3A103)
References: <20170919232416.108247-1-briannorris@chromium.org>
        <2809b2cf512d4c198d3cef3f5e468c3c@euamsexm01e.eu.qualcomm.com>
        <87vajbgqcz.fsf@kamboji.qca.qualcomm.com>       <20171019171224.GA46096@google.com>
In-Reply-To: <20171019171224.GA46096@google.com> (Brian Norris's message of
        "Thu, 19 Oct 2017 10:12:25 -0700")
Content-Type: text/plain; charset="iso-8859-1"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Brian Norris <briannorris@chromium.org> writes:

> + Arnd
>
> On Thu, Oct 19, 2017 at 02:32:45PM +0000, Kalle Valo wrote:
>> Kalle Valo <kvalo@qca.qualcomm.com> writes:
>>=20
>> > Brian Norris <briannorris@chromium.org> wrote:
>> >
>> >> For devices where the FW supports WoWLAN but user-space has not
>> >> configured it, we don't do any PCI-specific suspend/resume operations=
,
>> >> because mac80211 doesn't call drv_suspend() when !wowlan. This has
>> >> particularly bad effects for some platforms, because we don't stop th=
e
>> >> power-save timer, and if this timer goes off after the PCI controller
>> >> has suspended the link, Bad Things will happen.
>> >>=20
>> >> Commit 32faa3f0ee50 ("ath10k: add the PCI PM core suspend/resume ops"=
)
>> >> got some of this right, in that it understood there was a problem on
>> >> non-WoWLAN firmware. But it forgot the $subject case.
>> >>=20
>> >> Fix this by moving all the PCI driver suspend/resume logic exclusivel=
y
>> >> into the driver PM hooks. This shouldn't affect WoWLAN support much
>> >> (this just gets executed later on).
>> >>=20
>> >> I would just as well kill the entirety of ath10k_hif_suspend(), as it=
's
>> >> not even implemented on the USB or SDIO drivers. I expect that we don=
't
>> >> need the callback, except to return "supported" (i.e., 0) or "not
>> >> supported" (i.e., -EOPNOTSUPP).
>> >>=20
>> >> Fixes: 32faa3f0ee50 ("ath10k: add the PCI PM core suspend/resume ops"=
)
>> >> Fixes: 77258d409ce4 ("ath10k: enable pci soc powersaving")
>> >> Signed-off-by: Brian Norris <briannorris@chromium.org>
>> >> Cc: Ryan Hsu <ryanhsu@qti.qualcomm.com>
>> >> Cc: Kalle Valo <kvalo@qca.qualcomm.com>
>> >> Cc: Michal Kazior <michal.kazior@tieto.com>
>> >> Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
>> >
>> > Patch applied to ath-next branch of ath.git, thanks.
>> >
>> > 96378bd2c6cd ath10k: fix core PCI suspend when WoWLAN is supported but=
 disabled
>>=20
>> Kbuild found a build problem, I suspect it's caused by this patch:
>
> Actually, it's the interaction of this patch and Arnd's patch:
>
> 6af1de2e4ec4 ath10k: mark PM functions as __maybe_unused
>
> I see that's now in these branches:
>
>   ath/ath-current
>   ath/ath-qca
>   ath/master
>   ath/master-pending
>   wireless-drivers-next/master
>   wireless-drivers-next/pending
>
> Whereas mine got applied to:
>
>   ath/ath-next
>
> So technically, the problem is in your merge here :)
>
> 096ad2a15fd8 Merge branch 'ath-next'

Ah, that's why kbuild bot didn't report about this problem while your
patch was in my pending branch. And I was also really puzzled why it
claimed that my merge was at fault :) Thanks for the good explanation.

Just to clarify: ath-current is for patches going to 4.14 and ath-next
to 4.15, that's why they were applied to a different branch.

>> drivers/net/wireless/ath/ath10k/pci.c:3416:8: error: implicit
>> declaration of function 'ath10k_pci_suspend'
>> [-Werror=3Dimplicit-function-declaration]
>>=20
>> drivers/net/wireless/ath/ath10k/pci.c:3428:8: error: implicit
>> declaration of function 'ath10k_pci_resume'
>> [-Werror=3Dimplicit-function-declaration]
>>=20
>> http://lists.infradead.org/pipermail/ath10k/2017-October/010269.html
>>=20
>> The .config.gz there doesn't have CONFIG_PM set, maybe that's the
>> problem?
>
> Yes, indirectly that's also the problem.
>
> The solution would seem to be either to kill the #ifdefs around
> ath10k_pci_{suspend,resume}() and friends (and use __maybe_unused
> instead, to further extend Arnd's patch), or else revert Arnd's stuff
> and go with CONFIG_PM_SLEEP everywhere, which would resolve the original
> warning (promoted to error) that Arnd was resolving.
>
> I can send out one of these if you'd like.

I see that you already sent the patch, thanks!

--=20
Kalle Valo=

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:53849 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752421AbcIHRZ4 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 8 Sep 2016 13:25:56 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Valerio Passini <valerio.passini@unicam.it>
Cc: linux-wireless@vger.kernel.org,
        Omer Peleg <omer@cs.technion.ac.il>,
        Adam Morrison <mad@cs.technion.ac.il>,
        David Woodhouse <David.Woodhouse@intel.com>,
        linux-kernel@vger.kernel.org, Joerg Roedel <joro@8bytes.org>,
        iommu@lists.linux-foundation.org
Subject: Re: Stability connection problems in ath9k kernel 4.7
References: <1798564.U2X6r5Zons@automatix> <87wpio155z.fsf@purkki.adurom.net>
        <2596121.7secQ7hYiJ@automatix>
Date: Thu, 08 Sep 2016 20:25:45 +0300
In-Reply-To: <2596121.7secQ7hYiJ@automatix> (Valerio Passini's message of
        "Thu, 08 Sep 2016 16:11:49 +0200")
Message-ID: <87d1kes3qe.fsf@kamboji.qca.qualcomm.com> (sfid-20160908_192620_071841_4DFE0FD5)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Valerio Passini <valerio.passini@unicam.it> writes:

> On mercoledì 7 settembre 2016 11:32:24 CEST Kalle Valo wrote:
>> Valerio Passini <valerio.passini@unicam.it> writes:
>> > I have found some connection problems since 4.7 release using ath9k that
>> > turn the wifi pretty useless, I think it might be something in the power
>> > management because the signal seems really low. Previously, up to kernel
>> > 4.6.7 everything worked very well.
>> > 
>> > This is a sample of dmesg in kernel 4.7.2:
>> >  239.898935] wlp4s0: authenticate with XX:XX:XX:XX:XX:XX
>> > 
>> > [  239.919995] wlp4s0: send auth to XX:XX:XX:XX:XX:XX  (try 1/3)
>> > [  239.931877] wlp4s0: authenticated
>> > [  239.932357] wlp4s0: associate with XX:XX:XX:XX:XX:XX  (try 1/3)
>> > [  239.942171] wlp4s0: RX AssocResp from XX:XX:XX:XX:XX:XX  (capab=0x431
>> > status=0 aid=2)
>> > [  239.942301] wlp4s0: associated
>> > [  244.802853] ath: phy0: DMA failed to stop in 10 ms AR_CR=0x00000024
>> > AR_DIAG_SW=0x02000020 DMADBG_7=0x0000
>> > 6100
>> > [  245.931832] wlp4s0: authenticate with XX:XX:XX:XX:XX:XX
>> > [  245.953028] wlp4s0: send auth to XX:XX:XX:XX:XX:XX  (try 1/3)
>> > [  245.958702] wlp4s0: authenticated
>> > [  245.960386] wlp4s0: associate withXX:XX:XX:XX:XX:XX  (try 1/3)
>> > [  245.980543] wlp4s0: RX AssocResp from XX:XX:XX:XX:XX:XX  (capab=0x431
>> > status=0 aid=2)
>> > 
>> > lspci on 4.6.7 kernel:
>> > 04:00.0 Network controller: Qualcomm Atheros AR9485 Wireless Network
>> > Adapter (rev 01)
>> > 
>> >         Subsystem: AzureWave AR9485 Wireless Network Adapter
>> >         Flags: bus master, fast devsel, latency 0, IRQ 18
>> >         Memory at f7900000 (64-bit, non-prefetchable) [size=512K]
>> >         Expansion ROM at f7980000 [disabled] [size=64K]
>> >         Capabilities: [40] Power Management version 2
>> >         Capabilities: [50] MSI: Enable- Count=1/4 Maskable+ 64bit+
>> >         Capabilities: [70] Express Endpoint, MSI 00
>> >         Capabilities: [100] Advanced Error Reporting
>> >         Capabilities: [140] Virtual Channel
>> >         Capabilities: [160] Device Serial Number 00-00-00-00-00-00-00-00
>> >         Kernel driver in use: ath9k
>> >         Kernel modules: ath9k
>> > 
>> > Probably you need some debugging output, but before recompiling the kernel
>> > I would like to know if you are interested in any kind of help from me
>> > and what steps I should take (I'm able to help in testing patches but I'm
>> > not familiar with git). Thank you
>> 
>> Usually it's really helpful if you can find the commit id which broke
>> it. 'git bisect' is a great tool to do that and this seems to be a nice
>> tutorial how to use it:
>> 
>> http://webchick.net/node/99
>> 
>> Instead of commit ids you can use release tags like v4.6 and v4.7 to
>> make it easier to start the bisect. Just make sure that v4.7 is really
>> broken and v4.6 works before you start the bisection.
>
> Hi Kalle,
>
> I tried to understand the whole procedure related to git and git bisect, and 
> this is the first time I try it, so I can have done some mistake. In the git 
> log you'll find the commit that could be guilty for the behaviour I reported 
> yesterday. Anyhow, the resulting commit doesn't make any sense to me.

So your bisect found this as the bad commit:

commit 9257b4a206fc0229dd5f84b78e4d1ebf3f91d270
Author: Omer Peleg <omer@cs.technion.ac.il>
Date:   Wed Apr 20 11:34:11 2016 +0300

    iommu/iova: introduce per-cpu caching to iova allocation

The ath9k log you provided has a DMA warning and iommu problems can
cause DMA problems but I cannot make any conclusions yet. To confirm
that this commit really is the problem you could try to revert it with
'git revert -n 9257b4a206fc0229dd5f84b78e4d1ebf3f91d270'. For some
reason I got conflicts but if you are good enough with C you could try
to fix those yourself. Another option is that you disable iommu and see
if that helps.

I'm adding more people and mailing lists related to this commit,
hopefully they have better ideas.

This is Valerio's bisect log:

git bisect start
# good: [2dcd0af568b0cf583645c8a317dd12e344b1c72a] Linux 4.6
git bisect good 2dcd0af568b0cf583645c8a317dd12e344b1c72a
# bad: [523d939ef98fd712632d93a5a2b588e477a7565e] Linux 4.7
git bisect bad 523d939ef98fd712632d93a5a2b588e477a7565e
# good: [0694f0c9e20c47063e4237e5f6649ae5ce5a369a] radix tree test suite: 
remove dependencies on height
git bisect good 0694f0c9e20c47063e4237e5f6649ae5ce5a369a
# good: [e4f7bdc2ec0d0dcc27f7d70db27a620dfdc1f697] Merge branch 'for-4.7-zac' 
of git://git.kernel.org/pub/scm/linux/kernel/git/tj/libata
git bisect good e4f7bdc2ec0d0dcc27f7d70db27a620dfdc1f697
# bad: [049ec1b5a76d34a6980cccdb7c0baeb4eed7a993] Merge tag 'drm-fixes-for-
v4.7-rc2' of git://people.freedesktop.org/~airlied/linux
git bisect bad 049ec1b5a76d34a6980cccdb7c0baeb4eed7a993
# good: [a10c38a4f385f5d7c173a263ff6bb2d36021b3bb] Merge branch 'for-linus' of 
git://git.kernel.org/pub/scm/linux/kernel/git/sage/ceph-client
git bisect good a10c38a4f385f5d7c173a263ff6bb2d36021b3bb
# bad: [9ba55cf7cfbfd12a7e914d0d55b7581e896b3f0d] Merge branch 'for-next' of 
git://git.kernel.org/pub/scm/linux/kernel/git/nab/target-pending
git bisect bad 9ba55cf7cfbfd12a7e914d0d55b7581e896b3f0d
# bad: [c61b49c79e1c1d4bc0c2fdc053ef56e65759b5fd] Merge tag 'drm-fixes-v4.7-
rc1' of git://people.freedesktop.org/~airlied/linux
git bisect bad c61b49c79e1c1d4bc0c2fdc053ef56e65759b5fd
# good: [dc03c0f9d12d85286d5e3623aa96d5c2a271b8e6] Merge branch 'misc' of 
git://git.kernel.org/pub/scm/linux/kernel/git/mmarek/kbuild
git bisect good dc03c0f9d12d85286d5e3623aa96d5c2a271b8e6
# good: [e28e909c36bb5d6319953822d84df00fce7cbd18] Merge tag 'for-linus' of 
git://git.kernel.org/pub/scm/virt/kvm/kvm
git bisect good e28e909c36bb5d6319953822d84df00fce7cbd18
# good: [79b3c7164c18e2fe9e69b0dcc0d45bab7ae3c968] Merge branch 'drm-next-4.7' 
of git://people.freedesktop.org/~agd5f/linux into drm-next
git bisect good 79b3c7164c18e2fe9e69b0dcc0d45bab7ae3c968
# bad: [1e8143db755f745a9842984de5e8b423f583aea2] Merge tag 'platform-drivers-
x86-v4.7-1' of git://git.infradead.org/users/dvhart/linux-platform-drivers-x86
git bisect bad 1e8143db755f745a9842984de5e8b423f583aea2
# good: [afcedebc6a094224973534f43b396bbbf33fe44e] thinkpad_acpi: save 
kbdlight state on suspend and restore it on resume
git bisect good afcedebc6a094224973534f43b396bbbf33fe44e
# good: [2aac630429d986a43ac59525a4cff47a624dc58e] iommu/vt-d: change intel-
iommu to use IOVA frame numbers
git bisect good 2aac630429d986a43ac59525a4cff47a624dc58e
# bad: [2566278551d3db875bc3bbfc41b42f2e80392108] Merge git://
git.infradead.org/intel-iommu
git bisect bad 2566278551d3db875bc3bbfc41b42f2e80392108
# bad: [22e2f9fa63b092923873fc8a52955151f4d83274] iommu/vt-d: Use per-cpu IOVA 
caching
git bisect bad 22e2f9fa63b092923873fc8a52955151f4d83274
# bad: [9257b4a206fc0229dd5f84b78e4d1ebf3f91d270] iommu/iova: introduce per-
cpu caching to iova allocation
git bisect bad 9257b4a206fc0229dd5f84b78e4d1ebf3f91d270
# first bad commit: [9257b4a206fc0229dd5f84b78e4d1ebf3f91d270] iommu/iova: 
introduce per-cpu caching to iova allocation

-- 
Kalle Valo

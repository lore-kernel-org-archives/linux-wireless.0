Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:32815 "EHLO
        mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S965843AbcIHOLx (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 8 Sep 2016 10:11:53 -0400
Received: by mail-wm0-f66.google.com with SMTP id b187so4058579wme.0
        for <linux-wireless@vger.kernel.org>; Thu, 08 Sep 2016 07:11:52 -0700 (PDT)
From: Valerio Passini <valerio.passini@unicam.it>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org
Subject: Re: Stability connection problems in ath9k kernel 4.7
Date: Thu, 08 Sep 2016 16:11:49 +0200
Message-ID: <2596121.7secQ7hYiJ@automatix> (sfid-20160908_161159_953610_651C6148)
In-Reply-To: <87wpio155z.fsf@purkki.adurom.net>
References: <1798564.U2X6r5Zons@automatix> <87wpio155z.fsf@purkki.adurom.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On mercoled=EC 7 settembre 2016 11:32:24 CEST Kalle Valo wrote:
> Valerio Passini <valerio.passini@unicam.it> writes:
> > I have found some connection problems since 4.7 release using ath9k that
> > turn the wifi pretty useless, I think it might be something in the power
> > management because the signal seems really low. Previously, up to kernel
> > 4.6.7 everything worked very well.
> >=20
> > This is a sample of dmesg in kernel 4.7.2:
> >  239.898935] wlp4s0: authenticate with XX:XX:XX:XX:XX:XX
> >=20
> > [  239.919995] wlp4s0: send auth to XX:XX:XX:XX:XX:XX  (try 1/3)
> > [  239.931877] wlp4s0: authenticated
> > [  239.932357] wlp4s0: associate with XX:XX:XX:XX:XX:XX  (try 1/3)
> > [  239.942171] wlp4s0: RX AssocResp from XX:XX:XX:XX:XX:XX  (capab=3D0x=
431
> > status=3D0 aid=3D2)
> > [  239.942301] wlp4s0: associated
> > [  244.802853] ath: phy0: DMA failed to stop in 10 ms AR_CR=3D0x00000024
> > AR_DIAG_SW=3D0x02000020 DMADBG_7=3D0x0000
> > 6100
> > [  245.931832] wlp4s0: authenticate with XX:XX:XX:XX:XX:XX
> > [  245.953028] wlp4s0: send auth to XX:XX:XX:XX:XX:XX  (try 1/3)
> > [  245.958702] wlp4s0: authenticated
> > [  245.960386] wlp4s0: associate withXX:XX:XX:XX:XX:XX  (try 1/3)
> > [  245.980543] wlp4s0: RX AssocResp from XX:XX:XX:XX:XX:XX  (capab=3D0x=
431
> > status=3D0 aid=3D2)
> >=20
> > lspci on 4.6.7 kernel:
> > 04:00.0 Network controller: Qualcomm Atheros AR9485 Wireless Network
> > Adapter (rev 01)
> >=20
> >         Subsystem: AzureWave AR9485 Wireless Network Adapter
> >         Flags: bus master, fast devsel, latency 0, IRQ 18
> >         Memory at f7900000 (64-bit, non-prefetchable) [size=3D512K]
> >         Expansion ROM at f7980000 [disabled] [size=3D64K]
> >         Capabilities: [40] Power Management version 2
> >         Capabilities: [50] MSI: Enable- Count=3D1/4 Maskable+ 64bit+
> >         Capabilities: [70] Express Endpoint, MSI 00
> >         Capabilities: [100] Advanced Error Reporting
> >         Capabilities: [140] Virtual Channel
> >         Capabilities: [160] Device Serial Number 00-00-00-00-00-00-00-00
> >         Kernel driver in use: ath9k
> >         Kernel modules: ath9k
> >=20
> > Probably you need some debugging output, but before recompiling the ker=
nel
> > I would like to know if you are interested in any kind of help from me
> > and what steps I should take (I'm able to help in testing patches but I=
'm
> > not familiar with git). Thank you
>=20
> Usually it's really helpful if you can find the commit id which broke
> it. 'git bisect' is a great tool to do that and this seems to be a nice
> tutorial how to use it:
>=20
> http://webchick.net/node/99
>=20
> Instead of commit ids you can use release tags like v4.6 and v4.7 to
> make it easier to start the bisect. Just make sure that v4.7 is really
> broken and v4.6 works before you start the bisection.

Hi Kalle,

I tried to understand the whole procedure related to git and git bisect, an=
d=20
this is the first time I try it, so I can have done some mistake. In the gi=
t=20
log you'll find the commit that could be guilty for the behaviour I reporte=
d=20
yesterday. Anyhow, the resulting commit doesn't make any sense to me. If yo=
u=20
have any request, please send an email in cc to me, because I want to=20
unsuscribe this mailing list since it's too high volume for me. Best regards

Valerio

git bisect log

git bisect start
# good: [2dcd0af568b0cf583645c8a317dd12e344b1c72a] Linux 4.6
git bisect good 2dcd0af568b0cf583645c8a317dd12e344b1c72a
# bad: [523d939ef98fd712632d93a5a2b588e477a7565e] Linux 4.7
git bisect bad 523d939ef98fd712632d93a5a2b588e477a7565e
# good: [0694f0c9e20c47063e4237e5f6649ae5ce5a369a] radix tree test suite:=20
remove dependencies on height
git bisect good 0694f0c9e20c47063e4237e5f6649ae5ce5a369a
# good: [e4f7bdc2ec0d0dcc27f7d70db27a620dfdc1f697] Merge branch 'for-4.7-za=
c'=20
of git://git.kernel.org/pub/scm/linux/kernel/git/tj/libata
git bisect good e4f7bdc2ec0d0dcc27f7d70db27a620dfdc1f697
# bad: [049ec1b5a76d34a6980cccdb7c0baeb4eed7a993] Merge tag 'drm-fixes-for-
v4.7-rc2' of git://people.freedesktop.org/~airlied/linux
git bisect bad 049ec1b5a76d34a6980cccdb7c0baeb4eed7a993
# good: [a10c38a4f385f5d7c173a263ff6bb2d36021b3bb] Merge branch 'for-linus'=
 of=20
git://git.kernel.org/pub/scm/linux/kernel/git/sage/ceph-client
git bisect good a10c38a4f385f5d7c173a263ff6bb2d36021b3bb
# bad: [9ba55cf7cfbfd12a7e914d0d55b7581e896b3f0d] Merge branch 'for-next' o=
f=20
git://git.kernel.org/pub/scm/linux/kernel/git/nab/target-pending
git bisect bad 9ba55cf7cfbfd12a7e914d0d55b7581e896b3f0d
# bad: [c61b49c79e1c1d4bc0c2fdc053ef56e65759b5fd] Merge tag 'drm-fixes-v4.7-
rc1' of git://people.freedesktop.org/~airlied/linux
git bisect bad c61b49c79e1c1d4bc0c2fdc053ef56e65759b5fd
# good: [dc03c0f9d12d85286d5e3623aa96d5c2a271b8e6] Merge branch 'misc' of=20
git://git.kernel.org/pub/scm/linux/kernel/git/mmarek/kbuild
git bisect good dc03c0f9d12d85286d5e3623aa96d5c2a271b8e6
# good: [e28e909c36bb5d6319953822d84df00fce7cbd18] Merge tag 'for-linus' of=
=20
git://git.kernel.org/pub/scm/virt/kvm/kvm
git bisect good e28e909c36bb5d6319953822d84df00fce7cbd18
# good: [79b3c7164c18e2fe9e69b0dcc0d45bab7ae3c968] Merge branch 'drm-next-4=
=2E7'=20
of git://people.freedesktop.org/~agd5f/linux into drm-next
git bisect good 79b3c7164c18e2fe9e69b0dcc0d45bab7ae3c968
# bad: [1e8143db755f745a9842984de5e8b423f583aea2] Merge tag 'platform-drive=
rs-
x86-v4.7-1' of git://git.infradead.org/users/dvhart/linux-platform-drivers-=
x86
git bisect bad 1e8143db755f745a9842984de5e8b423f583aea2
# good: [afcedebc6a094224973534f43b396bbbf33fe44e] thinkpad_acpi: save=20
kbdlight state on suspend and restore it on resume
git bisect good afcedebc6a094224973534f43b396bbbf33fe44e
# good: [2aac630429d986a43ac59525a4cff47a624dc58e] iommu/vt-d: change intel-
iommu to use IOVA frame numbers
git bisect good 2aac630429d986a43ac59525a4cff47a624dc58e
# bad: [2566278551d3db875bc3bbfc41b42f2e80392108] Merge git://
git.infradead.org/intel-iommu
git bisect bad 2566278551d3db875bc3bbfc41b42f2e80392108

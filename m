Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f52.google.com ([74.125.82.52]:37106 "EHLO
        mail-wm0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1758341AbcIHOUd (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 8 Sep 2016 10:20:33 -0400
Received: by mail-wm0-f52.google.com with SMTP id w12so92278483wmf.0
        for <linux-wireless@vger.kernel.org>; Thu, 08 Sep 2016 07:20:32 -0700 (PDT)
From: Valerio Passini <valerio.passini@unicam.it>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org
Subject: Re: Stability connection problems in ath9k kernel 4.7
Date: Thu, 08 Sep 2016 16:20:24 +0200
Message-ID: <6464242.cuWmcIkdS0@automatix> (sfid-20160908_162037_682743_37129FFD)
In-Reply-To: <2596121.7secQ7hYiJ@automatix>
References: <1798564.U2X6r5Zons@automatix> <87wpio155z.fsf@purkki.adurom.net> <2596121.7secQ7hYiJ@automatix>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On gioved=EC 8 settembre 2016 16:11:49 CEST Valerio Passini wrote:
I missed a line in copy-paste, sorry.
Valerio

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
# bad: [22e2f9fa63b092923873fc8a52955151f4d83274] iommu/vt-d: Use per-cpu I=
OVA=20
caching
git bisect bad 22e2f9fa63b092923873fc8a52955151f4d83274
# bad: [9257b4a206fc0229dd5f84b78e4d1ebf3f91d270] iommu/iova: introduce per-
cpu caching to iova allocation
git bisect bad 9257b4a206fc0229dd5f84b78e4d1ebf3f91d270
# first bad commit: [9257b4a206fc0229dd5f84b78e4d1ebf3f91d270] iommu/iova:=
=20
introduce per-cpu caching to iova allocation

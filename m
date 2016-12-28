Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:53258 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750705AbcL1Duu (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 27 Dec 2016 22:50:50 -0500
Date: Wed, 28 Dec 2016 11:50:44 +0800
From: Peter Xu <peterx@redhat.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-wireless@vger.kernel.org
Subject: Re: Intel Wireless 7260 failed to work
Message-ID: <20161228035044.GA3924@pxdev.xzpeter.org> (sfid-20161228_045110_342878_84703DB0)
References: <20161227091706.GA20895@pxdev.xzpeter.org>
 <a1fbf107-24df-d9e8-1c69-78025c70a79c@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <a1fbf107-24df-d9e8-1c69-78025c70a79c@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Dec 27, 2016 at 10:41:22AM -0600, Larry Finger wrote:
> On 12/27/2016 03:17 AM, Peter Xu wrote:
> >Hello,
> >
> >Looks like latest Linux master (4.10-rc1, 7ce7d89f) cannot work well
> >with my wireless card, which is:
> >
> >  Intel Corporation Wireless 7260 (rev bb)
> >
> >Boot message shows that no suitable firmware found:
> >
> >    # journalctl -kp3
> >    Dec 27 16:38:00 kernel: Error parsing PCC subspaces from PCCT
> >    Dec 27 16:38:00 kernel: mmc0: Unknown controller version (3). You may experience problems.
> >    Dec 27 16:38:02 kernel: DMAR: DRHD: handling fault status reg 2
> >    Dec 27 16:38:02 kernel: DMAR: [DMA Write] Request device [00:02.0] fault addr 7200000000 [fault reason 05] PTE Write a
> >    Dec 27 16:38:03 kernel: tpm tpm0: A TPM error (6) occurred attempting to read a pcr value
> >    Dec 27 16:38:04 kernel: iwlwifi 0000:03:00.0: no suitable firmware found!
> >
> >Linux stable/master (Linux 4.8-rc8, 08895a8b6b) works for me. And no
> >further tests have been done yet.
> >
> >Is this a known issue? Please let me know if anyone wants more info or
> >logs, since this error triggers easily (everytime I boot).
> >
> 
> The problem appears to be specific for your system. On my Toshiba Tecra
> A50A, kernel 4.10-rc1 the driver works the same as in earlier kernels. The
> dmesg log shows the following:
> 
> [    4.760600] Intel(R) Wireless WiFi driver for Linux
> [    4.760601] Copyright(c) 2003- 2015 Intel Corporation
> [    4.799519] iwlwifi 0000:04:00.0: loaded firmware version 17.352738.0
> op_mode iwlmvm
> [    4.880820] iwlwifi 0000:04:00.0: Detected Intel(R) Dual Band Wireless AC
> 7260, REV=0x144
> [    4.883340] iwlwifi 0000:04:00.0: L1 Enabled - LTR Enabled
> [    4.883584] iwlwifi 0000:04:00.0: L1 Enabled - LTR Enabled
> 
> I'm not sure if the driver would look for firmware version 16 if 17 would
> not be available, but I think it would.
> 
> Check for firmware file /lib/firmware/iwlwifi-7260-17.ucode. If that is not
> present for your distro, it is in the repo at
> git://git.kernel.org/pub/scm/linux/kernel/git/dwmw2/linux-firmware.git.

This is useful. :-)

Putting iwlwifi-7260-17.ucode into /lib/firmware fixes my issue.

Thanks for the link!

-- peterx

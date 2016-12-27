Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f68.google.com ([209.85.218.68]:35920 "EHLO
        mail-oi0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753998AbcL0QlZ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 27 Dec 2016 11:41:25 -0500
Subject: Re: Intel Wireless 7260 failed to work
To: Peter Xu <peterx@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-wireless@vger.kernel.org
References: <20161227091706.GA20895@pxdev.xzpeter.org>
From: Larry Finger <Larry.Finger@lwfinger.net>
Message-ID: <a1fbf107-24df-d9e8-1c69-78025c70a79c@lwfinger.net> (sfid-20161227_174153_591496_B6E84D4B)
Date: Tue, 27 Dec 2016 10:41:22 -0600
MIME-Version: 1.0
In-Reply-To: <20161227091706.GA20895@pxdev.xzpeter.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 12/27/2016 03:17 AM, Peter Xu wrote:
> Hello,
>
> Looks like latest Linux master (4.10-rc1, 7ce7d89f) cannot work well
> with my wireless card, which is:
>
>   Intel Corporation Wireless 7260 (rev bb)
>
> Boot message shows that no suitable firmware found:
>
>     # journalctl -kp3
>     Dec 27 16:38:00 kernel: Error parsing PCC subspaces from PCCT
>     Dec 27 16:38:00 kernel: mmc0: Unknown controller version (3). You may experience problems.
>     Dec 27 16:38:02 kernel: DMAR: DRHD: handling fault status reg 2
>     Dec 27 16:38:02 kernel: DMAR: [DMA Write] Request device [00:02.0] fault addr 7200000000 [fault reason 05] PTE Write a
>     Dec 27 16:38:03 kernel: tpm tpm0: A TPM error (6) occurred attempting to read a pcr value
>     Dec 27 16:38:04 kernel: iwlwifi 0000:03:00.0: no suitable firmware found!
>
> Linux stable/master (Linux 4.8-rc8, 08895a8b6b) works for me. And no
> further tests have been done yet.
>
> Is this a known issue? Please let me know if anyone wants more info or
> logs, since this error triggers easily (everytime I boot).
>

The problem appears to be specific for your system. On my Toshiba Tecra A50A, 
kernel 4.10-rc1 the driver works the same as in earlier kernels. The dmesg log 
shows the following:

[    4.760600] Intel(R) Wireless WiFi driver for Linux
[    4.760601] Copyright(c) 2003- 2015 Intel Corporation
[    4.799519] iwlwifi 0000:04:00.0: loaded firmware version 17.352738.0 op_mode 
iwlmvm
[    4.880820] iwlwifi 0000:04:00.0: Detected Intel(R) Dual Band Wireless AC 
7260, REV=0x144
[    4.883340] iwlwifi 0000:04:00.0: L1 Enabled - LTR Enabled
[    4.883584] iwlwifi 0000:04:00.0: L1 Enabled - LTR Enabled

I'm not sure if the driver would look for firmware version 16 if 17 would not be 
available, but I think it would.

Check for firmware file /lib/firmware/iwlwifi-7260-17.ucode. If that is not 
present for your distro, it is in the repo at 
git://git.kernel.org/pub/scm/linux/kernel/git/dwmw2/linux-firmware.git.

If that firmware is present, or if adding it does not help, my next suggestion 
is to bisect between 4.8 and the current version to see where the problem was 
introduced. I would not limit the bisection to the Intel wireless drivers as the 
problem could be in the underlying PCIe support for your hardware. By the way, 
that bisection will require about 14 steps.

Larry

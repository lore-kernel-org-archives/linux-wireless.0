Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from pmta2.delivery5.ore.mailhop.org ([54.186.218.12]:11959 "EHLO
        pmta2.delivery5.ore.mailhop.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S933402AbcKWUV2 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 23 Nov 2016 15:21:28 -0500
Date: Wed, 23 Nov 2016 20:21:25 +0000
From: Jason Cooper <jason@lakedaemon.net>
To: Russell King - ARM Linux <linux@armlinux.org.uk>
Cc: linux-wireless@vger.kernel.org,
        Linux ARM Kernel <linux-arm-kernel@lists.infradead.org>,
        ath9k-devel@qca.qualcomm.com, ath9k-devel@lists.ath9k.org,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Gregory CLEMENT <gregory.clement@free-electrons.com>,
        Kalle Valo <kvalo@codeaurora.org>, Andrew Lunn <andrew@lunn.ch>
Subject: Re: ath9k ARMv7 OOPS in v4.8.6, v4.2.8
Message-ID: <20161123202125.GH2799@io.lakedaemon.net> (sfid-20161123_212132_695578_229C8580)
References: <20161123191539.GF2799@io.lakedaemon.net>
 <20161123195120.GE14217@n2100.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20161123195120.GE14217@n2100.armlinux.org.uk>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Russell,

On Wed, Nov 23, 2016 at 07:51:20PM +0000, Russell King - ARM Linux wrote:
> On Wed, Nov 23, 2016 at 07:15:39PM +0000, Jason Cooper wrote:
> > ------- oops from v4.8.6 #2 ------------------------------------------
> > [42059.303625] Unable to handle kernel NULL pointer dereference at virtual address 00000020
> > [42059.311799] pgd = c0004000
> > [42059.314522] [00000020] *pgd=00000000
> > [42059.318162] Internal error: Oops: 17 [#1] SMP ARM
> > [42059.322889] Modules linked in: ath9k ath9k_common ath9k_hw ath
> > [42059.328809] CPU: 0 PID: 0 Comm: swapper/0 Not tainted 4.8.6 #37
> > [42059.334755] Hardware name: Marvell Armada 370/XP (Device Tree)
> > [42059.340613] task: c0b091c0 task.stack: c0b00000
> > [42059.345176] PC is at ath_cmn_process_fft+0xa0/0x578 [ath9k_common]
> > [42059.351388] LR is at ath_cmn_process_fft+0xc4/0x578 [ath9k_common]
> > [42059.357598] pc : [<bf07bec4>]    lr : [<bf07bee8>]    psr: 80000153
> > [42059.357598] sp : c0b01cd0  ip : 00000000  fp : 00000000
> > [42059.369127] r10: c0b034d4  r9 : 00000069  r8 : 0000006c
> > [42059.374374] r7 : 00000000  r6 : dcfbd340  r5 : c0b03da0  r4 : 00000000
> > [42059.380930] r3 : 00000001  r2 : 00000008  r1 : 00000004  r0 : 00000000
> 
> Well, the good news is that it's reproducable.
> 
> It looks like it could be this:
> 
> static int
> ath_cmn_is_fft_buf_full(struct ath_spec_scan_priv *spec_priv)
> {
>         for_each_online_cpu(i)
>                 ret += relay_buf_full(rc->buf[i]);

ahhh, my config has NR_CPUS=4, this SoC is uniprocessor.  I'm going to
give it a go with SMP=no.  This config is a lightly modified
mvebu_v7_defconfig.  However, NR_CPUS isn't set in mvebu_v7_defconfig.
Only in multi_v7_defconfig.

I suspect ath9k uses different logic for setting up the relay buffer(s)
than for the code you referenced.

If SMP=no fails to fail ( :-P ) then we'll know where to start digging.

thx,

Jason.

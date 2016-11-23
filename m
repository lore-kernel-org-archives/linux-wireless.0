Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from pandora.armlinux.org.uk ([78.32.30.218]:35236 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933453AbcKWTva (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 23 Nov 2016 14:51:30 -0500
Date: Wed, 23 Nov 2016 19:51:20 +0000
From: Russell King - ARM Linux <linux@armlinux.org.uk>
To: Jason Cooper <jason@lakedaemon.net>
Cc: linux-wireless@vger.kernel.org,
        Linux ARM Kernel <linux-arm-kernel@lists.infradead.org>,
        ath9k-devel@qca.qualcomm.com, ath9k-devel@lists.ath9k.org,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Gregory CLEMENT <gregory.clement@free-electrons.com>,
        Kalle Valo <kvalo@codeaurora.org>, Andrew Lunn <andrew@lunn.ch>
Subject: Re: ath9k ARMv7 OOPS in v4.8.6, v4.2.8
Message-ID: <20161123195120.GE14217@n2100.armlinux.org.uk> (sfid-20161123_205133_311050_01AD1235)
References: <20161123191539.GF2799@io.lakedaemon.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20161123191539.GF2799@io.lakedaemon.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Nov 23, 2016 at 07:15:39PM +0000, Jason Cooper wrote:
> ------- oops from v4.8.6 #2 ------------------------------------------
> [42059.303625] Unable to handle kernel NULL pointer dereference at virtual address 00000020
> [42059.311799] pgd = c0004000
> [42059.314522] [00000020] *pgd=00000000
> [42059.318162] Internal error: Oops: 17 [#1] SMP ARM
> [42059.322889] Modules linked in: ath9k ath9k_common ath9k_hw ath
> [42059.328809] CPU: 0 PID: 0 Comm: swapper/0 Not tainted 4.8.6 #37
> [42059.334755] Hardware name: Marvell Armada 370/XP (Device Tree)
> [42059.340613] task: c0b091c0 task.stack: c0b00000
> [42059.345176] PC is at ath_cmn_process_fft+0xa0/0x578 [ath9k_common]
> [42059.351388] LR is at ath_cmn_process_fft+0xc4/0x578 [ath9k_common]
> [42059.357598] pc : [<bf07bec4>]    lr : [<bf07bee8>]    psr: 80000153
> [42059.357598] sp : c0b01cd0  ip : 00000000  fp : 00000000
> [42059.369127] r10: c0b034d4  r9 : 00000069  r8 : 0000006c
> [42059.374374] r7 : 00000000  r6 : dcfbd340  r5 : c0b03da0  r4 : 00000000
> [42059.380930] r3 : 00000001  r2 : 00000008  r1 : 00000004  r0 : 00000000

Well, the good news is that it's reproducable.

It looks like it could be this:

static int
ath_cmn_is_fft_buf_full(struct ath_spec_scan_priv *spec_priv)
{
        for_each_online_cpu(i)
                ret += relay_buf_full(rc->buf[i]);

where i = 8 (r2) and rc->buf is r7.  That's just a guess though, as
there's precious little to go on with the Code: line - modern GCCs
don't give us much with the Code: line anymore to figure out what's
going on without the exact object files.

        e5933000        ldr     r3, [r3]
        e1d330b4        ldrh    r3, [r3, #4]
        e58d3030        str     r3, [sp, #48]   ; 0x30
        ea000002        b       1c <foo+0x1c>
        e7970102        ldr     r0, [r7, r2, lsl #2]

What makes me wonder though is that if i=8, that means you must have a
system with 9 online CPUs, which is probably unlikely - or maybe that's
the problem, for_each_online_cpu() is going wrong...

If it's not that line of code, I don't see what else it would be based
on the output of my compiler - there's only one case in my disassembly
that corresponds with the single code line that we have to go on, and
it's this:

     a44:       e5983020        ldr     r3, [r8, #32]
     a48:       e793010a        ldr     r0, [r3, sl, lsl #2] <===
     a4c:       ebfffffe        bl      0 <relay_buf_full>
     a50:       e0844000        add     r4, r4, r0
     a54:       e59f9434        ldr     r9, [pc, #1076]
     a58:       e28a2001        add     r2, sl, #1
     a5c:       e3a01004        mov     r1, #4
     a60:       e1a00009        mov     r0, r9
     a64:       ebfffffe        bl      0 <_find_next_bit_le>
     a68:       e5953000        ldr     r3, [r5]
     a6c:       e1500003        cmp     r0, r3
     a70:       e1a0a000        mov     sl, r0
     a74:       bafffff2        blt     a44 <ath_cmn_process_fft+0xa8>

I'm debating now about whether we need to dump more of the code in the
oops - both before and after the faulting instruction...

-- 
RMK's Patch system: http://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line: currently at 9.6Mbps down 400kbps up
according to speedtest.net.

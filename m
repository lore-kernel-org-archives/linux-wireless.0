Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:33345 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755204Ab1FZW3O (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 26 Jun 2011 18:29:14 -0400
Message-ID: <4E07B2B2.4060204@hauke-m.de> (sfid-20110627_003310_549633_F67A1444)
Date: Mon, 27 Jun 2011 00:29:06 +0200
From: Hauke Mehrtens <hauke@hauke-m.de>
MIME-Version: 1.0
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	b43-dev <b43-dev@lists.infradead.org>
Subject: Regression in ssb pcicore with SoC
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Rafał,

I tried linux-3.0-rc4 on my Asus WL-500GP and got a kernel panic because
of a data bus error. This was caused by this commit you made:

commit af335a6cbc3dfcba64ad31561c0da563d1c43a2d
Author: Rafał Miłecki <zajec5@gmail.com>
Date:   Wed Apr 27 18:21:34 2011 +0200

    ssb: pci: early fix for SPROM core index

    Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
    Signed-off-by: John W. Linville <linville@tuxdriver.com>

My device has an PCI controller, in host mode and this device does not
have a sprom in its address space, so ssb_pcicore_fix_sprom_core_index()
should be be called. I tried to find the same function in Broadcom
source, but did not had success.

In the Broadcom open source code the pci init is done in
./driver/nicpci.c and all calls to sporm are done through
pcie_war_pci_setup() which is our ssb_pcicore_pcie_setup_workarounds()
in ssb. I think ssb_pcicore_fix_sprom_core_index() should be called from
somewhere in ssb_pcicore_pcie_setup_workarounds().

Could you please explain what you want to fix in
ssb_pcicore_fix_sprom_core_index() ?.

I will have a closer look at it tomorrow evening.

Hauke

Switched to NOHz mode on CPU #0
Data bus error, epc == 8017ed58, ra == 80225838
Oops[#1]:
Cpu 0
$ 0   : 00000000 10008000 b8000000 00000001
$ 4   : 80293b5c 00000caa ffffffff 00000000
$ 8   : 0000000a 00000003 00000001 696d6d20
$12   : ffffffff 00000000 00000000 ffffffff
$16   : 802d0140 b8004800 802c0000 00000000
$20   : 00000000 802c0000 00000000 802d04d4
$24   : 00000018 80151a00
$28   : 81816000 81817df8 8029bda0 80225838
Hi    : 00000000
Lo    : 00000000
epc   : 8017ed58 ssb_ssb_read16+0x48/0x60
    Not tainted
ra    : 80225838 ssb_pcicore_init+0x54/0x3b4
Status: 10008003    KERNEL EXL IE
Cause : 0080001c
PrId  : 00029006 (Broadcom BMIPS3300)
Modules linked in:
Process swapper (pid: 1, threadinfo=81816000, task=81814888, tls=00000000)
Stack : 8029b214 802d0140 b8000000 00004800 81863244 802d03d4 802d0204
80225838
        00000000 80117294 00000000 81862388 00000000 802d0140 00000000
8017f1cc
        8029b214 8029c0f4 81862388 802d0140 802a0000 802c0000 00000000
802251c4
        8029c0f4 00000000 802a0000 8015b4bc 00000000 00000000 00000000
802a0000
        802c0000 00000000 00000000 802c0000 00000000 00000000 00000000
802b0eb8
        ...
Call Trace:
[<8017ed58>] ssb_ssb_read16+0x48/0x60
[<80225838>] ssb_pcicore_init+0x54/0x3b4
[<802251c4>] ssb_attach_queued_buses+0xa0/0x2f4
[<802b0eb8>] ssb_modinit+0x3c/0xb0
[<800019b0>] do_one_initcall+0xf0/0x1e0
[<802a09d0>] kernel_init+0x94/0x12c
[<80006d00>] kernel_thread_helper+0x10/0x18


Code: 8e020000  8fbf001c  00518821
 8fb00014  3042ffff  8fb10018  03e00008  27bd0020
Disabling lock debugging due to kernel taint
Kernel panic - not syncing: Attempted to kill init!

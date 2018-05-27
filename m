Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 4.mo178.mail-out.ovh.net ([46.105.49.171]:40818 "EHLO
        4.mo178.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S936400AbeE0N1L (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 27 May 2018 09:27:11 -0400
Received: from player735.ha.ovh.net (unknown [10.109.122.20])
        by mo178.mail-out.ovh.net (Postfix) with ESMTP id 7C91817B6A
        for <linux-wireless@vger.kernel.org>; Sun, 27 May 2018 14:08:39 +0200 (CEST)
From: Alexander Wetzel <alexander.wetzel@web.de>
To: Luca Coelho <luca@coelho.fi>, kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Golan Ben Ami <golan.ben.ami@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
References: <20180422082745.9743-1-luca@coelho.fi>
 <20180422082745.9743-2-luca@coelho.fi>
Subject: iwlwifi: regression due to: allow different csr flags for different
 device families
Message-ID: <8ac31eb3-17cd-c4ee-fdf6-49aea171a667@web.de> (sfid-20180527_152749_208750_575076F6)
Date: Sun, 27 May 2018 14:08:23 +0200
MIME-Version: 1.0
In-Reply-To: <20180422082745.9743-2-luca@coelho.fi>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> From: Golan Ben Ami <golan.ben.ami@intel.com>
> 
> Different device families may have different flag values
> for passing a message to the fw (i.e. SW_RESET).
> In order to keep the code readable, and avoid conditioning
> upon the family, store a value for each flag, which indicates
> the bit that needs to be enabled.
> 
> Signed-off-by: Golan Ben Ami <golan.ben.ami@intel.com>
> Signed-off-by: Luca Coelho <luciano.coelho@intel.com>

This patch generates a Null pointer exception for my Ultimate-N 6300
card when loading the driver, making the card unusable.
(Bisecting linked it to commit
a8cbb46f831d2c101feccdd0e0daf3627b8c1dca.)

Sine the commit could not be simply reverted I applied this commit to my
distribution kernel - basically 4.16.12 - and can confirm it is indeed
causing the issue.

I've a trace from loading the module with the current 4.17.0-rc6-wt+,
but that's not very interesting:

        modprobe-32134 [006]   705.747029: iwlwifi_info:
CONFIG_IWLWIFI_DEBUG enabled
        modprobe-32134 [006]   705.747037: iwlwifi_info:
CONFIG_IWLWIFI_DEBUGFS enabled
        modprobe-32134 [006]   705.747038: iwlwifi_info:
CONFIG_IWLWIFI_DEVICE_TRACING enabled
        modprobe-32134 [006]   705.747039: iwlwifi_dbg:          ***
LOAD DRIVER ***
        modprobe-32134 [006]   705.747039: iwlwifi_dbg:          BT
channel inhibition is On
        modprobe-32134 [006]   705.747041: iwlwifi_info:
Detected Intel(R) Centrino(R) Ultimate-N 6300 AGN, REV=0x74
        modprobe-32134 [006]   705.747042: iwlwifi_dbg:
iwl_trans_prepare_card_hw enter
        modprobe-32134 [006]   705.747093: iwlwifi_dbg:
hardware ready


Here how the error looks in dmesg when loading the module (matches to
the trace above):

[  705.772297] iwlwifi 0000:03:00.0: CONFIG_IWLWIFI_DEBUG enabled
[  705.772307] iwlwifi 0000:03:00.0: CONFIG_IWLWIFI_DEBUGFS enabled
[  705.772309] iwlwifi 0000:03:00.0: CONFIG_IWLWIFI_DEVICE_TRACING enabled
[  705.772312] iwlwifi 0000:03:00.0: Detected Intel(R) Centrino(R)
Ultimate-N 6300 AGN, REV=0x74
[  705.772369] BUG: unable to handle kernel NULL pointer dereference at
0000000000000000
[  705.772371] PGD 0 P4D 0
[  705.772374] Oops: 0000 [#1] SMP PTI
[  705.772376] Modules linked in: iwldvm(+) ctr ccm arc4 rt2800usb
rt2x00usb rt2800lib crc_ccitt rt2x00lib iptable_mangle ipt_MASQUERADE
nf_nat_masquerade_ipv4 iptable_nat nf_nat_ipv4 nf_nat nf_conntrack_ipv4
nf_defrag_ipv4 xt_conntrack nf_conntrack ipt_REJECT nf_reject_ipv4
xt_tcpudp tun bridge stp llc ip6table_filter ip6_tables iptable_filter
ip_tables x_tables btusb btrtl btbcm btintel bluetooth
snd_hda_codec_realtek snd_hda_codec_generic x86_pkg_temp_thermal
coretemp ext4 mbcache jbd2 mac80211 iwlwifi snd_hda_intel kvm_intel kvm
sdhci_pci snd_hda_codec cqhci irqbypass joydev e1000e xhci_pci
thinkpad_acpi input_leds snd_hda_core sdhci cfg80211 firewire_ohci
nouveau thermal nvram snd_hwdep ehci_pci xhci_hcd mmc_core snd_pcm
ehci_hcd rfkill firewire_core ptp snd_timer led_class battery ac rtc_cmos
[  705.772415]  usbcore snd pps_core ttm i2c_i801 usb_common
[  705.772421] CPU: 6 PID: 32134 Comm: modprobe Not tainted
4.17.0-rc6-wt #13
[  705.772423] Hardware name: LENOVO 2438CTO/2438CTO, BIOS G5ETA7WW
(2.67 ) 05/16/2017
[  705.772429] RIP: 0010:iwl_trans_pcie_sw_reset+0x12/0x40 [iwlwifi]
[  705.772430] RSP: 0018:ffffc90003187bb8 EFLAGS: 00010246
[  705.772431] RAX: 0000000000000000 RBX: ffff880617820018 RCX:
0000000000000000
[  705.772432] RDX: 0000000000000001 RSI: 0000000000000246 RDI:
ffff880617820018
[  705.772433] RBP: 0000000000000000 R08: 0000000000000008 R09:
ffff880625bcc000
[  705.772434] R10: 00000000000004c1 R11: ffff880625ba4c00 R12:
ffff880617827d30
[  705.772435] R13: 0000000000000001 R14: ffff880617820220 R15:
ffffc90003187c00
[  705.772437] FS:  00007f55a3e08740(0000) GS:ffff88063e380000(0000)
knlGS:0000000000000000
[  705.772438] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  705.772439] CR2: 0000000000000000 CR3: 000000054522a002 CR4:
00000000001606e0
[  705.772440] Call Trace:
[  705.772446]  iwl_trans_pcie_start_hw+0x3f/0x1a0 [iwlwifi]
[  705.772453]  iwl_op_mode_dvm_start+0x259/0xb70 [iwldvm]
[  705.772458]  _iwl_op_mode_start.isra.8+0x47/0xa0 [iwlwifi]
[  705.772461]  ? _cond_resched+0x15/0x40
[  705.772465]  iwl_opmode_register+0x6f/0xe0 [iwlwifi]
[  705.772467]  ? 0xffffffffa08d6000
[  705.772472]  iwl_init+0x34/0x1000 [iwldvm]
[  705.772476]  do_one_initcall+0x4f/0x1d0
[  705.772478]  ? _cond_resched+0x15/0x40
[  705.772480]  do_init_module+0x5b/0x1fb
[  705.772483]  load_module+0x23a7/0x28c0
[  705.772486]  ? __se_sys_finit_module+0x87/0xa0
[  705.772488]  __se_sys_finit_module+0x87/0xa0
[  705.772490]  do_syscall_64+0x4f/0x100
[  705.772494]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
[  705.772496] RIP: 0033:0x7f55a3746749
[  705.772497] RSP: 002b:00007ffdc02fd8e8 EFLAGS: 00000206 ORIG_RAX:
0000000000000139
[  705.772499] RAX: ffffffffffffffda RBX: 000055c87462abe0 RCX:
00007f55a3746749
[  705.772500] RDX: 0000000000000000 RSI: 000055c87390d65e RDI:
0000000000000003
[  705.772501] RBP: 000055c87390d65e R08: 0000000000000000 R09:
0000000000000000
[  705.772502] R10: 0000000000000003 R11: 0000000000000206 R12:
0000000000000000
[  705.772503] R13: 000055c87462ae10 R14: 0000000000040000 R15:
0000000000000000
[  705.772505] Code: c7 c1 80 4a d7 a0 e8 3e 39 ff ff 89 e8 5b 5d c3 66
0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 8b 47 10 ba 01 00 00 00 48 8b
40 50 <0f> b6 08 0f b6 70 07 48 8b 07 48 d3 e2 89 d1 48 8b 80 f8 00 00
[  705.772538] RIP: iwl_trans_pcie_sw_reset+0x12/0x40 [iwlwifi] RSP:
ffffc90003187bb8
[  705.772540] CR2: 0000000000000000
[  705.772542] ---[ end trace 4337b74fce7e90bc ]---

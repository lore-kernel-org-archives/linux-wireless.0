Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from web52408.mail.re2.yahoo.com ([206.190.48.171]:32976 "HELO
	web52408.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756155AbZC3Che convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 29 Mar 2009 22:37:34 -0400
Message-ID: <231862.66787.qm@web52408.mail.re2.yahoo.com> (sfid-20090330_043744_085464_DC2D6789)
Date: Sun, 29 Mar 2009 19:37:32 -0700 (PDT)
From: Joo Aun Saw <jasaw81@yahoo.com.au>
Subject: ath5k kernel oops
To: linux-wireless@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Hello,

I'm getting kernel oops when modprobe ath5k on kernel 2.6.29 on ARM big-endian platform. PCI card is Atheros AR5413 168c:001b (rev 01).

Sometimes I don't get kernel oops, I get this instead:
ath5k phy0: failed to warm reset the MAC Chip

I've added a few debug messages in the driver, in file reset.c, function "static int ath5k_hw_nic_reset(struct ath5k_hw *ah, u32 val)", before and after this function call "ath5k_hw_register_timeout(ah, AR5K_RESET_CTL, mask, val, false);"
    data = ath5k_hw_reg_read(ah, AR5K_RESET_CTL);
    ATH5K_ERR(ah->ah_sc, "Check reg: 0x%x + 0x%x, mask: 0x%x, val: 0x%x, data: 0x%x\n", (int)(ah->ah_iobase), AR5K_RESET_CTL, mask, val, data);

>From the debug messages, I don't understand why I'm getting kernel oops. Can anyone help me? Thanks.


This is my kernel trace with a few of my added debug messages:
[42949463.750000] cfg80211: Using static regulatory domain info
[42949463.750000] cfg80211: Regulatory domain: US
[42949463.760000]       (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
[42949463.760000]       (2402000 KHz - 2472000 KHz @ 40000 KHz), (600 mBi, 2700 mBm)
[42949463.770000]       (5170000 KHz - 5190000 KHz @ 40000 KHz), (600 mBi, 2300 mBm)
[42949463.780000]       (5190000 KHz - 5210000 KHz @ 40000 KHz), (600 mBi, 2300 mBm)
[42949463.780000]       (5210000 KHz - 5230000 KHz @ 40000 KHz), (600 mBi, 2300 mBm)
[42949463.790000]       (5230000 KHz - 5330000 KHz @ 40000 KHz), (600 mBi, 2300 mBm)
[42949463.800000]       (5735000 KHz - 5835000 KHz @ 40000 KHz), (600 mBi, 3000 mBm)
[42949463.810000] cfg80211: Calling CRDA for country: US
[42949474.210000] PCI: enabling device 0000:00:02.0 (0340 -> 0342)
[42949474.210000] ath5k 0000:00:02.0: registered as 'phy0'
[42949474.220000] ath5k phy0: Write reg: 0xc8e40000 + 0x4000, val: 0x13
[42949474.220000] ath5k phy0: Check reg: 0xc8e40000 + 0x4000, mask: 0x3, val: 0x3, data: 0xe4c8
[42949474.230000] ath5k phy0: Check reg: 0xc8e40000 + 0x4000, mask: 0x3, val: 0x3, data: 0xe4c8
[42949474.240000] ath5k phy0: Reset MAC Chip success
[42949474.250000] ath5k phy0: Resume MAC Chip success
[42949474.250000] ath5k phy0: Write reg: 0xc8e40000 + 0x4000, val: 0x0
[42949474.260000] ath5k phy0: Check reg: 0xc8e40000 + 0x4000, mask: 0x3, val: 0x0, data: 0xe4c8
[42949474.280000] Bad mode in data abort handler detected
[42949474.280000] Internal error: Oops - bad mode: 0 [#1]
[42949474.280000] Modules linked in: ath5k(+) mac80211 cfg80211 ppp_async ppp_generic slhc crc_ccitt sierra usbserial tun ehci_hcd usbcore drv_vinetic drv_tapi hssdriver fpgadriver_cpe i2c_algo_bit i2c_core ipt_MASQUERADE xt_state xt_mark xt_tcpudp xt_MARK ipt_REJECT xt_condition iptable_mangle iptable_filter iptable_nat nf_nat nf_conntrack_ipv4 nf_conntrack nf_defrag_ipv4 ip_tables x_tables ixp400_eth ixp400(P) leds_gpio led_class europa_gpio europa_fuse
[42949474.280000] CPU: 0    Tainted: P            (2.6.29 #4)
[42949474.280000] PC is at 0xffff020c
[42949474.280000] LR is at ath5k_hw_register_timeout+0x70/0xcc [ath5k]
[42949474.280000] pc : [<ffff020c>]    lr : [<bf2d5f24>]    psr: a0000092
[42949474.280000] sp : c72fbc0c  ip : c8e40000  fp : c72fbc80
[42949474.280000] r10: 00000000  r9 : c02d34f0  r8 : c7290000
[42949474.280000] r7 : 00000000  r6 : 00004000  r5 : 0000493a  r4 : 00000003
[42949474.280000] r3 : c8e34000  r2 : c72fbc54  r1 : 00000002  r0 : 00004000
[42949474.280000] Flags: NzCv  IRQs off  FIQs on  Mode IRQ_32  ISA ARM  Segment user
[42949474.280000] Control: 000039ff  Table: 07224000  DAC: 00000015
[42949474.280000] Process insmod (pid: 1650, stack limit = 0xc72fa260)
[42949474.280000] Stack: (0xc72fbc0c to 0xc72fc000)
[42949474.280000] bc00:                            00004000 00000002 c72fbc54 c8e34000 00000003
[42949474.280000] bc20: 0000493a 00004000 00000000 c7290000 c02d34f0 00000000 c72fbc80 c8e40000
[42949474.280000] bc40: c72fbc0c bf2d5f24 ffff020c a0000092 ffffffff c72fbc60 00000000 c7290000
[42949474.280000] bc60: 0000e4c8 00000003 000000ab c7811800 00000003 c72fbcb4 c72fbc84 bf2d645c
[42949474.280000] bc80: bf2d5ec0 00000000 00000000 0000e4c8 c0038df8 00000000 c7290000 00000000
[42949474.280000] bca0: 00000000 000000ab c72fbce0 c72fbcb8 bf2d6778 bf2d62ec 00000000 00000001
[42949474.280000] bcc0: 00000002 c7290000 00000002 c7290000 0000000f c72fbd48 c72fbce4 bf2d93c0
[42949474.280000] bce0: bf2d65a8 40000013 c72fbd18 c7314d40 c7811800 c005ed6c 00000080 0000001c
[42949474.280000] bd00: bf2e6588 bf2dd0f4 c7314d40 c72fbd48 c72f0000 00000000 c005d194 00000000
[42949474.280000] bd20: bf2ea4bc c7811800 000030c8 00000000 c02de82c 00000000 c02c9778 c72fbdcc
[42949474.280000] bd40: c72fbd4c bf2dd654 bf2d92dc c7314d40 c72fbd74 c72fbd60 c00c474c c7811858
[42949474.280000] bd60: c8e40000 c7314d40 c7314160 c72fbd78 c00c47e4 c00c46a8 c72e621c c72e6274
[42949474.280000] bd80: c7847b0c c72fbda8 00000000 c72e6274 c7847b0c c781189c c72fbdb8 c72fbda8
[42949474.280000] bda0: c012b308 bf2ea1c4 c7811800 00000000 00000000 c02de82c 00000000 c02c9778
[42949474.280000] bdc0: c72fbddc c72fbdd0 c0142430 bf2dd434 c72fbe08 c72fbde0 c01425f4 c014241c
[42949474.280000] bde0: bf2ea1c4 c7811800 bf2ea4bc c7811858 bf2ea1f4 bf2ea1f4 c015db84 c72fbe2c
[42949474.280000] be00: c72fbe0c c015da7c c0142588 c7811858 bf2ea1f4 c78118e0 c015db84 c72ba5c0
[42949474.280000] be20: c72fbe48 c72fbe30 c015dc10 c015d9e0 00000000 c72fbe4c bf2ea1f4 c72fbe70
[42949474.280000] be40: c72fbe4c c015cf58 c015db90 c7832598 c7811888 00000000 bf2ea1f4 c72fa000
[42949474.280000] be60: 00000000 c72fbe80 c72fbe74 c015d8e4 c015cf0c c72fbeac c72fbe84 c015d57c
[42949474.280000] be80: c015d8d0 bf2e62f0 bf2ea1c4 bf2ea1f4 c72fa000 00000000 bf2ed000 c02d2eac
[42949474.280000] bea0: c72fbed0 c72fbeb0 c015dde8 c015d4dc bf2ea1c4 bf2ea1f4 c72fa000 00000000
[42949474.280000] bec0: bf2ed000 c72fbeec c72fbed4 c0142868 c015dda0 0002664b bf2ea52c c72fa000
[42949474.280000] bee0: c72fbf00 c72fbef0 bf2ed01c c0142834 0002664b c72fbf80 c72fbf04 c0020294
[42949474.280000] bf00: bf2ed00c c8e2503c 0000001b 0000000f 00000000 0000022b 0000022b bf2e6904
[42949474.280000] bf20: bf2e8ba4 c013c78c 0000001d c8e20944 00000000 00000000 00000000 00000000
[42949474.280000] bf40: 00000000 00000000 0002664b bf2ea52c 00079018 00000000 0002664b bf2ea52c
[42949474.280000] bf60: 00079018 00000000 c0020f64 c72fa000 4005ce70 c72fbfa4 c72fbf84 c005ba00
[42949474.280000] bf80: c002026c c008209c 0002664b 00079018 00000100 00000080 00000000 c72fbfa8
[42949474.280000] bfa0: c0020dc0 c005b97c 0002664b 00079018 00079018 0002664b 00079008 00079018
[42949474.280000] bfc0: 0002664b 00079018 00000100 00000002 0000002e 00000002 4005ce70 0000c56c
[42949474.280000] bfe0: 40019d84 be854d5c 00010838 40019d90 20000010 00079018 04102021 04102421
[42949474.280000] Backtrace:
[42949474.280000] [<bf2d5eb4>] (ath5k_hw_register_timeout+0x0/0xcc [ath5k]) from [<bf2d645c>] (ath5k_hw_nic_reset+0x17c/0x2bc [ath5k])
[42949474.280000] [<bf2d62e0>] (ath5k_hw_nic_reset+0x0/0x2bc [ath5k]) from [<bf2d6778>] (ath5k_hw_nic_wakeup+0x1dc/0x570 [ath5k])
[42949474.280000]  r8:000000ab r7:00000000 r6:00000000 r5:c7290000 r4:00000000
[42949474.280000] [<bf2d659c>] (ath5k_hw_nic_wakeup+0x0/0x570 [ath5k]) from [<bf2d93c0>] (ath5k_hw_attach+0xf0/0xda4 [ath5k])
[42949474.280000] [<bf2d92d0>] (ath5k_hw_attach+0x0/0xda4 [ath5k]) from [<bf2dd654>] (ath5k_pci_probe+0x22c/0xf44 [ath5k])
[42949474.280000] [<bf2dd428>] (ath5k_pci_probe+0x0/0xf44 [ath5k]) from [<c0142430>] (local_pci_probe+0x20/0x24)
[42949474.280000] [<c0142410>] (local_pci_probe+0x0/0x24) from [<c01425f4>] (pci_device_probe+0x78/0xa0)
[42949474.280000] [<c014257c>] (pci_device_probe+0x0/0xa0) from [<c015da7c>] (driver_probe_device+0xa8/0x1b0)
[42949474.280000]  r7:c015db84 r6:bf2ea1f4 r5:bf2ea1f4 r4:c7811858
[42949474.280000] [<c015d9d4>] (driver_probe_device+0x0/0x1b0) from [<c015dc10>] (__driver_attach+0x8c/0x90)
[42949474.280000]  r8:c72ba5c0 r7:c015db84 r6:c78118e0 r5:bf2ea1f4 r4:c7811858
[42949474.280000] [<c015db84>] (__driver_attach+0x0/0x90) from [<c015cf58>] (bus_for_each_dev+0x58/0x84)
[42949474.280000]  r6:bf2ea1f4 r5:c72fbe4c r4:00000000
[42949474.280000] [<c015cf00>] (bus_for_each_dev+0x0/0x84) from [<c015d8e4>] (driver_attach+0x20/0x28)
[42949474.280000]  r7:00000000 r6:c72fa000 r5:bf2ea1f4 r4:00000000
[42949474.280000] [<c015d8c4>] (driver_attach+0x0/0x28) from [<c015d57c>] (bus_add_driver+0xac/0x22c)
[42949474.280000] [<c015d4d0>] (bus_add_driver+0x0/0x22c) from [<c015dde8>] (driver_register+0x54/0x130)
[42949474.280000] [<c015dd94>] (driver_register+0x0/0x130) from [<c0142868>] (__pci_register_driver+0x40/0x80)
[42949474.280000]  r8:bf2ed000 r7:00000000 r6:c72fa000 r5:bf2ea1f4 r4:bf2ea1c4
[42949474.280000] [<c0142828>] (__pci_register_driver+0x0/0x80) from [<bf2ed01c>] (init_ath5k_pci+0x1c/0x44 [ath5k])
[42949474.280000]  r6:c72fa000 r5:bf2ea52c r4:0002664b
[42949474.280000] [<bf2ed000>] (init_ath5k_pci+0x0/0x44 [ath5k]) from [<c0020294>] (do_one_initcall+0x34/0x194)
[42949474.280000]  r4:0002664b
[42949474.280000] [<c0020260>] (do_one_initcall+0x0/0x194) from [<c005ba00>] (sys_init_module+0x90/0x19c)
[42949474.280000] [<c005b970>] (sys_init_module+0x0/0x19c) from [<c0020dc0>] (ret_fast_syscall+0x0/0x2c)
[42949474.280000]  r7:00000080 r6:00000100 r5:00079018 r4:0002664b
[42949474.280000] Code: 00000000 e24ee004 e88d4001 e14fe000 (e58de008)
[42949474.290000] ---[ end trace ed299f51ddc04ee0 ]---
#


      Enjoy a better web experience. Upgrade to the new Internet Explorer 8 optimised for Yahoo!7. Get it now.

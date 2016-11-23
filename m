Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from pmta2.delivery5.ore.mailhop.org ([54.186.218.12]:43484 "EHLO
        pmta2.delivery5.ore.mailhop.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750776AbcKWTbp (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 23 Nov 2016 14:31:45 -0500
Date: Wed, 23 Nov 2016 19:15:39 +0000
From: Jason Cooper <jason@lakedaemon.net>
To: linux-wireless@vger.kernel.org,
        Linux ARM Kernel <linux-arm-kernel@lists.infradead.org>,
        ath9k-devel@qca.qualcomm.com, ath9k-devel@lists.ath9k.org
Cc: Kalle Valo <kvalo@codeaurora.org>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Gregory CLEMENT <gregory.clement@free-electrons.com>,
        Andrew Lunn <andrew@lunn.ch>
Subject: ath9k ARMv7 OOPS in v4.8.6, v4.2.8
Message-ID: <20161123191539.GF2799@io.lakedaemon.net> (sfid-20161123_203150_206307_DFAEEF87)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

All,

I have a Ubiquiti SR-71 mini-pcie ath9k card in a Globalscale Mirabox
board (Marvell Armada 370 SoC).  Every day or so I get a consistent
crash that brings down the whole board.  I've attached three oops I
captured on the serial port.

I looked at the commits from v4.8.6 to v4.9-rc6, and nothing jumped out
at me as "this would fix it".  And since it takes a day or so to trigger
the oops, bisecting would be a bit brutal.  Does anyone have any insight
into this?

thx,

Jason.

------- oops from v4.2.8 ------------------------------------------
[ 3572.897994] Unable to handle kernel NULL pointer dereference at virtual address 00000020
[ 3572.906134] pgd = c0004000
[ 3572.908891] [00000020] *pgd=00000000
[ 3572.912504] Internal error: Oops: 5 [#1] SMP ARM
[ 3572.917142] Modules linked in: tun ip6table_filter ip6_tables iptable_filter ip_tables x_tables bridge ipv6 ath9k ath9k_common ath9k_hw led_class ath
[ 3572.930749] CPU: 0 PID: 0 Comm: swapper/0 Tainted: G        W       4.2.8 #57
[ 3572.937915] Hardware name: Marvell Armada 370/XP (Device Tree)
[ 3572.943774] task: c06fdd30 ti: c06f8000 task.ti: c06f8000
[ 3572.949208] PC is at ath_cmn_process_fft+0xac/0x4a0 [ath9k_common]
[ 3572.955421] LR is at ath_cmn_process_fft+0xc8/0x4a0 [ath9k_common]
[ 3572.961631] pc : [<bf081f44>]    lr : [<bf081f60>]    psr: 80000153
[ 3572.961631] sp : c06f9ca0  ip : 00000000  fp : 00000000
[ 3572.973160] r10: dc9a8010  r9 : 00000000  r8 : c06fa4d0
[ 3572.978409] r7 : 0000006c  r6 : dd3abfc0  r5 : c06fad88  r4 : 00000000
[ 3572.984965] r3 : 00000001  r2 : 00000008  r1 : 00000004  r0 : 00000000
[ 3572.991522] Flags: Nzcv  IRQs on  FIQs off  Mode SVC_32  ISA ARM  Segment kernel
[ 3572.998951] Control: 10c5387d  Table: 1c894019  DAC: 00000015
[ 3573.004723] Process swapper/0 (pid: 0, stack limit = 0xc06f8220)
[ 3573.010756] Stack: (0xc06f9ca0 to 0xc06fa000)
[ 3573.015137] 9ca0: c0734e31 dfbe3f40 c06f6f40 c06f6f40 c06fae34 c0734184 00989680 00000003
[ 3573.023356] 9cc0: dff6cde0 00000008 c06f9df4 00000069 dca0ab8c c0098b44 00000985 00000fc0
[ 3573.031573] 9ce0: c0733700 dffa0560 00000002 c001b6ac 000000c0 00000000 00000000 00000000
[ 3573.039790] 9d00: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000
[ 3573.048006] 9d20: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000
[ 3573.056222] 9d40: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000
[ 3573.064438] 9d60: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 dc9a8010
[ 3573.072654] 9d80: 00000000 dc983d18 dc983d00 dc983d00 00000002 dd045c90 dca08d40 bf090e64
[ 3573.080872] 9da0: d364463c 00000000 edf3c980 0000033f 0000033f 000001fa dc9a8010 00000000
[ 3573.089090] 9dc0: d3644890 00000000 dc9a8038 dca083e0 dd3abfc0 00000000 dd3abfc0 dca097ac
[ 3573.097306] 9de0: dc9a8038 00000002 00000001 dca083e0 00000100 d364463c 2602006c 018eff80
[ 3573.105522] 9e00: 80808000 00808080 20000001 00000000 00000000 00000000 00000000 00000000
[ 3573.113739] 9e20: 00000000 00000000 c06f9e68 dca08d40 00000001 dc9a8010 dca09708 c06f9e68
[ 3573.121955] 9e40: c06f4294 c06f8000 00000006 bf08e698 bf08e5dc dca096d0 dca096d4 00000000
[ 3573.130172] 9e60: c0735bc0 c0027e4c 00000000 c06fa098 00000100 c06f8000 c06f9e88 40000006
[ 3573.138389] 9e80: c06fa080 c0028030 ed5b3300 0000033f c06fa080 c06f4308 0000000a c0735bc0
[ 3573.146606] 9ea0: c06fa100 0004fe8e c051e380 00200000 c06f8000 c06f5444 00000000 00000000
[ 3573.154823] 9ec0: 00000001 df405000 c06fa484 c0759f80 c06f8000 c00283d8 c06f5444 c005b838
[ 3573.163041] 9ee0: c0341814 00000001 c0759f80 c06f9f20 000003ff c0009410 c034180c c0341814
[ 3573.171257] 9f00: 80000153 ffffffff c06f9f54 ed5b20c4 0000033f ed5b20c4 c06f8000 c0013340
[ 3573.179474] 9f20: 00000000 fffffffa 1f4ed000 dfbe3f40 ecf52c5b 0000033f dfbe34d0 00000001
[ 3573.187691] 9f40: ed5b20c4 0000033f ed5b20c4 c06f8000 0000001a c06f9f68 c034180c c0341814
[ 3573.195908] 9f60: 80000153 ffffffff 00000000 00000000 ed5b20c4 0000033f dfbe34d0 c051e374
[ 3573.204125] 9f80: dfbe34d0 c072a608 c06f64c8 c06fa51c c06f4364 c06fa524 c06f8000 c00535ec
[ 3573.212343] 9fa0: c06f9fa0 c0734dd1 dfffce00 ffffffff dfffce00 c06b5c6c ffffffff ffffffff
[ 3573.220559] 9fc0: 00000000 c06b5670 00000000 c06ea990 00000000 c0735294 c06fa4c0 c06ea98c
[ 3573.228777] 9fe0: c06fee2c 00004059 561f5811 00000000 00000000 0000807c 00000000 00000000
[ 3573.237025] [<bf081f44>] (ath_cmn_process_fft [ath9k_common]) from [<bf090e64>] (ath_rx_tasklet+0xa14/0xafc [ath9k])
[ 3573.247613] [<bf090e64>] (ath_rx_tasklet [ath9k]) from [<bf08e698>] (ath9k_tasklet+0xbc/0x20c [ath9k])
[ 3573.256981] [<bf08e698>] (ath9k_tasklet [ath9k]) from [<c0027e4c>] (tasklet_action+0x7c/0x110)
[ 3573.265641] [<c0027e4c>] (tasklet_action) from [<c0028030>] (__do_softirq+0xf8/0x23c)
[ 3573.273513] [<c0028030>] (__do_softirq) from [<c00283d8>] (irq_exit+0x78/0xb0)
[ 3573.280778] [<c00283d8>] (irq_exit) from [<c005b838>] (__handle_domain_irq+0x60/0xb0)
[ 3573.288651] [<c005b838>] (__handle_domain_irq) from [<c0009410>] (armada_370_xp_handle_irq+0x50/0xbc)
[ 3573.297917] [<c0009410>] (armada_370_xp_handle_irq) from [<c0013340>] (__irq_svc+0x40/0x54)
[ 3573.306306] Exception stack(0xc06f9f20 to 0xc06f9f68)
[ 3573.311385] 9f20: 00000000 fffffffa 1f4ed000 dfbe3f40 ecf52c5b 0000033f dfbe34d0 00000001
[ 3573.319602] 9f40: ed5b20c4 0000033f ed5b20c4 c06f8000 0000001a c06f9f68 c034180c c0341814
[ 3573.327816] 9f60: 80000153 ffffffff
[ 3573.331331] [<c0013340>] (__irq_svc) from [<c0341814>] (cpuidle_enter_state+0xdc/0x248)
[ 3573.339385] [<c0341814>] (cpuidle_enter_state) from [<c00535ec>] (cpu_startup_entry+0x170/0x234)
[ 3573.348218] [<c00535ec>] (cpu_startup_entry) from [<c06b5c6c>] (start_kernel+0x3b0/0x3bc)
[ 3573.356436] Code: e59c9004 e3e0b000 e5938000 ea000002 (e7990102)
[ 3573.362634] ---[ end trace 47b32564cd3160db ]---
[ 3573.367281] Kernel panic - not syncing: Fatal exception in interrupt
[ 3573.373667] ---[ end Kernel panic - not syncing: Fatal exception in interrupt
----------------------------------------------------------------------

------- oops from v4.8.6 ---------------------------------------------
[231233.388543] Unable to handle kernel NULL pointer dereference at virtual address 00000020
[231233.396804] pgd = c0004000
[231233.399614] [00000020] *pgd=00000000
[231233.403311] Internal error: Oops: 17 [#1] SMP ARM
[231233.408124] Modules linked in: ath9k ath9k_common ath9k_hw ath
[231233.414132] CPU: 0 PID: 0 Comm: swapper/0 Not tainted 4.8.6 #37
[231233.420165] Hardware name: Marvell Armada 370/XP (Device Tree)
[231233.426111] task: c0b091c0 task.stack: c0b00000
[231233.430760] PC is at ath_cmn_process_fft+0xa0/0x578 [ath9k_common]
[231233.437060] LR is at ath_cmn_process_fft+0xc4/0x578 [ath9k_common]
[231233.443357] pc : [<bf07bec4>]    lr : [<bf07bee8>]    psr: 80000153
[231233.443357] sp : c0b01cd0  ip : 00000000  fp : 00000000
[231233.455059] r10: c0b034d4  r9 : 00000069  r8 : 0000006c
[231233.460394] r7 : 00000000  r6 : dbef9440  r5 : c0b03da0  r4 : 00000000
[231233.467037] r3 : 00000001  r2 : 00000008  r1 : 00000004  r0 : 00000000
[231233.473682] Flags: Nzcv  IRQs on  FIQs off  Mode SVC_32  ISA ARM  Segment none
[231233.481023] Control: 10c5387d  Table: 1e614019  DAC: 00000051
[231233.486882] Process swapper/0 (pid: 0, stack limit = 0xc0b00220)
[231233.493001] Stack: (0xc0b01cd0 to 0xc0b02000)
[231233.497466] 1cc0:                                     fffffffa 3b9ac9ff 003c8995 c0b44d30
[231233.505770] 1ce0: dda18010 00000000 c0b01e14 c017ad48 ffffffff dee1ac84 c0b44d30 c0b44b00
[231233.514073] 1d00: 0000099e 00000440 0001bef9 c01176f4 00000002 00000786 00000000 00000000
[231233.522377] 1d20: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000
[231233.530680] 1d40: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000
[231233.538984] 1d60: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000
[231233.547287] 1d80: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000
[231233.555591] 1da0: dda18010 dda18010 00000000 defaa3d8 defaa3c0 defaa3c0 dee18e40 de5b4a18
[231233.563895] 1dc0: dda18010 bf08a9d0 071a3710 00000056 00989680 00000000 071a393a 00000056
[231233.572199] 1de0: 000001fb dee18440 00000000 dbef9440 dee198b0 00000014 dda18038 dee1a97c
[231233.580504] 1e00: dbef9440 00000002 00000001 dee18440 0036f478 071a3710 2422006c 018fff07
[231233.588807] 1e20: 80252900 01168e85 40000000 00000000 00000000 00000000 00000000 00000000
[231233.597110] 1e40: 00000000 00000000 c0a4a2c0 dee18e40 dda18010 dee19808 00000001 c0b00000
[231233.605414] 1e60: c0a4a2c0 c0b02080 40000006 bf088810 dee197d0 dee197d4 00000000 c0b01e88
[231233.613717] 1e80: c0b00000 c0126b88 00000000 00000006 c0b00000 c0b02098 c0b02080 00000100
[231233.622021] 1ea0: c0b02080 c0126d74 df405000 c0b01f30 c0b01ea8 c0b3bf80 0000000a 0160605b
[231233.630324] 1ec0: c0b02100 00200100 df488a20 c0a4d500 00000000 00000000 00000001 df405000
[231233.638629] 1ee0: c0b01f30 00000000 c0b03524 c0127120 c0a4d500 c01635e4 c04b7318 20000153
[231233.646933] 1f00: c0b61040 00000001 c0b61040 c010145c c04b7318 20000153 ffffffff c0b01f64
[231233.655236] 1f20: 0028571c c0b00000 00000000 c010bd8c 00000000 0000d24e 1f194000 dfbe31c0
[231233.663540] 1f40: 37d25f82 0000d24e dfbe2590 00000001 0028571c 0000d24e 00000000 c0b03524
[231233.671843] 1f60: 0d5e8652 c0b01f80 c04b7310 c04b7318 20000153 ffffffff 00000051 00000000
[231233.680148] 1f80: dfbe2590 c0b00000 c0b034d4 00000001 dfbe2590 c0b2e070 c0a4e588 c0b0352c
[231233.688452] 1fa0: c0b03524 c015a240 c0b01fa8 c0b3b0f4 00000000 ffffffff 00000000 c0a00c54
[231233.696756] 1fc0: ffffffff ffffffff 00000000 c0a0068c 00000000 c0a3ba28 c0b3b614 c0b034c0
[231233.705059] 1fe0: c0a3ba24 c0b0a3a8 00004059 561f5811 00000000 0000807c 00000000 00000000
[231233.713401] [<bf07bec4>] (ath_cmn_process_fft [ath9k_common]) from [<bf08a9d0>] (ath_rx_tasklet+0x47c/0xb20 [ath9k])
[231233.724079] [<bf08a9d0>] (ath_rx_tasklet [ath9k]) from [<bf088810>] (ath9k_tasklet+0x1dc/0x218 [ath9k])
[231233.733623] [<bf088810>] (ath9k_tasklet [ath9k]) from [<c0126b88>] (tasklet_action+0x74/0x110)
[231233.742367] [<c0126b88>] (tasklet_action) from [<c0126d74>] (__do_softirq+0xfc/0x218)
[231233.750324] [<c0126d74>] (__do_softirq) from [<c0127120>] (irq_exit+0x7c/0xb4)
[231233.757678] [<c0127120>] (irq_exit) from [<c01635e4>] (__handle_domain_irq+0x60/0xb4)
[231233.765637] [<c01635e4>] (__handle_domain_irq) from [<c010145c>] (armada_370_xp_handle_irq+0x48/0xa8)
[231233.774989] [<c010145c>] (armada_370_xp_handle_irq) from [<c010bd8c>] (__irq_svc+0x6c/0x90)
[231233.783463] Exception stack(0xc0b01f30 to 0xc0b01f78)
[231233.788625] 1f20:                                     00000000 0000d24e 1f194000 dfbe31c0
[231233.796930] 1f40: 37d25f82 0000d24e dfbe2590 00000001 0028571c 0000d24e 00000000 c0b03524
[231233.805232] 1f60: 0d5e8652 c0b01f80 c04b7310 c04b7318 20000153 ffffffff
[231233.811974] [<c010bd8c>] (__irq_svc) from [<c04b7318>] (cpuidle_enter_state+0x18c/0x2b4)
[231233.820202] [<c04b7318>] (cpuidle_enter_state) from [<c015a240>] (cpu_startup_entry+0x17c/0x220)
[231233.829124] [<c015a240>] (cpu_startup_entry) from [<c0a00c54>] (start_kernel+0x368/0x374)
[231233.837430] Code: e5933000 e1d330b4 e58d3030 ea000002 (e7970102)
[231233.843714] ---[ end trace 0a5139f91be0a117 ]---
[231233.848460] Kernel panic - not syncing: Fatal exception in interrupt
[231233.854937] ---[ end Kernel panic - not syncing: Fatal exception in interrupt
----------------------------------------------------------------------

------- oops from v4.8.6 #2 ------------------------------------------
[42059.303625] Unable to handle kernel NULL pointer dereference at virtual address 00000020
[42059.311799] pgd = c0004000
[42059.314522] [00000020] *pgd=00000000
[42059.318162] Internal error: Oops: 17 [#1] SMP ARM
[42059.322889] Modules linked in: ath9k ath9k_common ath9k_hw ath
[42059.328809] CPU: 0 PID: 0 Comm: swapper/0 Not tainted 4.8.6 #37
[42059.334755] Hardware name: Marvell Armada 370/XP (Device Tree)
[42059.340613] task: c0b091c0 task.stack: c0b00000
[42059.345176] PC is at ath_cmn_process_fft+0xa0/0x578 [ath9k_common]
[42059.351388] LR is at ath_cmn_process_fft+0xc4/0x578 [ath9k_common]
[42059.357598] pc : [<bf07bec4>]    lr : [<bf07bee8>]    psr: 80000153
[42059.357598] sp : c0b01cd0  ip : 00000000  fp : 00000000
[42059.369127] r10: c0b034d4  r9 : 00000069  r8 : 0000006c
[42059.374374] r7 : 00000000  r6 : dcfbd340  r5 : c0b03da0  r4 : 00000000
[42059.380930] r3 : 00000001  r2 : 00000008  r1 : 00000004  r0 : 00000000
[42059.387487] Flags: Nzcv  IRQs on  FIQs off  Mode SVC_32  ISA ARM  Segment none
[42059.394741] Control: 10c5387d  Table: 1ef48019  DAC: 00000051
[42059.400513] Process swapper/0 (pid: 0, stack limit = 0xc0b00220)
[42059.406545] Stack: (0xc0b01cd0 to 0xc0b02000)
[42059.410924] 1cc0:                                     fffffffa 3b9ac9ff 0047c6ce c0b44d30
[42059.419141] 1ce0: de6a0010 00000000 c0b01e14 c017ad48 ffffffff dee0ac84 c0b44d30 c0b44b00
[42059.427357] 1d00: 0000099e 00000340 0001cfbd c01176f4 00000002 00000786 00000080 00000000
[42059.435573] 1d20: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000
[42059.443789] 1d40: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000
[42059.452005] 1d60: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000
[42059.460220] 1d80: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000
[42059.468437] 1da0: de6a0010 de6a0010 00000000 deec5b58 deec5b40 deec5b40 dee08e40 de631ff0
[42059.476653] 1dc0: de6a0010 bf08a9d0 8918a8c8 00000002 00000000 00000000 8918aaa1 00000002
[42059.484869] 1de0: 00000200 dee08440 00000000 dcfbd340 dee098b0 00000014 de6a0038 dee0a97c
[42059.493085] 1e00: dcfbd340 00000002 00000001 dee08440 00fc2540 8918a8c8 0502006c 018e026c
[42059.501301] 1e20: 80202600 016d5ab7 40000100 00000000 00000000 00000000 00000000 00000000
[42059.509518] 1e40: 00000000 00000000 c0a4a2c0 dee08e40 de6a0010 dee09808 00000001 c0b00000
[42059.517734] 1e60: c0a4a2c0 c0b02080 40000006 bf088810 dee097d0 dee097d4 00000000 c0b01e88
[42059.525950] 1e80: c0b00000 c0126b88 00000000 00000006 c0b00000 c0b02098 c0b02080 00000100
[42059.534166] 1ea0: c0b02080 c0126d74 df405000 c0b01f30 c0b01ea8 c0b3bf80 0000000a 003fb83a
[42059.542382] 1ec0: c0b02100 00200100 df486a20 c0a4d500 00000000 00000000 00000001 df405000
[42059.550599] 1ee0: c0b01f30 00000000 c0b03524 c0127120 c0a4d500 c01635e4 c04b7318 20000153
[42059.558816] 1f00: c0b61040 00000001 c0b61040 c010145c c04b7318 20000153 ffffffff c0b01f64
[42059.567031] 1f20: 006895c7 c0b00000 00000000 c010bd8c 00000000 00002640 1f194000 dfbe31c0
[42059.575248] 1f40: b1708859 00002640 dfbe2590 00000001 006895c7 00002640 00000000 c0b03524
[42059.583464] 1f60: 0d5e8652 c0b01f80 c04b7310 c04b7318 20000153 ffffffff 00000051 00000000
[42059.591681] 1f80: dfbe2590 c0b00000 c0b034d4 00000001 dfbe2590 c0b2e070 c0a4e588 c0b0352c
[42059.599897] 1fa0: c0b03524 c015a240 c0b01fa8 c0b3b0f4 00000000 ffffffff 00000000 c0a00c54
[42059.608114] 1fc0: ffffffff ffffffff 00000000 c0a0068c 00000000 c0a3ba28 c0b3b614 c0b034c0
[42059.616330] 1fe0: c0a3ba24 c0b0a3a8 00004059 561f5811 00000000 0000807c 00000000 00000000
[42059.624586] [<bf07bec4>] (ath_cmn_process_fft [ath9k_common]) from [<bf08a9d0>] (ath_rx_tasklet+0x47c/0xb20 [ath9k])
[42059.635176] [<bf08a9d0>] (ath_rx_tasklet [ath9k]) from [<bf088810>] (ath9k_tasklet+0x1dc/0x218 [ath9k])
[42059.644631] [<bf088810>] (ath9k_tasklet [ath9k]) from [<c0126b88>] (tasklet_action+0x74/0x110)
[42059.653288] [<c0126b88>] (tasklet_action) from [<c0126d74>] (__do_softirq+0xfc/0x218)
[42059.661157] [<c0126d74>] (__do_softirq) from [<c0127120>] (irq_exit+0x7c/0xb4)
[42059.668423] [<c0127120>] (irq_exit) from [<c01635e4>] (__handle_domain_irq+0x60/0xb4)
[42059.676295] [<c01635e4>] (__handle_domain_irq) from [<c010145c>] (armada_370_xp_handle_irq+0x48/0xa8)
[42059.685559] [<c010145c>] (armada_370_xp_handle_irq) from [<c010bd8c>] (__irq_svc+0x6c/0x90)
[42059.693946] Exception stack(0xc0b01f30 to 0xc0b01f78)
[42059.699021] 1f20:                                     00000000 00002640 1f194000 dfbe31c0
[42059.707237] 1f40: b1708859 00002640 dfbe2590 00000001 006895c7 00002640 00000000 c0b03524
[42059.715453] 1f60: 0d5e8652 c0b01f80 c04b7310 c04b7318 20000153 ffffffff
[42059.722107] [<c010bd8c>] (__irq_svc) from [<c04b7318>] (cpuidle_enter_state+0x18c/0x2b4)
[42059.730247] [<c04b7318>] (cpuidle_enter_state) from [<c015a240>] (cpu_startup_entry+0x17c/0x220)
[42059.739081] [<c015a240>] (cpu_startup_entry) from [<c0a00c54>] (start_kernel+0x368/0x374)
[42059.747299] Code: e5933000 e1d330b4 e58d3030 ea000002 (e7970102)
[42059.753488] ---[ end trace d9b5665c4c165fb1 ]---
[42059.758151] Kernel panic - not syncing: Fatal exception in interrupt
[42059.764541] ---[ end Kernel panic - not syncing: Fatal exception in interrupt
----------------------------------------------------------------------

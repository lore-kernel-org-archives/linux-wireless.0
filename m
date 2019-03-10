Return-Path: <SRS0=lllw=RN=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_PASS autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7E89FC4360F
	for <linux-wireless@archiver.kernel.org>; Sun, 10 Mar 2019 04:17:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 232842077B
	for <linux-wireless@archiver.kernel.org>; Sun, 10 Mar 2019 04:17:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b="K4RRrW02"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726378AbfCJEQ5 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 9 Mar 2019 23:16:57 -0500
Received: from lelv0143.ext.ti.com ([198.47.23.248]:37498 "EHLO
        lelv0143.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726329AbfCJEQ4 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 9 Mar 2019 23:16:56 -0500
Received: from lelv0265.itg.ti.com ([10.180.67.224])
        by lelv0143.ext.ti.com (8.15.2/8.15.2) with ESMTP id x2A4GcWo057576;
        Sat, 9 Mar 2019 22:16:38 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1552191398;
        bh=/2G4+VSOU+HkAQgyb9apmD5aXwQH3HkyIx6x6JAVjCQ=;
        h=Subject:To:CC:References:From:Date:In-Reply-To;
        b=K4RRrW02C7zVUwb8yQeb62EeZ1LXuyq8bLt7eIKFP4dqzwRYRGYEF3lx74m59glEi
         O+Bcddzq+hf7uHzYRWfJndUTFHC4oBl+dksV5CwpooLxXXFt8L4sMoAtQC5dLWX/Hm
         WL62+H/OlBYz04RaM78H+efIPwFL9IyhXuTy/Hwk=
Received: from DFLE112.ent.ti.com (dfle112.ent.ti.com [10.64.6.33])
        by lelv0265.itg.ti.com (8.15.2/8.15.2) with ESMTPS id x2A4GctQ015582
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Sat, 9 Mar 2019 22:16:38 -0600
Received: from DFLE114.ent.ti.com (10.64.6.35) by DFLE112.ent.ti.com
 (10.64.6.33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1591.10; Sat, 9
 Mar 2019 22:16:37 -0600
Received: from dlep32.itg.ti.com (157.170.170.100) by DFLE114.ent.ti.com
 (10.64.6.35) with Microsoft SMTP Server (version=TLS1_0,
 cipher=TLS_RSA_WITH_AES_256_CBC_SHA) id 15.1.1591.10 via Frontend Transport;
 Sat, 9 Mar 2019 22:16:37 -0600
Received: from [172.22.216.167] (ileax41-snat.itg.ti.com [10.172.224.153])
        by dlep32.itg.ti.com (8.14.3/8.13.8) with ESMTP id x2A4GXM2004421;
        Sat, 9 Mar 2019 22:16:34 -0600
Subject: Re: Nokia N900: wl1251 spi3.0: EOW timed out on
To:     Merlijn Wajer <merlijn@wizzup.org>,
        "kvalo@codeaurora.org" <kvalo@codeaurora.org>
CC:     linux-omap <linux-omap@vger.kernel.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        Tony Lindgren <tony@atomide.com>,
        Sebastian Reichel <sre@kernel.org>,
        Pavel Machek <pavel@ucw.cz>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "broonie@kernel.org" <broonie@kernel.org>
References: <3819003e-2ab3-0325-de0d-9fa07b51ee9f@wizzup.org>
 <436a9a35-539a-3fe8-2225-36b45c7e5412@wizzup.org>
From:   Vignesh Raghavendra <vigneshr@ti.com>
Message-ID: <165d492e-435b-40a8-f784-5f2d08803514@ti.com>
Date:   Sun, 10 Mar 2019 09:46:33 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.3
MIME-Version: 1.0
In-Reply-To: <436a9a35-539a-3fe8-2225-36b45c7e5412@wizzup.org>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hi.

On 10-Mar-19 6:23 AM, Merlijn Wajer wrote:
> 
> Hi,
> 
> On 10/03/2019 00:22, Merlijn Wajer wrote:
>> Hi,
>>
>> I just migrated to Linux 5.0  (from 4.15) on my Nokia N900, and I'm
>> getting a lot of messages like this:
>>
>>> wl1251 spi3.0: EOW timed out


Could you try if this patch fixes the issue? This is part of latest mainline tree but not part of 5.0:
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=baf8b9f8d260c55a86405f70a384c29cda888476

Regards
Vignesh

>>
>> and it ends with:
>>
>>> [   29.072174] wl1251: ERROR chip id doesn't match after firmware boot
>>
>> My tree carries some patches, but none are related to SPI or wl1251. Any
>> clue what might be up?
> 
> Reverting these three commits makes the problem go away:
> 
> commit 89e8b9cb846515e4435eb42df7009b824cf3405a
> Author: Vignesh R <vigneshr@ti.com>
> Date:   Mon Oct 15 12:08:29 2018 +0530
> 
>     spi: omap2-mcspi: Add slave mode support
> 
> 
> commit b682cffa3ac6d9d9e16e9b413c45caee3b391fab
> Author: Vignesh R <vigneshr@ti.com>
> Date:   Mon Oct 15 12:08:28 2018 +0530
> 
>     spi: omap2-mcspi: Set FIFO DMA trigger level to word length
> 
> 
> commit 13d515c796adc49a49b0cd2212ccd7f43a37fc5a
> Author: Vignesh R <vigneshr@ti.com>
> Date:   Mon Oct 15 12:08:27 2018 +0530
> 
>     spi: omap2-mcspi: Switch to readl_poll_timeout()
> 
> I reverted 13d515c796adc49a49b0cd2212ccd7f43a37fc5a before, and that
> didn't make the difference, so I assume the problematic commit is either
> b682cffa3ac6d9d9e16e9b413c45caee3b391fab or
> 89e8b9cb846515e4435eb42df7009b824cf3405a
> 
> Cheers,
> Merlijn
> 
>> dmesg attached.
>>
>> Cheers,
>> Merlijn
>>
>> [1]
>>
>> [    0.000000] Booting Linux on physical CPU 0x0
>> [    0.000000] Linux version 5.0.0+ (merlijn@kgpe-d16) (gcc version
>> 7.3.0 (Gentoo Hardened 7.3.0-r3 p1.4)) #6 PREEMPT Wed Mar 6 08:35:59 CET
>> 2019
>> [    0.000000] CPU: ARMv7 Processor [411fc083] revision 3 (ARMv7),
>> cr=10c5387d
>> [    0.000000] CPU: PIPT / VIPT nonaliasing data cache, VIPT nonaliasing
>> instruction cache
>> [    0.000000] OF: fdt: Machine model: Nokia N900
>> [    0.000000] Memory policy: Data cache writeback
>> [    0.000000] On node 0 totalpages: 65280
>> [    0.000000]   Normal zone: 510 pages used for memmap
>> [    0.000000]   Normal zone: 0 pages reserved
>> [    0.000000]   Normal zone: 65280 pages, LIFO batch:15
>> [    0.000000] CPU: All CPU(s) started in SVC mode.
>> [    0.000000] OMAP3430/3530 ES3.1 (l2cache iva sgx neon isp)
>> [    0.000000] random: get_random_bytes called from
>> start_kernel+0x80/0x3fc with crng_init=0
>> [    0.000000] pcpu-alloc: s0 r0 d32768 u32768 alloc=1*32768
>> [    0.000000] pcpu-alloc: [0] 0
>> [    0.000000] Built 1 zonelists, mobility grouping on.  Total pages: 64770
>> [    0.000000] Kernel command line: root=/dev/mmcblk0p2 rootwait rw
>> mtdoops.mtddev=log console=tty1 omapfb.vram=0:4M
>> omapfb.mode=lcd:848x480-16 nokia-modem.pm=1
>> [    0.000000] Dentry cache hash table entries: 32768 (order: 5, 131072
>> bytes)
>> [    0.000000] Inode-cache hash table entries: 16384 (order: 4, 65536 bytes)
>> [    0.000000] Memory: 216140K/261120K available (6144K kernel code,
>> 258K rwdata, 1856K rodata, 1024K init, 32920K bss, 44980K reserved, 0K
>> cma-reserved, 0K highmem)
>> [    0.000000] Virtual kernel memory layout:
>>                    vector  : 0xffff0000 - 0xffff1000   (   4 kB)
>>                    fixmap  : 0xffc00000 - 0xfff00000   (3072 kB)
>>                    vmalloc : 0xd0000000 - 0xff800000   ( 760 MB)
>>                    lowmem  : 0xc0000000 - 0xcff00000   ( 255 MB)
>>                    pkmap   : 0xbfe00000 - 0xc0000000   (   2 MB)
>>                    modules : 0xbf000000 - 0xbfe00000   (  14 MB)
>>                      .text : 0x(ptrval) - 0x(ptrval)   (7136 kB)
>>                      .init : 0x(ptrval) - 0x(ptrval)   (1024 kB)
>>                      .data : 0x(ptrval) - 0x(ptrval)   ( 259 kB)
>>                       .bss : 0x(ptrval) - 0x(ptrval)   (32921 kB)
>> [    0.000000] SLUB: HWalign=64, Order=0-3, MinObjects=0, CPUs=1, Nodes=1
>> [    0.000000] rcu: Preemptible hierarchical RCU implementation.
>> [    0.000000]  Tasks RCU enabled.
>> [    0.000000] rcu: RCU calculated value of scheduler-enlistment delay
>> is 10 jiffies.
>> [    0.000000] NR_IRQS: 16, nr_irqs: 16, preallocated irqs: 16
>> [    0.000000] IRQ: Found an INTC at 0x(ptrval) (revision 4.0) with 96
>> interrupts
>> [    0.000000] Clocking rate (Crystal/Core/MPU): 19.2/332/500 MHz
>> [    0.000000] OMAP clockevent source: timer1 at 32768 Hz
>> [    0.000000] clocksource: 32k_counter: mask: 0xffffffff max_cycles:
>> 0xffffffff, max_idle_ns: 58327039986419 ns
>> [    0.000030] sched_clock: 32 bits at 32kHz, resolution 30517ns, wraps
>> every 65535999984741ns
>> [    0.000030] OMAP clocksource: 32k_counter at 32768 Hz
>> [    0.000579] Console: colour dummy device 80x30
>> [    0.001647] printk: console [tty1] enabled
>> [    0.001708] Calibrating delay loop... 496.43 BogoMIPS (lpj=2482176)
>> [    0.048919] pid_max: default: 32768 minimum: 301
>> [    0.049133] LSM: Security Framework initializing
>> [    0.049255] Mount-cache hash table entries: 1024 (order: 0, 4096 bytes)
>> [    0.049316] Mountpoint-cache hash table entries: 1024 (order: 0, 4096
>> bytes)
>> [    0.050628] CPU: Testing write buffer coherency: ok
>> [    0.050750] CPU0: Spectre v2: using BPIALL workaround
>> [    0.052307] Setting up static identity map for 0x80100000 - 0x80100060
>> [    0.052612] rcu: Hierarchical SRCU implementation.
>> [    0.056457] devtmpfs: initialized
>> [    0.086242] VFP support v0.3: implementor 41 architecture 3 part 30
>> variant c rev 1
>> [    0.086944] clocksource: jiffies: mask: 0xffffffff max_cycles:
>> 0xffffffff, max_idle_ns: 19112604462750000 ns
>> [    0.087036] futex hash table entries: 256 (order: -1, 3072 bytes)
>> [    0.087280] xor: measuring software checksum speed
>> [    0.178619]    arm4regs  :   623.600 MB/sec
>> [    0.278381]    8regs     :   459.600 MB/sec
>> [    0.378173]    32regs    :   600.000 MB/sec
>> [    0.477966]    neon      :   444.800 MB/sec
>> [    0.477996] xor: using function: arm4regs (623.600 MB/sec)
>> [    0.478149] pinctrl core: initialized pinctrl subsystem
>> [    0.479644] NET: Registered protocol family 16
>> [    0.481414] DMA: preallocated 256 KiB pool for atomic coherent
>> allocations
>> [    0.501464] omap_hwmod: mcbsp2_sidetone using broken dt data from mcbsp
>> [    0.502136] omap_hwmod: mcbsp3_sidetone using broken dt data from mcbsp
>> [    0.552520] cpuidle: using governor ladder
>> [    0.552612] cpuidle: using governor menu
>> [    0.553283] Reprogramming SDRC clock to 332000000 Hz
>> [    0.559783] OMAP GPIO hardware version 2.5
>> [    0.582397] RX-51: Enabling ARM errata 430973 workaround
>> [    0.584259] RX-51: Registering OMAP3 HWRNG device
>> [    0.584808] hw-breakpoint: debug architecture 0x4 unsupported.
>> [    0.586090] Reserving DMA channels 0 and 1 for HS ROM code
>> [    0.586151] OMAP DMA hardware revision 4.0
>> [    0.767700] raid6: neonx8   gen()   156 MB/s
>> [    0.937103] raid6: neonx8   xor()   205 MB/s
>> [    1.106658] raid6: neonx4   gen()   595 MB/s
>> [    1.276367] raid6: neonx4   xor()   447 MB/s
>> [    1.446044] raid6: neonx2   gen()   463 MB/s
>> [    1.615631] raid6: neonx2   xor()   380 MB/s
>> [    1.785247] raid6: neonx1   gen()   229 MB/s
>> [    1.955017] raid6: neonx1   xor()   212 MB/s
>> [    2.125213] raid6: int32x8  gen()    89 MB/s
>> [    2.294403] raid6: int32x8  xor()    58 MB/s
>> [    2.464355] raid6: int32x4  gen()    90 MB/s
>> [    2.553649] random: fast init done
>> [    2.633544] raid6: int32x4  xor()    70 MB/s
>> [    2.803527] raid6: int32x2  gen()   110 MB/s
>> [    2.972930] raid6: int32x2  xor()    69 MB/s
>> [    3.142791] raid6: int32x1  gen()    55 MB/s
>> [    3.312438] raid6: int32x1  xor()    45 MB/s
>> [    3.312469] raid6: using algorithm neonx4 gen() 595 MB/s
>> [    3.312499] raid6: .... xor() 447 MB/s, rmw enabled
>> [    3.312530] raid6: using neon recovery algorithm
>> [    3.328796] omap-dma-engine 48056000.dma-controller: OMAP DMA engine
>> driver
>> [    3.335205] omap-iommu 480bd400.mmu: 480bd400.mmu registered
>> [    3.335845] iommu: Adding device 480bc000.isp to group 0
>> [    3.336273] usbcore: registered new interface driver usbfs
>> [    3.336425] usbcore: registered new interface driver hub
>> [    3.336639] usbcore: registered new device driver usb
>> [    3.338134] omap-mailbox 48094000.mailbox: omap mailbox rev 0x40
>> [    3.338806] Advanced Linux Sound Architecture Driver Initialized.
>> [    3.340484] clocksource: Switched to clocksource 32k_counter
>> [    3.340728] VFS: Disk quotas dquot_6.6.0
>> [    3.340881] VFS: Dquot-cache hash table entries: 1024 (order 0, 4096
>> bytes)
>> [    3.357482] NET: Registered protocol family 2
>> [    3.358886] tcp_listen_portaddr_hash hash table entries: 512 (order:
>> 0, 4096 bytes)
>> [    3.358978] TCP established hash table entries: 2048 (order: 1, 8192
>> bytes)
>> [    3.359069] TCP bind hash table entries: 2048 (order: 1, 8192 bytes)
>> [    3.359130] TCP: Hash tables configured (established 2048 bind 2048)
>> [    3.359374] UDP hash table entries: 256 (order: 0, 4096 bytes)
>> [    3.359436] UDP-Lite hash table entries: 256 (order: 0, 4096 bytes)
>> [    3.359741] NET: Registered protocol family 1
>> [    3.366088] Initialise system trusted keyrings
>> [    3.366485] workingset: timestamp_bits=30 max_order=16 bucket_order=0
>> [    3.379058] squashfs: version 4.0 (2009/01/31) Phillip Lougher
>> [    3.386352] Key type asymmetric registered
>> [    3.386413] Asymmetric key parser 'x509' registered
>> [    3.386474] io scheduler mq-deadline registered
>> [    3.386505] io scheduler kyber registered
>> [    3.388366] ti-sysc 480cb024.target-module: sysc_flags 00000100 !=
>> 00000110
>> [    3.389739] ti-sysc 480c9024.target-module: sysc_flags 00000100 !=
>> 00000110
>> [    3.392486] pinctrl-single 48002030.pinmux: 284 pins, size 568
>> [    3.393218] pinctrl-single 48002a00.pinmux: 46 pins, size 92
>> [    3.394042] pinctrl-single 480025d8.pinmux: 18 pins, size 36
>> [    3.396789] omapdss_dss 48050000.dss: 48050000.dss supply vdda_video
>> not found, using dummy regulator
>> [    3.397064] omapdss_dss 48050000.dss: Linked as a consumer to regulator.0
>> [    3.397247] OMAP DSS rev 2.0
>> [    3.397521] omapdss_dss 48050000.dss: bound 48050400.dispc (ops
>> dispc_component_ops)
>> [    3.397888] omapdss_dss 48050000.dss: bound 48050c00.encoder (ops
>> venc_component_ops)
>> [    3.399566] omapfb omapfb: failed to connect default display
>> [    3.399627] omapfb omapfb: failed to init overlay connections
>> [    3.399871] omapfb omapfb: failed to setup omapfb
>> [    3.402923] omap_uart 4806c000.serial: no wakeirq for uart1
>> [    3.403289] 4806c000.serial: ttyO1 at MMIO 0x4806c000 (irq = 89,
>> base_baud = 3000000) is a OMAP UART1
>> [    3.404296] 49020000.serial: ttyO2 at MMIO 0x49020000 (irq = 90,
>> base_baud = 3000000) is a OMAP UART2
>> [    3.405761] omap3_rom_rng: initializing
>> [    3.405975] omap3_rom_rng: unable to get RNG clock
>> [    3.406036] omap3-rom-rng: probe of omap3-rom-rng failed with error -2
>> [    3.424102] brd: module loaded
>> [    3.439697] acx565akm spi0.2: omapfb: acx565akm rev ad LCD detected
>> [    3.446807] i2c /dev entries driver
>> [    3.447967] omap_wdt: OMAP Watchdog Timer Rev 0x31: initial timeout
>> 60 sec
>> [    3.450347] omap_gpio 49058000.gpio: Could not set line 0 debounce to
>> 200000 microseconds (-22)
>> [    3.450439] omap_hsmmc 4809c000.mmc: Got CD GPIO
>> [    3.467132] Initializing XFRM netlink socket
>> [    3.467254] NET: Registered protocol family 17
>> [    3.467346] NET: Registered protocol family 15
>> [    3.467407] NET: Registered protocol family 35
>> [    3.467864] Key type dns_resolver registered
>> [    3.468200] ThumbEE CPU extension supported.
>> [    3.468322] omap2_set_init_voltage: unable to find boot up OPP for
>> vdd_mpu_iva
>> [    3.468353] omap2_set_init_voltage: unable to set vdd_mpu_iva
>> [    3.468414] omap2_set_init_voltage: unable to find boot up OPP for
>> vdd_core
>> [    3.468475] omap2_set_init_voltage: unable to set vdd_core
>> [    3.472229] SmartReflex Class3 initialized
>> [    3.473449] registered taskstats version 1
>> [    3.473510] Loading compiled-in X.509 certificates
>> [    3.477539] Btrfs loaded, crc32c=crc32c-generic
>> [    3.502410] omap-gpmc 6e000000.gpmc: GPMC revision 5.0
>> [    3.502502] gpmc_mem_init: disabling cs 0 mapped at 0x0-0x1000000
>> [    3.504272] omap2-onenand 1000000.onenand: initializing on CS0
>> (0x01000000), va (ptrval), DMA mode
>> [    3.504364] OneNAND Manufacturer: Unknown (0xa0)
>> [    3.509002] Skipping twl internal clock init and using bootloader
>> value (unknown osc rate)
>> [    3.831176] twl 1-0048: PIH (irq 23) chaining IRQs 146..154
>> [    3.831329] twl 1-0048: power (irq 151) chaining IRQs 154..161
>> [    3.891784] twl_rtc 48070000.i2c:twl@48:rtc: Power up reset detected.
>> [    3.920745] twl_rtc 48070000.i2c:twl@48:rtc: Enabling TWL-RTC
>> [    4.041534] twl_rtc 48070000.i2c:twl@48:rtc: registered as rtc0
>> [    5.151458] V28_A: Bringing 2600000uV into 2800000-2800000uV
>> [    5.962188] twl4030_gpio twl4030-gpio: gpio (irq 146) chaining IRQs
>> 162..179
>> [    6.110900] twl4030_usb 48070000.i2c:twl@48:twl4030-usb: Linked as a
>> consumer to regulator.16
>> [    6.170898] twl4030_usb 48070000.i2c:twl@48:twl4030-usb: Linked as a
>> consumer to regulator.14
>> [    6.230926] twl4030_usb 48070000.i2c:twl@48:twl4030-usb: Linked as a
>> consumer to regulator.15
>> [    6.721160] twl4030_usb 48070000.i2c:twl@48:twl4030-usb: Initialized
>> TWL4030 USB module
>> [    6.781066] input: twl4030_pwrbutton as
>> /devices/platform/68000000.ocp/48070000.i2c/i2c-1/1-0048/48070000.i2c:twl@48:pwrbutton/input/input0
>> [    6.782592] input: TWL4030 Keypad as
>> /devices/platform/68000000.ocp/48070000.i2c/i2c-1/1-0048/48070000.i2c:twl@48:keypad/input/input1
>> [    7.110839] twl4030_madc 48070000.i2c:twl@48:madc:
>> 48070000.i2c:twl@48:madc supply vusb3v1 not found, using dummy regulator
>> [    7.111114] twl4030_madc 48070000.i2c:twl@48:madc: Linked as a
>> consumer to regulator.0
>> [   13.170959] omap_i2c 48070000.i2c: bus 1 rev3.3 at 2200 kHz
>> [   13.173492] tlv320aic3x-codec 2-0018: Linked as a consumer to regulator.8
>> [   13.174011] tlv320aic3x-codec 2-0018: Linked as a consumer to
>> regulator.13
>> [   13.175476] tlv320aic3x-codec 2-0019: Linked as a consumer to regulator.8
>> [   13.175903] tlv320aic3x-codec 2-0019: Linked as a consumer to
>> regulator.13
>> [   13.178161] tpa6130a2 2-0060: Linked as a consumer to regulator.13
>> [   13.179412] omap_i2c 48072000.i2c: bus 2 rev3.3 at 100 kHz
>> [   13.181793] omap_i2c 48060000.i2c: bus 3 rev3.3 at 400 kHz
>> [   13.183044] omapdss_dss 48050000.dss: Linked as a consumer to regulator.2
>> [   13.183258] omapdss_venc 48050c00.encoder: Linked as a consumer to
>> regulator.7
>> [   13.205535] Console: switching to colour frame buffer device 100x30
>> [   13.291076] omapfb omapfb: using display 'lcd' mode 800x480
>> [   13.661804] cpu cpu0: Linked as a consumer to regulator.6
>> [   13.668945] cpu cpu0: Dropping the link to regulator.6
>> [   13.676269] cpu cpu0: Linked as a consumer to regulator.6
>> [   13.685058] omap_gpio 49058000.gpio: Could not set line 0 debounce to
>> 200000 microseconds (-22)
>> [   13.692199] omap_hsmmc 4809c000.mmc: Got CD GPIO
>> [   13.699615] omap_hsmmc 4809c000.mmc: Linked as a consumer to regulator.12
>> [   13.706542] omap_hsmmc 4809c000.mmc: Linked as a consumer to regulator.1
>> [   13.864776] omap_hsmmc 480b4000.mmc: Linked as a consumer to regulator.4
>> [   13.890441] omap_hsmmc 480b4000.mmc: Linked as a consumer to regulator.19
>> [   14.011383] twl_rtc 48070000.i2c:twl@48:rtc: setting system clock to
>> 2000-01-01T00:00:10 UTC (946684810)
>> [   14.037658] smartreflex 480cb000.smartreflex: omap_sr_probe:
>> SmartReflex driver initialized
>> [   14.045013] smartreflex 480c9000.smartreflex: omap_sr_probe:
>> SmartReflex driver initialized
>> [   14.071289] VCSI: disabling
>> [   14.102355] mmc0: host does not support reading read-only switch,
>> assuming write-enable
>> [   14.119567] mmc0: new high speed SDHC card at address aaaa
>> [   14.131958] VDAC: disabling
>> [   14.148376] mmcblk0: mmc0:aaaa SC32G 29.7 GiB
>> [   14.161926] mmc1: switch to bus width 8 failed
>> [   14.175750] mmc1: switch to bus width 4 failed
>> [   14.181823]  mmcblk0: p1 p2
>> [   14.188018] mmc1: new high speed MMC card at address 0001
>> [   14.197631] mmcblk1: mmc1:0001 MMC32G 29.8 GiB
>> [   14.203582] ALSA device list:
>> [   14.209289]   No soundcards found.
>> [   14.216796] mmcblk1boot0: mmc1:0001 MMC32G partition 1 512 KiB
>> [   14.224304] mmcblk1boot1: mmc1:0001 MMC32G partition 2 512 KiB
>> [   14.232025]  mmcblk1: p1 p2 p3
>> [   14.274627] EXT4-fs (mmcblk0p2): mounted filesystem with ordered data
>> mode. Opts: (null)
>> [   14.279998] VFS: Mounted root (ext4 filesystem) on device 179:2.
>> [   14.297088] devtmpfs: mounted
>> [   14.306671] Freeing unused kernel memory: 1024K
>> [   14.312835] Run /sbin/init as init process
>> [   21.703887] udevd[664]: starting version 3.2.2
>> [   21.752258] random: udevd: uninitialized urandom read (16 bytes read)
>> [   21.761779] random: udevd: uninitialized urandom read (16 bytes read)
>> [   21.773956] random: udevd: uninitialized urandom read (16 bytes read)
>> [   22.068450] udevd[665]: starting eudev-3.2.2
>> [   22.481353] ti-soc-thermal 48002524.bandgap: This OMAP thermal sensor
>> is unreliable. You've been warned
>> [   22.539520] ti-soc-thermal 48002524.bandgap: Non-trimmed BGAP, Temp
>> not accurate
>> [   22.924926] omap_ssi 48058000.ssi-controller: ssi controller 0
>> initialized (1 ports)!
>> [   22.989501] lis3lv02d_i2c 3-001d: Linked as a consumer to regulator.2
>> [   23.064086] omap_ssi_port 4805a000.ssi-port: ssi port 0 successfully
>> initialized
>> [   23.069732] lis3lv02d_i2c 3-001d: Linked as a consumer to regulator.8
>> [   23.142425] input: twl4030:vibrator as
>> /devices/platform/68000000.ocp/48070000.i2c/i2c-1/1-0048/48070000.i2c:twl@48:audio/twl4030-vibra/input/input2
>> [   23.154266] lis3lv02d: 8 bits sensor found
>> [   23.271240] input: ST LIS3LV02DL Accelerometer as
>> /devices/platform/lis3lv02d/input/input3
>> [   23.675292] power_supply bq27200-0: Not all required supplies found,
>> defer probe
>> [   23.702728] tsl2563 2-0029: model 7, rev. 0
>> [   23.715972] media: Linux media interface: v0.10
>> [   23.811065] bq27xxx-battery 2-0055: failed to register battery
>> [   23.855712] tsc2005 spi0.0: Linked as a consumer to regulator.8
>> [   23.907867] input: TSC2005 touchscreen as
>> /devices/platform/68000000.ocp/48098000.spi/spi_master/spi0/spi0.0/input/input4
>> [   23.991668] videodev: Linux video capture interface: v2.00
>> [   24.027893] power_supply bq27200-0: bq27200-0: Found supply : bq24150a-0
>> [   24.148590] random: crng init done
>> [   24.155151] random: 2 urandom warning(s) missed due to ratelimiting
>> [   24.420288] si4713 2-0063: Linked as a consumer to regulator.2
>> [   24.498260] si4713 2-0063: Linked as a consumer to regulator.8
>> [   24.547149] cfg80211: Loading compiled-in X.509 certificates for
>> regulatory database
>> [   24.731201] omap3isp 480bc000.isp: ignoring dependency for device,
>> assuming no driver
>> [   24.738342] omap3isp 480bc000.isp: parsing endpoint
>> /ocp@68000000/isp@480bc000/ports/port@1/endpoint, interface 1
>> [   24.738372] omap3isp 480bc000.isp: CSI-1/CCP-2 configuration
>> [   24.738372] omap3isp 480bc000.isp: clock lane polarity 0, pos 1
>> [   24.738403] omap3isp 480bc000.isp: data lane polarity 0, pos 0
>> [   24.738464] omap3isp 480bc000.isp: 480bc000.isp supply vdd-csiphy1
>> not found, using dummy regulator
>> [   24.800781] omap_i2c 48072000.i2c: controller timed out
>> [   24.809997] cfg80211: Loaded X.509 cert 'sforshee: 00b28ddf47aef9cea7'
>> [   24.833770] bq2415x-charger 2-006b: automode supported, waiting for
>> events
>> [   24.859039] bq2415x-charger 2-006b: driver registered
>> [   24.866424] platform regulatory.0: Direct firmware load for
>> regulatory.db failed with error -2
>> [   24.902069] platform regulatory.0: Falling back to syfs fallback for:
>> regulatory.db
>> [   24.928802] omap3isp 480bc000.isp: Linked as a consumer to regulator.0
>> [   24.946075] si4713 2-0063: chip found @ 0xc6 (OMAP I2C adapter)
>> [   24.997772] omap3isp 480bc000.isp: 480bc000.isp supply vdd-csiphy2
>> not found, using dummy regulator
>> [   25.117736] omap3isp 480bc000.isp: Revision 2.0 found
>> [   25.150817] lp5523x 2-0032: lp5523 Programmable led chip found
>> [   25.168640] omap-iommu 480bd400.mmu: 480bd400.mmu: version 1.1
>> [   25.204071] isp1704_charger isp1707: init gpio 67
>> [   25.221405] omap3isp 480bc000.isp: Linked as a consumer to regulator.3
>> [   25.227905] omap3isp 480bc000.isp: hist: using DMA channel dma0chan10
>> [   25.227966] omap3isp 480bc000.isp: Entity type for entity OMAP3 ISP
>> CCP2 was not initialized!
>> [   25.251342] isp1704_charger isp1707: registered with product id isp1707
>> [   25.308929] omap3isp 480bc000.isp: Entity type for entity OMAP3 ISP
>> CSI2a was not initialized!
>> [   25.356964] input: gpio_keys as /devices/platform/gpio_keys/input/input5
>> [   25.364501] omap3isp 480bc000.isp: Entity type for entity OMAP3 ISP
>> CCDC was not initialized!
>> [   25.409423] omap3isp 480bc000.isp: Entity type for entity OMAP3 ISP
>> preview was not initialized!
>> [   25.453552] rc rc0: Unspecified device as
>> /devices/platform/n900-ir/rc/rc0
>> [   25.497741] omap3isp 480bc000.isp: Entity type for entity OMAP3 ISP
>> resizer was not initialized!
>> [   25.568054] omap3isp 480bc000.isp: Entity type for entity OMAP3 ISP
>> AEWB was not initialized!
>> [   25.574859] smc91x: not found (-19).
>> [   25.631713] omap3isp 480bc000.isp: Entity type for entity OMAP3 ISP
>> AF was not initialized!
>> [   25.638366] omap3isp 480bc000.isp: Entity type for entity OMAP3 ISP
>> histogram was not initialized!
>> [   26.078918] HSI/SSI char device loaded
>> [   26.257537] mousedev: PS/2 mouse device common for all mice
>> [   26.295654] cfg80211: failed to load regulatory.db
>> [   26.380493] wl1251 spi3.0: Linked as a consumer to regulator.8
>> [   26.403289] radio-si4713 radio-si4713: New device successfully probed
>> [   26.464630] wl1251: WARNING MAC address in eeprom or nvs data is not
>> valid
>> [   26.464660] wl1251: WARNING Setting random MAC address: 00:1f:df:05:29:05
>> [   26.686614] ieee80211 phy0: Selected rate control algorithm 'minstrel_ht'
>> [   26.687866] wl1251: loaded
>> [   26.711761] wl1251: initialized
>> [   27.715240] wl1251 spi3.0: EOW timed out
>> [   27.732025] wl1251 spi3.0: EOW timed out
>> [   27.746063] wl1251 spi3.0: EOW timed out
>> [   27.760833] wl1251 spi3.0: EOW timed out
>> [   27.770843] wl1251 spi3.0: EOW timed out
>> [   27.780242] wl1251 spi3.0: EOW timed out
>> [   27.798156] wl1251 spi3.0: EOW timed out
>> [   27.807128] wl1251 spi3.0: EOW timed out
>> [   27.822204] wl1251 spi3.0: EOW timed out
>> [   27.837829] wl1251 spi3.0: EOW timed out
>> [   27.843841] wl1251 spi3.0: EOW timed out
>> [   27.852020] wl1251 spi3.0: EOW timed out
>> [   27.861511] wl1251 spi3.0: EOW timed out
>> [   27.870788] wl1251 spi3.0: EOW timed out
>> [   27.879028] wl1251 spi3.0: EOW timed out
>> [   27.885345] wl1251 spi3.0: EOW timed out
>> [   27.891479] wl1251 spi3.0: EOW timed out
>> [   27.910034] wl1251 spi3.0: EOW timed out
>> [   27.916351] wl1251 spi3.0: EOW timed out
>> [   27.923980] wl1251 spi3.0: EOW timed out
>> [   27.939575] wl1251 spi3.0: EOW timed out
>> [   27.948028] wl1251 spi3.0: EOW timed out
>> [   27.951934] wl1251 spi3.0: EOW timed out
>> [   27.958038] wl1251 spi3.0: EOW timed out
>> [   27.962341] wl1251 spi3.0: EOW timed out
>> [   27.965789] wl1251 spi3.0: EOW timed out
>> [   27.968627] wl1251 spi3.0: EOW timed out
>> [   27.972442] wl1251 spi3.0: EOW timed out
>> [   27.980834] wl1251 spi3.0: EOW timed out
>> [   27.992126] wl1251 spi3.0: EOW timed out
>> [   27.994567] wl1251 spi3.0: EOW timed out
>> [   27.996612] wl1251 spi3.0: EOW timed out
>> [   27.998870] wl1251 spi3.0: EOW timed out
>> [   28.000976] wl1251 spi3.0: EOW timed out
>> [   28.003570] wl1251 spi3.0: EOW timed out
>> [   28.007049] wl1251 spi3.0: EOW timed out
>> [   28.009216] wl1251 spi3.0: EOW timed out
>> [   28.018859] wl1251 spi3.0: EOW timed out
>> [   28.028411] wl1251 spi3.0: EOW timed out
>> [   28.030731] wl1251 spi3.0: EOW timed out
>> [   28.032775] wl1251 spi3.0: EOW timed out
>> [   28.037994] wl1251 spi3.0: EOW timed out
>> [   28.040191] wl1251 spi3.0: EOW timed out
>> [   28.042358] wl1251 spi3.0: EOW timed out
>> [   28.044433] wl1251 spi3.0: EOW timed out
>> [   28.046447] wl1251 spi3.0: EOW timed out
>> [   28.048461] wl1251 spi3.0: EOW timed out
>> [   28.050476] wl1251 spi3.0: EOW timed out
>> [   28.052856] wl1251 spi3.0: EOW timed out
>> [   28.054870] wl1251 spi3.0: EOW timed out
>> [   28.056854] wl1251 spi3.0: EOW timed out
>> [   28.058868] wl1251 spi3.0: EOW timed out
>> [   28.068420] wl1251 spi3.0: EOW timed out
>> [   28.071899] wl1251 spi3.0: EOW timed out
>> [   28.079223] wl1251 spi3.0: EOW timed out
>> [   28.081481] wl1251 spi3.0: EOW timed out
>> [   28.084167] wl1251 spi3.0: EOW timed out
>> [   28.086273] wl1251 spi3.0: EOW timed out
>> [   28.088287] wl1251 spi3.0: EOW timed out
>> [   28.090301] wl1251 spi3.0: EOW timed out
>> [   28.092590] wl1251 spi3.0: EOW timed out
>> [   28.094635] wl1251 spi3.0: EOW timed out
>> [   28.096618] wl1251 spi3.0: EOW timed out
>> [   28.100860] wl1251 spi3.0: EOW timed out
>> [   28.110656] wl1251 spi3.0: EOW timed out
>> [   28.112854] wl1251 spi3.0: EOW timed out
>> [   28.114868] wl1251 spi3.0: EOW timed out
>> [   28.119171] wl1251 spi3.0: EOW timed out
>> [   28.121337] wl1251 spi3.0: EOW timed out
>> [   28.123474] wl1251 spi3.0: EOW timed out
>> [   28.128326] wl1251 spi3.0: EOW timed out
>> [   28.130523] wl1251 spi3.0: EOW timed out
>> [   28.132873] wl1251 spi3.0: EOW timed out
>> [   28.134857] wl1251 spi3.0: EOW timed out
>> [   28.136840] wl1251 spi3.0: EOW timed out
>> [   28.138824] wl1251 spi3.0: EOW timed out
>> [   28.141021] wl1251 spi3.0: EOW timed out
>> [   28.143035] wl1251 spi3.0: EOW timed out
>> [   28.145050] wl1251 spi3.0: EOW timed out
>> [   28.147033] wl1251 spi3.0: EOW timed out
>> [   28.148986] wl1251 spi3.0: EOW timed out
>> [   28.158477] wl1251 spi3.0: EOW timed out
>> [   28.162017] wl1251 spi3.0: EOW timed out
>> [   28.168945] wl1251 spi3.0: EOW timed out
>> [   28.171173] wl1251 spi3.0: EOW timed out
>> [   28.173858] wl1251 spi3.0: EOW timed out
>> [   28.175964] wl1251 spi3.0: EOW timed out
>> [   28.177947] wl1251 spi3.0: EOW timed out
>> [   28.179962] wl1251 spi3.0: EOW timed out
>> [   28.182250] wl1251 spi3.0: EOW timed out
>> [   28.184265] wl1251 spi3.0: EOW timed out
>> [   28.186248] wl1251 spi3.0: EOW timed out
>> [   28.190887] wl1251 spi3.0: EOW timed out
>> [   28.200408] wl1251 spi3.0: EOW timed out
>> [   28.202758] wl1251 spi3.0: EOW timed out
>> [   28.204833] wl1251 spi3.0: EOW timed out
>> [   28.208435] wl1251 spi3.0: EOW timed out
>> [   28.210662] wl1251 spi3.0: EOW timed out
>> [   28.212799] wl1251 spi3.0: EOW timed out
>> [   28.217620] wl1251 spi3.0: EOW timed out
>> [   28.219818] wl1251 spi3.0: EOW timed out
>> [   28.222167] wl1251 spi3.0: EOW timed out
>> [   28.224212] wl1251 spi3.0: EOW timed out
>> [   28.226196] wl1251 spi3.0: EOW timed out
>> [   28.228149] wl1251 spi3.0: EOW timed out
>> [   28.230133] wl1251 spi3.0: EOW timed out
>> [   28.232391] wl1251 spi3.0: EOW timed out
>> [   28.234405] wl1251 spi3.0: EOW timed out
>> [   28.236419] wl1251 spi3.0: EOW timed out
>> [   28.240844] wl1251 spi3.0: EOW timed out
>> [   28.251037] wl1251 spi3.0: EOW timed out
>> [   28.253143] wl1251 spi3.0: EOW timed out
>> [   28.255218] wl1251 spi3.0: EOW timed out
>> [   28.259918] wl1251 spi3.0: EOW timed out
>> [   28.263000] wl1251 spi3.0: EOW timed out
>> [   28.265930] wl1251 spi3.0: EOW timed out
>> [   28.267974] wl1251 spi3.0: EOW timed out
>> [   28.269989] wl1251 spi3.0: EOW timed out
>> [   28.272338] wl1251 spi3.0: EOW timed out
>> [   28.274353] wl1251 spi3.0: EOW timed out
>> [   28.276336] wl1251 spi3.0: EOW timed out
>> [   28.280914] wl1251 spi3.0: EOW timed out
>> [   28.290649] wl1251 spi3.0: EOW timed out
>> [   28.292785] wl1251 spi3.0: EOW timed out
>> [   28.294799] wl1251 spi3.0: EOW timed out
>> [   28.296813] wl1251 spi3.0: EOW timed out
>> [   28.300384] wl1251 spi3.0: EOW timed out
>> [   28.302764] wl1251 spi3.0: EOW timed out
>> [   28.310791] wl1251 spi3.0: EOW timed out
>> [   28.312927] wl1251 spi3.0: EOW timed out
>> [   28.314971] wl1251 spi3.0: EOW timed out
>> [   28.316986] wl1251 spi3.0: EOW timed out
>> [   28.318969] wl1251 spi3.0: EOW timed out
>> [   28.321105] wl1251 spi3.0: EOW timed out
>> [   28.326293] wl1251 spi3.0: EOW timed out
>> [   28.330749] wl1251 spi3.0: EOW timed out
>> [   28.332946] wl1251 spi3.0: EOW timed out
>> [   28.334930] wl1251 spi3.0: EOW timed out
>> [   28.339508] wl1251 spi3.0: EOW timed out
>> [   28.341613] wl1251 spi3.0: EOW timed out
>> [   28.343597] wl1251 spi3.0: EOW timed out
>> [   28.345550] wl1251 spi3.0: EOW timed out
>> [   28.347656] wl1251 spi3.0: EOW timed out
>> [   28.349639] wl1251 spi3.0: EOW timed out
>> [   28.351623] wl1251 spi3.0: EOW timed out
>> [   28.353729] wl1251 spi3.0: EOW timed out
>> [   28.360046] wl1251 spi3.0: EOW timed out
>> [   28.363281] wl1251 spi3.0: EOW timed out
>> [   28.365356] wl1251 spi3.0: EOW timed out
>> [   28.368377] wl1251 spi3.0: EOW timed out
>> [   28.370758] wl1251 spi3.0: EOW timed out
>> [   28.375091] wl1251 spi3.0: EOW timed out
>> [   28.377197] wl1251 spi3.0: EOW timed out
>> [   28.380950] wl1251 spi3.0: EOW timed out
>> [   28.383026] wl1251 spi3.0: EOW timed out
>> [   28.385040] wl1251 spi3.0: EOW timed out
>> [   28.387054] wl1251 spi3.0: EOW timed out
>> [   28.390869] wl1251 spi3.0: EOW timed out
>> [   28.393920] wl1251 spi3.0: EOW timed out
>> [   28.396026] wl1251 spi3.0: EOW timed out
>> [   28.398010] wl1251 spi3.0: EOW timed out
>> [   28.399993] wl1251 spi3.0: EOW timed out
>> [   28.402282] wl1251 spi3.0: EOW timed out
>> [   28.404296] wl1251 spi3.0: EOW timed out
>> [   28.406280] wl1251 spi3.0: EOW timed out
>> [   28.408233] wl1251 spi3.0: EOW timed out
>> [   28.413665] wl1251 spi3.0: EOW timed out
>> [   28.415771] wl1251 spi3.0: EOW timed out
>> [   28.417785] wl1251 spi3.0: EOW timed out
>> [   28.420867] wl1251 spi3.0: EOW timed out
>> [   28.422943] wl1251 spi3.0: EOW timed out
>> [   28.425140] wl1251 spi3.0: EOW timed out
>> [   28.427917] wl1251 spi3.0: EOW timed out
>> [   28.430053] wl1251 spi3.0: EOW timed out
>> [   28.435485] wl1251 spi3.0: EOW timed out
>> [   28.438812] wl1251 spi3.0: EOW timed out
>> [   28.441009] wl1251 spi3.0: EOW timed out
>> [   28.443054] wl1251 spi3.0: EOW timed out
>> [   28.445068] wl1251 spi3.0: EOW timed out
>> [   28.447113] wl1251 spi3.0: EOW timed out
>> [   28.449127] wl1251 spi3.0: EOW timed out
>> [   28.451293] wl1251 spi3.0: EOW timed out
>> [   28.455139] wl1251 spi3.0: EOW timed out
>> [   28.457183] wl1251 spi3.0: EOW timed out
>> [   28.461822] wl1251 spi3.0: EOW timed out
>> [   28.475524] wl1251 spi3.0: EOW timed out
>> [   28.477691] wl1251 spi3.0: EOW timed out
>> [   28.480316] wl1251 spi3.0: EOW timed out
>> [   28.482757] wl1251 spi3.0: EOW timed out
>> [   28.489959] wl1251 spi3.0: EOW timed out
>> [   28.500885] wl1251 spi3.0: EOW timed out
>> [   28.503021] wl1251 spi3.0: EOW timed out
>> [   28.505035] wl1251 spi3.0: EOW timed out
>> [   28.507049] wl1251 spi3.0: EOW timed out
>> [   28.509063] wl1251 spi3.0: EOW timed out
>> [   28.511077] wl1251 spi3.0: EOW timed out
>> [   28.518280] wl1251 spi3.0: EOW timed out
>> [   28.520416] wl1251 spi3.0: EOW timed out
>> [   28.527008] wl1251 spi3.0: EOW timed out
>> [   28.530853] wl1251 spi3.0: EOW timed out
>> [   28.532928] wl1251 spi3.0: EOW timed out
>> [   28.534973] wl1251 spi3.0: EOW timed out
>> [   28.536987] wl1251 spi3.0: EOW timed out
>> [   28.539245] wl1251 spi3.0: EOW timed out
>> [   28.541717] wl1251 spi3.0: EOW timed out
>> [   28.544403] wl1251 spi3.0: EOW timed out
>> [   28.546478] wl1251 spi3.0: EOW timed out
>> [   28.548461] wl1251 spi3.0: EOW timed out
>> [   28.551055] wl1251 spi3.0: EOW timed out
>> [   28.553741] wl1251 spi3.0: EOW timed out
>> [   28.555999] wl1251 spi3.0: EOW timed out
>> [   28.560791] wl1251 spi3.0: EOW timed out
>> [   28.567291] wl1251 spi3.0: EOW timed out
>> [   28.569458] wl1251 spi3.0: EOW timed out
>> [   28.572326] wl1251 spi3.0: EOW timed out
>> [   28.574493] wl1251 spi3.0: EOW timed out
>> [   28.576568] wl1251 spi3.0: EOW timed out
>> [   28.580810] wl1251 spi3.0: EOW timed out
>> [   28.583007] wl1251 spi3.0: EOW timed out
>> [   28.585144] wl1251 spi3.0: EOW timed out
>> [   28.587310] wl1251 spi3.0: EOW timed out
>> [   28.590301] wl1251 spi3.0: EOW timed out
>> [   28.592712] wl1251 spi3.0: EOW timed out
>> [   28.596343] wl1251 spi3.0: EOW timed out
>> [   28.598541] wl1251 spi3.0: EOW timed out
>> [   28.601104] wl1251 spi3.0: EOW timed out
>> [   28.604766] wl1251 spi3.0: EOW timed out
>> [   28.610900] wl1251 spi3.0: EOW timed out
>> [   28.613647] wl1251 spi3.0: EOW timed out
>> [   28.615783] wl1251 spi3.0: EOW timed out
>> [   28.617919] wl1251 spi3.0: EOW timed out
>> [   28.619995] wl1251 spi3.0: EOW timed out
>> [   28.626007] wl1251 spi3.0: EOW timed out
>> [   28.628265] wl1251 spi3.0: EOW timed out
>> [   28.631347] wl1251 spi3.0: EOW timed out
>> [   28.640258] wl1251 spi3.0: EOW timed out
>> [   28.642669] wl1251 spi3.0: EOW timed out
>> [   28.648529] wl1251 spi3.0: EOW timed out
>> [   28.652038] wl1251 spi3.0: EOW timed out
>> [   28.654235] wl1251 spi3.0: EOW timed out
>> [   28.656311] wl1251 spi3.0: EOW timed out
>> [   28.658447] wl1251 spi3.0: EOW timed out
>> [   28.661193] wl1251 spi3.0: EOW timed out
>> [   28.663269] wl1251 spi3.0: EOW timed out
>> [   28.670135] wl1251 spi3.0: EOW timed out
>> [   28.672851] wl1251 spi3.0: EOW timed out
>> [   28.674926] wl1251 spi3.0: EOW timed out
>> [   28.677154] wl1251 spi3.0: EOW timed out
>> [   28.679199] wl1251 spi3.0: EOW timed out
>> [   28.682281] wl1251 spi3.0: EOW timed out
>> [   28.690948] wl1251 spi3.0: EOW timed out
>> [   28.693084] wl1251 spi3.0: EOW timed out
>> [   28.695098] wl1251 spi3.0: EOW timed out
>> [   28.697113] wl1251 spi3.0: EOW timed out
>> [   28.699127] wl1251 spi3.0: EOW timed out
>> [   28.701080] wl1251 spi3.0: EOW timed out
>> [   28.709564] wl1251 spi3.0: EOW timed out
>> [   28.720886] wl1251 spi3.0: EOW timed out
>> [   28.723052] wl1251 spi3.0: EOW timed out
>> [   28.725219] wl1251 spi3.0: EOW timed out
>> [   28.727386] wl1251 spi3.0: EOW timed out
>> [   28.729370] wl1251 spi3.0: EOW timed out
>> [   28.737426] wl1251 spi3.0: EOW timed out
>> [   28.739654] wl1251 spi3.0: EOW timed out
>> [   28.750823] wl1251 spi3.0: EOW timed out
>> [   28.752990] wl1251 spi3.0: EOW timed out
>> [   28.755004] wl1251 spi3.0: EOW timed out
>> [   28.757049] wl1251 spi3.0: EOW timed out
>> [   28.759063] wl1251 spi3.0: EOW timed out
>> [   28.760955] wl1251 spi3.0: EOW timed out
>> [   28.770782] wl1251 spi3.0: EOW timed out
>> [   28.772857] wl1251 spi3.0: EOW timed out
>> [   28.774841] wl1251 spi3.0: EOW timed out
>> [   28.776855] wl1251 spi3.0: EOW timed out
>> [   28.778747] wl1251 spi3.0: EOW timed out
>> [   28.780761] wl1251 spi3.0: EOW timed out
>> [   28.790832] wl1251 spi3.0: EOW timed out
>> [   28.792785] wl1251 spi3.0: EOW timed out
>> [   28.794891] wl1251 spi3.0: EOW timed out
>> [   28.796783] wl1251 spi3.0: EOW timed out
>> [   28.798706] wl1251 spi3.0: EOW timed out
>> [   28.800659] wl1251 spi3.0: EOW timed out
>> [   28.802581] wl1251 spi3.0: EOW timed out
>> [   28.810668] wl1251 spi3.0: EOW timed out
>> [   28.812774] wl1251 spi3.0: EOW timed out
>> [   28.814697] wl1251 spi3.0: EOW timed out
>> [   28.816589] wl1251 spi3.0: EOW timed out
>> [   28.818695] wl1251 spi3.0: EOW timed out
>> [   28.820739] wl1251 spi3.0: EOW timed out
>> [   28.822723] wl1251 spi3.0: EOW timed out
>> [   28.829986] wl1251 spi3.0: EOW timed out
>> [   28.832183] wl1251 spi3.0: EOW timed out
>> [   28.834197] wl1251 spi3.0: EOW timed out
>> [   28.836181] wl1251 spi3.0: EOW timed out
>> [   28.838989] wl1251 spi3.0: EOW timed out
>> [   28.840637] wl1251 spi3.0: EOW timed out
>> [   28.842285] wl1251 spi3.0: EOW timed out
>> [   28.843872] wl1251 spi3.0: EOW timed out
>> [   28.845428] wl1251 spi3.0: EOW timed out
>> [   28.846984] wl1251 spi3.0: EOW timed out
>> [   28.848541] wl1251 spi3.0: EOW timed out
>> [   28.850097] wl1251 spi3.0: EOW timed out
>> [   28.851715] wl1251 spi3.0: EOW timed out
>> [   28.853393] wl1251 spi3.0: EOW timed out
>> [   28.854980] wl1251 spi3.0: EOW timed out
>> [   28.856536] wl1251 spi3.0: EOW timed out
>> [   28.858093] wl1251 spi3.0: EOW timed out
>> [   28.859649] wl1251 spi3.0: EOW timed out
>> [   28.861267] wl1251 spi3.0: EOW timed out
>> [   28.862854] wl1251 spi3.0: EOW timed out
>> [   28.864410] wl1251 spi3.0: EOW timed out
>> [   28.865966] wl1251 spi3.0: EOW timed out
>> [   28.867523] wl1251 spi3.0: EOW timed out
>> [   28.869079] wl1251 spi3.0: EOW timed out
>> [   28.870666] wl1251 spi3.0: EOW timed out
>> [   28.872222] wl1251 spi3.0: EOW timed out
>> [   28.873779] wl1251 spi3.0: EOW timed out
>> [   28.875335] wl1251 spi3.0: EOW timed out
>> [   28.876892] wl1251 spi3.0: EOW timed out
>> [   28.878448] wl1251 spi3.0: EOW timed out
>> [   28.880004] wl1251 spi3.0: EOW timed out
>> [   28.881591] wl1251 spi3.0: EOW timed out
>> [   28.882904] wl1251 spi3.0: EOW timed out
>> [   28.884185] wl1251 spi3.0: EOW timed out
>> [   28.886138] wl1251 spi3.0: EOW timed out
>> [   28.887237] wl1251 spi3.0: EOW timed out
>> [   28.888610] wl1251 spi3.0: EOW timed out
>> [   28.890930] wl1251 spi3.0: EOW timed out
>> [   28.893127] wl1251 spi3.0: EOW timed out
>> [   28.900115] wl1251 spi3.0: EOW timed out
>> [   28.902679] wl1251 spi3.0: EOW timed out
>> [   28.904907] wl1251 spi3.0: EOW timed out
>> [   28.908081] wl1251 spi3.0: EOW timed out
>> [   28.910400] wl1251 spi3.0: EOW timed out
>> [   28.920837] wl1251 spi3.0: EOW timed out
>> [   28.923187] wl1251 spi3.0: EOW timed out
>> [   28.925476] wl1251 spi3.0: EOW timed out
>> [   28.927703] wl1251 spi3.0: EOW timed out
>> [   28.930053] wl1251 spi3.0: EOW timed out
>> [   28.940856] wl1251 spi3.0: EOW timed out
>> [   28.943176] wl1251 spi3.0: EOW timed out
>> [   28.945373] wl1251 spi3.0: EOW timed out
>> [   28.947540] wl1251 spi3.0: EOW timed out
>> [   28.949768] wl1251 spi3.0: EOW timed out
>> [   28.952270] wl1251 spi3.0: EOW timed out
>> [   28.955810] wl1251 spi3.0: EOW timed out
>> [   28.958099] wl1251 spi3.0: EOW timed out
>> [   28.960357] wl1251 spi3.0: EOW timed out
>> [   28.963195] wl1251 spi3.0: EOW timed out
>> [   28.970886] wl1251 spi3.0: EOW timed out
>> [   28.973205] wl1251 spi3.0: EOW timed out
>> [   28.975433] wl1251 spi3.0: EOW timed out
>> [   28.977508] wl1251 spi3.0: EOW timed out
>> [   28.979797] wl1251 spi3.0: EOW timed out
>> [   28.989746] wl1251 spi3.0: EOW timed out
>> [   28.992156] wl1251 spi3.0: EOW timed out
>> [   28.994201] wl1251 spi3.0: EOW timed out
>> [   28.996246] wl1251 spi3.0: EOW timed out
>> [   29.000152] wl1251 spi3.0: EOW timed out
>> [   29.002441] wl1251 spi3.0: EOW timed out
>> [   29.008361] wl1251 spi3.0: EOW timed out
>> [   29.010467] wl1251 spi3.0: EOW timed out
>> [   29.012786] wl1251 spi3.0: EOW timed out
>> [   29.014801] wl1251 spi3.0: EOW timed out
>> [   29.020172] wl1251 spi3.0: EOW timed out
>> [   29.024658] wl1251 spi3.0: EOW timed out
>> [   29.026763] wl1251 spi3.0: EOW timed out
>> [   29.028778] wl1251 spi3.0: EOW timed out
>> [   29.030914] wl1251 spi3.0: EOW timed out
>> [   29.032958] wl1251 spi3.0: EOW timed out
>> [   29.036651] wl1251 spi3.0: EOW timed out
>> [   29.039001] wl1251 spi3.0: EOW timed out
>> [   29.041229] wl1251 spi3.0: EOW timed out
>> [   29.043884] wl1251 spi3.0: EOW timed out
>> [   29.045989] wl1251 spi3.0: EOW timed out
>> [   29.048004] wl1251 spi3.0: EOW timed out
>> [   29.050231] wl1251 spi3.0: EOW timed out
>> [   29.063598] wl1251 spi3.0: EOW timed out
>> [   29.070861] wl1251 spi3.0: EOW timed out
>> [   29.072174] wl1251: ERROR chip id doesn't match after firmware boot
>> [   30.585205] EXT4-fs (mmcblk0p2): re-mounted. Opts: (null)
>> [   38.298400] SSI protocol aka McSAAB added
>> [   38.427978] CMT speech driver added
>> [   38.506958] nokia-modem n900-modem: Registered Nokia HSI modem
>> [   42.001647] SGX clock rate 110 MHz
>> [   45.676727] NET: Registered protocol family 10
>> [   45.711944] Segment Routing with IPv6
>> [   53.900360] using random self ethernet address
>> [   53.912231] using random host ethernet address
>> [   53.943572] usb0: HOST MAC 8e:81:2f:99:ec:36
>> [   53.956573] usb0: MAC f2:99:b7:97:ba:31
>> [   54.373260] configfs-gadget gadget: high-speed config #1: The only one
>> [   54.563568] using random self ethernet address
>> [   54.568939] using random host ethernet address
>> [   54.612243] usb0: HOST MAC 6e:95:7f:5f:6f:45
>> [   54.617523] usb0: MAC b6:a9:66:15:5a:1d
>> [   55.059234] configfs-gadget gadget: high-speed config #1: The only one
>> [   55.066650] IPv6: ADDRCONF(NETDEV_CHANGE): usb0: link becomes ready
>> [   59.141021] Bluetooth: Core ver 2.22
>> [   59.144165] NET: Registered protocol family 31
>> [   59.144195] Bluetooth: HCI device and connection manager initialized
>> [   59.144256] Bluetooth: HCI socket layer initialized
>> [   59.144287] Bluetooth: L2CAP socket layer initialized
>> [   59.144317] Bluetooth: SCO socket layer initialized
>> [   59.277160] Bluetooth: BNEP (Ethernet Emulation) ver 1.3
>> [   59.277191] Bluetooth: BNEP filters: protocol multicast
>> [   59.277252] Bluetooth: BNEP socket layer initialized
>>
> 
> 

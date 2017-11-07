Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f195.google.com ([209.85.192.195]:45248 "EHLO
        mail-pf0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934244AbdKGNb1 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 7 Nov 2017 08:31:27 -0500
Date: Wed, 8 Nov 2017 00:31:15 +1100
From: Simon Shields <simon@lineageos.org>
To: Arend van Spriel <arend.vanspriel@broadcom.com>
Cc: linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        brcm80211-dev-list@cypress.com, devicetree@vger.kernel.org,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Chi-Hsien Lin <chi-hsien.lin@cypress.com>,
        Wright Feng <wright.feng@cypress.com>
Subject: Re: [PATCH] brcmfmac: add support for external 32khz clock
Message-ID: <20171107133112.GA1323@lineageos.org> (sfid-20171107_143138_406141_4655BCD4)
References: <20171104132421.GA1541@archbox.home>
 <5A004099.90200@broadcom.com>
 <20171106112726.GA25134@lineageos.org>
 <5A019463.9060701@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <5A019463.9060701@broadcom.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Arend,

On Tue, Nov 07, 2017 at 12:09:23PM +0100, Arend van Spriel wrote:
> On 11/6/2017 12:27 PM, Simon Shields wrote:
> > On Mon, Nov 06, 2017 at 11:59:37AM +0100, Arend van Spriel wrote:
> > > On 11/4/2017 2:24 PM, Simon Shields wrote:
> > > > Some boards use an external 32khz clock for low-power
> > > > mode timing. Make sure the clock is powered on while the chipset
> > > > is active.
> > > 
> > > Do you have such a board? With the little documentation I can get my hands
> > > on here I wonder whether the clock needs to be enabled before the device is
> > > powered. If you have the hardware I would like to check some registers in
> > > the device.
> > > 
> > 
> > Yes. Trats2 (exynos4412-based) has such a setup. The BCM4334 works fine
> > with this patch and one more that enables the WL_REG_EN pin when
> > brcmfmac is probed.
> 
> Ok. So this is exactly the thing I was wondering about. So it makes me
> curious how the WL_REG_EN patch looks like. Can you provide that?
> 

Here[0] is a link to the patch in its current state. Obviously, it's not
ready at all for mainlining :-)

[0]: https://github.com/fourkbomb/linux/commit/436e59e58b44d856c186fc4767560cecbcbc0c59.patch

> > Without this patch (and only enabling WL_REG_EN), the chip is detected but
> > attempting to initialise it fails with a bunch of timeouts.
> 
> I would be interested in seeing a detailed log of that. Could you provide
> that? You need to build the driver with CONFIG_BRCMDBG and pass module
> parameter 'debug=0x1416' upon insmod/modprobe.

Certainly:

[    0.000000] Booting Linux on physical CPU 0xa00
[    0.000000] Linux version 4.14.0-rc8-16239-g648339c97218-dirty (simon@archbox) (gcc version 7.2.0 (Buildroot 2017.08.1-g57ac0de)) #28 SMP PREEMPT Wed Nov 8 00:19:16 AEDT 2017
[    0.000000] CPU: ARMv7 Processor [413fc090] revision 0 (ARMv7), cr=10c5387d
[    0.000000] CPU: PIPT / VIPT nonaliasing data cache, VIPT aliasing instruction cache
[    0.000000] OF: fdt: Machine model: Samsung T03G (GT-N7100) based on MIDAS
[    0.000000] Memory policy: Data cache writealloc
[    0.000000] cma: Reserved 96 MiB at 0x79c00000
[    0.000000] Samsung CPU ID: 0xe4412211
[    0.000000] On node 0 totalpages: 261632
[    0.000000] free_area_init_node: node 0, pgdat c0c52d40, node_mem_map deff7000
[    0.000000]   Normal zone: 1008 pages used for memmap
[    0.000000]   Normal zone: 0 pages reserved
[    0.000000]   Normal zone: 129024 pages, LIFO batch:31
[    0.000000]   HighMem zone: 132608 pages, LIFO batch:31
[    0.000000] Running under secure firmware.
[    0.000000] random: fast init done
[    0.000000] percpu: Embedded 16 pages/cpu @def70000 s35672 r8192 d21672 u65536
[    0.000000] pcpu-alloc: s35672 r8192 d21672 u65536 alloc=16*4096
[    0.000000] pcpu-alloc: [0] 0 [0] 1 [0] 2 [0] 3 
[    0.000000] Built 1 zonelists, mobility grouping on.  Total pages: 260624
[    0.000000] Kernel command line:  console=ram loglevel=4 sec_debug.level=0 sec_watchdog.sec_pet=5 androidboot.debug_level=0x4f4c sec_log=0x100000@0x46000000 s3cfb.bootloaderfb=0x5ec00000 lcdtype=96 consoleblank=0 lpcharge=0 lpj=3981312 vmalloc=144m oops=panic pmic_info=67 cordon=5c0811cff7d6af7a5dacedab1b4aadf7 connie=GT-I9300_OPEN_EUR_e0f9225b82d5640974bd1e8552938c7d androidboot.emmc_checksum=3 androidboot.odin_download=1 androidboot.bootloader=I9300XXUGMK6 androidboot.serialno=4df7658224facfb9 snd_soc_core.pmdown_time=1000 console=tty0 androidboot.hardware=smdk4x12 androidboot.selinux=permissive vmalloc=512m consoleblank=0
[    0.000000] PID hash table entries: 2048 (order: 1, 8192 bytes)
[    0.000000] Dentry cache hash table entries: 65536 (order: 6, 262144 bytes)
[    0.000000] Inode-cache hash table entries: 32768 (order: 5, 131072 bytes)
[    0.000000] Memory: 924848K/1046528K available (7168K kernel code, 393K rwdata, 2580K rodata, 1024K init, 463K bss, 23376K reserved, 98304K cma-reserved, 432128K highmem)
[    0.000000] Virtual kernel memory layout:
                   vector  : 0xffff0000 - 0xffff1000   (   4 kB)
                   fixmap  : 0xffc00000 - 0xfff00000   (3072 kB)
                   vmalloc : 0xe0000000 - 0xff800000   ( 504 MB)
                   lowmem  : 0xc0000000 - 0xdf800000   ( 504 MB)
                   pkmap   : 0xbfe00000 - 0xc0000000   (   2 MB)
                   modules : 0xbf000000 - 0xbfe00000   (  14 MB)
                     .text : 0xc0008000 - 0xc0800000   (8160 kB)
                     .init : 0xc0b00000 - 0xc0c00000   (1024 kB)
                     .data : 0xc0c00000 - 0xc0c62678   ( 394 kB)
                      .bss : 0xc0c6ad74 - 0xc0cdeb6c   ( 464 kB)
[    0.000000] SLUB: HWalign=64, Order=0-3, MinObjects=0, CPUs=4, Nodes=1
[    0.000000] Preemptible hierarchical RCU implementation.
[    0.000000] 	RCU restricting CPUs from NR_CPUS=8 to nr_cpu_ids=4.
[    0.000000] 	Tasks RCU enabled.
[    0.000000] RCU: Adjusting geometry for rcu_fanout_leaf=16, nr_cpu_ids=4
[    0.000000] NR_IRQS: 16, nr_irqs: 16, preallocated irqs: 16
[    0.000000] L2C: platform modifies aux control register: 0x02070000 -> 0x3e470001
[    0.000000] L2C: platform provided aux values permit register corruption.
[    0.000000] L2C: DT/platform modifies aux control register: 0x02070000 -> 0x3e470001
[    0.000000] L2C-310 enabling early BRESP for Cortex-A9
[    0.000000] L2C-310: enabling full line of zeros but not enabled in Cortex-A9
[    0.000000] L2C-310 ID prefetch enabled, offset 8 lines
[    0.000000] L2C-310 dynamic clock gating enabled, standby mode enabled
[    0.000000] L2C-310 cache controller enabled, 16 ways, 1024 kB
[    0.000000] L2C-310: CACHE_ID 0x4100c4c8, AUX_CTRL 0x7e470001
[    0.000000] Exynos4x12 clocks: sclk_apll = 400000000, sclk_mpll = 800000000
               	sclk_epll = 96000000, sclk_vpll = 108000000, arm_clk = 800000000
[    0.000000] Switching to timer-based delay loop, resolution 41ns
[    0.000000] clocksource: mct-frc: mask: 0xffffffff max_cycles: 0xffffffff, max_idle_ns: 79635851949 ns
[    0.000005] sched_clock: 32 bits at 24MHz, resolution 41ns, wraps every 89478484971ns
[    0.000307] Console: colour dummy device 80x30
[    0.000351] console [tty0] enabled
[    0.000373] Calibrating delay loop (skipped) preset value.. 796.26 BogoMIPS (lpj=3981312)
[    0.000385] pid_max: default: 32768 minimum: 301
[    0.000460] Security Framework initialized
[    0.000467] SELinux:  Initializing.
[    0.000533] SELinux:  Starting in permissive mode
[    0.000571] Mount-cache hash table entries: 1024 (order: 0, 4096 bytes)
[    0.000579] Mountpoint-cache hash table entries: 1024 (order: 0, 4096 bytes)
[    0.001181] CPU: Testing write buffer coherency: ok
[    0.001680] CPU0: thread -1, cpu 0, socket 10, mpidr 80000a00
[    0.040040] Setting up static identity map for 0x40100000 - 0x40100060
[    0.060002] Hierarchical SRCU implementation.
[    0.100003] smp: Bringing up secondary CPUs ...
[    0.170431] CPU1: thread -1, cpu 1, socket 10, mpidr 80000a01
[    0.240358] CPU2: thread -1, cpu 2, socket 10, mpidr 80000a02
[    0.310334] CPU3: thread -1, cpu 3, socket 10, mpidr 80000a03
[    0.310439] smp: Brought up 1 node, 4 CPUs
[    0.310448] SMP: Total of 4 processors activated (3185.04 BogoMIPS).
[    0.310453] CPU: All CPU(s) started in SVC mode.
[    0.311319] devtmpfs: initialized
[    0.328843] VFP support v0.3: implementor 41 architecture 3 part 30 variant 9 rev 4
[    0.329097] clocksource: jiffies: mask: 0xffffffff max_cycles: 0xffffffff, max_idle_ns: 19112604462750000 ns
[    0.329114] futex hash table entries: 1024 (order: 4, 65536 bytes)
[    0.332515] pinctrl core: initialized pinctrl subsystem
[    0.333481] /lcd0-power-domain@10023C80 has as child subdomain: /tv-power-domain@10023C20.
[    0.334606] NET: Registered protocol family 16
[    0.337012] DMA: preallocated 256 KiB pool for atomic coherent allocations
[    0.338217] cpuidle: using governor menu
[    0.353786] gpio gpiochip0: (gpa0): added GPIO chardev (254:0)
[    0.353796] gpiochip_setup_dev: registered GPIOs 0 to 7 on device: gpiochip0 (gpa0)
[    0.353948] gpio gpiochip1: (gpa1): added GPIO chardev (254:1)
[    0.353957] gpiochip_setup_dev: registered GPIOs 8 to 13 on device: gpiochip1 (gpa1)
[    0.354102] gpio gpiochip2: (gpb): added GPIO chardev (254:2)
[    0.354110] gpiochip_setup_dev: registered GPIOs 14 to 21 on device: gpiochip2 (gpb)
[    0.354244] gpio gpiochip3: (gpc0): added GPIO chardev (254:3)
[    0.354252] gpiochip_setup_dev: registered GPIOs 22 to 26 on device: gpiochip3 (gpc0)
[    0.354397] gpio gpiochip4: (gpc1): added GPIO chardev (254:4)
[    0.354405] gpiochip_setup_dev: registered GPIOs 27 to 31 on device: gpiochip4 (gpc1)
[    0.354541] gpio gpiochip5: (gpd0): added GPIO chardev (254:5)
[    0.354549] gpiochip_setup_dev: registered GPIOs 32 to 35 on device: gpiochip5 (gpd0)
[    0.354690] gpio gpiochip6: (gpd1): added GPIO chardev (254:6)
[    0.354698] gpiochip_setup_dev: registered GPIOs 36 to 39 on device: gpiochip6 (gpd1)
[    0.354833] gpio gpiochip7: (gpf0): added GPIO chardev (254:7)
[    0.354841] gpiochip_setup_dev: registered GPIOs 40 to 47 on device: gpiochip7 (gpf0)
[    0.354982] gpio gpiochip8: (gpf1): added GPIO chardev (254:8)
[    0.354990] gpiochip_setup_dev: registered GPIOs 48 to 55 on device: gpiochip8 (gpf1)
[    0.355136] gpio gpiochip9: (gpf2): added GPIO chardev (254:9)
[    0.355144] gpiochip_setup_dev: registered GPIOs 56 to 63 on device: gpiochip9 (gpf2)
[    0.355278] gpio gpiochip10: (gpf3): added GPIO chardev (254:10)
[    0.355286] gpiochip_setup_dev: registered GPIOs 64 to 69 on device: gpiochip10 (gpf3)
[    0.355441] gpio gpiochip11: (gpj0): added GPIO chardev (254:11)
[    0.355449] gpiochip_setup_dev: registered GPIOs 70 to 77 on device: gpiochip11 (gpj0)
[    0.355584] gpio gpiochip12: (gpj1): added GPIO chardev (254:12)
[    0.355592] gpiochip_setup_dev: registered GPIOs 78 to 82 on device: gpiochip12 (gpj1)
[    0.359090] gpio gpiochip13: (gpk0): added GPIO chardev (254:13)
[    0.359100] gpiochip_setup_dev: registered GPIOs 83 to 89 on device: gpiochip13 (gpk0)
[    0.359248] gpio gpiochip14: (gpk1): added GPIO chardev (254:14)
[    0.359256] gpiochip_setup_dev: registered GPIOs 90 to 96 on device: gpiochip14 (gpk1)
[    0.359392] gpio gpiochip15: (gpk2): added GPIO chardev (254:15)
[    0.359400] gpiochip_setup_dev: registered GPIOs 97 to 103 on device: gpiochip15 (gpk2)
[    0.359533] gpio gpiochip16: (gpk3): added GPIO chardev (254:16)
[    0.359541] gpiochip_setup_dev: registered GPIOs 104 to 110 on device: gpiochip16 (gpk3)
[    0.359681] gpio gpiochip17: (gpl0): added GPIO chardev (254:17)
[    0.359689] gpiochip_setup_dev: registered GPIOs 111 to 117 on device: gpiochip17 (gpl0)
[    0.359823] gpio gpiochip18: (gpl1): added GPIO chardev (254:18)
[    0.359831] gpiochip_setup_dev: registered GPIOs 118 to 119 on device: gpiochip18 (gpl1)
[    0.359975] gpio gpiochip19: (gpl2): added GPIO chardev (254:19)
[    0.360020] gpiochip_setup_dev: registered GPIOs 120 to 127 on device: gpiochip19 (gpl2)
[    0.360161] gpio gpiochip20: (gpm0): added GPIO chardev (254:20)
[    0.360170] gpiochip_setup_dev: registered GPIOs 128 to 135 on device: gpiochip20 (gpm0)
[    0.360313] gpio gpiochip21: (gpm1): added GPIO chardev (254:21)
[    0.360321] gpiochip_setup_dev: registered GPIOs 136 to 142 on device: gpiochip21 (gpm1)
[    0.360465] gpio gpiochip22: (gpm2): added GPIO chardev (254:22)
[    0.360473] gpiochip_setup_dev: registered GPIOs 143 to 147 on device: gpiochip22 (gpm2)
[    0.360609] gpio gpiochip23: (gpm3): added GPIO chardev (254:23)
[    0.360617] gpiochip_setup_dev: registered GPIOs 148 to 155 on device: gpiochip23 (gpm3)
[    0.360765] gpio gpiochip24: (gpm4): added GPIO chardev (254:24)
[    0.360773] gpiochip_setup_dev: registered GPIOs 156 to 163 on device: gpiochip24 (gpm4)
[    0.360906] gpio gpiochip25: (gpy0): added GPIO chardev (254:25)
[    0.360914] gpiochip_setup_dev: registered GPIOs 164 to 169 on device: gpiochip25 (gpy0)
[    0.361048] gpio gpiochip26: (gpy1): added GPIO chardev (254:26)
[    0.361056] gpiochip_setup_dev: registered GPIOs 170 to 173 on device: gpiochip26 (gpy1)
[    0.361204] gpio gpiochip27: (gpy2): added GPIO chardev (254:27)
[    0.361212] gpiochip_setup_dev: registered GPIOs 174 to 179 on device: gpiochip27 (gpy2)
[    0.361346] gpio gpiochip28: (gpy3): added GPIO chardev (254:28)
[    0.361354] gpiochip_setup_dev: registered GPIOs 180 to 187 on device: gpiochip28 (gpy3)
[    0.361510] gpio gpiochip29: (gpy4): added GPIO chardev (254:29)
[    0.361518] gpiochip_setup_dev: registered GPIOs 188 to 195 on device: gpiochip29 (gpy4)
[    0.361661] gpio gpiochip30: (gpy5): added GPIO chardev (254:30)
[    0.361670] gpiochip_setup_dev: registered GPIOs 196 to 203 on device: gpiochip30 (gpy5)
[    0.361804] gpio gpiochip31: (gpy6): added GPIO chardev (254:31)
[    0.361812] gpiochip_setup_dev: registered GPIOs 204 to 211 on device: gpiochip31 (gpy6)
[    0.361953] gpio gpiochip32: (gpx0): added GPIO chardev (254:32)
[    0.361962] gpiochip_setup_dev: registered GPIOs 212 to 219 on device: gpiochip32 (gpx0)
[    0.362103] gpio gpiochip33: (gpx1): added GPIO chardev (254:33)
[    0.362111] gpiochip_setup_dev: registered GPIOs 220 to 227 on device: gpiochip33 (gpx1)
[    0.362255] gpio gpiochip34: (gpx2): added GPIO chardev (254:34)
[    0.362264] gpiochip_setup_dev: registered GPIOs 228 to 235 on device: gpiochip34 (gpx2)
[    0.362398] gpio gpiochip35: (gpx3): added GPIO chardev (254:35)
[    0.362406] gpiochip_setup_dev: registered GPIOs 236 to 243 on device: gpiochip35 (gpx3)
[    0.364251] gpio gpiochip36: (gpz): added GPIO chardev (254:36)
[    0.364261] gpiochip_setup_dev: registered GPIOs 244 to 250 on device: gpiochip36 (gpz)
[    0.364274] genirq: irq_chip COMBINER did not update eff. affinity mask of irq 109
[    0.365522] gpio gpiochip37: (gpv0): added GPIO chardev (254:37)
[    0.365531] gpiochip_setup_dev: registered GPIOs 251 to 258 on device: gpiochip37 (gpv0)
[    0.365669] gpio gpiochip38: (gpv1): added GPIO chardev (254:38)
[    0.365678] gpiochip_setup_dev: registered GPIOs 259 to 266 on device: gpiochip38 (gpv1)
[    0.365832] gpio gpiochip39: (gpv2): added GPIO chardev (254:39)
[    0.365840] gpiochip_setup_dev: registered GPIOs 267 to 274 on device: gpiochip39 (gpv2)
[    0.365975] gpio gpiochip40: (gpv3): added GPIO chardev (254:40)
[    0.365983] gpiochip_setup_dev: registered GPIOs 275 to 282 on device: gpiochip40 (gpv3)
[    0.366130] gpio gpiochip41: (gpv4): added GPIO chardev (254:41)
[    0.366139] gpiochip_setup_dev: registered GPIOs 283 to 284 on device: gpiochip41 (gpv4)
[    0.380631] of_get_named_gpiod_flags: parsed 'gpio' property of node '/regulators/voltage-regulator-0[0]' - status (0)
[    0.380935] of_get_named_gpiod_flags: parsed 'gpio' property of node '/regulators/voltage-regulator-1[0]' - status (0)
[    0.381213] of_get_named_gpiod_flags: parsed 'gpio' property of node '/regulators/voltage-regulator-2[0]' - status (0)
[    0.382036] SCSI subsystem initialized
[    0.382241] usbcore: registered new interface driver usbfs
[    0.382283] usbcore: registered new interface driver hub
[    0.382371] usbcore: registered new device driver usb
[    0.382754] of_get_named_gpiod_flags: parsed 'gpios' property of node '/i2c-gpio-0[0]' - status (0)
[    0.382794] of_get_named_gpiod_flags: parsed 'gpios' property of node '/i2c-gpio-0[1]' - status (0)
[    0.383025] i2c-gpio i2c-gpio-0: using pins 143 (SDA) and 144 (SCL)
[    0.383130] of_get_named_gpiod_flags: parsed 'gpios' property of node '/i2c-gpio-1[0]' - status (0)
[    0.383156] of_get_named_gpiod_flags: parsed 'gpios' property of node '/i2c-gpio-1[1]' - status (0)
[    0.383368] i2c-gpio i2c-gpio-1: using pins 53 (SDA) and 52 (SCL)
[    0.383834] s3c-i2c 138a0000.i2c: slave address 0x10
[    0.383845] s3c-i2c 138a0000.i2c: bus frequency set to 97 KHz
[    0.384187] s3c-i2c 138a0000.i2c: i2c-4: S3C I2C adapter
[    0.384436] s3c-i2c 138d0000.i2c: slave address 0x10
[    0.384447] s3c-i2c 138d0000.i2c: bus frequency set to 97 KHz
[    0.384762] s3c-i2c 138d0000.i2c: i2c-7: S3C I2C adapter
[    0.385599] Advanced Linux Sound Architecture Driver Initialized.
[    0.387236] clocksource: Switched to clocksource mct-frc
[    0.387335] VFS: Disk quotas dquot_6.6.0
[    0.387397] VFS: Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
[    0.396505] NET: Registered protocol family 2
[    0.397040] TCP established hash table entries: 4096 (order: 2, 16384 bytes)
[    0.397089] TCP bind hash table entries: 4096 (order: 4, 81920 bytes)
[    0.397177] TCP: Hash tables configured (established 4096 bind 4096)
[    0.397329] UDP hash table entries: 256 (order: 1, 12288 bytes)
[    0.397356] UDP-Lite hash table entries: 256 (order: 1, 12288 bytes)
[    0.397533] NET: Registered protocol family 1
[    0.397783] Trying to unpack rootfs image as initramfs...
[    1.581644] Freeing initrd memory: 1968K
[    1.583150] audit: initializing netlink subsys (disabled)
[    1.583327] audit: type=2000 audit(1.570:1): state=initialized audit_enabled=0 res=1
[    1.583474] workingset: timestamp_bits=30 max_order=18 bucket_order=0
[    1.588830] romfs: ROMFS MTD (C) 2007 Red Hat, Inc.
[    1.589082] fuse init (API version 7.26)
[    1.589441] SELinux:  Registering netfilter hooks
[    1.593599] bounce: pool size: 64 pages
[    1.593652] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 248)
[    1.593660] io scheduler noop registered
[    1.593666] io scheduler deadline registered
[    1.593785] io scheduler cfq registered (default)
[    1.593791] io scheduler mq-deadline registered
[    1.593797] io scheduler kyber registered
[    1.601487] dma-pl330 12680000.pdma: Loaded driver for PL330 DMAC-141330
[    1.601499] dma-pl330 12680000.pdma: 	DBUFF-32x4bytes Num_Chans-8 Num_Peri-32 Num_Events-32
[    1.603911] dma-pl330 12690000.pdma: Loaded driver for PL330 DMAC-141330
[    1.603922] dma-pl330 12690000.pdma: 	DBUFF-32x4bytes Num_Chans-8 Num_Peri-32 Num_Events-32
[    1.604765] dma-pl330 12850000.mdma: Loaded driver for PL330 DMAC-141330
[    1.604776] dma-pl330 12850000.mdma: 	DBUFF-64x8bytes Num_Chans-8 Num_Peri-1 Num_Events-32
[    1.664958] Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
[    1.667318] 13800000.serial: ttySAC0 at MMIO 0x13800000 (irq = 58, base_baud = 0) is a S3C6400/10
[    1.667767] 13810000.serial: ttySAC1 at MMIO 0x13810000 (irq = 59, base_baud = 0) is a S3C6400/10
[    1.668160] 13820000.serial: ttySAC2 at MMIO 0x13820000 (irq = 60, base_baud = 0) is a S3C6400/10
[    1.668543] 13830000.serial: ttySAC3 at MMIO 0x13830000 (irq = 61, base_baud = 0) is a S3C6400/10
[    1.670015] OF: graph: no port node found in /fimd@11c00000
[    1.672174] [drm] Exynos DRM: using 11c00000.fimd device for DMA mapping operations
[    1.672287] exynos-drm exynos-drm: bound 11c00000.fimd (ops fimd_component_ops)
[    1.672293] [drm] Supports vblank timestamp caching Rev 2 (21.10.2013).
[    1.672297] [drm] No driver support for vblank timestamp query.
[    1.672767] [drm] Initialized exynos 1.0.0 20110530 for exynos-drm on minor 0
[    1.683000] brd: module loaded
[    1.690941] loop: module loaded
[    1.691202] of_get_named_gpiod_flags: parsed 'wlf,ldo1ena' property of node '/i2c@138A0000/wm1811@1a[0]' - status (0)
[    1.691214] of_get_named_gpiod_flags: can't parse 'wlf,ldo2ena' property of node '/i2c@138A0000/wm1811@1a[0]'
[    1.692446] wm8994 4-001a: Failed to get supply 'DBVDD1': -517
[    1.692474] wm8994 4-001a: Failed to get supplies: -517
[    1.703645] VMPLL_1.0V_AP: Bringing 1100000uV into 1000000-1000000uV
[    1.707962] VPLL_1.0V_AP: Bringing 1100000uV into 1000000-1000000uV
[    1.713759] CAM_ISP_MIPI_1.2V: Bringing 1800000uV into 1200000-1200000uV
[    1.718398] VABB1_1.95V: Bringing 1800000uV into 1950000-1950000uV
[    1.726045] VABB2_1.95V: Bringing 1800000uV into 1950000-1950000uV
[    1.735778] of_get_named_gpiod_flags: can't parse 'maxim,ena-gpios' property of node '/i2c@138D0000/max77686_pmic@09/voltage-regulators/LDO20[0]'
[    1.736958] of_get_named_gpiod_flags: parsed 'maxim,ena-gpios' property of node '/i2c@138D0000/max77686_pmic@09/voltage-regulators/LDO21[0]' - status (0)
[    1.738551] of_get_named_gpiod_flags: parsed 'maxim,ena-gpios' property of node '/i2c@138D0000/max77686_pmic@09/voltage-regulators/LDO22[0]' - status (0)
[    1.741631] TSP_VDD_1.8V: Bringing 2200000uV into 1800000-1800000uV
[    1.744774] LCD_VCC_3.3V: Bringing 3300000uV into 2800000-2800000uV
[    1.765959] of_get_named_gpiod_flags: parsed 'maxim,ena-gpios' property of node '/i2c@138D0000/max77686_pmic@09/voltage-regulators/BUCK8[0]' - status (0)
[    1.766857] VMEM_VDDF_3.0V: Bringing 3000000uV into 2850000-2850000uV
[    1.769239] of_get_named_gpiod_flags: parsed 'maxim,ena-gpios' property of node '/i2c@138D0000/max77686_pmic@09/voltage-regulators/BUCK9[0]' - status (0)
[    1.772374] max77693 9-0066: device ID: 0x4
[    1.780763] s3c64xx-spi 13930000.spi: spi bus clock parent not specified, using clock at index 0 as parent
[    1.780774] s3c64xx-spi 13930000.spi: number of chip select lines not specified, assuming 1 chip select line
[    1.781167] of_get_named_gpiod_flags: parsed 'cs-gpios' property of node '/spi@13930000[0]' - status (0)
[    1.782249] mdio_bus fixed-0: GPIO lookup for consumer reset
[    1.782258] mdio_bus fixed-0: using lookup tables for GPIO lookup
[    1.782266] mdio_bus fixed-0: lookup for GPIO reset failed
[    1.782285] libphy: Fixed MDIO Bus: probed
[    1.782291] tun: Universal TUN/TAP device driver, 1.6
[    1.782507] PPP generic driver version 2.4.2
[    1.782675] PPP BSD Compression module registered
[    1.782681] PPP Deflate Compression module registered
[    1.782696] PPP MPPE Compression module registered
[    1.782847] brcmfmac: brcmfmac_module_init No platform data available.
[    1.783232] usbcore: registered new interface driver r8152
[    1.783345] usbcore: registered new interface driver asix
[    1.783389] usbcore: registered new interface driver ax88179_178a
[    1.783430] usbcore: registered new interface driver cdc_ether
[    1.783472] usbcore: registered new interface driver smsc75xx
[    1.783514] usbcore: registered new interface driver smsc95xx
[    1.783548] usbcore: registered new interface driver net1080
[    1.783581] usbcore: registered new interface driver cdc_subset
[    1.783612] usbcore: registered new interface driver zaurus
[    1.783666] usbcore: registered new interface driver cdc_ncm
[    1.783958] dwc2 12480000.hsotg: mapped PA 12480000 to VA e0920000
[    1.784472] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    1.784496] ehci-exynos: EHCI EXYNOS driver
[    1.784796] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    1.784819] ohci-exynos: OHCI EXYNOS driver
[    1.785152] usbcore: registered new interface driver usb-storage
[    1.785239] gadgetfs: USB Gadget filesystem, version 24 Aug 2004
[    1.786135] input: max77693-haptic as /devices/platform/i2c-gpio-0/i2c-9/9-0066/max77693-haptic/input/input0
[    1.919336] max77686-rtc max77686-rtc: rtc core: registered max77686-rtc as rtc0
[    1.921098] s3c-rtc 10070000.rtc: rtc disabled, re-enabling
[    1.921151] s3c-rtc 10070000.rtc: warning: invalid RTC value so initializing it
[    1.921202] rtc rtc1: invalid alarm value: 1900-1-1 0:0:0
[    1.921381] s3c-rtc 10070000.rtc: rtc core: registered s3c as rtc1
[    1.921843] i2c /dev entries driver
[    1.923122] IR NEC protocol handler initialized
[    1.923127] IR RC5(x/sz) protocol handler initialized
[    1.923132] IR RC6 protocol handler initialized
[    1.923136] IR JVC protocol handler initialized
[    1.923140] IR Sony protocol handler initialized
[    1.923144] IR SANYO protocol handler initialized
[    1.923148] IR Sharp protocol handler initialized
[    1.923152] IR MCE Keyboard/mouse protocol handler initialized
[    1.923157] IR XMP protocol handler initialized
[    1.925589] (NULL device *): hwmon_device_register() is deprecated. Please convert the driver to use hwmon_device_register_with_info().
[    1.926333] max17042 10-0036: SOC threshold INTR
[    1.954629] s3c2410-wdt 10060000.watchdog: watchdog inactive, reset disabled, irq disabled
[    1.955187] device-mapper: ioctl: 4.37.0-ioctl (2017-09-20) initialised: dm-devel@redhat.com
[    1.959817] sdhci: Secure Digital Host Controller Interface driver
[    1.959823] sdhci: Copyright(c) Pierre Ossman
[    1.960270] of_get_named_gpiod_flags: parsed 'cd-gpios' property of node '/sdhci@12530000[0]' - status (0)
[    1.960429] s3c-sdhci 12530000.sdhci: clock source 2: mmc_busclk.2 (50000000 Hz)
[    1.960472] s3c-sdhci 12530000.sdhci: GPIO lookup for consumer cd
[    1.960480] s3c-sdhci 12530000.sdhci: using device tree for GPIO lookup
[    1.960520] of_get_named_gpiod_flags: parsed 'cd-gpios' property of node '/sdhci@12530000[0]' - status (0)
[    1.960541] s3c-sdhci 12530000.sdhci: Got CD GPIO
[    1.960550] s3c-sdhci 12530000.sdhci: GPIO lookup for consumer wp
[    1.960557] s3c-sdhci 12530000.sdhci: using device tree for GPIO lookup
[    1.960566] of_get_named_gpiod_flags: can't parse 'wp-gpios' property of node '/sdhci@12530000[0]'
[    1.960576] of_get_named_gpiod_flags: can't parse 'wp-gpio' property of node '/sdhci@12530000[0]'
[    1.960583] s3c-sdhci 12530000.sdhci: using lookup tables for GPIO lookup
[    1.960591] s3c-sdhci 12530000.sdhci: lookup for GPIO wp failed
[    2.018318] mmc0: SDHCI controller on samsung-hsmmc [12530000.sdhci] using ADMA
[    2.020256] s3c-sdhci 12540000.sdhci: clock source 2: mmc_busclk.2 (40000000 Hz)
[    2.020395] s3c-sdhci 12540000.sdhci: GPIO lookup for consumer cd
[    2.020427] s3c-sdhci 12540000.sdhci: using device tree for GPIO lookup
[    2.020474] of_get_named_gpiod_flags: can't parse 'cd-gpios' property of node '/sdhci@12540000[0]'
[    2.020513] of_get_named_gpiod_flags: can't parse 'cd-gpio' property of node '/sdhci@12540000[0]'
[    2.020542] s3c-sdhci 12540000.sdhci: using lookup tables for GPIO lookup
[    2.020573] s3c-sdhci 12540000.sdhci: lookup for GPIO cd failed
[    2.020609] s3c-sdhci 12540000.sdhci: GPIO lookup for consumer wp
[    2.020634] s3c-sdhci 12540000.sdhci: using device tree for GPIO lookup
[    2.020671] of_get_named_gpiod_flags: can't parse 'wp-gpios' property of node '/sdhci@12540000[0]'
[    2.020705] of_get_named_gpiod_flags: can't parse 'wp-gpio' property of node '/sdhci@12540000[0]'
[    2.020730] s3c-sdhci 12540000.sdhci: using lookup tables for GPIO lookup
[    2.020757] s3c-sdhci 12540000.sdhci: lookup for GPIO wp failed
[    2.077438] mmc1: SDHCI controller on samsung-hsmmc [12540000.sdhci] using ADMA
[    2.078046] Synopsys Designware Multimedia Card Interface Driver
[    2.083469] dwmmc_exynos 12550000.mmc: 'num-slots' was deprecated.
[    2.083964] dwmmc_exynos 12550000.mmc: IDMAC supports 32-bit address mode.
[    2.084133] dwmmc_exynos 12550000.mmc: Using internal DMA controller.
[    2.084157] dwmmc_exynos 12550000.mmc: Version ID is 240a
[    2.084256] dwmmc_exynos 12550000.mmc: DW MMC controller at irq 117,32 bit host data width,128 deep fifo
[    2.084637] dwmmc_exynos 12550000.mmc: GPIO lookup for consumer wp
[    2.084706] dwmmc_exynos 12550000.mmc: using device tree for GPIO lookup
[    2.084733] of_get_named_gpiod_flags: can't parse 'wp-gpios' property of node '/mmc@12550000[0]'
[    2.084752] of_get_named_gpiod_flags: can't parse 'wp-gpio' property of node '/mmc@12550000[0]'
[    2.084767] dwmmc_exynos 12550000.mmc: using lookup tables for GPIO lookup
[    2.084784] dwmmc_exynos 12550000.mmc: lookup for GPIO wp failed
[    2.084867] mmc_host mmc2: card is non-removable.
[    2.097508] mmc1: queuing unknown CIS tuple 0x80 (7 bytes)
[    2.100081] mmc1: queuing unknown CIS tuple 0x80 (6 bytes)
[    2.107332] mmc_host mmc2: Bus speed (slot 0) = 50000000Hz (slot req 400000Hz, actual 396825HZ div = 63)
[    2.142700] max77693-led max77693-led: No DT child node found for connected LED(s).
[    2.142768] max77693-led: probe of max77693-led failed with error -22
[    2.145810] s5p-secss 10830000.sss: s5p-sss driver registered
[    2.146489] usbcore: registered new interface driver usbhid
[    2.146494] usbhid: USB HID core driver
[    2.146981] ashmem: initialized
[    2.159701] exynos-ppmu: new PPMU device registered 106a0000.ppmu_dmc0 (ppmu-event3-dmc0)
[    2.159894] exynos-ppmu: new PPMU device registered 106b0000.ppmu_dmc1 (ppmu-event3-dmc1)
[    2.160064] exynos-ppmu: new PPMU device registered 112a0000.ppmu_rightbus (ppmu-event3-rightbus)
[    2.160243] exynos-ppmu: new PPMU device registered 116a0000.ppmu_leftbus0 (ppmu-event3-leftbus)
[    2.160592] input: max77693-muic/dock as /devices/platform/i2c-gpio-0/i2c-9/9-0066/max77693-muic/input/input1
[    2.177561] mmc1: new high speed SDIO card at address 0001
[    2.178028] brcmfmac: brcmf_sdio_probe Enter
[    2.178200] brcmfmac: F1 signature read @0x18000000=0x16034334
[    2.178426] brcmfmac: brcmf_chip_recognition found AXI chip: BCM4334, rev=3
[    2.180290] brcmfmac: brcmf_chip_cores_check  [1 ] core 0x800:41 base 0x18000000 wrap 0x18100000
[    2.180296] brcmfmac: brcmf_chip_cores_check  [2 ] core 0x812:35 base 0x18001000 wrap 0x18101000
[    2.180301] brcmfmac: brcmf_chip_cores_check  [3 ] core 0x829:13 base 0x18002000 wrap 0x18102000
[    2.180306] brcmfmac: brcmf_chip_cores_check  [4 ] core 0x82a:7  base 0x18003000 wrap 0x18103000
[    2.180311] brcmfmac: brcmf_chip_cores_check  [5 ] core 0x80e:19 base 0x18004000 wrap 0x18104000
[    2.180315] brcmfmac: brcmf_chip_cores_check  [6 ] core 0x81a:14 base 0x18005000 wrap 0x18105000
[    2.180320] brcmfmac: brcmf_chip_cores_check  [7 ] core 0x135:0  base 0x00000000 wrap 0x18106000
[    2.180324] brcmfmac: brcmf_chip_cores_check  [8 ] core 0x135:0  base 0x00000000 wrap 0x18107000
[    2.180328] brcmfmac: brcmf_chip_cores_check  [9 ] core 0x240:0  base 0x00000000 wrap 0x18108000
[    2.180331] brcmfmac: brcmf_chip_set_passive Enter
[    2.181379] brcmfmac: brcmf_chip_get_raminfo RAM: base=0x0 size=524288 (0x80000) sr=32768 (0x8000)
[    2.181451] brcmfmac: brcmf_chip_setup ccrev=41, pmurev=17, pmucaps=0x218e5f11
[    2.181456] brcmfmac: brcmf_get_module_param Enter, bus=0, chip=17204, rev=3
[    2.181556] brcmfmac: brcmf_sdiod_sgtable_alloc nents=35
[    2.181562] brcmfmac: brcmf_sdio_kso_init Enter
[    2.181657] brcmfmac: brcmf_sdio_drivestrengthinit SDIO: 3 mA (req=6 mA) drive strength selected, set to 0x00001801
[    2.181802] brcmfmac: brcmf_attach Enter
[    2.181836] brcmfmac: brcmf_proto_attach Enter
[    2.181846] brcmfmac: brcmf_fweh_register event handler registered for PSM_WATCHDOG
[    2.181937] brcmfmac: brcmf_sdio_probe completed!!
[    2.181945] brcmfmac: brcmf_fw_map_chip_to_name: using brcm/brcmfmac4334-sdio.bin for chip 0x004334(17204) rev 0x000003
[    2.181963] brcmfmac: brcmf_fw_get_firmwares_pcie enter: dev=mmc1:0001:1
[    2.182796] brcmfmac: brcmf_fw_request_code_done enter: dev=mmc1:0001:1
[    2.182906] brcmfmac: brcmf_fw_request_nvram_done enter: dev=mmc1:0001:1
[    2.182993] brcmfmac: brcmf_sdio_firmware_callback Enter: dev=mmc1:0001:1, err=0
[    2.183083] brcmfmac: brcmf_sdio_download_code_file Enter
[    2.191710] max77693-muic max77693-muic: CONTROL1 : 0x09, CONTROL2 : 0x04, state : attached
[    2.191993] mmc_host mmc2: Bus speed (slot 0) = 50000000Hz (slot req 52000000Hz, actual 50000000HZ div = 0)
[    2.192209] mmc2: new DDR MMC card at address 0001
[    2.192489] max77693-muic max77693-muic: device ID : 0x8d
[    2.192514] mmcblk2: mmc2:0001 VTU00M 14.7 GiB 
[    2.192763] mmcblk2boot0: mmc2:0001 VTU00M partition 1 2.00 MiB
[    2.192873] mmcblk2boot1: mmc2:0001 VTU00M partition 2 2.00 MiB
[    2.192969] mmcblk2rpmb: mmc2:0001 VTU00M partition 3 128 KiB
[    2.196344]  mmcblk2: p1 p2 p3 p4 p5 p6 p7 p8 p9 p10 p11 p12
[    2.200494] u32 classifier
[    2.200498]     Actions configured
[    2.200505] Netfilter messages via NETLINK v0.30.
[    2.200659] nf_conntrack version 0.5.0 (16384 buckets, 65536 max)
[    2.201013] ctnetlink v0.93: registering with nfnetlink.
[    2.201263] xt_time: kernel timezone is -0000
[    2.201448] ip_tables: (C) 2000-2006 Netfilter Core Team
[    2.201825] arp_tables: arp_tables: (C) 2002 David S. Miller
[    2.201889] Initializing XFRM netlink socket
[    2.202154] NET: Registered protocol family 10
[    2.202962] Segment Routing with IPv6
[    2.203004] mip6: Mobile IPv6
[    2.203020] ip6_tables: (C) 2000-2006 Netfilter Core Team
[    2.203267] sit: IPv6, IPv4 and MPLS over IPv4 tunneling driver
[    2.203617] NET: Registered protocol family 17
[    2.203631] NET: Registered protocol family 15
[    2.203647] Key type dns_resolver registered
[    2.204058] Registering SWP/SWPB emulation handler
[    2.204881] registered taskstats version 1
[    2.209614] Key type encrypted registered
[    2.217614] brcmfmac: brcmf_sdio_verifymemory Compare RAM dl & ul at 0x00000000; size=451566
[    2.232041] of_get_named_gpiod_flags: parsed 'wlf,ldo1ena' property of node '/i2c@138A0000/wm1811@1a[0]' - status (0)
[    2.232052] of_get_named_gpiod_flags: can't parse 'wlf,ldo2ena' property of node '/i2c@138A0000/wm1811@1a[0]'
[    2.233616] wm8994 4-001a: 4-001a supply DBVDD2 not found, using dummy regulator
[    2.233668] wm8994 4-001a: 4-001a supply DBVDD3 not found, using dummy regulator
[    2.234209] wm8994 4-001a: 4-001a supply AVDD2 not found, using dummy regulator
[    2.234254] wm8994 4-001a: 4-001a supply CPVDD not found, using dummy regulator
[    2.234297] wm8994 4-001a: 4-001a supply SPKVDD1 not found, using dummy regulator
[    2.234357] wm8994 4-001a: 4-001a supply SPKVDD2 not found, using dummy regulator
[    2.238759] wm8994 4-001a: WM1811 revision D CUST_ID 00
[    2.247688] wm8994 4-001a: No interrupt specified, no interrupts
[    2.248012] gpiochip_find_base: found new base at 501
[    2.248185] gpio gpiochip42: (wm8994): added GPIO chardev (254:42)
[    2.248192] gpiochip_setup_dev: registered GPIOs 501 to 511 on device: gpiochip42 (wm8994)
[    2.248452] dwc2 12480000.hsotg: mapped PA 12480000 to VA e0a00000
[    2.248773] dwc2 12480000.hsotg: registering common handler for irq56
[    2.251926] dwc2 12480000.hsotg: Forcing mode to device
[    2.251940] dwc2 12480000.hsotg: Core Release: 2.81a (snpsid=4f54281a)
[    2.251949] dwc2 12480000.hsotg: Forcing mode to device
[    2.251976] dwc2 12480000.hsotg: dwc2_check_params: Invalid parameter g_np_tx_fifo_size=1024
[    2.251989] dwc2 12480000.hsotg: NonPeriodic TXFIFO size: 768
[    2.251997] dwc2 12480000.hsotg: RXFIFO size: 2048
[    2.252034] dwc2 12480000.hsotg: EPs: 16, dedicated fifos, 7808 entries in SPRAM
[    2.252422] dwc2 12480000.hsotg: DCFG=0x08200000, DCTL=0x00000000, DIEPMSK=00000000
[    2.252432] dwc2 12480000.hsotg: GAHBCFG=0x00000000, GHWCFG1=0x00000000
[    2.252441] dwc2 12480000.hsotg: GRXFSIZ=0x00001f00, GNPTXFSIZ=0x03001f00
[    2.252449] dwc2 12480000.hsotg: DPTx[1] FSize=768, StAddr=0x00002200
[    2.252458] dwc2 12480000.hsotg: DPTx[2] FSize=768, StAddr=0x00002500
[    2.252466] dwc2 12480000.hsotg: DPTx[3] FSize=768, StAddr=0x00002800
[    2.252474] dwc2 12480000.hsotg: DPTx[4] FSize=768, StAddr=0x00002b00
[    2.252483] dwc2 12480000.hsotg: DPTx[5] FSize=768, StAddr=0x00002e00
[    2.252490] dwc2 12480000.hsotg: DPTx[6] FSize=768, StAddr=0x00003100
[    2.252497] dwc2 12480000.hsotg: DPTx[7] FSize=768, StAddr=0x00003400
[    2.252505] dwc2 12480000.hsotg: DPTx[8] FSize=768, StAddr=0x00003700
[    2.252512] dwc2 12480000.hsotg: DPTx[9] FSize=768, StAddr=0x00003a00
[    2.252520] dwc2 12480000.hsotg: DPTx[10] FSize=768, StAddr=0x00003d00
[    2.252528] dwc2 12480000.hsotg: DPTx[11] FSize=768, StAddr=0x00004000
[    2.252535] dwc2 12480000.hsotg: DPTx[12] FSize=768, StAddr=0x00004300
[    2.252543] dwc2 12480000.hsotg: DPTx[13] FSize=768, StAddr=0x00004600
[    2.252550] dwc2 12480000.hsotg: DPTx[14] FSize=768, StAddr=0x00004900
[    2.252557] dwc2 12480000.hsotg: DPTx[15] FSize=768, StAddr=0x00004c00
[    2.252567] dwc2 12480000.hsotg: ep0-in: EPCTL=0x00008800, SIZ=0x00000000, DMA=0xca108aec
[    2.252576] dwc2 12480000.hsotg: ep0-out: EPCTL=0x00008000, SIZ=0x00000000, DMA=0x0858fe3d
[    2.252585] dwc2 12480000.hsotg: ep1-in: EPCTL=0x00001000, SIZ=0x00000000, DMA=0x5f061fcc
[    2.252594] dwc2 12480000.hsotg: ep1-out: EPCTL=0x00000000, SIZ=0x00000000, DMA=0xbd2da0ee
[    2.252603] dwc2 12480000.hsotg: ep2-in: EPCTL=0x00001800, SIZ=0x00000000, DMA=0x12c10551
[    2.252612] dwc2 12480000.hsotg: ep2-out: EPCTL=0x00000000, SIZ=0x00000000, DMA=0x96c7b391
[    2.252621] dwc2 12480000.hsotg: ep3-in: EPCTL=0x00002000, SIZ=0x00000000, DMA=0x25a20a5a
[    2.252629] dwc2 12480000.hsotg: ep3-out: EPCTL=0x00000000, SIZ=0x00000000, DMA=0xb869672a
[    2.252638] dwc2 12480000.hsotg: ep4-in: EPCTL=0x00002800, SIZ=0x00000000, DMA=0xe75a0cbf
[    2.252646] dwc2 12480000.hsotg: ep4-out: EPCTL=0x00000000, SIZ=0x00000000, DMA=0x3a2b3b7d
[    2.252655] dwc2 12480000.hsotg: ep5-in: EPCTL=0x00003000, SIZ=0x00000000, DMA=0x478441c5
[    2.252663] dwc2 12480000.hsotg: ep5-out: EPCTL=0x00000000, SIZ=0x00000000, DMA=0xf994de8c
[    2.252672] dwc2 12480000.hsotg: ep6-in: EPCTL=0x00003800, SIZ=0x00000000, DMA=0x87bb2c4c
[    2.252681] dwc2 12480000.hsotg: ep6-out: EPCTL=0x00000000, SIZ=0x00000000, DMA=0x286fdecb
[    2.252689] dwc2 12480000.hsotg: ep7-in: EPCTL=0x00004000, SIZ=0x00000000, DMA=0x5e590643
[    2.252698] dwc2 12480000.hsotg: ep7-out: EPCTL=0x00000000, SIZ=0x00000000, DMA=0x45f0caeb
[    2.252706] dwc2 12480000.hsotg: ep8-in: EPCTL=0x00004800, SIZ=0x00000000, DMA=0x1431d08a
[    2.252715] dwc2 12480000.hsotg: ep8-out: EPCTL=0x00000000, SIZ=0x00000000, DMA=0x6a9627fe
[    2.252723] dwc2 12480000.hsotg: ep9-in: EPCTL=0x00005000, SIZ=0x00000000, DMA=0x21ebd864
[    2.252732] dwc2 12480000.hsotg: ep9-out: EPCTL=0x00000000, SIZ=0x00000000, DMA=0x9bbc53a8
[    2.252740] dwc2 12480000.hsotg: ep10-in: EPCTL=0x00005800, SIZ=0x00000000, DMA=0xa9a8bb29
[    2.252749] dwc2 12480000.hsotg: ep10-out: EPCTL=0x00000000, SIZ=0x00000000, DMA=0x87bcbc7a
[    2.252757] dwc2 12480000.hsotg: ep11-in: EPCTL=0x00006000, SIZ=0x00000000, DMA=0xbe6c2047
[    2.252766] dwc2 12480000.hsotg: ep11-out: EPCTL=0x00000000, SIZ=0x00000000, DMA=0xbbf6eac3
[    2.252775] dwc2 12480000.hsotg: ep12-in: EPCTL=0x00006800, SIZ=0x00000000, DMA=0xad8a5716
[    2.252783] dwc2 12480000.hsotg: ep12-out: EPCTL=0x00000000, SIZ=0x00000000, DMA=0xf87042d7
[    2.252791] dwc2 12480000.hsotg: ep13-in: EPCTL=0x00007000, SIZ=0x00000000, DMA=0xcca18ad7
[    2.252801] dwc2 12480000.hsotg: ep13-out: EPCTL=0x00000000, SIZ=0x00000000, DMA=0xd44bdb2b
[    2.252809] dwc2 12480000.hsotg: ep14-in: EPCTL=0x00000000, SIZ=0x00000000, DMA=0x9e848cdc
[    2.252818] dwc2 12480000.hsotg: ep14-out: EPCTL=0x00000000, SIZ=0x00000000, DMA=0x9597b4c9
[    2.252827] dwc2 12480000.hsotg: ep15-in: EPCTL=0x00000800, SIZ=0x00000000, DMA=0x1ff1e418
[    2.252835] dwc2 12480000.hsotg: ep15-out: EPCTL=0x00000000, SIZ=0x00000000, DMA=0xedcc8171
[    2.252843] dwc2 12480000.hsotg: DVBUSDIS=0x000017d7, DVBUSPULSE=000005b8
[    2.261064] ntc-thermistor thermistor-ap: Thermistor type: ncp15wb473 successfully probed.
[    2.261502] ntc-thermistor thermistor-battery: Thermistor type: ncp15wb473 successfully probed.
[    2.262947] exynos-bus: new bus device registered: bus_dmc (100000 KHz ~ 400000 KHz)
[    2.263721] exynos-bus: new bus device registered: bus_acp (100000 KHz ~ 267000 KHz)
[    2.264218] exynos-bus: new bus device registered: bus_c2c (100000 KHz ~ 400000 KHz)
[    2.265478] exynos-bus: new bus device registered: bus_leftbus (100000 KHz ~ 200000 KHz)
[    2.265985] exynos-bus: new bus device registered: bus_rightbus (100000 KHz ~ 200000 KHz)
[    2.266616] exynos-bus: new bus device registered: bus_display (160000 KHz ~ 200000 KHz)
[    2.267301] exynos-bus: new bus device registered: bus_fsys (100000 KHz ~ 134000 KHz)
[    2.267962] exynos-bus: new bus device registered: bus_peri ( 50000 KHz ~ 100000 KHz)
[    2.268441] exynos-bus: new bus device registered: bus_mfc (100000 KHz ~ 200000 KHz)
[    2.270357] of_get_named_gpiod_flags: parsed 'gpios' property of node '/gpio-keys/key-down[0]' - status (0)
[    2.270386] gpio-239 (volume down): gpiod_set_debounce: missing set() or set_config() operations
[    2.270591] of_get_named_gpiod_flags: parsed 'gpios' property of node '/gpio-keys/key-up[0]' - status (0)
[    2.270614] gpio-230 (volume up): gpiod_set_debounce: missing set() or set_config() operations
[    2.270771] of_get_named_gpiod_flags: parsed 'gpios' property of node '/gpio-keys/key-power[0]' - status (0)
[    2.270786] gpio-235 (power): gpiod_set_debounce: missing set() or set_config() operations
[    2.270942] of_get_named_gpiod_flags: parsed 'gpios' property of node '/gpio-keys/key-home[0]' - status (0)
[    2.270969] gpio-213 (home): gpiod_set_debounce: missing set() or set_config() operations
[    2.271273] input: gpio-keys as /devices/platform/gpio-keys/input/input2
[    2.287847] brcmfmac: brcmf_sdio_download_nvram Enter
[    2.288267] brcmfmac: brcmf_sdio_verifymemory Compare RAM dl & ul at 0x0007f920; size=1760
[    2.288685] brcmfmac: brcmf_chip_set_active Enter
[    2.298289] max77686-rtc max77686-rtc: setting system clock to 2017-11-07 13:22:58 UTC (1510060978)
[    2.301611] CAM_SENSOR_A: disabling
[    2.301618] CAM_AF: disabling
[    2.302094] VMIPI_1.0V: disabling
[    2.307836] VHSIC_1.8V: disabling
[    2.311766] LCD_VCC_3.3V: disabling
[    2.315651] vdd_g3d: disabling
[    2.320587] CHARGER: disabling
[    2.321614] ALSA device list:
[    2.321622]   No soundcards found.
[    2.323811] Freeing unused kernel memory: 1024K
[    3.305314] brcmfmac: brcmf_sdio_htclk: HT Avail timeout (1000000): clkctl 0x50
[    3.305410] brcmfmac: brcmf_sdio_firmware_callback failed: dev=mmc1:0001:1, err=0
[    3.305513] brcmfmac: brcmf_sdio_remove Enter
[    3.305530] brcmfmac: brcmf_detach Enter
[    3.337439] brcmfmac: brcmf_bus_change_state 0 -> 0
[    3.337472] brcmfmac: brcmf_sdio_bus_stop Enter
[    4.350590] brcmfmac: brcmf_sdio_htclk: HT Avail timeout (1000000): clkctl 0x50
[    4.351662] brcmfmac: brcmf_proto_detach Enter
[    4.351711] brcmfmac: brcmf_fweh_unregister event handler cleared for PSM_WATCHDOG
[    5.360818] brcmfmac: brcmf_sdio_htclk: HT Avail timeout (1000000): clkctl 0x50
[    5.397630] brcmfmac: brcmf_chip_set_passive Enter
[    5.401477] brcmfmac: brcmf_sdio_remove Disconnected
[   18.746196] max77693-muic max77693-muic: external connector is detached(chg_type:0x0, prev_chg_type:0x0)
[   20.467914] max77693-muic max77693-muic: external connector is attached (adc:0x1c, prev_adc:0x1c)
[   20.467954] max77693-muic max77693-muic: external connector is attached (adc:0x1c)
[   20.471246] max77693-muic max77693-muic: CONTROL1 : 0x1b, CONTROL2 : 0x04, state : attached
[   22.249195] max77693-muic max77693-muic: external connector is attached (adc:0x1c, prev_adc:0x1c)
[   22.249234] max77693-muic max77693-muic: external connector is attached (adc:0x1c)
[   22.251415] max77693-muic max77693-muic: CONTROL1 : 0x1b, CONTROL2 : 0x04, state : attached
[   40.512684] EXT4-fs (mmcblk2p9): couldn't mount as ext3 due to feature incompatibilities
[   40.513928] EXT4-fs (mmcblk2p9): couldn't mount as ext2 due to feature incompatibilities
[   40.528262] EXT4-fs (mmcblk2p9): warning: maximal mount count reached, running e2fsck is recommended
[   40.530806] EXT4-fs (mmcblk2p9): recovery complete
[   40.532291] EXT4-fs (mmcblk2p9): mounted filesystem with ordered data mode. Opts: (null)

> 
> Regards,
> Arend

Cheers,
Simon

Return-Path: <SRS0=G8on=RY=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 339E4C43381
	for <linux-wireless@archiver.kernel.org>; Thu, 21 Mar 2019 10:31:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D7B30218D3
	for <linux-wireless@archiver.kernel.org>; Thu, 21 Mar 2019 10:31:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=csach0.onmicrosoft.com header.i=@csach0.onmicrosoft.com header.b="VzyXA9x7"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727867AbfCUKba (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 21 Mar 2019 06:31:30 -0400
Received: from mail-eopbgr150109.outbound.protection.outlook.com ([40.107.15.109]:48774
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727823AbfCUKb3 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 21 Mar 2019 06:31:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=csach0.onmicrosoft.com; s=selector1-csa-ch;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mZoMYGopdNNG6mHvy/SoiLwkeLoCdS5fA+khRQgiPCs=;
 b=VzyXA9x79OCGUJiP0FRF4nzf1wJMkVKJw06lbqBtUBfSLWPHd8UJ1qFTQk4ecH66of6AJuzrRriow5I8/ig+Bi1FOGWVU+G0jdpArFnk9P4zLabtgV1enAU4fiTT0fJh3XszU3CAhCIU8r2TGKGpma/7Fj4erAJHCSPV4wrq6tk=
Received: from VI1PR09MB2382.eurprd09.prod.outlook.com (20.177.59.212) by
 VI1PR09MB0495.eurprd09.prod.outlook.com (10.161.111.25) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1730.16; Thu, 21 Mar 2019 10:31:16 +0000
Received: from VI1PR09MB2382.eurprd09.prod.outlook.com
 ([fe80::401d:d26c:fdca:ab1]) by VI1PR09MB2382.eurprd09.prod.outlook.com
 ([fe80::401d:d26c:fdca:ab1%4]) with mapi id 15.20.1709.015; Thu, 21 Mar 2019
 10:31:16 +0000
From:   Urs Kofmel <Urs.Kofmel@csa.ch>
To:     "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: wlcore: sdio: wl12xx_sdio_power_on: failed to get_sync(-13)
Thread-Topic: wlcore: sdio: wl12xx_sdio_power_on: failed to get_sync(-13)
Thread-Index: AdTfz+2lYbszSHpiQLyYOmh0uksHaw==
Date:   Thu, 21 Mar 2019 10:31:16 +0000
Message-ID: <VI1PR09MB2382174B721D0F7D97328B82F2420@VI1PR09MB2382.eurprd09.prod.outlook.com>
Accept-Language: de-CH, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Urs.Kofmel@csa.ch; 
x-originating-ip: [212.101.6.166]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 32daa10c-d687-4054-8ec9-08d6ade859bf
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(7021145)(8989299)(4534185)(7022145)(4603075)(7168020)(4627221)(201702281549075)(8990200)(7048125)(7024125)(7027125)(7023125)(5600127)(711020)(4605104)(2017052603328)(7153060)(7193020);SRVR:VI1PR09MB0495;
x-ms-traffictypediagnostic: VI1PR09MB0495:
x-microsoft-antispam-prvs: <VI1PR09MB0495DA965631418FA122ECA2F2420@VI1PR09MB0495.eurprd09.prod.outlook.com>
x-forefront-prvs: 0983EAD6B2
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(366004)(396003)(346002)(136003)(39830400003)(376002)(189003)(199004)(5024004)(14444005)(256004)(14454004)(33656002)(186003)(7736002)(99286004)(2906002)(55016002)(2351001)(2501003)(106356001)(316002)(25786009)(8936002)(74482002)(81166006)(26005)(97736004)(71190400001)(71200400001)(81156014)(8676002)(476003)(55236004)(7696005)(53946003)(6506007)(74316002)(66066001)(102836004)(114624004)(305945005)(86362001)(9686003)(6436002)(6116002)(3846002)(5660300002)(68736007)(53936002)(30864003)(486006)(72206003)(508600001)(5640700003)(6916009)(105586002)(52536014)(559001)(579004);DIR:OUT;SFP:1102;SCL:1;SRVR:VI1PR09MB0495;H:VI1PR09MB2382.eurprd09.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:3;A:1;
received-spf: None (protection.outlook.com: csa.ch does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: DP+vq1oMjrDoRQ4ybAphceOmH/vT51IR9mi9clbCHqkN/jmzxhrHH/dp3EwJZ23fI/Ojo02wbtzqFBV+KYGVydcXp8g5FRAmlL6lHh7JiKXsimn13PLDphsvU6WYVrsSfgmQS7K2MKUkbjCGVFw3dckUZni9z6eduN+/NTVmnIc/o2LpBQcvC5koQ+jWJybiHJcf1UuUDM5cKsdmBDNPFHGyGwz2zW1mkjoG5CT73IfBnZLQXLGxja1QPuQNwkJPZCouV2f14qHFX8PkM3oGzvgoecqOJtZaykddJN2I3zj58qkf/MFCe+kRaNWJSDuQzqoxOznkU6/t/xXMJyg+e61U7icbkkjLjL/0ekTArcxbKzcLr72LxLP/Q2DbMzQU7rpDkl6vXNorw1JflZrrYVS8adqqp5N4vDILR1dYsAs=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: csa.ch
X-MS-Exchange-CrossTenant-Network-Message-Id: 32daa10c-d687-4054-8ec9-08d6ade859bf
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Mar 2019 10:31:16.7776
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a3e5a4af-40af-4132-b762-3fd6d56741a7
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR09MB0495
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hi

After switching from 4.14.14 to 4.19.y branch I get "wl12xx_sdio_power_on: =
failed to get_sync(-13)" in dmesg and no firmware is loaded, hence no wlan =
interface.
This is on armhf (imx6dl on a solidrun module with custom baseboard)

It would be great if someone could fix this.
Let me know if more information is needed.

Thanks

dmesg:
[    0.000000] Booting Linux on physical CPU 0x0
[    0.000000] Linux version 4.19.30 (root@ubuntu-bionic) (gcc version 7.2.=
1 20171011 (Linaro GCC 7.2-2017.11)) #5.75 SMP Tue Mar 19 14:09:36 UTC 2019
[    0.000000] CPU: ARMv7 Processor [412fc09a] revision 10 (ARMv7), cr=3D10=
c5387d
[    0.000000] CPU: PIPT / VIPT nonaliasing data cache, VIPT aliasing instr=
uction cache
[    0.000000] OF: fdt: Machine model: Viollier v-box (SOM v1.5)
[    0.000000] Memory policy: Data cache writealloc
[    0.000000] cma: Reserved 256 MiB at 0x40000000
[    0.000000] On node 0 totalpages: 262144
[    0.000000]   Normal zone: 2304 pages used for memmap
[    0.000000]   Normal zone: 0 pages reserved
[    0.000000]   Normal zone: 262144 pages, LIFO batch:63
[    0.000000] random: get_random_bytes called from start_kernel+0xa0/0x420=
 with crng_init=3D0
[    0.000000] percpu: Embedded 17 pages/cpu @(ptrval) s37068 r8192 d24372 =
u69632
[    0.000000] pcpu-alloc: s37068 r8192 d24372 u69632 alloc=3D17*4096
[    0.000000] pcpu-alloc: [0] 0 [0] 1
[    0.000000] Built 1 zonelists, mobility grouping on.  Total pages: 25984=
0
[    0.000000] Kernel command line: root=3DUUID=3D3af6a091-bd9e-48d3-9810-e=
2c4be866135 rootfstype=3Dext4 rootwait  console=3Dttymxc0,115200 consolebla=
nk=3D0 video=3Dmxcfb0:dev=3Dhdmi,1920x1080m60,if=3DRGB24,bpp=3D32 rd.dm=3D0=
 rd.luks=3D0 rd.lvm=3D0 raid=3Dnoautodetect pci=3Dnomsi vt.global_cursor_de=
fault=3D0 loglevel=3D1
[    0.000000] Dentry cache hash table entries: 131072 (order: 7, 524288 by=
tes)
[    0.000000] Inode-cache hash table entries: 65536 (order: 6, 262144 byte=
s)
[    0.000000] Memory: 754516K/1048576K available (11264K kernel code, 324K=
 rwdata, 2316K rodata, 1024K init, 449K bss, 31916K reserved, 262144K cma-r=
eserved, 0K highmem)
[    0.000000] Virtual kernel memory layout:
                   vector  : 0xffff0000 - 0xffff1000   (   4 kB)
                   fixmap  : 0xffc00000 - 0xfff00000   (3072 kB)
                   vmalloc : 0xc0800000 - 0xff800000   (1008 MB)
                   lowmem  : 0x80000000 - 0xc0000000   (1024 MB)
                   pkmap   : 0x7fe00000 - 0x80000000   (   2 MB)
                   modules : 0x7f000000 - 0x7fe00000   (  14 MB)
                     .text : 0x(ptrval) - 0x(ptrval)   (12256 kB)
                     .init : 0x(ptrval) - 0x(ptrval)   (1024 kB)
                     .data : 0x(ptrval) - 0x(ptrval)   ( 325 kB)
                      .bss : 0x(ptrval) - 0x(ptrval)   ( 450 kB)
[    0.000000] SLUB: HWalign=3D64, Order=3D0-3, MinObjects=3D0, CPUs=3D2, N=
odes=3D1
[    0.000000] rcu: Hierarchical RCU implementation.
[    0.000000] rcu:     RCU event tracing is enabled.
[    0.000000] rcu:     RCU restricting CPUs from NR_CPUS=3D4 to nr_cpu_ids=
=3D2.
[    0.000000] rcu: Adjusting geometry for rcu_fanout_leaf=3D16, nr_cpu_ids=
=3D2
[    0.000000] NR_IRQS: 16, nr_irqs: 16, preallocated irqs: 16
[    0.000000] L2C-310 erratum 769419 enabled
[    0.000000] L2C-310 enabling early BRESP for Cortex-A9
[    0.000000] L2C-310 full line of zeros enabled for Cortex-A9
[    0.000000] L2C-310 ID prefetch enabled, offset 16 lines
[    0.000000] L2C-310 dynamic clock gating enabled, standby mode enabled
[    0.000000] L2C-310 cache controller enabled, 16 ways, 512 kB
[    0.000000] L2C-310: CACHE_ID 0x410000c8, AUX_CTRL 0x76450001
[    0.000000] Switching to timer-based delay loop, resolution 333ns
[    0.000007] sched_clock: 32 bits at 3000kHz, resolution 333ns, wraps eve=
ry 715827882841ns
[    0.000020] clocksource: mxc_timer1: mask: 0xffffffff max_cycles: 0xffff=
ffff, max_idle_ns: 637086815595 ns
[    0.001008] Console: colour dummy device 80x30
[    0.001034] Calibrating delay loop (skipped), value calculated using tim=
er frequency.. 6.00 BogoMIPS (lpj=3D12000)
[    0.001046] pid_max: default: 32768 minimum: 301
[    0.001191] Security Framework initialized
[    0.001201] AppArmor: AppArmor disabled by boot time parameter
[    0.001265] Mount-cache hash table entries: 2048 (order: 1, 8192 bytes)
[    0.001283] Mountpoint-cache hash table entries: 2048 (order: 1, 8192 by=
tes)
[    0.002028] CPU: Testing write buffer coherency: ok
[    0.002060] CPU0: Spectre v2: using BPIALL workaround
[    0.002451] CPU0: thread -1, cpu 0, socket 0, mpidr 80000000
[    0.003170] Setting up static identity map for 0x10100000 - 0x10100060
[    0.003344] rcu: Hierarchical SRCU implementation.
[    0.004291] smp: Bringing up secondary CPUs ...
[    0.005102] CPU1: thread -1, cpu 1, socket 0, mpidr 80000001
[    0.005108] CPU1: Spectre v2: using BPIALL workaround
[    0.005241] smp: Brought up 1 node, 2 CPUs
[    0.005251] SMP: Total of 2 processors activated (12.00 BogoMIPS).
[    0.005255] CPU: All CPU(s) started in SVC mode.
[    0.006408] devtmpfs: initialized
[    0.014613] VFP support v0.3: implementor 41 architecture 3 part 30 vari=
ant 9 rev 4
[    0.014863] clocksource: jiffies: mask: 0xffffffff max_cycles: 0xfffffff=
f, max_idle_ns: 7645041785100000 ns
[    0.014879] futex hash table entries: 512 (order: 3, 32768 bytes)
[    0.026464] xor: measuring software checksum speed
[    0.063682]    arm4regs  :  1216.000 MB/sec
[    0.103678]    8regs     :   922.000 MB/sec
[    0.143679]    32regs    :  1021.000 MB/sec
[    0.183678]    neon      :   892.000 MB/sec
[    0.183683] xor: using function: arm4regs (1216.000 MB/sec)
[    0.183766] pinctrl core: initialized pinctrl subsystem
[    0.184634] NET: Registered protocol family 16
[    0.194250] DMA: preallocated 2048 KiB pool for atomic coherent allocati=
ons
[    0.194706] audit: initializing netlink subsys (disabled)
[    0.194919] audit: type=3D2000 audit(0.192:1): state=3Dinitialized audit=
_enabled=3D0 res=3D1
[    0.195370] cpuidle: using governor ladder
[    0.195396] cpuidle: using governor menu
[    0.195722] CPU identified as i.MX6DL, silicon rev 1.3
[    0.202439] vdd1p1: supplied by regulator-dummy
[    0.202897] vdd3p0: supplied by regulator-dummy
[    0.203348] vdd2p5: supplied by regulator-dummy
[    0.203809] vddarm: supplied by regulator-dummy
[    0.204289] vddpu: supplied by regulator-dummy
[    0.204728] vddsoc: supplied by regulator-dummy
[    0.213356] hw-breakpoint: found 5 (+1 reserved) breakpoint and 1 watchp=
oint registers.
[    0.213362] hw-breakpoint: maximum watchpoint size is 4 bytes.
[    0.214054] imx6dl-pinctrl 20e0000.iomuxc: initialized IMX pinctrl drive=
r
[    0.291827] raid6: int32x1  gen()   143 MB/s
[    0.359766] raid6: int32x1  xor()   136 MB/s
[    0.427773] raid6: int32x2  gen()   164 MB/s
[    0.495690] raid6: int32x2  xor()   162 MB/s
[    0.563734] raid6: int32x4  gen()   207 MB/s
[    0.631790] raid6: int32x4  xor()   173 MB/s
[    0.699715] raid6: int32x8  gen()   230 MB/s
[    0.767727] raid6: int32x8  xor()   157 MB/s
[    0.835727] raid6: neonx1   gen()   614 MB/s
[    0.903681] raid6: neonx1   xor()   567 MB/s
[    0.971700] raid6: neonx2   gen()   642 MB/s
[    1.039724] raid6: neonx2   xor()   672 MB/s
[    1.107749] raid6: neonx4   gen()   664 MB/s
[    1.175703] raid6: neonx4   xor()   672 MB/s
[    1.243720] raid6: neonx8   gen()   508 MB/s
[    1.311710] raid6: neonx8   xor()   522 MB/s
[    1.311716] raid6: using algorithm neonx4 gen() 664 MB/s
[    1.311721] raid6: .... xor() 672 MB/s, rmw enabled
[    1.311725] raid6: using neon recovery algorithm
[    1.323612] mxs-dma 110000.dma-apbh: initialized
[    1.325167] v_usb2: supplied by v_5v0
[    1.325379] vcc_3v3: supplied by v_5v0
[    1.325437] nvcc_sd1: supplied by vcc_3v3
[    1.325692] v_usb1: supplied by v_5v0
[    1.326592] SCSI subsystem initialized
[    1.326635] libata version 3.00 loaded.
[    1.326843] usbcore: registered new interface driver usbfs
[    1.326898] usbcore: registered new interface driver hub
[    1.327010] usbcore: registered new device driver usb
[    1.327968] i2c i2c-0: IMX I2C adapter registered
[    1.327982] i2c i2c-0: can't use DMA, using PIO instead.
[    1.328145] videodev: Linux video capture interface: v2.00
[    1.328188] pps_core: LinuxPPS API ver. 1 registered
[    1.328193] pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo =
Giometti <giometti@linux.it>
[    1.328210] PTP clock support registered
[    1.328414] Advanced Linux Sound Architecture Driver Initialized.
[    1.329525] clocksource: Switched to clocksource mxc_timer1
[    1.329711] VFS: Disk quotas dquot_6.6.0
[    1.329779] VFS: Dquot-cache hash table entries: 1024 (order 0, 4096 byt=
es)
[    1.338618] NET: Registered protocol family 2
[    1.339305] tcp_listen_portaddr_hash hash table entries: 512 (order: 0, =
6144 bytes)
[    1.339336] TCP established hash table entries: 8192 (order: 3, 32768 by=
tes)
[    1.339414] TCP bind hash table entries: 8192 (order: 4, 65536 bytes)
[    1.339552] TCP: Hash tables configured (established 8192 bind 8192)
[    1.339731] UDP hash table entries: 512 (order: 2, 16384 bytes)
[    1.339772] UDP-Lite hash table entries: 512 (order: 2, 16384 bytes)
[    1.340022] NET: Registered protocol family 1
[    1.340744] RPC: Registered named UNIX socket transport module.
[    1.340750] RPC: Registered udp transport module.
[    1.340753] RPC: Registered tcp transport module.
[    1.340757] RPC: Registered tcp NFSv4.1 backchannel transport module.
[    1.340964] Trying to unpack rootfs image as initramfs...
[    1.703662] Freeing initrd memory: 4948K
[    1.704170] hw perfevents: no interrupt-affinity property for /pmu, gues=
sing.
[    1.704410] hw perfevents: enabled with armv7_cortex_a9 PMU driver, 7 co=
unters available
[    1.706113] Initialise system trusted keyrings
[    1.706359] workingset: timestamp_bits=3D14 max_order=3D18 bucket_order=
=3D4
[    1.712822] NFS: Registering the id_resolver key type
[    1.712856] Key type id_resolver registered
[    1.712861] Key type id_legacy registered
[    1.712874] nfs4filelayout_init: NFSv4 File Layout Driver Registering...
[    1.712878] Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
[    1.713966] JFS: nTxBlock =3D 7981, nTxLock =3D 63850
[    1.720377] SGI XFS with ACLs, security attributes, realtime, no debug e=
nabled
[    1.730765] Key type asymmetric registered
[    1.730773] Asymmetric key parser 'x509' registered
[    1.730840] Block layer SCSI generic (bsg) driver version 0.4 loaded (ma=
jor 249)
[    1.731018] io scheduler noop registered
[    1.731024] io scheduler deadline registered
[    1.731194] io scheduler cfq registered (default)
[    1.734746] imx-pgc-pd imx-pgc-power-domain.0: DMA mask not set
[    1.734807] imx-pgc-pd imx-pgc-power-domain.0: Linked as a consumer to 2=
0dc000.gpc
[    1.734857] imx-pgc-pd imx-pgc-power-domain.1: DMA mask not set
[    1.734942] imx-pgc-pd imx-pgc-power-domain.1: Linked as a consumer to r=
egulator.5
[    1.735038] imx-pgc-pd imx-pgc-power-domain.1: Linked as a consumer to 2=
0dc000.gpc
[    1.739194] 2020000.serial: ttymxc0 at MMIO 0x2020000 (irq =3D 25, base_=
baud =3D 5000000) is a IMX
[    1.739257] console [ttymxc0] enabled
[    1.740090] 21f0000.serial: ttymxc3 at MMIO 0x21f0000 (irq =3D 68, base_=
baud =3D 5000000) is a IMX
[    1.743768] brd: module loaded
[    1.751250] loop: module loaded
[    1.754144] spi_imx 200c000.ecspi: probed
[    1.755378] libphy: Fixed MDIO Bus: probed
[    1.756727] fec 2188000.ethernet: 2188000.ethernet supply phy not found,=
 using dummy regulator
[    1.756810] fec 2188000.ethernet: Linked as a consumer to regulator.0
[    1.760365] pps pps0: new PPS source ptp0
[    1.770904] libphy: fec_enet_mii_bus: probed
[    1.771417] fec 2188000.ethernet eth0: registered PHC device 0
[    1.772096] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    1.772193] usbcore: registered new interface driver usb-storage
[    1.773885] imx_usb 2184000.usb: Linked as a consumer to regulator.11
[    1.777072] ci_hdrc ci_hdrc.0: EHCI Host Controller
[    1.777104] ci_hdrc ci_hdrc.0: new USB bus registered, assigned bus numb=
er 1
[    1.789556] ci_hdrc ci_hdrc.0: USB 2.0 started, EHCI 1.00
[    1.789777] usb usb1: New USB device found, idVendor=3D1d6b, idProduct=
=3D0002, bcdDevice=3D 4.19
[    1.789786] usb usb1: New USB device strings: Mfr=3D3, Product=3D2, Seri=
alNumber=3D1
[    1.789794] usb usb1: Product: EHCI Host Controller
[    1.789800] usb usb1: Manufacturer: Linux 4.19.30 ehci_hcd
[    1.789806] usb usb1: SerialNumber: ci_hdrc.0
[    1.790384] hub 1-0:1.0: USB hub found
[    1.790425] hub 1-0:1.0: 1 port detected
[    1.791263] imx_usb 2184200.usb: Linked as a consumer to regulator.10
[    1.794973] ci_hdrc ci_hdrc.1: EHCI Host Controller
[    1.795005] ci_hdrc ci_hdrc.1: new USB bus registered, assigned bus numb=
er 2
[    1.813550] ci_hdrc ci_hdrc.1: USB 2.0 started, EHCI 1.00
[    1.813743] usb usb2: New USB device found, idVendor=3D1d6b, idProduct=
=3D0002, bcdDevice=3D 4.19
[    1.813752] usb usb2: New USB device strings: Mfr=3D3, Product=3D2, Seri=
alNumber=3D1
[    1.813759] usb usb2: Product: EHCI Host Controller
[    1.813765] usb usb2: Manufacturer: Linux 4.19.30 ehci_hcd
[    1.813770] usb usb2: SerialNumber: ci_hdrc.1
[    1.814358] hub 2-0:1.0: USB hub found
[    1.814404] hub 2-0:1.0: 1 port detected
[    1.815638] mousedev: PS/2 mouse device common for all mice
[    1.820401] rtc-pcf8523 0-0068: rtc core: registered rtc-pcf8523 as rtc0
[    1.821039] snvs_rtc 20cc000.snvs:snvs-rtc-lp: rtc core: registered 20cc=
000.snvs:snvs-rtc-lp as rtc1
[    1.821187] i2c /dev entries driver
[    1.822384] imx2-wdt 20bc000.wdog: timeout 60 sec (nowayout=3D0)
[    1.822680] sdhci: Secure Digital Host Controller Interface driver
[    1.822684] sdhci: Copyright(c) Pierre Ossman
[    1.822687] sdhci-pltfm: SDHCI platform and OF driver helper
[    1.824027] sdhci-esdhc-imx 2194000.usdhc: Got CD GPIO
[    1.824159] sdhci-esdhc-imx 2194000.usdhc: Linked as a consumer to regul=
ator.7
[    1.857752] mmc0: SDHCI controller on 2194000.usdhc [2194000.usdhc] usin=
g ADMA
[    1.862823] ledtrig-cpu: registered to indicate activity on CPUs
[    1.862911] hidraw: raw HID events driver (C) Jiri Kosina
[    1.863060] usbcore: registered new interface driver usbhid
[    1.863064] usbhid: USB HID core driver
[    1.863125] usbcore: registered new interface driver r8712u
[    1.867083] NET: Registered protocol family 10
[    1.885659] Segment Routing with IPv6
[    1.885762] NET: Registered protocol family 17
[    1.885977] lib80211: common routines for IEEE802.11 drivers
[    1.885983] lib80211_crypt: registered algorithm 'NULL'
[    1.885987] lib80211_crypt: registered algorithm 'WEP'
[    1.885991] lib80211_crypt: registered algorithm 'CCMP'
[    1.885994] lib80211_crypt: registered algorithm 'TKIP'
[    1.886020] Key type dns_resolver registered
[    1.886790] cpu cpu0: Linked as a consumer to regulator.4
[    1.886873] cpu cpu0: Linked as a consumer to regulator.5
[    1.886949] cpu cpu0: Linked as a consumer to regulator.6
[    1.887678] Registering SWP/SWPB emulation handler
[    1.888860] registered taskstats version 1
[    1.888864] Loading compiled-in X.509 certificates
[    1.892476] zswap: default zpool zbud not available
[    1.892481] zswap: pool creation failed
[    1.894678] Btrfs loaded, crc32c=3Dcrc32c-generic
[    1.897661] mmc0: host does not support reading read-only switch, assumi=
ng write-enable
[    1.903961] mmc0: new high speed SDHC card at address 59b4
[    1.904991] mmcblk0: mmc0:59b4 NCard 15.1 GiB
[    1.905353] Key type encrypted registered
[    1.914986]  mmcblk0: p1
[    1.922571] imx_thermal tempmon: Commercial CPU temperature grade - max:=
95C critical:90C passive:85C
[    1.924960] input: gpio-keys as /devices/soc0/gpio-keys/input/input0
[    1.927228] rtc-pcf8523 0-0068: setting system clock to 2019-03-19 14:44=
:35 UTC (1553006675)
[    1.928301] Duplicate name in testcase-data, renamed to "duplicate-name#=
1"
[    1.930114] ### dt-test ### start of unittest - you will see error messa=
ges
[    1.930631] OF: /testcase-data/phandle-tests/consumer-a: could not get #=
phandle-cells-missing for /testcase-data/phandle-tests/provider1
[    1.930640] OF: /testcase-data/phandle-tests/consumer-a: could not get #=
phandle-cells-missing for /testcase-data/phandle-tests/provider1
[    1.930673] OF: /testcase-data/phandle-tests/consumer-a: could not find =
phandle
[    1.930696] OF: /testcase-data/phandle-tests/consumer-a: could not find =
phandle
[    1.930704] OF: /testcase-data/phandle-tests/consumer-a: arguments longe=
r than property
[    1.930711] OF: /testcase-data/phandle-tests/consumer-a: arguments longe=
r than property
[    1.930850] OF: /testcase-data/phandle-tests/consumer-b: could not get #=
phandle-missing-cells for /testcase-data/phandle-tests/provider1
[    1.930876] OF: /testcase-data/phandle-tests/consumer-b: could not find =
phandle
[    1.930887] OF: /testcase-data/phandle-tests/consumer-b: arguments longe=
r than property
[    1.945759] OF: overlay: node_overlaps_later_cs: #6 overlaps with #7 @/t=
estcase-data/overlay-node/test-bus/test-unittest8
[    1.945764] OF: overlay: overlay #6 is not topmost
[    1.953448] i2c i2c-4: Added multiplexed i2c bus 5
[    1.956108] i2c i2c-4: Added multiplexed i2c bus 6
[    1.962916] ### dt-test ### end of unittest - 210 passed, 0 failed
[    1.963180] ALSA device list:
[    1.963183]   No soundcards found.
[    1.965076] Freeing unused kernel memory: 1024K
[    1.978365] Run /init as init process
[    2.040732] random: systemd-udevd: uninitialized urandom read (16 bytes =
read)
[    2.041343] random: systemd-udevd: uninitialized urandom read (16 bytes =
read)
[    2.041460] random: systemd-udevd: uninitialized urandom read (16 bytes =
read)
[    2.125642] usb 1-1: new high-speed USB device number 2 using ci_hdrc
[    2.149630] usb 2-1: new high-speed USB device number 2 using ci_hdrc
[    2.282907] usb 1-1: New USB device found, idVendor=3D0403, idProduct=3D=
6011, bcdDevice=3D 8.00
[    2.282918] usb 1-1: New USB device strings: Mfr=3D1, Product=3D2, Seria=
lNumber=3D0
[    2.282922] usb 1-1: Product: Quad RS232-HS
[    2.282927] usb 1-1: Manufacturer: FTDI
[    2.307523] usb 2-1: New USB device found, idVendor=3D04b4, idProduct=3D=
6570, bcdDevice=3D32.99
[    2.307532] usb 2-1: New USB device strings: Mfr=3D0, Product=3D1, Seria=
lNumber=3D0
[    2.307539] usb 2-1: Product: USB2.0 Hub
[    2.308395] hub 2-1:1.0: USB hub found
[    2.308769] hub 2-1:1.0: 4 ports detected
[    2.406817] sdhci-esdhc-imx 2190000.usdhc: allocated mmc-pwrseq
[    2.406897] sdhci-esdhc-imx 2190000.usdhc: Linked as a consumer to regul=
ator.7
[    2.614864] random: fast init done
[    2.652270] mmc1: SDHCI controller on 2190000.usdhc [2190000.usdhc] usin=
g ADMA
[    2.660458] sdhci-esdhc-imx 2190000.usdhc: card claims to support voltag=
es below defined range
[    2.699159] mmc1: new high speed SDIO card at address 0001
[    2.958463] EXT4-fs (mmcblk0p1): mounted filesystem with writeback data =
mode. Opts: (null)
[    3.857948] systemd[1]: systemd 232 running in system mode. (+PAM +AUDIT=
 +SELINUX +IMA +APPARMOR +SMACK +SYSVINIT +UTMP +LIBCRYPTSETUP +GCRYPT +GNU=
TLS +ACL +XZ +LZ4 +SECCOMP +BLKID +ELFUTILS +KMOD +IDN)
[    3.858490] systemd[1]: Detected architecture arm.
[    3.894543] systemd[1]: Set hostname to <vbd063b4014937>.
[    4.160910] systemd[1]: Configuration file /lib/systemd/system/systemd-m=
odules-load.service.d/10-timeout.conf is marked executable. Please remove e=
xecutable permission bits. Proceeding anyway.
[    4.186993] systemd[1]: Configuration file /lib/systemd/system/armbian-h=
ardware-optimize.service is marked executable. Please remove executable per=
mission bits. Proceeding anyway.
[    4.188541] systemd[1]: Configuration file /lib/systemd/system/armbian-h=
ardware-monitor.service is marked executable. Please remove executable perm=
ission bits. Proceeding anyway.
[    4.321766] systemd[1]: Configuration file /lib/systemd/system/armbian-r=
amlog.service is marked executable. Please remove executable permission bit=
s. Proceeding anyway.
[    4.326345] systemd[1]: Configuration file /lib/systemd/system/armbian-z=
ram-config.service is marked executable. Please remove executable permissio=
n bits. Proceeding anyway.
[    4.390026] systemd[1]: Configuration file /lib/systemd/system/serial-ge=
tty@.service.d/10-term.conf is marked executable. Please remove executable =
permission bits. Proceeding anyway.
[    4.394683] systemd[1]: Configuration file /lib/systemd/system/getty@tty=
1.service.d/10-noclear.conf is marked executable. Please remove executable =
permission bits. Proceeding anyway.
[    4.841640] EXT4-fs (mmcblk0p1): re-mounted. Opts: commit=3D600,errors=
=3Dremount-ro
[    5.348293] systemd-journald[212]: Received request to flush runtime jou=
rnal from PID 1
[    6.273329] imx-ipuv3 2400000.ipu: IPUv3H probed
[    6.329388] [drm] Supports vblank timestamp caching Rev 2 (21.10.2013).
[    6.329396] [drm] No driver support for vblank timestamp query.
[    6.330607] imx-drm display-subsystem: bound imx-ipuv3-crtc.2 (ops ipu_c=
rtc_ops [imxdrm])
[    6.330839] imx-drm display-subsystem: bound imx-ipuv3-crtc.3 (ops ipu_c=
rtc_ops [imxdrm])
[    6.330881] [drm] Cannot find any crtc or sizes
[    6.331362] [drm] Initialized imx-drm 1.0.0 20120507 for display-subsyst=
em on minor 0
[    6.539311] fsl-ssi-dai 2030000.ssi: No cache defaults, reading back fro=
m HW
[    6.556750] etnaviv etnaviv: bound 130000.gpu (ops gpu_ops [etnaviv])
[    6.577552] etnaviv etnaviv: bound 134000.gpu (ops gpu_ops [etnaviv])
[    6.577618] etnaviv-gpu 130000.gpu: model: GC880, revision: 5106
[    6.620159] etnaviv-gpu 134000.gpu: model: GC320, revision: 5007
[    6.621947] fsl-ssi-dai 2030000.ssi: No cache defaults, reading back fro=
m HW
[    6.636524] fsl-ssi-dai 2030000.ssi: No cache defaults, reading back fro=
m HW
[    6.687923] [drm] Initialized etnaviv 1.2.0 20151214 for etnaviv on mino=
r 1
[    6.688462] fsl-ssi-dai 2030000.ssi: No cache defaults, reading back fro=
m HW
[    6.777267] fsl-ssi-dai 2030000.ssi: No cache defaults, reading back fro=
m HW
[    6.801852] fsl-ssi-dai 2030000.ssi: No cache defaults, reading back fro=
m HW
[    6.802270] caam 2100000.caam: Entropy delay =3D 3200
[    6.863076] caam 2100000.caam: Instantiated RNG4 SH0
[    6.923830] caam 2100000.caam: Instantiated RNG4 SH1
[    6.923841] caam 2100000.caam: device ID =3D 0x0a16010000000100 (Era 4)
[    6.923847] caam 2100000.caam: job rings =3D 2, qi =3D 0
[    6.930819] imx-sdma 20ec000.sdma: loaded firmware 1.1
[    7.032164] usbcore: registered new interface driver usbserial_generic
[    7.032221] usbserial: USB Serial support registered for generic
[    7.074020] usbcore: registered new interface driver ftdi_sio
[    7.074082] usbserial: USB Serial support registered for FTDI USB Serial=
 Device
[    7.074217] ftdi_sio 1-1:1.0: FTDI USB Serial Device converter detected
[    7.074340] usb 1-1: Detected FT4232H
[    7.077867] usb 1-1: FTDI USB Serial Device converter now attached to tt=
yUSB0
[    7.078115] ftdi_sio 1-1:1.1: FTDI USB Serial Device converter detected
[    7.078264] usb 1-1: Detected FT4232H
[    7.081767] usb 1-1: FTDI USB Serial Device converter now attached to tt=
yUSB1
[    7.095685] ftdi_sio 1-1:1.2: FTDI USB Serial Device converter detected
[    7.095899] usb 1-1: Detected FT4232H
[    7.103147] usb 1-1: FTDI USB Serial Device converter now attached to tt=
yUSB2
[    7.103386] ftdi_sio 1-1:1.3: FTDI USB Serial Device converter detected
[    7.103537] usb 1-1: Detected FT4232H
[    7.104979] usb 1-1: FTDI USB Serial Device converter now attached to tt=
yUSB3
[    7.161900] zram: Added device: zram0
[    7.162651] zram: Added device: zram1
[    7.165845] zram: Added device: zram2
[    7.166683] zram: Added device: zram3
[    7.220812] asoc-simple-card sound@2: ak4430 <-> 2030000.ssi mapping ok
[    7.339086] zram1: detected capacity change from 0 to 261795840
[    7.548611] Adding 255656k swap on /dev/zram1.  Priority:5 extents:1 acr=
oss:255656k SSFS
[    7.555973] zram2: detected capacity change from 0 to 261795840
[    7.732645] Adding 255656k swap on /dev/zram2.  Priority:5 extents:1 acr=
oss:255656k SSFS
[    8.046034] cfg80211: Loading compiled-in X.509 certificates for regulat=
ory database
[    8.094427] cfg80211: Loaded X.509 cert 'sforshee: 00b28ddf47aef9cea7'
[    8.094645] platform regulatory.0: Direct firmware load for regulatory.d=
b failed with error -2
[    8.094655] platform regulatory.0: Falling back to syfs fallback for: re=
gulatory.db
[    8.099460] cfg80211: failed to load regulatory.db
[    8.123797] zram0: detected capacity change from 0 to 52428800
[    8.209721] wl18xx_driver wl18xx.0.auto: Direct firmware load for ti-con=
nectivity/wl1271-nvs.bin failed with error -2
[    8.209736] wl18xx_driver wl18xx.0.auto: Falling back to syfs fallback f=
or: ti-connectivity/wl1271-nvs.bin
[    8.245628] wl1271_sdio mmc1:0001:2: wl12xx_sdio_power_on: failed to get=
_sync(-13)
[    8.450637] EXT4-fs (zram0): mounted filesystem without journal. Opts: d=
iscard
[   12.448773] random: crng init done
[   12.448783] random: 7 urandom warning(s) missed due to ratelimiting
[   12.911623] IPv6: ADDRCONF(NETDEV_UP): eth0: link is not ready
[   12.994849] Atheros 8035 ethernet 2188000.ethernet-1:00: attached PHY dr=
iver [Atheros 8035 ethernet] (mii_bus:phy_addr=3D2188000.ethernet-1:00, irq=
=3DPOLL)
[   12.994999] IPv6: ADDRCONF(NETDEV_UP): eth0: link is not ready
[   16.066091] fec 2188000.ethernet eth0: Link is Up - 1Gbps/Full - flow co=
ntrol rx/tx
[   16.066124] IPv6: ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
[   25.024267] bridge: filtering via arp/ip/ip6tables is no longer availabl=
e by default. Update your scripts to load br_netfilter if you need this.
________________________________
 Confidentiality Note: This message is intended only for the use of the nam=
ed recipient(s) and may contain confidential and/or privileged information.=
 If you are not the/an intended recipient, please contact the sender and de=
lete this message. Any unauthorized use of the information contained in thi=
s message is prohibited.

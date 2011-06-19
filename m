Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:47461 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754743Ab1FSVwB (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 19 Jun 2011 17:52:01 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: linux-wireless@vger.kernel.org, zajec5@gmail.com,
	linux-mips@linux-mips.org
Cc: mb@bu3sch.de, george@znau.edu.ua, arend@broadcom.com,
	b43-dev@lists.infradead.org, bernhardloos@googlemail.com,
	arnd@arndb.de, julian.calaby@gmail.com, sshtylyov@mvista.com,
	Hauke Mehrtens <hauke@hauke-m.de>
Subject: =?UTF-8?q?=5BRFC=20v2=2000/12=5D=20bcma=3A=20add=20support=20for=20embedded=20devices=20like=20bcm4716?=
Date: Sun, 19 Jun 2011 23:49:57 +0200
Message-Id: <1308520209-668-1-git-send-email-hauke@hauke-m.de> (sfid-20110619_235206_281108_59ECA9B4)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch series adds support for embedded devices like bcm47xx to 
bcma. Bcma is used on bcm4716 and bcm4718 SoCs. With these patches my 
bcm4716 device boots up till it tries to access the flash, because the 
serial flash chip is unsupported for now, this will be my next task. 
This adds support for MIPS cores, interrupt configuration and the 
serial console.

These patches are based on ssb code, some patches by George Kashperko 
and Bernhard Loos and parts of the source code release by ASUS and 
Netgear for their devices.

This was tested on a Netgear WNDR3400, but did not work fully because 
of serial flash.

This is bases on linux-next next-20110616, to which subsystem 
maintainer should I send these patches later, as it is based on the 
most recent version of bcma and bcm47xx?
I do not have any normal PCIe based wireless device using this bus, so 
I have not tested it with such a device, it will be nice to hear if it 
is still working on them.
The parallel flash should work so it could be that it will boot on an 
Asus rt-n16, I have not tested that.

An Ethernet driver is not included because the Braodcom source code 
available is not licensed under a GPL compatible license and building a 
new driver on that based is not possible.


Using bootmem was not possible it was not setup when plat_mem_setup was called.
 
TODO:
 * make bcm47xx built either with bcma, ssb or both and use mips MIPS 74K optimizations if possible
 * detect if a pci device is in host mode every time. -> Rafał
 * add block io support
v2:
 * use list and no arry to store cores
 * rename bcma_host_bcma_ to bcma_host_soc_
 * use core->io_addr and core->io_wrap to access cores
 * checkpatch fixes
 * some minor fixes

Bootlog till it goes down because of missing serial flash driver.

Starting program at 0x80001000
Linux version 3.0-rc3 (hauke@hauke) (gcc version 4.5.4 20110505 (prerelease) (Linaro GCC 4.5-2011.05-0) ) #1 Sun Jun 19 23:38:43 CEST 2011
bootconsole [early0] enabled
CPU revision is: 00019740 (MIPS 74Kc)
bcm47xx: using bcma bus
bcma: Core 0 found: ChipCommon (manuf 0x4BF, id 0x800, rev 0x1F, class 0x0)
bcma: Core 3 found: UNKNOWN (manuf 0x4A7, id 0x82C, rev 0x01, class 0x0)
bcma: PLL init unknown for device 0x4716
bcma: PMU resource config unknown for device 0x4716
bcma: PMU switch/regulators init unknown for device 0x4716
bcma: Workarounds unknown for device 0x4716
bcma: Initializing MIPS core...
bcma: IRQ reconfiguration done
bcma: core 0x0800, irq : 2(S)* 3  4  5  6  D  I
bcma: core 0x082c, irq : 2(S)* 3  4  5  6  D  I
bcma: Serial flash not supported.
bcma: Early bus registered
Determined physical RAM map:
 memory: 04000000 @ 00000000 (usable)
Initrd not found or empty - disabling initrd
Zone PFN ranges:
  Normal   0x00000000 -> 0x00004000
Movable zone start PFN for each node
early_node_map[1] active PFN ranges
    0: 0x00000000 -> 0x00004000
Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 16256
Kernel command line:  console=ttyS0,115200 root=/dev/mtdblock2 rootfstype=squashfs,jffs2 noinitrd console=ttyS0,115200
PID hash table entries: 256 (order: -2, 1024 bytes)
Dentry cache hash table entries: 8192 (order: 3, 32768 bytes)
Inode-cache hash table entries: 4096 (order: 2, 16384 bytes)
Primary instruction cache 32kB, VIPT, 4-way, linesize 32 bytes.
Primary data cache 32kB, 4-way, VIPT, cache aliases, linesize 32 bytes
Writing ErrCtl register=00000000
Readback ErrCtl register=00000000
Memory: 61924k/65536k available (2223k kernel code, 3612k reserved, 476k data, 160k init, 0k highmem)
NR_IRQS:128
Calibrating delay loop... 225.02 BogoMIPS (lpj=450048)
pid_max: default: 32768 minimum: 301
Mount-cache hash table entries: 512
NET: Registered protocol family 16
bio: create slab <bio-0> at 0
Switching to clocksource MIPS
Switched to NOHz mode on CPU #0
NET: Registered protocol family 2
IP route cache hash table entries: 1024 (order: 0, 4096 bytes)
TCP established hash table entries: 2048 (order: 2, 16384 bytes)
TCP bind hash table entries: 2048 (order: 1, 8192 bytes)
TCP: Hash tables configured (established 2048 bind 2048)
TCP reno registered
UDP hash table entries: 256 (order: 0, 4096 bytes)
UDP-Lite hash table entries: 256 (order: 0, 4096 bytes)
NET: Registered protocol family 1
bcma: Core 1 found: IEEE 802.11 (manuf 0x4BF, id 0x812, rev 0x11, class 0x0)
bcma: Core 2 found: GBit MAC (manuf 0x4BF, id 0x82D, rev 0x00, class 0x0)
bcma: Core 4 found: USB 2.0 Host (manuf 0x4BF, id 0x819, rev 0x04, class 0x0)
bcma: Core 5 found: PCIe (manuf 0x4BF, id 0x820, rev 0x0E, class 0x0)
bcma: Core 6 found: DDR1/DDR2 Memory Controller (manuf 0x4BF, id 0x82E, rev 0x01, class 0x0)
bcma: Core 7 found: Internal Memory (manuf 0x4BF, id 0x80E, rev 0x07, class 0x0)
bcma: Core 8 found: I2S (manuf 0x4BF, id 0x834, rev 0x00, class 0x0)
bcma: Initializing MIPS core...
bcma: set_irq: core 0x0812, irq 3 => 3
bcma: set_irq: core 0x082d, irq 4 => 4
bcma: set_irq: core 0x0819, irq 5 => 5
bcma: IRQ reconfiguration done
bcma: core 0x0800, irq : 2(S)* 3  4  5  6  D  I 
bcma: core 0x082c, irq : 2(S)* 3  4  5  6  D  I 
bcma: core 0x0812, irq : 2(S)  3* 4  5  6  D  I 
bcma: core 0x082d, irq : 2(S)  3  4* 5  6  D  I 
bcma: core 0x0819, irq : 2(S)  3  4  5* 6  D  I 
bcma: core 0x0820, irq : 2(S)  3  4  5  6* D  I 
bcma: core 0x082e, irq : 2(S)* 3  4  5  6  D  I 
bcma: core 0x080e, irq : 2(S)* 3  4  5  6  D  I 
bcma: core 0x0834, irq : 2(S)* 3  4  5  6  D  I 
bcma: No SPROM available
bcma: Bus registered
squashfs: version 4.0 (2009/01/31) Phillip Lougher
JFFS2 version 2.2 (NAND) (SUMMARY) (LZMA) (RTIME) (CMODE_PRIORITY) (c) 2001-2006 Red Hat, Inc.
msgmni has been set to 120
io scheduler noop registered
io scheduler deadline registered (default)
Serial: 8250/16550 driver, 2 ports, IRQ sharing enabled
console [ttyS0] enabled, bootconsole disabled 2) is a U6_16550A
console [ttyS0] enabled, bootconsole disabled
flash init: 0x1c000000 0x02000000
Failed to do_map_probe
BCM47xx Watchdog Timer enabled (30 seconds, nowayout)
TCP westwood registered
NET: Registered protocol family 17
802.1Q VLAN Support v1.8
Kernel not built with RTC support, ALARM timers will not wake from suspendVFS: Cannot open root device "mtdblock2" or unknown-block(0,0)
Please append a correct "root=" boot option; here are the available partitions:
Kernel panic - not syncing: VFS: Unable to mount root fs on unknown-block(0,0)

Hauke Mehrtens (12):
  bcma: move parsing of EEPROM into own function.
  bcma: move initializing of struct bcma_bus to own function.
  bcma: add functions to scan cores needed on SoCs
  bcma: add SOC bus
  bcma: add mips driver
  bcma: add serial console support
  bcma: get CPU clock
  bcma: add pci(e) host mode
  bcma: add check if sprom is available before accessing it.
  bcm47xx: prepare to support different buses
  bcm47xx: add support for bcma bus
  bcm47xx: fix irq assignment for new SoCs.

 arch/mips/Kconfig                            |    4 +
 arch/mips/bcm47xx/gpio.c                     |   63 ++++--
 arch/mips/bcm47xx/irq.c                      |   10 +
 arch/mips/bcm47xx/nvram.c                    |   21 ++-
 arch/mips/bcm47xx/serial.c                   |   38 +++-
 arch/mips/bcm47xx/setup.c                    |   69 +++++-
 arch/mips/bcm47xx/time.c                     |   12 +-
 arch/mips/bcm47xx/wgt634u.c                  |   13 +-
 arch/mips/include/asm/mach-bcm47xx/bcm47xx.h |   18 ++-
 arch/mips/include/asm/mach-bcm47xx/gpio.h    |   73 +++++--
 drivers/bcma/Kconfig                         |   20 ++
 drivers/bcma/Makefile                        |    3 +
 drivers/bcma/bcma_private.h                  |   27 ++
 drivers/bcma/driver_chipcommon.c             |   69 ++++++
 drivers/bcma/driver_chipcommon_pmu.c         |   87 +++++++
 drivers/bcma/driver_mips.c                   |  253 +++++++++++++++++++
 drivers/bcma/driver_pci.c                    |   17 ++-
 drivers/bcma/driver_pci_host.c               |   43 ++++
 drivers/bcma/host_soc.c                      |   85 +++++++
 drivers/bcma/main.c                          |   69 +++++-
 drivers/bcma/scan.c                          |  337 +++++++++++++++++---------
 drivers/bcma/sprom.c                         |    3 +
 drivers/watchdog/bcm47xx_wdt.c               |   19 ++-
 include/linux/bcma/bcma.h                    |    7 +
 include/linux/bcma/bcma_driver_chipcommon.h  |   36 +++
 include/linux/bcma/bcma_driver_mips.h        |   59 +++++
 include/linux/bcma/bcma_driver_pci.h         |    1 +
 include/linux/bcma/bcma_soc.h                |   16 ++
 28 files changed, 1298 insertions(+), 174 deletions(-)
 create mode 100644 drivers/bcma/driver_mips.c
 create mode 100644 drivers/bcma/driver_pci_host.c
 create mode 100644 drivers/bcma/host_soc.c
 create mode 100644 include/linux/bcma/bcma_driver_mips.h
 create mode 100644 include/linux/bcma/bcma_soc.h

-- 
1.7.4.1


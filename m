Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from test.hauke-m.de ([5.39.93.123]:43928 "EHLO test.hauke-m.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753286AbaHXVZW (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 24 Aug 2014 17:25:22 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: linux-wireless@vger.kernel.org, devicetree@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-mips@linux-mips.org
Cc: zajec5@gmail.com, Hauke Mehrtens <hauke@hauke-m.de>
Subject: [RFC 0/7] bcma: add device tree support
Date: Sun, 24 Aug 2014 23:24:38 +0200
Message-Id: <1408915485-8078-2-git-send-email-hauke@hauke-m.de> (sfid-20140824_232526_488594_F5805FDC)
In-Reply-To: <1408915485-8078-1-git-send-email-hauke@hauke-m.de>
References: <1408915485-8078-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This adds device tree support to bcma. In addition it also provides the 
sprom needed by bcma through a device tree driver.
This is needed for the Broadcom BCM47XX/BCM53XX ARM SoCs (NorthStar).

bcma drives the system AIX bus. This bus is scanable, so we 
automatically detect the cores attached to this bus. We only have to 
provide the address of the first core, this can now be done through 
device tree.
It is not possible to find out what IRQ is associated to a specific 
core, we have to provide this through device tree.

Broadcom uses a nvram which is a key value store on the flash chip. 
This nvram contains the mac addresses to be used by the wifi and 
Ethernet devices, the configuration data for the switch, the 
calibration data for the wifi cores and some more stuff. Currently bcma 
assumes to get some sprom when it gets initialized on a SoC. This sprom 
is a structure with all the data which are originally stored in the 
nvram. When bcma is used on a PCIe wifi card this data is fetched from 
some eeporm on the card. The nvram could contains more than one sprom, 
in case there is a main Baordocm SoC and a Broadcom wifi card connected 
via PCIe this PCIe cards mostly use the nvram to store the sprom with 
the calibration data.

This patch series adds two drivers, the nvram driver which reads the 
nvram and provides an interface to fetch values by giving a key and a 
driver which creates a sprom based on a given nvram. These two things 
are no real drivers, they are just converting stuff. I made them 
drivers so they can be replaced with some other drivers which are 
fetching the sprom from other storages. I know that the BCM63XX SoCs 
are also using an sprom, but there it is stored in a file on the file 
system. 

Some code was copied from the mips code at arch/mips/bcm47xx/ in the 
end I want to make this mips code also use these new drivers.

There is no device I know of which uses more than one nvram and I do 
not think there will ever be such a device. With this patch you have to 
provide a reference to the nvram you want to fetch data from which is a 
little bit annoying, should I remove this parameter and assume there is 
just one nvram driver in the system?

I am interested on comments if this architecture is correct or if there 
are some improvements I could do. I haven't fond similar code in the 
kernel.

Through which tree should I merge the final patches?

This is based on linus 3.17-rc1.

Log output:
bcma: bus0: Found chip with id 0xCF12, rev 0x00 and package 0x02
bcma: bus0: Core 0 found: ChipCommon (manuf 0x4BF, id 0x800, rev 0x2A, class 0x0)
bcma: bus0: Core 1 found: Chipcommon B (manuf 0x4BF, id 0x50B, rev 0x01, class 0x0)
bcma: bus0: Core 2 found: DMA (manuf 0x4BF, id 0x502, rev 0x01, class 0x0)
bcma: bus0: Core 3 found: GBit MAC (manuf 0x4BF, id 0x82D, rev 0x04, class 0x0)
bcma: bus0: Core 4 found: GBit MAC (manuf 0x4BF, id 0x82D, rev 0x04, class 0x0)
bcma: bus0: Core 5 found: GBit MAC (manuf 0x4BF, id 0x82D, rev 0x04, class 0x0)
bcma: bus0: Core 6 found: GBit MAC (manuf 0x4BF, id 0x82D, rev 0x04, class 0x0)
bcma: bus0: Core 7 found: PCIe Gen 2 (manuf 0x4BF, id 0x501, rev 0x01, class 0x0)
bcma: bus0: Core 8 found: PCIe Gen 2 (manuf 0x4BF, id 0x501, rev 0x01, class 0x0)
bcma: bus0: Core 9 found: ARM Cortex A9 core (ihost) (manuf 0x4BF, id 0x510, rev 0x01, class 0x0)
bcma: bus0: Core 10 found: USB 2.0 (manuf 0x4BF, id 0x504, rev 0x01, class 0x0)
bcma: bus0: Core 11 found: USB 3.0 (manuf 0x4BF, id 0x505, rev 0x01, class 0x0)
bcma: bus0: Core 12 found: SDIO3 (manuf 0x4BF, id 0x503, rev 0x01, class 0x0)
bcma: bus0: Core 13 found: ARM Cortex A9 JTAG (manuf 0x4BF, id 0x506, rev 0x01, class 0x0)
bcma: bus0: Core 14 found: Denali DDR2/DDR3 memory controller (manuf 0x4BF, id 0x507, rev 0x01, class 0x0)
bcma: bus0: Core 15 found: ROM (manuf 0x4BF, id 0x508, rev 0x01, class 0x0)
bcma: bus0: Core 16 found: NAND flash controller (manuf 0x4BF, id 0x509, rev 0x01, class 0x0)
bcma: bus0: Core 17 found: SPI flash controller (manuf 0x4BF, id 0x50A, rev 0x01, class 0x0)
bcma: bus0: Found sprom from device tree provider
bgmac bcma0:1: Found PHY addr: 30 (NOREGS)
bgmac bcma0:1: Support for Roboswitch not implemented
libphy: bgmac mii bus: probed
b53_common: found switch: BCM53011, rev 2
bgmac bcma0:2: Found PHY addr: 0
bgmac bcma0:2: Support for Roboswitch not implemented
libphy: bgmac mii bus: probed


Hauke Mehrtens (7):
  MIPS: BCM47XX: move the nvram header file into common space
  bcm47xx-nvram: add new broadcom nvram driver with dt support
  bcm47xx-sprom: add Broadcom sprom parser driver
  bcma: register bcma as device tree driver
  bcma: get IRQ numbers from dt
  bcma: get sprom from devicetree
  ARM: BCM5301X: register bcma bus

 Documentation/devicetree/bindings/bus/bcma.txt     |  46 ++
 .../devicetree/bindings/misc/bcm47xx-nvram.txt     |  19 +
 .../devicetree/bindings/misc/bcm47xx-sprom.txt     |  16 +
 arch/arm/boot/dts/bcm4708.dtsi                     |  58 ++
 arch/mips/bcm47xx/board.c                          |  42 +-
 arch/mips/bcm47xx/nvram.c                          |   9 +-
 arch/mips/bcm47xx/setup.c                          |   6 +-
 arch/mips/bcm47xx/sprom.c                          |   6 +-
 arch/mips/bcm47xx/time.c                           |   4 +-
 arch/mips/include/asm/mach-bcm47xx/bcm47xx_nvram.h |  53 --
 drivers/bcma/host_soc.c                            |  70 +++
 drivers/bcma/main.c                                |  42 +-
 drivers/bcma/sprom.c                               |  51 +-
 drivers/misc/Kconfig                               |  27 +
 drivers/misc/Makefile                              |   2 +
 drivers/misc/bcm47xx-nvram.c                       | 215 +++++++
 drivers/misc/bcm47xx-sprom.c                       | 690 +++++++++++++++++++++
 drivers/net/ethernet/broadcom/b44.c                |  10 +-
 drivers/net/ethernet/broadcom/bgmac.c              |   7 +-
 drivers/ssb/driver_chipcommon_pmu.c                |   9 +-
 include/linux/bcm47xx_nvram.h                      |  71 +++
 include/linux/bcma/bcma.h                          |   2 +
 22 files changed, 1350 insertions(+), 105 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/bus/bcma.txt
 create mode 100644 Documentation/devicetree/bindings/misc/bcm47xx-nvram.txt
 create mode 100644 Documentation/devicetree/bindings/misc/bcm47xx-sprom.txt
 delete mode 100644 arch/mips/include/asm/mach-bcm47xx/bcm47xx_nvram.h
 create mode 100644 drivers/misc/bcm47xx-nvram.c
 create mode 100644 drivers/misc/bcm47xx-sprom.c
 create mode 100644 include/linux/bcm47xx_nvram.h

-- 
1.9.1


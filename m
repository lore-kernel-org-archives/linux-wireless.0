Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:52214 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754945Ab2B0X5P (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Feb 2012 18:57:15 -0500
From: Hauke Mehrtens <hauke@hauke-m.de>
To: linville@tuxdriver.com
Cc: zajec5@gmail.com, b43-dev@lists.infradead.org,
	linux-mips@linux-mips.org, linux-wireless@vger.kernel.org,
	arend@broadcom.com, m@bues.ch, ralf@linux-mips.org,
	Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH v2 00/11] ssb/bcma/BCM47XX: sprom fixes and extensions
Date: Tue, 28 Feb 2012 00:56:03 +0100
Message-Id: <1330386974-4056-1-git-send-email-hauke@hauke-m.de> (sfid-20120228_005719_341875_3507357A)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch series fixes some errors in the sprom structures and extends 
it to contain members for all sprom values for sprom version 1 to 9. 
This was done by looking into the open source part of the Broadcom SDK. 
This also adds a fallback sprom registration method to bcma.
It also contains some small fixes for the bcma47xx arch code and a 
rewrite of the code to provide the sprom from flash. It now also 
provides sprom from flash for devices using bcma to control the system 
bus.

This patch series is based on wireles-testing. I think it is the best 
way to merge this through John's wireless tree as the changes in the 
sprom struct should be used in further patches extending the pci sprom 
parsing and the usage of struct sprom by the brcmsmac driver.

@Ralf could you please give me your Ack on the patches touching 
arch/mips/ or say to me what you do not like at these patches or the 
others.

v2:
 * fix drivers/ssb/pci.c:334:5: warning: unused variable 'gain'
 * rename ccode to alpha2
 * typos
 * use switch in bcm47xx_get_sprom_bcma()

Hauke Mehrtens (11):
  ssb: sprom fix some sizes / signedness
  ssb: remove 5GHz antenna gain from sprom
  ssb: fix per path sprom vars
  ssb: add alpha2
  ssb: add some missing sprom attributes
  bcma: export bcma_find_core
  bcma: add support for sprom not found on the device
  MIPS: BCM47XX: return number of written bytes in nvram_getenv
  MIPS: BCM47XX: fix signature of nvram_parse_macaddr
  MIPS: BCM47XX: move and extend sprom parsing
  MIPS: BCM47XX: provide sprom to bcma bus

 arch/mips/bcm47xx/Makefile                   |    2 +-
 arch/mips/bcm47xx/nvram.c                    |    3 +-
 arch/mips/bcm47xx/setup.c                    |  188 ++-------
 arch/mips/bcm47xx/sprom.c                    |  620 ++++++++++++++++++++++++++
 arch/mips/include/asm/mach-bcm47xx/bcm47xx.h |    3 +
 arch/mips/include/asm/mach-bcm47xx/nvram.h   |    2 +-
 drivers/bcma/main.c                          |    3 +-
 drivers/bcma/sprom.c                         |   77 +++-
 drivers/net/wireless/b43legacy/phy.c         |    2 +-
 drivers/ssb/pci.c                            |   41 +--
 drivers/ssb/pcmcia.c                         |   12 +-
 drivers/ssb/sdio.c                           |   12 +-
 include/linux/bcma/bcma.h                    |    7 +
 include/linux/ssb/ssb.h                      |  102 ++++-
 14 files changed, 848 insertions(+), 226 deletions(-)
 create mode 100644 arch/mips/bcm47xx/sprom.c

-- 
1.7.5.4


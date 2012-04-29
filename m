Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:44898 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751876Ab2D2AvK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 28 Apr 2012 20:51:10 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: linville@tuxdriver.com, arend@broadcom.com
Cc: linux-wireless@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 00/19] brcmsmac: use sprom and PCIe code from bcma
Date: Sun, 29 Apr 2012 02:50:24 +0200
Message-Id: <1335660643-26368-1-git-send-email-hauke@hauke-m.de> (sfid-20120429_025140_996374_EAC1582E)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch series is my start on getting brcmsmac to work on my SoC 
(BCM4718) and the PCIe devices connected to the SoC (BCM43224).

This patch series makes brcmsmac use the sprom parsed by bcma and 
removes the own sprom and otp parsing code.
Then it uses the boardinfo struct instead of reading out some pci 
registers to get the device subsystem vendor and id. Then the patches 
are removing some code for chips with an chip common revision of < 20 
and support for chips with a PCI core and not and PCIe core, and 
support for PCIe cores with a revision <= 10. I hope it is ok to remove 
all this stuff, I just *think* there are no devices which will ever get 
support by brcmsmac with such core revisions.
The next patches are removing the pci(e) specific code as bcma now 
provides everything which is in nicpci.c. The last patches are 
resolving some easy to fix problems with non PCI(e) based devices.

I have not completely runtime tested these patches as I do not have a 
PCI(e) devices currently supported by brcmsmac. My SoC (BCM4718) and 
the PCI devices connected to my SoC (BCM43224) are currently not 
working with brcmsmac, but they are failing much later that without 
these patches.

These patches are based on by previous patch series for bcma "bcma: add 
PCI functions from brcmsmac" and "bcma: add PCI functions from 
brcmsmac".

Hauke Mehrtens (19):
  brcmsmac: use sprom from bcma
  brcmsmac: remove brcmsmac own sprom parsing
  brcmsmac: get board and chip info from bcma
  brcmsmac: remove support for cc rev < 20
  brcmsmac: remove references to PCI
  brcmsmac: remove PCIe functions needed for PCIe core rev <= 10
  brcmsmac: remove pcicore_hwup()
  brcmsmac: remove ai_pci_setup()
  brcmsmac: remove ai_chipcontrl_epa4331
  brcmsmac: remove ai_gpiocontrol()
  brcmsmac: remove _ai_clkctl_cc()
  brcmsmac: remove pcicore_attach()
  brcmsmac: remove pcicore_find_pci_capability()
  brcmsmac: remove pcie_extendL1timer()
  brcmsmac: remove pcicore_fixcfg()
  brcmsmac: remove nicpci.c
  brcmsmac: do not access host_pci
  brcmsmac: read PCI vendor and device id only for PCI devices
  brcmsmac: handle non pci in ai_deviceremoved()

 drivers/net/wireless/brcm80211/brcmsmac/Makefile   |    3 -
 drivers/net/wireless/brcm80211/brcmsmac/aiutils.c  |  479 +---------
 drivers/net/wireless/brcm80211/brcmsmac/aiutils.h  |   24 -
 drivers/net/wireless/brcm80211/brcmsmac/antsel.c   |   16 +-
 drivers/net/wireless/brcm80211/brcmsmac/channel.c  |    7 +-
 .../net/wireless/brcm80211/brcmsmac/mac80211_if.c  |   11 +-
 drivers/net/wireless/brcm80211/brcmsmac/main.c     |  142 ++-
 drivers/net/wireless/brcm80211/brcmsmac/nicpci.c   |  826 -----------------
 drivers/net/wireless/brcm80211/brcmsmac/nicpci.h   |   77 --
 drivers/net/wireless/brcm80211/brcmsmac/otp.c      |  410 --------
 drivers/net/wireless/brcm80211/brcmsmac/otp.h      |   36 -
 .../net/wireless/brcm80211/brcmsmac/phy/phy_lcn.c  |   67 +-
 .../net/wireless/brcm80211/brcmsmac/phy/phy_n.c    |  333 +++----
 drivers/net/wireless/brcm80211/brcmsmac/phy_shim.c |    9 -
 drivers/net/wireless/brcm80211/brcmsmac/phy_shim.h |    3 -
 drivers/net/wireless/brcm80211/brcmsmac/pub.h      |  228 -----
 drivers/net/wireless/brcm80211/brcmsmac/srom.c     |  980 --------------------
 drivers/net/wireless/brcm80211/brcmsmac/srom.h     |   29 -
 drivers/net/wireless/brcm80211/brcmsmac/stf.c      |    6 +-
 19 files changed, 252 insertions(+), 3434 deletions(-)
 delete mode 100644 drivers/net/wireless/brcm80211/brcmsmac/nicpci.c
 delete mode 100644 drivers/net/wireless/brcm80211/brcmsmac/nicpci.h
 delete mode 100644 drivers/net/wireless/brcm80211/brcmsmac/otp.c
 delete mode 100644 drivers/net/wireless/brcm80211/brcmsmac/otp.h
 delete mode 100644 drivers/net/wireless/brcm80211/brcmsmac/srom.c
 delete mode 100644 drivers/net/wireless/brcm80211/brcmsmac/srom.h

-- 
1.7.9.5


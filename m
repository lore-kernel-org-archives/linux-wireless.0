Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:36187 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751239Ab2FEXIH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Jun 2012 19:08:07 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: linville@tuxdriver.com, arend@broadcom.com, brudley@broadcom.com
Cc: linux-wireless@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 00/18] brcmsmac: update to get SoCs working
Date: Wed,  6 Jun 2012 01:07:03 +0200
Message-Id: <1338937641-8519-1-git-send-email-hauke@hauke-m.de> (sfid-20120606_010812_333972_B0F67DBC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This series contains some patches needed to get brcmsmac working on 
SoCs like the BCM4718.
The last part which adds core rev 17 (used in the BCM4718) to the list 
of supported cores is missing, because we do not have a firmware 
supporting this core yet, but I extended the b43 fwcutter to generate 
a firmware which brcmsmac accepts. With this firmware my BCM4718 
works. I would appreciate an official firmware release from Broadcom 
adding support for this core.
The final patch adding support for the BCM43224 is missing because 
the PCIe host controller on the BCM4718 still causes problems and I 
have to add some more read after writes into the code, for now it uses 
an ugly hack and sometimes the problems still occur.

The wifi is not stable on the BCM4718, I had no problems connecting to 
my ath9k driven access point but I have problems connecting to my 
BCM47186 based AP running the vendor firmware with the Broadcom 
proprietary driver.
I get 12MBit/s max with the BCM4718 connected to ath9k on the 2.4 GHz 
band and 35 MBit/s max with the BCM43224 on the 5Ghz band connected to 
a Broadcom based AP running the proprietary driver. This seams to be 
CPU bounced as I have over 50% sirq in both cases.

brcmsmac starts on the BCM47186 (id: 0x5357), but it does not tx or rx 
any traffic.

One patch extends the xmtfifo_sz array for more core revs, I just toke 
the values from the other phy-n cores and hope this is correct.

These patches are depending on: "[PATCH 0/8] bcma misc updates" and 
based on wireless-testing.

Hauke Mehrtens (18):
  brcmsmac: remove PCIE() makro
  brcmsmac: remove PCI_FORCEHT() makro
  brcmsmac: remove ai_get_buscore{type,rev}()
  brcmsmac: use container_of instead of cast
  brcmsmac: remove ai_findcore()
  brcmsmac: remove si_pmu_init() and si_pmu_res_init()
  brcmsmac: remove si_pmu_spuravoid_pllupdate()
  brcmsmac: remove some redundant chip common workarounds
  brcmsmac: use core id constants from bcma
  brcmsmac: use chip and package id constants from bcma
  brcmsmac: remove some unnessessacry casts and void pointer
  brcmsmac: add a conditions for core rev 17 again
  brcmsmac: add some workarounds for other chips again
  brcmsmac: extend xmtfifo_sz array
  brcmsmac: fix DMA on SoCs
  brcmsmac: do not call brcms_c_chipmatch() for non PCI
  brcmsmac: fix read in write_phy_reg
  brcmsmac: handle non PCI devices in the phy code

 drivers/net/wireless/brcm80211/brcmsmac/aiutils.c  |  128 ++-------------
 drivers/net/wireless/brcm80211/brcmsmac/aiutils.h  |   16 --
 drivers/net/wireless/brcm80211/brcmsmac/dma.c      |   18 +-
 .../net/wireless/brcm80211/brcmsmac/mac80211_if.c  |   22 ++-
 drivers/net/wireless/brcm80211/brcmsmac/main.c     |   67 ++++++--
 .../net/wireless/brcm80211/brcmsmac/phy/phy_cmn.c  |   38 +++--
 .../net/wireless/brcm80211/brcmsmac/phy/phy_n.c    |  153 +++++++++++------
 drivers/net/wireless/brcm80211/brcmsmac/pmu.c      |  172 +-------------------
 drivers/net/wireless/brcm80211/brcmsmac/pmu.h      |    3 -
 drivers/net/wireless/brcm80211/include/soc.h       |   62 -------
 10 files changed, 230 insertions(+), 449 deletions(-)

-- 
1.7.9.5


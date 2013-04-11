Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:4549 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752582Ab3DKL3M (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Apr 2013 07:29:12 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
cc: linux-wireless <linux-wireless@vger.kernel.org>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 00/15] brcmfmac: new device support and fixes
Date: Thu, 11 Apr 2013 13:28:45 +0200
Message-ID: <1365679740-25679-1-git-send-email-arend@broadcom.com> (sfid-20130411_132919_823695_12FE6714)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch series adds support for two new SDIO devices, ie. the
BCM43143 and the BCM4335. It also contains several fixes for the
firmware-signalling feature.

This series applies to the master branch of the wireless-next
repository.

Arend van Spriel (4):
  brcmfmac: obtain iftype for firmware-signal descriptor lookup
  brcmfmac: pass ifp pointer in brcmf_fws_find_mac_desc()
  brcmfmac: rename brcmf_fws_mac_desc_ready()
  brcmfmac: remove ifidx variable from brcmf_fws_process_skb()

Franky Lin (6):
  brcmfmac: aggregate dongle ram access interface
  brcmfmac: move chip download state code to sdio_chip.c
  brcmutil: add new d11 interface support
  brcmfmac: adopt new d11 interface
  brcmfmac: add support for dongle ARM CR4 core
  brcmfmac: add BCM4335 sdio interface support

Hante Meuleman (3):
  brcmfmac: Add 43143 SDIO support.
  brcmfmac: Add drive strength programming for SDIO 43143.
  brcmfmac: define and use platform specific data for SDIO.

Piotr Haber (2):
  brcmfmac: support save&restore firmware feature
  brcmfmac: setup SDIO reset behavior

 drivers/net/wireless/brcm80211/Kconfig             |    9 -
 drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c   |  243 +++++---
 .../net/wireless/brcm80211/brcmfmac/bcmsdh_sdmmc.c |  118 ++--
 drivers/net/wireless/brcm80211/brcmfmac/dhd.h      |    1 +
 drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c |  659 ++++++++++----------
 drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c |   57 +-
 drivers/net/wireless/brcm80211/brcmfmac/p2p.c      |   98 ++-
 .../net/wireless/brcm80211/brcmfmac/sdio_chip.c    |  369 ++++++++++-
 .../net/wireless/brcm80211/brcmfmac/sdio_chip.h    |  101 ++-
 .../net/wireless/brcm80211/brcmfmac/sdio_host.h    |   32 +-
 .../net/wireless/brcm80211/brcmfmac/wl_cfg80211.c  |  141 +++--
 .../net/wireless/brcm80211/brcmfmac/wl_cfg80211.h  |    8 +-
 drivers/net/wireless/brcm80211/brcmutil/Makefile   |    3 +-
 drivers/net/wireless/brcm80211/brcmutil/d11.c      |  162 +++++
 .../net/wireless/brcm80211/include/brcm_hw_ids.h   |    2 +
 drivers/net/wireless/brcm80211/include/brcmu_d11.h |  145 +++++
 .../net/wireless/brcm80211/include/chipcommon.h    |   14 +-
 include/linux/bcma/bcma.h                          |    1 +
 include/linux/bcma/bcma_driver_chipcommon.h        |    3 +
 include/linux/bcma/bcma_regs.h                     |    1 +
 include/linux/brcmfmac_platform.h                  |  125 ++++
 21 files changed, 1593 insertions(+), 699 deletions(-)
 create mode 100644 drivers/net/wireless/brcm80211/brcmutil/d11.c
 create mode 100644 drivers/net/wireless/brcm80211/include/brcmu_d11.h
 create mode 100644 include/linux/brcmfmac_platform.h

-- 
1.7.10.4



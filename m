Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw3-out.broadcom.com ([216.31.210.64]:34167 "EHLO
	mail-gw3-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751477AbaA2Occ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Jan 2014 09:32:32 -0500
From: Arend van Spriel <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	Arend van Spriel <arend@broadcom.com>
Subject: [PATCH 00/15] brcmfmac: code rework in sdio and generic fixes
Date: Wed, 29 Jan 2014 15:32:10 +0100
Message-ID: <1391005944-3220-1-git-send-email-arend@broadcom.com> (sfid-20140129_160006_482211_507257EA)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This series reworks the SDIO part of the driver making several functions
independent of the host interface so it can be reused for PCIe driver
support which is coming soon. Other changes are cleanup and fixes in
message logging and cfg80211 interface.

This series is intended for v3.15 and applies to the master branch of
the wireless-next repository.

Arend van Spriel (7):
  brcmfmac: move SDIO specific functions
  brcmfmac: rename sdio_chip.[ch]
  brcmfmac: make chip related functions host interface independent
  brcmfmac: remove TRACE level debug message from
    brcmf_sdio_bus_sleep()
  brcmfmac: remove unintended error logging
  brcmfmac: get chip core information from the device
  brcmfmac: CR4 takes precedence over CM3 in
    brcmf_chip_enter_download()

Daniel Kim (2):
  brcmfmac: enable firmware console logging functionality
  brcmfmac: correct setting of WEP broadcast/unicast keys

Franky Lin (1):
  brcmfmac: add owner info to sdio_driver structure

Hante Meuleman (4):
  brcmfmac: expand sta info to report dtim and beacon period.
  brcmfmac: fix sdio sending of large buffers.
  brcmfmac: simplify sdio code download routine.
  brcmfmac: on sdio remove first detach bus then stop worker.

 drivers/net/wireless/brcm80211/brcmfmac/Makefile   |    4 +-
 drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c   |    8 +-
 drivers/net/wireless/brcm80211/brcmfmac/chip.c     | 1030 ++++++++++++++++++++
 drivers/net/wireless/brcm80211/brcmfmac/chip.h     |   91 ++
 drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c |  536 ++++++----
 .../net/wireless/brcm80211/brcmfmac/sdio_chip.c    |  972 ------------------
 .../net/wireless/brcm80211/brcmfmac/sdio_chip.h    |  231 -----
 .../net/wireless/brcm80211/brcmfmac/sdio_host.h    |   89 ++
 .../net/wireless/brcm80211/brcmfmac/wl_cfg80211.c  |   33 +-
 9 files changed, 1613 insertions(+), 1381 deletions(-)
 create mode 100644 drivers/net/wireless/brcm80211/brcmfmac/chip.c
 create mode 100644 drivers/net/wireless/brcm80211/brcmfmac/chip.h
 delete mode 100644 drivers/net/wireless/brcm80211/brcmfmac/sdio_chip.c
 delete mode 100644 drivers/net/wireless/brcm80211/brcmfmac/sdio_chip.h

-- 
1.7.10.4


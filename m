Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw2-out.broadcom.com ([216.31.210.63]:38819 "EHLO
	mail-gw2-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751415Ab3LLK7O (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Dec 2013 05:59:14 -0500
From: Arend van Spriel <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	Arend van Spriel <arend@broadcom.com>
Subject: [PATCH 00/18] brcmfmac: sdio rework and msgbuf protocol changes
Date: Thu, 12 Dec 2013 11:58:48 +0100
Message-ID: <1386845946-9859-1-git-send-email-arend@broadcom.com> (sfid-20131212_115918_711900_5642E6A3)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This series consists mostly of cleanup in SDIO driver code. Other changes
are preparing to new firmware protocol called msgbuf, which is intended
for PCIe fullmac devices.

Arend van Spriel (14):
  brcmfmac: add missing curly braces in brcmf_fws_txstatus_suppressed()
  brcmfmac: combine bcmsdh source files into one
  brcmfmac: remove unnecessary function prototypes
  brcmfmac: remove unused struct brcmf_sdio_dev::func_cis_ptr attribute
  brcmfmac: use sdio functions to enable/disable F2
  brcmfmac: remove brcmf_sdio_regrw_helper() from header file
  brcmfmac: remove regs parameter from sdio probe functions
  brcmfmac: get rid of some void pointer parameters
  brcmfmac: remove brcmf_sdio_wdtimer_enable() function
  brcmfmac: use consistent function names in bcmsdh.c
  brcmfmac: reduce function parameters in sdio send/receive calls
  brcmfmac: use consistent function names in dhd_sdio.c
  brcmfmac: remove brcmf_sdio_disconnect() function
  brcmfmac: clarify struct brcmf_sdio_dev::func[0] reference

Hante Meuleman (4):
  brcmfmac: Move common BCDC code in single function.
  brcmfmac: Fix hex dump for FWIL.
  brcmfmac: Add definition of new protocol layer msgbuf.
  brcmfmac: Combine protocol push hdr and bus txdata.

 drivers/net/wireless/brcm80211/brcmfmac/Makefile   |    1 -
 drivers/net/wireless/brcm80211/brcmfmac/bcdc.c     |   79 +--
 drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c   |  629 ++++++++++++++---
 .../net/wireless/brcm80211/brcmfmac/bcmsdh_sdmmc.c |  552 ---------------
 drivers/net/wireless/brcm80211/brcmfmac/dhd_bus.h  |    8 +
 drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c |  740 +++++++++-----------
 drivers/net/wireless/brcm80211/brcmfmac/fwil.c     |   12 +-
 drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c |   41 +-
 drivers/net/wireless/brcm80211/brcmfmac/proto.c    |    2 +-
 drivers/net/wireless/brcm80211/brcmfmac/proto.h    |   14 +-
 .../net/wireless/brcm80211/brcmfmac/sdio_chip.c    |  296 ++++----
 .../net/wireless/brcm80211/brcmfmac/sdio_chip.h    |    2 +-
 .../net/wireless/brcm80211/brcmfmac/sdio_host.h    |   82 +--
 drivers/net/wireless/brcm80211/brcmfmac/usb.c      |    1 +
 14 files changed, 1109 insertions(+), 1350 deletions(-)
 delete mode 100644 drivers/net/wireless/brcm80211/brcmfmac/bcmsdh_sdmmc.c

-- 
1.7.10.4


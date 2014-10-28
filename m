Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw1-out.broadcom.com ([216.31.210.62]:18132 "EHLO
	mail-gw1-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750927AbaJ1N5X (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Oct 2014 09:57:23 -0400
From: Arend van Spriel <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	Arend van Spriel <arend@broadcom.com>
Subject: [PATCH 00/16] brcmfmac: wowl support and cleanup
Date: Tue, 28 Oct 2014 14:56:03 +0100
Message-ID: <1414504579-12562-1-git-send-email-arend@broadcom.com> (sfid-20141028_145734_054840_143E985C)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This series has a couple of wowl patches that were too late to make
the 3.18 merge window. Apart from those there are a number of rename
and rework patches that get rid of the terms dhd and wl.

The series is intended for 3.19 and applies to the master branch
of the wireless-next repository.

Arend van Spriel (3):
  brcmfmac: show firmware error as string in debug message
  brcmfmac: remove unused defintion
  brcmfmac: do not use firmware error code in driver

Hante Meuleman (13):
  brcmfmac: Add wowl support for USB devices.
  brcmfmac: Add wowl support for SDIO devices.
  brcmfmac: Add wowl patterns support.
  brcmfmac: (clean) Remove usb_rdl.h as it is not needed.
  brcmfmac: (clean) Remove packet filter configuration.
  brcmfmac: (clean) Move tracepoint related function.
  brcmfmac: (clean) Rename files dhd_dbg to debug
  brcmfmac: (clean) Rename dhd_bus.h in bus.h
  brcmfmac: (clean) Rename dhd_common.c in common.c
  brcmfmac: (clean) Rename files wl_cfg80211 to cfg80211
  brcmfmac: (clean) Rename sdio related files.
  brcmfmac: (clean) Rename sdio related files.
  brcmfmac: (clean) Move sdio related function.

 drivers/net/wireless/brcm80211/brcmfmac/Makefile   |  10 +-
 drivers/net/wireless/brcm80211/brcmfmac/bcdc.c     |   6 +-
 drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c   |  51 ++-
 drivers/net/wireless/brcm80211/brcmfmac/btcoex.c   |   6 +-
 .../brcm80211/brcmfmac/{dhd_bus.h => bus.h}        |  11 +-
 .../brcmfmac/{wl_cfg80211.c => cfg80211.c}         |  77 +++-
 .../brcmfmac/{wl_cfg80211.h => cfg80211.h}         |   9 +-
 drivers/net/wireless/brcm80211/brcmfmac/chip.c     |   2 +-
 drivers/net/wireless/brcm80211/brcmfmac/common.c   | 168 +++++++++
 .../net/wireless/brcm80211/brcmfmac/commonring.c   |   2 +-
 .../brcm80211/brcmfmac/{dhd_linux.c => core.c}     |   8 +-
 .../wireless/brcm80211/brcmfmac/{dhd.h => core.h}  |   7 +-
 .../brcm80211/brcmfmac/{dhd_dbg.c => debug.c}      |   6 +-
 .../brcm80211/brcmfmac/{dhd_dbg.h => debug.h}      |   6 +-
 .../net/wireless/brcm80211/brcmfmac/dhd_common.c   | 400 ---------------------
 drivers/net/wireless/brcm80211/brcmfmac/feature.c  |  11 +-
 drivers/net/wireless/brcm80211/brcmfmac/firmware.c |   2 +-
 drivers/net/wireless/brcm80211/brcmfmac/flowring.c |   6 +-
 drivers/net/wireless/brcm80211/brcmfmac/fweh.c     |   4 +-
 drivers/net/wireless/brcm80211/brcmfmac/fwil.c     |  84 ++++-
 .../net/wireless/brcm80211/brcmfmac/fwil_types.h   |  89 +++--
 drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c |   8 +-
 drivers/net/wireless/brcm80211/brcmfmac/msgbuf.c   |   6 +-
 drivers/net/wireless/brcm80211/brcmfmac/of.c       |   4 +-
 drivers/net/wireless/brcm80211/brcmfmac/p2p.c      |   6 +-
 drivers/net/wireless/brcm80211/brcmfmac/pcie.c     |   4 +-
 drivers/net/wireless/brcm80211/brcmfmac/proto.c    |   6 +-
 .../brcm80211/brcmfmac/{dhd_sdio.c => sdio.c}      |  55 ++-
 .../brcm80211/brcmfmac/{sdio_host.h => sdio.h}     |   8 +-
 .../net/wireless/brcm80211/brcmfmac/tracepoint.c   |  16 +
 drivers/net/wireless/brcm80211/brcmfmac/usb.c      | 142 ++++++--
 drivers/net/wireless/brcm80211/brcmfmac/usb_rdl.h  |  75 ----
 drivers/net/wireless/brcm80211/brcmfmac/vendor.c   |   6 +-
 33 files changed, 650 insertions(+), 651 deletions(-)
 rename drivers/net/wireless/brcm80211/brcmfmac/{dhd_bus.h => bus.h} (98%)
 rename drivers/net/wireless/brcm80211/brcmfmac/{wl_cfg80211.c => cfg80211.c} (98%)
 rename drivers/net/wireless/brcm80211/brcmfmac/{wl_cfg80211.h => cfg80211.h} (98%)
 create mode 100644 drivers/net/wireless/brcm80211/brcmfmac/common.c
 rename drivers/net/wireless/brcm80211/brcmfmac/{dhd_linux.c => core.c} (99%)
 rename drivers/net/wireless/brcm80211/brcmfmac/{dhd.h => core.h} (98%)
 rename drivers/net/wireless/brcm80211/brcmfmac/{dhd_dbg.c => debug.c} (98%)
 rename drivers/net/wireless/brcm80211/brcmfmac/{dhd_dbg.h => debug.h} (98%)
 delete mode 100644 drivers/net/wireless/brcm80211/brcmfmac/dhd_common.c
 rename drivers/net/wireless/brcm80211/brcmfmac/{dhd_sdio.c => sdio.c} (98%)
 rename drivers/net/wireless/brcm80211/brcmfmac/{sdio_host.h => sdio.h} (98%)
 delete mode 100644 drivers/net/wireless/brcm80211/brcmfmac/usb_rdl.h

-- 
1.9.1


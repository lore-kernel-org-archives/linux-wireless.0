Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw3-out.broadcom.com ([216.31.210.64]:59323 "EHLO
	mail-gw3-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752008AbaE0K4f (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 May 2014 06:56:35 -0400
From: Arend van Spriel <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	Arend van Spriel <arend@broadcom.com>
Subject: [PATCH 00/16] brcmfmac: async firmware loading and USB3.0 detection
Date: Tue, 27 May 2014 12:56:12 +0200
Message-ID: <1401188188-16492-1-git-send-email-arend@broadcom.com> (sfid-20140527_125653_799533_2CF8209F)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This series mainly changes the driver to use the asynchronous firmware request
API. Hante also made couple of fixes that are needed to properly detect USB3.0
devices. Remaining patches are small fixes in scanning and connecting.

These patches are intended for v3.16 and apply to the master branch of
the wireless-next repository.

Arend van Spriel (13):
  brcmfmac: reduce log level for invalid scheduled scan request
  brcmfmac: restore mpc before passing scan status to cfg80211
  brcmfmac: make chandef_to_chanspec() function static
  brcmfmac: remove .init() callback for internal bus interface
  brcmfmac: rename nvram.[ch] for upcoming firmware handling functions
  brcmfmac: call brcmf_detach() unconditional in sdio .remove()
    callback
  brcmfmac: rework usb callback operations
  brcmfmac: introduce asynchronous firmware loading
  brcmfmac: use asynchronous firmware request in SDIO
  brcmfmac: use asynchronous firmware request in USB
  brcmfmac: make brcmf_fw_nvram_strip() static
  brcmutil: assure unused bits are cleared in 11n chanspec
  brcmfmac: remove firmware list from USB driver

Daniel Kim (1):
  brcmfmac: Increase max buffer size for receiving control message from
    dongle

Hante Meuleman (2):
  brcmfmac: Add log of superspeed device detection to USB probe.
  brcmfmac: Remove interrupt endpoint usage from USB driver.

 drivers/net/wireless/brcm80211/brcmfmac/Makefile   |    2 +-
 drivers/net/wireless/brcm80211/brcmfmac/dhd_bus.h  |    6 -
 .../net/wireless/brcm80211/brcmfmac/dhd_linux.c    |    7 -
 drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c |  283 +++++++++-----------
 .../brcm80211/brcmfmac/{nvram.c => firmware.c}     |  113 +++++++-
 .../brcm80211/brcmfmac/{nvram.h => firmware.h}     |   24 +-
 drivers/net/wireless/brcm80211/brcmfmac/usb.c      |  269 ++++++-------------
 .../net/wireless/brcm80211/brcmfmac/wl_cfg80211.c  |   11 +-
 drivers/net/wireless/brcm80211/brcmutil/d11.c      |    2 +-
 9 files changed, 352 insertions(+), 365 deletions(-)
 rename drivers/net/wireless/brcm80211/brcmfmac/{nvram.c => firmware.c} (65%)
 rename drivers/net/wireless/brcm80211/brcmfmac/{nvram.h => firmware.h} (52%)

-- 
1.7.9.5


Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:3380 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933258Ab2KOCqf (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Nov 2012 21:46:35 -0500
From: "Franky Lin" <frankyl@broadcom.com>
To: linville@tuxdriver.com
cc: linux-wireless@vger.kernel.org
Subject: [PATCH 00/19] brcmfmac: work for firmware event, suspend/resume
 and init/deinit
Date: Wed, 14 Nov 2012 18:46:04 -0800
Message-ID: <1352947583-25341-1-git-send-email-frankyl@broadcom.com> (sfid-20121115_034655_520371_6A77979A)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Arend has some patches to restructure the firmware event handling code and fix
some issue related to IF event. Also Hante has been working on suspend/resume
for USB bus interface as well as init/deinit routine.

Arend van Spriel (9):
  brcmfmac: rework firmware event handling code
  brcmfmac: change parameter in brcmf_add_if() function
  brcmfmac: fix for multiple netdevice interface support
  brcmfmac: correct handling IF firmware event
  brcmfmac: change mac address parameter in brcmf_add_if()
  brcmfmac: remove mac address validation from brcmf_net_attach()
  brcmfmac: fix wrong usage of unaligned include file
  brcmfmac: ignore IF event if it is a add for ifidx 0
  brcmfmac: restructure handling of IF event

Hante Meuleman (10):
  brcmfmac: cleanup of usb firmware download routines
  brcmfmac: usb suspend/resume.
  brcmfmac: fix NULL pointer access in brcmf_fweh_detach()
  brcmfmac: Any error should result in failure of probe.
  brcmfmac: Handle mmc exceptions during init correct.
  brcmfmac: sdio unload fix.
  brcmfmac: avoid usage of func->card->dev in sdio probe.
  brcmfmac: sdio module load fix.
  brcmfmac: limit hex dump on fwil.
  brcmfmac: code cleanup

 drivers/net/wireless/brcm80211/brcmfmac/Makefile   |    1 +
 drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c   |   15 +-
 .../net/wireless/brcm80211/brcmfmac/bcmsdh_sdmmc.c |  133 ++---
 drivers/net/wireless/brcm80211/brcmfmac/dhd.h      |  138 +-----
 drivers/net/wireless/brcm80211/brcmfmac/dhd_bus.h  |    3 +-
 drivers/net/wireless/brcm80211/brcmfmac/dhd_cdc.c  |    2 -
 .../net/wireless/brcm80211/brcmfmac/dhd_common.c   |  423 ----------------
 drivers/net/wireless/brcm80211/brcmfmac/dhd_dbg.c  |    5 -
 .../net/wireless/brcm80211/brcmfmac/dhd_linux.c    |  219 ++++-----
 .../net/wireless/brcm80211/brcmfmac/dhd_proto.h    |    4 -
 drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c |   25 +-
 drivers/net/wireless/brcm80211/brcmfmac/fweh.c     |  506 ++++++++++++++++++++
 drivers/net/wireless/brcm80211/brcmfmac/fweh.h     |  207 ++++++++
 drivers/net/wireless/brcm80211/brcmfmac/fwil.c     |   22 +-
 drivers/net/wireless/brcm80211/brcmfmac/usb.c      |  200 +++-----
 drivers/net/wireless/brcm80211/brcmfmac/usb.h      |   18 +-
 .../net/wireless/brcm80211/brcmfmac/wl_cfg80211.c  |  288 +++--------
 .../net/wireless/brcm80211/brcmfmac/wl_cfg80211.h  |   35 +-
 18 files changed, 1055 insertions(+), 1189 deletions(-)
 create mode 100644 drivers/net/wireless/brcm80211/brcmfmac/fweh.c
 create mode 100644 drivers/net/wireless/brcm80211/brcmfmac/fweh.h

-- 
1.7.9.5



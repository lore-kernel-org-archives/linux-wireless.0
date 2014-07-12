Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw1-out.broadcom.com ([216.31.210.62]:2887 "EHLO
	mail-gw1-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751515AbaGLGtp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 12 Jul 2014 02:49:45 -0400
From: Arend van Spriel <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	Arend van Spriel <arend@broadcom.com>
Subject: [PATCH 0/9] brcmfmac: cleanup wiphy setup and debugfs
Date: Sat, 12 Jul 2014 08:49:33 +0200
Message-ID: <1405147782-12768-1-git-send-email-arend@broadcom.com> (sfid-20140712_085001_669513_CDBFFBE1)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This series mainly fixes the wiphy setup as it was showing wrong
info when running multiple brcmfmac devices in the system. Another
thing reworked is the debugfs code making it easier to add an
entry in the driver. A new debugfs being 'features' entry that
will show which features are enabled for a device.

This series is intended for 3.17 and applies to the master branch
of wireless-next repository.

Arend van Spriel (7):
  brcmfmac: make use of seq_file API for debugfs entries
  brcmfmac: rework debugfs functions in the driver
  brcmfmac: move attach and detach functions in wl_cfg80211.c
  brcmfmac: introduce feature and quirk handling
  brcmfmac: moving some functions around
  brcmfmac: rework wiphy structure setup
  brcmfmac: add brcmf_p2p_detach() call in brcmf_cfg80211_detach()

Daniel Kim (1):
  brcmfmac: Make firmware path a module parameter

Hante Meuleman (1):
  brcmfmac: Cleanup used device IDs.

 drivers/net/wireless/brcm80211/brcmfmac/Makefile   |   1 +
 drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c   |  23 +-
 drivers/net/wireless/brcm80211/brcmfmac/chip.c     |  28 +-
 drivers/net/wireless/brcm80211/brcmfmac/dhd.h      |   5 +-
 drivers/net/wireless/brcm80211/brcmfmac/dhd_dbg.c  | 197 +----
 drivers/net/wireless/brcm80211/brcmfmac/dhd_dbg.h  |  74 +-
 .../net/wireless/brcm80211/brcmfmac/dhd_linux.c    |  13 +-
 drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c | 274 +++---
 drivers/net/wireless/brcm80211/brcmfmac/feature.c  | 137 +++
 drivers/net/wireless/brcm80211/brcmfmac/feature.h  |  87 ++
 drivers/net/wireless/brcm80211/brcmfmac/firmware.c |   5 +
 drivers/net/wireless/brcm80211/brcmfmac/firmware.h |   5 +
 drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c | 100 ++-
 .../net/wireless/brcm80211/brcmfmac/sdio_host.h    |   4 +
 drivers/net/wireless/brcm80211/brcmfmac/usb.c      |  49 +-
 .../net/wireless/brcm80211/brcmfmac/wl_cfg80211.c  | 984 +++++++++++----------
 .../net/wireless/brcm80211/include/brcm_hw_ids.h   |  60 +-
 17 files changed, 1140 insertions(+), 906 deletions(-)
 create mode 100644 drivers/net/wireless/brcm80211/brcmfmac/feature.c
 create mode 100644 drivers/net/wireless/brcm80211/brcmfmac/feature.h

-- 
1.9.1


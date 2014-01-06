Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw2-out.broadcom.com ([216.31.210.63]:59121 "EHLO
	mail-gw2-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754281AbaAFLk5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Jan 2014 06:40:57 -0500
From: Arend van Spriel <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	Arend van Spriel <arend@broadcom.com>
Subject: [PATCH 00/15] brcmfmac: sdio and netdev related cleanup
Date: Mon, 6 Jan 2014 12:40:35 +0100
Message-ID: <1389008450-28529-1-git-send-email-arend@broadcom.com> (sfid-20140106_124112_877516_8EDD8DDF)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This series cleans up some functions in the SDIO part of the brcmfmac driver
and in handling netdevice cleanup upon module unload, which get rid of a
warning from cfg80211. Working that part of code revealed cfg80211 was
accessing the struct wireless_dev pointer, which brcmfmac already had released.

The mmc patch moves brcmfmac SDIO device identifiers to
include/linux/mmc/sdio_ids.h. Decided to submit this through
the wireless tree. Let me know if that is ok.

This series is intended for 3.14 and applies to the master branch of
the wireless-next repository.

Arend van Spriel (13):
  brcmfmac: rework SDIO register access functions
  brcmfmac: cleanup helper functions in sdio remove path
  brcmfmac: cleanup helper functions in sdio probe path
  brcmfmac: correct reporting HT40 support in wiphy htcap
  brcmfmac: add sdio drive strength programming for bcm4334 chipset
  brcmfmac: correct detection of save&restore device capability
  brcmfmac: enable watchdog when bus initialization is complete
  brcmfmac: only disable clock when brcmf_sdio_bus_init() fails
  brcmfmac: inform cfg80211 when changing the CONNECTED state
  brcmfmac: move wiphy_unregister() call to brcmf_cfg80211_detach()
  brcmfmac: call brcmf_cfg80211_detach() after removal of interfaces
  brcmfmac: use custom destructor callback for all netdevice interfaces
  mmc: add SDIO identifiers for Broadcom WLAN devices

Hante Meuleman (2):
  brcmfmac: Remove some obsolete definitions and variables.
  brcmfmac: Limit control message length from host to device.

 drivers/net/wireless/brcm80211/brcmfmac/bcdc.c     |   10 +-
 drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c   |  229 ++++++++------------
 drivers/net/wireless/brcm80211/brcmfmac/dhd.h      |    7 +-
 .../net/wireless/brcm80211/brcmfmac/dhd_common.c   |    2 -
 .../net/wireless/brcm80211/brcmfmac/dhd_linux.c    |    9 +-
 drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c |  162 ++++++--------
 drivers/net/wireless/brcm80211/brcmfmac/p2p.c      |   43 +---
 .../net/wireless/brcm80211/brcmfmac/sdio_chip.c    |   13 ++
 .../net/wireless/brcm80211/brcmfmac/sdio_chip.h    |    8 -
 .../net/wireless/brcm80211/brcmfmac/sdio_host.h    |    1 -
 .../net/wireless/brcm80211/brcmfmac/wl_cfg80211.c  |  164 ++++++++------
 .../net/wireless/brcm80211/brcmfmac/wl_cfg80211.h  |    5 +-
 .../net/wireless/brcm80211/include/brcmu_wifi.h    |   14 ++
 include/linux/mmc/sdio_ids.h                       |    9 +
 14 files changed, 326 insertions(+), 350 deletions(-)

-- 
1.7.10.4


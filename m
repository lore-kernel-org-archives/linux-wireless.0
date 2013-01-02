Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:3914 "EHLO mms3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752788Ab3ABOX1 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Jan 2013 09:23:27 -0500
From: "Arend van Spriel" <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
cc: "Linux Wireless List" <linux-wireless@vger.kernel.org>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 00/18] brcm80211: cleanup work
Date: Wed, 2 Jan 2013 15:22:33 +0100
Message-ID: <1357136572-18273-1-git-send-email-arend@broadcom.com> (sfid-20130102_155321_272539_3E0C7B87)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

cleanup and rework on both drivers although mostly on
brcmfmac.

This series is intended for v3.9 and applies to the master
branch of wireless-next.

Arend van Spriel (9):
  brcmsmac: use perimeter lock in add_interface() callback
  brcmsmac: allow user-space setting of interface address
  brcmfmac: assure USB dongle firmware is reset upon module unload
  brcmfmac: define pr_fmt in one place
  brcmfmac: remove rx helper function from bus interface
  brcmfmac: remove brcmf_proto_hdrpull() from bus interface
  brcmfmac: remove unused event related definitions
  brcmfmac: cleanup netdev transmit callback
  brcmfmac: remove unnecessary curly braces in dhd_attach()

Hante Meuleman (7):
  brcmfmac: do not reconfigure refill rx on 0-length packet.
  brcmfmac: removed deprecated set_bitrate_mask support
  brcmfmac: Use dedicated trace level for CDC.
  brcmfmac: Remove unused caching dongle error.
  brcmfmac: Return correct error on netdev xmit.
  brcmfmac: Removing obsolete variables and inline functions.
  brcmfmac: Update init code routines from interface up.

Piotr Haber (2):
  brcmsmac: increase timer reference count for new timers only
  brcmsmac: remove dead code

 drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c   |    2 -
 .../net/wireless/brcm80211/brcmfmac/bcmsdh_sdmmc.c |    2 -
 drivers/net/wireless/brcm80211/brcmfmac/dhd.h      |   39 ++------
 drivers/net/wireless/brcm80211/brcmfmac/dhd_bus.h  |   19 +---
 drivers/net/wireless/brcm80211/brcmfmac/dhd_cdc.c  |   48 +++-------
 .../net/wireless/brcm80211/brcmfmac/dhd_common.c   |    2 -
 drivers/net/wireless/brcm80211/brcmfmac/dhd_dbg.h  |   50 +++++------
 .../net/wireless/brcm80211/brcmfmac/dhd_linux.c    |   90 +++++++++++--------
 drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c |   24 ++---
 .../net/wireless/brcm80211/brcmfmac/sdio_chip.c    |    2 -
 drivers/net/wireless/brcm80211/brcmfmac/usb.c      |   27 ++++--
 .../net/wireless/brcm80211/brcmfmac/wl_cfg80211.c  |   94 +++-----------------
 drivers/net/wireless/brcm80211/brcmsmac/ampdu.c    |    7 +-
 .../net/wireless/brcm80211/brcmsmac/mac80211_if.c  |   10 ++-
 drivers/net/wireless/brcm80211/brcmsmac/main.c     |    7 +-
 drivers/net/wireless/brcm80211/brcmsmac/scb.h      |    1 -
 16 files changed, 146 insertions(+), 278 deletions(-)

-- 
1.7.10.4



Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw3-out.broadcom.com ([216.31.210.64]:13244 "EHLO
	mail-gw3-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759931AbbAYTbr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 25 Jan 2015 14:31:47 -0500
From: Arend van Spriel <arend@broadcom.com>
To: Kalle Valo <kvalo@codeaurora.org>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	Arend van Spriel <arend@broadcom.com>
Subject: [PATCH 00/14] brcm80211: sdio suspend rework and other fixes
Date: Sun, 25 Jan 2015 20:31:29 +0100
Message-ID: <1422214303-7816-1-git-send-email-arend@broadcom.com> (sfid-20150125_204445_422822_0379783E)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch series reworks some code in SDIO part of the brcmfmac
driver related to suspend/resume that were found doing stress testing.
In PCIe part scheduling of worker thread needed to be relaxed.
Other changes involve minor fixes and exposing firmware revision
information to user-space, ie. ethtool.

This series is intended for v3.20 and applies to the master branch
of the wireless-drivers-next repository.

Arend van Spriel (9):
  brcmfmac: pass DEAUTH/DISASSOC reason code to user-space
  brcmfmac: wait for driver to go idle during suspend
  brcmfmac: do not load firmware when device is already running
  brcmutil: use define for boardrev string function
  brcmfmac: determine chip info when not provided by bus layer
  brcmfmac: always obtain device revision info upon intialization
  brcmfmac: show firmware release info in ethtool driver info
  brcmfmac: store revinfo retrieval result
  brcmfmac: fix nvram processing

Hante Meuleman (5):
  brcmfmac: Relax scheduling of msgbuf worker on high throughput.
  brcmfmac: prevent possible deadlock on resuming SDIO device.
  brcmfmac: use SDIO DPC for control frames.
  brcmfmac: SDIO: avoid using bus state for private states.
  brcmfmac: Reopen netdev queue on bus state data.

 drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c   |  70 ++++-----
 drivers/net/wireless/brcm80211/brcmfmac/bus.h      |  24 +--
 drivers/net/wireless/brcm80211/brcmfmac/cfg80211.c |  31 +++-
 drivers/net/wireless/brcm80211/brcmfmac/common.c   |  31 +++-
 .../net/wireless/brcm80211/brcmfmac/commonring.h   |   2 +
 drivers/net/wireless/brcm80211/brcmfmac/core.c     |  39 ++++-
 drivers/net/wireless/brcm80211/brcmfmac/core.h     |  30 ++++
 drivers/net/wireless/brcm80211/brcmfmac/firmware.c |   6 +-
 drivers/net/wireless/brcm80211/brcmfmac/fwil.c     |   2 +-
 drivers/net/wireless/brcm80211/brcmfmac/fwil.h     |   1 +
 .../net/wireless/brcm80211/brcmfmac/fwil_types.h   |  41 +++++
 drivers/net/wireless/brcm80211/brcmfmac/msgbuf.c   |  30 +++-
 drivers/net/wireless/brcm80211/brcmfmac/pcie.c     |   2 +-
 drivers/net/wireless/brcm80211/brcmfmac/sdio.c     | 168 ++++++++++-----------
 drivers/net/wireless/brcm80211/brcmfmac/sdio.h     |  12 +-
 drivers/net/wireless/brcm80211/brcmfmac/usb.c      |   4 +-
 drivers/net/wireless/brcm80211/brcmsmac/debug.c    |   2 +-
 drivers/net/wireless/brcm80211/brcmutil/utils.c    |  32 +++-
 .../net/wireless/brcm80211/include/brcmu_utils.h   |   4 +
 19 files changed, 348 insertions(+), 183 deletions(-)

-- 
1.9.1


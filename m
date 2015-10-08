Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw3-out.broadcom.com ([216.31.210.64]:32306 "EHLO
	mail-gw3-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753212AbbJHSdY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Oct 2015 14:33:24 -0400
From: Arend van Spriel <arend@broadcom.com>
To: Kalle Valo <kvalo@codeaurora.org>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	Arend van Spriel <arend@broadcom.com>
Subject: [PATCH 00/11] brcmfmac: cfg80211 callbacks and coredump
Date: Thu, 8 Oct 2015 20:33:10 +0200
Message-ID: <1444329201-3696-1-git-send-email-arend@broadcom.com> (sfid-20151008_203328_468089_FC9B3957)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This series provides following:

* using netdev carrier state.
* add and rework some cfg80211 callbacks mainly for AP mode.
* use devcoredump when triggered by firmware event.

The series is intended for 4.4 kernel and applies to the
master branch of wireless-drivers-next repository.

Arend van Spriel (2):
  brcmfmac: expose device memory to devcoredump subsystem
  brcmfmac: remove conversational comment

Franky Lin (1):
  brcmfmac: rename firmware_path to alternative_fw_path

Hante Meuleman (8):
  brcmfmac: Fix race condition between USB probe/load and disconnect.
  brcmfmac: Rework p2p attach, use single method for p2p dev creation.
  brcmfmac: Fix station info rate information.
  brcmfmac: Add RSSI information to get_station.
  brcmfmac: Add dump_station support to cfg80221 ops.
  brcmfmac: Move brcmf_c_preinit_dcmds prototype to correct file.
  brcmfmac: Remove unused state AP creating.
  brcmfmac: Properly set carrier state of netdev.

 drivers/net/wireless/brcm80211/Kconfig             |  1 +
 drivers/net/wireless/brcm80211/brcmfmac/bus.h      | 21 ++++++
 drivers/net/wireless/brcm80211/brcmfmac/cfg80211.c | 86 ++++++++++++++++++++--
 drivers/net/wireless/brcm80211/brcmfmac/cfg80211.h |  3 +-
 drivers/net/wireless/brcm80211/brcmfmac/common.h   |  3 +
 drivers/net/wireless/brcm80211/brcmfmac/core.c     | 65 ++++++++--------
 drivers/net/wireless/brcm80211/brcmfmac/core.h     | 11 +--
 drivers/net/wireless/brcm80211/brcmfmac/debug.c    | 42 ++++++++++-
 drivers/net/wireless/brcm80211/brcmfmac/debug.h    |  8 +-
 drivers/net/wireless/brcm80211/brcmfmac/firmware.c |  2 +-
 drivers/net/wireless/brcm80211/brcmfmac/fweh.c     |  3 +-
 drivers/net/wireless/brcm80211/brcmfmac/fwil.h     |  1 +
 .../net/wireless/brcm80211/brcmfmac/fwil_types.h   | 13 ++++
 drivers/net/wireless/brcm80211/brcmfmac/msgbuf.c   |  3 -
 drivers/net/wireless/brcm80211/brcmfmac/p2p.c      | 71 +++---------------
 drivers/net/wireless/brcm80211/brcmfmac/pcie.c     | 65 ++++++++++++++++
 drivers/net/wireless/brcm80211/brcmfmac/sdio.c     | 49 +++++++++++-
 drivers/net/wireless/brcm80211/brcmfmac/usb.c      | 29 +++++++-
 18 files changed, 355 insertions(+), 121 deletions(-)

-- 
1.9.1


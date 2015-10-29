Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw2-out.broadcom.com ([216.31.210.63]:61989 "EHLO
	mail-gw2-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757134AbbJ2Tnu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 29 Oct 2015 15:43:50 -0400
From: Arend van Spriel <arend@broadcom.com>
To: Kalle Valo <kvalo@codeaurora.org>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	Arend van Spriel <arend@broadcom.com>
Subject: [PATCH 0/9] brcmfmac: new device support and cleanup
Date: Thu, 29 Oct 2015 20:33:10 +0100
Message-ID: <1446147199-21671-1-git-send-email-arend@broadcom.com> (sfid-20151029_204353_593199_F6A0A01F)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Here a smallish series which hopefully can make it in 4.4 release. The
highlights are:

* support bcm4359 which can operate in two bands concurrently.
* disable runtime pm for USB avoiding issues.
* use generic pm callback in PCIe driver.
* support wowlan wake indication reporting.

The series is intended for v4.4 and applies to the master branch
of the wireless-drivers-next repository.

Hante Meuleman (9):
  brcmfmac: Add support for the BCM4359 11ac RSDB PCIE device.
  brcmfmac: Simplify and fix usage of brcmf_ifname.
  brcmfmac: Remove unnecessary check from start_xmit.
  brcmfmac: Remove unncessary variable irq_requested.
  brcmfmac: Disable runtime pm for USB.
  brcmfmac: Add RSDB support.
  brcmfmac: Use consistent naming for bsscfgidx.
  brcmfmac: Use new methods for pcie Power Management.
  brcmfmac: Add wowl wake indication report.

 drivers/net/wireless/brcm80211/brcmfmac/bcdc.c     |  10 +-
 drivers/net/wireless/brcm80211/brcmfmac/cfg80211.c |  87 +++++++++++++++--
 drivers/net/wireless/brcm80211/brcmfmac/chip.c     |   1 +
 drivers/net/wireless/brcm80211/brcmfmac/core.c     | 105 +++++++++------------
 drivers/net/wireless/brcm80211/brcmfmac/core.h     |   8 +-
 drivers/net/wireless/brcm80211/brcmfmac/debug.c    |   2 +-
 drivers/net/wireless/brcm80211/brcmfmac/feature.c  |   1 +
 drivers/net/wireless/brcm80211/brcmfmac/feature.h  |   5 +-
 drivers/net/wireless/brcm80211/brcmfmac/fweh.c     |   8 +-
 drivers/net/wireless/brcm80211/brcmfmac/fweh.h     |   2 +-
 drivers/net/wireless/brcm80211/brcmfmac/fwil.c     |  28 +++---
 .../net/wireless/brcm80211/brcmfmac/fwil_types.h   |  14 ++-
 drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c |   4 +-
 drivers/net/wireless/brcm80211/brcmfmac/p2p.c      |   6 +-
 drivers/net/wireless/brcm80211/brcmfmac/pcie.c     | 104 +++++++++-----------
 drivers/net/wireless/brcm80211/brcmfmac/usb.c      |   1 -
 .../net/wireless/brcm80211/include/brcm_hw_ids.h   |   2 +
 17 files changed, 225 insertions(+), 163 deletions(-)

-- 
1.9.1


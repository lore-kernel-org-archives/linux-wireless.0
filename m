Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw2-out.broadcom.com ([216.31.210.63]:59604 "EHLO
	mail-gw2-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753854AbbIRUIY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Sep 2015 16:08:24 -0400
From: Arend van Spriel <arend@broadcom.com>
To: Kalle Valo <kvalo@codeaurora.org>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	Arend van Spriel <arend@broadcom.com>
Subject: [PATCH 00/16] brcmfmac: new device support and P2P fixes
Date: Fri, 18 Sep 2015 22:08:03 +0200
Message-ID: <1442606899-31872-1-git-send-email-arend@broadcom.com> (sfid-20150918_220828_739738_9EB906D7)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This series is intended for v4.4 containing the following highlights:

* support for BCM4350, BCM4365, and BCM4366 PCIE devices.
* fixed for legacy P2P and P2P device handling.
* correct set and get tx-power.

The series should be applied to master branch of the wireless-drivers-next
repository after the series sent earlier with
Message-ID: <1440620104-2715-1-git-send-email-arend@broadcom.com>
and patch "brcmfmac: Reset PCIE devices after recognition." with
Message-ID: <1440684846-17214-1-git-send-email-arend@broadcom.com>.

Hante Meuleman (16):
  brcmfmac: Fix exception handling.
  brcmfmac: Add support for the BCM4350 PCIE device.
  brcmfmac: Fix set and get tx-power functions.
  brcmfmac: Only assign primary netdev to if2bss array.
  brcmfmac: Inform p2p module about p2pon through API
  brcmfmac: Fix bug in flowring management.
  brcmfmac: Make p2pon module param always available.
  brcmfmac: Workaround in change vif for wpa_supplicant support.
  brcmfmac: Deleting of p2p device is leaking memory.
  brcmfmac: Only handle p2p_stop_device if vif is valid
  brcmfmac: Fix p2p bug for older firmwares.
  brcmfmac: Add module parameter to disable features.
  brcmfmac: Fix race condition bug when deleting p2p interface.
  brcmfmac: Add support for the BCM4365 and BCM4366 PCIE devices.
  brcmfmac: Fix TDLS setup by properly handling p2p noif.
  brcmfmac: Accept events when TDLS is used in combination with p2p.

 drivers/net/wireless/brcm80211/brcmfmac/cfg80211.c | 186 +++++++--------------
 drivers/net/wireless/brcm80211/brcmfmac/cfg80211.h |   3 +-
 drivers/net/wireless/brcm80211/brcmfmac/chip.c     | 111 ++++++++++--
 drivers/net/wireless/brcm80211/brcmfmac/core.c     |  34 +++-
 drivers/net/wireless/brcm80211/brcmfmac/feature.c  |  13 ++
 drivers/net/wireless/brcm80211/brcmfmac/flowring.h |   2 +-
 drivers/net/wireless/brcm80211/brcmfmac/fweh.c     |  26 ++-
 drivers/net/wireless/brcm80211/brcmfmac/fweh.h     |   3 +
 drivers/net/wireless/brcm80211/brcmfmac/p2p.c      |  92 ++++++----
 drivers/net/wireless/brcm80211/brcmfmac/p2p.h      |   5 +-
 drivers/net/wireless/brcm80211/brcmfmac/pcie.c     |  31 ++++
 .../net/wireless/brcm80211/include/brcm_hw_ids.h   |  11 ++
 include/linux/bcma/bcma.h                          |   2 +
 13 files changed, 331 insertions(+), 188 deletions(-)

-- 
1.9.1


Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw3-out.broadcom.com ([216.31.210.64]:25612 "EHLO
	mail-gw3-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754313AbbFJWMb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Jun 2015 18:12:31 -0400
From: Arend van Spriel <arend@broadcom.com>
To: Kalle Valo <kvalo@codeaurora.org>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	Arend van Spriel <arend@broadcom.com>
Subject: [PATCH 0/7] brcmfmac: cfg80211 api rework and p2p device fixes
Date: Thu, 11 Jun 2015 00:12:16 +0200
Message-ID: <1433974343-16982-1-git-send-email-arend@broadcom.com> (sfid-20150611_001235_340949_69686A56)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hope to make the deadline with this series for 4.2 kernel. Here the
highlights of this series:

* rework .get_station() cfg80211 callback operation.
* determine interface combinations upon device feature support.
* fix p2p-device removal upon driver unload.

The series applies to the master branch of the wireless-drivers-next
repository.

Arend van Spriel (5):
  brcmfmac: rework .get_station() callback
  brcmfmac: have sdio return -EIO when device communication is not
    possible
  brcmfmac: free ifp for non-netdev interface in p2p module
  brcmfmac: move p2p attach/detach functions
  brcmfmac: assure p2pdev is unregistered upon driver unload

Pontus Fuchs (2):
  brcmfmac: Check if firmware supports p2p
  brcmfmac: Build wiphy mode and interface combinations dynamically

 drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c   |   1 +
 drivers/net/wireless/brcm80211/brcmfmac/cfg80211.c | 314 +++++++++++----------
 drivers/net/wireless/brcm80211/brcmfmac/core.c     |   3 +-
 drivers/net/wireless/brcm80211/brcmfmac/feature.c  |   1 +
 drivers/net/wireless/brcm80211/brcmfmac/feature.h  |   4 +-
 .../net/wireless/brcm80211/brcmfmac/fwil_types.h   |  79 ++++--
 drivers/net/wireless/brcm80211/brcmfmac/p2p.c      | 203 ++++++-------
 drivers/net/wireless/brcm80211/brcmfmac/sdio.c     |   6 +
 8 files changed, 346 insertions(+), 265 deletions(-)

-- 
1.9.1


Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:2820 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755075Ab3IYKLU (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Sep 2013 06:11:20 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
cc: linux-wireless <linux-wireless@vger.kernel.org>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH for-3.12 0/3] brcm80211: fixes for reported issues
Date: Wed, 25 Sep 2013 12:11:00 +0200
Message-ID: <1380103864-10447-1-git-send-email-arend@broadcom.com> (sfid-20130925_121123_502156_3461CB35)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This series contains a couple of fixes that have been reported by
users/developers.

This series is intended for v3.12 and applies to the master branch
of the wireless repository.

Regards,
Arend

Arend van Spriel (3):
  brcmfmac: obtain platform data upon module initialization
  bcma: make bcma_core_pci_{up,down}() callable from atomic context
  brcmsmac: call bcma_core_pci_power_save() from non-atomic context

 drivers/bcma/driver_pci.c                          |   49 +++++++++++---------
 .../net/wireless/brcm80211/brcmfmac/bcmsdh_sdmmc.c |   28 ++++++-----
 drivers/net/wireless/brcm80211/brcmfmac/dhd_bus.h  |    3 +-
 .../net/wireless/brcm80211/brcmfmac/dhd_linux.c    |   14 +++---
 drivers/net/wireless/brcm80211/brcmfmac/usb.c      |    2 +-
 .../net/wireless/brcm80211/brcmsmac/mac80211_if.c  |    4 ++
 include/linux/bcma/bcma_driver_pci.h               |    1 +
 7 files changed, 55 insertions(+), 46 deletions(-)

-- 
1.7.10.4



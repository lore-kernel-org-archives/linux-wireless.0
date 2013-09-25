Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:2568 "EHLO mms3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754723Ab3IYLF6 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Sep 2013 07:05:58 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
cc: linux-wireless <linux-wireless@vger.kernel.org>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 0/7] brcmfmac: cleanup and new device support
Date: Wed, 25 Sep 2013 13:05:39 +0200
Message-ID: <1380107146-24026-1-git-send-email-arend@broadcom.com> (sfid-20130925_130601_760235_13F4C625)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This series has a few cleanup patches fixing a sparse error, cleaning
up the rx path and also changing the firmware filename approach after
getting feedback on this by Stephen Warren. The remaining patches are
adding support for the BCM4339 SDIO chipset.

This series is intended for v3.13 kernel and applies to the master
branch of the wireless-next repository.

Arend van Spriel (2):
  brcmfmac: fix sparse error 'bad constant expression'
  brcmfmac: rework rx path bus interface

Franky Lin (4):
  brcmfmac: sync firmware event list
  brcmfmac: add BCM4339 SDIO interface support
  brcmfmac: add valid core index check in related functions
  brcmfmac: reserve memory for bus layer in sk_buff::cb

Hante Meuleman (1):
  brcmfmac: Use fw filename and nvram based of devid for sdio.

 .../net/wireless/brcm80211/brcmfmac/bcmsdh_sdmmc.c |   11 +-
 drivers/net/wireless/brcm80211/brcmfmac/dhd.h      |    2 -
 drivers/net/wireless/brcm80211/brcmfmac/dhd_bus.h  |    2 +-
 .../net/wireless/brcm80211/brcmfmac/dhd_linux.c    |   38 ++--
 drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c |  234 ++++++++++++--------
 drivers/net/wireless/brcm80211/brcmfmac/fweh.h     |    5 +-
 drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c |    2 +
 .../net/wireless/brcm80211/brcmfmac/sdio_chip.c    |   28 +++
 .../net/wireless/brcm80211/brcmfmac/sdio_chip.h    |    8 +
 drivers/net/wireless/brcm80211/brcmfmac/usb.c      |    5 +-
 .../net/wireless/brcm80211/include/brcm_hw_ids.h   |    1 +
 11 files changed, 211 insertions(+), 125 deletions(-)

-- 
1.7.10.4



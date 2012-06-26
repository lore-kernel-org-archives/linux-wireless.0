Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:4026 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752217Ab2FZT1X (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Jun 2012 15:27:23 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
cc: "Linux Wireless List" <linux-wireless@vger.kernel.org>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 0/7] brcmfmac: bcm4334 SDIO chip support
Date: Tue, 26 Jun 2012 21:26:33 +0200
Message-ID: <1340738800-14087-1-git-send-email-arend@broadcom.com> (sfid-20120626_212727_087595_B281D5C3)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This series is mainly intended to add support for BCM4334 SDIO
device to the brcmfmac driver. One additional patch fixes a
sparse warning that was introduced in wireless-next recently
and notified to us by Fengguang Wu from Intel.

The firmware for the BCM4334 device will be submitted to the
linux-firmware repository.

This series applies to the wireless-next repository.

Arend van Spriel (2):
  brcmfmac: reduce allocations needed during nvram data download
  brcmfmac: fix sparse warning introduced with checkdied patch

Franky Lin (5):
  brcmfmac: add support for bus specific data command
  brcmfmac: restrict dongle txglom disable to old SDIO core
  brcmfmac: move glom alignment setting to SDIO bus layer
  brcmfmac: use firmware data buffer directly for nvram
  brcmfmac: add BCM4334 support

 .../net/wireless/brcm80211/brcmfmac/bcmsdh_sdmmc.c |    2 +
 drivers/net/wireless/brcm80211/brcmfmac/dhd_bus.h  |    8 +
 .../net/wireless/brcm80211/brcmfmac/dhd_common.c   |   29 ++--
 .../net/wireless/brcm80211/brcmfmac/dhd_linux.c    |    2 +
 drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c |  169 +++++++++-----------
 .../net/wireless/brcm80211/brcmfmac/sdio_chip.c    |   17 ++
 .../net/wireless/brcm80211/include/brcm_hw_ids.h   |    1 +
 7 files changed, 118 insertions(+), 110 deletions(-)

-- 
1.7.9.5



Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:2187 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751275Ab2H3RnZ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Aug 2012 13:43:25 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
cc: "Linux Wireless List" <linux-wireless@vger.kernel.org>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 0/5] brcmfmac: add support for new fullmac devices
Date: Thu, 30 Aug 2012 19:42:57 +0200
Message-ID: <1346348582-20095-1-git-send-email-arend@broadcom.com> (sfid-20120830_194329_147306_0EFED785)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch series mainly contains support for new wireless devices. The
fix for possible race was created during testing the driver on those
devices. Finally, it has a patch that adds functionality to handle nl80211
testmode command when CONFIG_NL80211_TESTMODE Kconfig item is set.

This series applies to the wireless-next tree.

Arend van Spriel (1):
  brcmfmac: add callback for nl80211 testmode command

Franky Lin (1):
  brcmfmac: add BCM43241 sdio interface driver support

Hante Meuleman (3):
  brcmfmac: prevent possible race condition on usb rx control.
  brcmfmac: Add 43242 USB support.
  brcmfmac: Add 43143 USB support.

 .../net/wireless/brcm80211/brcmfmac/bcmsdh_sdmmc.c |    2 ++
 drivers/net/wireless/brcm80211/brcmfmac/dhd.h      |    1 +
 .../net/wireless/brcm80211/brcmfmac/dhd_linux.c    |    8 +++++
 drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c |    2 ++
 .../net/wireless/brcm80211/brcmfmac/sdio_chip.c    |   17 +++++++++++
 drivers/net/wireless/brcm80211/brcmfmac/usb.c      |   31 ++++++++++++++++++--
 .../net/wireless/brcm80211/brcmfmac/wl_cfg80211.c  |   25 +++++++++++++++-
 .../net/wireless/brcm80211/include/brcm_hw_ids.h   |    1 +
 8 files changed, 84 insertions(+), 3 deletions(-)

-- 
1.7.9.5



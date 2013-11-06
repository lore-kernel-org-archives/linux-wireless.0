Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:3225 "EHLO mms3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754805Ab3KFWHj (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Nov 2013 17:07:39 -0500
From: "Arend van Spriel" <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
cc: linux-wireless@vger.kernel.org,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 0/7] brcm80211: cleanup fixes and out-of-order fix
Date: Wed, 6 Nov 2013 23:07:15 +0100
Message-ID: <1383775642-647-1-git-send-email-arend@broadcom.com> (sfid-20131106_230747_317009_6C0A86FE)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This series contains a couple of small cleanup fixes and one fix
from Hante to get rid of out-of-order transmit seen doing UDP iperf.

This series is intended for 3.13 if the merge window has not yet
opened. It applies to the master branch of the wireless-next
repository.

Arend van Spriel (5):
  brcmfmac: add separate function for passing bus tx overhead
  brcmfmac: replace dongle command list with .preinit() callback
  brcmfmac: start netif queues only when setup is completed successful
  brcmfmac: reduce logging noise accessing SDIO SleepCSR register
  brcmsmac: select CONFIG_BCMA when possible

Franky Lin (1):
  brcmfmac: remove empty brcmf_proto_stop

Hante Meuleman (1):
  brcmfmac: Update fwsignal to fix out of order tx.

 drivers/net/wireless/brcm80211/Kconfig             |   3 +-
 .../net/wireless/brcm80211/brcmfmac/bcmsdh_sdmmc.c |  19 ++-
 drivers/net/wireless/brcm80211/brcmfmac/dhd_bus.h  |  15 +-
 drivers/net/wireless/brcm80211/brcmfmac/dhd_cdc.c  |   5 -
 .../net/wireless/brcm80211/brcmfmac/dhd_common.c   |  15 +-
 .../net/wireless/brcm80211/brcmfmac/dhd_linux.c    |  36 +++--
 .../net/wireless/brcm80211/brcmfmac/dhd_proto.h    |   3 -
 drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c |  60 ++++----
 drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c | 167 ++++++++++++++++++---
 drivers/net/wireless/brcm80211/brcmfmac/usb.c      |   4 +-
 10 files changed, 236 insertions(+), 91 deletions(-)

-- 
1.8.1.3



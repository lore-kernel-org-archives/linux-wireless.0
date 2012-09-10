Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:3374 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755984Ab2IJNbW (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Sep 2012 09:31:22 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
cc: "Linux Wireless List" <linux-wireless@vger.kernel.org>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 00/10] brcmfmac: transmit flow control and e-scan
 support
Date: Mon, 10 Sep 2012 15:16:48 +0200
Message-ID: <1347283018-24223-1-git-send-email-arend@broadcom.com> (sfid-20120910_153132_305356_394601F9)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This series contains transmit flow control handling when the brcmfmac driver
has no resources to transfer packets over the host interface. This improves
throughput number for TCP. The other feature in this series is event based
scanning in which firmware sends an event per BSS.

The other changes in this series are small fixes.

This series is for the v3.7 kernel and applies to the wireless-next tree.

Hante Meuleman (10):
  brcmfmac: Stop all net if queues on tx flow halt.
  brcmfmac: Add extra data support to firmware event queueing.
  brcmfmac: Fix extra data support handling.
  brcmfmac: Add tx flow control on net if queue for USB.
  brcmfmac: Clean up scan related code.
  brcmfmac: fix big endian bug in i-scan.
  brcmfmac: Fix big endian host configuration data.
  brcmfmac: refill buffers on rx protocol error.
  brcmfmac: avoid using local usb data.
  brcmfmac: add e-scan support.

 drivers/net/wireless/brcm80211/Kconfig             |    8 +
 drivers/net/wireless/brcm80211/brcmfmac/dhd.h      |   24 +
 drivers/net/wireless/brcm80211/brcmfmac/dhd_bus.h  |    2 +-
 .../net/wireless/brcm80211/brcmfmac/dhd_common.c   |   34 +-
 .../net/wireless/brcm80211/brcmfmac/dhd_linux.c    |   16 +-
 drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c |    8 +-
 drivers/net/wireless/brcm80211/brcmfmac/usb.c      |  184 +++----
 .../net/wireless/brcm80211/brcmfmac/wl_cfg80211.c  |  564 +++++++++++++++++++-
 .../net/wireless/brcm80211/brcmfmac/wl_cfg80211.h  |   25 +
 9 files changed, 717 insertions(+), 148 deletions(-)

-- 
1.7.9.5



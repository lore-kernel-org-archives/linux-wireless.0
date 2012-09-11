Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:1168 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755451Ab2IKTTC (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Sep 2012 15:19:02 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
cc: "Linux Wireless List" <linux-wireless@vger.kernel.org>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH v2 0/7] brcmfmac: transmit flow control and e-scan
 support
Date: Tue, 11 Sep 2012 21:18:45 +0200
Message-ID: <1347391132-10953-1-git-send-email-arend@broadcom.com> (sfid-20120911_211907_299379_6FF25897)
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

Hante Meuleman (7):
  brcmfmac: Stop all net if queues on tx flow halt.
  brcmfmac: Add extra data support to firmware event queueing.
  brcmfmac: Add tx flow control on net if queue for USB.
  brcmfmac: Clean up scan related code.
  brcmfmac: refill buffers on rx protocol error.
  brcmfmac: avoid using local usb data.
  brcmfmac: add e-scan support.

 drivers/net/wireless/brcm80211/Kconfig             |    8 +
 drivers/net/wireless/brcm80211/brcmfmac/dhd.h      |   24 +
 drivers/net/wireless/brcm80211/brcmfmac/dhd_bus.h  |    2 +-
 .../net/wireless/brcm80211/brcmfmac/dhd_common.c   |    8 +-
 .../net/wireless/brcm80211/brcmfmac/dhd_linux.c    |   16 +-
 drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c |    8 +-
 drivers/net/wireless/brcm80211/brcmfmac/usb.c      |  184 +++----
 .../net/wireless/brcm80211/brcmfmac/wl_cfg80211.c  |  558 +++++++++++++++++++-
 .../net/wireless/brcm80211/brcmfmac/wl_cfg80211.h  |   25 +
 9 files changed, 697 insertions(+), 136 deletions(-)

-- 
1.7.9.5



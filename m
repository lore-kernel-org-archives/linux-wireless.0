Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:2926 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752032Ab2IMTMZ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Sep 2012 15:12:25 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
cc: "Linux Wireless List" <linux-wireless@vger.kernel.org>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 00/10] brcmfmac: sdio dpc restructuring and cleanup
Date: Thu, 13 Sep 2012 21:11:56 +0200
Message-ID: <1347563526-12513-1-git-send-email-arend@broadcom.com> (sfid-20120913_211234_632462_873919D2)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This series mainly contains rework of the sdio interrupt handling
which addresses issues with in-band sdio interrupts. These were
raised by people working on nvidia tegra platform.

This series is intended for v3.7 kernel and applies to wireless-next.

Arend van Spriel (2):
  brcmfmac: add parameter check in brcmf_c_mkiovar()
  brcmfmac: simplify handling e-scan result firmware event

Franky Lin (7):
  brcmfmac: absorb brcmf_sendpkt into brcmf_netdev_start_xmit
  brcmfmac: remove obsolete sdio bus sleep mechanism
  brcmfmac: use atomic variable for interrupt pending flag
  brcmfmac: convert SDIO dpc implementation to workqueue
  brcmfmac: streamline SDIO dpc
  brcmfmac: raise SDIO host lock to higher level
  brcmfmac: clear status for in-band interrupt in brcmf_sdbrcm_isr

Hante Meuleman (1):
  brcmfmac: fix bug causing errorneous free on exception.

 drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c   |   39 +-
 .../net/wireless/brcm80211/brcmfmac/bcmsdh_sdmmc.c |   25 --
 drivers/net/wireless/brcm80211/brcmfmac/dhd.h      |    4 -
 .../net/wireless/brcm80211/brcmfmac/dhd_common.c   |    6 +-
 .../net/wireless/brcm80211/brcmfmac/dhd_linux.c    |   41 +-
 drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c |  416 ++++++++------------
 .../net/wireless/brcm80211/brcmfmac/sdio_host.h    |    2 +
 drivers/net/wireless/brcm80211/brcmfmac/usb.c      |    6 +-
 .../net/wireless/brcm80211/brcmfmac/wl_cfg80211.c  |   14 +-
 9 files changed, 225 insertions(+), 328 deletions(-)

-- 
1.7.9.5



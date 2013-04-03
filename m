Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:4446 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760450Ab3DCKlU (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Apr 2013 06:41:20 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
cc: linux-wireless <linux-wireless@vger.kernel.org>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 00/25] brcmfmac: cleanup and firmware-signalling
Date: Wed, 3 Apr 2013 12:40:25 +0200
Message-ID: <1364985650-11719-1-git-send-email-arend@broadcom.com> (sfid-20130403_124130_160397_1DC34FFD)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This series contain some rework just for the sake of cleanup and
to prepare for handling firmware signals properly. Firmware-signalling
is used to provide flow-control between host driver and firmware
using tlv based firmware signals.

The series is intended for v3.10 kernel and applies to the master
branch of the wireless-next repository.

Arend van Spriel (23):
  brcmfmac: correct success flag passed by brcmf_sdbrcm_txpkt()
  brcmfmac: minor optimization of brcmf_sdbrcm_txpkt() function
  brcmfmac: use skb_cow() in brcmf_sdbrcm_txpkt() to assure alignment
  brcmfmac: hookup firmware signalling to firmware interface events
  brcmfmac: handle firmware signal for updating mac descriptor info
  brcmfmac: add handler for credit map firmware events
  brcmfmac: add firmware-signalling cleanup function
  brcmfmac: allow stopping netif queue for different reasons
  brcmfmac: add definitions for handling sk_buff control buffer data
  brcmfmac: perform filtered firmware-signalling cleanup upon DEL_IF
  brcmfmac: add firmware-signalling hanger functions
  brcmfmac: add optional bus callback definition for tx queue cleanup
  brcmfmac: add flow-control mode to firmware signalling
  brcmfmac: enable tx status signalling
  brcmfmac: fix handling sk_buff cleanup upon bus tx failure
  brcmfmac: avoid error output in receive path
  brcmfmac: add dedicated log level for low-level sdio debugging
  brcmfmac: initialize struct brcmf_fws_info fields before iovar
  brcmfmac: correct specified length from FIFOCREDITBACK signal
  brcmfmac: move brcmf_fws_{de,}init() functions
  brcmfmac: only allocate firmware-signalling resources if required
  brcmfmac: no flow-control tlv signals when fcmode is NONE
  brcmfmac: enable sk_buff queueing when credits deplete

Hante Meuleman (1):
  brcmfmac: determine the wiphy->bands property correctly.

Piotr Haber (1):
  brcmfmac: avoid error output on header only packet

 drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c   |   30 +-
 .../net/wireless/brcm80211/brcmfmac/bcmsdh_sdmmc.c |   60 +-
 drivers/net/wireless/brcm80211/brcmfmac/dhd.h      |   32 +-
 drivers/net/wireless/brcm80211/brcmfmac/dhd_bus.h  |   13 +-
 drivers/net/wireless/brcm80211/brcmfmac/dhd_cdc.c  |    4 +-
 drivers/net/wireless/brcm80211/brcmfmac/dhd_dbg.c  |   46 +-
 drivers/net/wireless/brcm80211/brcmfmac/dhd_dbg.h  |   16 +
 .../net/wireless/brcm80211/brcmfmac/dhd_linux.c    |   79 +-
 drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c |   76 +-
 drivers/net/wireless/brcm80211/brcmfmac/fweh.c     |   10 +-
 drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c | 1714 ++++++++++++++++++--
 drivers/net/wireless/brcm80211/brcmfmac/fwsignal.h |    8 +
 .../net/wireless/brcm80211/brcmfmac/wl_cfg80211.c  |  326 +++-
 .../net/wireless/brcm80211/include/brcmu_wifi.h    |   28 +-
 14 files changed, 2113 insertions(+), 329 deletions(-)

-- 
1.7.10.4



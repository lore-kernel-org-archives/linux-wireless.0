Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:2588 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751296Ab3K2Ksc (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 29 Nov 2013 05:48:32 -0500
From: "Arend van Spriel" <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
cc: linux-wireless <linux-wireless@vger.kernel.org>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH V2 0/7] brcm80211: cleanup fixes and out-of-order fix
Date: Fri, 29 Nov 2013 11:48:12 +0100
Message-ID: <1385722099-5102-1-git-send-email-arend@broadcom.com> (sfid-20131129_114837_210411_B99C1DC8)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Resending this series containing a couple of small cleanup fixes and
one fix from Hante to get rid of out-of-order transmit seen doing UDP
iperf.

This series is now intended for 3.14 and applies to the master branch
of the wireless-next repository. It replaces the original patch series
with Message-ID:

<1383775642-647-1-git-send-email-arend@broadcom.com>

With the extern removal patch from networking tree that series no
longer applied.

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

 drivers/net/wireless/brcm80211/Kconfig             |    3 +-
 .../net/wireless/brcm80211/brcmfmac/bcmsdh_sdmmc.c |   19 ++-
 drivers/net/wireless/brcm80211/brcmfmac/dhd_bus.h  |   15 +-
 drivers/net/wireless/brcm80211/brcmfmac/dhd_cdc.c  |    5 -
 .../net/wireless/brcm80211/brcmfmac/dhd_common.c   |   15 +-
 .../net/wireless/brcm80211/brcmfmac/dhd_linux.c    |   36 +++--
 .../net/wireless/brcm80211/brcmfmac/dhd_proto.h    |    3 -
 drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c |   60 +++----
 drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c |  167 +++++++++++++++++---
 drivers/net/wireless/brcm80211/brcmfmac/usb.c      |    4 +-
 10 files changed, 236 insertions(+), 91 deletions(-)

-- 
1.7.10.4



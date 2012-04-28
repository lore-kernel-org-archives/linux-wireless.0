Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:4503 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758383Ab2D1B5M (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Apr 2012 21:57:12 -0400
From: "Franky Lin" <frankyl@broadcom.com>
To: linville@tuxdriver.com
cc: linux-wireless@vger.kernel.org
Subject: [PATCH 0/4] brcmfmac: introducing out of band interrupt support
Date: Fri, 27 Apr 2012 18:56:55 -0700
Message-ID: <1335578219-4224-1-git-send-email-frankyl@broadcom.com> (sfid-20120428_035716_190707_D31A7736)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi John,

This patch series brings the out of band (OOB) interrupt support to
brcmfmac for SDIO dongle. OOB interrupts implementation is intended
to provide a faster interrupt mechanism for SDIO host controllers that 
don't support SDIO interrupt. Also it provides the possibility that
dongle can wake up the application processor in deep sleep. So we
can have more offloading features to improve the overall system power
consumption especially for mobility platform.

Thanks,
Franky

Franky Lin (4):
  brcmfmac: stop releasing sdio host in irq handler
  brcmfmac: check bus state for status
  brcmfmac: postpone interrupt register function
  brcmfmac: add out of band interrupt support

 drivers/net/wireless/brcm80211/Kconfig             |    9 ++
 drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c   |   97 ++++++++++++++++--
 .../net/wireless/brcm80211/brcmfmac/bcmsdh_sdmmc.c |  105 +++++++++++++++++++-
 drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c |   39 ++++++--
 .../net/wireless/brcm80211/brcmfmac/sdio_host.h    |   22 +++-
 5 files changed, 245 insertions(+), 27 deletions(-)

-- 
1.7.9.5



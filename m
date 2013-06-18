Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:2414 "EHLO mms3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755087Ab3FRL3t (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Jun 2013 07:29:49 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
cc: linux-wireless <linux-wireless@vger.kernel.org>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 0/8] brcmfmac: scatterlist support in sdio and cleanup
Date: Tue, 18 Jun 2013 13:29:21 +0200
Message-ID: <1371554970-23495-1-git-send-email-arend@broadcom.com> (sfid-20130618_133000_027699_E352BD2C)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This series contains mostly cleanup patches. The main change is the
support for scatterlist api in sdio part of the brcmfmac driver.

The series is intended for v3.11 and applies to the master branch
of the wireless-next repository.

Arend van Spriel (4):
  brcmfmac: rename variable prec to more appropriate name, ie. fifo
  brcmfmac: remove dependency with nl80211.h
  brcmfmac: consolidate mac_descriptor related function names
  brcmfmac: simplify dpc handling using atomic operations

Franky Lin (3):
  brcmfmac: remove redundant chip ID check in dhd_sdio
  brcmfmac: replace brcmf_sdioh_request_buffer with brcmf_sdio_buffrw
  brcmfmac: add sdio sg list support

Hante Meuleman (1):
  brcmfmac: Only use credits for bcmc when firmware indicates it.

 drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c   |  179 ++++++++++++++++++--
 .../net/wireless/brcm80211/brcmfmac/bcmsdh_sdmmc.c |  114 +------------
 drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c |  174 ++-----------------
 drivers/net/wireless/brcm80211/brcmfmac/fweh.h     |    3 +-
 drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c |   96 +++++++----
 .../net/wireless/brcm80211/brcmfmac/sdio_host.h    |   15 +-
 6 files changed, 252 insertions(+), 329 deletions(-)

-- 
1.7.10.4



Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw3-out.broadcom.com ([216.31.210.64]:59531 "EHLO
	mail-gw3-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753526AbaBYTap (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Feb 2014 14:30:45 -0500
From: Arend van Spriel <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	Arend van Spriel <arend@broadcom.com>
Subject: [PATCH 00/14] brcmfmac: driver cleanup and rework
Date: Tue, 25 Feb 2014 20:30:24 +0100
Message-ID: <1393356639-19169-1-git-send-email-arend@broadcom.com> (sfid-20140225_203125_784662_44B069DA)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This series includes a number of cleanup changes and rework mainly
in the sdio driver. These are intended for 3.15 kernel and apply
on the master branch of the wireless-next repository.

Arend van Spriel (5):
  brcmfmac: add delay before unregistering the network device
  brcmfmac: fix use of skb control buffer in SDIO driver part
  brcmfmac: remove unused variable data_len from
    brcmf_sdio_bus_txdata()
  brcmfmac: use pre-allocated scatter-gather table for txglomming
  brcmfmac: reset suspend flag upon sdio suspend failure

Daniel Kim (1):
  brcmfmac: Correct mcs index report

Hante Meuleman (8):
  brcmfmac: Make firmeware roaming a module param.
  brcmfmac: Correct header debug dump for sdio tx hdrs.
  brcmfmac: de-init driver layers in correct order.
  brcmfmac: Minimize SDIO dpc scheduling.
  brcmfmac: Remove immediate sleep support from SDIO.
  brcmfmac: Small cleanup of redundant code.
  brcmfmac: Use atomic functions for intstatus update.
  brcmfmac: Put frame sdio tx error handling in sub function.

 drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c   |   53 +++--
 .../net/wireless/brcm80211/brcmfmac/dhd_linux.c    |    8 +-
 drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c |  209 +++++++-------------
 .../net/wireless/brcm80211/brcmfmac/sdio_host.h    |    2 +
 .../net/wireless/brcm80211/brcmfmac/wl_cfg80211.c  |   64 +++---
 .../net/wireless/brcm80211/brcmfmac/wl_cfg80211.h  |    1 -
 6 files changed, 154 insertions(+), 183 deletions(-)

-- 
1.7.10.4


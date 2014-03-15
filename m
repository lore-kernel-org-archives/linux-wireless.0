Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw1-out.broadcom.com ([216.31.210.62]:31634 "EHLO
	mail-gw1-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755611AbaCOQSZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 15 Mar 2014 12:18:25 -0400
From: Arend van Spriel <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Arend van Spriel <arend@broadcom.com>
Subject: [PATCH 0/5] brcmfmac: bcm4354 support and cleanup
Date: Sat, 15 Mar 2014 17:18:16 +0100
Message-ID: <1394900301-15417-1-git-send-email-arend@broadcom.com> (sfid-20140315_171829_233376_FE7C705C)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This series contains support for new 2x2 11ac device. Other patches
are minor issues that and/or cleanup.

This series is intended for v3.15 kernel and applies to the master
branch of the wireless-next repository.

Arend van Spriel (2):
  brcmfmac: assure active clock request upon entering SLEEP state
  brcmfmac: remove mode field from brcmf_cfg80211_vif structure

Franky Lin (1):
  brcmfmac: add BCM4354 SDIO interface support

Hante Meuleman (2):
  brcmfmac: Protect tx seq number for data and control
  brcmfmac: Improve scanning settings for connect.

 drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c   |    1 +
 drivers/net/wireless/brcm80211/brcmfmac/chip.c     |    5 +
 drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c |  260 +++++++++++---------
 drivers/net/wireless/brcm80211/brcmfmac/p2p.c      |    6 +-
 .../net/wireless/brcm80211/brcmfmac/wl_cfg80211.c  |   94 +++----
 .../net/wireless/brcm80211/brcmfmac/wl_cfg80211.h  |   17 --
 .../net/wireless/brcm80211/include/brcm_hw_ids.h   |    1 +
 include/linux/mmc/sdio_ids.h                       |    1 +
 8 files changed, 191 insertions(+), 194 deletions(-)

-- 
1.7.9.5


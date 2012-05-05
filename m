Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:1387 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756771Ab2EEB1u (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 4 May 2012 21:27:50 -0400
From: "Franky Lin" <frankyl@broadcom.com>
To: linville@tuxdriver.com
cc: linux-wireless@vger.kernel.org
Subject: [PATCH 00/11] brcmfmac: unify register access interface
Date: Fri, 4 May 2012 18:27:27 -0700
Message-ID: <1336181258-7305-1-git-send-email-frankyl@broadcom.com> (sfid-20120505_032840_321188_F038195F)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi John,

This patch series cleans up the WiFi dongle register access by
introducing a unified interface. With the new interface the user
who wants to read/write registers on the dongle only needs to
provide the register address. The helper function will handle
everything else.

Thanks,
Franky

Franky Lin (11):
  brcmfmac: remove unused parameter of brcmf_sdcard_reg_read
  brcmfmac: remove unused parameter of brcmf_sdcard_reg_write
  brcmfmac: decouple set_sbaddr_window from register write interface
  brcmfmac: introduce unified register access interface for SDIO
  brcmfmac: replace brcmf_sdcard_cfg_read with brcmf_sdio_regrb
  brcmfmac: replace brcmf_sdcard_cfg_write with brcmf_sdio_regwb
  brcmfmac: replace brcmf_sdcard_reg_read with brcmf_sdio_regrl
  brcmfmac: replace brcmf_sdcard_reg_write with brcmf_sdio_regwl
  brcmfmac: remove redundant retries for SDIO core register access
  brcmfmac: remove function brcmf_sdcard_regfail
  brcmfmac: replace brcmf_sdioh_card_regread with brcmf_sdio_regrl

 drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c   |  244 +++++++-------
 .../net/wireless/brcm80211/brcmfmac/bcmsdh_sdmmc.c |   32 +-
 drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c |  350 ++++++++------------
 .../net/wireless/brcm80211/brcmfmac/sdio_chip.c    |  265 ++++++++-------
 .../net/wireless/brcm80211/brcmfmac/sdio_host.h    |   37 +--
 5 files changed, 416 insertions(+), 512 deletions(-)

-- 
1.7.9.5



Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:4376 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758936Ab3JONpJ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Oct 2013 09:45:09 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
cc: linux-wireless <linux-wireless@vger.kernel.org>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 00/12] brcmfmac: fixes for MMC hosts without
 scatter-gather
Date: Tue, 15 Oct 2013 15:44:45 +0200
Message-ID: <1381844697-24881-1-git-send-email-arend@broadcom.com> (sfid-20131015_154545_692929_2BBC1E19)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On our internal test setups it turned out that the MMC host controller
did not support scatterlists (struct mmc_host::max_segs == 1). It took
a number of patches to cleanup and support this. While at it some debug
trace functions were modified and added.

Arend van Spriel (12):
  brcmfmac: store address in trace_brcmf_hexdump()
  brcmfmac: add tracepoint for capturing the SDPCM header
  brcmfmac: rename variable max_seg_sz to max_seg_cnt for clarity
  brcmfmac: determine host controller related variables during probe
  brcmfmac: rework scatter-gather code in brcmf_sdio_buffrw()
  brcmfmac: rename brcmf_sdio_buffrw()
  brcmfmac: rework single packet transfers
  brcmfmac: verify result of brcmf_sdio_addrprep() calls
  brcmfmac: remove stale code from brcmf_sdcard_recv_chain()
  brcmfmac: fix brcmf_sdcard_send_pkt() for host without sg support
  brcmfmac: fix brcmf_sdio_txpkt_prep() for host without sg support
  brcmfmac: fix brcmf_sdcard_recv_chain() for host without sg support

 drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c   |  186 +++++++++++---------
 .../net/wireless/brcm80211/brcmfmac/bcmsdh_sdmmc.c |   17 ++
 drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c |  111 +++++++-----
 .../net/wireless/brcm80211/brcmfmac/sdio_host.h    |    6 +-
 .../net/wireless/brcm80211/brcmfmac/tracepoint.h   |   21 ++-
 5 files changed, 216 insertions(+), 125 deletions(-)

-- 
1.7.10.4



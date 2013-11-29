Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:2244 "EHLO mms3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753803Ab3K2LZl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 29 Nov 2013 06:25:41 -0500
From: "Arend van Spriel" <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
cc: linux-wireless <linux-wireless@vger.kernel.org>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 00/19] brcmfmac: cleanup and sdio txglom feature
Date: Fri, 29 Nov 2013 12:25:05 +0100
Message-ID: <1385724324-6361-1-git-send-email-arend@broadcom.com> (sfid-20131129_123808_670529_498FCE84)
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This series has a number of cleanup patches including removing
ioctl() callbacks and providing firmware version information
through ethtool driver info callback.

For the SDIO driver it adds support for txglom feature, which
transfers multiple transmit packets in one MMC request.

Lastly, the firmware protocol layer is being reworked to allow
different protocols being used. This is preparational work for
PCIe fullmac support.

This series is intended for v3.14 and depends on the patch
series "brcm80211: cleanup fixes and out-of-order fix" with
Message-ID: <1385722099-5102-1-git-send-email-arend@broadcom.com>

Arend van Spriel (13):
  brcmfmac: support hardware extension header in
    trace_brcmf_sdpcm_hdr()
  brcmfmac: determine sd host controller related variable earlier
  brcmfmac: fix driver build issue when CONFIG_BRCMDBG is not set
  brcmfmac: determine alignment values during probe
  brcmfmac: use platform specific alignment in SDIO
  brcmfmac: remove redundant ioctl handlers
  brcmfmac: provide firmware version in ethtool driver info
  brcmfmac: remove unnecessary EXPORT_SYMBOL() usage
  brcmfmac: move firmware related structures to fwil_types.h
  brcmfmac: move firmware command code definitions
  brcmfmac: remove some unused definitions
  brcmfmac: move firmware event related defines to fweh.h
  brcmfmac: expose chip information through debugfs

Franky Lin (2):
  brcmfmac: add firmware and nvram file name for bcm4339
  brcmfmac: add host tx glomming support

Hante Meuleman (4):
  brcmfmac: rename dhd_cdc to bcdc
  brcmfmac: removed dhd_proto.h.
  brcmfmac: Dynamically register a protocol layer.
  brcmfmac: Use consistent naming for BCDC.

 drivers/net/wireless/brcm80211/brcmfmac/Makefile   |    3 +-
 drivers/net/wireless/brcm80211/brcmfmac/bcdc.c     |  384 ++++++++++++++++
 .../brcm80211/brcmfmac/{dhd_proto.h => bcdc.h}     |   27 +-
 drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c   |    3 -
 .../net/wireless/brcm80211/brcmfmac/bcmsdh_sdmmc.c |   32 +-
 drivers/net/wireless/brcm80211/brcmfmac/dhd.h      |  482 +-------------------
 drivers/net/wireless/brcm80211/brcmfmac/dhd_cdc.c  |  387 ----------------
 .../net/wireless/brcm80211/brcmfmac/dhd_common.c   |    7 +-
 drivers/net/wireless/brcm80211/brcmfmac/dhd_dbg.c  |   36 +-
 drivers/net/wireless/brcm80211/brcmfmac/dhd_dbg.h  |    2 +-
 .../net/wireless/brcm80211/brcmfmac/dhd_linux.c    |  158 +------
 drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c |  406 +++++++++++------
 drivers/net/wireless/brcm80211/brcmfmac/fweh.h     |   54 +++
 drivers/net/wireless/brcm80211/brcmfmac/fwil.c     |    7 +-
 drivers/net/wireless/brcm80211/brcmfmac/fwil.h     |   61 +++
 .../net/wireless/brcm80211/brcmfmac/fwil_types.h   |  304 ++++++++++++
 drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c |   10 +-
 drivers/net/wireless/brcm80211/brcmfmac/proto.c    |   62 +++
 drivers/net/wireless/brcm80211/brcmfmac/proto.h    |   57 +++
 .../net/wireless/brcm80211/brcmfmac/tracepoint.h   |   33 +-
 .../net/wireless/brcm80211/brcmfmac/wl_cfg80211.c  |   10 +-
 21 files changed, 1304 insertions(+), 1221 deletions(-)
 create mode 100644 drivers/net/wireless/brcm80211/brcmfmac/bcdc.c
 rename drivers/net/wireless/brcm80211/brcmfmac/{dhd_proto.h => bcdc.h} (51%)
 delete mode 100644 drivers/net/wireless/brcm80211/brcmfmac/dhd_cdc.c
 create mode 100644 drivers/net/wireless/brcm80211/brcmfmac/proto.c
 create mode 100644 drivers/net/wireless/brcm80211/brcmfmac/proto.h

-- 
1.7.10.4



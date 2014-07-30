Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw3-out.broadcom.com ([216.31.210.64]:62844 "EHLO
	mail-gw3-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751663AbaG3LUL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Jul 2014 07:20:11 -0400
From: Arend van Spriel <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	Arend van Spriel <arend@broadcom.com>
Subject: [PATCH 0/8] brcmfmac: add support for PCIe fullmac devices
Date: Wed, 30 Jul 2014 13:19:59 +0200
Message-ID: <1406719207-5126-1-git-send-email-arend@broadcom.com> (sfid-20140730_132027_829961_AFACC333)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This series mainly adds support 11ac devices using a PCIe host interface.
These devices also uses different protocol layer to communicate with
the firmware on the device. Implementation has been ready for some time
and got testing coverage while awaiting approval to publish.

This series is intended for 3.17 and applies to the master branch of
the wireless-next repository.

Daniel Kim (1):
  brcmfmac: Do not use strcpy and strcat

Hante Meuleman (7):
  brcmfmac: Export brcmf_netif_rx for new protocol msgbuf.
  brcmfmac: Add protocol addressing mode and peer deletion API.
  brcmfmac: Adding msgbuf protocol.
  brcmfmac: Adding PCIe bus layer support.
  brcmfmac: Update pcie reset device routine.
  brcmfmac: Fix msgbuf flow control.
  brcmfmac: Add TDLS support to msgbuf.

 drivers/net/wireless/brcm80211/Kconfig             |   10 +
 drivers/net/wireless/brcm80211/brcmfmac/Makefile   |    5 +
 drivers/net/wireless/brcm80211/brcmfmac/bcdc.c     |   20 +
 drivers/net/wireless/brcm80211/brcmfmac/chip.c     |    8 +
 .../net/wireless/brcm80211/brcmfmac/commonring.c   |  274 +++
 .../net/wireless/brcm80211/brcmfmac/commonring.h   |   69 +
 drivers/net/wireless/brcm80211/brcmfmac/dhd.h      |    7 +-
 drivers/net/wireless/brcm80211/brcmfmac/dhd_bus.h  |   33 +
 drivers/net/wireless/brcm80211/brcmfmac/dhd_dbg.h  |   36 +-
 .../net/wireless/brcm80211/brcmfmac/dhd_linux.c    |    9 +-
 drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c |   25 +-
 drivers/net/wireless/brcm80211/brcmfmac/flowring.c |  502 ++++++
 drivers/net/wireless/brcm80211/brcmfmac/flowring.h |   84 +
 drivers/net/wireless/brcm80211/brcmfmac/fweh.c     |    6 +-
 drivers/net/wireless/brcm80211/brcmfmac/fweh.h     |    5 +
 drivers/net/wireless/brcm80211/brcmfmac/msgbuf.c   | 1398 +++++++++++++++
 drivers/net/wireless/brcm80211/brcmfmac/msgbuf.h   |   40 +
 drivers/net/wireless/brcm80211/brcmfmac/pcie.c     | 1846 ++++++++++++++++++++
 drivers/net/wireless/brcm80211/brcmfmac/pcie.h     |   29 +
 drivers/net/wireless/brcm80211/brcmfmac/proto.c    |   29 +-
 drivers/net/wireless/brcm80211/brcmfmac/proto.h    |   31 +-
 .../net/wireless/brcm80211/brcmfmac/wl_cfg80211.c  |   57 +-
 .../net/wireless/brcm80211/include/brcm_hw_ids.h   |   11 +
 23 files changed, 4498 insertions(+), 36 deletions(-)
 create mode 100644 drivers/net/wireless/brcm80211/brcmfmac/commonring.c
 create mode 100644 drivers/net/wireless/brcm80211/brcmfmac/commonring.h
 create mode 100644 drivers/net/wireless/brcm80211/brcmfmac/flowring.c
 create mode 100644 drivers/net/wireless/brcm80211/brcmfmac/flowring.h
 create mode 100644 drivers/net/wireless/brcm80211/brcmfmac/msgbuf.c
 create mode 100644 drivers/net/wireless/brcm80211/brcmfmac/msgbuf.h
 create mode 100644 drivers/net/wireless/brcm80211/brcmfmac/pcie.c
 create mode 100644 drivers/net/wireless/brcm80211/brcmfmac/pcie.h

-- 
1.9.1


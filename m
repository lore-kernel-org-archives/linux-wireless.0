Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 5520-maca-inet1-outside.broadcom.com ([216.31.211.11]:39578
	"EHLO mail-irv-18.broadcom.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1161097AbcBQK1X (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Feb 2016 05:27:23 -0500
From: Arend van Spriel <arend@broadcom.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Arend van Spriel <arend@broadcom.com>
Subject: [PATCH 00/21] brcmfmac: driver setting concept and other changes
Date: Wed, 17 Feb 2016 11:26:49 +0100
Message-Id: <1455704830-10088-1-git-send-email-arend@broadcom.com> (sfid-20160217_112731_847175_C20DD9B2)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This series contain various changes for the brcmfmac driver. Here
the list of highlights:

* IPv6 Neighbor discovery offload.
* driver settings that can be populated from different sources.
* country code setting in firmware.
* length checks to validate firmware events.
* new way to determine device memory size needed for BCM4366.
* various offloads during wowl.
* full MFP support.

This series is intended for v4.6 and applies to the master branch
of the wireless-drivers-next repository. Patch #17 is already in
wireless-drivers repo. The other patches apply without it, but it
is needed to compile test the remainder of the series.

Arend van Spriel (1):
  brcmfmac: change function name for
    brcmf_cfg80211_wait_vif_event_timeout()

Franky Lin (3):
  brcmfmac: check for wowl support before enumerating feature flag
  brcmfmac: add neighbor discovery offload ip address table
    configuration
  brcmfmac: check return for ARP ip setting iovar

Hante Meuleman (17):
  brcmfmac: Limit memory allocs to <64K
  brcmfmac: Configure country code using device specific settings
  brcmfmac: Add length checks on firmware events
  brcmfmac: use device memsize config from fw if defined
  brcmfmac: use bar1 window size as provided by pci subsystem
  brcmfmac: add support for the PCIE 4366c0 chip
  brcmfmac: remove pcie gen1 support
  brcmfmac: increase timeout for tx eapol
  brcmfmac: move module init and exit to common
  brcmfmac: add wowl gtk rekeying offload support
  brcmfmac: move platform data retrieval code to common
  brcmfmac: keep ARP and ND offload enabled during WOWL
  brcmfmac: fix sdio sg table alloc crash
  brcmfmac: switch to new platform data
  brcmfmac: merge platform data and module paramaters
  brcmfmac: integrate add_keyext in add_key
  brcmfmac: add 802.11w management frame protection support

 .../wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c  | 145 ++---
 .../net/wireless/broadcom/brcm80211/brcmfmac/bus.h |   4 +-
 .../broadcom/brcm80211/brcmfmac/cfg80211.c         | 617 +++++++++++++--------
 .../broadcom/brcm80211/brcmfmac/cfg80211.h         |  20 +-
 .../wireless/broadcom/brcm80211/brcmfmac/common.c  | 152 ++++-
 .../wireless/broadcom/brcm80211/brcmfmac/common.h  |  43 +-
 .../wireless/broadcom/brcm80211/brcmfmac/core.c    | 180 ++++--
 .../wireless/broadcom/brcm80211/brcmfmac/core.h    |   9 +
 .../wireless/broadcom/brcm80211/brcmfmac/feature.c |  14 +
 .../wireless/broadcom/brcm80211/brcmfmac/feature.h |  10 +-
 .../wireless/broadcom/brcm80211/brcmfmac/fweh.c    |  57 +-
 .../wireless/broadcom/brcm80211/brcmfmac/fweh.h    |  68 ++-
 .../broadcom/brcm80211/brcmfmac/fwil_types.h       |  29 +-
 .../net/wireless/broadcom/brcm80211/brcmfmac/of.c  |  22 +-
 .../net/wireless/broadcom/brcm80211/brcmfmac/of.h  |   4 +-
 .../net/wireless/broadcom/brcm80211/brcmfmac/p2p.c |  26 +-
 .../wireless/broadcom/brcm80211/brcmfmac/pcie.c    | 206 +++----
 .../wireless/broadcom/brcm80211/brcmfmac/sdio.c    | 108 ++--
 .../wireless/broadcom/brcm80211/brcmfmac/sdio.h    |   3 +-
 .../net/wireless/broadcom/brcm80211/brcmfmac/usb.c |  16 +-
 .../broadcom/brcm80211/include/brcmu_wifi.h        |   2 +
 include/linux/platform_data/brcmfmac-sdio.h        | 135 -----
 include/linux/platform_data/brcmfmac.h             | 185 ++++++
 23 files changed, 1240 insertions(+), 815 deletions(-)
 delete mode 100644 include/linux/platform_data/brcmfmac-sdio.h
 create mode 100644 include/linux/platform_data/brcmfmac.h

-- 
1.9.1


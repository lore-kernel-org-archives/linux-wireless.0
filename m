Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:1545 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753199Ab3CCLqO (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 3 Mar 2013 06:46:14 -0500
From: "Arend van Spriel" <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
cc: linux-wireless@vger.kernel.org,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 00/13] brcm80211: cleanup and rework changes
Date: Sun, 3 Mar 2013 12:45:19 +0100
Message-ID: <1362311132-29561-1-git-send-email-arend@broadcom.com> (sfid-20130303_131303_783862_7A2783D1)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This series does contain one brcmsmac patch to provide WLAN led support. It
is only compiled when BCMA_DRIVER_GPIO is set. The brcmfmac patches contain
cleanup of the module related macros and patches that rework the driver for
upcoming firmware feature support. In this series also adding support for
tracepoints allowing tracing all driver debug messages.

This patch series is intended for v3.10 and applies to master branch in
the wireless-next repository.

Arend van Spriel (12):
  brcmfmac: introduce tracepoints for message logging
  brcmfmac: make debug module parameter more clear
  brcmfmac: cleanup module information macros
  brcmfmac: only do auth_type workaround when no WPA or RSN IE is
    provided
  brcmfmac: remove null-pointer check in .sched_scan_start() callback
  brcmfmac: increase required skbuff headroom for firmware signalling
  brcmutil: add macros for setting bitfields using mask/shift
    operations
  brcmfmac: add support for TLV based firmware signalling
  brcmfmac: release transmit packet in brcmf_txcomplete()
  brcmfmac: assure brcmf_txcomplete() is called in failure paths
  brcmutil: add dequeue function with filtering
  brcmfmac: add parameter to brcmf_proto_hdrpush() for data offset

Piotr Haber (1):
  brcmsmac: radio on led support

 drivers/net/wireless/brcm80211/Kconfig             |    5 +-
 drivers/net/wireless/brcm80211/brcmfmac/Makefile   |    3 +
 drivers/net/wireless/brcm80211/brcmfmac/dhd.h      |    7 +-
 drivers/net/wireless/brcm80211/brcmfmac/dhd_bus.h  |    2 +-
 drivers/net/wireless/brcm80211/brcmfmac/dhd_cdc.c  |   30 ++-
 .../net/wireless/brcm80211/brcmfmac/dhd_common.c   |   33 ++
 drivers/net/wireless/brcm80211/brcmfmac/dhd_dbg.c  |   42 +++
 drivers/net/wireless/brcm80211/brcmfmac/dhd_dbg.h  |   34 ++-
 .../net/wireless/brcm80211/brcmfmac/dhd_linux.c    |   39 ++-
 .../net/wireless/brcm80211/brcmfmac/dhd_proto.h    |    2 +-
 drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c |   28 +-
 drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c |  382 ++++++++++++++++++++
 drivers/net/wireless/brcm80211/brcmfmac/fwsignal.h |   25 ++
 .../net/wireless/brcm80211/brcmfmac/tracepoint.c   |   22 ++
 .../net/wireless/brcm80211/brcmfmac/tracepoint.h   |   87 +++++
 drivers/net/wireless/brcm80211/brcmfmac/usb.c      |   37 +-
 .../net/wireless/brcm80211/brcmfmac/wl_cfg80211.c  |   10 +-
 drivers/net/wireless/brcm80211/brcmsmac/Makefile   |    4 +
 drivers/net/wireless/brcm80211/brcmsmac/led.c      |  127 +++++++
 drivers/net/wireless/brcm80211/brcmsmac/led.h      |   36 ++
 .../net/wireless/brcm80211/brcmsmac/mac80211_if.c  |    4 +
 .../net/wireless/brcm80211/brcmsmac/mac80211_if.h  |    4 +
 drivers/net/wireless/brcm80211/brcmutil/utils.c    |   25 ++
 .../net/wireless/brcm80211/include/brcmu_utils.h   |   27 ++
 24 files changed, 943 insertions(+), 72 deletions(-)
 create mode 100644 drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c
 create mode 100644 drivers/net/wireless/brcm80211/brcmfmac/fwsignal.h
 create mode 100644 drivers/net/wireless/brcm80211/brcmfmac/tracepoint.c
 create mode 100644 drivers/net/wireless/brcm80211/brcmfmac/tracepoint.h
 create mode 100644 drivers/net/wireless/brcm80211/brcmsmac/led.c
 create mode 100644 drivers/net/wireless/brcm80211/brcmsmac/led.h

-- 
1.7.6



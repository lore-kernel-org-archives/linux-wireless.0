Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw1-out.broadcom.com ([216.31.210.62]:34722 "EHLO
	mail-gw1-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755253AbaFUKLX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 21 Jun 2014 06:11:23 -0400
From: Arend van Spriel <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	Arend van Spriel <arend@broadcom.com>
Subject: [PATCH 0/8] brcmfmac: new USB devices, vendor command, and cleanup
Date: Sat, 21 Jun 2014 12:11:11 +0200
Message-ID: <1403345479-13467-1-git-send-email-arend@broadcom.com> (sfid-20140621_121137_573081_BF680AF9)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The patch series add driver support for new USB device. These are 11ac fullmac
devices with USB3.0 interface. Also opting for the vendor-specific netlink
command instead of cfg80211 testmode. The remaining patches are small cleanup
patches.

This series is intended for 3.17 and applies to the master branch of the
wireless-next repository.

Arend van Spriel (3):
  brcmfmac: clear ht info during attach phase
  brcmfmac: correct logging levels in btcoex source
  brcmfmac: reduce log level in fwil if firmware returns error

Daniel Kim (1):
  brcmfmac: Don't control mpc setting during scan operation

Franky Lin (1):
  brcmfmac: replace cfg80211 testmode with vendor command

Hante Meuleman (3):
  brcmfmac: Add 43569 USB support.
  brcmfmac: Add USB device 43566 to supported devices.
  brcmfmac: Change USB probe routine to support Composite USB

 drivers/net/wireless/brcm80211/brcmfmac/Makefile   |    3 +-
 drivers/net/wireless/brcm80211/brcmfmac/btcoex.c   |   38 ++--
 drivers/net/wireless/brcm80211/brcmfmac/dhd.h      |   10 -
 .../net/wireless/brcm80211/brcmfmac/dhd_common.c   |    7 +
 drivers/net/wireless/brcm80211/brcmfmac/fwil.c     |    2 +-
 drivers/net/wireless/brcm80211/brcmfmac/usb.c      |  214 +++++++++-----------
 drivers/net/wireless/brcm80211/brcmfmac/vendor.c   |  115 +++++++++++
 drivers/net/wireless/brcm80211/brcmfmac/vendor.h   |   64 ++++++
 .../net/wireless/brcm80211/brcmfmac/wl_cfg80211.c  |   56 ++---
 9 files changed, 326 insertions(+), 183 deletions(-)
 create mode 100644 drivers/net/wireless/brcm80211/brcmfmac/vendor.c
 create mode 100644 drivers/net/wireless/brcm80211/brcmfmac/vendor.h

-- 
1.7.9.5


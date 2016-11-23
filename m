Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lpdvsmtp01.broadcom.com ([192.19.211.62]:53051 "EHLO
        relay.smtp.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S935249AbcKWKfj (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 23 Nov 2016 05:35:39 -0500
From: Arend van Spriel <arend.vanspriel@broadcom.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
        Arend van Spriel <arend.vanspriel@broadcom.com>
Subject: [PATCH 00/12] brcmfmac: scheduled scan cleanup and chip support
Date: Wed, 23 Nov 2016 10:25:19 +0000
Message-Id: <1479896731-5091-1-git-send-email-arend.vanspriel@broadcom.com> (sfid-20161123_113548_316327_8BFBA769)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch series contains:
* cleanup of scheduled scan code.
* fix handling schedules scan results for newer chips.
* support for bcm43341 chipset with different chip id.
* support rev6 of PCIe device interface.

The series is intended for 4.10 and applies to the master branch
of the wireless-drivers-next repository.

Arend van Spriel (11):
  brcmfmac: add support for 43341 chip
  brcmfmac: move pno helper functions in separate source file
  brcmfmac: fix handling ssids in .sched_scan_start() callback
  brcmfmac: change prototype for brcmf_do_escan()
  brcmfmac: make internal escan more generic
  brcmfmac: split up brcmf_pno_config() function
  brcmfmac: move scheduled scan activation to pno source file
  brcmfmac: use provided channels for scheduled scan
  brcmfmac: remove restriction from .sched_scan_start() callback
  brcmfmac: use requested scan interval in scheduled scan
  brcmfmac: fix scheduled scan result handling for newer chips

Franky Lin (1):
  brcmfmac: add pcie host dongle interface rev6 support

 .../wireless/broadcom/brcm80211/brcmfmac/Makefile  |   3 +-
 .../net/wireless/broadcom/brcm80211/brcmfmac/bus.h |  10 +-
 .../broadcom/brcm80211/brcmfmac/cfg80211.c         | 381 ++++++++-------------
 .../broadcom/brcm80211/brcmfmac/cfg80211.h         |   4 +-
 .../broadcom/brcm80211/brcmfmac/fwil_types.h       |  23 ++
 .../wireless/broadcom/brcm80211/brcmfmac/msgbuf.c  |  38 +-
 .../wireless/broadcom/brcm80211/brcmfmac/msgbuf.h  |   4 +
 .../wireless/broadcom/brcm80211/brcmfmac/pcie.c    | 171 +++++----
 .../net/wireless/broadcom/brcm80211/brcmfmac/pno.c | 242 +++++++++++++
 .../net/wireless/broadcom/brcm80211/brcmfmac/pno.h |  40 +++
 .../wireless/broadcom/brcm80211/brcmfmac/sdio.c    |   1 +
 .../broadcom/brcm80211/include/brcm_hw_ids.h       |   1 +
 12 files changed, 588 insertions(+), 330 deletions(-)
 create mode 100644 drivers/net/wireless/broadcom/brcm80211/brcmfmac/pno.c
 create mode 100644 drivers/net/wireless/broadcom/brcm80211/brcmfmac/pno.h

--
1.9.1

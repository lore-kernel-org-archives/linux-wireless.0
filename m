Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw3-out.broadcom.com ([216.31.210.64]:50093 "EHLO
	mail-gw3-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752701AbbLJMnU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Dec 2015 07:43:20 -0500
From: Arend van Spriel <arend@broadcom.com>
To: Kalle Valo <kvalo@codeaurora.org>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	Arend van Spriel <arend@broadcom.com>
Subject: [PATCH V2 00/13] brcmfmac: IBSS fix and cleanup
Date: Thu, 10 Dec 2015 13:42:59 +0100
Message-ID: <1449751392-32569-1-git-send-email-arend@broadcom.com> (sfid-20151210_134344_571660_7BAD53D7)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This series provides following:
* fix IBSS which got broken over time.
* new USB id for bcm43242 dongle.
* arp offload configuration through inet notifier.

The series is intended for 4.5 kernel and applies to master branch
of the wireless-drivers-next repository.

Arend van Spriel (2):
  brcmfmac: no interface combination check for single interface
  brcmfmac: add 43242 device id for LG dongle

Franky Lin (1):
  brcmfmac: add arp offload ip address table configuration support

Hante Meuleman (9):
  brcmfmac: Simplify scan timing configuration.
  brcmfmac: Use local storage for ssid iovar.
  brcmfmac: Remove some redundant cfg80211 data.
  brcmfmac: Cleanup pmksa cache handling code.
  brcmfmac: Make TDLS a detectable feature.
  brcmfmac: Add support for PCIE 4350 revision 5 device.
  brcmfmac: Fix IBSS setup.
  brcmfmac: Change error print in debug print.
  brcmfmac: Move scheduled scan related interface layer structs.

Kosuke Tatsukawa (1):
  brcmfmac: fix waitqueue_active without memory barrier in brcmfmac
    driver

 .../broadcom/brcm80211/brcmfmac/cfg80211.c         | 233 ++++++++++-----------
 .../broadcom/brcm80211/brcmfmac/cfg80211.h         | 111 +---------
 .../wireless/broadcom/brcm80211/brcmfmac/core.c    | 108 ++++++++++
 .../wireless/broadcom/brcm80211/brcmfmac/core.h    |   2 +
 .../wireless/broadcom/brcm80211/brcmfmac/feature.c |   1 +
 .../wireless/broadcom/brcm80211/brcmfmac/feature.h |   4 +-
 .../broadcom/brcm80211/brcmfmac/fwil_types.h       | 105 ++++++++++
 .../wireless/broadcom/brcm80211/brcmfmac/msgbuf.c  |   3 +-
 .../wireless/broadcom/brcm80211/brcmfmac/pcie.c    |   8 +-
 .../wireless/broadcom/brcm80211/brcmfmac/sdio.c    |   6 +-
 .../net/wireless/broadcom/brcm80211/brcmfmac/usb.c |   4 +-
 .../broadcom/brcm80211/include/brcm_hw_ids.h       |   2 +
 .../broadcom/brcm80211/include/brcmu_wifi.h        |  23 --
 13 files changed, 342 insertions(+), 268 deletions(-)

-- 
1.9.1


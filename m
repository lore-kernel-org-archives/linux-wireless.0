Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw3-out.broadcom.com ([216.31.210.64]:4803 "EHLO
	mail-gw3-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932348AbbLNNj5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Dec 2015 08:39:57 -0500
From: Arend van Spriel <arend@broadcom.com>
To: Kalle Valo <kvalo@codeaurora.org>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	Arend van Spriel <arend@broadcom.com>
Subject: [PATCH 0/7] brcmfmac: IBSS fixes and random mac scheduled scan
Date: Mon, 14 Dec 2015 14:39:47 +0100
Message-ID: <1450100394-17414-1-git-send-email-arend@broadcom.com> (sfid-20151214_144001_473468_B579B9B0)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This series adds the following:
* query features through firmware command.
* IBSS fixes.
* ARP offload through inet notifier.
* force probe to succeed for debugging.

Arend van Spriel (2):
  brcmfmac: obtain feature info using 'cap' firmware command
  brcmfmac: introduce module parameter to force successful probe

Franky Lin (1):
  brcmfmac: add arp offload ip address table configuration support

Hante Meuleman (4):
  brcmfmac: Add get_station support for IBSS
  brcmfmac: Add support for scheduled scan mac randomization
  brcmfmac: Fix warn trace on module unload while in ibss mode
  brcmfmac: Move all module parameters to one place

 .../wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c  |  12 +-
 .../broadcom/brcm80211/brcmfmac/cfg80211.c         | 118 +++++++++++++++---
 .../wireless/broadcom/brcm80211/brcmfmac/common.c  |  72 +++++++++++
 .../wireless/broadcom/brcm80211/brcmfmac/common.h  |  56 +++++++++
 .../wireless/broadcom/brcm80211/brcmfmac/core.c    | 132 +++++++++++++++++++--
 .../wireless/broadcom/brcm80211/brcmfmac/core.h    |   7 +-
 .../wireless/broadcom/brcm80211/brcmfmac/feature.c |  64 +++++-----
 .../broadcom/brcm80211/brcmfmac/firmware.c         |  16 +--
 .../wireless/broadcom/brcm80211/brcmfmac/fwil.h    |   1 +
 .../broadcom/brcm80211/brcmfmac/fwil_types.h       |  34 ++++++
 .../broadcom/brcm80211/brcmfmac/fwsignal.c         |   9 +-
 11 files changed, 439 insertions(+), 82 deletions(-)

-- 
1.9.1


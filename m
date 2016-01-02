Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw3-out.broadcom.com ([216.31.210.64]:51403 "EHLO
	mail-gw3-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751556AbcABIlw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 2 Jan 2016 03:41:52 -0500
From: Arend van Spriel <arend@broadcom.com>
To: Kalle Valo <kvalo@codeaurora.org>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	Arend van Spriel <arend@broadcom.com>
Subject: [PATCH V2 0/7] brcmfmac: IBSS fixes and random mac scheduled scan
Date: Sat, 2 Jan 2016 09:41:35 +0100
Message-ID: <1451724102-21911-1-git-send-email-arend@broadcom.com> (sfid-20160102_094233_997832_A8634992)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Start the new year setting things straight so resending series
incorporating review comments from Mathy Vanhoef. This replaces
the series with Message-ID:

<1450100394-17414-1-git-send-email-arend@broadcom.com>

This series adds the following:
* query features through firmware command.
* IBSS fixes.
* ARP offload through inet notifier.
* force probe to succeed for debugging.
* random mac support for scheduled scan.

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
 .../broadcom/brcm80211/brcmfmac/cfg80211.c         | 127 +++++++++++++++++---
 .../wireless/broadcom/brcm80211/brcmfmac/common.c  |  72 +++++++++++
 .../wireless/broadcom/brcm80211/brcmfmac/common.h  |  56 +++++++++
 .../wireless/broadcom/brcm80211/brcmfmac/core.c    | 132 +++++++++++++++++++--
 .../wireless/broadcom/brcm80211/brcmfmac/core.h    |   7 +-
 .../wireless/broadcom/brcm80211/brcmfmac/feature.c |  76 +++++++-----
 .../wireless/broadcom/brcm80211/brcmfmac/feature.h |   4 +-
 .../broadcom/brcm80211/brcmfmac/firmware.c         |  16 +--
 .../wireless/broadcom/brcm80211/brcmfmac/fwil.h    |   1 +
 .../broadcom/brcm80211/brcmfmac/fwil_types.h       |  34 ++++++
 .../broadcom/brcm80211/brcmfmac/fwsignal.c         |   9 +-
 12 files changed, 462 insertions(+), 84 deletions(-)

-- 
1.9.1


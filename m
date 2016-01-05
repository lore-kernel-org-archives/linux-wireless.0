Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw3-out.broadcom.com ([216.31.210.64]:24637 "EHLO
	mail-gw3-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751572AbcAEKF5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Jan 2016 05:05:57 -0500
From: Arend van Spriel <arend@broadcom.com>
To: Kalle Valo <kvalo@codeaurora.org>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	Arend van Spriel <arend@broadcom.com>
Subject: [PATCH 0/6] brcmfmac: extend wowl and cleanup
Date: Tue, 5 Jan 2016 11:05:44 +0100
Message-ID: <1451988350-2197-1-git-send-email-arend@broadcom.com> (sfid-20160105_110601_607102_B0D0562C)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This smallish series contains:
* link down fix for IBSS.
* support wowl upon net detect.
* cleanup timeout definitions.

The series are intended for 4.5 kernel and apply to
the master branch of wireless-drivers-next repo on top
of series posted earlier with Message-ID:

<1451724102-21911-1-git-send-email-arend@broadcom.com>

Arend van Spriel (3):
  brcmfmac: change brcmf_sdio_wd_timer() prototype
  brcmfmac: use msecs_to_jiffies() in macro definitions
  brcmfmac: use jiffies for timeout in btcoex

Hante Meuleman (3):
  brcmfmac: Add wowl net detect support
  brcmfmac: Reshuffle functions to avoid forward declarations
  brcmfmac: Do not handle link downs for ibss.

 .../wireless/broadcom/brcm80211/brcmfmac/btcoex.c  |   12 +-
 .../broadcom/brcm80211/brcmfmac/cfg80211.c         | 1116 +++++++++++---------
 .../broadcom/brcm80211/brcmfmac/cfg80211.h         |   29 +-
 .../wireless/broadcom/brcm80211/brcmfmac/core.c    |    4 +-
 .../broadcom/brcm80211/brcmfmac/fwil_types.h       |    2 +
 .../wireless/broadcom/brcm80211/brcmfmac/msgbuf.c  |    4 +-
 .../net/wireless/broadcom/brcm80211/brcmfmac/p2p.c |   18 +-
 .../wireless/broadcom/brcm80211/brcmfmac/pcie.c    |    7 +-
 .../wireless/broadcom/brcm80211/brcmfmac/sdio.c    |   51 +-
 .../wireless/broadcom/brcm80211/brcmfmac/sdio.h    |    6 +-
 .../net/wireless/broadcom/brcm80211/brcmfmac/usb.c |    5 +-
 11 files changed, 683 insertions(+), 571 deletions(-)

-- 
1.9.1


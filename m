Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw2-out.broadcom.com ([216.31.210.63]:30636 "EHLO
	mail-gw2-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750890AbcDKJfi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Apr 2016 05:35:38 -0400
From: Arend van Spriel <arend@broadcom.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Arend van Spriel <arend@broadcom.com>
Subject: [PATCH 0/8] brcmfmac: event handling and other fixes
Date: Mon, 11 Apr 2016 11:35:20 +0200
Message-Id: <1460367328-12082-1-git-send-email-arend@broadcom.com> (sfid-20160411_113543_152923_11E306B5)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This series provides the following:

* avoid unexpected firmware events.
* allow passing events explicitly for PCIe and SDIO devices.
* fix issue with boardrev entry in nvram.
* fix for wowl.
* fix possible null pointer access upon aborting p2p scan.

The series is intended for v4.7 kernel and applies to the master
branch of the wireless-drivers-next repository.

Arend van Spriel (3):
  brcmfmac: cleanup ampdu-rx host reorder code
  brcmfmac: revise handling events in receive path
  brcmfmac: create common function for handling brcmf_proto_hdrpull()

Franky Lin (1):
  brcmfmac: screening firmware event packet

Hante Meuleman (4):
  brcmfmac: clear eventmask array before using it
  brcmfmac: fix clearing wowl wake indicators
  brcmfmac: insert default boardrev in nvram data if missing
  brcmfmac: fix p2p scan abort null pointer exception

 .../wireless/broadcom/brcm80211/brcmfmac/bcdc.c    |   7 +
 .../net/wireless/broadcom/brcm80211/brcmfmac/bus.h |   4 +-
 .../broadcom/brcm80211/brcmfmac/cfg80211.c         |   3 +-
 .../wireless/broadcom/brcm80211/brcmfmac/core.c    | 247 +++------------------
 .../wireless/broadcom/brcm80211/brcmfmac/core.h    |   4 -
 .../broadcom/brcm80211/brcmfmac/firmware.c         |  30 ++-
 .../wireless/broadcom/brcm80211/brcmfmac/fweh.c    |   1 +
 .../broadcom/brcm80211/brcmfmac/fwsignal.c         | 209 +++++++++++++++++
 .../broadcom/brcm80211/brcmfmac/fwsignal.h         |   1 +
 .../wireless/broadcom/brcm80211/brcmfmac/msgbuf.c  |  46 ++--
 .../net/wireless/broadcom/brcm80211/brcmfmac/p2p.c |   2 +-
 .../wireless/broadcom/brcm80211/brcmfmac/proto.h   |  16 ++
 .../wireless/broadcom/brcm80211/brcmfmac/sdio.c    |  32 ++-
 .../net/wireless/broadcom/brcm80211/brcmfmac/usb.c |   2 +-
 14 files changed, 352 insertions(+), 252 deletions(-)

-- 
1.9.1


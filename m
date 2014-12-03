Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw2-out.broadcom.com ([216.31.210.63]:28975 "EHLO
	mail-gw2-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750833AbaLCUFh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Dec 2014 15:05:37 -0500
From: Arend van Spriel <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	Arend van Spriel <arend@broadcom.com>
Subject: [PATCH 0/7] brcmfmac: Multiple-BSS and PCIe fixes
Date: Wed, 3 Dec 2014 21:05:26 +0100
Message-ID: <1417637133-6966-1-git-send-email-arend@broadcom.com> (sfid-20141203_210540_734847_2394FD36)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hope this series can make it before the merge window. It contains
two patches that I marked for stable 3.18 as it is probably not
possible to pass them through the wireless tree this late in the
game.

This series add some BCM43602 PCIe ids which are used in Netgear R8000
and the other main feature is Multiple-BSS which uncovered a number of
small issue. Franky added code in PCIe part to enable use of MSI interrupts.

The series is intended for v3.19 and applies to the master branch of the
wireless-next repository.

Franky Lin (1):
  brcmfmac: switch to single message MSI

Hante Meuleman (6):
  brcmfmac: Fix bitmap malloc bug in msgbuf.
  brcmfmac: Fix ifidx for rx data by msgbuf.
  brcmfmac: Add PCIE ids for 43602 devices.
  brcmfmac: Fix vendor cmds used interface.
  brcmfmac: Add ifidx to logging of fwil cmds.
  brcmfmac: add multiple BSS support.

 drivers/net/wireless/brcm80211/brcmfmac/cfg80211.c | 245 +++++++++++++++++----
 drivers/net/wireless/brcm80211/brcmfmac/cfg80211.h |   2 +
 drivers/net/wireless/brcm80211/brcmfmac/core.c     |  39 +++-
 drivers/net/wireless/brcm80211/brcmfmac/core.h     |   3 +-
 drivers/net/wireless/brcm80211/brcmfmac/feature.c  |  23 ++
 drivers/net/wireless/brcm80211/brcmfmac/feature.h  |   1 +
 drivers/net/wireless/brcm80211/brcmfmac/fweh.c     |   6 +-
 drivers/net/wireless/brcm80211/brcmfmac/fwil.c     |  18 +-
 .../net/wireless/brcm80211/brcmfmac/fwil_types.h   |   6 +
 drivers/net/wireless/brcm80211/brcmfmac/msgbuf.c   |  10 +
 drivers/net/wireless/brcm80211/brcmfmac/pcie.c     |   6 +
 drivers/net/wireless/brcm80211/brcmfmac/vendor.c   |  15 +-
 .../net/wireless/brcm80211/include/brcm_hw_ids.h   |   2 +
 13 files changed, 309 insertions(+), 67 deletions(-)

-- 
1.9.1


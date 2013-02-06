Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:1342 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752085Ab3BFRmg (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Feb 2013 12:42:36 -0500
From: "Arend van Spriel" <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
cc: "Linux Wireless List" <linux-wireless@vger.kernel.org>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 00/12] brcmfmac: cleanup and chip workaround for
 unsecure AP
Date: Wed, 6 Feb 2013 18:40:35 +0100
Message-ID: <1360172447-2424-1-git-send-email-arend@broadcom.com> (sfid-20130206_184243_906946_7CA4C756)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Some cleanup items moving to interface oriented code to allow
dealing with multiple interfaces, which is going to be needed
soon.

Some other patches in this series fix connecting issues with
an AP that is configured without security. Turns out the bcm43236
specifically needs this workaround.

This series is intended for v3.9 and applies to the wireless-next
repository.

Arend van Spriel (3):
  brcmfmac: add chip information to the bus interface
  brcmfmac: add function to retrieve chip information
  brcmfmac: fix problem connecting to AP without security

Hante Meuleman (9):
  brcmfmac: Remove drvr_up from bus interface.
  brcmfmac: Remove copy mac address from drvr at netdev up.
  brcmfmac: Use struct brcmf_if in brcmf_configure_opensecurity.
  brcmfmac: Track pending 8021x frames per ifp.
  brcmfmac: Add logging for FIL int set/get cmds.
  brcmfmac: Track statistics per ifp.
  brcmfmac: Update tracelogging for multiple netdevs.
  brcmfmac: Cleanup function brcmf_notifiy_connect_status_ap.
  brcmfmac: Use single function for channel to chanspec.

 drivers/net/wireless/brcm80211/brcmfmac/dhd.h      |    8 +-
 drivers/net/wireless/brcm80211/brcmfmac/dhd_bus.h  |   19 +--
 .../net/wireless/brcm80211/brcmfmac/dhd_linux.c    |  142 +++++++++-----------
 drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c |   18 +--
 drivers/net/wireless/brcm80211/brcmfmac/fwil.c     |    2 +
 drivers/net/wireless/brcm80211/brcmfmac/usb.c      |   11 +-
 .../net/wireless/brcm80211/brcmfmac/wl_cfg80211.c  |  111 +++++++--------
 7 files changed, 134 insertions(+), 177 deletions(-)

-- 
1.7.10.4



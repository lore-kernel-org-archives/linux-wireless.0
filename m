Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:3752 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760195Ab3BHO4k (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Feb 2013 09:56:40 -0500
From: "Arend van Spriel" <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
cc: "Linux Wireless List" <linux-wireless@vger.kernel.org>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 00/27] brcmfmac: add initial (old-school) P2P support
Date: Fri, 8 Feb 2013 15:53:35 +0100
Message-ID: <1360335242-12608-1-git-send-email-arend@broadcom.com> (sfid-20130208_155928_790645_CA98E3D3)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This series adds P2P functionality to the brcmfmac driver. It has been
verified with wpa_supplicant performing successful FIND, LISTEN and
GO Negotiation. It can setup a peer-to-peer connection while associated
with an AP.

Now for the term "old-school". While working on this feature the
nl80211 interface type P2P_DEVICE was introduced. However, wpa_supplicant
has not support for it so the feature was developed and tested using
a dummy net device for P2P management. We have had contact with David
Spinadel, who is doing the wpa_supplicant work. Our next step will
be to rework brcmfmac supporting the P2P_DEVICE type and test it against
wpa_supplicant with David's changes.

Using the patches in this series, people can have a look at P2P feature
when it is built with CONFIG_BRCMDBG and the module is loaded with the
parameter p2pon=1.

This series is intended for v3.9 and depends on the patch series
identified by:

<1360321595-31722-1-git-send-email-arend@broadcom.com>

Arend van Spriel (6):
  brcmfmac: add peer-to-peer group discovery support
  brcmfmac: add support for creating P2P client/GO interface
  brcmfmac: fix compiler warning on printf format
  brcmfmac: fix generation of the p2p related mac addresses
  brcmfmac: implement support for deleting virtual interfaces
  brcmfmac: change function signatures

Hante Meuleman (21):
  brcmfmac: add support for P2P listen mode.
  brcmfmac: update escan for multiple bss and simplify.
  brcmfmac: update p2p add and delete vif routines.
  brcmfmac: add p2p change vif routines.
  brcmfmac: Fix bug mgmt_rx_register
  brcmfmac: Update connect setup/handling routines for multiple bss.
  brcmfmac: Update AP mode for GO creation.
  brcmfmac: Add handling of receiving P2P action frames.
  brcmfmac: P2P action frame tx.
  brcmfmac: Use real cookie value for p2p remain on channel.
  brcmfmac: Create p2p0 netdev via module variable.
  brcmfmac: Use role from wdev on AP commands and fix stop_ap.
  brcmfmac: Put printing action frames code under debug flag.
  brcmfmac: Ignore E_ADD_IF for ifidx 0.
  brcmfmac: Reject change vif for p2p if.
  brcmfmac: Update netdev configuration in wiphy for p2p.
  brcmfmac: Remove sleep on del_station.
  brcmfmac: Fix rtnl_lock lockup when registering netdev.
  brcmfmac: Cleanup of unused defines.
  brcmfmac: Create netdev before returning from add_virtual_intf.
  brcmfmac: Add tx p2p off-channel support.

 drivers/net/wireless/brcm80211/brcmfmac/Makefile   |    3 +-
 drivers/net/wireless/brcm80211/brcmfmac/dhd.h      |   39 +-
 .../net/wireless/brcm80211/brcmfmac/dhd_linux.c    |  124 +-
 drivers/net/wireless/brcm80211/brcmfmac/fweh.c     |    2 +-
 drivers/net/wireless/brcm80211/brcmfmac/fweh.h     |    6 +-
 .../net/wireless/brcm80211/brcmfmac/fwil_types.h   |   66 +
 drivers/net/wireless/brcm80211/brcmfmac/p2p.c      | 2277 ++++++++++++++++++++
 drivers/net/wireless/brcm80211/brcmfmac/p2p.h      |  183 ++
 .../net/wireless/brcm80211/brcmfmac/wl_cfg80211.c  | 1262 ++++++++---
 .../net/wireless/brcm80211/brcmfmac/wl_cfg80211.h  |  113 +-
 10 files changed, 3731 insertions(+), 344 deletions(-)
 create mode 100644 drivers/net/wireless/brcm80211/brcmfmac/fwil_types.h
 create mode 100644 drivers/net/wireless/brcm80211/brcmfmac/p2p.c
 create mode 100644 drivers/net/wireless/brcm80211/brcmfmac/p2p.h

-- 
1.7.10.4



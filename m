Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:1666 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1162001Ab3DEI6F (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 5 Apr 2013 04:58:05 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
cc: linux-wireless <linux-wireless@vger.kernel.org>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 00/16] brcm80211: patches providing new functionality
Date: Fri, 5 Apr 2013 10:57:38 +0200
Message-ID: <1365152274-4252-1-git-send-email-arend@broadcom.com> (sfid-20130405_105811_913400_72A1C1F2)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This series consist of patches completing/fixing firmware-signalling
functionality, and P2P device support for brcmfmac. For debugging, a
change has been made to obtain firmware console log through debugfs.

This series is intended for v3.10 kernel and applies to the master branch
of the wireless-next repository.

Arend van Spriel (14):
  brcmfmac: fix unaligned access in TXSTATUS signal handling
  brcmfmac: handle firmware signalling destination entry state
  brcmfmac: handle firmware signals requesting for packets
  brcmfmac: add hexadecimal trace of message payload
  brcmfmac: add role attribute to struct brcmf_if_event definition
  brcmfmac: remove condition for calling event handler
  brcmfmac: remove use of unconditional access of struct
    wireless_dev::netdev
  brcmfmac: use struct brcmf_if instance as parameter in
    brcmf_set_mpc()
  brcmfmac: use struct brcmf_if instance iso netdevice in escan
    functions
  brcmfmac: support creation of P2P_DEVICE through user-space
  brcmfmac: wait for firmware event when creating P2P_DEVICE interface
  brcmfmac: fix reception of P2P probe requests on P2P_DEVICE interface
  brcmfmac: obtain wdev using vif object in action frame rx
  brcmfmac: only use ifidx from BDC header in brcmf_rx_frames()

Piotr Haber (2):
  brcmfmac: read firmware console without trap indication
  brcmfmac: firmware shared data version fix

 drivers/net/wireless/brcm80211/brcmfmac/dhd.h      |    1 +
 drivers/net/wireless/brcm80211/brcmfmac/dhd_dbg.c  |    4 +
 drivers/net/wireless/brcm80211/brcmfmac/dhd_dbg.h  |    5 +
 .../net/wireless/brcm80211/brcmfmac/dhd_linux.c    |   37 ++--
 drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c |   35 ++--
 drivers/net/wireless/brcm80211/brcmfmac/fweh.c     |   15 +-
 drivers/net/wireless/brcm80211/brcmfmac/fweh.h     |    6 +-
 drivers/net/wireless/brcm80211/brcmfmac/fwil.c     |    1 +
 drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c |  115 ++++++++++--
 drivers/net/wireless/brcm80211/brcmfmac/p2p.c      |  190 +++++++++++++++++---
 .../net/wireless/brcm80211/brcmfmac/tracepoint.h   |   14 ++
 .../net/wireless/brcm80211/brcmfmac/wl_cfg80211.c  |  123 +++++++------
 .../net/wireless/brcm80211/brcmfmac/wl_cfg80211.h  |   11 +-
 13 files changed, 408 insertions(+), 149 deletions(-)

-- 
1.7.10.4



Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw3-out.broadcom.com ([216.31.210.64]:9049 "EHLO
	mail-gw3-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751809AbaI3IXX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 30 Sep 2014 04:23:23 -0400
From: Arend van Spriel <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	Arend van Spriel <arend@broadcom.com>
Subject: [PATCH 0/6] brcmfmac: wowlan support and cleanup
Date: Tue, 30 Sep 2014 10:23:12 +0200
Message-ID: <1412065398-14316-1-git-send-email-arend@broadcom.com> (sfid-20140930_102328_773824_B8C421A2)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This series contains WoWLAN support for PCIe chipsets. This feature
depends on firmware capability. Other changes involve minor fixes that
are rare enough to be submitted to wireless-next and cleanups.

The series is intended for 3.18 and applies to the master branch of
the wireless-next repository.

Arend van Spriel (1):
  brcmfmac: assure P2P discovery is disabled when setting P2P_DEVICE mac
    address

Hante Meuleman (5):
  brcmfmac: On scan timeout do send received results.
  brcmfmac: Fix sign issue with IOCTL return code in msgbuf.
  brcmfmac: Avoid usage of GFP_ATOMIC.
  brcmfmac: Fix crash on cleanup.
  brcmfmac: Add wowl support for PCIE devices.

 drivers/net/wireless/brcm80211/brcmfmac/dhd_bus.h  |  11 ++
 drivers/net/wireless/brcm80211/brcmfmac/feature.c  |   2 +
 drivers/net/wireless/brcm80211/brcmfmac/feature.h  |   3 +-
 drivers/net/wireless/brcm80211/brcmfmac/flowring.c |   4 +-
 .../net/wireless/brcm80211/brcmfmac/fwil_types.h   |  56 +++++++++
 drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c |   2 +-
 drivers/net/wireless/brcm80211/brcmfmac/msgbuf.c   | 133 +++++++++++++++++----
 drivers/net/wireless/brcm80211/brcmfmac/p2p.c      |   5 +-
 drivers/net/wireless/brcm80211/brcmfmac/pcie.c     |  74 ++++++++++--
 .../net/wireless/brcm80211/brcmfmac/wl_cfg80211.c  | 114 +++++++++++++-----
 .../net/wireless/brcm80211/brcmfmac/wl_cfg80211.h  |   7 +-
 drivers/net/wireless/brcm80211/include/defs.h      |   5 +-
 12 files changed, 340 insertions(+), 76 deletions(-)

-- 
1.9.1


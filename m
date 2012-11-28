Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:1674 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755970Ab2K1Uo1 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Nov 2012 15:44:27 -0500
From: "Arend van Spriel" <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
cc: "Linux Wireless List" <linux-wireless@vger.kernel.org>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 00/11] brcm80211: bugfixes, cleanup, and bcm4313 iPA
 support
Date: Wed, 28 Nov 2012 21:44:03 +0100
Message-ID: <1354135454-7035-1-git-send-email-arend@broadcom.com> (sfid-20121128_214440_046926_A05F4BD8)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This series contain a bugfix for brcmfmac and one for brcmsmac. Other cleanup
changes are in preparation for vif support in brcmfmac and the isr code in
brcmsmac needed cleanup as well. The other change involves support for internal
PA variant of the bcm4313 chip.

This series is intended for v3.8 and applies to wireless-next repository.

Arend van Spriel (3):
  brcm80211: update the MAINTAINERS file
  brcmfmac: get rid of struct brcmf_cfg80211_info::link_up attribute
  brcmfmac: remove mode from struct brcmf_cfg80211_conf

Hante Meuleman (2):
  brcmfmac: fix bug in setting mgmt ie and parsing vndrs ie.
  brcmfmac: change debug output for received event.

Piotr Haber (6):
  brcmsmac: handle packet drop during transmit correctly
  brcmsmac: cleanup in isr code
  brcmsmac: fix bounds checking in tx/rx
  brcmsmac: hardware info in debugfs
  brcmsmac: move PHY functions
  brcmsmac: support 4313iPA

 MAINTAINERS                                        |    3 +-
 drivers/net/wireless/brcm80211/brcmfmac/fweh.c     |    4 +-
 .../net/wireless/brcm80211/brcmfmac/wl_cfg80211.c  |  141 +++---
 .../net/wireless/brcm80211/brcmfmac/wl_cfg80211.h  |    3 -
 drivers/net/wireless/brcm80211/brcmsmac/debug.c    |  112 +++++
 drivers/net/wireless/brcm80211/brcmsmac/debug.h    |   23 +
 .../net/wireless/brcm80211/brcmsmac/mac80211_if.c  |   29 +-
 drivers/net/wireless/brcm80211/brcmsmac/main.c     |   61 +--
 .../net/wireless/brcm80211/brcmsmac/phy/phy_lcn.c  |  471 ++++++++++++--------
 .../wireless/brcm80211/brcmsmac/phy/phytbl_lcn.c   |   64 +--
 drivers/net/wireless/brcm80211/brcmsmac/pub.h      |    5 +-
 11 files changed, 567 insertions(+), 349 deletions(-)

-- 
1.7.10.4



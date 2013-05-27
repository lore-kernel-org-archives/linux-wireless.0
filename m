Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:4118 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756554Ab3E0TKQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 May 2013 15:10:16 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
cc: linux-wireless <linux-wireless@vger.kernel.org>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH for 3.10 0/7] brcmfmac: AP and P2P mode fixes
Date: Mon, 27 May 2013 21:09:52 +0200
Message-ID: <1369681799-3163-1-git-send-email-arend@broadcom.com> (sfid-20130527_211026_303923_D0A9D4FC)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Here a couple of fixes for brcmfmac. AP mode was already
added since v3.7 so it is tagged for stable. The majority
of P2P fixes are solving issues with creation and deletion
of the P2P interfaces, ie. P2P_DEVICE, P2P_CLIENT, P2P_GO.

This series applies to the master branch of the wireless
repository.

Arend van Spriel (3):
  brcmfmac: add additional parameter to brcmf_free_vif()
  brcmfmac: free net device when registration fails
  brcmfmac: use struct net_device::destructor to remove interfaces

Hante Meuleman (4):
  brcmfmac: Turn off ARP offloading when configured for AP.
  brcmfmac: Fix p2p setup when connected to ap on 5G.
  brcmfmac: Add multi channel support for P2P.
  brcmfmac: Disable powersave mode for P2P link.

 .../net/wireless/brcm80211/brcmfmac/dhd_common.c   |   18 ----
 .../net/wireless/brcm80211/brcmfmac/dhd_linux.c    |   16 ++--
 drivers/net/wireless/brcm80211/brcmfmac/fweh.c     |    3 +-
 .../net/wireless/brcm80211/brcmfmac/fwil_types.h   |    6 ++
 drivers/net/wireless/brcm80211/brcmfmac/p2p.c      |   74 +++++++++++-----
 .../net/wireless/brcm80211/brcmfmac/wl_cfg80211.c  |   89 +++++++++++++++++---
 .../net/wireless/brcm80211/brcmfmac/wl_cfg80211.h  |    3 +-
 7 files changed, 149 insertions(+), 60 deletions(-)

-- 
1.7.10.4



Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:1765 "EHLO mms3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751541Ab3FZMUd (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Jun 2013 08:20:33 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
cc: linux-wireless <linux-wireless@vger.kernel.org>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 0/9] brcmfmac: platform data change and cleanup
Date: Wed, 26 Jun 2013 14:20:13 +0200
Message-ID: <1372249222-4858-1-git-send-email-arend@broadcom.com> (sfid-20130626_142052_979081_16593957)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Testing the recently added scatter-gather support in SDIO on an
OMAP4 Panda showed DMA failures. This is due to alignment requirements
for that particular piece of hardware. Added flag to the platform data
to use a backup mechanism.

Other cleanup was done in firmware-signalling and some comment referring
to v2.4 kernel support triggered cleanup in rx path.

Arend van Spriel (6):
  brcmfmac: simplify transmit path
  brcmfmac: remove (ab)use of NL80211_NUM_ACS
  brcmfmac: tag packet in the netdev transmit callback
  brcmfmac: cleanup debug messages in brcmf_fws_hdrpush()
  brcmfmac: reduce firmware-signalling locking scope in rx path
  brcmfmac: remove code and comment for older kernel support

Franky Lin (3):
  brcmfmac: remove SDIO_REQ_ASYNC flag
  brcmfmac: use unified dongle address preparation function
  brcmfmac: add broken scatter-gather DMA support

 drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c   |  165 +++++++------
 .../net/wireless/brcm80211/brcmfmac/dhd_linux.c    |   29 +--
 drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c |  260 ++++++++------------
 .../net/wireless/brcm80211/brcmfmac/sdio_host.h    |    5 -
 include/linux/platform_data/brcmfmac-sdio.h        |    5 +
 5 files changed, 204 insertions(+), 260 deletions(-)

-- 
1.7.10.4



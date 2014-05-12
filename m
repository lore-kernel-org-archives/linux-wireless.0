Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw3-out.broadcom.com ([216.31.210.64]:7664 "EHLO
	mail-gw3-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753450AbaELIrm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 May 2014 04:47:42 -0400
From: Arend van Spriel <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	Arend van Spriel <arend@broadcom.com>
Subject: [PATCH 00/14] brcmfmac: enable 80MHz 11ac AP mode and minor changes
Date: Mon, 12 May 2014 10:47:25 +0200
Message-ID: <1399884459-5048-1-git-send-email-arend@broadcom.com> (sfid-20140512_104752_225209_ACB121EF)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The major part of this series are changes to enable 80MHz 11ac AP mode
operation. The other changes are minor optimizations and/or redesign to
prepare for new features.

The series is intended for v3.16 and applies to the master branch
of the wireless-next repository.

Arend van Spriel (8):
  brcmfmac: enhance nvram processing
  brcmfmac: remove usage of cfg80211_get_chandef_type()
  brcm80211: extend channel conversion functions for 80MHz support
  brcmfmac: provide VHT capability information to user-space
  brcmfmac: enable 80Mhz in 5G custom regulatory rules
  brcmfmac: get rid of brcmf_cfg80211_set_channel() function
  brcmfmac: handle 80MHz chanspecs in construct_reg_info() function
  brcmfmac: determine chanspec from struct cfg80211_chan_def info

Daniel Kim (3):
  brcmfmac: Give priority to 5GHz band in selecting target BSS
  brcmfmac: Report the support of firmware roaming
  brcmfmac: Fix reconnect failure after beacon timeout

Hante Meuleman (3):
  brcmfmac: Move out hdrpull from tx_finalize.
  brcmfmac: Move handling 802.1x frames to dhd_linux.
  brcmfmac: Make FWS queueing configurable.

 drivers/net/wireless/brcm80211/brcmfmac/dhd.h      |    2 +-
 drivers/net/wireless/brcm80211/brcmfmac/dhd_bus.h  |    1 +
 .../net/wireless/brcm80211/brcmfmac/dhd_common.c   |   18 ++
 .../net/wireless/brcm80211/brcmfmac/dhd_linux.c    |   32 +--
 .../net/wireless/brcm80211/brcmfmac/fwil_types.h   |   24 +++
 drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c |   80 +++----
 drivers/net/wireless/brcm80211/brcmfmac/nvram.c    |  220 ++++++++++++++++----
 drivers/net/wireless/brcm80211/brcmfmac/usb.c      |    1 +
 .../net/wireless/brcm80211/brcmfmac/wl_cfg80211.c  |  200 +++++++++++++-----
 drivers/net/wireless/brcm80211/brcmutil/d11.c      |   93 +++++++--
 drivers/net/wireless/brcm80211/include/brcmu_d11.h |   14 +-
 .../net/wireless/brcm80211/include/brcmu_wifi.h    |    1 +
 12 files changed, 508 insertions(+), 178 deletions(-)

-- 
1.7.9.5


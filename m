Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:4906 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752861Ab2I0MSS (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Sep 2012 08:18:18 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
cc: "Linux Wireless List" <linux-wireless@vger.kernel.org>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 00/11] brcmfmac: cleanup and support for AP mode
Date: Thu, 27 Sep 2012 14:17:46 +0200
Message-ID: <1348748277-21460-1-git-send-email-arend@broadcom.com> (sfid-20120927_141826_039303_CD070341)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch series delivers AP mode functionality for the brcmfmac
driver. Other changes involve cleanup or minor fixes.

This series is intended for v3.7 and depends on patch sent by Dan
Carpenter identified by:

Message-ID: <20120926072148.GA3956@elgon.mountain>
  brcmfmac: use kcalloc() to prevent integer overflow

Arend van Spriel (6):
  brcmfmac: get rid of extern keyword in wl_cfg80211.h
  brcmfmac: use brcmf_cfg80211_priv to interface with wl_cfg80211 code
  brcmfmac: remove two obsolete structure definitions
  brcmfmac: rename structure brcmf_cfg80211_priv
  brcmfmac: remove brcmf_read_prof() function
  brcmfmac: remove brcmf_update_prof() function

Hante Meuleman (5):
  brcmfmac: use wait_event_timeout for fw control packets over usb.
  brcmfmac: use different fw api for encryption,auth. config
  brcmfmac: use define instead of hardcoded values.
  brcmfmac: notify common driver about usb tx completion.
  brcmfmac: add hostap supoort.

 drivers/net/wireless/brcm80211/brcmfmac/dhd.h      |   33 +-
 .../net/wireless/brcm80211/brcmfmac/dhd_common.c   |   46 +
 drivers/net/wireless/brcm80211/brcmfmac/usb.c      |   48 +-
 .../net/wireless/brcm80211/brcmfmac/wl_cfg80211.c  | 2412 +++++++++++++-------
 .../net/wireless/brcm80211/brcmfmac/wl_cfg80211.h  |   81 +-
 5 files changed, 1762 insertions(+), 858 deletions(-)

-- 
1.7.9.5



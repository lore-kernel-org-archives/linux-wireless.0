Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:4377 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756666Ab2CBV4R (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 2 Mar 2012 16:56:17 -0500
From: "Arend van Spriel" <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
cc: "Linux Wireless List" <linux-wireless@vger.kernel.org>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 0/7] firmware request changed for udev and other cleanup
Date: Fri, 2 Mar 2012 22:55:44 +0100
Message-ID: <1330725351-3803-1-git-send-email-arend@broadcom.com> (sfid-20120302_225627_831445_9E5EB39A)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Both drivers have been changed to move firmware request from the init_module
syscall. Other patches are minor cleanup items

This patch series applies to the wireless-next repository.

Arend van Spriel (7):
  brcm80211: fmac: remove unnecessary NULL pointer check
  brcm80211: fmac: remove brcmf_usb_attrib structure
  brcm80211: fmac: use counters in brcmf_bus structure
  brcm80211: fmac: initialize host interface drivers regardless result
  brcm80211: fmac: remove firmware requests from init_module syscall
  brcm80211: smac: remove firmware requests from init_module syscall
  brcm80211: smac: cleanup couple of debug output statements

 .../net/wireless/brcm80211/brcmfmac/bcmsdh_sdmmc.c |    4 +--
 drivers/net/wireless/brcm80211/brcmfmac/dhd_bus.h  |    4 +-
 .../net/wireless/brcm80211/brcmfmac/dhd_linux.c    |   30 ++++++++++--------
 drivers/net/wireless/brcm80211/brcmfmac/usb.c      |   32 +++++++++----------
 drivers/net/wireless/brcm80211/brcmfmac/usb.h      |   27 +---------------
 drivers/net/wireless/brcm80211/brcmsmac/ampdu.c    |   20 +++++-------
 .../net/wireless/brcm80211/brcmsmac/mac80211_if.c  |   31 ++++++++++++-------
 7 files changed, 64 insertions(+), 84 deletions(-)

-- 
1.7.5.4



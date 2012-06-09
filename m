Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:2388 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752812Ab2FIVZb (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 9 Jun 2012 17:25:31 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
cc: "Linux Wireless List" <linux-wireless@vger.kernel.org>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 0/5] brcm80211: small fixes and debugfs support in
 brcmfmac
Date: Sat, 9 Jun 2012 22:51:40 +0200
Message-ID: <1339275105-3593-1-git-send-email-arend@broadcom.com> (sfid-20120609_232536_721890_FD0551AE)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This series contains couple of fixes for brcmsmac that were reported
on the wireless list. Also exposed some brcmfmac internals through
debugfs.

Arend van Spriel (5):
  brcmsmac: remove brcms_set_hint() function
  brcmsmac: fix smatch warning found in ampdu.c
  brcmfmac: add debugfs helper functions
  brcmfmac: expose sdio internal counters in debugfs
  brcmfmac: introduce checkdied debugfs functionality

 drivers/net/wireless/brcm80211/brcmfmac/Makefile   |    2 +
 drivers/net/wireless/brcm80211/brcmfmac/dhd.h      |    3 +
 drivers/net/wireless/brcm80211/brcmfmac/dhd_dbg.c  |  126 +++++
 drivers/net/wireless/brcm80211/brcmfmac/dhd_dbg.h  |   59 +++
 .../net/wireless/brcm80211/brcmfmac/dhd_linux.c    |    7 +
 drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c |  499 ++++++++++++++++----
 drivers/net/wireless/brcm80211/brcmsmac/ampdu.c    |    5 +-
 .../net/wireless/brcm80211/brcmsmac/mac80211_if.c  |   14 +-
 8 files changed, 608 insertions(+), 107 deletions(-)
 create mode 100644 drivers/net/wireless/brcm80211/brcmfmac/dhd_dbg.c

-- 
1.7.9.5



Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:3447 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755132Ab2DKJxa (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Apr 2012 05:53:30 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
cc: "Linux Wireless List" <linux-wireless@vger.kernel.org>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 0/9] brcm80211: minor bug fixes for broadcom driver
Date: Wed, 11 Apr 2012 11:52:42 +0200
Message-ID: <1334137971-3972-1-git-send-email-arend@broadcom.com> (sfid-20120411_115349_108022_B9669252)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The series contains a number of patches to resolve some issues found
in our brcmfmac regression testing. The brcmsmac changes are adressing
a problem reported by several people within the community. Last patch
in this series has been marked for stable tree.

This series is based on wireless-next repository and depends on the
following patch message:

Message-ID: <1334098954-7556-2-git-send-email-jim.cromie@gmail.com>

Arend van Spriel (6):
  brcm80211: fmac: make brcmf_net_attach() static
  brcm80211: fmac: remove primary mac address handling from
    brcmf_net_attach
  brcm80211: fmac: register primary net device with device mac address
  brcm80211: smac: do not use US as fallback regulatory hint
  brcm80211: smac: only provide valid regulatory hint
  brcm80211: smac: resume transmit fifo upon receiving frames

Franky Lin (3):
  brcm80211: fmac: add frame header extension support
  brcm80211: fmac: postpone dongle RF enabling.
  brcm80211: fmac: clean up chip id table

 drivers/net/wireless/brcm80211/brcmfmac/dhd.h      |    1 -
 drivers/net/wireless/brcm80211/brcmfmac/dhd_cdc.c  |    1 +
 .../net/wireless/brcm80211/brcmfmac/dhd_common.c   |    4 -
 .../net/wireless/brcm80211/brcmfmac/dhd_linux.c    |  127 +++++++++++---------
 drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c |    6 -
 drivers/net/wireless/brcm80211/brcmfmac/usb.c      |    8 --
 drivers/net/wireless/brcm80211/brcmsmac/channel.c  |   36 ++++++-
 .../net/wireless/brcm80211/brcmsmac/mac80211_if.c  |    6 +-
 drivers/net/wireless/brcm80211/brcmsmac/main.c     |    8 ++
 .../net/wireless/brcm80211/include/brcm_hw_ids.h   |   40 ++-----
 10 files changed, 124 insertions(+), 113 deletions(-)

-- 
1.7.5.4



Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:4980 "EHLO mms3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751944Ab2H3IF4 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Aug 2012 04:05:56 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
cc: "Linux Wireless List" <linux-wireless@vger.kernel.org>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 0/4 v3.6] brcmfmac: fix stability issues observed
Date: Thu, 30 Aug 2012 10:05:33 +0200
Message-ID: <1346313937-3605-1-git-send-email-arend@broadcom.com> (sfid-20120830_100612_237091_D8727231)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This series addresses a couple of issues that were found during
driver testing. These patches are intended for v3.6 and applies
to the wireless tree.

Arend van Spriel (1):
  brcmfmac: fix use of dev_kfree_skb() in irq context

Hante Meuleman (3):
  brcmfmac: dont use ZERO flag for usb IN
  brcmfmac: fix race condition for rx and tx data.
  brcmfmac: fix get rssi by clearing getvar struct.

 drivers/net/wireless/brcm80211/brcmfmac/usb.c      |   30 ++++++++++----------
 .../net/wireless/brcm80211/brcmfmac/wl_cfg80211.c  |   15 +++++-----
 2 files changed, 23 insertions(+), 22 deletions(-)

-- 
1.7.9.5



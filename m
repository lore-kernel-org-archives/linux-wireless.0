Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f215.google.com ([209.85.220.215]:39680 "EHLO
	mail-fx0-f215.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755404AbZHPSIO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 16 Aug 2009 14:08:14 -0400
Received: by fxm11 with SMTP id 11so1938814fxm.39
        for <linux-wireless@vger.kernel.org>; Sun, 16 Aug 2009 11:08:14 -0700 (PDT)
Message-ID: <4A884B0D.5000808@gmail.com>
Date: Sun, 16 Aug 2009 20:08:13 +0200
From: =?UTF-8?B?R8OhYm9yIFN0ZWZhbmlr?= <netrolller.3d@gmail.com>
MIME-Version: 1.0
To: John Linville <linville@tuxdriver.com>,
	Michael Buesch <mb@bu3sch.de>,
	Larry Finger <Larry.Finger@lwfinger.net>
CC: Mark Huijgen <mark@huijgen.tk>,
	Broadcom Wireless <bcm43xx-dev@lists.berlios.de>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: [PATCH] b43: LP-PHY: Update B2062 radio init with recent spec changes
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The spec for initializing the B2062 radio have changed recently,
update the code to match the changes.

Signed-off-by: Gábor Stefanik <netrolller.3d@gmail.com>
---
 drivers/net/wireless/b43/phy_lp.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/b43/phy_lp.c b/drivers/net/wireless/b43/phy_lp.c
index 5a7b873..34b7910 100644
--- a/drivers/net/wireless/b43/phy_lp.c
+++ b/drivers/net/wireless/b43/phy_lp.c
@@ -539,10 +539,15 @@ static void lpphy_2062_init(struct b43_wldev *dev)
 	b43_radio_write(dev, B2062_N_TX_CTL3, 0);
 	b43_radio_write(dev, B2062_N_TX_CTL4, 0);
 	b43_radio_write(dev, B2062_N_TX_CTL5, 0);
+	b43_radio_write(dev, B2062_N_TX_CTL6, 0);
 	b43_radio_write(dev, B2062_N_PDN_CTL0, 0x40);
 	b43_radio_write(dev, B2062_N_PDN_CTL0, 0);
 	b43_radio_write(dev, B2062_N_CALIB_TS, 0x10);
 	b43_radio_write(dev, B2062_N_CALIB_TS, 0);
+	if (dev->phy.rev > 0) {
+		b43_radio_write(dev, B2062_S_BG_CTL1,
+			(b43_radio_read(dev, B2062_N_COMM2) >> 1) | 0x80);
+	}
 	if (b43_current_band(dev->wl) == IEEE80211_BAND_2GHZ)
 		b43_radio_set(dev, B2062_N_TSSI_CTL0, 0x1);
 	else
-- 
1.6.2.4




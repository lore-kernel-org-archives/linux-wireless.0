Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:33596 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750859Ab0KRM1F (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Nov 2010 07:27:05 -0500
Received: by mail-ey0-f174.google.com with SMTP id 27so1855656eye.19
        for <linux-wireless@vger.kernel.org>; Thu, 18 Nov 2010 04:27:04 -0800 (PST)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: b43-dev@lists.infradead.org,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH 4/4] b43: N-PHY: init BPHY when needed
Date: Thu, 18 Nov 2010 13:28:00 +0100
Message-Id: <1290083280-13550-4-git-send-email-zajec5@gmail.com>
In-Reply-To: <1290083280-13550-1-git-send-email-zajec5@gmail.com>
References: <1290083280-13550-1-git-send-email-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
 drivers/net/wireless/b43/phy_n.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/b43/phy_n.c b/drivers/net/wireless/b43/phy_n.c
index bea7dab..2c60793 100644
--- a/drivers/net/wireless/b43/phy_n.c
+++ b/drivers/net/wireless/b43/phy_n.c
@@ -1572,6 +1572,7 @@ static void b43_nphy_rf_control_intc_override(struct b43_wldev *dev, u8 field,
 	}
 }
 
+/* http://bcm-v4.sipsolutions.net/802.11/PHY/N/BPHYInit */
 static void b43_nphy_bphy_init(struct b43_wldev *dev)
 {
 	unsigned int i;
@@ -3239,6 +3240,9 @@ int b43_phy_initn(struct b43_wldev *dev)
 
 	b43_nphy_classifier(dev, 0, 0);
 	b43_nphy_read_clip_detection(dev, clip);
+	if (b43_current_band(dev->wl) == IEEE80211_BAND_2GHZ)
+		b43_nphy_bphy_init(dev);
+
 	tx_pwr_state = nphy->txpwrctrl;
 	/* TODO N PHY TX power control with argument 0
 		(turning off power control) */
-- 
1.7.1


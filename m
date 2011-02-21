Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f42.google.com ([74.125.82.42]:46119 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751889Ab1BUSpu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Feb 2011 13:45:50 -0500
Received: by wwi17 with SMTP id 17so3258647wwi.1
        for <linux-wireless@vger.kernel.org>; Mon, 21 Feb 2011 10:45:49 -0800 (PST)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: b43-dev@lists.infradead.org,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH 1/2] b43: N-PHY: rev1: enable some gain ctl workarounds
Date: Mon, 21 Feb 2011 19:45:34 +0100
Message-Id: <1298313935-4094-1-git-send-email-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
 drivers/net/wireless/b43/phy_n.c |   18 +++++++++---------
 1 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/b43/phy_n.c b/drivers/net/wireless/b43/phy_n.c
index ab81ed8..cc19e3f 100644
--- a/drivers/net/wireless/b43/phy_n.c
+++ b/drivers/net/wireless/b43/phy_n.c
@@ -1281,17 +1281,17 @@ static void b43_nphy_gain_ctrl_workarounds(struct b43_wldev *dev)
 						B43_NPHY_TABLE_DATALO, tmp);
 				}
 			}
+		}
 
-			b43_nphy_set_rf_sequence(dev, 5,
-					rfseq_events, rfseq_delays, 3);
-			b43_phy_maskset(dev, B43_NPHY_OVER_DGAIN1,
-				~B43_NPHY_OVER_DGAIN_CCKDGECV & 0xFFFF,
-				0x5A << B43_NPHY_OVER_DGAIN_CCKDGECV_SHIFT);
+		b43_nphy_set_rf_sequence(dev, 5,
+				rfseq_events, rfseq_delays, 3);
+		b43_phy_maskset(dev, B43_NPHY_OVER_DGAIN1,
+			~B43_NPHY_OVER_DGAIN_CCKDGECV & 0xFFFF,
+			0x5A << B43_NPHY_OVER_DGAIN_CCKDGECV_SHIFT);
 
-			if (b43_current_band(dev->wl) == IEEE80211_BAND_2GHZ)
-				b43_phy_maskset(dev, B43_PHY_N(0xC5D),
-						0xFF80, 4);
-		}
+		if (b43_current_band(dev->wl) == IEEE80211_BAND_2GHZ)
+			b43_phy_maskset(dev, B43_PHY_N(0xC5D),
+					0xFF80, 4);
 	}
 }
 
-- 
1.7.1


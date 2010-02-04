Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f211.google.com ([209.85.220.211]:53036 "EHLO
	mail-fx0-f211.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756345Ab0BDLa4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 4 Feb 2010 06:30:56 -0500
Received: by fxm3 with SMTP id 3so2448023fxm.39
        for <linux-wireless@vger.kernel.org>; Thu, 04 Feb 2010 03:30:55 -0800 (PST)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: bcm43xx-dev@lists.berlios.de,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH 2/5] b43: N-PHY: load generated samples
Date: Thu,  4 Feb 2010 12:23:09 +0100
Message-Id: <1265282592-25491-2-git-send-email-zajec5@gmail.com>
In-Reply-To: <1265282592-25491-1-git-send-email-zajec5@gmail.com>
References: <1265282592-25491-1-git-send-email-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
 drivers/net/wireless/b43/phy_n.c |   26 +++++++++++++++++++++++++-
 1 files changed, 25 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/b43/phy_n.c b/drivers/net/wireless/b43/phy_n.c
index 8992457..89e9d66 100644
--- a/drivers/net/wireless/b43/phy_n.c
+++ b/drivers/net/wireless/b43/phy_n.c
@@ -956,6 +956,30 @@ static void b43_nphy_workarounds(struct b43_wldev *dev)
 		b43_nphy_stay_in_carrier_search(dev, 0);
 }
 
+/* http://bcm-v4.sipsolutions.net/802.11/PHY/N/LoadSampleTable */
+static void b43_nphy_load_samples(struct b43_wldev *dev,
+					struct b43_c32 *samples, u16 len) {
+	struct b43_phy_n *nphy = dev->phy.n;
+	u16 i;
+	u32 *data;
+
+	data = kzalloc(len * sizeof(u32), GFP_KERNEL);
+
+	if (nphy->hang_avoid)
+		b43_nphy_stay_in_carrier_search(dev, 1);
+
+	for (i = 0; i < len; i++) {
+		data[i] = (samples[i].i & 0x3FF << 10);
+		data[i] |= samples[i].q & 0x3FF;
+	}
+	b43_ntab_write_bulk(dev, B43_NTAB32(17, 0), len, data);
+
+	kfree(data);
+
+	if (nphy->hang_avoid)
+		b43_nphy_stay_in_carrier_search(dev, 0);
+}
+
 /* http://bcm-v4.sipsolutions.net/802.11/PHY/N/GenLoadSamples */
 static u16 b43_nphy_gen_load_samples(struct b43_wldev *dev, u32 freq, u16 max,
 					bool test)
@@ -991,7 +1015,7 @@ static u16 b43_nphy_gen_load_samples(struct b43_wldev *dev, u32 freq, u16 max,
 		samples[i].i = CORDIC_CONVERT(samples[i].i * max);
 	}
 
-	/* TODO: Call N PHY Load Sample Table with buffer, len as arguments */
+	b43_nphy_load_samples(dev, samples, len);
 	kfree(samples);
 	return len;
 }
-- 
1.6.4.2


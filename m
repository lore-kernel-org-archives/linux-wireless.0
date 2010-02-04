Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f211.google.com ([209.85.220.211]:57610 "EHLO
	mail-fx0-f211.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757809Ab0BDMIF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 4 Feb 2010 07:08:05 -0500
Received: by fxm3 with SMTP id 3so2491928fxm.39
        for <linux-wireless@vger.kernel.org>; Thu, 04 Feb 2010 04:08:02 -0800 (PST)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	bcm43xx-dev@lists.berlios.de,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH 2/5 V2] b43: N-PHY: load generated samples
Date: Thu,  4 Feb 2010 13:08:08 +0100
Message-Id: <1265285291-28202-3-git-send-email-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
V2: handle allocation fail, thanks Johannes for pointing
---
 drivers/net/wireless/b43/phy_n.c |   31 +++++++++++++++++++++++++++++--
 1 files changed, 29 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/b43/phy_n.c b/drivers/net/wireless/b43/phy_n.c
index 8992457..b2a91c2 100644
--- a/drivers/net/wireless/b43/phy_n.c
+++ b/drivers/net/wireless/b43/phy_n.c
@@ -956,6 +956,33 @@ static void b43_nphy_workarounds(struct b43_wldev *dev)
 		b43_nphy_stay_in_carrier_search(dev, 0);
 }
 
+/* http://bcm-v4.sipsolutions.net/802.11/PHY/N/LoadSampleTable */
+static int b43_nphy_load_samples(struct b43_wldev *dev,
+					struct b43_c32 *samples, u16 len) {
+	struct b43_phy_n *nphy = dev->phy.n;
+	u16 i;
+	u32 *data;
+
+	data = kzalloc(len * sizeof(u32), GFP_KERNEL);
+	if (!data) {
+		b43err(dev->wl, "allocation for samples loading failed\n");
+		return -ENOMEM;
+	}
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
+	if (nphy->hang_avoid)
+		b43_nphy_stay_in_carrier_search(dev, 0);
+	return 0;
+}
+
 /* http://bcm-v4.sipsolutions.net/802.11/PHY/N/GenLoadSamples */
 static u16 b43_nphy_gen_load_samples(struct b43_wldev *dev, u32 freq, u16 max,
 					bool test)
@@ -991,9 +1018,9 @@ static u16 b43_nphy_gen_load_samples(struct b43_wldev *dev, u32 freq, u16 max,
 		samples[i].i = CORDIC_CONVERT(samples[i].i * max);
 	}
 
-	/* TODO: Call N PHY Load Sample Table with buffer, len as arguments */
+	i = b43_nphy_load_samples(dev, samples, len);
 	kfree(samples);
-	return len;
+	return (i < 0) ? 0 : len;
 }
 
 /* http://bcm-v4.sipsolutions.net/802.11/PHY/N/RunSamples */
-- 
1.6.4.2


Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.24]:32432 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754609Ab0AYSAc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Jan 2010 13:00:32 -0500
Received: by ey-out-2122.google.com with SMTP id d26so984534eyd.19
        for <linux-wireless@vger.kernel.org>; Mon, 25 Jan 2010 10:00:30 -0800 (PST)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: bcm43xx-dev@lists.berlios.de,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH 4/4] b43: N-PHY: use cordic to generate samples
Date: Mon, 25 Jan 2010 19:00:01 +0100
Message-Id: <1264442401-6364-5-git-send-email-zajec5@gmail.com>
In-Reply-To: <1264442401-6364-1-git-send-email-zajec5@gmail.com>
References: <1264442401-6364-1-git-send-email-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
 drivers/net/wireless/b43/phy_n.c |   21 ++++++++++++---------
 1 files changed, 12 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/b43/phy_n.c b/drivers/net/wireless/b43/phy_n.c
index 061b01b..e15f05c 100644
--- a/drivers/net/wireless/b43/phy_n.c
+++ b/drivers/net/wireless/b43/phy_n.c
@@ -821,8 +821,9 @@ static u16 b43_nphy_gen_load_samples(struct b43_wldev *dev, u32 freq, u16 max,
 					bool test)
 {
 	int i;
-	u16 bw, len, num, rot, angle;
-	/* TODO: *buffer; */
+	u16 bw, len, rot, angle;
+	b43_c32 *samples;
+	
 
 	bw = (dev->phy.is_40mhz) ? 40 : 20;
 	len = bw << 3;
@@ -839,18 +840,20 @@ static u16 b43_nphy_gen_load_samples(struct b43_wldev *dev, u32 freq, u16 max,
 		len = bw << 1;
 	}
 
-	/* TODO: buffer = kzalloc(len * sizeof(u32), GFP_KERNEL); */
-	num = len;
+	samples = kzalloc(len * sizeof(b43_c32), GFP_KERNEL);
 	rot = (((freq * 36) / bw) << 16) / 100;
 	angle = 0;
 
-	for (i = 0; i < num; i++) {
-		/* TODO */
+	for (i = 0; i < len; i++) {
+		samples[i] = b43_cordic(angle);
+		angle += rot;
+		samples[i].q = CORDIC_CONVERT(samples[i].q * max);
+		samples[i].i = CORDIC_CONVERT(samples[i].i * max);
 	}
 
-	/* TODO: Call N PHY Load Sample Table with buffer, num as arguments */
-	/* TODO: kfree(buffer); */
-	return num;
+	/* TODO: Call N PHY Load Sample Table with buffer, len as arguments */
+	kfree(samples);
+	return len;
 }
 
 /* http://bcm-v4.sipsolutions.net/802.11/PHY/N/RunSamples */
-- 
1.6.4.2


Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:54056 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751395Ab1HXJuu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 24 Aug 2011 05:50:50 -0400
Received: by mail-bw0-f46.google.com with SMTP id 11so751897bke.19
        for <linux-wireless@vger.kernel.org>; Wed, 24 Aug 2011 02:50:50 -0700 (PDT)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: b43-dev@lists.infradead.org,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH 2/2] b43: HT-PHY: read clip state
Date: Wed, 24 Aug 2011 11:52:35 +0200
Message-Id: <1314179555-8188-2-git-send-email-zajec5@gmail.com> (sfid-20110824_115053_948716_C99880A1)
In-Reply-To: <1314179555-8188-1-git-send-email-zajec5@gmail.com>
References: <1314179555-8188-1-git-send-email-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We don't know yet when to restore it, implement just reading. We found
out what for are that PHY ops by comparing HT with N code.

Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
 drivers/net/wireless/b43/phy_ht.c |   11 ++++++++++-
 drivers/net/wireless/b43/phy_ht.h |    4 ++++
 2 files changed, 14 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/b43/phy_ht.c b/drivers/net/wireless/b43/phy_ht.c
index c0e436c..4d6345e 100644
--- a/drivers/net/wireless/b43/phy_ht.c
+++ b/drivers/net/wireless/b43/phy_ht.c
@@ -212,6 +212,13 @@ static void b43_phy_ht_force_rf_sequence(struct b43_wldev *dev, u16 rf_seq)
 	b43_phy_write(dev, B43_PHY_HT_RF_SEQ_MODE, save_seq_mode);
 }
 
+static void b43_phy_ht_read_clip_detection(struct b43_wldev *dev, u16 *clip_st)
+{
+	clip_st[0] = b43_phy_read(dev, B43_PHY_HT_C1_CLIP1THRES);
+	clip_st[1] = b43_phy_read(dev, B43_PHY_HT_C2_CLIP1THRES);
+	clip_st[2] = b43_phy_read(dev, B43_PHY_HT_C3_CLIP1THRES);
+}
+
 static void b43_phy_ht_bphy_init(struct b43_wldev *dev)
 {
 	unsigned int i;
@@ -335,6 +342,7 @@ static void b43_phy_ht_op_prepare_structs(struct b43_wldev *dev)
 static int b43_phy_ht_op_init(struct b43_wldev *dev)
 {
 	u16 tmp;
+	u16 clip_state[3];
 
 	b43_phy_ht_tables_init(dev);
 
@@ -443,7 +451,8 @@ static int b43_phy_ht_op_init(struct b43_wldev *dev)
 
 	/* TODO: PHY op on reg 0xb0 */
 
-	/* TODO: PHY ops on regs 0x40e, 0x44e, 0x48e */
+	/* TODO: Should we restore it? Or store it in global PHY info? */
+	b43_phy_ht_read_clip_detection(dev, clip_state);
 
 	if (b43_current_band(dev->wl) == IEEE80211_BAND_2GHZ)
 		b43_phy_ht_bphy_init(dev);
diff --git a/drivers/net/wireless/b43/phy_ht.h b/drivers/net/wireless/b43/phy_ht.h
index 0661ae2..6544c42 100644
--- a/drivers/net/wireless/b43/phy_ht.h
+++ b/drivers/net/wireless/b43/phy_ht.h
@@ -19,6 +19,10 @@
 #define B43_PHY_HT_BW5				0x1D2
 #define B43_PHY_HT_BW6				0x1D3
 
+#define B43_PHY_HT_C1_CLIP1THRES		B43_PHY_OFDM(0x00E)
+#define B43_PHY_HT_C2_CLIP1THRES		B43_PHY_OFDM(0x04E)
+#define B43_PHY_HT_C3_CLIP1THRES		B43_PHY_OFDM(0x08E)
+
 #define B43_PHY_HT_RF_SEQ_MODE			B43_PHY_EXTG(0x000)
 #define B43_PHY_HT_RF_SEQ_TRIG			B43_PHY_EXTG(0x003)
 #define  B43_PHY_HT_RF_SEQ_TRIG_RX2TX		0x0001 /* RX2TX */
-- 
1.7.3.4


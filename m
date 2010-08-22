Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f46.google.com ([209.85.215.46]:47999 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750996Ab0HVTsr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 22 Aug 2010 15:48:47 -0400
Received: by ewy23 with SMTP id 23so2946080ewy.19
        for <linux-wireless@vger.kernel.org>; Sun, 22 Aug 2010 12:48:46 -0700 (PDT)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: b43-dev@lists.infradead.org,
	=?UTF-8?q?G=C3=A1bor=20Stefanik?= <netrolller.3d@gmail.com>,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH 1/2] b43: N-PHY: band width setting with dumb clock control call
Date: Sun, 22 Aug 2010 21:49:48 +0200
Message-Id: <1282506589-8220-1-git-send-email-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
 drivers/net/wireless/b43/phy_common.c |   20 ++++++++++++++++++++
 drivers/net/wireless/b43/phy_common.h |   11 +++++++++++
 drivers/net/wireless/b43/phy_n.c      |    4 ++--
 drivers/net/wireless/b43/phy_n.h      |    1 -
 4 files changed, 33 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/b43/phy_common.c b/drivers/net/wireless/b43/phy_common.c
index 8f7d7ef..b06e3f0 100644
--- a/drivers/net/wireless/b43/phy_common.c
+++ b/drivers/net/wireless/b43/phy_common.c
@@ -466,3 +466,23 @@ struct b43_c32 b43_cordic(int theta)
 
 	return ret;
 }
+
+/* http://bcm-v4.sipsolutions.net/802.11/PHY/ClkCtlClk */
+static void b43_clock_control(struct b43_wldev *dev, u32 mode)
+{
+	; /* TODO */
+}
+
+/* http://bcm-v4.sipsolutions.net/802.11/PHY/BmacBwSet */
+void b43_bmac_set_b_width(struct b43_wldev *dev, u8 b_width)
+{
+	bool fast = dev->phy.forcefastclk;;
+	if (!fast)
+		b43_clock_control(dev, 0);
+	dev->phy.b_width = b_width;
+	b43_read32(dev, B43_MMIO_MACCTL); /* flush writes */
+	/* TODO: Call PHY BMAC Reset */
+	dev->phy.ops->init(dev);
+	if (fast)
+		b43_clock_control(dev, 2);
+}
diff --git a/drivers/net/wireless/b43/phy_common.h b/drivers/net/wireless/b43/phy_common.h
index bd480b4..9886db0 100644
--- a/drivers/net/wireless/b43/phy_common.h
+++ b/drivers/net/wireless/b43/phy_common.h
@@ -218,6 +218,9 @@ struct b43_phy {
 	bool supports_2ghz;
 	bool supports_5ghz;
 
+	/* Band width */
+	u8 b_width;
+
 	/* HT info */
 	bool is_40mhz;
 
@@ -256,6 +259,9 @@ struct b43_phy {
 	/* PHY TX errors counter. */
 	atomic_t txerr_cnt;
 
+	/* Clock */
+	bool forcefastclk;
+
 #ifdef CONFIG_B43_DEBUG
 	/* PHY registers locked (w.r.t. firmware) */
 	bool phy_locked;
@@ -429,4 +435,9 @@ void b43_phyop_switch_analog_generic(struct b43_wldev *dev, bool on);
 
 struct b43_c32 b43_cordic(int theta);
 
+/**
+ * b43_bmac_set_b_width - Set band width
+ */
+void b43_bmac_set_b_width(struct b43_wldev *dev, u8 b_width);
+
 #endif /* LINUX_B43_PHY_COMMON_H_ */
diff --git a/drivers/net/wireless/b43/phy_n.c b/drivers/net/wireless/b43/phy_n.c
index 2466c0a..ac217da 100644
--- a/drivers/net/wireless/b43/phy_n.c
+++ b/drivers/net/wireless/b43/phy_n.c
@@ -3410,8 +3410,8 @@ static int b43_nphy_set_chanspec(struct b43_wldev *dev,
 
 	nphy->radio_chanspec = chanspec;
 
-	if (chanspec.b_width != nphy->b_width)
-		; /* TODO: BMAC BW Set (chanspec.b_width) */
+	if (chanspec.b_width != dev->phy.b_width)
+		b43_bmac_set_b_width(dev, chanspec.b_width);
 
 	/* TODO: use defines */
 	if (chanspec.b_width == 3) {
diff --git a/drivers/net/wireless/b43/phy_n.h b/drivers/net/wireless/b43/phy_n.h
index 8b6d570..e7acae2 100644
--- a/drivers/net/wireless/b43/phy_n.h
+++ b/drivers/net/wireless/b43/phy_n.h
@@ -984,7 +984,6 @@ struct b43_phy_n {
 	u16 papd_epsilon_offset[2];
 	s32 preamble_override;
 	u32 bb_mult_save;
-	u8 b_width;
 	struct b43_chanspec radio_chanspec;
 
 	bool gain_boost;
-- 
1.7.1


Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:48509 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751740Ab0LVTPI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Dec 2010 14:15:08 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: linux-wireless@vger.kernel.org
Cc: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>,
	"John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 1/3] b43: N-PHY: band width setting with dumb clock control call
Date: Wed, 22 Dec 2010 14:11:30 -0500
Message-Id: <1293045092-12483-2-git-send-email-linville@tuxdriver.com>
In-Reply-To: <1293045092-12483-1-git-send-email-linville@tuxdriver.com>
References: <1293045092-12483-1-git-send-email-linville@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Rafał Miłecki <zajec5@gmail.com>

Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
---
 drivers/net/wireless/b43/phy_common.c |   20 ++++++++++++++++++++
 drivers/net/wireless/b43/phy_common.h |   11 +++++++++++
 drivers/net/wireless/b43/phy_n.c      |    2 +-
 3 files changed, 32 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/b43/phy_common.c b/drivers/net/wireless/b43/phy_common.c
index b5c5ce9..113b9f1 100644
--- a/drivers/net/wireless/b43/phy_common.c
+++ b/drivers/net/wireless/b43/phy_common.c
@@ -482,3 +482,23 @@ struct b43_c32 b43_cordic(int theta)
 
 	return ret;
 }
+
+/* http://bcm-v4.sipsolutions.net/802.11/PHY/ClkCtlClk */
+static void b43_clock_control(struct b43_wldev *dev, u32 mode)
+{
+	/* TODO */
+}
+
+/* http://bcm-v4.sipsolutions.net/802.11/PHY/BmacBwSet */
+void b43_bmac_set_b_width(struct b43_wldev *dev, u8 b_width)
+{
+	bool fast = dev->phy.forcefastclk;
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
index 2401bee..2dd04cf 100644
--- a/drivers/net/wireless/b43/phy_common.h
+++ b/drivers/net/wireless/b43/phy_common.h
@@ -222,6 +222,9 @@ struct b43_phy {
 	bool supports_2ghz;
 	bool supports_5ghz;
 
+	/* Band width */
+	u8 b_width;
+
 	/* HT info */
 	bool is_40mhz;
 
@@ -265,6 +268,9 @@ struct b43_phy {
 	/* PHY TX errors counter. */
 	atomic_t txerr_cnt;
 
+	/* Clock */
+	bool forcefastclk;
+
 #ifdef CONFIG_B43_DEBUG
 	/* PHY registers locked (w.r.t. firmware) */
 	bool phy_locked;
@@ -440,4 +446,9 @@ bool b43_channel_type_is_40mhz(enum nl80211_channel_type channel_type);
 
 struct b43_c32 b43_cordic(int theta);
 
+/**
+ * b43_bmac_set_b_width - Set band width
+ */
+void b43_bmac_set_b_width(struct b43_wldev *dev, u8 b_width);
+
 #endif /* LINUX_B43_PHY_COMMON_H_ */
diff --git a/drivers/net/wireless/b43/phy_n.c b/drivers/net/wireless/b43/phy_n.c
index a1aa570..3f2ce92 100644
--- a/drivers/net/wireless/b43/phy_n.c
+++ b/drivers/net/wireless/b43/phy_n.c
@@ -3595,7 +3595,7 @@ static int b43_nphy_set_channel(struct b43_wldev *dev,
 
 	if (b43_channel_type_is_40mhz(phy->channel_type) !=
 		b43_channel_type_is_40mhz(channel_type))
-		; /* TODO: BMAC BW Set (channel_type) */
+		b43_bmac_set_b_width(dev, channel_type);
 
 	if (channel_type == NL80211_CHAN_HT40PLUS)
 		b43_phy_set(dev, B43_NPHY_RXCTL,
-- 
1.7.3.3


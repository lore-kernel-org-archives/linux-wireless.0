Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.153]:58012 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757231Ab0BDLXj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 4 Feb 2010 06:23:39 -0500
Received: by fg-out-1718.google.com with SMTP id 19so27494fgg.1
        for <linux-wireless@vger.kernel.org>; Thu, 04 Feb 2010 03:23:39 -0800 (PST)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: bcm43xx-dev@lists.berlios.de,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH 5/5] b43: N-PHY: partly implement SPUR workaround
Date: Thu,  4 Feb 2010 12:23:12 +0100
Message-Id: <1265282592-25491-5-git-send-email-zajec5@gmail.com>
In-Reply-To: <1265282592-25491-1-git-send-email-zajec5@gmail.com>
References: <1265282592-25491-1-git-send-email-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
 drivers/net/wireless/b43/phy_n.c |   64 +++++++++++++++++++++++++++++++++++++-
 drivers/net/wireless/b43/phy_n.h |    3 ++
 2 files changed, 66 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/b43/phy_n.c b/drivers/net/wireless/b43/phy_n.c
index f632494..6f56844 100644
--- a/drivers/net/wireless/b43/phy_n.c
+++ b/drivers/net/wireless/b43/phy_n.c
@@ -717,6 +717,67 @@ static void b43_nphy_stop_playback(struct b43_wldev *dev)
 		b43_nphy_stay_in_carrier_search(dev, 0);
 }
 
+/* http://bcm-v4.sipsolutions.net/802.11/PHY/N/SpurWar */
+static void b43_nphy_spur_workaround(struct b43_wldev *dev)
+{
+	struct b43_phy_n *nphy = dev->phy.n;
+
+	unsigned int channel;
+	int tone[2] = { 57, 58 };
+	u32 noise[2] = { 0x3FF, 0x3FF };
+
+	B43_WARN_ON(dev->phy.rev < 3);
+
+	if (nphy->hang_avoid)
+		b43_nphy_stay_in_carrier_search(dev, 1);
+
+	/* FIXME: channel = radio_chanspec */
+
+	if (nphy->gband_spurwar_en) {
+		/* TODO: N PHY Adjust Analog Pfbw (7) */
+		if (channel == 11 && dev->phy.is_40mhz)
+			; /* TODO: N PHY Adjust Min Noise Var(2, tone, noise)*/
+		else
+			; /* TODO: N PHY Adjust Min Noise Var(0, NULL, NULL)*/
+		/* TODO: N PHY Adjust CRS Min Power (0x1E) */
+	}
+
+	if (nphy->aband_spurwar_en) {
+		if (channel == 54) {
+			tone[0] = 0x20;
+			noise[0] = 0x25F;
+		} else if (channel == 38 || channel == 102 || channel == 118) {
+			if (0 /* FIXME */) {
+				tone[0] = 0x20;
+				noise[0] = 0x21F;
+			} else {
+				tone[0] = 0;
+				noise[0] = 0;
+			}
+		} else if (channel == 134) {
+			tone[0] = 0x20;
+			noise[0] = 0x21F;
+		} else if (channel == 151) {
+			tone[0] = 0x10;
+			noise[0] = 0x23F;
+		} else if (channel == 153 || channel == 161) {
+			tone[0] = 0x30;
+			noise[0] = 0x23F;
+		} else {
+			tone[0] = 0;
+			noise[0] = 0;
+		}
+
+		if (!tone[0] && !noise[0])
+			; /* TODO: N PHY Adjust Min Noise Var(1, tone, noise)*/
+		else
+			; /* TODO: N PHY Adjust Min Noise Var(0, NULL, NULL)*/
+	}
+
+	if (nphy->hang_avoid)
+		b43_nphy_stay_in_carrier_search(dev, 0);
+}
+
 /* http://bcm-v4.sipsolutions.net/802.11/PHY/N/WorkaroundsGainCtrl */
 static void b43_nphy_gain_crtl_workarounds(struct b43_wldev *dev)
 {
@@ -3079,7 +3140,8 @@ int b43_phy_initn(struct b43_wldev *dev)
 	if (phy->rev >= 3 && phy->rev <= 6)
 		b43_phy_write(dev, B43_NPHY_PLOAD_CSENSE_EXTLEN, 0x0014);
 	b43_nphy_tx_lp_fbw(dev);
-	/* TODO N PHY Spur Workaround */
+	if (phy->rev >= 3)
+		b43_nphy_spur_workaround(dev);
 
 	b43err(dev->wl, "IEEE 802.11n devices are not supported, yet.\n");
 	return 0;
diff --git a/drivers/net/wireless/b43/phy_n.h b/drivers/net/wireless/b43/phy_n.h
index 0400a2c..403aad3 100644
--- a/drivers/net/wireless/b43/phy_n.h
+++ b/drivers/net/wireless/b43/phy_n.h
@@ -1002,6 +1002,9 @@ struct b43_phy_n {
 	u16 classifier_state;
 	u16 clip_state[2];
 
+	bool aband_spurwar_en;
+	bool gband_spurwar_en;
+
 	bool ipa2g_on;
 	u8 iqcal_chanspec_2G;
 	u8 rssical_chanspec_2G;
-- 
1.6.4.2


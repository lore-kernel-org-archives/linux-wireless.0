Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f219.google.com ([209.85.219.219]:34832 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755407Ab0AFPjM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Jan 2010 10:39:12 -0500
Received: by ewy19 with SMTP id 19so9724743ewy.21
        for <linux-wireless@vger.kernel.org>; Wed, 06 Jan 2010 07:39:11 -0800 (PST)
Content-Type: text/plain; charset=utf-8; format=flowed; delsp=yes
Cc: "bcm43xx-dev@lists.berlios.de" <bcm43xx-dev@lists.berlios.de>
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>
Date: Wed, 06 Jan 2010 16:40:32 +0100
Subject: [PATCH 1/5] b43: N-PHY: implement b43_nphy_stay_carrier_search and
 it's calls
MIME-Version: 1.0
From: =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Message-ID: <op.u54a5ufy9lhzdc@linux-g0th.site>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

b43: N-PHY: implement b43_nphy_stay_carrier_search and it's calls


 From ec599007464bb8220c605af500b724797d54aba8 Mon Sep 17 00:00:00 2001
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Date: Wed, 6 Jan 2010 15:20:20 +0100
Subject: [PATCH 1/5] b43: N-PHY: implement b43_nphy_stay_carrier_search and it's calls
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
  drivers/net/wireless/b43/phy_n.c |   57 ++++++++++++++++++++++++++++++++++++++
  drivers/net/wireless/b43/phy_n.h |    3 ++
  2 files changed, 60 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/b43/phy_n.c b/drivers/net/wireless/b43/phy_n.c
index ceb429a..40d7b73 100644
--- a/drivers/net/wireless/b43/phy_n.c
+++ b/drivers/net/wireless/b43/phy_n.c
@@ -348,6 +348,63 @@ static void b43_nphy_reset_cca(struct b43_wldev *dev)
  	b43_phy_write(dev, B43_NPHY_BBCFG, bbcfg & ~B43_NPHY_BBCFG_RSTCCA);
  }

+static void b43_nphy_write_clip_detection(struct b43_wldev *dev, u16 *vals)
+{
+	b43_phy_write(dev, B43_NPHY_C1_CLIP1THRES, vals[0]);
+	b43_phy_write(dev, B43_NPHY_C2_CLIP1THRES, vals[1]);
+}
+
+static void b43_nphy_read_clip_detection(struct b43_wldev *dev, u16 *vals)
+{
+	vals[0] = b43_phy_read(dev, B43_NPHY_C1_CLIP1THRES);
+	vals[1] = b43_phy_read(dev, B43_NPHY_C2_CLIP1THRES);
+}
+
+static u16 b43_nphy_classifier(struct b43_wldev *dev, u16 mask, u16 val)
+{
+	u16 tmp;
+	bool suspended = false;
+
+	if (dev->dev->id.revision == 16 && dev->mac_suspended == 0) {
+		b43_mac_suspend(dev);
+		suspended = true;
+	}
+
+	tmp = b43_phy_read(dev, B43_NPHY_CLASSCTL);
+	tmp &= (B43_NPHY_CLASSCTL_CCKEN | B43_NPHY_CLASSCTL_OFDMEN |
+		B43_NPHY_CLASSCTL_WAITEDEN);
+	tmp &= ~mask;
+	tmp |= (val & mask);
+	b43_phy_maskset(dev, B43_NPHY_CLASSCTL, 0xFFF8, tmp);
+
+	if (suspended)
+		b43_mac_enable(dev);
+
+	return tmp;
+}
+
+static void b43_nphy_stay_carrier_search(struct b43_wldev *dev, bool enable)
+{
+	struct b43_phy *phy = &dev->phy;
+	struct b43_phy_n *nphy = phy->n;
+
+	if (enable) {
+		u16 clip[] = { 0xFFFF, 0xFFFF };
+		if (nphy->deaf_count++ == 0) {
+			nphy->classifier_state = b43_nphy_classifier(dev, 0, 0);
+			b43_nphy_classifier(dev, 0x7, 0);
+			b43_nphy_read_clip_detection(dev, nphy->clip_state);
+			b43_nphy_write_clip_detection(dev, clip);
+		}
+		b43_nphy_reset_cca(dev);
+	} else {
+		if (--nphy->deaf_count != 0) {
+			b43_nphy_classifier(dev, 0x7, nphy->classifier_state);
+			b43_nphy_write_clip_detection(dev, nphy->clip_state);
+		}
+	}
+}
+
  enum b43_nphy_rf_sequence {
  	B43_RFSEQ_RX2TX,
  	B43_RFSEQ_TX2RX,
diff --git a/drivers/net/wireless/b43/phy_n.h b/drivers/net/wireless/b43/phy_n.h
index e5e402a..6ab07fc 100644
--- a/drivers/net/wireless/b43/phy_n.h
+++ b/drivers/net/wireless/b43/phy_n.h
@@ -932,6 +932,9 @@ struct b43_phy_n {
  	u32 deaf_count;
  	bool mute;

+	u16 classifier_state;
+	u16 clip_state[2];
+
  	u8 iqcal_chanspec_2G;
  	u8 rssical_chanspec_2G;

-- 
1.6.4.2

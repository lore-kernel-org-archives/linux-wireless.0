Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f219.google.com ([209.85.219.219]:51436 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932232Ab0AFUxS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Jan 2010 15:53:18 -0500
Received: by ewy19 with SMTP id 19so10051961ewy.21
        for <linux-wireless@vger.kernel.org>; Wed, 06 Jan 2010 12:53:17 -0800 (PST)
Content-Type: text/plain; charset=utf-8; format=flowed; delsp=yes
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>,
	"Michael Buesch" <mb@bu3sch.de>
Cc: bcm43xx-dev@lists.berlios.de
Subject: [PATCH 1/5] b43: N-PHY: implement b43_nphy_stay_in_carrier_search and
 it's calls (V2)
References: <op.u54a5ufy9lhzdc@linux-g0th.site>
 <201001061650.52062.mb@bu3sch.de>
 <b170af451001061211y51b3ca6do11fb24fbb1193c51@mail.gmail.com>
Date: Wed, 06 Jan 2010 21:54:38 +0100
MIME-Version: 1.0
From: =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Message-ID: <op.u54ppc2h9lhzdc@linux-g0th.site>
In-Reply-To: <b170af451001061211y51b3ca6do11fb24fbb1193c51@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

V2: fix typo in deaf_count counting, improve b43_mac_[sr] calls,
     rename function. Thanks Michael!

Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
  drivers/net/wireless/b43/phy_n.c |   58 ++++++++++++++++++++++++++++++++++++++
  drivers/net/wireless/b43/phy_n.h |    3 ++
  2 files changed, 61 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/b43/phy_n.c b/drivers/net/wireless/b43/phy_n.c
index ceb429a..5252c0f 100644
--- a/drivers/net/wireless/b43/phy_n.c
+++ b/drivers/net/wireless/b43/phy_n.c
@@ -348,6 +348,64 @@ static void b43_nphy_reset_cca(struct b43_wldev *dev)
  	b43_phy_write(dev, B43_NPHY_BBCFG, bbcfg & ~B43_NPHY_BBCFG_RSTCCA);
  }

+/* http://bcm-v4.sipsolutions.net/802.11/PHY/N/clip-detection */
+static void b43_nphy_write_clip_detection(struct b43_wldev *dev, u16 *clip_st)
+{
+	b43_phy_write(dev, B43_NPHY_C1_CLIP1THRES, clip_st[0]);
+	b43_phy_write(dev, B43_NPHY_C2_CLIP1THRES, clip_st[1]);
+}
+
+/* http://bcm-v4.sipsolutions.net/802.11/PHY/N/clip-detection */
+static void b43_nphy_read_clip_detection(struct b43_wldev *dev, u16 *clip_st)
+{
+	clip_st[0] = b43_phy_read(dev, B43_NPHY_C1_CLIP1THRES);
+	clip_st[1] = b43_phy_read(dev, B43_NPHY_C2_CLIP1THRES);
+}
+
+/* http://bcm-v4.sipsolutions.net/802.11/PHY/N/classifier */
+static u16 b43_nphy_classifier(struct b43_wldev *dev, u16 mask, u16 val)
+{
+	u16 tmp;
+
+	if (dev->dev->id.revision == 16)
+		b43_mac_suspend(dev);
+
+	tmp = b43_phy_read(dev, B43_NPHY_CLASSCTL);
+	tmp &= (B43_NPHY_CLASSCTL_CCKEN | B43_NPHY_CLASSCTL_OFDMEN |
+		B43_NPHY_CLASSCTL_WAITEDEN);
+	tmp &= ~mask;
+	tmp |= (val & mask);
+	b43_phy_maskset(dev, B43_NPHY_CLASSCTL, 0xFFF8, tmp);
+
+	if (dev->dev->id.revision == 16)
+		b43_mac_enable(dev);
+
+	return tmp;
+}
+
+/* http://bcm-v4.sipsolutions.net/802.11/PHY/N/carriersearch */
+static void b43_nphy_stay_in_carrier_search(struct b43_wldev *dev, bool enable)
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
+		if (--nphy->deaf_count == 0) {
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


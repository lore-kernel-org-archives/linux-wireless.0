Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f178.google.com ([209.85.212.178]:33599 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751734AbaIITSc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Sep 2014 15:18:32 -0400
Received: by mail-wi0-f178.google.com with SMTP id hi2so1780277wib.17
        for <linux-wireless@vger.kernel.org>; Tue, 09 Sep 2014 12:18:31 -0700 (PDT)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Cc: b43-dev@lists.infradead.org,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH 4/4] b43: HT-PHY: Complete radio init (add missing entries)
Date: Tue,  9 Sep 2014 21:17:09 +0200
Message-Id: <1410290229-7033-4-git-send-email-zajec5@gmail.com> (sfid-20140909_211848_110674_D9C78A2C)
In-Reply-To: <1410290229-7033-1-git-send-email-zajec5@gmail.com>
References: <1410290229-7033-1-git-send-email-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
 drivers/net/wireless/b43/phy_ht.c     |  3 +--
 drivers/net/wireless/b43/radio_2059.c | 27 +++++++++++++++++++++++++++
 drivers/net/wireless/b43/radio_2059.h |  2 ++
 3 files changed, 30 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/b43/phy_ht.c b/drivers/net/wireless/b43/phy_ht.c
index d346053..de52d48 100644
--- a/drivers/net/wireless/b43/phy_ht.c
+++ b/drivers/net/wireless/b43/phy_ht.c
@@ -160,8 +160,7 @@ static void b43_radio_2059_init(struct b43_wldev *dev)
 	/* Prepare (reset?) radio */
 	b43_radio_2059_init_pre(dev);
 
-	b43_radio_write(dev, R2059_ALL | 0x51, 0x0070);
-	b43_radio_write(dev, R2059_ALL | 0x5a, 0x0003);
+	r2059_upload_inittabs(dev);
 
 	for (i = 0; i < ARRAY_SIZE(routing); i++)
 		b43_radio_set(dev, routing[i] | 0x146, 0x3);
diff --git a/drivers/net/wireless/b43/radio_2059.c b/drivers/net/wireless/b43/radio_2059.c
index 38e31d8..b2a53b2 100644
--- a/drivers/net/wireless/b43/radio_2059.c
+++ b/drivers/net/wireless/b43/radio_2059.c
@@ -25,6 +25,13 @@
 #include "b43.h"
 #include "radio_2059.h"
 
+/* Extracted from MMIO dump of 6.30.223.141 */
+static u16 r2059_phy_rev1_init[][2] = {
+	{ 0x051, 0x70 }, { 0x05a, 0x03 }, { 0x079, 0x01 }, { 0x082, 0x70 },
+	{ 0x083, 0x00 }, { 0x084, 0x70 }, { 0x09a, 0x7f }, { 0x0b6, 0x10 },
+	{ 0x188, 0x05 },
+};
+
 #define RADIOREGS(r00, r01, r02, r03, r04, r05, r06, r07, r08, r09, \
 		  r10, r11, r12, r13, r14, r15, r16, r17, r18, r19, \
 		  r20) \
@@ -139,6 +146,26 @@ static const struct b43_phy_ht_channeltab_e_radio2059 b43_phy_ht_channeltab_radi
   },
 };
 
+void r2059_upload_inittabs(struct b43_wldev *dev)
+{
+	struct b43_phy *phy = &dev->phy;
+	u16 *table = NULL;
+	u16 size, i;
+
+	switch (phy->rev) {
+	case 1:
+		table = r2059_phy_rev1_init[0];
+		size = ARRAY_SIZE(r2059_phy_rev1_init);
+		break;
+	default:
+		B43_WARN_ON(1);
+		return;
+	}
+
+	for (i = 0; i < size; i++, table += 2)
+		b43_radio_write(dev, R2059_ALL | table[0], table[1]);
+}
+
 const struct b43_phy_ht_channeltab_e_radio2059
 *b43_phy_ht_get_channeltab_e_r2059(struct b43_wldev *dev, u16 freq)
 {
diff --git a/drivers/net/wireless/b43/radio_2059.h b/drivers/net/wireless/b43/radio_2059.h
index 9d828d5..9e22fb6 100644
--- a/drivers/net/wireless/b43/radio_2059.h
+++ b/drivers/net/wireless/b43/radio_2059.h
@@ -52,6 +52,8 @@ struct b43_phy_ht_channeltab_e_radio2059 {
 	struct b43_phy_ht_channeltab_e_phy phy_regs;
 };
 
+void r2059_upload_inittabs(struct b43_wldev *dev);
+
 const struct b43_phy_ht_channeltab_e_radio2059
 *b43_phy_ht_get_channeltab_e_r2059(struct b43_wldev *dev, u16 freq);
 
-- 
1.8.4.5


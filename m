Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:48930 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752562Ab0LUSkc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Dec 2010 13:40:32 -0500
Received: by wwa36 with SMTP id 36so4450786wwa.1
        for <linux-wireless@vger.kernel.org>; Tue, 21 Dec 2010 10:40:31 -0800 (PST)
From: =?utf-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: b43-dev@lists.infradead.org,
	=?utf-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH 1/2] b43: N-PHY: use correct channel tables for rev4+
Date: Tue, 21 Dec 2010 19:40:18 +0100
Message-Id: <1292956819-21166-1-git-send-email-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
 drivers/net/wireless/b43/phy_n.c      |    1 -
 drivers/net/wireless/b43/radio_2056.c |   37 +++++++++++++++++++++++++++++---
 2 files changed, 33 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/b43/phy_n.c b/drivers/net/wireless/b43/phy_n.c
index f6e90a1..dded231 100644
--- a/drivers/net/wireless/b43/phy_n.c
+++ b/drivers/net/wireless/b43/phy_n.c
@@ -3607,7 +3607,6 @@ static int b43_nphy_set_channel(struct b43_wldev *dev,
 	if (dev->phy.rev >= 3) {
 		tabent_r3 = b43_nphy_get_chantabent_rev3(dev,
 							channel->center_freq);
-		tabent_r3 = NULL;
 		if (!tabent_r3)
 			return -ESRCH;
 	} else {
diff --git a/drivers/net/wireless/b43/radio_2056.c b/drivers/net/wireless/b43/radio_2056.c
index 3cb98da..8890df0 100644
--- a/drivers/net/wireless/b43/radio_2056.c
+++ b/drivers/net/wireless/b43/radio_2056.c
@@ -9053,15 +9053,44 @@ void b2056_upload_inittabs(struct b43_wldev *dev,
 				B2056_RX1, pts->rx, pts->rx_length);
 }
 
-/* TODO: add support for rev4+ devices by searching in rev4+ tables */
 const struct b43_nphy_channeltab_entry_rev3 *
 b43_nphy_get_chantabent_rev3(struct b43_wldev *dev, u16 freq)
 {
 	const struct b43_nphy_channeltab_entry_rev3 *e;
-	unsigned int i;
+	unsigned int length, i;
 
-	for (i = 0; i < ARRAY_SIZE(b43_nphy_channeltab_rev3); i++) {
-		e = &(b43_nphy_channeltab_rev3[i]);
+	switch (dev->phy.rev) {
+	case 3:
+		e = b43_nphy_channeltab_rev3;
+		length = ARRAY_SIZE(b43_nphy_channeltab_rev3);
+		break;
+	case 4:
+		e = b43_nphy_channeltab_rev4;
+		length = ARRAY_SIZE(b43_nphy_channeltab_rev4);
+		break;
+	case 5:
+		e = b43_nphy_channeltab_rev5;
+		length = ARRAY_SIZE(b43_nphy_channeltab_rev5);
+		break;
+	case 6:
+		e = b43_nphy_channeltab_rev6;
+		length = ARRAY_SIZE(b43_nphy_channeltab_rev6);
+		break;
+	case 7:
+	case 9:
+		e = b43_nphy_channeltab_rev7_9;
+		length = ARRAY_SIZE(b43_nphy_channeltab_rev7_9);
+		break;
+	case 8:
+		e = b43_nphy_channeltab_rev8;
+		length = ARRAY_SIZE(b43_nphy_channeltab_rev8);
+		break;
+	default:
+		B43_WARN_ON(1);
+		return NULL;
+	}
+
+	for (i = 0; i < length; i++, e++) {
 		if (e->freq == freq)
 			return e;
 	}
-- 
1.6.3.3


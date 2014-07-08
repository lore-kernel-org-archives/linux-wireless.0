Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f48.google.com ([74.125.82.48]:42908 "EHLO
	mail-wg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753747AbaGHTAj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Jul 2014 15:00:39 -0400
Received: by mail-wg0-f48.google.com with SMTP id x12so1485529wgg.19
        for <linux-wireless@vger.kernel.org>; Tue, 08 Jul 2014 12:00:38 -0700 (PDT)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: b43-dev@lists.infradead.org,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH][3.16 MAYBE?] b43: don't warn about no 5 GHz support on 2.4 GHz devices
Date: Tue,  8 Jul 2014 21:00:19 +0200
Message-Id: <1404846019-11079-1-git-send-email-zajec5@gmail.com> (sfid-20140708_210042_950709_DCBEE798)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This could be a bit confusing to see warning about lacking support for
5 GHz band if your device supports 2.4 GHz only.

Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
John: even I was quite confused to see this warning on my BCM5357. I
suspected b43 incorrectly detected my WiFi as 5 GHz capable. I think
that proposed behavior makes more sense.
Do you think it's OK/worth to take it for 3.16?
---
 drivers/net/wireless/b43/main.c | 18 ++++++++++--------
 1 file changed, 10 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/b43/main.c b/drivers/net/wireless/b43/main.c
index 8aeef10..27dc343 100644
--- a/drivers/net/wireless/b43/main.c
+++ b/drivers/net/wireless/b43/main.c
@@ -5268,14 +5268,16 @@ static int b43_wireless_core_attach(struct b43_wldev *dev)
 	b43_supported_bands(dev, &have_2ghz_phy, &have_5ghz_phy);
 
 	/* We don't support 5 GHz on some PHYs yet */
-	switch (dev->phy.type) {
-	case B43_PHYTYPE_A:
-	case B43_PHYTYPE_G:
-	case B43_PHYTYPE_N:
-	case B43_PHYTYPE_LP:
-	case B43_PHYTYPE_HT:
-		b43warn(wl, "5 GHz band is unsupported on this PHY\n");
-		have_5ghz_phy = false;
+	if (have_5ghz_phy) {
+		switch (dev->phy.type) {
+		case B43_PHYTYPE_A:
+		case B43_PHYTYPE_G:
+		case B43_PHYTYPE_N:
+		case B43_PHYTYPE_LP:
+		case B43_PHYTYPE_HT:
+			b43warn(wl, "5 GHz band is unsupported on this PHY\n");
+			have_5ghz_phy = false;
+		}
 	}
 
 	if (!have_2ghz_phy && !have_5ghz_phy) {
-- 
1.8.4.5


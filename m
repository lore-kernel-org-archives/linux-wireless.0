Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f42.google.com ([209.85.215.42]:43495 "EHLO
	mail-ew0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750939Ab1IUTMH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 Sep 2011 15:12:07 -0400
Received: by ewy1 with SMTP id 1so2047977ewy.1
        for <linux-wireless@vger.kernel.org>; Wed, 21 Sep 2011 12:12:05 -0700 (PDT)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: b43-dev@lists.infradead.org,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH 2/3] b43: update dummy transmission
Date: Wed, 21 Sep 2011 21:44:14 +0200
Message-Id: <1316634255-3116-2-git-send-email-zajec5@gmail.com> (sfid-20110921_211211_933042_E6FA8F94)
In-Reply-To: <1316634255-3116-1-git-send-email-zajec5@gmail.com>
References: <1316634255-3116-1-git-send-email-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
 drivers/net/wireless/b43/main.c |   11 +++++++----
 1 files changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/b43/main.c b/drivers/net/wireless/b43/main.c
index 9437c9a..9adc43d 100644
--- a/drivers/net/wireless/b43/main.c
+++ b/drivers/net/wireless/b43/main.c
@@ -738,7 +738,8 @@ void b43_dummy_transmission(struct b43_wldev *dev, bool ofdm, bool pa_on)
 
 	value = (ofdm ? 0x41 : 0x40);
 	b43_write16(dev, B43_MMIO_TXE0_PHYCTL, value);
-	if ((phy->type == B43_PHYTYPE_N) || (phy->type == B43_PHYTYPE_LP))
+	if (phy->type == B43_PHYTYPE_N || phy->type == B43_PHYTYPE_LP ||
+	    phy->type == B43_PHYTYPE_LCN)
 		b43_write16(dev, B43_MMIO_TXE0_PHYCTL1, 0x1A02);
 
 	b43_write16(dev, B43_MMIO_TXE0_WM_0, 0x0000);
@@ -748,12 +749,13 @@ void b43_dummy_transmission(struct b43_wldev *dev, bool ofdm, bool pa_on)
 	b43_write16(dev, B43_MMIO_XMTTXCNT, 0x0014);
 	b43_write16(dev, B43_MMIO_XMTSEL, 0x0826);
 	b43_write16(dev, B43_MMIO_TXE0_CTL, 0x0000);
-	if (!pa_on && (phy->type == B43_PHYTYPE_N)) {
-		//SPEC TODO
-	}
+
+	if (!pa_on && phy->type == B43_PHYTYPE_N)
+		; /*b43_nphy_pa_override(dev, false) */
 
 	switch (phy->type) {
 	case B43_PHYTYPE_N:
+	case B43_PHYTYPE_LCN:
 		b43_write16(dev, B43_MMIO_TXE0_AUX, 0x00D0);
 		break;
 	case B43_PHYTYPE_LP:
@@ -762,6 +764,7 @@ void b43_dummy_transmission(struct b43_wldev *dev, bool ofdm, bool pa_on)
 	default:
 		b43_write16(dev, B43_MMIO_TXE0_AUX, 0x0030);
 	}
+	b43_read16(dev, B43_MMIO_TXE0_AUX);
 
 	if (phy->radio_ver == 0x2050 && phy->radio_rev <= 0x5)
 		b43_radio_write16(dev, 0x0051, 0x0017);
-- 
1.7.3.4


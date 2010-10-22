Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f46.google.com ([209.85.215.46]:55658 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932096Ab0JVPn6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Oct 2010 11:43:58 -0400
Received: by mail-ew0-f46.google.com with SMTP id 7so1270430ewy.19
        for <linux-wireless@vger.kernel.org>; Fri, 22 Oct 2010 08:43:58 -0700 (PDT)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: b43-dev@lists.infradead.org,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH 5/5] b43: N-PHY: improve 2055 radio initialization
Date: Fri, 22 Oct 2010 17:43:49 +0200
Message-Id: <1287762229-16516-6-git-send-email-zajec5@gmail.com>
In-Reply-To: <1287762229-16516-2-git-send-email-zajec5@gmail.com>
References: <1287762229-16516-2-git-send-email-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

1) Upload 5 GHz values when needed.
2) Do not upload all values on first init. Follow wl.

Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
 drivers/net/wireless/b43/phy_n.c |   11 +++++++----
 1 files changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/b43/phy_n.c b/drivers/net/wireless/b43/phy_n.c
index c22dbfb..6facb8a 100644
--- a/drivers/net/wireless/b43/phy_n.c
+++ b/drivers/net/wireless/b43/phy_n.c
@@ -241,10 +241,13 @@ static void b43_radio_init2055_post(struct b43_wldev *dev)
 static void b43_radio_init2055(struct b43_wldev *dev)
 {
 	b43_radio_init2055_pre(dev);
-	if (b43_status(dev) < B43_STAT_INITIALIZED)
-		b2055_upload_inittab(dev, 0, 1);
-	else
-		b2055_upload_inittab(dev, 0/*FIXME on 5ghz band*/, 0);
+	if (b43_status(dev) < B43_STAT_INITIALIZED) {
+		/* Follow wl, not specs. Do not force uploading all regs */
+		b2055_upload_inittab(dev, 0, 0);
+	} else {
+		bool ghz5 = b43_current_band(dev->wl) == IEEE80211_BAND_5GHZ;
+		b2055_upload_inittab(dev, ghz5, 0);
+	}
 	b43_radio_init2055_post(dev);
 }
 
-- 
1.7.1


Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f170.google.com ([209.85.212.170]:51101 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761229AbaGSKxW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 19 Jul 2014 06:53:22 -0400
Received: by mail-wi0-f170.google.com with SMTP id f8so2157741wiw.1
        for <linux-wireless@vger.kernel.org>; Sat, 19 Jul 2014 03:53:20 -0700 (PDT)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: b43-dev@lists.infradead.org,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH 7/7] b43: enable radio 0x2057 rev 14 support (AKA BCM43217)
Date: Sat, 19 Jul 2014 12:52:47 +0200
Message-Id: <1405767167-30315-7-git-send-email-zajec5@gmail.com> (sfid-20140719_125324_743769_3F0165AF)
In-Reply-To: <1405767167-30315-1-git-send-email-zajec5@gmail.com>
References: <1405767167-30315-1-git-send-email-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
 drivers/net/wireless/b43/main.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/b43/main.c b/drivers/net/wireless/b43/main.c
index 3e127be..73f629c 100644
--- a/drivers/net/wireless/b43/main.c
+++ b/drivers/net/wireless/b43/main.c
@@ -4512,7 +4512,8 @@ static int b43_phy_versioning(struct b43_wldev *dev)
 		if (radio_ver != 0x2055 && radio_ver != 0x2056 &&
 		    radio_ver != 0x2057)
 			unsupported = 1;
-		if (radio_ver == 0x2057 && !(radio_rev == 9))
+		if (radio_ver == 0x2057 &&
+		    !(radio_rev == 9 || radio_rev == 14))
 			unsupported = 1;
 		break;
 	case B43_PHYTYPE_LP:
@@ -5152,7 +5153,8 @@ static int b43_setup_bands(struct b43_wldev *dev,
 	bool limited_2g;
 
 	/* We don't support all 2 GHz channels on some devices */
-	limited_2g = phy->radio_ver == 0x2057 && phy->radio_rev == 9;
+	limited_2g = phy->radio_ver == 0x2057 &&
+		     (phy->radio_rev == 9 || phy->radio_rev == 14);
 
 	if (have_2ghz_phy)
 		hw->wiphy->bands[IEEE80211_BAND_2GHZ] = limited_2g ?
-- 
1.8.4.5


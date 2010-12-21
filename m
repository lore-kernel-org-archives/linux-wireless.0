Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:37728 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752971Ab0LUU3w (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Dec 2010 15:29:52 -0500
Received: by wyb28 with SMTP id 28so4349016wyb.19
        for <linux-wireless@vger.kernel.org>; Tue, 21 Dec 2010 12:29:51 -0800 (PST)
From: =?utf-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: b43-dev@lists.infradead.org,
	=?utf-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH] b43: N-PHY: enable support for PHYs rev 3 and higher
Date: Tue, 21 Dec 2010 21:29:44 +0100
Message-Id: <1292963384-23684-1-git-send-email-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
John: can we still make it for 2.6.38 merge? It was tested with 14e4:432b,
support seems to be on the same level as for PHYs 1 and 2.
---
 drivers/net/wireless/b43/main.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/b43/main.c b/drivers/net/wireless/b43/main.c
index 5fb0bc6..22bc9f1 100644
--- a/drivers/net/wireless/b43/main.c
+++ b/drivers/net/wireless/b43/main.c
@@ -4056,7 +4056,7 @@ static int b43_phy_versioning(struct b43_wldev *dev)
 		break;
 #ifdef CONFIG_B43_PHY_N
 	case B43_PHYTYPE_N:
-		if (phy_rev > 2)
+		if (phy_rev > 9)
 			unsupported = 1;
 		break;
 #endif
-- 
1.6.3.3


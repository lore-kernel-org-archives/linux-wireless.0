Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:62872 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751676Ab1BUSjV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Feb 2011 13:39:21 -0500
Received: by wwa36 with SMTP id 36so6398108wwa.1
        for <linux-wireless@vger.kernel.org>; Mon, 21 Feb 2011 10:39:20 -0800 (PST)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: b43-dev@lists.infradead.org,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH] b43: N-PHY: fix 0x2055 radio workaround condition
Date: Mon, 21 Feb 2011 19:38:58 +0100
Message-Id: <1298313538-3904-1-git-send-email-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
 drivers/net/wireless/b43/phy_n.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/b43/phy_n.c b/drivers/net/wireless/b43/phy_n.c
index 2186afc..9f5a3c9 100644
--- a/drivers/net/wireless/b43/phy_n.c
+++ b/drivers/net/wireless/b43/phy_n.c
@@ -430,9 +430,9 @@ static void b43_radio_init2055_post(struct b43_wldev *dev)
 	bool workaround = false;
 
 	if (sprom->revision < 4)
-		workaround = (binfo->vendor != PCI_VENDOR_ID_BROADCOM ||
-				binfo->type != 0x46D ||
-				binfo->rev < 0x41);
+		workaround = (binfo->vendor != PCI_VENDOR_ID_BROADCOM &&
+				binfo->type == 0x46D &&
+				binfo->rev >= 0x41);
 	else
 		workaround =
 			!(sprom->boardflags2_lo & B43_BFL2_RXBB_INT_REG_DIS);
-- 
1.7.1


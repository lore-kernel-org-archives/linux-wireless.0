Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f46.google.com ([209.85.215.46]:55658 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932087Ab0JVPny (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Oct 2010 11:43:54 -0400
Received: by mail-ew0-f46.google.com with SMTP id 7so1270430ewy.19
        for <linux-wireless@vger.kernel.org>; Fri, 22 Oct 2010 08:43:53 -0700 (PDT)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: b43-dev@lists.infradead.org,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH 4/5] b43: N-PHY: determine usage of radio regulatory workaround correctly
Date: Fri, 22 Oct 2010 17:43:48 +0200
Message-Id: <1287762229-16516-5-git-send-email-zajec5@gmail.com>
In-Reply-To: <1287762229-16516-2-git-send-email-zajec5@gmail.com>
References: <1287762229-16516-2-git-send-email-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
 drivers/net/wireless/b43/phy_n.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/b43/phy_n.c b/drivers/net/wireless/b43/phy_n.c
index e0f2d12..c22dbfb 100644
--- a/drivers/net/wireless/b43/phy_n.c
+++ b/drivers/net/wireless/b43/phy_n.c
@@ -191,7 +191,8 @@ static void b43_radio_init2055_post(struct b43_wldev *dev)
 				binfo->type != 0x46D ||
 				binfo->rev < 0x41);
 	else
-		workaround = ((sprom->boardflags_hi & B43_BFH_NOPA) == 0);
+		workaround =
+			!(sprom->boardflags2_lo & B43_BFL2_RXBB_INT_REG_DIS);
 
 	b43_radio_mask(dev, B2055_MASTER1, 0xFFF3);
 	if (workaround) {
-- 
1.7.1


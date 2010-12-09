Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:41870 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753920Ab0LIT4N (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Dec 2010 14:56:13 -0500
Received: by wyb28 with SMTP id 28so2643172wyb.19
        for <linux-wireless@vger.kernel.org>; Thu, 09 Dec 2010 11:56:11 -0800 (PST)
From: =?utf-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: b43-dev@lists.infradead.org,
	=?utf-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH 1/4] b43: N-PHY: use correct bit for controlling MAC and PHY
Date: Thu,  9 Dec 2010 20:55:58 +0100
Message-Id: <1291924561-21630-1-git-send-email-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
 drivers/net/wireless/b43/phy_n.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/b43/phy_n.c b/drivers/net/wireless/b43/phy_n.c
index 61875c8..e12f399 100644
--- a/drivers/net/wireless/b43/phy_n.c
+++ b/drivers/net/wireless/b43/phy_n.c
@@ -3278,9 +3278,9 @@ static void b43_nphy_mac_phy_clock_set(struct b43_wldev *dev, bool on)
 {
 	u32 tmslow = ssb_read32(dev->dev, SSB_TMSLOW);
 	if (on)
-		tmslow |= SSB_TMSLOW_PHYCLK;
+		tmslow |= B43_TMSLOW_MACPHYCLKEN;
 	else
-		tmslow &= ~SSB_TMSLOW_PHYCLK;
+		tmslow &= ~B43_TMSLOW_MACPHYCLKEN;
 	ssb_write32(dev->dev, SSB_TMSLOW, tmslow);
 }
 
-- 
1.6.3.3


Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:49490 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753206Ab0GUUpN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 Jul 2010 16:45:13 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH] rtl8180: silence "dubious: x | !y" sparse warning
Date: Wed, 21 Jul 2010 16:38:25 -0400
Message-Id: <1279744705-32389-1-git-send-email-linville@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

  CHECK   drivers/net/wireless/rtl818x/rtl8180_rtl8225.c
drivers/net/wireless/rtl818x/rtl8180_rtl8225.c:53:33: warning: dubious: x | !y

The existing code is clever and works fine, but it's not worth even a
single line of Sparse warning SPAM...

Signed-off-by: John W. Linville <linville@tuxdriver.com>
---
 drivers/net/wireless/rtl818x/rtl8180_rtl8225.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/rtl818x/rtl8180_rtl8225.c b/drivers/net/wireless/rtl818x/rtl8180_rtl8225.c
index 4d2be0d..69e4d47 100644
--- a/drivers/net/wireless/rtl818x/rtl8180_rtl8225.c
+++ b/drivers/net/wireless/rtl818x/rtl8180_rtl8225.c
@@ -50,7 +50,10 @@ static void rtl8225_write(struct ieee80211_hw *dev, u8 addr, u16 data)
 	udelay(10);
 
 	for (i = 15; i >= 0; i--) {
-		u16 reg = reg80 | !!(bangdata & (1 << i));
+		u16 reg = reg80;
+
+		if (bangdata & (1 << i))
+			reg |= 1;
 
 		if (i & 1)
 			rtl818x_iowrite16(priv, &priv->map->RFPinsOutput, reg);
-- 
1.7.1.1


Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f46.google.com ([209.85.215.46]:37717 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752062Ab0HVTxh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 22 Aug 2010 15:53:37 -0400
Received: by ewy23 with SMTP id 23so2946836ewy.19
        for <linux-wireless@vger.kernel.org>; Sun, 22 Aug 2010 12:53:36 -0700 (PDT)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: b43-dev@lists.infradead.org,
	=?UTF-8?q?G=C3=A1bor=20Stefanik?= <netrolller.3d@gmail.com>,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH] b43: N-PHY: check for clk when setting RX core state
Date: Sun, 22 Aug 2010 21:54:32 +0200
Message-Id: <1282506872-8537-1-git-send-email-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
Very trivial one, it should be included in previous two-patches-set.
---
 drivers/net/wireless/b43/phy_n.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/b43/phy_n.c b/drivers/net/wireless/b43/phy_n.c
index ac217da..ac7f02d 100644
--- a/drivers/net/wireless/b43/phy_n.c
+++ b/drivers/net/wireless/b43/phy_n.c
@@ -3094,7 +3094,7 @@ static void b43_nphy_set_rx_core_state(struct b43_wldev *dev, u8 mask)
 
 	nphy->phyrxchain = mask;
 
-	if (0 /* FIXME clk */)
+	if (!phy->clk)
 		return;
 
 	b43_mac_suspend(dev);
-- 
1.7.1


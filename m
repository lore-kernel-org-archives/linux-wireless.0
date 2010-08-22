Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:44215 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752203Ab0HVTrB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 22 Aug 2010 15:47:01 -0400
Received: by eyg5 with SMTP id 5so2942779eyg.19
        for <linux-wireless@vger.kernel.org>; Sun, 22 Aug 2010 12:47:00 -0700 (PDT)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: b43-dev@lists.infradead.org,
	=?UTF-8?q?G=C3=A1bor=20Stefanik?= <netrolller.3d@gmail.com>,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH] b43: N-PHY: add missing phyrxchain setting and fix warning in RX core function
Date: Sun, 22 Aug 2010 21:47:32 +0200
Message-Id: <1282506452-8159-1-git-send-email-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
Gábor: please kindly, watch out for such a missing calls/sets. We may lose a
lot of time looking for such a missing lines later.
---
 drivers/net/wireless/b43/phy_n.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/b43/phy_n.c b/drivers/net/wireless/b43/phy_n.c
index d116229..2466c0a 100644
--- a/drivers/net/wireless/b43/phy_n.c
+++ b/drivers/net/wireless/b43/phy_n.c
@@ -3092,6 +3092,8 @@ static void b43_nphy_set_rx_core_state(struct b43_wldev *dev, u8 mask)
 	struct b43_phy_n *nphy = phy->n;
 	u16 buf[16];
 
+	nphy->phyrxchain = mask;
+
 	if (0 /* FIXME clk */)
 		return;
 
@@ -3103,7 +3105,7 @@ static void b43_nphy_set_rx_core_state(struct b43_wldev *dev, u8 mask)
 	b43_phy_maskset(dev, B43_NPHY_RFSEQCA, ~B43_NPHY_RFSEQCA_RXEN,
 			(mask & 0x3) << B43_NPHY_RFSEQCA_RXEN_SHIFT);
 
-	if (mask & 0x3 != 0x3) {
+	if ((mask & 0x3) != 0x3) {
 		b43_phy_write(dev, B43_NPHY_HPANT_SWTHRES, 1);
 		if (dev->phy.rev >= 3) {
 			/* TODO */
-- 
1.7.1


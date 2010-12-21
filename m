Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:36145 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751944Ab0LUKuv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Dec 2010 05:50:51 -0500
Received: by mail-wy0-f174.google.com with SMTP id 28so3808933wyb.19
        for <linux-wireless@vger.kernel.org>; Tue, 21 Dec 2010 02:50:51 -0800 (PST)
From: =?utf-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: b43-dev@lists.infradead.org,
	=?utf-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH 4/4] b43: N-PHY: avoid PHY hangs for rev 3 and 4
Date: Tue, 21 Dec 2010 11:50:22 +0100
Message-Id: <1292928622-27651-4-git-send-email-zajec5@gmail.com>
In-Reply-To: <1292928622-27651-1-git-send-email-zajec5@gmail.com>
References: <1292928622-27651-1-git-send-email-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
 drivers/net/wireless/b43/phy_n.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/b43/phy_n.c b/drivers/net/wireless/b43/phy_n.c
index f0b264c..63d8db3 100644
--- a/drivers/net/wireless/b43/phy_n.c
+++ b/drivers/net/wireless/b43/phy_n.c
@@ -3667,6 +3667,7 @@ static void b43_nphy_op_prepare_structs(struct b43_wldev *dev)
 
 	memset(nphy, 0, sizeof(*nphy));
 
+	nphy->hang_avoid = (phy->rev == 3 || phy->rev == 4);
 	nphy->gain_boost = true; /* this way we follow wl, assume it is true */
 	nphy->txrx_chain = 2; /* sth different than 0 and 1 for now */
 	nphy->phyrxchain = 3; /* to avoid b43_nphy_set_rx_core_state like wl */
-- 
1.6.3.3


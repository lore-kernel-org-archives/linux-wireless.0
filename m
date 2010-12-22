Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:48511 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751791Ab0LVTPI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Dec 2010 14:15:08 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: linux-wireless@vger.kernel.org
Cc: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>,
	"John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 3/3] b43: N-PHY: check for clk when setting RX core state
Date: Wed, 22 Dec 2010 14:11:32 -0500
Message-Id: <1293045092-12483-4-git-send-email-linville@tuxdriver.com>
In-Reply-To: <1293045092-12483-1-git-send-email-linville@tuxdriver.com>
References: <1293045092-12483-1-git-send-email-linville@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Rafał Miłecki <zajec5@gmail.com>

Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
---
 drivers/net/wireless/b43/phy_n.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/b43/phy_n.c b/drivers/net/wireless/b43/phy_n.c
index 3f2ce92..d50e880 100644
--- a/drivers/net/wireless/b43/phy_n.c
+++ b/drivers/net/wireless/b43/phy_n.c
@@ -3282,7 +3282,7 @@ static void b43_nphy_set_rx_core_state(struct b43_wldev *dev, u8 mask)
 
 	nphy->phyrxchain = mask;
 
-	if (0 /* FIXME clk */)
+	if (!phy->clk)
 		return;
 
 	b43_mac_suspend(dev);
-- 
1.7.3.3


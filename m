Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from gateway34.websitewelcome.com ([192.185.149.222]:27266 "EHLO
        gateway34.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751180AbeC3VfR (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 30 Mar 2018 17:35:17 -0400
Received: from cm12.websitewelcome.com (cm12.websitewelcome.com [100.42.49.8])
        by gateway34.websitewelcome.com (Postfix) with ESMTP id 361C27C1106
        for <linux-wireless@vger.kernel.org>; Fri, 30 Mar 2018 16:12:25 -0500 (CDT)
Date: Fri, 30 Mar 2018 16:12:23 -0500
From: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
To: Jakub Kicinski <kubakici@wp.pl>, Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Subject: [PATCH] mt7601u: phy: mark expected switch fall-through
Message-ID: <20180330211223.GA22497@embeddedgus> (sfid-20180330_233521_600431_938B86B3)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In preparation to enabling -Wimplicit-fallthrough, mark switch cases
where we are expecting to fall through.

Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
---
 drivers/net/wireless/mediatek/mt7601u/phy.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/mediatek/mt7601u/phy.c b/drivers/net/wireless/mediatek/mt7601u/phy.c
index ca09a5d..9a90f1f 100644
--- a/drivers/net/wireless/mediatek/mt7601u/phy.c
+++ b/drivers/net/wireless/mediatek/mt7601u/phy.c
@@ -795,6 +795,7 @@ mt7601u_phy_rf_pa_mode_val(struct mt7601u_dev *dev, int phy_mode, int tx_rate)
 	switch (phy_mode) {
 	case MT_PHY_TYPE_OFDM:
 		tx_rate += 4;
+		/* fall through */
 	case MT_PHY_TYPE_CCK:
 		reg = dev->rf_pa_mode[0];
 		break;
-- 
2.7.4

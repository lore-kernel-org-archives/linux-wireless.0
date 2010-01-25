Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f219.google.com ([209.85.219.219]:34521 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754589Ab0AYSAO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Jan 2010 13:00:14 -0500
Received: by mail-ew0-f219.google.com with SMTP id 19so12782ewy.21
        for <linux-wireless@vger.kernel.org>; Mon, 25 Jan 2010 10:00:13 -0800 (PST)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: bcm43xx-dev@lists.berlios.de,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH 1/4] b43: N-PHY: fix one bit off in parsing RF Ctrl Override arguments
Date: Mon, 25 Jan 2010 18:59:58 +0100
Message-Id: <1264442401-6364-2-git-send-email-zajec5@gmail.com>
In-Reply-To: <1264442401-6364-1-git-send-email-zajec5@gmail.com>
References: <1264442401-6364-1-git-send-email-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
 drivers/net/wireless/b43/phy_n.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/b43/phy_n.c b/drivers/net/wireless/b43/phy_n.c
index a45a1f3..061b01b 100644
--- a/drivers/net/wireless/b43/phy_n.c
+++ b/drivers/net/wireless/b43/phy_n.c
@@ -1031,7 +1031,7 @@ static void b43_nphy_rf_control_override(struct b43_wldev *dev, u16 field,
 	u8 index = fls(field);
 	u8 addr, en_addr, val_addr;
 	/* we expect only one bit set */
-	B43_WARN_ON(field & (~(1 << index)));
+	B43_WARN_ON(field & (~(1 << (index - 1))));
 
 	if (dev->phy.rev >= 3) {
 		const struct nphy_rf_control_override_rev3 *rf_ctrl;
-- 
1.6.4.2


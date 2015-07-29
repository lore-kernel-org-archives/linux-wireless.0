Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hauke-m.de ([5.39.93.123]:36865 "EHLO hauke-m.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753090AbbG2Vgn (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Jul 2015 17:36:43 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: kvalo@qca.qualcomm.com
Cc: zajec5@gmail.com, linux-wireless@vger.kernel.org,
	b43-dev@lists.infradead.org, Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH] b43: fix extpa_gain check for 2GHz
Date: Wed, 29 Jul 2015 23:36:30 +0200
Message-Id: <1438205790-17629-1-git-send-email-hauke@hauke-m.de> (sfid-20150729_233647_031809_186F034D)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On the 2GHz and and on the 5GHZ band only the extpa_gain setting from
the 5GHz band was checked. this patch makes it check the property from
the correct band.

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 drivers/net/wireless/b43/tables_nphy.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/b43/tables_nphy.c b/drivers/net/wireless/b43/tables_nphy.c
index 25d1cbd..b2f0d24 100644
--- a/drivers/net/wireless/b43/tables_nphy.c
+++ b/drivers/net/wireless/b43/tables_nphy.c
@@ -3728,7 +3728,7 @@ const u32 *b43_nphy_get_tx_gain_table(struct b43_wldev *dev)
 		switch (phy->rev) {
 		case 6:
 		case 5:
-			if (sprom->fem.ghz5.extpa_gain == 3)
+			if (sprom->fem.ghz2.extpa_gain == 3)
 				return b43_ntab_tx_gain_epa_rev3_hi_pwr_2g;
 			/* fall through */
 		case 4:
-- 
2.1.4


Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:48875 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752324Ab1LUXGM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 Dec 2011 18:06:12 -0500
Received: by eekc4 with SMTP id c4so7959799eek.19
        for <linux-wireless@vger.kernel.org>; Wed, 21 Dec 2011 15:06:11 -0800 (PST)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: b43-dev@lists.infradead.org,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH 3/4] b43: N-PHY: fix controling RF override
Date: Thu, 22 Dec 2011 00:47:18 +0100
Message-Id: <1324511239-3536-3-git-send-email-zajec5@gmail.com> (sfid-20111222_000616_459088_770AC9A0)
In-Reply-To: <1324511239-3536-1-git-send-email-zajec5@gmail.com>
References: <1324511239-3536-1-git-send-email-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
 drivers/net/wireless/b43/phy_n.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/b43/phy_n.c b/drivers/net/wireless/b43/phy_n.c
index 38cf37d..b8525cc 100644
--- a/drivers/net/wireless/b43/phy_n.c
+++ b/drivers/net/wireless/b43/phy_n.c
@@ -167,7 +167,7 @@ static void b43_nphy_rf_control_override(struct b43_wldev *dev, u16 field,
 				b43_phy_mask(dev, val_addr,
 						~(rf_ctrl->val_mask));
 			} else {
-				if (core == 0 || ((1 << core) & i) != 0) {
+				if (core == 0 || ((1 << i) & core)) {
 					b43_phy_set(dev, en_addr, field);
 					b43_phy_maskset(dev, val_addr,
 						~(rf_ctrl->val_mask),
@@ -200,7 +200,7 @@ static void b43_nphy_rf_control_override(struct b43_wldev *dev, u16 field,
 			addr = B43_PHY_N((i == 0) ?
 				rf_ctrl->addr0 : rf_ctrl->addr1);
 
-			if ((core & (1 << i)) != 0)
+			if ((1 << i) & core)
 				b43_phy_maskset(dev, addr, ~(rf_ctrl->bmask),
 						(value << rf_ctrl->shift));
 
-- 
1.7.3.4


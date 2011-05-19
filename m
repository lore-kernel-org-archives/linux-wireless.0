Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f46.google.com ([209.85.215.46]:49508 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932238Ab1ESXEp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 19 May 2011 19:04:45 -0400
Received: by ewy4 with SMTP id 4so1014626ewy.19
        for <linux-wireless@vger.kernel.org>; Thu, 19 May 2011 16:04:43 -0700 (PDT)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: b43-dev@lists.infradead.org,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH] b43: N-PHY: initialize last var in calibration function
Date: Fri, 20 May 2011 01:04:46 +0200
Message-Id: <1305846286-1505-1-git-send-email-zajec5@gmail.com> (sfid-20110520_010448_702305_F21138D2)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Reported-by: Larry Finger <larry.finger@lwfinger.net>
Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
 drivers/net/wireless/b43/phy_n.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/b43/phy_n.c b/drivers/net/wireless/b43/phy_n.c
index 9ed6515..05960dd 100644
--- a/drivers/net/wireless/b43/phy_n.c
+++ b/drivers/net/wireless/b43/phy_n.c
@@ -3093,7 +3093,7 @@ static int b43_nphy_cal_tx_iq_lo(struct b43_wldev *dev,
 	int freq;
 	bool avoid = false;
 	u8 length;
-	u16 tmp, core, type, count, max, numb, last, cmd;
+	u16 tmp, core, type, count, max, numb, last = 0, cmd;
 	const u16 *table;
 	bool phy6or5x;
 
-- 
1.7.1


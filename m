Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f228.google.com ([209.85.220.228]:41669 "EHLO
	mail-fx0-f228.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754165AbZHJWy2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Aug 2009 18:54:28 -0400
Received: by fxm28 with SMTP id 28so1213943fxm.17
        for <linux-wireless@vger.kernel.org>; Mon, 10 Aug 2009 15:54:28 -0700 (PDT)
Message-ID: <4A80A522.2020200@gmail.com>
Date: Tue, 11 Aug 2009 00:54:26 +0200
From: =?UTF-8?B?R8OhYm9yIFN0ZWZhbmlr?= <netrolller.3d@gmail.com>
MIME-Version: 1.0
To: John Linville <linville@tuxdriver.com>,
	Michael Buesch <mb@bu3sch.de>
CC: Larry Finger <Larry.Finger@lwfinger.net>,
	Broadcom Wireless <bcm43xx-dev@lists.berlios.de>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: [PATCH] b43: Fix a typo in the sync_stx routine
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I completely missed the "one's complement" instruction from the specs.

Signed-off-by: Gábor Stefanik <netrolller.3d@gmail.com>
---
 drivers/net/wireless/b43/phy_lp.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/b43/phy_lp.c b/drivers/net/wireless/b43/phy_lp.c
index 46fe476..34ad738 100644
--- a/drivers/net/wireless/b43/phy_lp.c
+++ b/drivers/net/wireless/b43/phy_lp.c
@@ -578,7 +578,7 @@ static void lpphy_sync_stx(struct b43_wldev *dev)
 		tmp >>= e->rf_shift;
 		tmp <<= e->phy_shift;
 		b43_phy_maskset(dev, B43_PHY_OFDM(0xF2 + e->phy_offset),
-				e->mask << e->phy_shift, tmp);
+				~(e->mask << e->phy_shift), tmp);
 	}
 }
 
-- 
1.6.2.4



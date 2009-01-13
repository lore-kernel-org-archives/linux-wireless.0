Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 128-177-27-249.ip.openhosting.com ([128.177.27.249]:52385 "EHLO
	jmalinen.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754573AbZAMMdy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Jan 2009 07:33:54 -0500
Date: Tue, 13 Jan 2009 14:33:49 +0200
From: Jouni Malinen <jouni.malinen@atheros.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH] ath9k: Fix an operator typo in phy rate validation
Message-ID: <20090113123349.GB14346@jm.kir.nu> (sfid-20090113_133403_982707_ED08BF05)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This was not supposed to be a bitwise AND operation, but a check of
two separate conditions. Anyway, the old code happened to result in
the same behavior, so this is just changing the code to be easier to
understand and also to keep sparse from warning about dubious
operators.

Signed-off-by: Jouni Malinen <jouni.malinen@atheros.com>

---
 drivers/net/wireless/ath9k/rc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- wireless-testing.orig/drivers/net/wireless/ath9k/rc.c	2009-01-13 14:11:26.000000000 +0200
+++ wireless-testing/drivers/net/wireless/ath9k/rc.c	2009-01-13 14:11:37.000000000 +0200
@@ -490,7 +490,7 @@ static inline int ath_rc_get_nextvalid_t
 
 static int ath_rc_valid_phyrate(u32 phy, u32 capflag, int ignore_cw)
 {
-	if (WLAN_RC_PHY_HT(phy) & !(capflag & WLAN_RC_HT_FLAG))
+	if (WLAN_RC_PHY_HT(phy) && !(capflag & WLAN_RC_HT_FLAG))
 		return 0;
 	if (WLAN_RC_PHY_DS(phy) && !(capflag & WLAN_RC_DS_FLAG))
 		return 0;

-- 
Jouni Malinen                                            PGP id EFC895FA

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx2.zhaw.ch ([160.85.104.51]:61165 "EHLO mx2.zhaw.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754561AbZGPJFO (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Jul 2009 05:05:14 -0400
From: Tobias Klauser <klto@zhaw.ch>
To: stefano.brivio@polimi.it, mb@bu3sch.de, linville@tuxdriver.com,
	johannes@sipsolutions.net, linux-wireless@vger.kernel.org,
	netdev@vger.kernel.org
Cc: Tobias Klauser <klto@zhaw.ch>
Subject: [PATCH 3/8] b43: Use %pM conversion specifier
Date: Thu, 16 Jul 2009 10:56:02 +0200
Message-Id: <1247734562-20848-1-git-send-email-klto@zhaw.ch>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Use the %pM conversion specifier for printk instead of print_mac.

Signed-off-by: Tobias Klauser <klto@zhaw.ch>
---
 drivers/net/wireless/b43/main.c |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/b43/main.c b/drivers/net/wireless/b43/main.c
index e71c8d9..3f4360a 100644
--- a/drivers/net/wireless/b43/main.c
+++ b/drivers/net/wireless/b43/main.c
@@ -938,7 +938,6 @@ static void b43_clear_keys(struct b43_wldev *dev)
 static void b43_dump_keymemory(struct b43_wldev *dev)
 {
 	unsigned int i, index, offset;
-	DECLARE_MAC_BUF(macbuf);
 	u8 mac[ETH_ALEN];
 	u16 algo;
 	u32 rcmta0;
@@ -973,8 +972,7 @@ static void b43_dump_keymemory(struct b43_wldev *dev)
 						((index - 4) * 2) + 1);
 			*((__le32 *)(&mac[0])) = cpu_to_le32(rcmta0);
 			*((__le16 *)(&mac[4])) = cpu_to_le16(rcmta1);
-			printk("   MAC: %s",
-			       print_mac(macbuf, mac));
+			printk("   MAC: %pM", mac);
 		} else
 			printk("   DEFAULT KEY");
 		printk("\n");
-- 
1.6.0.4


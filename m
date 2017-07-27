Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:52643 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751465AbdG0WJz (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 27 Jul 2017 18:09:55 -0400
From: Colin King <colin.king@canonical.com>
To: Kalle Valo <kvalo@codeaurora.org>, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] wl3501_cs: fix spelling mistake: "Insupported" -> "Unsupported"
Date: Thu, 27 Jul 2017 23:09:54 +0100
Message-Id: <20170727220954.12105-1-colin.king@canonical.com> (sfid-20170728_001013_329847_AC13C4C4)
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Colin Ian King <colin.king@canonical.com>

Trivial fix to spelling mistake in printk message

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/net/wireless/wl3501_cs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/wl3501_cs.c b/drivers/net/wireless/wl3501_cs.c
index acec0d9ec422..da62220b9c01 100644
--- a/drivers/net/wireless/wl3501_cs.c
+++ b/drivers/net/wireless/wl3501_cs.c
@@ -965,7 +965,7 @@ static inline void wl3501_md_ind_interrupt(struct net_device *dev,
 			    &addr4, sizeof(addr4));
 	if (!(addr4[0] == 0xAA && addr4[1] == 0xAA &&
 	      addr4[2] == 0x03 && addr4[4] == 0x00)) {
-		printk(KERN_INFO "Insupported packet type!\n");
+		printk(KERN_INFO "Unsupported packet type!\n");
 		return;
 	}
 	pkt_len = sig.size + 12 - 24 - 4 - 6;
-- 
2.11.0

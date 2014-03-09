Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:34414 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752090AbaCIIvl (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 9 Mar 2014 04:51:41 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, dan.carpenter@oracle.com
Subject: [PATCH 3.14] ath9k_hw: fix unreachable code in baseband hang detection code
Date: Sun,  9 Mar 2014 09:51:16 +0100
Message-Id: <1394355076-280-1-git-send-email-nbd@openwrt.org> (sfid-20140309_095145_250842_62CE16DC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The commit "ath9k: reduce baseband hang detection false positive rate"
added a delay in the loop checking the baseband state, however it was
unreachable due to previous 'continue' statements.

Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/hw.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index 303ce27..9078a6c 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -1548,6 +1548,7 @@ bool ath9k_hw_check_alive(struct ath_hw *ah)
 		if (reg != last_val)
 			return true;
 
+		udelay(1);
 		last_val = reg;
 		if ((reg & 0x7E7FFFEF) == 0x00702400)
 			continue;
@@ -1560,8 +1561,6 @@ bool ath9k_hw_check_alive(struct ath_hw *ah)
 		default:
 			return true;
 		}
-
-		udelay(1);
 	} while (count-- > 0);
 
 	return false;
-- 
1.8.3.4 (Apple Git-47)


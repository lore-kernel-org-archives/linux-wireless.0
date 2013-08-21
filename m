Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:49217 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751159Ab3HUISD (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 Aug 2013 04:18:03 -0400
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org,
	Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [PATCH 3.11] iwl4965: fix rfkill set state regression
Date: Wed, 21 Aug 2013 10:18:19 +0200
Message-Id: <1377073099-16515-1-git-send-email-sgruszka@redhat.com> (sfid-20130821_101818_647579_1B6D1AED)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

My current 3.11 fix:

commit 788f7a56fce1bcb2067b62b851a086fca48a0056
Author: Stanislaw Gruszka <sgruszka@redhat.com>
Date:   Thu Aug 1 12:07:55 2013 +0200

    iwl4965: reset firmware after rfkill off 

broke rfkill notification to user-space . I missed that bug, because
I compiled without CONFIG_RFKILL, sorry about that.

Cc: stable@vger.kernel.org
Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/iwlegacy/4965-mac.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/iwlegacy/4965-mac.c b/drivers/net/wireless/iwlegacy/4965-mac.c
index f2ed62e..7acf5ee 100644
--- a/drivers/net/wireless/iwlegacy/4965-mac.c
+++ b/drivers/net/wireless/iwlegacy/4965-mac.c
@@ -4464,9 +4464,9 @@ il4965_irq_tasklet(struct il_priv *il)
 			set_bit(S_RFKILL, &il->status);
 		} else {
 			clear_bit(S_RFKILL, &il->status);
-			wiphy_rfkill_set_hw_state(il->hw->wiphy, hw_rf_kill);
 			il_force_reset(il, true);
 		}
+		wiphy_rfkill_set_hw_state(il->hw->wiphy, hw_rf_kill);
 
 		handled |= CSR_INT_BIT_RF_KILL;
 	}
-- 
1.7.11.7


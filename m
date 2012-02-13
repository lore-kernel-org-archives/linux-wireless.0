Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:65251 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752608Ab2BMKYi (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Feb 2012 05:24:38 -0500
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org,
	Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [PATCH 20/24] iwlegacy: only enable rfkill interrupt during UP
Date: Mon, 13 Feb 2012 11:23:27 +0100
Message-Id: <1329128611-6815-21-git-send-email-sgruszka@redhat.com> (sfid-20120213_112442_110974_29F62537)
In-Reply-To: <1329128611-6815-1-git-send-email-sgruszka@redhat.com>
References: <1329128611-6815-1-git-send-email-sgruszka@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/iwlegacy/4965-mac.c |    6 ++----
 1 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/iwlegacy/4965-mac.c b/drivers/net/wireless/iwlegacy/4965-mac.c
index 24a3bbc..cf14861 100644
--- a/drivers/net/wireless/iwlegacy/4965-mac.c
+++ b/drivers/net/wireless/iwlegacy/4965-mac.c
@@ -5523,13 +5523,11 @@ __il4965_up(struct il_priv *il)
 	/* If platform's RF_KILL switch is NOT set to KILL */
 	if (_il_rd(il, CSR_GP_CNTRL) & CSR_GP_CNTRL_REG_FLAG_HW_RF_KILL_SW)
 		clear_bit(S_RF_KILL_HW, &il->status);
-	else
+	else {
 		set_bit(S_RF_KILL_HW, &il->status);
-
-	if (il_is_rfkill(il)) {
 		wiphy_rfkill_set_hw_state(il->hw->wiphy, true);
 
-		il_enable_interrupts(il);
+		il_enable_rfkill_int(il);
 		IL_WARN("Radio disabled by HW RF Kill switch\n");
 		return 0;
 	}
-- 
1.7.1


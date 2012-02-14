Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:3599 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753108Ab2BNHuu (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Feb 2012 02:50:50 -0500
Date: Tue, 14 Feb 2012 08:50:42 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 20/24 v2] iwlegacy: enable only rfkill interrupt when rfkill
 switch is on during IFF_UP
Message-ID: <20120214075041.GA12905@redhat.com> (sfid-20120214_085054_166355_9D9125CC)
References: <1329128611-6815-1-git-send-email-sgruszka@redhat.com>
 <1329128611-6815-21-git-send-email-sgruszka@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1329128611-6815-21-git-send-email-sgruszka@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
v1 -> v2: make description less confusing

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


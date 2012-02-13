Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:34868 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756499Ab2BMKYY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Feb 2012 05:24:24 -0500
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org,
	Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [PATCH 16/24] iwleagcy: fix ident code damage
Date: Mon, 13 Feb 2012 11:23:23 +0100
Message-Id: <1329128611-6815-17-git-send-email-sgruszka@redhat.com> (sfid-20120213_112438_074192_89182C3C)
In-Reply-To: <1329128611-6815-1-git-send-email-sgruszka@redhat.com>
References: <1329128611-6815-1-git-send-email-sgruszka@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Using ident is not always good.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/iwlegacy/3945-mac.c |   18 +++++-------------
 drivers/net/wireless/iwlegacy/4965-mac.c |   18 +++++-------------
 2 files changed, 10 insertions(+), 26 deletions(-)

diff --git a/drivers/net/wireless/iwlegacy/3945-mac.c b/drivers/net/wireless/iwlegacy/3945-mac.c
index 99d7c72..002cf4f 100644
--- a/drivers/net/wireless/iwlegacy/3945-mac.c
+++ b/drivers/net/wireless/iwlegacy/3945-mac.c
@@ -2272,12 +2272,8 @@ __il3945_down(struct il_priv *il)
 	 * clear all bits but the RF Kill bits and return */
 	if (!il_is_init(il)) {
 		il->status =
-		    test_bit(S_RF_KILL_HW,
-			     &il->
-			     status) << S_RF_KILL_HW |
-		    test_bit(S_GEO_CONFIGURED,
-			     &il->
-			     status) << S_GEO_CONFIGURED |
+		    test_bit(S_RF_KILL_HW, &il->status) << S_RF_KILL_HW |
+		    test_bit(S_GEO_CONFIGURED, &il->status) << S_GEO_CONFIGURED |
 		    test_bit(S_EXIT_PENDING, &il->status) << S_EXIT_PENDING;
 		goto exit;
 	}
@@ -2285,13 +2281,9 @@ __il3945_down(struct il_priv *il)
 	/* ...otherwise clear out all the status bits but the RF Kill
 	 * bit and continue taking the NIC down. */
 	il->status &=
-	    test_bit(S_RF_KILL_HW,
-		     &il->status) << S_RF_KILL_HW | test_bit(S_GEO_CONFIGURED,
-							     &il->
-							     status) <<
-	    S_GEO_CONFIGURED | test_bit(S_FW_ERROR,
-					&il->
-					status) << S_FW_ERROR |
+	    test_bit(S_RF_KILL_HW, &il->status) << S_RF_KILL_HW |
+	    test_bit(S_GEO_CONFIGURED, &il->status) << S_GEO_CONFIGURED |
+	    test_bit(S_FW_ERROR, &il->status) << S_FW_ERROR |
 	    test_bit(S_EXIT_PENDING, &il->status) << S_EXIT_PENDING;
 
 	il3945_hw_txq_ctx_stop(il);
diff --git a/drivers/net/wireless/iwlegacy/4965-mac.c b/drivers/net/wireless/iwlegacy/4965-mac.c
index b251d34..8930e7a 100644
--- a/drivers/net/wireless/iwlegacy/4965-mac.c
+++ b/drivers/net/wireless/iwlegacy/4965-mac.c
@@ -5384,12 +5384,8 @@ __il4965_down(struct il_priv *il)
 	 * clear all bits but the RF Kill bit and return */
 	if (!il_is_init(il)) {
 		il->status =
-		    test_bit(S_RF_KILL_HW,
-			     &il->
-			     status) << S_RF_KILL_HW |
-		    test_bit(S_GEO_CONFIGURED,
-			     &il->
-			     status) << S_GEO_CONFIGURED |
+		    test_bit(S_RF_KILL_HW, &il->status) << S_RF_KILL_HW |
+		    test_bit(S_GEO_CONFIGURED, &il->status) << S_GEO_CONFIGURED |
 		    test_bit(S_EXIT_PENDING, &il->status) << S_EXIT_PENDING;
 		goto exit;
 	}
@@ -5397,13 +5393,9 @@ __il4965_down(struct il_priv *il)
 	/* ...otherwise clear out all the status bits but the RF Kill
 	 * bit and continue taking the NIC down. */
 	il->status &=
-	    test_bit(S_RF_KILL_HW,
-		     &il->status) << S_RF_KILL_HW | test_bit(S_GEO_CONFIGURED,
-							     &il->
-							     status) <<
-	    S_GEO_CONFIGURED | test_bit(S_FW_ERROR,
-					&il->
-					status) << S_FW_ERROR |
+	    test_bit(S_RF_KILL_HW, &il->status) << S_RF_KILL_HW |
+	    test_bit(S_GEO_CONFIGURED, &il->status) << S_GEO_CONFIGURED |
+	    test_bit(S_FW_ERROR, &il->status) << S_FW_ERROR |
 	    test_bit(S_EXIT_PENDING, &il->status) << S_EXIT_PENDING;
 
 	il4965_txq_ctx_stop(il);
-- 
1.7.1


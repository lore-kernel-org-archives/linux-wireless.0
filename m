Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:27614 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752608Ab2BMKY3 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Feb 2012 05:24:29 -0500
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org,
	Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [PATCH 19/24] iwlegacy: small il4965_set_hw_ready cleanup
Date: Mon, 13 Feb 2012 11:23:26 +0100
Message-Id: <1329128611-6815-20-git-send-email-sgruszka@redhat.com> (sfid-20120213_112438_667367_93F8E401)
In-Reply-To: <1329128611-6815-1-git-send-email-sgruszka@redhat.com>
References: <1329128611-6815-1-git-send-email-sgruszka@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/iwlegacy/4965-mac.c |   35 ++++++++++++------------------
 1 files changed, 14 insertions(+), 21 deletions(-)

diff --git a/drivers/net/wireless/iwlegacy/4965-mac.c b/drivers/net/wireless/iwlegacy/4965-mac.c
index 5ebf761..24a3bbc 100644
--- a/drivers/net/wireless/iwlegacy/4965-mac.c
+++ b/drivers/net/wireless/iwlegacy/4965-mac.c
@@ -5446,40 +5446,36 @@ il4965_down(struct il_priv *il)
 	il4965_cancel_deferred_work(il);
 }
 
-#define HW_READY_TIMEOUT (50)
 
-static int
+static void
 il4965_set_hw_ready(struct il_priv *il)
 {
-	int ret = 0;
+	int ret;
 
 	il_set_bit(il, CSR_HW_IF_CONFIG_REG,
 		   CSR_HW_IF_CONFIG_REG_BIT_NIC_READY);
 
 	/* See if we got it */
-	ret =
-	    _il_poll_bit(il, CSR_HW_IF_CONFIG_REG,
-			 CSR_HW_IF_CONFIG_REG_BIT_NIC_READY,
-			 CSR_HW_IF_CONFIG_REG_BIT_NIC_READY, HW_READY_TIMEOUT);
-	if (ret != -ETIMEDOUT)
+	ret = _il_poll_bit(il, CSR_HW_IF_CONFIG_REG,
+			   CSR_HW_IF_CONFIG_REG_BIT_NIC_READY,
+			   CSR_HW_IF_CONFIG_REG_BIT_NIC_READY,
+			   100);
+	if (ret >= 0)
 		il->hw_ready = true;
-	else
-		il->hw_ready = false;
 
-	D_INFO("hardware %s\n", (il->hw_ready == 1) ? "ready" : "not ready");
-	return ret;
+	D_INFO("hardware %s ready\n", (il->hw_ready) ? "" : "not");
 }
 
-static int
+static void
 il4965_prepare_card_hw(struct il_priv *il)
 {
-	int ret = 0;
+	int ret;
 
-	D_INFO("il4965_prepare_card_hw enter\n");
+	il->hw_ready = false;
 
-	ret = il4965_set_hw_ready(il);
+	il4965_set_hw_ready(il);
 	if (il->hw_ready)
-		return ret;
+		return;
 
 	/* If HW is not ready, prepare the conditions to check again */
 	il_set_bit(il, CSR_HW_IF_CONFIG_REG, CSR_HW_IF_CONFIG_REG_PREPARE);
@@ -5492,8 +5488,6 @@ il4965_prepare_card_hw(struct il_priv *il)
 	/* HW should be ready by now, check again. */
 	if (ret != -ETIMEDOUT)
 		il4965_set_hw_ready(il);
-
-	return ret;
 }
 
 #define MAX_HW_RESTARTS 5
@@ -5521,9 +5515,8 @@ __il4965_up(struct il_priv *il)
 	}
 
 	il4965_prepare_card_hw(il);
-
 	if (!il->hw_ready) {
-		IL_WARN("Exit HW not ready\n");
+		IL_ERR("HW not ready\n");
 		return -EIO;
 	}
 
-- 
1.7.1


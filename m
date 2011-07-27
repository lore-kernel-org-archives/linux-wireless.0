Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:60717 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753156Ab1G0NqK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 Jul 2011 09:46:10 -0400
Date: Wed, 27 Jul 2011 15:47:45 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH] iwlegacy: set tx power after rxon_assoc
Message-ID: <20110727134744.GA2145@redhat.com> (sfid-20110727_154614_378272_AC14909C)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>From 260ed53e8906b19985c8afc3d2cc359fa97d92a2 Mon Sep 17 00:00:00 2001
From: Stanislaw Gruszka <sgruszka@redhat.com>
Date: Wed, 27 Jul 2011 15:37:43 +0200
Subject: [PATCH] iwlegacy: set tx power after rxon_assoc

If settings of tx power was deferred during scan or changing channel we
have to setup them during commit rxon. Fix problem on 3945 (4965 already
has this fix).

Optimize code to apply tx settings only when tx power was actually
changed.

Cc: stable@kernel.org # 2.6.39+
Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/iwlegacy/iwl-3945.c |    6 +++++-
 drivers/net/wireless/iwlegacy/iwl-4965.c |    8 ++++++--
 2 files changed, 11 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/iwlegacy/iwl-3945.c b/drivers/net/wireless/iwlegacy/iwl-3945.c
index dab67a1..73fe3cd 100644
--- a/drivers/net/wireless/iwlegacy/iwl-3945.c
+++ b/drivers/net/wireless/iwlegacy/iwl-3945.c
@@ -1746,7 +1746,11 @@ int iwl3945_commit_rxon(struct iwl_priv *priv, struct iwl_rxon_context *ctx)
 		}
 
 		memcpy(active_rxon, staging_rxon, sizeof(*active_rxon));
-
+		/*
+		 * We do not commit tx power settings while channel changing,
+		 * do it now if tx power changed.
+		 */
+		iwl_legacy_set_tx_power(priv, priv->tx_power_next, false);
 		return 0;
 	}
 
diff --git a/drivers/net/wireless/iwlegacy/iwl-4965.c b/drivers/net/wireless/iwlegacy/iwl-4965.c
index bd4b000..ecdc6e5 100644
--- a/drivers/net/wireless/iwlegacy/iwl-4965.c
+++ b/drivers/net/wireless/iwlegacy/iwl-4965.c
@@ -1235,7 +1235,12 @@ static int iwl4965_commit_rxon(struct iwl_priv *priv, struct iwl_rxon_context *c
 
 		memcpy(active_rxon, &ctx->staging, sizeof(*active_rxon));
 		iwl_legacy_print_rx_config_cmd(priv, ctx);
-		goto set_tx_power;
+		/*
+		 * We do not commit tx power settings while channel changing,
+		 * do it now if tx power changed.
+		 */
+		iwl_legacy_set_tx_power(priv, priv->tx_power_next, false);
+		return 0;
 	}
 
 	/* If we are currently associated and the new config requires
@@ -1315,7 +1320,6 @@ static int iwl4965_commit_rxon(struct iwl_priv *priv, struct iwl_rxon_context *c
 
 	iwl4965_init_sensitivity(priv);
 
-set_tx_power:
 	/* If we issue a new RXON command which required a tune then we must
 	 * send a new TXPOWER command or we won't be able to Tx any frames */
 	ret = iwl_legacy_set_tx_power(priv, priv->tx_power_next, true);
-- 
1.7.1


Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:57262 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756155Ab1FFNL7 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Jun 2011 09:11:59 -0400
Date: Mon, 6 Jun 2011 15:11:30 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH wireless-2.6] iwl4965: set tx power after rxon_assoc
Message-ID: <20110606131123.GA5416@redhat.com> (sfid-20110606_151220_839003_28A2E10F)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Setting tx power can be deferred during scan or changing channel.
If after that correct tx power settings will not be sent to device,
we can observe transmission problems and timeouts. Force to send
tx power settings also after partial rxon change, to assure device
always be configured with up-to-date settings.

Resolves:
https://bugzilla.kernel.org/show_bug.cgi?id=36492

Cc: stable@kernel.org # 2.6.39+
Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/iwlegacy/iwl-4965.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/iwlegacy/iwl-4965.c b/drivers/net/wireless/iwlegacy/iwl-4965.c
index 8f33f63..3a022bc 100644
--- a/drivers/net/wireless/iwlegacy/iwl-4965.c
+++ b/drivers/net/wireless/iwlegacy/iwl-4965.c
@@ -1235,7 +1235,7 @@ static int iwl4965_commit_rxon(struct iwl_priv *priv, struct iwl_rxon_context *c
 
 		memcpy(active_rxon, &ctx->staging, sizeof(*active_rxon));
 		iwl_legacy_print_rx_config_cmd(priv, ctx);
-		return 0;
+		goto set_tx_power;
 	}
 
 	/* If we are currently associated and the new config requires
@@ -1315,6 +1315,7 @@ static int iwl4965_commit_rxon(struct iwl_priv *priv, struct iwl_rxon_context *c
 
 	iwl4965_init_sensitivity(priv);
 
+set_tx_power:
 	/* If we issue a new RXON command which required a tune then we must
 	 * send a new TXPOWER command or we won't be able to Tx any frames */
 	ret = iwl_legacy_set_tx_power(priv, priv->tx_power_next, true);
-- 
1.7.1


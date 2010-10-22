Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:64386 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756270Ab0JVPB5 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Oct 2010 11:01:57 -0400
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Wey-Yi Guy <wey-yi.w.guy@intel.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org,
	Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [PATCH 2/7] iwlwifi: send tx_power_cmd synchronously
Date: Fri, 22 Oct 2010 17:04:25 +0200
Message-Id: <1287759870-5758-2-git-send-email-sgruszka@redhat.com>
In-Reply-To: <1287759870-5758-1-git-send-email-sgruszka@redhat.com>
References: <1287759870-5758-1-git-send-email-sgruszka@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 5xxx and 6xxx change to send tx_power_cmd command synchronously,
to do not start other commands when setting tx power is pending.
We currently do the same for 4956 and 3945.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn-lib.c |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
index 5d76a5b..925347a 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
@@ -526,9 +526,8 @@ int iwlagn_send_tx_power(struct iwl_priv *priv)
 	else
 		tx_ant_cfg_cmd = REPLY_TX_POWER_DBM_CMD;
 
-	return  iwl_send_cmd_pdu_async(priv, tx_ant_cfg_cmd,
-				       sizeof(tx_power_cmd), &tx_power_cmd,
-				       NULL);
+	return iwl_send_cmd_pdu(priv, tx_ant_cfg_cmd, sizeof(tx_power_cmd),
+				&tx_power_cmd);
 }
 
 void iwlagn_temperature(struct iwl_priv *priv)
-- 
1.7.1


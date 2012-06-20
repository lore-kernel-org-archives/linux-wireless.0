Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:39607 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754973Ab2FTHiV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Jun 2012 03:38:21 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 01/12] iwlwifi: check that we have enough bits to track the TX queues
Date: Wed, 20 Jun 2012 09:38:03 +0200
Message-Id: <1340177894-12992-2-git-send-email-johannes@sipsolutions.net> (sfid-20120620_093843_204800_F2889251)
In-Reply-To: <1340177894-12992-1-git-send-email-johannes@sipsolutions.net>
References: <1340177894-12992-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/iwlwifi/dvm/main.c |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/wireless/iwlwifi/dvm/main.c b/drivers/net/wireless/iwlwifi/dvm/main.c
index e620af3..bba3edf 100644
--- a/drivers/net/wireless/iwlwifi/dvm/main.c
+++ b/drivers/net/wireless/iwlwifi/dvm/main.c
@@ -1352,6 +1352,9 @@ static struct iwl_op_mode *iwl_op_mode_dvm_start(struct iwl_trans *trans,
 		trans_cfg.queue_watchdog_timeout = IWL_WATCHDOG_DISABLED;
 	trans_cfg.command_names = iwl_dvm_cmd_strings;
 
+	WARN_ON(sizeof(priv->transport_queue_stop) * BITS_PER_BYTE <
+		priv->cfg->base_params->num_of_queues);
+
 	ucode_flags = fw->ucode_capa.flags;
 
 #ifndef CONFIG_IWLWIFI_P2P
-- 
1.7.10


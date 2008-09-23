Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:53524 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752444AbYIWRPJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Sep 2008 13:15:09 -0400
Subject: [PATCH] iwlagn: downgrade BUG_ON in interrupt
From: Johannes Berg <johannes@sipsolutions.net>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Tomas Winkler <tomasw@gmail.com>
Content-Type: text/plain
Date: Tue, 23 Sep 2008 19:14:22 +0200
Message-Id: <1222190062.18015.34.camel@johannes.berg> (sfid-20080923_191515_468904_B9897FB7)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This BUG_ON really shouldn't trigger, but if it does, as on my machine,
it leaves you wondering what happened because you won't see it. Let's
instead leak a bit of state and memory and at least make it possible to
report it to the kerneloops project to track it.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---

--- wireless-testing.orig/drivers/net/wireless/iwlwifi/iwl-tx.c	2008-09-23 13:00:01.096489715 +0200
+++ wireless-testing/drivers/net/wireless/iwlwifi/iwl-tx.c	2008-09-23 13:02:32.195402653 +0200
@@ -1203,7 +1203,8 @@ void iwl_tx_cmd_complete(struct iwl_priv
 	if (txq_id != IWL_CMD_QUEUE_NUM)
 		IWL_ERROR("Error wrong command queue %d command id 0x%X\n",
 			  txq_id, pkt->hdr.cmd);
-	BUG_ON(txq_id != IWL_CMD_QUEUE_NUM);
+	if (WARN_ON(txq_id != IWL_CMD_QUEUE_NUM))
+		return;
 
 	cmd_index = get_cmd_index(&priv->txq[IWL_CMD_QUEUE_NUM].q, index, huge);
 	cmd = priv->txq[IWL_CMD_QUEUE_NUM].cmd[cmd_index];



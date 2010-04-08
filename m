Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:50520 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933150Ab0DHUAT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Apr 2010 16:00:19 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: linux-wireless@vger.kernel.org
Cc: reinette.chatre@intel.com,
	"John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH] iwlwifi: avoid warning by using result of iwl_send_cmd_pdu in iwl_sta_init_lq
Date: Thu,  8 Apr 2010 15:48:09 -0400
Message-Id: <1270756089-9589-1-git-send-email-linville@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

  CC [M]  drivers/net/wireless/iwlwifi/iwl-sta.o
drivers/net/wireless/iwlwifi/iwl-sta.c: In function ‘iwl_sta_init_lq’:
drivers/net/wireless/iwlwifi/iwl-sta.c:461: warning: ignoring return value of ‘iwl_send_cmd_pdu’, declared with attribute warn_unused_result

Signed-off-by: John W. Linville <linville@tuxdriver.com>
---
 drivers/net/wireless/iwlwifi/iwl-sta.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-sta.c b/drivers/net/wireless/iwlwifi/iwl-sta.c
index e34ac03..91aaf11 100644
--- a/drivers/net/wireless/iwlwifi/iwl-sta.c
+++ b/drivers/net/wireless/iwlwifi/iwl-sta.c
@@ -458,8 +458,9 @@ static void iwl_sta_init_lq(struct iwl_priv *priv, const u8 *addr, bool is_ap)
 	/* Update the rate scaling for control frame Tx to AP */
 	link_cmd.sta_id = is_ap ? IWL_AP_ID : priv->hw_params.bcast_sta_id;
 
-	iwl_send_cmd_pdu(priv, REPLY_TX_LINK_QUALITY_CMD,
-			       sizeof(link_cmd), &link_cmd);
+	if (!iwl_send_cmd_pdu(priv, REPLY_TX_LINK_QUALITY_CMD,
+			       sizeof(link_cmd), &link_cmd))
+		IWL_WARN(priv, "Tx link quality reply failed\n");
 }
 
 /*
-- 
1.6.2.5


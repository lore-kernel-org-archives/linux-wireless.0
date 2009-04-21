Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:21382 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751204AbZDURtp (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Apr 2009 13:49:45 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH v2.6.30 and w-t 1/2] iwlwifi: add debugging for TX path
Date: Tue, 21 Apr 2009 10:55:47 -0700
Message-Id: <1240336548-20913-2-git-send-email-reinette.chatre@intel.com> (sfid-20090421_194950_531456_670D001B)
In-Reply-To: <1240336548-20913-1-git-send-email-reinette.chatre@intel.com>
References: <1240336548-20913-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Reinette Chatre <reinette.chatre@intel.com>

When debugging TX issues it is helpful to know the seq nr of the
frame being transmitted. The seq nr is printed as part of ucode's
log informing us which frame is being processed. Having this information
printed in driver log makes it easy to match activities between driver
and firmware.

Also make possible to print TX flags directly. These are already printed
as part of entire TX command, but having it printed directly in cpu format
makes it easier to look at.

Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-tx.c       |    4 +++-
 drivers/net/wireless/iwlwifi/iwl3945-base.c |    4 +++-
 2 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-tx.c b/drivers/net/wireless/iwlwifi/iwl-tx.c
index 58cdd32..c8c0a13 100644
--- a/drivers/net/wireless/iwlwifi/iwl-tx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-tx.c
@@ -875,8 +875,10 @@ int iwl_tx_skb(struct iwl_priv *priv, struct sk_buff *skb)
 		txq->need_update = 0;
 	}
 
+	IWL_DEBUG_TX(priv, "sequence nr = 0X%x \n",
+		     le16_to_cpu(out_cmd->hdr.sequence));
+	IWL_DEBUG_TX(priv, "tx_flags = 0X%x \n", le32_to_cpu(tx_cmd->tx_flags));
 	iwl_print_hex_dump(priv, IWL_DL_TX, (u8 *)tx_cmd, sizeof(*tx_cmd));
-
 	iwl_print_hex_dump(priv, IWL_DL_TX, (u8 *)tx_cmd->hdr, hdr_len);
 
 	/* Set up entry for this TFD in Tx byte-count array */
diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index 34c53ef..3b7b5fa 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -864,8 +864,10 @@ static int iwl3945_tx_skb(struct iwl_priv *priv, struct sk_buff *skb)
 		txq->need_update = 0;
 	}
 
+	IWL_DEBUG_TX(priv, "sequence nr = 0X%x \n",
+		     le16_to_cpu(out_cmd->hdr.sequence));
+	IWL_DEBUG_TX(priv, "tx_flags = 0X%x \n", le32_to_cpu(tx->tx_flags));
 	iwl_print_hex_dump(priv, IWL_DL_TX, tx, sizeof(*tx));
-
 	iwl_print_hex_dump(priv, IWL_DL_TX, (u8 *)tx->hdr,
 			   ieee80211_hdrlen(fc));
 
-- 
1.5.6.3


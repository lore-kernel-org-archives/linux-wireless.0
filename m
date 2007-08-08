Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:38791 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758829AbXHHHhd (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Aug 2007 03:37:33 -0400
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Zhu Yi <yi.zhu@intel.com>
Subject: [PATCH 13/28] iwlwifi: define iwl_rx_reply_scan only when CONFIG_IWLWIFI_DEBUG enabled
Date: Wed,  8 Aug 2007 15:33:30 +0800
Message-Id: <11865584562811-git-send-email-yi.zhu@intel.com>
In-Reply-To: <11865584543903-git-send-email-yi.zhu@intel.com>
References: <11865584251026-git-send-email-yi.zhu@intel.com>
 <11865584292234-git-send-email-yi.zhu@intel.com>
 <1186558432932-git-send-email-yi.zhu@intel.com>
 <11865584342308-git-send-email-yi.zhu@intel.com>
 <11865584363863-git-send-email-yi.zhu@intel.com>
 <11865584392893-git-send-email-yi.zhu@intel.com>
 <11865584413292-git-send-email-yi.zhu@intel.com>
 <1186558443548-git-send-email-yi.zhu@intel.com>
 <11865584452614-git-send-email-yi.zhu@intel.com>
 <11865584473732-git-send-email-yi.zhu@intel.com>
 <11865584503648-git-send-email-yi.zhu@intel.com>
 <11865584521358-git-send-email-yi.zhu@intel.com>
 <11865584543903-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Zhu Yi <yi.zhu@intel.com>
---
 drivers/net/wireless/iwl-base.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/iwl-base.c b/drivers/net/wireless/iwl-base.c
index dad9649..8863953 100644
--- a/drivers/net/wireless/iwl-base.c
+++ b/drivers/net/wireless/iwl-base.c
@@ -3902,11 +3902,13 @@ static void iwl_rx_beacon_notif(struct iwl_priv *priv,
 static void iwl_rx_reply_scan(struct iwl_priv *priv,
 			      struct iwl_rx_mem_buffer *rxb)
 {
+#ifdef CONFIG_IWLWIFI_DEBUG
 	struct iwl_rx_packet *pkt = (void *)rxb->skb->data;
 	struct iwl_scanstart_notification *notif =
 	    (struct iwl_scanstart_notification *)pkt->u.raw;
 
 	IWL_DEBUG_RX("Scan request status = 0x%x\n", notif->status);
+#endif
 }
 
 static void iwl_rx_scan_start_notif(struct iwl_priv *priv,
-- 
1.5.2

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:33548 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753674Ab1BQWsC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Feb 2011 17:48:02 -0500
Received: by qwa26 with SMTP id 26so2836568qwa.19
        for <linux-wireless@vger.kernel.org>; Thu, 17 Feb 2011 14:48:01 -0800 (PST)
From: Thomas Pedersen <thomas@cozybit.com>
To: linux-wireless@vger.kernel.org
Cc: buytenh@wantstofly.org
Subject: [PATCH V2 3/3] mwl8k: Invert tx queues for set_hw_spec and set_edca_params
Date: Thu, 17 Feb 2011 14:45:18 -0800
Message-Id: <1297982718-20377-3-git-send-email-thomas@cozybit.com>
In-Reply-To: <1297982718-20377-1-git-send-email-thomas@cozybit.com>
References: <1297982718-20377-1-git-send-email-thomas@cozybit.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Nishant Sarmukadam <nishants@marvell.com>

mac80211 and mwl8k FW tx queue priorities map inversely to each other.
Fix this.

Signed-off-by: Pradeep Nemavat <pnemavat@marvell.com>
Signed-off-by: Lennert Buytenhek <buytenh@wantstofly.org>
Tested-by: Pradeep Nemavat <pnemavat@marvell.com>
---
 drivers/net/wireless/mwl8k.c |   20 ++++++++++++++++----
 1 files changed, 16 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/mwl8k.c b/drivers/net/wireless/mwl8k.c
index 44355f7..03f2584 100644
--- a/drivers/net/wireless/mwl8k.c
+++ b/drivers/net/wireless/mwl8k.c
@@ -2128,8 +2128,18 @@ static int mwl8k_cmd_set_hw_spec(struct ieee80211_hw *hw)
 	cmd->ps_cookie = cpu_to_le32(priv->cookie_dma);
 	cmd->rx_queue_ptr = cpu_to_le32(priv->rxq[0].rxd_dma);
 	cmd->num_tx_queues = cpu_to_le32(MWL8K_TX_QUEUES);
-	for (i = 0; i < MWL8K_TX_QUEUES; i++)
-		cmd->tx_queue_ptrs[i] = cpu_to_le32(priv->txq[i].txd_dma);
+
+	/*
+	 * Mac80211 stack has Q0 as highest priority and Q3 as lowest in
+	 * that order. Firmware has Q3 as highest priority and Q0 as lowest
+	 * in that order. Map Q3 of mac80211 to Q0 of firmware so that the
+	 * priority is interpreted the right way in firmware.
+	 */
+	for (i = 0; i < MWL8K_TX_QUEUES; i++) {
+		int j = MWL8K_TX_QUEUES - 1 - i;
+		cmd->tx_queue_ptrs[i] = cpu_to_le32(priv->txq[j].txd_dma);
+	}
+
 	cmd->flags = cpu_to_le32(MWL8K_SET_HW_SPEC_FLAG_HOST_DECR_MGMT |
 				 MWL8K_SET_HW_SPEC_FLAG_HOSTFORM_PROBERESP |
 				 MWL8K_SET_HW_SPEC_FLAG_HOSTFORM_BEACON);
@@ -4331,12 +4341,14 @@ static int mwl8k_conf_tx(struct ieee80211_hw *hw, u16 queue,
 		if (!priv->wmm_enabled)
 			rc = mwl8k_cmd_set_wmm_mode(hw, 1);
 
-		if (!rc)
-			rc = mwl8k_cmd_set_edca_params(hw, queue,
+		if (!rc) {
+			int q = MWL8K_TX_QUEUES - 1 - queue;
+			rc = mwl8k_cmd_set_edca_params(hw, q,
 						       params->cw_min,
 						       params->cw_max,
 						       params->aifs,
 						       params->txop);
+		}
 
 		mwl8k_fw_unlock(hw);
 	}
-- 
1.7.0.4


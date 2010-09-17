Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:3029 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754462Ab0IQVXb (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 17 Sep 2010 17:23:31 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 10/10] iwlagn: initialize both tx/rx prio boost parameters
Date: Fri, 17 Sep 2010 14:24:34 -0700
Message-Id: <1284758674-25297-11-git-send-email-wey-yi.w.guy@intel.com>
In-Reply-To: <1284758674-25297-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1284758674-25297-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Wey-Yi Guy <wey-yi.w.guy@intel.com>

For config bt command, initialize both tx_prio_boost and
rx_prio_boost to "0".

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn-lib.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
index 616115a..299fd9d 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
@@ -1781,6 +1781,8 @@ void iwlagn_send_advance_bt_config(struct iwl_priv *priv)
 	bt_cmd.kill_ack_mask = priv->kill_ack_mask;
 	bt_cmd.kill_cts_mask = priv->kill_cts_mask;
 	bt_cmd.valid = priv->bt_valid;
+	bt_cmd.tx_prio_boost = 0;
+	bt_cmd.rx_prio_boost = 0;
 
 	/*
 	 * Configure BT coex mode to "no coexistence" when the
-- 
1.7.0.4


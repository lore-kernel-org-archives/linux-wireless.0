Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:59070 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751400Ab1AEAbu (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Jan 2011 19:31:50 -0500
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Johannes Berg <johannes.berg@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 1/5] iwlagn: make iwl_rx_handle static
Date: Tue,  4 Jan 2011 16:21:59 -0800
Message-Id: <1294186923-4582-2-git-send-email-wey-yi.w.guy@intel.com>
In-Reply-To: <1294186923-4582-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1294186923-4582-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

It's not used or likely to be needed from other
files, so it can be static.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn.c |    2 +-
 drivers/net/wireless/iwlwifi/iwl-agn.h |    1 -
 2 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index 5f11dc2..bd7ae27 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -846,7 +846,7 @@ static void iwl_setup_rx_handlers(struct iwl_priv *priv)
  * the appropriate handlers, including command responses,
  * frame-received notifications, and other notifications.
  */
-void iwl_rx_handle(struct iwl_priv *priv)
+static void iwl_rx_handle(struct iwl_priv *priv)
 {
 	struct iwl_rx_mem_buffer *rxb;
 	struct iwl_rx_packet *pkt;
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.h b/drivers/net/wireless/iwlwifi/iwl-agn.h
index da30358..e725784 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.h
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.h
@@ -185,7 +185,6 @@ void iwlagn_rx_reply_rx(struct iwl_priv *priv,
 		     struct iwl_rx_mem_buffer *rxb);
 void iwlagn_rx_reply_rx_phy(struct iwl_priv *priv,
 			 struct iwl_rx_mem_buffer *rxb);
-void iwl_rx_handle(struct iwl_priv *priv);
 
 /* tx */
 void iwl_hw_txq_free_tfd(struct iwl_priv *priv, struct iwl_tx_queue *txq);
-- 
1.7.0.4


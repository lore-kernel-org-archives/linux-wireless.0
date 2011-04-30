Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:11717 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756477Ab1D3Qkr (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 30 Apr 2011 12:40:47 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 05/14] iwlagn: remove 5000 from rxon_assoc structure
Date: Sat, 30 Apr 2011 09:17:31 -0700
Message-Id: <1304180260-13875-6-git-send-email-wey-yi.w.guy@intel.com> (sfid-20110430_184054_748027_4F1A2DDB)
In-Reply-To: <1304180260-13875-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1304180260-13875-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The data structure is shared by all _agn devices, remove the reference to 5000

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn-rxon.c |    2 +-
 drivers/net/wireless/iwlwifi/iwl-commands.h |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-rxon.c b/drivers/net/wireless/iwlwifi/iwl-agn-rxon.c
index aba5bc9..7f52ab8 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-rxon.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-rxon.c
@@ -125,7 +125,7 @@ static int iwlagn_send_rxon_assoc(struct iwl_priv *priv,
 			   struct iwl_rxon_context *ctx)
 {
 	int ret = 0;
-	struct iwl5000_rxon_assoc_cmd rxon_assoc;
+	struct iwl_rxon_assoc_cmd rxon_assoc;
 	const struct iwl_rxon_cmd *rxon1 = &ctx->staging;
 	const struct iwl_rxon_cmd *rxon2 = &ctx->active;
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-commands.h b/drivers/net/wireless/iwlwifi/iwl-commands.h
index e125896..5fdad65 100644
--- a/drivers/net/wireless/iwlwifi/iwl-commands.h
+++ b/drivers/net/wireless/iwlwifi/iwl-commands.h
@@ -661,7 +661,7 @@ struct iwl_rxon_cmd {
 /*
  * REPLY_RXON_ASSOC = 0x11 (command, has simple generic response)
  */
-struct iwl5000_rxon_assoc_cmd {
+struct iwl_rxon_assoc_cmd {
 	__le32 flags;
 	__le32 filter_flags;
 	u8 ofdm_basic_rates;
-- 
1.7.0.4


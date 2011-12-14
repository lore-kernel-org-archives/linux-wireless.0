Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:23571 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757705Ab1LNRWO (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Dec 2011 12:22:14 -0500
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 2/2] iwlwifi: allow to switch to HT40 if not associated
Date: Wed, 14 Dec 2011 08:22:36 -0800
Message-Id: <1323879756-3817-3-git-send-email-wey-yi.w.guy@intel.com> (sfid-20111214_182230_413732_56CA4119)
In-Reply-To: <1323879756-3817-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1323879756-3817-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

My previous patch
34a5b4b6af104cf18eb50748509528b9bdbc4036 iwlwifi: do not re-configure
HT40 after associated

Fix the case of HT40 after association on specified AP, but it break the
association for some APs and cause not able to establish connection.
We need to address HT40 before and after addociation.

CC: stable@vger.kernel.org #3.0+
Reported-by: Andrej Gelenberg <andrej.gelenberg@udo.edu>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
Tested-by: Andrej Gelenberg <andrej.gelenberg@udo.edu>
---
 drivers/net/wireless/iwlwifi/iwl-agn-rxon.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-rxon.c b/drivers/net/wireless/iwlwifi/iwl-agn-rxon.c
index a7a6def..5c7c17c 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-rxon.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-rxon.c
@@ -606,8 +606,8 @@ int iwlagn_mac_config(struct ieee80211_hw *hw, u32 changed)
 			if (ctx->ht.enabled) {
 				/* if HT40 is used, it should not change
 				 * after associated except channel switch */
-				if (iwl_is_associated_ctx(ctx) &&
-				     !ctx->ht.is_40mhz)
+				if (!ctx->ht.is_40mhz ||
+						!iwl_is_associated_ctx(ctx))
 					iwlagn_config_ht40(conf, ctx);
 			} else
 				ctx->ht.is_40mhz = false;
-- 
1.7.0.4


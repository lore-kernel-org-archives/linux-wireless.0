Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:52688 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752181AbYE2IhW (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 29 May 2008 04:37:22 -0400
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Tomas Winkler <tomas.winkler@intel.com>
Subject: [PATCH 07/43] iwlwifi: remove unused variable form __iwl4965_down
Date: Thu, 29 May 2008 16:34:52 +0800
Message-Id: <1212050128-17132-8-git-send-email-yi.zhu@intel.com> (sfid-20080529_103727_914970_3138F00A)
In-Reply-To: <1212050128-17132-7-git-send-email-yi.zhu@intel.com>
References: <1212050128-17132-1-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-2-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-3-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-4-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-5-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-6-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-7-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Tomas Winkler <tomas.winkler@intel.com>

This patch removes unused variable from __iwl4965_down.

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl4965-base.c |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl4965-base.c b/drivers/net/wireless/iwlwifi/iwl4965-base.c
index e9dfb72..d7f9321 100644
--- a/drivers/net/wireless/iwlwifi/iwl4965-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl4965-base.c
@@ -3341,12 +3341,9 @@ static void __iwl4965_down(struct iwl_priv *priv)
 {
 	unsigned long flags;
 	int exit_pending = test_bit(STATUS_EXIT_PENDING, &priv->status);
-	struct ieee80211_conf *conf = NULL;
 
 	IWL_DEBUG_INFO(DRV_NAME " is going down\n");
 
-	conf = ieee80211_get_hw_conf(priv->hw);
-
 	if (!exit_pending)
 		set_bit(STATUS_EXIT_PENDING, &priv->status);
 
-- 
1.5.3.6


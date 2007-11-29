Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:4146 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755672AbXK2DKv (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Nov 2007 22:10:51 -0500
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Saleem Abdulrasool <compnerd@compnerd.org>,
	Zhu Yi <yi.zhu@intel.com>
Subject: [PATCH 16/36] iwlwifi: fix possibly NULL dereference in iwl_set_rate()
Date: Thu, 29 Nov 2007 11:09:56 +0800
Message-Id: <1196305816-23023-17-git-send-email-yi.zhu@intel.com> (sfid-20071129_033534_493599_FEC16AFF)
In-Reply-To: <1196305816-23023-16-git-send-email-yi.zhu@intel.com>
References: <1196305816-23023-1-git-send-email-yi.zhu@intel.com>
 <1196305816-23023-2-git-send-email-yi.zhu@intel.com>
 <1196305816-23023-3-git-send-email-yi.zhu@intel.com>
 <1196305816-23023-4-git-send-email-yi.zhu@intel.com>
 <1196305816-23023-5-git-send-email-yi.zhu@intel.com>
 <1196305816-23023-6-git-send-email-yi.zhu@intel.com>
 <1196305816-23023-7-git-send-email-yi.zhu@intel.com>
 <1196305816-23023-8-git-send-email-yi.zhu@intel.com>
 <1196305816-23023-9-git-send-email-yi.zhu@intel.com>
 <1196305816-23023-10-git-send-email-yi.zhu@intel.com>
 <1196305816-23023-11-git-send-email-yi.zhu@intel.com>
 <1196305816-23023-12-git-send-email-yi.zhu@intel.com>
 <1196305816-23023-13-git-send-email-yi.zhu@intel.com>
 <1196305816-23023-14-git-send-email-yi.zhu@intel.com>
 <1196305816-23023-15-git-send-email-yi.zhu@intel.com>
 <1196305816-23023-16-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Saleem Abdulrasool <compnerd@compnerd.org>

Signed-off-by: Saleem Abdulrasool <compnerd@compnerd.org>
Signed-off-by: Zhu Yi <yi.zhu@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl3945-base.c |    4 ++++
 drivers/net/wireless/iwlwifi/iwl4965-base.c |    4 ++++
 2 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index a742309..a892e26 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -2984,6 +2984,10 @@ static void iwl3945_set_rate(struct iwl3945_priv *priv)
 	int i;
 
 	hw = iwl3945_get_hw_mode(priv, priv->phymode);
+	if (!hw) {
+		IWL_ERROR("Failed to set rate: unable to get hw mode\n");
+		return;
+	}
 
 	priv->active_rate = 0;
 	priv->active_rate_basic = 0;
diff --git a/drivers/net/wireless/iwlwifi/iwl4965-base.c b/drivers/net/wireless/iwlwifi/iwl4965-base.c
index 01ba374..f813669 100644
--- a/drivers/net/wireless/iwlwifi/iwl4965-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl4965-base.c
@@ -3092,6 +3092,10 @@ static void iwl4965_set_rate(struct iwl4965_priv *priv)
 	int i;
 
 	hw = iwl4965_get_hw_mode(priv, priv->phymode);
+	if (!hw) {
+		IWL_ERROR("Failed to set rate: unable to get hw mode\n");
+		return;
+	}
 
 	priv->active_rate = 0;
 	priv->active_rate_basic = 0;
-- 
1.5.3.6

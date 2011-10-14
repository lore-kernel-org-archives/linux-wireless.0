Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:36497 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932592Ab1JNUoh (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 14 Oct 2011 16:44:37 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Don Fry <donald.h.fry@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 4/6] iwlagn: simplify iwl_alloc_all
Date: Fri, 14 Oct 2011 12:54:46 -0700
Message-Id: <1318622088-14679-5-git-send-email-wey-yi.w.guy@intel.com> (sfid-20111014_224445_814413_3CDCF204)
In-Reply-To: <1318622088-14679-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1318622088-14679-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Don Fry <donald.h.fry@intel.com>

The iwl_alloc_all routine is only called once.  Delete the argument
and print an error in the calling routine if needed.

Signed-off-by: Don Fry <donald.h.fry@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn.c |   10 ++++------
 1 files changed, 4 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index 47dbcca..9d463cf 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -3178,7 +3178,7 @@ static int iwl_set_hw_params(struct iwl_priv *priv)
 }
 
 /* This function both allocates and initializes hw and priv. */
-static struct ieee80211_hw *iwl_alloc_all(struct iwl_cfg *cfg)
+static struct ieee80211_hw *iwl_alloc_all(void)
 {
 	struct iwl_priv *priv;
 	/* mac80211 allocates memory for this device instance, including
@@ -3186,11 +3186,8 @@ static struct ieee80211_hw *iwl_alloc_all(struct iwl_cfg *cfg)
 	struct ieee80211_hw *hw;
 
 	hw = ieee80211_alloc_hw(sizeof(struct iwl_priv), &iwlagn_hw_ops);
-	if (hw == NULL) {
-		pr_err("%s: Can not allocate network device\n",
-		       cfg->name);
+	if (!hw)
 		goto out;
-	}
 
 	priv = hw->priv;
 	priv->hw = hw;
@@ -3211,8 +3208,9 @@ int iwl_probe(struct iwl_bus *bus, const struct iwl_trans_ops *trans_ops,
 	/************************
 	 * 1. Allocating HW data
 	 ************************/
-	hw = iwl_alloc_all(cfg);
+	hw = iwl_alloc_all();
 	if (!hw) {
+		pr_err("%s: Cannot allocate network device\n", cfg->name);
 		err = -ENOMEM;
 		goto out;
 	}
-- 
1.7.0.4


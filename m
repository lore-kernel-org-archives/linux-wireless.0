Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:42373 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752858Ab0JMNhk (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Oct 2010 09:37:40 -0400
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Johannes Berg <johannes@sipsolutions.net>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Cc: linux-wireless@vger.kernel.org,
	Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [PATCH 2/2] iwlwifi: one less commit_rxon while scan
Date: Wed, 13 Oct 2010 15:39:53 +0200
Message-Id: <1286977193-12144-2-git-send-email-sgruszka@redhat.com>
In-Reply-To: <1286977193-12144-1-git-send-email-sgruszka@redhat.com>
References: <1286977193-12144-1-git-send-email-sgruszka@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Almost anywhere in the code we avoid committing rxon while performing
scan, and make rxon commit when scan complete. Some current patches do
not follow that rule. We have that problem at least in
iwlagn_confirue_filter(), iwl_update_chain_flags() and
iwl_bg_bt_full_concurrency(). This patch try to resolve the first
function, formers are much harder to resolve so left them by now.

Since we do not commit directly in iwl3945_configure_filter, we can
also do the same for agn, so I just remove iwlcore_commit_rxon()
function and add a comment. Also change comment for iwl3945.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn.c      |    6 +++++-
 drivers/net/wireless/iwlwifi/iwl3945-base.c |    6 +++---
 2 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index 0881452..5a881c9 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -3984,7 +3984,11 @@ static void iwlagn_configure_filter(struct ieee80211_hw *hw,
 	for_each_context(priv, ctx) {
 		ctx->staging.filter_flags &= ~filter_nand;
 		ctx->staging.filter_flags |= filter_or;
-		iwlcore_commit_rxon(priv, ctx);
+
+		/*
+		 * Not committing directly because hardware can perform a scan,
+		 * but we'll eventually commit the filter flags change anyway.
+		 */
 	}
 
 	mutex_unlock(&priv->mutex);
diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index 9d0f736..4ff4b2e 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -3407,9 +3407,9 @@ static void iwl3945_configure_filter(struct ieee80211_hw *hw,
 	ctx->staging.filter_flags |= filter_or;
 
 	/*
-	 * Committing directly here breaks for some reason,
-	 * but we'll eventually commit the filter flags
-	 * change anyway.
+	 * Not committing directly because hardware can perfrom a scan,
+	 * but even if hw is ready, commiting here breaks for some reason,
+	 * we'll eventually commit the filter flags change anyway.
 	 */
 
 	mutex_unlock(&priv->mutex);
-- 
1.7.1


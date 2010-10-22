Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:49701 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756270Ab0JVPCA (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Oct 2010 11:02:00 -0400
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Wey-Yi Guy <wey-yi.w.guy@intel.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org,
	Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [PATCH 4/7] iwlwifi: avoid commit rxon during scan in iwlagn_configure_filter
Date: Fri, 22 Oct 2010 17:04:27 +0200
Message-Id: <1287759870-5758-4-git-send-email-sgruszka@redhat.com>
In-Reply-To: <1287759870-5758-1-git-send-email-sgruszka@redhat.com>
References: <1287759870-5758-1-git-send-email-sgruszka@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Almost anywhere in the code we avoid committing rxon while performing
scan, and make rxon commit when scan complete. However in some places
in the code we do not follow that rule. This patch fix that problem in
iwlagn_configure_filter().

Since we do not commit directly in iwl3945_configure_filter, we can
also do the same for agn, so I just remove iwlcore_commit_rxon()
function and add a comment. Also change comment for iwl3945.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn.c      |    6 +++++-
 drivers/net/wireless/iwlwifi/iwl3945-base.c |    6 +++---
 2 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index d3435c4..0ba8083 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -3983,7 +3983,11 @@ static void iwlagn_configure_filter(struct ieee80211_hw *hw,
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
index a754291..25f77e4 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -3407,9 +3407,9 @@ static void iwl3945_configure_filter(struct ieee80211_hw *hw,
 	ctx->staging.filter_flags |= filter_or;
 
 	/*
-	 * Committing directly here breaks for some reason,
-	 * but we'll eventually commit the filter flags
-	 * change anyway.
+	 * Not committing directly because hardware can perform a scan,
+	 * but even if hw is ready, committing here breaks for some reason,
+	 * we'll eventually commit the filter flags change anyway.
 	 */
 
 	mutex_unlock(&priv->mutex);
-- 
1.7.1


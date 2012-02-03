Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:22834 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754302Ab2BCMI1 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 3 Feb 2012 07:08:27 -0500
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org,
	Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [PATCH 20/25] iwlegacy: remove il_setup_interface()
Date: Fri,  3 Feb 2012 13:07:20 +0100
Message-Id: <1328270845-16891-21-git-send-email-sgruszka@redhat.com> (sfid-20120203_130845_295413_786B705B)
In-Reply-To: <1328270845-16891-1-git-send-email-sgruszka@redhat.com>
References: <1328270845-16891-1-git-send-email-sgruszka@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/iwlegacy/common.c |   22 +++-------------------
 1 files changed, 3 insertions(+), 19 deletions(-)

diff --git a/drivers/net/wireless/iwlegacy/common.c b/drivers/net/wireless/iwlegacy/common.c
index 13bd3a8..ea2fa97 100644
--- a/drivers/net/wireless/iwlegacy/common.c
+++ b/drivers/net/wireless/iwlegacy/common.c
@@ -4533,23 +4533,6 @@ il_set_mode(struct il_priv *il, struct il_rxon_context *ctx)
 	return il_commit_rxon(il, ctx);
 }
 
-static int
-il_setup_interface(struct il_priv *il, struct il_rxon_context *ctx)
-{
-	struct ieee80211_vif *vif = ctx->vif;
-
-	lockdep_assert_held(&il->mutex);
-
-	/*
-	 * This variable will be correct only when there's just
-	 * a single context, but all code using it is for hardware
-	 * that supports only one context.
-	 */
-	il->iw_mode = vif->type;
-
-	return il_set_mode(il, ctx);
-}
-
 int
 il_mac_add_interface(struct ieee80211_hw *hw, struct ieee80211_vif *vif)
 {
@@ -4574,8 +4557,9 @@ il_mac_add_interface(struct ieee80211_hw *hw, struct ieee80211_vif *vif)
 
 	vif_priv->ctx = &il->ctx;
 	il->ctx.vif = vif;
+	il->iw_mode = vif->type;
 
-	err = il_setup_interface(il, &il->ctx);
+	err = il_set_mode(il, &il->ctx);
 	if (err) {
 		il->ctx.vif = NULL;
 		il->iw_mode = NL80211_IFTYPE_STATION;
@@ -4978,7 +4962,7 @@ il_mac_change_interface(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 	il_teardown_interface(il, vif, true);
 	vif->type = newtype;
 	vif->p2p = false;
-	err = il_setup_interface(il, ctx);
+	err = il_set_mode(il, ctx);
 	WARN_ON(err);
 	/*
 	 * We've switched internally, but submitting to the
-- 
1.7.1


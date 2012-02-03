Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:35575 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756892Ab2BCQdG (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 3 Feb 2012 11:33:06 -0500
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org,
	Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [PATCH v2 19/25] iwlegacy: get rid of ctx->is_active
Date: Fri,  3 Feb 2012 17:31:55 +0100
Message-Id: <1328286721-11309-20-git-send-email-sgruszka@redhat.com> (sfid-20120203_173327_954465_49992E92)
In-Reply-To: <1328286721-11309-1-git-send-email-sgruszka@redhat.com>
References: <1328286721-11309-1-git-send-email-sgruszka@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/iwlegacy/4965-mac.c |    3 ---
 drivers/net/wireless/iwlegacy/4965.c     |    3 ---
 drivers/net/wireless/iwlegacy/common.c   |   21 +++------------------
 drivers/net/wireless/iwlegacy/common.h   |    7 -------
 4 files changed, 3 insertions(+), 31 deletions(-)

diff --git a/drivers/net/wireless/iwlegacy/4965-mac.c b/drivers/net/wireless/iwlegacy/4965-mac.c
index 1c3c85e..1a54c1a 100644
--- a/drivers/net/wireless/iwlegacy/4965-mac.c
+++ b/drivers/net/wireless/iwlegacy/4965-mac.c
@@ -6134,9 +6134,6 @@ il4965_pci_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	il = hw->priv;
 	/* At this point both hw and il are allocated. */
 
-	il->ctx.always_active = true;
-	il->ctx.is_active = true;
-
 	SET_IEEE80211_DEV(hw, &pdev->dev);
 
 	D_INFO("*** LOAD DRIVER ***\n");
diff --git a/drivers/net/wireless/iwlegacy/4965.c b/drivers/net/wireless/iwlegacy/4965.c
index 8d0fd60..7b0192a 100644
--- a/drivers/net/wireless/iwlegacy/4965.c
+++ b/drivers/net/wireless/iwlegacy/4965.c
@@ -1419,9 +1419,6 @@ il4965_commit_rxon(struct il_priv *il, struct il_rxon_context *ctx)
 	if (!il_is_alive(il))
 		return -EBUSY;
 
-	if (!ctx->is_active)
-		return 0;
-
 	/* always get timestamp with Rx frame */
 	il->staging.flags |= RXON_FLG_TSF2HOST_MSK;
 
diff --git a/drivers/net/wireless/iwlegacy/common.c b/drivers/net/wireless/iwlegacy/common.c
index db2e8bb..13bd3a8 100644
--- a/drivers/net/wireless/iwlegacy/common.c
+++ b/drivers/net/wireless/iwlegacy/common.c
@@ -4537,7 +4537,6 @@ static int
 il_setup_interface(struct il_priv *il, struct il_rxon_context *ctx)
 {
 	struct ieee80211_vif *vif = ctx->vif;
-	int err;
 
 	lockdep_assert_held(&il->mutex);
 
@@ -4548,16 +4547,7 @@ il_setup_interface(struct il_priv *il, struct il_rxon_context *ctx)
 	 */
 	il->iw_mode = vif->type;
 
-	ctx->is_active = true;
-
-	err = il_set_mode(il, ctx);
-	if (err) {
-		if (!ctx->always_active)
-			ctx->is_active = false;
-		return err;
-	}
-
-	return 0;
+	return il_set_mode(il, ctx);
 }
 
 int
@@ -4612,11 +4602,9 @@ il_teardown_interface(struct il_priv *il, struct ieee80211_vif *vif,
 		il_force_scan_end(il);
 	}
 
-	if (!mode_change) {
+	if (!mode_change)
 		il_set_mode(il, ctx);
-		if (!ctx->always_active)
-			ctx->is_active = false;
-	}
+
 }
 
 void
@@ -5227,9 +5215,6 @@ il_update_qos(struct il_priv *il, struct il_rxon_context *ctx)
 	if (test_bit(S_EXIT_PENDING, &il->status))
 		return;
 
-	if (!ctx->is_active)
-		return;
-
 	il->qos_data.def_qos_parm.qos_flags = 0;
 
 	if (il->qos_data.qos_active)
diff --git a/drivers/net/wireless/iwlegacy/common.h b/drivers/net/wireless/iwlegacy/common.h
index e085131..51c1eec 100644
--- a/drivers/net/wireless/iwlegacy/common.h
+++ b/drivers/net/wireless/iwlegacy/common.h
@@ -1154,13 +1154,6 @@ struct il_force_reset {
 
 struct il_rxon_context {
 	struct ieee80211_vif *vif;
-
-	/*
-	 * We could use the vif to indicate active, but we
-	 * also need it to be active during disabling when
-	 * we already removed the vif for type setting.
-	 */
-	bool always_active, is_active;
 };
 
 struct il_power_mgr {
-- 
1.7.1


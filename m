Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:1030 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753943Ab2BCQdE (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 3 Feb 2012 11:33:04 -0500
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org,
	Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [PATCH v2 17/25] iwlegacy: get rid of ctx->ac_to_fifo
Date: Fri,  3 Feb 2012 17:31:53 +0100
Message-Id: <1328286721-11309-18-git-send-email-sgruszka@redhat.com> (sfid-20120203_173312_398819_F60E81A4)
In-Reply-To: <1328286721-11309-1-git-send-email-sgruszka@redhat.com>
References: <1328286721-11309-1-git-send-email-sgruszka@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/iwlegacy/4965-mac.c |   17 ++++++++---------
 drivers/net/wireless/iwlegacy/common.h   |    1 -
 2 files changed, 8 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/iwlegacy/4965-mac.c b/drivers/net/wireless/iwlegacy/4965-mac.c
index 94984c8..731bb8c 100644
--- a/drivers/net/wireless/iwlegacy/4965-mac.c
+++ b/drivers/net/wireless/iwlegacy/4965-mac.c
@@ -1458,8 +1458,15 @@ il4965_get_ac_from_tid(u16 tid)
 static inline int
 il4965_get_fifo_from_tid(struct il_rxon_context *ctx, u16 tid)
 {
+	const u8 ac_to_fifo[] = {
+		IL_TX_FIFO_VO,
+		IL_TX_FIFO_VI,
+		IL_TX_FIFO_BE,
+		IL_TX_FIFO_BK,
+	};
+
 	if (likely(tid < ARRAY_SIZE(tid_to_ac)))
-		return ctx->ac_to_fifo[tid_to_ac[tid]];
+		return ac_to_fifo[tid_to_ac[tid]];
 
 	/* no support for TIDs 8-15 yet */
 	return -EINVAL;
@@ -6104,13 +6111,6 @@ il4965_set_hw_params(struct il_priv *il)
 	return il->cfg->ops->lib->set_hw_params(il);
 }
 
-static const u8 il4965_bss_ac_to_fifo[] = {
-	IL_TX_FIFO_VO,
-	IL_TX_FIFO_VI,
-	IL_TX_FIFO_BE,
-	IL_TX_FIFO_BK,
-};
-
 static const u8 il4965_bss_ac_to_queue[] = {
 	0, 1, 2, 3,
 };
@@ -6139,7 +6139,6 @@ il4965_pci_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 
 	il->ctx.always_active = true;
 	il->ctx.is_active = true;
-	il->ctx.ac_to_fifo = il4965_bss_ac_to_fifo;
 	il->ctx.ac_to_queue = il4965_bss_ac_to_queue;
 
 	SET_IEEE80211_DEV(hw, &pdev->dev);
diff --git a/drivers/net/wireless/iwlegacy/common.h b/drivers/net/wireless/iwlegacy/common.h
index df4d160..e0e4d01 100644
--- a/drivers/net/wireless/iwlegacy/common.h
+++ b/drivers/net/wireless/iwlegacy/common.h
@@ -1155,7 +1155,6 @@ struct il_force_reset {
 struct il_rxon_context {
 	struct ieee80211_vif *vif;
 
-	const u8 *ac_to_fifo;
 	const u8 *ac_to_queue;
 
 	/*
-- 
1.7.1


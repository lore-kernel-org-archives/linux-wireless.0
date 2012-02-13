Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:39744 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756565Ab2BMKYv (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Feb 2012 05:24:51 -0500
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org,
	Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [PATCH 23/24] iwlegacy: s/il_txq_mem/il_free_txq_mem/g
Date: Mon, 13 Feb 2012 11:23:30 +0100
Message-Id: <1329128611-6815-24-git-send-email-sgruszka@redhat.com> (sfid-20120213_112456_556986_8AE4B6EF)
In-Reply-To: <1329128611-6815-1-git-send-email-sgruszka@redhat.com>
References: <1329128611-6815-1-git-send-email-sgruszka@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Previous name was confusing.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/iwlegacy/3945.c     |    2 +-
 drivers/net/wireless/iwlegacy/4965-mac.c |    2 +-
 drivers/net/wireless/iwlegacy/common.c   |    4 ++--
 drivers/net/wireless/iwlegacy/common.h   |    2 +-
 4 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/iwlegacy/3945.c b/drivers/net/wireless/iwlegacy/3945.c
index 8900e3c..456f32d 100644
--- a/drivers/net/wireless/iwlegacy/3945.c
+++ b/drivers/net/wireless/iwlegacy/3945.c
@@ -1002,7 +1002,7 @@ il3945_hw_txq_ctx_free(struct il_priv *il)
 				il_tx_queue_free(il, txq_id);
 
 	/* free tx queue structure */
-	il_txq_mem(il);
+	il_free_txq_mem(il);
 }
 
 void
diff --git a/drivers/net/wireless/iwlegacy/4965-mac.c b/drivers/net/wireless/iwlegacy/4965-mac.c
index 3aa0ee5..2d01db0 100644
--- a/drivers/net/wireless/iwlegacy/4965-mac.c
+++ b/drivers/net/wireless/iwlegacy/4965-mac.c
@@ -1939,7 +1939,7 @@ il4965_hw_txq_ctx_free(struct il_priv *il)
 	il4965_free_dma_ptr(il, &il->scd_bc_tbls);
 
 	/* free tx queue structure */
-	il_txq_mem(il);
+	il_free_txq_mem(il);
 }
 
 /**
diff --git a/drivers/net/wireless/iwlegacy/common.c b/drivers/net/wireless/iwlegacy/common.c
index defe8d9..b42052b 100644
--- a/drivers/net/wireless/iwlegacy/common.c
+++ b/drivers/net/wireless/iwlegacy/common.c
@@ -4591,12 +4591,12 @@ il_alloc_txq_mem(struct il_priv *il)
 EXPORT_SYMBOL(il_alloc_txq_mem);
 
 void
-il_txq_mem(struct il_priv *il)
+il_free_txq_mem(struct il_priv *il)
 {
 	kfree(il->txq);
 	il->txq = NULL;
 }
-EXPORT_SYMBOL(il_txq_mem);
+EXPORT_SYMBOL(il_free_txq_mem);
 
 int
 il_force_reset(struct il_priv *il, bool external)
diff --git a/drivers/net/wireless/iwlegacy/common.h b/drivers/net/wireless/iwlegacy/common.h
index 4282018..cee72f1 100644
--- a/drivers/net/wireless/iwlegacy/common.h
+++ b/drivers/net/wireless/iwlegacy/common.h
@@ -1747,7 +1747,7 @@ void il_mac_remove_interface(struct ieee80211_hw *hw,
 int il_mac_change_interface(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 			    enum nl80211_iftype newtype, bool newp2p);
 int il_alloc_txq_mem(struct il_priv *il);
-void il_txq_mem(struct il_priv *il);
+void il_free_txq_mem(struct il_priv *il);
 
 #ifdef CONFIG_IWLEGACY_DEBUGFS
 extern void il_update_stats(struct il_priv *il, bool is_tx, __le16 fc, u16 len);
-- 
1.7.1


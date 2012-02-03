Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:8370 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754141Ab2BCMIV (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 3 Feb 2012 07:08:21 -0500
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org,
	Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [PATCH 18/25] iwlegacy: get rid of ctx->ac_to_queue
Date: Fri,  3 Feb 2012 13:07:18 +0100
Message-Id: <1328270845-16891-19-git-send-email-sgruszka@redhat.com> (sfid-20120203_130830_956306_8DAA08D2)
In-Reply-To: <1328270845-16891-1-git-send-email-sgruszka@redhat.com>
References: <1328270845-16891-1-git-send-email-sgruszka@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/iwlegacy/4965-mac.c |    8 ++------
 drivers/net/wireless/iwlegacy/common.h   |    2 --
 2 files changed, 2 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/iwlegacy/4965-mac.c b/drivers/net/wireless/iwlegacy/4965-mac.c
index 731bb8c..1c3c85e 100644
--- a/drivers/net/wireless/iwlegacy/4965-mac.c
+++ b/drivers/net/wireless/iwlegacy/4965-mac.c
@@ -1718,7 +1718,8 @@ il4965_tx_skb(struct il_priv *il, struct sk_buff *skb)
 	/* FIXME: remove me ? */
 	WARN_ON_ONCE(info->flags & IEEE80211_TX_CTL_SEND_AFTER_DTIM);
 
-	txq_id = ctx->ac_to_queue[skb_get_queue_mapping(skb)];
+	/* Access category (AC) is also the queue number */
+	txq_id = skb_get_queue_mapping(skb);
 
 	/* irqs already disabled/saved above when locking il->lock */
 	spin_lock(&il->sta_lock);
@@ -6111,10 +6112,6 @@ il4965_set_hw_params(struct il_priv *il)
 	return il->cfg->ops->lib->set_hw_params(il);
 }
 
-static const u8 il4965_bss_ac_to_queue[] = {
-	0, 1, 2, 3,
-};
-
 static int
 il4965_pci_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 {
@@ -6139,7 +6136,6 @@ il4965_pci_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 
 	il->ctx.always_active = true;
 	il->ctx.is_active = true;
-	il->ctx.ac_to_queue = il4965_bss_ac_to_queue;
 
 	SET_IEEE80211_DEV(hw, &pdev->dev);
 
diff --git a/drivers/net/wireless/iwlegacy/common.h b/drivers/net/wireless/iwlegacy/common.h
index e0e4d01..e085131 100644
--- a/drivers/net/wireless/iwlegacy/common.h
+++ b/drivers/net/wireless/iwlegacy/common.h
@@ -1155,8 +1155,6 @@ struct il_force_reset {
 struct il_rxon_context {
 	struct ieee80211_vif *vif;
 
-	const u8 *ac_to_queue;
-
 	/*
 	 * We could use the vif to indicate active, but we
 	 * also need it to be active during disabling when
-- 
1.7.1


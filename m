Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:53616 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753963Ab2BCMIK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 3 Feb 2012 07:08:10 -0500
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org,
	Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [PATCH 10/25] iwlegacy: get rid of ctxid
Date: Fri,  3 Feb 2012 13:07:10 +0100
Message-Id: <1328270845-16891-11-git-send-email-sgruszka@redhat.com> (sfid-20120203_130851_117122_36BDE9F5)
In-Reply-To: <1328270845-16891-1-git-send-email-sgruszka@redhat.com>
References: <1328270845-16891-1-git-send-email-sgruszka@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/iwlegacy/3945-mac.c |    2 --
 drivers/net/wireless/iwlegacy/4965-mac.c |    2 --
 drivers/net/wireless/iwlegacy/common.c   |    6 ------
 drivers/net/wireless/iwlegacy/common.h   |    4 +---
 4 files changed, 1 insertions(+), 13 deletions(-)

diff --git a/drivers/net/wireless/iwlegacy/3945-mac.c b/drivers/net/wireless/iwlegacy/3945-mac.c
index 15dcafb..52cac0c 100644
--- a/drivers/net/wireless/iwlegacy/3945-mac.c
+++ b/drivers/net/wireless/iwlegacy/3945-mac.c
@@ -3617,8 +3617,6 @@ il3945_pci_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 
 	il->cmd_queue = IL39_CMD_QUEUE_NUM;
 
-	il->ctx.ctxid = 0;
-
 	il->ctx.interface_modes =
 	    BIT(NL80211_IFTYPE_STATION) | BIT(NL80211_IFTYPE_ADHOC);
 
diff --git a/drivers/net/wireless/iwlegacy/4965-mac.c b/drivers/net/wireless/iwlegacy/4965-mac.c
index 33725e1..3209970 100644
--- a/drivers/net/wireless/iwlegacy/4965-mac.c
+++ b/drivers/net/wireless/iwlegacy/4965-mac.c
@@ -6132,8 +6132,6 @@ il4965_pci_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	il = hw->priv;
 	/* At this point both hw and il are allocated. */
 
-	il->ctx.ctxid = 0;
-
 	il->ctx.always_active = true;
 	il->ctx.is_active = true;
 	il->ctx.ac_to_fifo = il4965_bss_ac_to_fifo;
diff --git a/drivers/net/wireless/iwlegacy/common.c b/drivers/net/wireless/iwlegacy/common.c
index 19ed867..7c7ea77 100644
--- a/drivers/net/wireless/iwlegacy/common.c
+++ b/drivers/net/wireless/iwlegacy/common.c
@@ -1951,7 +1951,6 @@ il_prep_station(struct il_priv *il, struct il_rxon_context *ctx,
 	station->sta.mode = 0;
 	station->sta.sta.sta_id = sta_id;
 	station->sta.station_flags = ctx->station_flags;
-	station->ctxid = ctx->ctxid;
 
 	if (sta) {
 		struct il_station_priv_common *sta_priv;
@@ -2191,9 +2190,6 @@ il_clear_ucode_stations(struct il_priv *il, struct il_rxon_context *ctx)
 
 	spin_lock_irqsave(&il->sta_lock, flags_spin);
 	for (i = 0; i < il->hw_params.max_stations; i++) {
-		if (ctx && ctx->ctxid != il->stations[i].ctxid)
-			continue;
-
 		if (il->stations[i].used & IL_STA_UCODE_ACTIVE) {
 			D_INFO("Clearing ucode active for station %d\n", i);
 			il->stations[i].used &= ~IL_STA_UCODE_ACTIVE;
@@ -2234,8 +2230,6 @@ il_restore_stations(struct il_priv *il, struct il_rxon_context *ctx)
 	D_ASSOC("Restoring all known stations ... start.\n");
 	spin_lock_irqsave(&il->sta_lock, flags_spin);
 	for (i = 0; i < il->hw_params.max_stations; i++) {
-		if (ctx->ctxid != il->stations[i].ctxid)
-			continue;
 		if ((il->stations[i].used & IL_STA_DRIVER_ACTIVE) &&
 		    !(il->stations[i].used & IL_STA_UCODE_ACTIVE)) {
 			D_ASSOC("Restoring sta %pM\n",
diff --git a/drivers/net/wireless/iwlegacy/common.h b/drivers/net/wireless/iwlegacy/common.h
index 8eac571..8df2286 100644
--- a/drivers/net/wireless/iwlegacy/common.h
+++ b/drivers/net/wireless/iwlegacy/common.h
@@ -735,7 +735,7 @@ struct il_qos_info {
 struct il_station_entry {
 	struct il_addsta_cmd sta;
 	struct il_tid_data tid[MAX_TID_COUNT];
-	u8 used, ctxid;
+	u8 used;
 	struct il_hw_key keyinfo;
 	struct il_link_quality_cmd *lq;
 };
@@ -1168,8 +1168,6 @@ struct il_rxon_context {
 
 	bool ht_need_multiple_chains;
 
-	int ctxid;
-
 	u32 interface_modes, exclusive_interface_modes;
 
 	struct il_qos_info qos_data;
-- 
1.7.1


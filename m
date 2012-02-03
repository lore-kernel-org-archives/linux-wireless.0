Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:27539 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756865Ab2BCQc6 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 3 Feb 2012 11:32:58 -0500
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org,
	Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [PATCH v2 10/25] iwlegacy: get rid of ctxid
Date: Fri,  3 Feb 2012 17:31:46 +0100
Message-Id: <1328286721-11309-11-git-send-email-sgruszka@redhat.com> (sfid-20120203_173314_968690_01E51EC5)
In-Reply-To: <1328286721-11309-1-git-send-email-sgruszka@redhat.com>
References: <1328286721-11309-1-git-send-email-sgruszka@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/iwlegacy/3945-mac.c |    2 --
 drivers/net/wireless/iwlegacy/4965-mac.c |    2 --
 drivers/net/wireless/iwlegacy/common.c   |    6 ------
 drivers/net/wireless/iwlegacy/common.h   |    4 +---
 drivers/net/wireless/iwlegacy/debug.c    |    1 -
 5 files changed, 1 insertions(+), 14 deletions(-)

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
diff --git a/drivers/net/wireless/iwlegacy/debug.c b/drivers/net/wireless/iwlegacy/debug.c
index 6e3841b..f3cb45e 100644
--- a/drivers/net/wireless/iwlegacy/debug.c
+++ b/drivers/net/wireless/iwlegacy/debug.c
@@ -649,7 +649,6 @@ il_dbgfs_qos_read(struct file *file, char __user *user_buf, size_t count,
 	char buf[256];
 	const size_t bufsz = sizeof(buf);
 
-	pos += scnprintf(buf + pos, bufsz - pos, "context %d:\n", ctx->ctxid);
 	for (i = 0; i < AC_NUM; i++) {
 		pos +=
 		    scnprintf(buf + pos, bufsz - pos,
-- 
1.7.1


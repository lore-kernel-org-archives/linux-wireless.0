Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:9331 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756865Ab2BCQct (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 3 Feb 2012 11:32:49 -0500
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org,
	Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [PATCH v2 09/25] iwlegacy: get rid of *_devtype
Date: Fri,  3 Feb 2012 17:31:45 +0100
Message-Id: <1328286721-11309-10-git-send-email-sgruszka@redhat.com> (sfid-20120203_173256_991729_942758E2)
In-Reply-To: <1328286721-11309-1-git-send-email-sgruszka@redhat.com>
References: <1328286721-11309-1-git-send-email-sgruszka@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/iwlegacy/3945-mac.c |    3 ---
 drivers/net/wireless/iwlegacy/4965-mac.c |    4 ----
 drivers/net/wireless/iwlegacy/common.c   |    6 +++---
 drivers/net/wireless/iwlegacy/common.h   |    1 -
 4 files changed, 3 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wireless/iwlegacy/3945-mac.c b/drivers/net/wireless/iwlegacy/3945-mac.c
index b11701f..15dcafb 100644
--- a/drivers/net/wireless/iwlegacy/3945-mac.c
+++ b/drivers/net/wireless/iwlegacy/3945-mac.c
@@ -3621,9 +3621,6 @@ il3945_pci_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 
 	il->ctx.interface_modes =
 	    BIT(NL80211_IFTYPE_STATION) | BIT(NL80211_IFTYPE_ADHOC);
-	il->ctx.ibss_devtype = RXON_DEV_TYPE_IBSS;
-	il->ctx.station_devtype = RXON_DEV_TYPE_ESS;
-	il->ctx.unused_devtype = RXON_DEV_TYPE_ESS;
 
 	/*
 	 * Disabling hardware scan means that mac80211 will perform scans
diff --git a/drivers/net/wireless/iwlegacy/4965-mac.c b/drivers/net/wireless/iwlegacy/4965-mac.c
index af78862..33725e1 100644
--- a/drivers/net/wireless/iwlegacy/4965-mac.c
+++ b/drivers/net/wireless/iwlegacy/4965-mac.c
@@ -6140,10 +6140,6 @@ il4965_pci_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	il->ctx.ac_to_queue = il4965_bss_ac_to_queue;
 	il->ctx.exclusive_interface_modes = BIT(NL80211_IFTYPE_ADHOC);
 	il->ctx.interface_modes = BIT(NL80211_IFTYPE_STATION);
-	il->ctx.ap_devtype = RXON_DEV_TYPE_AP;
-	il->ctx.ibss_devtype = RXON_DEV_TYPE_IBSS;
-	il->ctx.station_devtype = RXON_DEV_TYPE_ESS;
-	il->ctx.unused_devtype = RXON_DEV_TYPE_ESS;
 
 	SET_IEEE80211_DEV(hw, &pdev->dev);
 
diff --git a/drivers/net/wireless/iwlegacy/common.c b/drivers/net/wireless/iwlegacy/common.c
index b7567a8..19ed867 100644
--- a/drivers/net/wireless/iwlegacy/common.c
+++ b/drivers/net/wireless/iwlegacy/common.c
@@ -4002,17 +4002,17 @@ il_connection_init_rx_config(struct il_priv *il, struct il_rxon_context *ctx)
 	memset(&il->staging, 0, sizeof(il->staging));
 
 	if (!ctx->vif) {
-		il->staging.dev_type = ctx->unused_devtype;
+		il->staging.dev_type = RXON_DEV_TYPE_ESS;
 	} else
 		switch (ctx->vif->type) {
 
 		case NL80211_IFTYPE_STATION:
-			il->staging.dev_type = ctx->station_devtype;
+			il->staging.dev_type = RXON_DEV_TYPE_ESS;
 			il->staging.filter_flags = RXON_FILTER_ACCEPT_GRP_MSK;
 			break;
 
 		case NL80211_IFTYPE_ADHOC:
-			il->staging.dev_type = ctx->ibss_devtype;
+			il->staging.dev_type = RXON_DEV_TYPE_IBSS;
 			il->staging.flags = RXON_FLG_SHORT_PREAMBLE_MSK;
 			il->staging.filter_flags =
 			    RXON_FILTER_BCON_AWARE_MSK |
diff --git a/drivers/net/wireless/iwlegacy/common.h b/drivers/net/wireless/iwlegacy/common.h
index 66d0c1d..8eac571 100644
--- a/drivers/net/wireless/iwlegacy/common.h
+++ b/drivers/net/wireless/iwlegacy/common.h
@@ -1171,7 +1171,6 @@ struct il_rxon_context {
 	int ctxid;
 
 	u32 interface_modes, exclusive_interface_modes;
-	u8 unused_devtype, ap_devtype, ibss_devtype, station_devtype;
 
 	struct il_qos_info qos_data;
 
-- 
1.7.1


Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:3520 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756865Ab2BCQcx (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 3 Feb 2012 11:32:53 -0500
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org,
	Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [PATCH v2 07/25] iwlegacy: get rid of ap_sta_id
Date: Fri,  3 Feb 2012 17:31:43 +0100
Message-Id: <1328286721-11309-8-git-send-email-sgruszka@redhat.com> (sfid-20120203_173300_736058_BB085E1F)
In-Reply-To: <1328286721-11309-1-git-send-email-sgruszka@redhat.com>
References: <1328286721-11309-1-git-send-email-sgruszka@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/iwlegacy/3945-mac.c |    1 -
 drivers/net/wireless/iwlegacy/4965-mac.c |    3 +--
 drivers/net/wireless/iwlegacy/common.c   |    2 +-
 drivers/net/wireless/iwlegacy/common.h   |    2 +-
 4 files changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/iwlegacy/3945-mac.c b/drivers/net/wireless/iwlegacy/3945-mac.c
index 4a01acb..8072ae8 100644
--- a/drivers/net/wireless/iwlegacy/3945-mac.c
+++ b/drivers/net/wireless/iwlegacy/3945-mac.c
@@ -3619,7 +3619,6 @@ il3945_pci_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 
 	il->ctx.ctxid = 0;
 
-	il->ctx.ap_sta_id = IL_AP_ID;
 	il->ctx.interface_modes =
 	    BIT(NL80211_IFTYPE_STATION) | BIT(NL80211_IFTYPE_ADHOC);
 	il->ctx.ibss_devtype = RXON_DEV_TYPE_IBSS;
diff --git a/drivers/net/wireless/iwlegacy/4965-mac.c b/drivers/net/wireless/iwlegacy/4965-mac.c
index a2955a4..f2b03cd 100644
--- a/drivers/net/wireless/iwlegacy/4965-mac.c
+++ b/drivers/net/wireless/iwlegacy/4965-mac.c
@@ -2906,7 +2906,7 @@ il4965_set_default_wep_key(struct il_priv *il, struct il_rxon_context *ctx,
 
 	keyconf->flags &= ~IEEE80211_KEY_FLAG_GENERATE_IV;
 	keyconf->hw_key_idx = HW_KEY_DEFAULT;
-	il->stations[ctx->ap_sta_id].keyinfo.cipher = keyconf->cipher;
+	il->stations[IL_AP_ID].keyinfo.cipher = keyconf->cipher;
 
 	ctx->wep_keys[keyconf->keyidx].key_size = keyconf->keylen;
 	memcpy(&ctx->wep_keys[keyconf->keyidx].key, &keyconf->key,
@@ -6135,7 +6135,6 @@ il4965_pci_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 
 	il->ctx.always_active = true;
 	il->ctx.is_active = true;
-	il->ctx.ap_sta_id = IL_AP_ID;
 	il->ctx.ac_to_fifo = il4965_bss_ac_to_fifo;
 	il->ctx.ac_to_queue = il4965_bss_ac_to_queue;
 	il->ctx.exclusive_interface_modes = BIT(NL80211_IFTYPE_ADHOC);
diff --git a/drivers/net/wireless/iwlegacy/common.c b/drivers/net/wireless/iwlegacy/common.c
index b95f832..d30a206 100644
--- a/drivers/net/wireless/iwlegacy/common.c
+++ b/drivers/net/wireless/iwlegacy/common.c
@@ -1899,7 +1899,7 @@ il_prep_station(struct il_priv *il, struct il_rxon_context *ctx,
 	u16 rate;
 
 	if (is_ap)
-		sta_id = ctx->ap_sta_id;
+		sta_id = IL_AP_ID;
 	else if (is_broadcast_ether_addr(addr))
 		sta_id = ctx->bcast_sta_id;
 	else
diff --git a/drivers/net/wireless/iwlegacy/common.h b/drivers/net/wireless/iwlegacy/common.h
index 46835f9..cf7352f 100644
--- a/drivers/net/wireless/iwlegacy/common.h
+++ b/drivers/net/wireless/iwlegacy/common.h
@@ -1173,7 +1173,7 @@ struct il_rxon_context {
 
 	struct il_qos_info qos_data;
 
-	u8 bcast_sta_id, ap_sta_id;
+	u8 bcast_sta_id;
 
 	struct il_wep_key wep_keys[WEP_KEYS_MAX];
 	u8 key_mapping_keys;
-- 
1.7.1


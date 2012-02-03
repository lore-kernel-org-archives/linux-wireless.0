Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:19535 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756865Ab2BCQcr (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 3 Feb 2012 11:32:47 -0500
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org,
	Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [PATCH v2 06/25] iwlegacy: get rid of wep_key_cmd
Date: Fri,  3 Feb 2012 17:31:42 +0100
Message-Id: <1328286721-11309-7-git-send-email-sgruszka@redhat.com> (sfid-20120203_173249_472337_EA9C9D25)
In-Reply-To: <1328286721-11309-1-git-send-email-sgruszka@redhat.com>
References: <1328286721-11309-1-git-send-email-sgruszka@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/iwlegacy/3945-mac.c |    1 -
 drivers/net/wireless/iwlegacy/4965-mac.c |    3 +--
 drivers/net/wireless/iwlegacy/common.h   |    2 --
 3 files changed, 1 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/iwlegacy/3945-mac.c b/drivers/net/wireless/iwlegacy/3945-mac.c
index bbbac26..4a01acb 100644
--- a/drivers/net/wireless/iwlegacy/3945-mac.c
+++ b/drivers/net/wireless/iwlegacy/3945-mac.c
@@ -3620,7 +3620,6 @@ il3945_pci_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	il->ctx.ctxid = 0;
 
 	il->ctx.ap_sta_id = IL_AP_ID;
-	il->ctx.wep_key_cmd = C_WEPKEY;
 	il->ctx.interface_modes =
 	    BIT(NL80211_IFTYPE_STATION) | BIT(NL80211_IFTYPE_ADHOC);
 	il->ctx.ibss_devtype = RXON_DEV_TYPE_IBSS;
diff --git a/drivers/net/wireless/iwlegacy/4965-mac.c b/drivers/net/wireless/iwlegacy/4965-mac.c
index 2ee5de3..a2955a4 100644
--- a/drivers/net/wireless/iwlegacy/4965-mac.c
+++ b/drivers/net/wireless/iwlegacy/4965-mac.c
@@ -2823,7 +2823,7 @@ il4965_static_wepkey_cmd(struct il_priv *il, struct il_rxon_context *ctx,
 	struct il_wep_cmd *wep_cmd = (struct il_wep_cmd *)buff;
 	size_t cmd_size = sizeof(struct il_wep_cmd);
 	struct il_host_cmd cmd = {
-		.id = ctx->wep_key_cmd,
+		.id = C_WEPKEY,
 		.data = wep_cmd,
 		.flags = CMD_SYNC,
 	};
@@ -6136,7 +6136,6 @@ il4965_pci_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	il->ctx.always_active = true;
 	il->ctx.is_active = true;
 	il->ctx.ap_sta_id = IL_AP_ID;
-	il->ctx.wep_key_cmd = C_WEPKEY;
 	il->ctx.ac_to_fifo = il4965_bss_ac_to_fifo;
 	il->ctx.ac_to_queue = il4965_bss_ac_to_queue;
 	il->ctx.exclusive_interface_modes = BIT(NL80211_IFTYPE_ADHOC);
diff --git a/drivers/net/wireless/iwlegacy/common.h b/drivers/net/wireless/iwlegacy/common.h
index b08ddd1..46835f9 100644
--- a/drivers/net/wireless/iwlegacy/common.h
+++ b/drivers/net/wireless/iwlegacy/common.h
@@ -1175,8 +1175,6 @@ struct il_rxon_context {
 
 	u8 bcast_sta_id, ap_sta_id;
 
-	u8 wep_key_cmd;
-
 	struct il_wep_key wep_keys[WEP_KEYS_MAX];
 	u8 key_mapping_keys;
 
-- 
1.7.1


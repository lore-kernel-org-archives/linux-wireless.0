Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:3472 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753848Ab2BCMIH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 3 Feb 2012 07:08:07 -0500
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org,
	Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [PATCH 04/25] iwlegacy: get rid of C_RXON_ASSOC
Date: Fri,  3 Feb 2012 13:07:04 +0100
Message-Id: <1328270845-16891-5-git-send-email-sgruszka@redhat.com> (sfid-20120203_130815_998912_2D571FC0)
In-Reply-To: <1328270845-16891-1-git-send-email-sgruszka@redhat.com>
References: <1328270845-16891-1-git-send-email-sgruszka@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/iwlegacy/3945-mac.c |    1 -
 drivers/net/wireless/iwlegacy/4965-mac.c |    1 -
 drivers/net/wireless/iwlegacy/common.h   |    1 -
 3 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/iwlegacy/3945-mac.c b/drivers/net/wireless/iwlegacy/3945-mac.c
index 5ca8a78..e5857df 100644
--- a/drivers/net/wireless/iwlegacy/3945-mac.c
+++ b/drivers/net/wireless/iwlegacy/3945-mac.c
@@ -3619,7 +3619,6 @@ il3945_pci_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 
 	il->ctx.ctxid = 0;
 
-	il->ctx.rxon_assoc_cmd = C_RXON_ASSOC;
 	il->ctx.qos_cmd = C_QOS_PARAM;
 	il->ctx.ap_sta_id = IL_AP_ID;
 	il->ctx.wep_key_cmd = C_WEPKEY;
diff --git a/drivers/net/wireless/iwlegacy/4965-mac.c b/drivers/net/wireless/iwlegacy/4965-mac.c
index 9539acc..bd83299 100644
--- a/drivers/net/wireless/iwlegacy/4965-mac.c
+++ b/drivers/net/wireless/iwlegacy/4965-mac.c
@@ -6135,7 +6135,6 @@ il4965_pci_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 
 	il->ctx.always_active = true;
 	il->ctx.is_active = true;
-	il->ctx.rxon_assoc_cmd = C_RXON_ASSOC;
 	il->ctx.qos_cmd = C_QOS_PARAM;
 	il->ctx.ap_sta_id = IL_AP_ID;
 	il->ctx.wep_key_cmd = C_WEPKEY;
diff --git a/drivers/net/wireless/iwlegacy/common.h b/drivers/net/wireless/iwlegacy/common.h
index d1d5055..d8e309a 100644
--- a/drivers/net/wireless/iwlegacy/common.h
+++ b/drivers/net/wireless/iwlegacy/common.h
@@ -1175,7 +1175,6 @@ struct il_rxon_context {
 
 	u8 bcast_sta_id, ap_sta_id;
 
-	u8 rxon_assoc_cmd;
 	u8 qos_cmd;
 	u8 wep_key_cmd;
 
-- 
1.7.1


Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pw0-f46.google.com ([209.85.160.46]:57703 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752565Ab1EQHND (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 May 2011 03:13:03 -0400
Received: by pwi15 with SMTP id 15so151989pwi.19
        for <linux-wireless@vger.kernel.org>; Tue, 17 May 2011 00:13:02 -0700 (PDT)
From: Sujith <m.sujith@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <19922.8099.530894.947924@gargle.gargle.HOWL> (sfid-20110517_091306_788857_5114FDEA)
Date: Tue, 17 May 2011 12:41:31 +0530
To: linville@tuxdriver.com
CC: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org
Subject: [PATCH 2/8] ath9k_htc: Fix station flags
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <Sujith.Manoharan@atheros.com>

The FW does absolutely nothing with the station flags,
so remove them. But keep the field around since it might
come in handy in the future.

Signed-off-by: Sujith Manoharan <Sujith.Manoharan@atheros.com>
---
 drivers/net/wireless/ath/ath9k/htc.h          |    7 +------
 drivers/net/wireless/ath/ath9k/htc_drv_main.c |    3 ---
 2 files changed, 1 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/htc.h b/drivers/net/wireless/ath/ath9k/htc.h
index 5ec214c..29dfdf8 100644
--- a/drivers/net/wireless/ath/ath9k/htc.h
+++ b/drivers/net/wireless/ath/ath9k/htc.h
@@ -116,18 +116,13 @@ struct ath9k_htc_target_vif {
 	u8 pad;
 } __packed;
 
-#define ATH_HTC_STA_AUTH  0x0001
-#define ATH_HTC_STA_QOS   0x0002
-#define ATH_HTC_STA_ERP   0x0004
-#define ATH_HTC_STA_HT    0x0008
-
 struct ath9k_htc_target_sta {
 	u8 macaddr[ETH_ALEN];
 	u8 bssid[ETH_ALEN];
 	u8 sta_index;
 	u8 vif_index;
 	u8 is_vif_sta;
-	__be16 flags; /* ATH_HTC_STA_* */
+	__be16 flags;
 	__be16 htcap;
 	__be16 maxampdu;
 	u8 pad;
diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_main.c b/drivers/net/wireless/ath/ath9k/htc_drv_main.c
index 6065c2f..b1b8613 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_main.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_main.c
@@ -502,9 +502,6 @@ static int ath9k_htc_add_station(struct ath9k_htc_priv *priv,
 		tsta.maxampdu = cpu_to_be16(maxampdu);
 	}
 
-	if (sta && sta->ht_cap.ht_supported)
-		tsta.flags = cpu_to_be16(ATH_HTC_STA_HT);
-
 	WMI_CMD_BUF(WMI_NODE_CREATE_CMDID, &tsta);
 	if (ret) {
 		if (sta)
-- 
1.7.5.1


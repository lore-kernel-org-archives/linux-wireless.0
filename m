Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:58758 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1753644AbeD3NTW (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 30 Apr 2018 09:19:22 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id B598DEC013
        for <linux-wireless@vger.kernel.org>; Mon, 30 Apr 2018 13:19:21 +0000 (UTC)
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: linux-wireless@vger.kernel.org
Cc: Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [PATCH 1/2] rt2x00: call sta_add/remove directly in rt2800
Date: Mon, 30 Apr 2018 15:19:16 +0200
Message-Id: <1525094357-24782-1-git-send-email-sgruszka@redhat.com> (sfid-20180430_151928_441887_6939C876)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Only rt2800 subdriver of rt2x00 implement sta_add() and sta_remove(),
we do not need generic version of those.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/ralink/rt2x00/rt2800lib.c | 11 +++++++----
 drivers/net/wireless/ralink/rt2x00/rt2800lib.h |  5 +++--
 drivers/net/wireless/ralink/rt2x00/rt2800pci.c |  6 ++----
 drivers/net/wireless/ralink/rt2x00/rt2800soc.c |  6 ++----
 drivers/net/wireless/ralink/rt2x00/rt2800usb.c |  6 ++----
 drivers/net/wireless/ralink/rt2x00/rt2x00.h    |  4 ----
 6 files changed, 16 insertions(+), 22 deletions(-)

diff --git a/drivers/net/wireless/ralink/rt2x00/rt2800lib.c b/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
index e827dc522580..a567bc273ffc 100644
--- a/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
@@ -1557,12 +1557,13 @@ static void rt2800_set_max_psdu_len(struct rt2x00_dev *rt2x00dev)
 	rt2800_register_write(rt2x00dev, MAX_LEN_CFG, reg);
 }
 
-int rt2800_sta_add(struct rt2x00_dev *rt2x00dev, struct ieee80211_vif *vif,
+int rt2800_sta_add(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 		   struct ieee80211_sta *sta)
 {
-	int wcid;
-	struct rt2x00_sta *sta_priv = sta_to_rt2x00_sta(sta);
+	struct rt2x00_dev *rt2x00dev = hw->priv;
 	struct rt2800_drv_data *drv_data = rt2x00dev->drv_data;
+	struct rt2x00_sta *sta_priv = sta_to_rt2x00_sta(sta);
+	int wcid;
 
 	/*
 	 * Limit global maximum TX AMPDU length to smallest value of all
@@ -1608,8 +1609,10 @@ int rt2800_sta_add(struct rt2x00_dev *rt2x00dev, struct ieee80211_vif *vif,
 }
 EXPORT_SYMBOL_GPL(rt2800_sta_add);
 
-int rt2800_sta_remove(struct rt2x00_dev *rt2x00dev, struct ieee80211_sta *sta)
+int rt2800_sta_remove(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
+		      struct ieee80211_sta *sta)
 {
+	struct rt2x00_dev *rt2x00dev = hw->priv;
 	struct rt2800_drv_data *drv_data = rt2x00dev->drv_data;
 	struct rt2x00_sta *sta_priv = sta_to_rt2x00_sta(sta);
 	int wcid = sta_priv->wcid;
diff --git a/drivers/net/wireless/ralink/rt2x00/rt2800lib.h b/drivers/net/wireless/ralink/rt2x00/rt2800lib.h
index 275e3969abdd..51d9c2a932cc 100644
--- a/drivers/net/wireless/ralink/rt2x00/rt2800lib.h
+++ b/drivers/net/wireless/ralink/rt2x00/rt2800lib.h
@@ -208,9 +208,10 @@ int rt2800_config_shared_key(struct rt2x00_dev *rt2x00dev,
 int rt2800_config_pairwise_key(struct rt2x00_dev *rt2x00dev,
 			       struct rt2x00lib_crypto *crypto,
 			       struct ieee80211_key_conf *key);
-int rt2800_sta_add(struct rt2x00_dev *rt2x00dev, struct ieee80211_vif *vif,
+int rt2800_sta_add(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 		   struct ieee80211_sta *sta);
-int rt2800_sta_remove(struct rt2x00_dev *rt2x00dev, struct ieee80211_sta *sta);
+int rt2800_sta_remove(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
+		      struct ieee80211_sta *sta);
 void rt2800_config_filter(struct rt2x00_dev *rt2x00dev,
 			  const unsigned int filter_flags);
 void rt2800_config_intf(struct rt2x00_dev *rt2x00dev, struct rt2x00_intf *intf,
diff --git a/drivers/net/wireless/ralink/rt2x00/rt2800pci.c b/drivers/net/wireless/ralink/rt2x00/rt2800pci.c
index 1172eefd1c1a..71b1affc3885 100644
--- a/drivers/net/wireless/ralink/rt2x00/rt2800pci.c
+++ b/drivers/net/wireless/ralink/rt2x00/rt2800pci.c
@@ -311,8 +311,8 @@ static int rt2800pci_read_eeprom(struct rt2x00_dev *rt2x00dev)
 	.get_stats		= rt2x00mac_get_stats,
 	.get_key_seq		= rt2800_get_key_seq,
 	.set_rts_threshold	= rt2800_set_rts_threshold,
-	.sta_add		= rt2x00mac_sta_add,
-	.sta_remove		= rt2x00mac_sta_remove,
+	.sta_add		= rt2800_sta_add,
+	.sta_remove		= rt2800_sta_remove,
 	.bss_info_changed	= rt2x00mac_bss_info_changed,
 	.conf_tx		= rt2800_conf_tx,
 	.get_tsf		= rt2800_get_tsf,
@@ -377,8 +377,6 @@ static int rt2800pci_read_eeprom(struct rt2x00_dev *rt2x00dev)
 	.config_erp		= rt2800_config_erp,
 	.config_ant		= rt2800_config_ant,
 	.config			= rt2800_config,
-	.sta_add		= rt2800_sta_add,
-	.sta_remove		= rt2800_sta_remove,
 };
 
 static const struct rt2x00_ops rt2800pci_ops = {
diff --git a/drivers/net/wireless/ralink/rt2x00/rt2800soc.c b/drivers/net/wireless/ralink/rt2x00/rt2800soc.c
index 6848ebc83534..a502816214ab 100644
--- a/drivers/net/wireless/ralink/rt2x00/rt2800soc.c
+++ b/drivers/net/wireless/ralink/rt2x00/rt2800soc.c
@@ -150,8 +150,8 @@ static int rt2800soc_write_firmware(struct rt2x00_dev *rt2x00dev,
 	.get_stats		= rt2x00mac_get_stats,
 	.get_key_seq		= rt2800_get_key_seq,
 	.set_rts_threshold	= rt2800_set_rts_threshold,
-	.sta_add		= rt2x00mac_sta_add,
-	.sta_remove		= rt2x00mac_sta_remove,
+	.sta_add		= rt2800_sta_add,
+	.sta_remove		= rt2800_sta_remove,
 	.bss_info_changed	= rt2x00mac_bss_info_changed,
 	.conf_tx		= rt2800_conf_tx,
 	.get_tsf		= rt2800_get_tsf,
@@ -216,8 +216,6 @@ static int rt2800soc_write_firmware(struct rt2x00_dev *rt2x00dev,
 	.config_erp		= rt2800_config_erp,
 	.config_ant		= rt2800_config_ant,
 	.config			= rt2800_config,
-	.sta_add		= rt2800_sta_add,
-	.sta_remove		= rt2800_sta_remove,
 };
 
 static const struct rt2x00_ops rt2800soc_ops = {
diff --git a/drivers/net/wireless/ralink/rt2x00/rt2800usb.c b/drivers/net/wireless/ralink/rt2x00/rt2800usb.c
index d901a41d36e4..98a7313fea4a 100644
--- a/drivers/net/wireless/ralink/rt2x00/rt2800usb.c
+++ b/drivers/net/wireless/ralink/rt2x00/rt2800usb.c
@@ -797,8 +797,8 @@ static int rt2800usb_probe_hw(struct rt2x00_dev *rt2x00dev)
 	.get_stats		= rt2x00mac_get_stats,
 	.get_key_seq		= rt2800_get_key_seq,
 	.set_rts_threshold	= rt2800_set_rts_threshold,
-	.sta_add		= rt2x00mac_sta_add,
-	.sta_remove		= rt2x00mac_sta_remove,
+	.sta_add		= rt2800_sta_add,
+	.sta_remove		= rt2800_sta_remove,
 	.bss_info_changed	= rt2x00mac_bss_info_changed,
 	.conf_tx		= rt2800_conf_tx,
 	.get_tsf		= rt2800_get_tsf,
@@ -858,8 +858,6 @@ static int rt2800usb_probe_hw(struct rt2x00_dev *rt2x00dev)
 	.config_erp		= rt2800_config_erp,
 	.config_ant		= rt2800_config_ant,
 	.config			= rt2800_config,
-	.sta_add		= rt2800_sta_add,
-	.sta_remove		= rt2800_sta_remove,
 };
 
 static void rt2800usb_queue_init(struct data_queue *queue)
diff --git a/drivers/net/wireless/ralink/rt2x00/rt2x00.h b/drivers/net/wireless/ralink/rt2x00/rt2x00.h
index 1f38c338ca7a..a279a4363bc1 100644
--- a/drivers/net/wireless/ralink/rt2x00/rt2x00.h
+++ b/drivers/net/wireless/ralink/rt2x00/rt2x00.h
@@ -1457,10 +1457,6 @@ int rt2x00mac_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
 #else
 #define rt2x00mac_set_key	NULL
 #endif /* CONFIG_RT2X00_LIB_CRYPTO */
-int rt2x00mac_sta_add(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
-		      struct ieee80211_sta *sta);
-int rt2x00mac_sta_remove(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
-			 struct ieee80211_sta *sta);
 void rt2x00mac_sw_scan_start(struct ieee80211_hw *hw,
 			     struct ieee80211_vif *vif,
 			     const u8 *mac_addr);
-- 
1.9.3

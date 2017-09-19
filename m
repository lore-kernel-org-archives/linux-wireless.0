Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f52.google.com ([74.125.82.52]:44297 "EHLO
        mail-wm0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751374AbdISMd1 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 19 Sep 2017 08:33:27 -0400
Received: by mail-wm0-f52.google.com with SMTP id 189so18278971wmh.1
        for <linux-wireless@vger.kernel.org>; Tue, 19 Sep 2017 05:33:26 -0700 (PDT)
From: Loic Poulain <loic.poulain@linaro.org>
To: k.eugene.e@gmail.com, kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org, wcn36xx@lists.infradead.org,
        Loic Poulain <loic.poulain@linaro.org>
Subject: [PATCH] wcn36xx: Disable 5GHz for wcn3620
Date: Tue, 19 Sep 2017 14:33:23 +0200
Message-Id: <1505824403-26798-1-git-send-email-loic.poulain@linaro.org> (sfid-20170919_143330_943156_9DABCF36)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

wcn3620 can only operate on 2.4GHz band due to RF limitation.
If wcn36xx digital block is associated with an external IRIS
RF module, retrieve the id and disable 5GHz band in case of
wcn3620 id.

Signed-off-by: Loic Poulain <loic.poulain@linaro.org>
---
 drivers/net/wireless/ath/wcn36xx/main.c    | 12 +++++++++++-
 drivers/net/wireless/ath/wcn36xx/wcn36xx.h |  6 ++++++
 2 files changed, 17 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/wcn36xx/main.c b/drivers/net/wireless/ath/wcn36xx/main.c
index a9220b4..c3bc248 100644
--- a/drivers/net/wireless/ath/wcn36xx/main.c
+++ b/drivers/net/wireless/ath/wcn36xx/main.c
@@ -1089,7 +1089,8 @@ static int wcn36xx_init_ieee80211(struct wcn36xx *wcn)
 		BIT(NL80211_IFTYPE_MESH_POINT);
 
 	wcn->hw->wiphy->bands[NL80211_BAND_2GHZ] = &wcn_band_2ghz;
-	wcn->hw->wiphy->bands[NL80211_BAND_5GHZ] = &wcn_band_5ghz;
+	if (wcn->rf_id != RF_IRIS_WCN3620)
+		wcn->hw->wiphy->bands[NL80211_BAND_5GHZ] = &wcn_band_5ghz;
 
 	wcn->hw->wiphy->max_scan_ssids = WCN36XX_MAX_SCAN_SSIDS;
 	wcn->hw->wiphy->max_scan_ie_len = WCN36XX_MAX_SCAN_IE_LEN;
@@ -1119,6 +1120,7 @@ static int wcn36xx_platform_get_resources(struct wcn36xx *wcn,
 					  struct platform_device *pdev)
 {
 	struct device_node *mmio_node;
+	struct device_node *iris_node;
 	struct resource *res;
 	int index;
 	int ret;
@@ -1181,6 +1183,14 @@ static int wcn36xx_platform_get_resources(struct wcn36xx *wcn,
 		goto unmap_ccu;
 	}
 
+	/* External RF module */
+	iris_node = of_find_node_by_name(mmio_node, "iris");
+	if (iris_node) {
+		if (of_device_is_compatible(iris_node, "qcom,wcn3620"))
+			wcn->rf_id = RF_IRIS_WCN3620;
+		of_node_put(iris_node);
+	}
+
 	of_node_put(mmio_node);
 	return 0;
 
diff --git a/drivers/net/wireless/ath/wcn36xx/wcn36xx.h b/drivers/net/wireless/ath/wcn36xx/wcn36xx.h
index b52b4da9..0643477 100644
--- a/drivers/net/wireless/ath/wcn36xx/wcn36xx.h
+++ b/drivers/net/wireless/ath/wcn36xx/wcn36xx.h
@@ -94,6 +94,9 @@ enum wcn36xx_ampdu_state {
 #define WCN36XX_FLAGS(__wcn) (__wcn->hw->flags)
 #define WCN36XX_MAX_POWER(__wcn) (__wcn->hw->conf.chandef.chan->max_power)
 
+#define RF_UNKNOWN	0x0000
+#define RF_IRIS_WCN3620	0x3620
+
 static inline void buff_to_be(u32 *buf, size_t len)
 {
 	int i;
@@ -238,6 +241,9 @@ struct wcn36xx {
 
 	struct sk_buff		*tx_ack_skb;
 
+	/* RF module */
+	unsigned		rf_id;
+
 #ifdef CONFIG_WCN36XX_DEBUGFS
 	/* Debug file system entry */
 	struct wcn36xx_dfs_entry    dfs;
-- 
2.7.4

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wr1-f43.google.com ([209.85.221.43]:40496 "EHLO
        mail-wr1-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726909AbeIECZS (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 4 Sep 2018 22:25:18 -0400
Received: by mail-wr1-f43.google.com with SMTP id n2-v6so5492789wrw.7
        for <linux-wireless@vger.kernel.org>; Tue, 04 Sep 2018 14:58:13 -0700 (PDT)
From: =?UTF-8?q?Tomislav=20Po=C5=BEega?= <pozega.tomislav@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, ath9k-devel@qca.qualcomm.com
Subject: [PATCH v2 3/3] ath9k_htc: increase number of configurable virtual interfaces
Date: Tue,  4 Sep 2018 23:57:59 +0200
Message-Id: <1536098279-3268-3-git-send-email-pozega.tomislav@gmail.com> (sfid-20180904_235902_681838_276A3164)
In-Reply-To: <1536098279-3268-1-git-send-email-pozega.tomislav@gmail.com>
References: <1536098279-3268-1-git-send-email-pozega.tomislav@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Increase driver limit for various interface combinations.
I was able to start 8 virtual APs and connect 5 clients to
these.
New firmware will be sent to linux-firmware mailing list too.
Meanwhile, take a look here for changes it includes if you wish
to build it yourself:
https://github.com/qca/open-ath9k-htc-firmware/pull/149

Signed-off-by: Tomislav Požega <pozega.tomislav@gmail.com>
---
 drivers/net/wireless/ath/ath9k/hif_usb.c      |    4 ++--
 drivers/net/wireless/ath/ath9k/htc.h          |    8 ++++----
 drivers/net/wireless/ath/ath9k/htc_drv_init.c |    6 +++---
 3 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/hif_usb.c b/drivers/net/wireless/ath/ath9k/hif_usb.c
index fb649d8..fdcf224 100644
--- a/drivers/net/wireless/ath/ath9k/hif_usb.c
+++ b/drivers/net/wireless/ath/ath9k/hif_usb.c
@@ -1131,10 +1131,10 @@ static int ath9k_hif_request_firmware(struct hif_device_usb *hif_dev,
 
 		/* expected fw locations:
 		 * - ath9k_htc/htc_9271-1.dev.0.fw (development version)
-		 * - ath9k_htc/htc_9271-1.4.0.fw   (stable version)
+		 * - ath9k_htc/htc_9271-1.4.1.fw   (stable version)
 		 */
 		snprintf(hif_dev->fw_name, sizeof(hif_dev->fw_name),
-			 "%s/htc_%s-%d.%s.0.fw", HTC_FW_PATH,
+			 "%s/htc_%s-%d.%s.1.fw", HTC_FW_PATH,
 			 chip, MAJOR_VERSION_REQ, index);
 	}
 
diff --git a/drivers/net/wireless/ath/ath9k/htc.h b/drivers/net/wireless/ath/ath9k/htc.h
index 5490c5f..b6c577b 100644
--- a/drivers/net/wireless/ath/ath9k/htc.h
+++ b/drivers/net/wireless/ath/ath9k/htc.h
@@ -197,8 +197,8 @@ struct ath9k_htc_target_rx_stats {
 	__be32 host_done;
 } __packed;
 
-#define ATH9K_HTC_MAX_VIF 2
-#define ATH9K_HTC_MAX_BCN_VIF 2
+#define ATH9K_HTC_MAX_VIF 8
+#define ATH9K_HTC_MAX_BCN_VIF 8
 
 #define INC_VIF(_priv, _type) do {		\
 		switch (_type) {		\
@@ -251,8 +251,8 @@ struct ath9k_vif_iter_data {
 	u8 mask[ETH_ALEN];
 };
 
-#define ATH9K_HTC_MAX_STA 8
-#define ATH9K_HTC_MAX_TID 8
+#define ATH9K_HTC_MAX_STA 128
+#define ATH9K_HTC_MAX_TID 16
 
 enum tid_aggr_state {
 	AGGR_STOP = 0,
diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_init.c b/drivers/net/wireless/ath/ath9k/htc_drv_init.c
index 214c682..fa13ba9 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_init.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_init.c
@@ -697,9 +697,9 @@ static int ath9k_init_priv(struct ath9k_htc_priv *priv,
 }
 
 static const struct ieee80211_iface_limit if_limits[] = {
-	{ .max = 2,	.types = BIT(NL80211_IFTYPE_STATION) |
+	{ .max = 8,	.types = BIT(NL80211_IFTYPE_STATION) |
 				 BIT(NL80211_IFTYPE_P2P_CLIENT) },
-	{ .max = 2,	.types = BIT(NL80211_IFTYPE_AP) |
+	{ .max = 8,	.types = BIT(NL80211_IFTYPE_AP) |
 #ifdef CONFIG_MAC80211_MESH
 				 BIT(NL80211_IFTYPE_MESH_POINT) |
 #endif
@@ -709,7 +709,7 @@ static int ath9k_init_priv(struct ath9k_htc_priv *priv,
 static const struct ieee80211_iface_combination if_comb = {
 	.limits = if_limits,
 	.n_limits = ARRAY_SIZE(if_limits),
-	.max_interfaces = 2,
+	.max_interfaces = 8,
 	.num_different_channels = 1,
 };
 
-- 
1.7.0.4

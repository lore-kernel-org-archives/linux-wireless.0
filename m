Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wr1-f65.google.com ([209.85.221.65]:38613 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727465AbeICWMD (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 3 Sep 2018 18:12:03 -0400
Received: by mail-wr1-f65.google.com with SMTP id w11-v6so1434261wrc.5
        for <linux-wireless@vger.kernel.org>; Mon, 03 Sep 2018 10:50:48 -0700 (PDT)
From: =?UTF-8?q?Tomislav=20Po=C5=BEega?= <pozega.tomislav@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, ath9k-devel@qca.qualcomm.com,
        ath9k_htc_fw@lists.infradead.org
Subject: [PATCH 3/3] ath9k_htc: increase number of configurable virtual interfaces
Date: Mon,  3 Sep 2018 19:50:33 +0200
Message-Id: <1535997033-16330-3-git-send-email-pozega.tomislav@gmail.com> (sfid-20180903_195104_263232_E0602B42)
In-Reply-To: <1535997033-16330-1-git-send-email-pozega.tomislav@gmail.com>
References: <1535997033-16330-1-git-send-email-pozega.tomislav@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Increase driver limit for various interface combinations.
I was able to start 8 virtual APs and connect 5 clients to
these. Frimware support is required too, see:
https://github.com/qca/open-ath9k-htc-firmware/pull/149

Signed-off-by: Tomislav Požega <pozega.tomislav@gmail.com>
---
 drivers/net/wireless/ath/ath9k/htc.h          |    8 ++++----
 drivers/net/wireless/ath/ath9k/htc_drv_init.c |    6 +++---
 2 files changed, 7 insertions(+), 7 deletions(-)

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

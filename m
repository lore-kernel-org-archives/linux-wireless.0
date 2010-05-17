Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:10972 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753656Ab0EQGbA (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 May 2010 02:31:00 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Sun, 16 May 2010 23:31:00 -0700
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <19440.58038.38360.648206@gargle.gargle.HOWL>
Date: Mon, 17 May 2010 12:01:18 +0530
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH 3/5] ath9k_htc: Update HT configuration properly
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Use BSS_CHANGED_HT to handle HT parameter changes.
The rate information on the target has to be updated
to handle changes in HT configuration.

Signed-off-by: Sujith <Sujith.Manoharan@atheros.com>
---
 drivers/net/wireless/ath/ath9k/htc_drv_main.c |   30 +++++++++++++++++++++++++
 1 files changed, 30 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_main.c b/drivers/net/wireless/ath/ath9k/htc_drv_main.c
index fe5debf..80feeb3 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_main.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_main.c
@@ -409,6 +409,33 @@ static void ath9k_htc_init_rate(struct ath9k_htc_priv *priv,
 			  sta->addr, be32_to_cpu(trate.capflags));
 }
 
+static void ath9k_htc_update_rate(struct ath9k_htc_priv *priv,
+				  struct ieee80211_vif *vif,
+				  struct ieee80211_bss_conf *bss_conf)
+{
+	struct ath_common *common = ath9k_hw_common(priv->ah);
+	struct ath9k_htc_target_rate trate;
+	struct ieee80211_sta *sta;
+	int ret;
+
+	memset(&trate, 0, sizeof(struct ath9k_htc_target_rate));
+
+	rcu_read_lock();
+	sta = ieee80211_find_sta(vif, bss_conf->bssid);
+	if (!sta) {
+		rcu_read_unlock();
+		return;
+	}
+	ath9k_htc_setup_rate(priv, sta, &trate);
+	rcu_read_unlock();
+
+	ret = ath9k_htc_send_rate_cmd(priv, &trate);
+	if (!ret)
+		ath_print(common, ATH_DBG_CONFIG,
+			  "Updated target sta: %pM, rate caps: 0x%X\n",
+			  bss_conf->bssid, be32_to_cpu(trate.capflags));
+}
+
 static int ath9k_htc_aggr_oper(struct ath9k_htc_priv *priv,
 			       struct ieee80211_vif *vif,
 			       u8 *sta_addr, u8 tid, bool oper)
@@ -1595,6 +1622,9 @@ static void ath9k_htc_bss_info_changed(struct ieee80211_hw *hw,
 		ath9k_hw_init_global_settings(ah);
 	}
 
+	if (changed & BSS_CHANGED_HT)
+		ath9k_htc_update_rate(priv, vif, bss_conf);
+
 	ath9k_htc_ps_restore(priv);
 	mutex_unlock(&priv->mutex);
 }
-- 
1.7.1


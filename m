Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from contumacia.investici.org ([178.255.144.35]:48265 "EHLO
	contumacia.investici.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750852Ab2HLRgu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 12 Aug 2012 13:36:50 -0400
From: Antonio Quartulli <ordex@autistici.org>
To: "Luis R. Rodriguez" <mcgrof@qca.qualcomm.com>,
	Sujith Manoharan <c_manoha@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org,
	Antonio Quartulli <ordex@autistici.org>
Subject: [PATCH] ath9k_htc: implement sta_rc_update() mac80211 callback
Date: Sun, 12 Aug 2012 19:36:41 +0200
Message-Id: <1344793001-27085-1-git-send-email-ordex@autistici.org> (sfid-20120812_193654_245030_C033F2D0)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In case of changes in the supported rates set for a given station, it is now
possible to use this callback to update the current internal state of the
station in the htc driver.

Reported-by: Gui Iribarren <gui@altermundi.net>
Signed-off-by: Antonio Quartulli <ordex@autistici.org>
---
 drivers/net/wireless/ath/ath9k/htc_drv_main.c |   29 +++++++++++++++++++++++++
 1 file changed, 29 insertions(+)

diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_main.c b/drivers/net/wireless/ath/ath9k/htc_drv_main.c
index c785129..2658d0a 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_main.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_main.c
@@ -1331,6 +1331,34 @@ static int ath9k_htc_sta_remove(struct ieee80211_hw *hw,
 	return ret;
 }
 
+static void ath9k_htc_sta_rc_update(struct ieee80211_hw *hw,
+				    struct ieee80211_vif *vif,
+				    struct ieee80211_sta *sta, u32 changed)
+{
+	struct ath9k_htc_priv *priv = hw->priv;
+	struct ath_common *common = ath9k_hw_common(priv->ah);
+	struct ath9k_htc_target_rate trate;
+
+	mutex_lock(&priv->mutex);
+	ath9k_htc_ps_wakeup(priv);
+
+	if (changed & IEEE80211_RC_SUPP_RATES_CHANGED) {
+		memset(&trate, 0, sizeof(struct ath9k_htc_target_rate));
+		ath9k_htc_setup_rate(priv, sta, &trate);
+		if (!ath9k_htc_send_rate_cmd(priv, &trate))
+			ath_dbg(common, CONFIG,
+				"Supported rates for sta: %pM updated, rate caps: 0x%X\n",
+				sta->addr, be32_to_cpu(trate.capflags));
+		else
+			ath_dbg(common, CONFIG,
+				"Unable to update supported rates for sta: %pM\n",
+				sta->addr);
+	}
+
+	ath9k_htc_ps_restore(priv);
+	mutex_unlock(&priv->mutex);
+}
+
 static int ath9k_htc_conf_tx(struct ieee80211_hw *hw,
 			     struct ieee80211_vif *vif, u16 queue,
 			     const struct ieee80211_tx_queue_params *params)
@@ -1758,6 +1786,7 @@ struct ieee80211_ops ath9k_htc_ops = {
 	.sta_add            = ath9k_htc_sta_add,
 	.sta_remove         = ath9k_htc_sta_remove,
 	.conf_tx            = ath9k_htc_conf_tx,
+	.sta_rc_update      = ath9k_htc_sta_rc_update,
 	.bss_info_changed   = ath9k_htc_bss_info_changed,
 	.set_key            = ath9k_htc_set_key,
 	.get_tsf            = ath9k_htc_get_tsf,
-- 
1.7.9.4


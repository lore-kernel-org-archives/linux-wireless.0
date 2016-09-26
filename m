Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f67.google.com ([209.85.220.67]:34519 "EHLO
        mail-pa0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754994AbcIZKhe (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 26 Sep 2016 06:37:34 -0400
Received: by mail-pa0-f67.google.com with SMTP id hm5so1536538pac.1
        for <linux-wireless@vger.kernel.org>; Mon, 26 Sep 2016 03:37:34 -0700 (PDT)
From: Prameela Rani Garnepudi <prameela.j04cs@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, johannes.berg@intel.com, hofrat@osadl.org,
        xypron.glpk@gmx.de, prameela.garnepudi@redpinesignals.com,
        Prameela Rani Garnepudi <prameela.j04cs@gmail.com>
Subject: [PATCH] rsi: update in vap_capabilities frame to device
Date: Mon, 26 Sep 2016 16:03:01 +0530
Message-Id: <1474885981-6810-1-git-send-email-prameela.j04cs@gmail.com> (sfid-20160926_123738_774496_B83640F4)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

added vap status(add/delete) field in vap capabilities frame to device
added sending vap capabilites frame(with vap status 'delete') in remove interface

Signed-off-by: Prameela Rani Garnepudi <prameela.j04cs@gmail.com>
---
 drivers/net/wireless/rsi/rsi_91x_mac80211.c | 12 ++++++++----
 drivers/net/wireless/rsi/rsi_91x_mgmt.c     |  8 ++++++--
 drivers/net/wireless/rsi/rsi_mgmt.h         |  9 ++++++++-
 3 files changed, 22 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/rsi/rsi_91x_mac80211.c b/drivers/net/wireless/rsi/rsi_91x_mac80211.c
index dbb2389..d5b17b1 100644
--- a/drivers/net/wireless/rsi/rsi_91x_mac80211.c
+++ b/drivers/net/wireless/rsi/rsi_91x_mac80211.c
@@ -304,13 +304,15 @@ static int rsi_mac80211_add_interface(struct ieee80211_hw *hw,
 		if (!adapter->sc_nvifs) {
 			++adapter->sc_nvifs;
 			adapter->vifs[0] = vif;
-			ret = rsi_set_vap_capabilities(common, STA_OPMODE);
+			ret = rsi_set_vap_capabilities(common,
+						       STA_OPMODE,
+						       VAP_ADD);
 		}
 		break;
 	default:
 		rsi_dbg(ERR_ZONE,
-			"%s: Interface type %d not supported\n", __func__,
-			vif->type);
+			"%s: Interface type %d not supported\n",
+			__func__, vif->type);
 	}
 	mutex_unlock(&common->mutex);
 
@@ -332,8 +334,10 @@ static void rsi_mac80211_remove_interface(struct ieee80211_hw *hw,
 	struct rsi_common *common = adapter->priv;
 
 	mutex_lock(&common->mutex);
-	if (vif->type == NL80211_IFTYPE_STATION)
+	if (vif->type == NL80211_IFTYPE_STATION) {
 		adapter->sc_nvifs--;
+		rsi_set_vap_capabilities(common, STA_OPMODE, VAP_DELETE);
+	}
 
 	if (!memcmp(adapter->vifs[0], vif, sizeof(struct ieee80211_vif)))
 		adapter->vifs[0] = NULL;
diff --git a/drivers/net/wireless/rsi/rsi_91x_mgmt.c b/drivers/net/wireless/rsi/rsi_91x_mgmt.c
index 35c14cc..c41bb4f 100644
--- a/drivers/net/wireless/rsi/rsi_91x_mgmt.c
+++ b/drivers/net/wireless/rsi/rsi_91x_mgmt.c
@@ -617,7 +617,9 @@ static int rsi_program_bb_rf(struct rsi_common *common)
  *
  * Return: 0 on success, corresponding negative error code on failure.
  */
-int rsi_set_vap_capabilities(struct rsi_common *common, enum opmode mode)
+int rsi_set_vap_capabilities(struct rsi_common *common,
+			     enum opmode mode,
+			     u8 vap_status)
 {
 	struct sk_buff *skb = NULL;
 	struct rsi_vap_caps *vap_caps;
@@ -626,7 +628,8 @@ int rsi_set_vap_capabilities(struct rsi_common *common, enum opmode mode)
 	struct ieee80211_conf *conf = &hw->conf;
 	u16 vap_id = 0;
 
-	rsi_dbg(MGMT_TX_ZONE, "%s: Sending VAP capabilities frame\n", __func__);
+	rsi_dbg(MGMT_TX_ZONE,
+		"%s: Sending VAP capabilities frame\n", __func__);
 
 	skb = dev_alloc_skb(sizeof(struct rsi_vap_caps));
 	if (!skb) {
@@ -642,6 +645,7 @@ int rsi_set_vap_capabilities(struct rsi_common *common, enum opmode mode)
 					     FRAME_DESC_SZ) |
 					     (RSI_WIFI_MGMT_Q << 12));
 	vap_caps->desc_word[1] = cpu_to_le16(VAP_CAPABILITIES);
+	vap_caps->desc_word[2] = cpu_to_le16(vap_status << 8);
 	vap_caps->desc_word[4] = cpu_to_le16(mode |
 					     (common->channel_width << 8));
 	vap_caps->desc_word[7] = cpu_to_le16((vap_id << 8) |
diff --git a/drivers/net/wireless/rsi/rsi_mgmt.h b/drivers/net/wireless/rsi/rsi_mgmt.h
index 3741173..d155358 100644
--- a/drivers/net/wireless/rsi/rsi_mgmt.h
+++ b/drivers/net/wireless/rsi/rsi_mgmt.h
@@ -145,6 +145,12 @@ enum opmode {
 	AP_OPMODE = 2
 };
 
+enum vap_status {
+	VAP_ADD = 1,
+	VAP_DELETE = 2,
+	VAP_UPDATE = 3
+};
+
 extern struct ieee80211_rate rsi_rates[12];
 extern const u16 rsi_mcsrates[8];
 
@@ -287,7 +293,8 @@ static inline u8 rsi_get_channel(u8 *addr)
 }
 
 int rsi_mgmt_pkt_recv(struct rsi_common *common, u8 *msg);
-int rsi_set_vap_capabilities(struct rsi_common *common, enum opmode mode);
+int rsi_set_vap_capabilities(struct rsi_common *common, enum opmode mode,
+			     u8 vap_status);
 int rsi_send_aggregation_params_frame(struct rsi_common *common, u16 tid,
 				      u16 ssn, u8 buf_size, u8 event);
 int rsi_hal_load_key(struct rsi_common *common, u8 *data, u16 key_len,
-- 
2.4.11

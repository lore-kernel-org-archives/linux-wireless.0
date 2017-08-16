Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f196.google.com ([209.85.192.196]:36460 "EHLO
        mail-pf0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751605AbdHPNRt (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 16 Aug 2017 09:17:49 -0400
Received: by mail-pf0-f196.google.com with SMTP id t83so1362761pfj.3
        for <linux-wireless@vger.kernel.org>; Wed, 16 Aug 2017 06:17:49 -0700 (PDT)
From: Amitkumar Karwar <amitkarwar@gmail.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org,
        Amitkumar Karwar <amit.karwar@redpinesignals.com>,
        Prameela Rani Garnepudi <prameela.j04cs@gmail.com>
Subject: [v2 02/11] rsi: add interface changes for ap mode
Date: Wed, 16 Aug 2017 18:43:09 +0530
Message-Id: <1502889198-4478-3-git-send-email-amitkarwar@gmail.com> (sfid-20170816_151752_090808_8F8ADC0E)
In-Reply-To: <1502889198-4478-1-git-send-email-amitkarwar@gmail.com>
References: <1502889198-4478-1-git-send-email-amitkarwar@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Prameela Rani Garnepudi <prameela.j04cs@gmail.com>

AP mode is handled in add_interface callback of mac80211.
Also for AP mode, sending rx filter frame to disallow beacons
to host is added. Station structures are initialized to NULL.

Signed-off-by: Prameela Rani Garnepudi <prameela.j04cs@gmail.com>
Signed-off-by: Amitkumar Karwar <amit.karwar@redpinesignals.com>
---
 drivers/net/wireless/rsi/rsi_91x_mac80211.c | 43 +++++++++++++++++++++++------
 drivers/net/wireless/rsi/rsi_91x_mgmt.c     |  5 ++--
 drivers/net/wireless/rsi/rsi_main.h         |  3 ++
 drivers/net/wireless/rsi/rsi_mgmt.h         |  6 ++--
 4 files changed, 44 insertions(+), 13 deletions(-)

diff --git a/drivers/net/wireless/rsi/rsi_91x_mac80211.c b/drivers/net/wireless/rsi/rsi_91x_mac80211.c
index 2da5493..edcba56 100644
--- a/drivers/net/wireless/rsi/rsi_91x_mac80211.c
+++ b/drivers/net/wireless/rsi/rsi_91x_mac80211.c
@@ -342,25 +342,51 @@ static int rsi_mac80211_add_interface(struct ieee80211_hw *hw,
 {
 	struct rsi_hw *adapter = hw->priv;
 	struct rsi_common *common = adapter->priv;
+	enum opmode intf_mode;
 	int ret = -EOPNOTSUPP;
 
 	vif->driver_flags |= IEEE80211_VIF_SUPPORTS_UAPSD;
 	mutex_lock(&common->mutex);
+
+	if (adapter->sc_nvifs > 1) {
+		mutex_unlock(&common->mutex);
+		return -EOPNOTSUPP;
+	}
+
 	switch (vif->type) {
 	case NL80211_IFTYPE_STATION:
-		if (!adapter->sc_nvifs) {
-			++adapter->sc_nvifs;
-			adapter->vifs[0] = vif;
-			ret = rsi_set_vap_capabilities(common,
-						       STA_OPMODE,
-						       VAP_ADD);
-		}
+		rsi_dbg(INFO_ZONE, "Station Mode");
+		intf_mode = STA_OPMODE;
+		break;
+	case NL80211_IFTYPE_AP:
+		rsi_dbg(INFO_ZONE, "AP Mode");
+		intf_mode = AP_OPMODE;
 		break;
 	default:
 		rsi_dbg(ERR_ZONE,
 			"%s: Interface type %d not supported\n", __func__,
 			vif->type);
+		goto out;
 	}
+
+	adapter->vifs[adapter->sc_nvifs++] = vif;
+	ret = rsi_set_vap_capabilities(common, intf_mode, common->mac_addr,
+				       0, VAP_ADD);
+	if (ret) {
+		rsi_dbg(ERR_ZONE, "Failed to set VAP capabilities\n");
+		goto out;
+	}
+
+	if (vif->type == NL80211_IFTYPE_AP) {
+		int i;
+
+		rsi_send_rx_filter_frame(common, DISALLOW_BEACONS);
+		common->min_rate = RSI_RATE_AUTO;
+		for (i = 0; i < common->max_stations; i++)
+			common->stations[i].sta = NULL;
+	}
+
+out:
 	mutex_unlock(&common->mutex);
 
 	return ret;
@@ -383,7 +409,8 @@ static void rsi_mac80211_remove_interface(struct ieee80211_hw *hw,
 	mutex_lock(&common->mutex);
 	if (vif->type == NL80211_IFTYPE_STATION) {
 		adapter->sc_nvifs--;
-		rsi_set_vap_capabilities(common, STA_OPMODE, VAP_DELETE);
+		rsi_set_vap_capabilities(common, STA_OPMODE, vif->addr,
+					 0, VAP_DELETE);
 	}
 
 	if (!memcmp(adapter->vifs[0], vif, sizeof(struct ieee80211_vif)))
diff --git a/drivers/net/wireless/rsi/rsi_91x_mgmt.c b/drivers/net/wireless/rsi/rsi_91x_mgmt.c
index f93499d0..233a418 100644
--- a/drivers/net/wireless/rsi/rsi_91x_mgmt.c
+++ b/drivers/net/wireless/rsi/rsi_91x_mgmt.c
@@ -624,6 +624,8 @@ static int rsi_program_bb_rf(struct rsi_common *common)
  */
 int rsi_set_vap_capabilities(struct rsi_common *common,
 			     enum opmode mode,
+			     u8 *mac_addr,
+			     u8 vap_id,
 			     u8 vap_status)
 {
 	struct sk_buff *skb = NULL;
@@ -632,7 +634,6 @@ int rsi_set_vap_capabilities(struct rsi_common *common,
 	struct ieee80211_hw *hw = adapter->hw;
 	struct ieee80211_conf *conf = &hw->conf;
 	u16 frame_len = sizeof(struct rsi_vap_caps);
-	u16 vap_id = 0;
 
 	rsi_dbg(MGMT_TX_ZONE, "%s: Sending VAP capabilities frame\n", __func__);
 
@@ -656,7 +657,7 @@ int rsi_set_vap_capabilities(struct rsi_common *common,
 	vap_caps->radioid_macid = ((common->mac_id & 0xf) << 4) |
 				   (common->radio_id & 0xf);
 
-	memcpy(vap_caps->mac_addr, common->mac_addr, IEEE80211_ADDR_LEN);
+	memcpy(vap_caps->mac_addr, mac_addr, IEEE80211_ADDR_LEN);
 	vap_caps->keep_alive_period = cpu_to_le16(90);
 	vap_caps->frag_threshold = cpu_to_le16(IEEE80211_MAX_FRAG_THRESHOLD);
 
diff --git a/drivers/net/wireless/rsi/rsi_main.h b/drivers/net/wireless/rsi/rsi_main.h
index 0077888..9f5f33f 100644
--- a/drivers/net/wireless/rsi/rsi_main.h
+++ b/drivers/net/wireless/rsi/rsi_main.h
@@ -90,6 +90,7 @@ extern __printf(2, 3) void rsi_dbg(u32 zone, const char *fmt, ...);
 #define IEEE80211_MGMT_FRAME            0x00
 #define IEEE80211_CTL_FRAME             0x04
 
+#define RSI_MAX_ASSOC_STAS		32
 #define IEEE80211_QOS_TID               0x0f
 #define IEEE80211_NONQOS_TID            16
 
@@ -262,6 +263,8 @@ struct rsi_common {
 	u8 dtim_cnt;
 
 	/* AP mode parameters */
+	struct rsi_sta stations[RSI_MAX_ASSOC_STAS + 1];
+	int num_stations;
 	int max_stations;
 };
 
diff --git a/drivers/net/wireless/rsi/rsi_mgmt.h b/drivers/net/wireless/rsi/rsi_mgmt.h
index 201a465..9093ba6 100644
--- a/drivers/net/wireless/rsi/rsi_mgmt.h
+++ b/drivers/net/wireless/rsi/rsi_mgmt.h
@@ -188,8 +188,8 @@
 	 IEEE80211_WMM_IE_STA_QOSINFO_AC_BK)
 
 enum opmode {
-	STA_OPMODE = 1,
-	AP_OPMODE = 2
+	AP_OPMODE = 0,
+	STA_OPMODE,
 };
 
 enum vap_status {
@@ -591,7 +591,7 @@ static inline void rsi_set_len_qno(__le16 *addr, u16 len, u8 qno)
 
 int rsi_mgmt_pkt_recv(struct rsi_common *common, u8 *msg);
 int rsi_set_vap_capabilities(struct rsi_common *common, enum opmode mode,
-			     u8 vap_status);
+			     u8 *mac_addr, u8 vap_id, u8 vap_status);
 int rsi_send_aggregation_params_frame(struct rsi_common *common, u16 tid,
 				      u16 ssn, u8 buf_size, u8 event);
 int rsi_hal_load_key(struct rsi_common *common, u8 *data, u16 key_len,
-- 
2.7.4

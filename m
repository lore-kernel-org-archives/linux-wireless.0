Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-cys01nam02on0041.outbound.protection.outlook.com ([104.47.37.41]:61440
        "EHLO NAM02-CY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1754347AbdHYCau (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 24 Aug 2017 22:30:50 -0400
From: igor.mitsyanko.os@quantenna.com
To: linux-wireless@vger.kernel.org
Cc: sergey.matyukevich.os@quantenna.com, avinashp@quantenna.com,
        johannes@sipsolutions.net,
        Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>
Subject: [PATCH 04/27] qtnfmac: do not cache AP settings in driver structures
Date: Thu, 24 Aug 2017 19:30:01 -0700
Message-Id: <20170825023024.10565-5-igor.mitsyanko.os@quantenna.com> (sfid-20170825_043145_576867_BAE31CAC)
In-Reply-To: <20170825023024.10565-1-igor.mitsyanko.os@quantenna.com>
References: <20170825023024.10565-1-igor.mitsyanko.os@quantenna.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>

Cached AP setings are passed to WiFi card right away and never used.

Signed-off-by: Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>
---
 drivers/net/wireless/quantenna/qtnfmac/cfg80211.c | 17 +--------
 drivers/net/wireless/quantenna/qtnfmac/commands.c | 46 +++++++++++------------
 drivers/net/wireless/quantenna/qtnfmac/commands.h |  3 +-
 3 files changed, 25 insertions(+), 41 deletions(-)

diff --git a/drivers/net/wireless/quantenna/qtnfmac/cfg80211.c b/drivers/net/wireless/quantenna/qtnfmac/cfg80211.c
index 8bfe61d..f6eb681 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/cfg80211.c
+++ b/drivers/net/wireless/quantenna/qtnfmac/cfg80211.c
@@ -267,7 +267,6 @@ static int qtnf_start_ap(struct wiphy *wiphy, struct net_device *dev,
 {
 	struct qtnf_vif *vif = qtnf_netdev_get_priv(dev);
 	struct qtnf_wmac *mac = wiphy_priv(wiphy);
-	struct qtnf_bss_config *bss_cfg;
 	int ret;
 
 	if (!cfg80211_chandef_identical(&mac->chandef, &settings->chandef)) {
@@ -278,21 +277,7 @@ static int qtnf_start_ap(struct wiphy *wiphy, struct net_device *dev,
 				settings->chandef.chan->center_freq);
 	}
 
-	bss_cfg = &vif->bss_cfg;
-	memset(bss_cfg, 0, sizeof(*bss_cfg));
-
-	bss_cfg->bcn_period = settings->beacon_interval;
-	bss_cfg->dtim = settings->dtim_period;
-	bss_cfg->auth_type = settings->auth_type;
-	bss_cfg->privacy = settings->privacy;
-
-	bss_cfg->ssid_len = settings->ssid_len;
-	memcpy(&bss_cfg->ssid, settings->ssid, bss_cfg->ssid_len);
-
-	memcpy(&bss_cfg->crypto, &settings->crypto,
-	       sizeof(struct cfg80211_crypto_settings));
-
-	ret = qtnf_cmd_send_config_ap(vif);
+	ret = qtnf_cmd_send_config_ap(vif, settings);
 	if (ret) {
 		pr_err("VIF%u.%u: failed to push config to FW\n",
 		       vif->mac->macid, vif->vifid);
diff --git a/drivers/net/wireless/quantenna/qtnfmac/commands.c b/drivers/net/wireless/quantenna/qtnfmac/commands.c
index 806b88b..b498019 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/commands.c
+++ b/drivers/net/wireless/quantenna/qtnfmac/commands.c
@@ -181,10 +181,10 @@ int qtnf_cmd_send_start_ap(struct qtnf_vif *vif)
 	return ret;
 }
 
-int qtnf_cmd_send_config_ap(struct qtnf_vif *vif)
+int qtnf_cmd_send_config_ap(struct qtnf_vif *vif,
+			    const struct cfg80211_ap_settings *s)
 {
 	struct sk_buff *cmd_skb;
-	struct qtnf_bss_config *bss_cfg = &vif->bss_cfg;
 	struct cfg80211_chan_def *chandef = &vif->mac->chandef;
 	struct qlink_tlv_channel *qchan;
 	struct qlink_auth_encr aen;
@@ -200,11 +200,13 @@ int qtnf_cmd_send_config_ap(struct qtnf_vif *vif)
 
 	qtnf_bus_lock(vif->mac->bus);
 
-	qtnf_cmd_skb_put_tlv_arr(cmd_skb, WLAN_EID_SSID, bss_cfg->ssid,
-				 bss_cfg->ssid_len);
+	if (s->ssid && s->ssid_len > 0 && s->ssid_len <= IEEE80211_MAX_SSID_LEN)
+		qtnf_cmd_skb_put_tlv_arr(cmd_skb, WLAN_EID_SSID, s->ssid,
+					 s->ssid_len);
+
 	qtnf_cmd_skb_put_tlv_u16(cmd_skb, QTN_TLV_ID_BCN_PERIOD,
-				 bss_cfg->bcn_period);
-	qtnf_cmd_skb_put_tlv_u8(cmd_skb, QTN_TLV_ID_DTIM, bss_cfg->dtim);
+				 s->beacon_interval);
+	qtnf_cmd_skb_put_tlv_u8(cmd_skb, QTN_TLV_ID_DTIM, s->dtim_period);
 
 	qchan = skb_put_zero(cmd_skb, sizeof(*qchan));
 	qchan->hdr.type = cpu_to_le16(QTN_TLV_ID_CHANNEL);
@@ -214,26 +216,22 @@ int qtnf_cmd_send_config_ap(struct qtnf_vif *vif)
 		ieee80211_frequency_to_channel(chandef->chan->center_freq));
 
 	memset(&aen, 0, sizeof(aen));
-	aen.auth_type = bss_cfg->auth_type;
-	aen.privacy = !!bss_cfg->privacy;
-	aen.mfp = bss_cfg->mfp;
-	aen.wpa_versions = cpu_to_le32(bss_cfg->crypto.wpa_versions);
-	aen.cipher_group = cpu_to_le32(bss_cfg->crypto.cipher_group);
-	aen.n_ciphers_pairwise = cpu_to_le32(
-					bss_cfg->crypto.n_ciphers_pairwise);
+	aen.auth_type = s->auth_type;
+	aen.privacy = !!s->privacy;
+	aen.mfp = 0;
+	aen.wpa_versions = cpu_to_le32(s->crypto.wpa_versions);
+	aen.cipher_group = cpu_to_le32(s->crypto.cipher_group);
+	aen.n_ciphers_pairwise = cpu_to_le32(s->crypto.n_ciphers_pairwise);
 	for (i = 0; i < QLINK_MAX_NR_CIPHER_SUITES; i++)
-		aen.ciphers_pairwise[i] = cpu_to_le32(
-					bss_cfg->crypto.ciphers_pairwise[i]);
-	aen.n_akm_suites = cpu_to_le32(
-					bss_cfg->crypto.n_akm_suites);
+		aen.ciphers_pairwise[i] =
+			cpu_to_le32(s->crypto.ciphers_pairwise[i]);
+	aen.n_akm_suites = cpu_to_le32(s->crypto.n_akm_suites);
 	for (i = 0; i < QLINK_MAX_NR_AKM_SUITES; i++)
-		aen.akm_suites[i] = cpu_to_le32(
-					bss_cfg->crypto.akm_suites[i]);
-	aen.control_port = bss_cfg->crypto.control_port;
-	aen.control_port_no_encrypt =
-			bss_cfg->crypto.control_port_no_encrypt;
-	aen.control_port_ethertype = cpu_to_le16(be16_to_cpu(
-				bss_cfg->crypto.control_port_ethertype));
+		aen.akm_suites[i] = cpu_to_le32(s->crypto.akm_suites[i]);
+	aen.control_port = s->crypto.control_port;
+	aen.control_port_no_encrypt =s->crypto.control_port_no_encrypt;
+	aen.control_port_ethertype =
+		cpu_to_le16(be16_to_cpu(s->crypto.control_port_ethertype));
 
 	qtnf_cmd_skb_put_tlv_arr(cmd_skb, QTN_TLV_ID_CRYPTO, (u8 *)&aen,
 				 sizeof(aen));
diff --git a/drivers/net/wireless/quantenna/qtnfmac/commands.h b/drivers/net/wireless/quantenna/qtnfmac/commands.h
index e1bcb83..634b057 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/commands.h
+++ b/drivers/net/wireless/quantenna/qtnfmac/commands.h
@@ -33,7 +33,8 @@ int qtnf_cmd_send_del_intf(struct qtnf_vif *vif);
 int qtnf_cmd_get_mac_chan_info(struct qtnf_wmac *mac,
 			       struct ieee80211_supported_band *band);
 int qtnf_cmd_send_regulatory_config(struct qtnf_wmac *mac, const char *alpha2);
-int qtnf_cmd_send_config_ap(struct qtnf_vif *vif);
+int qtnf_cmd_send_config_ap(struct qtnf_vif *vif,
+			    const struct cfg80211_ap_settings *s);
 int qtnf_cmd_send_start_ap(struct qtnf_vif *vif);
 int qtnf_cmd_send_stop_ap(struct qtnf_vif *vif);
 int qtnf_cmd_send_register_mgmt(struct qtnf_vif *vif, u16 frame_type, bool reg);
-- 
2.9.5

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f196.google.com ([209.85.192.196]:35495 "EHLO
        mail-pf0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754421AbcJMN2A (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 13 Oct 2016 09:28:00 -0400
Received: by mail-pf0-f196.google.com with SMTP id s8so5104037pfj.2
        for <linux-wireless@vger.kernel.org>; Thu, 13 Oct 2016 06:27:59 -0700 (PDT)
From: Prameela Rani Garnepudi <prameela.j04cs@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, johannes.berg@intel.com, hofrat@osadl.org,
        xypron.glpk@gmx.de, prameela.garnepudi@redpinesignals.com,
        Prameela Rani Garnepudi <prameela.j04cs@gmail.com>
Subject: [PATCH 2/3] rsi: Host to device command frame vap_capabilites modified with new field vap status
Date: Thu, 13 Oct 2016 16:56:45 +0530
Message-Id: <1476358005-15521-1-git-send-email-prameela.j04cs@gmail.com> (sfid-20161013_152803_512687_87899CC1)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

* Command frame vap_capabilites is modified to use for vap add, vap delete
  and vap update in firmware, hence new filed vap status is added.
* When interface is down this frame needs to be send with vap status delete.
  Otherwise it is considered as wrong frame for the same interface in firmware.
* vap_update status is reserved for future.

Signed-off-by: Prameela Rani Garnepudi <prameela.j04cs@gmail.com>
---
 drivers/net/wireless/rsi/rsi_91x_mac80211.c | 8 ++++++--
 drivers/net/wireless/rsi/rsi_91x_mgmt.c     | 5 ++++-
 drivers/net/wireless/rsi/rsi_mgmt.h         | 9 ++++++++-
 3 files changed, 18 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/rsi/rsi_91x_mac80211.c b/drivers/net/wireless/rsi/rsi_91x_mac80211.c
index 58779c0..aaca258 100644
--- a/drivers/net/wireless/rsi/rsi_91x_mac80211.c
+++ b/drivers/net/wireless/rsi/rsi_91x_mac80211.c
@@ -315,7 +315,9 @@ static int rsi_mac80211_add_interface(struct ieee80211_hw *hw,
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
@@ -343,8 +345,10 @@ static void rsi_mac80211_remove_interface(struct ieee80211_hw *hw,
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
index 35c14cc..30b9d44 100644
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
@@ -642,6 +644,7 @@ int rsi_set_vap_capabilities(struct rsi_common *common, enum opmode mode)
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

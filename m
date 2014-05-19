Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:33904 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932355AbaESPyN (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 May 2014 11:54:13 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 2/2] cfg80211: constify more pointers in the cfg80211 API
Date: Mon, 19 May 2014 17:54:07 +0200
Message-Id: <1400514847-17594-2-git-send-email-johannes@sipsolutions.net> (sfid-20140519_175432_739950_6B25CE55)
In-Reply-To: <1400514847-17594-1-git-send-email-johannes@sipsolutions.net>
References: <1400514847-17594-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

This also propagates through the drivers.

The orinoco driver uses the cfg80211 API structs for internal
bookkeeping, and so needs a (void *) cast that removes the
const - but that's OK because it allocates those pointers.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/ath/ath6kl/wmi.c |  2 +-
 drivers/net/wireless/ath/ath6kl/wmi.h |  2 +-
 drivers/net/wireless/libertas/cfg.c   |  5 ++---
 drivers/net/wireless/libertas/defs.h  |  3 ++-
 drivers/net/wireless/orinoco/hw.c     |  4 ++--
 drivers/net/wireless/orinoco/hw.h     |  4 ++--
 drivers/net/wireless/orinoco/wext.c   |  4 ++--
 drivers/staging/wlan-ng/cfg80211.c    |  2 +-
 include/net/cfg80211.h                | 23 ++++++++++++-----------
 net/wireless/ibss.c                   |  2 +-
 net/wireless/sme.c                    |  2 +-
 net/wireless/util.c                   |  3 ++-
 12 files changed, 29 insertions(+), 27 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/wmi.c b/drivers/net/wireless/ath/ath6kl/wmi.c
index 8b4ce28e3ce8..051094604e21 100644
--- a/drivers/net/wireless/ath/ath6kl/wmi.c
+++ b/drivers/net/wireless/ath/ath6kl/wmi.c
@@ -2322,7 +2322,7 @@ int ath6kl_wmi_addkey_cmd(struct wmi *wmi, u8 if_idx, u8 key_index,
 	return ret;
 }
 
-int ath6kl_wmi_add_krk_cmd(struct wmi *wmi, u8 if_idx, u8 *krk)
+int ath6kl_wmi_add_krk_cmd(struct wmi *wmi, u8 if_idx, const u8 *krk)
 {
 	struct sk_buff *skb;
 	struct wmi_add_krk_cmd *cmd;
diff --git a/drivers/net/wireless/ath/ath6kl/wmi.h b/drivers/net/wireless/ath/ath6kl/wmi.h
index b5f226503baf..39ee35e60c1d 100644
--- a/drivers/net/wireless/ath/ath6kl/wmi.h
+++ b/drivers/net/wireless/ath/ath6kl/wmi.h
@@ -2617,7 +2617,7 @@ int ath6kl_wmi_addkey_cmd(struct wmi *wmi, u8 if_idx, u8 key_index,
 			  u8 *key_material,
 			  u8 key_op_ctrl, u8 *mac_addr,
 			  enum wmi_sync_flag sync_flag);
-int ath6kl_wmi_add_krk_cmd(struct wmi *wmi, u8 if_idx, u8 *krk);
+int ath6kl_wmi_add_krk_cmd(struct wmi *wmi, u8 if_idx, const u8 *krk);
 int ath6kl_wmi_deletekey_cmd(struct wmi *wmi, u8 if_idx, u8 key_index);
 int ath6kl_wmi_setpmkid_cmd(struct wmi *wmi, u8 if_idx, const u8 *bssid,
 			    const u8 *pmkid, bool set);
diff --git a/drivers/net/wireless/libertas/cfg.c b/drivers/net/wireless/libertas/cfg.c
index e4d7031df05c..47a998d8f99e 100644
--- a/drivers/net/wireless/libertas/cfg.c
+++ b/drivers/net/wireless/libertas/cfg.c
@@ -1006,9 +1006,8 @@ struct cmd_key_material {
 } __packed;
 
 static int lbs_set_key_material(struct lbs_private *priv,
-				int key_type,
-				int key_info,
-				u8 *key, u16 key_len)
+				int key_type, int key_info,
+				const u8 *key, u16 key_len)
 {
 	struct cmd_key_material cmd;
 	int ret;
diff --git a/drivers/net/wireless/libertas/defs.h b/drivers/net/wireless/libertas/defs.h
index ab966f08024a..407784aca627 100644
--- a/drivers/net/wireless/libertas/defs.h
+++ b/drivers/net/wireless/libertas/defs.h
@@ -90,7 +90,8 @@ do { if ((lbs_debug & (grp)) == (grp)) \
 #define lbs_deb_cfg80211(fmt, args...)  LBS_DEB_LL(LBS_DEB_CFG80211, " cfg80211", fmt, ##args)
 
 #ifdef DEBUG
-static inline void lbs_deb_hex(unsigned int grp, const char *prompt, u8 *buf, int len)
+static inline void lbs_deb_hex(unsigned int grp, const char *prompt,
+			       const u8 *buf, int len)
 {
 	int i = 0;
 
diff --git a/drivers/net/wireless/orinoco/hw.c b/drivers/net/wireless/orinoco/hw.c
index 49300d04efdf..e27e32851f1e 100644
--- a/drivers/net/wireless/orinoco/hw.c
+++ b/drivers/net/wireless/orinoco/hw.c
@@ -988,8 +988,8 @@ int __orinoco_hw_setup_enc(struct orinoco_private *priv)
  * tsc must be NULL or up to 8 bytes
  */
 int __orinoco_hw_set_tkip_key(struct orinoco_private *priv, int key_idx,
-			      int set_tx, u8 *key, u8 *rsc, size_t rsc_len,
-			      u8 *tsc, size_t tsc_len)
+			      int set_tx, const u8 *key, const u8 *rsc,
+			      size_t rsc_len, const u8 *tsc, size_t tsc_len)
 {
 	struct {
 		__le16 idx;
diff --git a/drivers/net/wireless/orinoco/hw.h b/drivers/net/wireless/orinoco/hw.h
index 8f6831f4e328..466d1ede76f1 100644
--- a/drivers/net/wireless/orinoco/hw.h
+++ b/drivers/net/wireless/orinoco/hw.h
@@ -38,8 +38,8 @@ int __orinoco_hw_set_wap(struct orinoco_private *priv);
 int __orinoco_hw_setup_wepkeys(struct orinoco_private *priv);
 int __orinoco_hw_setup_enc(struct orinoco_private *priv);
 int __orinoco_hw_set_tkip_key(struct orinoco_private *priv, int key_idx,
-			      int set_tx, u8 *key, u8 *rsc, size_t rsc_len,
-			      u8 *tsc, size_t tsc_len);
+			      int set_tx, const u8 *key, const u8 *rsc,
+			      size_t rsc_len, const u8 *tsc, size_t tsc_len);
 int orinoco_clear_tkip_key(struct orinoco_private *priv, int key_idx);
 int __orinoco_hw_set_multicast_list(struct orinoco_private *priv,
 				    struct net_device *dev,
diff --git a/drivers/net/wireless/orinoco/wext.c b/drivers/net/wireless/orinoco/wext.c
index b7a867b50b94..6abdaf0aa052 100644
--- a/drivers/net/wireless/orinoco/wext.c
+++ b/drivers/net/wireless/orinoco/wext.c
@@ -52,9 +52,9 @@ static int orinoco_set_key(struct orinoco_private *priv, int index,
 	priv->keys[index].seq_len = seq_len;
 
 	if (key_len)
-		memcpy(priv->keys[index].key, key, key_len);
+		memcpy((void *)priv->keys[index].key, key, key_len);
 	if (seq_len)
-		memcpy(priv->keys[index].seq, seq, seq_len);
+		memcpy((void *)priv->keys[index].seq, seq, seq_len);
 
 	switch (alg) {
 	case ORINOCO_ALG_TKIP:
diff --git a/drivers/staging/wlan-ng/cfg80211.c b/drivers/staging/wlan-ng/cfg80211.c
index f7eb8163d4fb..723319ee08f3 100644
--- a/drivers/staging/wlan-ng/cfg80211.c
+++ b/drivers/staging/wlan-ng/cfg80211.c
@@ -84,7 +84,7 @@ static int prism2_domibset_uint32(wlandevice_t *wlandev, u32 did, u32 data)
 }
 
 static int prism2_domibset_pstr32(wlandevice_t *wlandev,
-				  u32 did, u8 len, u8 *data)
+				  u32 did, u8 len, const u8 *data)
 {
 	struct p80211msg_dot11req_mibset msg;
 	p80211item_pstr32_t *mibitem =
diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index d4a602b92edf..3299d1b731ef 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -341,8 +341,8 @@ struct vif_params {
  * @seq_len: length of @seq.
  */
 struct key_params {
-	u8 *key;
-	u8 *seq;
+	const u8 *key;
+	const u8 *seq;
 	int key_len;
 	int seq_len;
 	u32 cipher;
@@ -1169,7 +1169,7 @@ struct bss_parameters {
 	int use_cts_prot;
 	int use_short_preamble;
 	int use_short_slot_time;
-	u8 *basic_rates;
+	const u8 *basic_rates;
 	u8 basic_rates_len;
 	int ap_isolate;
 	int ht_opmode;
@@ -1699,10 +1699,10 @@ struct cfg80211_disassoc_request {
  * @ht_capa_mask:  The bits of ht_capa which are to be used.
  */
 struct cfg80211_ibss_params {
-	u8 *ssid;
-	u8 *bssid;
+	const u8 *ssid;
+	const u8 *bssid;
 	struct cfg80211_chan_def chandef;
-	u8 *ie;
+	const u8 *ie;
 	u8 ssid_len, ie_len;
 	u16 beacon_interval;
 	u32 basic_rates;
@@ -1811,8 +1811,8 @@ struct cfg80211_bitrate_mask {
  * @pmkid: The PMK material itself.
  */
 struct cfg80211_pmksa {
-	u8 *bssid;
-	u8 *pmkid;
+	const u8 *bssid;
+	const u8 *pmkid;
 };
 
 /**
@@ -3289,7 +3289,7 @@ struct wireless_dev {
 		struct cfg80211_ibss_params ibss;
 		struct cfg80211_connect_params connect;
 		struct cfg80211_cached_keys *keys;
-		u8 *ie;
+		const u8 *ie;
 		size_t ie_len;
 		u8 bssid[ETH_ALEN], prev_bssid[ETH_ALEN];
 		u8 ssid[IEEE80211_MAX_SSID_LEN];
@@ -3530,7 +3530,8 @@ int ieee80211_data_to_8023(struct sk_buff *skb, const u8 *addr,
  * Return: 0 on success, or a negative error code.
  */
 int ieee80211_data_from_8023(struct sk_buff *skb, const u8 *addr,
-			     enum nl80211_iftype iftype, u8 *bssid, bool qos);
+			     enum nl80211_iftype iftype, const u8 *bssid,
+			     bool qos);
 
 /**
  * ieee80211_amsdu_to_8023s - decode an IEEE 802.11n A-MSDU frame
@@ -4319,7 +4320,7 @@ void cfg80211_roamed_bss(struct net_device *dev, struct cfg80211_bss *bss,
  * and not try to connect to any AP any more.
  */
 void cfg80211_disconnected(struct net_device *dev, u16 reason,
-			   u8 *ie, size_t ie_len, gfp_t gfp);
+			   const u8 *ie, size_t ie_len, gfp_t gfp);
 
 /**
  * cfg80211_ready_on_channel - notification of remain_on_channel start
diff --git a/net/wireless/ibss.c b/net/wireless/ibss.c
index 6b50588b709f..8f345da3ea5f 100644
--- a/net/wireless/ibss.c
+++ b/net/wireless/ibss.c
@@ -420,8 +420,8 @@ int cfg80211_ibss_wext_siwessid(struct net_device *dev,
 	if (len > 0 && ssid[len - 1] == '\0')
 		len--;
 
+	memcpy(wdev->ssid, ssid, len);
 	wdev->wext.ibss.ssid = wdev->ssid;
-	memcpy(wdev->wext.ibss.ssid, ssid, len);
 	wdev->wext.ibss.ssid_len = len;
 
 	wdev_lock(wdev);
diff --git a/net/wireless/sme.c b/net/wireless/sme.c
index 4bc21a2b1989..ea701bbacc6a 100644
--- a/net/wireless/sme.c
+++ b/net/wireless/sme.c
@@ -879,7 +879,7 @@ void __cfg80211_disconnected(struct net_device *dev, const u8 *ie,
 }
 
 void cfg80211_disconnected(struct net_device *dev, u16 reason,
-			   u8 *ie, size_t ie_len, gfp_t gfp)
+			   const u8 *ie, size_t ie_len, gfp_t gfp)
 {
 	struct wireless_dev *wdev = dev->ieee80211_ptr;
 	struct cfg80211_registered_device *rdev = wiphy_to_rdev(wdev->wiphy);
diff --git a/net/wireless/util.c b/net/wireless/util.c
index 8c61d5c6fad3..fa61ac9c9b26 100644
--- a/net/wireless/util.c
+++ b/net/wireless/util.c
@@ -476,7 +476,8 @@ int ieee80211_data_to_8023(struct sk_buff *skb, const u8 *addr,
 EXPORT_SYMBOL(ieee80211_data_to_8023);
 
 int ieee80211_data_from_8023(struct sk_buff *skb, const u8 *addr,
-			     enum nl80211_iftype iftype, u8 *bssid, bool qos)
+			     enum nl80211_iftype iftype,
+			     const u8 *bssid, bool qos)
 {
 	struct ieee80211_hdr hdr;
 	u16 hdrlen, ethertype;
-- 
2.0.0.rc0


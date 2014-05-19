Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:33902 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932418AbaESPyM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 May 2014 11:54:12 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 1/2] cfg80211: constify MAC addresses in cfg80211 ops
Date: Mon, 19 May 2014 17:54:06 +0200
Message-Id: <1400514847-17594-1-git-send-email-johannes@sipsolutions.net> (sfid-20140519_175432_123720_EEDEEC2B)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

This propagates through all the drivers and mac80211.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/ath/ath6kl/cfg80211.c         |  7 ++--
 drivers/net/wireless/ath/wil6210/cfg80211.c        |  4 +-
 drivers/net/wireless/ath/wil6210/main.c            |  4 +-
 drivers/net/wireless/ath/wil6210/wil6210.h         |  2 +-
 .../net/wireless/brcm80211/brcmfmac/wl_cfg80211.c  |  6 +--
 drivers/net/wireless/libertas/cfg.c                |  2 +-
 drivers/net/wireless/mwifiex/11n.h                 |  2 +-
 drivers/net/wireless/mwifiex/cfg80211.c            | 19 +++++-----
 drivers/net/wireless/mwifiex/main.h                | 22 +++++------
 drivers/net/wireless/mwifiex/tdls.c                | 44 ++++++++++++----------
 drivers/net/wireless/mwifiex/util.c                |  6 +--
 drivers/net/wireless/mwifiex/wmm.c                 | 10 ++---
 drivers/net/wireless/mwifiex/wmm.h                 |  5 ++-
 drivers/net/wireless/rndis_wlan.c                  |  4 +-
 drivers/staging/wlan-ng/cfg80211.c                 |  2 +-
 include/net/cfg80211.h                             | 29 +++++++-------
 net/mac80211/cfg.c                                 | 24 ++++++------
 net/mac80211/ieee80211_i.h                         |  4 +-
 net/mac80211/tdls.c                                | 12 +++---
 19 files changed, 106 insertions(+), 102 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/cfg80211.c b/drivers/net/wireless/ath/ath6kl/cfg80211.c
index c2c6f4604958..1fffbde4b01e 100644
--- a/drivers/net/wireless/ath/ath6kl/cfg80211.c
+++ b/drivers/net/wireless/ath/ath6kl/cfg80211.c
@@ -1759,7 +1759,7 @@ static bool is_rate_ht40(s32 rate, u8 *mcs, bool *sgi)
 }
 
 static int ath6kl_get_station(struct wiphy *wiphy, struct net_device *dev,
-			      u8 *mac, struct station_info *sinfo)
+			      const u8 *mac, struct station_info *sinfo)
 {
 	struct ath6kl *ar = ath6kl_priv(dev);
 	struct ath6kl_vif *vif = netdev_priv(dev);
@@ -2975,7 +2975,7 @@ static int ath6kl_stop_ap(struct wiphy *wiphy, struct net_device *dev)
 static const u8 bcast_addr[ETH_ALEN] = { 0xff, 0xff, 0xff, 0xff, 0xff, 0xff };
 
 static int ath6kl_del_station(struct wiphy *wiphy, struct net_device *dev,
-			      u8 *mac)
+			      const u8 *mac)
 {
 	struct ath6kl *ar = ath6kl_priv(dev);
 	struct ath6kl_vif *vif = netdev_priv(dev);
@@ -2986,7 +2986,8 @@ static int ath6kl_del_station(struct wiphy *wiphy, struct net_device *dev,
 }
 
 static int ath6kl_change_station(struct wiphy *wiphy, struct net_device *dev,
-				 u8 *mac, struct station_parameters *params)
+				 const u8 *mac,
+				 struct station_parameters *params)
 {
 	struct ath6kl *ar = ath6kl_priv(dev);
 	struct ath6kl_vif *vif = netdev_priv(dev);
diff --git a/drivers/net/wireless/ath/wil6210/cfg80211.c b/drivers/net/wireless/ath/wil6210/cfg80211.c
index 4806a49cb61b..6e699d050d1e 100644
--- a/drivers/net/wireless/ath/wil6210/cfg80211.c
+++ b/drivers/net/wireless/ath/wil6210/cfg80211.c
@@ -172,7 +172,7 @@ static int wil_cid_fill_sinfo(struct wil6210_priv *wil, int cid,
 
 static int wil_cfg80211_get_station(struct wiphy *wiphy,
 				    struct net_device *ndev,
-				    u8 *mac, struct station_info *sinfo)
+				    const u8 *mac, struct station_info *sinfo)
 {
 	struct wil6210_priv *wil = wiphy_to_wil(wiphy);
 	int rc;
@@ -671,7 +671,7 @@ static int wil_cfg80211_stop_ap(struct wiphy *wiphy,
 }
 
 static int wil_cfg80211_del_station(struct wiphy *wiphy,
-				    struct net_device *dev, u8 *mac)
+				    struct net_device *dev, const u8 *mac)
 {
 	struct wil6210_priv *wil = wiphy_to_wil(wiphy);
 
diff --git a/drivers/net/wireless/ath/wil6210/main.c b/drivers/net/wireless/ath/wil6210/main.c
index 95f4efe9ef37..a6b1d5872786 100644
--- a/drivers/net/wireless/ath/wil6210/main.c
+++ b/drivers/net/wireless/ath/wil6210/main.c
@@ -81,7 +81,7 @@ static void wil_disconnect_cid(struct wil6210_priv *wil, int cid)
 	memset(&sta->stats, 0, sizeof(sta->stats));
 }
 
-static void _wil6210_disconnect(struct wil6210_priv *wil, void *bssid)
+static void _wil6210_disconnect(struct wil6210_priv *wil, const u8 *bssid)
 {
 	int cid = -ENOENT;
 	struct net_device *ndev = wil_to_ndev(wil);
@@ -252,7 +252,7 @@ int wil_priv_init(struct wil6210_priv *wil)
 	return 0;
 }
 
-void wil6210_disconnect(struct wil6210_priv *wil, void *bssid)
+void wil6210_disconnect(struct wil6210_priv *wil, const u8 *bssid)
 {
 	del_timer_sync(&wil->connect_timer);
 	_wil6210_disconnect(wil, bssid);
diff --git a/drivers/net/wireless/ath/wil6210/wil6210.h b/drivers/net/wireless/ath/wil6210/wil6210.h
index 2a2dec75f026..6b353be64579 100644
--- a/drivers/net/wireless/ath/wil6210/wil6210.h
+++ b/drivers/net/wireless/ath/wil6210/wil6210.h
@@ -507,7 +507,7 @@ void wil_wdev_free(struct wil6210_priv *wil);
 int wmi_set_mac_address(struct wil6210_priv *wil, void *addr);
 int wmi_pcp_start(struct wil6210_priv *wil, int bi, u8 wmi_nettype, u8 chan);
 int wmi_pcp_stop(struct wil6210_priv *wil);
-void wil6210_disconnect(struct wil6210_priv *wil, void *bssid);
+void wil6210_disconnect(struct wil6210_priv *wil, const u8 *bssid);
 
 int wil_rx_init(struct wil6210_priv *wil);
 void wil_rx_fini(struct wil6210_priv *wil);
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
index afb3d15e38ff..befa9c04166d 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
@@ -2182,7 +2182,7 @@ brcmf_cfg80211_config_default_mgmt_key(struct wiphy *wiphy,
 
 static s32
 brcmf_cfg80211_get_station(struct wiphy *wiphy, struct net_device *ndev,
-			   u8 *mac, struct station_info *sinfo)
+			   const u8 *mac, struct station_info *sinfo)
 {
 	struct brcmf_if *ifp = netdev_priv(ndev);
 	struct brcmf_cfg80211_profile *profile = &ifp->vif->profile;
@@ -3975,7 +3975,7 @@ brcmf_cfg80211_change_beacon(struct wiphy *wiphy, struct net_device *ndev,
 
 static int
 brcmf_cfg80211_del_station(struct wiphy *wiphy, struct net_device *ndev,
-			   u8 *mac)
+			   const u8 *mac)
 {
 	struct brcmf_cfg80211_info *cfg = wiphy_to_cfg(wiphy);
 	struct brcmf_scb_val_le scbval;
@@ -4203,7 +4203,7 @@ static int brcmf_convert_nl80211_tdls_oper(enum nl80211_tdls_operation oper)
 }
 
 static int brcmf_cfg80211_tdls_oper(struct wiphy *wiphy,
-				    struct net_device *ndev, u8 *peer,
+				    struct net_device *ndev, const u8 *peer,
 				    enum nl80211_tdls_operation oper)
 {
 	struct brcmf_if *ifp;
diff --git a/drivers/net/wireless/libertas/cfg.c b/drivers/net/wireless/libertas/cfg.c
index 54e344aed6e0..e4d7031df05c 100644
--- a/drivers/net/wireless/libertas/cfg.c
+++ b/drivers/net/wireless/libertas/cfg.c
@@ -1610,7 +1610,7 @@ static int lbs_cfg_del_key(struct wiphy *wiphy, struct net_device *netdev,
  */
 
 static int lbs_cfg_get_station(struct wiphy *wiphy, struct net_device *dev,
-			      u8 *mac, struct station_info *sinfo)
+			       const u8 *mac, struct station_info *sinfo)
 {
 	struct lbs_private *priv = wiphy_priv(wiphy);
 	s8 signal, noise;
diff --git a/drivers/net/wireless/mwifiex/11n.h b/drivers/net/wireless/mwifiex/11n.h
index 40b007a00f4b..0a46aab24214 100644
--- a/drivers/net/wireless/mwifiex/11n.h
+++ b/drivers/net/wireless/mwifiex/11n.h
@@ -199,7 +199,7 @@ static inline int mwifiex_is_sta_11n_enabled(struct mwifiex_private *priv,
 }
 
 static inline u8
-mwifiex_tdls_peer_11n_enabled(struct mwifiex_private *priv, u8 *ra)
+mwifiex_tdls_peer_11n_enabled(struct mwifiex_private *priv, const u8 *ra)
 {
 	struct mwifiex_sta_node *node = mwifiex_get_sta_entry(priv, ra);
 	if (node)
diff --git a/drivers/net/wireless/mwifiex/cfg80211.c b/drivers/net/wireless/mwifiex/cfg80211.c
index 21ee27ab7b74..e95dec91a561 100644
--- a/drivers/net/wireless/mwifiex/cfg80211.c
+++ b/drivers/net/wireless/mwifiex/cfg80211.c
@@ -994,7 +994,7 @@ mwifiex_dump_station_info(struct mwifiex_private *priv,
  */
 static int
 mwifiex_cfg80211_get_station(struct wiphy *wiphy, struct net_device *dev,
-			     u8 *mac, struct station_info *sinfo)
+			     const u8 *mac, struct station_info *sinfo)
 {
 	struct mwifiex_private *priv = mwifiex_netdev_get_priv(dev);
 
@@ -1270,7 +1270,7 @@ static int mwifiex_cfg80211_change_beacon(struct wiphy *wiphy,
  */
 static int
 mwifiex_cfg80211_del_station(struct wiphy *wiphy, struct net_device *dev,
-			     u8 *mac)
+			     const u8 *mac)
 {
 	struct mwifiex_private *priv = mwifiex_netdev_get_priv(dev);
 	struct mwifiex_sta_node *sta_node;
@@ -2629,7 +2629,7 @@ static int mwifiex_cfg80211_set_coalesce(struct wiphy *wiphy,
  */
 static int
 mwifiex_cfg80211_tdls_mgmt(struct wiphy *wiphy, struct net_device *dev,
-			   u8 *peer, u8 action_code, u8 dialog_token,
+			   const u8 *peer, u8 action_code, u8 dialog_token,
 			   u16 status_code, u32 peer_capability,
 			   const u8 *extra_ies, size_t extra_ies_len)
 {
@@ -2701,7 +2701,7 @@ mwifiex_cfg80211_tdls_mgmt(struct wiphy *wiphy, struct net_device *dev,
 
 static int
 mwifiex_cfg80211_tdls_oper(struct wiphy *wiphy, struct net_device *dev,
-			   u8 *peer, enum nl80211_tdls_operation action)
+			   const u8 *peer, enum nl80211_tdls_operation action)
 {
 	struct mwifiex_private *priv = mwifiex_netdev_get_priv(dev);
 
@@ -2748,9 +2748,8 @@ mwifiex_cfg80211_tdls_oper(struct wiphy *wiphy, struct net_device *dev,
 }
 
 static int
-mwifiex_cfg80211_add_station(struct wiphy *wiphy,
-			     struct net_device *dev,
-			     u8 *mac, struct station_parameters *params)
+mwifiex_cfg80211_add_station(struct wiphy *wiphy, struct net_device *dev,
+			     const u8 *mac, struct station_parameters *params)
 {
 	struct mwifiex_private *priv = mwifiex_netdev_get_priv(dev);
 
@@ -2765,9 +2764,9 @@ mwifiex_cfg80211_add_station(struct wiphy *wiphy,
 }
 
 static int
-mwifiex_cfg80211_change_station(struct wiphy *wiphy,
-				struct net_device *dev,
-				u8 *mac, struct station_parameters *params)
+mwifiex_cfg80211_change_station(struct wiphy *wiphy, struct net_device *dev,
+				const u8 *mac,
+				struct station_parameters *params)
 {
 	int ret;
 	struct mwifiex_private *priv = mwifiex_netdev_get_priv(dev);
diff --git a/drivers/net/wireless/mwifiex/main.h b/drivers/net/wireless/mwifiex/main.h
index d53e1e8c9467..86c6b8cdec22 100644
--- a/drivers/net/wireless/mwifiex/main.h
+++ b/drivers/net/wireless/mwifiex/main.h
@@ -910,8 +910,6 @@ int mwifiex_handle_uap_rx_forward(struct mwifiex_private *priv,
 				  struct sk_buff *skb);
 int mwifiex_process_sta_event(struct mwifiex_private *);
 int mwifiex_process_uap_event(struct mwifiex_private *);
-struct mwifiex_sta_node *
-mwifiex_get_sta_entry(struct mwifiex_private *priv, u8 *mac);
 void mwifiex_delete_all_station_list(struct mwifiex_private *priv);
 void *mwifiex_process_sta_txpd(struct mwifiex_private *, struct sk_buff *skb);
 void *mwifiex_process_uap_txpd(struct mwifiex_private *, struct sk_buff *skb);
@@ -1220,26 +1218,26 @@ void mwifiex_dnld_txpwr_table(struct mwifiex_private *priv);
 extern const struct ethtool_ops mwifiex_ethtool_ops;
 
 void mwifiex_del_all_sta_list(struct mwifiex_private *priv);
-void mwifiex_del_sta_entry(struct mwifiex_private *priv, u8 *mac);
+void mwifiex_del_sta_entry(struct mwifiex_private *priv, const u8 *mac);
 void
 mwifiex_set_sta_ht_cap(struct mwifiex_private *priv, const u8 *ies,
 		       int ies_len, struct mwifiex_sta_node *node);
 struct mwifiex_sta_node *
-mwifiex_add_sta_entry(struct mwifiex_private *priv, u8 *mac);
+mwifiex_add_sta_entry(struct mwifiex_private *priv, const u8 *mac);
 struct mwifiex_sta_node *
-mwifiex_get_sta_entry(struct mwifiex_private *priv, u8 *mac);
-int mwifiex_send_tdls_data_frame(struct mwifiex_private *priv, u8 *peer,
+mwifiex_get_sta_entry(struct mwifiex_private *priv, const u8 *mac);
+int mwifiex_send_tdls_data_frame(struct mwifiex_private *priv, const u8 *peer,
 				 u8 action_code, u8 dialog_token,
 				 u16 status_code, const u8 *extra_ies,
 				 size_t extra_ies_len);
-int mwifiex_send_tdls_action_frame(struct mwifiex_private *priv,
-				 u8 *peer, u8 action_code, u8 dialog_token,
-				 u16 status_code, const u8 *extra_ies,
-				 size_t extra_ies_len);
+int mwifiex_send_tdls_action_frame(struct mwifiex_private *priv, const u8 *peer,
+				   u8 action_code, u8 dialog_token,
+				   u16 status_code, const u8 *extra_ies,
+				   size_t extra_ies_len);
 void mwifiex_process_tdls_action_frame(struct mwifiex_private *priv,
 				       u8 *buf, int len);
-int mwifiex_tdls_oper(struct mwifiex_private *priv, u8 *peer, u8 action);
-int mwifiex_get_tdls_link_status(struct mwifiex_private *priv, u8 *mac);
+int mwifiex_tdls_oper(struct mwifiex_private *priv, const u8 *peer, u8 action);
+int mwifiex_get_tdls_link_status(struct mwifiex_private *priv, const u8 *mac);
 void mwifiex_disable_all_tdls_links(struct mwifiex_private *priv);
 bool mwifiex_is_bss_in_11ac_mode(struct mwifiex_private *priv);
 u8 mwifiex_get_center_freq_index(struct mwifiex_private *priv, u8 band,
diff --git a/drivers/net/wireless/mwifiex/tdls.c b/drivers/net/wireless/mwifiex/tdls.c
index 97662a1ba58c..49c8a2c64eeb 100644
--- a/drivers/net/wireless/mwifiex/tdls.c
+++ b/drivers/net/wireless/mwifiex/tdls.c
@@ -25,8 +25,8 @@
 #define TDLS_RESP_FIX_LEN     8
 #define TDLS_CONFIRM_FIX_LEN  6
 
-static void
-mwifiex_restore_tdls_packets(struct mwifiex_private *priv, u8 *mac, u8 status)
+static void mwifiex_restore_tdls_packets(struct mwifiex_private *priv,
+					 const u8 *mac, u8 status)
 {
 	struct mwifiex_ra_list_tbl *ra_list;
 	struct list_head *tid_list;
@@ -84,7 +84,8 @@ mwifiex_restore_tdls_packets(struct mwifiex_private *priv, u8 *mac, u8 status)
 	return;
 }
 
-static void mwifiex_hold_tdls_packets(struct mwifiex_private *priv, u8 *mac)
+static void mwifiex_hold_tdls_packets(struct mwifiex_private *priv,
+				      const u8 *mac)
 {
 	struct mwifiex_ra_list_tbl *ra_list;
 	struct list_head *ra_list_head;
@@ -186,7 +187,7 @@ static int mwifiex_tdls_add_vht_capab(struct mwifiex_private *priv,
 }
 
 static int mwifiex_tdls_add_vht_oper(struct mwifiex_private *priv,
-				     u8 *mac, struct sk_buff *skb)
+				     const u8 *mac, struct sk_buff *skb)
 {
 	struct mwifiex_bssdescriptor *bss_desc;
 	struct ieee80211_vht_operation *vht_oper;
@@ -325,8 +326,9 @@ static void mwifiex_tdls_add_qos_capab(struct sk_buff *skb)
 }
 
 static int mwifiex_prep_tdls_encap_data(struct mwifiex_private *priv,
-			     u8 *peer, u8 action_code, u8 dialog_token,
-			     u16 status_code, struct sk_buff *skb)
+					const u8 *peer, u8 action_code,
+					u8 dialog_token,
+					u16 status_code, struct sk_buff *skb)
 {
 	struct ieee80211_tdls_data *tf;
 	int ret;
@@ -453,7 +455,8 @@ static int mwifiex_prep_tdls_encap_data(struct mwifiex_private *priv,
 }
 
 static void
-mwifiex_tdls_add_link_ie(struct sk_buff *skb, u8 *src_addr, u8 *peer, u8 *bssid)
+mwifiex_tdls_add_link_ie(struct sk_buff *skb, const u8 *src_addr,
+			 const u8 *peer, const u8 *bssid)
 {
 	struct ieee80211_tdls_lnkie *lnkid;
 
@@ -467,8 +470,8 @@ mwifiex_tdls_add_link_ie(struct sk_buff *skb, u8 *src_addr, u8 *peer, u8 *bssid)
 	memcpy(lnkid->resp_sta, peer, ETH_ALEN);
 }
 
-int mwifiex_send_tdls_data_frame(struct mwifiex_private *priv,
-				 u8 *peer, u8 action_code, u8 dialog_token,
+int mwifiex_send_tdls_data_frame(struct mwifiex_private *priv, const u8 *peer,
+				 u8 action_code, u8 dialog_token,
 				 u16 status_code, const u8 *extra_ies,
 				 size_t extra_ies_len)
 {
@@ -560,7 +563,8 @@ int mwifiex_send_tdls_data_frame(struct mwifiex_private *priv,
 }
 
 static int
-mwifiex_construct_tdls_action_frame(struct mwifiex_private *priv, u8 *peer,
+mwifiex_construct_tdls_action_frame(struct mwifiex_private *priv,
+				    const u8 *peer,
 				    u8 action_code, u8 dialog_token,
 				    u16 status_code, struct sk_buff *skb)
 {
@@ -638,10 +642,10 @@ mwifiex_construct_tdls_action_frame(struct mwifiex_private *priv, u8 *peer,
 	return 0;
 }
 
-int mwifiex_send_tdls_action_frame(struct mwifiex_private *priv,
-				 u8 *peer, u8 action_code, u8 dialog_token,
-				 u16 status_code, const u8 *extra_ies,
-				 size_t extra_ies_len)
+int mwifiex_send_tdls_action_frame(struct mwifiex_private *priv, const u8 *peer,
+				   u8 action_code, u8 dialog_token,
+				   u16 status_code, const u8 *extra_ies,
+				   size_t extra_ies_len)
 {
 	struct sk_buff *skb;
 	struct mwifiex_txinfo *tx_info;
@@ -848,7 +852,7 @@ void mwifiex_process_tdls_action_frame(struct mwifiex_private *priv,
 }
 
 static int
-mwifiex_tdls_process_config_link(struct mwifiex_private *priv, u8 *peer)
+mwifiex_tdls_process_config_link(struct mwifiex_private *priv, const u8 *peer)
 {
 	struct mwifiex_sta_node *sta_ptr;
 	struct mwifiex_ds_tdls_oper tdls_oper;
@@ -869,7 +873,7 @@ mwifiex_tdls_process_config_link(struct mwifiex_private *priv, u8 *peer)
 }
 
 static int
-mwifiex_tdls_process_create_link(struct mwifiex_private *priv, u8 *peer)
+mwifiex_tdls_process_create_link(struct mwifiex_private *priv, const u8 *peer)
 {
 	struct mwifiex_sta_node *sta_ptr;
 	struct mwifiex_ds_tdls_oper tdls_oper;
@@ -896,7 +900,7 @@ mwifiex_tdls_process_create_link(struct mwifiex_private *priv, u8 *peer)
 }
 
 static int
-mwifiex_tdls_process_disable_link(struct mwifiex_private *priv, u8 *peer)
+mwifiex_tdls_process_disable_link(struct mwifiex_private *priv, const u8 *peer)
 {
 	struct mwifiex_sta_node *sta_ptr;
 	struct mwifiex_ds_tdls_oper tdls_oper;
@@ -925,7 +929,7 @@ mwifiex_tdls_process_disable_link(struct mwifiex_private *priv, u8 *peer)
 }
 
 static int
-mwifiex_tdls_process_enable_link(struct mwifiex_private *priv, u8 *peer)
+mwifiex_tdls_process_enable_link(struct mwifiex_private *priv, const u8 *peer)
 {
 	struct mwifiex_sta_node *sta_ptr;
 	struct ieee80211_mcs_info mcs;
@@ -982,7 +986,7 @@ mwifiex_tdls_process_enable_link(struct mwifiex_private *priv, u8 *peer)
 	return 0;
 }
 
-int mwifiex_tdls_oper(struct mwifiex_private *priv, u8 *peer, u8 action)
+int mwifiex_tdls_oper(struct mwifiex_private *priv, const u8 *peer, u8 action)
 {
 	switch (action) {
 	case MWIFIEX_TDLS_ENABLE_LINK:
@@ -997,7 +1001,7 @@ int mwifiex_tdls_oper(struct mwifiex_private *priv, u8 *peer, u8 action)
 	return 0;
 }
 
-int mwifiex_get_tdls_link_status(struct mwifiex_private *priv, u8 *mac)
+int mwifiex_get_tdls_link_status(struct mwifiex_private *priv, const u8 *mac)
 {
 	struct mwifiex_sta_node *sta_ptr;
 
diff --git a/drivers/net/wireless/mwifiex/util.c b/drivers/net/wireless/mwifiex/util.c
index c3824e37f3f2..6da5abf52e61 100644
--- a/drivers/net/wireless/mwifiex/util.c
+++ b/drivers/net/wireless/mwifiex/util.c
@@ -259,7 +259,7 @@ int mwifiex_complete_cmd(struct mwifiex_adapter *adapter,
  * NULL is returned if station entry is not found in associated STA list.
  */
 struct mwifiex_sta_node *
-mwifiex_get_sta_entry(struct mwifiex_private *priv, u8 *mac)
+mwifiex_get_sta_entry(struct mwifiex_private *priv, const u8 *mac)
 {
 	struct mwifiex_sta_node *node;
 
@@ -280,7 +280,7 @@ mwifiex_get_sta_entry(struct mwifiex_private *priv, u8 *mac)
  * If received mac address is NULL, NULL is returned.
  */
 struct mwifiex_sta_node *
-mwifiex_add_sta_entry(struct mwifiex_private *priv, u8 *mac)
+mwifiex_add_sta_entry(struct mwifiex_private *priv, const u8 *mac)
 {
 	struct mwifiex_sta_node *node;
 	unsigned long flags;
@@ -332,7 +332,7 @@ mwifiex_set_sta_ht_cap(struct mwifiex_private *priv, const u8 *ies,
 }
 
 /* This function will delete a station entry from station list */
-void mwifiex_del_sta_entry(struct mwifiex_private *priv, u8 *mac)
+void mwifiex_del_sta_entry(struct mwifiex_private *priv, const u8 *mac)
 {
 	struct mwifiex_sta_node *node;
 	unsigned long flags;
diff --git a/drivers/net/wireless/mwifiex/wmm.c b/drivers/net/wireless/mwifiex/wmm.c
index 0a7cc742aed7..c6bc5b3191d6 100644
--- a/drivers/net/wireless/mwifiex/wmm.c
+++ b/drivers/net/wireless/mwifiex/wmm.c
@@ -92,7 +92,7 @@ mwifiex_wmm_ac_debug_print(const struct ieee_types_wmm_ac_parameters *ac_param)
  * The function also initializes the list with the provided RA.
  */
 static struct mwifiex_ra_list_tbl *
-mwifiex_wmm_allocate_ralist_node(struct mwifiex_adapter *adapter, u8 *ra)
+mwifiex_wmm_allocate_ralist_node(struct mwifiex_adapter *adapter, const u8 *ra)
 {
 	struct mwifiex_ra_list_tbl *ra_list;
 
@@ -139,8 +139,7 @@ static u8 mwifiex_get_random_ba_threshold(void)
  * This function allocates and adds a RA list for all TIDs
  * with the given RA.
  */
-void
-mwifiex_ralist_add(struct mwifiex_private *priv, u8 *ra)
+void mwifiex_ralist_add(struct mwifiex_private *priv, const u8 *ra)
 {
 	int i;
 	struct mwifiex_ra_list_tbl *ra_list;
@@ -575,7 +574,7 @@ mwifiex_clean_txrx(struct mwifiex_private *priv)
  */
 static struct mwifiex_ra_list_tbl *
 mwifiex_wmm_get_ralist_node(struct mwifiex_private *priv, u8 tid,
-			    u8 *ra_addr)
+			    const u8 *ra_addr)
 {
 	struct mwifiex_ra_list_tbl *ra_list;
 
@@ -596,7 +595,8 @@ mwifiex_wmm_get_ralist_node(struct mwifiex_private *priv, u8 tid,
  * retrieved.
  */
 struct mwifiex_ra_list_tbl *
-mwifiex_wmm_get_queue_raptr(struct mwifiex_private *priv, u8 tid, u8 *ra_addr)
+mwifiex_wmm_get_queue_raptr(struct mwifiex_private *priv, u8 tid,
+			    const u8 *ra_addr)
 {
 	struct mwifiex_ra_list_tbl *ra_list;
 
diff --git a/drivers/net/wireless/mwifiex/wmm.h b/drivers/net/wireless/mwifiex/wmm.h
index 83e42083ebff..eca56e371a57 100644
--- a/drivers/net/wireless/mwifiex/wmm.h
+++ b/drivers/net/wireless/mwifiex/wmm.h
@@ -99,7 +99,7 @@ mwifiex_wmm_is_ra_list_empty(struct list_head *ra_list_hhead)
 
 void mwifiex_wmm_add_buf_txqueue(struct mwifiex_private *priv,
 				 struct sk_buff *skb);
-void mwifiex_ralist_add(struct mwifiex_private *priv, u8 *ra);
+void mwifiex_ralist_add(struct mwifiex_private *priv, const u8 *ra);
 void mwifiex_rotate_priolists(struct mwifiex_private *priv,
 			      struct mwifiex_ra_list_tbl *ra, int tid);
 
@@ -123,7 +123,8 @@ void mwifiex_wmm_setup_ac_downgrade(struct mwifiex_private *priv);
 int mwifiex_ret_wmm_get_status(struct mwifiex_private *priv,
 			       const struct host_cmd_ds_command *resp);
 struct mwifiex_ra_list_tbl *
-mwifiex_wmm_get_queue_raptr(struct mwifiex_private *priv, u8 tid, u8 *ra_addr);
+mwifiex_wmm_get_queue_raptr(struct mwifiex_private *priv, u8 tid,
+			    const u8 *ra_addr);
 u8 mwifiex_wmm_downgrade_tid(struct mwifiex_private *priv, u32 tid);
 
 #endif /* !_MWIFIEX_WMM_H_ */
diff --git a/drivers/net/wireless/rndis_wlan.c b/drivers/net/wireless/rndis_wlan.c
index 39d22a154341..d2a9a08210be 100644
--- a/drivers/net/wireless/rndis_wlan.c
+++ b/drivers/net/wireless/rndis_wlan.c
@@ -517,7 +517,7 @@ static int rndis_set_default_key(struct wiphy *wiphy, struct net_device *netdev,
 				 u8 key_index, bool unicast, bool multicast);
 
 static int rndis_get_station(struct wiphy *wiphy, struct net_device *dev,
-					u8 *mac, struct station_info *sinfo);
+			     const u8 *mac, struct station_info *sinfo);
 
 static int rndis_dump_station(struct wiphy *wiphy, struct net_device *dev,
 			       int idx, u8 *mac, struct station_info *sinfo);
@@ -2490,7 +2490,7 @@ static void rndis_fill_station_info(struct usbnet *usbdev,
 }
 
 static int rndis_get_station(struct wiphy *wiphy, struct net_device *dev,
-					u8 *mac, struct station_info *sinfo)
+			     const u8 *mac, struct station_info *sinfo)
 {
 	struct rndis_wlan_private *priv = wiphy_priv(wiphy);
 	struct usbnet *usbdev = priv->usbdev;
diff --git a/drivers/staging/wlan-ng/cfg80211.c b/drivers/staging/wlan-ng/cfg80211.c
index f76f95c29617..f7eb8163d4fb 100644
--- a/drivers/staging/wlan-ng/cfg80211.c
+++ b/drivers/staging/wlan-ng/cfg80211.c
@@ -298,7 +298,7 @@ static int prism2_set_default_key(struct wiphy *wiphy, struct net_device *dev,
 
 
 static int prism2_get_station(struct wiphy *wiphy, struct net_device *dev,
-			      u8 *mac, struct station_info *sinfo)
+			      const u8 *mac, struct station_info *sinfo)
 {
 	wlandevice_t *wlandev = dev->ml_priv;
 	struct p80211msg_lnxreq_commsquality quality;
diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 955fdec5a1b6..d4a602b92edf 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -2345,28 +2345,29 @@ struct cfg80211_ops {
 
 
 	int	(*add_station)(struct wiphy *wiphy, struct net_device *dev,
-			       u8 *mac, struct station_parameters *params);
+			       const u8 *mac,
+			       struct station_parameters *params);
 	int	(*del_station)(struct wiphy *wiphy, struct net_device *dev,
-			       u8 *mac);
+			       const u8 *mac);
 	int	(*change_station)(struct wiphy *wiphy, struct net_device *dev,
-				  u8 *mac, struct station_parameters *params);
+				  const u8 *mac,
+				  struct station_parameters *params);
 	int	(*get_station)(struct wiphy *wiphy, struct net_device *dev,
-			       u8 *mac, struct station_info *sinfo);
+			       const u8 *mac, struct station_info *sinfo);
 	int	(*dump_station)(struct wiphy *wiphy, struct net_device *dev,
-			       int idx, u8 *mac, struct station_info *sinfo);
+				int idx, u8 *mac, struct station_info *sinfo);
 
 	int	(*add_mpath)(struct wiphy *wiphy, struct net_device *dev,
-			       u8 *dst, u8 *next_hop);
+			       const u8 *dst, const u8 *next_hop);
 	int	(*del_mpath)(struct wiphy *wiphy, struct net_device *dev,
-			       u8 *dst);
+			       const u8 *dst);
 	int	(*change_mpath)(struct wiphy *wiphy, struct net_device *dev,
-				  u8 *dst, u8 *next_hop);
+				  const u8 *dst, const u8 *next_hop);
 	int	(*get_mpath)(struct wiphy *wiphy, struct net_device *dev,
-			       u8 *dst, u8 *next_hop,
-			       struct mpath_info *pinfo);
+			     u8 *dst, u8 *next_hop, struct mpath_info *pinfo);
 	int	(*dump_mpath)(struct wiphy *wiphy, struct net_device *dev,
-			       int idx, u8 *dst, u8 *next_hop,
-			       struct mpath_info *pinfo);
+			      int idx, u8 *dst, u8 *next_hop,
+			      struct mpath_info *pinfo);
 	int	(*get_mesh_config)(struct wiphy *wiphy,
 				struct net_device *dev,
 				struct mesh_config *conf);
@@ -2496,11 +2497,11 @@ struct cfg80211_ops {
 				  struct cfg80211_gtk_rekey_data *data);
 
 	int	(*tdls_mgmt)(struct wiphy *wiphy, struct net_device *dev,
-			     u8 *peer, u8 action_code,  u8 dialog_token,
+			     const u8 *peer, u8 action_code,  u8 dialog_token,
 			     u16 status_code, u32 peer_capability,
 			     const u8 *buf, size_t len);
 	int	(*tdls_oper)(struct wiphy *wiphy, struct net_device *dev,
-			     u8 *peer, enum nl80211_tdls_operation oper);
+			     const u8 *peer, enum nl80211_tdls_operation oper);
 
 	int	(*probe_client)(struct wiphy *wiphy, struct net_device *dev,
 				const u8 *peer, u64 *cookie);
diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index bfd2534e5a4d..ac45304590d8 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -777,7 +777,7 @@ static void ieee80211_get_et_strings(struct wiphy *wiphy,
 }
 
 static int ieee80211_dump_station(struct wiphy *wiphy, struct net_device *dev,
-				 int idx, u8 *mac, struct station_info *sinfo)
+				  int idx, u8 *mac, struct station_info *sinfo)
 {
 	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 	struct ieee80211_local *local = sdata->local;
@@ -807,7 +807,7 @@ static int ieee80211_dump_survey(struct wiphy *wiphy, struct net_device *dev,
 }
 
 static int ieee80211_get_station(struct wiphy *wiphy, struct net_device *dev,
-				 u8 *mac, struct station_info *sinfo)
+				 const u8 *mac, struct station_info *sinfo)
 {
 	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 	struct ieee80211_local *local = sdata->local;
@@ -1457,7 +1457,8 @@ static int sta_apply_parameters(struct ieee80211_local *local,
 }
 
 static int ieee80211_add_station(struct wiphy *wiphy, struct net_device *dev,
-				 u8 *mac, struct station_parameters *params)
+				 const u8 *mac,
+				 struct station_parameters *params)
 {
 	struct ieee80211_local *local = wiphy_priv(wiphy);
 	struct sta_info *sta;
@@ -1526,7 +1527,7 @@ static int ieee80211_add_station(struct wiphy *wiphy, struct net_device *dev,
 }
 
 static int ieee80211_del_station(struct wiphy *wiphy, struct net_device *dev,
-				 u8 *mac)
+				 const u8 *mac)
 {
 	struct ieee80211_sub_if_data *sdata;
 
@@ -1540,7 +1541,7 @@ static int ieee80211_del_station(struct wiphy *wiphy, struct net_device *dev,
 }
 
 static int ieee80211_change_station(struct wiphy *wiphy,
-				    struct net_device *dev, u8 *mac,
+				    struct net_device *dev, const u8 *mac,
 				    struct station_parameters *params)
 {
 	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
@@ -1665,7 +1666,7 @@ out_err:
 
 #ifdef CONFIG_MAC80211_MESH
 static int ieee80211_add_mpath(struct wiphy *wiphy, struct net_device *dev,
-				 u8 *dst, u8 *next_hop)
+			       const u8 *dst, const u8 *next_hop)
 {
 	struct ieee80211_sub_if_data *sdata;
 	struct mesh_path *mpath;
@@ -1693,7 +1694,7 @@ static int ieee80211_add_mpath(struct wiphy *wiphy, struct net_device *dev,
 }
 
 static int ieee80211_del_mpath(struct wiphy *wiphy, struct net_device *dev,
-			       u8 *dst)
+			       const u8 *dst)
 {
 	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 
@@ -1704,9 +1705,8 @@ static int ieee80211_del_mpath(struct wiphy *wiphy, struct net_device *dev,
 	return 0;
 }
 
-static int ieee80211_change_mpath(struct wiphy *wiphy,
-				    struct net_device *dev,
-				    u8 *dst, u8 *next_hop)
+static int ieee80211_change_mpath(struct wiphy *wiphy, struct net_device *dev,
+				  const u8 *dst, const u8 *next_hop)
 {
 	struct ieee80211_sub_if_data *sdata;
 	struct mesh_path *mpath;
@@ -1798,8 +1798,8 @@ static int ieee80211_get_mpath(struct wiphy *wiphy, struct net_device *dev,
 }
 
 static int ieee80211_dump_mpath(struct wiphy *wiphy, struct net_device *dev,
-				 int idx, u8 *dst, u8 *next_hop,
-				 struct mpath_info *pinfo)
+				int idx, u8 *dst, u8 *next_hop,
+				struct mpath_info *pinfo)
 {
 	struct ieee80211_sub_if_data *sdata;
 	struct mesh_path *mpath;
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 57e0b2682cef..ed2b817d5ece 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -1839,11 +1839,11 @@ int ieee80211_max_num_channels(struct ieee80211_local *local);
 
 /* TDLS */
 int ieee80211_tdls_mgmt(struct wiphy *wiphy, struct net_device *dev,
-			u8 *peer, u8 action_code, u8 dialog_token,
+			const u8 *peer, u8 action_code, u8 dialog_token,
 			u16 status_code, u32 peer_capability,
 			const u8 *extra_ies, size_t extra_ies_len);
 int ieee80211_tdls_oper(struct wiphy *wiphy, struct net_device *dev,
-			u8 *peer, enum nl80211_tdls_operation oper);
+			const u8 *peer, enum nl80211_tdls_operation oper);
 
 
 #ifdef CONFIG_MAC80211_NOINLINE
diff --git a/net/mac80211/tdls.c b/net/mac80211/tdls.c
index 8e14e2aaea11..652813b2d3df 100644
--- a/net/mac80211/tdls.c
+++ b/net/mac80211/tdls.c
@@ -40,8 +40,8 @@ static u16 ieee80211_get_tdls_sta_capab(struct ieee80211_sub_if_data *sdata)
 	return capab;
 }
 
-static void ieee80211_tdls_add_link_ie(struct sk_buff *skb, u8 *src_addr,
-				       u8 *peer, u8 *bssid)
+static void ieee80211_tdls_add_link_ie(struct sk_buff *skb, const u8 *src_addr,
+				       const u8 *peer, const u8 *bssid)
 {
 	struct ieee80211_tdls_lnkie *lnkid;
 
@@ -57,7 +57,7 @@ static void ieee80211_tdls_add_link_ie(struct sk_buff *skb, u8 *src_addr,
 
 static int
 ieee80211_prep_tdls_encap_data(struct wiphy *wiphy, struct net_device *dev,
-			       u8 *peer, u8 action_code, u8 dialog_token,
+			       const u8 *peer, u8 action_code, u8 dialog_token,
 			       u16 status_code, struct sk_buff *skb)
 {
 	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
@@ -130,7 +130,7 @@ ieee80211_prep_tdls_encap_data(struct wiphy *wiphy, struct net_device *dev,
 
 static int
 ieee80211_prep_tdls_direct(struct wiphy *wiphy, struct net_device *dev,
-			   u8 *peer, u8 action_code, u8 dialog_token,
+			   const u8 *peer, u8 action_code, u8 dialog_token,
 			   u16 status_code, struct sk_buff *skb)
 {
 	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
@@ -169,7 +169,7 @@ ieee80211_prep_tdls_direct(struct wiphy *wiphy, struct net_device *dev,
 }
 
 int ieee80211_tdls_mgmt(struct wiphy *wiphy, struct net_device *dev,
-			u8 *peer, u8 action_code, u8 dialog_token,
+			const u8 *peer, u8 action_code, u8 dialog_token,
 			u16 status_code, u32 peer_capability,
 			const u8 *extra_ies, size_t extra_ies_len)
 {
@@ -285,7 +285,7 @@ fail:
 }
 
 int ieee80211_tdls_oper(struct wiphy *wiphy, struct net_device *dev,
-			u8 *peer, enum nl80211_tdls_operation oper)
+			const u8 *peer, enum nl80211_tdls_operation oper)
 {
 	struct sta_info *sta;
 	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
-- 
2.0.0.rc0


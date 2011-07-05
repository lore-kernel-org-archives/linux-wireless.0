Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:4301 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754194Ab1GEUGf (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Jul 2011 16:06:35 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH v2 19/21] staging: brcm80211: rename structures and
 variables in wl_cfg80211.c
Date: Tue, 5 Jul 2011 22:06:15 +0200
Message-ID: <1309896377-4425-20-git-send-email-arend@broadcom.com> (sfid-20110705_220654_172976_3EB0D25C)
In-Reply-To: <1309896377-4425-1-git-send-email-arend@broadcom.com>
References: <1309896377-4425-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Making an effort getting rid of the wl_ prefix from the fullmac source
files.

Signed-off-by: Arend van Spriel <arend@broadcom.com>
Reviewed-by: Roland Vossen <rvossen@broadcom.com>
Reviewed-by: Franky Lin <frankyl@broadcom.com>
---
 drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c | 1246 +++++++++++----------
 drivers/staging/brcm80211/brcmfmac/wl_cfg80211.h |  103 +--
 2 files changed, 695 insertions(+), 654 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c b/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c
index 85ff00b..5c858c5 100644
--- a/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c
+++ b/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c
@@ -36,7 +36,7 @@
 #include "wl_cfg80211.h"
 
 static struct sdio_func *cfg80211_sdio_func;
-static struct wl_dev *wl_cfg80211_dev;
+static struct brcmf_cfg80211_dev *cfg80211_dev;
 static const u8 ether_bcast[ETH_ALEN] = {255, 255, 255, 255, 255, 255};
 
 u32 brcmf_dbg_level = WL_DBG_ERR;
@@ -45,34 +45,35 @@ u32 brcmf_dbg_level = WL_DBG_ERR;
 ** cfg80211_ops api/callback list
 */
 static s32 brcmf_cfg80211_change_iface(struct wiphy *wiphy,
-				      struct net_device *ndev,
-				      enum nl80211_iftype type, u32 *flags,
-				      struct vif_params *params);
+				       struct net_device *ndev,
+				       enum nl80211_iftype type, u32 *flags,
+				       struct vif_params *params);
 static s32 __brcmf_cfg80211_scan(struct wiphy *wiphy, struct net_device *ndev,
-				struct cfg80211_scan_request *request,
-				struct cfg80211_ssid *this_ssid);
+				 struct cfg80211_scan_request *request,
+				 struct cfg80211_ssid *this_ssid);
 static s32 brcmf_cfg80211_scan(struct wiphy *wiphy, struct net_device *ndev,
-			      struct cfg80211_scan_request *request);
+			       struct cfg80211_scan_request *request);
 static s32 brcmf_cfg80211_set_wiphy_params(struct wiphy *wiphy, u32 changed);
 static s32 brcmf_cfg80211_join_ibss(struct wiphy *wiphy, struct net_device *dev,
-				   struct cfg80211_ibss_params *params);
+				    struct cfg80211_ibss_params *params);
 static s32 brcmf_cfg80211_leave_ibss(struct wiphy *wiphy,
-				    struct net_device *dev);
+				     struct net_device *dev);
 static s32 brcmf_cfg80211_get_station(struct wiphy *wiphy,
-				     struct net_device *dev, u8 *mac,
-				     struct station_info *sinfo);
+				      struct net_device *dev, u8 *mac,
+				      struct station_info *sinfo);
 static s32 brcmf_cfg80211_set_power_mgmt(struct wiphy *wiphy,
-					struct net_device *dev, bool enabled,
-					s32 timeout);
+					 struct net_device *dev, bool enabled,
+					 s32 timeout);
 static s32 brcmf_cfg80211_set_bitrate_mask(struct wiphy *wiphy,
-					  struct net_device *dev,
-					  const u8 *addr,
-					  const struct cfg80211_bitrate_mask
-					  *mask);
+					   struct net_device *dev,
+					   const u8 *addr,
+					   const struct cfg80211_bitrate_mask
+					   *mask);
 static int brcmf_cfg80211_connect(struct wiphy *wiphy, struct net_device *dev,
-			       struct cfg80211_connect_params *sme);
-static s32 brcmf_cfg80211_disconnect(struct wiphy *wiphy, struct net_device *dev,
-				    u16 reason_code);
+				  struct cfg80211_connect_params *sme);
+static s32 brcmf_cfg80211_disconnect(struct wiphy *wiphy,
+				     struct net_device *dev,
+				     u16 reason_code);
 static s32 brcmf_cfg80211_set_tx_power(struct wiphy *wiphy,
 				      enum nl80211_tx_power_setting type,
 				      s32 dbm);
@@ -106,40 +107,47 @@ static s32 brcmf_cfg80211_flush_pmksa(struct wiphy *wiphy,
 /*
 ** event & event Q handlers for cfg80211 interfaces
 */
-static s32 brcmf_create_event_handler(struct wl_priv *wl);
-static void brcmf_destroy_event_handler(struct wl_priv *wl);
+static s32 brcmf_create_event_handler(struct brcmf_cfg80211_priv *cfg_priv);
+static void brcmf_destroy_event_handler(struct brcmf_cfg80211_priv *cfg_priv);
 static s32 brcmf_event_handler(void *data);
-static void brcmf_init_eq(struct wl_priv *wl);
-static void brcmf_flush_eq(struct wl_priv *wl);
-static void brcmf_lock_eq(struct wl_priv *wl);
-static void brcmf_unlock_eq(struct wl_priv *wl);
-static void brcmf_init_eq_lock(struct wl_priv *wl);
-static void brcmf_init_eloop_handler(struct wl_event_loop *el);
-static struct wl_event_q *brcmf_deq_event(struct wl_priv *wl);
-static s32 brcmf_enq_event(struct wl_priv *wl, u32 type,
-			   const struct brcmf_event_msg *msg, void *data);
-static void brcmf_put_event(struct wl_event_q *e);
-static void brcmf_wakeup_event(struct wl_priv *wl);
-static s32 brcmf_notify_connect_status(struct wl_priv *wl, struct net_device *ndev,
+static void brcmf_init_eq(struct brcmf_cfg80211_priv *cfg_priv);
+static void brcmf_flush_eq(struct brcmf_cfg80211_priv *cfg_priv);
+static void brcmf_lock_eq(struct brcmf_cfg80211_priv *cfg_priv);
+static void brcmf_unlock_eq(struct brcmf_cfg80211_priv *cfg_priv);
+static void brcmf_init_eq_lock(struct brcmf_cfg80211_priv *cfg_priv);
+static void brcmf_init_eloop_handler(struct brcmf_cfg80211_event_loop *el);
+static struct brcmf_cfg80211_event_q *
+brcmf_deq_event(struct brcmf_cfg80211_priv *cfg_priv);
+static s32 brcmf_enq_event(struct brcmf_cfg80211_priv *cfg_priv, u32 type,
+			  const struct brcmf_event_msg *msg, void *data);
+static void brcmf_put_event(struct brcmf_cfg80211_event_q *e);
+static void brcmf_wakeup_event(struct brcmf_cfg80211_priv *cfg_priv);
+static s32 brcmf_notify_connect_status(struct brcmf_cfg80211_priv *cfg_priv,
+				       struct net_device *ndev,
+				       const struct brcmf_event_msg *e,
+				       void *data);
+static s32 brcmf_notify_roaming_status(struct brcmf_cfg80211_priv *cfg_priv,
+				       struct net_device *ndev,
 				       const struct brcmf_event_msg *e,
 				       void *data);
-static s32 brcmf_notify_roaming_status(struct wl_priv *wl, struct net_device *ndev,
+static s32 brcmf_notify_scan_status(struct brcmf_cfg80211_priv *cfg_priv,
+				    struct net_device *ndev,
 				    const struct brcmf_event_msg *e,
 				    void *data);
-static s32 brcmf_notify_scan_status(struct wl_priv *wl, struct net_device *ndev,
-				    const struct brcmf_event_msg *e, void *data);
-static s32 brcmf_bss_connect_done(struct wl_priv *wl, struct net_device *ndev,
+static s32 brcmf_bss_connect_done(struct brcmf_cfg80211_priv *cfg_priv,
+				  struct net_device *ndev,
 				  const struct brcmf_event_msg *e, void *data,
 				  bool completed);
-static s32 brcmf_bss_roaming_done(struct wl_priv *wl, struct net_device *ndev,
+static s32 brcmf_bss_roaming_done(struct brcmf_cfg80211_priv *cfg_priv,
+				  struct net_device *ndev,
 				  const struct brcmf_event_msg *e, void *data);
-static s32 brcmf_notify_mic_status(struct wl_priv *wl, struct net_device *ndev,
+static s32 brcmf_notify_mic_status(struct brcmf_cfg80211_priv *cfg_priv,
+				   struct net_device *ndev,
 				   const struct brcmf_event_msg *e, void *data);
 
 /*
 ** register/deregister sdio function
 */
-struct sdio_func *wl_cfg80211_get_sdio_func(void);
 static void brcmf_clear_sdio_func(void);
 
 /*
@@ -165,10 +173,11 @@ static s32 brcmf_set_retry(struct net_device *dev, u32 retry, bool l);
 /*
 ** wl profile utilities
 */
-static s32 brcmf_update_prof(struct wl_priv *wl, const struct brcmf_event_msg *e,
+static s32 brcmf_update_prof(struct brcmf_cfg80211_priv *cfg_priv,
+			     const struct brcmf_event_msg *e,
 			     void *data, s32 item);
-static void *brcmf_read_prof(struct wl_priv *wl, s32 item);
-static void brcmf_init_prof(struct wl_profile *prof);
+static void *brcmf_read_prof(struct brcmf_cfg80211_priv *cfg_priv, s32 item);
+static void brcmf_init_prof(struct brcmf_cfg80211_profile *prof);
 
 /*
 ** cfg80211 connect utilites
@@ -183,22 +192,24 @@ static s32 brcmf_set_key_mgmt(struct net_device *dev,
 			struct cfg80211_connect_params *sme);
 static s32 brcmf_set_set_sharedkey(struct net_device *dev,
 			struct cfg80211_connect_params *sme);
-static s32 brcmf_get_assoc_ies(struct wl_priv *wl);
-static void brcmf_clear_assoc_ies(struct wl_priv *wl);
+static s32 brcmf_get_assoc_ies(struct brcmf_cfg80211_priv *cfg_priv);
+static void brcmf_clear_assoc_ies(struct brcmf_cfg80211_priv *cfg_priv);
 static void brcmf_ch_to_chanspec(int ch,
 	struct brcmf_join_params *join_params, size_t *join_params_size);
 
 /*
 ** information element utilities
 */
-static __used s32 brcmf_add_ie(struct wl_priv *wl, u8 t, u8 l, u8 *v);
+static __used s32 brcmf_add_ie(struct brcmf_cfg80211_priv *cfg_priv,
+			       u8 t, u8 l, u8 *v);
 static s32 brcmf_mode_to_nl80211_iftype(s32 mode);
 static struct wireless_dev *brcmf_alloc_wdev(s32 sizeof_iface,
 			struct device *dev);
-static void brcmf_free_wdev(struct wl_priv *wl);
-static s32 brcmf_inform_bss(struct wl_priv *wl);
-static s32 brcmf_inform_single_bss(struct wl_priv *wl, struct brcmf_bss_info *bi);
-static s32 brcmf_update_bss_info(struct wl_priv *wl);
+static void brcmf_free_wdev(struct brcmf_cfg80211_priv *cfg_priv);
+static s32 brcmf_inform_bss(struct brcmf_cfg80211_priv *cfg_priv);
+static s32 brcmf_inform_single_bss(struct brcmf_cfg80211_priv *cfg_priv,
+				   struct brcmf_bss_info *bi);
+static s32 brcmf_update_bss_info(struct brcmf_cfg80211_priv *cfg_priv);
 static s32 brcmf_add_keyext(struct wiphy *wiphy, struct net_device *dev,
 			u8 key_idx, const u8 *mac_addr,
 			struct key_params *params);
@@ -210,45 +221,48 @@ static void swap_key_from_BE(struct brcmf_wsec_key *key);
 static void swap_key_to_BE(struct brcmf_wsec_key *key);
 
 /*
-** wl_priv memory init/deinit utilities
+** brcmf_cfg80211_priv memory init/deinit utilities
 */
-static s32 brcmf_init_priv_mem(struct wl_priv *wl);
-static void brcmf_deinit_priv_mem(struct wl_priv *wl);
+static s32 brcmf_init_priv_mem(struct brcmf_cfg80211_priv *cfg_priv);
+static void brcmf_deinit_priv_mem(struct brcmf_cfg80211_priv *cfg_priv);
 
 static void brcmf_delay(u32 ms);
 
 /*
 ** store/restore cfg80211 instance data
 */
-static void brcmf_set_drvdata(struct wl_dev *dev, void *data);
-static void *brcmf_get_drvdata(struct wl_dev *dev);
+static void brcmf_set_drvdata(struct brcmf_cfg80211_dev *dev, void *data);
+static void *brcmf_get_drvdata(struct brcmf_cfg80211_dev *dev);
 
 /*
 ** ibss mode utilities
 */
-static bool brcmf_is_ibssmode(struct wl_priv *wl);
+static bool brcmf_is_ibssmode(struct brcmf_cfg80211_priv *cfg_priv);
 
 /*
 ** dongle up/down , default configuration utilities
 */
-static bool brcmf_is_linkdown(struct wl_priv *wl, const struct brcmf_event_msg *e);
-static bool brcmf_is_linkup(struct wl_priv *wl, const struct brcmf_event_msg *e);
-static bool brcmf_is_nonetwork(struct wl_priv *wl,
+static bool brcmf_is_linkdown(struct brcmf_cfg80211_priv *cfg_priv,
+			      const struct brcmf_event_msg *e);
+static bool brcmf_is_linkup(struct brcmf_cfg80211_priv *cfg_priv,
+			    const struct brcmf_event_msg *e);
+static bool brcmf_is_nonetwork(struct brcmf_cfg80211_priv *cfg_priv,
 			       const struct brcmf_event_msg *e);
-static void brcmf_link_down(struct wl_priv *wl);
+static void brcmf_link_down(struct brcmf_cfg80211_priv *cfg_priv);
 static s32 brcmf_dongle_mode(struct net_device *ndev, s32 iftype);
-static s32 __brcmf_cfg80211_up(struct wl_priv *wl);
-static s32 __brcmf_cfg80211_down(struct wl_priv *wl);
-static s32 brcmf_dongle_probecap(struct wl_priv *wl);
-static void brcmf_init_conf(struct wl_conf *conf);
+static s32 __brcmf_cfg80211_up(struct brcmf_cfg80211_priv *cfg_priv);
+static s32 __brcmf_cfg80211_down(struct brcmf_cfg80211_priv *cfg_priv);
+static s32 brcmf_dongle_probecap(struct brcmf_cfg80211_priv *cfg_priv);
+static void brcmf_init_conf(struct brcmf_cfg80211_conf *conf);
 
 /*
 ** dongle configuration utilities
 */
 static s32 brcmf_dongle_eventmsg(struct net_device *ndev);
 static s32 brcmf_dongle_scantime(struct net_device *ndev, s32 scan_assoc_time,
-				s32 scan_unassoc_time, s32 scan_passive_time);
-static s32 brcmf_config_dongle(struct wl_priv *wl, bool need_lock);
+				 s32 scan_unassoc_time, s32 scan_passive_time);
+static s32 brcmf_config_dongle(struct brcmf_cfg80211_priv *cfg_priv,
+			       bool need_lock);
 static s32 brcmf_dongle_roam(struct net_device *ndev, u32 roamvar,
 			    u32 bcn_timeout);
 
@@ -256,8 +270,8 @@ static s32 brcmf_dongle_roam(struct net_device *ndev, u32 roamvar,
 ** iscan handler
 */
 static void brcmf_iscan_timer(unsigned long data);
-static void brcmf_term_iscan(struct wl_priv *wl);
-static s32 brcmf_init_iscan(struct wl_priv *wl);
+static void brcmf_term_iscan(struct brcmf_cfg80211_priv *cfg_priv);
+static s32 brcmf_init_iscan(struct brcmf_cfg80211_priv *cfg_priv);
 static s32 brcmf_iscan_thread(void *data);
 static s32 brcmf_dev_iovar_setbuf(struct net_device *dev, s8 *iovar,
 				 void *param, s32 paramlen, void *bufptr,
@@ -265,19 +279,21 @@ static s32 brcmf_dev_iovar_setbuf(struct net_device *dev, s8 *iovar,
 static s32 brcmf_dev_iovar_getbuf(struct net_device *dev, s8 *iovar,
 				 void *param, s32 paramlen, void *bufptr,
 				 s32 buflen);
-static s32 brcmf_run_iscan(struct wl_iscan_ctrl *iscan, struct brcmf_ssid *ssid,
-			  u16 action);
-static s32 brcmf_do_iscan(struct wl_priv *wl);
-static s32 brcmf_wakeup_iscan(struct wl_iscan_ctrl *iscan);
-static s32 brcmf_invoke_iscan(struct wl_priv *wl);
-static s32 brcmf_get_iscan_results(struct wl_iscan_ctrl *iscan, u32 *status,
-				  struct brcmf_scan_results **bss_list);
-static void brcmf_notify_iscan_complete(struct wl_iscan_ctrl *iscan, bool aborted);
-static void brcmf_init_iscan_eloop(struct wl_iscan_eloop *el);
-static s32 brcmf_iscan_done(struct wl_priv *wl);
-static s32 brcmf_iscan_pending(struct wl_priv *wl);
-static s32 brcmf_iscan_inprogress(struct wl_priv *wl);
-static s32 brcmf_iscan_aborted(struct wl_priv *wl);
+static s32 brcmf_run_iscan(struct brcmf_cfg80211_iscan_ctrl *iscan,
+			   struct brcmf_ssid *ssid, u16 action);
+static s32 brcmf_do_iscan(struct brcmf_cfg80211_priv *cfg_priv);
+static s32 brcmf_wakeup_iscan(struct brcmf_cfg80211_iscan_ctrl *iscan);
+static s32 brcmf_invoke_iscan(struct brcmf_cfg80211_priv *cfg_priv);
+static s32 brcmf_get_iscan_results(struct brcmf_cfg80211_iscan_ctrl *iscan,
+				   u32 *status,
+				   struct brcmf_scan_results **bss_list);
+static void brcmf_notify_iscan_complete(struct brcmf_cfg80211_iscan_ctrl *iscan,
+					bool aborted);
+static void brcmf_init_iscan_eloop(struct brcmf_cfg80211_iscan_eloop *el);
+static s32 brcmf_iscan_done(struct brcmf_cfg80211_priv *cfg_priv);
+static s32 brcmf_iscan_pending(struct brcmf_cfg80211_priv *cfg_priv);
+static s32 brcmf_iscan_inprogress(struct brcmf_cfg80211_priv *cfg_priv);
+static s32 brcmf_iscan_aborted(struct brcmf_cfg80211_priv *cfg_priv);
 
 /*
 * find most significant bit set
@@ -288,19 +304,21 @@ static __used u32 brcmf_find_msb(u16 bit16);
 * update pmklist to dongle
 */
 static __used s32 brcmf_update_pmklist(struct net_device *dev,
-				      struct wl_pmk_list *pmk_list, s32 err);
+				       struct brcmf_cfg80211_pmk_list *pmk_list,
+				       s32 err);
 
 static void brcmf_set_mpc(struct net_device *ndev, int mpc);
 
 /*
 * debufs support
 */
-static int brcmf_debugfs_add_netdev_params(struct wl_priv *wl);
-static void brcmf_debugfs_remove_netdev(struct wl_priv *wl);
+static int
+brcmf_debugfs_add_netdev_params(struct brcmf_cfg80211_priv *cfg_priv);
+static void brcmf_debugfs_remove_netdev(struct brcmf_cfg80211_priv *cfg_priv);
 
 #define WL_PRIV_GET()							\
 	({								\
-	struct wl_iface *ci = brcmf_get_drvdata(wl_cfg80211_dev);		\
+	struct brcmf_cfg80211_iface *ci = brcmf_get_drvdata(cfg80211_dev); \
 	if (unlikely(!ci)) {						\
 		WL_ERR("wl_cfg80211_dev is unavailable\n");		\
 		BUG();							\
@@ -310,10 +328,10 @@ static void brcmf_debugfs_remove_netdev(struct wl_priv *wl);
 
 #define CHECK_SYS_UP()							\
 do {									\
-	struct wl_priv *wl = wiphy_to_wl(wiphy);			\
-	if (unlikely(!test_bit(WL_STATUS_READY, &wl->status))) {	\
+	struct brcmf_cfg80211_priv *cfg_priv = wiphy_to_wl(wiphy);	\
+	if (unlikely(!test_bit(WL_STATUS_READY, &cfg_priv->status))) {	\
 		WL_INFO("device is not ready : status (%d)\n",		\
-			(int)wl->status);				\
+			(int)cfg_priv->status);				\
 		return -EIO;						\
 	}								\
 } while (0)
@@ -543,7 +561,7 @@ brcmf_cfg80211_change_iface(struct wiphy *wiphy, struct net_device *ndev,
 			 enum nl80211_iftype type, u32 *flags,
 			 struct vif_params *params)
 {
-	struct wl_priv *wl = wiphy_to_wl(wiphy);
+	struct brcmf_cfg80211_priv *cfg_priv = wiphy_to_wl(wiphy);
 	struct wireless_dev *wdev;
 	s32 infra = 0;
 	s32 err = 0;
@@ -558,11 +576,11 @@ brcmf_cfg80211_change_iface(struct wiphy *wiphy, struct net_device *ndev,
 		       type);
 		return -EOPNOTSUPP;
 	case NL80211_IFTYPE_ADHOC:
-		wl->conf->mode = WL_MODE_IBSS;
+		cfg_priv->conf->mode = WL_MODE_IBSS;
 		infra = 0;
 		break;
 	case NL80211_IFTYPE_STATION:
-		wl->conf->mode = WL_MODE_BSS;
+		cfg_priv->conf->mode = WL_MODE_BSS;
 		infra = 1;
 		break;
 	default:
@@ -581,7 +599,7 @@ brcmf_cfg80211_change_iface(struct wiphy *wiphy, struct net_device *ndev,
 	}
 
 	WL_INFO("IF Type = %s\n",
-		(wl->conf->mode == WL_MODE_IBSS) ? "Adhoc" : "Infra");
+		(cfg_priv->conf->mode == WL_MODE_IBSS) ? "Adhoc" : "Infra");
 
 done:
 	WL_TRACE("Exit\n");
@@ -635,7 +653,8 @@ brcmf_dev_iovar_getbuf(struct net_device *dev, s8 * iovar, void *param,
 }
 
 static s32
-brcmf_run_iscan(struct wl_iscan_ctrl *iscan, struct brcmf_ssid *ssid, u16 action)
+brcmf_run_iscan(struct brcmf_cfg80211_iscan_ctrl *iscan,
+		struct brcmf_ssid *ssid, u16 action)
 {
 	s32 params_size = (BRCMF_SCAN_PARAMS_FIXED_SIZE +
 				offsetof(struct brcmf_iscan_params, params));
@@ -669,10 +688,10 @@ brcmf_run_iscan(struct wl_iscan_ctrl *iscan, struct brcmf_ssid *ssid, u16 action
 	return err;
 }
 
-static s32 brcmf_do_iscan(struct wl_priv *wl)
+static s32 brcmf_do_iscan(struct brcmf_cfg80211_priv *cfg_priv)
 {
-	struct wl_iscan_ctrl *iscan = wl_to_iscan(wl);
-	struct net_device *ndev = wl_to_ndev(wl);
+	struct brcmf_cfg80211_iscan_ctrl *iscan = wl_to_iscan(cfg_priv);
+	struct net_device *ndev = wl_to_ndev(cfg_priv);
 	struct brcmf_ssid ssid;
 	s32 passive_scan;
 	s32 err = 0;
@@ -682,15 +701,15 @@ static s32 brcmf_do_iscan(struct wl_priv *wl)
 
 	iscan->state = WL_ISCAN_STATE_SCANING;
 
-	passive_scan = wl->active_scan ? 0 : 1;
-	err = brcmf_dev_ioctl(wl_to_ndev(wl), BRCMF_C_SET_PASSIVE_SCAN,
+	passive_scan = cfg_priv->active_scan ? 0 : 1;
+	err = brcmf_dev_ioctl(wl_to_ndev(cfg_priv), BRCMF_C_SET_PASSIVE_SCAN,
 			&passive_scan, sizeof(passive_scan));
 	if (unlikely(err)) {
 		WL_ERR("error (%d)\n", err);
 		return err;
 	}
 	brcmf_set_mpc(ndev, 0);
-	wl->iscan_kickstart = true;
+	cfg_priv->iscan_kickstart = true;
 	brcmf_run_iscan(iscan, &ssid, BRCMF_SCAN_ACTION_START);
 	mod_timer(&iscan->timer, jiffies + iscan->timer_ms * HZ / 1000);
 	iscan->timer_on = 1;
@@ -703,26 +722,26 @@ __brcmf_cfg80211_scan(struct wiphy *wiphy, struct net_device *ndev,
 		   struct cfg80211_scan_request *request,
 		   struct cfg80211_ssid *this_ssid)
 {
-	struct wl_priv *wl = ndev_to_wl(ndev);
+	struct brcmf_cfg80211_priv *cfg_priv = ndev_to_wl(ndev);
 	struct cfg80211_ssid *ssids;
-	struct wl_scan_req *sr = wl_to_sr(wl);
+	struct brcmf_cfg80211_scan_req *sr = wl_to_sr(cfg_priv);
 	s32 passive_scan;
 	bool iscan_req;
 	bool spec_scan;
 	s32 err = 0;
 
-	if (unlikely(test_bit(WL_STATUS_SCANNING, &wl->status))) {
-		WL_ERR("Scanning already : status (%d)\n", (int)wl->status);
+	if (unlikely(test_bit(WL_STATUS_SCANNING, &cfg_priv->status))) {
+		WL_ERR("Scanning already : status (%lu)\n", cfg_priv->status);
 		return -EAGAIN;
 	}
-	if (unlikely(test_bit(WL_STATUS_SCAN_ABORTING, &wl->status))) {
-		WL_ERR("Scanning being aborted : status (%d)\n",
-		       (int)wl->status);
+	if (unlikely(test_bit(WL_STATUS_SCAN_ABORTING, &cfg_priv->status))) {
+		WL_ERR("Scanning being aborted : status (%lu)\n",
+		       cfg_priv->status);
 		return -EAGAIN;
 	}
-	if (test_bit(WL_STATUS_CONNECTING, &wl->status)) {
-		WL_ERR("Connecting : status (%d)\n",
-		       (int)wl->status);
+	if (test_bit(WL_STATUS_CONNECTING, &cfg_priv->status)) {
+		WL_ERR("Connecting : status (%lu)\n",
+		       cfg_priv->status);
 		return -EAGAIN;
 	}
 
@@ -731,7 +750,7 @@ __brcmf_cfg80211_scan(struct wiphy *wiphy, struct net_device *ndev,
 	if (request) {
 		/* scan bss */
 		ssids = request->ssids;
-		if (wl->iscan_on && (!ssids || !ssids->ssid_len))
+		if (cfg_priv->iscan_on && (!ssids || !ssids->ssid_len))
 			iscan_req = true;
 	} else {
 		/* scan in ibss */
@@ -739,10 +758,10 @@ __brcmf_cfg80211_scan(struct wiphy *wiphy, struct net_device *ndev,
 		ssids = this_ssid;
 	}
 
-	wl->scan_request = request;
-	set_bit(WL_STATUS_SCANNING, &wl->status);
+	cfg_priv->scan_request = request;
+	set_bit(WL_STATUS_SCANNING, &cfg_priv->status);
 	if (iscan_req) {
-		err = brcmf_do_iscan(wl);
+		err = brcmf_do_iscan(cfg_priv);
 		if (likely(!err))
 			return err;
 		else
@@ -761,7 +780,7 @@ __brcmf_cfg80211_scan(struct wiphy *wiphy, struct net_device *ndev,
 			WL_SCAN("Broadcast scan\n");
 		}
 
-		passive_scan = wl->active_scan ? 0 : 1;
+		passive_scan = cfg_priv->active_scan ? 0 : 1;
 		err = brcmf_dev_ioctl(ndev, BRCMF_C_SET_PASSIVE_SCAN,
 				&passive_scan, sizeof(passive_scan));
 		if (unlikely(err)) {
@@ -786,8 +805,8 @@ __brcmf_cfg80211_scan(struct wiphy *wiphy, struct net_device *ndev,
 	return 0;
 
 scan_out:
-	clear_bit(WL_STATUS_SCANNING, &wl->status);
-	wl->scan_request = NULL;
+	clear_bit(WL_STATUS_SCANNING, &cfg_priv->status);
+	cfg_priv->scan_request = NULL;
 	return err;
 }
 
@@ -889,38 +908,38 @@ static s32 brcmf_set_retry(struct net_device *dev, u32 retry, bool l)
 
 static s32 brcmf_cfg80211_set_wiphy_params(struct wiphy *wiphy, u32 changed)
 {
-	struct wl_priv *wl = wiphy_to_wl(wiphy);
-	struct net_device *ndev = wl_to_ndev(wl);
+	struct brcmf_cfg80211_priv *cfg_priv = wiphy_to_wl(wiphy);
+	struct net_device *ndev = wl_to_ndev(cfg_priv);
 	s32 err = 0;
 
 	WL_TRACE("Enter\n");
 	CHECK_SYS_UP();
 
 	if (changed & WIPHY_PARAM_RTS_THRESHOLD &&
-	    (wl->conf->rts_threshold != wiphy->rts_threshold)) {
-		wl->conf->rts_threshold = wiphy->rts_threshold;
-		err = brcmf_set_rts(ndev, wl->conf->rts_threshold);
+	    (cfg_priv->conf->rts_threshold != wiphy->rts_threshold)) {
+		cfg_priv->conf->rts_threshold = wiphy->rts_threshold;
+		err = brcmf_set_rts(ndev, cfg_priv->conf->rts_threshold);
 		if (!err)
 			goto done;
 	}
 	if (changed & WIPHY_PARAM_FRAG_THRESHOLD &&
-	    (wl->conf->frag_threshold != wiphy->frag_threshold)) {
-		wl->conf->frag_threshold = wiphy->frag_threshold;
-		err = brcmf_set_frag(ndev, wl->conf->frag_threshold);
+	    (cfg_priv->conf->frag_threshold != wiphy->frag_threshold)) {
+		cfg_priv->conf->frag_threshold = wiphy->frag_threshold;
+		err = brcmf_set_frag(ndev, cfg_priv->conf->frag_threshold);
 		if (!err)
 			goto done;
 	}
 	if (changed & WIPHY_PARAM_RETRY_LONG
-	    && (wl->conf->retry_long != wiphy->retry_long)) {
-		wl->conf->retry_long = wiphy->retry_long;
-		err = brcmf_set_retry(ndev, wl->conf->retry_long, true);
+	    && (cfg_priv->conf->retry_long != wiphy->retry_long)) {
+		cfg_priv->conf->retry_long = wiphy->retry_long;
+		err = brcmf_set_retry(ndev, cfg_priv->conf->retry_long, true);
 		if (!err)
 			goto done;
 	}
 	if (changed & WIPHY_PARAM_RETRY_SHORT
-	    && (wl->conf->retry_short != wiphy->retry_short)) {
-		wl->conf->retry_short = wiphy->retry_short;
-		err = brcmf_set_retry(ndev, wl->conf->retry_short, false);
+	    && (cfg_priv->conf->retry_short != wiphy->retry_short)) {
+		cfg_priv->conf->retry_short = wiphy->retry_short;
+		err = brcmf_set_retry(ndev, cfg_priv->conf->retry_short, false);
 		if (!err)
 			goto done;
 	}
@@ -934,7 +953,7 @@ static s32
 brcmf_cfg80211_join_ibss(struct wiphy *wiphy, struct net_device *dev,
 		      struct cfg80211_ibss_params *params)
 {
-	struct wl_priv *wl = wiphy_to_wl(wiphy);
+	struct brcmf_cfg80211_priv *cfg_priv = wiphy_to_wl(wiphy);
 	struct brcmf_join_params join_params;
 	size_t join_params_size = 0;
 	s32 err = 0;
@@ -951,7 +970,7 @@ brcmf_cfg80211_join_ibss(struct wiphy *wiphy, struct net_device *dev,
 		return -EOPNOTSUPP;
 	}
 
-	set_bit(WL_STATUS_CONNECTING, &wl->status);
+	set_bit(WL_STATUS_CONNECTING, &cfg_priv->status);
 
 	if (params->bssid)
 		WL_CONN("BSSID: %02X %02X %02X %02X %02X %02X\n",
@@ -1021,7 +1040,7 @@ brcmf_cfg80211_join_ibss(struct wiphy *wiphy, struct net_device *dev,
 	memcpy(join_params.ssid.SSID, params->ssid, join_params.ssid.SSID_len);
 	join_params.ssid.SSID_len = cpu_to_le32(join_params.ssid.SSID_len);
 	join_params_size = sizeof(join_params.ssid);
-	brcmf_update_prof(wl, NULL, &join_params.ssid, WL_PROF_SSID);
+	brcmf_update_prof(cfg_priv, NULL, &join_params.ssid, WL_PROF_SSID);
 
 	/* BSSID */
 	if (params->bssid) {
@@ -1031,23 +1050,24 @@ brcmf_cfg80211_join_ibss(struct wiphy *wiphy, struct net_device *dev,
 	} else {
 		memcpy(join_params.params.bssid, ether_bcast, ETH_ALEN);
 	}
-	brcmf_update_prof(wl, NULL, &join_params.params.bssid, WL_PROF_BSSID);
+	brcmf_update_prof(cfg_priv, NULL,
+			  &join_params.params.bssid, WL_PROF_BSSID);
 
 	/* Channel */
 	if (params->channel) {
 		u32 target_channel;
 
-		wl->channel =
+		cfg_priv->channel =
 			ieee80211_frequency_to_channel(
 				params->channel->center_freq);
 		if (params->channel_fixed) {
 			/* adding chanspec */
-			brcmf_ch_to_chanspec(wl->channel,
+			brcmf_ch_to_chanspec(cfg_priv->channel,
 				&join_params, &join_params_size);
 		}
 
 		/* set channel for starter */
-		target_channel = cpu_to_le32(wl->channel);
+		target_channel = cpu_to_le32(cfg_priv->channel);
 		err = brcmf_dev_ioctl(dev, WLC_SET_CHANNEL,
 			&target_channel, sizeof(target_channel));
 		if (unlikely(err)) {
@@ -1055,9 +1075,9 @@ brcmf_cfg80211_join_ibss(struct wiphy *wiphy, struct net_device *dev,
 			goto done;
 		}
 	} else
-		wl->channel = 0;
+		cfg_priv->channel = 0;
 
-	wl->ibss_starter = false;
+	cfg_priv->ibss_starter = false;
 
 
 	err = brcmf_dev_ioctl(dev, BRCMF_C_SET_SSID,
@@ -1069,20 +1089,20 @@ brcmf_cfg80211_join_ibss(struct wiphy *wiphy, struct net_device *dev,
 
 done:
 	if (err)
-		clear_bit(WL_STATUS_CONNECTING, &wl->status);
+		clear_bit(WL_STATUS_CONNECTING, &cfg_priv->status);
 	WL_TRACE("Exit\n");
 	return err;
 }
 
 static s32 brcmf_cfg80211_leave_ibss(struct wiphy *wiphy, struct net_device *dev)
 {
-	struct wl_priv *wl = wiphy_to_wl(wiphy);
+	struct brcmf_cfg80211_priv *cfg_priv = wiphy_to_wl(wiphy);
 	s32 err = 0;
 
 	WL_TRACE("Enter\n");
 	CHECK_SYS_UP();
 
-	brcmf_link_down(wl);
+	brcmf_link_down(cfg_priv);
 
 	WL_TRACE("Exit\n");
 
@@ -1092,8 +1112,8 @@ static s32 brcmf_cfg80211_leave_ibss(struct wiphy *wiphy, struct net_device *dev
 static s32
 brcmf_set_wpa_version(struct net_device *dev, struct cfg80211_connect_params *sme)
 {
-	struct wl_priv *wl = ndev_to_wl(dev);
-	struct wl_security *sec;
+	struct brcmf_cfg80211_priv *cfg_priv = ndev_to_wl(dev);
+	struct brcmf_cfg80211_security *sec;
 	s32 val = 0;
 	s32 err = 0;
 
@@ -1109,7 +1129,7 @@ brcmf_set_wpa_version(struct net_device *dev, struct cfg80211_connect_params *sm
 		WL_ERR("set wpa_auth failed (%d)\n", err);
 		return err;
 	}
-	sec = brcmf_read_prof(wl, WL_PROF_SEC);
+	sec = brcmf_read_prof(cfg_priv, WL_PROF_SEC);
 	sec->wpa_versions = sme->crypto.wpa_versions;
 	return err;
 }
@@ -1117,8 +1137,8 @@ brcmf_set_wpa_version(struct net_device *dev, struct cfg80211_connect_params *sm
 static s32
 brcmf_set_auth_type(struct net_device *dev, struct cfg80211_connect_params *sme)
 {
-	struct wl_priv *wl = ndev_to_wl(dev);
-	struct wl_security *sec;
+	struct brcmf_cfg80211_priv *cfg_priv = ndev_to_wl(dev);
+	struct brcmf_cfg80211_security *sec;
 	s32 val = 0;
 	s32 err = 0;
 
@@ -1148,7 +1168,7 @@ brcmf_set_auth_type(struct net_device *dev, struct cfg80211_connect_params *sme)
 		WL_ERR("set auth failed (%d)\n", err);
 		return err;
 	}
-	sec = brcmf_read_prof(wl, WL_PROF_SEC);
+	sec = brcmf_read_prof(cfg_priv, WL_PROF_SEC);
 	sec->auth_type = sme->auth_type;
 	return err;
 }
@@ -1156,8 +1176,8 @@ brcmf_set_auth_type(struct net_device *dev, struct cfg80211_connect_params *sme)
 static s32
 brcmf_set_set_cipher(struct net_device *dev, struct cfg80211_connect_params *sme)
 {
-	struct wl_priv *wl = ndev_to_wl(dev);
-	struct wl_security *sec;
+	struct brcmf_cfg80211_priv *cfg_priv = ndev_to_wl(dev);
+	struct brcmf_cfg80211_security *sec;
 	s32 pval = 0;
 	s32 gval = 0;
 	s32 err = 0;
@@ -1212,7 +1232,7 @@ brcmf_set_set_cipher(struct net_device *dev, struct cfg80211_connect_params *sme
 		return err;
 	}
 
-	sec = brcmf_read_prof(wl, WL_PROF_SEC);
+	sec = brcmf_read_prof(cfg_priv, WL_PROF_SEC);
 	sec->cipher_pairwise = sme->crypto.ciphers_pairwise[0];
 	sec->cipher_group = sme->crypto.cipher_group;
 
@@ -1222,8 +1242,8 @@ brcmf_set_set_cipher(struct net_device *dev, struct cfg80211_connect_params *sme
 static s32
 brcmf_set_key_mgmt(struct net_device *dev, struct cfg80211_connect_params *sme)
 {
-	struct wl_priv *wl = ndev_to_wl(dev);
-	struct wl_security *sec;
+	struct brcmf_cfg80211_priv *cfg_priv = ndev_to_wl(dev);
+	struct brcmf_cfg80211_security *sec;
 	s32 val = 0;
 	s32 err = 0;
 
@@ -1268,7 +1288,7 @@ brcmf_set_key_mgmt(struct net_device *dev, struct cfg80211_connect_params *sme)
 			return err;
 		}
 	}
-	sec = brcmf_read_prof(wl, WL_PROF_SEC);
+	sec = brcmf_read_prof(cfg_priv, WL_PROF_SEC);
 	sec->wpa_auth = sme->crypto.akm_suites[0];
 
 	return err;
@@ -1278,15 +1298,15 @@ static s32
 brcmf_set_set_sharedkey(struct net_device *dev,
 		     struct cfg80211_connect_params *sme)
 {
-	struct wl_priv *wl = ndev_to_wl(dev);
-	struct wl_security *sec;
+	struct brcmf_cfg80211_priv *cfg_priv = ndev_to_wl(dev);
+	struct brcmf_cfg80211_security *sec;
 	struct brcmf_wsec_key key;
 	s32 val;
 	s32 err = 0;
 
 	WL_CONN("key len (%d)\n", sme->key_len);
 	if (sme->key_len) {
-		sec = brcmf_read_prof(wl, WL_PROF_SEC);
+		sec = brcmf_read_prof(cfg_priv, WL_PROF_SEC);
 		WL_CONN("wpa_versions 0x%x cipher_pairwise 0x%x\n",
 		       sec->wpa_versions, sec->cipher_pairwise);
 		if (!
@@ -1344,7 +1364,7 @@ static s32
 brcmf_cfg80211_connect(struct wiphy *wiphy, struct net_device *dev,
 		    struct cfg80211_connect_params *sme)
 {
-	struct wl_priv *wl = wiphy_to_wl(wiphy);
+	struct brcmf_cfg80211_priv *cfg_priv = wiphy_to_wl(wiphy);
 	struct ieee80211_channel *chan = sme->channel;
 	struct brcmf_join_params join_params;
 	size_t join_params_size;
@@ -1359,15 +1379,15 @@ brcmf_cfg80211_connect(struct wiphy *wiphy, struct net_device *dev,
 		return -EOPNOTSUPP;
 	}
 
-	set_bit(WL_STATUS_CONNECTING, &wl->status);
+	set_bit(WL_STATUS_CONNECTING, &cfg_priv->status);
 
 	if (chan) {
-		wl->channel =
+		cfg_priv->channel =
 			ieee80211_frequency_to_channel(chan->center_freq);
 		WL_CONN("channel (%d), center_req (%d)\n",
-			wl->channel, chan->center_freq);
+				cfg_priv->channel, chan->center_freq);
 	} else
-		wl->channel = 0;
+		cfg_priv->channel = 0;
 
 	WL_INFO("ie (%p), ie_len (%zd)\n", sme->ie, sme->ie_len);
 
@@ -1401,7 +1421,7 @@ brcmf_cfg80211_connect(struct wiphy *wiphy, struct net_device *dev,
 		goto done;
 	}
 
-	brcmf_update_prof(wl, NULL, sme->bssid, WL_PROF_BSSID);
+	brcmf_update_prof(cfg_priv, NULL, sme->bssid, WL_PROF_BSSID);
 	/*
 	 **  Join with specific BSSID and cached SSID
 	 **  If SSID is zero join based on BSSID only
@@ -1412,7 +1432,7 @@ brcmf_cfg80211_connect(struct wiphy *wiphy, struct net_device *dev,
 	join_params.ssid.SSID_len = min(sizeof(join_params.ssid.SSID), sme->ssid_len);
 	memcpy(&join_params.ssid.SSID, sme->ssid, join_params.ssid.SSID_len);
 	join_params.ssid.SSID_len = cpu_to_le32(join_params.ssid.SSID_len);
-	brcmf_update_prof(wl, NULL, &join_params.ssid, WL_PROF_SSID);
+	brcmf_update_prof(cfg_priv, NULL, &join_params.ssid, WL_PROF_SSID);
 
 	if (sme->bssid)
 		memcpy(join_params.params.bssid, sme->bssid, ETH_ALEN);
@@ -1424,7 +1444,8 @@ brcmf_cfg80211_connect(struct wiphy *wiphy, struct net_device *dev,
 		       join_params.ssid.SSID, join_params.ssid.SSID_len);
 	}
 
-	brcmf_ch_to_chanspec(wl->channel, &join_params, &join_params_size);
+	brcmf_ch_to_chanspec(cfg_priv->channel,
+			     &join_params, &join_params_size);
 	err = brcmf_dev_ioctl(dev, BRCMF_C_SET_SSID,
 			   &join_params, join_params_size);
 	if (err)
@@ -1432,7 +1453,7 @@ brcmf_cfg80211_connect(struct wiphy *wiphy, struct net_device *dev,
 
 done:
 	if (err)
-		clear_bit(WL_STATUS_CONNECTING, &wl->status);
+		clear_bit(WL_STATUS_CONNECTING, &cfg_priv->status);
 	WL_TRACE("Exit\n");
 	return err;
 }
@@ -1441,24 +1462,24 @@ static s32
 brcmf_cfg80211_disconnect(struct wiphy *wiphy, struct net_device *dev,
 		       u16 reason_code)
 {
-	struct wl_priv *wl = wiphy_to_wl(wiphy);
+	struct brcmf_cfg80211_priv *cfg_priv = wiphy_to_wl(wiphy);
 	struct brcmf_scb_val scbval;
 	s32 err = 0;
 
 	WL_TRACE("Enter. Reason code = %d\n", reason_code);
 	CHECK_SYS_UP();
 
-	clear_bit(WL_STATUS_CONNECTED, &wl->status);
+	clear_bit(WL_STATUS_CONNECTED, &cfg_priv->status);
 
 	scbval.val = reason_code;
-	memcpy(&scbval.ea, brcmf_read_prof(wl, WL_PROF_BSSID), ETH_ALEN);
+	memcpy(&scbval.ea, brcmf_read_prof(cfg_priv, WL_PROF_BSSID), ETH_ALEN);
 	scbval.val = cpu_to_le32(scbval.val);
 	err = brcmf_dev_ioctl(dev, BRCMF_C_DISASSOC, &scbval,
 			sizeof(struct brcmf_scb_val));
 	if (unlikely(err))
 		WL_ERR("error (%d)\n", err);
 
-	wl->link_up = false;
+	cfg_priv->link_up = false;
 
 	WL_TRACE("Exit\n");
 	return err;
@@ -1469,8 +1490,8 @@ brcmf_cfg80211_set_tx_power(struct wiphy *wiphy,
 			 enum nl80211_tx_power_setting type, s32 dbm)
 {
 
-	struct wl_priv *wl = wiphy_to_wl(wiphy);
-	struct net_device *ndev = wl_to_ndev(wl);
+	struct brcmf_cfg80211_priv *cfg_priv = wiphy_to_wl(wiphy);
+	struct net_device *ndev = wl_to_ndev(cfg_priv);
 	u16 txpwrmw;
 	s32 err = 0;
 	s32 disable = 0;
@@ -1511,7 +1532,7 @@ brcmf_cfg80211_set_tx_power(struct wiphy *wiphy,
 			(s32) (brcmu_mw_to_qdbm(txpwrmw)));
 	if (unlikely(err))
 		WL_ERR("qtxpower error (%d)\n", err);
-	wl->conf->tx_power = dbm;
+	cfg_priv->conf->tx_power = dbm;
 
 done:
 	WL_TRACE("Exit\n");
@@ -1520,8 +1541,8 @@ done:
 
 static s32 brcmf_cfg80211_get_tx_power(struct wiphy *wiphy, s32 *dbm)
 {
-	struct wl_priv *wl = wiphy_to_wl(wiphy);
-	struct net_device *ndev = wl_to_ndev(wl);
+	struct brcmf_cfg80211_priv *cfg_priv = wiphy_to_wl(wiphy);
+	struct net_device *ndev = wl_to_ndev(cfg_priv);
 	s32 txpwrdbm;
 	u8 result;
 	s32 err = 0;
@@ -1829,8 +1850,8 @@ brcmf_cfg80211_get_key(struct wiphy *wiphy, struct net_device *dev,
 {
 	struct key_params params;
 	struct brcmf_wsec_key key;
-	struct wl_priv *wl = wiphy_to_wl(wiphy);
-	struct wl_security *sec;
+	struct brcmf_cfg80211_priv *cfg_priv = wiphy_to_wl(wiphy);
+	struct brcmf_cfg80211_security *sec;
 	s32 wsec;
 	s32 err = 0;
 
@@ -1855,7 +1876,7 @@ brcmf_cfg80211_get_key(struct wiphy *wiphy, struct net_device *dev,
 	wsec = le32_to_cpu(wsec);
 	switch (wsec) {
 	case WEP_ENABLED:
-		sec = brcmf_read_prof(wl, WL_PROF_SEC);
+		sec = brcmf_read_prof(cfg_priv, WL_PROF_SEC);
 		if (sec->cipher_pairwise & WLAN_CIPHER_SUITE_WEP40) {
 			params.cipher = WLAN_CIPHER_SUITE_WEP40;
 			WL_CONN("WLAN_CIPHER_SUITE_WEP40\n");
@@ -1898,12 +1919,12 @@ static s32
 brcmf_cfg80211_get_station(struct wiphy *wiphy, struct net_device *dev,
 			u8 *mac, struct station_info *sinfo)
 {
-	struct wl_priv *wl = wiphy_to_wl(wiphy);
+	struct brcmf_cfg80211_priv *cfg_priv = wiphy_to_wl(wiphy);
 	struct brcmf_scb_val scb_val;
 	int rssi;
 	s32 rate;
 	s32 err = 0;
-	u8 *bssid = brcmf_read_prof(wl, WL_PROF_BSSID);
+	u8 *bssid = brcmf_read_prof(cfg_priv, WL_PROF_BSSID);
 
 	WL_TRACE("Enter\n");
 	CHECK_SYS_UP();
@@ -1930,7 +1951,7 @@ brcmf_cfg80211_get_station(struct wiphy *wiphy, struct net_device *dev,
 		WL_CONN("Rate %d Mbps\n", rate / 2);
 	}
 
-	if (test_bit(WL_STATUS_CONNECTED, &wl->status)) {
+	if (test_bit(WL_STATUS_CONNECTED, &cfg_priv->status)) {
 		scb_val.val = 0;
 		err = brcmf_dev_ioctl(dev, BRCMF_C_GET_RSSI, &scb_val,
 				sizeof(struct brcmf_scb_val));
@@ -2061,7 +2082,7 @@ done:
 
 static s32 brcmf_cfg80211_resume(struct wiphy *wiphy)
 {
-	struct wl_priv *wl = wiphy_to_wl(wiphy);
+	struct brcmf_cfg80211_priv *cfg_priv = wiphy_to_wl(wiphy);
 
 	/*
 	 * Check for WL_STATUS_READY before any function call which
@@ -2074,17 +2095,18 @@ static s32 brcmf_cfg80211_resume(struct wiphy *wiphy)
 	atomic_set(&brcmf_mmc_suspend, false);
 #endif	/*  defined(CONFIG_PM_SLEEP) */
 
-	if (test_bit(WL_STATUS_READY, &wl->status))
+	if (test_bit(WL_STATUS_READY, &cfg_priv->status))
 		brcmf_invoke_iscan(wiphy_to_wl(wiphy));
 
 	WL_TRACE("Exit\n");
 	return 0;
 }
 
-static s32 brcmf_cfg80211_suspend(struct wiphy *wiphy, struct cfg80211_wowlan *wow)
+static s32 brcmf_cfg80211_suspend(struct wiphy *wiphy,
+				  struct cfg80211_wowlan *wow)
 {
-	struct wl_priv *wl = wiphy_to_wl(wiphy);
-	struct net_device *ndev = wl_to_ndev(wl);
+	struct brcmf_cfg80211_priv *cfg_priv = wiphy_to_wl(wiphy);
+	struct net_device *ndev = wl_to_ndev(cfg_priv);
 
 	WL_TRACE("Enter\n");
 
@@ -2098,12 +2120,12 @@ static s32 brcmf_cfg80211_suspend(struct wiphy *wiphy, struct cfg80211_wowlan *w
 	 * While going to suspend if associated with AP disassociate
 	 * from AP to save power while system is in suspended state
 	 */
-	if ((test_bit(WL_STATUS_CONNECTED, &wl->status) ||
-	     test_bit(WL_STATUS_CONNECTING, &wl->status)) &&
-	     test_bit(WL_STATUS_READY, &wl->status)) {
+	if ((test_bit(WL_STATUS_CONNECTED, &cfg_priv->status) ||
+	     test_bit(WL_STATUS_CONNECTING, &cfg_priv->status)) &&
+	     test_bit(WL_STATUS_READY, &cfg_priv->status)) {
 		WL_INFO("Disassociating from AP"
 			" while entering suspend state\n");
-		brcmf_link_down(wl);
+		brcmf_link_down(cfg_priv);
 
 		/*
 		 * Make sure WPA_Supplicant receives all the event
@@ -2115,21 +2137,21 @@ static s32 brcmf_cfg80211_suspend(struct wiphy *wiphy, struct cfg80211_wowlan *w
 		rtnl_lock();
 	}
 
-	set_bit(WL_STATUS_SCAN_ABORTING, &wl->status);
-	if (test_bit(WL_STATUS_READY, &wl->status))
-		brcmf_term_iscan(wl);
+	set_bit(WL_STATUS_SCAN_ABORTING, &cfg_priv->status);
+	if (test_bit(WL_STATUS_READY, &cfg_priv->status))
+		brcmf_term_iscan(cfg_priv);
 
-	if (wl->scan_request) {
+	if (cfg_priv->scan_request) {
 		/* Indidate scan abort to cfg80211 layer */
 		WL_INFO("Terminating scan in progress\n");
-		cfg80211_scan_done(wl->scan_request, true);
-		wl->scan_request = NULL;
+		cfg80211_scan_done(cfg_priv->scan_request, true);
+		cfg_priv->scan_request = NULL;
 	}
-	clear_bit(WL_STATUS_SCANNING, &wl->status);
-	clear_bit(WL_STATUS_SCAN_ABORTING, &wl->status);
+	clear_bit(WL_STATUS_SCANNING, &cfg_priv->status);
+	clear_bit(WL_STATUS_SCAN_ABORTING, &cfg_priv->status);
 
 	/* Turn off watchdog timer */
-	if (test_bit(WL_STATUS_READY, &wl->status)) {
+	if (test_bit(WL_STATUS_READY, &cfg_priv->status)) {
 		WL_INFO("Enable MPC\n");
 		brcmf_set_mpc(ndev, 1);
 	}
@@ -2144,8 +2166,8 @@ static s32 brcmf_cfg80211_suspend(struct wiphy *wiphy, struct cfg80211_wowlan *w
 }
 
 static __used s32
-brcmf_update_pmklist(struct net_device *dev, struct wl_pmk_list *pmk_list,
-		  s32 err)
+brcmf_update_pmklist(struct net_device *dev,
+		     struct brcmf_cfg80211_pmk_list *pmk_list, s32 err)
 {
 	int i, j;
 
@@ -2166,37 +2188,33 @@ brcmf_update_pmklist(struct net_device *dev, struct wl_pmk_list *pmk_list,
 
 static s32
 brcmf_cfg80211_set_pmksa(struct wiphy *wiphy, struct net_device *dev,
-		      struct cfg80211_pmksa *pmksa)
+			 struct cfg80211_pmksa *pmksa)
 {
-	struct wl_priv *wl = wiphy_to_wl(wiphy);
+	struct brcmf_cfg80211_priv *cfg_priv = wiphy_to_wl(wiphy);
+	struct _pmkid_list *pmkids = &cfg_priv->pmk_list->pmkids;
 	s32 err = 0;
 	int i;
 
 	WL_TRACE("Enter\n");
 	CHECK_SYS_UP();
 
-	for (i = 0; i < wl->pmk_list->pmkids.npmkid; i++)
-		if (!memcmp(pmksa->bssid, &wl->pmk_list->pmkids.pmkid[i].BSSID,
-			    ETH_ALEN))
+	for (i = 0; i < pmkids->npmkid; i++)
+		if (!memcmp(pmksa->bssid, pmkids->pmkid[i].BSSID, ETH_ALEN))
 			break;
 	if (i < WL_NUM_PMKIDS_MAX) {
-		memcpy(&wl->pmk_list->pmkids.pmkid[i].BSSID, pmksa->bssid,
-		       ETH_ALEN);
-		memcpy(&wl->pmk_list->pmkids.pmkid[i].PMKID, pmksa->pmkid,
-		       WLAN_PMKID_LEN);
-		if (i == wl->pmk_list->pmkids.npmkid)
-			wl->pmk_list->pmkids.npmkid++;
+		memcpy(pmkids->pmkid[i].BSSID, pmksa->bssid, ETH_ALEN);
+		memcpy(pmkids->pmkid[i].PMKID, pmksa->pmkid, WLAN_PMKID_LEN);
+		if (i == pmkids->npmkid)
+			pmkids->npmkid++;
 	} else
 		err = -EINVAL;
 
 	WL_CONN("set_pmksa,IW_PMKSA_ADD - PMKID: %pM =\n",
-	       &wl->pmk_list->pmkids.pmkid[wl->pmk_list->pmkids.npmkid].BSSID);
+		pmkids->pmkid[pmkids->npmkid].BSSID);
 	for (i = 0; i < WLAN_PMKID_LEN; i++)
-		WL_CONN("%02x\n",
-		       wl->pmk_list->pmkids.pmkid[wl->pmk_list->pmkids.npmkid].
-		       PMKID[i]);
+		WL_CONN("%02x\n", pmkids->pmkid[pmkids->npmkid].PMKID[i]);
 
-	err = brcmf_update_pmklist(dev, wl->pmk_list, err);
+	err = brcmf_update_pmklist(dev, cfg_priv->pmk_list, err);
 
 	WL_TRACE("Exit\n");
 	return err;
@@ -2206,7 +2224,7 @@ static s32
 brcmf_cfg80211_del_pmksa(struct wiphy *wiphy, struct net_device *dev,
 		      struct cfg80211_pmksa *pmksa)
 {
-	struct wl_priv *wl = wiphy_to_wl(wiphy);
+	struct brcmf_cfg80211_priv *cfg_priv = wiphy_to_wl(wiphy);
 	struct _pmkid_list pmkid;
 	s32 err = 0;
 	int i;
@@ -2221,28 +2239,29 @@ brcmf_cfg80211_del_pmksa(struct wiphy *wiphy, struct net_device *dev,
 	for (i = 0; i < WLAN_PMKID_LEN; i++)
 		WL_CONN("%02x\n", pmkid.pmkid[0].PMKID[i]);
 
-	for (i = 0; i < wl->pmk_list->pmkids.npmkid; i++)
+	for (i = 0; i < cfg_priv->pmk_list->pmkids.npmkid; i++)
 		if (!memcmp
-		    (pmksa->bssid, &wl->pmk_list->pmkids.pmkid[i].BSSID,
+		    (pmksa->bssid, &cfg_priv->pmk_list->pmkids.pmkid[i].BSSID,
 		     ETH_ALEN))
 			break;
 
-	if ((wl->pmk_list->pmkids.npmkid > 0)
-	    && (i < wl->pmk_list->pmkids.npmkid)) {
-		memset(&wl->pmk_list->pmkids.pmkid[i], 0, sizeof(pmkid_t));
-		for (; i < (wl->pmk_list->pmkids.npmkid - 1); i++) {
-			memcpy(&wl->pmk_list->pmkids.pmkid[i].BSSID,
-			       &wl->pmk_list->pmkids.pmkid[i + 1].BSSID,
+	if ((cfg_priv->pmk_list->pmkids.npmkid > 0)
+	    && (i < cfg_priv->pmk_list->pmkids.npmkid)) {
+		memset(&cfg_priv->pmk_list->pmkids.pmkid[i], 0,
+		       sizeof(pmkid_t));
+		for (; i < (cfg_priv->pmk_list->pmkids.npmkid - 1); i++) {
+			memcpy(&cfg_priv->pmk_list->pmkids.pmkid[i].BSSID,
+			       &cfg_priv->pmk_list->pmkids.pmkid[i + 1].BSSID,
 			       ETH_ALEN);
-			memcpy(&wl->pmk_list->pmkids.pmkid[i].PMKID,
-			       &wl->pmk_list->pmkids.pmkid[i + 1].PMKID,
+			memcpy(&cfg_priv->pmk_list->pmkids.pmkid[i].PMKID,
+			       &cfg_priv->pmk_list->pmkids.pmkid[i + 1].PMKID,
 			       WLAN_PMKID_LEN);
 		}
-		wl->pmk_list->pmkids.npmkid--;
+		cfg_priv->pmk_list->pmkids.npmkid--;
 	} else
 		err = -EINVAL;
 
-	err = brcmf_update_pmklist(dev, wl->pmk_list, err);
+	err = brcmf_update_pmklist(dev, cfg_priv->pmk_list, err);
 
 	WL_TRACE("Exit\n");
 	return err;
@@ -2252,14 +2271,14 @@ brcmf_cfg80211_del_pmksa(struct wiphy *wiphy, struct net_device *dev,
 static s32
 brcmf_cfg80211_flush_pmksa(struct wiphy *wiphy, struct net_device *dev)
 {
-	struct wl_priv *wl = wiphy_to_wl(wiphy);
+	struct brcmf_cfg80211_priv *cfg_priv = wiphy_to_wl(wiphy);
 	s32 err = 0;
 
 	WL_TRACE("Enter\n");
 	CHECK_SYS_UP();
 
-	memset(wl->pmk_list, 0, sizeof(*wl->pmk_list));
-	err = brcmf_update_pmklist(dev, wl->pmk_list, err);
+	memset(cfg_priv->pmk_list, 0, sizeof(*cfg_priv->pmk_list));
+	err = brcmf_update_pmklist(dev, cfg_priv->pmk_list, err);
 
 	WL_TRACE("Exit\n");
 	return err;
@@ -2319,7 +2338,8 @@ static struct wireless_dev *brcmf_alloc_wdev(s32 sizeof_iface,
 		return ERR_PTR(-ENOMEM);
 	}
 	wdev->wiphy =
-	    wiphy_new(&wl_cfg80211_ops, sizeof(struct wl_priv) + sizeof_iface);
+	    wiphy_new(&wl_cfg80211_ops,
+		      sizeof(struct brcmf_cfg80211_priv) + sizeof_iface);
 	if (unlikely(!wdev->wiphy)) {
 		WL_ERR("Couldn not allocate wiphy device\n");
 		err = -ENOMEM;
@@ -2365,9 +2385,9 @@ wiphy_new_out:
 	return ERR_PTR(err);
 }
 
-static void brcmf_free_wdev(struct wl_priv *wl)
+static void brcmf_free_wdev(struct brcmf_cfg80211_priv *cfg_priv)
 {
-	struct wireless_dev *wdev = wl_to_wdev(wl);
+	struct wireless_dev *wdev = wl_to_wdev(cfg_priv);
 
 	if (unlikely(!wdev)) {
 		WL_ERR("wdev is invalid\n");
@@ -2376,17 +2396,17 @@ static void brcmf_free_wdev(struct wl_priv *wl)
 	wiphy_unregister(wdev->wiphy);
 	wiphy_free(wdev->wiphy);
 	kfree(wdev);
-	wl_to_wdev(wl) = NULL;
+	wl_to_wdev(cfg_priv) = NULL;
 }
 
-static s32 brcmf_inform_bss(struct wl_priv *wl)
+static s32 brcmf_inform_bss(struct brcmf_cfg80211_priv *cfg_priv)
 {
 	struct brcmf_scan_results *bss_list;
 	struct brcmf_bss_info *bi = NULL;	/* must be initialized */
 	s32 err = 0;
 	int i;
 
-	bss_list = wl->bss_list;
+	bss_list = cfg_priv->bss_list;
 	if (unlikely(bss_list->version != BRCMF_BSS_INFO_VERSION)) {
 		WL_ERR("Version %d != WL_BSS_INFO_VERSION\n",
 		       bss_list->version);
@@ -2395,7 +2415,7 @@ static s32 brcmf_inform_bss(struct wl_priv *wl)
 	WL_SCAN("scanned AP count (%d)\n", bss_list->count);
 	bi = next_bss(bss_list, bi);
 	for_each_bss(bss_list, bi, i) {
-		err = brcmf_inform_single_bss(wl, bi);
+		err = brcmf_inform_single_bss(cfg_priv, bi);
 		if (unlikely(err))
 			break;
 	}
@@ -2403,9 +2423,10 @@ static s32 brcmf_inform_bss(struct wl_priv *wl)
 }
 
 
-static s32 brcmf_inform_single_bss(struct wl_priv *wl, struct brcmf_bss_info *bi)
+static s32 brcmf_inform_single_bss(struct brcmf_cfg80211_priv *cfg_priv,
+				   struct brcmf_bss_info *bi)
 {
-	struct wiphy *wiphy = wl_to_wiphy(wl);
+	struct wiphy *wiphy = wl_to_wiphy(cfg_priv);
 	struct ieee80211_channel *notify_channel;
 	struct cfg80211_bss *bss;
 	struct ieee80211_supported_band *band;
@@ -2463,10 +2484,10 @@ static s32 brcmf_inform_single_bss(struct wl_priv *wl, struct brcmf_bss_info *bi
 	return err;
 }
 
-static s32
-wl_inform_ibss(struct wl_priv *wl, struct net_device *dev, const u8 *bssid)
+static s32 wl_inform_ibss(struct brcmf_cfg80211_priv *cfg_priv,
+			  struct net_device *dev, const u8 *bssid)
 {
-	struct wiphy *wiphy = wl_to_wiphy(wl);
+	struct wiphy *wiphy = wl_to_wiphy(cfg_priv);
 	struct ieee80211_channel *notify_channel;
 	struct brcmf_bss_info *bi = NULL;
 	struct ieee80211_supported_band *band;
@@ -2537,21 +2558,23 @@ CleanUp:
 	return err;
 }
 
-static bool brcmf_is_linkup(struct wl_priv *wl, const struct brcmf_event_msg *e)
+static bool brcmf_is_linkup(struct brcmf_cfg80211_priv *cfg_priv,
+			    const struct brcmf_event_msg *e)
 {
 	u32 event = be32_to_cpu(e->event_type);
 	u32 status = be32_to_cpu(e->status);
 
 	if (event == BRCMF_E_SET_SSID && status == BRCMF_E_STATUS_SUCCESS) {
 		WL_CONN("Processing set ssid\n");
-		wl->link_up = true;
+		cfg_priv->link_up = true;
 		return true;
 	}
 
 	return false;
 }
 
-static bool brcmf_is_linkdown(struct wl_priv *wl, const struct brcmf_event_msg *e)
+static bool brcmf_is_linkdown(struct brcmf_cfg80211_priv *cfg_priv,
+			      const struct brcmf_event_msg *e)
 {
 	u32 event = be32_to_cpu(e->event_type);
 	u16 flags = be16_to_cpu(e->flags);
@@ -2563,7 +2586,8 @@ static bool brcmf_is_linkdown(struct wl_priv *wl, const struct brcmf_event_msg *
 	return false;
 }
 
-static bool brcmf_is_nonetwork(struct wl_priv *wl, const struct brcmf_event_msg *e)
+static bool brcmf_is_nonetwork(struct brcmf_cfg80211_priv *cfg_priv,
+			       const struct brcmf_event_msg *e)
 {
 	u32 event = be32_to_cpu(e->event_type);
 	u32 status = be32_to_cpu(e->status);
@@ -2584,51 +2608,53 @@ static bool brcmf_is_nonetwork(struct wl_priv *wl, const struct brcmf_event_msg
 }
 
 static s32
-brcmf_notify_connect_status(struct wl_priv *wl, struct net_device *ndev,
+brcmf_notify_connect_status(struct brcmf_cfg80211_priv *cfg_priv,
+			    struct net_device *ndev,
 			    const struct brcmf_event_msg *e, void *data)
 {
 	s32 err = 0;
 
-	if (brcmf_is_linkup(wl, e)) {
+	if (brcmf_is_linkup(cfg_priv, e)) {
 		WL_CONN("Linkup\n");
-		if (brcmf_is_ibssmode(wl)) {
-			brcmf_update_prof(wl, NULL, (void *)e->addr,
+		if (brcmf_is_ibssmode(cfg_priv)) {
+			brcmf_update_prof(cfg_priv, NULL, (void *)e->addr,
 				WL_PROF_BSSID);
-			wl_inform_ibss(wl, ndev, e->addr);
+			wl_inform_ibss(cfg_priv, ndev, e->addr);
 			cfg80211_ibss_joined(ndev, e->addr, GFP_KERNEL);
-			clear_bit(WL_STATUS_CONNECTING, &wl->status);
-			set_bit(WL_STATUS_CONNECTED, &wl->status);
+			clear_bit(WL_STATUS_CONNECTING, &cfg_priv->status);
+			set_bit(WL_STATUS_CONNECTED, &cfg_priv->status);
 		} else
-			brcmf_bss_connect_done(wl, ndev, e, data, true);
-	} else if (brcmf_is_linkdown(wl, e)) {
+			brcmf_bss_connect_done(cfg_priv, ndev, e, data, true);
+	} else if (brcmf_is_linkdown(cfg_priv, e)) {
 		WL_CONN("Linkdown\n");
-		if (brcmf_is_ibssmode(wl)) {
-			clear_bit(WL_STATUS_CONNECTING, &wl->status);
+		if (brcmf_is_ibssmode(cfg_priv)) {
+			clear_bit(WL_STATUS_CONNECTING, &cfg_priv->status);
 			if (test_and_clear_bit(WL_STATUS_CONNECTED,
-				&wl->status))
-				brcmf_link_down(wl);
+				&cfg_priv->status))
+				brcmf_link_down(cfg_priv);
 		} else {
-			brcmf_bss_connect_done(wl, ndev, e, data, false);
+			brcmf_bss_connect_done(cfg_priv, ndev, e, data, false);
 			if (test_and_clear_bit(WL_STATUS_CONNECTED,
-				&wl->status)) {
+				&cfg_priv->status)) {
 				cfg80211_disconnected(ndev, 0, NULL, 0,
 					GFP_KERNEL);
-				brcmf_link_down(wl);
+				brcmf_link_down(cfg_priv);
 			}
 		}
-		brcmf_init_prof(wl->profile);
-	} else if (brcmf_is_nonetwork(wl, e)) {
-		if (brcmf_is_ibssmode(wl))
-			clear_bit(WL_STATUS_CONNECTING, &wl->status);
+		brcmf_init_prof(cfg_priv->profile);
+	} else if (brcmf_is_nonetwork(cfg_priv, e)) {
+		if (brcmf_is_ibssmode(cfg_priv))
+			clear_bit(WL_STATUS_CONNECTING, &cfg_priv->status);
 		else
-			brcmf_bss_connect_done(wl, ndev, e, data, false);
+			brcmf_bss_connect_done(cfg_priv, ndev, e, data, false);
 	}
 
 	return err;
 }
 
 static s32
-brcmf_notify_roaming_status(struct wl_priv *wl, struct net_device *ndev,
+brcmf_notify_roaming_status(struct brcmf_cfg80211_priv *cfg_priv,
+			    struct net_device *ndev,
 			    const struct brcmf_event_msg *e, void *data)
 {
 	s32 err = 0;
@@ -2636,10 +2662,10 @@ brcmf_notify_roaming_status(struct wl_priv *wl, struct net_device *ndev,
 	u32 status = be32_to_cpu(e->status);
 
 	if (event == BRCMF_E_ROAM && status == BRCMF_E_STATUS_SUCCESS) {
-		if (test_bit(WL_STATUS_CONNECTED, &wl->status))
-			brcmf_bss_roaming_done(wl, ndev, e, data);
+		if (test_bit(WL_STATUS_CONNECTED, &cfg_priv->status))
+			brcmf_bss_roaming_done(cfg_priv, ndev, e, data);
 		else
-			brcmf_bss_connect_done(wl, ndev, e, data, true);
+			brcmf_bss_connect_done(cfg_priv, ndev, e, data, true);
 	}
 
 	return err;
@@ -2648,80 +2674,87 @@ brcmf_notify_roaming_status(struct wl_priv *wl, struct net_device *ndev,
 static __used s32
 brcmf_dev_bufvar_set(struct net_device *dev, s8 *name, s8 *buf, s32 len)
 {
-	struct wl_priv *wl = ndev_to_wl(dev);
+	struct brcmf_cfg80211_priv *cfg_priv = ndev_to_wl(dev);
 	u32 buflen;
 
-	buflen = brcmu_mkiovar(name, buf, len, wl->ioctl_buf, WL_IOCTL_LEN_MAX);
+	buflen = brcmu_mkiovar(name, buf, len, cfg_priv->ioctl_buf,
+			       WL_IOCTL_LEN_MAX);
 	BUG_ON(!buflen);
 
-	return brcmf_dev_ioctl(dev, BRCMF_C_SET_VAR, wl->ioctl_buf, buflen);
+	return brcmf_dev_ioctl(dev, BRCMF_C_SET_VAR, cfg_priv->ioctl_buf,
+			       buflen);
 }
 
 static s32
 brcmf_dev_bufvar_get(struct net_device *dev, s8 *name, s8 *buf,
 		  s32 buf_len)
 {
-	struct wl_priv *wl = ndev_to_wl(dev);
+	struct brcmf_cfg80211_priv *cfg_priv = ndev_to_wl(dev);
 	u32 len;
 	s32 err = 0;
 
-	len = brcmu_mkiovar(name, NULL, 0, wl->ioctl_buf, WL_IOCTL_LEN_MAX);
+	len = brcmu_mkiovar(name, NULL, 0, cfg_priv->ioctl_buf,
+			    WL_IOCTL_LEN_MAX);
 	BUG_ON(!len);
-	err = brcmf_dev_ioctl(dev, BRCMF_C_GET_VAR, (void *)wl->ioctl_buf,
+	err = brcmf_dev_ioctl(dev, BRCMF_C_GET_VAR, (void *)cfg_priv->ioctl_buf,
 			WL_IOCTL_LEN_MAX);
 	if (unlikely(err)) {
 		WL_ERR("error (%d)\n", err);
 		return err;
 	}
-	memcpy(buf, wl->ioctl_buf, buf_len);
+	memcpy(buf, cfg_priv->ioctl_buf, buf_len);
 
 	return err;
 }
 
-static s32 brcmf_get_assoc_ies(struct wl_priv *wl)
+static s32 brcmf_get_assoc_ies(struct brcmf_cfg80211_priv *cfg_priv)
 {
-	struct net_device *ndev = wl_to_ndev(wl);
-	struct wl_assoc_ielen *assoc_info;
-	struct wl_connect_info *conn_info = wl_to_conn(wl);
+	struct net_device *ndev = wl_to_ndev(cfg_priv);
+	struct brcmf_cfg80211_assoc_ielen *assoc_info;
+	struct brcmf_cfg80211_connect_info *conn_info = wl_to_conn(cfg_priv);
 	u32 req_len;
 	u32 resp_len;
 	s32 err = 0;
 
-	brcmf_clear_assoc_ies(wl);
+	brcmf_clear_assoc_ies(cfg_priv);
 
-	err = brcmf_dev_bufvar_get(ndev, "assoc_info", wl->extra_buf,
+	err = brcmf_dev_bufvar_get(ndev, "assoc_info", cfg_priv->extra_buf,
 				WL_ASSOC_INFO_MAX);
 	if (unlikely(err)) {
 		WL_ERR("could not get assoc info (%d)\n", err);
 		return err;
 	}
-	assoc_info = (struct wl_assoc_ielen *)wl->extra_buf;
+	assoc_info = (struct brcmf_cfg80211_assoc_ielen *)cfg_priv->extra_buf;
 	req_len = assoc_info->req_len;
 	resp_len = assoc_info->resp_len;
 	if (req_len) {
-		err = brcmf_dev_bufvar_get(ndev, "assoc_req_ies", wl->extra_buf,
-					WL_ASSOC_INFO_MAX);
+		err = brcmf_dev_bufvar_get(ndev, "assoc_req_ies",
+					   cfg_priv->extra_buf,
+					   WL_ASSOC_INFO_MAX);
 		if (unlikely(err)) {
 			WL_ERR("could not get assoc req (%d)\n", err);
 			return err;
 		}
 		conn_info->req_ie_len = req_len;
 		conn_info->req_ie =
-		    kmemdup(wl->extra_buf, conn_info->req_ie_len, GFP_KERNEL);
+		    kmemdup(cfg_priv->extra_buf, conn_info->req_ie_len,
+			    GFP_KERNEL);
 	} else {
 		conn_info->req_ie_len = 0;
 		conn_info->req_ie = NULL;
 	}
 	if (resp_len) {
-		err = brcmf_dev_bufvar_get(ndev, "assoc_resp_ies", wl->extra_buf,
-					WL_ASSOC_INFO_MAX);
+		err = brcmf_dev_bufvar_get(ndev, "assoc_resp_ies",
+					   cfg_priv->extra_buf,
+					   WL_ASSOC_INFO_MAX);
 		if (unlikely(err)) {
 			WL_ERR("could not get assoc resp (%d)\n", err);
 			return err;
 		}
 		conn_info->resp_ie_len = resp_len;
 		conn_info->resp_ie =
-		    kmemdup(wl->extra_buf, conn_info->resp_ie_len, GFP_KERNEL);
+		    kmemdup(cfg_priv->extra_buf, conn_info->resp_ie_len,
+			    GFP_KERNEL);
 	} else {
 		conn_info->resp_ie_len = 0;
 		conn_info->resp_ie = NULL;
@@ -2732,9 +2765,9 @@ static s32 brcmf_get_assoc_ies(struct wl_priv *wl)
 	return err;
 }
 
-static void brcmf_clear_assoc_ies(struct wl_priv *wl)
+static void brcmf_clear_assoc_ies(struct brcmf_cfg80211_priv *cfg_priv)
 {
-	struct wl_connect_info *conn_info = wl_to_conn(wl);
+	struct brcmf_cfg80211_connect_info *conn_info = wl_to_conn(cfg_priv);
 
 	kfree(conn_info->req_ie);
 	conn_info->req_ie = NULL;
@@ -2779,7 +2812,7 @@ static void brcmf_ch_to_chanspec(int ch, struct brcmf_join_params *join_params,
 	}
 }
 
-static s32 brcmf_update_bss_info(struct wl_priv *wl)
+static s32 brcmf_update_bss_info(struct brcmf_cfg80211_priv *cfg_priv)
 {
 	struct brcmf_bss_info *bi;
 	struct brcmf_ssid *ssid;
@@ -2791,21 +2824,21 @@ static s32 brcmf_update_bss_info(struct wl_priv *wl)
 	s32 err = 0;
 
 	WL_TRACE("Enter\n");
-	if (brcmf_is_ibssmode(wl))
+	if (brcmf_is_ibssmode(cfg_priv))
 		return err;
 
-	ssid = (struct brcmf_ssid *)brcmf_read_prof(wl, WL_PROF_SSID);
+	ssid = (struct brcmf_ssid *)brcmf_read_prof(cfg_priv, WL_PROF_SSID);
 
-	*(u32 *)wl->extra_buf = cpu_to_le32(WL_EXTRA_BUF_MAX);
-	err = brcmf_dev_ioctl(wl_to_ndev(wl), BRCMF_C_GET_BSS_INFO,
-			wl->extra_buf, WL_EXTRA_BUF_MAX);
+	*(u32 *)cfg_priv->extra_buf = cpu_to_le32(WL_EXTRA_BUF_MAX);
+	err = brcmf_dev_ioctl(wl_to_ndev(cfg_priv), BRCMF_C_GET_BSS_INFO,
+			cfg_priv->extra_buf, WL_EXTRA_BUF_MAX);
 	if (unlikely(err)) {
 		WL_ERR("Could not get bss info %d\n", err);
 		goto update_bss_info_out;
 	}
 
-	bi = (struct brcmf_bss_info *)(wl->extra_buf + 4);
-	err = brcmf_inform_single_bss(wl, bi);
+	bi = (struct brcmf_bss_info *)(cfg_priv->extra_buf + 4);
+	err = brcmf_inform_single_bss(cfg_priv, bi);
 	if (unlikely(err))
 		goto update_bss_info_out;
 
@@ -2823,7 +2856,8 @@ static s32 brcmf_update_bss_info(struct wl_priv *wl)
 		* so we speficially query dtim information to dongle.
 		*/
 		u32 var;
-		err = brcmf_dev_intvar_get(wl_to_ndev(wl), "dtim_assoc", &var);
+		err = brcmf_dev_intvar_get(wl_to_ndev(cfg_priv),
+					   "dtim_assoc", &var);
 		if (unlikely(err)) {
 			WL_ERR("wl dtim_assoc failed (%d)\n", err);
 			goto update_bss_info_out;
@@ -2831,8 +2865,8 @@ static s32 brcmf_update_bss_info(struct wl_priv *wl)
 		dtim_period = (u8)var;
 	}
 
-	brcmf_update_prof(wl, NULL, &beacon_interval, WL_PROF_BEACONINT);
-	brcmf_update_prof(wl, NULL, &dtim_period, WL_PROF_DTIMPERIOD);
+	brcmf_update_prof(cfg_priv, NULL, &beacon_interval, WL_PROF_BEACONINT);
+	brcmf_update_prof(cfg_priv, NULL, &dtim_period, WL_PROF_DTIMPERIOD);
 
 update_bss_info_out:
 	WL_TRACE("Exit");
@@ -2840,54 +2874,59 @@ update_bss_info_out:
 }
 
 static s32
-brcmf_bss_roaming_done(struct wl_priv *wl, struct net_device *ndev,
+brcmf_bss_roaming_done(struct brcmf_cfg80211_priv *cfg_priv,
+		       struct net_device *ndev,
 		       const struct brcmf_event_msg *e, void *data)
 {
-	struct wl_connect_info *conn_info = wl_to_conn(wl);
+	struct brcmf_cfg80211_connect_info *conn_info = wl_to_conn(cfg_priv);
 	s32 err = 0;
 
 	WL_TRACE("Enter\n");
 
-	brcmf_get_assoc_ies(wl);
-	brcmf_update_prof(wl, NULL, &e->addr, WL_PROF_BSSID);
-	brcmf_update_bss_info(wl);
+	brcmf_get_assoc_ies(cfg_priv);
+	brcmf_update_prof(cfg_priv, NULL, &e->addr, WL_PROF_BSSID);
+	brcmf_update_bss_info(cfg_priv);
 
 	cfg80211_roamed(ndev, NULL,
-			(u8 *)brcmf_read_prof(wl, WL_PROF_BSSID),
+			(u8 *)brcmf_read_prof(cfg_priv, WL_PROF_BSSID),
 			conn_info->req_ie, conn_info->req_ie_len,
 			conn_info->resp_ie, conn_info->resp_ie_len, GFP_KERNEL);
 	WL_CONN("Report roaming result\n");
 
-	set_bit(WL_STATUS_CONNECTED, &wl->status);
+	set_bit(WL_STATUS_CONNECTED, &cfg_priv->status);
 	WL_TRACE("Exit\n");
 	return err;
 }
 
 static s32
-brcmf_bss_connect_done(struct wl_priv *wl, struct net_device *ndev,
-		       const struct brcmf_event_msg *e, void *data, bool completed)
+brcmf_bss_connect_done(struct brcmf_cfg80211_priv *cfg_priv,
+		       struct net_device *ndev, const struct brcmf_event_msg *e,
+		       void *data, bool completed)
 {
-	struct wl_connect_info *conn_info = wl_to_conn(wl);
+	struct brcmf_cfg80211_connect_info *conn_info = wl_to_conn(cfg_priv);
 	s32 err = 0;
 
 	WL_TRACE("Enter\n");
 
-	if (test_and_clear_bit(WL_STATUS_CONNECTING, &wl->status)) {
+	if (test_and_clear_bit(WL_STATUS_CONNECTING, &cfg_priv->status)) {
 		if (completed) {
-			brcmf_get_assoc_ies(wl);
-			brcmf_update_prof(wl, NULL, &e->addr, WL_PROF_BSSID);
-			brcmf_update_bss_info(wl);
+			brcmf_get_assoc_ies(cfg_priv);
+			brcmf_update_prof(cfg_priv, NULL, &e->addr,
+					  WL_PROF_BSSID);
+			brcmf_update_bss_info(cfg_priv);
 		}
 		cfg80211_connect_result(ndev,
-					(u8 *)brcmf_read_prof(wl, WL_PROF_BSSID),
+					(u8 *)brcmf_read_prof(cfg_priv,
+							      WL_PROF_BSSID),
 					conn_info->req_ie,
 					conn_info->req_ie_len,
 					conn_info->resp_ie,
 					conn_info->resp_ie_len,
-					completed ? WLAN_STATUS_SUCCESS : WLAN_STATUS_AUTH_TIMEOUT,
+					completed ? WLAN_STATUS_SUCCESS :
+						    WLAN_STATUS_AUTH_TIMEOUT,
 					GFP_KERNEL);
 		if (completed)
-			set_bit(WL_STATUS_CONNECTED, &wl->status);
+			set_bit(WL_STATUS_CONNECTED, &cfg_priv->status);
 		WL_CONN("Report connect result - connection %s\n",
 				completed ? "succeeded" : "failed");
 	}
@@ -2896,7 +2935,8 @@ brcmf_bss_connect_done(struct wl_priv *wl, struct net_device *ndev,
 }
 
 static s32
-brcmf_notify_mic_status(struct wl_priv *wl, struct net_device *ndev,
+brcmf_notify_mic_status(struct brcmf_cfg80211_priv *cfg_priv,
+			struct net_device *ndev,
 			const struct brcmf_event_msg *e, void *data)
 {
 	u16 flags = be16_to_cpu(e->flags);
@@ -2916,7 +2956,8 @@ brcmf_notify_mic_status(struct wl_priv *wl, struct net_device *ndev,
 }
 
 static s32
-brcmf_notify_scan_status(struct wl_priv *wl, struct net_device *ndev,
+brcmf_notify_scan_status(struct brcmf_cfg80211_priv *cfg_priv,
+			 struct net_device *ndev,
 			 const struct brcmf_event_msg *e, void *data)
 {
 	struct brcmf_channel_info channel_inform;
@@ -2927,12 +2968,13 @@ brcmf_notify_scan_status(struct wl_priv *wl, struct net_device *ndev,
 
 	WL_TRACE("Enter\n");
 
-	if (wl->iscan_on && wl->iscan_kickstart) {
+	if (cfg_priv->iscan_on && cfg_priv->iscan_kickstart) {
 		WL_TRACE("Exit\n");
-		return brcmf_wakeup_iscan(wl_to_iscan(wl));
+		return brcmf_wakeup_iscan(wl_to_iscan(cfg_priv));
 	}
 
-	if (unlikely(!test_and_clear_bit(WL_STATUS_SCANNING, &wl->status))) {
+	if (unlikely(!test_and_clear_bit(WL_STATUS_SCANNING,
+					 &cfg_priv->status))) {
 		WL_ERR("Scan complete while device not scanning\n");
 		scan_abort = true;
 		err = -EINVAL;
@@ -2952,8 +2994,8 @@ brcmf_notify_scan_status(struct wl_priv *wl, struct net_device *ndev,
 		WL_CONN("channel_inform.scan_channel (%d)\n",
 		       channel_inform.scan_channel);
 	}
-	wl->bss_list = wl->scan_results;
-	bss_list = wl->bss_list;
+	cfg_priv->bss_list = cfg_priv->scan_results;
+	bss_list = cfg_priv->bss_list;
 	memset(bss_list, 0, len);
 	bss_list->buflen = cpu_to_le32(len);
 
@@ -2968,18 +3010,18 @@ brcmf_notify_scan_status(struct wl_priv *wl, struct net_device *ndev,
 	bss_list->version = le32_to_cpu(bss_list->version);
 	bss_list->count = le32_to_cpu(bss_list->count);
 
-	err = brcmf_inform_bss(wl);
+	err = brcmf_inform_bss(cfg_priv);
 	if (err) {
 		scan_abort = true;
 		goto scan_done_out;
 	}
 
 scan_done_out:
-	if (wl->scan_request) {
+	if (cfg_priv->scan_request) {
 		WL_SCAN("calling cfg80211_scan_done\n");
-		cfg80211_scan_done(wl->scan_request, scan_abort);
+		cfg80211_scan_done(cfg_priv->scan_request, scan_abort);
 		brcmf_set_mpc(ndev, 1);
-		wl->scan_request = NULL;
+		cfg_priv->scan_request = NULL;
 	}
 
 	WL_TRACE("Exit\n");
@@ -2987,7 +3029,7 @@ scan_done_out:
 	return err;
 }
 
-static void brcmf_init_conf(struct wl_conf *conf)
+static void brcmf_init_conf(struct brcmf_cfg80211_conf *conf)
 {
 	conf->mode = (u32)-1;
 	conf->frag_threshold = (u32)-1;
@@ -2997,12 +3039,12 @@ static void brcmf_init_conf(struct wl_conf *conf)
 	conf->tx_power = -1;
 }
 
-static void brcmf_init_prof(struct wl_profile *prof)
+static void brcmf_init_prof(struct brcmf_cfg80211_profile *prof)
 {
 	memset(prof, 0, sizeof(*prof));
 }
 
-static void brcmf_init_eloop_handler(struct wl_event_loop *el)
+static void brcmf_init_eloop_handler(struct brcmf_cfg80211_event_loop *el)
 {
 	memset(el, 0, sizeof(*el));
 	el->handler[BRCMF_E_SCAN_COMPLETE] = brcmf_notify_scan_status;
@@ -3012,50 +3054,51 @@ static void brcmf_init_eloop_handler(struct wl_event_loop *el)
 	el->handler[BRCMF_E_SET_SSID] = brcmf_notify_connect_status;
 }
 
-static s32 brcmf_init_priv_mem(struct wl_priv *wl)
+static s32 brcmf_init_priv_mem(struct brcmf_cfg80211_priv *cfg_priv)
 {
-	wl->scan_results = kzalloc(WL_SCAN_BUF_MAX, GFP_KERNEL);
-	if (unlikely(!wl->scan_results)) {
+	cfg_priv->scan_results = kzalloc(WL_SCAN_BUF_MAX, GFP_KERNEL);
+	if (unlikely(!cfg_priv->scan_results)) {
 		WL_ERR("Scan results alloc failed\n");
 		goto init_priv_mem_out;
 	}
-	wl->conf = kzalloc(sizeof(*wl->conf), GFP_KERNEL);
-	if (unlikely(!wl->conf)) {
+	cfg_priv->conf = kzalloc(sizeof(*cfg_priv->conf), GFP_KERNEL);
+	if (unlikely(!cfg_priv->conf)) {
 		WL_ERR("wl_conf alloc failed\n");
 		goto init_priv_mem_out;
 	}
-	wl->profile = kzalloc(sizeof(*wl->profile), GFP_KERNEL);
-	if (unlikely(!wl->profile)) {
+	cfg_priv->profile = kzalloc(sizeof(*cfg_priv->profile), GFP_KERNEL);
+	if (unlikely(!cfg_priv->profile)) {
 		WL_ERR("wl_profile alloc failed\n");
 		goto init_priv_mem_out;
 	}
-	wl->bss_info = kzalloc(WL_BSS_INFO_MAX, GFP_KERNEL);
-	if (unlikely(!wl->bss_info)) {
+	cfg_priv->bss_info = kzalloc(WL_BSS_INFO_MAX, GFP_KERNEL);
+	if (unlikely(!cfg_priv->bss_info)) {
 		WL_ERR("Bss information alloc failed\n");
 		goto init_priv_mem_out;
 	}
-	wl->scan_req_int = kzalloc(sizeof(*wl->scan_req_int), GFP_KERNEL);
-	if (unlikely(!wl->scan_req_int)) {
+	cfg_priv->scan_req_int = kzalloc(sizeof(*cfg_priv->scan_req_int),
+					 GFP_KERNEL);
+	if (unlikely(!cfg_priv->scan_req_int)) {
 		WL_ERR("Scan req alloc failed\n");
 		goto init_priv_mem_out;
 	}
-	wl->ioctl_buf = kzalloc(WL_IOCTL_LEN_MAX, GFP_KERNEL);
-	if (unlikely(!wl->ioctl_buf)) {
+	cfg_priv->ioctl_buf = kzalloc(WL_IOCTL_LEN_MAX, GFP_KERNEL);
+	if (unlikely(!cfg_priv->ioctl_buf)) {
 		WL_ERR("Ioctl buf alloc failed\n");
 		goto init_priv_mem_out;
 	}
-	wl->extra_buf = kzalloc(WL_EXTRA_BUF_MAX, GFP_KERNEL);
-	if (unlikely(!wl->extra_buf)) {
+	cfg_priv->extra_buf = kzalloc(WL_EXTRA_BUF_MAX, GFP_KERNEL);
+	if (unlikely(!cfg_priv->extra_buf)) {
 		WL_ERR("Extra buf alloc failed\n");
 		goto init_priv_mem_out;
 	}
-	wl->iscan = kzalloc(sizeof(*wl->iscan), GFP_KERNEL);
-	if (unlikely(!wl->iscan)) {
+	cfg_priv->iscan = kzalloc(sizeof(*cfg_priv->iscan), GFP_KERNEL);
+	if (unlikely(!cfg_priv->iscan)) {
 		WL_ERR("Iscan buf alloc failed\n");
 		goto init_priv_mem_out;
 	}
-	wl->pmk_list = kzalloc(sizeof(*wl->pmk_list), GFP_KERNEL);
-	if (unlikely(!wl->pmk_list)) {
+	cfg_priv->pmk_list = kzalloc(sizeof(*cfg_priv->pmk_list), GFP_KERNEL);
+	if (unlikely(!cfg_priv->pmk_list)) {
 		WL_ERR("pmk list alloc failed\n");
 		goto init_priv_mem_out;
 	}
@@ -3063,59 +3106,60 @@ static s32 brcmf_init_priv_mem(struct wl_priv *wl)
 	return 0;
 
 init_priv_mem_out:
-	brcmf_deinit_priv_mem(wl);
+	brcmf_deinit_priv_mem(cfg_priv);
 
 	return -ENOMEM;
 }
 
-static void brcmf_deinit_priv_mem(struct wl_priv *wl)
-{
-	kfree(wl->scan_results);
-	wl->scan_results = NULL;
-	kfree(wl->bss_info);
-	wl->bss_info = NULL;
-	kfree(wl->conf);
-	wl->conf = NULL;
-	kfree(wl->profile);
-	wl->profile = NULL;
-	kfree(wl->scan_req_int);
-	wl->scan_req_int = NULL;
-	kfree(wl->ioctl_buf);
-	wl->ioctl_buf = NULL;
-	kfree(wl->extra_buf);
-	wl->extra_buf = NULL;
-	kfree(wl->iscan);
-	wl->iscan = NULL;
-	kfree(wl->pmk_list);
-	wl->pmk_list = NULL;
-}
-
-static s32 brcmf_create_event_handler(struct wl_priv *wl)
-{
-	sema_init(&wl->event_sync, 0);
-	wl->event_tsk = kthread_run(brcmf_event_handler, wl, "wl_event_handler");
-	if (IS_ERR(wl->event_tsk)) {
-		wl->event_tsk = NULL;
+static void brcmf_deinit_priv_mem(struct brcmf_cfg80211_priv *cfg_priv)
+{
+	kfree(cfg_priv->scan_results);
+	cfg_priv->scan_results = NULL;
+	kfree(cfg_priv->bss_info);
+	cfg_priv->bss_info = NULL;
+	kfree(cfg_priv->conf);
+	cfg_priv->conf = NULL;
+	kfree(cfg_priv->profile);
+	cfg_priv->profile = NULL;
+	kfree(cfg_priv->scan_req_int);
+	cfg_priv->scan_req_int = NULL;
+	kfree(cfg_priv->ioctl_buf);
+	cfg_priv->ioctl_buf = NULL;
+	kfree(cfg_priv->extra_buf);
+	cfg_priv->extra_buf = NULL;
+	kfree(cfg_priv->iscan);
+	cfg_priv->iscan = NULL;
+	kfree(cfg_priv->pmk_list);
+	cfg_priv->pmk_list = NULL;
+}
+
+static s32 brcmf_create_event_handler(struct brcmf_cfg80211_priv *cfg_priv)
+{
+	sema_init(&cfg_priv->event_sync, 0);
+	cfg_priv->event_tsk = kthread_run(brcmf_event_handler, cfg_priv,
+					  "wl_event_handler");
+	if (IS_ERR(cfg_priv->event_tsk)) {
+		cfg_priv->event_tsk = NULL;
 		WL_ERR("failed to create event thread\n");
 		return -ENOMEM;
 	}
 	return 0;
 }
 
-static void brcmf_destroy_event_handler(struct wl_priv *wl)
+static void brcmf_destroy_event_handler(struct brcmf_cfg80211_priv *cfg_priv)
 {
-	if (wl->event_tsk) {
-		send_sig(SIGTERM, wl->event_tsk, 1);
-		kthread_stop(wl->event_tsk);
-		wl->event_tsk = NULL;
+	if (cfg_priv->event_tsk) {
+		send_sig(SIGTERM, cfg_priv->event_tsk, 1);
+		kthread_stop(cfg_priv->event_tsk);
+		cfg_priv->event_tsk = NULL;
 	}
 }
 
-static void brcmf_term_iscan(struct wl_priv *wl)
+static void brcmf_term_iscan(struct brcmf_cfg80211_priv *cfg_priv)
 {
-	struct wl_iscan_ctrl *iscan = wl_to_iscan(wl);
+	struct brcmf_cfg80211_iscan_ctrl *iscan = wl_to_iscan(cfg_priv);
 
-	if (wl->iscan_on && iscan->tsk) {
+	if (cfg_priv->iscan_on && iscan->tsk) {
 		iscan->state = WL_ISCAN_STATE_IDLE;
 		send_sig(SIGTERM, iscan->tsk, 1);
 		kthread_stop(iscan->tsk);
@@ -3123,26 +3167,28 @@ static void brcmf_term_iscan(struct wl_priv *wl)
 	}
 }
 
-static void brcmf_notify_iscan_complete(struct wl_iscan_ctrl *iscan, bool aborted)
+static void brcmf_notify_iscan_complete(struct brcmf_cfg80211_iscan_ctrl *iscan,
+					bool aborted)
 {
-	struct wl_priv *wl = iscan_to_wl(iscan);
-	struct net_device *ndev = wl_to_ndev(wl);
+	struct brcmf_cfg80211_priv *cfg_priv = iscan_to_wl(iscan);
+	struct net_device *ndev = wl_to_ndev(cfg_priv);
 
-	if (unlikely(!test_and_clear_bit(WL_STATUS_SCANNING, &wl->status))) {
+	if (unlikely(!test_and_clear_bit(WL_STATUS_SCANNING,
+					 &cfg_priv->status))) {
 		WL_ERR("Scan complete while device not scanning\n");
 		return;
 	}
-	if (likely(wl->scan_request)) {
+	if (likely(cfg_priv->scan_request)) {
 		WL_SCAN("ISCAN Completed scan: %s\n",
 				aborted ? "Aborted" : "Done");
-		cfg80211_scan_done(wl->scan_request, aborted);
+		cfg80211_scan_done(cfg_priv->scan_request, aborted);
 		brcmf_set_mpc(ndev, 1);
-		wl->scan_request = NULL;
+		cfg_priv->scan_request = NULL;
 	}
-	wl->iscan_kickstart = false;
+	cfg_priv->iscan_kickstart = false;
 }
 
-static s32 brcmf_wakeup_iscan(struct wl_iscan_ctrl *iscan)
+static s32 brcmf_wakeup_iscan(struct brcmf_cfg80211_iscan_ctrl *iscan)
 {
 	if (likely(iscan->state != WL_ISCAN_STATE_IDLE)) {
 		WL_SCAN("wake up iscan\n");
@@ -3154,7 +3200,7 @@ static s32 brcmf_wakeup_iscan(struct wl_iscan_ctrl *iscan)
 }
 
 static s32
-brcmf_get_iscan_results(struct wl_iscan_ctrl *iscan, u32 *status,
+brcmf_get_iscan_results(struct brcmf_cfg80211_iscan_ctrl *iscan, u32 *status,
 		     struct brcmf_scan_results **bss_list)
 {
 	struct brcmf_iscan_results list;
@@ -3189,23 +3235,23 @@ brcmf_get_iscan_results(struct wl_iscan_ctrl *iscan, u32 *status,
 	return err;
 }
 
-static s32 brcmf_iscan_done(struct wl_priv *wl)
+static s32 brcmf_iscan_done(struct brcmf_cfg80211_priv *cfg_priv)
 {
-	struct wl_iscan_ctrl *iscan = wl->iscan;
+	struct brcmf_cfg80211_iscan_ctrl *iscan = cfg_priv->iscan;
 	s32 err = 0;
 
 	iscan->state = WL_ISCAN_STATE_IDLE;
 	rtnl_lock();
-	brcmf_inform_bss(wl);
+	brcmf_inform_bss(cfg_priv);
 	brcmf_notify_iscan_complete(iscan, false);
 	rtnl_unlock();
 
 	return err;
 }
 
-static s32 brcmf_iscan_pending(struct wl_priv *wl)
+static s32 brcmf_iscan_pending(struct brcmf_cfg80211_priv *cfg_priv)
 {
-	struct wl_iscan_ctrl *iscan = wl->iscan;
+	struct brcmf_cfg80211_iscan_ctrl *iscan = cfg_priv->iscan;
 	s32 err = 0;
 
 	/* Reschedule the timer */
@@ -3215,13 +3261,13 @@ static s32 brcmf_iscan_pending(struct wl_priv *wl)
 	return err;
 }
 
-static s32 brcmf_iscan_inprogress(struct wl_priv *wl)
+static s32 brcmf_iscan_inprogress(struct brcmf_cfg80211_priv *cfg_priv)
 {
-	struct wl_iscan_ctrl *iscan = wl->iscan;
+	struct brcmf_cfg80211_iscan_ctrl *iscan = cfg_priv->iscan;
 	s32 err = 0;
 
 	rtnl_lock();
-	brcmf_inform_bss(wl);
+	brcmf_inform_bss(cfg_priv);
 	brcmf_run_iscan(iscan, NULL, BRCMF_SCAN_ACTION_CONTINUE);
 	rtnl_unlock();
 	/* Reschedule the timer */
@@ -3231,9 +3277,9 @@ static s32 brcmf_iscan_inprogress(struct wl_priv *wl)
 	return err;
 }
 
-static s32 brcmf_iscan_aborted(struct wl_priv *wl)
+static s32 brcmf_iscan_aborted(struct brcmf_cfg80211_priv *cfg_priv)
 {
-	struct wl_iscan_ctrl *iscan = wl->iscan;
+	struct brcmf_cfg80211_iscan_ctrl *iscan = cfg_priv->iscan;
 	s32 err = 0;
 
 	iscan->state = WL_ISCAN_STATE_IDLE;
@@ -3247,9 +3293,10 @@ static s32 brcmf_iscan_aborted(struct wl_priv *wl)
 static s32 brcmf_iscan_thread(void *data)
 {
 	struct sched_param param = {.sched_priority = MAX_RT_PRIO - 1 };
-	struct wl_iscan_ctrl *iscan = (struct wl_iscan_ctrl *)data;
-	struct wl_priv *wl = iscan_to_wl(iscan);
-	struct wl_iscan_eloop *el = &iscan->el;
+	struct brcmf_cfg80211_iscan_ctrl *iscan =
+			(struct brcmf_cfg80211_iscan_ctrl *)data;
+	struct brcmf_cfg80211_priv *cfg_priv = iscan_to_wl(iscan);
+	struct brcmf_cfg80211_iscan_eloop *el = &iscan->el;
 	u32 status;
 	int err = 0;
 
@@ -3264,13 +3311,14 @@ static s32 brcmf_iscan_thread(void *data)
 			iscan->timer_on = 0;
 		}
 		rtnl_lock();
-		err = brcmf_get_iscan_results(iscan, &status, &wl->bss_list);
+		err = brcmf_get_iscan_results(iscan, &status,
+					      &cfg_priv->bss_list);
 		if (unlikely(err)) {
 			status = BRCMF_SCAN_RESULTS_ABORTED;
 			WL_ERR("Abort iscan\n");
 		}
 		rtnl_unlock();
-		el->handler[status] (wl);
+		el->handler[status](cfg_priv);
 	}
 	if (iscan->timer_on) {
 		del_timer_sync(&iscan->timer);
@@ -3283,7 +3331,8 @@ static s32 brcmf_iscan_thread(void *data)
 
 static void brcmf_iscan_timer(unsigned long data)
 {
-	struct wl_iscan_ctrl *iscan = (struct wl_iscan_ctrl *)data;
+	struct brcmf_cfg80211_iscan_ctrl *iscan =
+			(struct brcmf_cfg80211_iscan_ctrl *)data;
 
 	if (iscan) {
 		iscan->timer_on = 0;
@@ -3292,12 +3341,12 @@ static void brcmf_iscan_timer(unsigned long data)
 	}
 }
 
-static s32 brcmf_invoke_iscan(struct wl_priv *wl)
+static s32 brcmf_invoke_iscan(struct brcmf_cfg80211_priv *cfg_priv)
 {
-	struct wl_iscan_ctrl *iscan = wl_to_iscan(wl);
+	struct brcmf_cfg80211_iscan_ctrl *iscan = wl_to_iscan(cfg_priv);
 	int err = 0;
 
-	if (wl->iscan_on && !iscan->tsk) {
+	if (cfg_priv->iscan_on && !iscan->tsk) {
 		iscan->state = WL_ISCAN_STATE_IDLE;
 		sema_init(&iscan->sync, 0);
 		iscan->tsk = kthread_run(brcmf_iscan_thread, iscan, "wl_iscan");
@@ -3311,7 +3360,7 @@ static s32 brcmf_invoke_iscan(struct wl_priv *wl)
 	return err;
 }
 
-static void brcmf_init_iscan_eloop(struct wl_iscan_eloop *el)
+static void brcmf_init_iscan_eloop(struct brcmf_cfg80211_iscan_eloop *el)
 {
 	memset(el, 0, sizeof(*el));
 	el->handler[BRCMF_SCAN_RESULTS_SUCCESS] = brcmf_iscan_done;
@@ -3321,13 +3370,13 @@ static void brcmf_init_iscan_eloop(struct wl_iscan_eloop *el)
 	el->handler[BRCMF_SCAN_RESULTS_NO_MEM] = brcmf_iscan_aborted;
 }
 
-static s32 brcmf_init_iscan(struct wl_priv *wl)
+static s32 brcmf_init_iscan(struct brcmf_cfg80211_priv *cfg_priv)
 {
-	struct wl_iscan_ctrl *iscan = wl_to_iscan(wl);
+	struct brcmf_cfg80211_iscan_ctrl *iscan = wl_to_iscan(cfg_priv);
 	int err = 0;
 
-	if (wl->iscan_on) {
-		iscan->dev = wl_to_ndev(wl);
+	if (cfg_priv->iscan_on) {
+		iscan->dev = wl_to_ndev(cfg_priv);
 		iscan->state = WL_ISCAN_STATE_IDLE;
 		brcmf_init_iscan_eloop(&iscan->el);
 		iscan->timer_ms = WL_ISCAN_TIMER_INTERVAL_MS;
@@ -3341,139 +3390,142 @@ static s32 brcmf_init_iscan(struct wl_priv *wl)
 			iscan->tsk = NULL;
 			return -ENOMEM;
 		}
-		iscan->data = wl;
+		iscan->data = cfg_priv;
 	}
 
 	return err;
 }
 
-static s32 wl_init_priv(struct wl_priv *wl)
+static s32 wl_init_priv(struct brcmf_cfg80211_priv *cfg_priv)
 {
-	struct wiphy *wiphy = wl_to_wiphy(wl);
+	struct wiphy *wiphy = wl_to_wiphy(cfg_priv);
 	s32 err = 0;
 
-	wl->scan_request = NULL;
-	wl->pwr_save = !!(wiphy->flags & WIPHY_FLAG_PS_ON_BY_DEFAULT);
-	wl->iscan_on = true;	/* iscan on & off switch.
+	cfg_priv->scan_request = NULL;
+	cfg_priv->pwr_save = !!(wiphy->flags & WIPHY_FLAG_PS_ON_BY_DEFAULT);
+	cfg_priv->iscan_on = true;	/* iscan on & off switch.
 				 we enable iscan per default */
-	wl->roam_on = false;	/* roam on & off switch.
+	cfg_priv->roam_on = false;	/* roam on & off switch.
 				 we enable roam per default */
 
-	wl->iscan_kickstart = false;
-	wl->active_scan = true;	/* we do active scan for
+	cfg_priv->iscan_kickstart = false;
+	cfg_priv->active_scan = true;	/* we do active scan for
 				 specific scan per default */
-	wl->dongle_up = false;	/* dongle is not up yet */
-	brcmf_init_eq(wl);
-	err = brcmf_init_priv_mem(wl);
+	cfg_priv->dongle_up = false;	/* dongle is not up yet */
+	brcmf_init_eq(cfg_priv);
+	err = brcmf_init_priv_mem(cfg_priv);
 	if (unlikely(err))
 		return err;
-	if (unlikely(brcmf_create_event_handler(wl)))
+	if (unlikely(brcmf_create_event_handler(cfg_priv)))
 		return -ENOMEM;
-	brcmf_init_eloop_handler(&wl->el);
-	mutex_init(&wl->usr_sync);
-	err = brcmf_init_iscan(wl);
+	brcmf_init_eloop_handler(&cfg_priv->el);
+	mutex_init(&cfg_priv->usr_sync);
+	err = brcmf_init_iscan(cfg_priv);
 	if (unlikely(err))
 		return err;
-	brcmf_init_conf(wl->conf);
-	brcmf_init_prof(wl->profile);
-	brcmf_link_down(wl);
+	brcmf_init_conf(cfg_priv->conf);
+	brcmf_init_prof(cfg_priv->profile);
+	brcmf_link_down(cfg_priv);
 
 	return err;
 }
 
-static void wl_deinit_priv(struct wl_priv *wl)
+static void wl_deinit_priv(struct brcmf_cfg80211_priv *cfg_priv)
 {
-	brcmf_destroy_event_handler(wl);
-	wl->dongle_up = false;	/* dongle down */
-	brcmf_flush_eq(wl);
-	brcmf_link_down(wl);
-	brcmf_term_iscan(wl);
-	brcmf_deinit_priv_mem(wl);
+	brcmf_destroy_event_handler(cfg_priv);
+	cfg_priv->dongle_up = false;	/* dongle down */
+	brcmf_flush_eq(cfg_priv);
+	brcmf_link_down(cfg_priv);
+	brcmf_term_iscan(cfg_priv);
+	brcmf_deinit_priv_mem(cfg_priv);
 }
 
 s32 wl_cfg80211_attach(struct net_device *ndev, void *data)
 {
 	struct wireless_dev *wdev;
-	struct wl_priv *wl;
-	struct wl_iface *ci;
+	struct brcmf_cfg80211_priv *cfg_priv;
+	struct brcmf_cfg80211_iface *ci;
 	s32 err = 0;
 
 	if (unlikely(!ndev)) {
 		WL_ERR("ndev is invalid\n");
 		return -ENODEV;
 	}
-	wl_cfg80211_dev = kzalloc(sizeof(struct wl_dev), GFP_KERNEL);
-	if (unlikely(!wl_cfg80211_dev)) {
+	cfg80211_dev = kzalloc(sizeof(struct brcmf_cfg80211_dev), GFP_KERNEL);
+	if (unlikely(!cfg80211_dev)) {
 		WL_ERR("wl_cfg80211_dev is invalid\n");
 		return -ENOMEM;
 	}
 	WL_INFO("func %p\n", wl_cfg80211_get_sdio_func());
-	wdev = brcmf_alloc_wdev(sizeof(struct wl_iface), &wl_cfg80211_get_sdio_func()->dev);
+	wdev = brcmf_alloc_wdev(sizeof(struct brcmf_cfg80211_iface),
+				&wl_cfg80211_get_sdio_func()->dev);
 	if (IS_ERR(wdev))
 		return -ENOMEM;
 
 	wdev->iftype = brcmf_mode_to_nl80211_iftype(WL_MODE_BSS);
-	wl = wdev_to_wl(wdev);
-	wl->wdev = wdev;
-	wl->pub = data;
-	ci = (struct wl_iface *)wl_to_ci(wl);
-	ci->wl = wl;
+	cfg_priv = wdev_to_wl(wdev);
+	cfg_priv->wdev = wdev;
+	cfg_priv->pub = data;
+	ci = (struct brcmf_cfg80211_iface *)wl_to_ci(cfg_priv);
+	ci->cfg_priv = cfg_priv;
 	ndev->ieee80211_ptr = wdev;
 	SET_NETDEV_DEV(ndev, wiphy_dev(wdev->wiphy));
 	wdev->netdev = ndev;
-	err = wl_init_priv(wl);
+	err = wl_init_priv(cfg_priv);
 	if (unlikely(err)) {
 		WL_ERR("Failed to init iwm_priv (%d)\n", err);
 		goto cfg80211_attach_out;
 	}
-	brcmf_set_drvdata(wl_cfg80211_dev, ci);
+	brcmf_set_drvdata(cfg80211_dev, ci);
 
 	return err;
 
 cfg80211_attach_out:
-	brcmf_free_wdev(wl);
+	brcmf_free_wdev(cfg_priv);
 	return err;
 }
 
 void wl_cfg80211_detach(void)
 {
-	struct wl_priv *wl;
+	struct brcmf_cfg80211_priv *cfg_priv;
 
-	wl = WL_PRIV_GET();
+	cfg_priv = WL_PRIV_GET();
 
-	wl_deinit_priv(wl);
-	brcmf_free_wdev(wl);
-	brcmf_set_drvdata(wl_cfg80211_dev, NULL);
-	kfree(wl_cfg80211_dev);
-	wl_cfg80211_dev = NULL;
+	wl_deinit_priv(cfg_priv);
+	brcmf_free_wdev(cfg_priv);
+	brcmf_set_drvdata(cfg80211_dev, NULL);
+	kfree(cfg80211_dev);
+	cfg80211_dev = NULL;
 	brcmf_clear_sdio_func();
 }
 
-static void brcmf_wakeup_event(struct wl_priv *wl)
+static void brcmf_wakeup_event(struct brcmf_cfg80211_priv *cfg_priv)
 {
-	up(&wl->event_sync);
+	up(&cfg_priv->event_sync);
 }
 
 static s32 brcmf_event_handler(void *data)
 {
-	struct wl_priv *wl = (struct wl_priv *)data;
+	struct brcmf_cfg80211_priv *cfg_priv =
+			(struct brcmf_cfg80211_priv *)data;
 	struct sched_param param = {.sched_priority = MAX_RT_PRIO - 1 };
-	struct wl_event_q *e;
+	struct brcmf_cfg80211_event_q *e;
 
 	sched_setscheduler(current, SCHED_FIFO, &param);
 	allow_signal(SIGTERM);
-	while (likely(!down_interruptible(&wl->event_sync))) {
+	while (likely(!down_interruptible(&cfg_priv->event_sync))) {
 		if (kthread_should_stop())
 			break;
-		e = brcmf_deq_event(wl);
+		e = brcmf_deq_event(cfg_priv);
 		if (unlikely(!e)) {
 			WL_ERR("event queue empty...\n");
 			BUG();
 		}
 		WL_INFO("event type (%d)\n", e->etype);
-		if (wl->el.handler[e->etype]) {
-			wl->el.handler[e->etype] (wl, wl_to_ndev(wl), &e->emsg,
-						  e->edata);
+		if (cfg_priv->el.handler[e->etype]) {
+			cfg_priv->el.handler[e->etype](cfg_priv,
+						       wl_to_ndev(cfg_priv),
+						       &e->emsg, e->edata);
 		} else {
 			WL_INFO("Unknown Event (%d): ignoring\n", e->etype);
 		}
@@ -3488,45 +3540,48 @@ wl_cfg80211_event(struct net_device *ndev,
 		  const struct brcmf_event_msg *e, void *data)
 {
 	u32 event_type = be32_to_cpu(e->event_type);
-	struct wl_priv *wl = ndev_to_wl(ndev);
+	struct brcmf_cfg80211_priv *cfg_priv = ndev_to_wl(ndev);
 
-	if (likely(!brcmf_enq_event(wl, event_type, e, data)))
-		brcmf_wakeup_event(wl);
+	if (likely(!brcmf_enq_event(cfg_priv, event_type, e, data)))
+		brcmf_wakeup_event(cfg_priv);
 }
 
-static void brcmf_init_eq(struct wl_priv *wl)
+static void brcmf_init_eq(struct brcmf_cfg80211_priv *cfg_priv)
 {
-	brcmf_init_eq_lock(wl);
-	INIT_LIST_HEAD(&wl->eq_list);
+	brcmf_init_eq_lock(cfg_priv);
+	INIT_LIST_HEAD(&cfg_priv->eq_list);
 }
 
-static void brcmf_flush_eq(struct wl_priv *wl)
+static void brcmf_flush_eq(struct brcmf_cfg80211_priv *cfg_priv)
 {
-	struct wl_event_q *e;
+	struct brcmf_cfg80211_event_q *e;
 
-	brcmf_lock_eq(wl);
-	while (!list_empty(&wl->eq_list)) {
-		e = list_first_entry(&wl->eq_list, struct wl_event_q, eq_list);
+	brcmf_lock_eq(cfg_priv);
+	while (!list_empty(&cfg_priv->eq_list)) {
+		e = list_first_entry(&cfg_priv->eq_list,
+				     struct brcmf_cfg80211_event_q, eq_list);
 		list_del(&e->eq_list);
 		kfree(e);
 	}
-	brcmf_unlock_eq(wl);
+	brcmf_unlock_eq(cfg_priv);
 }
 
 /*
 * retrieve first queued event from head
 */
 
-static struct wl_event_q *brcmf_deq_event(struct wl_priv *wl)
+static struct brcmf_cfg80211_event_q *brcmf_deq_event(
+	struct brcmf_cfg80211_priv *cfg_priv)
 {
-	struct wl_event_q *e = NULL;
+	struct brcmf_cfg80211_event_q *e = NULL;
 
-	brcmf_lock_eq(wl);
-	if (likely(!list_empty(&wl->eq_list))) {
-		e = list_first_entry(&wl->eq_list, struct wl_event_q, eq_list);
+	brcmf_lock_eq(cfg_priv);
+	if (likely(!list_empty(&cfg_priv->eq_list))) {
+		e = list_first_entry(&cfg_priv->eq_list,
+				     struct brcmf_cfg80211_event_q, eq_list);
 		list_del(&e->eq_list);
 	}
-	brcmf_unlock_eq(wl);
+	brcmf_unlock_eq(cfg_priv);
 
 	return e;
 }
@@ -3536,13 +3591,13 @@ static struct wl_event_q *brcmf_deq_event(struct wl_priv *wl)
 */
 
 static s32
-brcmf_enq_event(struct wl_priv *wl, u32 event, const struct brcmf_event_msg *msg,
-		void *data)
+brcmf_enq_event(struct brcmf_cfg80211_priv *cfg_priv, u32 event,
+		const struct brcmf_event_msg *msg, void *data)
 {
-	struct wl_event_q *e;
+	struct brcmf_cfg80211_event_q *e;
 	s32 err = 0;
 
-	e = kzalloc(sizeof(struct wl_event_q), GFP_KERNEL);
+	e = kzalloc(sizeof(struct brcmf_cfg80211_event_q), GFP_KERNEL);
 	if (unlikely(!e)) {
 		WL_ERR("event alloc failed\n");
 		return -ENOMEM;
@@ -3552,14 +3607,14 @@ brcmf_enq_event(struct wl_priv *wl, u32 event, const struct brcmf_event_msg *msg
 	memcpy(&e->emsg, msg, sizeof(struct brcmf_event_msg));
 	if (data) {
 	}
-	brcmf_lock_eq(wl);
-	list_add_tail(&e->eq_list, &wl->eq_list);
-	brcmf_unlock_eq(wl);
+	brcmf_lock_eq(cfg_priv);
+	list_add_tail(&e->eq_list, &cfg_priv->eq_list);
+	brcmf_unlock_eq(cfg_priv);
 
 	return err;
 }
 
-static void brcmf_put_event(struct wl_event_q *e)
+static void brcmf_put_event(struct brcmf_cfg80211_event_q *e)
 {
 	kfree(e);
 }
@@ -3761,16 +3816,16 @@ dongle_scantime_out:
 	return err;
 }
 
-s32 brcmf_config_dongle(struct wl_priv *wl, bool need_lock)
+s32 brcmf_config_dongle(struct brcmf_cfg80211_priv *cfg_priv, bool need_lock)
 {
 	struct net_device *ndev;
 	struct wireless_dev *wdev;
 	s32 err = 0;
 
-	if (wl->dongle_up)
+	if (cfg_priv->dongle_up)
 		return err;
 
-	ndev = wl_to_ndev(wl);
+	ndev = wl_to_ndev(cfg_priv);
 	wdev = ndev->ieee80211_ptr;
 	if (need_lock)
 		rtnl_lock();
@@ -3781,13 +3836,14 @@ s32 brcmf_config_dongle(struct wl_priv *wl, bool need_lock)
 	err = brcmf_dongle_eventmsg(ndev);
 	if (unlikely(err))
 		goto default_conf_out;
-	err = brcmf_dongle_roam(ndev, (wl->roam_on ? 0 : 1), WL_BEACON_TIMEOUT);
+	err = brcmf_dongle_roam(ndev, (cfg_priv->roam_on ? 0 : 1),
+				WL_BEACON_TIMEOUT);
 	if (unlikely(err))
 		goto default_conf_out;
 	err = brcmf_dongle_mode(ndev, wdev->iftype);
 	if (unlikely(err && err != -EINPROGRESS))
 		goto default_conf_out;
-	err = brcmf_dongle_probecap(wl);
+	err = brcmf_dongle_probecap(cfg_priv);
 	if (unlikely(err))
 		goto default_conf_out;
 
@@ -3797,20 +3853,20 @@ default_conf_out:
 	if (need_lock)
 		rtnl_unlock();
 
-	wl->dongle_up = true;
+	cfg_priv->dongle_up = true;
 
 	return err;
 
 }
 
-static s32 wl_update_wiphybands(struct wl_priv *wl)
+static s32 wl_update_wiphybands(struct brcmf_cfg80211_priv *cfg_priv)
 {
 	struct wiphy *wiphy;
 	s32 phy_list;
 	s8 phy;
 	s32 err = 0;
 
-	err = brcmf_dev_ioctl(wl_to_ndev(wl), WLC_GET_PHYLIST, &phy_list,
+	err = brcmf_dev_ioctl(wl_to_ndev(cfg_priv), WLC_GET_PHYLIST, &phy_list,
 			sizeof(phy_list));
 	if (unlikely(err)) {
 		WL_ERR("error (%d)\n", err);
@@ -3820,41 +3876,41 @@ static s32 wl_update_wiphybands(struct wl_priv *wl)
 	phy = ((char *)&phy_list)[1];
 	WL_INFO("%c phy\n", phy);
 	if (phy == 'n' || phy == 'a') {
-		wiphy = wl_to_wiphy(wl);
+		wiphy = wl_to_wiphy(cfg_priv);
 		wiphy->bands[IEEE80211_BAND_5GHZ] = &__wl_band_5ghz_n;
 	}
 
 	return err;
 }
 
-static s32 __brcmf_cfg80211_up(struct wl_priv *wl)
+static s32 __brcmf_cfg80211_up(struct brcmf_cfg80211_priv *cfg_priv)
 {
 	s32 err = 0;
 
-	set_bit(WL_STATUS_READY, &wl->status);
+	set_bit(WL_STATUS_READY, &cfg_priv->status);
 
-	brcmf_debugfs_add_netdev_params(wl);
+	brcmf_debugfs_add_netdev_params(cfg_priv);
 
-	err = brcmf_config_dongle(wl, false);
+	err = brcmf_config_dongle(cfg_priv, false);
 	if (unlikely(err))
 		return err;
 
-	brcmf_invoke_iscan(wl);
+	brcmf_invoke_iscan(cfg_priv);
 
 	return err;
 }
 
-static s32 __brcmf_cfg80211_down(struct wl_priv *wl)
+static s32 __brcmf_cfg80211_down(struct brcmf_cfg80211_priv *cfg_priv)
 {
 	/*
 	 * While going down, if associated with AP disassociate
 	 * from AP to save power
 	 */
-	if ((test_bit(WL_STATUS_CONNECTED, &wl->status) ||
-	     test_bit(WL_STATUS_CONNECTING, &wl->status)) &&
-	     test_bit(WL_STATUS_READY, &wl->status)) {
+	if ((test_bit(WL_STATUS_CONNECTED, &cfg_priv->status) ||
+	     test_bit(WL_STATUS_CONNECTING, &cfg_priv->status)) &&
+	     test_bit(WL_STATUS_READY, &cfg_priv->status)) {
 		WL_INFO("Disassociating from AP");
-		brcmf_link_down(wl);
+		brcmf_link_down(cfg_priv);
 
 		/* Make sure WPA_Supplicant receives all the event
 		   generated due to DISASSOC call to the fw to keep
@@ -3865,71 +3921,71 @@ static s32 __brcmf_cfg80211_down(struct wl_priv *wl)
 		rtnl_lock();
 	}
 
-	set_bit(WL_STATUS_SCAN_ABORTING, &wl->status);
-	brcmf_term_iscan(wl);
-	if (wl->scan_request) {
-		cfg80211_scan_done(wl->scan_request, true);
+	set_bit(WL_STATUS_SCAN_ABORTING, &cfg_priv->status);
+	brcmf_term_iscan(cfg_priv);
+	if (cfg_priv->scan_request) {
+		cfg80211_scan_done(cfg_priv->scan_request, true);
 		/* May need to perform this to cover rmmod */
 		/* wl_set_mpc(wl_to_ndev(wl), 1); */
-		wl->scan_request = NULL;
+		cfg_priv->scan_request = NULL;
 	}
-	clear_bit(WL_STATUS_READY, &wl->status);
-	clear_bit(WL_STATUS_SCANNING, &wl->status);
-	clear_bit(WL_STATUS_SCAN_ABORTING, &wl->status);
+	clear_bit(WL_STATUS_READY, &cfg_priv->status);
+	clear_bit(WL_STATUS_SCANNING, &cfg_priv->status);
+	clear_bit(WL_STATUS_SCAN_ABORTING, &cfg_priv->status);
 
-	brcmf_debugfs_remove_netdev(wl);
+	brcmf_debugfs_remove_netdev(cfg_priv);
 
 	return 0;
 }
 
 s32 wl_cfg80211_up(void)
 {
-	struct wl_priv *wl;
+	struct brcmf_cfg80211_priv *cfg_priv;
 	s32 err = 0;
 
-	wl = WL_PRIV_GET();
-	mutex_lock(&wl->usr_sync);
-	err = __brcmf_cfg80211_up(wl);
-	mutex_unlock(&wl->usr_sync);
+	cfg_priv = WL_PRIV_GET();
+	mutex_lock(&cfg_priv->usr_sync);
+	err = __brcmf_cfg80211_up(cfg_priv);
+	mutex_unlock(&cfg_priv->usr_sync);
 
 	return err;
 }
 
 s32 wl_cfg80211_down(void)
 {
-	struct wl_priv *wl;
+	struct brcmf_cfg80211_priv *cfg_priv;
 	s32 err = 0;
 
-	wl = WL_PRIV_GET();
-	mutex_lock(&wl->usr_sync);
-	err = __brcmf_cfg80211_down(wl);
-	mutex_unlock(&wl->usr_sync);
+	cfg_priv = WL_PRIV_GET();
+	mutex_lock(&cfg_priv->usr_sync);
+	err = __brcmf_cfg80211_down(cfg_priv);
+	mutex_unlock(&cfg_priv->usr_sync);
 
 	return err;
 }
 
-static s32 brcmf_dongle_probecap(struct wl_priv *wl)
+static s32 brcmf_dongle_probecap(struct brcmf_cfg80211_priv *cfg_priv)
 {
-	return wl_update_wiphybands(wl);
+	return wl_update_wiphybands(cfg_priv);
 }
 
-static void *brcmf_read_prof(struct wl_priv *wl, s32 item)
+static void *brcmf_read_prof(struct brcmf_cfg80211_priv *cfg_priv, s32 item)
 {
 	switch (item) {
 	case WL_PROF_SEC:
-		return &wl->profile->sec;
+		return &cfg_priv->profile->sec;
 	case WL_PROF_BSSID:
-		return &wl->profile->bssid;
+		return &cfg_priv->profile->bssid;
 	case WL_PROF_SSID:
-		return &wl->profile->ssid;
+		return &cfg_priv->profile->ssid;
 	}
 	WL_ERR("invalid item (%d)\n", item);
 	return NULL;
 }
 
 static s32
-brcmf_update_prof(struct wl_priv *wl, const struct brcmf_event_msg *e, void *data,
-		  s32 item)
+brcmf_update_prof(struct brcmf_cfg80211_priv *cfg_priv,
+		  const struct brcmf_event_msg *e, void *data, s32 item)
 {
 	s32 err = 0;
 	struct brcmf_ssid *ssid;
@@ -3937,25 +3993,27 @@ brcmf_update_prof(struct wl_priv *wl, const struct brcmf_event_msg *e, void *dat
 	switch (item) {
 	case WL_PROF_SSID:
 		ssid = (struct brcmf_ssid *) data;
-		memset(wl->profile->ssid.SSID, 0,
-		       sizeof(wl->profile->ssid.SSID));
-		memcpy(wl->profile->ssid.SSID, ssid->SSID, ssid->SSID_len);
-		wl->profile->ssid.SSID_len = ssid->SSID_len;
+		memset(cfg_priv->profile->ssid.SSID, 0,
+		       sizeof(cfg_priv->profile->ssid.SSID));
+		memcpy(cfg_priv->profile->ssid.SSID,
+		       ssid->SSID, ssid->SSID_len);
+		cfg_priv->profile->ssid.SSID_len = ssid->SSID_len;
 		break;
 	case WL_PROF_BSSID:
 		if (data)
-			memcpy(wl->profile->bssid, data, ETH_ALEN);
+			memcpy(cfg_priv->profile->bssid, data, ETH_ALEN);
 		else
-			memset(wl->profile->bssid, 0, ETH_ALEN);
+			memset(cfg_priv->profile->bssid, 0, ETH_ALEN);
 		break;
 	case WL_PROF_SEC:
-		memcpy(&wl->profile->sec, data, sizeof(wl->profile->sec));
+		memcpy(&cfg_priv->profile->sec, data,
+		       sizeof(cfg_priv->profile->sec));
 		break;
 	case WL_PROF_BEACONINT:
-		wl->profile->beacon_interval = *(u16 *)data;
+		cfg_priv->profile->beacon_interval = *(u16 *)data;
 		break;
 	case WL_PROF_DTIMPERIOD:
-		wl->profile->dtim_period = *(u8 *)data;
+		cfg_priv->profile->dtim_period = *(u8 *)data;
 		break;
 	default:
 		WL_ERR("unsupported item (%d)\n", item);
@@ -3966,14 +4024,15 @@ brcmf_update_prof(struct wl_priv *wl, const struct brcmf_event_msg *e, void *dat
 	return err;
 }
 
-static bool brcmf_is_ibssmode(struct wl_priv *wl)
+static bool brcmf_is_ibssmode(struct brcmf_cfg80211_priv *cfg_priv)
 {
-	return wl->conf->mode == WL_MODE_IBSS;
+	return cfg_priv->conf->mode == WL_MODE_IBSS;
 }
 
-static __used s32 brcmf_add_ie(struct wl_priv *wl, u8 t, u8 l, u8 *v)
+static __used s32 brcmf_add_ie(struct brcmf_cfg80211_priv *cfg_priv,
+			       u8 t, u8 l, u8 *v)
 {
-	struct wl_ie *ie = wl_to_ie(wl);
+	struct brcmf_cfg80211_ie *ie = wl_to_ie(cfg_priv);
 	s32 err = 0;
 
 	if (unlikely(ie->offset + l + 2 > WL_TLV_INFO_MAX)) {
@@ -3988,37 +4047,37 @@ static __used s32 brcmf_add_ie(struct wl_priv *wl, u8 t, u8 l, u8 *v)
 	return err;
 }
 
-static void brcmf_link_down(struct wl_priv *wl)
+static void brcmf_link_down(struct brcmf_cfg80211_priv *cfg_priv)
 {
 	struct net_device *dev = NULL;
 	s32 err = 0;
 
 	WL_TRACE("Enter\n");
 
-	if (wl->link_up) {
-		dev = wl_to_ndev(wl);
+	if (cfg_priv->link_up) {
+		dev = wl_to_ndev(cfg_priv);
 		WL_INFO("Call WLC_DISASSOC to stop excess roaming\n ");
 		err = brcmf_dev_ioctl(dev, BRCMF_C_DISASSOC, NULL, 0);
 		if (unlikely(err))
 			WL_ERR("WLC_DISASSOC failed (%d)\n", err);
-		wl->link_up = false;
+		cfg_priv->link_up = false;
 	}
 	WL_TRACE("Exit\n");
 }
 
-static void brcmf_lock_eq(struct wl_priv *wl)
+static void brcmf_lock_eq(struct brcmf_cfg80211_priv *cfg_priv)
 {
-	spin_lock_irq(&wl->eq_lock);
+	spin_lock_irq(&cfg_priv->eq_lock);
 }
 
-static void brcmf_unlock_eq(struct wl_priv *wl)
+static void brcmf_unlock_eq(struct brcmf_cfg80211_priv *cfg_priv)
 {
-	spin_unlock_irq(&wl->eq_lock);
+	spin_unlock_irq(&cfg_priv->eq_lock);
 }
 
-static void brcmf_init_eq_lock(struct wl_priv *wl)
+static void brcmf_init_eq_lock(struct brcmf_cfg80211_priv *cfg_priv)
 {
-	spin_lock_init(&wl->eq_lock);
+	spin_lock_init(&cfg_priv->eq_lock);
 }
 
 static void brcmf_delay(u32 ms)
@@ -4031,12 +4090,12 @@ static void brcmf_delay(u32 ms)
 	}
 }
 
-static void brcmf_set_drvdata(struct wl_dev *dev, void *data)
+static void brcmf_set_drvdata(struct brcmf_cfg80211_dev *dev, void *data)
 {
 	dev->driver_data = data;
 }
 
-static void *brcmf_get_drvdata(struct wl_dev *dev)
+static void *brcmf_get_drvdata(struct brcmf_cfg80211_dev *dev)
 {
 	void *data = NULL;
 
@@ -4048,9 +4107,9 @@ static void *brcmf_get_drvdata(struct wl_dev *dev)
 static void brcmf_set_mpc(struct net_device *ndev, int mpc)
 {
 	s32 err = 0;
-	struct wl_priv *wl = ndev_to_wl(ndev);
+	struct brcmf_cfg80211_priv *cfg_priv = ndev_to_wl(ndev);
 
-	if (test_bit(WL_STATUS_READY, &wl->status)) {
+	if (test_bit(WL_STATUS_READY, &cfg_priv->status)) {
 		err = brcmf_dev_intvar_set(ndev, "mpc", mpc);
 		if (unlikely(err)) {
 			WL_ERR("fail to set mpc\n");
@@ -4060,24 +4119,25 @@ static void brcmf_set_mpc(struct net_device *ndev, int mpc)
 	}
 }
 
-static int brcmf_debugfs_add_netdev_params(struct wl_priv *wl)
+static int brcmf_debugfs_add_netdev_params(struct brcmf_cfg80211_priv *cfg_priv)
 {
 	char buf[10+IFNAMSIZ];
 	struct dentry *fd;
 	s32 err = 0;
 
-	sprintf(buf, "netdev:%s", wl_to_ndev(wl)->name);
-	wl->debugfsdir = debugfs_create_dir(buf, wl_to_wiphy(wl)->debugfsdir);
+	sprintf(buf, "netdev:%s", wl_to_ndev(cfg_priv)->name);
+	cfg_priv->debugfsdir = debugfs_create_dir(buf,
+					wl_to_wiphy(cfg_priv)->debugfsdir);
 
-	fd = debugfs_create_u16("beacon_int", S_IRUGO, wl->debugfsdir,
-		(u16 *)&wl->profile->beacon_interval);
+	fd = debugfs_create_u16("beacon_int", S_IRUGO, cfg_priv->debugfsdir,
+		(u16 *)&cfg_priv->profile->beacon_interval);
 	if (!fd) {
 		err = -ENOMEM;
 		goto err_out;
 	}
 
-	fd = debugfs_create_u8("dtim_period", S_IRUGO, wl->debugfsdir,
-		(u8 *)&wl->profile->dtim_period);
+	fd = debugfs_create_u8("dtim_period", S_IRUGO, cfg_priv->debugfsdir,
+		(u8 *)&cfg_priv->profile->dtim_period);
 	if (!fd) {
 		err = -ENOMEM;
 		goto err_out;
@@ -4087,8 +4147,8 @@ err_out:
 	return err;
 }
 
-static void brcmf_debugfs_remove_netdev(struct wl_priv *wl)
+static void brcmf_debugfs_remove_netdev(struct brcmf_cfg80211_priv *cfg_priv)
 {
-	debugfs_remove_recursive(wl->debugfsdir);
-	wl->debugfsdir = NULL;
+	debugfs_remove_recursive(cfg_priv->debugfsdir);
+	cfg_priv->debugfsdir = NULL;
 }
diff --git a/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.h b/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.h
index af62cee..e2f41ab 100644
--- a/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.h
+++ b/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.h
@@ -17,11 +17,11 @@
 #ifndef _wl_cfg80211_h_
 #define _wl_cfg80211_h_
 
-struct wl_conf;
-struct wl_iface;
-struct wl_priv;
-struct wl_security;
-struct wl_ibss;
+struct brcmf_cfg80211_conf;
+struct brcmf_cfg80211_iface;
+struct brcmf_cfg80211_priv;
+struct brcmf_cfg80211_security;
+struct brcmf_cfg80211_ibss;
 
 #define WL_DBG_NONE		0
 #define WL_DBG_CONN		(1 << 5)
@@ -90,8 +90,6 @@ do {								\
 #define	WL_CONN(fmt, args...)
 #endif /* (defined BCMDBG) */
 
-
-#define WL_SCAN_RETRY_MAX	3	/* used for ibss scan */
 #define WL_NUM_SCAN_MAX		1
 #define WL_NUM_PMKIDS_MAX	MAXPMKID	/* will be used
 						 * for 2.6.33 kernel
@@ -160,16 +158,8 @@ enum wl_iscan_state {
 	WL_ISCAN_STATE_SCANING
 };
 
-/* beacon / probe_response */
-struct beacon_proberesp {
-	__le64 timestamp;
-	__le16 beacon_int;
-	__le16 capab_info;
-	u8 variable[0];
-} __attribute__ ((packed));
-
 /* dongle configuration */
-struct wl_conf {
+struct brcmf_cfg80211_conf {
 	u32 mode;		/* adhoc , infrastructure or ap */
 	u32 frag_threshold;
 	u32 rts_threshold;
@@ -180,44 +170,35 @@ struct wl_conf {
 };
 
 /* cfg80211 main event loop */
-struct wl_event_loop {
-	s32(*handler[BRCMF_E_LAST]) (struct wl_priv *wl,
+struct brcmf_cfg80211_event_loop {
+	s32(*handler[BRCMF_E_LAST]) (struct brcmf_cfg80211_priv *cfg_priv,
 				     struct net_device *ndev,
 				     const struct brcmf_event_msg *e,
 				     void *data);
 };
 
 /* representing interface of cfg80211 plane */
-struct wl_iface {
-	struct wl_priv *wl;
+struct brcmf_cfg80211_iface {
+	struct brcmf_cfg80211_priv *cfg_priv;
 };
 
-struct wl_dev {
+struct brcmf_cfg80211_dev {
 	void *driver_data;	/* to store cfg80211 object information */
 };
 
-/* bss inform structure for cfg80211 interface */
-struct wl_cfg80211_bss_info {
-	u16 band;
-	u16 channel;
-	s16 rssi;
-	u16 frame_len;
-	u8 frame_buf[1];
-};
-
 /* basic structure of scan request */
-struct wl_scan_req {
+struct brcmf_cfg80211_scan_req {
 	struct brcmf_ssid ssid;
 };
 
 /* basic structure of information element */
-struct wl_ie {
+struct brcmf_cfg80211_ie {
 	u16 offset;
 	u8 buf[WL_TLV_INFO_MAX];
 };
 
 /* event queue for cfg80211 main event */
-struct wl_event_q {
+struct brcmf_cfg80211_event_q {
 	struct list_head eq_list;
 	u32 etype;
 	struct brcmf_event_msg emsg;
@@ -225,7 +206,7 @@ struct wl_event_q {
 };
 
 /* security information with currently associated ap */
-struct wl_security {
+struct brcmf_cfg80211_security {
 	u32 wpa_versions;
 	u32 auth_type;
 	u32 cipher_pairwise;
@@ -234,7 +215,7 @@ struct wl_security {
 };
 
 /* ibss information for currently joined ibss network */
-struct wl_ibss {
+struct brcmf_cfg80211_ibss {
 	u8 beacon_interval;	/* in millisecond */
 	u8 atim;		/* in millisecond */
 	s8 join_only;
@@ -243,24 +224,25 @@ struct wl_ibss {
 };
 
 /* dongle profile */
-struct wl_profile {
+struct brcmf_cfg80211_profile {
 	u32 mode;
 	struct brcmf_ssid ssid;
 	u8 bssid[ETH_ALEN];
 	u16 beacon_interval;
 	u8 dtim_period;
-	struct wl_security sec;
-	struct wl_ibss ibss;
+	struct brcmf_cfg80211_security sec;
+	struct brcmf_cfg80211_ibss ibss;
 	s32 band;
 };
 
 /* dongle iscan event loop */
-struct wl_iscan_eloop {
-	s32(*handler[WL_SCAN_ERSULTS_LAST]) (struct wl_priv *wl);
+struct brcmf_cfg80211_iscan_eloop {
+	s32 (*handler[WL_SCAN_ERSULTS_LAST])
+		(struct brcmf_cfg80211_priv *cfg_priv);
 };
 
 /* dongle iscan controller */
-struct wl_iscan_ctrl {
+struct brcmf_cfg80211_iscan_ctrl {
 	struct net_device *dev;
 	struct timer_list timer;
 	u32 timer_ms;
@@ -268,14 +250,14 @@ struct wl_iscan_ctrl {
 	s32 state;
 	struct task_struct *tsk;
 	struct semaphore sync;
-	struct wl_iscan_eloop el;
+	struct brcmf_cfg80211_iscan_eloop el;
 	void *data;
 	s8 ioctl_buf[BRCMF_C_IOCTL_SMLEN];
 	s8 scan_buf[WL_ISCAN_BUF_MAX];
 };
 
 /* association inform */
-struct wl_connect_info {
+struct brcmf_cfg80211_connect_info {
 	u8 *req_ie;
 	s32 req_ie_len;
 	u8 *resp_ie;
@@ -283,43 +265,42 @@ struct wl_connect_info {
 };
 
 /* assoc ie length */
-struct wl_assoc_ielen {
+struct brcmf_cfg80211_assoc_ielen {
 	u32 req_len;
 	u32 resp_len;
 };
 
 /* wpa2 pmk list */
-struct wl_pmk_list {
+struct brcmf_cfg80211_pmk_list {
 	pmkid_list_t pmkids;
 	pmkid_t foo[MAXPMKID - 1];
 };
 
 /* dongle private data of cfg80211 interface */
-struct wl_priv {
+struct brcmf_cfg80211_priv {
 	struct wireless_dev *wdev;	/* representing wl cfg80211 device */
-	struct wl_conf *conf;	/* dongle configuration */
+	struct brcmf_cfg80211_conf *conf;	/* dongle configuration */
 	struct cfg80211_scan_request *scan_request;	/* scan request
 							 object */
-	struct wl_event_loop el;	/* main event loop */
+	struct brcmf_cfg80211_event_loop el;	/* main event loop */
 	struct list_head eq_list;	/* used for event queue */
 	spinlock_t eq_lock;	/* for event queue synchronization */
 	struct mutex usr_sync;	/* maily for dongle up/down synchronization */
 	struct brcmf_scan_results *bss_list;	/* bss_list holding scanned
 						 ap information */
 	struct brcmf_scan_results *scan_results;
-	struct wl_scan_req *scan_req_int;	/* scan request object for
-						 internal purpose */
+	struct brcmf_cfg80211_scan_req *scan_req_int;	/* scan request object
+						 for internal purpose */
 	struct wl_cfg80211_bss_info *bss_info;	/* bss information for
 						 cfg80211 layer */
-	struct wl_ie ie;	/* information element object for
+	struct brcmf_cfg80211_ie ie;	/* information element object for
 					 internal purpose */
 	struct semaphore event_sync;	/* for synchronization of main event
 					 thread */
-	struct wl_profile *profile;	/* holding dongle profile */
-	struct wl_iscan_ctrl *iscan;	/* iscan controller */
-	struct wl_connect_info conn_info;	/* association information
-						 container */
-	struct wl_pmk_list *pmk_list;	/* wpa2 pmk list */
+	struct brcmf_cfg80211_profile *profile;	/* holding dongle profile */
+	struct brcmf_cfg80211_iscan_ctrl *iscan;	/* iscan controller */
+	struct brcmf_cfg80211_connect_info conn_info; /* association info */
+	struct brcmf_cfg80211_pmk_list *pmk_list;	/* wpa2 pmk list */
 	struct task_struct *event_tsk;	/* task of main event handler thread */
 	unsigned long status;		/* current dongle status */
 	void *pub;
@@ -342,16 +323,16 @@ struct wl_priv {
 
 #define wl_to_dev(w) (wiphy_dev(wl->wdev->wiphy))
 #define wl_to_wiphy(w) (w->wdev->wiphy)
-#define wiphy_to_wl(w) ((struct wl_priv *)(wiphy_priv(w)))
+#define wiphy_to_wl(w) ((struct brcmf_cfg80211_priv *)(wiphy_priv(w)))
 #define wl_to_wdev(w) (w->wdev)
-#define wdev_to_wl(w) ((struct wl_priv *)(wdev_priv(w)))
+#define wdev_to_wl(w) ((struct brcmf_cfg80211_priv *)(wdev_priv(w)))
 #define wl_to_ndev(w) (w->wdev->netdev)
 #define ndev_to_wl(n) (wdev_to_wl(n->ieee80211_ptr))
-#define ci_to_wl(c) (ci->wl)
+#define ci_to_wl(c) (ci->cfg_priv)
 #define wl_to_ci(w) (&w->ci)
 #define wl_to_sr(w) (w->scan_req_int)
 #define wl_to_ie(w) (&w->ie)
-#define iscan_to_wl(i) ((struct wl_priv *)(i->data))
+#define iscan_to_wl(i) ((struct brcmf_cfg80211_priv *)(i->data))
 #define wl_to_iscan(w) (w->iscan)
 #define wl_to_conn(w) (&w->conn_info)
 
@@ -373,7 +354,7 @@ extern void wl_cfg80211_detach(void);
 extern void wl_cfg80211_event(struct net_device *ndev,
 			      const struct brcmf_event_msg *e, void *data);
 extern void wl_cfg80211_sdio_func(void *func);	/* set sdio function info */
-extern struct sdio_func *wl_cfg80211_get_sdio_func(void);	/* set sdio function info */
+extern struct sdio_func *wl_cfg80211_get_sdio_func(void);
 extern s32 wl_cfg80211_up(void);	/* dongle up */
 extern s32 wl_cfg80211_down(void);	/* dongle down */
 extern void wl_cfg80211_dbg_level(u32 level);	/* set dongle
-- 
1.7.4.1



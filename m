Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:2017 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758045Ab1F2Xs4 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Jun 2011 19:48:56 -0400
From: "Franky Lin" <frankyl@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Subject: [PATCH 105/119] staging: brcm80211: rename static functions in
 wl_cfg80211.c
Date: Wed, 29 Jun 2011 16:48:09 -0700
Message-ID: <1309391303-22741-106-git-send-email-frankyl@broadcom.com> (sfid-20110630_015116_737284_197855C9)
In-Reply-To: <1309391303-22741-1-git-send-email-frankyl@broadcom.com>
References: <1309391303-22741-1-git-send-email-frankyl@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Arend van Spriel <arend@broadcom.com>

The static functions in wl_cfg80211.c starting with wl_ prefix have
been renamed starting with brcmf_ prefix to be consistent.

Signed-off-by: Arend van Spriel <arend@broadcom.com>
Reviewed-by: Roland Vossen <rvossen@broadcom.com>
Reviewed-by: Franky Lin <frankyl@broadcom.com>
---
 drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c |  920 +++++++++++-----------
 1 files changed, 460 insertions(+), 460 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c b/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c
index 2555838..b0ac780 100644
--- a/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c
+++ b/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c
@@ -44,162 +44,162 @@ u32 brcmf_dbg_level = WL_DBG_ERR;
 /*
 ** cfg80211_ops api/callback list
 */
-static s32 wl_cfg80211_change_iface(struct wiphy *wiphy,
+static s32 brcmf_cfg80211_change_iface(struct wiphy *wiphy,
 				      struct net_device *ndev,
 				      enum nl80211_iftype type, u32 *flags,
 				      struct vif_params *params);
-static s32 __wl_cfg80211_scan(struct wiphy *wiphy, struct net_device *ndev,
+static s32 __brcmf_cfg80211_scan(struct wiphy *wiphy, struct net_device *ndev,
 				struct cfg80211_scan_request *request,
 				struct cfg80211_ssid *this_ssid);
-static s32 wl_cfg80211_scan(struct wiphy *wiphy, struct net_device *ndev,
+static s32 brcmf_cfg80211_scan(struct wiphy *wiphy, struct net_device *ndev,
 			      struct cfg80211_scan_request *request);
-static s32 wl_cfg80211_set_wiphy_params(struct wiphy *wiphy, u32 changed);
-static s32 wl_cfg80211_join_ibss(struct wiphy *wiphy, struct net_device *dev,
+static s32 brcmf_cfg80211_set_wiphy_params(struct wiphy *wiphy, u32 changed);
+static s32 brcmf_cfg80211_join_ibss(struct wiphy *wiphy, struct net_device *dev,
 				   struct cfg80211_ibss_params *params);
-static s32 wl_cfg80211_leave_ibss(struct wiphy *wiphy,
+static s32 brcmf_cfg80211_leave_ibss(struct wiphy *wiphy,
 				    struct net_device *dev);
-static s32 wl_cfg80211_get_station(struct wiphy *wiphy,
+static s32 brcmf_cfg80211_get_station(struct wiphy *wiphy,
 				     struct net_device *dev, u8 *mac,
 				     struct station_info *sinfo);
-static s32 wl_cfg80211_set_power_mgmt(struct wiphy *wiphy,
+static s32 brcmf_cfg80211_set_power_mgmt(struct wiphy *wiphy,
 					struct net_device *dev, bool enabled,
 					s32 timeout);
-static s32 wl_cfg80211_set_bitrate_mask(struct wiphy *wiphy,
+static s32 brcmf_cfg80211_set_bitrate_mask(struct wiphy *wiphy,
 					  struct net_device *dev,
 					  const u8 *addr,
 					  const struct cfg80211_bitrate_mask
 					  *mask);
-static int wl_cfg80211_connect(struct wiphy *wiphy, struct net_device *dev,
+static int brcmf_cfg80211_connect(struct wiphy *wiphy, struct net_device *dev,
 			       struct cfg80211_connect_params *sme);
-static s32 wl_cfg80211_disconnect(struct wiphy *wiphy, struct net_device *dev,
+static s32 brcmf_cfg80211_disconnect(struct wiphy *wiphy, struct net_device *dev,
 				    u16 reason_code);
-static s32 wl_cfg80211_set_tx_power(struct wiphy *wiphy,
+static s32 brcmf_cfg80211_set_tx_power(struct wiphy *wiphy,
 				      enum nl80211_tx_power_setting type,
 				      s32 dbm);
-static s32 wl_cfg80211_get_tx_power(struct wiphy *wiphy, s32 *dbm);
-static s32 wl_cfg80211_config_default_key(struct wiphy *wiphy,
+static s32 brcmf_cfg80211_get_tx_power(struct wiphy *wiphy, s32 *dbm);
+static s32 brcmf_cfg80211_config_default_key(struct wiphy *wiphy,
 					  struct net_device *dev, u8 key_idx,
 					  bool unicast, bool multicast);
-static s32 wl_cfg80211_add_key(struct wiphy *wiphy, struct net_device *dev,
+static s32 brcmf_cfg80211_add_key(struct wiphy *wiphy, struct net_device *dev,
 				 u8 key_idx, bool pairwise, const u8 *mac_addr,
 				 struct key_params *params);
-static s32 wl_cfg80211_del_key(struct wiphy *wiphy, struct net_device *dev,
+static s32 brcmf_cfg80211_del_key(struct wiphy *wiphy, struct net_device *dev,
 				 u8 key_idx, bool pairwise, const u8 *mac_addr);
-static s32 wl_cfg80211_get_key(struct wiphy *wiphy, struct net_device *dev,
+static s32 brcmf_cfg80211_get_key(struct wiphy *wiphy, struct net_device *dev,
 				 u8 key_idx, bool pairwise, const u8 *mac_addr,
 				 void *cookie, void (*callback) (void *cookie,
 								 struct
 								 key_params *
 								 params));
-static s32 wl_cfg80211_config_default_mgmt_key(struct wiphy *wiphy,
+static s32 brcmf_cfg80211_config_default_mgmt_key(struct wiphy *wiphy,
 						 struct net_device *dev,
 						 u8 key_idx);
-static s32 wl_cfg80211_resume(struct wiphy *wiphy);
-static s32 wl_cfg80211_suspend(struct wiphy *wiphy,
+static s32 brcmf_cfg80211_resume(struct wiphy *wiphy);
+static s32 brcmf_cfg80211_suspend(struct wiphy *wiphy,
 				 struct cfg80211_wowlan *wow);
-static s32 wl_cfg80211_set_pmksa(struct wiphy *wiphy, struct net_device *dev,
+static s32 brcmf_cfg80211_set_pmksa(struct wiphy *wiphy, struct net_device *dev,
 				   struct cfg80211_pmksa *pmksa);
-static s32 wl_cfg80211_del_pmksa(struct wiphy *wiphy, struct net_device *dev,
+static s32 brcmf_cfg80211_del_pmksa(struct wiphy *wiphy, struct net_device *dev,
 				   struct cfg80211_pmksa *pmksa);
-static s32 wl_cfg80211_flush_pmksa(struct wiphy *wiphy,
+static s32 brcmf_cfg80211_flush_pmksa(struct wiphy *wiphy,
 				     struct net_device *dev);
 /*
 ** event & event Q handlers for cfg80211 interfaces
 */
-static s32 wl_create_event_handler(struct wl_priv *wl);
-static void wl_destroy_event_handler(struct wl_priv *wl);
-static s32 wl_event_handler(void *data);
-static void wl_init_eq(struct wl_priv *wl);
-static void wl_flush_eq(struct wl_priv *wl);
-static void wl_lock_eq(struct wl_priv *wl);
-static void wl_unlock_eq(struct wl_priv *wl);
-static void wl_init_eq_lock(struct wl_priv *wl);
-static void wl_init_eloop_handler(struct wl_event_loop *el);
-static struct wl_event_q *wl_deq_event(struct wl_priv *wl);
-static s32 wl_enq_event(struct wl_priv *wl, u32 type,
+static s32 brcmf_create_event_handler(struct wl_priv *wl);
+static void brcmf_destroy_event_handler(struct wl_priv *wl);
+static s32 brcmf_event_handler(void *data);
+static void brcmf_init_eq(struct wl_priv *wl);
+static void brcmf_flush_eq(struct wl_priv *wl);
+static void brcmf_lock_eq(struct wl_priv *wl);
+static void brcmf_unlock_eq(struct wl_priv *wl);
+static void brcmf_init_eq_lock(struct wl_priv *wl);
+static void brcmf_init_eloop_handler(struct wl_event_loop *el);
+static struct wl_event_q *brcmf_deq_event(struct wl_priv *wl);
+static s32 brcmf_enq_event(struct wl_priv *wl, u32 type,
 			  const brcmf_event_msg_t *msg, void *data);
-static void wl_put_event(struct wl_event_q *e);
-static void wl_wakeup_event(struct wl_priv *wl);
-static s32 wl_notify_connect_status(struct wl_priv *wl,
+static void brcmf_put_event(struct wl_event_q *e);
+static void brcmf_wakeup_event(struct wl_priv *wl);
+static s32 brcmf_notify_connect_status(struct wl_priv *wl,
 				      struct net_device *ndev,
 				      const brcmf_event_msg_t *e, void *data);
-static s32 wl_notify_roaming_status(struct wl_priv *wl,
+static s32 brcmf_notify_roaming_status(struct wl_priv *wl,
 				      struct net_device *ndev,
 				      const brcmf_event_msg_t *e, void *data);
-static s32 wl_notify_scan_status(struct wl_priv *wl, struct net_device *ndev,
+static s32 brcmf_notify_scan_status(struct wl_priv *wl, struct net_device *ndev,
 				   const brcmf_event_msg_t *e, void *data);
-static s32 wl_bss_connect_done(struct wl_priv *wl, struct net_device *ndev,
+static s32 brcmf_bss_connect_done(struct wl_priv *wl, struct net_device *ndev,
 				 const brcmf_event_msg_t *e, void *data,
 				bool completed);
-static s32 wl_bss_roaming_done(struct wl_priv *wl, struct net_device *ndev,
+static s32 brcmf_bss_roaming_done(struct wl_priv *wl, struct net_device *ndev,
 				 const brcmf_event_msg_t *e, void *data);
-static s32 wl_notify_mic_status(struct wl_priv *wl, struct net_device *ndev,
+static s32 brcmf_notify_mic_status(struct wl_priv *wl, struct net_device *ndev,
 				  const brcmf_event_msg_t *e, void *data);
 
 /*
 ** register/deregister sdio function
 */
 struct sdio_func *wl_cfg80211_get_sdio_func(void);
-static void wl_clear_sdio_func(void);
+static void brcmf_clear_sdio_func(void);
 
 /*
 ** ioctl utilites
 */
-static s32 wl_dev_bufvar_get(struct net_device *dev, s8 *name, s8 *buf,
+static s32 brcmf_dev_bufvar_get(struct net_device *dev, s8 *name, s8 *buf,
 			       s32 buf_len);
-static __used s32 wl_dev_bufvar_set(struct net_device *dev, s8 *name,
+static __used s32 brcmf_dev_bufvar_set(struct net_device *dev, s8 *name,
 				      s8 *buf, s32 len);
-static s32 wl_dev_intvar_set(struct net_device *dev, s8 *name, s32 val);
-static s32 wl_dev_intvar_get(struct net_device *dev, s8 *name,
+static s32 brcmf_dev_intvar_set(struct net_device *dev, s8 *name, s32 val);
+static s32 brcmf_dev_intvar_get(struct net_device *dev, s8 *name,
 			       s32 *retval);
-static s32 wl_dev_ioctl(struct net_device *dev, u32 cmd, void *arg,
+static s32 brcmf_dev_ioctl(struct net_device *dev, u32 cmd, void *arg,
 			  u32 len);
 
 /*
 ** cfg80211 set_wiphy_params utilities
 */
-static s32 wl_set_frag(struct net_device *dev, u32 frag_threshold);
-static s32 wl_set_rts(struct net_device *dev, u32 frag_threshold);
-static s32 wl_set_retry(struct net_device *dev, u32 retry, bool l);
+static s32 brcmf_set_frag(struct net_device *dev, u32 frag_threshold);
+static s32 brcmf_set_rts(struct net_device *dev, u32 frag_threshold);
+static s32 brcmf_set_retry(struct net_device *dev, u32 retry, bool l);
 
 /*
 ** wl profile utilities
 */
-static s32 wl_update_prof(struct wl_priv *wl, const brcmf_event_msg_t *e,
+static s32 brcmf_update_prof(struct wl_priv *wl, const brcmf_event_msg_t *e,
 			    void *data, s32 item);
-static void *wl_read_prof(struct wl_priv *wl, s32 item);
-static void wl_init_prof(struct wl_profile *prof);
+static void *brcmf_read_prof(struct wl_priv *wl, s32 item);
+static void brcmf_init_prof(struct wl_profile *prof);
 
 /*
 ** cfg80211 connect utilites
 */
-static s32 wl_set_wpa_version(struct net_device *dev,
+static s32 brcmf_set_wpa_version(struct net_device *dev,
 			struct cfg80211_connect_params *sme);
-static s32 wl_set_auth_type(struct net_device *dev,
+static s32 brcmf_set_auth_type(struct net_device *dev,
 			struct cfg80211_connect_params *sme);
-static s32 wl_set_set_cipher(struct net_device *dev,
+static s32 brcmf_set_set_cipher(struct net_device *dev,
 			struct cfg80211_connect_params *sme);
-static s32 wl_set_key_mgmt(struct net_device *dev,
+static s32 brcmf_set_key_mgmt(struct net_device *dev,
 			struct cfg80211_connect_params *sme);
-static s32 wl_set_set_sharedkey(struct net_device *dev,
+static s32 brcmf_set_set_sharedkey(struct net_device *dev,
 			struct cfg80211_connect_params *sme);
-static s32 wl_get_assoc_ies(struct wl_priv *wl);
-static void wl_clear_assoc_ies(struct wl_priv *wl);
-static void wl_ch_to_chanspec(int ch,
+static s32 brcmf_get_assoc_ies(struct wl_priv *wl);
+static void brcmf_clear_assoc_ies(struct wl_priv *wl);
+static void brcmf_ch_to_chanspec(int ch,
 	struct brcmf_join_params *join_params, size_t *join_params_size);
 
 /*
 ** information element utilities
 */
-static __used s32 wl_add_ie(struct wl_priv *wl, u8 t, u8 l, u8 *v);
-static s32 wl_mode_to_nl80211_iftype(s32 mode);
-static struct wireless_dev *wl_alloc_wdev(s32 sizeof_iface,
+static __used s32 brcmf_add_ie(struct wl_priv *wl, u8 t, u8 l, u8 *v);
+static s32 brcmf_mode_to_nl80211_iftype(s32 mode);
+static struct wireless_dev *brcmf_alloc_wdev(s32 sizeof_iface,
 			struct device *dev);
-static void wl_free_wdev(struct wl_priv *wl);
-static s32 wl_inform_bss(struct wl_priv *wl);
-static s32 wl_inform_single_bss(struct wl_priv *wl, struct brcmf_bss_info *bi);
-static s32 wl_update_bss_info(struct wl_priv *wl);
-static s32 wl_add_keyext(struct wiphy *wiphy, struct net_device *dev,
+static void brcmf_free_wdev(struct wl_priv *wl);
+static s32 brcmf_inform_bss(struct wl_priv *wl);
+static s32 brcmf_inform_single_bss(struct wl_priv *wl, struct brcmf_bss_info *bi);
+static s32 brcmf_update_bss_info(struct wl_priv *wl);
+static s32 brcmf_add_keyext(struct wiphy *wiphy, struct net_device *dev,
 			u8 key_idx, const u8 *mac_addr,
 			struct key_params *params);
 
@@ -212,94 +212,94 @@ static void swap_key_to_BE(struct brcmf_wsec_key *key);
 /*
 ** wl_priv memory init/deinit utilities
 */
-static s32 wl_init_priv_mem(struct wl_priv *wl);
-static void wl_deinit_priv_mem(struct wl_priv *wl);
+static s32 brcmf_init_priv_mem(struct wl_priv *wl);
+static void brcmf_deinit_priv_mem(struct wl_priv *wl);
 
-static void wl_delay(u32 ms);
+static void brcmf_delay(u32 ms);
 
 /*
 ** store/restore cfg80211 instance data
 */
-static void wl_set_drvdata(struct wl_dev *dev, void *data);
-static void *wl_get_drvdata(struct wl_dev *dev);
+static void brcmf_set_drvdata(struct wl_dev *dev, void *data);
+static void *brcmf_get_drvdata(struct wl_dev *dev);
 
 /*
 ** ibss mode utilities
 */
-static bool wl_is_ibssmode(struct wl_priv *wl);
+static bool brcmf_is_ibssmode(struct wl_priv *wl);
 
 /*
 ** dongle up/down , default configuration utilities
 */
-static bool wl_is_linkdown(struct wl_priv *wl, const brcmf_event_msg_t *e);
-static bool wl_is_linkup(struct wl_priv *wl, const brcmf_event_msg_t *e);
-static bool wl_is_nonetwork(struct wl_priv *wl, const brcmf_event_msg_t *e);
-static void wl_link_down(struct wl_priv *wl);
-static s32 wl_dongle_mode(struct net_device *ndev, s32 iftype);
-static s32 __wl_cfg80211_up(struct wl_priv *wl);
-static s32 __wl_cfg80211_down(struct wl_priv *wl);
-static s32 wl_dongle_probecap(struct wl_priv *wl);
-static void wl_init_conf(struct wl_conf *conf);
+static bool brcmf_is_linkdown(struct wl_priv *wl, const brcmf_event_msg_t *e);
+static bool brcmf_is_linkup(struct wl_priv *wl, const brcmf_event_msg_t *e);
+static bool brcmf_is_nonetwork(struct wl_priv *wl, const brcmf_event_msg_t *e);
+static void brcmf_link_down(struct wl_priv *wl);
+static s32 brcmf_dongle_mode(struct net_device *ndev, s32 iftype);
+static s32 __brcmf_cfg80211_up(struct wl_priv *wl);
+static s32 __brcmf_cfg80211_down(struct wl_priv *wl);
+static s32 brcmf_dongle_probecap(struct wl_priv *wl);
+static void brcmf_init_conf(struct wl_conf *conf);
 
 /*
 ** dongle configuration utilities
 */
-static s32 wl_dongle_eventmsg(struct net_device *ndev);
-static s32 wl_dongle_scantime(struct net_device *ndev, s32 scan_assoc_time,
+static s32 brcmf_dongle_eventmsg(struct net_device *ndev);
+static s32 brcmf_dongle_scantime(struct net_device *ndev, s32 scan_assoc_time,
 				s32 scan_unassoc_time, s32 scan_passive_time);
-static s32 wl_config_dongle(struct wl_priv *wl, bool need_lock);
-static s32 wl_dongle_roam(struct net_device *ndev, u32 roamvar,
+static s32 brcmf_config_dongle(struct wl_priv *wl, bool need_lock);
+static s32 brcmf_dongle_roam(struct net_device *ndev, u32 roamvar,
 			    u32 bcn_timeout);
 
 /*
 ** iscan handler
 */
-static void wl_iscan_timer(unsigned long data);
-static void wl_term_iscan(struct wl_priv *wl);
-static s32 wl_init_iscan(struct wl_priv *wl);
-static s32 wl_iscan_thread(void *data);
-static s32 wl_dev_iovar_setbuf(struct net_device *dev, s8 *iovar,
+static void brcmf_iscan_timer(unsigned long data);
+static void brcmf_term_iscan(struct wl_priv *wl);
+static s32 brcmf_init_iscan(struct wl_priv *wl);
+static s32 brcmf_iscan_thread(void *data);
+static s32 brcmf_dev_iovar_setbuf(struct net_device *dev, s8 *iovar,
 				 void *param, s32 paramlen, void *bufptr,
 				 s32 buflen);
-static s32 wl_dev_iovar_getbuf(struct net_device *dev, s8 *iovar,
+static s32 brcmf_dev_iovar_getbuf(struct net_device *dev, s8 *iovar,
 				 void *param, s32 paramlen, void *bufptr,
 				 s32 buflen);
-static s32 wl_run_iscan(struct wl_iscan_ctrl *iscan, struct brcmf_ssid *ssid,
+static s32 brcmf_run_iscan(struct wl_iscan_ctrl *iscan, struct brcmf_ssid *ssid,
 			  u16 action);
-static s32 wl_do_iscan(struct wl_priv *wl);
-static s32 wl_wakeup_iscan(struct wl_iscan_ctrl *iscan);
-static s32 wl_invoke_iscan(struct wl_priv *wl);
-static s32 wl_get_iscan_results(struct wl_iscan_ctrl *iscan, u32 *status,
+static s32 brcmf_do_iscan(struct wl_priv *wl);
+static s32 brcmf_wakeup_iscan(struct wl_iscan_ctrl *iscan);
+static s32 brcmf_invoke_iscan(struct wl_priv *wl);
+static s32 brcmf_get_iscan_results(struct wl_iscan_ctrl *iscan, u32 *status,
 				  struct brcmf_scan_results **bss_list);
-static void wl_notify_iscan_complete(struct wl_iscan_ctrl *iscan, bool aborted);
-static void wl_init_iscan_eloop(struct wl_iscan_eloop *el);
-static s32 wl_iscan_done(struct wl_priv *wl);
-static s32 wl_iscan_pending(struct wl_priv *wl);
-static s32 wl_iscan_inprogress(struct wl_priv *wl);
-static s32 wl_iscan_aborted(struct wl_priv *wl);
+static void brcmf_notify_iscan_complete(struct wl_iscan_ctrl *iscan, bool aborted);
+static void brcmf_init_iscan_eloop(struct wl_iscan_eloop *el);
+static s32 brcmf_iscan_done(struct wl_priv *wl);
+static s32 brcmf_iscan_pending(struct wl_priv *wl);
+static s32 brcmf_iscan_inprogress(struct wl_priv *wl);
+static s32 brcmf_iscan_aborted(struct wl_priv *wl);
 
 /*
 * find most significant bit set
 */
-static __used u32 wl_find_msb(u16 bit16);
+static __used u32 brcmf_find_msb(u16 bit16);
 
 /*
 * update pmklist to dongle
 */
-static __used s32 wl_update_pmklist(struct net_device *dev,
+static __used s32 brcmf_update_pmklist(struct net_device *dev,
 				      struct wl_pmk_list *pmk_list, s32 err);
 
-static void wl_set_mpc(struct net_device *ndev, int mpc);
+static void brcmf_set_mpc(struct net_device *ndev, int mpc);
 
 /*
 * debufs support
 */
-static int wl_debugfs_add_netdev_params(struct wl_priv *wl);
-static void wl_debugfs_remove_netdev(struct wl_priv *wl);
+static int brcmf_debugfs_add_netdev_params(struct wl_priv *wl);
+static void brcmf_debugfs_remove_netdev(struct wl_priv *wl);
 
 #define WL_PRIV_GET()							\
 	({								\
-	struct wl_iface *ci = wl_get_drvdata(wl_cfg80211_dev);		\
+	struct wl_iface *ci = brcmf_get_drvdata(wl_cfg80211_dev);		\
 	if (unlikely(!ci)) {						\
 		WL_ERR("wl_cfg80211_dev is unavailable\n");		\
 		BUG();							\
@@ -515,7 +515,7 @@ static void swap_key_to_BE(struct brcmf_wsec_key *key)
 }
 
 static s32
-wl_dev_ioctl(struct net_device *dev, u32 cmd, void *arg, u32 len)
+brcmf_dev_ioctl(struct net_device *dev, u32 cmd, void *arg, u32 len)
 {
 	struct ifreq ifr;
 	struct brcmf_ioctl ioc;
@@ -538,7 +538,7 @@ wl_dev_ioctl(struct net_device *dev, u32 cmd, void *arg, u32 len)
 }
 
 static s32
-wl_cfg80211_change_iface(struct wiphy *wiphy, struct net_device *ndev,
+brcmf_cfg80211_change_iface(struct wiphy *wiphy, struct net_device *ndev,
 			 enum nl80211_iftype type, u32 *flags,
 			 struct vif_params *params)
 {
@@ -570,7 +570,7 @@ wl_cfg80211_change_iface(struct wiphy *wiphy, struct net_device *ndev,
 	}
 
 	infra = cpu_to_le32(infra);
-	err = wl_dev_ioctl(ndev, BRCMF_C_SET_INFRA, &infra, sizeof(infra));
+	err = brcmf_dev_ioctl(ndev, BRCMF_C_SET_INFRA, &infra, sizeof(infra));
 	if (unlikely(err)) {
 		WL_ERR("WLC_SET_INFRA error (%d)\n", err);
 		err = -EAGAIN;
@@ -610,7 +610,7 @@ static void wl_iscan_prep(struct brcmf_scan_params *params,
 }
 
 static s32
-wl_dev_iovar_setbuf(struct net_device *dev, s8 * iovar, void *param,
+brcmf_dev_iovar_setbuf(struct net_device *dev, s8 * iovar, void *param,
 		    s32 paramlen, void *bufptr, s32 buflen)
 {
 	s32 iolen;
@@ -618,11 +618,11 @@ wl_dev_iovar_setbuf(struct net_device *dev, s8 * iovar, void *param,
 	iolen = brcmu_mkiovar(iovar, param, paramlen, bufptr, buflen);
 	BUG_ON(!iolen);
 
-	return wl_dev_ioctl(dev, BRCMF_C_SET_VAR, bufptr, iolen);
+	return brcmf_dev_ioctl(dev, BRCMF_C_SET_VAR, bufptr, iolen);
 }
 
 static s32
-wl_dev_iovar_getbuf(struct net_device *dev, s8 * iovar, void *param,
+brcmf_dev_iovar_getbuf(struct net_device *dev, s8 * iovar, void *param,
 		    s32 paramlen, void *bufptr, s32 buflen)
 {
 	s32 iolen;
@@ -630,11 +630,11 @@ wl_dev_iovar_getbuf(struct net_device *dev, s8 * iovar, void *param,
 	iolen = brcmu_mkiovar(iovar, param, paramlen, bufptr, buflen);
 	BUG_ON(!iolen);
 
-	return wl_dev_ioctl(dev, BRCMF_C_GET_VAR, bufptr, buflen);
+	return brcmf_dev_ioctl(dev, BRCMF_C_GET_VAR, bufptr, buflen);
 }
 
 static s32
-wl_run_iscan(struct wl_iscan_ctrl *iscan, struct brcmf_ssid *ssid, u16 action)
+brcmf_run_iscan(struct wl_iscan_ctrl *iscan, struct brcmf_ssid *ssid, u16 action)
 {
 	s32 params_size = (BRCMF_SCAN_PARAMS_FIXED_SIZE +
 				offsetof(struct brcmf_iscan_params, params));
@@ -655,7 +655,7 @@ wl_run_iscan(struct wl_iscan_ctrl *iscan, struct brcmf_ssid *ssid, u16 action)
 	params->scan_duration = cpu_to_le16(0);
 
 	/* params_size += offsetof(struct brcmf_iscan_params, params); */
-	err = wl_dev_iovar_setbuf(iscan->dev, "iscan", params, params_size,
+	err = brcmf_dev_iovar_setbuf(iscan->dev, "iscan", params, params_size,
 				iscan->ioctl_buf, BRCMF_C_IOCTL_SMLEN);
 	if (unlikely(err)) {
 		if (err == -EBUSY) {
@@ -668,7 +668,7 @@ wl_run_iscan(struct wl_iscan_ctrl *iscan, struct brcmf_ssid *ssid, u16 action)
 	return err;
 }
 
-static s32 wl_do_iscan(struct wl_priv *wl)
+static s32 brcmf_do_iscan(struct wl_priv *wl)
 {
 	struct wl_iscan_ctrl *iscan = wl_to_iscan(wl);
 	struct net_device *ndev = wl_to_ndev(wl);
@@ -682,15 +682,15 @@ static s32 wl_do_iscan(struct wl_priv *wl)
 	iscan->state = WL_ISCAN_STATE_SCANING;
 
 	passive_scan = wl->active_scan ? 0 : 1;
-	err = wl_dev_ioctl(wl_to_ndev(wl), BRCMF_C_SET_PASSIVE_SCAN,
+	err = brcmf_dev_ioctl(wl_to_ndev(wl), BRCMF_C_SET_PASSIVE_SCAN,
 			&passive_scan, sizeof(passive_scan));
 	if (unlikely(err)) {
 		WL_ERR("error (%d)\n", err);
 		return err;
 	}
-	wl_set_mpc(ndev, 0);
+	brcmf_set_mpc(ndev, 0);
 	wl->iscan_kickstart = true;
-	wl_run_iscan(iscan, &ssid, BRCMF_SCAN_ACTION_START);
+	brcmf_run_iscan(iscan, &ssid, BRCMF_SCAN_ACTION_START);
 	mod_timer(&iscan->timer, jiffies + iscan->timer_ms * HZ / 1000);
 	iscan->timer_on = 1;
 
@@ -698,7 +698,7 @@ static s32 wl_do_iscan(struct wl_priv *wl)
 }
 
 static s32
-__wl_cfg80211_scan(struct wiphy *wiphy, struct net_device *ndev,
+__brcmf_cfg80211_scan(struct wiphy *wiphy, struct net_device *ndev,
 		   struct cfg80211_scan_request *request,
 		   struct cfg80211_ssid *this_ssid)
 {
@@ -741,7 +741,7 @@ __wl_cfg80211_scan(struct wiphy *wiphy, struct net_device *ndev,
 	wl->scan_request = request;
 	set_bit(WL_STATUS_SCANNING, &wl->status);
 	if (iscan_req) {
-		err = wl_do_iscan(wl);
+		err = brcmf_do_iscan(wl);
 		if (likely(!err))
 			return err;
 		else
@@ -761,14 +761,14 @@ __wl_cfg80211_scan(struct wiphy *wiphy, struct net_device *ndev,
 		}
 
 		passive_scan = wl->active_scan ? 0 : 1;
-		err = wl_dev_ioctl(ndev, BRCMF_C_SET_PASSIVE_SCAN,
+		err = brcmf_dev_ioctl(ndev, BRCMF_C_SET_PASSIVE_SCAN,
 				&passive_scan, sizeof(passive_scan));
 		if (unlikely(err)) {
 			WL_ERR("WLC_SET_PASSIVE_SCAN error (%d)\n", err);
 			goto scan_out;
 		}
-		wl_set_mpc(ndev, 0);
-		err = wl_dev_ioctl(ndev, BRCMF_C_SCAN, &sr->ssid,
+		brcmf_set_mpc(ndev, 0);
+		err = brcmf_dev_ioctl(ndev, BRCMF_C_SCAN, &sr->ssid,
 				sizeof(sr->ssid));
 		if (err) {
 			if (err == -EBUSY) {
@@ -777,7 +777,7 @@ __wl_cfg80211_scan(struct wiphy *wiphy, struct net_device *ndev,
 			} else {
 				WL_ERR("WLC_SCAN error (%d)\n", err);
 			}
-			wl_set_mpc(ndev, 1);
+			brcmf_set_mpc(ndev, 1);
 			goto scan_out;
 		}
 	}
@@ -791,7 +791,7 @@ scan_out:
 }
 
 static s32
-wl_cfg80211_scan(struct wiphy *wiphy, struct net_device *ndev,
+brcmf_cfg80211_scan(struct wiphy *wiphy, struct net_device *ndev,
 		 struct cfg80211_scan_request *request)
 {
 	s32 err = 0;
@@ -800,7 +800,7 @@ wl_cfg80211_scan(struct wiphy *wiphy, struct net_device *ndev,
 
 	CHECK_SYS_UP();
 
-	err = __wl_cfg80211_scan(wiphy, ndev, request, NULL);
+	err = __brcmf_cfg80211_scan(wiphy, ndev, request, NULL);
 	if (unlikely(err))
 		WL_ERR("scan error (%d)\n", err);
 
@@ -808,7 +808,7 @@ wl_cfg80211_scan(struct wiphy *wiphy, struct net_device *ndev,
 	return err;
 }
 
-static s32 wl_dev_intvar_set(struct net_device *dev, s8 *name, s32 val)
+static s32 brcmf_dev_intvar_set(struct net_device *dev, s8 *name, s32 val)
 {
 	s8 buf[BRCMF_C_IOCTL_SMLEN];
 	u32 len;
@@ -819,7 +819,7 @@ static s32 wl_dev_intvar_set(struct net_device *dev, s8 *name, s32 val)
 			    sizeof(buf));
 	BUG_ON(!len);
 
-	err = wl_dev_ioctl(dev, BRCMF_C_SET_VAR, buf, len);
+	err = brcmf_dev_ioctl(dev, BRCMF_C_SET_VAR, buf, len);
 	if (unlikely(err))
 		WL_ERR("error (%d)\n", err);
 
@@ -827,7 +827,7 @@ static s32 wl_dev_intvar_set(struct net_device *dev, s8 *name, s32 val)
 }
 
 static s32
-wl_dev_intvar_get(struct net_device *dev, s8 *name, s32 *retval)
+brcmf_dev_intvar_get(struct net_device *dev, s8 *name, s32 *retval)
 {
 	union {
 		s8 buf[BRCMF_C_IOCTL_SMLEN];
@@ -841,7 +841,7 @@ wl_dev_intvar_get(struct net_device *dev, s8 *name, s32 *retval)
 	    brcmu_mkiovar(name, (char *)(&data_null), 0, (char *)(&var),
 			sizeof(var.buf));
 	BUG_ON(!len);
-	err = wl_dev_ioctl(dev, BRCMF_C_GET_VAR, &var, len);
+	err = brcmf_dev_ioctl(dev, BRCMF_C_GET_VAR, &var, len);
 	if (unlikely(err))
 		WL_ERR("error (%d)\n", err);
 
@@ -850,35 +850,35 @@ wl_dev_intvar_get(struct net_device *dev, s8 *name, s32 *retval)
 	return err;
 }
 
-static s32 wl_set_rts(struct net_device *dev, u32 rts_threshold)
+static s32 brcmf_set_rts(struct net_device *dev, u32 rts_threshold)
 {
 	s32 err = 0;
 
-	err = wl_dev_intvar_set(dev, "rtsthresh", rts_threshold);
+	err = brcmf_dev_intvar_set(dev, "rtsthresh", rts_threshold);
 	if (unlikely(err))
 		WL_ERR("Error (%d)\n", err);
 
 	return err;
 }
 
-static s32 wl_set_frag(struct net_device *dev, u32 frag_threshold)
+static s32 brcmf_set_frag(struct net_device *dev, u32 frag_threshold)
 {
 	s32 err = 0;
 
-	err = wl_dev_intvar_set(dev, "fragthresh", frag_threshold);
+	err = brcmf_dev_intvar_set(dev, "fragthresh", frag_threshold);
 	if (unlikely(err))
 		WL_ERR("Error (%d)\n", err);
 
 	return err;
 }
 
-static s32 wl_set_retry(struct net_device *dev, u32 retry, bool l)
+static s32 brcmf_set_retry(struct net_device *dev, u32 retry, bool l)
 {
 	s32 err = 0;
 	u32 cmd = (l ? WLC_SET_LRL : WLC_SET_SRL);
 
 	retry = cpu_to_le32(retry);
-	err = wl_dev_ioctl(dev, cmd, &retry, sizeof(retry));
+	err = brcmf_dev_ioctl(dev, cmd, &retry, sizeof(retry));
 	if (unlikely(err)) {
 		WL_ERR("cmd (%d) , error (%d)\n", cmd, err);
 		return err;
@@ -886,7 +886,7 @@ static s32 wl_set_retry(struct net_device *dev, u32 retry, bool l)
 	return err;
 }
 
-static s32 wl_cfg80211_set_wiphy_params(struct wiphy *wiphy, u32 changed)
+static s32 brcmf_cfg80211_set_wiphy_params(struct wiphy *wiphy, u32 changed)
 {
 	struct wl_priv *wl = wiphy_to_wl(wiphy);
 	struct net_device *ndev = wl_to_ndev(wl);
@@ -898,28 +898,28 @@ static s32 wl_cfg80211_set_wiphy_params(struct wiphy *wiphy, u32 changed)
 	if (changed & WIPHY_PARAM_RTS_THRESHOLD &&
 	    (wl->conf->rts_threshold != wiphy->rts_threshold)) {
 		wl->conf->rts_threshold = wiphy->rts_threshold;
-		err = wl_set_rts(ndev, wl->conf->rts_threshold);
+		err = brcmf_set_rts(ndev, wl->conf->rts_threshold);
 		if (!err)
 			goto done;
 	}
 	if (changed & WIPHY_PARAM_FRAG_THRESHOLD &&
 	    (wl->conf->frag_threshold != wiphy->frag_threshold)) {
 		wl->conf->frag_threshold = wiphy->frag_threshold;
-		err = wl_set_frag(ndev, wl->conf->frag_threshold);
+		err = brcmf_set_frag(ndev, wl->conf->frag_threshold);
 		if (!err)
 			goto done;
 	}
 	if (changed & WIPHY_PARAM_RETRY_LONG
 	    && (wl->conf->retry_long != wiphy->retry_long)) {
 		wl->conf->retry_long = wiphy->retry_long;
-		err = wl_set_retry(ndev, wl->conf->retry_long, true);
+		err = brcmf_set_retry(ndev, wl->conf->retry_long, true);
 		if (!err)
 			goto done;
 	}
 	if (changed & WIPHY_PARAM_RETRY_SHORT
 	    && (wl->conf->retry_short != wiphy->retry_short)) {
 		wl->conf->retry_short = wiphy->retry_short;
-		err = wl_set_retry(ndev, wl->conf->retry_short, false);
+		err = brcmf_set_retry(ndev, wl->conf->retry_short, false);
 		if (!err)
 			goto done;
 	}
@@ -930,7 +930,7 @@ done:
 }
 
 static s32
-wl_cfg80211_join_ibss(struct wiphy *wiphy, struct net_device *dev,
+brcmf_cfg80211_join_ibss(struct wiphy *wiphy, struct net_device *dev,
 		      struct cfg80211_ibss_params *params)
 {
 	struct wl_priv *wl = wiphy_to_wl(wiphy);
@@ -993,7 +993,7 @@ wl_cfg80211_join_ibss(struct wiphy *wiphy, struct net_device *dev,
 	if (params->privacy)
 		wsec |= WEP_ENABLED;
 
-	err = wl_dev_intvar_set(dev, "wsec", wsec);
+	err = brcmf_dev_intvar_set(dev, "wsec", wsec);
 	if (unlikely(err)) {
 		WL_ERR("wsec failed (%d)\n", err);
 		goto done;
@@ -1005,7 +1005,7 @@ wl_cfg80211_join_ibss(struct wiphy *wiphy, struct net_device *dev,
 	else
 		bcnprd = cpu_to_le32(100);
 
-	err = wl_dev_ioctl(dev, WLC_SET_BCNPRD, &bcnprd, sizeof(bcnprd));
+	err = brcmf_dev_ioctl(dev, WLC_SET_BCNPRD, &bcnprd, sizeof(bcnprd));
 	if (unlikely(err)) {
 		WL_ERR("WLC_SET_BCNPRD failed (%d)\n", err);
 		goto done;
@@ -1020,7 +1020,7 @@ wl_cfg80211_join_ibss(struct wiphy *wiphy, struct net_device *dev,
 	memcpy(join_params.ssid.SSID, params->ssid, join_params.ssid.SSID_len);
 	join_params.ssid.SSID_len = cpu_to_le32(join_params.ssid.SSID_len);
 	join_params_size = sizeof(join_params.ssid);
-	wl_update_prof(wl, NULL, &join_params.ssid, WL_PROF_SSID);
+	brcmf_update_prof(wl, NULL, &join_params.ssid, WL_PROF_SSID);
 
 	/* BSSID */
 	if (params->bssid) {
@@ -1030,7 +1030,7 @@ wl_cfg80211_join_ibss(struct wiphy *wiphy, struct net_device *dev,
 	} else {
 		memcpy(join_params.params.bssid, ether_bcast, ETH_ALEN);
 	}
-	wl_update_prof(wl, NULL, &join_params.params.bssid, WL_PROF_BSSID);
+	brcmf_update_prof(wl, NULL, &join_params.params.bssid, WL_PROF_BSSID);
 
 	/* Channel */
 	if (params->channel) {
@@ -1041,13 +1041,13 @@ wl_cfg80211_join_ibss(struct wiphy *wiphy, struct net_device *dev,
 				params->channel->center_freq);
 		if (params->channel_fixed) {
 			/* adding chanspec */
-			wl_ch_to_chanspec(wl->channel,
+			brcmf_ch_to_chanspec(wl->channel,
 				&join_params, &join_params_size);
 		}
 
 		/* set channel for starter */
 		target_channel = cpu_to_le32(wl->channel);
-		err = wl_dev_ioctl(dev, WLC_SET_CHANNEL,
+		err = brcmf_dev_ioctl(dev, WLC_SET_CHANNEL,
 			&target_channel, sizeof(target_channel));
 		if (unlikely(err)) {
 			WL_ERR("WLC_SET_CHANNEL failed (%d)\n", err);
@@ -1059,7 +1059,7 @@ wl_cfg80211_join_ibss(struct wiphy *wiphy, struct net_device *dev,
 	wl->ibss_starter = false;
 
 
-	err = wl_dev_ioctl(dev, BRCMF_C_SET_SSID,
+	err = brcmf_dev_ioctl(dev, BRCMF_C_SET_SSID,
 			   &join_params, join_params_size);
 	if (unlikely(err)) {
 		WL_ERR("WLC_SET_SSID failed (%d)\n", err);
@@ -1073,7 +1073,7 @@ done:
 	return err;
 }
 
-static s32 wl_cfg80211_leave_ibss(struct wiphy *wiphy, struct net_device *dev)
+static s32 brcmf_cfg80211_leave_ibss(struct wiphy *wiphy, struct net_device *dev)
 {
 	struct wl_priv *wl = wiphy_to_wl(wiphy);
 	s32 err = 0;
@@ -1081,7 +1081,7 @@ static s32 wl_cfg80211_leave_ibss(struct wiphy *wiphy, struct net_device *dev)
 	WL_TRACE("Enter\n");
 	CHECK_SYS_UP();
 
-	wl_link_down(wl);
+	brcmf_link_down(wl);
 
 	WL_TRACE("Exit\n");
 
@@ -1089,7 +1089,7 @@ static s32 wl_cfg80211_leave_ibss(struct wiphy *wiphy, struct net_device *dev)
 }
 
 static s32
-wl_set_wpa_version(struct net_device *dev, struct cfg80211_connect_params *sme)
+brcmf_set_wpa_version(struct net_device *dev, struct cfg80211_connect_params *sme)
 {
 	struct wl_priv *wl = ndev_to_wl(dev);
 	struct wl_security *sec;
@@ -1103,18 +1103,18 @@ wl_set_wpa_version(struct net_device *dev, struct cfg80211_connect_params *sme)
 	else
 		val = WPA_AUTH_DISABLED;
 	WL_CONN("setting wpa_auth to 0x%0x\n", val);
-	err = wl_dev_intvar_set(dev, "wpa_auth", val);
+	err = brcmf_dev_intvar_set(dev, "wpa_auth", val);
 	if (unlikely(err)) {
 		WL_ERR("set wpa_auth failed (%d)\n", err);
 		return err;
 	}
-	sec = wl_read_prof(wl, WL_PROF_SEC);
+	sec = brcmf_read_prof(wl, WL_PROF_SEC);
 	sec->wpa_versions = sme->crypto.wpa_versions;
 	return err;
 }
 
 static s32
-wl_set_auth_type(struct net_device *dev, struct cfg80211_connect_params *sme)
+brcmf_set_auth_type(struct net_device *dev, struct cfg80211_connect_params *sme)
 {
 	struct wl_priv *wl = ndev_to_wl(dev);
 	struct wl_security *sec;
@@ -1142,18 +1142,18 @@ wl_set_auth_type(struct net_device *dev, struct cfg80211_connect_params *sme)
 		break;
 	}
 
-	err = wl_dev_intvar_set(dev, "auth", val);
+	err = brcmf_dev_intvar_set(dev, "auth", val);
 	if (unlikely(err)) {
 		WL_ERR("set auth failed (%d)\n", err);
 		return err;
 	}
-	sec = wl_read_prof(wl, WL_PROF_SEC);
+	sec = brcmf_read_prof(wl, WL_PROF_SEC);
 	sec->auth_type = sme->auth_type;
 	return err;
 }
 
 static s32
-wl_set_set_cipher(struct net_device *dev, struct cfg80211_connect_params *sme)
+brcmf_set_set_cipher(struct net_device *dev, struct cfg80211_connect_params *sme)
 {
 	struct wl_priv *wl = ndev_to_wl(dev);
 	struct wl_security *sec;
@@ -1205,13 +1205,13 @@ wl_set_set_cipher(struct net_device *dev, struct cfg80211_connect_params *sme)
 	}
 
 	WL_CONN("pval (%d) gval (%d)\n", pval, gval);
-	err = wl_dev_intvar_set(dev, "wsec", pval | gval);
+	err = brcmf_dev_intvar_set(dev, "wsec", pval | gval);
 	if (unlikely(err)) {
 		WL_ERR("error (%d)\n", err);
 		return err;
 	}
 
-	sec = wl_read_prof(wl, WL_PROF_SEC);
+	sec = brcmf_read_prof(wl, WL_PROF_SEC);
 	sec->cipher_pairwise = sme->crypto.ciphers_pairwise[0];
 	sec->cipher_group = sme->crypto.cipher_group;
 
@@ -1219,7 +1219,7 @@ wl_set_set_cipher(struct net_device *dev, struct cfg80211_connect_params *sme)
 }
 
 static s32
-wl_set_key_mgmt(struct net_device *dev, struct cfg80211_connect_params *sme)
+brcmf_set_key_mgmt(struct net_device *dev, struct cfg80211_connect_params *sme)
 {
 	struct wl_priv *wl = ndev_to_wl(dev);
 	struct wl_security *sec;
@@ -1227,7 +1227,7 @@ wl_set_key_mgmt(struct net_device *dev, struct cfg80211_connect_params *sme)
 	s32 err = 0;
 
 	if (sme->crypto.n_akm_suites) {
-		err = wl_dev_intvar_get(dev, "wpa_auth", &val);
+		err = brcmf_dev_intvar_get(dev, "wpa_auth", &val);
 		if (unlikely(err)) {
 			WL_ERR("could not get wpa_auth (%d)\n", err);
 			return err;
@@ -1261,20 +1261,20 @@ wl_set_key_mgmt(struct net_device *dev, struct cfg80211_connect_params *sme)
 		}
 
 		WL_CONN("setting wpa_auth to %d\n", val);
-		err = wl_dev_intvar_set(dev, "wpa_auth", val);
+		err = brcmf_dev_intvar_set(dev, "wpa_auth", val);
 		if (unlikely(err)) {
 			WL_ERR("could not set wpa_auth (%d)\n", err);
 			return err;
 		}
 	}
-	sec = wl_read_prof(wl, WL_PROF_SEC);
+	sec = brcmf_read_prof(wl, WL_PROF_SEC);
 	sec->wpa_auth = sme->crypto.akm_suites[0];
 
 	return err;
 }
 
 static s32
-wl_set_set_sharedkey(struct net_device *dev,
+brcmf_set_set_sharedkey(struct net_device *dev,
 		     struct cfg80211_connect_params *sme)
 {
 	struct wl_priv *wl = ndev_to_wl(dev);
@@ -1285,7 +1285,7 @@ wl_set_set_sharedkey(struct net_device *dev,
 
 	WL_CONN("key len (%d)\n", sme->key_len);
 	if (sme->key_len) {
-		sec = wl_read_prof(wl, WL_PROF_SEC);
+		sec = brcmf_read_prof(wl, WL_PROF_SEC);
 		WL_CONN("wpa_versions 0x%x cipher_pairwise 0x%x\n",
 		       sec->wpa_versions, sec->cipher_pairwise);
 		if (!
@@ -1319,7 +1319,7 @@ wl_set_set_sharedkey(struct net_device *dev,
 			       key.len, key.index, key.algo);
 			WL_CONN("key \"%s\"\n", key.data);
 			swap_key_from_BE(&key);
-			err = wl_dev_ioctl(dev, BRCMF_C_SET_KEY, &key,
+			err = brcmf_dev_ioctl(dev, BRCMF_C_SET_KEY, &key,
 					sizeof(key));
 			if (unlikely(err)) {
 				WL_ERR("WLC_SET_KEY error (%d)\n", err);
@@ -1328,7 +1328,7 @@ wl_set_set_sharedkey(struct net_device *dev,
 			if (sec->auth_type == NL80211_AUTHTYPE_OPEN_SYSTEM) {
 				WL_CONN("set auth_type to shared key\n");
 				val = 1;	/* shared key */
-				err = wl_dev_intvar_set(dev, "auth", val);
+				err = brcmf_dev_intvar_set(dev, "auth", val);
 				if (unlikely(err)) {
 					WL_ERR("set auth failed (%d)\n", err);
 					return err;
@@ -1340,7 +1340,7 @@ wl_set_set_sharedkey(struct net_device *dev,
 }
 
 static s32
-wl_cfg80211_connect(struct wiphy *wiphy, struct net_device *dev,
+brcmf_cfg80211_connect(struct wiphy *wiphy, struct net_device *dev,
 		    struct cfg80211_connect_params *sme)
 {
 	struct wl_priv *wl = wiphy_to_wl(wiphy);
@@ -1370,37 +1370,37 @@ wl_cfg80211_connect(struct wiphy *wiphy, struct net_device *dev,
 
 	WL_INFO("ie (%p), ie_len (%zd)\n", sme->ie, sme->ie_len);
 
-	err = wl_set_wpa_version(dev, sme);
+	err = brcmf_set_wpa_version(dev, sme);
 	if (err) {
 		WL_ERR("wl_set_wpa_version failed (%d)\n", err);
 		goto done;
 	}
 
-	err = wl_set_auth_type(dev, sme);
+	err = brcmf_set_auth_type(dev, sme);
 	if (err) {
 		WL_ERR("wl_set_auth_type failed (%d)\n", err);
 		goto done;
 	}
 
-	err = wl_set_set_cipher(dev, sme);
+	err = brcmf_set_set_cipher(dev, sme);
 	if (err) {
 		WL_ERR("wl_set_set_cipher failed (%d)\n", err);
 		goto done;
 	}
 
-	err = wl_set_key_mgmt(dev, sme);
+	err = brcmf_set_key_mgmt(dev, sme);
 	if (err) {
 		WL_ERR("wl_set_key_mgmt failed (%d)\n", err);
 		goto done;
 	}
 
-	err = wl_set_set_sharedkey(dev, sme);
+	err = brcmf_set_set_sharedkey(dev, sme);
 	if (err) {
 		WL_ERR("wl_set_set_sharedkey failed (%d)\n", err);
 		goto done;
 	}
 
-	wl_update_prof(wl, NULL, sme->bssid, WL_PROF_BSSID);
+	brcmf_update_prof(wl, NULL, sme->bssid, WL_PROF_BSSID);
 	/*
 	 **  Join with specific BSSID and cached SSID
 	 **  If SSID is zero join based on BSSID only
@@ -1411,7 +1411,7 @@ wl_cfg80211_connect(struct wiphy *wiphy, struct net_device *dev,
 	join_params.ssid.SSID_len = min(sizeof(join_params.ssid.SSID), sme->ssid_len);
 	memcpy(&join_params.ssid.SSID, sme->ssid, join_params.ssid.SSID_len);
 	join_params.ssid.SSID_len = cpu_to_le32(join_params.ssid.SSID_len);
-	wl_update_prof(wl, NULL, &join_params.ssid, WL_PROF_SSID);
+	brcmf_update_prof(wl, NULL, &join_params.ssid, WL_PROF_SSID);
 
 	if (sme->bssid)
 		memcpy(join_params.params.bssid, sme->bssid, ETH_ALEN);
@@ -1423,8 +1423,8 @@ wl_cfg80211_connect(struct wiphy *wiphy, struct net_device *dev,
 		       join_params.ssid.SSID, join_params.ssid.SSID_len);
 	}
 
-	wl_ch_to_chanspec(wl->channel, &join_params, &join_params_size);
-	err = wl_dev_ioctl(dev, BRCMF_C_SET_SSID,
+	brcmf_ch_to_chanspec(wl->channel, &join_params, &join_params_size);
+	err = brcmf_dev_ioctl(dev, BRCMF_C_SET_SSID,
 			   &join_params, join_params_size);
 	if (err)
 		WL_ERR("WLC_SET_SSID failed (%d)\n", err);
@@ -1437,7 +1437,7 @@ done:
 }
 
 static s32
-wl_cfg80211_disconnect(struct wiphy *wiphy, struct net_device *dev,
+brcmf_cfg80211_disconnect(struct wiphy *wiphy, struct net_device *dev,
 		       u16 reason_code)
 {
 	struct wl_priv *wl = wiphy_to_wl(wiphy);
@@ -1450,9 +1450,9 @@ wl_cfg80211_disconnect(struct wiphy *wiphy, struct net_device *dev,
 	clear_bit(WL_STATUS_CONNECTED, &wl->status);
 
 	scbval.val = reason_code;
-	memcpy(&scbval.ea, wl_read_prof(wl, WL_PROF_BSSID), ETH_ALEN);
+	memcpy(&scbval.ea, brcmf_read_prof(wl, WL_PROF_BSSID), ETH_ALEN);
 	scbval.val = cpu_to_le32(scbval.val);
-	err = wl_dev_ioctl(dev, BRCMF_C_DISASSOC, &scbval,
+	err = brcmf_dev_ioctl(dev, BRCMF_C_DISASSOC, &scbval,
 			sizeof(struct brcmf_scb_val));
 	if (unlikely(err))
 		WL_ERR("error (%d)\n", err);
@@ -1464,7 +1464,7 @@ wl_cfg80211_disconnect(struct wiphy *wiphy, struct net_device *dev,
 }
 
 static s32
-wl_cfg80211_set_tx_power(struct wiphy *wiphy,
+brcmf_cfg80211_set_tx_power(struct wiphy *wiphy,
 			 enum nl80211_tx_power_setting type, s32 dbm)
 {
 
@@ -1498,7 +1498,7 @@ wl_cfg80211_set_tx_power(struct wiphy *wiphy,
 	/* Make sure radio is off or on as far as software is concerned */
 	disable = WL_RADIO_SW_DISABLE << 16;
 	disable = cpu_to_le32(disable);
-	err = wl_dev_ioctl(ndev, BRCMF_C_SET_RADIO, &disable, sizeof(disable));
+	err = brcmf_dev_ioctl(ndev, BRCMF_C_SET_RADIO, &disable, sizeof(disable));
 	if (unlikely(err))
 		WL_ERR("WLC_SET_RADIO error (%d)\n", err);
 
@@ -1506,7 +1506,7 @@ wl_cfg80211_set_tx_power(struct wiphy *wiphy,
 		txpwrmw = 0xffff;
 	else
 		txpwrmw = (u16) dbm;
-	err = wl_dev_intvar_set(ndev, "qtxpower",
+	err = brcmf_dev_intvar_set(ndev, "qtxpower",
 			(s32) (brcmu_mw_to_qdbm(txpwrmw)));
 	if (unlikely(err))
 		WL_ERR("qtxpower error (%d)\n", err);
@@ -1517,7 +1517,7 @@ done:
 	return err;
 }
 
-static s32 wl_cfg80211_get_tx_power(struct wiphy *wiphy, s32 *dbm)
+static s32 brcmf_cfg80211_get_tx_power(struct wiphy *wiphy, s32 *dbm)
 {
 	struct wl_priv *wl = wiphy_to_wl(wiphy);
 	struct net_device *ndev = wl_to_ndev(wl);
@@ -1528,7 +1528,7 @@ static s32 wl_cfg80211_get_tx_power(struct wiphy *wiphy, s32 *dbm)
 	WL_TRACE("Enter\n");
 	CHECK_SYS_UP();
 
-	err = wl_dev_intvar_get(ndev, "qtxpower", &txpwrdbm);
+	err = brcmf_dev_intvar_get(ndev, "qtxpower", &txpwrdbm);
 	if (unlikely(err)) {
 		WL_ERR("error (%d)\n", err);
 		goto done;
@@ -1543,7 +1543,7 @@ done:
 }
 
 static s32
-wl_cfg80211_config_default_key(struct wiphy *wiphy, struct net_device *dev,
+brcmf_cfg80211_config_default_key(struct wiphy *wiphy, struct net_device *dev,
 			       u8 key_idx, bool unicast, bool multicast)
 {
 	u32 index;
@@ -1554,7 +1554,7 @@ wl_cfg80211_config_default_key(struct wiphy *wiphy, struct net_device *dev,
 	WL_CONN("key index (%d)\n", key_idx);
 	CHECK_SYS_UP();
 
-	err = wl_dev_ioctl(dev, BRCMF_C_GET_WSEC, &wsec, sizeof(wsec));
+	err = brcmf_dev_ioctl(dev, BRCMF_C_GET_WSEC, &wsec, sizeof(wsec));
 	if (unlikely(err)) {
 		WL_ERR("WLC_GET_WSEC error (%d)\n", err);
 		goto done;
@@ -1565,7 +1565,7 @@ wl_cfg80211_config_default_key(struct wiphy *wiphy, struct net_device *dev,
 		/* Just select a new current key */
 		index = (u32) key_idx;
 		index = cpu_to_le32(index);
-		err = wl_dev_ioctl(dev, BRCMF_C_SET_KEY_PRIMARY, &index,
+		err = brcmf_dev_ioctl(dev, BRCMF_C_SET_KEY_PRIMARY, &index,
 				sizeof(index));
 		if (unlikely(err))
 			WL_ERR("error (%d)\n", err);
@@ -1576,7 +1576,7 @@ done:
 }
 
 static s32
-wl_add_keyext(struct wiphy *wiphy, struct net_device *dev,
+brcmf_add_keyext(struct wiphy *wiphy, struct net_device *dev,
 	      u8 key_idx, const u8 *mac_addr, struct key_params *params)
 {
 	struct brcmf_wsec_key key;
@@ -1593,7 +1593,7 @@ wl_add_keyext(struct wiphy *wiphy, struct net_device *dev,
 	if (key.len == 0) {
 		/* key delete */
 		swap_key_from_BE(&key);
-		err = wl_dev_ioctl(dev, BRCMF_C_SET_KEY, &key, sizeof(key));
+		err = brcmf_dev_ioctl(dev, BRCMF_C_SET_KEY, &key, sizeof(key));
 		if (unlikely(err)) {
 			WL_ERR("key delete error (%d)\n", err);
 			return err;
@@ -1653,7 +1653,7 @@ wl_add_keyext(struct wiphy *wiphy, struct net_device *dev,
 		swap_key_from_BE(&key);
 
 		brcmf_netdev_wait_pend8021x(dev);
-		err = wl_dev_ioctl(dev, BRCMF_C_SET_KEY, &key, sizeof(key));
+		err = brcmf_dev_ioctl(dev, BRCMF_C_SET_KEY, &key, sizeof(key));
 		if (unlikely(err)) {
 			WL_ERR("WLC_SET_KEY error (%d)\n", err);
 			return err;
@@ -1663,7 +1663,7 @@ wl_add_keyext(struct wiphy *wiphy, struct net_device *dev,
 }
 
 static s32
-wl_cfg80211_add_key(struct wiphy *wiphy, struct net_device *dev,
+brcmf_cfg80211_add_key(struct wiphy *wiphy, struct net_device *dev,
 		    u8 key_idx, bool pairwise, const u8 *mac_addr,
 		    struct key_params *params)
 {
@@ -1679,7 +1679,7 @@ wl_cfg80211_add_key(struct wiphy *wiphy, struct net_device *dev,
 
 	if (mac_addr) {
 		WL_TRACE("Exit");
-		return wl_add_keyext(wiphy, dev, key_idx, mac_addr, params);
+		return brcmf_add_keyext(wiphy, dev, key_idx, mac_addr, params);
 	}
 	memset(&key, 0, sizeof(key));
 
@@ -1726,21 +1726,21 @@ wl_cfg80211_add_key(struct wiphy *wiphy, struct net_device *dev,
 
 	/* Set the new key/index */
 	swap_key_from_BE(&key);
-	err = wl_dev_ioctl(dev, BRCMF_C_SET_KEY, &key, sizeof(key));
+	err = brcmf_dev_ioctl(dev, BRCMF_C_SET_KEY, &key, sizeof(key));
 	if (unlikely(err)) {
 		WL_ERR("WLC_SET_KEY error (%d)\n", err);
 		goto done;
 	}
 
 	val = WEP_ENABLED;
-	err = wl_dev_intvar_get(dev, "wsec", &wsec);
+	err = brcmf_dev_intvar_get(dev, "wsec", &wsec);
 	if (unlikely(err)) {
 		WL_ERR("get wsec error (%d)\n", err);
 		goto done;
 	}
 	wsec &= ~(WEP_ENABLED);
 	wsec |= val;
-	err = wl_dev_intvar_set(dev, "wsec", wsec);
+	err = brcmf_dev_intvar_set(dev, "wsec", wsec);
 	if (unlikely(err)) {
 		WL_ERR("set wsec error (%d)\n", err);
 		goto done;
@@ -1748,7 +1748,7 @@ wl_cfg80211_add_key(struct wiphy *wiphy, struct net_device *dev,
 
 	val = 1;		/* assume shared key. otherwise 0 */
 	val = cpu_to_le32(val);
-	err = wl_dev_ioctl(dev, BRCMF_C_SET_AUTH, &val, sizeof(val));
+	err = brcmf_dev_ioctl(dev, BRCMF_C_SET_AUTH, &val, sizeof(val));
 	if (unlikely(err))
 		WL_ERR("WLC_SET_AUTH error (%d)\n", err);
 done:
@@ -1757,7 +1757,7 @@ done:
 }
 
 static s32
-wl_cfg80211_del_key(struct wiphy *wiphy, struct net_device *dev,
+brcmf_cfg80211_del_key(struct wiphy *wiphy, struct net_device *dev,
 		    u8 key_idx, bool pairwise, const u8 *mac_addr)
 {
 	struct brcmf_wsec_key key;
@@ -1776,7 +1776,7 @@ wl_cfg80211_del_key(struct wiphy *wiphy, struct net_device *dev,
 	WL_CONN("key index (%d)\n", key_idx);
 	/* Set the new key/index */
 	swap_key_from_BE(&key);
-	err = wl_dev_ioctl(dev, BRCMF_C_SET_KEY, &key, sizeof(key));
+	err = brcmf_dev_ioctl(dev, BRCMF_C_SET_KEY, &key, sizeof(key));
 	if (unlikely(err)) {
 		if (err == -EINVAL) {
 			if (key.index >= DOT11_MAX_DEFAULT_KEYS)
@@ -1791,7 +1791,7 @@ wl_cfg80211_del_key(struct wiphy *wiphy, struct net_device *dev,
 	}
 
 	val = 0;
-	err = wl_dev_intvar_get(dev, "wsec", &wsec);
+	err = brcmf_dev_intvar_get(dev, "wsec", &wsec);
 	if (unlikely(err)) {
 		WL_ERR("get wsec error (%d)\n", err);
 		/* Ignore this error, may happen during DISASSOC */
@@ -1800,7 +1800,7 @@ wl_cfg80211_del_key(struct wiphy *wiphy, struct net_device *dev,
 	}
 	wsec &= ~(WEP_ENABLED);
 	wsec |= val;
-	err = wl_dev_intvar_set(dev, "wsec", wsec);
+	err = brcmf_dev_intvar_set(dev, "wsec", wsec);
 	if (unlikely(err)) {
 		WL_ERR("set wsec error (%d)\n", err);
 		/* Ignore this error, may happen during DISASSOC */
@@ -1810,7 +1810,7 @@ wl_cfg80211_del_key(struct wiphy *wiphy, struct net_device *dev,
 
 	val = 0;		/* assume open key. otherwise 1 */
 	val = cpu_to_le32(val);
-	err = wl_dev_ioctl(dev, BRCMF_C_SET_AUTH, &val, sizeof(val));
+	err = brcmf_dev_ioctl(dev, BRCMF_C_SET_AUTH, &val, sizeof(val));
 	if (unlikely(err)) {
 		WL_ERR("WLC_SET_AUTH error (%d)\n", err);
 		/* Ignore this error, may happen during DISASSOC */
@@ -1822,7 +1822,7 @@ done:
 }
 
 static s32
-wl_cfg80211_get_key(struct wiphy *wiphy, struct net_device *dev,
+brcmf_cfg80211_get_key(struct wiphy *wiphy, struct net_device *dev,
 		    u8 key_idx, bool pairwise, const u8 *mac_addr, void *cookie,
 		    void (*callback) (void *cookie, struct key_params * params))
 {
@@ -1844,7 +1844,7 @@ wl_cfg80211_get_key(struct wiphy *wiphy, struct net_device *dev,
 	params.key_len = (u8) min_t(u8, WLAN_MAX_KEY_LEN, key.len);
 	memcpy(params.key, key.data, params.key_len);
 
-	err = wl_dev_ioctl(dev, BRCMF_C_GET_WSEC, &wsec, sizeof(wsec));
+	err = brcmf_dev_ioctl(dev, BRCMF_C_GET_WSEC, &wsec, sizeof(wsec));
 	if (unlikely(err)) {
 		WL_ERR("WLC_GET_WSEC error (%d)\n", err);
 		/* Ignore this error, may happen during DISASSOC */
@@ -1854,7 +1854,7 @@ wl_cfg80211_get_key(struct wiphy *wiphy, struct net_device *dev,
 	wsec = le32_to_cpu(wsec);
 	switch (wsec) {
 	case WEP_ENABLED:
-		sec = wl_read_prof(wl, WL_PROF_SEC);
+		sec = brcmf_read_prof(wl, WL_PROF_SEC);
 		if (sec->cipher_pairwise & WLAN_CIPHER_SUITE_WEP40) {
 			params.cipher = WLAN_CIPHER_SUITE_WEP40;
 			WL_CONN("WLAN_CIPHER_SUITE_WEP40\n");
@@ -1884,7 +1884,7 @@ done:
 }
 
 static s32
-wl_cfg80211_config_default_mgmt_key(struct wiphy *wiphy,
+brcmf_cfg80211_config_default_mgmt_key(struct wiphy *wiphy,
 				    struct net_device *dev, u8 key_idx)
 {
 	WL_INFO("Not supported\n");
@@ -1894,7 +1894,7 @@ wl_cfg80211_config_default_mgmt_key(struct wiphy *wiphy,
 }
 
 static s32
-wl_cfg80211_get_station(struct wiphy *wiphy, struct net_device *dev,
+brcmf_cfg80211_get_station(struct wiphy *wiphy, struct net_device *dev,
 			u8 *mac, struct station_info *sinfo)
 {
 	struct wl_priv *wl = wiphy_to_wl(wiphy);
@@ -1902,7 +1902,7 @@ wl_cfg80211_get_station(struct wiphy *wiphy, struct net_device *dev,
 	int rssi;
 	s32 rate;
 	s32 err = 0;
-	u8 *bssid = wl_read_prof(wl, WL_PROF_BSSID);
+	u8 *bssid = brcmf_read_prof(wl, WL_PROF_BSSID);
 
 	WL_TRACE("Enter\n");
 	CHECK_SYS_UP();
@@ -1919,7 +1919,7 @@ wl_cfg80211_get_station(struct wiphy *wiphy, struct net_device *dev,
 	}
 
 	/* Report the current tx rate */
-	err = wl_dev_ioctl(dev, BRCMF_C_GET_RATE, &rate, sizeof(rate));
+	err = brcmf_dev_ioctl(dev, BRCMF_C_GET_RATE, &rate, sizeof(rate));
 	if (err) {
 		WL_ERR("Could not get rate (%d)\n", err);
 	} else {
@@ -1931,7 +1931,7 @@ wl_cfg80211_get_station(struct wiphy *wiphy, struct net_device *dev,
 
 	if (test_bit(WL_STATUS_CONNECTED, &wl->status)) {
 		scb_val.val = 0;
-		err = wl_dev_ioctl(dev, BRCMF_C_GET_RSSI, &scb_val,
+		err = brcmf_dev_ioctl(dev, BRCMF_C_GET_RSSI, &scb_val,
 				sizeof(struct brcmf_scb_val));
 		if (unlikely(err)) {
 			WL_ERR("Could not get rssi (%d)\n", err);
@@ -1948,7 +1948,7 @@ done:
 }
 
 static s32
-wl_cfg80211_set_power_mgmt(struct wiphy *wiphy, struct net_device *dev,
+brcmf_cfg80211_set_power_mgmt(struct wiphy *wiphy, struct net_device *dev,
 			   bool enabled, s32 timeout)
 {
 	s32 pm;
@@ -1961,7 +1961,7 @@ wl_cfg80211_set_power_mgmt(struct wiphy *wiphy, struct net_device *dev,
 	pm = cpu_to_le32(pm);
 	WL_INFO("power save %s\n", (pm ? "enabled" : "disabled"));
 
-	err = wl_dev_ioctl(dev, BRCMF_C_SET_PM, &pm, sizeof(pm));
+	err = brcmf_dev_ioctl(dev, BRCMF_C_SET_PM, &pm, sizeof(pm));
 	if (unlikely(err)) {
 		if (err == -ENODEV)
 			WL_ERR("net_device is not ready yet\n");
@@ -1972,7 +1972,7 @@ wl_cfg80211_set_power_mgmt(struct wiphy *wiphy, struct net_device *dev,
 	return err;
 }
 
-static __used u32 wl_find_msb(u16 bit16)
+static __used u32 brcmf_find_msb(u16 bit16)
 {
 	u32 ret = 0;
 
@@ -2000,7 +2000,7 @@ static __used u32 wl_find_msb(u16 bit16)
 }
 
 static s32
-wl_cfg80211_set_bitrate_mask(struct wiphy *wiphy, struct net_device *dev,
+brcmf_cfg80211_set_bitrate_mask(struct wiphy *wiphy, struct net_device *dev,
 			     const u8 *addr,
 			     const struct cfg80211_bitrate_mask *mask)
 {
@@ -2017,7 +2017,7 @@ wl_cfg80211_set_bitrate_mask(struct wiphy *wiphy, struct net_device *dev,
 
 	/* addr param is always NULL. ignore it */
 	/* Get current rateset */
-	err = wl_dev_ioctl(dev, WLC_GET_CURR_RATESET, &rateset,
+	err = brcmf_dev_ioctl(dev, WLC_GET_CURR_RATESET, &rateset,
 			sizeof(rateset));
 	if (unlikely(err)) {
 		WL_ERR("could not get current rateset (%d)\n", err);
@@ -2026,9 +2026,9 @@ wl_cfg80211_set_bitrate_mask(struct wiphy *wiphy, struct net_device *dev,
 
 	rateset.count = le32_to_cpu(rateset.count);
 
-	legacy = wl_find_msb(mask->control[IEEE80211_BAND_2GHZ].legacy);
+	legacy = brcmf_find_msb(mask->control[IEEE80211_BAND_2GHZ].legacy);
 	if (!legacy)
-		legacy = wl_find_msb(mask->control[IEEE80211_BAND_5GHZ].legacy);
+		legacy = brcmf_find_msb(mask->control[IEEE80211_BAND_5GHZ].legacy);
 
 	val = wl_g_rates[legacy - 1].bitrate * 100000;
 
@@ -2046,8 +2046,8 @@ wl_cfg80211_set_bitrate_mask(struct wiphy *wiphy, struct net_device *dev,
 	 *      Set rate override,
 	 *      Since the is a/b/g-blind, both a/bg_rate are enforced.
 	 */
-	err_bg = wl_dev_intvar_set(dev, "bg_rate", rate);
-	err_a = wl_dev_intvar_set(dev, "a_rate", rate);
+	err_bg = brcmf_dev_intvar_set(dev, "bg_rate", rate);
+	err_a = brcmf_dev_intvar_set(dev, "a_rate", rate);
 	if (unlikely(err_bg && err_a)) {
 		WL_ERR("could not set fixed rate (%d) (%d)\n", err_bg, err_a);
 		err = err_bg | err_a;
@@ -2058,7 +2058,7 @@ done:
 	return err;
 }
 
-static s32 wl_cfg80211_resume(struct wiphy *wiphy)
+static s32 brcmf_cfg80211_resume(struct wiphy *wiphy)
 {
 	struct wl_priv *wl = wiphy_to_wl(wiphy);
 
@@ -2074,13 +2074,13 @@ static s32 wl_cfg80211_resume(struct wiphy *wiphy)
 #endif	/*  defined(CONFIG_PM_SLEEP) */
 
 	if (test_bit(WL_STATUS_READY, &wl->status))
-		wl_invoke_iscan(wiphy_to_wl(wiphy));
+		brcmf_invoke_iscan(wiphy_to_wl(wiphy));
 
 	WL_TRACE("Exit\n");
 	return 0;
 }
 
-static s32 wl_cfg80211_suspend(struct wiphy *wiphy, struct cfg80211_wowlan *wow)
+static s32 brcmf_cfg80211_suspend(struct wiphy *wiphy, struct cfg80211_wowlan *wow)
 {
 	struct wl_priv *wl = wiphy_to_wl(wiphy);
 	struct net_device *ndev = wl_to_ndev(wl);
@@ -2102,7 +2102,7 @@ static s32 wl_cfg80211_suspend(struct wiphy *wiphy, struct cfg80211_wowlan *wow)
 	     test_bit(WL_STATUS_READY, &wl->status)) {
 		WL_INFO("Disassociating from AP"
 			" while entering suspend state\n");
-		wl_link_down(wl);
+		brcmf_link_down(wl);
 
 		/*
 		 * Make sure WPA_Supplicant receives all the event
@@ -2110,13 +2110,13 @@ static s32 wl_cfg80211_suspend(struct wiphy *wiphy, struct cfg80211_wowlan *wow)
 		 * the state fw and WPA_Supplicant state consistent
 		 */
 		rtnl_unlock();
-		wl_delay(500);
+		brcmf_delay(500);
 		rtnl_lock();
 	}
 
 	set_bit(WL_STATUS_SCAN_ABORTING, &wl->status);
 	if (test_bit(WL_STATUS_READY, &wl->status))
-		wl_term_iscan(wl);
+		brcmf_term_iscan(wl);
 
 	if (wl->scan_request) {
 		/* Indidate scan abort to cfg80211 layer */
@@ -2130,7 +2130,7 @@ static s32 wl_cfg80211_suspend(struct wiphy *wiphy, struct cfg80211_wowlan *wow)
 	/* Turn off watchdog timer */
 	if (test_bit(WL_STATUS_READY, &wl->status)) {
 		WL_INFO("Enable MPC\n");
-		wl_set_mpc(ndev, 1);
+		brcmf_set_mpc(ndev, 1);
 	}
 
 #if defined(CONFIG_PM_SLEEP)
@@ -2143,7 +2143,7 @@ static s32 wl_cfg80211_suspend(struct wiphy *wiphy, struct cfg80211_wowlan *wow)
 }
 
 static __used s32
-wl_update_pmklist(struct net_device *dev, struct wl_pmk_list *pmk_list,
+brcmf_update_pmklist(struct net_device *dev, struct wl_pmk_list *pmk_list,
 		  s32 err)
 {
 	int i, j;
@@ -2157,14 +2157,14 @@ wl_update_pmklist(struct net_device *dev, struct wl_pmk_list *pmk_list,
 	}
 
 	if (likely(!err))
-		wl_dev_bufvar_set(dev, "pmkid_info", (char *)pmk_list,
+		brcmf_dev_bufvar_set(dev, "pmkid_info", (char *)pmk_list,
 					sizeof(*pmk_list));
 
 	return err;
 }
 
 static s32
-wl_cfg80211_set_pmksa(struct wiphy *wiphy, struct net_device *dev,
+brcmf_cfg80211_set_pmksa(struct wiphy *wiphy, struct net_device *dev,
 		      struct cfg80211_pmksa *pmksa)
 {
 	struct wl_priv *wl = wiphy_to_wl(wiphy);
@@ -2195,14 +2195,14 @@ wl_cfg80211_set_pmksa(struct wiphy *wiphy, struct net_device *dev,
 		       wl->pmk_list->pmkids.pmkid[wl->pmk_list->pmkids.npmkid].
 		       PMKID[i]);
 
-	err = wl_update_pmklist(dev, wl->pmk_list, err);
+	err = brcmf_update_pmklist(dev, wl->pmk_list, err);
 
 	WL_TRACE("Exit\n");
 	return err;
 }
 
 static s32
-wl_cfg80211_del_pmksa(struct wiphy *wiphy, struct net_device *dev,
+brcmf_cfg80211_del_pmksa(struct wiphy *wiphy, struct net_device *dev,
 		      struct cfg80211_pmksa *pmksa)
 {
 	struct wl_priv *wl = wiphy_to_wl(wiphy);
@@ -2241,7 +2241,7 @@ wl_cfg80211_del_pmksa(struct wiphy *wiphy, struct net_device *dev,
 	} else
 		err = -EINVAL;
 
-	err = wl_update_pmklist(dev, wl->pmk_list, err);
+	err = brcmf_update_pmklist(dev, wl->pmk_list, err);
 
 	WL_TRACE("Exit\n");
 	return err;
@@ -2249,7 +2249,7 @@ wl_cfg80211_del_pmksa(struct wiphy *wiphy, struct net_device *dev,
 }
 
 static s32
-wl_cfg80211_flush_pmksa(struct wiphy *wiphy, struct net_device *dev)
+brcmf_cfg80211_flush_pmksa(struct wiphy *wiphy, struct net_device *dev)
 {
 	struct wl_priv *wl = wiphy_to_wl(wiphy);
 	s32 err = 0;
@@ -2258,7 +2258,7 @@ wl_cfg80211_flush_pmksa(struct wiphy *wiphy, struct net_device *dev)
 	CHECK_SYS_UP();
 
 	memset(wl->pmk_list, 0, sizeof(*wl->pmk_list));
-	err = wl_update_pmklist(dev, wl->pmk_list, err);
+	err = brcmf_update_pmklist(dev, wl->pmk_list, err);
 
 	WL_TRACE("Exit\n");
 	return err;
@@ -2266,31 +2266,31 @@ wl_cfg80211_flush_pmksa(struct wiphy *wiphy, struct net_device *dev)
 }
 
 static struct cfg80211_ops wl_cfg80211_ops = {
-	.change_virtual_intf = wl_cfg80211_change_iface,
-	.scan = wl_cfg80211_scan,
-	.set_wiphy_params = wl_cfg80211_set_wiphy_params,
-	.join_ibss = wl_cfg80211_join_ibss,
-	.leave_ibss = wl_cfg80211_leave_ibss,
-	.get_station = wl_cfg80211_get_station,
-	.set_tx_power = wl_cfg80211_set_tx_power,
-	.get_tx_power = wl_cfg80211_get_tx_power,
-	.add_key = wl_cfg80211_add_key,
-	.del_key = wl_cfg80211_del_key,
-	.get_key = wl_cfg80211_get_key,
-	.set_default_key = wl_cfg80211_config_default_key,
-	.set_default_mgmt_key = wl_cfg80211_config_default_mgmt_key,
-	.set_power_mgmt = wl_cfg80211_set_power_mgmt,
-	.set_bitrate_mask = wl_cfg80211_set_bitrate_mask,
-	.connect = wl_cfg80211_connect,
-	.disconnect = wl_cfg80211_disconnect,
-	.suspend = wl_cfg80211_suspend,
-	.resume = wl_cfg80211_resume,
-	.set_pmksa = wl_cfg80211_set_pmksa,
-	.del_pmksa = wl_cfg80211_del_pmksa,
-	.flush_pmksa = wl_cfg80211_flush_pmksa
+	.change_virtual_intf = brcmf_cfg80211_change_iface,
+	.scan = brcmf_cfg80211_scan,
+	.set_wiphy_params = brcmf_cfg80211_set_wiphy_params,
+	.join_ibss = brcmf_cfg80211_join_ibss,
+	.leave_ibss = brcmf_cfg80211_leave_ibss,
+	.get_station = brcmf_cfg80211_get_station,
+	.set_tx_power = brcmf_cfg80211_set_tx_power,
+	.get_tx_power = brcmf_cfg80211_get_tx_power,
+	.add_key = brcmf_cfg80211_add_key,
+	.del_key = brcmf_cfg80211_del_key,
+	.get_key = brcmf_cfg80211_get_key,
+	.set_default_key = brcmf_cfg80211_config_default_key,
+	.set_default_mgmt_key = brcmf_cfg80211_config_default_mgmt_key,
+	.set_power_mgmt = brcmf_cfg80211_set_power_mgmt,
+	.set_bitrate_mask = brcmf_cfg80211_set_bitrate_mask,
+	.connect = brcmf_cfg80211_connect,
+	.disconnect = brcmf_cfg80211_disconnect,
+	.suspend = brcmf_cfg80211_suspend,
+	.resume = brcmf_cfg80211_resume,
+	.set_pmksa = brcmf_cfg80211_set_pmksa,
+	.del_pmksa = brcmf_cfg80211_del_pmksa,
+	.flush_pmksa = brcmf_cfg80211_flush_pmksa
 };
 
-static s32 wl_mode_to_nl80211_iftype(s32 mode)
+static s32 brcmf_mode_to_nl80211_iftype(s32 mode)
 {
 	s32 err = 0;
 
@@ -2306,7 +2306,7 @@ static s32 wl_mode_to_nl80211_iftype(s32 mode)
 	return err;
 }
 
-static struct wireless_dev *wl_alloc_wdev(s32 sizeof_iface,
+static struct wireless_dev *brcmf_alloc_wdev(s32 sizeof_iface,
 					  struct device *dev)
 {
 	struct wireless_dev *wdev;
@@ -2364,7 +2364,7 @@ wiphy_new_out:
 	return ERR_PTR(err);
 }
 
-static void wl_free_wdev(struct wl_priv *wl)
+static void brcmf_free_wdev(struct wl_priv *wl)
 {
 	struct wireless_dev *wdev = wl_to_wdev(wl);
 
@@ -2378,7 +2378,7 @@ static void wl_free_wdev(struct wl_priv *wl)
 	wl_to_wdev(wl) = NULL;
 }
 
-static s32 wl_inform_bss(struct wl_priv *wl)
+static s32 brcmf_inform_bss(struct wl_priv *wl)
 {
 	struct brcmf_scan_results *bss_list;
 	struct brcmf_bss_info *bi = NULL;	/* must be initialized */
@@ -2394,7 +2394,7 @@ static s32 wl_inform_bss(struct wl_priv *wl)
 	WL_SCAN("scanned AP count (%d)\n", bss_list->count);
 	bi = next_bss(bss_list, bi);
 	for_each_bss(bss_list, bi, i) {
-		err = wl_inform_single_bss(wl, bi);
+		err = brcmf_inform_single_bss(wl, bi);
 		if (unlikely(err))
 			break;
 	}
@@ -2402,7 +2402,7 @@ static s32 wl_inform_bss(struct wl_priv *wl)
 }
 
 
-static s32 wl_inform_single_bss(struct wl_priv *wl, struct brcmf_bss_info *bi)
+static s32 brcmf_inform_single_bss(struct wl_priv *wl, struct brcmf_bss_info *bi)
 {
 	struct wiphy *wiphy = wl_to_wiphy(wl);
 	struct ieee80211_channel *notify_channel;
@@ -2491,7 +2491,7 @@ wl_inform_ibss(struct wl_priv *wl, struct net_device *dev, const u8 *bssid)
 
 	*(u32 *)buf = cpu_to_le32(WL_BSS_INFO_MAX);
 
-	err = wl_dev_ioctl(dev, BRCMF_C_GET_BSS_INFO, buf, WL_BSS_INFO_MAX);
+	err = brcmf_dev_ioctl(dev, BRCMF_C_GET_BSS_INFO, buf, WL_BSS_INFO_MAX);
 	if (unlikely(err)) {
 		WL_ERR("WLC_GET_BSS_INFO failed: %d\n", err);
 		goto CleanUp;
@@ -2536,7 +2536,7 @@ CleanUp:
 	return err;
 }
 
-static bool wl_is_linkup(struct wl_priv *wl, const brcmf_event_msg_t *e)
+static bool brcmf_is_linkup(struct wl_priv *wl, const brcmf_event_msg_t *e)
 {
 	u32 event = be32_to_cpu(e->event_type);
 	u32 status = be32_to_cpu(e->status);
@@ -2550,7 +2550,7 @@ static bool wl_is_linkup(struct wl_priv *wl, const brcmf_event_msg_t *e)
 	return false;
 }
 
-static bool wl_is_linkdown(struct wl_priv *wl, const brcmf_event_msg_t *e)
+static bool brcmf_is_linkdown(struct wl_priv *wl, const brcmf_event_msg_t *e)
 {
 	u32 event = be32_to_cpu(e->event_type);
 	u16 flags = be16_to_cpu(e->flags);
@@ -2562,7 +2562,7 @@ static bool wl_is_linkdown(struct wl_priv *wl, const brcmf_event_msg_t *e)
 	return false;
 }
 
-static bool wl_is_nonetwork(struct wl_priv *wl, const brcmf_event_msg_t *e)
+static bool brcmf_is_nonetwork(struct wl_priv *wl, const brcmf_event_msg_t *e)
 {
 	u32 event = be32_to_cpu(e->event_type);
 	u32 status = be32_to_cpu(e->status);
@@ -2583,51 +2583,51 @@ static bool wl_is_nonetwork(struct wl_priv *wl, const brcmf_event_msg_t *e)
 }
 
 static s32
-wl_notify_connect_status(struct wl_priv *wl, struct net_device *ndev,
+brcmf_notify_connect_status(struct wl_priv *wl, struct net_device *ndev,
 			 const brcmf_event_msg_t *e, void *data)
 {
 	s32 err = 0;
 
-	if (wl_is_linkup(wl, e)) {
+	if (brcmf_is_linkup(wl, e)) {
 		WL_CONN("Linkup\n");
-		if (wl_is_ibssmode(wl)) {
-			wl_update_prof(wl, NULL, (void *)e->addr,
+		if (brcmf_is_ibssmode(wl)) {
+			brcmf_update_prof(wl, NULL, (void *)e->addr,
 				WL_PROF_BSSID);
 			wl_inform_ibss(wl, ndev, e->addr);
 			cfg80211_ibss_joined(ndev, e->addr, GFP_KERNEL);
 			clear_bit(WL_STATUS_CONNECTING, &wl->status);
 			set_bit(WL_STATUS_CONNECTED, &wl->status);
 		} else
-			wl_bss_connect_done(wl, ndev, e, data, true);
-	} else if (wl_is_linkdown(wl, e)) {
+			brcmf_bss_connect_done(wl, ndev, e, data, true);
+	} else if (brcmf_is_linkdown(wl, e)) {
 		WL_CONN("Linkdown\n");
-		if (wl_is_ibssmode(wl)) {
+		if (brcmf_is_ibssmode(wl)) {
 			clear_bit(WL_STATUS_CONNECTING, &wl->status);
 			if (test_and_clear_bit(WL_STATUS_CONNECTED,
 				&wl->status))
-				wl_link_down(wl);
+				brcmf_link_down(wl);
 		} else {
-			wl_bss_connect_done(wl, ndev, e, data, false);
+			brcmf_bss_connect_done(wl, ndev, e, data, false);
 			if (test_and_clear_bit(WL_STATUS_CONNECTED,
 				&wl->status)) {
 				cfg80211_disconnected(ndev, 0, NULL, 0,
 					GFP_KERNEL);
-				wl_link_down(wl);
+				brcmf_link_down(wl);
 			}
 		}
-		wl_init_prof(wl->profile);
-	} else if (wl_is_nonetwork(wl, e)) {
-		if (wl_is_ibssmode(wl))
+		brcmf_init_prof(wl->profile);
+	} else if (brcmf_is_nonetwork(wl, e)) {
+		if (brcmf_is_ibssmode(wl))
 			clear_bit(WL_STATUS_CONNECTING, &wl->status);
 		else
-			wl_bss_connect_done(wl, ndev, e, data, false);
+			brcmf_bss_connect_done(wl, ndev, e, data, false);
 	}
 
 	return err;
 }
 
 static s32
-wl_notify_roaming_status(struct wl_priv *wl, struct net_device *ndev,
+brcmf_notify_roaming_status(struct wl_priv *wl, struct net_device *ndev,
 			 const brcmf_event_msg_t *e, void *data)
 {
 	s32 err = 0;
@@ -2636,16 +2636,16 @@ wl_notify_roaming_status(struct wl_priv *wl, struct net_device *ndev,
 
 	if (event == BRCMF_E_ROAM && status == BRCMF_E_STATUS_SUCCESS) {
 		if (test_bit(WL_STATUS_CONNECTED, &wl->status))
-			wl_bss_roaming_done(wl, ndev, e, data);
+			brcmf_bss_roaming_done(wl, ndev, e, data);
 		else
-			wl_bss_connect_done(wl, ndev, e, data, true);
+			brcmf_bss_connect_done(wl, ndev, e, data, true);
 	}
 
 	return err;
 }
 
 static __used s32
-wl_dev_bufvar_set(struct net_device *dev, s8 *name, s8 *buf, s32 len)
+brcmf_dev_bufvar_set(struct net_device *dev, s8 *name, s8 *buf, s32 len)
 {
 	struct wl_priv *wl = ndev_to_wl(dev);
 	u32 buflen;
@@ -2653,11 +2653,11 @@ wl_dev_bufvar_set(struct net_device *dev, s8 *name, s8 *buf, s32 len)
 	buflen = brcmu_mkiovar(name, buf, len, wl->ioctl_buf, WL_IOCTL_LEN_MAX);
 	BUG_ON(!buflen);
 
-	return wl_dev_ioctl(dev, BRCMF_C_SET_VAR, wl->ioctl_buf, buflen);
+	return brcmf_dev_ioctl(dev, BRCMF_C_SET_VAR, wl->ioctl_buf, buflen);
 }
 
 static s32
-wl_dev_bufvar_get(struct net_device *dev, s8 *name, s8 *buf,
+brcmf_dev_bufvar_get(struct net_device *dev, s8 *name, s8 *buf,
 		  s32 buf_len)
 {
 	struct wl_priv *wl = ndev_to_wl(dev);
@@ -2666,7 +2666,7 @@ wl_dev_bufvar_get(struct net_device *dev, s8 *name, s8 *buf,
 
 	len = brcmu_mkiovar(name, NULL, 0, wl->ioctl_buf, WL_IOCTL_LEN_MAX);
 	BUG_ON(!len);
-	err = wl_dev_ioctl(dev, BRCMF_C_GET_VAR, (void *)wl->ioctl_buf,
+	err = brcmf_dev_ioctl(dev, BRCMF_C_GET_VAR, (void *)wl->ioctl_buf,
 			WL_IOCTL_LEN_MAX);
 	if (unlikely(err)) {
 		WL_ERR("error (%d)\n", err);
@@ -2677,7 +2677,7 @@ wl_dev_bufvar_get(struct net_device *dev, s8 *name, s8 *buf,
 	return err;
 }
 
-static s32 wl_get_assoc_ies(struct wl_priv *wl)
+static s32 brcmf_get_assoc_ies(struct wl_priv *wl)
 {
 	struct net_device *ndev = wl_to_ndev(wl);
 	struct wl_assoc_ielen *assoc_info;
@@ -2686,9 +2686,9 @@ static s32 wl_get_assoc_ies(struct wl_priv *wl)
 	u32 resp_len;
 	s32 err = 0;
 
-	wl_clear_assoc_ies(wl);
+	brcmf_clear_assoc_ies(wl);
 
-	err = wl_dev_bufvar_get(ndev, "assoc_info", wl->extra_buf,
+	err = brcmf_dev_bufvar_get(ndev, "assoc_info", wl->extra_buf,
 				WL_ASSOC_INFO_MAX);
 	if (unlikely(err)) {
 		WL_ERR("could not get assoc info (%d)\n", err);
@@ -2698,7 +2698,7 @@ static s32 wl_get_assoc_ies(struct wl_priv *wl)
 	req_len = assoc_info->req_len;
 	resp_len = assoc_info->resp_len;
 	if (req_len) {
-		err = wl_dev_bufvar_get(ndev, "assoc_req_ies", wl->extra_buf,
+		err = brcmf_dev_bufvar_get(ndev, "assoc_req_ies", wl->extra_buf,
 					WL_ASSOC_INFO_MAX);
 		if (unlikely(err)) {
 			WL_ERR("could not get assoc req (%d)\n", err);
@@ -2712,7 +2712,7 @@ static s32 wl_get_assoc_ies(struct wl_priv *wl)
 		conn_info->req_ie = NULL;
 	}
 	if (resp_len) {
-		err = wl_dev_bufvar_get(ndev, "assoc_resp_ies", wl->extra_buf,
+		err = brcmf_dev_bufvar_get(ndev, "assoc_resp_ies", wl->extra_buf,
 					WL_ASSOC_INFO_MAX);
 		if (unlikely(err)) {
 			WL_ERR("could not get assoc resp (%d)\n", err);
@@ -2731,7 +2731,7 @@ static s32 wl_get_assoc_ies(struct wl_priv *wl)
 	return err;
 }
 
-static void wl_clear_assoc_ies(struct wl_priv *wl)
+static void brcmf_clear_assoc_ies(struct wl_priv *wl)
 {
 	struct wl_connect_info *conn_info = wl_to_conn(wl);
 
@@ -2744,7 +2744,7 @@ static void wl_clear_assoc_ies(struct wl_priv *wl)
 }
 
 
-static void wl_ch_to_chanspec(int ch, struct brcmf_join_params *join_params,
+static void brcmf_ch_to_chanspec(int ch, struct brcmf_join_params *join_params,
 	size_t *join_params_size)
 {
 	chanspec_t chanspec = 0;
@@ -2778,7 +2778,7 @@ static void wl_ch_to_chanspec(int ch, struct brcmf_join_params *join_params,
 	}
 }
 
-static s32 wl_update_bss_info(struct wl_priv *wl)
+static s32 brcmf_update_bss_info(struct wl_priv *wl)
 {
 	struct brcmf_bss_info *bi;
 	struct brcmf_ssid *ssid;
@@ -2790,13 +2790,13 @@ static s32 wl_update_bss_info(struct wl_priv *wl)
 	s32 err = 0;
 
 	WL_TRACE("Enter\n");
-	if (wl_is_ibssmode(wl))
+	if (brcmf_is_ibssmode(wl))
 		return err;
 
-	ssid = (struct brcmf_ssid *)wl_read_prof(wl, WL_PROF_SSID);
+	ssid = (struct brcmf_ssid *)brcmf_read_prof(wl, WL_PROF_SSID);
 
 	*(u32 *)wl->extra_buf = cpu_to_le32(WL_EXTRA_BUF_MAX);
-	err = wl_dev_ioctl(wl_to_ndev(wl), BRCMF_C_GET_BSS_INFO,
+	err = brcmf_dev_ioctl(wl_to_ndev(wl), BRCMF_C_GET_BSS_INFO,
 			wl->extra_buf, WL_EXTRA_BUF_MAX);
 	if (unlikely(err)) {
 		WL_ERR("Could not get bss info %d\n", err);
@@ -2804,7 +2804,7 @@ static s32 wl_update_bss_info(struct wl_priv *wl)
 	}
 
 	bi = (struct brcmf_bss_info *)(wl->extra_buf + 4);
-	err = wl_inform_single_bss(wl, bi);
+	err = brcmf_inform_single_bss(wl, bi);
 	if (unlikely(err))
 		goto update_bss_info_out;
 
@@ -2822,7 +2822,7 @@ static s32 wl_update_bss_info(struct wl_priv *wl)
 		* so we speficially query dtim information to dongle.
 		*/
 		u32 var;
-		err = wl_dev_intvar_get(wl_to_ndev(wl), "dtim_assoc", &var);
+		err = brcmf_dev_intvar_get(wl_to_ndev(wl), "dtim_assoc", &var);
 		if (unlikely(err)) {
 			WL_ERR("wl dtim_assoc failed (%d)\n", err);
 			goto update_bss_info_out;
@@ -2830,8 +2830,8 @@ static s32 wl_update_bss_info(struct wl_priv *wl)
 		dtim_period = (u8)var;
 	}
 
-	wl_update_prof(wl, NULL, &beacon_interval, WL_PROF_BEACONINT);
-	wl_update_prof(wl, NULL, &dtim_period, WL_PROF_DTIMPERIOD);
+	brcmf_update_prof(wl, NULL, &beacon_interval, WL_PROF_BEACONINT);
+	brcmf_update_prof(wl, NULL, &dtim_period, WL_PROF_DTIMPERIOD);
 
 update_bss_info_out:
 	WL_TRACE("Exit");
@@ -2839,7 +2839,7 @@ update_bss_info_out:
 }
 
 static s32
-wl_bss_roaming_done(struct wl_priv *wl, struct net_device *ndev,
+brcmf_bss_roaming_done(struct wl_priv *wl, struct net_device *ndev,
 		    const brcmf_event_msg_t *e, void *data)
 {
 	struct wl_connect_info *conn_info = wl_to_conn(wl);
@@ -2847,12 +2847,12 @@ wl_bss_roaming_done(struct wl_priv *wl, struct net_device *ndev,
 
 	WL_TRACE("Enter\n");
 
-	wl_get_assoc_ies(wl);
-	wl_update_prof(wl, NULL, &e->addr, WL_PROF_BSSID);
-	wl_update_bss_info(wl);
+	brcmf_get_assoc_ies(wl);
+	brcmf_update_prof(wl, NULL, &e->addr, WL_PROF_BSSID);
+	brcmf_update_bss_info(wl);
 
 	cfg80211_roamed(ndev, NULL,
-			(u8 *)wl_read_prof(wl, WL_PROF_BSSID),
+			(u8 *)brcmf_read_prof(wl, WL_PROF_BSSID),
 			conn_info->req_ie, conn_info->req_ie_len,
 			conn_info->resp_ie, conn_info->resp_ie_len, GFP_KERNEL);
 	WL_CONN("Report roaming result\n");
@@ -2863,7 +2863,7 @@ wl_bss_roaming_done(struct wl_priv *wl, struct net_device *ndev,
 }
 
 static s32
-wl_bss_connect_done(struct wl_priv *wl, struct net_device *ndev,
+brcmf_bss_connect_done(struct wl_priv *wl, struct net_device *ndev,
 		    const brcmf_event_msg_t *e, void *data, bool completed)
 {
 	struct wl_connect_info *conn_info = wl_to_conn(wl);
@@ -2873,12 +2873,12 @@ wl_bss_connect_done(struct wl_priv *wl, struct net_device *ndev,
 
 	if (test_and_clear_bit(WL_STATUS_CONNECTING, &wl->status)) {
 		if (completed) {
-			wl_get_assoc_ies(wl);
-			wl_update_prof(wl, NULL, &e->addr, WL_PROF_BSSID);
-			wl_update_bss_info(wl);
+			brcmf_get_assoc_ies(wl);
+			brcmf_update_prof(wl, NULL, &e->addr, WL_PROF_BSSID);
+			brcmf_update_bss_info(wl);
 		}
 		cfg80211_connect_result(ndev,
-					(u8 *)wl_read_prof(wl, WL_PROF_BSSID),
+					(u8 *)brcmf_read_prof(wl, WL_PROF_BSSID),
 					conn_info->req_ie,
 					conn_info->req_ie_len,
 					conn_info->resp_ie,
@@ -2895,7 +2895,7 @@ wl_bss_connect_done(struct wl_priv *wl, struct net_device *ndev,
 }
 
 static s32
-wl_notify_mic_status(struct wl_priv *wl, struct net_device *ndev,
+brcmf_notify_mic_status(struct wl_priv *wl, struct net_device *ndev,
 		     const brcmf_event_msg_t *e, void *data)
 {
 	u16 flags = be16_to_cpu(e->flags);
@@ -2915,7 +2915,7 @@ wl_notify_mic_status(struct wl_priv *wl, struct net_device *ndev,
 }
 
 static s32
-wl_notify_scan_status(struct wl_priv *wl, struct net_device *ndev,
+brcmf_notify_scan_status(struct wl_priv *wl, struct net_device *ndev,
 		      const brcmf_event_msg_t *e, void *data)
 {
 	struct brcmf_channel_info channel_inform;
@@ -2928,7 +2928,7 @@ wl_notify_scan_status(struct wl_priv *wl, struct net_device *ndev,
 
 	if (wl->iscan_on && wl->iscan_kickstart) {
 		WL_TRACE("Exit\n");
-		return wl_wakeup_iscan(wl_to_iscan(wl));
+		return brcmf_wakeup_iscan(wl_to_iscan(wl));
 	}
 
 	if (unlikely(!test_and_clear_bit(WL_STATUS_SCANNING, &wl->status))) {
@@ -2938,7 +2938,7 @@ wl_notify_scan_status(struct wl_priv *wl, struct net_device *ndev,
 		goto scan_done_out;
 	}
 
-	err = wl_dev_ioctl(ndev, BRCMF_C_GET_CHANNEL, &channel_inform,
+	err = brcmf_dev_ioctl(ndev, BRCMF_C_GET_CHANNEL, &channel_inform,
 			sizeof(channel_inform));
 	if (unlikely(err)) {
 		WL_ERR("scan busy (%d)\n", err);
@@ -2956,7 +2956,7 @@ wl_notify_scan_status(struct wl_priv *wl, struct net_device *ndev,
 	memset(bss_list, 0, len);
 	bss_list->buflen = cpu_to_le32(len);
 
-	err = wl_dev_ioctl(ndev, BRCMF_C_SCAN_RESULTS, bss_list, len);
+	err = brcmf_dev_ioctl(ndev, BRCMF_C_SCAN_RESULTS, bss_list, len);
 	if (unlikely(err)) {
 		WL_ERR("%s Scan_results error (%d)\n", ndev->name, err);
 		err = -EINVAL;
@@ -2967,7 +2967,7 @@ wl_notify_scan_status(struct wl_priv *wl, struct net_device *ndev,
 	bss_list->version = le32_to_cpu(bss_list->version);
 	bss_list->count = le32_to_cpu(bss_list->count);
 
-	err = wl_inform_bss(wl);
+	err = brcmf_inform_bss(wl);
 	if (err) {
 		scan_abort = true;
 		goto scan_done_out;
@@ -2977,7 +2977,7 @@ scan_done_out:
 	if (wl->scan_request) {
 		WL_SCAN("calling cfg80211_scan_done\n");
 		cfg80211_scan_done(wl->scan_request, scan_abort);
-		wl_set_mpc(ndev, 1);
+		brcmf_set_mpc(ndev, 1);
 		wl->scan_request = NULL;
 	}
 
@@ -2986,7 +2986,7 @@ scan_done_out:
 	return err;
 }
 
-static void wl_init_conf(struct wl_conf *conf)
+static void brcmf_init_conf(struct wl_conf *conf)
 {
 	conf->mode = (u32)-1;
 	conf->frag_threshold = (u32)-1;
@@ -2996,22 +2996,22 @@ static void wl_init_conf(struct wl_conf *conf)
 	conf->tx_power = -1;
 }
 
-static void wl_init_prof(struct wl_profile *prof)
+static void brcmf_init_prof(struct wl_profile *prof)
 {
 	memset(prof, 0, sizeof(*prof));
 }
 
-static void wl_init_eloop_handler(struct wl_event_loop *el)
+static void brcmf_init_eloop_handler(struct wl_event_loop *el)
 {
 	memset(el, 0, sizeof(*el));
-	el->handler[BRCMF_E_SCAN_COMPLETE] = wl_notify_scan_status;
-	el->handler[BRCMF_E_LINK] = wl_notify_connect_status;
-	el->handler[BRCMF_E_ROAM] = wl_notify_roaming_status;
-	el->handler[BRCMF_E_MIC_ERROR] = wl_notify_mic_status;
-	el->handler[BRCMF_E_SET_SSID] = wl_notify_connect_status;
+	el->handler[BRCMF_E_SCAN_COMPLETE] = brcmf_notify_scan_status;
+	el->handler[BRCMF_E_LINK] = brcmf_notify_connect_status;
+	el->handler[BRCMF_E_ROAM] = brcmf_notify_roaming_status;
+	el->handler[BRCMF_E_MIC_ERROR] = brcmf_notify_mic_status;
+	el->handler[BRCMF_E_SET_SSID] = brcmf_notify_connect_status;
 }
 
-static s32 wl_init_priv_mem(struct wl_priv *wl)
+static s32 brcmf_init_priv_mem(struct wl_priv *wl)
 {
 	wl->scan_results = kzalloc(WL_SCAN_BUF_MAX, GFP_KERNEL);
 	if (unlikely(!wl->scan_results)) {
@@ -3062,12 +3062,12 @@ static s32 wl_init_priv_mem(struct wl_priv *wl)
 	return 0;
 
 init_priv_mem_out:
-	wl_deinit_priv_mem(wl);
+	brcmf_deinit_priv_mem(wl);
 
 	return -ENOMEM;
 }
 
-static void wl_deinit_priv_mem(struct wl_priv *wl)
+static void brcmf_deinit_priv_mem(struct wl_priv *wl)
 {
 	kfree(wl->scan_results);
 	wl->scan_results = NULL;
@@ -3089,10 +3089,10 @@ static void wl_deinit_priv_mem(struct wl_priv *wl)
 	wl->pmk_list = NULL;
 }
 
-static s32 wl_create_event_handler(struct wl_priv *wl)
+static s32 brcmf_create_event_handler(struct wl_priv *wl)
 {
 	sema_init(&wl->event_sync, 0);
-	wl->event_tsk = kthread_run(wl_event_handler, wl, "wl_event_handler");
+	wl->event_tsk = kthread_run(brcmf_event_handler, wl, "wl_event_handler");
 	if (IS_ERR(wl->event_tsk)) {
 		wl->event_tsk = NULL;
 		WL_ERR("failed to create event thread\n");
@@ -3101,7 +3101,7 @@ static s32 wl_create_event_handler(struct wl_priv *wl)
 	return 0;
 }
 
-static void wl_destroy_event_handler(struct wl_priv *wl)
+static void brcmf_destroy_event_handler(struct wl_priv *wl)
 {
 	if (wl->event_tsk) {
 		send_sig(SIGTERM, wl->event_tsk, 1);
@@ -3110,7 +3110,7 @@ static void wl_destroy_event_handler(struct wl_priv *wl)
 	}
 }
 
-static void wl_term_iscan(struct wl_priv *wl)
+static void brcmf_term_iscan(struct wl_priv *wl)
 {
 	struct wl_iscan_ctrl *iscan = wl_to_iscan(wl);
 
@@ -3122,7 +3122,7 @@ static void wl_term_iscan(struct wl_priv *wl)
 	}
 }
 
-static void wl_notify_iscan_complete(struct wl_iscan_ctrl *iscan, bool aborted)
+static void brcmf_notify_iscan_complete(struct wl_iscan_ctrl *iscan, bool aborted)
 {
 	struct wl_priv *wl = iscan_to_wl(iscan);
 	struct net_device *ndev = wl_to_ndev(wl);
@@ -3135,13 +3135,13 @@ static void wl_notify_iscan_complete(struct wl_iscan_ctrl *iscan, bool aborted)
 		WL_SCAN("ISCAN Completed scan: %s\n",
 				aborted ? "Aborted" : "Done");
 		cfg80211_scan_done(wl->scan_request, aborted);
-		wl_set_mpc(ndev, 1);
+		brcmf_set_mpc(ndev, 1);
 		wl->scan_request = NULL;
 	}
 	wl->iscan_kickstart = false;
 }
 
-static s32 wl_wakeup_iscan(struct wl_iscan_ctrl *iscan)
+static s32 brcmf_wakeup_iscan(struct wl_iscan_ctrl *iscan)
 {
 	if (likely(iscan->state != WL_ISCAN_STATE_IDLE)) {
 		WL_SCAN("wake up iscan\n");
@@ -3153,7 +3153,7 @@ static s32 wl_wakeup_iscan(struct wl_iscan_ctrl *iscan)
 }
 
 static s32
-wl_get_iscan_results(struct wl_iscan_ctrl *iscan, u32 *status,
+brcmf_get_iscan_results(struct wl_iscan_ctrl *iscan, u32 *status,
 		     struct brcmf_scan_results **bss_list)
 {
 	struct brcmf_iscan_results list;
@@ -3170,7 +3170,7 @@ wl_get_iscan_results(struct wl_iscan_ctrl *iscan, u32 *status,
 
 	memset(&list, 0, sizeof(list));
 	list.results.buflen = cpu_to_le32(WL_ISCAN_BUF_MAX);
-	err = wl_dev_iovar_getbuf(iscan->dev, "iscanresults", &list,
+	err = brcmf_dev_iovar_getbuf(iscan->dev, "iscanresults", &list,
 				BRCMF_ISCAN_RESULTS_FIXED_SIZE, iscan->scan_buf,
 				WL_ISCAN_BUF_MAX);
 	if (unlikely(err)) {
@@ -3188,21 +3188,21 @@ wl_get_iscan_results(struct wl_iscan_ctrl *iscan, u32 *status,
 	return err;
 }
 
-static s32 wl_iscan_done(struct wl_priv *wl)
+static s32 brcmf_iscan_done(struct wl_priv *wl)
 {
 	struct wl_iscan_ctrl *iscan = wl->iscan;
 	s32 err = 0;
 
 	iscan->state = WL_ISCAN_STATE_IDLE;
 	rtnl_lock();
-	wl_inform_bss(wl);
-	wl_notify_iscan_complete(iscan, false);
+	brcmf_inform_bss(wl);
+	brcmf_notify_iscan_complete(iscan, false);
 	rtnl_unlock();
 
 	return err;
 }
 
-static s32 wl_iscan_pending(struct wl_priv *wl)
+static s32 brcmf_iscan_pending(struct wl_priv *wl)
 {
 	struct wl_iscan_ctrl *iscan = wl->iscan;
 	s32 err = 0;
@@ -3214,14 +3214,14 @@ static s32 wl_iscan_pending(struct wl_priv *wl)
 	return err;
 }
 
-static s32 wl_iscan_inprogress(struct wl_priv *wl)
+static s32 brcmf_iscan_inprogress(struct wl_priv *wl)
 {
 	struct wl_iscan_ctrl *iscan = wl->iscan;
 	s32 err = 0;
 
 	rtnl_lock();
-	wl_inform_bss(wl);
-	wl_run_iscan(iscan, NULL, BRCMF_SCAN_ACTION_CONTINUE);
+	brcmf_inform_bss(wl);
+	brcmf_run_iscan(iscan, NULL, BRCMF_SCAN_ACTION_CONTINUE);
 	rtnl_unlock();
 	/* Reschedule the timer */
 	mod_timer(&iscan->timer, jiffies + iscan->timer_ms * HZ / 1000);
@@ -3230,20 +3230,20 @@ static s32 wl_iscan_inprogress(struct wl_priv *wl)
 	return err;
 }
 
-static s32 wl_iscan_aborted(struct wl_priv *wl)
+static s32 brcmf_iscan_aborted(struct wl_priv *wl)
 {
 	struct wl_iscan_ctrl *iscan = wl->iscan;
 	s32 err = 0;
 
 	iscan->state = WL_ISCAN_STATE_IDLE;
 	rtnl_lock();
-	wl_notify_iscan_complete(iscan, true);
+	brcmf_notify_iscan_complete(iscan, true);
 	rtnl_unlock();
 
 	return err;
 }
 
-static s32 wl_iscan_thread(void *data)
+static s32 brcmf_iscan_thread(void *data)
 {
 	struct sched_param param = {.sched_priority = MAX_RT_PRIO - 1 };
 	struct wl_iscan_ctrl *iscan = (struct wl_iscan_ctrl *)data;
@@ -3263,7 +3263,7 @@ static s32 wl_iscan_thread(void *data)
 			iscan->timer_on = 0;
 		}
 		rtnl_lock();
-		err = wl_get_iscan_results(iscan, &status, &wl->bss_list);
+		err = brcmf_get_iscan_results(iscan, &status, &wl->bss_list);
 		if (unlikely(err)) {
 			status = BRCMF_SCAN_RESULTS_ABORTED;
 			WL_ERR("Abort iscan\n");
@@ -3280,18 +3280,18 @@ static s32 wl_iscan_thread(void *data)
 	return 0;
 }
 
-static void wl_iscan_timer(unsigned long data)
+static void brcmf_iscan_timer(unsigned long data)
 {
 	struct wl_iscan_ctrl *iscan = (struct wl_iscan_ctrl *)data;
 
 	if (iscan) {
 		iscan->timer_on = 0;
 		WL_SCAN("timer expired\n");
-		wl_wakeup_iscan(iscan);
+		brcmf_wakeup_iscan(iscan);
 	}
 }
 
-static s32 wl_invoke_iscan(struct wl_priv *wl)
+static s32 brcmf_invoke_iscan(struct wl_priv *wl)
 {
 	struct wl_iscan_ctrl *iscan = wl_to_iscan(wl);
 	int err = 0;
@@ -3299,7 +3299,7 @@ static s32 wl_invoke_iscan(struct wl_priv *wl)
 	if (wl->iscan_on && !iscan->tsk) {
 		iscan->state = WL_ISCAN_STATE_IDLE;
 		sema_init(&iscan->sync, 0);
-		iscan->tsk = kthread_run(wl_iscan_thread, iscan, "wl_iscan");
+		iscan->tsk = kthread_run(brcmf_iscan_thread, iscan, "wl_iscan");
 		if (IS_ERR(iscan->tsk)) {
 			WL_ERR("Could not create iscan thread\n");
 			iscan->tsk = NULL;
@@ -3310,17 +3310,17 @@ static s32 wl_invoke_iscan(struct wl_priv *wl)
 	return err;
 }
 
-static void wl_init_iscan_eloop(struct wl_iscan_eloop *el)
+static void brcmf_init_iscan_eloop(struct wl_iscan_eloop *el)
 {
 	memset(el, 0, sizeof(*el));
-	el->handler[BRCMF_SCAN_RESULTS_SUCCESS] = wl_iscan_done;
-	el->handler[BRCMF_SCAN_RESULTS_PARTIAL] = wl_iscan_inprogress;
-	el->handler[BRCMF_SCAN_RESULTS_PENDING] = wl_iscan_pending;
-	el->handler[BRCMF_SCAN_RESULTS_ABORTED] = wl_iscan_aborted;
-	el->handler[BRCMF_SCAN_RESULTS_NO_MEM] = wl_iscan_aborted;
+	el->handler[BRCMF_SCAN_RESULTS_SUCCESS] = brcmf_iscan_done;
+	el->handler[BRCMF_SCAN_RESULTS_PARTIAL] = brcmf_iscan_inprogress;
+	el->handler[BRCMF_SCAN_RESULTS_PENDING] = brcmf_iscan_pending;
+	el->handler[BRCMF_SCAN_RESULTS_ABORTED] = brcmf_iscan_aborted;
+	el->handler[BRCMF_SCAN_RESULTS_NO_MEM] = brcmf_iscan_aborted;
 }
 
-static s32 wl_init_iscan(struct wl_priv *wl)
+static s32 brcmf_init_iscan(struct wl_priv *wl)
 {
 	struct wl_iscan_ctrl *iscan = wl_to_iscan(wl);
 	int err = 0;
@@ -3328,13 +3328,13 @@ static s32 wl_init_iscan(struct wl_priv *wl)
 	if (wl->iscan_on) {
 		iscan->dev = wl_to_ndev(wl);
 		iscan->state = WL_ISCAN_STATE_IDLE;
-		wl_init_iscan_eloop(&iscan->el);
+		brcmf_init_iscan_eloop(&iscan->el);
 		iscan->timer_ms = WL_ISCAN_TIMER_INTERVAL_MS;
 		init_timer(&iscan->timer);
 		iscan->timer.data = (unsigned long) iscan;
-		iscan->timer.function = wl_iscan_timer;
+		iscan->timer.function = brcmf_iscan_timer;
 		sema_init(&iscan->sync, 0);
-		iscan->tsk = kthread_run(wl_iscan_thread, iscan, "wl_iscan");
+		iscan->tsk = kthread_run(brcmf_iscan_thread, iscan, "wl_iscan");
 		if (IS_ERR(iscan->tsk)) {
 			WL_ERR("Could not create iscan thread\n");
 			iscan->tsk = NULL;
@@ -3362,32 +3362,32 @@ static s32 wl_init_priv(struct wl_priv *wl)
 	wl->active_scan = true;	/* we do active scan for
 				 specific scan per default */
 	wl->dongle_up = false;	/* dongle is not up yet */
-	wl_init_eq(wl);
-	err = wl_init_priv_mem(wl);
+	brcmf_init_eq(wl);
+	err = brcmf_init_priv_mem(wl);
 	if (unlikely(err))
 		return err;
-	if (unlikely(wl_create_event_handler(wl)))
+	if (unlikely(brcmf_create_event_handler(wl)))
 		return -ENOMEM;
-	wl_init_eloop_handler(&wl->el);
+	brcmf_init_eloop_handler(&wl->el);
 	mutex_init(&wl->usr_sync);
-	err = wl_init_iscan(wl);
+	err = brcmf_init_iscan(wl);
 	if (unlikely(err))
 		return err;
-	wl_init_conf(wl->conf);
-	wl_init_prof(wl->profile);
-	wl_link_down(wl);
+	brcmf_init_conf(wl->conf);
+	brcmf_init_prof(wl->profile);
+	brcmf_link_down(wl);
 
 	return err;
 }
 
 static void wl_deinit_priv(struct wl_priv *wl)
 {
-	wl_destroy_event_handler(wl);
+	brcmf_destroy_event_handler(wl);
 	wl->dongle_up = false;	/* dongle down */
-	wl_flush_eq(wl);
-	wl_link_down(wl);
-	wl_term_iscan(wl);
-	wl_deinit_priv_mem(wl);
+	brcmf_flush_eq(wl);
+	brcmf_link_down(wl);
+	brcmf_term_iscan(wl);
+	brcmf_deinit_priv_mem(wl);
 }
 
 s32 wl_cfg80211_attach(struct net_device *ndev, void *data)
@@ -3407,11 +3407,11 @@ s32 wl_cfg80211_attach(struct net_device *ndev, void *data)
 		return -ENOMEM;
 	}
 	WL_INFO("func %p\n", wl_cfg80211_get_sdio_func());
-	wdev = wl_alloc_wdev(sizeof(struct wl_iface), &wl_cfg80211_get_sdio_func()->dev);
+	wdev = brcmf_alloc_wdev(sizeof(struct wl_iface), &wl_cfg80211_get_sdio_func()->dev);
 	if (IS_ERR(wdev))
 		return -ENOMEM;
 
-	wdev->iftype = wl_mode_to_nl80211_iftype(WL_MODE_BSS);
+	wdev->iftype = brcmf_mode_to_nl80211_iftype(WL_MODE_BSS);
 	wl = wdev_to_wl(wdev);
 	wl->wdev = wdev;
 	wl->pub = data;
@@ -3425,12 +3425,12 @@ s32 wl_cfg80211_attach(struct net_device *ndev, void *data)
 		WL_ERR("Failed to init iwm_priv (%d)\n", err);
 		goto cfg80211_attach_out;
 	}
-	wl_set_drvdata(wl_cfg80211_dev, ci);
+	brcmf_set_drvdata(wl_cfg80211_dev, ci);
 
 	return err;
 
 cfg80211_attach_out:
-	wl_free_wdev(wl);
+	brcmf_free_wdev(wl);
 	return err;
 }
 
@@ -3441,19 +3441,19 @@ void wl_cfg80211_detach(void)
 	wl = WL_PRIV_GET();
 
 	wl_deinit_priv(wl);
-	wl_free_wdev(wl);
-	wl_set_drvdata(wl_cfg80211_dev, NULL);
+	brcmf_free_wdev(wl);
+	brcmf_set_drvdata(wl_cfg80211_dev, NULL);
 	kfree(wl_cfg80211_dev);
 	wl_cfg80211_dev = NULL;
-	wl_clear_sdio_func();
+	brcmf_clear_sdio_func();
 }
 
-static void wl_wakeup_event(struct wl_priv *wl)
+static void brcmf_wakeup_event(struct wl_priv *wl)
 {
 	up(&wl->event_sync);
 }
 
-static s32 wl_event_handler(void *data)
+static s32 brcmf_event_handler(void *data)
 {
 	struct wl_priv *wl = (struct wl_priv *)data;
 	struct sched_param param = {.sched_priority = MAX_RT_PRIO - 1 };
@@ -3464,7 +3464,7 @@ static s32 wl_event_handler(void *data)
 	while (likely(!down_interruptible(&wl->event_sync))) {
 		if (kthread_should_stop())
 			break;
-		e = wl_deq_event(wl);
+		e = brcmf_deq_event(wl);
 		if (unlikely(!e)) {
 			WL_ERR("event queue empty...\n");
 			BUG();
@@ -3476,7 +3476,7 @@ static s32 wl_event_handler(void *data)
 		} else {
 			WL_INFO("Unknown Event (%d): ignoring\n", e->etype);
 		}
-		wl_put_event(e);
+		brcmf_put_event(e);
 	}
 	WL_INFO("was terminated\n");
 	return 0;
@@ -3489,43 +3489,43 @@ wl_cfg80211_event(struct net_device *ndev,
 	u32 event_type = be32_to_cpu(e->event_type);
 	struct wl_priv *wl = ndev_to_wl(ndev);
 
-	if (likely(!wl_enq_event(wl, event_type, e, data)))
-		wl_wakeup_event(wl);
+	if (likely(!brcmf_enq_event(wl, event_type, e, data)))
+		brcmf_wakeup_event(wl);
 }
 
-static void wl_init_eq(struct wl_priv *wl)
+static void brcmf_init_eq(struct wl_priv *wl)
 {
-	wl_init_eq_lock(wl);
+	brcmf_init_eq_lock(wl);
 	INIT_LIST_HEAD(&wl->eq_list);
 }
 
-static void wl_flush_eq(struct wl_priv *wl)
+static void brcmf_flush_eq(struct wl_priv *wl)
 {
 	struct wl_event_q *e;
 
-	wl_lock_eq(wl);
+	brcmf_lock_eq(wl);
 	while (!list_empty(&wl->eq_list)) {
 		e = list_first_entry(&wl->eq_list, struct wl_event_q, eq_list);
 		list_del(&e->eq_list);
 		kfree(e);
 	}
-	wl_unlock_eq(wl);
+	brcmf_unlock_eq(wl);
 }
 
 /*
 * retrieve first queued event from head
 */
 
-static struct wl_event_q *wl_deq_event(struct wl_priv *wl)
+static struct wl_event_q *brcmf_deq_event(struct wl_priv *wl)
 {
 	struct wl_event_q *e = NULL;
 
-	wl_lock_eq(wl);
+	brcmf_lock_eq(wl);
 	if (likely(!list_empty(&wl->eq_list))) {
 		e = list_first_entry(&wl->eq_list, struct wl_event_q, eq_list);
 		list_del(&e->eq_list);
 	}
-	wl_unlock_eq(wl);
+	brcmf_unlock_eq(wl);
 
 	return e;
 }
@@ -3535,7 +3535,7 @@ static struct wl_event_q *wl_deq_event(struct wl_priv *wl)
 */
 
 static s32
-wl_enq_event(struct wl_priv *wl, u32 event, const brcmf_event_msg_t *msg,
+brcmf_enq_event(struct wl_priv *wl, u32 event, const brcmf_event_msg_t *msg,
 	     void *data)
 {
 	struct wl_event_q *e;
@@ -3551,14 +3551,14 @@ wl_enq_event(struct wl_priv *wl, u32 event, const brcmf_event_msg_t *msg,
 	memcpy(&e->emsg, msg, sizeof(brcmf_event_msg_t));
 	if (data) {
 	}
-	wl_lock_eq(wl);
+	brcmf_lock_eq(wl);
 	list_add_tail(&e->eq_list, &wl->eq_list);
-	wl_unlock_eq(wl);
+	brcmf_unlock_eq(wl);
 
 	return err;
 }
 
-static void wl_put_event(struct wl_event_q *e)
+static void brcmf_put_event(struct wl_event_q *e)
 {
 	kfree(e);
 }
@@ -3568,7 +3568,7 @@ void wl_cfg80211_sdio_func(void *func)
 	cfg80211_sdio_func = (struct sdio_func *)func;
 }
 
-static void wl_clear_sdio_func(void)
+static void brcmf_clear_sdio_func(void)
 {
 	cfg80211_sdio_func = NULL;
 }
@@ -3578,7 +3578,7 @@ struct sdio_func *wl_cfg80211_get_sdio_func(void)
 	return cfg80211_sdio_func;
 }
 
-static s32 wl_dongle_mode(struct net_device *ndev, s32 iftype)
+static s32 brcmf_dongle_mode(struct net_device *ndev, s32 iftype)
 {
 	s32 infra = 0;
 	s32 err = 0;
@@ -3602,7 +3602,7 @@ static s32 wl_dongle_mode(struct net_device *ndev, s32 iftype)
 		return err;
 	}
 	infra = cpu_to_le32(infra);
-	err = wl_dev_ioctl(ndev, BRCMF_C_SET_INFRA, &infra, sizeof(infra));
+	err = brcmf_dev_ioctl(ndev, BRCMF_C_SET_INFRA, &infra, sizeof(infra));
 	if (unlikely(err)) {
 		WL_ERR("WLC_SET_INFRA error (%d)\n", err);
 		return err;
@@ -3611,7 +3611,7 @@ static s32 wl_dongle_mode(struct net_device *ndev, s32 iftype)
 	return 0;
 }
 
-static s32 wl_dongle_eventmsg(struct net_device *ndev)
+static s32 brcmf_dongle_eventmsg(struct net_device *ndev)
 {
 	/* Room for "event_msgs" + '\0' + bitvec */
 	s8 iovbuf[BRCMF_EVENTING_MASK_LEN + 12];
@@ -3623,7 +3623,7 @@ static s32 wl_dongle_eventmsg(struct net_device *ndev)
 	/* Setup event_msgs */
 	brcmu_mkiovar("event_msgs", eventmask, BRCMF_EVENTING_MASK_LEN, iovbuf,
 		    sizeof(iovbuf));
-	err = wl_dev_ioctl(ndev, BRCMF_C_GET_VAR, iovbuf, sizeof(iovbuf));
+	err = brcmf_dev_ioctl(ndev, BRCMF_C_GET_VAR, iovbuf, sizeof(iovbuf));
 	if (unlikely(err)) {
 		WL_ERR("Get event_msgs error (%d)\n", err);
 		goto dongle_eventmsg_out;
@@ -3652,7 +3652,7 @@ static s32 wl_dongle_eventmsg(struct net_device *ndev)
 
 	brcmu_mkiovar("event_msgs", eventmask, BRCMF_EVENTING_MASK_LEN, iovbuf,
 		    sizeof(iovbuf));
-	err = wl_dev_ioctl(ndev, BRCMF_C_SET_VAR, iovbuf, sizeof(iovbuf));
+	err = brcmf_dev_ioctl(ndev, BRCMF_C_SET_VAR, iovbuf, sizeof(iovbuf));
 	if (unlikely(err)) {
 		WL_ERR("Set event_msgs error (%d)\n", err);
 		goto dongle_eventmsg_out;
@@ -3664,7 +3664,7 @@ dongle_eventmsg_out:
 }
 
 static s32
-wl_dongle_roam(struct net_device *ndev, u32 roamvar, u32 bcn_timeout)
+brcmf_dongle_roam(struct net_device *ndev, u32 roamvar, u32 bcn_timeout)
 {
 	s8 iovbuf[32];
 	s32 roamtrigger[2];
@@ -3678,7 +3678,7 @@ wl_dongle_roam(struct net_device *ndev, u32 roamvar, u32 bcn_timeout)
 	if (roamvar) {
 		brcmu_mkiovar("bcn_timeout", (char *)&bcn_timeout,
 			sizeof(bcn_timeout), iovbuf, sizeof(iovbuf));
-		err = wl_dev_ioctl(ndev, BRCMF_C_SET_VAR,
+		err = brcmf_dev_ioctl(ndev, BRCMF_C_SET_VAR,
 				   iovbuf, sizeof(iovbuf));
 		if (unlikely(err)) {
 			WL_ERR("bcn_timeout error (%d)\n", err);
@@ -3693,7 +3693,7 @@ wl_dongle_roam(struct net_device *ndev, u32 roamvar, u32 bcn_timeout)
 	WL_INFO("Internal Roaming = %s\n", roamvar ? "Off" : "On");
 	brcmu_mkiovar("roam_off", (char *)&roamvar,
 				sizeof(roamvar), iovbuf, sizeof(iovbuf));
-	err = wl_dev_ioctl(ndev, BRCMF_C_SET_VAR, iovbuf, sizeof(iovbuf));
+	err = brcmf_dev_ioctl(ndev, BRCMF_C_SET_VAR, iovbuf, sizeof(iovbuf));
 	if (unlikely(err)) {
 		WL_ERR("roam_off error (%d)\n", err);
 		goto dongle_rom_out;
@@ -3701,7 +3701,7 @@ wl_dongle_roam(struct net_device *ndev, u32 roamvar, u32 bcn_timeout)
 
 	roamtrigger[0] = WL_ROAM_TRIGGER_LEVEL;
 	roamtrigger[1] = WLC_BAND_ALL;
-	err = wl_dev_ioctl(ndev, BRCMF_C_SET_ROAM_TRIGGER,
+	err = brcmf_dev_ioctl(ndev, BRCMF_C_SET_ROAM_TRIGGER,
 			(void *)roamtrigger, sizeof(roamtrigger));
 	if (unlikely(err)) {
 		WL_ERR("WLC_SET_ROAM_TRIGGER error (%d)\n", err);
@@ -3710,7 +3710,7 @@ wl_dongle_roam(struct net_device *ndev, u32 roamvar, u32 bcn_timeout)
 
 	roam_delta[0] = WL_ROAM_DELTA;
 	roam_delta[1] = WLC_BAND_ALL;
-	err = wl_dev_ioctl(ndev, BRCMF_C_SET_ROAM_DELTA,
+	err = brcmf_dev_ioctl(ndev, BRCMF_C_SET_ROAM_DELTA,
 				(void *)roam_delta, sizeof(roam_delta));
 	if (unlikely(err)) {
 		WL_ERR("WLC_SET_ROAM_DELTA error (%d)\n", err);
@@ -3722,12 +3722,12 @@ dongle_rom_out:
 }
 
 static s32
-wl_dongle_scantime(struct net_device *ndev, s32 scan_assoc_time,
+brcmf_dongle_scantime(struct net_device *ndev, s32 scan_assoc_time,
 		s32 scan_unassoc_time, s32 scan_passive_time)
 {
 	s32 err = 0;
 
-	err = wl_dev_ioctl(ndev, BRCMF_C_SET_SCAN_CHANNEL_TIME,
+	err = brcmf_dev_ioctl(ndev, BRCMF_C_SET_SCAN_CHANNEL_TIME,
 			   &scan_assoc_time, sizeof(scan_assoc_time));
 	if (err) {
 		if (err == -EOPNOTSUPP)
@@ -3736,7 +3736,7 @@ wl_dongle_scantime(struct net_device *ndev, s32 scan_assoc_time,
 			WL_ERR("Scan assoc time error (%d)\n", err);
 		goto dongle_scantime_out;
 	}
-	err = wl_dev_ioctl(ndev, BRCMF_C_SET_SCAN_UNASSOC_TIME,
+	err = brcmf_dev_ioctl(ndev, BRCMF_C_SET_SCAN_UNASSOC_TIME,
 			   &scan_unassoc_time, sizeof(scan_unassoc_time));
 	if (err) {
 		if (err == -EOPNOTSUPP)
@@ -3746,7 +3746,7 @@ wl_dongle_scantime(struct net_device *ndev, s32 scan_assoc_time,
 		goto dongle_scantime_out;
 	}
 
-	err = wl_dev_ioctl(ndev, BRCMF_C_SET_SCAN_PASSIVE_TIME,
+	err = brcmf_dev_ioctl(ndev, BRCMF_C_SET_SCAN_PASSIVE_TIME,
 			   &scan_passive_time, sizeof(scan_passive_time));
 	if (err) {
 		if (err == -EOPNOTSUPP)
@@ -3760,7 +3760,7 @@ dongle_scantime_out:
 	return err;
 }
 
-s32 wl_config_dongle(struct wl_priv *wl, bool need_lock)
+s32 brcmf_config_dongle(struct wl_priv *wl, bool need_lock)
 {
 	struct net_device *ndev;
 	struct wireless_dev *wdev;
@@ -3774,19 +3774,19 @@ s32 wl_config_dongle(struct wl_priv *wl, bool need_lock)
 	if (need_lock)
 		rtnl_lock();
 
-	wl_dongle_scantime(ndev, WL_SCAN_CHANNEL_TIME,
+	brcmf_dongle_scantime(ndev, WL_SCAN_CHANNEL_TIME,
 			WL_SCAN_UNASSOC_TIME, WL_SCAN_PASSIVE_TIME);
 
-	err = wl_dongle_eventmsg(ndev);
+	err = brcmf_dongle_eventmsg(ndev);
 	if (unlikely(err))
 		goto default_conf_out;
-	err = wl_dongle_roam(ndev, (wl->roam_on ? 0 : 1), WL_BEACON_TIMEOUT);
+	err = brcmf_dongle_roam(ndev, (wl->roam_on ? 0 : 1), WL_BEACON_TIMEOUT);
 	if (unlikely(err))
 		goto default_conf_out;
-	err = wl_dongle_mode(ndev, wdev->iftype);
+	err = brcmf_dongle_mode(ndev, wdev->iftype);
 	if (unlikely(err && err != -EINPROGRESS))
 		goto default_conf_out;
-	err = wl_dongle_probecap(wl);
+	err = brcmf_dongle_probecap(wl);
 	if (unlikely(err))
 		goto default_conf_out;
 
@@ -3809,7 +3809,7 @@ static s32 wl_update_wiphybands(struct wl_priv *wl)
 	s8 phy;
 	s32 err = 0;
 
-	err = wl_dev_ioctl(wl_to_ndev(wl), WLC_GET_PHYLIST, &phy_list,
+	err = brcmf_dev_ioctl(wl_to_ndev(wl), WLC_GET_PHYLIST, &phy_list,
 			sizeof(phy_list));
 	if (unlikely(err)) {
 		WL_ERR("error (%d)\n", err);
@@ -3826,24 +3826,24 @@ static s32 wl_update_wiphybands(struct wl_priv *wl)
 	return err;
 }
 
-static s32 __wl_cfg80211_up(struct wl_priv *wl)
+static s32 __brcmf_cfg80211_up(struct wl_priv *wl)
 {
 	s32 err = 0;
 
 	set_bit(WL_STATUS_READY, &wl->status);
 
-	wl_debugfs_add_netdev_params(wl);
+	brcmf_debugfs_add_netdev_params(wl);
 
-	err = wl_config_dongle(wl, false);
+	err = brcmf_config_dongle(wl, false);
 	if (unlikely(err))
 		return err;
 
-	wl_invoke_iscan(wl);
+	brcmf_invoke_iscan(wl);
 
 	return err;
 }
 
-static s32 __wl_cfg80211_down(struct wl_priv *wl)
+static s32 __brcmf_cfg80211_down(struct wl_priv *wl)
 {
 	/*
 	 * While going down, if associated with AP disassociate
@@ -3853,19 +3853,19 @@ static s32 __wl_cfg80211_down(struct wl_priv *wl)
 	     test_bit(WL_STATUS_CONNECTING, &wl->status)) &&
 	     test_bit(WL_STATUS_READY, &wl->status)) {
 		WL_INFO("Disassociating from AP");
-		wl_link_down(wl);
+		brcmf_link_down(wl);
 
 		/* Make sure WPA_Supplicant receives all the event
 		   generated due to DISASSOC call to the fw to keep
 		   the state fw and WPA_Supplicant state consistent
 		 */
 		rtnl_unlock();
-		wl_delay(500);
+		brcmf_delay(500);
 		rtnl_lock();
 	}
 
 	set_bit(WL_STATUS_SCAN_ABORTING, &wl->status);
-	wl_term_iscan(wl);
+	brcmf_term_iscan(wl);
 	if (wl->scan_request) {
 		cfg80211_scan_done(wl->scan_request, true);
 		/* May need to perform this to cover rmmod */
@@ -3876,7 +3876,7 @@ static s32 __wl_cfg80211_down(struct wl_priv *wl)
 	clear_bit(WL_STATUS_SCANNING, &wl->status);
 	clear_bit(WL_STATUS_SCAN_ABORTING, &wl->status);
 
-	wl_debugfs_remove_netdev(wl);
+	brcmf_debugfs_remove_netdev(wl);
 
 	return 0;
 }
@@ -3888,7 +3888,7 @@ s32 wl_cfg80211_up(void)
 
 	wl = WL_PRIV_GET();
 	mutex_lock(&wl->usr_sync);
-	err = __wl_cfg80211_up(wl);
+	err = __brcmf_cfg80211_up(wl);
 	mutex_unlock(&wl->usr_sync);
 
 	return err;
@@ -3901,18 +3901,18 @@ s32 wl_cfg80211_down(void)
 
 	wl = WL_PRIV_GET();
 	mutex_lock(&wl->usr_sync);
-	err = __wl_cfg80211_down(wl);
+	err = __brcmf_cfg80211_down(wl);
 	mutex_unlock(&wl->usr_sync);
 
 	return err;
 }
 
-static s32 wl_dongle_probecap(struct wl_priv *wl)
+static s32 brcmf_dongle_probecap(struct wl_priv *wl)
 {
 	return wl_update_wiphybands(wl);
 }
 
-static void *wl_read_prof(struct wl_priv *wl, s32 item)
+static void *brcmf_read_prof(struct wl_priv *wl, s32 item)
 {
 	switch (item) {
 	case WL_PROF_SEC:
@@ -3927,7 +3927,7 @@ static void *wl_read_prof(struct wl_priv *wl, s32 item)
 }
 
 static s32
-wl_update_prof(struct wl_priv *wl, const brcmf_event_msg_t *e, void *data,
+brcmf_update_prof(struct wl_priv *wl, const brcmf_event_msg_t *e, void *data,
 	       s32 item)
 {
 	s32 err = 0;
@@ -3965,12 +3965,12 @@ wl_update_prof(struct wl_priv *wl, const brcmf_event_msg_t *e, void *data,
 	return err;
 }
 
-static bool wl_is_ibssmode(struct wl_priv *wl)
+static bool brcmf_is_ibssmode(struct wl_priv *wl)
 {
 	return wl->conf->mode == WL_MODE_IBSS;
 }
 
-static __used s32 wl_add_ie(struct wl_priv *wl, u8 t, u8 l, u8 *v)
+static __used s32 brcmf_add_ie(struct wl_priv *wl, u8 t, u8 l, u8 *v)
 {
 	struct wl_ie *ie = wl_to_ie(wl);
 	s32 err = 0;
@@ -3987,7 +3987,7 @@ static __used s32 wl_add_ie(struct wl_priv *wl, u8 t, u8 l, u8 *v)
 	return err;
 }
 
-static void wl_link_down(struct wl_priv *wl)
+static void brcmf_link_down(struct wl_priv *wl)
 {
 	struct net_device *dev = NULL;
 	s32 err = 0;
@@ -3997,7 +3997,7 @@ static void wl_link_down(struct wl_priv *wl)
 	if (wl->link_up) {
 		dev = wl_to_ndev(wl);
 		WL_INFO("Call WLC_DISASSOC to stop excess roaming\n ");
-		err = wl_dev_ioctl(dev, BRCMF_C_DISASSOC, NULL, 0);
+		err = brcmf_dev_ioctl(dev, BRCMF_C_DISASSOC, NULL, 0);
 		if (unlikely(err))
 			WL_ERR("WLC_DISASSOC failed (%d)\n", err);
 		wl->link_up = false;
@@ -4005,22 +4005,22 @@ static void wl_link_down(struct wl_priv *wl)
 	WL_TRACE("Exit\n");
 }
 
-static void wl_lock_eq(struct wl_priv *wl)
+static void brcmf_lock_eq(struct wl_priv *wl)
 {
 	spin_lock_irq(&wl->eq_lock);
 }
 
-static void wl_unlock_eq(struct wl_priv *wl)
+static void brcmf_unlock_eq(struct wl_priv *wl)
 {
 	spin_unlock_irq(&wl->eq_lock);
 }
 
-static void wl_init_eq_lock(struct wl_priv *wl)
+static void brcmf_init_eq_lock(struct wl_priv *wl)
 {
 	spin_lock_init(&wl->eq_lock);
 }
 
-static void wl_delay(u32 ms)
+static void brcmf_delay(u32 ms)
 {
 	if (ms < 1000 / HZ) {
 		cond_resched();
@@ -4030,12 +4030,12 @@ static void wl_delay(u32 ms)
 	}
 }
 
-static void wl_set_drvdata(struct wl_dev *dev, void *data)
+static void brcmf_set_drvdata(struct wl_dev *dev, void *data)
 {
 	dev->driver_data = data;
 }
 
-static void *wl_get_drvdata(struct wl_dev *dev)
+static void *brcmf_get_drvdata(struct wl_dev *dev)
 {
 	void *data = NULL;
 
@@ -4044,13 +4044,13 @@ static void *wl_get_drvdata(struct wl_dev *dev)
 	return data;
 }
 
-static void wl_set_mpc(struct net_device *ndev, int mpc)
+static void brcmf_set_mpc(struct net_device *ndev, int mpc)
 {
 	s32 err = 0;
 	struct wl_priv *wl = ndev_to_wl(ndev);
 
 	if (test_bit(WL_STATUS_READY, &wl->status)) {
-		err = wl_dev_intvar_set(ndev, "mpc", mpc);
+		err = brcmf_dev_intvar_set(ndev, "mpc", mpc);
 		if (unlikely(err)) {
 			WL_ERR("fail to set mpc\n");
 			return;
@@ -4059,7 +4059,7 @@ static void wl_set_mpc(struct net_device *ndev, int mpc)
 	}
 }
 
-static int wl_debugfs_add_netdev_params(struct wl_priv *wl)
+static int brcmf_debugfs_add_netdev_params(struct wl_priv *wl)
 {
 	char buf[10+IFNAMSIZ];
 	struct dentry *fd;
@@ -4086,7 +4086,7 @@ err_out:
 	return err;
 }
 
-static void wl_debugfs_remove_netdev(struct wl_priv *wl)
+static void brcmf_debugfs_remove_netdev(struct wl_priv *wl)
 {
 	debugfs_remove_recursive(wl->debugfsdir);
 	wl->debugfsdir = NULL;
-- 
1.7.1



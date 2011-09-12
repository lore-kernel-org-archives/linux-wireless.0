Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:3817 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754379Ab1ILKPY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Sep 2011 06:15:24 -0400
From: "Roland Vossen" <rvossen@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Subject: [PATCH 20/20] staging: brcm80211: remove static function
 declaration in wl_cfg80211
Date: Mon, 12 Sep 2011 12:15:04 +0200
Message-ID: <1315822504-24210-21-git-send-email-rvossen@broadcom.com> (sfid-20110912_121540_050325_CE083BB6)
In-Reply-To: <1315822504-24210-1-git-send-email-rvossen@broadcom.com>
References: <1315822504-24210-1-git-send-email-rvossen@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Franky Lin <frankyl@broadcom.com>

Reshuffle function order in wl_cfg80211 of fullmac to get rid of
static function declaration

Reported-by: Johannes Berg <johannes@sipsolutions.net>
Reviewed-by: Arend van Spriel <arend@broadcom.com>
Reviewed-by: Roland Vossen <rvossen@broadcom.com>
Signed-off-by: Roland Vossen <rvossen@broadcom.com>
---
 drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c | 2484 ++++++++++------------
 1 files changed, 1109 insertions(+), 1375 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c b/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c
index d33d2cd..198f0cc 100644
--- a/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c
+++ b/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c
@@ -40,269 +40,19 @@ static const u8 ether_bcast[ETH_ALEN] = {255, 255, 255, 255, 255, 255};
 
 static u32 brcmf_dbg_level = WL_DBG_ERR;
 
-/*
-** cfg80211_ops api/callback list
-*/
-static s32 brcmf_cfg80211_change_iface(struct wiphy *wiphy,
-				       struct net_device *ndev,
-				       enum nl80211_iftype type, u32 *flags,
-				       struct vif_params *params);
-static s32 __brcmf_cfg80211_scan(struct wiphy *wiphy, struct net_device *ndev,
-				 struct cfg80211_scan_request *request,
-				 struct cfg80211_ssid *this_ssid);
-static s32 brcmf_cfg80211_scan(struct wiphy *wiphy, struct net_device *ndev,
-			       struct cfg80211_scan_request *request);
-static s32 brcmf_cfg80211_set_wiphy_params(struct wiphy *wiphy, u32 changed);
-static s32 brcmf_cfg80211_join_ibss(struct wiphy *wiphy, struct net_device *dev,
-				    struct cfg80211_ibss_params *params);
-static s32 brcmf_cfg80211_leave_ibss(struct wiphy *wiphy,
-				     struct net_device *dev);
-static s32 brcmf_cfg80211_get_station(struct wiphy *wiphy,
-				      struct net_device *dev, u8 *mac,
-				      struct station_info *sinfo);
-static s32 brcmf_cfg80211_set_power_mgmt(struct wiphy *wiphy,
-					 struct net_device *dev, bool enabled,
-					 s32 timeout);
-static s32 brcmf_cfg80211_set_bitrate_mask(struct wiphy *wiphy,
-					   struct net_device *dev,
-					   const u8 *addr,
-					   const struct cfg80211_bitrate_mask
-					   *mask);
-static int brcmf_cfg80211_connect(struct wiphy *wiphy, struct net_device *dev,
-				  struct cfg80211_connect_params *sme);
-static s32 brcmf_cfg80211_disconnect(struct wiphy *wiphy,
-				     struct net_device *dev,
-				     u16 reason_code);
-static s32 brcmf_cfg80211_set_tx_power(struct wiphy *wiphy,
-				      enum nl80211_tx_power_setting type,
-				      s32 dbm);
-static s32 brcmf_cfg80211_get_tx_power(struct wiphy *wiphy, s32 *dbm);
-static s32 brcmf_cfg80211_config_default_key(struct wiphy *wiphy,
-					  struct net_device *dev, u8 key_idx,
-					  bool unicast, bool multicast);
-static s32 brcmf_cfg80211_add_key(struct wiphy *wiphy, struct net_device *dev,
-				 u8 key_idx, bool pairwise, const u8 *mac_addr,
-				 struct key_params *params);
-static s32 brcmf_cfg80211_del_key(struct wiphy *wiphy, struct net_device *dev,
-				 u8 key_idx, bool pairwise, const u8 *mac_addr);
-static s32 brcmf_cfg80211_get_key(struct wiphy *wiphy, struct net_device *dev,
-				 u8 key_idx, bool pairwise, const u8 *mac_addr,
-				 void *cookie, void (*callback) (void *cookie,
-								 struct
-								 key_params *
-								 params));
-static s32 brcmf_cfg80211_config_default_mgmt_key(struct wiphy *wiphy,
-						 struct net_device *dev,
-						 u8 key_idx);
-static s32 brcmf_cfg80211_resume(struct wiphy *wiphy);
-static s32 brcmf_cfg80211_suspend(struct wiphy *wiphy,
-				 struct cfg80211_wowlan *wow);
-static s32 brcmf_cfg80211_set_pmksa(struct wiphy *wiphy, struct net_device *dev,
-				   struct cfg80211_pmksa *pmksa);
-static s32 brcmf_cfg80211_del_pmksa(struct wiphy *wiphy, struct net_device *dev,
-				   struct cfg80211_pmksa *pmksa);
-static s32 brcmf_cfg80211_flush_pmksa(struct wiphy *wiphy,
-				     struct net_device *dev);
-/*
-** event & event Q handlers for cfg80211 interfaces
-*/
-static s32 brcmf_create_event_handler(struct brcmf_cfg80211_priv *cfg_priv);
-static void brcmf_destroy_event_handler(struct brcmf_cfg80211_priv *cfg_priv);
-static s32 brcmf_event_handler(void *data);
-static void brcmf_init_eq(struct brcmf_cfg80211_priv *cfg_priv);
-static void brcmf_flush_eq(struct brcmf_cfg80211_priv *cfg_priv);
-static void brcmf_lock_eq(struct brcmf_cfg80211_priv *cfg_priv);
-static void brcmf_unlock_eq(struct brcmf_cfg80211_priv *cfg_priv);
-static void brcmf_init_eq_lock(struct brcmf_cfg80211_priv *cfg_priv);
-static void brcmf_init_eloop_handler(struct brcmf_cfg80211_event_loop *el);
-static struct brcmf_cfg80211_event_q *
-brcmf_deq_event(struct brcmf_cfg80211_priv *cfg_priv);
-static s32 brcmf_enq_event(struct brcmf_cfg80211_priv *cfg_priv, u32 type,
-			  const struct brcmf_event_msg *msg);
-static void brcmf_put_event(struct brcmf_cfg80211_event_q *e);
-static void brcmf_wakeup_event(struct brcmf_cfg80211_priv *cfg_priv);
-static s32 brcmf_notify_connect_status(struct brcmf_cfg80211_priv *cfg_priv,
-				       struct net_device *ndev,
-				       const struct brcmf_event_msg *e,
-				       void *data);
-static s32 brcmf_notify_roaming_status(struct brcmf_cfg80211_priv *cfg_priv,
-				       struct net_device *ndev,
-				       const struct brcmf_event_msg *e,
-				       void *data);
-static s32 brcmf_notify_scan_status(struct brcmf_cfg80211_priv *cfg_priv,
-				    struct net_device *ndev,
-				    const struct brcmf_event_msg *e,
-				    void *data);
-static s32 brcmf_bss_connect_done(struct brcmf_cfg80211_priv *cfg_priv,
-				  struct net_device *ndev,
-				  const struct brcmf_event_msg *e,
-				  bool completed);
-static s32 brcmf_bss_roaming_done(struct brcmf_cfg80211_priv *cfg_priv,
-				  struct net_device *ndev,
-				  const struct brcmf_event_msg *e);
-static s32 brcmf_notify_mic_status(struct brcmf_cfg80211_priv *cfg_priv,
-				   struct net_device *ndev,
-				   const struct brcmf_event_msg *e, void *data);
-
-/*
-** ioctl utilites
-*/
-static s32 brcmf_dev_bufvar_get(struct net_device *dev, s8 *name, s8 *buf,
-			       s32 buf_len);
-static __used s32 brcmf_dev_bufvar_set(struct net_device *dev, s8 *name,
-				      s8 *buf, s32 len);
-static s32 brcmf_dev_intvar_set(struct net_device *dev, s8 *name, s32 val);
-static s32 brcmf_dev_intvar_get(struct net_device *dev, s8 *name,
-			       s32 *retval);
-static s32 brcmf_dev_ioctl(struct net_device *dev, u32 cmd, void *arg,
-			  u32 len);
-
-/*
-** cfg80211 set_wiphy_params utilities
-*/
-static s32 brcmf_set_frag(struct net_device *dev, u32 frag_threshold);
-static s32 brcmf_set_rts(struct net_device *dev, u32 frag_threshold);
-static s32 brcmf_set_retry(struct net_device *dev, u32 retry, bool l);
-
-/*
-** wl profile utilities
-*/
-static s32 brcmf_update_prof(struct brcmf_cfg80211_priv *cfg_priv,
-			     const struct brcmf_event_msg *e,
-			     void *data, s32 item);
-static void *brcmf_read_prof(struct brcmf_cfg80211_priv *cfg_priv, s32 item);
-static void brcmf_init_prof(struct brcmf_cfg80211_profile *prof);
-
-/*
-** cfg80211 connect utilites
-*/
-static s32 brcmf_set_wpa_version(struct net_device *dev,
-			struct cfg80211_connect_params *sme);
-static s32 brcmf_set_auth_type(struct net_device *dev,
-			struct cfg80211_connect_params *sme);
-static s32 brcmf_set_set_cipher(struct net_device *dev,
-			struct cfg80211_connect_params *sme);
-static s32 brcmf_set_key_mgmt(struct net_device *dev,
-			struct cfg80211_connect_params *sme);
-static s32 brcmf_set_set_sharedkey(struct net_device *dev,
-			struct cfg80211_connect_params *sme);
-static s32 brcmf_get_assoc_ies(struct brcmf_cfg80211_priv *cfg_priv);
-static void brcmf_clear_assoc_ies(struct brcmf_cfg80211_priv *cfg_priv);
-static void brcmf_ch_to_chanspec(int ch,
-	struct brcmf_join_params *join_params, size_t *join_params_size);
-
-/*
-** information element utilities
-*/
-static __used s32 brcmf_add_ie(struct brcmf_cfg80211_priv *cfg_priv,
-			       u8 t, u8 l, u8 *v);
-static s32 brcmf_mode_to_nl80211_iftype(s32 mode);
-static struct wireless_dev *brcmf_alloc_wdev(s32 sizeof_iface,
-			struct device *dev);
-static void brcmf_free_wdev(struct brcmf_cfg80211_priv *cfg_priv);
-static s32 brcmf_inform_bss(struct brcmf_cfg80211_priv *cfg_priv);
-static s32 brcmf_inform_single_bss(struct brcmf_cfg80211_priv *cfg_priv,
-				   struct brcmf_bss_info *bi);
-static s32 brcmf_update_bss_info(struct brcmf_cfg80211_priv *cfg_priv);
-static s32 brcmf_add_keyext(struct wiphy *wiphy, struct net_device *dev,
-			u8 key_idx, const u8 *mac_addr,
-			struct key_params *params);
-
-/*
-** key indianess swap utilities
-*/
-static void convert_key_from_CPU(struct brcmf_wsec_key *key);
-static void convert_key_to_CPU(struct brcmf_wsec_key *key);
-
-/*
-** brcmf_cfg80211_priv memory init/deinit utilities
-*/
-static s32 brcmf_init_priv_mem(struct brcmf_cfg80211_priv *cfg_priv);
-static void brcmf_deinit_priv_mem(struct brcmf_cfg80211_priv *cfg_priv);
-
-static void brcmf_delay(u32 ms);
-
-/*
-** store/restore cfg80211 instance data
-*/
-static void brcmf_set_drvdata(struct brcmf_cfg80211_dev *dev, void *data);
-static void *brcmf_get_drvdata(struct brcmf_cfg80211_dev *dev);
-
-/*
-** ibss mode utilities
-*/
-static bool brcmf_is_ibssmode(struct brcmf_cfg80211_priv *cfg_priv);
-
-/*
-** dongle up/down , default configuration utilities
-*/
-static bool brcmf_is_linkdown(struct brcmf_cfg80211_priv *cfg_priv,
-			      const struct brcmf_event_msg *e);
-static bool brcmf_is_linkup(struct brcmf_cfg80211_priv *cfg_priv,
-			    const struct brcmf_event_msg *e);
-static bool brcmf_is_nonetwork(struct brcmf_cfg80211_priv *cfg_priv,
-			       const struct brcmf_event_msg *e);
-static void brcmf_link_down(struct brcmf_cfg80211_priv *cfg_priv);
-static s32 brcmf_dongle_mode(struct net_device *ndev, s32 iftype);
-static s32 __brcmf_cfg80211_up(struct brcmf_cfg80211_priv *cfg_priv);
-static s32 __brcmf_cfg80211_down(struct brcmf_cfg80211_priv *cfg_priv);
-static s32 brcmf_dongle_probecap(struct brcmf_cfg80211_priv *cfg_priv);
-static void brcmf_init_conf(struct brcmf_cfg80211_conf *conf);
-
-/*
-** dongle configuration utilities
-*/
-static s32 brcmf_dongle_eventmsg(struct net_device *ndev);
-static s32 brcmf_dongle_scantime(struct net_device *ndev, s32 scan_assoc_time,
-				 s32 scan_unassoc_time, s32 scan_passive_time);
-static s32 brcmf_config_dongle(struct brcmf_cfg80211_priv *cfg_priv,
-			       bool need_lock);
-static s32 brcmf_dongle_roam(struct net_device *ndev, u32 roamvar,
-			    u32 bcn_timeout);
-
-/*
-** iscan handler
-*/
-static void brcmf_iscan_timer(unsigned long data);
-static void brcmf_term_iscan(struct brcmf_cfg80211_priv *cfg_priv);
-static s32 brcmf_init_iscan(struct brcmf_cfg80211_priv *cfg_priv);
-static s32 brcmf_dev_iovar_setbuf(struct net_device *dev, s8 *iovar,
-				 void *param, s32 paramlen, void *bufptr,
-				 s32 buflen);
-static s32 brcmf_dev_iovar_getbuf(struct net_device *dev, s8 *iovar,
-				 void *param, s32 paramlen, void *bufptr,
-				 s32 buflen);
-static s32 brcmf_run_iscan(struct brcmf_cfg80211_iscan_ctrl *iscan,
-			   struct brcmf_ssid *ssid, u16 action);
-static s32 brcmf_do_iscan(struct brcmf_cfg80211_priv *cfg_priv);
-static s32 brcmf_wakeup_iscan(struct brcmf_cfg80211_iscan_ctrl *iscan);
-static s32 brcmf_invoke_iscan(struct brcmf_cfg80211_priv *cfg_priv);
-static s32 brcmf_get_iscan_results(struct brcmf_cfg80211_iscan_ctrl *iscan,
-				   u32 *status,
-				   struct brcmf_scan_results **bss_list);
-static void brcmf_notify_iscan_complete(struct brcmf_cfg80211_iscan_ctrl *iscan,
-					bool aborted);
-static void brcmf_init_iscan_eloop(struct brcmf_cfg80211_iscan_eloop *el);
-static s32 brcmf_iscan_done(struct brcmf_cfg80211_priv *cfg_priv);
-static s32 brcmf_iscan_pending(struct brcmf_cfg80211_priv *cfg_priv);
-static s32 brcmf_iscan_inprogress(struct brcmf_cfg80211_priv *cfg_priv);
-static s32 brcmf_iscan_aborted(struct brcmf_cfg80211_priv *cfg_priv);
-
-/*
-* update pmklist to dongle
-*/
-static __used s32 brcmf_update_pmklist(struct net_device *dev,
-				       struct brcmf_cfg80211_pmk_list *pmk_list,
-				       s32 err);
+static void brcmf_set_drvdata(struct brcmf_cfg80211_dev *dev, void *data)
+{
+	dev->driver_data = data;
+}
 
-static void brcmf_set_mpc(struct net_device *ndev, int mpc);
+static void *brcmf_get_drvdata(struct brcmf_cfg80211_dev *dev)
+{
+	void *data = NULL;
 
-/*
-* debufs support
-*/
-static int
-brcmf_debugfs_add_netdev_params(struct brcmf_cfg80211_priv *cfg_priv);
-static void brcmf_debugfs_remove_netdev(struct brcmf_cfg80211_priv *cfg_priv);
+	if (dev)
+		data = dev->driver_data;
+	return data;
+}
 
 static
 struct brcmf_cfg80211_priv *brcmf_priv_get(struct brcmf_cfg80211_dev *cfg_dev)
@@ -594,6 +344,63 @@ done:
 	return err;
 }
 
+static s32 brcmf_dev_intvar_set(struct net_device *dev, s8 *name, s32 val)
+{
+	s8 buf[BRCMF_C_IOCTL_SMLEN];
+	u32 len;
+	s32 err = 0;
+
+	val = cpu_to_le32(val);
+	len = brcmu_mkiovar(name, (char *)(&val), sizeof(val), buf,
+			    sizeof(buf));
+	BUG_ON(!len);
+
+	err = brcmf_dev_ioctl(dev, BRCMF_C_SET_VAR, buf, len);
+	if (unlikely(err))
+		WL_ERR("error (%d)\n", err);
+
+	return err;
+}
+
+static s32
+brcmf_dev_intvar_get(struct net_device *dev, s8 *name, s32 *retval)
+{
+	union {
+		s8 buf[BRCMF_C_IOCTL_SMLEN];
+		s32 val;
+	} var;
+	u32 len;
+	u32 data_null;
+	s32 err = 0;
+
+	len =
+	    brcmu_mkiovar(name, (char *)(&data_null), 0, (char *)(&var),
+			sizeof(var.buf));
+	BUG_ON(!len);
+	err = brcmf_dev_ioctl(dev, BRCMF_C_GET_VAR, &var, len);
+	if (unlikely(err))
+		WL_ERR("error (%d)\n", err);
+
+	*retval = le32_to_cpu(var.val);
+
+	return err;
+}
+
+static void brcmf_set_mpc(struct net_device *ndev, int mpc)
+{
+	s32 err = 0;
+	struct brcmf_cfg80211_priv *cfg_priv = ndev_to_cfg(ndev);
+
+	if (test_bit(WL_STATUS_READY, &cfg_priv->status)) {
+		err = brcmf_dev_intvar_set(ndev, "mpc", mpc);
+		if (unlikely(err)) {
+			WL_ERR("fail to set mpc\n");
+			return;
+		}
+		WL_INFO("MPC : %d\n", mpc);
+	}
+}
+
 static void wl_iscan_prep(struct brcmf_scan_params *params,
 			  struct brcmf_ssid *ssid)
 {
@@ -820,48 +627,6 @@ brcmf_cfg80211_scan(struct wiphy *wiphy, struct net_device *ndev,
 	return err;
 }
 
-static s32 brcmf_dev_intvar_set(struct net_device *dev, s8 *name, s32 val)
-{
-	s8 buf[BRCMF_C_IOCTL_SMLEN];
-	u32 len;
-	s32 err = 0;
-
-	val = cpu_to_le32(val);
-	len = brcmu_mkiovar(name, (char *)(&val), sizeof(val), buf,
-			    sizeof(buf));
-	BUG_ON(!len);
-
-	err = brcmf_dev_ioctl(dev, BRCMF_C_SET_VAR, buf, len);
-	if (unlikely(err))
-		WL_ERR("error (%d)\n", err);
-
-	return err;
-}
-
-static s32
-brcmf_dev_intvar_get(struct net_device *dev, s8 *name, s32 *retval)
-{
-	union {
-		s8 buf[BRCMF_C_IOCTL_SMLEN];
-		s32 val;
-	} var;
-	u32 len;
-	u32 data_null;
-	s32 err = 0;
-
-	len =
-	    brcmu_mkiovar(name, (char *)(&data_null), 0, (char *)(&var),
-			sizeof(var.buf));
-	BUG_ON(!len);
-	err = brcmf_dev_ioctl(dev, BRCMF_C_GET_VAR, &var, len);
-	if (unlikely(err))
-		WL_ERR("error (%d)\n", err);
-
-	*retval = le32_to_cpu(var.val);
-
-	return err;
-}
-
 static s32 brcmf_set_rts(struct net_device *dev, u32 rts_threshold)
 {
 	s32 err = 0;
@@ -942,46 +707,158 @@ done:
 	return err;
 }
 
+static void *brcmf_read_prof(struct brcmf_cfg80211_priv *cfg_priv, s32 item)
+{
+	switch (item) {
+	case WL_PROF_SEC:
+		return &cfg_priv->profile->sec;
+	case WL_PROF_BSSID:
+		return &cfg_priv->profile->bssid;
+	case WL_PROF_SSID:
+		return &cfg_priv->profile->ssid;
+	}
+	WL_ERR("invalid item (%d)\n", item);
+	return NULL;
+}
+
 static s32
-brcmf_cfg80211_join_ibss(struct wiphy *wiphy, struct net_device *dev,
-		      struct cfg80211_ibss_params *params)
+brcmf_update_prof(struct brcmf_cfg80211_priv *cfg_priv,
+		  const struct brcmf_event_msg *e, void *data, s32 item)
 {
-	struct brcmf_cfg80211_priv *cfg_priv = wiphy_to_cfg(wiphy);
-	struct brcmf_join_params join_params;
-	size_t join_params_size = 0;
 	s32 err = 0;
-	s32 wsec = 0;
-	s32 bcnprd;
-
-	WL_TRACE("Enter\n");
-	if (!check_sys_up(wiphy))
-		return -EIO;
+	struct brcmf_ssid *ssid;
 
-	if (params->ssid)
-		WL_CONN("SSID: %s\n", params->ssid);
-	else {
-		WL_CONN("SSID: NULL, Not supported\n");
-		return -EOPNOTSUPP;
+	switch (item) {
+	case WL_PROF_SSID:
+		ssid = (struct brcmf_ssid *) data;
+		memset(cfg_priv->profile->ssid.SSID, 0,
+		       sizeof(cfg_priv->profile->ssid.SSID));
+		memcpy(cfg_priv->profile->ssid.SSID,
+		       ssid->SSID, ssid->SSID_len);
+		cfg_priv->profile->ssid.SSID_len = ssid->SSID_len;
+		break;
+	case WL_PROF_BSSID:
+		if (data)
+			memcpy(cfg_priv->profile->bssid, data, ETH_ALEN);
+		else
+			memset(cfg_priv->profile->bssid, 0, ETH_ALEN);
+		break;
+	case WL_PROF_SEC:
+		memcpy(&cfg_priv->profile->sec, data,
+		       sizeof(cfg_priv->profile->sec));
+		break;
+	case WL_PROF_BEACONINT:
+		cfg_priv->profile->beacon_interval = *(u16 *)data;
+		break;
+	case WL_PROF_DTIMPERIOD:
+		cfg_priv->profile->dtim_period = *(u8 *)data;
+		break;
+	default:
+		WL_ERR("unsupported item (%d)\n", item);
+		err = -EOPNOTSUPP;
+		break;
 	}
 
-	set_bit(WL_STATUS_CONNECTING, &cfg_priv->status);
+	return err;
+}
 
-	if (params->bssid)
-		WL_CONN("BSSID: %02X %02X %02X %02X %02X %02X\n",
-		params->bssid[0], params->bssid[1], params->bssid[2],
-		params->bssid[3], params->bssid[4], params->bssid[5]);
-	else
-		WL_CONN("No BSSID specified\n");
+static void brcmf_init_prof(struct brcmf_cfg80211_profile *prof)
+{
+	memset(prof, 0, sizeof(*prof));
+}
 
-	if (params->channel)
-		WL_CONN("channel: %d\n", params->channel->center_freq);
-	else
-		WL_CONN("no channel specified\n");
+static void brcmf_ch_to_chanspec(int ch, struct brcmf_join_params *join_params,
+	size_t *join_params_size)
+{
+	u16 chanspec = 0;
 
-	if (params->channel_fixed)
-		WL_CONN("fixed channel required\n");
-	else
-		WL_CONN("no fixed channel required\n");
+	if (ch != 0) {
+		join_params->params.chanspec_num = 1;
+		join_params->params.chanspec_list[0] = ch;
+
+		if (join_params->params.chanspec_list[0] <= CH_MAX_2G_CHANNEL)
+			chanspec |= WL_CHANSPEC_BAND_2G;
+		else
+			chanspec |= WL_CHANSPEC_BAND_5G;
+
+		chanspec |= WL_CHANSPEC_BW_20;
+		chanspec |= WL_CHANSPEC_CTL_SB_NONE;
+
+		*join_params_size += BRCMF_ASSOC_PARAMS_FIXED_SIZE +
+			join_params->params.chanspec_num * sizeof(u16);
+
+		join_params->params.chanspec_list[0] &= WL_CHANSPEC_CHAN_MASK;
+		join_params->params.chanspec_list[0] |= chanspec;
+		join_params->params.chanspec_list[0] =
+		cpu_to_le16(join_params->params.chanspec_list[0]);
+
+		join_params->params.chanspec_num =
+			cpu_to_le32(join_params->params.chanspec_num);
+
+		WL_CONN("join_params->params.chanspec_list[0]= %#X,"
+			"channel %d, chanspec %#X\n",
+		       join_params->params.chanspec_list[0], ch, chanspec);
+	}
+}
+
+static void brcmf_link_down(struct brcmf_cfg80211_priv *cfg_priv)
+{
+	struct net_device *dev = NULL;
+	s32 err = 0;
+
+	WL_TRACE("Enter\n");
+
+	if (cfg_priv->link_up) {
+		dev = cfg_to_ndev(cfg_priv);
+		WL_INFO("Call WLC_DISASSOC to stop excess roaming\n ");
+		err = brcmf_dev_ioctl(dev, BRCMF_C_DISASSOC, NULL, 0);
+		if (unlikely(err))
+			WL_ERR("WLC_DISASSOC failed (%d)\n", err);
+		cfg_priv->link_up = false;
+	}
+	WL_TRACE("Exit\n");
+}
+
+static s32
+brcmf_cfg80211_join_ibss(struct wiphy *wiphy, struct net_device *dev,
+		      struct cfg80211_ibss_params *params)
+{
+	struct brcmf_cfg80211_priv *cfg_priv = wiphy_to_cfg(wiphy);
+	struct brcmf_join_params join_params;
+	size_t join_params_size = 0;
+	s32 err = 0;
+	s32 wsec = 0;
+	s32 bcnprd;
+
+	WL_TRACE("Enter\n");
+	if (!check_sys_up(wiphy))
+		return -EIO;
+
+	if (params->ssid)
+		WL_CONN("SSID: %s\n", params->ssid);
+	else {
+		WL_CONN("SSID: NULL, Not supported\n");
+		return -EOPNOTSUPP;
+	}
+
+	set_bit(WL_STATUS_CONNECTING, &cfg_priv->status);
+
+	if (params->bssid)
+		WL_CONN("BSSID: %02X %02X %02X %02X %02X %02X\n",
+		params->bssid[0], params->bssid[1], params->bssid[2],
+		params->bssid[3], params->bssid[4], params->bssid[5]);
+	else
+		WL_CONN("No BSSID specified\n");
+
+	if (params->channel)
+		WL_CONN("channel: %d\n", params->channel->center_freq);
+	else
+		WL_CONN("no channel specified\n");
+
+	if (params->channel_fixed)
+		WL_CONN("fixed channel required\n");
+	else
+		WL_CONN("no fixed channel required\n");
 
 	if (params->ie && params->ie_len)
 		WL_CONN("ie len: %d\n", params->ie_len);
@@ -2071,122 +1948,615 @@ done:
 	return err;
 }
 
-static s32 brcmf_cfg80211_resume(struct wiphy *wiphy)
+static s32 brcmf_inform_single_bss(struct brcmf_cfg80211_priv *cfg_priv,
+				   struct brcmf_bss_info *bi)
 {
-	struct brcmf_cfg80211_priv *cfg_priv = wiphy_to_cfg(wiphy);
-
-	/*
-	 * Check for WL_STATUS_READY before any function call which
-	 * could result is bus access. Don't block the resume for
-	 * any driver error conditions
-	 */
-	WL_TRACE("Enter\n");
-
-	if (test_bit(WL_STATUS_READY, &cfg_priv->status))
-		brcmf_invoke_iscan(wiphy_to_cfg(wiphy));
-
-	WL_TRACE("Exit\n");
-	return 0;
-}
+	struct wiphy *wiphy = cfg_to_wiphy(cfg_priv);
+	struct ieee80211_channel *notify_channel;
+	struct cfg80211_bss *bss;
+	struct ieee80211_supported_band *band;
+	s32 err = 0;
+	u16 channel;
+	u32 freq;
+	u64 notify_timestamp;
+	u16 notify_capability;
+	u16 notify_interval;
+	u8 *notify_ie;
+	size_t notify_ielen;
+	s32 notify_signal;
 
-static s32 brcmf_cfg80211_suspend(struct wiphy *wiphy,
-				  struct cfg80211_wowlan *wow)
-{
-	struct brcmf_cfg80211_priv *cfg_priv = wiphy_to_cfg(wiphy);
-	struct net_device *ndev = cfg_to_ndev(cfg_priv);
+	if (unlikely(le32_to_cpu(bi->length) > WL_BSS_INFO_MAX)) {
+		WL_ERR("Bss info is larger than buffer. Discarding\n");
+		return 0;
+	}
 
-	WL_TRACE("Enter\n");
+	channel = bi->ctl_ch ? bi->ctl_ch :
+				CHSPEC_CHANNEL(le16_to_cpu(bi->chanspec));
 
-	/*
-	 * Check for WL_STATUS_READY before any function call which
-	 * could result is bus access. Don't block the suspend for
-	 * any driver error conditions
-	 */
+	if (channel <= CH_MAX_2G_CHANNEL)
+		band = wiphy->bands[IEEE80211_BAND_2GHZ];
+	else
+		band = wiphy->bands[IEEE80211_BAND_5GHZ];
 
-	/*
-	 * While going to suspend if associated with AP disassociate
-	 * from AP to save power while system is in suspended state
-	 */
-	if ((test_bit(WL_STATUS_CONNECTED, &cfg_priv->status) ||
-	     test_bit(WL_STATUS_CONNECTING, &cfg_priv->status)) &&
-	     test_bit(WL_STATUS_READY, &cfg_priv->status)) {
-		WL_INFO("Disassociating from AP"
-			" while entering suspend state\n");
-		brcmf_link_down(cfg_priv);
+	freq = ieee80211_channel_to_frequency(channel, band->band);
+	notify_channel = ieee80211_get_channel(wiphy, freq);
 
-		/*
-		 * Make sure WPA_Supplicant receives all the event
-		 * generated due to DISASSOC call to the fw to keep
-		 * the state fw and WPA_Supplicant state consistent
-		 */
-		rtnl_unlock();
-		brcmf_delay(500);
-		rtnl_lock();
-	}
+	notify_timestamp = jiffies_to_msecs(jiffies)*1000; /* uSec */
+	notify_capability = le16_to_cpu(bi->capability);
+	notify_interval = le16_to_cpu(bi->beacon_period);
+	notify_ie = (u8 *)bi + le16_to_cpu(bi->ie_offset);
+	notify_ielen = le16_to_cpu(bi->ie_length);
+	notify_signal = (s16)le16_to_cpu(bi->RSSI) * 100;
 
-	set_bit(WL_STATUS_SCAN_ABORTING, &cfg_priv->status);
-	if (test_bit(WL_STATUS_READY, &cfg_priv->status))
-		brcmf_term_iscan(cfg_priv);
+	WL_CONN("bssid: %2.2X:%2.2X:%2.2X:%2.2X:%2.2X:%2.2X\n",
+			bi->BSSID[0], bi->BSSID[1], bi->BSSID[2],
+			bi->BSSID[3], bi->BSSID[4], bi->BSSID[5]);
+	WL_CONN("Channel: %d(%d)\n", channel, freq);
+	WL_CONN("Capability: %X\n", notify_capability);
+	WL_CONN("Beacon interval: %d\n", notify_interval);
+	WL_CONN("Signal: %d\n", notify_signal);
+	WL_CONN("notify_timestamp: %#018llx\n", notify_timestamp);
 
-	if (cfg_priv->scan_request) {
-		/* Indidate scan abort to cfg80211 layer */
-		WL_INFO("Terminating scan in progress\n");
-		cfg80211_scan_done(cfg_priv->scan_request, true);
-		cfg_priv->scan_request = NULL;
-	}
-	clear_bit(WL_STATUS_SCANNING, &cfg_priv->status);
-	clear_bit(WL_STATUS_SCAN_ABORTING, &cfg_priv->status);
+	bss = cfg80211_inform_bss(wiphy, notify_channel, (const u8 *)bi->BSSID,
+		notify_timestamp, notify_capability, notify_interval, notify_ie,
+		notify_ielen, notify_signal, GFP_KERNEL);
 
-	/* Turn off watchdog timer */
-	if (test_bit(WL_STATUS_READY, &cfg_priv->status)) {
-		WL_INFO("Enable MPC\n");
-		brcmf_set_mpc(ndev, 1);
+	if (unlikely(!bss)) {
+		WL_ERR("cfg80211_inform_bss_frame error\n");
+		return -EINVAL;
 	}
 
-	WL_TRACE("Exit\n");
-
-	return 0;
+	return err;
 }
 
-static __used s32
-brcmf_update_pmklist(struct net_device *dev,
-		     struct brcmf_cfg80211_pmk_list *pmk_list, s32 err)
+static s32 brcmf_inform_bss(struct brcmf_cfg80211_priv *cfg_priv)
 {
-	int i, j;
+	struct brcmf_scan_results *bss_list;
+	struct brcmf_bss_info *bi = NULL;	/* must be initialized */
+	s32 err = 0;
+	int i;
 
-	WL_CONN("No of elements %d\n", pmk_list->pmkids.npmkid);
-	for (i = 0; i < pmk_list->pmkids.npmkid; i++) {
-		WL_CONN("PMKID[%d]: %pM =\n", i,
-			&pmk_list->pmkids.pmkid[i].BSSID);
-		for (j = 0; j < WLAN_PMKID_LEN; j++)
-			WL_CONN("%02x\n", pmk_list->pmkids.pmkid[i].PMKID[j]);
+	bss_list = cfg_priv->bss_list;
+	if (unlikely(bss_list->version != BRCMF_BSS_INFO_VERSION)) {
+		WL_ERR("Version %d != WL_BSS_INFO_VERSION\n",
+		       bss_list->version);
+		return -EOPNOTSUPP;
+	}
+	WL_SCAN("scanned AP count (%d)\n", bss_list->count);
+	bi = next_bss(bss_list, bi);
+	for_each_bss(bss_list, bi, i) {
+		err = brcmf_inform_single_bss(cfg_priv, bi);
+		if (unlikely(err))
+			break;
 	}
-
-	if (likely(!err))
-		brcmf_dev_bufvar_set(dev, "pmkid_info", (char *)pmk_list,
-					sizeof(*pmk_list));
-
 	return err;
 }
 
-static s32
-brcmf_cfg80211_set_pmksa(struct wiphy *wiphy, struct net_device *dev,
-			 struct cfg80211_pmksa *pmksa)
+static s32 wl_inform_ibss(struct brcmf_cfg80211_priv *cfg_priv,
+			  struct net_device *dev, const u8 *bssid)
 {
-	struct brcmf_cfg80211_priv *cfg_priv = wiphy_to_cfg(wiphy);
-	struct pmkid_list *pmkids = &cfg_priv->pmk_list->pmkids;
+	struct wiphy *wiphy = cfg_to_wiphy(cfg_priv);
+	struct ieee80211_channel *notify_channel;
+	struct brcmf_bss_info *bi = NULL;
+	struct ieee80211_supported_band *band;
+	u8 *buf = NULL;
 	s32 err = 0;
-	int i;
+	u16 channel;
+	u32 freq;
+	u64 notify_timestamp;
+	u16 notify_capability;
+	u16 notify_interval;
+	u8 *notify_ie;
+	size_t notify_ielen;
+	s32 notify_signal;
 
 	WL_TRACE("Enter\n");
-	if (!check_sys_up(wiphy))
-		return -EIO;
 
-	for (i = 0; i < pmkids->npmkid; i++)
-		if (!memcmp(pmksa->bssid, pmkids->pmkid[i].BSSID, ETH_ALEN))
-			break;
-	if (i < WL_NUM_PMKIDS_MAX) {
-		memcpy(pmkids->pmkid[i].BSSID, pmksa->bssid, ETH_ALEN);
+	buf = kzalloc(WL_BSS_INFO_MAX, GFP_KERNEL);
+	if (buf == NULL) {
+		WL_ERR("kzalloc() failed\n");
+		err = -ENOMEM;
+		goto CleanUp;
+	}
+
+	*(u32 *)buf = cpu_to_le32(WL_BSS_INFO_MAX);
+
+	err = brcmf_dev_ioctl(dev, BRCMF_C_GET_BSS_INFO, buf, WL_BSS_INFO_MAX);
+	if (unlikely(err)) {
+		WL_ERR("WLC_GET_BSS_INFO failed: %d\n", err);
+		goto CleanUp;
+	}
+
+	bi = (struct brcmf_bss_info *)(buf + 4);
+
+	channel = bi->ctl_ch ? bi->ctl_ch :
+				CHSPEC_CHANNEL(le16_to_cpu(bi->chanspec));
+
+	if (channel <= CH_MAX_2G_CHANNEL)
+		band = wiphy->bands[IEEE80211_BAND_2GHZ];
+	else
+		band = wiphy->bands[IEEE80211_BAND_5GHZ];
+
+	freq = ieee80211_channel_to_frequency(channel, band->band);
+	notify_channel = ieee80211_get_channel(wiphy, freq);
+
+	notify_timestamp = jiffies_to_msecs(jiffies)*1000; /* uSec */
+	notify_capability = le16_to_cpu(bi->capability);
+	notify_interval = le16_to_cpu(bi->beacon_period);
+	notify_ie = (u8 *)bi + le16_to_cpu(bi->ie_offset);
+	notify_ielen = le16_to_cpu(bi->ie_length);
+	notify_signal = (s16)le16_to_cpu(bi->RSSI) * 100;
+
+	WL_CONN("channel: %d(%d)\n", channel, freq);
+	WL_CONN("capability: %X\n", notify_capability);
+	WL_CONN("beacon interval: %d\n", notify_interval);
+	WL_CONN("signal: %d\n", notify_signal);
+	WL_CONN("notify_timestamp: %#018llx\n", notify_timestamp);
+
+	cfg80211_inform_bss(wiphy, notify_channel, bssid,
+		notify_timestamp, notify_capability, notify_interval,
+		notify_ie, notify_ielen, notify_signal, GFP_KERNEL);
+
+CleanUp:
+
+	kfree(buf);
+
+	WL_TRACE("Exit\n");
+
+	return err;
+}
+
+static bool brcmf_is_ibssmode(struct brcmf_cfg80211_priv *cfg_priv)
+{
+	return cfg_priv->conf->mode == WL_MODE_IBSS;
+}
+
+static s32 brcmf_update_bss_info(struct brcmf_cfg80211_priv *cfg_priv)
+{
+	struct brcmf_bss_info *bi;
+	struct brcmf_ssid *ssid;
+	struct brcmu_tlv *tim;
+	u16 beacon_interval;
+	u8 dtim_period;
+	size_t ie_len;
+	u8 *ie;
+	s32 err = 0;
+
+	WL_TRACE("Enter\n");
+	if (brcmf_is_ibssmode(cfg_priv))
+		return err;
+
+	ssid = (struct brcmf_ssid *)brcmf_read_prof(cfg_priv, WL_PROF_SSID);
+
+	*(u32 *)cfg_priv->extra_buf = cpu_to_le32(WL_EXTRA_BUF_MAX);
+	err = brcmf_dev_ioctl(cfg_to_ndev(cfg_priv), BRCMF_C_GET_BSS_INFO,
+			cfg_priv->extra_buf, WL_EXTRA_BUF_MAX);
+	if (unlikely(err)) {
+		WL_ERR("Could not get bss info %d\n", err);
+		goto update_bss_info_out;
+	}
+
+	bi = (struct brcmf_bss_info *)(cfg_priv->extra_buf + 4);
+	err = brcmf_inform_single_bss(cfg_priv, bi);
+	if (unlikely(err))
+		goto update_bss_info_out;
+
+	ie = ((u8 *)bi) + bi->ie_offset;
+	ie_len = bi->ie_length;
+	beacon_interval = cpu_to_le16(bi->beacon_period);
+
+	tim = brcmu_parse_tlvs(ie, ie_len, WLAN_EID_TIM);
+	if (tim)
+		dtim_period = tim->data[1];
+	else {
+		/*
+		* active scan was done so we could not get dtim
+		* information out of probe response.
+		* so we speficially query dtim information to dongle.
+		*/
+		u32 var;
+		err = brcmf_dev_intvar_get(cfg_to_ndev(cfg_priv),
+					   "dtim_assoc", &var);
+		if (unlikely(err)) {
+			WL_ERR("wl dtim_assoc failed (%d)\n", err);
+			goto update_bss_info_out;
+		}
+		dtim_period = (u8)var;
+	}
+
+	brcmf_update_prof(cfg_priv, NULL, &beacon_interval, WL_PROF_BEACONINT);
+	brcmf_update_prof(cfg_priv, NULL, &dtim_period, WL_PROF_DTIMPERIOD);
+
+update_bss_info_out:
+	WL_TRACE("Exit");
+	return err;
+}
+
+static void brcmf_term_iscan(struct brcmf_cfg80211_priv *cfg_priv)
+{
+	struct brcmf_cfg80211_iscan_ctrl *iscan = cfg_to_iscan(cfg_priv);
+	struct brcmf_ssid ssid;
+
+	if (cfg_priv->iscan_on) {
+		iscan->state = WL_ISCAN_STATE_IDLE;
+
+		if (iscan->timer_on) {
+			del_timer_sync(&iscan->timer);
+			iscan->timer_on = 0;
+		}
+
+		cancel_work_sync(&iscan->work);
+
+		/* Abort iscan running in FW */
+		memset(&ssid, 0, sizeof(ssid));
+		brcmf_run_iscan(iscan, &ssid, WL_SCAN_ACTION_ABORT);
+	}
+}
+
+static void brcmf_notify_iscan_complete(struct brcmf_cfg80211_iscan_ctrl *iscan,
+					bool aborted)
+{
+	struct brcmf_cfg80211_priv *cfg_priv = iscan_to_cfg(iscan);
+	struct net_device *ndev = cfg_to_ndev(cfg_priv);
+
+	if (unlikely(!test_and_clear_bit(WL_STATUS_SCANNING,
+					 &cfg_priv->status))) {
+		WL_ERR("Scan complete while device not scanning\n");
+		return;
+	}
+	if (likely(cfg_priv->scan_request)) {
+		WL_SCAN("ISCAN Completed scan: %s\n",
+				aborted ? "Aborted" : "Done");
+		cfg80211_scan_done(cfg_priv->scan_request, aborted);
+		brcmf_set_mpc(ndev, 1);
+		cfg_priv->scan_request = NULL;
+	}
+	cfg_priv->iscan_kickstart = false;
+}
+
+static s32 brcmf_wakeup_iscan(struct brcmf_cfg80211_iscan_ctrl *iscan)
+{
+	if (likely(iscan->state != WL_ISCAN_STATE_IDLE)) {
+		WL_SCAN("wake up iscan\n");
+		schedule_work(&iscan->work);
+		return 0;
+	}
+
+	return -EIO;
+}
+
+static s32
+brcmf_get_iscan_results(struct brcmf_cfg80211_iscan_ctrl *iscan, u32 *status,
+		     struct brcmf_scan_results **bss_list)
+{
+	struct brcmf_iscan_results list;
+	struct brcmf_scan_results *results;
+	struct brcmf_iscan_results *list_buf;
+	s32 err = 0;
+
+	memset(iscan->scan_buf, 0, WL_ISCAN_BUF_MAX);
+	list_buf = (struct brcmf_iscan_results *)iscan->scan_buf;
+	results = &list_buf->results;
+	results->buflen = BRCMF_ISCAN_RESULTS_FIXED_SIZE;
+	results->version = 0;
+	results->count = 0;
+
+	memset(&list, 0, sizeof(list));
+	list.results.buflen = cpu_to_le32(WL_ISCAN_BUF_MAX);
+	err = brcmf_dev_iovar_getbuf(iscan->dev, "iscanresults", &list,
+				BRCMF_ISCAN_RESULTS_FIXED_SIZE, iscan->scan_buf,
+				WL_ISCAN_BUF_MAX);
+	if (unlikely(err)) {
+		WL_ERR("error (%d)\n", err);
+		return err;
+	}
+	results->buflen = le32_to_cpu(results->buflen);
+	results->version = le32_to_cpu(results->version);
+	results->count = le32_to_cpu(results->count);
+	WL_SCAN("results->count = %d\n", results->count);
+	WL_SCAN("results->buflen = %d\n", results->buflen);
+	*status = le32_to_cpu(list_buf->status);
+	WL_SCAN("status = %d\n", *status);
+	*bss_list = results;
+
+	return err;
+}
+
+static s32 brcmf_iscan_done(struct brcmf_cfg80211_priv *cfg_priv)
+{
+	struct brcmf_cfg80211_iscan_ctrl *iscan = cfg_priv->iscan;
+	s32 err = 0;
+
+	iscan->state = WL_ISCAN_STATE_IDLE;
+	rtnl_lock();
+	brcmf_inform_bss(cfg_priv);
+	brcmf_notify_iscan_complete(iscan, false);
+	rtnl_unlock();
+
+	return err;
+}
+
+static s32 brcmf_iscan_pending(struct brcmf_cfg80211_priv *cfg_priv)
+{
+	struct brcmf_cfg80211_iscan_ctrl *iscan = cfg_priv->iscan;
+	s32 err = 0;
+
+	/* Reschedule the timer */
+	mod_timer(&iscan->timer, jiffies + iscan->timer_ms * HZ / 1000);
+	iscan->timer_on = 1;
+
+	return err;
+}
+
+static s32 brcmf_iscan_inprogress(struct brcmf_cfg80211_priv *cfg_priv)
+{
+	struct brcmf_cfg80211_iscan_ctrl *iscan = cfg_priv->iscan;
+	s32 err = 0;
+
+	rtnl_lock();
+	brcmf_inform_bss(cfg_priv);
+	brcmf_run_iscan(iscan, NULL, BRCMF_SCAN_ACTION_CONTINUE);
+	rtnl_unlock();
+	/* Reschedule the timer */
+	mod_timer(&iscan->timer, jiffies + iscan->timer_ms * HZ / 1000);
+	iscan->timer_on = 1;
+
+	return err;
+}
+
+static s32 brcmf_iscan_aborted(struct brcmf_cfg80211_priv *cfg_priv)
+{
+	struct brcmf_cfg80211_iscan_ctrl *iscan = cfg_priv->iscan;
+	s32 err = 0;
+
+	iscan->state = WL_ISCAN_STATE_IDLE;
+	rtnl_lock();
+	brcmf_notify_iscan_complete(iscan, true);
+	rtnl_unlock();
+
+	return err;
+}
+
+static void brcmf_cfg80211_iscan_handler(struct work_struct *work)
+{
+	struct brcmf_cfg80211_iscan_ctrl *iscan =
+			container_of(work, struct brcmf_cfg80211_iscan_ctrl,
+				     work);
+	struct brcmf_cfg80211_priv *cfg_priv = iscan_to_cfg(iscan);
+	struct brcmf_cfg80211_iscan_eloop *el = &iscan->el;
+	u32 status = BRCMF_SCAN_RESULTS_PARTIAL;
+
+	if (iscan->timer_on) {
+		del_timer_sync(&iscan->timer);
+		iscan->timer_on = 0;
+	}
+
+	rtnl_lock();
+	if (brcmf_get_iscan_results(iscan, &status, &cfg_priv->bss_list)) {
+		status = BRCMF_SCAN_RESULTS_ABORTED;
+		WL_ERR("Abort iscan\n");
+	}
+	rtnl_unlock();
+
+	el->handler[status](cfg_priv);
+}
+
+static void brcmf_iscan_timer(unsigned long data)
+{
+	struct brcmf_cfg80211_iscan_ctrl *iscan =
+			(struct brcmf_cfg80211_iscan_ctrl *)data;
+
+	if (iscan) {
+		iscan->timer_on = 0;
+		WL_SCAN("timer expired\n");
+		brcmf_wakeup_iscan(iscan);
+	}
+}
+
+static s32 brcmf_invoke_iscan(struct brcmf_cfg80211_priv *cfg_priv)
+{
+	struct brcmf_cfg80211_iscan_ctrl *iscan = cfg_to_iscan(cfg_priv);
+
+	if (cfg_priv->iscan_on) {
+		iscan->state = WL_ISCAN_STATE_IDLE;
+		INIT_WORK(&iscan->work, brcmf_cfg80211_iscan_handler);
+	}
+
+	return 0;
+}
+
+static void brcmf_init_iscan_eloop(struct brcmf_cfg80211_iscan_eloop *el)
+{
+	memset(el, 0, sizeof(*el));
+	el->handler[BRCMF_SCAN_RESULTS_SUCCESS] = brcmf_iscan_done;
+	el->handler[BRCMF_SCAN_RESULTS_PARTIAL] = brcmf_iscan_inprogress;
+	el->handler[BRCMF_SCAN_RESULTS_PENDING] = brcmf_iscan_pending;
+	el->handler[BRCMF_SCAN_RESULTS_ABORTED] = brcmf_iscan_aborted;
+	el->handler[BRCMF_SCAN_RESULTS_NO_MEM] = brcmf_iscan_aborted;
+}
+
+static s32 brcmf_init_iscan(struct brcmf_cfg80211_priv *cfg_priv)
+{
+	struct brcmf_cfg80211_iscan_ctrl *iscan = cfg_to_iscan(cfg_priv);
+	int err = 0;
+
+	if (cfg_priv->iscan_on) {
+		iscan->dev = cfg_to_ndev(cfg_priv);
+		brcmf_init_iscan_eloop(&iscan->el);
+		iscan->timer_ms = WL_ISCAN_TIMER_INTERVAL_MS;
+		init_timer(&iscan->timer);
+		iscan->timer.data = (unsigned long) iscan;
+		iscan->timer.function = brcmf_iscan_timer;
+		err = brcmf_invoke_iscan(cfg_priv);
+		if (!err)
+			iscan->data = cfg_priv;
+	}
+
+	return err;
+}
+
+static void brcmf_delay(u32 ms)
+{
+	if (ms < 1000 / HZ) {
+		cond_resched();
+		mdelay(ms);
+	} else {
+		msleep(ms);
+	}
+}
+
+static s32 brcmf_cfg80211_resume(struct wiphy *wiphy)
+{
+	struct brcmf_cfg80211_priv *cfg_priv = wiphy_to_cfg(wiphy);
+
+	/*
+	 * Check for WL_STATUS_READY before any function call which
+	 * could result is bus access. Don't block the resume for
+	 * any driver error conditions
+	 */
+	WL_TRACE("Enter\n");
+
+	if (test_bit(WL_STATUS_READY, &cfg_priv->status))
+		brcmf_invoke_iscan(wiphy_to_cfg(wiphy));
+
+	WL_TRACE("Exit\n");
+	return 0;
+}
+
+static s32 brcmf_cfg80211_suspend(struct wiphy *wiphy,
+				  struct cfg80211_wowlan *wow)
+{
+	struct brcmf_cfg80211_priv *cfg_priv = wiphy_to_cfg(wiphy);
+	struct net_device *ndev = cfg_to_ndev(cfg_priv);
+
+	WL_TRACE("Enter\n");
+
+	/*
+	 * Check for WL_STATUS_READY before any function call which
+	 * could result is bus access. Don't block the suspend for
+	 * any driver error conditions
+	 */
+
+	/*
+	 * While going to suspend if associated with AP disassociate
+	 * from AP to save power while system is in suspended state
+	 */
+	if ((test_bit(WL_STATUS_CONNECTED, &cfg_priv->status) ||
+	     test_bit(WL_STATUS_CONNECTING, &cfg_priv->status)) &&
+	     test_bit(WL_STATUS_READY, &cfg_priv->status)) {
+		WL_INFO("Disassociating from AP"
+			" while entering suspend state\n");
+		brcmf_link_down(cfg_priv);
+
+		/*
+		 * Make sure WPA_Supplicant receives all the event
+		 * generated due to DISASSOC call to the fw to keep
+		 * the state fw and WPA_Supplicant state consistent
+		 */
+		rtnl_unlock();
+		brcmf_delay(500);
+		rtnl_lock();
+	}
+
+	set_bit(WL_STATUS_SCAN_ABORTING, &cfg_priv->status);
+	if (test_bit(WL_STATUS_READY, &cfg_priv->status))
+		brcmf_term_iscan(cfg_priv);
+
+	if (cfg_priv->scan_request) {
+		/* Indidate scan abort to cfg80211 layer */
+		WL_INFO("Terminating scan in progress\n");
+		cfg80211_scan_done(cfg_priv->scan_request, true);
+		cfg_priv->scan_request = NULL;
+	}
+	clear_bit(WL_STATUS_SCANNING, &cfg_priv->status);
+	clear_bit(WL_STATUS_SCAN_ABORTING, &cfg_priv->status);
+
+	/* Turn off watchdog timer */
+	if (test_bit(WL_STATUS_READY, &cfg_priv->status)) {
+		WL_INFO("Enable MPC\n");
+		brcmf_set_mpc(ndev, 1);
+	}
+
+	WL_TRACE("Exit\n");
+
+	return 0;
+}
+
+static __used s32
+brcmf_dev_bufvar_set(struct net_device *dev, s8 *name, s8 *buf, s32 len)
+{
+	struct brcmf_cfg80211_priv *cfg_priv = ndev_to_cfg(dev);
+	u32 buflen;
+
+	buflen = brcmu_mkiovar(name, buf, len, cfg_priv->ioctl_buf,
+			       WL_IOCTL_LEN_MAX);
+	BUG_ON(!buflen);
+
+	return brcmf_dev_ioctl(dev, BRCMF_C_SET_VAR, cfg_priv->ioctl_buf,
+			       buflen);
+}
+
+static s32
+brcmf_dev_bufvar_get(struct net_device *dev, s8 *name, s8 *buf,
+		  s32 buf_len)
+{
+	struct brcmf_cfg80211_priv *cfg_priv = ndev_to_cfg(dev);
+	u32 len;
+	s32 err = 0;
+
+	len = brcmu_mkiovar(name, NULL, 0, cfg_priv->ioctl_buf,
+			    WL_IOCTL_LEN_MAX);
+	BUG_ON(!len);
+	err = brcmf_dev_ioctl(dev, BRCMF_C_GET_VAR, (void *)cfg_priv->ioctl_buf,
+			WL_IOCTL_LEN_MAX);
+	if (unlikely(err)) {
+		WL_ERR("error (%d)\n", err);
+		return err;
+	}
+	memcpy(buf, cfg_priv->ioctl_buf, buf_len);
+
+	return err;
+}
+
+static __used s32
+brcmf_update_pmklist(struct net_device *dev,
+		     struct brcmf_cfg80211_pmk_list *pmk_list, s32 err)
+{
+	int i, j;
+
+	WL_CONN("No of elements %d\n", pmk_list->pmkids.npmkid);
+	for (i = 0; i < pmk_list->pmkids.npmkid; i++) {
+		WL_CONN("PMKID[%d]: %pM =\n", i,
+			&pmk_list->pmkids.pmkid[i].BSSID);
+		for (j = 0; j < WLAN_PMKID_LEN; j++)
+			WL_CONN("%02x\n", pmk_list->pmkids.pmkid[i].PMKID[j]);
+	}
+
+	if (likely(!err))
+		brcmf_dev_bufvar_set(dev, "pmkid_info", (char *)pmk_list,
+					sizeof(*pmk_list));
+
+	return err;
+}
+
+static s32
+brcmf_cfg80211_set_pmksa(struct wiphy *wiphy, struct net_device *dev,
+			 struct cfg80211_pmksa *pmksa)
+{
+	struct brcmf_cfg80211_priv *cfg_priv = wiphy_to_cfg(wiphy);
+	struct pmkid_list *pmkids = &cfg_priv->pmk_list->pmkids;
+	s32 err = 0;
+	int i;
+
+	WL_TRACE("Enter\n");
+	if (!check_sys_up(wiphy))
+		return -EIO;
+
+	for (i = 0; i < pmkids->npmkid; i++)
+		if (!memcmp(pmksa->bssid, pmkids->pmkid[i].BSSID, ETH_ALEN))
+			break;
+	if (i < WL_NUM_PMKIDS_MAX) {
+		memcpy(pmkids->pmkid[i].BSSID, pmksa->bssid, ETH_ALEN);
 		memcpy(pmkids->pmkid[i].PMKID, pmksa->pmkid, WLAN_PMKID_LEN);
 		if (i == pmkids->npmkid)
 			pmkids->npmkid++;
@@ -2382,165 +2752,6 @@ static void brcmf_free_wdev(struct brcmf_cfg80211_priv *cfg_priv)
 	cfg_priv->wdev = NULL;
 }
 
-static s32 brcmf_inform_bss(struct brcmf_cfg80211_priv *cfg_priv)
-{
-	struct brcmf_scan_results *bss_list;
-	struct brcmf_bss_info *bi = NULL;	/* must be initialized */
-	s32 err = 0;
-	int i;
-
-	bss_list = cfg_priv->bss_list;
-	if (unlikely(bss_list->version != BRCMF_BSS_INFO_VERSION)) {
-		WL_ERR("Version %d != WL_BSS_INFO_VERSION\n",
-		       bss_list->version);
-		return -EOPNOTSUPP;
-	}
-	WL_SCAN("scanned AP count (%d)\n", bss_list->count);
-	bi = next_bss(bss_list, bi);
-	for_each_bss(bss_list, bi, i) {
-		err = brcmf_inform_single_bss(cfg_priv, bi);
-		if (unlikely(err))
-			break;
-	}
-	return err;
-}
-
-
-static s32 brcmf_inform_single_bss(struct brcmf_cfg80211_priv *cfg_priv,
-				   struct brcmf_bss_info *bi)
-{
-	struct wiphy *wiphy = cfg_to_wiphy(cfg_priv);
-	struct ieee80211_channel *notify_channel;
-	struct cfg80211_bss *bss;
-	struct ieee80211_supported_band *band;
-	s32 err = 0;
-	u16 channel;
-	u32 freq;
-	u64 notify_timestamp;
-	u16 notify_capability;
-	u16 notify_interval;
-	u8 *notify_ie;
-	size_t notify_ielen;
-	s32 notify_signal;
-
-	if (unlikely(le32_to_cpu(bi->length) > WL_BSS_INFO_MAX)) {
-		WL_ERR("Bss info is larger than buffer. Discarding\n");
-		return 0;
-	}
-
-	channel = bi->ctl_ch ? bi->ctl_ch :
-				CHSPEC_CHANNEL(le16_to_cpu(bi->chanspec));
-
-	if (channel <= CH_MAX_2G_CHANNEL)
-		band = wiphy->bands[IEEE80211_BAND_2GHZ];
-	else
-		band = wiphy->bands[IEEE80211_BAND_5GHZ];
-
-	freq = ieee80211_channel_to_frequency(channel, band->band);
-	notify_channel = ieee80211_get_channel(wiphy, freq);
-
-	notify_timestamp = jiffies_to_msecs(jiffies)*1000; /* uSec */
-	notify_capability = le16_to_cpu(bi->capability);
-	notify_interval = le16_to_cpu(bi->beacon_period);
-	notify_ie = (u8 *)bi + le16_to_cpu(bi->ie_offset);
-	notify_ielen = le16_to_cpu(bi->ie_length);
-	notify_signal = (s16)le16_to_cpu(bi->RSSI) * 100;
-
-	WL_CONN("bssid: %2.2X:%2.2X:%2.2X:%2.2X:%2.2X:%2.2X\n",
-			bi->BSSID[0], bi->BSSID[1], bi->BSSID[2],
-			bi->BSSID[3], bi->BSSID[4], bi->BSSID[5]);
-	WL_CONN("Channel: %d(%d)\n", channel, freq);
-	WL_CONN("Capability: %X\n", notify_capability);
-	WL_CONN("Beacon interval: %d\n", notify_interval);
-	WL_CONN("Signal: %d\n", notify_signal);
-	WL_CONN("notify_timestamp: %#018llx\n", notify_timestamp);
-
-	bss = cfg80211_inform_bss(wiphy, notify_channel, (const u8 *)bi->BSSID,
-		notify_timestamp, notify_capability, notify_interval, notify_ie,
-		notify_ielen, notify_signal, GFP_KERNEL);
-
-	if (unlikely(!bss)) {
-		WL_ERR("cfg80211_inform_bss_frame error\n");
-		return -EINVAL;
-	}
-
-	return err;
-}
-
-static s32 wl_inform_ibss(struct brcmf_cfg80211_priv *cfg_priv,
-			  struct net_device *dev, const u8 *bssid)
-{
-	struct wiphy *wiphy = cfg_to_wiphy(cfg_priv);
-	struct ieee80211_channel *notify_channel;
-	struct brcmf_bss_info *bi = NULL;
-	struct ieee80211_supported_band *band;
-	u8 *buf = NULL;
-	s32 err = 0;
-	u16 channel;
-	u32 freq;
-	u64 notify_timestamp;
-	u16 notify_capability;
-	u16 notify_interval;
-	u8 *notify_ie;
-	size_t notify_ielen;
-	s32 notify_signal;
-
-	WL_TRACE("Enter\n");
-
-	buf = kzalloc(WL_BSS_INFO_MAX, GFP_KERNEL);
-	if (buf == NULL) {
-		WL_ERR("kzalloc() failed\n");
-		err = -ENOMEM;
-		goto CleanUp;
-	}
-
-	*(u32 *)buf = cpu_to_le32(WL_BSS_INFO_MAX);
-
-	err = brcmf_dev_ioctl(dev, BRCMF_C_GET_BSS_INFO, buf, WL_BSS_INFO_MAX);
-	if (unlikely(err)) {
-		WL_ERR("WLC_GET_BSS_INFO failed: %d\n", err);
-		goto CleanUp;
-	}
-
-	bi = (struct brcmf_bss_info *)(buf + 4);
-
-	channel = bi->ctl_ch ? bi->ctl_ch :
-				CHSPEC_CHANNEL(le16_to_cpu(bi->chanspec));
-
-	if (channel <= CH_MAX_2G_CHANNEL)
-		band = wiphy->bands[IEEE80211_BAND_2GHZ];
-	else
-		band = wiphy->bands[IEEE80211_BAND_5GHZ];
-
-	freq = ieee80211_channel_to_frequency(channel, band->band);
-	notify_channel = ieee80211_get_channel(wiphy, freq);
-
-	notify_timestamp = jiffies_to_msecs(jiffies)*1000; /* uSec */
-	notify_capability = le16_to_cpu(bi->capability);
-	notify_interval = le16_to_cpu(bi->beacon_period);
-	notify_ie = (u8 *)bi + le16_to_cpu(bi->ie_offset);
-	notify_ielen = le16_to_cpu(bi->ie_length);
-	notify_signal = (s16)le16_to_cpu(bi->RSSI) * 100;
-
-	WL_CONN("channel: %d(%d)\n", channel, freq);
-	WL_CONN("capability: %X\n", notify_capability);
-	WL_CONN("beacon interval: %d\n", notify_interval);
-	WL_CONN("signal: %d\n", notify_signal);
-	WL_CONN("notify_timestamp: %#018llx\n", notify_timestamp);
-
-	cfg80211_inform_bss(wiphy, notify_channel, bssid,
-		notify_timestamp, notify_capability, notify_interval,
-		notify_ie, notify_ielen, notify_signal, GFP_KERNEL);
-
-CleanUp:
-
-	kfree(buf);
-
-	WL_TRACE("Exit\n");
-
-	return err;
-}
-
 static bool brcmf_is_linkup(struct brcmf_cfg80211_priv *cfg_priv,
 			    const struct brcmf_event_msg *e)
 {
@@ -2556,138 +2767,50 @@ static bool brcmf_is_linkup(struct brcmf_cfg80211_priv *cfg_priv,
 	return false;
 }
 
-static bool brcmf_is_linkdown(struct brcmf_cfg80211_priv *cfg_priv,
-			      const struct brcmf_event_msg *e)
-{
-	u32 event = be32_to_cpu(e->event_type);
-	u16 flags = be16_to_cpu(e->flags);
-
-	if (event == BRCMF_E_LINK && (!(flags & BRCMF_EVENT_MSG_LINK))) {
-		WL_CONN("Processing link down\n");
-		return true;
-	}
-	return false;
-}
-
-static bool brcmf_is_nonetwork(struct brcmf_cfg80211_priv *cfg_priv,
-			       const struct brcmf_event_msg *e)
-{
-	u32 event = be32_to_cpu(e->event_type);
-	u32 status = be32_to_cpu(e->status);
-
-	if (event == BRCMF_E_LINK && status == BRCMF_E_STATUS_NO_NETWORKS) {
-		WL_CONN("Processing Link %s & no network found\n",
-				be16_to_cpu(e->flags) & BRCMF_EVENT_MSG_LINK ?
-				"up" : "down");
-		return true;
-	}
-
-	if (event == BRCMF_E_SET_SSID && status != BRCMF_E_STATUS_SUCCESS) {
-		WL_CONN("Processing connecting & no network found\n");
-		return true;
-	}
-
-	return false;
-}
-
-static s32
-brcmf_notify_connect_status(struct brcmf_cfg80211_priv *cfg_priv,
-			    struct net_device *ndev,
-			    const struct brcmf_event_msg *e, void *data)
-{
-	s32 err = 0;
-
-	if (brcmf_is_linkup(cfg_priv, e)) {
-		WL_CONN("Linkup\n");
-		if (brcmf_is_ibssmode(cfg_priv)) {
-			brcmf_update_prof(cfg_priv, NULL, (void *)e->addr,
-				WL_PROF_BSSID);
-			wl_inform_ibss(cfg_priv, ndev, e->addr);
-			cfg80211_ibss_joined(ndev, e->addr, GFP_KERNEL);
-			clear_bit(WL_STATUS_CONNECTING, &cfg_priv->status);
-			set_bit(WL_STATUS_CONNECTED, &cfg_priv->status);
-		} else
-			brcmf_bss_connect_done(cfg_priv, ndev, e, true);
-	} else if (brcmf_is_linkdown(cfg_priv, e)) {
-		WL_CONN("Linkdown\n");
-		if (brcmf_is_ibssmode(cfg_priv)) {
-			clear_bit(WL_STATUS_CONNECTING, &cfg_priv->status);
-			if (test_and_clear_bit(WL_STATUS_CONNECTED,
-				&cfg_priv->status))
-				brcmf_link_down(cfg_priv);
-		} else {
-			brcmf_bss_connect_done(cfg_priv, ndev, e, false);
-			if (test_and_clear_bit(WL_STATUS_CONNECTED,
-				&cfg_priv->status)) {
-				cfg80211_disconnected(ndev, 0, NULL, 0,
-					GFP_KERNEL);
-				brcmf_link_down(cfg_priv);
-			}
-		}
-		brcmf_init_prof(cfg_priv->profile);
-	} else if (brcmf_is_nonetwork(cfg_priv, e)) {
-		if (brcmf_is_ibssmode(cfg_priv))
-			clear_bit(WL_STATUS_CONNECTING, &cfg_priv->status);
-		else
-			brcmf_bss_connect_done(cfg_priv, ndev, e, false);
-	}
-
-	return err;
-}
-
-static s32
-brcmf_notify_roaming_status(struct brcmf_cfg80211_priv *cfg_priv,
-			    struct net_device *ndev,
-			    const struct brcmf_event_msg *e, void *data)
+static bool brcmf_is_linkdown(struct brcmf_cfg80211_priv *cfg_priv,
+			      const struct brcmf_event_msg *e)
 {
-	s32 err = 0;
 	u32 event = be32_to_cpu(e->event_type);
-	u32 status = be32_to_cpu(e->status);
+	u16 flags = be16_to_cpu(e->flags);
 
-	if (event == BRCMF_E_ROAM && status == BRCMF_E_STATUS_SUCCESS) {
-		if (test_bit(WL_STATUS_CONNECTED, &cfg_priv->status))
-			brcmf_bss_roaming_done(cfg_priv, ndev, e);
-		else
-			brcmf_bss_connect_done(cfg_priv, ndev, e, true);
+	if (event == BRCMF_E_LINK && (!(flags & BRCMF_EVENT_MSG_LINK))) {
+		WL_CONN("Processing link down\n");
+		return true;
 	}
-
-	return err;
+	return false;
 }
 
-static __used s32
-brcmf_dev_bufvar_set(struct net_device *dev, s8 *name, s8 *buf, s32 len)
+static bool brcmf_is_nonetwork(struct brcmf_cfg80211_priv *cfg_priv,
+			       const struct brcmf_event_msg *e)
 {
-	struct brcmf_cfg80211_priv *cfg_priv = ndev_to_cfg(dev);
-	u32 buflen;
+	u32 event = be32_to_cpu(e->event_type);
+	u32 status = be32_to_cpu(e->status);
 
-	buflen = brcmu_mkiovar(name, buf, len, cfg_priv->ioctl_buf,
-			       WL_IOCTL_LEN_MAX);
-	BUG_ON(!buflen);
+	if (event == BRCMF_E_LINK && status == BRCMF_E_STATUS_NO_NETWORKS) {
+		WL_CONN("Processing Link %s & no network found\n",
+				be16_to_cpu(e->flags) & BRCMF_EVENT_MSG_LINK ?
+				"up" : "down");
+		return true;
+	}
 
-	return brcmf_dev_ioctl(dev, BRCMF_C_SET_VAR, cfg_priv->ioctl_buf,
-			       buflen);
+	if (event == BRCMF_E_SET_SSID && status != BRCMF_E_STATUS_SUCCESS) {
+		WL_CONN("Processing connecting & no network found\n");
+		return true;
+	}
+
+	return false;
 }
 
-static s32
-brcmf_dev_bufvar_get(struct net_device *dev, s8 *name, s8 *buf,
-		  s32 buf_len)
+static void brcmf_clear_assoc_ies(struct brcmf_cfg80211_priv *cfg_priv)
 {
-	struct brcmf_cfg80211_priv *cfg_priv = ndev_to_cfg(dev);
-	u32 len;
-	s32 err = 0;
-
-	len = brcmu_mkiovar(name, NULL, 0, cfg_priv->ioctl_buf,
-			    WL_IOCTL_LEN_MAX);
-	BUG_ON(!len);
-	err = brcmf_dev_ioctl(dev, BRCMF_C_GET_VAR, (void *)cfg_priv->ioctl_buf,
-			WL_IOCTL_LEN_MAX);
-	if (unlikely(err)) {
-		WL_ERR("error (%d)\n", err);
-		return err;
-	}
-	memcpy(buf, cfg_priv->ioctl_buf, buf_len);
+	struct brcmf_cfg80211_connect_info *conn_info = cfg_to_conn(cfg_priv);
 
-	return err;
+	kfree(conn_info->req_ie);
+	conn_info->req_ie = NULL;
+	conn_info->req_ie_len = 0;
+	kfree(conn_info->resp_ie);
+	conn_info->resp_ie = NULL;
+	conn_info->resp_ie_len = 0;
 }
 
 static s32 brcmf_get_assoc_ies(struct brcmf_cfg80211_priv *cfg_priv)
@@ -2748,114 +2871,6 @@ static s32 brcmf_get_assoc_ies(struct brcmf_cfg80211_priv *cfg_priv)
 	return err;
 }
 
-static void brcmf_clear_assoc_ies(struct brcmf_cfg80211_priv *cfg_priv)
-{
-	struct brcmf_cfg80211_connect_info *conn_info = cfg_to_conn(cfg_priv);
-
-	kfree(conn_info->req_ie);
-	conn_info->req_ie = NULL;
-	conn_info->req_ie_len = 0;
-	kfree(conn_info->resp_ie);
-	conn_info->resp_ie = NULL;
-	conn_info->resp_ie_len = 0;
-}
-
-
-static void brcmf_ch_to_chanspec(int ch, struct brcmf_join_params *join_params,
-	size_t *join_params_size)
-{
-	u16 chanspec = 0;
-
-	if (ch != 0) {
-		join_params->params.chanspec_num = 1;
-		join_params->params.chanspec_list[0] = ch;
-
-		if (join_params->params.chanspec_list[0] <= CH_MAX_2G_CHANNEL)
-			chanspec |= WL_CHANSPEC_BAND_2G;
-		else
-			chanspec |= WL_CHANSPEC_BAND_5G;
-
-		chanspec |= WL_CHANSPEC_BW_20;
-		chanspec |= WL_CHANSPEC_CTL_SB_NONE;
-
-		*join_params_size += BRCMF_ASSOC_PARAMS_FIXED_SIZE +
-			join_params->params.chanspec_num * sizeof(u16);
-
-		join_params->params.chanspec_list[0] &= WL_CHANSPEC_CHAN_MASK;
-		join_params->params.chanspec_list[0] |= chanspec;
-		join_params->params.chanspec_list[0] =
-		cpu_to_le16(join_params->params.chanspec_list[0]);
-
-		join_params->params.chanspec_num =
-			cpu_to_le32(join_params->params.chanspec_num);
-
-		WL_CONN("join_params->params.chanspec_list[0]= %#X,"
-			"channel %d, chanspec %#X\n",
-		       join_params->params.chanspec_list[0], ch, chanspec);
-	}
-}
-
-static s32 brcmf_update_bss_info(struct brcmf_cfg80211_priv *cfg_priv)
-{
-	struct brcmf_bss_info *bi;
-	struct brcmf_ssid *ssid;
-	struct brcmu_tlv *tim;
-	u16 beacon_interval;
-	u8 dtim_period;
-	size_t ie_len;
-	u8 *ie;
-	s32 err = 0;
-
-	WL_TRACE("Enter\n");
-	if (brcmf_is_ibssmode(cfg_priv))
-		return err;
-
-	ssid = (struct brcmf_ssid *)brcmf_read_prof(cfg_priv, WL_PROF_SSID);
-
-	*(u32 *)cfg_priv->extra_buf = cpu_to_le32(WL_EXTRA_BUF_MAX);
-	err = brcmf_dev_ioctl(cfg_to_ndev(cfg_priv), BRCMF_C_GET_BSS_INFO,
-			cfg_priv->extra_buf, WL_EXTRA_BUF_MAX);
-	if (unlikely(err)) {
-		WL_ERR("Could not get bss info %d\n", err);
-		goto update_bss_info_out;
-	}
-
-	bi = (struct brcmf_bss_info *)(cfg_priv->extra_buf + 4);
-	err = brcmf_inform_single_bss(cfg_priv, bi);
-	if (unlikely(err))
-		goto update_bss_info_out;
-
-	ie = ((u8 *)bi) + bi->ie_offset;
-	ie_len = bi->ie_length;
-	beacon_interval = cpu_to_le16(bi->beacon_period);
-
-	tim = brcmu_parse_tlvs(ie, ie_len, WLAN_EID_TIM);
-	if (tim)
-		dtim_period = tim->data[1];
-	else {
-		/*
-		* active scan was done so we could not get dtim
-		* information out of probe response.
-		* so we speficially query dtim information to dongle.
-		*/
-		u32 var;
-		err = brcmf_dev_intvar_get(cfg_to_ndev(cfg_priv),
-					   "dtim_assoc", &var);
-		if (unlikely(err)) {
-			WL_ERR("wl dtim_assoc failed (%d)\n", err);
-			goto update_bss_info_out;
-		}
-		dtim_period = (u8)var;
-	}
-
-	brcmf_update_prof(cfg_priv, NULL, &beacon_interval, WL_PROF_BEACONINT);
-	brcmf_update_prof(cfg_priv, NULL, &dtim_period, WL_PROF_DTIMPERIOD);
-
-update_bss_info_out:
-	WL_TRACE("Exit");
-	return err;
-}
-
 static s32
 brcmf_bss_roaming_done(struct brcmf_cfg80211_priv *cfg_priv,
 		       struct net_device *ndev,
@@ -2895,44 +2910,108 @@ brcmf_bss_roaming_done(struct brcmf_cfg80211_priv *cfg_priv,
 			conn_info->resp_ie, conn_info->resp_ie_len, GFP_KERNEL);
 	WL_CONN("Report roaming result\n");
 
-	set_bit(WL_STATUS_CONNECTED, &cfg_priv->status);
-	WL_TRACE("Exit\n");
+	set_bit(WL_STATUS_CONNECTED, &cfg_priv->status);
+	WL_TRACE("Exit\n");
+	return err;
+}
+
+static s32
+brcmf_bss_connect_done(struct brcmf_cfg80211_priv *cfg_priv,
+		       struct net_device *ndev, const struct brcmf_event_msg *e,
+		       bool completed)
+{
+	struct brcmf_cfg80211_connect_info *conn_info = cfg_to_conn(cfg_priv);
+	s32 err = 0;
+
+	WL_TRACE("Enter\n");
+
+	if (test_and_clear_bit(WL_STATUS_CONNECTING, &cfg_priv->status)) {
+		if (completed) {
+			brcmf_get_assoc_ies(cfg_priv);
+			brcmf_update_prof(cfg_priv, NULL, &e->addr,
+					  WL_PROF_BSSID);
+			brcmf_update_bss_info(cfg_priv);
+		}
+		cfg80211_connect_result(ndev,
+					(u8 *)brcmf_read_prof(cfg_priv,
+							      WL_PROF_BSSID),
+					conn_info->req_ie,
+					conn_info->req_ie_len,
+					conn_info->resp_ie,
+					conn_info->resp_ie_len,
+					completed ? WLAN_STATUS_SUCCESS :
+						    WLAN_STATUS_AUTH_TIMEOUT,
+					GFP_KERNEL);
+		if (completed)
+			set_bit(WL_STATUS_CONNECTED, &cfg_priv->status);
+		WL_CONN("Report connect result - connection %s\n",
+				completed ? "succeeded" : "failed");
+	}
+	WL_TRACE("Exit\n");
+	return err;
+}
+
+static s32
+brcmf_notify_connect_status(struct brcmf_cfg80211_priv *cfg_priv,
+			    struct net_device *ndev,
+			    const struct brcmf_event_msg *e, void *data)
+{
+	s32 err = 0;
+
+	if (brcmf_is_linkup(cfg_priv, e)) {
+		WL_CONN("Linkup\n");
+		if (brcmf_is_ibssmode(cfg_priv)) {
+			brcmf_update_prof(cfg_priv, NULL, (void *)e->addr,
+				WL_PROF_BSSID);
+			wl_inform_ibss(cfg_priv, ndev, e->addr);
+			cfg80211_ibss_joined(ndev, e->addr, GFP_KERNEL);
+			clear_bit(WL_STATUS_CONNECTING, &cfg_priv->status);
+			set_bit(WL_STATUS_CONNECTED, &cfg_priv->status);
+		} else
+			brcmf_bss_connect_done(cfg_priv, ndev, e, true);
+	} else if (brcmf_is_linkdown(cfg_priv, e)) {
+		WL_CONN("Linkdown\n");
+		if (brcmf_is_ibssmode(cfg_priv)) {
+			clear_bit(WL_STATUS_CONNECTING, &cfg_priv->status);
+			if (test_and_clear_bit(WL_STATUS_CONNECTED,
+				&cfg_priv->status))
+				brcmf_link_down(cfg_priv);
+		} else {
+			brcmf_bss_connect_done(cfg_priv, ndev, e, false);
+			if (test_and_clear_bit(WL_STATUS_CONNECTED,
+				&cfg_priv->status)) {
+				cfg80211_disconnected(ndev, 0, NULL, 0,
+					GFP_KERNEL);
+				brcmf_link_down(cfg_priv);
+			}
+		}
+		brcmf_init_prof(cfg_priv->profile);
+	} else if (brcmf_is_nonetwork(cfg_priv, e)) {
+		if (brcmf_is_ibssmode(cfg_priv))
+			clear_bit(WL_STATUS_CONNECTING, &cfg_priv->status);
+		else
+			brcmf_bss_connect_done(cfg_priv, ndev, e, false);
+	}
+
 	return err;
 }
 
 static s32
-brcmf_bss_connect_done(struct brcmf_cfg80211_priv *cfg_priv,
-		       struct net_device *ndev, const struct brcmf_event_msg *e,
-		       bool completed)
+brcmf_notify_roaming_status(struct brcmf_cfg80211_priv *cfg_priv,
+			    struct net_device *ndev,
+			    const struct brcmf_event_msg *e, void *data)
 {
-	struct brcmf_cfg80211_connect_info *conn_info = cfg_to_conn(cfg_priv);
 	s32 err = 0;
+	u32 event = be32_to_cpu(e->event_type);
+	u32 status = be32_to_cpu(e->status);
 
-	WL_TRACE("Enter\n");
-
-	if (test_and_clear_bit(WL_STATUS_CONNECTING, &cfg_priv->status)) {
-		if (completed) {
-			brcmf_get_assoc_ies(cfg_priv);
-			brcmf_update_prof(cfg_priv, NULL, &e->addr,
-					  WL_PROF_BSSID);
-			brcmf_update_bss_info(cfg_priv);
-		}
-		cfg80211_connect_result(ndev,
-					(u8 *)brcmf_read_prof(cfg_priv,
-							      WL_PROF_BSSID),
-					conn_info->req_ie,
-					conn_info->req_ie_len,
-					conn_info->resp_ie,
-					conn_info->resp_ie_len,
-					completed ? WLAN_STATUS_SUCCESS :
-						    WLAN_STATUS_AUTH_TIMEOUT,
-					GFP_KERNEL);
-		if (completed)
-			set_bit(WL_STATUS_CONNECTED, &cfg_priv->status);
-		WL_CONN("Report connect result - connection %s\n",
-				completed ? "succeeded" : "failed");
+	if (event == BRCMF_E_ROAM && status == BRCMF_E_STATUS_SUCCESS) {
+		if (test_bit(WL_STATUS_CONNECTED, &cfg_priv->status))
+			brcmf_bss_roaming_done(cfg_priv, ndev, e);
+		else
+			brcmf_bss_connect_done(cfg_priv, ndev, e, true);
 	}
-	WL_TRACE("Exit\n");
+
 	return err;
 }
 
@@ -3041,11 +3120,6 @@ static void brcmf_init_conf(struct brcmf_cfg80211_conf *conf)
 	conf->tx_power = -1;
 }
 
-static void brcmf_init_prof(struct brcmf_cfg80211_profile *prof)
-{
-	memset(prof, 0, sizeof(*prof));
-}
-
 static void brcmf_init_eloop_handler(struct brcmf_cfg80211_event_loop *el)
 {
 	memset(el, 0, sizeof(*el));
@@ -3056,6 +3130,28 @@ static void brcmf_init_eloop_handler(struct brcmf_cfg80211_event_loop *el)
 	el->handler[BRCMF_E_SET_SSID] = brcmf_notify_connect_status;
 }
 
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
 static s32 brcmf_init_priv_mem(struct brcmf_cfg80211_priv *cfg_priv)
 {
 	cfg_priv->scan_results = kzalloc(WL_SCAN_BUF_MAX, GFP_KERNEL);
@@ -3113,271 +3209,156 @@ init_priv_mem_out:
 	return -ENOMEM;
 }
 
-static void brcmf_deinit_priv_mem(struct brcmf_cfg80211_priv *cfg_priv)
+static void brcmf_lock_eq(struct brcmf_cfg80211_priv *cfg_priv)
 {
-	kfree(cfg_priv->scan_results);
-	cfg_priv->scan_results = NULL;
-	kfree(cfg_priv->bss_info);
-	cfg_priv->bss_info = NULL;
-	kfree(cfg_priv->conf);
-	cfg_priv->conf = NULL;
-	kfree(cfg_priv->profile);
-	cfg_priv->profile = NULL;
-	kfree(cfg_priv->scan_req_int);
-	cfg_priv->scan_req_int = NULL;
-	kfree(cfg_priv->ioctl_buf);
-	cfg_priv->ioctl_buf = NULL;
-	kfree(cfg_priv->extra_buf);
-	cfg_priv->extra_buf = NULL;
-	kfree(cfg_priv->iscan);
-	cfg_priv->iscan = NULL;
-	kfree(cfg_priv->pmk_list);
-	cfg_priv->pmk_list = NULL;
+	spin_lock_irq(&cfg_priv->eq_lock);
 }
 
-static s32 brcmf_create_event_handler(struct brcmf_cfg80211_priv *cfg_priv)
+static void brcmf_unlock_eq(struct brcmf_cfg80211_priv *cfg_priv)
 {
-	init_waitqueue_head(&cfg_priv->event_waitq);
-	cfg_priv->event_tsk = kthread_run(brcmf_event_handler, cfg_priv,
-					  "wl_event_handler");
-	if (IS_ERR(cfg_priv->event_tsk)) {
-		cfg_priv->event_tsk = NULL;
-		WL_ERR("failed to create event thread\n");
-		return -ENOMEM;
-	}
-	return 0;
+	spin_unlock_irq(&cfg_priv->eq_lock);
 }
 
-static void brcmf_destroy_event_handler(struct brcmf_cfg80211_priv *cfg_priv)
+static void brcmf_init_eq_lock(struct brcmf_cfg80211_priv *cfg_priv)
 {
-	if (cfg_priv->event_tsk) {
-		send_sig(SIGTERM, cfg_priv->event_tsk, 1);
-		kthread_stop(cfg_priv->event_tsk);
-		cfg_priv->event_tsk = NULL;
-	}
+	spin_lock_init(&cfg_priv->eq_lock);
 }
 
-static void brcmf_term_iscan(struct brcmf_cfg80211_priv *cfg_priv)
-{
-	struct brcmf_cfg80211_iscan_ctrl *iscan = cfg_to_iscan(cfg_priv);
-	struct brcmf_ssid ssid;
-
-	if (cfg_priv->iscan_on) {
-		iscan->state = WL_ISCAN_STATE_IDLE;
-
-		if (iscan->timer_on) {
-			del_timer_sync(&iscan->timer);
-			iscan->timer_on = 0;
-		}
-
-		cancel_work_sync(&iscan->work);
-
-		/* Abort iscan running in FW */
-		memset(&ssid, 0, sizeof(ssid));
-		brcmf_run_iscan(iscan, &ssid, WL_SCAN_ACTION_ABORT);
-	}
-}
+/*
+* retrieve first queued event from head
+*/
 
-static void brcmf_notify_iscan_complete(struct brcmf_cfg80211_iscan_ctrl *iscan,
-					bool aborted)
+static struct brcmf_cfg80211_event_q *brcmf_deq_event(
+	struct brcmf_cfg80211_priv *cfg_priv)
 {
-	struct brcmf_cfg80211_priv *cfg_priv = iscan_to_cfg(iscan);
-	struct net_device *ndev = cfg_to_ndev(cfg_priv);
-
-	if (unlikely(!test_and_clear_bit(WL_STATUS_SCANNING,
-					 &cfg_priv->status))) {
-		WL_ERR("Scan complete while device not scanning\n");
-		return;
-	}
-	if (likely(cfg_priv->scan_request)) {
-		WL_SCAN("ISCAN Completed scan: %s\n",
-				aborted ? "Aborted" : "Done");
-		cfg80211_scan_done(cfg_priv->scan_request, aborted);
-		brcmf_set_mpc(ndev, 1);
-		cfg_priv->scan_request = NULL;
-	}
-	cfg_priv->iscan_kickstart = false;
-}
+	struct brcmf_cfg80211_event_q *e = NULL;
 
-static s32 brcmf_wakeup_iscan(struct brcmf_cfg80211_iscan_ctrl *iscan)
-{
-	if (likely(iscan->state != WL_ISCAN_STATE_IDLE)) {
-		WL_SCAN("wake up iscan\n");
-		schedule_work(&iscan->work);
-		return 0;
+	brcmf_lock_eq(cfg_priv);
+	if (likely(!list_empty(&cfg_priv->eq_list))) {
+		e = list_first_entry(&cfg_priv->eq_list,
+				     struct brcmf_cfg80211_event_q, eq_list);
+		list_del(&e->eq_list);
 	}
+	brcmf_unlock_eq(cfg_priv);
 
-	return -EIO;
+	return e;
 }
 
+/*
+** push event to tail of the queue
+*/
+
 static s32
-brcmf_get_iscan_results(struct brcmf_cfg80211_iscan_ctrl *iscan, u32 *status,
-		     struct brcmf_scan_results **bss_list)
+brcmf_enq_event(struct brcmf_cfg80211_priv *cfg_priv, u32 event,
+		const struct brcmf_event_msg *msg)
 {
-	struct brcmf_iscan_results list;
-	struct brcmf_scan_results *results;
-	struct brcmf_iscan_results *list_buf;
+	struct brcmf_cfg80211_event_q *e;
 	s32 err = 0;
 
-	memset(iscan->scan_buf, 0, WL_ISCAN_BUF_MAX);
-	list_buf = (struct brcmf_iscan_results *)iscan->scan_buf;
-	results = &list_buf->results;
-	results->buflen = BRCMF_ISCAN_RESULTS_FIXED_SIZE;
-	results->version = 0;
-	results->count = 0;
-
-	memset(&list, 0, sizeof(list));
-	list.results.buflen = cpu_to_le32(WL_ISCAN_BUF_MAX);
-	err = brcmf_dev_iovar_getbuf(iscan->dev, "iscanresults", &list,
-				BRCMF_ISCAN_RESULTS_FIXED_SIZE, iscan->scan_buf,
-				WL_ISCAN_BUF_MAX);
-	if (unlikely(err)) {
-		WL_ERR("error (%d)\n", err);
-		return err;
+	e = kzalloc(sizeof(struct brcmf_cfg80211_event_q), GFP_KERNEL);
+	if (unlikely(!e)) {
+		WL_ERR("event alloc failed\n");
+		return -ENOMEM;
 	}
-	results->buflen = le32_to_cpu(results->buflen);
-	results->version = le32_to_cpu(results->version);
-	results->count = le32_to_cpu(results->count);
-	WL_SCAN("results->count = %d\n", results->count);
-	WL_SCAN("results->buflen = %d\n", results->buflen);
-	*status = le32_to_cpu(list_buf->status);
-	WL_SCAN("status = %d\n", *status);
-	*bss_list = results;
-
-	return err;
-}
-
-static s32 brcmf_iscan_done(struct brcmf_cfg80211_priv *cfg_priv)
-{
-	struct brcmf_cfg80211_iscan_ctrl *iscan = cfg_priv->iscan;
-	s32 err = 0;
-
-	iscan->state = WL_ISCAN_STATE_IDLE;
-	rtnl_lock();
-	brcmf_inform_bss(cfg_priv);
-	brcmf_notify_iscan_complete(iscan, false);
-	rtnl_unlock();
-
-	return err;
-}
 
-static s32 brcmf_iscan_pending(struct brcmf_cfg80211_priv *cfg_priv)
-{
-	struct brcmf_cfg80211_iscan_ctrl *iscan = cfg_priv->iscan;
-	s32 err = 0;
+	e->etype = event;
+	memcpy(&e->emsg, msg, sizeof(struct brcmf_event_msg));
 
-	/* Reschedule the timer */
-	mod_timer(&iscan->timer, jiffies + iscan->timer_ms * HZ / 1000);
-	iscan->timer_on = 1;
+	brcmf_lock_eq(cfg_priv);
+	list_add_tail(&e->eq_list, &cfg_priv->eq_list);
+	brcmf_unlock_eq(cfg_priv);
 
 	return err;
 }
 
-static s32 brcmf_iscan_inprogress(struct brcmf_cfg80211_priv *cfg_priv)
-{
-	struct brcmf_cfg80211_iscan_ctrl *iscan = cfg_priv->iscan;
-	s32 err = 0;
-
-	rtnl_lock();
-	brcmf_inform_bss(cfg_priv);
-	brcmf_run_iscan(iscan, NULL, BRCMF_SCAN_ACTION_CONTINUE);
-	rtnl_unlock();
-	/* Reschedule the timer */
-	mod_timer(&iscan->timer, jiffies + iscan->timer_ms * HZ / 1000);
-	iscan->timer_on = 1;
-
-	return err;
+static void brcmf_put_event(struct brcmf_cfg80211_event_q *e)
+{
+	kfree(e);
 }
 
-static s32 brcmf_iscan_aborted(struct brcmf_cfg80211_priv *cfg_priv)
+static s32 brcmf_event_handler(void *data)
 {
-	struct brcmf_cfg80211_iscan_ctrl *iscan = cfg_priv->iscan;
-	s32 err = 0;
+	struct brcmf_cfg80211_priv *cfg_priv =
+			(struct brcmf_cfg80211_priv *)data;
+	struct sched_param param = {.sched_priority = MAX_RT_PRIO - 1 };
+	struct brcmf_cfg80211_event_q *e;
+	DECLARE_WAITQUEUE(wait, current);
 
-	iscan->state = WL_ISCAN_STATE_IDLE;
-	rtnl_lock();
-	brcmf_notify_iscan_complete(iscan, true);
-	rtnl_unlock();
+	sched_setscheduler(current, SCHED_FIFO, &param);
+	allow_signal(SIGTERM);
+	add_wait_queue(&cfg_priv->event_waitq, &wait);
+	while (1) {
+		prepare_to_wait(&cfg_priv->event_waitq, &wait,
+				TASK_INTERRUPTIBLE);
 
-	return err;
-}
+		schedule();
 
-static void brcmf_cfg80211_iscan_handler(struct work_struct *work)
-{
-	struct brcmf_cfg80211_iscan_ctrl *iscan =
-			container_of(work, struct brcmf_cfg80211_iscan_ctrl,
-				     work);
-	struct brcmf_cfg80211_priv *cfg_priv = iscan_to_cfg(iscan);
-	struct brcmf_cfg80211_iscan_eloop *el = &iscan->el;
-	u32 status = BRCMF_SCAN_RESULTS_PARTIAL;
+		if (kthread_should_stop())
+			break;
 
-	if (iscan->timer_on) {
-		del_timer_sync(&iscan->timer);
-		iscan->timer_on = 0;
-	}
+		e = brcmf_deq_event(cfg_priv);
+		if (unlikely(!e)) {
+			WL_ERR("event queue empty...\n");
+			continue;
+		}
 
-	rtnl_lock();
-	if (brcmf_get_iscan_results(iscan, &status, &cfg_priv->bss_list)) {
-		status = BRCMF_SCAN_RESULTS_ABORTED;
-		WL_ERR("Abort iscan\n");
+		do {
+			WL_INFO("event type (%d)\n", e->etype);
+			if (cfg_priv->el.handler[e->etype])
+				cfg_priv->el.handler[e->etype](cfg_priv,
+					cfg_to_ndev(cfg_priv),
+					&e->emsg, e->edata);
+			else
+				WL_INFO("Unknown Event (%d): ignoring\n",
+					e->etype);
+			brcmf_put_event(e);
+		} while ((e = brcmf_deq_event(cfg_priv)));
 	}
-	rtnl_unlock();
-
-	el->handler[status](cfg_priv);
+	finish_wait(&cfg_priv->event_waitq, &wait);
+	WL_INFO("was terminated\n");
+	return 0;
 }
 
-static void brcmf_iscan_timer(unsigned long data)
+static s32 brcmf_create_event_handler(struct brcmf_cfg80211_priv *cfg_priv)
 {
-	struct brcmf_cfg80211_iscan_ctrl *iscan =
-			(struct brcmf_cfg80211_iscan_ctrl *)data;
-
-	if (iscan) {
-		iscan->timer_on = 0;
-		WL_SCAN("timer expired\n");
-		brcmf_wakeup_iscan(iscan);
+	init_waitqueue_head(&cfg_priv->event_waitq);
+	cfg_priv->event_tsk = kthread_run(brcmf_event_handler, cfg_priv,
+					  "wl_event_handler");
+	if (IS_ERR(cfg_priv->event_tsk)) {
+		cfg_priv->event_tsk = NULL;
+		WL_ERR("failed to create event thread\n");
+		return -ENOMEM;
 	}
+	return 0;
 }
 
-static s32 brcmf_invoke_iscan(struct brcmf_cfg80211_priv *cfg_priv)
+static void brcmf_destroy_event_handler(struct brcmf_cfg80211_priv *cfg_priv)
 {
-	struct brcmf_cfg80211_iscan_ctrl *iscan = cfg_to_iscan(cfg_priv);
-
-	if (cfg_priv->iscan_on) {
-		iscan->state = WL_ISCAN_STATE_IDLE;
-		INIT_WORK(&iscan->work, brcmf_cfg80211_iscan_handler);
+	if (cfg_priv->event_tsk) {
+		send_sig(SIGTERM, cfg_priv->event_tsk, 1);
+		kthread_stop(cfg_priv->event_tsk);
+		cfg_priv->event_tsk = NULL;
 	}
-
-	return 0;
 }
 
-static void brcmf_init_iscan_eloop(struct brcmf_cfg80211_iscan_eloop *el)
+static void brcmf_init_eq(struct brcmf_cfg80211_priv *cfg_priv)
 {
-	memset(el, 0, sizeof(*el));
-	el->handler[BRCMF_SCAN_RESULTS_SUCCESS] = brcmf_iscan_done;
-	el->handler[BRCMF_SCAN_RESULTS_PARTIAL] = brcmf_iscan_inprogress;
-	el->handler[BRCMF_SCAN_RESULTS_PENDING] = brcmf_iscan_pending;
-	el->handler[BRCMF_SCAN_RESULTS_ABORTED] = brcmf_iscan_aborted;
-	el->handler[BRCMF_SCAN_RESULTS_NO_MEM] = brcmf_iscan_aborted;
+	brcmf_init_eq_lock(cfg_priv);
+	INIT_LIST_HEAD(&cfg_priv->eq_list);
 }
 
-static s32 brcmf_init_iscan(struct brcmf_cfg80211_priv *cfg_priv)
+static void brcmf_flush_eq(struct brcmf_cfg80211_priv *cfg_priv)
 {
-	struct brcmf_cfg80211_iscan_ctrl *iscan = cfg_to_iscan(cfg_priv);
-	int err = 0;
+	struct brcmf_cfg80211_event_q *e;
 
-	if (cfg_priv->iscan_on) {
-		iscan->dev = cfg_to_ndev(cfg_priv);
-		brcmf_init_iscan_eloop(&iscan->el);
-		iscan->timer_ms = WL_ISCAN_TIMER_INTERVAL_MS;
-		init_timer(&iscan->timer);
-		iscan->timer.data = (unsigned long) iscan;
-		iscan->timer.function = brcmf_iscan_timer;
-		err = brcmf_invoke_iscan(cfg_priv);
-		if (!err)
-			iscan->data = cfg_priv;
+	brcmf_lock_eq(cfg_priv);
+	while (!list_empty(&cfg_priv->eq_list)) {
+		e = list_first_entry(&cfg_priv->eq_list,
+				     struct brcmf_cfg80211_event_q, eq_list);
+		list_del(&e->eq_list);
+		kfree(e);
 	}
-
-	return err;
+	brcmf_unlock_eq(cfg_priv);
 }
 
 static s32 wl_init_priv(struct brcmf_cfg80211_priv *cfg_priv)
@@ -3480,140 +3461,25 @@ void brcmf_cfg80211_detach(struct brcmf_cfg80211_dev *cfg_dev)
 	cfg_priv = brcmf_priv_get(cfg_dev);
 
 	wl_deinit_priv(cfg_priv);
-	brcmf_free_wdev(cfg_priv);
-	brcmf_set_drvdata(cfg_dev, NULL);
-	kfree(cfg_dev);
-}
-
-static void brcmf_wakeup_event(struct brcmf_cfg80211_priv *cfg_priv)
-{
-	wake_up(&cfg_priv->event_waitq);
-}
-
-static s32 brcmf_event_handler(void *data)
-{
-	struct brcmf_cfg80211_priv *cfg_priv =
-			(struct brcmf_cfg80211_priv *)data;
-	struct sched_param param = {.sched_priority = MAX_RT_PRIO - 1 };
-	struct brcmf_cfg80211_event_q *e;
-	DECLARE_WAITQUEUE(wait, current);
-
-	sched_setscheduler(current, SCHED_FIFO, &param);
-	allow_signal(SIGTERM);
-	add_wait_queue(&cfg_priv->event_waitq, &wait);
-	while (1) {
-		prepare_to_wait(&cfg_priv->event_waitq, &wait,
-				TASK_INTERRUPTIBLE);
-
-		schedule();
-
-		if (kthread_should_stop())
-			break;
-
-		e = brcmf_deq_event(cfg_priv);
-		if (unlikely(!e)) {
-			WL_ERR("event queue empty...\n");
-			continue;
-		}
-
-		do {
-			WL_INFO("event type (%d)\n", e->etype);
-			if (cfg_priv->el.handler[e->etype])
-				cfg_priv->el.handler[e->etype](cfg_priv,
-					cfg_to_ndev(cfg_priv),
-					&e->emsg, e->edata);
-			else
-				WL_INFO("Unknown Event (%d): ignoring\n",
-					e->etype);
-			brcmf_put_event(e);
-		} while ((e = brcmf_deq_event(cfg_priv)));
-	}
-	finish_wait(&cfg_priv->event_waitq, &wait);
-	WL_INFO("was terminated\n");
-	return 0;
-}
-
-void
-brcmf_cfg80211_event(struct net_device *ndev,
-		  const struct brcmf_event_msg *e, void *data)
-{
-	u32 event_type = be32_to_cpu(e->event_type);
-	struct brcmf_cfg80211_priv *cfg_priv = ndev_to_cfg(ndev);
-
-	if (likely(!brcmf_enq_event(cfg_priv, event_type, e)))
-		brcmf_wakeup_event(cfg_priv);
-}
-
-static void brcmf_init_eq(struct brcmf_cfg80211_priv *cfg_priv)
-{
-	brcmf_init_eq_lock(cfg_priv);
-	INIT_LIST_HEAD(&cfg_priv->eq_list);
-}
-
-static void brcmf_flush_eq(struct brcmf_cfg80211_priv *cfg_priv)
-{
-	struct brcmf_cfg80211_event_q *e;
-
-	brcmf_lock_eq(cfg_priv);
-	while (!list_empty(&cfg_priv->eq_list)) {
-		e = list_first_entry(&cfg_priv->eq_list,
-				     struct brcmf_cfg80211_event_q, eq_list);
-		list_del(&e->eq_list);
-		kfree(e);
-	}
-	brcmf_unlock_eq(cfg_priv);
-}
-
-/*
-* retrieve first queued event from head
-*/
-
-static struct brcmf_cfg80211_event_q *brcmf_deq_event(
-	struct brcmf_cfg80211_priv *cfg_priv)
-{
-	struct brcmf_cfg80211_event_q *e = NULL;
-
-	brcmf_lock_eq(cfg_priv);
-	if (likely(!list_empty(&cfg_priv->eq_list))) {
-		e = list_first_entry(&cfg_priv->eq_list,
-				     struct brcmf_cfg80211_event_q, eq_list);
-		list_del(&e->eq_list);
-	}
-	brcmf_unlock_eq(cfg_priv);
-
-	return e;
-}
-
-/*
-** push event to tail of the queue
-*/
-
-static s32
-brcmf_enq_event(struct brcmf_cfg80211_priv *cfg_priv, u32 event,
-		const struct brcmf_event_msg *msg)
-{
-	struct brcmf_cfg80211_event_q *e;
-	s32 err = 0;
-
-	e = kzalloc(sizeof(struct brcmf_cfg80211_event_q), GFP_KERNEL);
-	if (unlikely(!e)) {
-		WL_ERR("event alloc failed\n");
-		return -ENOMEM;
-	}
-
-	e->etype = event;
-	memcpy(&e->emsg, msg, sizeof(struct brcmf_event_msg));
-
-	brcmf_lock_eq(cfg_priv);
-	list_add_tail(&e->eq_list, &cfg_priv->eq_list);
-	brcmf_unlock_eq(cfg_priv);
+	brcmf_free_wdev(cfg_priv);
+	brcmf_set_drvdata(cfg_dev, NULL);
+	kfree(cfg_dev);
+}
 
-	return err;
+static void brcmf_wakeup_event(struct brcmf_cfg80211_priv *cfg_priv)
+{
+	wake_up(&cfg_priv->event_waitq);
 }
 
-static void brcmf_put_event(struct brcmf_cfg80211_event_q *e)
+void
+brcmf_cfg80211_event(struct net_device *ndev,
+		  const struct brcmf_event_msg *e, void *data)
 {
-	kfree(e);
+	u32 event_type = be32_to_cpu(e->event_type);
+	struct brcmf_cfg80211_priv *cfg_priv = ndev_to_cfg(ndev);
+
+	if (likely(!brcmf_enq_event(cfg_priv, event_type, e)))
+		brcmf_wakeup_event(cfg_priv);
 }
 
 static s32 brcmf_dongle_mode(struct net_device *ndev, s32 iftype)
@@ -3798,6 +3664,35 @@ dongle_scantime_out:
 	return err;
 }
 
+static s32 wl_update_wiphybands(struct brcmf_cfg80211_priv *cfg_priv)
+{
+	struct wiphy *wiphy;
+	s32 phy_list;
+	s8 phy;
+	s32 err = 0;
+
+	err = brcmf_dev_ioctl(cfg_to_ndev(cfg_priv), BRCM_GET_PHYLIST,
+			      &phy_list, sizeof(phy_list));
+	if (unlikely(err)) {
+		WL_ERR("error (%d)\n", err);
+		return err;
+	}
+
+	phy = ((char *)&phy_list)[1];
+	WL_INFO("%c phy\n", phy);
+	if (phy == 'n' || phy == 'a') {
+		wiphy = cfg_to_wiphy(cfg_priv);
+		wiphy->bands[IEEE80211_BAND_5GHZ] = &__wl_band_5ghz_n;
+	}
+
+	return err;
+}
+
+static s32 brcmf_dongle_probecap(struct brcmf_cfg80211_priv *cfg_priv)
+{
+	return wl_update_wiphybands(cfg_priv);
+}
+
 static s32 brcmf_config_dongle(struct brcmf_cfg80211_priv *cfg_priv,
 			       bool need_lock)
 {
@@ -3853,30 +3748,40 @@ default_conf_out:
 
 }
 
-static s32 wl_update_wiphybands(struct brcmf_cfg80211_priv *cfg_priv)
+static int brcmf_debugfs_add_netdev_params(struct brcmf_cfg80211_priv *cfg_priv)
 {
-	struct wiphy *wiphy;
-	s32 phy_list;
-	s8 phy;
+	char buf[10+IFNAMSIZ];
+	struct dentry *fd;
 	s32 err = 0;
 
-	err = brcmf_dev_ioctl(cfg_to_ndev(cfg_priv), BRCM_GET_PHYLIST,
-			      &phy_list, sizeof(phy_list));
-	if (unlikely(err)) {
-		WL_ERR("error (%d)\n", err);
-		return err;
+	sprintf(buf, "netdev:%s", cfg_to_ndev(cfg_priv)->name);
+	cfg_priv->debugfsdir = debugfs_create_dir(buf,
+					cfg_to_wiphy(cfg_priv)->debugfsdir);
+
+	fd = debugfs_create_u16("beacon_int", S_IRUGO, cfg_priv->debugfsdir,
+		(u16 *)&cfg_priv->profile->beacon_interval);
+	if (!fd) {
+		err = -ENOMEM;
+		goto err_out;
 	}
 
-	phy = ((char *)&phy_list)[1];
-	WL_INFO("%c phy\n", phy);
-	if (phy == 'n' || phy == 'a') {
-		wiphy = cfg_to_wiphy(cfg_priv);
-		wiphy->bands[IEEE80211_BAND_5GHZ] = &__wl_band_5ghz_n;
+	fd = debugfs_create_u8("dtim_period", S_IRUGO, cfg_priv->debugfsdir,
+		(u8 *)&cfg_priv->profile->dtim_period);
+	if (!fd) {
+		err = -ENOMEM;
+		goto err_out;
 	}
 
+err_out:
 	return err;
 }
 
+static void brcmf_debugfs_remove_netdev(struct brcmf_cfg80211_priv *cfg_priv)
+{
+	debugfs_remove_recursive(cfg_priv->debugfsdir);
+	cfg_priv->debugfsdir = NULL;
+}
+
 static s32 __brcmf_cfg80211_up(struct brcmf_cfg80211_priv *cfg_priv)
 {
 	s32 err = 0;
@@ -3958,71 +3863,6 @@ s32 brcmf_cfg80211_down(struct brcmf_cfg80211_dev *cfg_dev)
 	return err;
 }
 
-static s32 brcmf_dongle_probecap(struct brcmf_cfg80211_priv *cfg_priv)
-{
-	return wl_update_wiphybands(cfg_priv);
-}
-
-static void *brcmf_read_prof(struct brcmf_cfg80211_priv *cfg_priv, s32 item)
-{
-	switch (item) {
-	case WL_PROF_SEC:
-		return &cfg_priv->profile->sec;
-	case WL_PROF_BSSID:
-		return &cfg_priv->profile->bssid;
-	case WL_PROF_SSID:
-		return &cfg_priv->profile->ssid;
-	}
-	WL_ERR("invalid item (%d)\n", item);
-	return NULL;
-}
-
-static s32
-brcmf_update_prof(struct brcmf_cfg80211_priv *cfg_priv,
-		  const struct brcmf_event_msg *e, void *data, s32 item)
-{
-	s32 err = 0;
-	struct brcmf_ssid *ssid;
-
-	switch (item) {
-	case WL_PROF_SSID:
-		ssid = (struct brcmf_ssid *) data;
-		memset(cfg_priv->profile->ssid.SSID, 0,
-		       sizeof(cfg_priv->profile->ssid.SSID));
-		memcpy(cfg_priv->profile->ssid.SSID,
-		       ssid->SSID, ssid->SSID_len);
-		cfg_priv->profile->ssid.SSID_len = ssid->SSID_len;
-		break;
-	case WL_PROF_BSSID:
-		if (data)
-			memcpy(cfg_priv->profile->bssid, data, ETH_ALEN);
-		else
-			memset(cfg_priv->profile->bssid, 0, ETH_ALEN);
-		break;
-	case WL_PROF_SEC:
-		memcpy(&cfg_priv->profile->sec, data,
-		       sizeof(cfg_priv->profile->sec));
-		break;
-	case WL_PROF_BEACONINT:
-		cfg_priv->profile->beacon_interval = *(u16 *)data;
-		break;
-	case WL_PROF_DTIMPERIOD:
-		cfg_priv->profile->dtim_period = *(u8 *)data;
-		break;
-	default:
-		WL_ERR("unsupported item (%d)\n", item);
-		err = -EOPNOTSUPP;
-		break;
-	}
-
-	return err;
-}
-
-static bool brcmf_is_ibssmode(struct brcmf_cfg80211_priv *cfg_priv)
-{
-	return cfg_priv->conf->mode == WL_MODE_IBSS;
-}
-
 static __used s32 brcmf_add_ie(struct brcmf_cfg80211_priv *cfg_priv,
 			       u8 t, u8 l, u8 *v)
 {
@@ -4040,109 +3880,3 @@ static __used s32 brcmf_add_ie(struct brcmf_cfg80211_priv *cfg_priv,
 
 	return err;
 }
-
-static void brcmf_link_down(struct brcmf_cfg80211_priv *cfg_priv)
-{
-	struct net_device *dev = NULL;
-	s32 err = 0;
-
-	WL_TRACE("Enter\n");
-
-	if (cfg_priv->link_up) {
-		dev = cfg_to_ndev(cfg_priv);
-		WL_INFO("Call WLC_DISASSOC to stop excess roaming\n ");
-		err = brcmf_dev_ioctl(dev, BRCMF_C_DISASSOC, NULL, 0);
-		if (unlikely(err))
-			WL_ERR("WLC_DISASSOC failed (%d)\n", err);
-		cfg_priv->link_up = false;
-	}
-	WL_TRACE("Exit\n");
-}
-
-static void brcmf_lock_eq(struct brcmf_cfg80211_priv *cfg_priv)
-{
-	spin_lock_irq(&cfg_priv->eq_lock);
-}
-
-static void brcmf_unlock_eq(struct brcmf_cfg80211_priv *cfg_priv)
-{
-	spin_unlock_irq(&cfg_priv->eq_lock);
-}
-
-static void brcmf_init_eq_lock(struct brcmf_cfg80211_priv *cfg_priv)
-{
-	spin_lock_init(&cfg_priv->eq_lock);
-}
-
-static void brcmf_delay(u32 ms)
-{
-	if (ms < 1000 / HZ) {
-		cond_resched();
-		mdelay(ms);
-	} else {
-		msleep(ms);
-	}
-}
-
-static void brcmf_set_drvdata(struct brcmf_cfg80211_dev *dev, void *data)
-{
-	dev->driver_data = data;
-}
-
-static void *brcmf_get_drvdata(struct brcmf_cfg80211_dev *dev)
-{
-	void *data = NULL;
-
-	if (dev)
-		data = dev->driver_data;
-	return data;
-}
-
-static void brcmf_set_mpc(struct net_device *ndev, int mpc)
-{
-	s32 err = 0;
-	struct brcmf_cfg80211_priv *cfg_priv = ndev_to_cfg(ndev);
-
-	if (test_bit(WL_STATUS_READY, &cfg_priv->status)) {
-		err = brcmf_dev_intvar_set(ndev, "mpc", mpc);
-		if (unlikely(err)) {
-			WL_ERR("fail to set mpc\n");
-			return;
-		}
-		WL_INFO("MPC : %d\n", mpc);
-	}
-}
-
-static int brcmf_debugfs_add_netdev_params(struct brcmf_cfg80211_priv *cfg_priv)
-{
-	char buf[10+IFNAMSIZ];
-	struct dentry *fd;
-	s32 err = 0;
-
-	sprintf(buf, "netdev:%s", cfg_to_ndev(cfg_priv)->name);
-	cfg_priv->debugfsdir = debugfs_create_dir(buf,
-					cfg_to_wiphy(cfg_priv)->debugfsdir);
-
-	fd = debugfs_create_u16("beacon_int", S_IRUGO, cfg_priv->debugfsdir,
-		(u16 *)&cfg_priv->profile->beacon_interval);
-	if (!fd) {
-		err = -ENOMEM;
-		goto err_out;
-	}
-
-	fd = debugfs_create_u8("dtim_period", S_IRUGO, cfg_priv->debugfsdir,
-		(u8 *)&cfg_priv->profile->dtim_period);
-	if (!fd) {
-		err = -ENOMEM;
-		goto err_out;
-	}
-
-err_out:
-	return err;
-}
-
-static void brcmf_debugfs_remove_netdev(struct brcmf_cfg80211_priv *cfg_priv)
-{
-	debugfs_remove_recursive(cfg_priv->debugfsdir);
-	cfg_priv->debugfsdir = NULL;
-}
-- 
1.7.4.1



Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:3145 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753930Ab1GEUGe (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Jul 2011 16:06:34 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH v2 20/21] staging: brcm80211: rename pointer conversion
 macros in wl_cfg80211.h
Date: Tue, 5 Jul 2011 22:06:16 +0200
Message-ID: <1309896377-4425-21-git-send-email-arend@broadcom.com> (sfid-20110705_220716_695017_B948AD8C)
In-Reply-To: <1309896377-4425-1-git-send-email-arend@broadcom.com>
References: <1309896377-4425-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The data structures in fullmac driver references are made easier by
using provided macros in wl_cfg80211.h. The abbreviation 'wl' in these
macros has been replaced by cfg or the macro has been removed if used
only once.

Signed-off-by: Arend van Spriel <arend@broadcom.com>
Reviewed-by: Roland Vossen <rvossen@broadcom.com>
Reviewed-by: Franky Lin <frankyl@broadcom.com>
---
 drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c |  134 +++++++++++-----------
 drivers/staging/brcm80211/brcmfmac/wl_cfg80211.h |   23 ++---
 2 files changed, 76 insertions(+), 81 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c b/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c
index 5c858c5..d109de1 100644
--- a/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c
+++ b/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c
@@ -323,12 +323,12 @@ static void brcmf_debugfs_remove_netdev(struct brcmf_cfg80211_priv *cfg_priv);
 		WL_ERR("wl_cfg80211_dev is unavailable\n");		\
 		BUG();							\
 	}								\
-	ci_to_wl(ci);							\
+	ci->cfg_priv;							\
 })
 
 #define CHECK_SYS_UP()							\
 do {									\
-	struct brcmf_cfg80211_priv *cfg_priv = wiphy_to_wl(wiphy);	\
+	struct brcmf_cfg80211_priv *cfg_priv = wiphy_to_cfg(wiphy);	\
 	if (unlikely(!test_bit(WL_STATUS_READY, &cfg_priv->status))) {	\
 		WL_INFO("device is not ready : status (%d)\n",		\
 			(int)cfg_priv->status);				\
@@ -561,7 +561,7 @@ brcmf_cfg80211_change_iface(struct wiphy *wiphy, struct net_device *ndev,
 			 enum nl80211_iftype type, u32 *flags,
 			 struct vif_params *params)
 {
-	struct brcmf_cfg80211_priv *cfg_priv = wiphy_to_wl(wiphy);
+	struct brcmf_cfg80211_priv *cfg_priv = wiphy_to_cfg(wiphy);
 	struct wireless_dev *wdev;
 	s32 infra = 0;
 	s32 err = 0;
@@ -690,8 +690,8 @@ brcmf_run_iscan(struct brcmf_cfg80211_iscan_ctrl *iscan,
 
 static s32 brcmf_do_iscan(struct brcmf_cfg80211_priv *cfg_priv)
 {
-	struct brcmf_cfg80211_iscan_ctrl *iscan = wl_to_iscan(cfg_priv);
-	struct net_device *ndev = wl_to_ndev(cfg_priv);
+	struct brcmf_cfg80211_iscan_ctrl *iscan = cfg_to_iscan(cfg_priv);
+	struct net_device *ndev = cfg_to_ndev(cfg_priv);
 	struct brcmf_ssid ssid;
 	s32 passive_scan;
 	s32 err = 0;
@@ -702,7 +702,7 @@ static s32 brcmf_do_iscan(struct brcmf_cfg80211_priv *cfg_priv)
 	iscan->state = WL_ISCAN_STATE_SCANING;
 
 	passive_scan = cfg_priv->active_scan ? 0 : 1;
-	err = brcmf_dev_ioctl(wl_to_ndev(cfg_priv), BRCMF_C_SET_PASSIVE_SCAN,
+	err = brcmf_dev_ioctl(cfg_to_ndev(cfg_priv), BRCMF_C_SET_PASSIVE_SCAN,
 			&passive_scan, sizeof(passive_scan));
 	if (unlikely(err)) {
 		WL_ERR("error (%d)\n", err);
@@ -722,9 +722,9 @@ __brcmf_cfg80211_scan(struct wiphy *wiphy, struct net_device *ndev,
 		   struct cfg80211_scan_request *request,
 		   struct cfg80211_ssid *this_ssid)
 {
-	struct brcmf_cfg80211_priv *cfg_priv = ndev_to_wl(ndev);
+	struct brcmf_cfg80211_priv *cfg_priv = ndev_to_cfg(ndev);
 	struct cfg80211_ssid *ssids;
-	struct brcmf_cfg80211_scan_req *sr = wl_to_sr(cfg_priv);
+	struct brcmf_cfg80211_scan_req *sr = cfg_priv->scan_req_int;
 	s32 passive_scan;
 	bool iscan_req;
 	bool spec_scan;
@@ -908,8 +908,8 @@ static s32 brcmf_set_retry(struct net_device *dev, u32 retry, bool l)
 
 static s32 brcmf_cfg80211_set_wiphy_params(struct wiphy *wiphy, u32 changed)
 {
-	struct brcmf_cfg80211_priv *cfg_priv = wiphy_to_wl(wiphy);
-	struct net_device *ndev = wl_to_ndev(cfg_priv);
+	struct brcmf_cfg80211_priv *cfg_priv = wiphy_to_cfg(wiphy);
+	struct net_device *ndev = cfg_to_ndev(cfg_priv);
 	s32 err = 0;
 
 	WL_TRACE("Enter\n");
@@ -953,7 +953,7 @@ static s32
 brcmf_cfg80211_join_ibss(struct wiphy *wiphy, struct net_device *dev,
 		      struct cfg80211_ibss_params *params)
 {
-	struct brcmf_cfg80211_priv *cfg_priv = wiphy_to_wl(wiphy);
+	struct brcmf_cfg80211_priv *cfg_priv = wiphy_to_cfg(wiphy);
 	struct brcmf_join_params join_params;
 	size_t join_params_size = 0;
 	s32 err = 0;
@@ -1096,7 +1096,7 @@ done:
 
 static s32 brcmf_cfg80211_leave_ibss(struct wiphy *wiphy, struct net_device *dev)
 {
-	struct brcmf_cfg80211_priv *cfg_priv = wiphy_to_wl(wiphy);
+	struct brcmf_cfg80211_priv *cfg_priv = wiphy_to_cfg(wiphy);
 	s32 err = 0;
 
 	WL_TRACE("Enter\n");
@@ -1112,7 +1112,7 @@ static s32 brcmf_cfg80211_leave_ibss(struct wiphy *wiphy, struct net_device *dev
 static s32
 brcmf_set_wpa_version(struct net_device *dev, struct cfg80211_connect_params *sme)
 {
-	struct brcmf_cfg80211_priv *cfg_priv = ndev_to_wl(dev);
+	struct brcmf_cfg80211_priv *cfg_priv = ndev_to_cfg(dev);
 	struct brcmf_cfg80211_security *sec;
 	s32 val = 0;
 	s32 err = 0;
@@ -1137,7 +1137,7 @@ brcmf_set_wpa_version(struct net_device *dev, struct cfg80211_connect_params *sm
 static s32
 brcmf_set_auth_type(struct net_device *dev, struct cfg80211_connect_params *sme)
 {
-	struct brcmf_cfg80211_priv *cfg_priv = ndev_to_wl(dev);
+	struct brcmf_cfg80211_priv *cfg_priv = ndev_to_cfg(dev);
 	struct brcmf_cfg80211_security *sec;
 	s32 val = 0;
 	s32 err = 0;
@@ -1176,7 +1176,7 @@ brcmf_set_auth_type(struct net_device *dev, struct cfg80211_connect_params *sme)
 static s32
 brcmf_set_set_cipher(struct net_device *dev, struct cfg80211_connect_params *sme)
 {
-	struct brcmf_cfg80211_priv *cfg_priv = ndev_to_wl(dev);
+	struct brcmf_cfg80211_priv *cfg_priv = ndev_to_cfg(dev);
 	struct brcmf_cfg80211_security *sec;
 	s32 pval = 0;
 	s32 gval = 0;
@@ -1242,7 +1242,7 @@ brcmf_set_set_cipher(struct net_device *dev, struct cfg80211_connect_params *sme
 static s32
 brcmf_set_key_mgmt(struct net_device *dev, struct cfg80211_connect_params *sme)
 {
-	struct brcmf_cfg80211_priv *cfg_priv = ndev_to_wl(dev);
+	struct brcmf_cfg80211_priv *cfg_priv = ndev_to_cfg(dev);
 	struct brcmf_cfg80211_security *sec;
 	s32 val = 0;
 	s32 err = 0;
@@ -1298,7 +1298,7 @@ static s32
 brcmf_set_set_sharedkey(struct net_device *dev,
 		     struct cfg80211_connect_params *sme)
 {
-	struct brcmf_cfg80211_priv *cfg_priv = ndev_to_wl(dev);
+	struct brcmf_cfg80211_priv *cfg_priv = ndev_to_cfg(dev);
 	struct brcmf_cfg80211_security *sec;
 	struct brcmf_wsec_key key;
 	s32 val;
@@ -1364,7 +1364,7 @@ static s32
 brcmf_cfg80211_connect(struct wiphy *wiphy, struct net_device *dev,
 		    struct cfg80211_connect_params *sme)
 {
-	struct brcmf_cfg80211_priv *cfg_priv = wiphy_to_wl(wiphy);
+	struct brcmf_cfg80211_priv *cfg_priv = wiphy_to_cfg(wiphy);
 	struct ieee80211_channel *chan = sme->channel;
 	struct brcmf_join_params join_params;
 	size_t join_params_size;
@@ -1462,7 +1462,7 @@ static s32
 brcmf_cfg80211_disconnect(struct wiphy *wiphy, struct net_device *dev,
 		       u16 reason_code)
 {
-	struct brcmf_cfg80211_priv *cfg_priv = wiphy_to_wl(wiphy);
+	struct brcmf_cfg80211_priv *cfg_priv = wiphy_to_cfg(wiphy);
 	struct brcmf_scb_val scbval;
 	s32 err = 0;
 
@@ -1490,8 +1490,8 @@ brcmf_cfg80211_set_tx_power(struct wiphy *wiphy,
 			 enum nl80211_tx_power_setting type, s32 dbm)
 {
 
-	struct brcmf_cfg80211_priv *cfg_priv = wiphy_to_wl(wiphy);
-	struct net_device *ndev = wl_to_ndev(cfg_priv);
+	struct brcmf_cfg80211_priv *cfg_priv = wiphy_to_cfg(wiphy);
+	struct net_device *ndev = cfg_to_ndev(cfg_priv);
 	u16 txpwrmw;
 	s32 err = 0;
 	s32 disable = 0;
@@ -1541,8 +1541,8 @@ done:
 
 static s32 brcmf_cfg80211_get_tx_power(struct wiphy *wiphy, s32 *dbm)
 {
-	struct brcmf_cfg80211_priv *cfg_priv = wiphy_to_wl(wiphy);
-	struct net_device *ndev = wl_to_ndev(cfg_priv);
+	struct brcmf_cfg80211_priv *cfg_priv = wiphy_to_cfg(wiphy);
+	struct net_device *ndev = cfg_to_ndev(cfg_priv);
 	s32 txpwrdbm;
 	u8 result;
 	s32 err = 0;
@@ -1850,7 +1850,7 @@ brcmf_cfg80211_get_key(struct wiphy *wiphy, struct net_device *dev,
 {
 	struct key_params params;
 	struct brcmf_wsec_key key;
-	struct brcmf_cfg80211_priv *cfg_priv = wiphy_to_wl(wiphy);
+	struct brcmf_cfg80211_priv *cfg_priv = wiphy_to_cfg(wiphy);
 	struct brcmf_cfg80211_security *sec;
 	s32 wsec;
 	s32 err = 0;
@@ -1919,7 +1919,7 @@ static s32
 brcmf_cfg80211_get_station(struct wiphy *wiphy, struct net_device *dev,
 			u8 *mac, struct station_info *sinfo)
 {
-	struct brcmf_cfg80211_priv *cfg_priv = wiphy_to_wl(wiphy);
+	struct brcmf_cfg80211_priv *cfg_priv = wiphy_to_cfg(wiphy);
 	struct brcmf_scb_val scb_val;
 	int rssi;
 	s32 rate;
@@ -2082,7 +2082,7 @@ done:
 
 static s32 brcmf_cfg80211_resume(struct wiphy *wiphy)
 {
-	struct brcmf_cfg80211_priv *cfg_priv = wiphy_to_wl(wiphy);
+	struct brcmf_cfg80211_priv *cfg_priv = wiphy_to_cfg(wiphy);
 
 	/*
 	 * Check for WL_STATUS_READY before any function call which
@@ -2096,7 +2096,7 @@ static s32 brcmf_cfg80211_resume(struct wiphy *wiphy)
 #endif	/*  defined(CONFIG_PM_SLEEP) */
 
 	if (test_bit(WL_STATUS_READY, &cfg_priv->status))
-		brcmf_invoke_iscan(wiphy_to_wl(wiphy));
+		brcmf_invoke_iscan(wiphy_to_cfg(wiphy));
 
 	WL_TRACE("Exit\n");
 	return 0;
@@ -2105,8 +2105,8 @@ static s32 brcmf_cfg80211_resume(struct wiphy *wiphy)
 static s32 brcmf_cfg80211_suspend(struct wiphy *wiphy,
 				  struct cfg80211_wowlan *wow)
 {
-	struct brcmf_cfg80211_priv *cfg_priv = wiphy_to_wl(wiphy);
-	struct net_device *ndev = wl_to_ndev(cfg_priv);
+	struct brcmf_cfg80211_priv *cfg_priv = wiphy_to_cfg(wiphy);
+	struct net_device *ndev = cfg_to_ndev(cfg_priv);
 
 	WL_TRACE("Enter\n");
 
@@ -2190,7 +2190,7 @@ static s32
 brcmf_cfg80211_set_pmksa(struct wiphy *wiphy, struct net_device *dev,
 			 struct cfg80211_pmksa *pmksa)
 {
-	struct brcmf_cfg80211_priv *cfg_priv = wiphy_to_wl(wiphy);
+	struct brcmf_cfg80211_priv *cfg_priv = wiphy_to_cfg(wiphy);
 	struct _pmkid_list *pmkids = &cfg_priv->pmk_list->pmkids;
 	s32 err = 0;
 	int i;
@@ -2224,7 +2224,7 @@ static s32
 brcmf_cfg80211_del_pmksa(struct wiphy *wiphy, struct net_device *dev,
 		      struct cfg80211_pmksa *pmksa)
 {
-	struct brcmf_cfg80211_priv *cfg_priv = wiphy_to_wl(wiphy);
+	struct brcmf_cfg80211_priv *cfg_priv = wiphy_to_cfg(wiphy);
 	struct _pmkid_list pmkid;
 	s32 err = 0;
 	int i;
@@ -2271,7 +2271,7 @@ brcmf_cfg80211_del_pmksa(struct wiphy *wiphy, struct net_device *dev,
 static s32
 brcmf_cfg80211_flush_pmksa(struct wiphy *wiphy, struct net_device *dev)
 {
-	struct brcmf_cfg80211_priv *cfg_priv = wiphy_to_wl(wiphy);
+	struct brcmf_cfg80211_priv *cfg_priv = wiphy_to_cfg(wiphy);
 	s32 err = 0;
 
 	WL_TRACE("Enter\n");
@@ -2387,7 +2387,7 @@ wiphy_new_out:
 
 static void brcmf_free_wdev(struct brcmf_cfg80211_priv *cfg_priv)
 {
-	struct wireless_dev *wdev = wl_to_wdev(cfg_priv);
+	struct wireless_dev *wdev = cfg_to_wdev(cfg_priv);
 
 	if (unlikely(!wdev)) {
 		WL_ERR("wdev is invalid\n");
@@ -2396,7 +2396,7 @@ static void brcmf_free_wdev(struct brcmf_cfg80211_priv *cfg_priv)
 	wiphy_unregister(wdev->wiphy);
 	wiphy_free(wdev->wiphy);
 	kfree(wdev);
-	wl_to_wdev(cfg_priv) = NULL;
+	cfg_to_wdev(cfg_priv) = NULL;
 }
 
 static s32 brcmf_inform_bss(struct brcmf_cfg80211_priv *cfg_priv)
@@ -2426,7 +2426,7 @@ static s32 brcmf_inform_bss(struct brcmf_cfg80211_priv *cfg_priv)
 static s32 brcmf_inform_single_bss(struct brcmf_cfg80211_priv *cfg_priv,
 				   struct brcmf_bss_info *bi)
 {
-	struct wiphy *wiphy = wl_to_wiphy(cfg_priv);
+	struct wiphy *wiphy = cfg_to_wiphy(cfg_priv);
 	struct ieee80211_channel *notify_channel;
 	struct cfg80211_bss *bss;
 	struct ieee80211_supported_band *band;
@@ -2487,7 +2487,7 @@ static s32 brcmf_inform_single_bss(struct brcmf_cfg80211_priv *cfg_priv,
 static s32 wl_inform_ibss(struct brcmf_cfg80211_priv *cfg_priv,
 			  struct net_device *dev, const u8 *bssid)
 {
-	struct wiphy *wiphy = wl_to_wiphy(cfg_priv);
+	struct wiphy *wiphy = cfg_to_wiphy(cfg_priv);
 	struct ieee80211_channel *notify_channel;
 	struct brcmf_bss_info *bi = NULL;
 	struct ieee80211_supported_band *band;
@@ -2674,7 +2674,7 @@ brcmf_notify_roaming_status(struct brcmf_cfg80211_priv *cfg_priv,
 static __used s32
 brcmf_dev_bufvar_set(struct net_device *dev, s8 *name, s8 *buf, s32 len)
 {
-	struct brcmf_cfg80211_priv *cfg_priv = ndev_to_wl(dev);
+	struct brcmf_cfg80211_priv *cfg_priv = ndev_to_cfg(dev);
 	u32 buflen;
 
 	buflen = brcmu_mkiovar(name, buf, len, cfg_priv->ioctl_buf,
@@ -2689,7 +2689,7 @@ static s32
 brcmf_dev_bufvar_get(struct net_device *dev, s8 *name, s8 *buf,
 		  s32 buf_len)
 {
-	struct brcmf_cfg80211_priv *cfg_priv = ndev_to_wl(dev);
+	struct brcmf_cfg80211_priv *cfg_priv = ndev_to_cfg(dev);
 	u32 len;
 	s32 err = 0;
 
@@ -2709,9 +2709,9 @@ brcmf_dev_bufvar_get(struct net_device *dev, s8 *name, s8 *buf,
 
 static s32 brcmf_get_assoc_ies(struct brcmf_cfg80211_priv *cfg_priv)
 {
-	struct net_device *ndev = wl_to_ndev(cfg_priv);
+	struct net_device *ndev = cfg_to_ndev(cfg_priv);
 	struct brcmf_cfg80211_assoc_ielen *assoc_info;
-	struct brcmf_cfg80211_connect_info *conn_info = wl_to_conn(cfg_priv);
+	struct brcmf_cfg80211_connect_info *conn_info = cfg_to_conn(cfg_priv);
 	u32 req_len;
 	u32 resp_len;
 	s32 err = 0;
@@ -2767,7 +2767,7 @@ static s32 brcmf_get_assoc_ies(struct brcmf_cfg80211_priv *cfg_priv)
 
 static void brcmf_clear_assoc_ies(struct brcmf_cfg80211_priv *cfg_priv)
 {
-	struct brcmf_cfg80211_connect_info *conn_info = wl_to_conn(cfg_priv);
+	struct brcmf_cfg80211_connect_info *conn_info = cfg_to_conn(cfg_priv);
 
 	kfree(conn_info->req_ie);
 	conn_info->req_ie = NULL;
@@ -2830,7 +2830,7 @@ static s32 brcmf_update_bss_info(struct brcmf_cfg80211_priv *cfg_priv)
 	ssid = (struct brcmf_ssid *)brcmf_read_prof(cfg_priv, WL_PROF_SSID);
 
 	*(u32 *)cfg_priv->extra_buf = cpu_to_le32(WL_EXTRA_BUF_MAX);
-	err = brcmf_dev_ioctl(wl_to_ndev(cfg_priv), BRCMF_C_GET_BSS_INFO,
+	err = brcmf_dev_ioctl(cfg_to_ndev(cfg_priv), BRCMF_C_GET_BSS_INFO,
 			cfg_priv->extra_buf, WL_EXTRA_BUF_MAX);
 	if (unlikely(err)) {
 		WL_ERR("Could not get bss info %d\n", err);
@@ -2856,7 +2856,7 @@ static s32 brcmf_update_bss_info(struct brcmf_cfg80211_priv *cfg_priv)
 		* so we speficially query dtim information to dongle.
 		*/
 		u32 var;
-		err = brcmf_dev_intvar_get(wl_to_ndev(cfg_priv),
+		err = brcmf_dev_intvar_get(cfg_to_ndev(cfg_priv),
 					   "dtim_assoc", &var);
 		if (unlikely(err)) {
 			WL_ERR("wl dtim_assoc failed (%d)\n", err);
@@ -2878,7 +2878,7 @@ brcmf_bss_roaming_done(struct brcmf_cfg80211_priv *cfg_priv,
 		       struct net_device *ndev,
 		       const struct brcmf_event_msg *e, void *data)
 {
-	struct brcmf_cfg80211_connect_info *conn_info = wl_to_conn(cfg_priv);
+	struct brcmf_cfg80211_connect_info *conn_info = cfg_to_conn(cfg_priv);
 	s32 err = 0;
 
 	WL_TRACE("Enter\n");
@@ -2903,7 +2903,7 @@ brcmf_bss_connect_done(struct brcmf_cfg80211_priv *cfg_priv,
 		       struct net_device *ndev, const struct brcmf_event_msg *e,
 		       void *data, bool completed)
 {
-	struct brcmf_cfg80211_connect_info *conn_info = wl_to_conn(cfg_priv);
+	struct brcmf_cfg80211_connect_info *conn_info = cfg_to_conn(cfg_priv);
 	s32 err = 0;
 
 	WL_TRACE("Enter\n");
@@ -2970,7 +2970,7 @@ brcmf_notify_scan_status(struct brcmf_cfg80211_priv *cfg_priv,
 
 	if (cfg_priv->iscan_on && cfg_priv->iscan_kickstart) {
 		WL_TRACE("Exit\n");
-		return brcmf_wakeup_iscan(wl_to_iscan(cfg_priv));
+		return brcmf_wakeup_iscan(cfg_to_iscan(cfg_priv));
 	}
 
 	if (unlikely(!test_and_clear_bit(WL_STATUS_SCANNING,
@@ -3157,7 +3157,7 @@ static void brcmf_destroy_event_handler(struct brcmf_cfg80211_priv *cfg_priv)
 
 static void brcmf_term_iscan(struct brcmf_cfg80211_priv *cfg_priv)
 {
-	struct brcmf_cfg80211_iscan_ctrl *iscan = wl_to_iscan(cfg_priv);
+	struct brcmf_cfg80211_iscan_ctrl *iscan = cfg_to_iscan(cfg_priv);
 
 	if (cfg_priv->iscan_on && iscan->tsk) {
 		iscan->state = WL_ISCAN_STATE_IDLE;
@@ -3170,8 +3170,8 @@ static void brcmf_term_iscan(struct brcmf_cfg80211_priv *cfg_priv)
 static void brcmf_notify_iscan_complete(struct brcmf_cfg80211_iscan_ctrl *iscan,
 					bool aborted)
 {
-	struct brcmf_cfg80211_priv *cfg_priv = iscan_to_wl(iscan);
-	struct net_device *ndev = wl_to_ndev(cfg_priv);
+	struct brcmf_cfg80211_priv *cfg_priv = iscan_to_cfg(iscan);
+	struct net_device *ndev = cfg_to_ndev(cfg_priv);
 
 	if (unlikely(!test_and_clear_bit(WL_STATUS_SCANNING,
 					 &cfg_priv->status))) {
@@ -3295,7 +3295,7 @@ static s32 brcmf_iscan_thread(void *data)
 	struct sched_param param = {.sched_priority = MAX_RT_PRIO - 1 };
 	struct brcmf_cfg80211_iscan_ctrl *iscan =
 			(struct brcmf_cfg80211_iscan_ctrl *)data;
-	struct brcmf_cfg80211_priv *cfg_priv = iscan_to_wl(iscan);
+	struct brcmf_cfg80211_priv *cfg_priv = iscan_to_cfg(iscan);
 	struct brcmf_cfg80211_iscan_eloop *el = &iscan->el;
 	u32 status;
 	int err = 0;
@@ -3343,7 +3343,7 @@ static void brcmf_iscan_timer(unsigned long data)
 
 static s32 brcmf_invoke_iscan(struct brcmf_cfg80211_priv *cfg_priv)
 {
-	struct brcmf_cfg80211_iscan_ctrl *iscan = wl_to_iscan(cfg_priv);
+	struct brcmf_cfg80211_iscan_ctrl *iscan = cfg_to_iscan(cfg_priv);
 	int err = 0;
 
 	if (cfg_priv->iscan_on && !iscan->tsk) {
@@ -3372,11 +3372,11 @@ static void brcmf_init_iscan_eloop(struct brcmf_cfg80211_iscan_eloop *el)
 
 static s32 brcmf_init_iscan(struct brcmf_cfg80211_priv *cfg_priv)
 {
-	struct brcmf_cfg80211_iscan_ctrl *iscan = wl_to_iscan(cfg_priv);
+	struct brcmf_cfg80211_iscan_ctrl *iscan = cfg_to_iscan(cfg_priv);
 	int err = 0;
 
 	if (cfg_priv->iscan_on) {
-		iscan->dev = wl_to_ndev(cfg_priv);
+		iscan->dev = cfg_to_ndev(cfg_priv);
 		iscan->state = WL_ISCAN_STATE_IDLE;
 		brcmf_init_iscan_eloop(&iscan->el);
 		iscan->timer_ms = WL_ISCAN_TIMER_INTERVAL_MS;
@@ -3398,7 +3398,7 @@ static s32 brcmf_init_iscan(struct brcmf_cfg80211_priv *cfg_priv)
 
 static s32 wl_init_priv(struct brcmf_cfg80211_priv *cfg_priv)
 {
-	struct wiphy *wiphy = wl_to_wiphy(cfg_priv);
+	struct wiphy *wiphy = cfg_to_wiphy(cfg_priv);
 	s32 err = 0;
 
 	cfg_priv->scan_request = NULL;
@@ -3463,10 +3463,10 @@ s32 wl_cfg80211_attach(struct net_device *ndev, void *data)
 		return -ENOMEM;
 
 	wdev->iftype = brcmf_mode_to_nl80211_iftype(WL_MODE_BSS);
-	cfg_priv = wdev_to_wl(wdev);
+	cfg_priv = wdev_to_cfg(wdev);
 	cfg_priv->wdev = wdev;
 	cfg_priv->pub = data;
-	ci = (struct brcmf_cfg80211_iface *)wl_to_ci(cfg_priv);
+	ci = (struct brcmf_cfg80211_iface *)&cfg_priv->ci;
 	ci->cfg_priv = cfg_priv;
 	ndev->ieee80211_ptr = wdev;
 	SET_NETDEV_DEV(ndev, wiphy_dev(wdev->wiphy));
@@ -3524,7 +3524,7 @@ static s32 brcmf_event_handler(void *data)
 		WL_INFO("event type (%d)\n", e->etype);
 		if (cfg_priv->el.handler[e->etype]) {
 			cfg_priv->el.handler[e->etype](cfg_priv,
-						       wl_to_ndev(cfg_priv),
+						       cfg_to_ndev(cfg_priv),
 						       &e->emsg, e->edata);
 		} else {
 			WL_INFO("Unknown Event (%d): ignoring\n", e->etype);
@@ -3540,7 +3540,7 @@ wl_cfg80211_event(struct net_device *ndev,
 		  const struct brcmf_event_msg *e, void *data)
 {
 	u32 event_type = be32_to_cpu(e->event_type);
-	struct brcmf_cfg80211_priv *cfg_priv = ndev_to_wl(ndev);
+	struct brcmf_cfg80211_priv *cfg_priv = ndev_to_cfg(ndev);
 
 	if (likely(!brcmf_enq_event(cfg_priv, event_type, e, data)))
 		brcmf_wakeup_event(cfg_priv);
@@ -3825,7 +3825,7 @@ s32 brcmf_config_dongle(struct brcmf_cfg80211_priv *cfg_priv, bool need_lock)
 	if (cfg_priv->dongle_up)
 		return err;
 
-	ndev = wl_to_ndev(cfg_priv);
+	ndev = cfg_to_ndev(cfg_priv);
 	wdev = ndev->ieee80211_ptr;
 	if (need_lock)
 		rtnl_lock();
@@ -3866,7 +3866,7 @@ static s32 wl_update_wiphybands(struct brcmf_cfg80211_priv *cfg_priv)
 	s8 phy;
 	s32 err = 0;
 
-	err = brcmf_dev_ioctl(wl_to_ndev(cfg_priv), WLC_GET_PHYLIST, &phy_list,
+	err = brcmf_dev_ioctl(cfg_to_ndev(cfg_priv), WLC_GET_PHYLIST, &phy_list,
 			sizeof(phy_list));
 	if (unlikely(err)) {
 		WL_ERR("error (%d)\n", err);
@@ -3876,7 +3876,7 @@ static s32 wl_update_wiphybands(struct brcmf_cfg80211_priv *cfg_priv)
 	phy = ((char *)&phy_list)[1];
 	WL_INFO("%c phy\n", phy);
 	if (phy == 'n' || phy == 'a') {
-		wiphy = wl_to_wiphy(cfg_priv);
+		wiphy = cfg_to_wiphy(cfg_priv);
 		wiphy->bands[IEEE80211_BAND_5GHZ] = &__wl_band_5ghz_n;
 	}
 
@@ -3926,7 +3926,7 @@ static s32 __brcmf_cfg80211_down(struct brcmf_cfg80211_priv *cfg_priv)
 	if (cfg_priv->scan_request) {
 		cfg80211_scan_done(cfg_priv->scan_request, true);
 		/* May need to perform this to cover rmmod */
-		/* wl_set_mpc(wl_to_ndev(wl), 1); */
+		/* wl_set_mpc(cfg_to_ndev(wl), 1); */
 		cfg_priv->scan_request = NULL;
 	}
 	clear_bit(WL_STATUS_READY, &cfg_priv->status);
@@ -4032,7 +4032,7 @@ static bool brcmf_is_ibssmode(struct brcmf_cfg80211_priv *cfg_priv)
 static __used s32 brcmf_add_ie(struct brcmf_cfg80211_priv *cfg_priv,
 			       u8 t, u8 l, u8 *v)
 {
-	struct brcmf_cfg80211_ie *ie = wl_to_ie(cfg_priv);
+	struct brcmf_cfg80211_ie *ie = &cfg_priv->ie;
 	s32 err = 0;
 
 	if (unlikely(ie->offset + l + 2 > WL_TLV_INFO_MAX)) {
@@ -4055,7 +4055,7 @@ static void brcmf_link_down(struct brcmf_cfg80211_priv *cfg_priv)
 	WL_TRACE("Enter\n");
 
 	if (cfg_priv->link_up) {
-		dev = wl_to_ndev(cfg_priv);
+		dev = cfg_to_ndev(cfg_priv);
 		WL_INFO("Call WLC_DISASSOC to stop excess roaming\n ");
 		err = brcmf_dev_ioctl(dev, BRCMF_C_DISASSOC, NULL, 0);
 		if (unlikely(err))
@@ -4107,7 +4107,7 @@ static void *brcmf_get_drvdata(struct brcmf_cfg80211_dev *dev)
 static void brcmf_set_mpc(struct net_device *ndev, int mpc)
 {
 	s32 err = 0;
-	struct brcmf_cfg80211_priv *cfg_priv = ndev_to_wl(ndev);
+	struct brcmf_cfg80211_priv *cfg_priv = ndev_to_cfg(ndev);
 
 	if (test_bit(WL_STATUS_READY, &cfg_priv->status)) {
 		err = brcmf_dev_intvar_set(ndev, "mpc", mpc);
@@ -4125,9 +4125,9 @@ static int brcmf_debugfs_add_netdev_params(struct brcmf_cfg80211_priv *cfg_priv)
 	struct dentry *fd;
 	s32 err = 0;
 
-	sprintf(buf, "netdev:%s", wl_to_ndev(cfg_priv)->name);
+	sprintf(buf, "netdev:%s", cfg_to_ndev(cfg_priv)->name);
 	cfg_priv->debugfsdir = debugfs_create_dir(buf,
-					wl_to_wiphy(cfg_priv)->debugfsdir);
+					cfg_to_wiphy(cfg_priv)->debugfsdir);
 
 	fd = debugfs_create_u16("beacon_int", S_IRUGO, cfg_priv->debugfsdir,
 		(u16 *)&cfg_priv->profile->beacon_interval);
diff --git a/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.h b/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.h
index e2f41ab..3ee7a3f 100644
--- a/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.h
+++ b/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.h
@@ -321,20 +321,15 @@ struct brcmf_cfg80211_priv {
 	u8 ci[0] __attribute__ ((__aligned__(NETDEV_ALIGN)));
 };
 
-#define wl_to_dev(w) (wiphy_dev(wl->wdev->wiphy))
-#define wl_to_wiphy(w) (w->wdev->wiphy)
-#define wiphy_to_wl(w) ((struct brcmf_cfg80211_priv *)(wiphy_priv(w)))
-#define wl_to_wdev(w) (w->wdev)
-#define wdev_to_wl(w) ((struct brcmf_cfg80211_priv *)(wdev_priv(w)))
-#define wl_to_ndev(w) (w->wdev->netdev)
-#define ndev_to_wl(n) (wdev_to_wl(n->ieee80211_ptr))
-#define ci_to_wl(c) (ci->cfg_priv)
-#define wl_to_ci(w) (&w->ci)
-#define wl_to_sr(w) (w->scan_req_int)
-#define wl_to_ie(w) (&w->ie)
-#define iscan_to_wl(i) ((struct brcmf_cfg80211_priv *)(i->data))
-#define wl_to_iscan(w) (w->iscan)
-#define wl_to_conn(w) (&w->conn_info)
+#define cfg_to_wiphy(w) (w->wdev->wiphy)
+#define wiphy_to_cfg(w) ((struct brcmf_cfg80211_priv *)(wiphy_priv(w)))
+#define cfg_to_wdev(w) (w->wdev)
+#define wdev_to_cfg(w) ((struct brcmf_cfg80211_priv *)(wdev_priv(w)))
+#define cfg_to_ndev(w) (w->wdev->netdev)
+#define ndev_to_cfg(n) (wdev_to_cfg(n->ieee80211_ptr))
+#define iscan_to_cfg(i) ((struct brcmf_cfg80211_priv *)(i->data))
+#define cfg_to_iscan(w) (w->iscan)
+#define cfg_to_conn(w) (&w->conn_info)
 
 static inline struct brcmf_bss_info *next_bss(struct brcmf_scan_results *list,
 					   struct brcmf_bss_info *bss)
-- 
1.7.4.1



Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:4532 "EHLO mms3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756211Ab2JVUz6 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Oct 2012 16:55:58 -0400
From: "Franky Lin" <frankyl@broadcom.com>
To: linville@tuxdriver.com
cc: linux-wireless@vger.kernel.org,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 02/12] brcmfmac: store profile information per virtual
 interface
Date: Mon, 22 Oct 2012 13:55:31 -0700
Message-ID: <1350939341-17687-3-git-send-email-frankyl@broadcom.com> (sfid-20121022_225616_369164_2CC5FF91)
In-Reply-To: <1350939341-17687-1-git-send-email-frankyl@broadcom.com>
References: <1350939341-17687-1-git-send-email-frankyl@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Arend van Spriel <arend@broadcom.com>

The profile information applies to an interface so each virtual
interface needs it. So it is removed from brcmf_cfg80211_info
and added to brcmf_cfg80211_vif structure.

Reviewed-by: Hante Meuleman <meuleman@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
Signed-off-by: Franky Lin <frankyl@broadcom.com>
---
 .../net/wireless/brcm80211/brcmfmac/wl_cfg80211.c  |   59 +++++++++-----------
 .../net/wireless/brcm80211/brcmfmac/wl_cfg80211.h  |   10 +++-
 2 files changed, 34 insertions(+), 35 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
index 21d6ab3..d01396d 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
@@ -1189,7 +1189,7 @@ brcmf_cfg80211_join_ibss(struct wiphy *wiphy, struct net_device *ndev,
 		      struct cfg80211_ibss_params *params)
 {
 	struct brcmf_cfg80211_info *cfg = wiphy_to_cfg(wiphy);
-	struct brcmf_cfg80211_profile *profile = cfg->profile;
+	struct brcmf_cfg80211_profile *profile = ndev_to_prof(ndev);
 	struct brcmf_join_params join_params;
 	size_t join_params_size = 0;
 	s32 err = 0;
@@ -1348,8 +1348,7 @@ brcmf_cfg80211_leave_ibss(struct wiphy *wiphy, struct net_device *ndev)
 static s32 brcmf_set_wpa_version(struct net_device *ndev,
 				 struct cfg80211_connect_params *sme)
 {
-	struct brcmf_cfg80211_info *cfg = ndev_to_cfg(ndev);
-	struct brcmf_cfg80211_profile *profile = cfg->profile;
+	struct brcmf_cfg80211_profile *profile = ndev_to_prof(ndev);
 	struct brcmf_cfg80211_security *sec;
 	s32 val = 0;
 	s32 err = 0;
@@ -1374,8 +1373,7 @@ static s32 brcmf_set_wpa_version(struct net_device *ndev,
 static s32 brcmf_set_auth_type(struct net_device *ndev,
 			       struct cfg80211_connect_params *sme)
 {
-	struct brcmf_cfg80211_info *cfg = ndev_to_cfg(ndev);
-	struct brcmf_cfg80211_profile *profile = cfg->profile;
+	struct brcmf_cfg80211_profile *profile = ndev_to_prof(ndev);
 	struct brcmf_cfg80211_security *sec;
 	s32 val = 0;
 	s32 err = 0;
@@ -1415,8 +1413,7 @@ static s32
 brcmf_set_set_cipher(struct net_device *ndev,
 		     struct cfg80211_connect_params *sme)
 {
-	struct brcmf_cfg80211_info *cfg = ndev_to_cfg(ndev);
-	struct brcmf_cfg80211_profile *profile = cfg->profile;
+	struct brcmf_cfg80211_profile *profile = ndev_to_prof(ndev);
 	struct brcmf_cfg80211_security *sec;
 	s32 pval = 0;
 	s32 gval = 0;
@@ -1482,8 +1479,7 @@ brcmf_set_set_cipher(struct net_device *ndev,
 static s32
 brcmf_set_key_mgmt(struct net_device *ndev, struct cfg80211_connect_params *sme)
 {
-	struct brcmf_cfg80211_info *cfg = ndev_to_cfg(ndev);
-	struct brcmf_cfg80211_profile *profile = cfg->profile;
+	struct brcmf_cfg80211_profile *profile = ndev_to_prof(ndev);
 	struct brcmf_cfg80211_security *sec;
 	s32 val = 0;
 	s32 err = 0;
@@ -1541,8 +1537,7 @@ static s32
 brcmf_set_sharedkey(struct net_device *ndev,
 		    struct cfg80211_connect_params *sme)
 {
-	struct brcmf_cfg80211_info *cfg = ndev_to_cfg(ndev);
-	struct brcmf_cfg80211_profile *profile = cfg->profile;
+	struct brcmf_cfg80211_profile *profile = ndev_to_prof(ndev);
 	struct brcmf_cfg80211_security *sec;
 	struct brcmf_wsec_key key;
 	s32 val;
@@ -1608,7 +1603,7 @@ brcmf_cfg80211_connect(struct wiphy *wiphy, struct net_device *ndev,
 		    struct cfg80211_connect_params *sme)
 {
 	struct brcmf_cfg80211_info *cfg = wiphy_to_cfg(wiphy);
-	struct brcmf_cfg80211_profile *profile = cfg->profile;
+	struct brcmf_cfg80211_profile *profile = ndev_to_prof(ndev);
 	struct ieee80211_channel *chan = sme->channel;
 	struct brcmf_join_params join_params;
 	size_t join_params_size;
@@ -1701,7 +1696,7 @@ brcmf_cfg80211_disconnect(struct wiphy *wiphy, struct net_device *ndev,
 		       u16 reason_code)
 {
 	struct brcmf_cfg80211_info *cfg = wiphy_to_cfg(wiphy);
-	struct brcmf_cfg80211_profile *profile = cfg->profile;
+	struct brcmf_cfg80211_profile *profile = ndev_to_prof(ndev);
 	struct brcmf_scb_val_le scbval;
 	s32 err = 0;
 
@@ -2044,8 +2039,7 @@ brcmf_cfg80211_get_key(struct wiphy *wiphy, struct net_device *ndev,
 		    void (*callback) (void *cookie, struct key_params * params))
 {
 	struct key_params params;
-	struct brcmf_cfg80211_info *cfg = wiphy_to_cfg(wiphy);
-	struct brcmf_cfg80211_profile *profile = cfg->profile;
+	struct brcmf_cfg80211_profile *profile = ndev_to_prof(ndev);
 	struct brcmf_cfg80211_security *sec;
 	s32 wsec;
 	s32 err = 0;
@@ -2109,7 +2103,7 @@ brcmf_cfg80211_get_station(struct wiphy *wiphy, struct net_device *ndev,
 			   u8 *mac, struct station_info *sinfo)
 {
 	struct brcmf_cfg80211_info *cfg = wiphy_to_cfg(wiphy);
-	struct brcmf_cfg80211_profile *profile = cfg->profile;
+	struct brcmf_cfg80211_profile *profile = ndev_to_prof(ndev);
 	struct brcmf_scb_val_le scb_val;
 	int rssi;
 	s32 rate;
@@ -2519,8 +2513,9 @@ brcmf_find_wpaie(u8 *parse, u32 len)
 
 static s32 brcmf_update_bss_info(struct brcmf_cfg80211_info *cfg)
 {
-	struct brcmf_cfg80211_profile *profile = cfg->profile;
-	struct brcmf_if *ifp = netdev_priv(cfg_to_ndev(cfg));
+	struct net_device *ndev = cfg_to_ndev(cfg);
+	struct brcmf_cfg80211_profile *profile = ndev_to_prof(ndev);
+	struct brcmf_if *ifp = netdev_priv(ndev);
 	struct brcmf_bss_info_le *bi;
 	struct brcmf_ssid *ssid;
 	struct brcmf_tlv *tim;
@@ -3777,11 +3772,11 @@ brcmf_set_management_ie(struct brcmf_cfg80211_info *cfg,
 	struct parsed_vndr_ies new_vndr_ies;
 	struct parsed_vndr_ie_info *vndrie_info;
 	s32 i;
-	s32 bssidx = brcmf_ndev_bssidx(ndev);
 	u8 *ptr;
 	int remained_buf_len;
 
-	WL_TRACE("bssidx %d, pktflag : 0x%02X\n", bssidx, pktflag);
+	WL_TRACE("bssidx %d, pktflag : 0x%02X\n",
+		 brcmf_ndev_bssidx(ndev), pktflag);
 	iovar_ie_buf = kzalloc(WL_EXTRA_BUF_MAX, GFP_KERNEL);
 	if (!iovar_ie_buf)
 		return -ENOMEM;
@@ -4265,6 +4260,8 @@ struct brcmf_cfg80211_vif *brcmf_alloc_vif(struct brcmf_cfg80211_info *cfg,
 	vif->pm_block = pm_block;
 	vif->roam_off = -1;
 
+	brcmf_init_prof(&vif->profile);
+
 	list_add_tail(&vif->list, &cfg->vif_list);
 	cfg->vif_cnt++;
 	return vif;
@@ -4412,7 +4409,7 @@ brcmf_bss_roaming_done(struct brcmf_cfg80211_info *cfg,
 		       struct net_device *ndev,
 		       const struct brcmf_event_msg *e)
 {
-	struct brcmf_cfg80211_profile *profile = cfg->profile;
+	struct brcmf_cfg80211_profile *profile = ndev_to_prof(ndev);
 	struct brcmf_cfg80211_connect_info *conn_info = cfg_to_conn(cfg);
 	struct wiphy *wiphy = cfg_to_wiphy(cfg);
 	struct ieee80211_channel *notify_channel = NULL;
@@ -4472,7 +4469,7 @@ brcmf_bss_connect_done(struct brcmf_cfg80211_info *cfg,
 		       struct net_device *ndev, const struct brcmf_event_msg *e,
 		       bool completed)
 {
-	struct brcmf_cfg80211_profile *profile = cfg->profile;
+	struct brcmf_cfg80211_profile *profile = ndev_to_prof(ndev);
 	struct brcmf_cfg80211_connect_info *conn_info = cfg_to_conn(cfg);
 	s32 err = 0;
 
@@ -4546,7 +4543,7 @@ brcmf_notify_connect_status(struct brcmf_cfg80211_info *cfg,
 			    struct net_device *ndev,
 			    const struct brcmf_event_msg *e, void *data)
 {
-	struct brcmf_cfg80211_profile *profile = cfg->profile;
+	struct brcmf_cfg80211_profile *profile = ndev_to_prof(ndev);
 	s32 err = 0;
 
 	if (cfg->conf->mode == WL_MODE_AP) {
@@ -4577,7 +4574,7 @@ brcmf_notify_connect_status(struct brcmf_cfg80211_info *cfg,
 				brcmf_link_down(cfg);
 			}
 		}
-		brcmf_init_prof(cfg->profile);
+		brcmf_init_prof(ndev_to_prof(ndev));
 	} else if (brcmf_is_nonetwork(cfg, e)) {
 		if (brcmf_is_ibssmode(cfg))
 			clear_bit(WL_STATUS_CONNECTING, &cfg->status);
@@ -4731,8 +4728,6 @@ static void brcmf_deinit_priv_mem(struct brcmf_cfg80211_info *cfg)
 	cfg->bss_info = NULL;
 	kfree(cfg->conf);
 	cfg->conf = NULL;
-	kfree(cfg->profile);
-	cfg->profile = NULL;
 	kfree(cfg->scan_req_int);
 	cfg->scan_req_int = NULL;
 	kfree(cfg->escan_ioctl_buf);
@@ -4761,9 +4756,6 @@ static s32 brcmf_init_priv_mem(struct brcmf_cfg80211_info *cfg)
 	cfg->conf = kzalloc(sizeof(*cfg->conf), GFP_KERNEL);
 	if (!cfg->conf)
 		goto init_priv_mem_out;
-	cfg->profile = kzalloc(sizeof(*cfg->profile), GFP_KERNEL);
-	if (!cfg->profile)
-		goto init_priv_mem_out;
 	cfg->bss_info = kzalloc(WL_BSS_INFO_MAX, GFP_KERNEL);
 	if (!cfg->bss_info)
 		goto init_priv_mem_out;
@@ -4940,7 +4932,6 @@ static s32 wl_init_priv(struct brcmf_cfg80211_info *cfg)
 		return err;
 	brcmf_init_escan(cfg);
 	brcmf_init_conf(cfg->conf);
-	brcmf_init_prof(cfg->profile);
 	brcmf_link_down(cfg);
 
 	return err;
@@ -5247,23 +5238,25 @@ default_conf_out:
 
 static int brcmf_debugfs_add_netdev_params(struct brcmf_cfg80211_info *cfg)
 {
+	struct net_device *ndev = cfg_to_ndev(cfg);
+	struct brcmf_cfg80211_profile *profile = ndev_to_prof(ndev);
 	char buf[10+IFNAMSIZ];
 	struct dentry *fd;
 	s32 err = 0;
 
-	sprintf(buf, "netdev:%s", cfg_to_ndev(cfg)->name);
+	sprintf(buf, "netdev:%s", ndev->name);
 	cfg->debugfsdir = debugfs_create_dir(buf,
 					cfg_to_wiphy(cfg)->debugfsdir);
 
 	fd = debugfs_create_u16("beacon_int", S_IRUGO, cfg->debugfsdir,
-		(u16 *)&cfg->profile->beacon_interval);
+		(u16 *)&profile->beacon_interval);
 	if (!fd) {
 		err = -ENOMEM;
 		goto err_out;
 	}
 
 	fd = debugfs_create_u8("dtim_period", S_IRUGO, cfg->debugfsdir,
-		(u8 *)&cfg->profile->dtim_period);
+		(u8 *)&profile->dtim_period);
 	if (!fd) {
 		err = -ENOMEM;
 		goto err_out;
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.h b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.h
index 6644ea8..bf172d9 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.h
+++ b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.h
@@ -240,6 +240,7 @@ struct brcmf_cfg80211_profile {
  *
  * @ifp: lower layer interface pointer
  * @wdev: wireless device.
+ * @profile: profile information.
  * @mode: operating mode.
  * @roam_off: roaming state.
  * @pm_block: power-management blocked.
@@ -248,6 +249,7 @@ struct brcmf_cfg80211_profile {
 struct brcmf_cfg80211_vif {
 	struct brcmf_if *ifp;
 	struct wireless_dev wdev;
+	struct brcmf_cfg80211_profile profile;
 	s32 mode;
 	s32 roam_off;
 	bool pm_block;
@@ -414,7 +416,6 @@ struct brcmf_pno_scanresults_le {
  * @scan_req_int: internal scan request object.
  * @bss_info: bss information for cfg80211 layer.
  * @ie: information element object for internal purpose.
- * @profile: holding dongle profile.
  * @iscan: iscan controller information.
  * @conn_info: association info.
  * @pmk_list: wpa2 pmk list.
@@ -457,7 +458,6 @@ struct brcmf_cfg80211_info {
 	struct brcmf_cfg80211_scan_req *scan_req_int;
 	struct wl_cfg80211_bss_info *bss_info;
 	struct brcmf_cfg80211_ie ie;
-	struct brcmf_cfg80211_profile *profile;
 	struct brcmf_cfg80211_iscan_ctrl *iscan;
 	struct brcmf_cfg80211_connect_info conn_info;
 	struct brcmf_cfg80211_pmk_list *pmk_list;
@@ -516,6 +516,12 @@ static inline struct brcmf_cfg80211_info *ndev_to_cfg(struct net_device *ndev)
 	return wdev_to_cfg(ndev->ieee80211_ptr);
 }
 
+static inline struct brcmf_cfg80211_profile *ndev_to_prof(struct net_device *nd)
+{
+	struct brcmf_if *ifp = netdev_priv(nd);
+	return &ifp->vif->profile;
+}
+
 #define iscan_to_cfg(i) ((struct brcmf_cfg80211_info *)(i->data))
 #define cfg_to_iscan(w) (w->iscan)
 
-- 
1.7.9.5



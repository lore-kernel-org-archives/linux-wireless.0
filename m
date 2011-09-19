Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:4554 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932499Ab1ISV0b (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Sep 2011 17:26:31 -0400
From: "Franky Lin" <frankyl@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Subject: [PATCH 15/20] staging: brcm80211: removed likely/unlikely calls
Date: Mon, 19 Sep 2011 14:26:03 -0700
Message-ID: <1316467568-27683-16-git-send-email-frankyl@broadcom.com> (sfid-20110919_232640_875261_BF890316)
In-Reply-To: <1316467568-27683-1-git-send-email-frankyl@broadcom.com>
References: <1316467568-27683-1-git-send-email-frankyl@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Roland Vossen <rvossen@broadcom.com>

There was no performance rationale to use these guys.

Reported-by: Dan Carpenter <error27@gmail.com>
Reviewed-by: Arend van Spriel <arend@broadcom.com>
Reviewed-by: Franky Lin <frankyl@broadcom.com>
Signed-off-by: Franky Lin <frankyl@broadcom.com>
---
 drivers/staging/brcm80211/brcmfmac/dhd_linux.c   |    4 +-
 drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c |  211 +++++++++++-----------
 drivers/staging/brcm80211/brcmsmac/ampdu.c       |    2 +-
 3 files changed, 107 insertions(+), 110 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmfmac/dhd_linux.c b/drivers/staging/brcm80211/brcmfmac/dhd_linux.c
index e1d7456..cc8564a 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd_linux.c
+++ b/drivers/staging/brcm80211/brcmfmac/dhd_linux.c
@@ -944,7 +944,7 @@ static int brcmf_netdev_open(struct net_device *net)
 	/* Allow transmit calls */
 	netif_start_queue(net);
 	drvr_priv->pub.up = 1;
-	if (unlikely(brcmf_cfg80211_up(drvr_priv->pub.config))) {
+	if (brcmf_cfg80211_up(drvr_priv->pub.config)) {
 		brcmf_dbg(ERROR, "failed to bring up cfg80211\n");
 		return -1;
 	}
@@ -1054,7 +1054,7 @@ struct brcmf_pub *brcmf_attach(struct brcmf_bus *bus, uint bus_hdrlen)
 			brcmf_cfg80211_attach(net,
 					      brcmf_bus_get_device(bus),
 					      &drvr_priv->pub);
-	if (unlikely(drvr_priv->pub.config == NULL)) {
+	if (drvr_priv->pub.config == NULL) {
 		brcmf_dbg(ERROR, "wl_cfg80211_attach failed\n");
 		goto fail;
 	}
diff --git a/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c b/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c
index 0bda00c..6acaaae 100644
--- a/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c
+++ b/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c
@@ -337,7 +337,7 @@ brcmf_cfg80211_change_iface(struct wiphy *wiphy, struct net_device *ndev,
 	}
 
 	err = brcmf_dev_ioctl_u32(ndev, BRCMF_C_SET_INFRA, &infra);
-	if (unlikely(err)) {
+	if (err) {
 		WL_ERR("WLC_SET_INFRA error (%d)\n", err);
 		err = -EAGAIN;
 	} else {
@@ -367,7 +367,7 @@ static s32 brcmf_dev_intvar_set(struct net_device *dev, s8 *name, s32 val)
 	BUG_ON(!len);
 
 	err = brcmf_dev_ioctl(dev, BRCMF_C_SET_VAR, buf, len);
-	if (unlikely(err))
+	if (err)
 		WL_ERR("error (%d)\n", err);
 
 	return err;
@@ -389,7 +389,7 @@ brcmf_dev_intvar_get(struct net_device *dev, s8 *name, s32 *retval)
 			sizeof(var.buf));
 	BUG_ON(!len);
 	err = brcmf_dev_ioctl(dev, BRCMF_C_GET_VAR, &var, len);
-	if (unlikely(err))
+	if (err)
 		WL_ERR("error (%d)\n", err);
 
 	*retval = le32_to_cpu(var.val);
@@ -404,7 +404,7 @@ static void brcmf_set_mpc(struct net_device *ndev, int mpc)
 
 	if (test_bit(WL_STATUS_READY, &cfg_priv->status)) {
 		err = brcmf_dev_intvar_set(ndev, "mpc", mpc);
-		if (unlikely(err)) {
+		if (err) {
 			WL_ERR("fail to set mpc\n");
 			return;
 		}
@@ -463,7 +463,7 @@ brcmf_run_iscan(struct brcmf_cfg80211_iscan_ctrl *iscan,
 	if (ssid && ssid->SSID_len)
 		params_size += sizeof(struct brcmf_ssid);
 	params = kzalloc(params_size, GFP_KERNEL);
-	if (unlikely(!params))
+	if (!params)
 		return -ENOMEM;
 	BUG_ON(params_size >= BRCMF_C_IOCTL_SMLEN);
 
@@ -475,7 +475,7 @@ brcmf_run_iscan(struct brcmf_cfg80211_iscan_ctrl *iscan,
 
 	err = brcmf_dev_iovar_setbuf(iscan->dev, "iscan", params, params_size,
 				iscan->ioctl_buf, BRCMF_C_IOCTL_SMLEN);
-	if (unlikely(err)) {
+	if (err) {
 		if (err == -EBUSY)
 			WL_INFO("system busy : iscan canceled\n");
 		else
@@ -502,7 +502,7 @@ static s32 brcmf_do_iscan(struct brcmf_cfg80211_priv *cfg_priv)
 	passive_scan = cfg_priv->active_scan ? 0 : 1;
 	err = brcmf_dev_ioctl(cfg_to_ndev(cfg_priv), BRCMF_C_SET_PASSIVE_SCAN,
 			&passive_scan, sizeof(passive_scan));
-	if (unlikely(err)) {
+	if (err) {
 		WL_ERR("error (%d)\n", err);
 		return err;
 	}
@@ -533,11 +533,11 @@ __brcmf_cfg80211_scan(struct wiphy *wiphy, struct net_device *ndev,
 	s32 err = 0;
 	u32 SSID_len;
 
-	if (unlikely(test_bit(WL_STATUS_SCANNING, &cfg_priv->status))) {
+	if (test_bit(WL_STATUS_SCANNING, &cfg_priv->status)) {
 		WL_ERR("Scanning already : status (%lu)\n", cfg_priv->status);
 		return -EAGAIN;
 	}
-	if (unlikely(test_bit(WL_STATUS_SCAN_ABORTING, &cfg_priv->status))) {
+	if (test_bit(WL_STATUS_SCAN_ABORTING, &cfg_priv->status)) {
 		WL_ERR("Scanning being aborted : status (%lu)\n",
 		       cfg_priv->status);
 		return -EAGAIN;
@@ -565,7 +565,7 @@ __brcmf_cfg80211_scan(struct wiphy *wiphy, struct net_device *ndev,
 	set_bit(WL_STATUS_SCANNING, &cfg_priv->status);
 	if (iscan_req) {
 		err = brcmf_do_iscan(cfg_priv);
-		if (likely(!err))
+		if (!err)
 			return err;
 		else
 			goto scan_out;
@@ -586,7 +586,7 @@ __brcmf_cfg80211_scan(struct wiphy *wiphy, struct net_device *ndev,
 		passive_scan = cfg_priv->active_scan ? 0 : 1;
 		err = brcmf_dev_ioctl(ndev, BRCMF_C_SET_PASSIVE_SCAN,
 				&passive_scan, sizeof(passive_scan));
-		if (unlikely(err)) {
+		if (err) {
 			WL_ERR("WLC_SET_PASSIVE_SCAN error (%d)\n", err);
 			goto scan_out;
 		}
@@ -625,7 +625,7 @@ brcmf_cfg80211_scan(struct wiphy *wiphy, struct net_device *ndev,
 		return -EIO;
 
 	err = __brcmf_cfg80211_scan(wiphy, ndev, request, NULL);
-	if (unlikely(err))
+	if (err)
 		WL_ERR("scan error (%d)\n", err);
 
 	WL_TRACE("Exit\n");
@@ -637,7 +637,7 @@ static s32 brcmf_set_rts(struct net_device *dev, u32 rts_threshold)
 	s32 err = 0;
 
 	err = brcmf_dev_intvar_set(dev, "rtsthresh", rts_threshold);
-	if (unlikely(err))
+	if (err)
 		WL_ERR("Error (%d)\n", err);
 
 	return err;
@@ -648,7 +648,7 @@ static s32 brcmf_set_frag(struct net_device *dev, u32 frag_threshold)
 	s32 err = 0;
 
 	err = brcmf_dev_intvar_set(dev, "fragthresh", frag_threshold);
-	if (unlikely(err))
+	if (err)
 		WL_ERR("Error (%d)\n", err);
 
 	return err;
@@ -660,7 +660,7 @@ static s32 brcmf_set_retry(struct net_device *dev, u32 retry, bool l)
 	u32 cmd = (l ? BRCM_SET_LRL : BRCM_SET_SRL);
 
 	err = brcmf_dev_ioctl_u32(dev, cmd, &retry);
-	if (unlikely(err)) {
+	if (err) {
 		WL_ERR("cmd (%d) , error (%d)\n", cmd, err);
 		return err;
 	}
@@ -809,7 +809,7 @@ static void brcmf_link_down(struct brcmf_cfg80211_priv *cfg_priv)
 		dev = cfg_to_ndev(cfg_priv);
 		WL_INFO("Call WLC_DISASSOC to stop excess roaming\n ");
 		err = brcmf_dev_ioctl(dev, BRCMF_C_DISASSOC, NULL, 0);
-		if (unlikely(err))
+		if (err)
 			WL_ERR("WLC_DISASSOC failed (%d)\n", err);
 		cfg_priv->link_up = false;
 	}
@@ -883,7 +883,7 @@ brcmf_cfg80211_join_ibss(struct wiphy *wiphy, struct net_device *dev,
 		wsec |= WEP_ENABLED;
 
 	err = brcmf_dev_intvar_set(dev, "wsec", wsec);
-	if (unlikely(err)) {
+	if (err) {
 		WL_ERR("wsec failed (%d)\n", err);
 		goto done;
 	}
@@ -895,7 +895,7 @@ brcmf_cfg80211_join_ibss(struct wiphy *wiphy, struct net_device *dev,
 		bcnprd = 100;
 
 	err = brcmf_dev_ioctl_u32(dev, BRCM_SET_BCNPRD, &bcnprd);
-	if (unlikely(err)) {
+	if (err) {
 		WL_ERR("WLC_SET_BCNPRD failed (%d)\n", err);
 		goto done;
 	}
@@ -940,7 +940,7 @@ brcmf_cfg80211_join_ibss(struct wiphy *wiphy, struct net_device *dev,
 		target_channel = cfg_priv->channel;
 		err = brcmf_dev_ioctl_u32(dev, BRCM_SET_CHANNEL,
 					  &target_channel);
-		if (unlikely(err)) {
+		if (err) {
 			WL_ERR("WLC_SET_CHANNEL failed (%d)\n", err);
 			goto done;
 		}
@@ -952,7 +952,7 @@ brcmf_cfg80211_join_ibss(struct wiphy *wiphy, struct net_device *dev,
 
 	err = brcmf_dev_ioctl(dev, BRCMF_C_SET_SSID,
 			   &join_params, join_params_size);
-	if (unlikely(err)) {
+	if (err) {
 		WL_ERR("WLC_SET_SSID failed (%d)\n", err);
 		goto done;
 	}
@@ -997,7 +997,7 @@ static s32 brcmf_set_wpa_version(struct net_device *dev,
 		val = WPA_AUTH_DISABLED;
 	WL_CONN("setting wpa_auth to 0x%0x\n", val);
 	err = brcmf_dev_intvar_set(dev, "wpa_auth", val);
-	if (unlikely(err)) {
+	if (err) {
 		WL_ERR("set wpa_auth failed (%d)\n", err);
 		return err;
 	}
@@ -1036,7 +1036,7 @@ brcmf_set_auth_type(struct net_device *dev, struct cfg80211_connect_params *sme)
 	}
 
 	err = brcmf_dev_intvar_set(dev, "auth", val);
-	if (unlikely(err)) {
+	if (err) {
 		WL_ERR("set auth failed (%d)\n", err);
 		return err;
 	}
@@ -1100,7 +1100,7 @@ brcmf_set_set_cipher(struct net_device *dev,
 
 	WL_CONN("pval (%d) gval (%d)\n", pval, gval);
 	err = brcmf_dev_intvar_set(dev, "wsec", pval | gval);
-	if (unlikely(err)) {
+	if (err) {
 		WL_ERR("error (%d)\n", err);
 		return err;
 	}
@@ -1122,7 +1122,7 @@ brcmf_set_key_mgmt(struct net_device *dev, struct cfg80211_connect_params *sme)
 
 	if (sme->crypto.n_akm_suites) {
 		err = brcmf_dev_intvar_get(dev, "wpa_auth", &val);
-		if (unlikely(err)) {
+		if (err) {
 			WL_ERR("could not get wpa_auth (%d)\n", err);
 			return err;
 		}
@@ -1156,7 +1156,7 @@ brcmf_set_key_mgmt(struct net_device *dev, struct cfg80211_connect_params *sme)
 
 		WL_CONN("setting wpa_auth to %d\n", val);
 		err = brcmf_dev_intvar_set(dev, "wpa_auth", val);
-		if (unlikely(err)) {
+		if (err) {
 			WL_ERR("could not set wpa_auth (%d)\n", err);
 			return err;
 		}
@@ -1190,7 +1190,7 @@ brcmf_set_set_sharedkey(struct net_device *dev,
 			memset(&key, 0, sizeof(key));
 			key.len = (u32) sme->key_len;
 			key.index = (u32) sme->key_idx;
-			if (unlikely(key.len > sizeof(key.data))) {
+			if (key.len > sizeof(key.data)) {
 				WL_ERR("Too long key length (%u)\n", key.len);
 				return -EINVAL;
 			}
@@ -1220,7 +1220,7 @@ brcmf_set_set_sharedkey(struct net_device *dev,
 				WL_CONN("set auth_type to shared key\n");
 				val = 1;	/* shared key */
 				err = brcmf_dev_intvar_set(dev, "auth", val);
-				if (unlikely(err)) {
+				if (err) {
 					WL_ERR("set auth failed (%d)\n", err);
 					return err;
 				}
@@ -1246,7 +1246,7 @@ brcmf_cfg80211_connect(struct wiphy *wiphy, struct net_device *dev,
 	if (!check_sys_up(wiphy))
 		return -EIO;
 
-	if (unlikely(!sme->ssid)) {
+	if (!sme->ssid) {
 		WL_ERR("Invalid ssid\n");
 		return -EOPNOTSUPP;
 	}
@@ -1340,7 +1340,7 @@ brcmf_cfg80211_disconnect(struct wiphy *wiphy, struct net_device *dev,
 	scbval.val = cpu_to_le32(reason_code);
 	err = brcmf_dev_ioctl(dev, BRCMF_C_DISASSOC, &scbval,
 			      sizeof(struct brcmf_scb_val_le));
-	if (unlikely(err))
+	if (err)
 		WL_ERR("error (%d)\n", err);
 
 	cfg_priv->link_up = false;
@@ -1385,7 +1385,7 @@ brcmf_cfg80211_set_tx_power(struct wiphy *wiphy,
 	/* Make sure radio is off or on as far as software is concerned */
 	disable = WL_RADIO_SW_DISABLE << 16;
 	err = brcmf_dev_ioctl_u32(ndev, BRCMF_C_SET_RADIO, &disable);
-	if (unlikely(err))
+	if (err)
 		WL_ERR("WLC_SET_RADIO error (%d)\n", err);
 
 	if (dbm > 0xffff)
@@ -1394,7 +1394,7 @@ brcmf_cfg80211_set_tx_power(struct wiphy *wiphy,
 		txpwrmw = (u16) dbm;
 	err = brcmf_dev_intvar_set(ndev, "qtxpower",
 			(s32) (brcmu_mw_to_qdbm(txpwrmw)));
-	if (unlikely(err))
+	if (err)
 		WL_ERR("qtxpower error (%d)\n", err);
 	cfg_priv->conf->tx_power = dbm;
 
@@ -1416,7 +1416,7 @@ static s32 brcmf_cfg80211_get_tx_power(struct wiphy *wiphy, s32 *dbm)
 		return -EIO;
 
 	err = brcmf_dev_intvar_get(ndev, "qtxpower", &txpwrdbm);
-	if (unlikely(err)) {
+	if (err) {
 		WL_ERR("error (%d)\n", err);
 		goto done;
 	}
@@ -1443,7 +1443,7 @@ brcmf_cfg80211_config_default_key(struct wiphy *wiphy, struct net_device *dev,
 		return -EIO;
 
 	err = brcmf_dev_ioctl_u32(dev, BRCMF_C_GET_WSEC, &wsec);
-	if (unlikely(err)) {
+	if (err) {
 		WL_ERR("WLC_GET_WSEC error (%d)\n", err);
 		goto done;
 	}
@@ -1452,7 +1452,7 @@ brcmf_cfg80211_config_default_key(struct wiphy *wiphy, struct net_device *dev,
 		/* Just select a new current key */
 		index = key_idx;
 		err = brcmf_dev_ioctl_u32(dev, BRCMF_C_SET_KEY_PRIMARY, &index);
-		if (unlikely(err))
+		if (err)
 			WL_ERR("error (%d)\n", err);
 	}
 done:
@@ -1538,7 +1538,7 @@ brcmf_add_keyext(struct wiphy *wiphy, struct net_device *dev,
 		brcmf_netdev_wait_pend8021x(dev);
 		err = brcmf_dev_ioctl(dev, BRCMF_C_SET_KEY, &key_le,
 				      sizeof(key_le));
-		if (unlikely(err)) {
+		if (err) {
 			WL_ERR("WLC_SET_KEY error (%d)\n", err);
 			return err;
 		}
@@ -1571,7 +1571,7 @@ brcmf_cfg80211_add_key(struct wiphy *wiphy, struct net_device *dev,
 	key.len = (u32) params->key_len;
 	key.index = (u32) key_idx;
 
-	if (unlikely(key.len > sizeof(key.data))) {
+	if (key.len > sizeof(key.data)) {
 		WL_ERR("Too long key length (%u)\n", key.len);
 		err = -EINVAL;
 		goto done;
@@ -1615,21 +1615,21 @@ brcmf_cfg80211_add_key(struct wiphy *wiphy, struct net_device *dev,
 
 	val = WEP_ENABLED;
 	err = brcmf_dev_intvar_get(dev, "wsec", &wsec);
-	if (unlikely(err)) {
+	if (err) {
 		WL_ERR("get wsec error (%d)\n", err);
 		goto done;
 	}
 	wsec &= ~(WEP_ENABLED);
 	wsec |= val;
 	err = brcmf_dev_intvar_set(dev, "wsec", wsec);
-	if (unlikely(err)) {
+	if (err) {
 		WL_ERR("set wsec error (%d)\n", err);
 		goto done;
 	}
 
 	val = 1;		/* assume shared key. otherwise 0 */
 	err = brcmf_dev_ioctl_u32(dev, BRCMF_C_SET_AUTH, &val);
-	if (unlikely(err))
+	if (err)
 		WL_ERR("WLC_SET_AUTH error (%d)\n", err);
 done:
 	WL_TRACE("Exit\n");
@@ -1672,7 +1672,7 @@ brcmf_cfg80211_del_key(struct wiphy *wiphy, struct net_device *dev,
 
 	val = 0;
 	err = brcmf_dev_intvar_get(dev, "wsec", &wsec);
-	if (unlikely(err)) {
+	if (err) {
 		WL_ERR("get wsec error (%d)\n", err);
 		/* Ignore this error, may happen during DISASSOC */
 		err = -EAGAIN;
@@ -1681,7 +1681,7 @@ brcmf_cfg80211_del_key(struct wiphy *wiphy, struct net_device *dev,
 	wsec &= ~(WEP_ENABLED);
 	wsec |= val;
 	err = brcmf_dev_intvar_set(dev, "wsec", wsec);
-	if (unlikely(err)) {
+	if (err) {
 		WL_ERR("set wsec error (%d)\n", err);
 		/* Ignore this error, may happen during DISASSOC */
 		err = -EAGAIN;
@@ -1690,7 +1690,7 @@ brcmf_cfg80211_del_key(struct wiphy *wiphy, struct net_device *dev,
 
 	val = 0;		/* assume open key. otherwise 1 */
 	err = brcmf_dev_ioctl_u32(dev, BRCMF_C_SET_AUTH, &val);
-	if (unlikely(err)) {
+	if (err) {
 		WL_ERR("WLC_SET_AUTH error (%d)\n", err);
 		/* Ignore this error, may happen during DISASSOC */
 		err = -EAGAIN;
@@ -1719,7 +1719,7 @@ brcmf_cfg80211_get_key(struct wiphy *wiphy, struct net_device *dev,
 	memset(&params, 0, sizeof(params));
 
 	err = brcmf_dev_ioctl_u32(dev, BRCMF_C_GET_WSEC, &wsec);
-	if (unlikely(err)) {
+	if (err) {
 		WL_ERR("WLC_GET_WSEC error (%d)\n", err);
 		/* Ignore this error, may happen during DISASSOC */
 		err = -EAGAIN;
@@ -1780,8 +1780,7 @@ brcmf_cfg80211_get_station(struct wiphy *wiphy, struct net_device *dev,
 	if (!check_sys_up(wiphy))
 		return -EIO;
 
-	if (unlikely
-	    (memcmp(mac, bssid, ETH_ALEN))) {
+	if (memcmp(mac, bssid, ETH_ALEN)) {
 		WL_ERR("Wrong Mac address cfg_mac-%X:%X:%X:%X:%X:%X"
 			"wl_bssid-%X:%X:%X:%X:%X:%X\n",
 			mac[0], mac[1], mac[2], mac[3], mac[4], mac[5],
@@ -1805,7 +1804,7 @@ brcmf_cfg80211_get_station(struct wiphy *wiphy, struct net_device *dev,
 		scb_val.val = cpu_to_le32(0);
 		err = brcmf_dev_ioctl(dev, BRCMF_C_GET_RSSI, &scb_val,
 				      sizeof(struct brcmf_scb_val_le));
-		if (unlikely(err))
+		if (err)
 			WL_ERR("Could not get rssi (%d)\n", err);
 
 		rssi = le32_to_cpu(scb_val.val);
@@ -1848,7 +1847,7 @@ brcmf_cfg80211_set_power_mgmt(struct wiphy *wiphy, struct net_device *dev,
 	WL_INFO("power save %s\n", (pm ? "enabled" : "disabled"));
 
 	err = brcmf_dev_ioctl_u32(dev, BRCMF_C_SET_PM, &pm);
-	if (unlikely(err)) {
+	if (err) {
 		if (err == -ENODEV)
 			WL_ERR("net_device is not ready yet\n");
 		else
@@ -1880,7 +1879,7 @@ brcmf_cfg80211_set_bitrate_mask(struct wiphy *wiphy, struct net_device *dev,
 	/* Get current rateset */
 	err = brcmf_dev_ioctl(dev, BRCM_GET_CURR_RATESET, &rateset_le,
 			      sizeof(rateset_le));
-	if (unlikely(err)) {
+	if (err) {
 		WL_ERR("could not get current rateset (%d)\n", err);
 		goto done;
 	}
@@ -1908,7 +1907,7 @@ brcmf_cfg80211_set_bitrate_mask(struct wiphy *wiphy, struct net_device *dev,
 	 */
 	err_bg = brcmf_dev_intvar_set(dev, "bg_rate", rate);
 	err_a = brcmf_dev_intvar_set(dev, "a_rate", rate);
-	if (unlikely(err_bg && err_a)) {
+	if (err_bg && err_a) {
 		WL_ERR("could not set fixed rate (%d) (%d)\n", err_bg, err_a);
 		err = err_bg | err_a;
 	}
@@ -1935,7 +1934,7 @@ static s32 brcmf_inform_single_bss(struct brcmf_cfg80211_priv *cfg_priv,
 	size_t notify_ielen;
 	s32 notify_signal;
 
-	if (unlikely(le32_to_cpu(bi->length) > WL_BSS_INFO_MAX)) {
+	if (le32_to_cpu(bi->length) > WL_BSS_INFO_MAX) {
 		WL_ERR("Bss info is larger than buffer. Discarding\n");
 		return 0;
 	}
@@ -1971,7 +1970,7 @@ static s32 brcmf_inform_single_bss(struct brcmf_cfg80211_priv *cfg_priv,
 		notify_timestamp, notify_capability, notify_interval, notify_ie,
 		notify_ielen, notify_signal, GFP_KERNEL);
 
-	if (unlikely(!bss)) {
+	if (!bss) {
 		WL_ERR("cfg80211_inform_bss_frame error\n");
 		return -EINVAL;
 	}
@@ -1987,7 +1986,7 @@ static s32 brcmf_inform_bss(struct brcmf_cfg80211_priv *cfg_priv)
 	int i;
 
 	bss_list = cfg_priv->bss_list;
-	if (unlikely(bss_list->version != BRCMF_BSS_INFO_VERSION)) {
+	if (bss_list->version != BRCMF_BSS_INFO_VERSION) {
 		WL_ERR("Version %d != WL_BSS_INFO_VERSION\n",
 		       bss_list->version);
 		return -EOPNOTSUPP;
@@ -1996,7 +1995,7 @@ static s32 brcmf_inform_bss(struct brcmf_cfg80211_priv *cfg_priv)
 	for (i = 0; i < bss_list->count && i < WL_AP_MAX; i++) {
 		bi = next_bss(bss_list, bi);
 		err = brcmf_inform_single_bss(cfg_priv, bi);
-		if (unlikely(err))
+		if (err)
 			break;
 	}
 	return err;
@@ -2032,7 +2031,7 @@ static s32 wl_inform_ibss(struct brcmf_cfg80211_priv *cfg_priv,
 	*(__le32 *)buf = cpu_to_le32(WL_BSS_INFO_MAX);
 
 	err = brcmf_dev_ioctl(dev, BRCMF_C_GET_BSS_INFO, buf, WL_BSS_INFO_MAX);
-	if (unlikely(err)) {
+	if (err) {
 		WL_ERR("WLC_GET_BSS_INFO failed: %d\n", err);
 		goto CleanUp;
 	}
@@ -2101,14 +2100,14 @@ static s32 brcmf_update_bss_info(struct brcmf_cfg80211_priv *cfg_priv)
 	*(__le32 *)cfg_priv->extra_buf = cpu_to_le32(WL_EXTRA_BUF_MAX);
 	err = brcmf_dev_ioctl(cfg_to_ndev(cfg_priv), BRCMF_C_GET_BSS_INFO,
 			cfg_priv->extra_buf, WL_EXTRA_BUF_MAX);
-	if (unlikely(err)) {
+	if (err) {
 		WL_ERR("Could not get bss info %d\n", err);
 		goto update_bss_info_out;
 	}
 
 	bi = (struct brcmf_bss_info *)(cfg_priv->extra_buf + 4);
 	err = brcmf_inform_single_bss(cfg_priv, bi);
-	if (unlikely(err))
+	if (err)
 		goto update_bss_info_out;
 
 	ie = ((u8 *)bi) + le16_to_cpu(bi->ie_offset);
@@ -2127,7 +2126,7 @@ static s32 brcmf_update_bss_info(struct brcmf_cfg80211_priv *cfg_priv)
 		u32 var;
 		err = brcmf_dev_intvar_get(cfg_to_ndev(cfg_priv),
 					   "dtim_assoc", &var);
-		if (unlikely(err)) {
+		if (err) {
 			WL_ERR("wl dtim_assoc failed (%d)\n", err);
 			goto update_bss_info_out;
 		}
@@ -2169,12 +2168,11 @@ static void brcmf_notify_iscan_complete(struct brcmf_cfg80211_iscan_ctrl *iscan,
 	struct brcmf_cfg80211_priv *cfg_priv = iscan_to_cfg(iscan);
 	struct net_device *ndev = cfg_to_ndev(cfg_priv);
 
-	if (unlikely(!test_and_clear_bit(WL_STATUS_SCANNING,
-					 &cfg_priv->status))) {
+	if (!test_and_clear_bit(WL_STATUS_SCANNING, &cfg_priv->status)) {
 		WL_ERR("Scan complete while device not scanning\n");
 		return;
 	}
-	if (likely(cfg_priv->scan_request)) {
+	if (cfg_priv->scan_request) {
 		WL_SCAN("ISCAN Completed scan: %s\n",
 				aborted ? "Aborted" : "Done");
 		cfg80211_scan_done(cfg_priv->scan_request, aborted);
@@ -2186,7 +2184,7 @@ static void brcmf_notify_iscan_complete(struct brcmf_cfg80211_iscan_ctrl *iscan,
 
 static s32 brcmf_wakeup_iscan(struct brcmf_cfg80211_iscan_ctrl *iscan)
 {
-	if (likely(iscan->state != WL_ISCAN_STATE_IDLE)) {
+	if (iscan->state != WL_ISCAN_STATE_IDLE) {
 		WL_SCAN("wake up iscan\n");
 		schedule_work(&iscan->work);
 		return 0;
@@ -2218,7 +2216,7 @@ brcmf_get_iscan_results(struct brcmf_cfg80211_iscan_ctrl *iscan, u32 *status,
 	err = brcmf_dev_iovar_getbuf(iscan->dev, "iscanresults", &list,
 				BRCMF_ISCAN_RESULTS_FIXED_SIZE, iscan->scan_buf,
 				WL_ISCAN_BUF_MAX);
-	if (unlikely(err)) {
+	if (err) {
 		WL_ERR("error (%d)\n", err);
 		return err;
 	}
@@ -2481,7 +2479,7 @@ brcmf_dev_bufvar_get(struct net_device *dev, s8 *name, s8 *buf,
 	BUG_ON(!len);
 	err = brcmf_dev_ioctl(dev, BRCMF_C_GET_VAR, (void *)cfg_priv->ioctl_buf,
 			WL_IOCTL_LEN_MAX);
-	if (unlikely(err)) {
+	if (err) {
 		WL_ERR("error (%d)\n", err);
 		return err;
 	}
@@ -2504,7 +2502,7 @@ brcmf_update_pmklist(struct net_device *dev,
 			WL_CONN("%02x\n", pmk_list->pmkids.pmkid[i].PMKID[j]);
 	}
 
-	if (likely(!err))
+	if (!err)
 		brcmf_dev_bufvar_set(dev, "pmkid_info", (char *)pmk_list,
 					sizeof(*pmk_list));
 
@@ -2662,14 +2660,14 @@ static struct wireless_dev *brcmf_alloc_wdev(s32 sizeof_iface,
 	s32 err = 0;
 
 	wdev = kzalloc(sizeof(*wdev), GFP_KERNEL);
-	if (unlikely(!wdev)) {
+	if (!wdev) {
 		WL_ERR("Could not allocate wireless device\n");
 		return ERR_PTR(-ENOMEM);
 	}
 	wdev->wiphy =
 	    wiphy_new(&wl_cfg80211_ops,
 		      sizeof(struct brcmf_cfg80211_priv) + sizeof_iface);
-	if (unlikely(!wdev->wiphy)) {
+	if (!wdev->wiphy) {
 		WL_ERR("Couldn not allocate wiphy device\n");
 		err = -ENOMEM;
 		goto wiphy_new_out;
@@ -2695,7 +2693,7 @@ static struct wireless_dev *brcmf_alloc_wdev(s32 sizeof_iface,
 								 * by default
 								 */
 	err = wiphy_register(wdev->wiphy);
-	if (unlikely(err < 0)) {
+	if (err < 0) {
 		WL_ERR("Couldn not register wiphy device (%d)\n", err);
 		goto wiphy_register_out;
 	}
@@ -2714,7 +2712,7 @@ static void brcmf_free_wdev(struct brcmf_cfg80211_priv *cfg_priv)
 {
 	struct wireless_dev *wdev = cfg_priv->wdev;
 
-	if (unlikely(!wdev)) {
+	if (!wdev) {
 		WL_ERR("wdev is invalid\n");
 		return;
 	}
@@ -2798,7 +2796,7 @@ static s32 brcmf_get_assoc_ies(struct brcmf_cfg80211_priv *cfg_priv)
 
 	err = brcmf_dev_bufvar_get(ndev, "assoc_info", cfg_priv->extra_buf,
 				WL_ASSOC_INFO_MAX);
-	if (unlikely(err)) {
+	if (err) {
 		WL_ERR("could not get assoc info (%d)\n", err);
 		return err;
 	}
@@ -2809,7 +2807,7 @@ static s32 brcmf_get_assoc_ies(struct brcmf_cfg80211_priv *cfg_priv)
 		err = brcmf_dev_bufvar_get(ndev, "assoc_req_ies",
 					   cfg_priv->extra_buf,
 					   WL_ASSOC_INFO_MAX);
-		if (unlikely(err)) {
+		if (err) {
 			WL_ERR("could not get assoc req (%d)\n", err);
 			return err;
 		}
@@ -2825,7 +2823,7 @@ static s32 brcmf_get_assoc_ies(struct brcmf_cfg80211_priv *cfg_priv)
 		err = brcmf_dev_bufvar_get(ndev, "assoc_resp_ies",
 					   cfg_priv->extra_buf,
 					   WL_ASSOC_INFO_MAX);
-		if (unlikely(err)) {
+		if (err) {
 			WL_ERR("could not get assoc resp (%d)\n", err);
 			return err;
 		}
@@ -3028,8 +3026,7 @@ brcmf_notify_scan_status(struct brcmf_cfg80211_priv *cfg_priv,
 		return brcmf_wakeup_iscan(cfg_to_iscan(cfg_priv));
 	}
 
-	if (unlikely(!test_and_clear_bit(WL_STATUS_SCANNING,
-					 &cfg_priv->status))) {
+	if (!test_and_clear_bit(WL_STATUS_SCANNING, &cfg_priv->status)) {
 		WL_ERR("Scan complete while device not scanning\n");
 		scan_abort = true;
 		err = -EINVAL;
@@ -3038,13 +3035,13 @@ brcmf_notify_scan_status(struct brcmf_cfg80211_priv *cfg_priv,
 
 	err = brcmf_dev_ioctl(ndev, BRCMF_C_GET_CHANNEL, &channel_inform_le,
 			      sizeof(channel_inform_le));
-	if (unlikely(err)) {
+	if (err) {
 		WL_ERR("scan busy (%d)\n", err);
 		scan_abort = true;
 		goto scan_done_out;
 	}
 	scan_channel = le32_to_cpu(channel_inform_le.scan_channel);
-	if (unlikely(scan_channel))
+	if (scan_channel)
 		WL_CONN("channel_inform.scan_channel (%d)\n", scan_channel);
 	cfg_priv->bss_list = cfg_priv->scan_results;
 	bss_list_le = (struct brcmf_scan_results_le *) cfg_priv->bss_list;
@@ -3053,7 +3050,7 @@ brcmf_notify_scan_status(struct brcmf_cfg80211_priv *cfg_priv,
 	bss_list_le->buflen = cpu_to_le32(len);
 	err = brcmf_dev_ioctl(ndev, BRCMF_C_SCAN_RESULTS,
 			      cfg_priv->scan_results, len);
-	if (unlikely(err)) {
+	if (err) {
 		WL_ERR("%s Scan_results error (%d)\n", ndev->name, err);
 		err = -EINVAL;
 		scan_abort = true;
@@ -3127,48 +3124,48 @@ static void brcmf_deinit_priv_mem(struct brcmf_cfg80211_priv *cfg_priv)
 static s32 brcmf_init_priv_mem(struct brcmf_cfg80211_priv *cfg_priv)
 {
 	cfg_priv->scan_results = kzalloc(WL_SCAN_BUF_MAX, GFP_KERNEL);
-	if (unlikely(!cfg_priv->scan_results)) {
+	if (!cfg_priv->scan_results) {
 		WL_ERR("Scan results alloc failed\n");
 		goto init_priv_mem_out;
 	}
 	cfg_priv->conf = kzalloc(sizeof(*cfg_priv->conf), GFP_KERNEL);
-	if (unlikely(!cfg_priv->conf)) {
+	if (!cfg_priv->conf) {
 		WL_ERR("wl_conf alloc failed\n");
 		goto init_priv_mem_out;
 	}
 	cfg_priv->profile = kzalloc(sizeof(*cfg_priv->profile), GFP_KERNEL);
-	if (unlikely(!cfg_priv->profile)) {
+	if (!cfg_priv->profile) {
 		WL_ERR("wl_profile alloc failed\n");
 		goto init_priv_mem_out;
 	}
 	cfg_priv->bss_info = kzalloc(WL_BSS_INFO_MAX, GFP_KERNEL);
-	if (unlikely(!cfg_priv->bss_info)) {
+	if (!cfg_priv->bss_info) {
 		WL_ERR("Bss information alloc failed\n");
 		goto init_priv_mem_out;
 	}
 	cfg_priv->scan_req_int = kzalloc(sizeof(*cfg_priv->scan_req_int),
 					 GFP_KERNEL);
-	if (unlikely(!cfg_priv->scan_req_int)) {
+	if (!cfg_priv->scan_req_int) {
 		WL_ERR("Scan req alloc failed\n");
 		goto init_priv_mem_out;
 	}
 	cfg_priv->ioctl_buf = kzalloc(WL_IOCTL_LEN_MAX, GFP_KERNEL);
-	if (unlikely(!cfg_priv->ioctl_buf)) {
+	if (!cfg_priv->ioctl_buf) {
 		WL_ERR("Ioctl buf alloc failed\n");
 		goto init_priv_mem_out;
 	}
 	cfg_priv->extra_buf = kzalloc(WL_EXTRA_BUF_MAX, GFP_KERNEL);
-	if (unlikely(!cfg_priv->extra_buf)) {
+	if (!cfg_priv->extra_buf) {
 		WL_ERR("Extra buf alloc failed\n");
 		goto init_priv_mem_out;
 	}
 	cfg_priv->iscan = kzalloc(sizeof(*cfg_priv->iscan), GFP_KERNEL);
-	if (unlikely(!cfg_priv->iscan)) {
+	if (!cfg_priv->iscan) {
 		WL_ERR("Iscan buf alloc failed\n");
 		goto init_priv_mem_out;
 	}
 	cfg_priv->pmk_list = kzalloc(sizeof(*cfg_priv->pmk_list), GFP_KERNEL);
-	if (unlikely(!cfg_priv->pmk_list)) {
+	if (!cfg_priv->pmk_list) {
 		WL_ERR("pmk list alloc failed\n");
 		goto init_priv_mem_out;
 	}
@@ -3191,7 +3188,7 @@ static struct brcmf_cfg80211_event_q *brcmf_deq_event(
 	struct brcmf_cfg80211_event_q *e = NULL;
 
 	spin_lock_irq(&cfg_priv->evt_q_lock);
-	if (likely(!list_empty(&cfg_priv->evt_q_list))) {
+	if (!list_empty(&cfg_priv->evt_q_list)) {
 		e = list_first_entry(&cfg_priv->evt_q_list,
 				     struct brcmf_cfg80211_event_q, evt_q_list);
 		list_del(&e->evt_q_list);
@@ -3213,7 +3210,7 @@ brcmf_enq_event(struct brcmf_cfg80211_priv *cfg_priv, u32 event,
 	s32 err = 0;
 
 	e = kzalloc(sizeof(struct brcmf_cfg80211_event_q), GFP_KERNEL);
-	if (unlikely(!e)) {
+	if (!e) {
 		WL_ERR("event alloc failed\n");
 		return -ENOMEM;
 	}
@@ -3296,13 +3293,13 @@ static s32 wl_init_priv(struct brcmf_cfg80211_priv *cfg_priv)
 	cfg_priv->dongle_up = false;	/* dongle is not up yet */
 	brcmf_init_eq(cfg_priv);
 	err = brcmf_init_priv_mem(cfg_priv);
-	if (unlikely(err))
+	if (err)
 		return err;
 	INIT_WORK(&cfg_priv->event_work, brcmf_cfg80211_event_handler);
 	brcmf_init_eloop_handler(&cfg_priv->el);
 	mutex_init(&cfg_priv->usr_sync);
 	err = brcmf_init_iscan(cfg_priv);
-	if (unlikely(err))
+	if (err)
 		return err;
 	brcmf_init_conf(cfg_priv->conf);
 	brcmf_init_prof(cfg_priv->profile);
@@ -3331,12 +3328,12 @@ struct brcmf_cfg80211_dev *brcmf_cfg80211_attach(struct net_device *ndev,
 	struct brcmf_cfg80211_dev *cfg_dev;
 	s32 err = 0;
 
-	if (unlikely(!ndev)) {
+	if (!ndev) {
 		WL_ERR("ndev is invalid\n");
 		return NULL;
 	}
 	cfg_dev = kzalloc(sizeof(struct brcmf_cfg80211_dev), GFP_KERNEL);
-	if (unlikely(!cfg_dev)) {
+	if (!cfg_dev) {
 		WL_ERR("wl_cfg80211_dev is invalid\n");
 		return NULL;
 	}
@@ -3357,7 +3354,7 @@ struct brcmf_cfg80211_dev *brcmf_cfg80211_attach(struct net_device *ndev,
 	SET_NETDEV_DEV(ndev, wiphy_dev(wdev->wiphy));
 	wdev->netdev = ndev;
 	err = wl_init_priv(cfg_priv);
-	if (unlikely(err)) {
+	if (err) {
 		WL_ERR("Failed to init iwm_priv (%d)\n", err);
 		goto cfg80211_attach_out;
 	}
@@ -3390,7 +3387,7 @@ brcmf_cfg80211_event(struct net_device *ndev,
 	u32 event_type = be32_to_cpu(e->event_type);
 	struct brcmf_cfg80211_priv *cfg_priv = ndev_to_cfg(ndev);
 
-	if (likely(!brcmf_enq_event(cfg_priv, event_type, e)))
+	if (!brcmf_enq_event(cfg_priv, event_type, e))
 		schedule_work(&cfg_priv->event_work);
 }
 
@@ -3418,7 +3415,7 @@ static s32 brcmf_dongle_mode(struct net_device *ndev, s32 iftype)
 		return err;
 	}
 	err = brcmf_dev_ioctl_u32(ndev, BRCMF_C_SET_INFRA, &infra);
-	if (unlikely(err)) {
+	if (err) {
 		WL_ERR("WLC_SET_INFRA error (%d)\n", err);
 		return err;
 	}
@@ -3439,7 +3436,7 @@ static s32 brcmf_dongle_eventmsg(struct net_device *ndev)
 	brcmu_mkiovar("event_msgs", eventmask, BRCMF_EVENTING_MASK_LEN, iovbuf,
 		    sizeof(iovbuf));
 	err = brcmf_dev_ioctl(ndev, BRCMF_C_GET_VAR, iovbuf, sizeof(iovbuf));
-	if (unlikely(err)) {
+	if (err) {
 		WL_ERR("Get event_msgs error (%d)\n", err);
 		goto dongle_eventmsg_out;
 	}
@@ -3468,7 +3465,7 @@ static s32 brcmf_dongle_eventmsg(struct net_device *ndev)
 	brcmu_mkiovar("event_msgs", eventmask, BRCMF_EVENTING_MASK_LEN, iovbuf,
 		    sizeof(iovbuf));
 	err = brcmf_dev_ioctl(ndev, BRCMF_C_SET_VAR, iovbuf, sizeof(iovbuf));
-	if (unlikely(err)) {
+	if (err) {
 		WL_ERR("Set event_msgs error (%d)\n", err);
 		goto dongle_eventmsg_out;
 	}
@@ -3495,7 +3492,7 @@ brcmf_dongle_roam(struct net_device *ndev, u32 roamvar, u32 bcn_timeout)
 			sizeof(bcn_timeout), iovbuf, sizeof(iovbuf));
 		err = brcmf_dev_ioctl(ndev, BRCMF_C_SET_VAR,
 				   iovbuf, sizeof(iovbuf));
-		if (unlikely(err)) {
+		if (err) {
 			WL_ERR("bcn_timeout error (%d)\n", err);
 			goto dongle_rom_out;
 		}
@@ -3509,7 +3506,7 @@ brcmf_dongle_roam(struct net_device *ndev, u32 roamvar, u32 bcn_timeout)
 	brcmu_mkiovar("roam_off", (char *)&roamvar,
 				sizeof(roamvar), iovbuf, sizeof(iovbuf));
 	err = brcmf_dev_ioctl(ndev, BRCMF_C_SET_VAR, iovbuf, sizeof(iovbuf));
-	if (unlikely(err)) {
+	if (err) {
 		WL_ERR("roam_off error (%d)\n", err);
 		goto dongle_rom_out;
 	}
@@ -3518,7 +3515,7 @@ brcmf_dongle_roam(struct net_device *ndev, u32 roamvar, u32 bcn_timeout)
 	roamtrigger[1] = BRCM_BAND_ALL;
 	err = brcmf_dev_ioctl(ndev, BRCMF_C_SET_ROAM_TRIGGER,
 			(void *)roamtrigger, sizeof(roamtrigger));
-	if (unlikely(err)) {
+	if (err) {
 		WL_ERR("WLC_SET_ROAM_TRIGGER error (%d)\n", err);
 		goto dongle_rom_out;
 	}
@@ -3527,7 +3524,7 @@ brcmf_dongle_roam(struct net_device *ndev, u32 roamvar, u32 bcn_timeout)
 	roam_delta[1] = BRCM_BAND_ALL;
 	err = brcmf_dev_ioctl(ndev, BRCMF_C_SET_ROAM_DELTA,
 				(void *)roam_delta, sizeof(roam_delta));
-	if (unlikely(err)) {
+	if (err) {
 		WL_ERR("WLC_SET_ROAM_DELTA error (%d)\n", err);
 		goto dongle_rom_out;
 	}
@@ -3584,7 +3581,7 @@ static s32 wl_update_wiphybands(struct brcmf_cfg80211_priv *cfg_priv)
 
 	err = brcmf_dev_ioctl(cfg_to_ndev(cfg_priv), BRCM_GET_PHYLIST,
 			      &phy_list, sizeof(phy_list));
-	if (unlikely(err)) {
+	if (err) {
 		WL_ERR("error (%d)\n", err);
 		return err;
 	}
@@ -3624,7 +3621,7 @@ static s32 brcmf_config_dongle(struct brcmf_cfg80211_priv *cfg_priv,
 			WL_SCAN_UNASSOC_TIME, WL_SCAN_PASSIVE_TIME);
 
 	err = brcmf_dongle_eventmsg(ndev);
-	if (unlikely(err))
+	if (err)
 		goto default_conf_out;
 
 	power_mode = cfg_priv->pwr_save ? PM_FAST : PM_OFF;
@@ -3636,13 +3633,13 @@ static s32 brcmf_config_dongle(struct brcmf_cfg80211_priv *cfg_priv,
 
 	err = brcmf_dongle_roam(ndev, (cfg_priv->roam_on ? 0 : 1),
 				WL_BEACON_TIMEOUT);
-	if (unlikely(err))
+	if (err)
 		goto default_conf_out;
 	err = brcmf_dongle_mode(ndev, wdev->iftype);
-	if (unlikely(err && err != -EINPROGRESS))
+	if (err && err != -EINPROGRESS)
 		goto default_conf_out;
 	err = brcmf_dongle_probecap(cfg_priv);
-	if (unlikely(err))
+	if (err)
 		goto default_conf_out;
 
 	/* -EINPROGRESS: Call commit handler */
@@ -3700,7 +3697,7 @@ static s32 __brcmf_cfg80211_up(struct brcmf_cfg80211_priv *cfg_priv)
 	brcmf_debugfs_add_netdev_params(cfg_priv);
 
 	err = brcmf_config_dongle(cfg_priv, false);
-	if (unlikely(err))
+	if (err)
 		return err;
 
 	brcmf_invoke_iscan(cfg_priv);
@@ -3778,7 +3775,7 @@ static __used s32 brcmf_add_ie(struct brcmf_cfg80211_priv *cfg_priv,
 	struct brcmf_cfg80211_ie *ie = &cfg_priv->ie;
 	s32 err = 0;
 
-	if (unlikely(ie->offset + l + 2 > WL_TLV_INFO_MAX)) {
+	if (ie->offset + l + 2 > WL_TLV_INFO_MAX) {
 		WL_ERR("ei crosses buffer boundary\n");
 		return -ENOSPC;
 	}
diff --git a/drivers/staging/brcm80211/brcmsmac/ampdu.c b/drivers/staging/brcm80211/brcmsmac/ampdu.c
index 47dc27a..d221a3a 100644
--- a/drivers/staging/brcm80211/brcmsmac/ampdu.c
+++ b/drivers/staging/brcm80211/brcmsmac/ampdu.c
@@ -1132,7 +1132,7 @@ brcms_c_ampdu_dotxstatus(struct ampdu_info *ampdu, struct scb *scb,
 		s2 = R_REG(&wlc->regs->frmtxstatus2);
 	}
 
-	if (likely(scb)) {
+	if (scb) {
 		scb_ampdu = &scb->scb_ampdu;
 		ini = &scb_ampdu->ini[p->priority];
 		brcms_c_ampdu_dotxstatus_complete(ampdu, scb, p, txs, s1, s2);
-- 
1.7.1



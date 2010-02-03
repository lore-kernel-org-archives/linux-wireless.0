Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx51.mymxserver.com ([85.199.173.110]:4851 "EHLO
	mx51.mymxserver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756105Ab0BCJcy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Feb 2010 04:32:54 -0500
From: Holger Schurig <holgerschurig@gmail.com>
To: linux-wireless@vger.kernel.org
Subject: Re: [PATCH] libertas: cfg80211 support
Date: Wed, 3 Feb 2010 10:31:22 +0100
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Samuel Ortiz <sameo@linux.intel.com>,
	Dan Williams <dcbw@redhat.com>,
	Holger Schurig <holgerschurig@googlemail.com>
References: <20100202000934.GA19847@sortiz.org> <20100202203643.GD2967@tuxdriver.com>
In-Reply-To: <20100202203643.GD2967@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <201002031031.22805.holgerschurig@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> I'm happy to have libertas support cfg80211.  But doesn't this
> remove the mesh support that the OLPC guys still use?

yes.


Or maybe not. I have another work-in-progress on top of my
previous v4 patch that should implement mesh. I'll post that
ASAP. Samuel can than rip things out of it :-)  Because it's a
patch on top of v4 (and not a new hs-v5 one), it's easy to see my
changes.


------------------------------------------------------------------



* made "lbs_band_2ghz" non static, re-used that array in mesh code
* twiddled some debug output
* remove unused local variable "nr_sets" in lbs_ret_scan()
* lbs_ret_scan() bails out early if scanresp->nr_sets == 0
* added some "BUG_ON(!priv->scan_req)" sanity checks
* removed carrier up/down changes during scan
* lbs_cfg_scan() schedules the scan worker immediately and
  sets priv->scan_req before that
* added some more comments
* lbs_cfg_ret_disconnect() correctly sets state to LBS_DISCONNECTED
* removed reporting of bitrate, as this is not working
* fixed noise level reporting (broken lbs_get_survey() function)
* monitor will monitor more data
* untested mesh support via nl80211/cfg80211
* lbs_scan_deinit() will now send a scan-abort message to cfg80211
  when priv->scan_req was active
* call lbs_scan_deinit() at "ifconfig wlan0 down" time. This
  also aborts the scan state inside cfg80211 and removes a BUG_ON-
  warning if a scan was active during "ifconfig wlan0 down" time.
* initialize return value in lbs_init_adapter() to avoid a warning

Signed-off-by: Holger Schurig <hs4233@mail.mn-solutions.de>

make C=1 clean, but not run throught scripts/checkpatch.pl

---
 drivers/net/wireless/libertas/cfg.c  |  108 +++++++++++++--------
 drivers/net/wireless/libertas/cfg.h  |    5 -
 drivers/net/wireless/libertas/cmd.c  |    5 -
 drivers/net/wireless/libertas/dev.h  |    3 
 drivers/net/wireless/libertas/main.c |   13 +-
 drivers/net/wireless/libertas/mesh.c |  174 ++++++++++++++++++++++++++++++-----
 drivers/net/wireless/libertas/mesh.h |   16 +--
 7 files changed, 236 insertions(+), 88 deletions(-)

--- linux-wl.orig/drivers/net/wireless/libertas/cfg.c
+++ linux-wl/drivers/net/wireless/libertas/cfg.c
@@ -64,7 +64,7 @@ static struct ieee80211_rate lbs_rates[]
 	RATETAB_ENT(540, 12, 0),
 };
 
-static struct ieee80211_supported_band lbs_band_2ghz = {
+struct ieee80211_supported_band lbs_band_2ghz = {
 	.channels = lbs_2ghz_channels,
 	.n_channels = ARRAY_SIZE(lbs_2ghz_channels),
 	.bitrates = lbs_rates,
@@ -203,7 +203,7 @@ static int lbs_add_channel_list_tlv(stru
 	header->len  = cpu_to_le16(chanscanparamsize);
 	tlv += sizeof(struct mrvl_ie_header);
 
-	/* lbs_deb_scan("scan: channels %d to %d\n", priv->scan_channel,
+	/* lbs_deb_scan("channels %d to %d\n", priv->scan_channel,
 		     last_channel); */
 	memset(tlv, 0, chanscanparamsize);
 
@@ -457,7 +457,6 @@ static int lbs_ret_scan(struct lbs_priva
 	struct cmd_ds_802_11_scan_rsp *scanresp = (void *)resp;
 	int bsssize;
 	const u8 *pos;
-	u16 nr_sets;
 	const u8 *tsfdesc;
 	int tsfsize;
 	int i;
@@ -465,8 +464,14 @@ static int lbs_ret_scan(struct lbs_priva
 
 	lbs_deb_enter(LBS_DEB_CFG80211);
 
+	/* Bail out early out if we didn't get BSS entries */
+	if (scanresp->nr_sets == 0) {
+		ret = 0;
+		goto done;
+	}
 	bsssize = get_unaligned_le16(&scanresp->bssdescriptsize);
-	nr_sets = le16_to_cpu(resp->size);
+
+	BUG_ON(!priv->scan_req);
 
 	/*
 	 * The general layout of the scan response is described in chapter
@@ -476,7 +481,7 @@ static int lbs_ret_scan(struct lbs_priva
 	 *
 	 * cmd_ds_802_11_scan_rsp
 	 *   cmd_header
-	 *   pos_size
+	 *   bssdescriptsize
 	 *   nr_sets
 	 *   bssdesc 1
 	 *     bssid
@@ -569,11 +574,11 @@ static int lbs_ret_scan(struct lbs_priva
 			struct ieee80211_channel *channel =
 				ieee80211_get_channel(wiphy, freq);
 
-			lbs_deb_scan("scan: %pM, capa %04x, chan %2d, %s, "
-				     "%d dBm\n",
+			lbs_deb_scan("%pM, capa %04x, chan %2d, "
+				     "%d dBm, %s\n",
 				     bssid, capa, chan_no,
-				     print_ssid(ssid_buf, ssid, ssid_len),
-				     LBS_SCAN_RSSI_TO_MBM(rssi)/100);
+				     LBS_SCAN_RSSI_TO_MBM(rssi)/100,
+				     print_ssid(ssid_buf, ssid, ssid_len));
 
 			if (channel ||
 			    !(channel->flags & IEEE80211_CHAN_DISABLED))
@@ -614,24 +619,23 @@ static void lbs_scan_worker(struct work_
 	struct cmd_ds_802_11_scan *scan_cmd;
 	u8 *tlv; /* pointer into our current, growing TLV storage area */
 	int last_channel;
-	int running, carrier;
+	int running;
 
 	lbs_deb_enter(LBS_DEB_SCAN);
 
+	BUG_ON(!priv->scan_req);
+
 	scan_cmd = kzalloc(LBS_SCAN_MAX_CMD_SIZE, GFP_KERNEL);
 	if (scan_cmd == NULL)
-		goto out_no_scan_cmd;
+		goto done;
 
 	/* prepare fixed part of scan command */
 	scan_cmd->bsstype = CMD_BSS_TYPE_ANY;
 
 	/* stop network while we're away from our main channel */
 	running = !netif_queue_stopped(priv->dev);
-	carrier = netif_carrier_ok(priv->dev);
 	if (running)
 		netif_stop_queue(priv->dev);
-	if (carrier)
-		netif_carrier_off(priv->dev);
 
 	/* prepare fixed part of scan command */
 	tlv = scan_cmd->tlvbuffer;
@@ -669,6 +673,10 @@ static void lbs_scan_worker(struct work_
 		le16_to_cpu(scan_cmd->hdr.size),
 		lbs_ret_scan, 0);
 
+	/* __lbs_cmd() can possibly schedule, so make sure things are
+	 * still sane */
+	BUG_ON(!priv->scan_req);
+
 	if (priv->scan_channel >= priv->scan_req->n_channels) {
 		/* Mark scan done */
 		cfg80211_scan_done(priv->scan_req, false);
@@ -676,14 +684,11 @@ static void lbs_scan_worker(struct work_
 	}
 
 	/* Restart network */
-	if (carrier)
-		netif_carrier_on(priv->dev);
 	if (running && !priv->tx_pending_len)
 		netif_wake_queue(priv->dev);
 
 	kfree(scan_cmd);
-
- out_no_scan_cmd:
+ done:
 	lbs_deb_leave(LBS_DEB_SCAN);
 }
 
@@ -703,18 +708,16 @@ static int lbs_cfg_scan(struct wiphy *wi
 		goto out;
 	}
 
-	lbs_deb_scan("scan: ssids %d, channels %d, ie_len %d\n",
+	lbs_deb_scan("ssids %d, channels %d, ie_len %d\n",
 		request->n_ssids, request->n_channels, request->ie_len);
 
 	priv->scan_channel = 0;
-	queue_delayed_work(priv->work_thread, &priv->scan_work,
-		msecs_to_jiffies(50));
+	priv->scan_req = request;
+	queue_delayed_work(priv->work_thread, &priv->scan_work, 0);
 
 	if (priv->surpriseremoved)
 		ret = -EIO;
 
-	priv->scan_req = request;
-
  out:
 	lbs_deb_leave_args(LBS_DEB_CFG80211, "ret %d", ret);
 	return ret;
@@ -901,7 +904,7 @@ static int lbs_set_key_material(struct l
 	struct cmd_key_material cmd;
 	int ret;
 
-	lbs_deb_enter(LBS_DEB_CFG80211);
+	lbs_deb_enter_args(LBS_DEB_CFG80211, "len %d", key_len);
 
 	/*
 	 * Example for WPA (TKIP):
@@ -910,8 +913,8 @@ static int lbs_set_key_material(struct l
 	 * size      34 00
 	 * sequence  xx xx
 	 * result    00 00
-	 * action    01 00
-	 * TLV type  00 01    key param
+	 * action    01 00    CMD_ACT_SET
+	 * TLV type  00 01    TLV_TYPE_KEY_MATERIAL
 	 * length    00 26
 	 * key type  01 00    TKIP
 	 * key info  06 00    UNICAST | ENABLED
@@ -948,7 +951,7 @@ static int lbs_set_authtype(struct lbs_p
 	struct cmd_ds_802_11_authenticate cmd;
 	int ret;
 
-	lbs_deb_enter_args(LBS_DEB_CFG80211, "%d", sme->auth_type);
+	lbs_deb_enter_args(LBS_DEB_ASSOC, "%d", sme->auth_type);
 
 	/*
 	 * cmd        11 00
@@ -972,7 +975,7 @@ static int lbs_set_authtype(struct lbs_p
 	ret = lbs_cmd_with_response(priv, CMD_802_11_AUTHENTICATE, &cmd);
 
  done:
-	lbs_deb_leave_args(LBS_DEB_CFG80211, "ret %d", ret);
+	lbs_deb_leave_args(LBS_DEB_ASSOC, "ret %d", ret);
 	return ret;
 }
 
@@ -1002,7 +1005,7 @@ static int lbs_associate(struct lbs_priv
 	int ret;
 	u8 *pos = &(cmd->iebuf[0]);
 
-	lbs_deb_enter(LBS_DEB_CFG80211);
+	lbs_deb_enter(LBS_DEB_ASSOC);
 
 	if (!cmd) {
 		ret = -ENOMEM;
@@ -1121,7 +1124,7 @@ static int lbs_associate(struct lbs_priv
 
 
 done:
-	lbs_deb_leave_args(LBS_DEB_CFG80211, "ret %d", ret);
+	lbs_deb_leave_args(LBS_DEB_ASSOC, "ret %d", ret);
 	return ret;
 }
 
@@ -1162,7 +1165,7 @@ static int lbs_cfg_connect(struct wiphy 
 
 
 	if (!bss) {
-		lbs_pr_err("assicate: bss %pM not in scan results\n",
+		lbs_pr_err("associate: BSS %pM not in scan results\n",
 			   sme->bssid);
 		ret = -ENOENT;
 		goto done;
@@ -1185,10 +1188,14 @@ static int lbs_cfg_connect(struct wiphy 
 		priv->wep_tx_key = sme->key_idx;
 		priv->wep_key_len[sme->key_idx] = sme->key_len;
 		memcpy(priv->wep_key[sme->key_idx], sme->key, sme->key_len);
+
 		/* Set WEP keys and WEP mode */
 		lbs_set_wep_keys(priv);
+
+		/* Enable WEP mode in the MAC */
 		priv->mac_control |= CMD_ACT_MAC_WEP_ENABLE;
 		lbs_set_mac_control(priv);
+
 		/* No RSN mode for WEP */
 		lbs_enable_rsn(priv, 0);
 		break;
@@ -1204,6 +1211,8 @@ static int lbs_cfg_connect(struct wiphy 
 	case WLAN_CIPHER_SUITE_CCMP:
 		/* Remove WEP keys and WEP mode */
 		lbs_remove_wep_keys(priv);
+
+		/* Disable WEP mode in MAC */
 		priv->mac_control &= ~CMD_ACT_MAC_WEP_ENABLE;
 		lbs_set_mac_control(priv);
 
@@ -1216,6 +1225,7 @@ static int lbs_cfg_connect(struct wiphy 
 			KEY_TYPE_ID_WEP, /* doesn't matter */
 			KEY_INFO_WPA_MCAST,
 			NULL, 0);
+
 		/* RSN mode for WPA/WPA2 */
 		lbs_enable_rsn(priv, sme->crypto.cipher_group != 0);
 		break;
@@ -1246,7 +1256,7 @@ static int lbs_cfg_connect(struct wiphy 
 static int lbs_cfg_ret_disconnect(struct lbs_private *priv, unsigned long dummy,
 			      struct cmd_header *resp)
 {
-	lbs_deb_enter(LBS_DEB_CFG80211);
+	lbs_deb_enter(LBS_DEB_ASSOC);
 
 	cfg80211_disconnected(priv->dev,
 			      priv->disassoc_reason,
@@ -1254,9 +1264,10 @@ static int lbs_cfg_ret_disconnect(struct
 			      GFP_KERNEL);
 
 	/* TODO: get rid of priv->connect_status */
-	priv->connect_status = LBS_CONNECTED;
+	priv->connect_status = LBS_DISCONNECTED;
+	netif_carrier_off(priv->dev);
 
-	lbs_deb_leave(LBS_DEB_CFG80211);
+	lbs_deb_leave(LBS_DEB_ASSOC);
 	return 0;
 }
 
@@ -1427,7 +1438,7 @@ static int lbs_enable_monitor_mode(struc
 	 * sequence  xx xx
 	 * result    00 00
 	 * action    01 00    ACT_SET
-	 * enable    01 00
+	 * enable    01 00    bitmask (1=data, 2=ctrl, 4=beacon)
 	 */
 	memset(&cmd, 0, sizeof(cmd));
 	cmd.hdr.size = cpu_to_le16(sizeof(cmd));
@@ -1493,7 +1504,6 @@ static int lbs_cfg_get_station(struct wi
 	struct lbs_private *priv = wiphy_priv(wiphy);
 	s8 signal, noise;
 	int ret;
-	size_t i;
 
 	lbs_deb_enter(LBS_DEB_CFG80211);
 
@@ -1513,14 +1523,20 @@ static int lbs_cfg_get_station(struct wi
 		sinfo->filled |= STATION_INFO_SIGNAL;
 	}
 
+#ifdef TODO
+	size_t i;
+
+	/* "iw wlan link" says "failed to parse nested attributes!" */
+
 	/* Convert priv->cur_rate from hw_value to NL80211 value */
 	for (i = 0; i < ARRAY_SIZE(lbs_rates); i++) {
-		if (priv->cur_rate == lbs_rates[i].hw_value) {
-			sinfo->txrate.legacy = lbs_rates[i].bitrate;
+		if (priv->cur_rate == lbs_rates[i].bitrate) {
+			sinfo->txrate.legacy = lbs_rates[i].bitrate * 10;
 			sinfo->filled |= STATION_INFO_TX_BITRATE;
 			break;
 		}
 	}
+#endif
 
 	return 0;
 }
@@ -1539,8 +1555,10 @@ static int lbs_get_survey(struct wiphy *
 	s8 signal, noise;
 	int ret;
 
-	if (idx != 0)
+	if (idx != 0) {
 		ret = -ENOENT;
+		goto out;
+	}
 
 	lbs_deb_enter(LBS_DEB_CFG80211);
 
@@ -1554,6 +1572,7 @@ static int lbs_get_survey(struct wiphy *
 	}
 
 	lbs_deb_leave_args(LBS_DEB_CFG80211, "ret %d", ret);
+out:
 	return ret;
 }
 
@@ -1575,7 +1594,7 @@ static int lbs_change_intf(struct wiphy 
 
 	switch (type) {
 	case NL80211_IFTYPE_MONITOR:
-		ret = lbs_enable_monitor_mode(priv, 1);
+		ret = lbs_enable_monitor_mode(priv, 0x07);
 		break;
 	case NL80211_IFTYPE_STATION:
 		if (priv->wdev->iftype == NL80211_IFTYPE_MONITOR)
@@ -2076,8 +2095,15 @@ int lbs_cfg_register(struct lbs_private 
 
 void lbs_scan_deinit(struct lbs_private *priv)
 {
-	lbs_deb_enter(LBS_DEB_CFG80211);
+	lbs_deb_enter(LBS_DEB_SCAN);
+
 	cancel_delayed_work_sync(&priv->scan_work);
+	if (priv->scan_req) {
+		cfg80211_scan_done(priv->scan_req, true);
+		priv->scan_req = NULL;
+	}
+
+	lbs_deb_leave(LBS_DEB_SCAN);
 }
 
 
--- linux-wl.orig/drivers/net/wireless/libertas/mesh.c
+++ linux-wl/drivers/net/wireless/libertas/mesh.c
@@ -5,13 +5,130 @@
 #include <linux/if_arp.h>
 #include <linux/kthread.h>
 #include <linux/kfifo.h>
+#include <net/cfg80211.h>
 
 #include "mesh.h"
+#include "cfg.h"
 #include "decl.h"
 #include "cmd.h"
 
 
 /***************************************************************************
+ * Mesh cfg80211 support
+ */
+
+static int lbs_join_mesh(struct wiphy *wiphy, struct net_device *dev,
+		struct cfg80211_ibss_params *params)
+{
+	struct lbs_private *priv = wiphy_priv(wiphy);
+	int ret = 0;
+	DECLARE_SSID_BUF(ssid_buf);
+
+	lbs_deb_enter(LBS_DEB_CFG80211);
+
+	if (!params->channel) {
+		ret = -ENOTSUPP;
+		goto out;
+	}
+
+	/* If channel != current channel AND if we're connected, then this
+	 * won't work */
+
+	ret = lbs_set_channel(priv, params->channel->hw_value);
+	if (ret)
+		goto out;
+
+	//TODO
+	// CMD_ACT_MESH_CONFIG_START
+ out:
+	lbs_deb_leave_args(LBS_DEB_CFG80211, "ret %d", ret);
+	return ret;
+}
+
+
+static int lbs_leave_mesh(struct wiphy *wiphy, struct net_device *dev)
+{
+	//struct lbs_private *priv = wiphy_priv(wiphy);
+	//struct cmd_ds_802_11_ad_hoc_stop cmd;
+	int ret = 0;
+
+	lbs_deb_enter(LBS_DEB_CFG80211);
+
+	//TODO
+
+	lbs_deb_leave_args(LBS_DEB_CFG80211, "ret %d", ret);
+	return ret;
+}
+
+
+static struct cfg80211_ops lbs_cfg80211_mesh_ops = {
+	.join_ibss = lbs_join_mesh,
+	.leave_ibss = lbs_leave_mesh,
+};
+
+
+static struct wireless_dev *lbs_cfg_alloc_mesh(struct lbs_private *priv)
+{
+	int ret = 0;
+	struct wireless_dev *wdev;
+
+	lbs_deb_enter(LBS_DEB_MESH);
+
+	wdev = kzalloc(sizeof(struct wireless_dev), GFP_KERNEL);
+	if (!wdev) {
+		lbs_pr_err("cannot allocate mesh wireless device\n");
+		return ERR_PTR(-ENOMEM);
+	}
+
+	wdev->wiphy = wiphy_new(&lbs_cfg80211_mesh_ops, 0);
+	if (!wdev->wiphy) {
+		lbs_pr_err("cannot allocate mesh wiphy\n");
+		ret = -ENOMEM;
+		goto err_wiphy_new;
+	}
+	wdev->iftype = NL80211_IFTYPE_ADHOC; //TODO: is this right?
+
+	lbs_deb_leave(LBS_DEB_MESH);
+	return wdev;
+
+ err_wiphy_new:
+	kfree(wdev);
+	lbs_deb_leave_args(LBS_DEB_MESH, "ret %d", ret);
+	return ERR_PTR(ret);
+}
+
+static int lbs_mesh_register(struct lbs_private *priv)
+{
+	struct wireless_dev *wdev = priv->mesh_wdev;
+	int ret;
+
+	lbs_deb_enter(LBS_DEB_MESH);
+
+	wdev->wiphy->max_scan_ssids = 1;
+	wdev->wiphy->signal_type = CFG80211_SIGNAL_TYPE_MBM;
+
+	wdev->wiphy->interface_modes = BIT(NL80211_IFTYPE_ADHOC);
+
+	wdev->wiphy->bands[IEEE80211_BAND_2GHZ] = &lbs_band_2ghz;
+
+	/*
+	 * We could check priv->fwcapinfo && FW_CAPINFO_WPA, but I have
+	 * never seen a firmware without WPA
+	 */
+	//wdev->wiphy->cipher_suites = cipher_suites;
+	//wdev->wiphy->n_cipher_suites = ARRAY_SIZE(cipher_suites);
+
+	ret = wiphy_register(wdev->wiphy);
+	if (ret < 0)
+		lbs_pr_err("cannot register mesh wiphy device\n");
+
+	lbs_deb_leave_args(LBS_DEB_MESH, "ret %d", ret);
+	return ret;
+}
+
+
+
+/***************************************************************************
  * Mesh sysfs support
  */
 
@@ -185,14 +302,14 @@ static struct attribute_group lbs_mesh_a
  * Initializing and starting, stopping mesh
  */
 
+
 /*
  * Check mesh FW version and appropriately send the mesh start
  * command
  */
-int lbs_init_mesh(struct lbs_private *priv)
+void lbs_init_mesh(struct lbs_private *priv)
 {
 	struct net_device *dev = priv->dev;
-	int ret = 0;
 
 	lbs_deb_enter(LBS_DEB_MESH);
 
@@ -237,31 +354,41 @@ int lbs_init_mesh(struct lbs_private *pr
 			priv->mesh_tlv = 0;
 	}
 
+	if (!priv->mesh_tlv)
+		goto out;
 
-	if (priv->mesh_tlv) {
-		sprintf(priv->mesh_ssid, "mesh");
-		priv->mesh_ssid_len = 4;
-
-		lbs_add_mesh(priv);
-
-		if (device_create_file(&dev->dev, &dev_attr_lbs_mesh))
-			lbs_pr_err("cannot register lbs_mesh attribute\n");
+	lbs_deb_mesh("using %s mesh commands\n",
+		     priv->mesh_tlv == TLV_TYPE_OLD_MESH_ID
+		     ? "old" : "new");
+	sprintf(priv->mesh_ssid, "mesh");
+	priv->mesh_ssid_len = 4;
+
+	priv->mesh_wdev = lbs_cfg_alloc_mesh(priv);
+	lbs_add_mesh(priv);
+	lbs_mesh_register(priv);
 
-		ret = 1;
-	}
+	if (device_create_file(&dev->dev, &dev_attr_lbs_mesh))
+		lbs_pr_err("cannot register lbs_mesh attribute\n");
 
-	lbs_deb_leave_args(LBS_DEB_MESH, "ret %d", ret);
-	return ret;
+out:
+	lbs_deb_leave(LBS_DEB_MESH);
 }
 
 
 int lbs_deinit_mesh(struct lbs_private *priv)
 {
 	struct net_device *dev = priv->dev;
+	struct wireless_dev *mesh_wdev = priv->mesh_wdev;
 	int ret = 0;
 
 	lbs_deb_enter(LBS_DEB_MESH);
 
+	if (mesh_wdev) {
+		if (mesh_wdev->wiphy)
+			wiphy_unregister(mesh_wdev->wiphy);
+		wiphy_free(mesh_wdev->wiphy);
+	}
+
 	if (priv->mesh_tlv) {
 		device_remove_file(&dev->dev, &dev_attr_lbs_mesh);
 		ret = 1;
@@ -283,6 +410,7 @@ static int lbs_mesh_stop(struct net_devi
 	struct lbs_private *priv = dev->ml_priv;
 
 	lbs_deb_enter(LBS_DEB_MESH);
+
 	spin_lock_irq(&priv->driver_lock);
 
 	priv->mesh_open = 0;
@@ -310,16 +438,14 @@ static int lbs_mesh_dev_open(struct net_
 	struct lbs_private *priv = dev->ml_priv;
 	int ret = 0;
 
-	lbs_deb_enter(LBS_DEB_NET);
+	lbs_deb_enter(LBS_DEB_MESH);
 
 	spin_lock_irq(&priv->driver_lock);
 
-#ifdef TODO
-	if (priv->monitormode) {
+ 	if (priv->wdev->iftype == NL80211_IFTYPE_MONITOR) {
 		ret = -EBUSY;
 		goto out;
 	}
-#endif
 
 	priv->mesh_open = 1;
 	priv->mesh_connect_status = LBS_CONNECTED;
@@ -329,7 +455,7 @@ static int lbs_mesh_dev_open(struct net_
 		netif_wake_queue(dev);
 
 	spin_unlock_irq(&priv->driver_lock);
-	lbs_deb_leave_args(LBS_DEB_NET, "ret %d", ret);
+	lbs_deb_leave_args(LBS_DEB_MESH, "ret %d", ret);
 	return ret;
 }
 
@@ -364,16 +490,15 @@ int lbs_add_mesh(struct lbs_private *pri
 	mesh_dev->ml_priv = priv;
 	priv->mesh_dev = mesh_dev;
 
+	//TODO mesh_dev->ieee80211_ptr = priv->mesh_wdev;
 	mesh_dev->netdev_ops = &mesh_netdev_ops;
 	mesh_dev->ethtool_ops = &lbs_ethtool_ops;
 	memcpy(mesh_dev->dev_addr, priv->dev->dev_addr, ETH_ALEN);
 
 	SET_NETDEV_DEV(priv->mesh_dev, priv->dev->dev.parent);
 
-#ifdef	WIRELESS_EXT
-	mesh_dev->wireless_handlers = &mesh_handler_def;
-#endif
 	mesh_dev->flags |= IFF_BROADCAST | IFF_MULTICAST;
+
 	/* Register virtual mesh interface */
 	ret = register_netdev(mesh_dev);
 	if (ret) {
@@ -404,13 +529,13 @@ done:
 
 void lbs_remove_mesh(struct lbs_private *priv)
 {
-	struct net_device *mesh_dev;
+	struct net_device *mesh_dev = priv->mesh_dev;
 
-	mesh_dev = priv->mesh_dev;
 	if (!mesh_dev)
 		return;
 
 	lbs_deb_enter(LBS_DEB_MESH);
+
 	netif_stop_queue(mesh_dev);
 	netif_carrier_off(mesh_dev);
 	sysfs_remove_group(&(mesh_dev->dev.kobj), &lbs_mesh_attr_group);
@@ -418,6 +543,7 @@ void lbs_remove_mesh(struct lbs_private 
 	unregister_netdev(mesh_dev);
 	priv->mesh_dev = NULL;
 	free_netdev(mesh_dev);
+
 	lbs_deb_leave(LBS_DEB_MESH);
 }
 
--- linux-wl.orig/drivers/net/wireless/libertas/cfg.h
+++ linux-wl/drivers/net/wireless/libertas/cfg.h
@@ -1,9 +1,12 @@
 #ifndef __LBS_CFG80211_H__
 #define __LBS_CFG80211_H__
 
-struct device;
+#include <net/cfg80211.h>
+
 struct lbs_private;
 
+extern struct ieee80211_supported_band lbs_band_2ghz;
+
 struct wireless_dev *lbs_cfg_alloc(struct device *dev);
 int lbs_cfg_register(struct lbs_private *priv);
 void lbs_cfg_free(struct lbs_private *priv);
--- linux-wl.orig/drivers/net/wireless/libertas/dev.h
+++ linux-wl/drivers/net/wireless/libertas/dev.h
@@ -40,8 +40,9 @@ struct lbs_private {
 	u8 disassoc_reason;
 
 	/* Mesh */
-	struct net_device *mesh_dev; /* Virtual device */
+	struct net_device *mesh_dev;
 #ifdef CONFIG_LIBERTAS_MESH
+	struct wireless_dev *mesh_wdev;
 	u32 mesh_connect_status;
 	struct lbs_mesh_stats mstats;
 	int mesh_open;
--- linux-wl.orig/drivers/net/wireless/libertas/main.c
+++ linux-wl/drivers/net/wireless/libertas/main.c
@@ -129,6 +129,8 @@ static int lbs_eth_stop(struct net_devic
 
 	lbs_deb_enter(LBS_DEB_NET);
 
+	lbs_scan_deinit(priv);
+
 	spin_lock_irq(&priv->driver_lock);
 	netif_stop_queue(dev);
 	spin_unlock_irq(&priv->driver_lock);
@@ -730,7 +732,7 @@ int lbs_exit_auto_deep_sleep(struct lbs_
 
 static int lbs_init_adapter(struct lbs_private *priv)
 {
-	int ret;
+	int ret = 0;
 
 	lbs_deb_enter(LBS_DEB_MAIN);
 
@@ -899,17 +901,12 @@ void lbs_remove_card(struct lbs_private 
 
 	lbs_remove_mesh(priv);
 	lbs_scan_deinit(priv);
-
-	dev = priv->dev;
-
 	cancel_work_sync(&priv->mcast_work);
 
 	/* worker thread destruction blocks on the in-flight command which
 	 * should have been cleared already in lbs_stop_card().
 	 */
-	lbs_deb_main("destroying worker thread\n");
 	destroy_workqueue(priv->work_thread);
-	lbs_deb_main("done destroying worker thread\n");
 
 	if (priv->psmode == LBS802_11POWERMODEMAX_PSP) {
 		priv->psmode = LBS802_11POWERMODECAM;
@@ -1036,7 +1033,7 @@ void lbs_queue_event(struct lbs_private 
 {
 	unsigned long flags;
 
-	lbs_deb_enter(LBS_DEB_THREAD);
+	lbs_deb_enter_args(LBS_DEB_CMD, "event %d", event);
 	spin_lock_irqsave(&priv->driver_lock, flags);
 
 	if (priv->psstate == PS_STATE_SLEEP)
@@ -1047,7 +1044,7 @@ void lbs_queue_event(struct lbs_private 
 	wake_up_interruptible(&priv->waitq);
 
 	spin_unlock_irqrestore(&priv->driver_lock, flags);
-	lbs_deb_leave(LBS_DEB_THREAD);
+	lbs_deb_leave(LBS_DEB_CMD);
 }
 EXPORT_SYMBOL_GPL(lbs_queue_event);
 
--- linux-wl.orig/drivers/net/wireless/libertas/mesh.h
+++ linux-wl/drivers/net/wireless/libertas/mesh.h
@@ -11,6 +11,11 @@
 
 #ifdef CONFIG_LIBERTAS_MESH
 
+
+struct net_device;
+struct lbs_private;
+
+
 /* Mesh statistics */
 struct lbs_mesh_stats {
 	u32	fwd_bcast_cnt;		/* Fwd: Broadcast counter */
@@ -24,10 +29,8 @@ struct lbs_mesh_stats {
 };
 
 
-struct net_device;
-struct lbs_private;
-
-int lbs_init_mesh(struct lbs_private *priv);
+/* Initialization */
+void lbs_init_mesh(struct lbs_private *priv);
 int lbs_deinit_mesh(struct lbs_private *priv);
 
 int lbs_add_mesh(struct lbs_private *priv);
@@ -70,11 +73,6 @@ void lbs_persist_config_init(struct net_
 void lbs_persist_config_remove(struct net_device *net);
 
 
-/* WEXT handler */
-
-extern struct iw_handler_def mesh_handler_def;
-
-
 /* Ethtool statistics */
 
 struct ethtool_stats;
--- linux-wl.orig/drivers/net/wireless/libertas/cmd.c
+++ linux-wl/drivers/net/wireless/libertas/cmd.c
@@ -81,8 +81,6 @@ static int lbs_is_cmd_allowed(struct lbs
 {
 	int ret = 1;
 
-	lbs_deb_enter(LBS_DEB_CMD);
-
 	if (!priv->is_auto_deep_sleep_enabled) {
 		if (priv->is_deep_sleep) {
 			lbs_deb_cmd("command not allowed in deep sleep\n");
@@ -90,7 +88,6 @@ static int lbs_is_cmd_allowed(struct lbs
 		}
 	}
 
-	lbs_deb_leave(LBS_DEB_CMD);
 	return ret;
 }
 
@@ -864,7 +861,7 @@ void lbs_set_mac_control(struct lbs_priv
 {
 	struct cmd_ds_mac_control cmd;
 
-	lbs_deb_enter(LBS_DEB_CMD);
+	lbs_deb_enter_args(LBS_DEB_CMD, "0x%04x", priv->mac_control);
 
 	cmd.hdr.size = cpu_to_le16(sizeof(cmd));
 	cmd.action = cpu_to_le16(priv->mac_control);

-- 
http://www.holgerschurig.de

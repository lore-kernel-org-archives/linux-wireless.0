Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s131.mittwaldmedien.de ([62.216.178.31]:11963 "EHLO
	s131.mittwaldmedien.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751088AbYFSPEX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 19 Jun 2008 11:04:23 -0400
From: Holger Schurig <hs4233@mail.mn-solutions.de>
To: "John W. Linville" <linville@tuxdriver.com>,
	Dan Williams <dcbw@redhat.com>, linux-wireless@vger.kernel.org,
	libertas-dev@lists.infradead.org
Subject: [PATCH] libertas: make mesh code configurable
Date: Thu, 19 Jun 2008 17:04:10 +0200
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200806191704.10297.hs4233@mail.mn-solutions.de> (sfid-20080619_170429_512985_CDD100EA)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

There are no known firmwares for CF and SDIO based devices that
support MESH. For those devices, mesh-support in the driver is just
a bit of bloat. Moreover, they're mostly used in embedded devices,
where space counts.

This patch saves about 10 kB in .text and 288 bytes in .data:

 129542    4012      28  133582   209ce libertas.ko
 119279    3724      28  123031   1e097 nomesh/libertas.ko

   8142     840       0    8982    2316 libertas_cs.ko
   8134     840       0    8974    230e nomesh/libertas_cs.ko

   9516     700       8   10224    27f0 libertas_sdio.ko
   9516     700       8   10224    27f0 nomesh/libertas_sdio.ko

  10333     860       0   11193    2bb9 usb8xxx.ko
  10333     860       0   11193    2bb9 nomesh/usb8xxx.ko

Signed-off-by: Holger Schurig <hs4233@mail.mn-solutions.de>

--- wireless-testing.orig/drivers/net/wireless/Kconfig
+++ wireless-testing/drivers/net/wireless/Kconfig
@@ -294,6 +294,13 @@
 	---help---
 	  A driver for Marvell Libertas 8385 and 8686 SDIO devices.
 
+config LIBERTAS_MESH
+	bool "Support 802.11s mesh support."
+	depends on LIBERTAS
+	---help---
+	  This needs a special firmware, which only seems to exist for USB
+	  dongles.
+
 config LIBERTAS_DEBUG
 	bool "Enable full debugging output in the Libertas module."
 	depends on LIBERTAS
--- wireless-testing.orig/drivers/net/wireless/libertas/decl.h
+++ wireless-testing/drivers/net/wireless/libertas/decl.h
@@ -17,6 +17,14 @@
 struct cmd_ctrl_node;
 struct cmd_ds_command;
 
+#ifdef CONFIG_LIBERTAS_MESH
+#define lbs_mesh_open(priv) (priv->mesh_open)
+#define lbs_mesh_connected(priv) (priv->mesh_connect_status != LBS_CONNECTED)
+#else
+#define lbs_mesh_open(priv) (0)
+#define lbs_mesh_connected(priv) (0)
+#endif
+
 void lbs_set_mac_control(struct lbs_private *priv);
 
 void lbs_send_tx_feedback(struct lbs_private *priv, u32 try_count);
--- wireless-testing.orig/drivers/net/wireless/libertas/dev.h
+++ wireless-testing/drivers/net/wireless/libertas/dev.h
@@ -86,6 +86,7 @@
 	uint16_t sp_reserved;
 };
 
+#ifdef CONFIG_LIBERTAS_MESH
 /* Mesh statistics */
 struct lbs_mesh_stats {
 	u32	fwd_bcast_cnt;		/* Fwd: Broadcast counter */
@@ -97,12 +98,15 @@
 	u32	drop_blind;		/* Rx:  Dropped by blinding table */
 	u32	tx_failed_cnt;		/* Tx:  Failed transmissions */
 };
+#endif
 
 /** Private structure for the MV device */
 struct lbs_private {
-	int mesh_open;
 	int infra_open;
+#ifdef CONFIG_LIBERTAS_MESH
+	int mesh_open;
 	int mesh_autostart_enabled;
+#endif
 
 	char name[DEV_NAME_LEN];
 
@@ -110,11 +114,16 @@
 	struct net_device *dev;
 
 	struct net_device_stats stats;
-	struct net_device *mesh_dev; /* Virtual device */
 	struct net_device *rtap_net_dev;
+#ifdef CONFIG_LIBERTAS_MESH
+	struct net_device *mesh_dev; /* Virtual device */
+#endif
 
 	struct iw_statistics wstats;
+#ifdef CONFIG_LIBERTAS_MESH
 	struct lbs_mesh_stats mstats;
+#endif
+
 	struct dentry *debugfs_dir;
 	struct dentry *debugfs_debug;
 	struct dentry *debugfs_files[6];
@@ -210,9 +219,11 @@
 	/** current ssid/bssid related parameters*/
 	struct current_bss_params curbssparams;
 
+#ifdef CONFIG_LIBERTAS_MESH
 	uint16_t mesh_tlv;
 	u8 mesh_ssid[IW_ESSID_MAX_SIZE + 1];
 	u8 mesh_ssid_len;
+#endif
 
 	/* IW_MODE_* */
 	u8 mode;
@@ -251,9 +262,11 @@
 	/** NIC Operation characteristics */
 	u16 mac_control;
 	u32 connect_status;
-	u32 mesh_connect_status;
 	u16 regioncode;
 	u16 txpowerlevel;
+#ifdef CONFIG_LIBERTAS_MESH
+	u32 mesh_connect_status;
+#endif
 
 	/** POWER MANAGEMENT AND PnP SUPPORT */
 	u8 surpriseremoved;
@@ -354,7 +367,9 @@
 	u8 rsn_ie[MAX_WPA_IE_LEN];
 	size_t rsn_ie_len;
 
+#ifdef CONFIG_LIBERTAS_MESH
 	u8 mesh;
+#endif
 
 	struct list_head list;
 };
--- wireless-testing.orig/drivers/net/wireless/libertas/main.c
+++ wireless-testing/drivers/net/wireless/libertas/main.c
@@ -217,6 +217,7 @@
  * Attributes exported through sysfs
  */
 
+#ifdef CONFIG_LIBERTAS_MESH
 /**
  * @brief Get function for sysfs attribute anycast_mask
  */
@@ -258,10 +259,12 @@
 	return strlen(buf);
 }
 
-static int lbs_add_rtap(struct lbs_private *priv);
-static void lbs_remove_rtap(struct lbs_private *priv);
 static int lbs_add_mesh(struct lbs_private *priv);
 static void lbs_remove_mesh(struct lbs_private *priv);
+#endif
+
+static int lbs_add_rtap(struct lbs_private *priv);
+static void lbs_remove_rtap(struct lbs_private *priv);
 
 
 /**
@@ -288,7 +291,7 @@
 		if (priv->monitormode == monitor_mode)
 			return strlen(buf);
 		if (!priv->monitormode) {
-			if (priv->infra_open || priv->mesh_open)
+			if (priv->infra_open || lbs_mesh_open(priv))
 				return -EBUSY;
 			if (priv->mode == IW_MODE_INFRA)
 				lbs_send_deauthentication(priv);
@@ -326,6 +329,7 @@
  */
 static DEVICE_ATTR(lbs_rtap, 0644, lbs_rtap_get, lbs_rtap_set );
 
+#ifdef CONFIG_LIBERTAS_MESH
 /**
  * Get function for sysfs attribute mesh
  */
@@ -384,6 +388,7 @@
 static struct attribute_group lbs_mesh_attr_group = {
 	.attrs = lbs_mesh_sysfs_entries,
 };
+#endif
 
 /**
  *  @brief This function opens the ethX or mshX interface
@@ -405,11 +410,14 @@
 		goto out;
 	}
 
+#ifdef CONFIG_LIBERTAS_MESH
 	if (dev == priv->mesh_dev) {
 		priv->mesh_open = 1;
 		priv->mesh_connect_status = LBS_CONNECTED;
 		netif_carrier_on(dev);
-	} else {
+	} else
+#endif
+	{
 		priv->infra_open = 1;
 
 		if (priv->connect_status == LBS_CONNECTED)
@@ -427,6 +435,7 @@
 	return ret;
 }
 
+#ifdef CONFIG_LIBERTAS_MESH
 /**
  *  @brief This function closes the mshX interface
  *
@@ -453,6 +462,7 @@
 	lbs_deb_leave(LBS_DEB_MESH);
 	return 0;
 }
+#endif
 
 /**
  *  @brief This function closes the ethX interface
@@ -561,8 +571,10 @@
 
 	memcpy(priv->current_addr, phwaddr->sa_data, ETH_ALEN);
 	memcpy(dev->dev_addr, phwaddr->sa_data, ETH_ALEN);
+#ifdef CONFIG_LIBERTAS_MESH
 	if (priv->mesh_dev)
 		memcpy(priv->mesh_dev->dev_addr, phwaddr->sa_data, ETH_ALEN);
+#endif
 
 done:
 	lbs_deb_leave_args(LBS_DEB_NET, "ret %d", ret);
@@ -626,8 +638,10 @@
 	lbs_deb_enter(LBS_DEB_NET);
 
 	dev_flags = priv->dev->flags;
+#ifdef CONFIG_LIBERTAS_MESH
 	if (priv->mesh_dev)
 		dev_flags |= priv->mesh_dev->flags;
+#endif
 
 	if (dev_flags & IFF_PROMISC) {
 		priv->mac_control |= CMD_ACT_MAC_PROMISCUOUS_ENABLE;
@@ -644,8 +658,10 @@
 
 	/* Once for priv->dev, again for priv->mesh_dev if it exists */
 	nr_addrs = lbs_add_mcast_addrs(&mcast_cmd, priv->dev, 0);
+#ifdef CONFIG_LIBERTAS_MESH
 	if (nr_addrs >= 0 && priv->mesh_dev)
 		nr_addrs = lbs_add_mcast_addrs(&mcast_cmd, priv->mesh_dev, nr_addrs);
+#endif
 	if (nr_addrs < 0)
 		goto do_allmulti;
 
@@ -875,9 +891,11 @@
 				   waiting for TX feedback */
 				if (priv->connect_status == LBS_CONNECTED)
 					netif_wake_queue(priv->dev);
+#ifdef CONFIG_LIBERTAS_MESH
 				if (priv->mesh_dev &&
 				    priv->mesh_connect_status == LBS_CONNECTED)
 					netif_wake_queue(priv->mesh_dev);
+#endif
 			}
 		}
 		spin_unlock_irq(&priv->driver_lock);
@@ -896,8 +914,10 @@
 	lbs_deb_enter(LBS_DEB_FW);
 
 	netif_device_detach(priv->dev);
+#ifdef CONFIG_LIBERTAS_MESH
 	if (priv->mesh_dev)
 		netif_device_detach(priv->mesh_dev);
+#endif
 
 	priv->fw_ready = 0;
 	lbs_deb_leave(LBS_DEB_FW);
@@ -940,8 +960,10 @@
 				     0, 0, NULL);
 
 	netif_device_attach(priv->dev);
+#ifdef CONFIG_LIBERTAS_MESH
 	if (priv->mesh_dev)
 		netif_device_attach(priv->mesh_dev);
+#endif
 
 	lbs_deb_leave(LBS_DEB_FW);
 }
@@ -1039,7 +1061,9 @@
 	memset(priv->current_addr, 0xff, ETH_ALEN);
 
 	priv->connect_status = LBS_DISCONNECTED;
+#ifdef CONFIG_LIBERTAS_MESH
 	priv->mesh_connect_status = LBS_DISCONNECTED;
+#endif
 	priv->secinfo.auth_mode = IW_AUTH_ALG_OPEN_SYSTEM;
 	priv->mode = IW_MODE_INFRA;
 	priv->curbssparams.channel = DEFAULT_AD_HOC_CHANNEL;
@@ -1127,7 +1151,9 @@
 
 	priv->dev = dev;
 	priv->card = card;
+#ifdef CONFIG_LIBERTAS_MESH
 	priv->mesh_open = 0;
+#endif
 	priv->infra_open = 0;
 
 	/* Setup the OS Interface to our functions */
@@ -1163,8 +1189,10 @@
 	INIT_WORK(&priv->mcast_work, lbs_set_mcast_worker);
 	INIT_WORK(&priv->sync_channel, lbs_sync_channel_worker);
 
+#ifdef CONFIG_LIBERTAS_MESH
 	sprintf(priv->mesh_ssid, "mesh");
 	priv->mesh_ssid_len = 4;
+#endif
 
 	priv->wol_criteria = 0xffffffff;
 	priv->wol_gpio = 0xff;
@@ -1190,7 +1218,9 @@
 
 	lbs_deb_enter(LBS_DEB_MAIN);
 
+#ifdef CONFIG_LIBERTAS_MESH
 	lbs_remove_mesh(priv);
+#endif
 	lbs_remove_rtap(priv);
 
 	dev = priv->dev;
@@ -1247,6 +1277,7 @@
 
 	lbs_update_channel(priv);
 
+#ifdef CONFIG_LIBERTAS_MESH
 	/* 5.0.16p0 is known to NOT support any mesh */
 	if (priv->fwrelease > 0x05001000) {
 		/* Enable mesh, if supported, and work out which TLV it uses.
@@ -1277,6 +1308,7 @@
 				lbs_pr_err("cannot register lbs_mesh attribute\n");
 		}
 	}
+#endif
 
 	lbs_debugfs_init_one(priv, dev);
 
@@ -1307,9 +1339,10 @@
 
 	lbs_debugfs_remove_one(priv);
 	device_remove_file(&dev->dev, &dev_attr_lbs_rtap);
-	if (priv->mesh_tlv) {
+#ifdef CONFIG_LIBERTAS_MESH
+	if (priv->mesh_tlv)
 		device_remove_file(&dev->dev, &dev_attr_lbs_mesh);
-	}
+#endif
 
 	/* Flush pending command nodes */
 	del_timer_sync(&priv->command_timer);
@@ -1329,6 +1362,7 @@
 EXPORT_SYMBOL_GPL(lbs_stop_card);
 
 
+#ifdef CONFIG_LIBERTAS_MESH
 /**
  * @brief This function adds mshX interface
  *
@@ -1399,7 +1433,6 @@
 {
 	struct net_device *mesh_dev;
 
-
 	mesh_dev = priv->mesh_dev;
 	if (!mesh_dev)
 		return;
@@ -1414,6 +1447,7 @@
 	free_netdev(mesh_dev);
 	lbs_deb_leave(LBS_DEB_MESH);
 }
+#endif
 
 /**
  *  @brief This function finds the CFP in
--- wireless-testing.orig/drivers/net/wireless/libertas/wext.c
+++ wireless-testing/drivers/net/wireless/libertas/wext.c
@@ -159,7 +159,7 @@
 	lbs_deb_enter(LBS_DEB_WEXT);
 
 	if ((priv->connect_status != LBS_CONNECTED) &&
-		(priv->mesh_connect_status != LBS_CONNECTED))
+		!lbs_mesh_connected(priv))
 		memcpy(rates, lbs_bg_rates, MAX_RATES);
 	else
 		memcpy(rates, priv->curbssparams.rates, MAX_RATES);
@@ -265,6 +265,7 @@
 	return 0;
 }
 
+#ifdef CONFIG_LIBERTAS_MESH
 static int mesh_get_nick(struct net_device *dev, struct iw_request_info *info,
 			 struct iw_point *dwrq, char *extra)
 {
@@ -288,6 +289,7 @@
 	lbs_deb_leave(LBS_DEB_WEXT);
 	return 0;
 }
+#endif
 
 static int lbs_set_rts(struct net_device *dev, struct iw_request_info *info,
 			struct iw_param *vwrq, char *extra)
@@ -404,6 +406,7 @@
 	return 0;
 }
 
+#ifdef CONFIG_LIBERTAS_MESH
 static int mesh_wlan_get_mode(struct net_device *dev,
 		              struct iw_request_info *info, u32 * uwrq,
 			      char *extra)
@@ -415,6 +418,7 @@
 	lbs_deb_leave(LBS_DEB_WEXT);
 	return 0;
 }
+#endif
 
 static int lbs_get_txpow(struct net_device *dev,
 			  struct iw_request_info *info,
@@ -584,7 +588,7 @@
 
 	if (priv->enable11d &&
 	    (priv->connect_status == LBS_CONNECTED ||
-	    priv->mesh_connect_status == LBS_CONNECTED)) {
+	    lbs_mesh_connected(priv))) {
 		u8 chan_no;
 		u8 band;
 
@@ -818,7 +822,7 @@
 
 	/* If we're not associated, all quality values are meaningless */
 	if ((priv->connect_status != LBS_CONNECTED) &&
-	    (priv->mesh_connect_status != LBS_CONNECTED))
+	    lbs_mesh_connected(priv))
 		goto out;
 
 	/* Quality by RSSI */
@@ -961,6 +965,7 @@
 	return ret;
 }
 
+#ifdef CONFIG_LIBERTAS_MESH
 static int lbs_mesh_set_freq(struct net_device *dev,
 			     struct iw_request_info *info,
 			     struct iw_freq *fwrq, char *extra)
@@ -1010,6 +1015,7 @@
 	lbs_deb_leave_args(LBS_DEB_WEXT, "ret %d", ret);
 	return ret;
 }
+#endif
 
 static int lbs_set_rate(struct net_device *dev, struct iw_request_info *info,
 		  struct iw_param *vwrq, char *extra)
@@ -1978,6 +1984,7 @@
 	return ret;
 }
 
+#ifdef CONFIG_LIBERTAS_MESH
 static int lbs_mesh_get_essid(struct net_device *dev,
 			      struct iw_request_info *info,
 			      struct iw_point *dwrq, char *extra)
@@ -2026,6 +2033,7 @@
 	lbs_deb_leave_args(LBS_DEB_WEXT, "ret %d", ret);
 	return ret;
 }
+#endif
 
 /**
  *  @brief Connect to the AP or Ad-hoc Network with specific bssid
@@ -2130,7 +2138,13 @@
 	(iw_handler) lbs_get_encodeext,/* SIOCGIWENCODEEXT */
 	(iw_handler) NULL,		/* SIOCSIWPMKSA */
 };
+struct iw_handler_def lbs_handler_def = {
+	.num_standard	= ARRAY_SIZE(lbs_handler),
+	.standard	= (iw_handler *) lbs_handler,
+	.get_wireless_stats = lbs_get_wireless_stats,
+};
 
+#ifdef CONFIG_LIBERTAS_MESH
 static const iw_handler mesh_wlan_handler[] = {
 	(iw_handler) NULL,	/* SIOCSIWCOMMIT */
 	(iw_handler) lbs_get_name,	/* SIOCGIWNAME */
@@ -2188,14 +2202,11 @@
 	(iw_handler) lbs_get_encodeext,/* SIOCGIWENCODEEXT */
 	(iw_handler) NULL,		/* SIOCSIWPMKSA */
 };
-struct iw_handler_def lbs_handler_def = {
-	.num_standard	= ARRAY_SIZE(lbs_handler),
-	.standard	= (iw_handler *) lbs_handler,
-	.get_wireless_stats = lbs_get_wireless_stats,
-};
-
 struct iw_handler_def mesh_handler_def = {
 	.num_standard	= ARRAY_SIZE(mesh_wlan_handler),
 	.standard	= (iw_handler *) mesh_wlan_handler,
 	.get_wireless_stats = lbs_get_wireless_stats,
 };
+#endif
+
+
--- wireless-testing.orig/drivers/net/wireless/libertas/assoc.c
+++ wireless-testing/drivers/net/wireless/libertas/assoc.c
@@ -599,6 +599,7 @@
 	if (assoc_req->channel == priv->curbssparams.channel)
 		goto done;
 
+#ifdef CONFIG_LIBERTAS_MESH
 	if (priv->mesh_dev) {
 		/* Change mesh channel first; 21.p21 firmware won't let
 		   you change channel otherwise (even though it'll return
@@ -606,6 +607,7 @@
 		lbs_mesh_config(priv, CMD_ACT_MESH_CONFIG_STOP,
 				assoc_req->channel);
 	}
+#endif
 
 	lbs_deb_assoc("ASSOC: channel: %d -> %d\n",
 		      priv->curbssparams.channel, assoc_req->channel);
@@ -642,9 +644,11 @@
  	set_bit(ASSOC_FLAG_SSID, &assoc_req->flags);
 
  restore_mesh:
+#ifdef CONFIG_LIBERTAS_MESH
 	if (priv->mesh_dev)
 		lbs_mesh_config(priv, CMD_ACT_MESH_CONFIG_START,
 				priv->curbssparams.channel);
+#endif
 
  done:
 	lbs_deb_leave_args(LBS_DEB_ASSOC, "ret %d", ret);
--- wireless-testing.orig/drivers/net/wireless/libertas/cmd.c
+++ wireless-testing/drivers/net/wireless/libertas/cmd.c
@@ -142,8 +142,10 @@
 		memmove(priv->current_addr, cmd.permanentaddr, ETH_ALEN);
 
 	memcpy(priv->dev->dev_addr, priv->current_addr, ETH_ALEN);
+#ifdef CONFIG_LIBERTAS_MESH
 	if (priv->mesh_dev)
 		memcpy(priv->mesh_dev->dev_addr, priv->current_addr, ETH_ALEN);
+#endif
 
 	if (lbs_set_regiontable(priv, priv->regioncode, 0)) {
 		ret = -1;
@@ -956,6 +958,7 @@
 	return 0;
 }
 
+#ifdef CONFIG_LIBERTAS_MESH
 static int lbs_cmd_bt_access(struct cmd_ds_command *cmd,
 			       u16 cmd_action, void *pdata_buf)
 {
@@ -1118,6 +1121,7 @@
 	lbs_deb_leave(LBS_DEB_CMD);
 	return 0;
 }
+#endif
 
 static void lbs_queue_cmd(struct lbs_private *priv,
 			  struct cmd_ctrl_node *cmdnode)
@@ -1482,6 +1486,7 @@
 			break;
 		}
 
+#ifdef CONFIG_LIBERTAS_MESH
 	case CMD_BT_ACCESS:
 		ret = lbs_cmd_bt_access(cmdptr, cmd_action, pdata_buf);
 		break;
@@ -1499,6 +1504,7 @@
 	case CMD_802_11_BEACON_CTRL:
 		ret = lbs_cmd_bcn_ctrl(priv, cmdptr, cmd_action);
 		break;
+#endif
 	default:
 		lbs_pr_err("PREP_CMD: unknown command 0x%04x\n", cmd_no);
 		ret = -1;
@@ -1790,7 +1796,7 @@
 		if ((priv->psmode != LBS802_11POWERMODECAM) &&
 		    (priv->psstate == PS_STATE_FULL_POWER) &&
 		    ((priv->connect_status == LBS_CONNECTED) ||
-		    (priv->mesh_connect_status == LBS_CONNECTED))) {
+		    lbs_mesh_connected(priv))) {
 			if (priv->secinfo.WPAenabled ||
 			    priv->secinfo.WPA2enabled) {
 				/* check for valid WPA group keys */
--- wireless-testing.orig/drivers/net/wireless/libertas/cmd.h
+++ wireless-testing/drivers/net/wireless/libertas/cmd.h
@@ -31,18 +31,20 @@
 
 int lbs_update_hw_spec(struct lbs_private *priv);
 
-int lbs_mesh_access(struct lbs_private *priv, uint16_t cmd_action,
-		    struct cmd_ds_mesh_access *cmd);
-
 int lbs_set_data_rate(struct lbs_private *priv, u8 rate);
 
 int lbs_get_channel(struct lbs_private *priv);
 int lbs_set_channel(struct lbs_private *priv, u8 channel);
 
+#ifdef CONFIG_LIBERTAS_MESH
+int lbs_mesh_access(struct lbs_private *priv, uint16_t cmd_action,
+		    struct cmd_ds_mesh_access *cmd);
+
 int lbs_mesh_config_send(struct lbs_private *priv,
 			 struct cmd_ds_mesh_config *cmd,
 			 uint16_t action, uint16_t type);
 int lbs_mesh_config(struct lbs_private *priv, uint16_t enable, uint16_t chan);
+#endif
 
 int lbs_host_sleep_cfg(struct lbs_private *priv, uint32_t criteria);
 int lbs_suspend(struct lbs_private *priv);
--- wireless-testing.orig/drivers/net/wireless/libertas/cmdresp.c
+++ wireless-testing/drivers/net/wireless/libertas/cmdresp.c
@@ -652,6 +652,7 @@
 		lbs_pr_alert("EVENT: snr high\n");
 		break;
 
+#ifdef CONFIG_LIBERTAS_MESH
 	case MACREG_INT_CODE_MESH_AUTO_STARTED:
 		/* Ignore spurious autostart events if autostart is disabled */
 		if (!priv->mesh_autostart_enabled) {
@@ -668,6 +669,7 @@
 		priv->mode = IW_MODE_ADHOC;
 		schedule_work(&priv->sync_channel);
 		break;
+#endif
 
 	default:
 		lbs_pr_alert("EVENT: unknown event id %d\n", event);
--- wireless-testing.orig/drivers/net/wireless/libertas/ethtool.c
+++ wireless-testing/drivers/net/wireless/libertas/ethtool.c
@@ -9,6 +9,7 @@
 #include "wext.h"
 #include "cmd.h"
 
+#ifdef CONFIG_LIBERTAS_MESH
 static const char * mesh_stat_strings[]= {
 			"drop_duplicate_bcast",
 			"drop_ttl_zero",
@@ -19,6 +20,7 @@
 			"drop_blind_table",
 			"tx_failed_cnt"
 };
+#endif
 
 static void lbs_ethtool_get_drvinfo(struct net_device *dev,
 					 struct ethtool_drvinfo *info)
@@ -73,6 +75,7 @@
         return ret;
 }
 
+#ifdef CONFIG_LIBERTAS_MESH
 static void lbs_ethtool_get_stats(struct net_device *dev,
 				  struct ethtool_stats *stats, uint64_t *data)
 {
@@ -139,6 +142,7 @@
         }
 	lbs_deb_enter(LBS_DEB_ETHTOOL);
 }
+#endif
 
 static void lbs_ethtool_get_wol(struct net_device *dev,
 				struct ethtool_wolinfo *wol)
@@ -187,9 +191,11 @@
 	.get_drvinfo = lbs_ethtool_get_drvinfo,
 	.get_eeprom =  lbs_ethtool_get_eeprom,
 	.get_eeprom_len = lbs_ethtool_get_eeprom_len,
+#ifdef CONFIG_LIBERTAS_MESH
 	.get_sset_count = lbs_ethtool_get_sset_count,
 	.get_ethtool_stats = lbs_ethtool_get_stats,
 	.get_strings = lbs_ethtool_get_strings,
+#endif
 	.get_wol = lbs_ethtool_get_wol,
 	.set_wol = lbs_ethtool_set_wol,
 };
--- wireless-testing.orig/drivers/net/wireless/libertas/host.h
+++ wireless-testing/drivers/net/wireless/libertas/host.h
@@ -210,6 +210,7 @@
 #define CMD_WAKE_METHOD_COMMAND_INT	0x0001
 #define CMD_WAKE_METHOD_GPIO		0x0002
 
+#ifdef CONFIG_LIBERTAS_MESH
 /* Define action or option for CMD_BT_ACCESS */
 enum cmd_bt_access_opts {
 	/* The bt commands start at 5 instead of 1 because the old dft commands
@@ -272,6 +273,7 @@
 	CMD_TYPE_MESH_GET_DEFAULTS,
 	CMD_TYPE_MESH_GET_MESH_IE, /* GET_DEFAULTS is superset of GET_MESHIE */
 };
+#endif
 
 /** Card Event definition */
 #define MACREG_INT_CODE_TX_PPA_FREE		0
--- wireless-testing.orig/drivers/net/wireless/libertas/hostcmd.h
+++ wireless-testing/drivers/net/wireless/libertas/hostcmd.h
@@ -661,6 +661,7 @@
 } __attribute__ ((packed));
 
 
+#ifdef CONFIG_LIBERTAS_MESH
 struct cmd_ds_mesh_config {
 	struct cmd_header hdr;
 
@@ -681,6 +682,7 @@
 
 /* Number of stats counters returned by the firmware */
 #define MESH_STATS_NUM 8
+#endif
 
 struct cmd_ds_command {
 	/* command header */
--- wireless-testing.orig/drivers/net/wireless/libertas/persistcfg.c
+++ wireless-testing/drivers/net/wireless/libertas/persistcfg.c
@@ -1,3 +1,4 @@
+#ifdef CONFIG_LIBERTAS_MESH
 #include <linux/moduleparam.h>
 #include <linux/delay.h>
 #include <linux/etherdevice.h>
@@ -451,3 +452,4 @@
 	sysfs_remove_group(&(dev->dev.kobj), &boot_opts_group);
 	sysfs_remove_group(&(dev->dev.kobj), &mesh_ie_group);
 }
+#endif
--- wireless-testing.orig/drivers/net/wireless/libertas/rx.c
+++ wireless-testing/drivers/net/wireless/libertas/rx.c
@@ -160,8 +160,10 @@
 
 	p_rx_pkt = (struct rxpackethdr *) skb->data;
 	p_rx_pd = &p_rx_pkt->rx_pd;
+#ifdef CONFIG_LIBERTAS_MESH
 	if (priv->mesh_dev && (p_rx_pd->rx_control & RxPD_MESH_FRAME))
 		dev = priv->mesh_dev;
+#endif
 
 	lbs_deb_hex(LBS_DEB_RX, "RX Data: Before chop rxpd", skb->data,
 		 min_t(unsigned int, skb->len, 100));
--- wireless-testing.orig/drivers/net/wireless/libertas/scan.c
+++ wireless-testing/drivers/net/wireless/libertas/scan.c
@@ -156,7 +156,7 @@
 
 	for (rgnidx = 0; rgnidx < ARRAY_SIZE(priv->region_channel); rgnidx++) {
 		if (priv->enable11d && (priv->connect_status != LBS_CONNECTED)
-		    && (priv->mesh_connect_status != LBS_CONNECTED)) {
+		    && !lbs_mesh_connected(priv)) {
 			/* Scan all the supported chan for the first scan */
 			if (!priv->universal_channel[rgnidx].valid)
 				continue;
@@ -394,10 +394,12 @@
 
 	netif_stop_queue(priv->dev);
 	netif_carrier_off(priv->dev);
+#ifdef CONFIG_LIBERTAS_MESH
 	if (priv->mesh_dev) {
 		netif_stop_queue(priv->mesh_dev);
 		netif_carrier_off(priv->mesh_dev);
 	}
+#endif
 
 	/* Prepare to continue an interrupted scan */
 	lbs_deb_scan("chan_count %d, scan_channel %d\n",
@@ -466,11 +468,13 @@
 		if (!priv->tx_pending_len)
 			netif_wake_queue(priv->dev);
 	}
+#ifdef CONFIG_LIBERTAS_MESH
 	if (priv->mesh_dev && (priv->mesh_connect_status == LBS_CONNECTED)) {
 		netif_carrier_on(priv->mesh_dev);
 		if (!priv->tx_pending_len)
 			netif_wake_queue(priv->mesh_dev);
 	}
+#endif
 	kfree(chan_list);
 
 	lbs_deb_leave_args(LBS_DEB_SCAN, "ret %d", ret);
@@ -686,11 +690,13 @@
 				memcpy(bss->wpa_ie, elem, bss->wpa_ie_len);
 				lbs_deb_scan("got WPA IE\n");
 				lbs_deb_hex(LBS_DEB_SCAN, "WPA IE", bss->wpa_ie, elem->len);
+#ifdef CONFIG_LIBERTAS_MESH
 			} else if (elem->len >= MARVELL_MESH_IE_LENGTH &&
 				   elem->data[0] == 0x00 && elem->data[1] == 0x50 &&
 				   elem->data[2] == 0x43 && elem->data[3] == 0x04) {
 				lbs_deb_scan("got mesh IE\n");
 				bss->mesh = 1;
+#endif
 			} else {
 				lbs_deb_scan("got generic IE: %02x:%02x:%02x:%02x, len %d\n",
 					elem->data[0], elem->data[1],
@@ -907,6 +913,7 @@
 		start = iwe_stream_add_point(start, stop, &iwe, buf);
 	}
 
+#ifdef CONFIG_LIBERTAS_MESH
 	if (bss->mesh) {
 		char custom[MAX_CUSTOM_LEN];
 		char *p = custom;
@@ -917,6 +924,7 @@
 		if (iwe.u.data.length)
 			start = iwe_stream_add_point(start, stop, &iwe, custom);
 	}
+#endif
 
 out:
 	lbs_deb_leave_args(LBS_DEB_SCAN, "start %p", start);
@@ -1023,9 +1031,11 @@
 			break;
 		}
 
+#ifdef CONFIG_LIBERTAS_MESH
 		/* For mesh device, list only mesh networks */
 		if (dev == priv->mesh_dev && !iter_bss->mesh)
 			continue;
+#endif
 
 		/* Prune old an old scan result */
 		stale_time = iter_bss->last_scanned + DEFAULT_MAX_SCAN_AGE;
--- wireless-testing.orig/drivers/net/wireless/libertas/tx.c
+++ wireless-testing/drivers/net/wireless/libertas/tx.c
@@ -89,8 +89,10 @@
 
 
 	netif_stop_queue(priv->dev);
+#ifdef CONFIG_LIBERTAS_MESH
 	if (priv->mesh_dev)
 		netif_stop_queue(priv->mesh_dev);
+#endif
 
 	if (priv->tx_pending_len) {
 		/* This can happen if packets come in on the mesh and eth
@@ -132,8 +134,10 @@
 	txpd->tx_packet_length = cpu_to_le16(pkt_len);
 	txpd->tx_packet_location = cpu_to_le32(sizeof(struct txpd));
 
+#ifdef CONFIG_LIBERTAS_MESH
 	if (dev == priv->mesh_dev)
 		txpd->tx_control |= cpu_to_le32(TxPD_MESH_FRAME);
+#endif
 
 	lbs_deb_hex(LBS_DEB_TX, "txpd", (u8 *) &txpd, sizeof(struct txpd));
 
@@ -200,7 +204,9 @@
 	if (priv->connect_status == LBS_CONNECTED)
 		netif_wake_queue(priv->dev);
 
+#ifdef CONFIG_LIBERTAS_MESH
 	if (priv->mesh_dev && (priv->mesh_connect_status == LBS_CONNECTED))
 		netif_wake_queue(priv->mesh_dev);
+#endif
 }
 EXPORT_SYMBOL_GPL(lbs_send_tx_feedback);
--- wireless-testing.orig/drivers/net/wireless/libertas/types.h
+++ wireless-testing/drivers/net/wireless/libertas/types.h
@@ -254,6 +254,7 @@
 	struct led_bhv ledbhv[1];
 } __attribute__ ((packed));
 
+#ifdef CONFIG_LIBERTAS_MESH
 /* Meant to be packed as the value member of a struct ieee80211_info_element.
  * Note that the len member of the ieee80211_info_element varies depending on
  * the mesh_id_len */
@@ -281,5 +282,6 @@
 	__le16 channel;
 	struct mrvl_meshie meshie;
 } __attribute__ ((packed));
+#endif
 
 #endif
--- wireless-testing.orig/drivers/net/wireless/libertas/wext.h
+++ wireless-testing/drivers/net/wireless/libertas/wext.h
@@ -5,6 +5,9 @@
 #define	_LBS_WEXT_H_
 
 extern struct iw_handler_def lbs_handler_def;
+
+#ifdef CONFIG_LIBERTAS_MESH
 extern struct iw_handler_def mesh_handler_def;
+#endif
 
 #endif

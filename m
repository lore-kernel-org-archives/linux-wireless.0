Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx51.mymxserver.com ([85.199.173.110]:15764 "EHLO
	mx51.mymxserver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760254AbZKZK11 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Nov 2009 05:27:27 -0500
From: Holger Schurig <holgerschurig@gmail.com>
To: linux-wireless@vger.kernel.org
Subject: [PATCH 6/6, v2] libertas: make mesh configurable
Date: Thu, 26 Nov 2009 11:27:18 +0100
Cc: John Linville <linville@tuxdriver.com>,
	Dan Williams <dcbw@redhat.com>
References: <200911261045.42446.holgerschurig@gmail.com>
In-Reply-To: <200911261045.42446.holgerschurig@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200911261127.18416.holgerschurig@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Mostly for the embedded people that know beforehand that they don't need
MESH at all and want to save some bytes, but also helpful for the upcoming
cfg80211 transition.

   text    data     bss     dec     hex filename
 114264    2308     140  116712   1c7e8 libertas.ko   with mesh
 105026    2000     140  107166   1a29e libertas.ko   without mesh
 --------------------------------------------------
  -9238    -308           -9546


Signed-off-by: Holger Schurig <holgerschurig@gmail.com>

---

v2: forget to handle mesh_wlan_get_mode()


I added dummy defines in mesh.h so that the code doesn't get sprinkled with
"#ifdef CONFIG_LIBERTAS_MESH".  As wext.c gets deleted by the upcoming
cfg80211 patch anyway, I felt free to add #ifdef's there.

Dan said that he converted mesh to new-style commands. Once this patch
lands in mainline, the #ifdef in cmd.c also goes away.


--- linux-wl.orig/drivers/net/wireless/libertas/Kconfig
+++ linux-wl/drivers/net/wireless/libertas/Kconfig
@@ -37,3 +37,24 @@ config LIBERTAS_DEBUG
 	depends on LIBERTAS
 	---help---
 	  Debugging support.
+
+choice
+	prompt "API to user-space"
+	depends on LIBERTAS
+	default LIBERTAS_WEXT
+
+config LIBERTAS_CFG80211
+	bool "use CFG80211"
+
+config LIBERTAS_WEXT
+	bool "use WEXT"
+	select WIRELESS_EXT
+	select WEXT_SPY
+
+endchoice
+
+config LIBERTAS_MESH
+	bool "Enable mesh support"
+	depends on LIBERTAS_WEXT
+	help
+	  This enables Libertas' MESH support, used by e.g. the OLPC people.
--- linux-wl.orig/drivers/net/wireless/libertas/Makefile
+++ linux-wl/drivers/net/wireless/libertas/Makefile
@@ -5,11 +5,11 @@ libertas-y += cmdresp.o
 libertas-y += debugfs.o
 libertas-y += ethtool.o
 libertas-y += main.o
-libertas-y += mesh.o
 libertas-y += rx.o
 libertas-y += scan.o
 libertas-y += tx.o
 libertas-y += wext.o
+libertas-$(CONFIG_LIBERTAS_MESH) += mesh.o
 
 usb8xxx-objs += if_usb.o
 libertas_cs-objs += if_cs.o
--- linux-wl.orig/drivers/net/wireless/libertas/mesh.h
+++ linux-wl/drivers/net/wireless/libertas/mesh.h
@@ -9,6 +9,8 @@
 #include <net/lib80211.h>
 
 
+#ifdef CONFIG_LIBERTAS_MESH
+
 /* Mesh statistics */
 struct lbs_mesh_stats {
 	u32	fwd_bcast_cnt;		/* Fwd: Broadcast counter */
@@ -90,5 +92,20 @@ void lbs_mesh_ethtool_get_strings(struct
 #define lbs_mesh_connected(priv)
 	(priv->mesh_connect_status == LBS_CONNECTED)
 
+#else
+
+#define lbs_init_mesh(priv)
+#define lbs_deinit_mesh(priv)
+#define lbs_add_mesh(priv)
+#define lbs_remove_mesh(priv)
+#define lbs_mesh_set_dev(priv, dev, rxpd) (dev)
+#define lbs_mesh_set_txpd(priv, dev, txpd)
+#define lbs_mesh_config(priv, enable, chan)
+#define lbs_mesh_open(priv) (0)
+#define lbs_mesh_connected(priv) (0)
+
+#endif
+
+
 
 #endif
--- linux-wl.orig/drivers/net/wireless/libertas/dev.h
+++ linux-wl/drivers/net/wireless/libertas/dev.h
@@ -39,12 +39,14 @@ struct lbs_private {
 
 	/* Mesh */
 	struct net_device *mesh_dev; /* Virtual device */
+#ifdef CONFIG_LIBERTAS_MESH
 	u32 mesh_connect_status;
 	struct lbs_mesh_stats mstats;
 	int mesh_open;
 	uint16_t mesh_tlv;
 	u8 mesh_ssid[IEEE80211_MAX_SSID_LEN + 1];
 	u8 mesh_ssid_len;
+#endif
 
 	/* Monitor mode */
 	struct net_device *rtap_net_dev;
--- linux-wl.orig/drivers/net/wireless/libertas/cmd.c
+++ linux-wl/drivers/net/wireless/libertas/cmd.c
@@ -998,6 +998,8 @@ int lbs_prepare_and_send_command(struct 
 		ret = 0;
 		break;
 
+#ifdef CONFIG_LIBERTAS_MESH
+
 	case CMD_BT_ACCESS:
 		ret = lbs_cmd_bt_access(cmdptr, cmd_action, pdata_buf);
 		break;
@@ -1006,6 +1008,8 @@ int lbs_prepare_and_send_command(struct 
 		ret = lbs_cmd_fwt_access(cmdptr, cmd_action, pdata_buf);
 		break;
 
+#endif
+
 	case CMD_802_11_BEACON_CTRL:
 		ret = lbs_cmd_bcn_ctrl(priv, cmdptr, cmd_action);
 		break;
--- linux-wl.orig/drivers/net/wireless/libertas/ethtool.c
+++ linux-wl/drivers/net/wireless/libertas/ethtool.c
@@ -114,9 +114,11 @@ const struct ethtool_ops lbs_ethtool_ops
 	.get_drvinfo = lbs_ethtool_get_drvinfo,
 	.get_eeprom =  lbs_ethtool_get_eeprom,
 	.get_eeprom_len = lbs_ethtool_get_eeprom_len,
+#ifdef CONFIG_LIBERTAS_MESH
 	.get_sset_count = lbs_mesh_ethtool_get_sset_count,
 	.get_ethtool_stats = lbs_mesh_ethtool_get_stats,
 	.get_strings = lbs_mesh_ethtool_get_strings,
+#endif
 	.get_wol = lbs_ethtool_get_wol,
 	.set_wol = lbs_ethtool_set_wol,
 };
--- linux-wl.orig/drivers/net/wireless/libertas/wext.c
+++ linux-wl/drivers/net/wireless/libertas/wext.c
@@ -298,6 +298,7 @@ static int lbs_get_nick(struct net_devic
 	return 0;
 }
 
+#ifdef CONFIG_LIBERTAS_MESH
 static int mesh_get_nick(struct net_device *dev, struct iw_request_info *info,
 			 struct iw_point *dwrq, char *extra)
 {
@@ -321,6 +322,7 @@ static int mesh_get_nick(struct net_devi
 	lbs_deb_leave(LBS_DEB_WEXT);
 	return 0;
 }
+#endif
 
 static int lbs_set_rts(struct net_device *dev, struct iw_request_info *info,
 			struct iw_param *vwrq, char *extra)
@@ -422,6 +424,7 @@ static int lbs_get_mode(struct net_devic
 	return 0;
 }
 
+#ifdef CONFIG_LIBERTAS_MESH
 static int mesh_wlan_get_mode(struct net_device *dev,
 		              struct iw_request_info *info, u32 * uwrq,
 			      char *extra)
@@ -433,6 +436,7 @@ static int mesh_wlan_get_mode(struct net
 	lbs_deb_leave(LBS_DEB_WEXT);
 	return 0;
 }
+#endif
 
 static int lbs_get_txpow(struct net_device *dev,
 			  struct iw_request_info *info,
@@ -1010,6 +1014,7 @@ out:
 	return ret;
 }
 
+#ifdef CONFIG_LIBERTAS_MESH
 static int lbs_mesh_set_freq(struct net_device *dev,
 			     struct iw_request_info *info,
 			     struct iw_freq *fwrq, char *extra)
@@ -1061,6 +1066,7 @@ out:
 	lbs_deb_leave_args(LBS_DEB_WEXT, "ret %d", ret);
 	return ret;
 }
+#endif
 
 static int lbs_set_rate(struct net_device *dev, struct iw_request_info *info,
 		  struct iw_param *vwrq, char *extra)
@@ -2110,6 +2116,7 @@ out:
 	return ret;
 }
 
+#ifdef CONFIG_LIBERTAS_MESH
 static int lbs_mesh_get_essid(struct net_device *dev,
 			      struct iw_request_info *info,
 			      struct iw_point *dwrq, char *extra)
@@ -2163,6 +2170,7 @@ static int lbs_mesh_set_essid(struct net
 	lbs_deb_leave_args(LBS_DEB_WEXT, "ret %d", ret);
 	return ret;
 }
+#endif
 
 /**
  *  @brief Connect to the AP or Ad-hoc Network with specific bssid
@@ -2269,7 +2277,13 @@ static const iw_handler lbs_handler[] = 
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
@@ -2327,14 +2341,10 @@ static const iw_handler mesh_wlan_handle
 	(iw_handler) lbs_get_encodeext,/* SIOCGIWENCODEEXT */
 	(iw_handler) NULL,		/* SIOCSIWPMKSA */
 };
-struct iw_handler_def lbs_handler_def = {
-	.num_standard	= ARRAY_SIZE(lbs_handler),
-	.standard	= (iw_handler *) lbs_handler,
-	.get_wireless_stats = lbs_get_wireless_stats,
-};
 
 struct iw_handler_def mesh_handler_def = {
 	.num_standard	= ARRAY_SIZE(mesh_wlan_handler),
 	.standard	= (iw_handler *) mesh_wlan_handler,
 	.get_wireless_stats = lbs_get_wireless_stats,
 };
+#endif

-- 
http://www.holgerschurig.de

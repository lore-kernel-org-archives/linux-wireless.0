Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx51.mymxserver.com ([85.199.173.110]:32256 "EHLO
	mx51.mymxserver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755467AbZJVNfw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Oct 2009 09:35:52 -0400
Message-Id: <20091022133425.317619132@mail.mn-solutions.de>
References: <20091022133043.185554096@mail.mn-solutions.de>
Date: Thu, 22 Oct 2009 15:31:00 +0200
From: Holger Schurig <hs4233@mail.mn-solutions.de>
To: linux-wireless@vger.kernel.org,
	John Linville <linville@tuxdriver.com>,
	Dan Williams <dcbw@redhat.com>
Subject: [PATCH 17/19] [RFC, v2] libertas: Kconfig entry for libertas+cfg80211
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Holger Schurig <hs4233@mail.mn-solutions.de>

---
v2: incorporated Dan's ideas, e.g. kept mesh outside of #ifdef/#endif

--- linux-wl.orig/drivers/net/wireless/libertas/Kconfig
+++ linux-wl/drivers/net/wireless/libertas/Kconfig
@@ -37,3 +37,29 @@
 	depends on LIBERTAS
 	---help---
 	  Debugging support.
+
+choice
+	prompt "interface to user-space"
+	depends on LIBERTAS
+	default LIBERTAS_WEXT
+
+config LIBERTAS_WEXT
+	bool "WEXT"
+	help
+	  This is the old Libertas code as it always used to be:
+	  configuration done via "iwconfig" or "wpa_supplicant -Dwext",
+	  associating via libertas-internal code. This is currently the only
+	  way to support:
+
+	  * AD-HOC
+	  * Libertas' MESH
+	  * Monitor interface ("rtap")
+
+config LIBERTAS_CFG80211
+	bool "CFG80211"
+	depends on EXPERIMENTAL
+	help
+	  This is new new way of wireless: use cfg80211 for all, e.g.
+	  "iw" or "wpa_supplicant -Dnl80211".
+
+endchoice
--- linux-wl.orig/drivers/net/wireless/libertas/Makefile
+++ linux-wl/drivers/net/wireless/libertas/Makefile
@@ -1,15 +1,15 @@
-libertas-y += assoc.o
 libertas-y += cfg.o
 libertas-y += cmd.o
 libertas-y += cmdresp.o
 libertas-y += debugfs.o
 libertas-y += ethtool.o
-libertas-y += main.o
 libertas-y += persistcfg.o
+libertas-y += main.o
 libertas-y += rx.o
-libertas-y += scan.o
 libertas-y += tx.o
-libertas-y += wext.o
+libertas-$(CONFIG_LIBERTAS_WEXT) += assoc.o
+libertas-$(CONFIG_LIBERTAS_WEXT) += scan.o
+libertas-$(CONFIG_LIBERTAS_WEXT) += wext.o
 
 usb8xxx-objs += if_usb.o
 libertas_cs-objs += if_cs.o
--- linux-wl.orig/drivers/net/wireless/libertas/cmd.c
+++ linux-wl/drivers/net/wireless/libertas/cmd.c
@@ -188,10 +188,12 @@
 	if (priv->mesh_dev)
 		memcpy(priv->mesh_dev->dev_addr, priv->current_addr, ETH_ALEN);
 
+#ifdef CONFIG_LIBERTAS_WEXT
 	if (lbs_set_regiontable(priv, priv->regioncode, 0)) {
 		ret = -1;
 		goto out;
 	}
+#endif
 
 out:
 	lbs_deb_leave(LBS_DEB_CMD);
@@ -522,6 +524,7 @@
 	return ret;
 }
 
+#ifdef CONFIG_LIBERTAS_WEXT
 static int lbs_cmd_802_11_monitor_mode(struct cmd_ds_command *cmd,
 				      u16 cmd_action, void *pdata_buf)
 {
@@ -540,6 +543,7 @@
 
 	return 0;
 }
+#endif
 
 /**
  *  @brief Get the radio channel
@@ -1145,6 +1149,7 @@
 		ret = lbs_cmd_reg_access(cmdptr, cmd_action, pdata_buf);
 		break;
 
+#ifdef CONFIG_LIBERTAS_WEXT
 	case CMD_802_11_MONITOR_MODE:
 		ret = lbs_cmd_802_11_monitor_mode(cmdptr,
 				          cmd_action, pdata_buf);
@@ -1154,6 +1159,11 @@
 		ret = lbs_cmd_802_11_rssi(priv, cmdptr);
 		break;
 
+	case CMD_802_11_BEACON_CTRL:
+		ret = lbs_cmd_bcn_ctrl(priv, cmdptr, cmd_action);
+		break;
+#endif
+
 	case CMD_802_11_SET_AFC:
 	case CMD_802_11_GET_AFC:
 
@@ -1187,9 +1197,6 @@
 		ret = lbs_cmd_fwt_access(cmdptr, cmd_action, pdata_buf);
 		break;
 
-	case CMD_802_11_BEACON_CTRL:
-		ret = lbs_cmd_bcn_ctrl(priv, cmdptr, cmd_action);
-		break;
 	case CMD_802_11_DEEP_SLEEP:
 		cmdptr->command = cpu_to_le16(CMD_802_11_DEEP_SLEEP);
 		cmdptr->size = cpu_to_le16(sizeof(struct cmd_header));
@@ -1482,6 +1489,7 @@
 		 * check if in power save mode, if yes, put the device back
 		 * to PS mode
 		 */
+#ifdef CONFIG_LIBERTAS_WEXT
 		if ((priv->psmode != LBS802_11POWERMODECAM) &&
 		    (priv->psstate == PS_STATE_FULL_POWER) &&
 		    ((priv->connect_status == LBS_CONNECTED) ||
@@ -1503,6 +1511,9 @@
 				lbs_ps_sleep(priv, 0);
 			}
 		}
+#else
+	/* TODO: we need to figure out what to do here in cfg80211-mode */
+#endif
 	}
 
 	ret = 0;
--- linux-wl.orig/drivers/net/wireless/libertas/dev.h
+++ linux-wl/drivers/net/wireless/libertas/dev.h
@@ -6,8 +6,10 @@
 #ifndef _LBS_DEV_H_
 #define _LBS_DEV_H_
 
+#include "defs.h"
 #include "scan.h"
 #include "assoc.h"
+#include "host.h"
 
 
 
@@ -53,15 +55,17 @@
 	struct lbs_mesh_stats mstats;
 	int mesh_open;
 	int mesh_fw_ver;
-	int mesh_autostart_enabled;
 	uint16_t mesh_tlv;
 	u8 mesh_ssid[IEEE80211_MAX_SSID_LEN + 1];
 	u8 mesh_ssid_len;
 	struct work_struct sync_channel;
+#ifdef CONFIG_LIBERTAS_WEXT
+	int mesh_autostart_enabled;
 
 	/* Monitor mode */
 	struct net_device *rtap_net_dev;
 	u32 monitormode;
+#endif
 
 	/* Debugfs */
 	struct dentry *debugfs_dir;
@@ -138,11 +142,13 @@
 	struct workqueue_struct *work_thread;
 
 	/** Encryption stuff */
+#ifdef CONFIG_LIBERTAS_WEXT
 	struct lbs_802_11_security secinfo;
 	struct enc_key wpa_mcast_key;
 	struct enc_key wpa_unicast_key;
 	u8 wpa_ie[MAX_WPA_IE_LEN];
 	u8 wpa_ie_len;
+#endif
 	u16 wep_tx_keyidx;
 	struct enc_key wep_keys[4];
 
@@ -163,9 +169,11 @@
 	spinlock_t driver_lock;
 
 	/* NIC/link operation characteristics */
+	u16 capability;
 	u16 mac_control;
 	u8 radio_on;
 	u8 channel;
+	u8 cur_rate;
 	s16 txpower_cur;
 	s16 txpower_min;
 	s16 txpower_max;
@@ -174,6 +182,7 @@
 	struct delayed_work scan_work;
 	int scan_channel;
 	/* remember which channel was scanned last, != 0 if currently scanning */
+#ifdef CONFIG_LIBERTAS_WEXT
 	u8 scan_ssid[IEEE80211_MAX_SSID_LEN + 1];
 	u8 scan_ssid_len;
 
@@ -186,7 +195,6 @@
 	struct bss_descriptor *networks;
 	struct assoc_request * pending_assoc_req;
 	struct assoc_request * in_progress_assoc_req;
-	u16 capability;
 	uint16_t enablehwauto;
 	uint16_t ratebitmap;
 
@@ -199,7 +207,6 @@
 	char name[DEV_NAME_LEN];
 	u8 nodename[16];
 	struct iw_statistics wstats;
-	u8 cur_rate;
 #define	MAX_REGION_CHANNEL_NUM	2
 	struct region_channel region_channel[MAX_REGION_CHANNEL_NUM];
 
@@ -211,6 +218,7 @@
 	u8 rawNF[DEFAULT_DATA_AVG_FACTOR];
 	u16 nextSNRNF;
 	u16 numSNRNF;
+#endif
 };
 
 extern struct cmd_confirm_sleep confirm_sleep;
--- linux-wl.orig/drivers/net/wireless/libertas/main.c
+++ linux-wl/drivers/net/wireless/libertas/main.c
@@ -13,7 +13,6 @@
 #include <linux/kfifo.h>
 #include <linux/stddef.h>
 #include <linux/ieee80211.h>
-#include <net/iw_handler.h>
 #include <net/cfg80211.h>
 
 #include "host.h"
@@ -191,10 +190,10 @@
 	return strlen(buf);
 }
 
+#ifdef CONFIG_LIBERTAS_WEXT
+
 static int lbs_add_rtap(struct lbs_private *priv);
 static void lbs_remove_rtap(struct lbs_private *priv);
-static int lbs_add_mesh(struct lbs_private *priv);
-static void lbs_remove_mesh(struct lbs_private *priv);
 
 
 /**
@@ -258,6 +257,10 @@
  * through sysfs (/sys/class/net/ethX/lbs_rtap)
  */
 static DEVICE_ATTR(lbs_rtap, 0644, lbs_rtap_get, lbs_rtap_set );
+#endif
+
+static int lbs_add_mesh(struct lbs_private *priv);
+static void lbs_remove_mesh(struct lbs_private *priv);
 
 /**
  * Get function for sysfs attribute mesh
@@ -341,10 +344,12 @@
 
 	spin_lock_irq(&priv->driver_lock);
 
+#ifdef CONFIG_LIBERTAS_WEXT
 	if (priv->monitormode) {
 		ret = -EBUSY;
 		goto out;
 	}
+#endif
 
 	if (dev == priv->mesh_dev) {
 		priv->mesh_open = 1;
@@ -361,8 +366,10 @@
 
 	if (!priv->tx_pending_len)
 		netif_wake_queue(dev);
- out:
 
+#ifdef CONFIG_LIBERTAS_WEXT
+ out:
+#endif
 	spin_unlock_irq(&priv->driver_lock);
 	lbs_deb_leave_args(LBS_DEB_NET, "ret %d", ret);
 	return ret;
@@ -428,8 +435,10 @@
 
 	dev->trans_start = jiffies;
 
+#ifdef CONFIG_LIBERTAS_WEXT
 	if (priv->currenttxskb)
 		lbs_send_tx_feedback(priv, 0);
+#endif
 
 	/* XX: Shouldn't we also call into the hw-specific driver
 	   to kick it somehow? */
@@ -1015,14 +1024,17 @@
 	lbs_deb_leave(LBS_DEB_MAIN);
 }
 
-
 static int lbs_init_adapter(struct lbs_private *priv)
 {
+	int ret = 0;
+#ifdef CONFIG_LIBERTAS_WEXT
 	size_t bufsize;
-	int i, ret = 0;
+	int i;
+#endif
 
 	lbs_deb_enter(LBS_DEB_MAIN);
 
+#ifdef CONFIG_LIBERTAS_WEXT
 	/* Allocate buffer to store the BSSID list */
 	bufsize = MAX_NETWORK_COUNT * sizeof(struct bss_descriptor);
 	priv->networks = kzalloc(bufsize, GFP_KERNEL);
@@ -1039,17 +1051,18 @@
 		list_add_tail(&priv->networks[i].list,
 			      &priv->network_free_list);
 	}
+	priv->secinfo.auth_mode = IW_AUTH_ALG_OPEN_SYSTEM;
+	priv->mode = IW_MODE_INFRA;
+	priv->enablehwauto = 1;
+#endif
 
 	memset(priv->current_addr, 0xff, ETH_ALEN);
 
 	priv->connect_status = LBS_DISCONNECTED;
 	priv->mesh_connect_status = LBS_DISCONNECTED;
-	priv->secinfo.auth_mode = IW_AUTH_ALG_OPEN_SYSTEM;
-	priv->mode = IW_MODE_INFRA;
 	priv->channel = DEFAULT_AD_HOC_CHANNEL;
 	priv->mac_control = CMD_ACT_MAC_RX_ON | CMD_ACT_MAC_TX_ON;
 	priv->radio_on = 1;
-	priv->enablehwauto = 1;
 	priv->capability = WLAN_CAPABILITY_SHORT_PREAMBLE;
 	priv->psmode = LBS802_11POWERMODECAM;
 	priv->psstate = PS_STATE_FULL_POWER;
@@ -1103,8 +1116,10 @@
 		kfifo_free(priv->event_fifo);
 	del_timer(&priv->command_timer);
 	del_timer(&priv->auto_deepsleep_timer);
+#ifdef CONFIG_LIBERTAS_WEXT
 	kfree(priv->networks);
 	priv->networks = NULL;
+#endif
 
 	lbs_deb_leave(LBS_DEB_MAIN);
 }
@@ -1166,8 +1181,8 @@
 
  	dev->netdev_ops = &lbs_netdev_ops;
 	dev->watchdog_timeo = 5 * HZ;
+#ifdef CONFIG_LIBERTAS_WEXT
 	dev->ethtool_ops = &lbs_ethtool_ops;
-#ifdef	WIRELESS_EXT
 	dev->wireless_handlers = &lbs_handler_def;
 #endif
 	dev->flags |= IFF_BROADCAST | IFF_MULTICAST;
@@ -1180,8 +1195,6 @@
 	priv->mesh_open = 0;
 	priv->infra_open = 0;
 
-
-	priv->rtap_net_dev = NULL;
 	strcpy(dev->name, "wlan%d");
 
 	lbs_deb_thread("Starting main thread...\n");
@@ -1193,7 +1206,12 @@
 	}
 
 	priv->work_thread = create_singlethread_workqueue("lbs_worker");
+
+#ifdef CONFIG_LIBERTAS_WEXT
+	priv->rtap_net_dev = NULL;
+
 	INIT_DELAYED_WORK(&priv->assoc_work, lbs_association_worker);
+#endif
 	INIT_DELAYED_WORK(&priv->scan_work, lbs_scan_worker);
 	INIT_WORK(&priv->mcast_work, lbs_set_mcast_worker);
 	INIT_WORK(&priv->sync_channel, lbs_sync_channel_worker);
@@ -1230,13 +1248,15 @@
 
 	lbs_deb_enter(LBS_DEB_MAIN);
 
+	dev = priv->dev;
+
 	lbs_remove_mesh(priv);
+#ifdef CONFIG_LIBERTAS_WEXT
 	lbs_remove_rtap(priv);
 
-	dev = priv->dev;
-
-	cancel_delayed_work_sync(&priv->scan_work);
 	cancel_delayed_work_sync(&priv->assoc_work);
+#endif
+	cancel_delayed_work_sync(&priv->scan_work);
 	cancel_work_sync(&priv->mcast_work);
 
 	/* worker thread destruction blocks on the in-flight command which
@@ -1332,12 +1352,14 @@
 		if (device_create_file(&dev->dev, &dev_attr_lbs_mesh))
 			lbs_pr_err("cannot register lbs_mesh attribute\n");
 
+#ifdef CONFIG_LIBERTAS_WEXT
 		/* While rtap isn't related to mesh, only mesh-enabled
 		 * firmware implements the rtap functionality via
 		 * CMD_802_11_MONITOR_MODE.
 		 */
 		if (device_create_file(&dev->dev, &dev_attr_lbs_rtap))
 			lbs_pr_err("cannot register lbs_rtap attribute\n");
+#endif
 	}
 
 	lbs_debugfs_init_one(priv, dev);
@@ -1371,7 +1393,9 @@
 	lbs_debugfs_remove_one(priv);
 	if (priv->mesh_tlv) {
 		device_remove_file(&dev->dev, &dev_attr_lbs_mesh);
+#ifdef CONFIG_LIBERTAS_WEXT
 		device_remove_file(&dev->dev, &dev_attr_lbs_rtap);
+#endif
 	}
 
 	/* Delete the timeout of the currently processing command */
@@ -1442,7 +1466,7 @@
 
 	SET_NETDEV_DEV(priv->mesh_dev, priv->dev->dev.parent);
 
-#ifdef	WIRELESS_EXT
+#ifdef CONFIG_LIBERTAS_WEXT
 	mesh_dev->wireless_handlers = (struct iw_handler_def *)&mesh_handler_def;
 #endif
 	mesh_dev->flags |= IFF_BROADCAST | IFF_MULTICAST;
@@ -1478,7 +1502,6 @@
 {
 	struct net_device *mesh_dev;
 
-
 	mesh_dev = priv->mesh_dev;
 	if (!mesh_dev)
 		return;
@@ -1549,6 +1572,7 @@
 	lbs_deb_leave(LBS_DEB_MAIN);
 }
 
+#ifdef CONFIG_LIBERTAS_WEXT
 /*
  * rtap interface support fuctions
  */
@@ -1629,6 +1653,7 @@
 	lbs_deb_leave_args(LBS_DEB_MAIN, "ret %d", ret);
 	return ret;
 }
+#endif
 
 module_init(lbs_init_module);
 module_exit(lbs_exit_module);
--- linux-wl.orig/drivers/net/wireless/libertas/cmdresp.c
+++ linux-wl/drivers/net/wireless/libertas/cmdresp.c
@@ -7,7 +7,6 @@
 #include <linux/if_arp.h>
 #include <linux/netdevice.h>
 #include <asm/unaligned.h>
-#include <net/iw_handler.h>
 
 #include "host.h"
 #include "decl.h"
@@ -16,6 +15,7 @@
 #include "dev.h"
 #include "assoc.h"
 #include "wext.h"
+#include "cfg.h"
 
 /**
  *  @brief This function handles disconnect event. it
@@ -49,6 +49,7 @@
 	priv->tx_pending_len = 0;
 
 	/* reset SNR/NF/RSSI values */
+#ifdef CONFIG_LIBERTAS_WEXT
 	memset(priv->SNR, 0x00, sizeof(priv->SNR));
 	memset(priv->NF, 0x00, sizeof(priv->NF));
 	memset(priv->RSSI, 0x00, sizeof(priv->RSSI));
@@ -56,7 +57,6 @@
 	memset(priv->rawNF, 0x00, sizeof(priv->rawNF));
 	priv->nextSNRNF = 0;
 	priv->numSNRNF = 0;
-	priv->connect_status = LBS_DISCONNECTED;
 
 	/* Clear out associated SSID and BSSID since connection is
 	 * no longer valid.
@@ -64,6 +64,9 @@
 	memset(&priv->curbssparams.bssid, 0, ETH_ALEN);
 	memset(&priv->curbssparams.ssid, 0, IEEE80211_MAX_SSID_LEN);
 	priv->curbssparams.ssid_len = 0;
+#endif
+	priv->connect_status = LBS_DISCONNECTED;
+
 
 	if (priv->psstate != PS_STATE_FULL_POWER) {
 		/* make firmware to exit PS mode */
@@ -145,10 +148,6 @@
 	case CMD_RET(CMD_802_11_BEACON_STOP):
 		break;
 
-	case CMD_RET(CMD_802_11_RSSI):
-		ret = lbs_ret_802_11_rssi(priv, resp);
-		break;
-
 	case CMD_RET(CMD_802_11_TPC_CFG):
 		spin_lock_irqsave(&priv->driver_lock, flags);
 		memmove((void *)priv->cur_cmd->callback_arg, &resp->params.tpccfg,
@@ -170,9 +169,16 @@
 			       sizeof(resp->params.fwt));
 		spin_unlock_irqrestore(&priv->driver_lock, flags);
 		break;
+
+#ifdef CONFIG_LIBERTAS_WEXT
+	case CMD_RET(CMD_802_11_RSSI):
+		ret = lbs_ret_802_11_rssi(priv, resp);
+		break;
+
 	case CMD_RET(CMD_802_11_BEACON_CTRL):
 		ret = lbs_ret_802_11_bcn_ctrl(priv, resp);
 		break;
+#endif
 
 	default:
 		lbs_pr_err("CMD_RESP: unknown cmd response 0x%04x\n",
@@ -265,9 +271,13 @@
 			 * ad-hoc mode. It takes place in
 			 * lbs_execute_next_command().
 			 */
+#ifdef CONFIG_LIBERTAS_WEXT
 			if (priv->mode == IW_MODE_ADHOC &&
 			    action == CMD_SUBCMD_ENTER_PS)
 				priv->psmode = LBS802_11POWERMODECAM;
+#else
+		/* TODO: we need to figure out what to do here in cfg80211-mode */
+#endif
 		} else if (action == CMD_SUBCMD_ENTER_PS) {
 			priv->needtowakeup = 0;
 			priv->psstate = PS_STATE_AWAKE;
@@ -485,11 +495,14 @@
 		break;
 
 	case MACREG_INT_CODE_MESH_AUTO_STARTED:
+#ifdef CONFIG_LIBERTAS_WEXT
 		/* Ignore spurious autostart events if autostart is disabled */
 		if (!priv->mesh_autostart_enabled) {
 			lbs_pr_info("EVENT: MESH_AUTO_STARTED (ignoring)\n");
 			break;
 		}
+		priv->mode = IW_MODE_ADHOC;
+#endif
 		lbs_pr_info("EVENT: MESH_AUTO_STARTED\n");
 		priv->mesh_connect_status = LBS_CONNECTED;
 		if (priv->mesh_open) {
@@ -497,7 +510,6 @@
 			if (!priv->tx_pending_len)
 				netif_wake_queue(priv->mesh_dev);
 		}
-		priv->mode = IW_MODE_ADHOC;
 		schedule_work(&priv->sync_channel);
 		break;
 
--- linux-wl.orig/drivers/net/wireless/libertas/debugfs.c
+++ linux-wl/drivers/net/wireless/libertas/debugfs.c
@@ -4,7 +4,6 @@
 #include <linux/delay.h>
 #include <linux/mm.h>
 #include <linux/string.h>
-#include <net/iw_handler.h>
 #include <net/lib80211.h>
 
 #include "dev.h"
@@ -60,6 +59,7 @@
 }
 
 
+#ifdef CONFIG_LIBERTAS_WEXT
 static ssize_t lbs_getscantable(struct file *file, char __user *userbuf,
 				  size_t count, loff_t *ppos)
 {
@@ -103,6 +103,7 @@
 	free_page(addr);
 	return res;
 }
+#endif
 
 static ssize_t lbs_sleepparams_write(struct file *file,
 				const char __user *user_buf, size_t count,
@@ -722,8 +723,10 @@
 
 static const struct lbs_debugfs_files debugfs_files[] = {
 	{ "info", 0444, FOPS(lbs_dev_info, write_file_dummy), },
+#ifdef CONFIG_LIBERTAS_WEXT
 	{ "getscantable", 0444, FOPS(lbs_getscantable,
 					write_file_dummy), },
+#endif
 	{ "sleepparams", 0644, FOPS(lbs_sleepparams_read,
 				lbs_sleepparams_write), },
 };
--- linux-wl.orig/drivers/net/wireless/libertas/rx.c
+++ linux-wl/drivers/net/wireless/libertas/rx.c
@@ -34,9 +34,7 @@
 	void *eth80211_hdr;
 } __attribute__ ((packed));
 
-static int process_rxed_802_11_packet(struct lbs_private *priv,
-	struct sk_buff *skb);
-
+#ifdef CONFIG_LIBERTAS_WEXT
 /**
  *  @brief This function computes the avgSNR .
  *
@@ -131,6 +129,133 @@
 }
 
 /**
+ *  @brief This function converts Tx/Rx rates from the Marvell WLAN format
+ *  (see Table 2 in Section 3.1) to IEEE80211_RADIOTAP_RATE units (500 Kb/s)
+ *
+ *  @param rate    Input rate
+ *  @return 	   Output Rate (0 if invalid)
+ */
+static u8 convert_mv_rate_to_radiotap(u8 rate)
+{
+	switch (rate) {
+	case 0:		/*   1 Mbps */
+		return 2;
+	case 1:		/*   2 Mbps */
+		return 4;
+	case 2:		/* 5.5 Mbps */
+		return 11;
+	case 3:		/*  11 Mbps */
+		return 22;
+	/* case 4: reserved */
+	case 5:		/*   6 Mbps */
+		return 12;
+	case 6:		/*   9 Mbps */
+		return 18;
+	case 7:		/*  12 Mbps */
+		return 24;
+	case 8:		/*  18 Mbps */
+		return 36;
+	case 9:		/*  24 Mbps */
+		return 48;
+	case 10:		/*  36 Mbps */
+		return 72;
+	case 11:		/*  48 Mbps */
+		return 96;
+	case 12:		/*  54 Mbps */
+		return 108;
+	}
+	lbs_pr_alert("Invalid Marvell WLAN rate %i\n", rate);
+	return 0;
+}
+
+/**
+ *  @brief This function processes a received 802.11 packet and forwards it
+ *  to kernel/upper layer
+ *
+ *  @param priv    A pointer to struct lbs_private
+ *  @param skb     A pointer to skb which includes the received packet
+ *  @return 	   0 or -1
+ */
+static int process_rxed_802_11_packet(struct lbs_private *priv,
+	struct sk_buff *skb)
+{
+	int ret = 0;
+	struct net_device *dev = priv->dev;
+	struct rx80211packethdr *p_rx_pkt;
+	struct rxpd *prxpd;
+	struct rx_radiotap_hdr radiotap_hdr;
+	struct rx_radiotap_hdr *pradiotap_hdr;
+
+	lbs_deb_enter(LBS_DEB_RX);
+
+	p_rx_pkt = (struct rx80211packethdr *) skb->data;
+	prxpd = &p_rx_pkt->rx_pd;
+
+	// lbs_deb_hex(LBS_DEB_RX, "RX Data: Before chop rxpd", skb->data, min(skb->len, 100));
+
+	if (skb->len < (ETH_HLEN + 8 + sizeof(struct rxpd))) {
+		lbs_deb_rx("rx err: frame received with bad length\n");
+		dev->stats.rx_length_errors++;
+		ret = -EINVAL;
+		kfree_skb(skb);
+		goto done;
+	}
+
+	lbs_deb_rx("rx data: skb->len-sizeof(RxPd) = %d-%zd = %zd\n",
+	       skb->len, sizeof(struct rxpd), skb->len - sizeof(struct rxpd));
+
+	/* create the exported radio header */
+
+	/* radiotap header */
+	radiotap_hdr.hdr.it_version = 0;
+	/* XXX must check this value for pad */
+	radiotap_hdr.hdr.it_pad = 0;
+	radiotap_hdr.hdr.it_len = cpu_to_le16 (sizeof(struct rx_radiotap_hdr));
+	radiotap_hdr.hdr.it_present = cpu_to_le32 (RX_RADIOTAP_PRESENT);
+	radiotap_hdr.rate = convert_mv_rate_to_radiotap(prxpd->rx_rate);
+	/* XXX must check no carryout */
+	radiotap_hdr.antsignal = prxpd->snr + prxpd->nf;
+
+	/* chop the rxpd */
+	skb_pull(skb, sizeof(struct rxpd));
+
+	/* add space for the new radio header */
+	if ((skb_headroom(skb) < sizeof(struct rx_radiotap_hdr)) &&
+	    pskb_expand_head(skb, sizeof(struct rx_radiotap_hdr), 0, GFP_ATOMIC)) {
+		lbs_pr_alert("%s: couldn't pskb_expand_head\n", __func__);
+		ret = -ENOMEM;
+		kfree_skb(skb);
+		goto done;
+	}
+
+	pradiotap_hdr = (void *)skb_push(skb, sizeof(struct rx_radiotap_hdr));
+	memcpy(pradiotap_hdr, &radiotap_hdr, sizeof(struct rx_radiotap_hdr));
+
+	lbs_compute_rssi(priv, prxpd);
+
+	/* Take the data rate from the rxpd structure
+	 * only if the rate is auto
+	 */
+	if (priv->enablehwauto)
+		priv->cur_rate = lbs_fw_index_to_data_rate(prxpd->rx_rate);
+
+
+	lbs_deb_rx("rx data: size of actual packet %d\n", skb->len);
+	dev->stats.rx_bytes += skb->len;
+	dev->stats.rx_packets++;
+
+	skb->protocol = eth_type_trans(skb, priv->rtap_net_dev);
+	netif_rx(skb);
+
+	ret = 0;
+
+done:
+	lbs_deb_leave_args(LBS_DEB_RX, "ret %d", ret);
+	return ret;
+}
+#endif
+
+/**
  *  @brief This function processes received packet and forwards it
  *  to kernel/upper layer
  *
@@ -154,8 +279,10 @@
 
 	skb->ip_summed = CHECKSUM_NONE;
 
+#ifdef CONFIG_LIBERTAS_WEXT
 	if (priv->monitormode)
 		return process_rxed_802_11_packet(priv, skb);
+#endif
 
 	p_rx_pd = (struct rxpd *) skb->data;
 	p_rx_pkt = (struct rxpackethdr *) ((u8 *)p_rx_pd +
@@ -232,6 +359,7 @@
 	 */
 	skb_pull(skb, hdrchop);
 
+#ifdef CONFIG_LIBERTAS_WEXT
 	/* Take the data rate from the rxpd structure
 	 * only if the rate is auto
 	 */
@@ -239,6 +367,9 @@
 		priv->cur_rate = lbs_fw_index_to_data_rate(p_rx_pd->rx_rate);
 
 	lbs_compute_rssi(priv, p_rx_pd);
+#else
+	priv->cur_rate = p_rx_pd->rx_rate;
+#endif
 
 	lbs_deb_rx("rx data: size of actual packet %d\n", skb->len);
 	dev->stats.rx_bytes += skb->len;
@@ -257,127 +388,3 @@
 }
 EXPORT_SYMBOL_GPL(lbs_process_rxed_packet);
 
-/**
- *  @brief This function converts Tx/Rx rates from the Marvell WLAN format
- *  (see Table 2 in Section 3.1) to IEEE80211_RADIOTAP_RATE units (500 Kb/s)
- *
- *  @param rate    Input rate
- *  @return 	   Output Rate (0 if invalid)
- */
-static u8 convert_mv_rate_to_radiotap(u8 rate)
-{
-	switch (rate) {
-	case 0:		/*   1 Mbps */
-		return 2;
-	case 1:		/*   2 Mbps */
-		return 4;
-	case 2:		/* 5.5 Mbps */
-		return 11;
-	case 3:		/*  11 Mbps */
-		return 22;
-	/* case 4: reserved */
-	case 5:		/*   6 Mbps */
-		return 12;
-	case 6:		/*   9 Mbps */
-		return 18;
-	case 7:		/*  12 Mbps */
-		return 24;
-	case 8:		/*  18 Mbps */
-		return 36;
-	case 9:		/*  24 Mbps */
-		return 48;
-	case 10:		/*  36 Mbps */
-		return 72;
-	case 11:		/*  48 Mbps */
-		return 96;
-	case 12:		/*  54 Mbps */
-		return 108;
-	}
-	lbs_pr_alert("Invalid Marvell WLAN rate %i\n", rate);
-	return 0;
-}
-
-/**
- *  @brief This function processes a received 802.11 packet and forwards it
- *  to kernel/upper layer
- *
- *  @param priv    A pointer to struct lbs_private
- *  @param skb     A pointer to skb which includes the received packet
- *  @return 	   0 or -1
- */
-static int process_rxed_802_11_packet(struct lbs_private *priv,
-	struct sk_buff *skb)
-{
-	int ret = 0;
-	struct net_device *dev = priv->dev;
-	struct rx80211packethdr *p_rx_pkt;
-	struct rxpd *prxpd;
-	struct rx_radiotap_hdr radiotap_hdr;
-	struct rx_radiotap_hdr *pradiotap_hdr;
-
-	lbs_deb_enter(LBS_DEB_RX);
-
-	p_rx_pkt = (struct rx80211packethdr *) skb->data;
-	prxpd = &p_rx_pkt->rx_pd;
-
-	// lbs_deb_hex(LBS_DEB_RX, "RX Data: Before chop rxpd", skb->data, min(skb->len, 100));
-
-	if (skb->len < (ETH_HLEN + 8 + sizeof(struct rxpd))) {
-		lbs_deb_rx("rx err: frame received with bad length\n");
-		dev->stats.rx_length_errors++;
-		ret = -EINVAL;
-		kfree_skb(skb);
-		goto done;
-	}
-
-	lbs_deb_rx("rx data: skb->len-sizeof(RxPd) = %d-%zd = %zd\n",
-	       skb->len, sizeof(struct rxpd), skb->len - sizeof(struct rxpd));
-
-	/* create the exported radio header */
-
-	/* radiotap header */
-	radiotap_hdr.hdr.it_version = 0;
-	/* XXX must check this value for pad */
-	radiotap_hdr.hdr.it_pad = 0;
-	radiotap_hdr.hdr.it_len = cpu_to_le16 (sizeof(struct rx_radiotap_hdr));
-	radiotap_hdr.hdr.it_present = cpu_to_le32 (RX_RADIOTAP_PRESENT);
-	radiotap_hdr.rate = convert_mv_rate_to_radiotap(prxpd->rx_rate);
-	/* XXX must check no carryout */
-	radiotap_hdr.antsignal = prxpd->snr + prxpd->nf;
-
-	/* chop the rxpd */
-	skb_pull(skb, sizeof(struct rxpd));
-
-	/* add space for the new radio header */
-	if ((skb_headroom(skb) < sizeof(struct rx_radiotap_hdr)) &&
-	    pskb_expand_head(skb, sizeof(struct rx_radiotap_hdr), 0, GFP_ATOMIC)) {
-		lbs_pr_alert("%s: couldn't pskb_expand_head\n", __func__);
-		ret = -ENOMEM;
-		kfree_skb(skb);
-		goto done;
-	}
-
-	pradiotap_hdr = (void *)skb_push(skb, sizeof(struct rx_radiotap_hdr));
-	memcpy(pradiotap_hdr, &radiotap_hdr, sizeof(struct rx_radiotap_hdr));
-
-	/* Take the data rate from the rxpd structure
-	 * only if the rate is auto
-	 */
-	if (priv->enablehwauto)
-		priv->cur_rate = lbs_fw_index_to_data_rate(prxpd->rx_rate);
-
-	lbs_compute_rssi(priv, prxpd);
-
-	lbs_deb_rx("rx data: size of actual packet %d\n", skb->len);
-	dev->stats.rx_bytes += skb->len;
-	dev->stats.rx_packets++;
-
-	skb->protocol = eth_type_trans(skb, priv->rtap_net_dev);
-	netif_rx(skb);
-
-	ret = 0;
-
-done:
-	lbs_deb_leave_args(LBS_DEB_RX, "ret %d", ret);
-	return ret;
-}
--- linux-wl.orig/drivers/net/wireless/libertas/tx.c
+++ linux-wl/drivers/net/wireless/libertas/tx.c
@@ -12,6 +12,7 @@
 #include "dev.h"
 #include "wext.h"
 
+#ifdef CONFIG_LIBERTAS_WEXT
 /**
  *  @brief This function converts Tx/Rx rates from IEEE80211_RADIOTAP_RATE
  *  units (500 Kb/s) into Marvell WLAN format (see Table 8 in Section 3.2.1)
@@ -49,6 +50,7 @@
 	}
 	return 0;
 }
+#endif
 
 /**
  *  @brief This function checks the conditions and sends packet to IF
@@ -111,6 +113,7 @@
 	p802x_hdr = skb->data;
 	pkt_len = skb->len;
 
+#ifdef CONFIG_LIBERTAS_WEXT
 	if (dev == priv->rtap_net_dev) {
 		struct tx_radiotap_hdr *rtap_hdr = (void *)skb->data;
 
@@ -123,6 +126,9 @@
 
 		/* copy destination address from 802.11 header */
 		memcpy(txpd->tx_dest_addr_high, p802x_hdr + 4, ETH_ALEN);
+#else
+	if (0) {
+#endif
 	} else {
 		/* copy destination address from 802.3 header */
 		memcpy(txpd->tx_dest_addr_high, p802x_hdr, ETH_ALEN);
@@ -154,6 +160,7 @@
 
 	dev->trans_start = jiffies;
 
+#ifdef CONFIG_LIBERTAS_WEXT
 	if (priv->monitormode) {
 		/* Keep the skb to echo it back once Tx feedback is
 		   received from FW */
@@ -161,6 +168,9 @@
 
 		/* Keep the skb around for when we get feedback */
 		priv->currenttxskb = skb;
+#else
+	if (0) {
+#endif
 	} else {
  free:
 		dev_kfree_skb_any(skb);
@@ -173,6 +183,7 @@
 	return ret;
 }
 
+#ifdef CONFIG_LIBERTAS_WEXT
 /**
  *  @brief This function sends to the host the last transmitted packet,
  *  filling the radiotap headers with transmission information.
@@ -207,3 +218,4 @@
 		netif_wake_queue(priv->mesh_dev);
 }
 EXPORT_SYMBOL_GPL(lbs_send_tx_feedback);
+#endif
--- linux-wl.orig/drivers/net/wireless/libertas/if_usb.c
+++ linux-wl/drivers/net/wireless/libertas/if_usb.c
@@ -759,9 +759,11 @@
 
 		/* Icky undocumented magic special case */
 		if (event & 0xffff0000) {
+#ifdef CONFIG_LIBERTAS_WEXT
 			u32 trycount = (event & 0xffff0000) >> 16;
 
 			lbs_send_tx_feedback(priv, trycount);
+#endif
 		} else
 			lbs_queue_event(priv, event & 0xFF);
 		break;
--- linux-wl.orig/drivers/net/wireless/libertas/assoc.h
+++ linux-wl/drivers/net/wireless/libertas/assoc.h
@@ -3,6 +3,7 @@
 #ifndef _LBS_ASSOC_H_
 #define _LBS_ASSOC_H_
 
+#ifdef CONFIG_LIBERTAS_WEXT
 
 #include "defs.h"
 #include "host.h"
@@ -152,4 +153,6 @@
 int lbs_cmd_802_11_key_material(struct lbs_private *priv, uint16_t cmd_action,
 				struct assoc_request *assoc);
 
+#endif
+
 #endif /* _LBS_ASSOC_H */
--- linux-wl.orig/drivers/net/wireless/libertas/scan.h
+++ linux-wl/drivers/net/wireless/libertas/scan.h
@@ -7,6 +7,8 @@
 #ifndef _LBS_SCAN_H
 #define _LBS_SCAN_H
 
+#ifdef CONFIG_LIBERTAS_WEXT
+
 #include <net/iw_handler.h>
 
 struct lbs_private;
@@ -61,3 +63,5 @@
 void lbs_scan_worker(struct work_struct *work);
 
 #endif
+
+#endif
--- linux-wl.orig/drivers/net/wireless/libertas/wext.h
+++ linux-wl/drivers/net/wireless/libertas/wext.h
@@ -4,6 +4,8 @@
 #ifndef	_LBS_WEXT_H_
 #define	_LBS_WEXT_H_
 
+#ifdef CONFIG_LIBERTAS_WEXT
+
 void lbs_send_disconnect_notification(struct lbs_private *priv);
 void lbs_send_mic_failureevent(struct lbs_private *priv, u32 event);
 
@@ -16,3 +18,5 @@
 	u16 channel);
 
 #endif
+
+#endif
--- linux-wl.orig/drivers/net/wireless/libertas/cfg.h
+++ linux-wl/drivers/net/wireless/libertas/cfg.h
@@ -7,10 +7,13 @@
 int lbs_cfg_register(struct lbs_private *priv);
 void lbs_cfg_free(struct lbs_private *priv);
 
-int lbs_send_specific_ssid_scan(struct lbs_private *priv, u8 *ssid,
-	u8 ssid_len);
-int lbs_scan_networks(struct lbs_private *priv, int full_scan);
-void lbs_cfg_scan_worker(struct work_struct *work);
+
+#ifdef CONFIG_LIBERTAS_CFG80211
+void lbs_send_disconnect_notification(struct lbs_private *priv);
+void lbs_send_mic_failureevent(struct lbs_private *priv, u32 event);
+
+void lbs_scan_worker(struct work_struct *work);
+#endif
 
 
 #endif
--- linux-wl.orig/drivers/net/wireless/libertas/cfg.c
+++ linux-wl/drivers/net/wireless/libertas/cfg.c
@@ -97,6 +97,22 @@
 }
 
 
+#ifdef CONFIG_LIBERTAS_CFG80211
+void lbs_scan_worker(struct work_struct *work)
+{
+	/* TODO */
+}
+
+void lbs_send_disconnect_notification(struct lbs_private *priv)
+{
+	/* TODO */
+}
+
+void lbs_send_mic_failureevent(struct lbs_private *priv, u32 event)
+{
+	/* TODO */
+}
+#endif
 
 
 static struct cfg80211_ops lbs_cfg80211_ops = {

-- 

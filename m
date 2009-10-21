Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:14971 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754057AbZJUSja (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 Oct 2009 14:39:30 -0400
Subject: Re: [RFC] libertas: monster-patch to make CFG/WEXT configurable
From: Dan Williams <dcbw@redhat.com>
To: Holger Schurig <hs4233@mail.mn-solutions.de>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1256150184.5010.45.camel@localhost.localdomain>
References: <200910191449.18915.hs4233@mail.mn-solutions.de>
	 <1256150184.5010.45.camel@localhost.localdomain>
Content-Type: text/plain
Date: Wed, 21 Oct 2009 11:39:30 -0700
Message-Id: <1256150370.8469.0.camel@localhost.localdomain>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2009-10-21 at 11:36 -0700, Dan Williams wrote:
> On Mon, 2009-10-19 at 14:49 +0200, Holger Schurig wrote:
> > This is a monster patch that makes CFG80211/WEXT operation
> > configurable. My cfg80211-RFC/WIP-Patch would come on top of it,
> > but would then be quite small, e.g. almost only changed to
> > cfg.c/cfg.h.
> > 
> > As there's no mesh/adhoc/monitor mode implemented in cfg80211-
> > mode, I added many, many #ifdef/#endif pairs. Maybe too many.
> > Is this too ugly?   Or would this patch be applyable as-is ?
> 
> For the mesh interface stuff, especially in tx/rx paths, would you mind
> not ifdefing that?  Since with cfg80211, priv->mesh_dev will always be
> NULL, those checks will be just fine and you still don't have to care
> about mesh.
> 
> I'm sure that the bits for SNMP_MIB_OID_BSS_TYPE could also be converted
> to use lib80211 or cfg80211 values instead of WEXT ones; I just picked
> WEXT at the time because we had no cfg80211 yet.
> 
> Stuff like lbs_cmd_bt_access doesn't need to be ifdefed either, because
> it simply won't be called if the debugfs bits are disabled.
> 
> I'm sure the WEXT-specific lbs_mac_event_disconnected bits could also be
> abstracted like you did with the IWAP stuff a few patches ago too.

I just saw the v2 patch from earlier that did this.  Thanks.

> Basically, I don't mind having some ifdefs; but I think there are way
> too many in that patch.  Not all the mesh stuff needs to be disabled
> just for cfg80211.
> 
> > If the patch is perceived to be too ugly, I could create an
> > monitor.h/monitor.c file and singleout everything related to
> > monitoring in it, where monitor.h would resolv to dummy static
> > functions in the cfg80211-case ... at least as long as we don't
> > have monitor suppport in libertas+cfg80211. The same for mesh
> > support, e.g. here I could create a mesh.h/mesh.c and do the
> > same.
> > 
> > Signed-off-by: Holger Schurig <hs4233@mail.mn-solutions.de>
> > 
> > --- linux-wl.orig/drivers/net/wireless/libertas/Kconfig
> > +++ linux-wl/drivers/net/wireless/libertas/Kconfig
> > @@ -37,3 +37,29 @@
> >  	depends on LIBERTAS
> >  	---help---
> >  	  Debugging support.
> > +
> > +choice
> > +	prompt "interface to user-space"
> > +	depends on LIBERTAS
> > +	default LIBERTAS_WEXT
> > +
> > +config LIBERTAS_WEXT
> > +	bool "WEXT"
> > +	help
> > +	  This is the old Libertas code as it always used to be:
> > +	  configuration done via "iwconfig" or "wpa_supplicant -Dwext",
> > +	  associating via libertas-internal code. This is currently the only
> > +	  way to support:
> > +
> > +	  * AD-HOC
> > +	  * Libertas' MESH
> > +	  * Monitor interface ("rtap")
> > +
> > +config LIBERTAS_CFG80211
> > +	bool "CFG80211"
> > +	depends on EXPERIMENTAL
> > +	help
> > +	  This is new new way of wireless: use cfg80211 for all, e.g.
> > +	  "iw" or "wpa_supplicant -Dnl80211".
> > +
> > +endchoice
> > --- linux-wl.orig/drivers/net/wireless/libertas/Makefile
> > +++ linux-wl/drivers/net/wireless/libertas/Makefile
> > @@ -1,15 +1,15 @@
> > -libertas-y += assoc.o
> >  libertas-y += cfg.o
> >  libertas-y += cmd.o
> >  libertas-y += cmdresp.o
> >  libertas-y += debugfs.o
> > -libertas-y += ethtool.o
> >  libertas-y += main.o
> > -libertas-y += persistcfg.o
> >  libertas-y += rx.o
> > -libertas-y += scan.o
> >  libertas-y += tx.o
> > -libertas-y += wext.o
> > +libertas-$(CONFIG_LIBERTAS_WEXT) += assoc.o
> > +libertas-$(CONFIG_LIBERTAS_WEXT) += ethtool.o
> > +libertas-$(CONFIG_LIBERTAS_WEXT) += persistcfg.o
> > +libertas-$(CONFIG_LIBERTAS_WEXT) += scan.o
> > +libertas-$(CONFIG_LIBERTAS_WEXT) += wext.o
> >  
> >  usb8xxx-objs += if_usb.o
> >  libertas_cs-objs += if_cs.o
> > --- linux-wl.orig/drivers/net/wireless/libertas/cmd.c
> > +++ linux-wl/drivers/net/wireless/libertas/cmd.c
> > @@ -3,7 +3,6 @@
> >    * It prepares command and sends it to firmware when it is ready.
> >    */
> >  
> > -#include <net/iw_handler.h>
> >  #include <net/lib80211.h>
> >  #include <linux/kfifo.h>
> >  #include <linux/sched.h>
> > @@ -184,6 +183,8 @@
> >  		memmove(priv->current_addr, cmd.permanentaddr, ETH_ALEN);
> >  
> >  	memcpy(priv->dev->dev_addr, priv->current_addr, ETH_ALEN);
> > +
> > +#ifdef CONFIG_LIBERTAS_WEXT
> >  	if (priv->mesh_dev)
> >  		memcpy(priv->mesh_dev->dev_addr, priv->current_addr, ETH_ALEN);
> >  
> > @@ -191,6 +192,7 @@
> >  		ret = -1;
> >  		goto out;
> >  	}
> > +#endif
> >  
> >  out:
> >  	lbs_deb_leave(LBS_DEB_CMD);
> > @@ -387,10 +389,12 @@
> >  	cmd.oid = cpu_to_le16((u16) oid);
> >  
> >  	switch (oid) {
> > +#ifdef CONFIG_LIBERTAS_WEXT
> >  	case SNMP_MIB_OID_BSS_TYPE:
> >  		cmd.bufsize = cpu_to_le16(sizeof(u8));
> >  		cmd.value[0] = (val == IW_MODE_ADHOC) ? 2 : 1;
> >  		break;
> > +#endif
> >  	case SNMP_MIB_OID_11D_ENABLE:
> >  	case SNMP_MIB_OID_FRAG_THRESHOLD:
> >  	case SNMP_MIB_OID_RTS_THRESHOLD:
> > @@ -442,12 +446,14 @@
> >  
> >  	switch (le16_to_cpu(cmd.bufsize)) {
> >  	case sizeof(u8):
> > +#ifdef CONFIG_LIBERTAS_WEXT
> >  		if (oid == SNMP_MIB_OID_BSS_TYPE) {
> >  			if (cmd.value[0] == 2)
> >  				*out_val = IW_MODE_ADHOC;
> >  			else
> >  				*out_val = IW_MODE_INFRA;
> >  		} else
> > +#endif
> >  			*out_val = cmd.value[0];
> >  		break;
> >  	case sizeof(u16):
> > @@ -702,6 +708,7 @@
> >  	return 0;
> >  }
> >  
> > +#ifdef CONFIG_LIBERTAS_WEXT
> >  static int lbs_cmd_bt_access(struct cmd_ds_command *cmd,
> >  			       u16 cmd_action, void *pdata_buf)
> >  {
> > @@ -868,6 +875,7 @@
> >  
> >  	return __lbs_mesh_config_send(priv, &cmd, action, priv->mesh_tlv);
> >  }
> > +#endif
> >  
> >  static void lbs_queue_cmd(struct lbs_private *priv,
> >  			  struct cmd_ctrl_node *cmdnode)
> > @@ -1155,10 +1163,6 @@
> >  				          cmd_action, pdata_buf);
> >  		break;
> >  
> > -	case CMD_802_11_RSSI:
> > -		ret = lbs_cmd_802_11_rssi(priv, cmdptr);
> > -		break;
> > -
> >  	case CMD_802_11_SET_AFC:
> >  	case CMD_802_11_GET_AFC:
> >  
> > @@ -1184,6 +1188,11 @@
> >  		ret = 0;
> >  		break;
> >  
> > +#ifdef CONFIG_LIBERTAS_WEXT
> > +	case CMD_802_11_RSSI:
> > +		ret = lbs_cmd_802_11_rssi(priv, cmdptr);
> > +		break;
> > +
> >  	case CMD_BT_ACCESS:
> >  		ret = lbs_cmd_bt_access(cmdptr, cmd_action, pdata_buf);
> >  		break;
> > @@ -1195,6 +1204,8 @@
> >  	case CMD_802_11_BEACON_CTRL:
> >  		ret = lbs_cmd_bcn_ctrl(priv, cmdptr, cmd_action);
> >  		break;
> > +#endif
> > +
> >  	case CMD_802_11_DEEP_SLEEP:
> >  		cmdptr->command = cpu_to_le16(CMD_802_11_DEEP_SLEEP);
> >  		cmdptr->size = cpu_to_le16(sizeof(struct cmd_header));
> > @@ -1487,6 +1498,7 @@
> >  		 * check if in power save mode, if yes, put the device back
> >  		 * to PS mode
> >  		 */
> > +#ifdef CONFIG_LIBERTAS_WEXT
> >  		if ((priv->psmode != LBS802_11POWERMODECAM) &&
> >  		    (priv->psstate == PS_STATE_FULL_POWER) &&
> >  		    ((priv->connect_status == LBS_CONNECTED) ||
> > @@ -1508,6 +1520,9 @@
> >  				lbs_ps_sleep(priv, 0);
> >  			}
> >  		}
> > +#else
> > +	/* TODO: we need to figure out what to do here in cfg80211-mode */
> > +#endif
> >  	}
> >  
> >  	ret = 0;
> > --- linux-wl.orig/drivers/net/wireless/libertas/dev.h
> > +++ linux-wl/drivers/net/wireless/libertas/dev.h
> > @@ -6,8 +6,10 @@
> >  #ifndef _LBS_DEV_H_
> >  #define _LBS_DEV_H_
> >  
> > +#include "defs.h"
> >  #include "scan.h"
> >  #include "assoc.h"
> > +#include "host.h"
> >  
> > 
> > 
> > @@ -21,6 +23,9 @@
> >  	uint16_t sp_reserved;
> >  };
> >  
> > +
> > +#ifdef CONFIG_LIBERTAS_WEXT
> > +
> >  /* Mesh statistics */
> >  struct lbs_mesh_stats {
> >  	u32	fwd_bcast_cnt;		/* Fwd: Broadcast counter */
> > @@ -32,6 +37,8 @@
> >  	u32	drop_blind;		/* Rx:  Dropped by blinding table */
> >  	u32	tx_failed_cnt;		/* Tx:  Failed transmissions */
> >  };
> > +#endif
> > +
> >  
> >  /** Private structure for the MV device */
> >  struct lbs_private {
> > @@ -48,11 +55,11 @@
> >  	struct wireless_dev *wdev;
> >  
> >  	/* Mesh */
> > +#ifdef CONFIG_LIBERTAS_WEXT
> >  	struct net_device *mesh_dev; /* Virtual device */
> >  	u32 mesh_connect_status;
> >  	struct lbs_mesh_stats mstats;
> >  	int mesh_open;
> > -	int mesh_fw_ver;
> >  	int mesh_autostart_enabled;
> >  	uint16_t mesh_tlv;
> >  	u8 mesh_ssid[IEEE80211_MAX_SSID_LEN + 1];
> > @@ -62,6 +69,7 @@
> >  	/* Monitor mode */
> >  	struct net_device *rtap_net_dev;
> >  	u32 monitormode;
> > +#endif
> >  
> >  	/* Debugfs */
> >  	struct dentry *debugfs_dir;
> > @@ -103,6 +111,7 @@
> >  	int (*reset_deep_sleep_wakeup) (struct lbs_private *priv);
> >  
> >  	/* Adapter info (from EEPROM) */
> > +	int mesh_fw_ver;
> >  	u32 fwrelease;
> >  	u32 fwcapinfo;
> >  	u16 regioncode;
> > @@ -138,11 +147,13 @@
> >  	struct workqueue_struct *work_thread;
> >  
> >  	/** Encryption stuff */
> > +#ifdef CONFIG_LIBERTAS_WEXT
> >  	struct lbs_802_11_security secinfo;
> >  	struct enc_key wpa_mcast_key;
> >  	struct enc_key wpa_unicast_key;
> >  	u8 wpa_ie[MAX_WPA_IE_LEN];
> >  	u8 wpa_ie_len;
> > +#endif
> >  	u16 wep_tx_keyidx;
> >  	struct enc_key wep_keys[4];
> >  
> > @@ -163,6 +174,7 @@
> >  	spinlock_t driver_lock;
> >  
> >  	/* NIC/link operation characteristics */
> > +	u16 capability;
> >  	u16 mac_control;
> >  	u8 radio_on;
> >  	u8 channel;
> > @@ -174,6 +186,7 @@
> >  	struct delayed_work scan_work;
> >  	int scan_channel;
> >  	/* remember which channel was scanned last, != 0 if currently scanning */
> > +#ifdef CONFIG_LIBERTAS_WEXT
> >  	u8 scan_ssid[IEEE80211_MAX_SSID_LEN + 1];
> >  	u8 scan_ssid_len;
> >  
> > @@ -186,7 +199,6 @@
> >  	struct bss_descriptor *networks;
> >  	struct assoc_request * pending_assoc_req;
> >  	struct assoc_request * in_progress_assoc_req;
> > -	u16 capability;
> >  	uint16_t enablehwauto;
> >  	uint16_t ratebitmap;
> >  
> > @@ -211,6 +223,7 @@
> >  	u8 rawNF[DEFAULT_DATA_AVG_FACTOR];
> >  	u16 nextSNRNF;
> >  	u16 numSNRNF;
> > +#endif
> >  };
> >  
> >  extern struct cmd_confirm_sleep confirm_sleep;
> > --- linux-wl.orig/drivers/net/wireless/libertas/main.c
> > +++ linux-wl/drivers/net/wireless/libertas/main.c
> > @@ -13,7 +13,6 @@
> >  #include <linux/kfifo.h>
> >  #include <linux/stddef.h>
> >  #include <linux/ieee80211.h>
> > -#include <net/iw_handler.h>
> >  #include <net/cfg80211.h>
> >  
> >  #include "host.h"
> > @@ -98,6 +97,7 @@
> >   * Attributes exported through sysfs
> >   */
> >  
> > +#ifdef CONFIG_LIBERTAS_WEXT
> >  /**
> >   * @brief Get function for sysfs attribute anycast_mask
> >   */
> > @@ -325,6 +325,8 @@
> >  static struct attribute_group lbs_mesh_attr_group = {
> >  	.attrs = lbs_mesh_sysfs_entries,
> >  };
> > +#endif
> > +
> >  
> >  /**
> >   *  @brief This function opens the ethX or mshX interface
> > @@ -341,6 +343,7 @@
> >  
> >  	spin_lock_irq(&priv->driver_lock);
> >  
> > +#ifdef CONFIG_LIBERTAS_WEXT
> >  	if (priv->monitormode) {
> >  		ret = -EBUSY;
> >  		goto out;
> > @@ -351,6 +354,9 @@
> >  		priv->mesh_connect_status = LBS_CONNECTED;
> >  		netif_carrier_on(dev);
> >  	} else {
> > +#else
> > +	if (1) {
> > +#endif
> >  		priv->infra_open = 1;
> >  
> >  		if (priv->connect_status == LBS_CONNECTED)
> > @@ -361,13 +367,16 @@
> >  
> >  	if (!priv->tx_pending_len)
> >  		netif_wake_queue(dev);
> > - out:
> >  
> > +#ifdef CONFIG_LIBERTAS_WEXT
> > + out:
> > +#endif
> >  	spin_unlock_irq(&priv->driver_lock);
> >  	lbs_deb_leave_args(LBS_DEB_NET, "ret %d", ret);
> >  	return ret;
> >  }
> >  
> > +#ifdef CONFIG_LIBERTAS_WEXT
> >  /**
> >   *  @brief This function closes the mshX interface
> >   *
> > @@ -383,7 +392,6 @@
> >  
> >  	priv->mesh_open = 0;
> >  	priv->mesh_connect_status = LBS_DISCONNECTED;
> > -
> >  	netif_stop_queue(dev);
> >  	netif_carrier_off(dev);
> >  
> > @@ -394,6 +402,7 @@
> >  	lbs_deb_leave(LBS_DEB_MESH);
> >  	return 0;
> >  }
> > +#endif
> >  
> >  /**
> >   *  @brief This function closes the ethX interface
> > @@ -428,8 +437,10 @@
> >  
> >  	dev->trans_start = jiffies;
> >  
> > +#ifdef CONFIG_LIBERTAS_WEXT
> >  	if (priv->currenttxskb)
> >  		lbs_send_tx_feedback(priv, 0);
> > +#endif
> >  
> >  	/* XX: Shouldn't we also call into the hw-specific driver
> >  	   to kick it somehow? */
> > @@ -490,8 +501,10 @@
> >  
> >  	memcpy(priv->current_addr, phwaddr->sa_data, ETH_ALEN);
> >  	memcpy(dev->dev_addr, phwaddr->sa_data, ETH_ALEN);
> > +#ifdef CONFIG_LIBERTAS_WEXT
> >  	if (priv->mesh_dev)
> >  		memcpy(priv->mesh_dev->dev_addr, phwaddr->sa_data, ETH_ALEN);
> > +#endif
> >  
> >  done:
> >  	lbs_deb_leave_args(LBS_DEB_NET, "ret %d", ret);
> > @@ -554,8 +567,10 @@
> >  	lbs_deb_enter(LBS_DEB_NET);
> >  
> >  	dev_flags = priv->dev->flags;
> > +#ifdef CONFIG_LIBERTAS_WEXT
> >  	if (priv->mesh_dev)
> >  		dev_flags |= priv->mesh_dev->flags;
> > +#endif
> >  
> >  	if (dev_flags & IFF_PROMISC) {
> >  		priv->mac_control |= CMD_ACT_MAC_PROMISCUOUS_ENABLE;
> > @@ -572,8 +587,10 @@
> >  
> >  	/* Once for priv->dev, again for priv->mesh_dev if it exists */
> >  	nr_addrs = lbs_add_mcast_addrs(&mcast_cmd, priv->dev, 0);
> > +#ifdef CONFIG_LIBERTAS_WEXT
> >  	if (nr_addrs >= 0 && priv->mesh_dev)
> >  		nr_addrs = lbs_add_mcast_addrs(&mcast_cmd, priv->mesh_dev, nr_addrs);
> > +#endif
> >  	if (nr_addrs < 0)
> >  		goto do_allmulti;
> >  
> > @@ -816,9 +833,11 @@
> >  				   waiting for TX feedback */
> >  				if (priv->connect_status == LBS_CONNECTED)
> >  					netif_wake_queue(priv->dev);
> > +#ifdef CONFIG_LIBERTAS_WEXT
> >  				if (priv->mesh_dev &&
> >  				    priv->mesh_connect_status == LBS_CONNECTED)
> >  					netif_wake_queue(priv->mesh_dev);
> > +#endif
> >  			}
> >  		}
> >  		spin_unlock_irq(&priv->driver_lock);
> > @@ -838,8 +857,10 @@
> >  	lbs_deb_enter(LBS_DEB_FW);
> >  
> >  	netif_device_detach(priv->dev);
> > +#ifdef CONFIG_LIBERTAS_WEXT
> >  	if (priv->mesh_dev)
> >  		netif_device_detach(priv->mesh_dev);
> > +#endif
> >  
> >  	priv->fw_ready = 0;
> >  	lbs_deb_leave(LBS_DEB_FW);
> > @@ -882,8 +903,10 @@
> >  				     0, 0, NULL);
> >  
> >  	netif_device_attach(priv->dev);
> > +#ifdef CONFIG_LIBERTAS_WEXT
> >  	if (priv->mesh_dev)
> >  		netif_device_attach(priv->mesh_dev);
> > +#endif
> >  
> >  	lbs_deb_leave(LBS_DEB_FW);
> >  }
> > @@ -1004,6 +1027,7 @@
> >  	return 0;
> >  }
> >  
> > +#ifdef CONFIG_LIBERTAS_WEXT
> >  static void lbs_sync_channel_worker(struct work_struct *work)
> >  {
> >  	struct lbs_private *priv = container_of(work, struct lbs_private,
> > @@ -1014,15 +1038,19 @@
> >  		lbs_pr_info("Channel synchronization failed.");
> >  	lbs_deb_leave(LBS_DEB_MAIN);
> >  }
> > -
> > +#endif
> >  
> >  static int lbs_init_adapter(struct lbs_private *priv)
> >  {
> > +	int ret = 0;
> > +#ifdef CONFIG_LIBERTAS_WEXT
> >  	size_t bufsize;
> > -	int i, ret = 0;
> > +	int i;
> > +#endif
> >  
> >  	lbs_deb_enter(LBS_DEB_MAIN);
> >  
> > +#ifdef CONFIG_LIBERTAS_WEXT
> >  	/* Allocate buffer to store the BSSID list */
> >  	bufsize = MAX_NETWORK_COUNT * sizeof(struct bss_descriptor);
> >  	priv->networks = kzalloc(bufsize, GFP_KERNEL);
> > @@ -1039,17 +1067,18 @@
> >  		list_add_tail(&priv->networks[i].list,
> >  			      &priv->network_free_list);
> >  	}
> > +	priv->secinfo.auth_mode = IW_AUTH_ALG_OPEN_SYSTEM;
> > +	priv->mode = IW_MODE_INFRA;
> > +	priv->enablehwauto = 1;
> > +	priv->mesh_connect_status = LBS_DISCONNECTED;
> > +#endif
> >  
> >  	memset(priv->current_addr, 0xff, ETH_ALEN);
> >  
> >  	priv->connect_status = LBS_DISCONNECTED;
> > -	priv->mesh_connect_status = LBS_DISCONNECTED;
> > -	priv->secinfo.auth_mode = IW_AUTH_ALG_OPEN_SYSTEM;
> > -	priv->mode = IW_MODE_INFRA;
> >  	priv->channel = DEFAULT_AD_HOC_CHANNEL;
> >  	priv->mac_control = CMD_ACT_MAC_RX_ON | CMD_ACT_MAC_TX_ON;
> >  	priv->radio_on = 1;
> > -	priv->enablehwauto = 1;
> >  	priv->capability = WLAN_CAPABILITY_SHORT_PREAMBLE;
> >  	priv->psmode = LBS802_11POWERMODECAM;
> >  	priv->psstate = PS_STATE_FULL_POWER;
> > @@ -1103,8 +1132,10 @@
> >  		kfifo_free(priv->event_fifo);
> >  	del_timer(&priv->command_timer);
> >  	del_timer(&priv->auto_deepsleep_timer);
> > +#ifdef CONFIG_LIBERTAS_WEXT
> >  	kfree(priv->networks);
> >  	priv->networks = NULL;
> > +#endif
> >  
> >  	lbs_deb_leave(LBS_DEB_MAIN);
> >  }
> > @@ -1166,8 +1197,8 @@
> >  
> >   	dev->netdev_ops = &lbs_netdev_ops;
> >  	dev->watchdog_timeo = 5 * HZ;
> > +#ifdef CONFIG_LIBERTAS_WEXT
> >  	dev->ethtool_ops = &lbs_ethtool_ops;
> > -#ifdef	WIRELESS_EXT
> >  	dev->wireless_handlers = &lbs_handler_def;
> >  #endif
> >  	dev->flags |= IFF_BROADCAST | IFF_MULTICAST;
> > @@ -1177,11 +1208,8 @@
> >  
> > 
> >  	priv->card = card;
> > -	priv->mesh_open = 0;
> >  	priv->infra_open = 0;
> >  
> > -
> > -	priv->rtap_net_dev = NULL;
> >  	strcpy(dev->name, "wlan%d");
> >  
> >  	lbs_deb_thread("Starting main thread...\n");
> > @@ -1193,13 +1221,18 @@
> >  	}
> >  
> >  	priv->work_thread = create_singlethread_workqueue("lbs_worker");
> > -	INIT_DELAYED_WORK(&priv->assoc_work, lbs_association_worker);
> > -	INIT_DELAYED_WORK(&priv->scan_work, lbs_scan_worker);
> > -	INIT_WORK(&priv->mcast_work, lbs_set_mcast_worker);
> > -	INIT_WORK(&priv->sync_channel, lbs_sync_channel_worker);
> > +#ifdef CONFIG_LIBERTAS_WEXT
> > +	priv->rtap_net_dev = NULL;
> >  
> >  	sprintf(priv->mesh_ssid, "mesh");
> >  	priv->mesh_ssid_len = 4;
> > +	priv->mesh_open = 0;
> > +
> > +	INIT_DELAYED_WORK(&priv->assoc_work, lbs_association_worker);
> > +	INIT_DELAYED_WORK(&priv->scan_work, lbs_scan_worker);
> > +	INIT_WORK(&priv->sync_channel, lbs_sync_channel_worker);
> > +#endif
> > +	INIT_WORK(&priv->mcast_work, lbs_set_mcast_worker);
> >  
> >  	priv->wol_criteria = 0xffffffff;
> >  	priv->wol_gpio = 0xff;
> > @@ -1231,13 +1264,15 @@
> >  
> >  	lbs_deb_enter(LBS_DEB_MAIN);
> >  
> > +	dev = priv->dev;
> > +
> > +#ifdef CONFIG_LIBERTAS_WEXT
> >  	lbs_remove_mesh(priv);
> >  	lbs_remove_rtap(priv);
> >  
> > -	dev = priv->dev;
> > -
> >  	cancel_delayed_work_sync(&priv->scan_work);
> >  	cancel_delayed_work_sync(&priv->assoc_work);
> > +#endif
> >  	cancel_work_sync(&priv->mcast_work);
> >  
> >  	/* worker thread destruction blocks on the in-flight command which
> > @@ -1295,6 +1330,7 @@
> >  
> >  	lbs_update_channel(priv);
> >  
> > +#ifdef CONFIG_LIBERTAS_WEXT
> >  	/* Check mesh FW version and appropriately send the mesh start
> >  	 * command
> >  	 */
> > @@ -1342,6 +1378,7 @@
> >  		if (device_create_file(&dev->dev, &dev_attr_lbs_rtap))
> >  			lbs_pr_err("cannot register lbs_rtap attribute\n");
> >  	}
> > +#endif
> >  
> >  	lbs_debugfs_init_one(priv, dev);
> >  
> > @@ -1372,10 +1409,12 @@
> >  	netif_carrier_off(dev);
> >  
> >  	lbs_debugfs_remove_one(priv);
> > +#ifdef CONFIG_LIBERTAS_WEXT
> >  	if (priv->mesh_tlv) {
> >  		device_remove_file(&dev->dev, &dev_attr_lbs_mesh);
> >  		device_remove_file(&dev->dev, &dev_attr_lbs_rtap);
> >  	}
> > +#endif
> >  
> >  	/* Delete the timeout of the currently processing command */
> >  	del_timer_sync(&priv->command_timer);
> > @@ -1408,6 +1447,7 @@
> >  EXPORT_SYMBOL_GPL(lbs_stop_card);
> >  
> > 
> > +#ifdef CONFIG_LIBERTAS_WEXT
> >  static const struct net_device_ops mesh_netdev_ops = {
> >  	.ndo_open		= lbs_dev_open,
> >  	.ndo_stop 		= lbs_mesh_stop,
> > @@ -1445,7 +1485,7 @@
> >  
> >  	SET_NETDEV_DEV(priv->mesh_dev, priv->dev->dev.parent);
> >  
> > -#ifdef	WIRELESS_EXT
> > +#ifdef CONFIG_LIBERTAS_WEXT
> >  	mesh_dev->wireless_handlers = (struct iw_handler_def *)&mesh_handler_def;
> >  #endif
> >  	mesh_dev->flags |= IFF_BROADCAST | IFF_MULTICAST;
> > @@ -1496,6 +1536,7 @@
> >  	free_netdev(mesh_dev);
> >  	lbs_deb_leave(LBS_DEB_MESH);
> >  }
> > +#endif
> >  
> >  void lbs_queue_event(struct lbs_private *priv, u32 event)
> >  {
> > @@ -1556,6 +1597,7 @@
> >   * rtap interface support fuctions
> >   */
> >  
> > +#ifdef CONFIG_LIBERTAS_WEXT
> >  static int lbs_rtap_open(struct net_device *dev)
> >  {
> >  	/* Yes, _stop_ the queue. Because we don't support injection */
> > @@ -1632,6 +1674,7 @@
> >  	lbs_deb_leave_args(LBS_DEB_MAIN, "ret %d", ret);
> >  	return ret;
> >  }
> > +#endif
> >  
> >  module_init(lbs_init_module);
> >  module_exit(lbs_exit_module);
> > --- linux-wl.orig/drivers/net/wireless/libertas/cmdresp.c
> > +++ linux-wl/drivers/net/wireless/libertas/cmdresp.c
> > @@ -7,7 +7,6 @@
> >  #include <linux/if_arp.h>
> >  #include <linux/netdevice.h>
> >  #include <asm/unaligned.h>
> > -#include <net/iw_handler.h>
> >  
> >  #include "host.h"
> >  #include "decl.h"
> > @@ -27,13 +26,16 @@
> >   */
> >  void lbs_mac_event_disconnected(struct lbs_private *priv)
> >  {
> > +#ifdef CONFIG_LIBERTAS_WEXT
> >  	union iwreq_data wrqu;
> > +#endif
> >  
> >  	if (priv->connect_status != LBS_CONNECTED)
> >  		return;
> >  
> >  	lbs_deb_enter(LBS_DEB_ASSOC);
> >  
> > +#ifdef CONFIG_LIBERTAS_WEXT
> >  	memset(wrqu.ap_addr.sa_data, 0x00, ETH_ALEN);
> >  	wrqu.ap_addr.sa_family = ARPHRD_ETHER;
> >  
> > @@ -44,6 +46,9 @@
> >  
> >  	msleep_interruptible(1000);
> >  	wireless_send_event(priv->dev, SIOCGIWAP, &wrqu, NULL);
> > +#else
> > +	/* TODO: find out what to do in the cfg80211 case */
> > +#endif
> >  
> >  	/* report disconnect to upper layer */
> >  	netif_stop_queue(priv->dev);
> > @@ -55,6 +60,7 @@
> >  	priv->tx_pending_len = 0;
> >  
> >  	/* reset SNR/NF/RSSI values */
> > +#ifdef CONFIG_LIBERTAS_WEXT
> >  	memset(priv->SNR, 0x00, sizeof(priv->SNR));
> >  	memset(priv->NF, 0x00, sizeof(priv->NF));
> >  	memset(priv->RSSI, 0x00, sizeof(priv->RSSI));
> > @@ -62,7 +68,6 @@
> >  	memset(priv->rawNF, 0x00, sizeof(priv->rawNF));
> >  	priv->nextSNRNF = 0;
> >  	priv->numSNRNF = 0;
> > -	priv->connect_status = LBS_DISCONNECTED;
> >  
> >  	/* Clear out associated SSID and BSSID since connection is
> >  	 * no longer valid.
> > @@ -70,6 +75,9 @@
> >  	memset(&priv->curbssparams.bssid, 0, ETH_ALEN);
> >  	memset(&priv->curbssparams.ssid, 0, IEEE80211_MAX_SSID_LEN);
> >  	priv->curbssparams.ssid_len = 0;
> > +#endif
> > +	priv->connect_status = LBS_DISCONNECTED;
> > +
> >  
> >  	if (priv->psstate != PS_STATE_FULL_POWER) {
> >  		/* make firmware to exit PS mode */
> > @@ -88,9 +96,12 @@
> >   */
> >  static void handle_mic_failureevent(struct lbs_private *priv, u32 event)
> >  {
> > +#ifdef CONFIG_LIBERTAS_WEXT
> >  	char buf[50];
> > +#endif
> >  
> >  	lbs_deb_enter(LBS_DEB_CMD);
> > +#ifdef CONFIG_LIBERTAS_WEXT
> >  	memset(buf, 0, sizeof(buf));
> >  
> >  	sprintf(buf, "%s", "MLME-MICHAELMICFAILURE.indication ");
> > @@ -102,6 +113,7 @@
> >  	}
> >  
> >  	lbs_send_iwevcustom_event(priv, buf);
> > +#endif
> >  	lbs_deb_leave(LBS_DEB_CMD);
> >  }
> >  
> > @@ -177,10 +189,6 @@
> >  	case CMD_RET(CMD_802_11_BEACON_STOP):
> >  		break;
> >  
> > -	case CMD_RET(CMD_802_11_RSSI):
> > -		ret = lbs_ret_802_11_rssi(priv, resp);
> > -		break;
> > -
> >  	case CMD_RET(CMD_802_11_TPC_CFG):
> >  		spin_lock_irqsave(&priv->driver_lock, flags);
> >  		memmove((void *)priv->cur_cmd->callback_arg, &resp->params.tpccfg,
> > @@ -202,9 +210,16 @@
> >  			       sizeof(resp->params.fwt));
> >  		spin_unlock_irqrestore(&priv->driver_lock, flags);
> >  		break;
> > +
> > +#ifdef CONFIG_LIBERTAS_WEXT
> > +	case CMD_RET(CMD_802_11_RSSI):
> > +		ret = lbs_ret_802_11_rssi(priv, resp);
> > +		break;
> > +
> >  	case CMD_RET(CMD_802_11_BEACON_CTRL):
> >  		ret = lbs_ret_802_11_bcn_ctrl(priv, resp);
> >  		break;
> > +#endif
> >  
> >  	default:
> >  		lbs_pr_err("CMD_RESP: unknown cmd response 0x%04x\n",
> > @@ -297,9 +312,13 @@
> >  			 * ad-hoc mode. It takes place in
> >  			 * lbs_execute_next_command().
> >  			 */
> > +#ifdef CONFIG_LIBERTAS_WEXT
> >  			if (priv->mode == IW_MODE_ADHOC &&
> >  			    action == CMD_SUBCMD_ENTER_PS)
> >  				priv->psmode = LBS802_11POWERMODECAM;
> > +#else
> > +		/* TODO: we need to figure out what to do here in cfg80211-mode */
> > +#endif
> >  		} else if (action == CMD_SUBCMD_ENTER_PS) {
> >  			priv->needtowakeup = 0;
> >  			priv->psstate = PS_STATE_AWAKE;
> > @@ -516,6 +535,7 @@
> >  		lbs_pr_alert("EVENT: snr high\n");
> >  		break;
> >  
> > +#ifdef CONFIG_LIBERTAS_WEXT
> >  	case MACREG_INT_CODE_MESH_AUTO_STARTED:
> >  		/* Ignore spurious autostart events if autostart is disabled */
> >  		if (!priv->mesh_autostart_enabled) {
> > @@ -532,6 +552,7 @@
> >  		priv->mode = IW_MODE_ADHOC;
> >  		schedule_work(&priv->sync_channel);
> >  		break;
> > +#endif
> >  
> >  	default:
> >  		lbs_pr_alert("EVENT: unknown event id %d\n", event);
> > --- linux-wl.orig/drivers/net/wireless/libertas/debugfs.c
> > +++ linux-wl/drivers/net/wireless/libertas/debugfs.c
> > @@ -4,7 +4,6 @@
> >  #include <linux/delay.h>
> >  #include <linux/mm.h>
> >  #include <linux/string.h>
> > -#include <net/iw_handler.h>
> >  #include <net/lib80211.h>
> >  
> >  #include "dev.h"
> > @@ -60,6 +59,7 @@
> >  }
> >  
> > 
> > +#ifdef CONFIG_LIBERTAS_WEXT
> >  static ssize_t lbs_getscantable(struct file *file, char __user *userbuf,
> >  				  size_t count, loff_t *ppos)
> >  {
> > @@ -103,6 +103,7 @@
> >  	free_page(addr);
> >  	return res;
> >  }
> > +#endif
> >  
> >  static ssize_t lbs_sleepparams_write(struct file *file,
> >  				const char __user *user_buf, size_t count,
> > @@ -722,8 +723,10 @@
> >  
> >  static const struct lbs_debugfs_files debugfs_files[] = {
> >  	{ "info", 0444, FOPS(lbs_dev_info, write_file_dummy), },
> > +#ifdef CONFIG_LIBERTAS_WEXT
> >  	{ "getscantable", 0444, FOPS(lbs_getscantable,
> >  					write_file_dummy), },
> > +#endif
> >  	{ "sleepparams", 0644, FOPS(lbs_sleepparams_read,
> >  				lbs_sleepparams_write), },
> >  };
> > --- linux-wl.orig/drivers/net/wireless/libertas/rx.c
> > +++ linux-wl/drivers/net/wireless/libertas/rx.c
> > @@ -34,6 +34,7 @@
> >  	void *eth80211_hdr;
> >  } __attribute__ ((packed));
> >  
> > +#ifdef CONFIG_LIBERTAS_WEXT
> >  static int process_rxed_802_11_packet(struct lbs_private *priv,
> >  	struct sk_buff *skb);
> >  
> > @@ -129,6 +130,7 @@
> >  
> >  	lbs_deb_leave(LBS_DEB_RX);
> >  }
> > +#endif
> >  
> >  /**
> >   *  @brief This function processes received packet and forwards it
> > @@ -154,12 +156,15 @@
> >  
> >  	skb->ip_summed = CHECKSUM_NONE;
> >  
> > +#ifdef CONFIG_LIBERTAS_WEXT
> >  	if (priv->monitormode)
> >  		return process_rxed_802_11_packet(priv, skb);
> > +#endif
> >  
> >  	p_rx_pd = (struct rxpd *) skb->data;
> >  	p_rx_pkt = (struct rxpackethdr *) ((u8 *)p_rx_pd +
> >  		le32_to_cpu(p_rx_pd->pkt_ptr));
> > +#ifdef CONFIG_LIBERTAS_WEXT
> >  	if (priv->mesh_dev) {
> >  		if (priv->mesh_fw_ver == MESH_FW_OLD) {
> >  			if (p_rx_pd->rx_control & RxPD_MESH_FRAME)
> > @@ -169,6 +174,7 @@
> >  				dev = priv->mesh_dev;
> >  		}
> >  	}
> > +#endif
> >  
> >  	lbs_deb_hex(LBS_DEB_RX, "RX Data: Before chop rxpd", skb->data,
> >  		 min_t(unsigned int, skb->len, 100));
> > @@ -232,6 +238,7 @@
> >  	 */
> >  	skb_pull(skb, hdrchop);
> >  
> > +#ifdef CONFIG_LIBERTAS_WEXT
> >  	/* Take the data rate from the rxpd structure
> >  	 * only if the rate is auto
> >  	 */
> > @@ -239,6 +246,7 @@
> >  		priv->cur_rate = lbs_fw_index_to_data_rate(p_rx_pd->rx_rate);
> >  
> >  	lbs_compute_rssi(priv, p_rx_pd);
> > +#endif
> >  
> >  	lbs_deb_rx("rx data: size of actual packet %d\n", skb->len);
> >  	dev->stats.rx_bytes += skb->len;
> > @@ -257,6 +265,7 @@
> >  }
> >  EXPORT_SYMBOL_GPL(lbs_process_rxed_packet);
> >  
> > +#ifdef CONFIG_LIBERTAS_WEXT
> >  /**
> >   *  @brief This function converts Tx/Rx rates from the Marvell WLAN format
> >   *  (see Table 2 in Section 3.1) to IEEE80211_RADIOTAP_RATE units (500 Kb/s)
> > @@ -381,3 +390,4 @@
> >  	lbs_deb_leave_args(LBS_DEB_RX, "ret %d", ret);
> >  	return ret;
> >  }
> > +#endif
> > --- linux-wl.orig/drivers/net/wireless/libertas/tx.c
> > +++ linux-wl/drivers/net/wireless/libertas/tx.c
> > @@ -12,6 +12,7 @@
> >  #include "dev.h"
> >  #include "wext.h"
> >  
> > +#ifdef CONFIG_LIBERTAS_WEXT
> >  /**
> >   *  @brief This function converts Tx/Rx rates from IEEE80211_RADIOTAP_RATE
> >   *  units (500 Kb/s) into Marvell WLAN format (see Table 8 in Section 3.2.1)
> > @@ -49,6 +50,7 @@
> >  	}
> >  	return 0;
> >  }
> > +#endif
> >  
> >  /**
> >   *  @brief This function checks the conditions and sends packet to IF
> > @@ -88,8 +90,10 @@
> >  
> > 
> >  	netif_stop_queue(priv->dev);
> > +#ifdef CONFIG_LIBERTAS_WEXT
> >  	if (priv->mesh_dev)
> >  		netif_stop_queue(priv->mesh_dev);
> > +#endif
> >  
> >  	if (priv->tx_pending_len) {
> >  		/* This can happen if packets come in on the mesh and eth
> > @@ -111,6 +115,7 @@
> >  	p802x_hdr = skb->data;
> >  	pkt_len = skb->len;
> >  
> > +#ifdef CONFIG_LIBERTAS_WEXT
> >  	if (dev == priv->rtap_net_dev) {
> >  		struct tx_radiotap_hdr *rtap_hdr = (void *)skb->data;
> >  
> > @@ -123,6 +128,9 @@
> >  
> >  		/* copy destination address from 802.11 header */
> >  		memcpy(txpd->tx_dest_addr_high, p802x_hdr + 4, ETH_ALEN);
> > +#else
> > +	if (0) {
> > +#endif
> >  	} else {
> >  		/* copy destination address from 802.3 header */
> >  		memcpy(txpd->tx_dest_addr_high, p802x_hdr, ETH_ALEN);
> > @@ -131,12 +139,14 @@
> >  	txpd->tx_packet_length = cpu_to_le16(pkt_len);
> >  	txpd->tx_packet_location = cpu_to_le32(sizeof(struct txpd));
> >  
> > +#ifdef CONFIG_LIBERTAS_WEXT
> >  	if (dev == priv->mesh_dev) {
> >  		if (priv->mesh_fw_ver == MESH_FW_OLD)
> >  			txpd->tx_control |= cpu_to_le32(TxPD_MESH_FRAME);
> >  		else if (priv->mesh_fw_ver == MESH_FW_NEW)
> >  			txpd->u.bss.bss_num = MESH_IFACE_ID;
> >  	}
> > +#endif
> >  
> >  	lbs_deb_hex(LBS_DEB_TX, "txpd", (u8 *) &txpd, sizeof(struct txpd));
> >  
> > @@ -154,6 +164,7 @@
> >  
> >  	dev->trans_start = jiffies;
> >  
> > +#ifdef CONFIG_LIBERTAS_WEXT
> >  	if (priv->monitormode) {
> >  		/* Keep the skb to echo it back once Tx feedback is
> >  		   received from FW */
> > @@ -161,6 +172,9 @@
> >  
> >  		/* Keep the skb around for when we get feedback */
> >  		priv->currenttxskb = skb;
> > +#else
> > +	if (0) {
> > +#endif
> >  	} else {
> >   free:
> >  		dev_kfree_skb_any(skb);
> > @@ -173,6 +187,7 @@
> >  	return ret;
> >  }
> >  
> > +#ifdef CONFIG_LIBERTAS_WEXT
> >  /**
> >   *  @brief This function sends to the host the last transmitted packet,
> >   *  filling the radiotap headers with transmission information.
> > @@ -207,3 +222,4 @@
> >  		netif_wake_queue(priv->mesh_dev);
> >  }
> >  EXPORT_SYMBOL_GPL(lbs_send_tx_feedback);
> > +#endif
> > --- linux-wl.orig/drivers/net/wireless/libertas/if_usb.c
> > +++ linux-wl/drivers/net/wireless/libertas/if_usb.c
> > @@ -757,6 +757,7 @@
> >  		lbs_deb_usbd(&cardp->udev->dev, "**EVENT** 0x%X\n", event);
> >  		kfree_skb(skb);
> >  
> > +#ifdef CONFIG_LIBERTAS_WEXT
> >  		/* Icky undocumented magic special case */
> >  		if (event & 0xffff0000) {
> >  			u32 trycount = (event & 0xffff0000) >> 16;
> > @@ -764,6 +765,7 @@
> >  			lbs_send_tx_feedback(priv, trycount);
> >  		} else
> >  			lbs_queue_event(priv, event & 0xFF);
> > +#endif
> >  		break;
> >  
> >  	default:
> > --- linux-wl.orig/drivers/net/wireless/libertas/assoc.h
> > +++ linux-wl/drivers/net/wireless/libertas/assoc.h
> > @@ -3,6 +3,7 @@
> >  #ifndef _LBS_ASSOC_H_
> >  #define _LBS_ASSOC_H_
> >  
> > +#ifdef CONFIG_LIBERTAS_WEXT
> >  
> >  #include "defs.h"
> >  #include "host.h"
> > @@ -152,4 +153,6 @@
> >  int lbs_cmd_802_11_key_material(struct lbs_private *priv, uint16_t cmd_action,
> >  				struct assoc_request *assoc);
> >  
> > +#endif
> > +
> >  #endif /* _LBS_ASSOC_H */
> > --- linux-wl.orig/drivers/net/wireless/libertas/scan.h
> > +++ linux-wl/drivers/net/wireless/libertas/scan.h
> > @@ -7,6 +7,8 @@
> >  #ifndef _LBS_SCAN_H
> >  #define _LBS_SCAN_H
> >  
> > +#ifdef CONFIG_LIBERTAS_WEXT
> > +
> >  #include <net/iw_handler.h>
> >  
> >  struct lbs_private;
> > @@ -61,3 +63,5 @@
> >  void lbs_scan_worker(struct work_struct *work);
> >  
> >  #endif
> > +
> > +#endif
> > --- linux-wl.orig/drivers/net/wireless/libertas/wext.h
> > +++ linux-wl/drivers/net/wireless/libertas/wext.h
> > @@ -4,9 +4,13 @@
> >  #ifndef	_LBS_WEXT_H_
> >  #define	_LBS_WEXT_H_
> >  
> > +#ifdef CONFIG_LIBERTAS_WEXT
> > +
> >  void lbs_send_iwevcustom_event(struct lbs_private *priv, s8 *str);
> >  
> >  extern struct iw_handler_def lbs_handler_def;
> >  extern struct iw_handler_def mesh_handler_def;
> >  
> >  #endif
> > +
> > +#endif
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


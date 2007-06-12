Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s131.mittwaldmedien.de ([62.216.178.31]:13860 "EHLO
	s131.mittwaldmedien.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752883AbXFLGn7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Jun 2007 02:43:59 -0400
From: Holger Schurig <hs4233@mail.mn-solutions.de>
To: linux-wireless@vger.kernel.org, Dan Williams <dcbw@redhat.com>
Subject: Re: Please pull libertas-2.6
Date: Tue, 12 Jun 2007 08:43:48 +0200
References: <1181102122.18061.8.camel@xo-28-0B-88.localdomain> <20070611201222.GI10397@tuxdriver.com> <1181597511.6131.2.camel@xo-28-0B-88.localdomain>
In-Reply-To: <1181597511.6131.2.camel@xo-28-0B-88.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Message-Id: <200706120843.48517.hs4233@mail.mn-solutions.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> for bugfixes.  Otherwise I can give you a list of commit IDs
> to cherry-pick or something like that.

If we're going to cherry-pick, maybe you can look (and possible
integrate) my get-rid-of-fw.c-patch that is necessary for
Compact-Flash (and possibly SDIO based) 83xx cards?



>From 605d5440d0a2ff442d0506aa15d4d9f8ebe8e630 Mon Sep 17 00:00:00 2001
From: Holger Schurig <schurig@schurig.homelinux.net>
Date: Tue, 5 Jun 2007 22:37:04 +0200
Subject: [PATCH] [libertas] change firmware downlaod logic

Firmware download is quite different for different hardware. The
SDIO and CF cards have two flat files that need to be downloaded,
whereas the USB driver needs only one file, but with an internal
structure.

This patch moves the firmware downloading code from fw.c into if_usb.c. The
other code that used to be in fw.c has been moved to main.c.

Signed-off-by: Holger Schurig <h4233@mail.mn-solutions.de>

---
 drivers/net/wireless/libertas/Makefile |    2 +-
 drivers/net/wireless/libertas/decl.h   |    5 +-
 drivers/net/wireless/libertas/fw.c     |  346 --------------------------------
 drivers/net/wireless/libertas/if_usb.c |   78 +++++++-
 drivers/net/wireless/libertas/main.c   |  278 +++++++++++++++++++++++++-
 5 files changed, 354 insertions(+), 355 deletions(-)
 delete mode 100644 drivers/net/wireless/libertas/fw.c

diff --git a/drivers/net/wireless/libertas/Makefile b/drivers/net/wireless/libertas/Makefile
index fdda0f0..4d120c3 100644
--- a/drivers/net/wireless/libertas/Makefile
+++ b/drivers/net/wireless/libertas/Makefile
@@ -1,4 +1,4 @@
-libertas-objs := main.o fw.o wext.o \
+libertas-objs := main.o wext.o \
 		rx.o tx.o cmd.o 	  \
 		cmdresp.o scan.o	  \
 		join.o 11d.o 		  \
diff --git a/drivers/net/wireless/libertas/decl.h b/drivers/net/wireless/libertas/decl.h
index 129b021..113cfc1 100644
--- a/drivers/net/wireless/libertas/decl.h
+++ b/drivers/net/wireless/libertas/decl.h
@@ -75,14 +75,11 @@ void libertas_mac_event_disconnected(wlan_private * priv);
 
 void libertas_send_iwevcustom_event(wlan_private * priv, s8 * str);
 
-/* fw.c */
-int libertas_init_fw(wlan_private * priv, char *fw_name);
-
 /* main.c */
 struct chan_freq_power *libertas_get_region_cfp_table(u8 region, u8 band,
 						             int *cfp_no);
 wlan_private *libertas_add_card(void *card, struct device *dmdev);
-int libertas_activate_card(wlan_private *priv, char *fw_name);
+int libertas_activate_card(wlan_private *priv);
 int libertas_remove_card(wlan_private *priv);
 int libertas_add_mesh(wlan_private *priv, struct device *dev);
 void libertas_remove_mesh(wlan_private *priv);
diff --git a/drivers/net/wireless/libertas/fw.c b/drivers/net/wireless/libertas/fw.c
deleted file mode 100644
index 6c25987..0000000
--- a/drivers/net/wireless/libertas/fw.c
+++ /dev/null
@@ -1,346 +0,0 @@
-/**
-  * This file contains the initialization for FW and HW
-  */
-#include <linux/firmware.h>
-
-#include "host.h"
-#include "defs.h"
-#include "decl.h"
-#include "dev.h"
-#include "wext.h"
-#include "if_usb.h"
-
-/**
- *  @brief This function checks the validity of Boot2/FW image.
- *
- *  @param data              pointer to image
- *         len               image length
- *  @return     0 or -1
- */
-static int check_fwfile_format(u8 *data, u32 totlen)
-{
-	u32 bincmd, exit;
-	u32 blksize, offset, len;
-	int ret;
-
-	ret = 1;
-	exit = len = 0;
-
-	do {
-		struct fwheader *fwh = (void *)data;
-
-		bincmd = le32_to_cpu(fwh->dnldcmd);
-		blksize = le32_to_cpu(fwh->datalength);
-		switch (bincmd) {
-		case FW_HAS_DATA_TO_RECV:
-			offset = sizeof(struct fwheader) + blksize;
-			data += offset;
-			len += offset;
-			if (len >= totlen)
-				exit = 1;
-			break;
-		case FW_HAS_LAST_BLOCK:
-			exit = 1;
-			ret = 0;
-			break;
-		default:
-			exit = 1;
-			break;
-		}
-	} while (!exit);
-
-	if (ret)
-		lbs_pr_err("firmware file format check FAIL\n");
-	else
-		lbs_deb_fw("firmware file format check PASS\n");
-
-	return ret;
-}
-
-/**
- *  @brief This function downloads firmware image, gets
- *  HW spec from firmware and set basic parameters to
- *  firmware.
- *
- *  @param priv    A pointer to wlan_private structure
- *  @return 	   0 or -1
- */
-static int wlan_setup_station_hw(wlan_private * priv, char *fw_name)
-{
-	int ret = -1;
-	wlan_adapter *adapter = priv->adapter;
-
-	lbs_deb_enter(LBS_DEB_FW);
-
-	if ((ret = request_firmware(&priv->firmware, fw_name,
-				    priv->hotplug_device)) < 0) {
-		lbs_pr_err("request_firmware() failed with %#x\n", ret);
-		lbs_pr_err("firmware %s not found\n", fw_name);
-		goto done;
-	}
-
-	if (check_fwfile_format(priv->firmware->data, priv->firmware->size)) {
-		release_firmware(priv->firmware);
-		goto done;
-	}
-
-	ret = priv->hw_prog_firmware(priv);
-
-	release_firmware(priv->firmware);
-
-	if (ret) {
-		lbs_deb_fw("bootloader in invalid state\n");
-		ret = -1;
-		goto done;
-	}
-
-	/*
-	 * Read MAC address from HW
-	 */
-	memset(adapter->current_addr, 0xff, ETH_ALEN);
-
-	ret = libertas_prepare_and_send_command(priv, CMD_GET_HW_SPEC,
-				    0, CMD_OPTION_WAITFORRSP, 0, NULL);
-
-	if (ret) {
-		ret = -1;
-		goto done;
-	}
-
-	libertas_set_mac_packet_filter(priv);
-
-	/* Get the supported Data rates */
-	ret = libertas_prepare_and_send_command(priv, CMD_802_11_DATA_RATE,
-				    CMD_ACT_GET_TX_RATE,
-				    CMD_OPTION_WAITFORRSP, 0, NULL);
-
-	if (ret) {
-		ret = -1;
-		goto done;
-	}
-
-	ret = 0;
-done:
-	lbs_deb_leave_args(LBS_DEB_FW, "ret %d", ret);
-	return ret;
-}
-
-static int wlan_allocate_adapter(wlan_private * priv)
-{
-	size_t bufsize;
-	wlan_adapter *adapter = priv->adapter;
-
-	/* Allocate buffer to store the BSSID list */
-	bufsize = MAX_NETWORK_COUNT * sizeof(struct bss_descriptor);
-	adapter->networks = kzalloc(bufsize, GFP_KERNEL);
-	if (!adapter->networks) {
-		lbs_pr_err("Out of memory allocating beacons\n");
-		libertas_free_adapter(priv);
-		return -ENOMEM;
-	}
-
-	/* Allocate the command buffers */
-	libertas_allocate_cmd_buffer(priv);
-
-	memset(&adapter->libertas_ps_confirm_sleep, 0, sizeof(struct PS_CMD_ConfirmSleep));
-	adapter->libertas_ps_confirm_sleep.seqnum = cpu_to_le16(++adapter->seqnum);
-	adapter->libertas_ps_confirm_sleep.command =
-	    cpu_to_le16(CMD_802_11_PS_MODE);
-	adapter->libertas_ps_confirm_sleep.size =
-	    cpu_to_le16(sizeof(struct PS_CMD_ConfirmSleep));
-	adapter->libertas_ps_confirm_sleep.result = 0;
-	adapter->libertas_ps_confirm_sleep.action =
-	    cpu_to_le16(CMD_SUBCMD_SLEEP_CONFIRMED);
-
-	return 0;
-}
-
-static void wlan_init_adapter(wlan_private * priv)
-{
-	wlan_adapter *adapter = priv->adapter;
-	int i;
-
-	adapter->scanprobes = 0;
-
-	adapter->bcn_avg_factor = DEFAULT_BCN_AVG_FACTOR;
-	adapter->data_avg_factor = DEFAULT_DATA_AVG_FACTOR;
-
-	/* ATIM params */
-	adapter->atimwindow = 0;
-
-	adapter->connect_status = LIBERTAS_DISCONNECTED;
-	memset(adapter->current_addr, 0xff, ETH_ALEN);
-
-	/* scan type */
-	adapter->scantype = CMD_SCAN_TYPE_ACTIVE;
-
-	/* scan mode */
-	adapter->scanmode = CMD_BSS_TYPE_ANY;
-
-	/* 802.11 specific */
-	adapter->secinfo.wep_enabled = 0;
-	for (i = 0; i < sizeof(adapter->wep_keys) / sizeof(adapter->wep_keys[0]);
-	     i++)
-		memset(&adapter->wep_keys[i], 0, sizeof(struct enc_key));
-	adapter->wep_tx_keyidx = 0;
-	adapter->secinfo.auth_mode = IW_AUTH_ALG_OPEN_SYSTEM;
-	adapter->mode = IW_MODE_INFRA;
-
-	adapter->pending_assoc_req = NULL;
-	adapter->in_progress_assoc_req = NULL;
-
-	/* Initialize scan result lists */
-	INIT_LIST_HEAD(&adapter->network_free_list);
-	INIT_LIST_HEAD(&adapter->network_list);
-	for (i = 0; i < MAX_NETWORK_COUNT; i++) {
-		list_add_tail(&adapter->networks[i].list,
-			      &adapter->network_free_list);
-	}
-
-	mutex_init(&adapter->lock);
-
-	adapter->prescan = 1;
-
-	memset(&adapter->curbssparams, 0, sizeof(adapter->curbssparams));
-	adapter->curbssparams.channel = DEFAULT_AD_HOC_CHANNEL;
-
-	/* PnP and power profile */
-	adapter->surpriseremoved = 0;
-
-	adapter->currentpacketfilter =
-	    CMD_ACT_MAC_RX_ON | CMD_ACT_MAC_TX_ON;
-
-	adapter->radioon = RADIO_ON;
-	adapter->txantenna = RF_ANTENNA_2;
-	adapter->rxantenna = RF_ANTENNA_AUTO;
-
-	adapter->auto_rate = 1;
-	adapter->cur_rate = 0;
-	adapter->adhoc_grate_enabled = 0;
-
-	adapter->beaconperiod = MRVDRV_BEACON_INTERVAL;
-
-	// set default capabilities
-	adapter->capability = WLAN_CAPABILITY_SHORT_PREAMBLE;
-
-	adapter->psmode = WLAN802_11POWERMODECAM;
-	adapter->multipledtim = MRVDRV_DEFAULT_MULTIPLE_DTIM;
-
-	adapter->listeninterval = MRVDRV_DEFAULT_LISTEN_INTERVAL;
-
-	adapter->psstate = PS_STATE_FULL_POWER;
-	adapter->needtowakeup = 0;
-	adapter->locallisteninterval = 0;	/* default value in firmware will be used */
-
-	adapter->intcounter = 0;
-
-	adapter->currenttxskb = NULL;
-	adapter->pkttxctrl = 0;
-
-	memset(&adapter->tx_queue_ps, 0, NR_TX_QUEUE*sizeof(struct sk_buff*));
-	adapter->tx_queue_idx = 0;
-	spin_lock_init(&adapter->txqueue_lock);
-
-	return;
-}
-
-static void command_timer_fn(unsigned long data);
-
-int libertas_init_fw(wlan_private * priv, char *fw_name)
-{
-	int ret = -1;
-	wlan_adapter *adapter = priv->adapter;
-
-	lbs_deb_enter(LBS_DEB_FW);
-
-	/* Allocate adapter structure */
-	if ((ret = wlan_allocate_adapter(priv)) != 0)
-		goto done;
-
-	/* init adapter structure */
-	wlan_init_adapter(priv);
-
-	/* init timer etc. */
-	setup_timer(&adapter->command_timer, command_timer_fn,
-			(unsigned long)priv);
-
-	/* download fimrware etc. */
-	if ((ret = wlan_setup_station_hw(priv, fw_name)) != 0) {
-		del_timer_sync(&adapter->command_timer);
-		goto done;
-	}
-
-	/* init 802.11d */
-	libertas_init_11d(priv);
-
-	ret = 0;
-done:
-	lbs_deb_leave_args(LBS_DEB_FW, "ret %d", ret);
-	return ret;
-}
-
-void libertas_free_adapter(wlan_private * priv)
-{
-	wlan_adapter *adapter = priv->adapter;
-
-	if (!adapter) {
-		lbs_deb_fw("why double free adapter?\n");
-		return;
-	}
-
-	lbs_deb_fw("free command buffer\n");
-	libertas_free_cmd_buffer(priv);
-
-	lbs_deb_fw("free command_timer\n");
-	del_timer(&adapter->command_timer);
-
-	lbs_deb_fw("free scan results table\n");
-	kfree(adapter->networks);
-	adapter->networks = NULL;
-
-	/* Free the adapter object itself */
-	lbs_deb_fw("free adapter\n");
-	kfree(adapter);
-	priv->adapter = NULL;
-}
-
-/**
- *  This function handles the timeout of command sending.
- *  It will re-send the same command again.
- */
-static void command_timer_fn(unsigned long data)
-{
-	wlan_private *priv = (wlan_private *)data;
-	wlan_adapter *adapter = priv->adapter;
-	struct cmd_ctrl_node *ptempnode;
-	struct cmd_ds_command *cmd;
-	unsigned long flags;
-
-	ptempnode = adapter->cur_cmd;
-	if (ptempnode == NULL) {
-		lbs_deb_fw("ptempnode empty\n");
-		return;
-	}
-
-	cmd = (struct cmd_ds_command *)ptempnode->bufvirtualaddr;
-	if (!cmd) {
-		lbs_deb_fw("cmd is NULL\n");
-		return;
-	}
-
-	lbs_deb_fw("command_timer_fn fired, cmd %x\n", cmd->command);
-
-	if (!adapter->fw_ready)
-		return;
-
-	spin_lock_irqsave(&adapter->driver_lock, flags);
-	adapter->cur_cmd = NULL;
-	spin_unlock_irqrestore(&adapter->driver_lock, flags);
-
-	lbs_deb_fw("re-sending same command because of timeout\n");
-	libertas_queue_cmd(adapter, ptempnode, 0);
-
-	wake_up_interruptible(&priv->waitq);
-
-	return;
-}
diff --git a/drivers/net/wireless/libertas/if_usb.c b/drivers/net/wireless/libertas/if_usb.c
index e38fce7..ac1cfc2 100644
--- a/drivers/net/wireless/libertas/if_usb.c
+++ b/drivers/net/wireless/libertas/if_usb.c
@@ -216,7 +216,7 @@ static int if_usb_probe(struct usb_interface *intf,
 	priv->hw_get_int_status = if_usb_get_int_status;
 	priv->hw_read_event_cause = if_usb_read_event_cause;
 
-	if (libertas_activate_card(priv, libertas_fw_name))
+	if (libertas_activate_card(priv))
 		goto err_activate_card;
 
 	list_add_tail(&cardp->list, &usb_devices);
@@ -819,7 +819,7 @@ static int if_usb_issue_boot_command(wlan_private *priv, int ivalue)
 }
 
 
-static int if_usb_prog_firmware(wlan_private * priv)
+static int if_usb_do_prog_firmware(wlan_private * priv)
 {
 	struct usb_card_rec *cardp = priv->card;
 	int i = 0;
@@ -903,6 +903,80 @@ done:
 	return ret;
 }
 
+/**
+ *  @brief This function checks the validity of Boot2/FW image.
+ *
+ *  @param data              pointer to image
+ *         len               image length
+ *  @return     0 or -1
+ */
+static int check_fwfile_format(u8 *data, u32 totlen)
+{
+	u32 bincmd, exit;
+	u32 blksize, offset, len;
+	int ret;
+
+	ret = 1;
+	exit = len = 0;
+
+	do {
+		struct fwheader *fwh = (void *)data;
+
+		bincmd = le32_to_cpu(fwh->dnldcmd);
+		blksize = le32_to_cpu(fwh->datalength);
+		switch (bincmd) {
+		case FW_HAS_DATA_TO_RECV:
+			offset = sizeof(struct fwheader) + blksize;
+			data += offset;
+			len += offset;
+			if (len >= totlen)
+				exit = 1;
+			break;
+		case FW_HAS_LAST_BLOCK:
+			exit = 1;
+			ret = 0;
+			break;
+		default:
+			exit = 1;
+			break;
+		}
+	} while (!exit);
+
+	if (ret)
+		lbs_pr_err("firmware file format check FAIL\n");
+	else
+		lbs_deb_fw("firmware file format check PASS\n");
+
+	return ret;
+}
+
+
+static int if_usb_prog_firmware(wlan_private *priv)
+{
+	int ret = -1;
+
+	lbs_deb_enter(LBS_DEB_FW);
+
+	if ((ret = request_firmware(&priv->firmware, libertas_fw_name,
+				    priv->hotplug_device)) < 0) {
+		lbs_pr_err("request_firmware() failed with %#x\n", ret);
+		lbs_pr_err("firmware %s not found\n", libertas_fw_name);
+		goto done;
+	}
+
+	if (check_fwfile_format(priv->firmware->data, priv->firmware->size)) {
+		release_firmware(priv->firmware);
+		goto done;
+	}
+
+	ret = if_usb_do_prog_firmware(priv);
+
+	release_firmware(priv->firmware);
+done:
+	return ret;
+}
+
+
 #ifdef CONFIG_PM
 static int if_usb_suspend(struct usb_interface *intf, pm_message_t message)
 {
diff --git a/drivers/net/wireless/libertas/main.c b/drivers/net/wireless/libertas/main.c
index 4760b01..3835979 100644
--- a/drivers/net/wireless/libertas/main.c
+++ b/drivers/net/wireless/libertas/main.c
@@ -792,6 +792,280 @@ static int libertas_thread(void *data)
 }
 
 /**
+ *  @brief This function downloads firmware image, gets
+ *  HW spec from firmware and set basic parameters to
+ *  firmware.
+ *
+ *  @param priv    A pointer to wlan_private structure
+ *  @return 	   0 or -1
+ */
+static int wlan_setup_station_hw(wlan_private * priv)
+{
+	int ret = -1;
+	wlan_adapter *adapter = priv->adapter;
+
+	lbs_deb_enter(LBS_DEB_FW);
+
+	ret = priv->hw_prog_firmware(priv);
+
+	if (ret) {
+		lbs_deb_fw("bootloader in invalid state\n");
+		ret = -1;
+		goto done;
+	}
+
+	/*
+	 * Read MAC address from HW
+	 */
+	memset(adapter->current_addr, 0xff, ETH_ALEN);
+
+	ret = libertas_prepare_and_send_command(priv, CMD_GET_HW_SPEC,
+				    0, CMD_OPTION_WAITFORRSP, 0, NULL);
+
+	if (ret) {
+		ret = -1;
+		goto done;
+	}
+
+	libertas_set_mac_packet_filter(priv);
+
+	/* Get the supported Data rates */
+	ret = libertas_prepare_and_send_command(priv, CMD_802_11_DATA_RATE,
+				    CMD_ACT_GET_TX_RATE,
+				    CMD_OPTION_WAITFORRSP, 0, NULL);
+
+	if (ret) {
+		ret = -1;
+		goto done;
+	}
+
+	ret = 0;
+done:
+	lbs_deb_leave_args(LBS_DEB_FW, "ret %d", ret);
+	return ret;
+}
+
+static void command_timer_fn(unsigned long data);
+
+/**
+ *  This function handles the timeout of command sending.
+ *  It will re-send the same command again.
+ */
+static void command_timer_fn(unsigned long data)
+{
+	wlan_private *priv = (wlan_private *)data;
+	wlan_adapter *adapter = priv->adapter;
+	struct cmd_ctrl_node *ptempnode;
+	struct cmd_ds_command *cmd;
+	unsigned long flags;
+
+	ptempnode = adapter->cur_cmd;
+	if (ptempnode == NULL) {
+		lbs_deb_fw("ptempnode empty\n");
+		return;
+	}
+
+	cmd = (struct cmd_ds_command *)ptempnode->bufvirtualaddr;
+	if (!cmd) {
+		lbs_deb_fw("cmd is NULL\n");
+		return;
+	}
+
+	lbs_deb_fw("command_timer_fn fired, cmd %x\n", cmd->command);
+
+	if (!adapter->fw_ready)
+		return;
+
+	spin_lock_irqsave(&adapter->driver_lock, flags);
+	adapter->cur_cmd = NULL;
+	spin_unlock_irqrestore(&adapter->driver_lock, flags);
+
+	lbs_deb_fw("re-sending same command because of timeout\n");
+	libertas_queue_cmd(adapter, ptempnode, 0);
+
+	wake_up_interruptible(&priv->waitq);
+
+	return;
+}
+
+static int wlan_allocate_adapter(wlan_private * priv)
+{
+	size_t bufsize;
+	wlan_adapter *adapter = priv->adapter;
+
+	/* Allocate buffer to store the BSSID list */
+	bufsize = MAX_NETWORK_COUNT * sizeof(struct bss_descriptor);
+	adapter->networks = kzalloc(bufsize, GFP_KERNEL);
+	if (!adapter->networks) {
+		lbs_pr_err("Out of memory allocating beacons\n");
+		libertas_free_adapter(priv);
+		return -ENOMEM;
+	}
+
+	/* Allocate the command buffers */
+	libertas_allocate_cmd_buffer(priv);
+
+	memset(&adapter->libertas_ps_confirm_sleep, 0, sizeof(struct PS_CMD_ConfirmSleep));
+	adapter->libertas_ps_confirm_sleep.seqnum = cpu_to_le16(++adapter->seqnum);
+	adapter->libertas_ps_confirm_sleep.command =
+	    cpu_to_le16(CMD_802_11_PS_MODE);
+	adapter->libertas_ps_confirm_sleep.size =
+	    cpu_to_le16(sizeof(struct PS_CMD_ConfirmSleep));
+	adapter->libertas_ps_confirm_sleep.result = 0;
+	adapter->libertas_ps_confirm_sleep.action =
+	    cpu_to_le16(CMD_SUBCMD_SLEEP_CONFIRMED);
+
+	return 0;
+}
+
+static void wlan_init_adapter(wlan_private * priv)
+{
+	wlan_adapter *adapter = priv->adapter;
+	int i;
+
+	adapter->scanprobes = 0;
+
+	adapter->bcn_avg_factor = DEFAULT_BCN_AVG_FACTOR;
+	adapter->data_avg_factor = DEFAULT_DATA_AVG_FACTOR;
+
+	/* ATIM params */
+	adapter->atimwindow = 0;
+
+	adapter->connect_status = LIBERTAS_DISCONNECTED;
+	memset(adapter->current_addr, 0xff, ETH_ALEN);
+
+	/* scan type */
+	adapter->scantype = CMD_SCAN_TYPE_ACTIVE;
+
+	/* scan mode */
+	adapter->scanmode = CMD_BSS_TYPE_ANY;
+
+	/* 802.11 specific */
+	adapter->secinfo.wep_enabled = 0;
+	for (i = 0; i < sizeof(adapter->wep_keys) / sizeof(adapter->wep_keys[0]);
+	     i++)
+		memset(&adapter->wep_keys[i], 0, sizeof(struct enc_key));
+	adapter->wep_tx_keyidx = 0;
+	adapter->secinfo.auth_mode = IW_AUTH_ALG_OPEN_SYSTEM;
+	adapter->mode = IW_MODE_INFRA;
+
+	adapter->pending_assoc_req = NULL;
+	adapter->in_progress_assoc_req = NULL;
+
+	/* Initialize scan result lists */
+	INIT_LIST_HEAD(&adapter->network_free_list);
+	INIT_LIST_HEAD(&adapter->network_list);
+	for (i = 0; i < MAX_NETWORK_COUNT; i++) {
+		list_add_tail(&adapter->networks[i].list,
+			      &adapter->network_free_list);
+	}
+
+	mutex_init(&adapter->lock);
+
+	adapter->prescan = 1;
+
+	memset(&adapter->curbssparams, 0, sizeof(adapter->curbssparams));
+	adapter->curbssparams.channel = DEFAULT_AD_HOC_CHANNEL;
+
+	/* PnP and power profile */
+	adapter->surpriseremoved = 0;
+
+	adapter->currentpacketfilter =
+	    CMD_ACT_MAC_RX_ON | CMD_ACT_MAC_TX_ON;
+
+	adapter->radioon = RADIO_ON;
+	adapter->txantenna = RF_ANTENNA_2;
+	adapter->rxantenna = RF_ANTENNA_AUTO;
+
+	adapter->auto_rate = 1;
+	adapter->cur_rate = 0;
+	adapter->adhoc_grate_enabled = 0;
+
+	adapter->beaconperiod = MRVDRV_BEACON_INTERVAL;
+
+	// set default capabilities
+	adapter->capability = WLAN_CAPABILITY_SHORT_PREAMBLE;
+
+	adapter->psmode = WLAN802_11POWERMODECAM;
+	adapter->multipledtim = MRVDRV_DEFAULT_MULTIPLE_DTIM;
+
+	adapter->listeninterval = MRVDRV_DEFAULT_LISTEN_INTERVAL;
+
+	adapter->psstate = PS_STATE_FULL_POWER;
+	adapter->needtowakeup = 0;
+	adapter->locallisteninterval = 0;	/* default value in firmware will be used */
+
+	adapter->intcounter = 0;
+
+	adapter->currenttxskb = NULL;
+	adapter->pkttxctrl = 0;
+
+	memset(&adapter->tx_queue_ps, 0, NR_TX_QUEUE*sizeof(struct sk_buff*));
+	adapter->tx_queue_idx = 0;
+	spin_lock_init(&adapter->txqueue_lock);
+
+	return;
+}
+
+void libertas_free_adapter(wlan_private * priv)
+{
+	wlan_adapter *adapter = priv->adapter;
+
+	if (!adapter) {
+		lbs_deb_fw("why double free adapter?\n");
+		return;
+	}
+
+	lbs_deb_fw("free command buffer\n");
+	libertas_free_cmd_buffer(priv);
+
+	lbs_deb_fw("free command_timer\n");
+	del_timer(&adapter->command_timer);
+
+	lbs_deb_fw("free scan results table\n");
+	kfree(adapter->networks);
+	adapter->networks = NULL;
+
+	/* Free the adapter object itself */
+	lbs_deb_fw("free adapter\n");
+	kfree(adapter);
+	priv->adapter = NULL;
+}
+
+int libertas_init_fw(wlan_private * priv)
+{
+	int ret = -1;
+	wlan_adapter *adapter = priv->adapter;
+
+	lbs_deb_enter(LBS_DEB_FW);
+
+	/* Allocate adapter structure */
+	if ((ret = wlan_allocate_adapter(priv)) != 0)
+		goto done;
+
+	/* init adapter structure */
+	wlan_init_adapter(priv);
+
+	/* init timer etc. */
+	setup_timer(&adapter->command_timer, command_timer_fn,
+			(unsigned long)priv);
+
+	/* download fimrware etc. */
+	if ((ret = wlan_setup_station_hw(priv)) != 0) {
+		del_timer_sync(&adapter->command_timer);
+		goto done;
+	}
+
+	/* init 802.11d */
+	libertas_init_11d(priv);
+
+	ret = 0;
+done:
+	lbs_deb_leave_args(LBS_DEB_FW, "ret %d", ret);
+	return ret;
+}
+
+/**
  * @brief This function adds the card. it will probe the
  * card, allocate the wlan_priv and initialize the device.
  *
@@ -862,7 +1136,7 @@ done:
 }
 EXPORT_SYMBOL_GPL(libertas_add_card);
 
-int libertas_activate_card(wlan_private *priv, char *fw_name)
+int libertas_activate_card(wlan_private *priv)
 {
 	struct net_device *dev = priv->dev;
 	int ret = -1;
@@ -893,7 +1167,7 @@ int libertas_activate_card(wlan_private *priv, char *fw_name)
 	}
 
 	/* init FW and HW */
-	if (fw_name && libertas_init_fw(priv, fw_name)) {
+	if (libertas_init_fw(priv)) {
 		lbs_pr_err("firmware init failed\n");
 		goto err_registerdev;
 	}
-- 
1.5.2


_______________________________________________
libertas-dev mailing list
libertas-dev@lists.infradead.org
http://lists.infradead.org/mailman/listinfo/libertas-dev




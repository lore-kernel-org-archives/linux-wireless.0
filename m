Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s131.mittwaldmedien.de ([62.216.178.31]:9087 "EHLO
	s131.mittwaldmedien.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751431AbXJIMPM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Oct 2007 08:15:12 -0400
From: Holger Schurig <hs4233@mail.mn-solutions.de>
To: linux-wireless@vger.kernel.org
Subject: Re: [PATCH, take 2] libertas: clean up scan debug messages
Date: Tue, 9 Oct 2007 14:15:19 +0200
Cc: libertas-dev@lists.infradead.org, Dan Williams <dcbw@redhat.com>
References: <200710091344.31107.hs4233@mail.mn-solutions.de>
In-Reply-To: <200710091344.31107.hs4233@mail.mn-solutions.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200710091415.19171.hs4233@mail.mn-solutions.de> (sfid-20071009_131518_656053_D232C441)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

* make scan debug output cleaner
* change some LBS_DEB_ASSOC messages to LBS_DEB_SCAN, which is more correct
* move helper functions together
* print function return value in the tracing code at one central location

Signed-off-by: Holger Schurig <hs4233@mail.mn-solutions.de>
---

Index: libertas-2.6/drivers/net/wireless/libertas/scan.c
===================================================================
--- libertas-2.6.orig/drivers/net/wireless/libertas/scan.c	2007-10-09 14:38:35.000000000 +0200
+++ libertas-2.6/drivers/net/wireless/libertas/scan.c	2007-10-09 15:12:49.000000000 +0200
@@ -65,6 +65,15 @@
 static const u8 zeromac[ETH_ALEN] = { 0x00, 0x00, 0x00, 0x00, 0x00, 0x00 };
 static const u8 bcastmac[ETH_ALEN] = { 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF };
 
+
+
+
+/*********************************************************************/
+/*                                                                   */
+/*  Misc helper functions                                            */
+/*                                                                   */
+/*********************************************************************/
+
 static inline void clear_bss_descriptor (struct bss_descriptor * bss)
 {
 	/* Don't blow away ->list, just BSS data */
@@ -165,7 +174,7 @@ static int is_network_compatible(wlan_ad
 {
 	int matched = 0;
 
-	lbs_deb_enter(LBS_DEB_ASSOC);
+	lbs_deb_enter(LBS_DEB_SCAN);
 
 	if (bss->mode != mode)
 		goto done;
@@ -214,13 +223,41 @@ static int is_network_compatible(wlan_ad
 	       (bss->capability & WLAN_CAPABILITY_PRIVACY));
 
 done:
-	lbs_deb_leave(LBS_DEB_SCAN);
+	lbs_deb_leave_args(LBS_DEB_SCAN, "matched: %d", matched);
 	return matched;
 }
 
 /**
+ *  @brief Compare two SSIDs
+ *
+ *  @param ssid1    A pointer to ssid to compare
+ *  @param ssid2    A pointer to ssid to compare
+ *
+ *  @return         0--ssid is same, otherwise is different
+ */
+int libertas_ssid_cmp(u8 *ssid1, u8 ssid1_len, u8 *ssid2, u8 ssid2_len)
+{
+	if (ssid1_len != ssid2_len)
+		return -1;
+
+	return memcmp(ssid1, ssid2, ssid1_len);
+}
+
+
+
+
+/*********************************************************************/
+/*                                                                   */
+/*  Main scanning support                                            */
+/*                                                                   */
+/*********************************************************************/
+
+
+/**
  *  @brief Create a channel list for the driver to scan based on region info
  *
+ *  Only used from wlan_scan_setup_scan_config()
+ *
  *  Use the driver region/band information to construct a comprehensive list
  *    of channels to scan.  This routine is used for any scan that is not
  *    provided a specific channel list to scan.
@@ -248,6 +285,8 @@ static void wlan_scan_create_channel_lis
 	int nextchan;
 	u8 scantype;
 
+	lbs_deb_enter_args(LBS_DEB_SCAN, "filteredscan %d", filteredscan);
+
 	chanidx = 0;
 
 	/* Set the default scan type to the user specified type, will later
@@ -384,6 +423,8 @@ wlan_scan_setup_scan_config(wlan_private
 	int channel;
 	int radiotype;
 
+	lbs_deb_enter(LBS_DEB_SCAN);
+
 	pscancfgout = kzalloc(MAX_SCAN_CFG_ALLOC, GFP_KERNEL);
 	if (pscancfgout == NULL)
 		goto out;
@@ -481,13 +522,12 @@ wlan_scan_setup_scan_config(wlan_private
 
 	if (!puserscanin || !puserscanin->chanlist[0].channumber) {
 		/* Create a default channel scan list */
-		lbs_deb_scan("Scan: Creating full region channel list\n");
+		lbs_deb_scan("creating full region channel list\n");
 		wlan_scan_create_channel_list(priv, pscanchanlist,
 					      *pfilteredscan);
 		goto out;
 	}
 
-	lbs_deb_scan("Scan: Using supplied channel list\n");
 	for (chanidx = 0;
 	     chanidx < WLAN_IOCTL_USER_SCAN_CHAN_MAX
 	     && puserscanin->chanlist[chanidx].channumber; chanidx++) {
@@ -529,7 +569,7 @@ wlan_scan_setup_scan_config(wlan_private
 	    (puserscanin->chanlist[0].channumber ==
 			       priv->adapter->curbssparams.channel)) {
 		*pscancurrentonly = 1;
-		lbs_deb_scan("Scan: Scanning current channel only");
+		lbs_deb_scan("scanning current channel only");
 	}
 
 out:
@@ -539,6 +579,8 @@ out:
 /**
  *  @brief Construct and send multiple scan config commands to the firmware
  *
+ *  Only used from wlan_scan_networks()
+ *
  *  Previous routines have created a wlan_scan_cmd_config with any requested
  *   TLVs.  This function splits the channel TLV into maxchanperscan lists
  *   and sends the portion of the channel TLV along with the other TLVs
@@ -576,12 +618,14 @@ static int wlan_scan_channel_list(wlan_p
 	int scanned = 0;
 	union iwreq_data wrqu;
 
-	lbs_deb_enter(LBS_DEB_ASSOC);
+	lbs_deb_enter_args(LBS_DEB_SCAN, "maxchanperscan %d, filteredscan %d, "
+		"full_scan %d", maxchanperscan, filteredscan, full_scan);
 
 	if (!pscancfgout || !pchantlvout || !pscanchanlist) {
-		lbs_deb_scan("Scan: Null detect: %p, %p, %p\n",
-		       pscancfgout, pchantlvout, pscanchanlist);
-		return -1;
+		lbs_deb_scan("pscancfgout, pchantlvout or "
+			"pscanchanlist is NULL\n");
+		ret = -1;
+		goto out;
 	}
 
 	pchantlvout->header.type = cpu_to_le16(TLV_TYPE_CHANLIST);
@@ -613,9 +657,10 @@ static int wlan_scan_channel_list(wlan_p
 		while (tlvidx < maxchanperscan && ptmpchan->channumber
 		       && !doneearly && scanned < 2) {
 
-			lbs_deb_scan("Scan: Chan(%3d), Radio(%d), mode(%d,%d), "
-			             "Dur(%d)\n",
-			             ptmpchan->channumber, ptmpchan->radiotype,
+			lbs_deb_scan("channel %d, radio %d, passive %d, "
+				"dischanflt %d, maxscantime %d\n",
+				ptmpchan->channumber,
+				ptmpchan->radiotype,
 			             ptmpchan->chanscanmode.passivescan,
 			             ptmpchan->chanscanmode.disablechanfilt,
 			             ptmpchan->maxscantime);
@@ -700,20 +745,25 @@ done:
 		wireless_send_event(priv->dev, SIOCGIWSCAN, &wrqu, NULL);
 	}
 
+out:
 	lbs_deb_leave_args(LBS_DEB_SCAN, "ret %d", ret);
 	return ret;
 }
 
-static void
-clear_selected_scan_list_entries(wlan_adapter * adapter,
-                                 const struct wlan_ioctl_user_scan_cfg * scan_cfg)
+/*
+ * Only used from wlan_scan_networks()
+*/
+static void clear_selected_scan_list_entries(wlan_adapter *adapter,
+	const struct wlan_ioctl_user_scan_cfg *scan_cfg)
 {
-	struct bss_descriptor * bss;
-	struct bss_descriptor * safe;
+	struct bss_descriptor *bss;
+	struct bss_descriptor *safe;
 	u32 clear_ssid_flag = 0, clear_bssid_flag = 0;
 
+	lbs_deb_enter(LBS_DEB_SCAN);
+
 	if (!scan_cfg)
-		return;
+		goto out;
 
 	if (scan_cfg->clear_ssid && scan_cfg->ssid_len)
 		clear_ssid_flag = 1;
@@ -725,7 +775,7 @@ clear_selected_scan_list_entries(wlan_ad
 	}
 
 	if (!clear_ssid_flag && !clear_bssid_flag)
-		return;
+		goto out;
 
 	mutex_lock(&adapter->lock);
 	list_for_each_entry_safe (bss, safe, &adapter->network_list, list) {
@@ -748,12 +798,16 @@ clear_selected_scan_list_entries(wlan_ad
 		}
 	}
 	mutex_unlock(&adapter->lock);
+out:
+	lbs_deb_leave(LBS_DEB_SCAN);
 }
 
 
 /**
  *  @brief Internal function used to start a scan based on an input config
  *
+ *  Also used from debugfs
+ *
  *  Use the input user scan configuration information when provided in
  *    order to send the appropriate scan commands to firmware to populate or
  *    update the internal driver scan table
@@ -761,6 +815,7 @@ clear_selected_scan_list_entries(wlan_ad
  *  @param priv          A pointer to wlan_private structure
  *  @param puserscanin   Pointer to the input configuration for the requested
  *                       scan.
+ *  @param full_scan     ???
  *
  *  @return              0 or < 0 if error
  */
@@ -781,7 +836,7 @@ int wlan_scan_networks(wlan_private * pr
 	int i = 0;
 #endif
 
-	lbs_deb_enter(LBS_DEB_SCAN);
+	lbs_deb_enter_args(LBS_DEB_SCAN, "full_scan %d", full_scan);
 
 	/* Cancel any partial outstanding partial scans if this scan
 	 * is a full scan.
@@ -832,8 +887,9 @@ int wlan_scan_networks(wlan_private * pr
 #ifdef CONFIG_LIBERTAS_DEBUG
 	/* Dump the scan table */
 	mutex_lock(&adapter->lock);
+	lbs_deb_scan("The scan table contains:\n");
 	list_for_each_entry (iter_bss, &adapter->network_list, list) {
-		lbs_deb_scan("Scan:(%02d) " MAC_FMT ", RSSI[%03d], SSID[%s]\n",
+		lbs_deb_scan("scan %02d, " MAC_FMT ", RSSI, %d, SSID '%s'\n",
 		       i++, MAC_ARG(iter_bss->bssid), (s32) iter_bss->rssi,
 		       escape_essid(iter_bss->ssid, iter_bss->ssid_len));
 	}
@@ -884,7 +940,7 @@ static int libertas_process_bss(struct b
 	u16 beaconsize = 0;
 	int ret;
 
-	lbs_deb_enter(LBS_DEB_ASSOC);
+	lbs_deb_enter(LBS_DEB_SCAN);
 
 	if (*bytesleft >= sizeof(beaconsize)) {
 		/* Extract & convert beacon size from the command buffer */
@@ -896,7 +952,8 @@ static int libertas_process_bss(struct b
 	if (beaconsize == 0 || beaconsize > *bytesleft) {
 		*pbeaconinfo += *bytesleft;
 		*bytesleft = 0;
-		return -1;
+		ret = -1;
+		goto done;
 	}
 
 	/* Initialize the current working beacon pointer for this BSS iteration */
@@ -913,7 +970,8 @@ static int libertas_process_bss(struct b
 
 	if ((end - pos) < 12) {
 		lbs_deb_scan("process_bss: Not enough bytes left\n");
-		return -1;
+		ret = -1;
+		goto done;
 	}
 
 	/*
@@ -1089,38 +1147,26 @@ done:
 }
 
 /**
- *  @brief Compare two SSIDs
- *
- *  @param ssid1    A pointer to ssid to compare
- *  @param ssid2    A pointer to ssid to compare
- *
- *  @return         0--ssid is same, otherwise is different
- */
-int libertas_ssid_cmp(u8 *ssid1, u8 ssid1_len, u8 *ssid2, u8 ssid2_len)
-{
-	if (ssid1_len != ssid2_len)
-		return -1;
-
-	return memcmp(ssid1, ssid2, ssid1_len);
-}
-
-/**
  *  @brief This function finds a specific compatible BSSID in the scan list
  *
+ *  Used in association code
+ *
  *  @param adapter  A pointer to wlan_adapter
  *  @param bssid    BSSID to find in the scan list
  *  @param mode     Network mode: Infrastructure or IBSS
  *
  *  @return         index in BSSID list, or error return code (< 0)
  */
-struct bss_descriptor * libertas_find_bssid_in_list(wlan_adapter * adapter,
+struct bss_descriptor *libertas_find_bssid_in_list(wlan_adapter * adapter,
 		u8 * bssid, u8 mode)
 {
 	struct bss_descriptor * iter_bss;
 	struct bss_descriptor * found_bss = NULL;
 
+	lbs_deb_enter(LBS_DEB_SCAN);
+
 	if (!bssid)
-		return NULL;
+		goto out;
 
 	lbs_deb_hex(LBS_DEB_SCAN, "looking for",
 		bssid, ETH_ALEN);
@@ -1147,12 +1193,16 @@ struct bss_descriptor * libertas_find_bs
 	}
 	mutex_unlock(&adapter->lock);
 
+out:
+	lbs_deb_leave_args(LBS_DEB_SCAN, "found_bss %p", found_bss);
 	return found_bss;
 }
 
 /**
  *  @brief This function finds ssid in ssid list.
  *
+ *  Used in association code
+ *
  *  @param adapter  A pointer to wlan_adapter
  *  @param ssid     SSID to find in the list
  *  @param bssid    BSSID to qualify the SSID selection (if provided)
@@ -1169,6 +1219,8 @@ struct bss_descriptor * libertas_find_ss
 	struct bss_descriptor * found_bss = NULL;
 	struct bss_descriptor * tmp_oldest = NULL;
 
+	lbs_deb_enter(LBS_DEB_SCAN);
+
 	mutex_lock(&adapter->lock);
 
 	list_for_each_entry (iter_bss, &adapter->network_list, list) {
@@ -1213,6 +1265,7 @@ struct bss_descriptor * libertas_find_ss
 
 out:
 	mutex_unlock(&adapter->lock);
+	lbs_deb_leave_args(LBS_DEB_SCAN, "found_bss %p", found_bss);
 	return found_bss;
 }
 
@@ -1233,6 +1286,8 @@ static struct bss_descriptor * libertas_
 	struct bss_descriptor * iter_bss;
 	struct bss_descriptor * best_bss = NULL;
 
+	lbs_deb_enter(LBS_DEB_SCAN);
+
 	mutex_lock(&adapter->lock);
 
 	list_for_each_entry (iter_bss, &adapter->network_list, list) {
@@ -1257,12 +1312,15 @@ static struct bss_descriptor * libertas_
 	}
 
 	mutex_unlock(&adapter->lock);
+	lbs_deb_leave_args(LBS_DEB_SCAN, "best_bss %p", best_bss);
 	return best_bss;
 }
 
 /**
  *  @brief Find the AP with specific ssid in the scan list
  *
+ *  Used from association worker.
+ *
  *  @param priv         A pointer to wlan_private structure
  *  @param pSSID        A pointer to AP's ssid
  *
@@ -1275,11 +1333,11 @@ int libertas_find_best_network_ssid(wlan
 	int ret = -1;
 	struct bss_descriptor * found;
 
-	lbs_deb_enter(LBS_DEB_ASSOC);
+	lbs_deb_enter(LBS_DEB_SCAN);
 
 	wlan_scan_networks(priv, NULL, 1);
 	if (adapter->surpriseremoved)
-		return -1;
+		goto out;
 
 	wait_event_interruptible(adapter->cmd_pending, !adapter->nr_cmd_pending);
 
@@ -1291,6 +1349,7 @@ int libertas_find_best_network_ssid(wlan
 		ret = 0;
 	}
 
+out:
 	lbs_deb_leave_args(LBS_DEB_SCAN, "ret %d", ret);
 	return ret;
 }
@@ -1325,10 +1384,17 @@ int libertas_set_scan(struct net_device 
 	return 0;
 }
 
+
 /**
  *  @brief Send a scan command for all available channels filtered on a spec
  *
+ *  Used in association code and from debugfs
+ *
  *  @param priv             A pointer to wlan_private structure
+ *  @param ssid             A pointer to the SSID to scan for
+ *  @param ssid_len         Length of the SSID
+ *  @param clear_ssid       Should existing scan results with this SSID
+ *                          be cleared?
  *  @param prequestedssid   A pointer to AP's ssid
  *  @param keeppreviousscan Flag used to save/clear scan table before scan
  *
@@ -1341,7 +1407,8 @@ int libertas_send_specific_ssid_scan(wla
 	struct wlan_ioctl_user_scan_cfg scancfg;
 	int ret = 0;
 
-	lbs_deb_enter(LBS_DEB_ASSOC);
+	lbs_deb_enter_args(LBS_DEB_SCAN, "SSID '%s', clear %d",
+		escape_essid(ssid, ssid_len), clear_ssid);
 
 	if (!ssid_len)
 		goto out;
@@ -1352,15 +1419,26 @@ int libertas_send_specific_ssid_scan(wla
 	scancfg.clear_ssid = clear_ssid;
 
 	wlan_scan_networks(priv, &scancfg, 1);
-	if (adapter->surpriseremoved)
-		return -1;
+	if (adapter->surpriseremoved) {
+		ret = -1;
+		goto out;
+	}
 	wait_event_interruptible(adapter->cmd_pending, !adapter->nr_cmd_pending);
 
 out:
-	lbs_deb_leave(LBS_DEB_ASSOC);
+	lbs_deb_leave_args(LBS_DEB_SCAN, "ret %d", ret);
 	return ret;
 }
 
+
+
+
+/*********************************************************************/
+/*                                                                   */
+/*  Support for Wireless Extensions                                  */
+/*                                                                   */
+/*********************************************************************/
+
 #define MAX_CUSTOM_LEN 64
 
 static inline char *libertas_translate_scan(wlan_private *priv,
@@ -1377,10 +1455,13 @@ static inline char *libertas_translate_s
 #define RSSI_DIFF    ((u8)(PERFECT_RSSI - WORST_RSSI))
 	u8 rssi;
 
+	lbs_deb_enter(LBS_DEB_SCAN);
+
 	cfp = libertas_find_cfp_by_band_and_channel(adapter, 0, bss->channel);
 	if (!cfp) {
 		lbs_deb_scan("Invalid channel number %d\n", bss->channel);
-		return NULL;
+		start = NULL;
+		goto out;
 	}
 
 	/* First entry *MUST* be the AP BSSID */
@@ -1508,11 +1589,13 @@ static inline char *libertas_translate_s
 			start = iwe_stream_add_point(start, stop, &iwe, custom);
 	}
 
+out:
+	lbs_deb_leave_args(LBS_DEB_SCAN, "start %p", start);
 	return start;
 }
 
 /**
- *  @brief  Retrieve the scan table entries via wireless tools IOCTL call
+ *  @brief  Handle Retrieve scan table ioctl
  *
  *  @param dev          A pointer to net_device structure
  *  @param info         A pointer to iw_request_info structure
@@ -1533,7 +1616,7 @@ int libertas_get_scan(struct net_device 
 	struct bss_descriptor * iter_bss;
 	struct bss_descriptor * safe;
 
-	lbs_deb_enter(LBS_DEB_ASSOC);
+	lbs_deb_enter(LBS_DEB_SCAN);
 
 	/* Update RSSI if current BSS is a locally created ad-hoc BSS */
 	if ((adapter->mode == IW_MODE_ADHOC) && adapter->adhoccreate) {
@@ -1575,19 +1658,27 @@ int libertas_get_scan(struct net_device 
 	dwrq->length = (ev - extra);
 	dwrq->flags = 0;
 
-	lbs_deb_leave(LBS_DEB_ASSOC);
+	lbs_deb_leave_args(LBS_DEB_SCAN, "ret %d", err);
 	return err;
 }
 
+
+
+
+/*********************************************************************/
+/*                                                                   */
+/*  Command execution                                                */
+/*                                                                   */
+/*********************************************************************/
+
+
 /**
  *  @brief Prepare a scan command to be sent to the firmware
  *
- *  Use the wlan_scan_cmd_config sent to the command processing module in
- *   the libertas_prepare_and_send_command to configure a cmd_ds_802_11_scan command
- *   struct to send to firmware.
+ *  Called from libertas_prepare_and_send_command() in cmd.c
  *
- *  The fixed fields specifying the BSS type and BSSID filters as well as a
- *   variable number/length of TLVs are sent in the command to firmware.
+ *  Sends a fixed lenght data part (specifying the BSS type and BSSID filters)
+ *  as well as a variable number/length of TLVs to the firmware.
  *
  *  @param priv       A pointer to wlan_private structure
  *  @param cmd        A pointer to cmd_ds_command structure to be sent to
@@ -1596,18 +1687,14 @@ int libertas_get_scan(struct net_device 
  *                    to set the fields/TLVs for the command sent to firmware
  *
  *  @return           0 or -1
- *
- *  @sa wlan_scan_create_channel_list
  */
 int libertas_cmd_80211_scan(wlan_private * priv,
 			 struct cmd_ds_command *cmd, void *pdata_buf)
 {
 	struct cmd_ds_802_11_scan *pscan = &cmd->params.scan;
-	struct wlan_scan_cmd_config *pscancfg;
-
-	lbs_deb_enter(LBS_DEB_ASSOC);
+	struct wlan_scan_cmd_config *pscancfg = pdata_buf;
 
-	pscancfg = pdata_buf;
+	lbs_deb_enter(LBS_DEB_SCAN);
 
 	/* Set fixed field variables in scan command */
 	pscan->bsstype = pscancfg->bsstype;
@@ -1620,11 +1707,11 @@ int libertas_cmd_80211_scan(wlan_private
 	cmd->size = cpu_to_le16(sizeof(pscan->bsstype) + ETH_ALEN
 				+ pscancfg->tlvbufferlen + S_DS_GEN);
 
-	lbs_deb_scan("SCAN_CMD: command=%x, size=%x, seqnum=%x\n",
+	lbs_deb_scan("SCAN_CMD: command 0x%04x, size %d, seqnum %d\n",
 		     le16_to_cpu(cmd->command), le16_to_cpu(cmd->size),
 		     le16_to_cpu(cmd->seqnum));
 
-	lbs_deb_leave(LBS_DEB_ASSOC);
+	lbs_deb_leave(LBS_DEB_SCAN);
 	return 0;
 }
 
@@ -1643,6 +1730,8 @@ static inline int is_same_network(struct
 /**
  *  @brief This function handles the command response of scan
  *
+ *  Called from handle_cmd_response() in cmdrespc.
+ *
  *   The response buffer for the scan command has the following
  *      memory layout:
  *
@@ -1677,7 +1766,7 @@ int libertas_ret_80211_scan(wlan_private
 	int tlvbufsize;
 	int ret;
 
-	lbs_deb_enter(LBS_DEB_ASSOC);
+	lbs_deb_enter(LBS_DEB_SCAN);
 
 	/* Prune old entries from scan table */
 	list_for_each_entry_safe (iter_bss, safe, &adapter->network_list, list) {
Index: libertas-2.6/drivers/net/wireless/libertas/join.c
===================================================================
--- libertas-2.6.orig/drivers/net/wireless/libertas/join.c	2007-10-09 14:38:35.000000000 +0200
+++ libertas-2.6/drivers/net/wireless/libertas/join.c	2007-10-09 14:39:39.000000000 +0200
@@ -797,8 +797,6 @@ int libertas_ret_80211_associate(wlan_pr
 		netif_wake_queue(priv->mesh_dev);
 	}
 
-	lbs_deb_join("ASSOC_RESP: Associated \n");
-
 	memcpy(wrqu.ap_addr.sa_data, adapter->curbssparams.bssid, ETH_ALEN);
 	wrqu.ap_addr.sa_family = ARPHRD_ETHER;
 	wireless_send_event(priv->dev, SIOCGIWAP, &wrqu, NULL);

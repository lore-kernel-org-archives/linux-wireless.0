Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s131.mittwaldmedien.de ([62.216.178.31]:18020 "EHLO
	s131.mittwaldmedien.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753974AbYBZPZA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Feb 2008 10:25:00 -0500
From: Holger Schurig <hs4233@mail.mn-solutions.de>
To: libertas-dev@lists.infradead.org, linux-wireless@vger.kernel.org
Subject: [PATCH, take 2] libertas: implement SSID scanning for SIOCSIWSCAN
Date: Tue, 26 Feb 2008 15:22:05 +0100
Cc: Dan Williams <dcbw@redhat.com>,
	"John W. Linville" <linville@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200802261522.05676.hs4233@mail.mn-solutions.de> (sfid-20080226_152507_153511_B6B0EBE2)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

libertas: implement SSID scanning for SIOCSIWSCAN

After my bit scan re-writing the SIOCSIWSCAN wext ioctl no longer supported
scanning for a specific SSID. However, wpa_supplicant is a possible user of
this ioctl, so here is code that add's this.

While passing, removed even more of the debugfs-based scanning. You can (and
should) the SIOCSIWSCAN to ask for scans, so there is no need for
proprietary interfaces for scanning. And, besides, the scan result couldn't
be used further, e.g. not for associating.

Signed-off-by: Holger Schurig <hs4233@mail.mn-solutions.de>

---

This code change allowed to association to an AP with a hidden SSID
like this:

$ ifconfig eth1 up
$ cat wpa_supplicant.conf
ctrl_interface=/var/run/wpa_supplicant
network={
        ssid="MNHS"
        scan_ssid=1
        key_mgmt=NONE
        wep_key0="54321"
        wep_tx_keyidx=0
}
$ wpa_supplicant -Dwext -ieth1 -cwpa_supplicant.conf

Index: wireless-testing/drivers/net/wireless/libertas/dev.h
===================================================================
--- wireless-testing.orig/drivers/net/wireless/libertas/dev.h	2008-02-26 15:11:27.000000000 +0100
+++ wireless-testing/drivers/net/wireless/libertas/dev.h	2008-02-26 15:11:29.000000000 +0100
@@ -149,6 +149,8 @@ struct lbs_private {
 	struct work_struct sync_channel;
 	/* remember which channel was scanned last, != 0 if currently scanning */
 	int scan_channel;
+	u8 scan_ssid[IW_ESSID_MAX_SIZE + 1];
+	u8 scan_ssid_len;
 
 	/** Hardware access */
 	int (*hw_host_to_card) (struct lbs_private *priv, u8 type, u8 *payload, u16 nb);
Index: wireless-testing/drivers/net/wireless/libertas/scan.h
===================================================================
--- wireless-testing.orig/drivers/net/wireless/libertas/scan.h	2008-02-26 15:11:27.000000000 +0100
+++ wireless-testing/drivers/net/wireless/libertas/scan.h	2008-02-26 15:11:29.000000000 +0100
@@ -12,8 +12,6 @@
 
 /**
  *  @brief Maximum number of channels that can be sent in a setuserscan ioctl
- *
- *  @sa lbs_ioctl_user_scan_cfg
  */
 #define LBS_IOCTL_USER_SCAN_CHAN_MAX  50
 
@@ -68,60 +66,6 @@ struct lbs_scan_cmd_config {
 };
 
 /**
- *  @brief IOCTL channel sub-structure sent in lbs_ioctl_user_scan_cfg
- *
- *  Multiple instances of this structure are included in the IOCTL command
- *   to configure a instance of a scan on the specific channel.
- */
-struct lbs_ioctl_user_scan_chan {
-	u8 channumber;		//!< channel Number to scan
-	u8 radiotype;		//!< Radio type: 'B/G' band = 0, 'A' band = 1
-	u8 scantype;		//!< Scan type: Active = 0, Passive = 1
-	u16 scantime;		//!< Scan duration in milliseconds; if 0 default used
-};
-
-/**
- *  @brief IOCTL input structure to configure an immediate scan cmd to firmware
- *
- *  Used in the setuserscan (LBS_SET_USER_SCAN) private ioctl.  Specifies
- *   a number of parameters to be used in general for the scan as well
- *   as a channel list (lbs_ioctl_user_scan_chan) for each scan period
- *   desired.
- *
- *  @sa lbs_set_user_scan_ioctl
- */
-struct lbs_ioctl_user_scan_cfg {
-    /**
-     *  @brief BSS type to be sent in the firmware command
-     *
-     *  Field can be used to restrict the types of networks returned in the
-     *    scan.  valid settings are:
-     *
-     *   - LBS_SCAN_BSS_TYPE_BSS  (infrastructure)
-     *   - LBS_SCAN_BSS_TYPE_IBSS (adhoc)
-     *   - LBS_SCAN_BSS_TYPE_ANY  (unrestricted, adhoc and infrastructure)
-     */
-	u8 bsstype;
-
-	/**
-	 *  @brief BSSID filter sent in the firmware command to limit the results
-	 */
-	u8 bssid[ETH_ALEN];
-
-	/* Clear existing scan results matching this BSSID */
-	u8 clear_bssid;
-
-	/**
-	 *  @brief SSID filter sent in the firmware command to limit the results
-	 */
-	char ssid[IW_ESSID_MAX_SIZE];
-	u8 ssid_len;
-
-	/* Clear existing scan results matching this SSID */
-	u8 clear_ssid;
-};
-
-/**
  *  @brief Structure used to store information for each beacon/probe response
  */
 struct bss_descriptor {
@@ -177,7 +121,7 @@ int lbs_find_best_network_ssid(struct lb
 			u8 *out_ssid_len, u8 preferred_mode, u8 *out_mode);
 
 int lbs_send_specific_ssid_scan(struct lbs_private *priv, u8 *ssid,
-				u8 ssid_len, u8 clear_ssid);
+				u8 ssid_len);
 
 int lbs_cmd_80211_scan(struct lbs_private *priv,
 				struct cmd_ds_command *cmd,
@@ -186,19 +130,10 @@ int lbs_cmd_80211_scan(struct lbs_privat
 int lbs_ret_80211_scan(struct lbs_private *priv,
 				struct cmd_ds_command *resp);
 
-int lbs_scan_networks(struct lbs_private *priv,
-	const struct lbs_ioctl_user_scan_cfg *puserscanin,
-                int full_scan);
-
-struct ifreq;
-
-struct iw_point;
-struct iw_param;
-struct iw_request_info;
 int lbs_get_scan(struct net_device *dev, struct iw_request_info *info,
 			 struct iw_point *dwrq, char *extra);
 int lbs_set_scan(struct net_device *dev, struct iw_request_info *info,
-			 struct iw_param *vwrq, char *extra);
+			 union iwreq_data *wrqu, char *extra);
 
 void lbs_scan_worker(struct work_struct *work);
 
Index: wireless-testing/drivers/net/wireless/libertas/scan.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/libertas/scan.c	2008-02-26 15:11:27.000000000 +0100
+++ wireless-testing/drivers/net/wireless/libertas/scan.c	2008-02-26 15:13:49.000000000 +0100
@@ -66,7 +66,6 @@ static const u8 bcastmac[ETH_ALEN] = { 0
 
 
 
-
 /*********************************************************************/
 /*                                                                   */
 /*  Misc helper functions                                            */
@@ -280,17 +279,6 @@ done:
 /*                                                                   */
 /*********************************************************************/
 
-void lbs_scan_worker(struct work_struct *work)
-{
-	struct lbs_private *priv =
-		container_of(work, struct lbs_private, scan_work.work);
-
-	lbs_deb_enter(LBS_DEB_SCAN);
-	lbs_scan_networks(priv, NULL, 0);
-	lbs_deb_leave(LBS_DEB_SCAN);
-}
-
-
 /**
  *  @brief Create a channel list for the driver to scan based on region info
  *
@@ -302,17 +290,11 @@ void lbs_scan_worker(struct work_struct 
  *
  *  @param priv          A pointer to struct lbs_private structure
  *  @param scanchanlist  Output parameter: resulting channel list to scan
- *  @param filteredscan  Flag indicating whether or not a BSSID or SSID filter
- *                       is being sent in the command to firmware.  Used to
- *                       increase the number of channels sent in a scan
- *                       command and to disable the firmware channel scan
- *                       filter.
  *
  *  @return              void
  */
 static int lbs_scan_create_channel_list(struct lbs_private *priv,
-					  struct chanscanparamset * scanchanlist,
-					  u8 filteredscan)
+	struct chanscanparamset *scanchanlist)
 {
 
 	struct region_channel *scanregion;
@@ -382,11 +364,6 @@ static int lbs_scan_create_channel_list(
 			}
 
 			scanchanlist[chanidx].channumber = cfp->channel;
-
-			if (filteredscan) {
-				scanchanlist[chanidx].chanscanmode.
-				    disablechanfilt = 1;
-			}
 		}
 	}
 	return chanidx;
@@ -400,15 +377,14 @@ static int lbs_scan_create_channel_list(
  * length          06 00
  * ssid            4d 4e 54 45 53 54
  */
-static int lbs_scan_add_ssid_tlv(u8 *tlv,
-	const struct lbs_ioctl_user_scan_cfg *user_cfg)
+static int lbs_scan_add_ssid_tlv(struct lbs_private *priv, u8 *tlv)
 {
 	struct mrvlietypes_ssidparamset *ssid_tlv =
 		(struct mrvlietypes_ssidparamset *)tlv;
 	ssid_tlv->header.type = cpu_to_le16(TLV_TYPE_SSID);
-	ssid_tlv->header.len = cpu_to_le16(user_cfg->ssid_len);
-	memcpy(ssid_tlv->ssid, user_cfg->ssid, user_cfg->ssid_len);
-	return sizeof(ssid_tlv->header) + user_cfg->ssid_len;
+	ssid_tlv->header.len = cpu_to_le16(priv->scan_ssid_len);
+	memcpy(ssid_tlv->ssid, priv->scan_ssid, priv->scan_ssid_len);
+	return sizeof(ssid_tlv->header) + priv->scan_ssid_len;
 }
 
 
@@ -495,8 +471,7 @@ static int lbs_scan_add_rates_tlv(u8 *tl
 static int lbs_do_scan(struct lbs_private *priv,
 	u8 bsstype,
 	struct chanscanparamset *chan_list,
-	int chan_count,
-	const struct lbs_ioctl_user_scan_cfg *user_cfg)
+	int chan_count)
 {
 	int ret = -ENOMEM;
 	struct lbs_scan_cmd_config *scan_cmd;
@@ -511,13 +486,13 @@ static int lbs_do_scan(struct lbs_privat
 	if (scan_cmd == NULL)
 		goto out;
 	tlv = scan_cmd->tlvbuffer;
-	if (user_cfg)
-		memcpy(scan_cmd->bssid, user_cfg->bssid, ETH_ALEN);
+	/* TODO: do we need to scan for a specific BSSID?
+	memcpy(scan_cmd->bssid, priv->scan_bssid, ETH_ALEN); */
 	scan_cmd->bsstype = bsstype;
 
 	/* add TLVs */
-	if (user_cfg && user_cfg->ssid_len)
-		tlv += lbs_scan_add_ssid_tlv(tlv, user_cfg);
+	if (priv->scan_ssid_len)
+		tlv += lbs_scan_add_ssid_tlv(priv, tlv);
 	if (chan_list && chan_count)
 		tlv += lbs_scan_add_chanlist_tlv(tlv, chan_list, chan_count);
 	tlv += lbs_scan_add_rates_tlv(tlv);
@@ -547,14 +522,11 @@ out:
  *    update the internal driver scan table
  *
  *  @param priv          A pointer to struct lbs_private structure
- *  @param puserscanin   Pointer to the input configuration for the requested
- *                       scan.
+ *  @param full_scan     should a full (blocking) scan be done?
  *
  *  @return              0 or < 0 if error
  */
-int lbs_scan_networks(struct lbs_private *priv,
-	const struct lbs_ioctl_user_scan_cfg *user_cfg,
-                       int full_scan)
+static int lbs_scan_networks(struct lbs_private *priv, int full_scan)
 {
 	int ret = -ENOMEM;
 	struct chanscanparamset *chan_list;
@@ -562,7 +534,6 @@ int lbs_scan_networks(struct lbs_private
 	int chan_count;
 	u8 bsstype = CMD_BSS_TYPE_ANY;
 	int numchannels = MRVDRV_CHANNELS_PER_SCAN_CMD;
-	int filteredscan = 0;
 	union iwreq_data wrqu;
 #ifdef CONFIG_LIBERTAS_DEBUG
 	struct bss_descriptor *iter;
@@ -579,18 +550,19 @@ int lbs_scan_networks(struct lbs_private
 	if (full_scan && delayed_work_pending(&priv->scan_work))
 		cancel_delayed_work(&priv->scan_work);
 
-	/* Determine same scan parameters */
+	/* User-specified bsstype or channel list
+	TODO: this can be implemented if some user-space application
+	need the feature. Formerly, it was accessible from debugfs,
+	but then nowhere used.
+
 	if (user_cfg) {
 		if (user_cfg->bsstype)
 			bsstype = user_cfg->bsstype;
-		if (compare_ether_addr(user_cfg->bssid, &zeromac[0]) != 0) {
-			numchannels = MRVDRV_MAX_CHANNELS_PER_SCAN;
-			filteredscan = 1;
-		}
 	}
-	lbs_deb_scan("numchannels %d, bsstype %d, "
-		"filteredscan %d\n",
-		numchannels, bsstype, filteredscan);
+	*/
+
+	lbs_deb_scan("numchannels %d, bsstype %d\n",
+		numchannels, bsstype);
 
 	/* Create list of channels to scan */
 	chan_list = kzalloc(sizeof(struct chanscanparamset) *
@@ -601,8 +573,7 @@ int lbs_scan_networks(struct lbs_private
 	}
 
 	/* We want to scan all channels */
-	chan_count = lbs_scan_create_channel_list(priv, chan_list,
-		filteredscan);
+	chan_count = lbs_scan_create_channel_list(priv, chan_list);
 
 	netif_stop_queue(priv->dev);
 	netif_carrier_off(priv->dev);
@@ -631,7 +602,7 @@ int lbs_scan_networks(struct lbs_private
 		lbs_deb_scan("scanning %d of %d channels\n",
 			to_scan, chan_count);
 		ret = lbs_do_scan(priv, bsstype, curr_chans,
-			to_scan, user_cfg);
+			to_scan);
 		if (ret) {
 			lbs_pr_err("SCAN_CMD failed\n");
 			goto out2;
@@ -693,6 +664,17 @@ out:
 
 
 
+void lbs_scan_worker(struct work_struct *work)
+{
+	struct lbs_private *priv =
+		container_of(work, struct lbs_private, scan_work.work);
+
+	lbs_deb_enter(LBS_DEB_SCAN);
+	lbs_scan_networks(priv, 0);
+	lbs_deb_leave(LBS_DEB_SCAN);
+}
+
+
 /*********************************************************************/
 /*                                                                   */
 /*  Result interpretation                                            */
@@ -1115,7 +1097,7 @@ static struct bss_descriptor *lbs_find_b
 }
 
 /**
- *  @brief Find the AP with specific ssid in the scan list
+ *  @brief Find the best AP
  *
  *  Used from association worker.
  *
@@ -1132,7 +1114,8 @@ int lbs_find_best_network_ssid(struct lb
 
 	lbs_deb_enter(LBS_DEB_SCAN);
 
-	lbs_scan_networks(priv, NULL, 1);
+	priv->scan_ssid_len = 0;
+	lbs_scan_networks(priv, 1);
 	if (priv->surpriseremoved)
 		goto out;
 
@@ -1164,23 +1147,20 @@ out:
  *  @return                0-success, otherwise fail
  */
 int lbs_send_specific_ssid_scan(struct lbs_private *priv,
-			u8 *ssid, u8 ssid_len, u8 clear_ssid)
+			u8 *ssid, u8 ssid_len)
 {
-	struct lbs_ioctl_user_scan_cfg scancfg;
 	int ret = 0;
 
-	lbs_deb_enter_args(LBS_DEB_SCAN, "SSID '%s', clear %d",
-		escape_essid(ssid, ssid_len), clear_ssid);
+	lbs_deb_enter_args(LBS_DEB_SCAN, "SSID '%s'",
+		escape_essid(ssid, ssid_len));
 
 	if (!ssid_len)
 		goto out;
 
-	memset(&scancfg, 0x00, sizeof(scancfg));
-	memcpy(scancfg.ssid, ssid, ssid_len);
-	scancfg.ssid_len = ssid_len;
-	scancfg.clear_ssid = clear_ssid;
+	memcpy(priv->scan_ssid, ssid, ssid_len);
+	priv->scan_ssid_len = ssid_len;
 
-	lbs_scan_networks(priv, &scancfg, 1);
+	lbs_scan_networks(priv, 1);
 	if (priv->surpriseremoved) {
 		ret = -1;
 		goto out;
@@ -1367,27 +1347,37 @@ out:
  *  @return             0 --success, otherwise fail
  */
 int lbs_set_scan(struct net_device *dev, struct iw_request_info *info,
-		  struct iw_param *wrqu, char *extra)
+		union iwreq_data *wrqu, char *extra)
 {
 	struct lbs_private *priv = dev->priv;
+	int ret = 0;
 
-	lbs_deb_enter(LBS_DEB_SCAN);
+	lbs_deb_enter(LBS_DEB_WEXT);
 
-	if (!netif_running(dev))
-		return -ENETDOWN;
+	if (!netif_running(dev)) {
+		ret = -ENETDOWN;
+		goto out;
+	}
 
 	/* mac80211 does this:
 	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
-	if (sdata->type != IEEE80211_IF_TYPE_xxx)
-		return -EOPNOTSUPP;
+	if (sdata->type != IEEE80211_IF_TYPE_xxx) {
+		ret = -EOPNOTSUPP;
+		goto out;
+	}
+	*/
 
 	if (wrqu->data.length == sizeof(struct iw_scan_req) &&
 	    wrqu->data.flags & IW_SCAN_THIS_ESSID) {
-		req = (struct iw_scan_req *)extra;
-			ssid = req->essid;
-		ssid_len = req->essid_len;
+		struct iw_scan_req *req = (struct iw_scan_req *)extra;
+		priv->scan_ssid_len = req->essid_len;
+		memcpy(priv->scan_ssid, req->essid, priv->scan_ssid_len);
+		lbs_deb_wext("set_scan, essid '%s'\n",
+			escape_essid(priv->scan_ssid, priv->scan_ssid_len));
+	} else {
+		priv->scan_ssid_len = 0;
+		lbs_deb_wext("set_scan\n");
 	}
-	*/
 
 	if (!delayed_work_pending(&priv->scan_work))
 		queue_delayed_work(priv->work_thread, &priv->scan_work,
@@ -1396,10 +1386,11 @@ int lbs_set_scan(struct net_device *dev,
 	priv->scan_channel = -1;
 
 	if (priv->surpriseremoved)
-		return -EIO;
+		ret = -EIO;
 
-	lbs_deb_leave(LBS_DEB_SCAN);
-	return 0;
+out:
+	lbs_deb_leave_args(LBS_DEB_WEXT, "ret %d", ret);
+	return ret;
 }
 
 
@@ -1424,7 +1415,7 @@ int lbs_get_scan(struct net_device *dev,
 	struct bss_descriptor * iter_bss;
 	struct bss_descriptor * safe;
 
-	lbs_deb_enter(LBS_DEB_SCAN);
+	lbs_deb_enter(LBS_DEB_WEXT);
 
 	/* iwlist should wait until the current scan is finished */
 	if (priv->scan_channel)
@@ -1470,7 +1461,7 @@ int lbs_get_scan(struct net_device *dev,
 	dwrq->length = (ev - extra);
 	dwrq->flags = 0;
 
-	lbs_deb_leave_args(LBS_DEB_SCAN, "ret %d", err);
+	lbs_deb_leave_args(LBS_DEB_WEXT, "ret %d", err);
 	return err;
 }
 
Index: wireless-testing/drivers/net/wireless/libertas/assoc.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/libertas/assoc.c	2008-02-26 15:11:27.000000000 +0100
+++ wireless-testing/drivers/net/wireless/libertas/assoc.c	2008-02-26 15:11:29.000000000 +0100
@@ -38,7 +38,7 @@ static int assoc_helper_essid(struct lbs
 	              escape_essid(assoc_req->ssid, assoc_req->ssid_len));
 	if (assoc_req->mode == IW_MODE_INFRA) {
 		lbs_send_specific_ssid_scan(priv, assoc_req->ssid,
-			assoc_req->ssid_len, 0);
+			assoc_req->ssid_len);
 
 		bss = lbs_find_ssid_in_list(priv, assoc_req->ssid,
 				assoc_req->ssid_len, NULL, IW_MODE_INFRA, channel);
@@ -53,7 +53,7 @@ static int assoc_helper_essid(struct lbs
 		 *   scan data will cause us to join a non-existant adhoc network
 		 */
 		lbs_send_specific_ssid_scan(priv, assoc_req->ssid,
-			assoc_req->ssid_len, 1);
+			assoc_req->ssid_len);
 
 		/* Search for the requested SSID in the scan table */
 		bss = lbs_find_ssid_in_list(priv, assoc_req->ssid,
Index: wireless-testing/drivers/net/wireless/libertas/debugfs.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/libertas/debugfs.c	2008-02-26 15:11:27.000000000 +0100
+++ wireless-testing/drivers/net/wireless/libertas/debugfs.c	2008-02-26 15:11:29.000000000 +0100
@@ -164,173 +164,6 @@ out_unlock:
 	return ret;
 }
 
-static ssize_t lbs_extscan(struct file *file, const char __user *userbuf,
-				  size_t count, loff_t *ppos)
-{
-	struct lbs_private *priv = file->private_data;
-	ssize_t res, buf_size;
-	union iwreq_data wrqu;
-	unsigned long addr = get_zeroed_page(GFP_KERNEL);
-	char *buf = (char *)addr;
-
-	buf_size = min(count, len - 1);
-	if (copy_from_user(buf, userbuf, buf_size)) {
-		res = -EFAULT;
-		goto out_unlock;
-	}
-
-	lbs_send_specific_ssid_scan(priv, buf, strlen(buf)-1, 0);
-
-	memset(&wrqu, 0, sizeof(union iwreq_data));
-	wireless_send_event(priv->dev, SIOCGIWSCAN, &wrqu, NULL);
-
-out_unlock:
-	free_page(addr);
-	return count;
-}
-
-static void lbs_parse_bssid(char *buf, size_t count,
-	struct lbs_ioctl_user_scan_cfg *scan_cfg)
-{
-	char *hold;
-	unsigned int mac[ETH_ALEN];
-
-	hold = strstr(buf, "bssid=");
-	if (!hold)
-		return;
-	hold += 6;
-	sscanf(hold, "%02x:%02x:%02x:%02x:%02x:%02x",
-	       mac, mac+1, mac+2, mac+3, mac+4, mac+5);
-	memcpy(scan_cfg->bssid, mac, ETH_ALEN);
-}
-
-static void lbs_parse_ssid(char *buf, size_t count,
-	struct lbs_ioctl_user_scan_cfg *scan_cfg)
-{
-	char *hold, *end;
-	ssize_t size;
-
-	hold = strstr(buf, "ssid=");
-	if (!hold)
-		return;
-	hold += 5;
-	end = strchr(hold, ' ');
-	if (!end)
-		end = buf + count - 1;
-
-	size = min((size_t)IW_ESSID_MAX_SIZE, (size_t) (end - hold));
-	strncpy(scan_cfg->ssid, hold, size);
-
-	return;
-}
-
-static int lbs_parse_clear(char *buf, size_t count, const char *tag)
-{
-	char *hold;
-	int val;
-
-	hold = strstr(buf, tag);
-	if (!hold)
-		return 0;
-	hold += strlen(tag);
-	sscanf(hold, "%d", &val);
-
-	if (val != 0)
-		val = 1;
-
-	return val;
-}
-
-static int lbs_parse_dur(char *buf, size_t count,
-	struct lbs_ioctl_user_scan_cfg *scan_cfg)
-{
-	char *hold;
-	int val;
-
-	hold = strstr(buf, "dur=");
-	if (!hold)
-		return 0;
-	hold += 4;
-	sscanf(hold, "%d", &val);
-
-	return val;
-}
-
-static void lbs_parse_type(char *buf, size_t count,
-	struct lbs_ioctl_user_scan_cfg *scan_cfg)
-{
-	char *hold;
-	int val;
-
-	hold = strstr(buf, "type=");
-	if (!hold)
-		return;
-	hold += 5;
-	sscanf(hold, "%d", &val);
-
-	/* type=1,2 or 3 */
-	if (val < 1 || val > 3)
-		return;
-
-	scan_cfg->bsstype = val;
-
-	return;
-}
-
-static ssize_t lbs_setuserscan(struct file *file,
-				    const char __user *userbuf,
-				    size_t count, loff_t *ppos)
-{
-	struct lbs_private *priv = file->private_data;
-	ssize_t res, buf_size;
-	struct lbs_ioctl_user_scan_cfg *scan_cfg;
-	union iwreq_data wrqu;
-	int dur;
-	char *buf = (char *)get_zeroed_page(GFP_KERNEL);
-
-	if (!buf)
-		return -ENOMEM;
-
-	buf_size = min(count, len - 1);
-	if (copy_from_user(buf, userbuf, buf_size)) {
-		res = -EFAULT;
-		goto out_buf;
-	}
-
-	scan_cfg = kzalloc(sizeof(struct lbs_ioctl_user_scan_cfg), GFP_KERNEL);
-	if (!scan_cfg) {
-		res = -ENOMEM;
-		goto out_buf;
-	}
-	res = count;
-
-	scan_cfg->bsstype = LBS_SCAN_BSS_TYPE_ANY;
-
-	dur = lbs_parse_dur(buf, count, scan_cfg);
-	lbs_parse_bssid(buf, count, scan_cfg);
-	scan_cfg->clear_bssid = lbs_parse_clear(buf, count, "clear_bssid=");
-	lbs_parse_ssid(buf, count, scan_cfg);
-	scan_cfg->clear_ssid = lbs_parse_clear(buf, count, "clear_ssid=");
-	lbs_parse_type(buf, count, scan_cfg);
-
-	lbs_scan_networks(priv, scan_cfg, 1);
-	wait_event_interruptible(priv->cmd_pending,
-				 priv->surpriseremoved || !priv->scan_channel);
-
-	if (priv->surpriseremoved)
-		goto out_scan_cfg;
-
-	memset(&wrqu, 0x00, sizeof(union iwreq_data));
-	wireless_send_event(priv->dev, SIOCGIWSCAN, &wrqu, NULL);
-
- out_scan_cfg:
-	kfree(scan_cfg);
- out_buf:
-	free_page((unsigned long)buf);
-	return res;
-}
-
-
 /*
  * When calling CMD_802_11_SUBSCRIBE_EVENT with CMD_ACT_GET, me might
  * get a bunch of vendor-specific TLVs (a.k.a. IEs) back from the
@@ -857,8 +690,6 @@ static struct lbs_debugfs_files debugfs_
 					write_file_dummy), },
 	{ "sleepparams", 0644, FOPS(lbs_sleepparams_read,
 				lbs_sleepparams_write), },
-	{ "extscan", 0600, FOPS(NULL, lbs_extscan), },
-	{ "setuserscan", 0600, FOPS(NULL, lbs_setuserscan), },
 };
 
 static struct lbs_debugfs_files debugfs_events_files[] = {
Index: wireless-testing/drivers/net/wireless/libertas/wext.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/libertas/wext.c	2008-02-26 15:11:27.000000000 +0100
+++ wireless-testing/drivers/net/wireless/libertas/wext.c	2008-02-26 15:13:00.000000000 +0100
@@ -579,6 +579,9 @@ static int lbs_get_range(struct net_devi
 	       range->num_bitrates);
 
 	range->num_frequency = 0;
+
+	range->scan_capa = IW_SCAN_CAPA_ESSID;
+
 	if (priv->enable11d &&
 	    (priv->connect_status == LBS_CONNECTED ||
 	    priv->mesh_connect_status == LBS_CONNECTED)) {

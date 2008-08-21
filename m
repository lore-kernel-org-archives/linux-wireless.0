Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.185]:58253 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759546AbYHUW3J (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Aug 2008 18:29:09 -0400
Received: by nf-out-0910.google.com with SMTP id d3so81281nfc.21
        for <linux-wireless@vger.kernel.org>; Thu, 21 Aug 2008 15:29:08 -0700 (PDT)
To: linux-wireless@vger.kernel.org
Cc: orinoco-devel@lists.sourceforge.net,
	David Kilroy <kilroyd@gmail.com>
Subject: [PATCH v2 12/19] orinoco: Use extended Agere scans available on 9.x series firmwares
Date: Thu, 21 Aug 2008 23:27:58 +0100
Message-Id: <dc5df8328be19728aec203304d9c265368c2b876.1219352675.git.kilroyd@gmail.com> (sfid-20080822_005042_080946_BFCB6B3B)
In-Reply-To: <5e42f22bf794bbefae50fa2a3e5b4ff6e36c7096.1219352675.git.kilroyd@gmail.com>
References: <1219357685-24731-1-git-send-email-kilroyd@gmail.com>
 <3bd1799afef838bfc6eb688b1e0cf6b0f4949f1b.1219352674.git.kilroyd@gmail.com>
 <24148627bbab77e1365aa43c22a7f24ded1bed7a.1219352674.git.kilroyd@gmail.com>
 <6e9e9826934e0256adbe561e587f93212e042bf2.1219352674.git.kilroyd@gmail.com>
 <77df696e5b53b5e4db3b8c8e70b23cf5aaa2aca2.1219352674.git.kilroyd@gmail.com>
 <ac0da2799e97f5256019ad669f5a6c461bd0d82a.1219352674.git.kilroyd@gmail.com>
 <d792f6b1d5853becf1b1488e6572a4c3244eb769.1219352674.git.kilroyd@gmail.com>
 <6c4f63d9cc1bec763719e18ea8282919b6604503.1219352674.git.kilroyd@gmail.com>
 <9a54acb1147a2c0a7c1cf9b07b9ac756366d0877.1219352674.git.kilroyd@gmail.com>
 <889676c2c8c53b8193620e51d81017ade21e593c.1219352674.git.kilroyd@gmail.com>
 <889676c2c8c53b8193620e51d81017ade21e593c.1219352674.git.kilroyd@gmail.com>
 <347f1ce011aaeeb9b4d8f805fdfb6eb58fc467ca.1219352675.git.kilroyd@gmail.com>
 <5e42f22bf794bbefae50fa2a3e5b4ff6e36c7096.1219352675.git.kilroyd@gmail.com>
In-Reply-To: <3bd1799afef838bfc6eb688b1e0cf6b0f4949f1b.1219352674.git.kilroyd@gmail.com>
References: <3bd1799afef838bfc6eb688b1e0cf6b0f4949f1b.1219352674.git.kilroyd@gmail.com>
From: kilroyd@googlemail.com
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This provides more information than the standard Agere scan, including
the WPA IE.

Signed-off-by: David Kilroy <kilroyd@gmail.com>
---
 drivers/net/wireless/hermes.h     |   34 +++
 drivers/net/wireless/hermes_rid.h |    1 +
 drivers/net/wireless/orinoco.c    |  448 +++++++++++++++++++++++++++++++++----
 drivers/net/wireless/orinoco.h    |    9 +-
 4 files changed, 448 insertions(+), 44 deletions(-)

diff --git a/drivers/net/wireless/hermes.h b/drivers/net/wireless/hermes.h
index 1d0c584..113f3f6 100644
--- a/drivers/net/wireless/hermes.h
+++ b/drivers/net/wireless/hermes.h
@@ -303,6 +303,40 @@ union hermes_scan_info {
 	struct symbol_scan_apinfo	s;
 };
 
+/* Extended scan struct for HERMES_INQ_CHANNELINFO.
+ * wl_lkm calls this an ACS scan (Automatic Channel Select).
+ * Keep out of union hermes_scan_info because it is much bigger than
+ * the older scan structures. */
+struct agere_ext_scan_info {
+	__le16	reserved0;
+
+	u8	noise;
+	u8	level;
+	u8	rx_flow;
+	u8	rate;
+	__le16	reserved1[2];
+
+	__le16	frame_control;
+	__le16	dur_id;
+	u8	addr1[ETH_ALEN];
+	u8	addr2[ETH_ALEN];
+	u8	bssid[ETH_ALEN];
+	__le16	sequence;
+	u8	addr4[ETH_ALEN];
+
+	__le16	data_length;
+
+	/* Next 3 fields do not get filled in. */
+	u8	daddr[ETH_ALEN];
+	u8	saddr[ETH_ALEN];
+	__le16	len_type;
+
+	__le64	timestamp;
+	__le16	beacon_interval;
+	__le16	capabilities;
+	u8	data[316];
+} __attribute__ ((packed));
+
 #define HERMES_LINKSTATUS_NOT_CONNECTED   (0x0000)  
 #define HERMES_LINKSTATUS_CONNECTED       (0x0001)
 #define HERMES_LINKSTATUS_DISCONNECTED    (0x0002)
diff --git a/drivers/net/wireless/hermes_rid.h b/drivers/net/wireless/hermes_rid.h
index 4f46b48..bcd9c82 100644
--- a/drivers/net/wireless/hermes_rid.h
+++ b/drivers/net/wireless/hermes_rid.h
@@ -85,6 +85,7 @@
 #define HERMES_RID_CNFSCANSSID_AGERE		0xFCB2
 #define HERMES_RID_CNFBASICRATES		0xFCB3
 #define HERMES_RID_CNFSUPPORTEDRATES		0xFCB4
+#define HERMES_RID_CNFSCANCHANNELS2GHZ		0xFCC2
 #define HERMES_RID_CNFTICKTIME			0xFCE0
 #define HERMES_RID_CNFSCANREQUEST		0xFCE1
 #define HERMES_RID_CNFJOINREQUEST		0xFCE2
diff --git a/drivers/net/wireless/orinoco.c b/drivers/net/wireless/orinoco.c
index 3d5570d..22718e8 100644
--- a/drivers/net/wireless/orinoco.c
+++ b/drivers/net/wireless/orinoco.c
@@ -275,13 +275,19 @@ static inline void set_port_type(struct orinoco_private *priv)
 #define ORINOCO_MAX_BSS_COUNT	64
 static int orinoco_bss_data_allocate(struct orinoco_private *priv)
 {
-	if (priv->bss_data)
+	if (priv->bss_xbss_data)
 		return 0;
 
-	priv->bss_data =
-	    kzalloc(ORINOCO_MAX_BSS_COUNT * sizeof(struct bss_element),
-		    GFP_KERNEL);
-	if (!priv->bss_data) {
+	if (priv->has_ext_scan)
+		priv->bss_xbss_data = kzalloc(ORINOCO_MAX_BSS_COUNT *
+					      sizeof(struct xbss_element),
+					      GFP_KERNEL);
+	else
+		priv->bss_xbss_data = kzalloc(ORINOCO_MAX_BSS_COUNT *
+					      sizeof(struct bss_element),
+					      GFP_KERNEL);
+
+	if (!priv->bss_xbss_data) {
 		printk(KERN_WARNING "Out of memory allocating beacons");
 		return -ENOMEM;
 	}
@@ -290,18 +296,53 @@ static int orinoco_bss_data_allocate(struct orinoco_private *priv)
 
 static void orinoco_bss_data_free(struct orinoco_private *priv)
 {
-	kfree(priv->bss_data);
-	priv->bss_data = NULL;
+	kfree(priv->bss_xbss_data);
+	priv->bss_xbss_data = NULL;
 }
 
+#define PRIV_BSS	((struct bss_element *)priv->bss_xbss_data)
+#define PRIV_XBSS	((struct xbss_element *)priv->bss_xbss_data)
 static void orinoco_bss_data_init(struct orinoco_private *priv)
 {
 	int i;
 
 	INIT_LIST_HEAD(&priv->bss_free_list);
 	INIT_LIST_HEAD(&priv->bss_list);
-	for (i = 0; i < ORINOCO_MAX_BSS_COUNT; i++)
-		list_add_tail(&priv->bss_data[i].list, &priv->bss_free_list);
+	if (priv->has_ext_scan)
+		for (i = 0; i < ORINOCO_MAX_BSS_COUNT; i++)
+			list_add_tail(&(PRIV_XBSS[i].list),
+				      &priv->bss_free_list);
+	else
+		for (i = 0; i < ORINOCO_MAX_BSS_COUNT; i++)
+			list_add_tail(&(PRIV_BSS[i].list),
+				      &priv->bss_free_list);
+
+}
+
+static inline u8 *orinoco_get_ie(u8 *data, size_t len,
+				 enum ieee80211_mfie eid)
+{
+	u8 *p = data;
+	while ((p + 2) < (data + len)) {
+		if (p[0] == eid)
+			return p;
+		p += p[1] + 2;
+	}
+	return NULL;
+}
+
+#define WPA_OUI_TYPE	"\x00\x50\xF2\x01"
+#define WPA_SELECTOR_LEN 4
+static inline u8 *orinoco_get_wpa_ie(u8 *data, size_t len)
+{
+	u8 *p = data;
+	while ((p + 2 + WPA_SELECTOR_LEN) < (data + len)) {
+		if ((p[0] == MFIE_TYPE_GENERIC) &&
+		    (memcmp(&p[2], WPA_OUI_TYPE, WPA_SELECTOR_LEN) == 0))
+			return p;
+		p += p[1] + 2;
+	}
+	return NULL;
 }
 
 
@@ -1414,18 +1455,72 @@ static void orinoco_send_wevents(struct work_struct *work)
 static inline void orinoco_clear_scan_results(struct orinoco_private *priv,
 					      unsigned long scan_age)
 {
-	struct bss_element *bss;
-	struct bss_element *tmp_bss;
-
-	/* Blow away current list of scan results */
-	list_for_each_entry_safe(bss, tmp_bss, &priv->bss_list, list) {
-		if (!scan_age ||
-		    time_after(jiffies, bss->last_scanned + scan_age)) {
-			list_move_tail(&bss->list, &priv->bss_free_list);
-			/* Don't blow away ->list, just BSS data */
-			memset(bss, 0, sizeof(bss->bss));
-			bss->last_scanned = 0;
+	if (priv->has_ext_scan) {
+		struct xbss_element *bss;
+		struct xbss_element *tmp_bss;
+
+		/* Blow away current list of scan results */
+		list_for_each_entry_safe(bss, tmp_bss, &priv->bss_list, list) {
+			if (!scan_age ||
+			    time_after(jiffies, bss->last_scanned + scan_age)) {
+				list_move_tail(&bss->list,
+					       &priv->bss_free_list);
+				/* Don't blow away ->list, just BSS data */
+				memset(&bss->bss, 0, sizeof(bss->bss));
+				bss->last_scanned = 0;
+			}
 		}
+	} else {
+		struct bss_element *bss;
+		struct bss_element *tmp_bss;
+
+		/* Blow away current list of scan results */
+		list_for_each_entry_safe(bss, tmp_bss, &priv->bss_list, list) {
+			if (!scan_age ||
+			    time_after(jiffies, bss->last_scanned + scan_age)) {
+				list_move_tail(&bss->list,
+					       &priv->bss_free_list);
+				/* Don't blow away ->list, just BSS data */
+				memset(&bss->bss, 0, sizeof(bss->bss));
+				bss->last_scanned = 0;
+			}
+		}
+	}
+}
+
+static void orinoco_add_ext_scan_result(struct orinoco_private *priv,
+					struct agere_ext_scan_info *atom)
+{
+	struct xbss_element *bss = NULL;
+	int found = 0;
+
+	/* Try to update an existing bss first */
+	list_for_each_entry(bss, &priv->bss_list, list) {
+		if (compare_ether_addr(bss->bss.bssid, atom->bssid))
+			continue;
+		/* ESSID lengths */
+		if (bss->bss.data[1] != atom->data[1])
+			continue;
+		if (memcmp(&bss->bss.data[2], &atom->data[2],
+			   atom->data[1]))
+			continue;
+		found = 1;
+		break;
+	}
+
+	/* Grab a bss off the free list */
+	if (!found && !list_empty(&priv->bss_free_list)) {
+		bss = list_entry(priv->bss_free_list.next,
+				 struct xbss_element, list);
+		list_del(priv->bss_free_list.next);
+
+		list_add_tail(&bss->list, &priv->bss_list);
+	}
+
+	if (bss) {
+		/* Always update the BSS to get latest beacon info */
+		memcpy(&bss->bss, atom, sizeof(bss->bss));
+		bss->last_scanned = jiffies;
 	}
 }
 
@@ -1700,6 +1795,63 @@ static void __orinoco_ev_info(struct net_device *dev, hermes_t *hw)
 		kfree(buf);
 	}
 	break;
+	case HERMES_INQ_CHANNELINFO:
+	{
+		struct agere_ext_scan_info *bss;
+
+		if (!priv->scan_inprogress) {
+			printk(KERN_DEBUG "%s: Got chaninfo without scan, "
+			       "len=%d\n", dev->name, len);
+			break;
+		}
+
+		/* An empty result indicates that the scan is complete */
+		if (len == 0) {
+			union iwreq_data	wrqu;
+
+			/* Scan is no longer in progress */
+			priv->scan_inprogress = 0;
+
+			wrqu.data.length = 0;
+			wrqu.data.flags = 0;
+			wireless_send_event(dev, SIOCGIWSCAN, &wrqu, NULL);
+			break;
+		}
+
+		/* Sanity check */
+		else if (len > sizeof(*bss)) {
+			printk(KERN_WARNING
+			       "%s: Ext scan results too large (%d bytes). "
+			       "Truncating results to %zd bytes.\n",
+			       dev->name, len, sizeof(*bss));
+			len = sizeof(*bss);
+		} else if (len < (offsetof(struct agere_ext_scan_info,
+					   data) + 2)) {
+			/* Drop this result now so we don't have to
+			 * keep checking later */
+			printk(KERN_WARNING
+			       "%s: Ext scan results too short (%d bytes)\n",
+			       dev->name, len);
+			break;
+		}
+
+		bss = kmalloc(sizeof(*bss), GFP_ATOMIC);
+		if (bss == NULL)
+			break;
+
+		/* Read scan data */
+		err = hermes_bap_pread(hw, IRQ_BAP, (void *) bss, len,
+				       infofid, sizeof(info));
+		if (err) {
+			kfree(bss);
+			break;
+		}
+
+		orinoco_add_ext_scan_result(priv, bss);
+
+		kfree(bss);
+		break;
+	}
 	case HERMES_INQ_SEC_STAT_AGERE:
 		/* Security status (Agere specific) */
 		/* Ignore this frame for now */
@@ -2557,6 +2709,7 @@ static int determine_firmware(struct net_device *dev)
 	priv->has_wep = 0;
 	priv->has_big_wep = 0;
 	priv->has_alt_txcntl = 0;
+	priv->has_ext_scan = 0;
 	priv->do_fw_download = 0;
 
 	/* Determine capabilities from the firmware version */
@@ -2580,7 +2733,7 @@ static int determine_firmware(struct net_device *dev)
 		priv->do_fw_download = 1;
 		priv->broken_monitor = (firmver >= 0x80000);
 		priv->has_alt_txcntl = (firmver >= 0x90000); /* All 9.x ? */
-
+		priv->has_ext_scan = (firmver >= 0x90000); /* All 9.x ? */
 		/* Tested with Agere firmware :
 		 *	1.16 ; 4.08 ; 4.52 ; 6.04 ; 6.16 ; 7.28 => Jean II
 		 * Tested CableTron firmware : 4.32 => Anton */
@@ -2735,6 +2888,12 @@ static int orinoco_init(struct net_device *dev)
 			printk("40-bit key\n");
 	}
 
+	/* Now we have the firmware capabilities, allocate appropiate
+	 * sized scan buffers */
+	if (orinoco_bss_data_allocate(priv))
+		goto out;
+	orinoco_bss_data_init(priv);
+
 	/* Get the MAC address */
 	err = hermes_read_ltv(hw, USER_BAP, HERMES_RID_CNFOWNMACADDR,
 			      ETH_ALEN, NULL, dev->dev_addr);
@@ -2885,10 +3044,6 @@ struct net_device
 		priv->card = NULL;
 	priv->dev = device;
 
-	if (orinoco_bss_data_allocate(priv))
-		goto err_out_free;
-	orinoco_bss_data_init(priv);
-
 	/* Setup / override net_device fields */
 	dev->init = orinoco_init;
 	dev->hard_start_xmit = orinoco_xmit;
@@ -2924,10 +3079,6 @@ struct net_device
 	priv->last_linkstatus = 0xffff;
 
 	return dev;
-
-err_out_free:
-	free_netdev(dev);
-	return NULL;
 }
 
 void free_orinocodev(struct net_device *dev)
@@ -4375,7 +4526,25 @@ static int orinoco_ioctl_setscan(struct net_device *dev,
 			if (err)
 				break;
 
-			err = hermes_inquire(hw, HERMES_INQ_SCAN);
+			if (priv->has_ext_scan) {
+				/* Clear scan results at the start of
+				 * an extended scan */
+				orinoco_clear_scan_results(priv,
+						msecs_to_jiffies(15000));
+
+				/* TODO: Is this available on older firmware?
+				 *   Can we use it to scan specific channels
+				 *   for IW_SCAN_THIS_FREQ? */
+				err = hermes_write_wordrec(hw, USER_BAP,
+						HERMES_RID_CNFSCANCHANNELS2GHZ,
+						0x7FFF);
+				if (err)
+					goto out;
+
+				err = hermes_inquire(hw,
+						     HERMES_INQ_CHANNELINFO);
+			} else
+				err = hermes_inquire(hw, HERMES_INQ_SCAN);
 			break;
 		}
 	} else
@@ -4541,6 +4710,171 @@ static inline char *orinoco_translate_scan(struct net_device *dev,
 	return current_ev;
 }
 
+static inline char *orinoco_translate_ext_scan(struct net_device *dev,
+					       struct iw_request_info *info,
+					       char *current_ev,
+					       char *end_buf,
+					       struct agere_ext_scan_info *bss,
+					       unsigned int last_scanned)
+{
+	u16			capabilities;
+	u16			channel;
+	struct iw_event		iwe;		/* Temporary buffer */
+	char custom[MAX_CUSTOM_LEN];
+	u8 *ie;
+
+	memset(&iwe, 0, sizeof(iwe));
+
+	/* First entry *MUST* be the AP MAC address */
+	iwe.cmd = SIOCGIWAP;
+	iwe.u.ap_addr.sa_family = ARPHRD_ETHER;
+	memcpy(iwe.u.ap_addr.sa_data, bss->bssid, ETH_ALEN);
+	current_ev = iwe_stream_add_event(info, current_ev, end_buf,
+					  &iwe, IW_EV_ADDR_LEN);
+
+	/* Other entries will be displayed in the order we give them */
+
+	/* Add the ESSID */
+	ie = bss->data;
+	iwe.u.data.length = ie[1];
+	if (iwe.u.data.length) {
+		if (iwe.u.data.length > 32)
+			iwe.u.data.length = 32;
+		iwe.cmd = SIOCGIWESSID;
+		iwe.u.data.flags = 1;
+		current_ev = iwe_stream_add_point(info, current_ev, end_buf,
+						  &iwe, &ie[2]);
+	}
+
+	/* Add mode */
+	capabilities = le16_to_cpu(bss->capabilities);
+	if (capabilities & (WLAN_CAPABILITY_ESS | WLAN_CAPABILITY_IBSS)) {
+		iwe.cmd = SIOCGIWMODE;
+		if (capabilities & WLAN_CAPABILITY_ESS)
+			iwe.u.mode = IW_MODE_MASTER;
+		else
+			iwe.u.mode = IW_MODE_ADHOC;
+		current_ev = iwe_stream_add_event(info, current_ev, end_buf,
+						  &iwe, IW_EV_UINT_LEN);
+	}
+
+	ie = orinoco_get_ie(bss->data, sizeof(bss->data), MFIE_TYPE_DS_SET);
+	channel = ie ? ie[2] : 0;
+	if ((channel >= 1) && (channel <= NUM_CHANNELS)) {
+		/* Add channel and frequency */
+		iwe.cmd = SIOCGIWFREQ;
+		iwe.u.freq.m = channel;
+		iwe.u.freq.e = 0;
+		current_ev = iwe_stream_add_event(info, current_ev, end_buf,
+						  &iwe, IW_EV_FREQ_LEN);
+
+		iwe.u.freq.m = channel_frequency[channel-1] * 100000;
+		iwe.u.freq.e = 1;
+		current_ev = iwe_stream_add_event(info, current_ev, end_buf,
+						  &iwe, IW_EV_FREQ_LEN);
+	}
+
+	/* Add quality statistics. level and noise in dB. No link quality */
+	iwe.cmd = IWEVQUAL;
+	iwe.u.qual.updated = IW_QUAL_DBM | IW_QUAL_QUAL_INVALID;
+	iwe.u.qual.level = bss->level - 0x95;
+	iwe.u.qual.noise = bss->noise - 0x95;
+	/* Wireless tools prior to 27.pre22 will show link quality
+	 * anyway, so we provide a reasonable value. */
+	if (iwe.u.qual.level > iwe.u.qual.noise)
+		iwe.u.qual.qual = iwe.u.qual.level - iwe.u.qual.noise;
+	else
+		iwe.u.qual.qual = 0;
+	current_ev = iwe_stream_add_event(info, current_ev, end_buf,
+					  &iwe, IW_EV_QUAL_LEN);
+
+	/* Add encryption capability */
+	iwe.cmd = SIOCGIWENCODE;
+	if (capabilities & WLAN_CAPABILITY_PRIVACY)
+		iwe.u.data.flags = IW_ENCODE_ENABLED | IW_ENCODE_NOKEY;
+	else
+		iwe.u.data.flags = IW_ENCODE_DISABLED;
+	iwe.u.data.length = 0;
+	current_ev = iwe_stream_add_point(info, current_ev, end_buf,
+					  &iwe, NULL);
+
+	/* WPA IE */
+	ie = orinoco_get_wpa_ie(bss->data, sizeof(bss->data));
+	if (ie) {
+		iwe.cmd = IWEVGENIE;
+		iwe.u.data.length = ie[1] + 2;
+		current_ev = iwe_stream_add_point(info, current_ev, end_buf,
+						  &iwe, ie);
+	}
+
+	/* RSN IE */
+	ie = orinoco_get_ie(bss->data, sizeof(bss->data), MFIE_TYPE_RSN);
+	if (ie) {
+		iwe.cmd = IWEVGENIE;
+		iwe.u.data.length = ie[1] + 2;
+		current_ev = iwe_stream_add_point(info, current_ev, end_buf,
+						  &iwe, ie);
+	}
+
+	ie = orinoco_get_ie(bss->data, sizeof(bss->data), MFIE_TYPE_RATES);
+	if (ie) {
+		char *p = current_ev + iwe_stream_lcp_len(info);
+		int i;
+
+		iwe.cmd = SIOCGIWRATE;
+		/* Those two flags are ignored... */
+		iwe.u.bitrate.fixed = iwe.u.bitrate.disabled = 0;
+
+		for (i = 2; i < (ie[1] + 2); i++) {
+			iwe.u.bitrate.value = ((ie[i] & 0x7F) * 500000);
+			p = iwe_stream_add_value(info, current_ev, p, end_buf,
+						 &iwe, IW_EV_PARAM_LEN);
+		}
+		/* Check if we added any event */
+		if (p > (current_ev + iwe_stream_lcp_len(info)))
+			current_ev = p;
+	}
+
+	/* Timestamp */
+	iwe.cmd = IWEVCUSTOM;
+	iwe.u.data.length = snprintf(custom, MAX_CUSTOM_LEN,
+				     "tsf=%016llx",
+				     le64_to_cpu(bss->timestamp));
+	if (iwe.u.data.length)
+		current_ev = iwe_stream_add_point(info, current_ev, end_buf,
+						  &iwe, custom);
+
+	/* Beacon interval */
+	iwe.cmd = IWEVCUSTOM;
+	iwe.u.data.length = snprintf(custom, MAX_CUSTOM_LEN,
+				     "bcn_int=%d",
+				     le16_to_cpu(bss->beacon_interval));
+	if (iwe.u.data.length)
+		current_ev = iwe_stream_add_point(info, current_ev, end_buf,
+						  &iwe, custom);
+
+	/* Capabilites */
+	iwe.cmd = IWEVCUSTOM;
+	iwe.u.data.length = snprintf(custom, MAX_CUSTOM_LEN,
+				     "capab=0x%04x",
+				     capabilities);
+	if (iwe.u.data.length)
+		current_ev = iwe_stream_add_point(info, current_ev, end_buf,
+						  &iwe, custom);
+
+	/* Add EXTRA: Age to display seconds since last beacon/probe response
+	 * for given network. */
+	iwe.cmd = IWEVCUSTOM;
+	iwe.u.data.length = snprintf(custom, MAX_CUSTOM_LEN,
+				     " Last beacon: %dms ago",
+				     jiffies_to_msecs(jiffies - last_scanned));
+	if (iwe.u.data.length)
+		current_ev = iwe_stream_add_point(info, current_ev, end_buf,
+						  &iwe, custom);
+
+	return current_ev;
+}
+
 /* Return results of a scan */
 static int orinoco_ioctl_getscan(struct net_device *dev,
 				 struct iw_request_info *info,
@@ -4548,7 +4882,6 @@ static int orinoco_ioctl_getscan(struct net_device *dev,
 				 char *extra)
 {
 	struct orinoco_private *priv = netdev_priv(dev);
-	struct bss_element *bss;
 	int err = 0;
 	unsigned long flags;
 	char *current_ev = extra;
@@ -4568,18 +4901,47 @@ static int orinoco_ioctl_getscan(struct net_device *dev,
 		goto out;
 	}
 
-	list_for_each_entry(bss, &priv->bss_list, list) {
-		/* Translate to WE format this entry */
-		current_ev = orinoco_translate_scan(dev, info, current_ev,
-						    extra + srq->length,
-						    &bss->bss,
-						    bss->last_scanned);
-
-		/* Check if there is space for one more entry */
-		if ((extra + srq->length - current_ev) <= IW_EV_ADDR_LEN) {
-			/* Ask user space to try again with a bigger buffer */
-			err = -E2BIG;
-			goto out;
+	if (priv->has_ext_scan) {
+		struct xbss_element *bss;
+
+		list_for_each_entry(bss, &priv->bss_list, list) {
+			/* Translate this entry to WE format */
+			current_ev =
+				orinoco_translate_ext_scan(dev, info,
+							   current_ev,
+							   extra + srq->length,
+							   &bss->bss,
+							   bss->last_scanned);
+
+			/* Check if there is space for one more entry */
+			if ((extra + srq->length - current_ev)
+			    <= IW_EV_ADDR_LEN) {
+				/* Ask user space to try again with a
+				 * bigger buffer */
+				err = -E2BIG;
+				goto out;
+			}
+		}
+
+	} else {
+		struct bss_element *bss;
+
+		list_for_each_entry(bss, &priv->bss_list, list) {
+			/* Translate this entry to WE format */
+			current_ev = orinoco_translate_scan(dev, info,
+							    current_ev,
+							    extra + srq->length,
+							    &bss->bss,
+							    bss->last_scanned);
+
+			/* Check if there is space for one more entry */
+			if ((extra + srq->length - current_ev)
+			    <= IW_EV_ADDR_LEN) {
+				/* Ask user space to try again with a
+				 * bigger buffer */
+				err = -E2BIG;
+				goto out;
+			}
 		}
 	}
 
diff --git a/drivers/net/wireless/orinoco.h b/drivers/net/wireless/orinoco.h
index 584d8c9..f510994 100644
--- a/drivers/net/wireless/orinoco.h
+++ b/drivers/net/wireless/orinoco.h
@@ -42,6 +42,12 @@ struct bss_element {
 	struct list_head list;
 };
 
+struct xbss_element {
+	struct agere_ext_scan_info bss;
+	unsigned long last_scanned;
+	struct list_head list;
+};
+
 struct orinoco_private {
 	void *card;	/* Pointer to card dependent structure */
 	struct device *dev;
@@ -86,6 +92,7 @@ struct orinoco_private {
 	unsigned int has_sensitivity:1;
 	unsigned int has_hostscan:1;
 	unsigned int has_alt_txcntl:1;
+	unsigned int has_ext_scan:1;
 	unsigned int do_fw_download:1;
 	unsigned int broken_disableport:1;
 	unsigned int broken_monitor:1;
@@ -117,7 +124,7 @@ struct orinoco_private {
 	/* Scanning support */
 	struct list_head bss_list;
 	struct list_head bss_free_list;
-	struct bss_element *bss_data;
+	void *bss_xbss_data;
 
 	int	scan_inprogress;	/* Scan pending... */
 	u32	scan_mode;		/* Type of scan done */
-- 
1.5.6.4


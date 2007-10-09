Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:32833 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752827AbXJIQQD (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Oct 2007 12:16:03 -0400
Subject: [RFC PATCH] orinoco: more reliable scan handling
From: Dan Williams <dcbw@redhat.com>
To: linux-wireless@vger.kernel.org
Cc: proski@gnu.org, hermes@gibson.dropbear.id.au
Content-Type: text/plain
Date: Tue, 09 Oct 2007 12:17:23 -0400
Message-Id: <1191946643.20183.2.camel@localhost.localdomain> (sfid-20071009_171612_662288_9824BEBF)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Bring scan result handling more in line with drivers like ipw.  Scan
results are aggregated and a BSS dropped after 15 seconds if no beacon
is received.  This allows the driver to interact better with userspace
where more than one process may request scans or results at any time.

Signed-off-by: Dan Williams <dcbw@redhat.com>

diff --git a/drivers/net/wireless/orinoco.c b/drivers/net/wireless/orinoco.c
index 062286d..842c1cf 100644
--- a/drivers/net/wireless/orinoco.c
+++ b/drivers/net/wireless/orinoco.c
@@ -270,6 +270,37 @@ static inline void set_port_type(struct orinoco_private *priv)
 	}
 }
 
+#define ORINOCO_MAX_BSS_COUNT	64
+static int orinoco_bss_data_allocate(struct orinoco_private *priv)
+{
+	if (priv->bss_data)
+		return 0;
+
+	priv->bss_data =
+	    kzalloc(ORINOCO_MAX_BSS_COUNT * sizeof(bss_element), GFP_KERNEL);
+	if (!priv->bss_data) {
+		printk(KERN_WARNING "Out of memory allocating beacons");
+		return -ENOMEM;
+	}
+	return 0;
+}
+
+static void orinoco_bss_data_free(struct orinoco_private *priv)
+{
+	kfree(priv->bss_data);
+	priv->bss_data = NULL;
+}
+
+static void orinoco_bss_data_init(struct orinoco_private *priv)
+{
+	int i;
+
+	INIT_LIST_HEAD(&priv->bss_free_list);
+	INIT_LIST_HEAD(&priv->bss_list);
+	for (i = 0; i < ORINOCO_MAX_BSS_COUNT; i++)
+		list_add_tail(&priv->bss_data[i].list, &priv->bss_free_list);
+}
+
 /********************************************************************/
 /* Device methods                                                   */
 /********************************************************************/
@@ -1083,6 +1114,121 @@ static void orinoco_send_wevents(struct work_struct *work)
 	orinoco_unlock(priv, &flags);
 }
 
+
+static inline void orinoco_clear_scan_results(struct orinoco_private *priv,
+					      unsigned long scan_age)
+{
+	bss_element *bss;
+	bss_element *tmp_bss;
+
+	/* Blow away current list of scan results */
+	list_for_each_entry_safe(bss, tmp_bss, &priv->bss_list, list) {
+		if (!scan_age ||
+		    time_after(jiffies, bss->last_scanned + scan_age)) {
+			list_move_tail(&bss->list, &priv->bss_free_list);
+			/* Don't blow away ->list, just BSS data */
+			memset(bss, 0, sizeof(bss->bss));
+			bss->last_scanned = 0;
+		}
+	}
+}
+
+static int orinoco_process_scan_results(struct net_device *dev,
+					unsigned char *buf,
+					int len)
+{
+	struct orinoco_private *priv = netdev_priv(dev);
+	int			offset;		/* In the scan data */
+	union hermes_scan_info *atom;
+	int			atom_len;
+
+	switch (priv->firmware_type) {
+	case FIRMWARE_TYPE_AGERE:
+		atom_len = sizeof(struct agere_scan_apinfo);
+		offset = 0;
+		break;
+	case FIRMWARE_TYPE_SYMBOL:
+		/* Lack of documentation necessitates this hack.
+		 * Different firmwares have 68 or 76 byte long atoms.
+		 * We try modulo first.  If the length divides by both,
+		 * we check what would be the channel in the second
+		 * frame for a 68-byte atom.  76-byte atoms have 0 there.
+		 * Valid channel cannot be 0.  */
+		if (len % 76)
+			atom_len = 68;
+		else if (len % 68)
+			atom_len = 76;
+		else if (len >= 1292 && buf[68] == 0)
+			atom_len = 76;
+		else
+			atom_len = 68;
+		offset = 0;
+		break;
+	case FIRMWARE_TYPE_INTERSIL:
+		offset = 4;
+		if (priv->has_hostscan) {
+			atom_len = le16_to_cpup((__le16 *)buf);
+			/* Sanity check for atom_len */
+			if (atom_len < sizeof(struct prism2_scan_apinfo)) {
+				printk(KERN_ERR "%s: Invalid atom_len in scan "
+				       "data: %d\n", dev->name, atom_len);
+				return -EIO;
+			}
+		} else
+			atom_len = offsetof(struct prism2_scan_apinfo, atim);
+		break;
+	default:
+		return -EOPNOTSUPP;
+	}
+
+	/* Check that we got an whole number of atoms */
+	if ((len - offset) % atom_len) {
+		printk(KERN_ERR "%s: Unexpected scan data length %d, "
+		       "atom_len %d, offset %d\n", dev->name, len,
+		       atom_len, offset);
+		return -EIO;
+	}
+
+	orinoco_clear_scan_results(priv, msecs_to_jiffies(15000));
+
+	/* Read the entries one by one */
+	for (; offset + atom_len <= len; offset += atom_len) {
+		int found = 0;
+		bss_element *bss;
+
+		/* Get next atom */
+		atom = (union hermes_scan_info *) (buf + offset);
+
+		/* Try to update an existing bss first */
+		list_for_each_entry(bss, &priv->bss_list, list) {
+			if (compare_ether_addr(bss->bss.a.bssid, atom->a.bssid))
+				continue;
+			if (le16_to_cpu(bss->bss.a.essid_len) !=
+			      le16_to_cpu(atom->a.essid_len))
+				continue;
+			if (memcmp(bss->bss.a.essid, atom->a.essid,
+			      le16_to_cpu(atom->a.essid_len)))
+				continue;
+			bss->last_scanned = jiffies;
+			found = 1;
+			break;
+		}
+
+		/* Grab a bss off the free list */
+		if (!found && !list_empty(&priv->bss_free_list)) {
+			bss = list_entry(priv->bss_free_list.next,
+					 bss_element, list);
+			list_del(priv->bss_free_list.next);
+
+			memcpy(bss, atom, sizeof(bss->bss));
+			bss->last_scanned = jiffies;
+			list_add_tail(&bss->list, &priv->bss_list);
+		}
+	}
+
+	return 0;
+}
+
 static void __orinoco_ev_info(struct net_device *dev, hermes_t *hw)
 {
 	struct orinoco_private *priv = netdev_priv(dev);
@@ -1208,6 +1354,9 @@ static void __orinoco_ev_info(struct net_device *dev, hermes_t *hw)
 		union iwreq_data	wrqu;
 		unsigned char *buf;
 
+		/* Scan is no longer in progress */
+		priv->scan_inprogress = 0;
+
 		/* Sanity check */
 		if (len > 4096) {
 			printk(KERN_WARNING "%s: Scan results too large (%d bytes)\n",
@@ -1215,15 +1364,6 @@ static void __orinoco_ev_info(struct net_device *dev, hermes_t *hw)
 			break;
 		}
 
-		/* We are a strict producer. If the previous scan results
-		 * have not been consumed, we just have to drop this
-		 * frame. We can't remove the previous results ourselves,
-		 * that would be *very* racy... Jean II */
-		if (priv->scan_result != NULL) {
-			printk(KERN_WARNING "%s: Previous scan results not consumed, dropping info frame.\n", dev->name);
-			break;
-		}
-
 		/* Allocate buffer for results */
 		buf = kmalloc(len, GFP_ATOMIC);
 		if (buf == NULL)
@@ -1248,18 +1388,17 @@ static void __orinoco_ev_info(struct net_device *dev, hermes_t *hw)
 		}
 #endif	/* ORINOCO_DEBUG */
 
-		/* Allow the clients to access the results */
-		priv->scan_len = len;
-		priv->scan_result = buf;
-
-		/* Send an empty event to user space.
-		 * We don't send the received data on the event because
-		 * it would require us to do complex transcoding, and
-		 * we want to minimise the work done in the irq handler
-		 * Use a request to extract the data - Jean II */
-		wrqu.data.length = 0;
-		wrqu.data.flags = 0;
-		wireless_send_event(dev, SIOCGIWSCAN, &wrqu, NULL);
+		if (orinoco_process_scan_results(dev, buf, len) == 0) {
+			/* Send an empty event to user space.
+			 * We don't send the received data on the event because
+			 * it would require us to do complex transcoding, and
+			 * we want to minimise the work done in the irq handler
+			 * Use a request to extract the data - Jean II */
+			wrqu.data.length = 0;
+			wrqu.data.flags = 0;
+			wireless_send_event(dev, SIOCGIWSCAN, &wrqu, NULL);
+		}
+		kfree(buf);
 	}
 	break;
 	case HERMES_INQ_SEC_STAT_AGERE:
@@ -1896,8 +2035,7 @@ static void orinoco_reset(struct work_struct *work)
 	orinoco_unlock(priv, &flags);
 
  	/* Scanning support: Cleanup of driver struct */
-	kfree(priv->scan_result);
-	priv->scan_result = NULL;
+	orinoco_clear_scan_results(priv, 0);
 	priv->scan_inprogress = 0;
 
 	if (priv->hard_reset) {
@@ -2413,6 +2551,10 @@ struct net_device *alloc_orinocodev(int sizeof_card,
 	else
 		priv->card = NULL;
 
+	if (orinoco_bss_data_allocate(priv))
+		goto err_out_free;
+	orinoco_bss_data_init(priv);
+
 	/* Setup / override net_device fields */
 	dev->init = orinoco_init;
 	dev->hard_start_xmit = orinoco_xmit;
@@ -2448,13 +2590,16 @@ struct net_device *alloc_orinocodev(int sizeof_card,
 
 	return dev;
 
+err_out_free:
+	free_netdev(dev);
+	return NULL;
 }
 
 void free_orinocodev(struct net_device *dev)
 {
 	struct orinoco_private *priv = netdev_priv(dev);
 
-	kfree(priv->scan_result);
+	orinoco_bss_data_free(priv);
 	free_netdev(dev);
 }
 
@@ -3842,23 +3987,10 @@ static int orinoco_ioctl_setscan(struct net_device *dev,
 	 * we access scan variables in priv is critical.
 	 *	o scan_inprogress : not touched by irq handler
 	 *	o scan_mode : not touched by irq handler
-	 *	o scan_result : irq is strict producer, non-irq is strict
-	 *		consumer.
 	 *	o scan_len : synchronised with scan_result
 	 * Before modifying anything on those variables, please think hard !
 	 * Jean II */
 
-	/* If there is still some left-over scan results, get rid of it */
-	if (priv->scan_result != NULL) {
-		/* What's likely is that a client did crash or was killed
-		 * between triggering the scan request and reading the
-		 * results, so we need to reset everything.
-		 * Some clients that are too slow may suffer from that...
-		 * Jean II */
-		kfree(priv->scan_result);
-		priv->scan_result = NULL;
-	}
-
 	/* Save flags */
 	priv->scan_mode = srq->flags;
 
@@ -3906,169 +4038,125 @@ static int orinoco_ioctl_setscan(struct net_device *dev,
 	return err;
 }
 
+#define MAX_CUSTOM_LEN 64
+
 /* Translate scan data returned from the card to a card independant
  * format that the Wireless Tools will understand - Jean II
  * Return message length or -errno for fatal errors */
-static inline int orinoco_translate_scan(struct net_device *dev,
-					 char *buffer,
-					 char *scan,
-					 int scan_len)
+static inline char *orinoco_translate_scan(struct net_device *dev,
+					   char *current_ev,
+					   char *end_buf,
+					   union hermes_scan_info *bss,
+					   unsigned int last_scanned)
 {
 	struct orinoco_private *priv = netdev_priv(dev);
-	int			offset;		/* In the scan data */
-	union hermes_scan_info *atom;
-	int			atom_len;
 	u16			capabilities;
 	u16			channel;
 	struct iw_event		iwe;		/* Temporary buffer */
-	char *			current_ev = buffer;
-	char *			end_buf = buffer + IW_SCAN_MAX_DATA;
-
-	switch (priv->firmware_type) {
-	case FIRMWARE_TYPE_AGERE:
-		atom_len = sizeof(struct agere_scan_apinfo);
- 		offset = 0;
-		break;
-	case FIRMWARE_TYPE_SYMBOL:
-		/* Lack of documentation necessitates this hack.
-		 * Different firmwares have 68 or 76 byte long atoms.
-		 * We try modulo first.  If the length divides by both,
-		 * we check what would be the channel in the second
-		 * frame for a 68-byte atom.  76-byte atoms have 0 there.
-		 * Valid channel cannot be 0.  */
-		if (scan_len % 76)
-			atom_len = 68;
-		else if (scan_len % 68)
-			atom_len = 76;
-		else if (scan_len >= 1292 && scan[68] == 0)
-			atom_len = 76;
+	char                   *p;
+	char custom[MAX_CUSTOM_LEN];
+
+	/* First entry *MUST* be the AP MAC address */
+	iwe.cmd = SIOCGIWAP;
+	iwe.u.ap_addr.sa_family = ARPHRD_ETHER;
+	memcpy(iwe.u.ap_addr.sa_data, bss->a.bssid, ETH_ALEN);
+	current_ev = iwe_stream_add_event(current_ev, end_buf, &iwe, IW_EV_ADDR_LEN);
+
+	/* Other entries will be displayed in the order we give them */
+
+	/* Add the ESSID */
+	iwe.u.data.length = le16_to_cpu(bss->a.essid_len);
+	if (iwe.u.data.length > 32)
+		iwe.u.data.length = 32;
+	iwe.cmd = SIOCGIWESSID;
+	iwe.u.data.flags = 1;
+	current_ev = iwe_stream_add_point(current_ev, end_buf, &iwe, bss->a.essid);
+
+	/* Add mode */
+	iwe.cmd = SIOCGIWMODE;
+	capabilities = le16_to_cpu(bss->a.capabilities);
+	if (capabilities & 0x3) {
+		if (capabilities & 0x1)
+			iwe.u.mode = IW_MODE_MASTER;
 		else
-			atom_len = 68;
-		offset = 0;
-		break;
-	case FIRMWARE_TYPE_INTERSIL:
-		offset = 4;
-		if (priv->has_hostscan) {
-			atom_len = le16_to_cpup((__le16 *)scan);
-			/* Sanity check for atom_len */
-			if (atom_len < sizeof(struct prism2_scan_apinfo)) {
-				printk(KERN_ERR "%s: Invalid atom_len in scan data: %d\n",
-				dev->name, atom_len);
-				return -EIO;
-			}
-		} else
-			atom_len = offsetof(struct prism2_scan_apinfo, atim);
-		break;
-	default:
-		return -EOPNOTSUPP;
-	}
-
-	/* Check that we got an whole number of atoms */
-	if ((scan_len - offset) % atom_len) {
-		printk(KERN_ERR "%s: Unexpected scan data length %d, "
-		       "atom_len %d, offset %d\n", dev->name, scan_len,
-		       atom_len, offset);
-		return -EIO;
-	}
-
-	/* Read the entries one by one */
-	for (; offset + atom_len <= scan_len; offset += atom_len) {
-		/* Get next atom */
-		atom = (union hermes_scan_info *) (scan + offset);
-
-		/* First entry *MUST* be the AP MAC address */
-		iwe.cmd = SIOCGIWAP;
-		iwe.u.ap_addr.sa_family = ARPHRD_ETHER;
-		memcpy(iwe.u.ap_addr.sa_data, atom->a.bssid, ETH_ALEN);
-		current_ev = iwe_stream_add_event(current_ev, end_buf, &iwe, IW_EV_ADDR_LEN);
-
-		/* Other entries will be displayed in the order we give them */
-
-		/* Add the ESSID */
-		iwe.u.data.length = le16_to_cpu(atom->a.essid_len);
-		if (iwe.u.data.length > 32)
-			iwe.u.data.length = 32;
-		iwe.cmd = SIOCGIWESSID;
-		iwe.u.data.flags = 1;
-		current_ev = iwe_stream_add_point(current_ev, end_buf, &iwe, atom->a.essid);
-
-		/* Add mode */
-		iwe.cmd = SIOCGIWMODE;
-		capabilities = le16_to_cpu(atom->a.capabilities);
-		if (capabilities & 0x3) {
-			if (capabilities & 0x1)
-				iwe.u.mode = IW_MODE_MASTER;
-			else
-				iwe.u.mode = IW_MODE_ADHOC;
-			current_ev = iwe_stream_add_event(current_ev, end_buf, &iwe, IW_EV_UINT_LEN);
-		}
-
-		channel = atom->s.channel;
-		if ( (channel >= 1) && (channel <= NUM_CHANNELS) ) {
-			/* Add frequency */
-			iwe.cmd = SIOCGIWFREQ;
-			iwe.u.freq.m = channel_frequency[channel-1] * 100000;
-			iwe.u.freq.e = 1;
-			current_ev = iwe_stream_add_event(current_ev, end_buf,
-							  &iwe, IW_EV_FREQ_LEN);
-		}
+			iwe.u.mode = IW_MODE_ADHOC;
+		current_ev = iwe_stream_add_event(current_ev, end_buf, &iwe, IW_EV_UINT_LEN);
+	}
+
+	channel = bss->s.channel;
+	if ((channel >= 1) && (channel <= NUM_CHANNELS)) {
+		/* Add frequency */
+		iwe.cmd = SIOCGIWFREQ;
+		iwe.u.freq.m = channel_frequency[channel-1] * 100000;
+		iwe.u.freq.e = 1;
+		current_ev = iwe_stream_add_event(current_ev, end_buf,
+						  &iwe, IW_EV_FREQ_LEN);
+	}
+
+	/* Add quality statistics */
+	iwe.cmd = IWEVQUAL;
+	iwe.u.qual.updated = 0x10;	/* no link quality */
+	iwe.u.qual.level = (__u8) le16_to_cpu(bss->a.level) - 0x95;
+	iwe.u.qual.noise = (__u8) le16_to_cpu(bss->a.noise) - 0x95;
+	/* Wireless tools prior to 27.pre22 will show link quality
+	 * anyway, so we provide a reasonable value. */
+	if (iwe.u.qual.level > iwe.u.qual.noise)
+		iwe.u.qual.qual = iwe.u.qual.level - iwe.u.qual.noise;
+	else
+		iwe.u.qual.qual = 0;
+	current_ev = iwe_stream_add_event(current_ev, end_buf, &iwe, IW_EV_QUAL_LEN);
 
-		/* Add quality statistics */
-		iwe.cmd = IWEVQUAL;
-		iwe.u.qual.updated = 0x10;	/* no link quality */
-		iwe.u.qual.level = (__u8) le16_to_cpu(atom->a.level) - 0x95;
-		iwe.u.qual.noise = (__u8) le16_to_cpu(atom->a.noise) - 0x95;
-		/* Wireless tools prior to 27.pre22 will show link quality
-		 * anyway, so we provide a reasonable value. */
-		if (iwe.u.qual.level > iwe.u.qual.noise)
-			iwe.u.qual.qual = iwe.u.qual.level - iwe.u.qual.noise;
-		else
-			iwe.u.qual.qual = 0;
-		current_ev = iwe_stream_add_event(current_ev, end_buf, &iwe, IW_EV_QUAL_LEN);
+	/* Add encryption capability */
+	iwe.cmd = SIOCGIWENCODE;
+	if (capabilities & 0x10)
+		iwe.u.data.flags = IW_ENCODE_ENABLED | IW_ENCODE_NOKEY;
+	else
+		iwe.u.data.flags = IW_ENCODE_DISABLED;
+	iwe.u.data.length = 0;
+	current_ev = iwe_stream_add_point(current_ev, end_buf, &iwe, bss->a.essid);
+
+	/* Add EXTRA: Age to display seconds since last beacon/probe response
+	 * for given network. */
+	iwe.cmd = IWEVCUSTOM;
+	p = custom;
+	p += snprintf(p, MAX_CUSTOM_LEN - (p - custom),
+		      " Last beacon: %dms ago",
+		      jiffies_to_msecs(jiffies - last_scanned));
+	iwe.u.data.length = p - custom;
+	if (iwe.u.data.length)
+		current_ev = iwe_stream_add_point(current_ev, end_buf, &iwe, custom);
+
+	/* Bit rate is not available in Lucent/Agere firmwares */
+	if (priv->firmware_type != FIRMWARE_TYPE_AGERE) {
+		char *current_val = current_ev + IW_EV_LCP_LEN;
+		int i;
+		int step;
 
-		/* Add encryption capability */
-		iwe.cmd = SIOCGIWENCODE;
-		if (capabilities & 0x10)
-			iwe.u.data.flags = IW_ENCODE_ENABLED | IW_ENCODE_NOKEY;
+		if (priv->firmware_type == FIRMWARE_TYPE_SYMBOL)
+			step = 2;
 		else
-			iwe.u.data.flags = IW_ENCODE_DISABLED;
-		iwe.u.data.length = 0;
-		current_ev = iwe_stream_add_point(current_ev, end_buf, &iwe, atom->a.essid);
-
-		/* Bit rate is not available in Lucent/Agere firmwares */
-		if (priv->firmware_type != FIRMWARE_TYPE_AGERE) {
-			char *	current_val = current_ev + IW_EV_LCP_LEN;
-			int	i;
-			int	step;
-
-			if (priv->firmware_type == FIRMWARE_TYPE_SYMBOL)
-				step = 2;
-			else
-				step = 1;
-
-			iwe.cmd = SIOCGIWRATE;
-			/* Those two flags are ignored... */
-			iwe.u.bitrate.fixed = iwe.u.bitrate.disabled = 0;
-			/* Max 10 values */
-			for (i = 0; i < 10; i += step) {
-				/* NULL terminated */
-				if (atom->p.rates[i] == 0x0)
-					break;
-				/* Bit rate given in 500 kb/s units (+ 0x80) */
-				iwe.u.bitrate.value = ((atom->p.rates[i] & 0x7f) * 500000);
-				current_val = iwe_stream_add_value(current_ev, current_val,
-								   end_buf, &iwe,
-								   IW_EV_PARAM_LEN);
-			}
-			/* Check if we added any event */
-			if ((current_val - current_ev) > IW_EV_LCP_LEN)
-				current_ev = current_val;
+			step = 1;
+
+		iwe.cmd = SIOCGIWRATE;
+		/* Those two flags are ignored... */
+		iwe.u.bitrate.fixed = iwe.u.bitrate.disabled = 0;
+		/* Max 10 values */
+		for (i = 0; i < 10; i += step) {
+			/* NULL terminated */
+			if (bss->p.rates[i] == 0x0)
+				break;
+			/* Bit rate given in 500 kb/s units (+ 0x80) */
+			iwe.u.bitrate.value = ((bss->p.rates[i] & 0x7f) * 500000);
+			current_val = iwe_stream_add_value(current_ev, current_val,
+							   end_buf, &iwe,
+							   IW_EV_PARAM_LEN);
 		}
-
-		/* The other data in the scan result are not really
-		 * interesting, so for now drop it - Jean II */
+		/* Check if we added any event */
+		if ((current_val - current_ev) > IW_EV_LCP_LEN)
+			current_ev = current_val;
 	}
-	return current_ev - buffer;
+
+	return current_ev;
 }
 
 /* Return results of a scan */
@@ -4078,68 +4166,45 @@ static int orinoco_ioctl_getscan(struct net_device *dev,
 				 char *extra)
 {
 	struct orinoco_private *priv = netdev_priv(dev);
+	bss_element *bss;
 	int err = 0;
 	unsigned long flags;
+	char *current_ev = extra;
 
 	if (orinoco_lock(priv, &flags) != 0)
 		return -EBUSY;
 
-	/* If no results yet, ask to try again later */
-	if (priv->scan_result == NULL) {
-		if (priv->scan_inprogress)
-			/* Important note : we don't want to block the caller
-			 * until results are ready for various reasons.
-			 * First, managing wait queues is complex and racy.
-			 * Second, we grab some rtnetlink lock before comming
-			 * here (in dev_ioctl()).
-			 * Third, we generate an Wireless Event, so the
-			 * caller can wait itself on that - Jean II */
-			err = -EAGAIN;
-		else
-			/* Client error, no scan results...
-			 * The caller need to restart the scan. */
-			err = -ENODATA;
-	} else {
-		/* We have some results to push back to user space */
-
-		/* Translate to WE format */
-		int ret = orinoco_translate_scan(dev, extra,
-						 priv->scan_result,
-						 priv->scan_len);
-
-		if (ret < 0) {
-			err = ret;
-			kfree(priv->scan_result);
-			priv->scan_result = NULL;
-		} else {
-			srq->length = ret;
+	if (priv->scan_inprogress) {
+		/* Important note : we don't want to block the caller
+		 * until results are ready for various reasons.
+		 * First, managing wait queues is complex and racy.
+		 * Second, we grab some rtnetlink lock before comming
+		 * here (in dev_ioctl()).
+		 * Third, we generate an Wireless Event, so the
+		 * caller can wait itself on that - Jean II */
+		err = -EAGAIN;
+		goto out;
+	}
 
-			/* Return flags */
-			srq->flags = (__u16) priv->scan_mode;
+	list_for_each_entry(bss, &priv->bss_list, list) {
+		/* Translate to WE format this entry */
+		current_ev = orinoco_translate_scan(dev, current_ev,
+						    extra + srq->length,
+						    &bss->bss,
+						    bss->last_scanned);
 
-			/* In any case, Scan results will be cleaned up in the
-			 * reset function and when exiting the driver.
-			 * The person triggering the scanning may never come to
-			 * pick the results, so we need to do it in those places.
-			 * Jean II */
-
-#ifdef SCAN_SINGLE_READ
-			/* If you enable this option, only one client (the first
-			 * one) will be able to read the result (and only one
-			 * time). If there is multiple concurent clients that
-			 * want to read scan results, this behavior is not
-			 * advisable - Jean II */
-			kfree(priv->scan_result);
-			priv->scan_result = NULL;
-#endif /* SCAN_SINGLE_READ */
-			/* Here, if too much time has elapsed since last scan,
-			 * we may want to clean up scan results... - Jean II */
+		/* Check if there is space for one more entry */
+		if ((extra + srq->length - current_ev) <= IW_EV_ADDR_LEN) {
+			/* Ask user space to try again with a bigger buffer */
+			err = -E2BIG;
+			goto out;
 		}
-
-		/* Scan is no longer in progress */
-		priv->scan_inprogress = 0;
 	}
-	  
+
+	srq->length = (current_ev - extra);
+	srq->flags = (__u16) priv->scan_mode;
+
+out:
 	orinoco_unlock(priv, &flags);
 	return err;
 }


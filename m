Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.185]:58253 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759110AbYHUW2R (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Aug 2008 18:28:17 -0400
Received: by nf-out-0910.google.com with SMTP id d3so81281nfc.21
        for <linux-wireless@vger.kernel.org>; Thu, 21 Aug 2008 15:28:17 -0700 (PDT)
To: linux-wireless@vger.kernel.org
Cc: orinoco-devel@lists.sourceforge.net,
	David Kilroy <kilroyd@gmail.com>
Subject: [PATCH v2 02/19] orinoco: Update scan translation
Date: Thu, 21 Aug 2008 23:27:47 +0100
Message-Id: <24148627bbab77e1365aa43c22a7f24ded1bed7a.1219352674.git.kilroyd@gmail.com> (sfid-20080822_002820_610266_C52B95E7)
In-Reply-To: <3bd1799afef838bfc6eb688b1e0cf6b0f4949f1b.1219352674.git.kilroyd@gmail.com>
References: <1219357685-24731-1-git-send-email-kilroyd@gmail.com>
 <3bd1799afef838bfc6eb688b1e0cf6b0f4949f1b.1219352674.git.kilroyd@gmail.com>
In-Reply-To: <3bd1799afef838bfc6eb688b1e0cf6b0f4949f1b.1219352674.git.kilroyd@gmail.com>
References: <3bd1799afef838bfc6eb688b1e0cf6b0f4949f1b.1219352674.git.kilroyd@gmail.com>
From: kilroyd@googlemail.com
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Report channel, beacon interval and capabilities.
Use WEXT defines instead of magic numbers.
State quality stats in dB.
Also a few changes to keep line length less than 80.

Signed-off-by: David Kilroy <kilroyd@gmail.com>
---
 drivers/net/wireless/orinoco.c |   71 ++++++++++++++++++++++++++--------------
 1 files changed, 46 insertions(+), 25 deletions(-)

diff --git a/drivers/net/wireless/orinoco.c b/drivers/net/wireless/orinoco.c
index a60b459..00b1d59 100644
--- a/drivers/net/wireless/orinoco.c
+++ b/drivers/net/wireless/orinoco.c
@@ -3948,7 +3948,7 @@ static int orinoco_ioctl_getrid(struct net_device *dev,
 	return err;
 }
 
-/* Trigger a scan (look for other cells in the vicinity */
+/* Trigger a scan (look for other cells in the vicinity) */
 static int orinoco_ioctl_setscan(struct net_device *dev,
 				 struct iw_request_info *info,
 				 struct iw_param *srq,
@@ -3988,7 +3988,6 @@ static int orinoco_ioctl_setscan(struct net_device *dev,
 	 * we access scan variables in priv is critical.
 	 *	o scan_inprogress : not touched by irq handler
 	 *	o scan_mode : not touched by irq handler
-	 *	o scan_len : synchronised with scan_result
 	 * Before modifying anything on those variables, please think hard !
 	 * Jean II */
 
@@ -4054,8 +4053,7 @@ static int orinoco_ioctl_setscan(struct net_device *dev,
 #define MAX_CUSTOM_LEN 64
 
 /* Translate scan data returned from the card to a card independant
- * format that the Wireless Tools will understand - Jean II
- * Return message length or -errno for fatal errors */
+ * format that the Wireless Tools will understand - Jean II */
 static inline char *orinoco_translate_scan(struct net_device *dev,
 					   struct iw_request_info *info,
 					   char *current_ev,
@@ -4067,9 +4065,10 @@ static inline char *orinoco_translate_scan(struct net_device *dev,
 	u16			capabilities;
 	u16			channel;
 	struct iw_event		iwe;		/* Temporary buffer */
-	char                   *p;
 	char custom[MAX_CUSTOM_LEN];
 
+	memset(&iwe, 0, sizeof(iwe));
+
 	/* First entry *MUST* be the AP MAC address */
 	iwe.cmd = SIOCGIWAP;
 	iwe.u.ap_addr.sa_family = ARPHRD_ETHER;
@@ -4091,8 +4090,8 @@ static inline char *orinoco_translate_scan(struct net_device *dev,
 	/* Add mode */
 	iwe.cmd = SIOCGIWMODE;
 	capabilities = le16_to_cpu(bss->a.capabilities);
-	if (capabilities & 0x3) {
-		if (capabilities & 0x1)
+	if (capabilities & (WLAN_CAPABILITY_ESS | WLAN_CAPABILITY_IBSS)) {
+		if (capabilities & WLAN_CAPABILITY_ESS)
 			iwe.u.mode = IW_MODE_MASTER;
 		else
 			iwe.u.mode = IW_MODE_ADHOC;
@@ -4102,17 +4101,22 @@ static inline char *orinoco_translate_scan(struct net_device *dev,
 
 	channel = bss->s.channel;
 	if ((channel >= 1) && (channel <= NUM_CHANNELS)) {
-		/* Add frequency */
+		/* Add channel and frequency */
 		iwe.cmd = SIOCGIWFREQ;
+		iwe.u.freq.m = channel;
+		iwe.u.freq.e = 0;
+		current_ev = iwe_stream_add_event(info, current_ev, end_buf,
+						  &iwe, IW_EV_FREQ_LEN);
+
 		iwe.u.freq.m = channel_frequency[channel-1] * 100000;
 		iwe.u.freq.e = 1;
 		current_ev = iwe_stream_add_event(info, current_ev, end_buf,
 						  &iwe, IW_EV_FREQ_LEN);
 	}
 
-	/* Add quality statistics */
+	/* Add quality statistics. level and noise in dB. No link quality */
 	iwe.cmd = IWEVQUAL;
-	iwe.u.qual.updated = 0x10;	/* no link quality */
+	iwe.u.qual.updated = IW_QUAL_DBM | IW_QUAL_QUAL_INVALID;
 	iwe.u.qual.level = (__u8) le16_to_cpu(bss->a.level) - 0x95;
 	iwe.u.qual.noise = (__u8) le16_to_cpu(bss->a.noise) - 0x95;
 	/* Wireless tools prior to 27.pre22 will show link quality
@@ -4126,25 +4130,13 @@ static inline char *orinoco_translate_scan(struct net_device *dev,
 
 	/* Add encryption capability */
 	iwe.cmd = SIOCGIWENCODE;
-	if (capabilities & 0x10)
+	if (capabilities & WLAN_CAPABILITY_PRIVACY)
 		iwe.u.data.flags = IW_ENCODE_ENABLED | IW_ENCODE_NOKEY;
 	else
 		iwe.u.data.flags = IW_ENCODE_DISABLED;
 	iwe.u.data.length = 0;
 	current_ev = iwe_stream_add_point(info, current_ev, end_buf,
-					  &iwe, bss->a.essid);
-
-	/* Add EXTRA: Age to display seconds since last beacon/probe response
-	 * for given network. */
-	iwe.cmd = IWEVCUSTOM;
-	p = custom;
-	p += snprintf(p, MAX_CUSTOM_LEN - (p - custom),
-		      " Last beacon: %dms ago",
-		      jiffies_to_msecs(jiffies - last_scanned));
-	iwe.u.data.length = p - custom;
-	if (iwe.u.data.length)
-		current_ev = iwe_stream_add_point(info, current_ev, end_buf,
-						  &iwe, custom);
+					  &iwe, NULL);
 
 	/* Bit rate is not available in Lucent/Agere firmwares */
 	if (priv->firmware_type != FIRMWARE_TYPE_AGERE) {
@@ -4166,7 +4158,8 @@ static inline char *orinoco_translate_scan(struct net_device *dev,
 			if (bss->p.rates[i] == 0x0)
 				break;
 			/* Bit rate given in 500 kb/s units (+ 0x80) */
-			iwe.u.bitrate.value = ((bss->p.rates[i] & 0x7f) * 500000);
+			iwe.u.bitrate.value =
+				((bss->p.rates[i] & 0x7f) * 500000);
 			current_val = iwe_stream_add_value(info, current_ev,
 							   current_val,
 							   end_buf, &iwe,
@@ -4177,6 +4170,34 @@ static inline char *orinoco_translate_scan(struct net_device *dev,
 			current_ev = current_val;
 	}
 
+	/* Beacon interval */
+	iwe.cmd = IWEVCUSTOM;
+	iwe.u.data.length = snprintf(custom, MAX_CUSTOM_LEN,
+				     "bcn_int=%d",
+				     le16_to_cpu(bss->a.beacon_interv));
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
 	return current_ev;
 }
 
-- 
1.5.6.4


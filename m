Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:2787 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934174AbXC0SoX (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Mar 2007 14:44:23 -0400
Date: Tue, 27 Mar 2007 14:26:24 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: jeff@garzik.org
Cc: linux-wireless@vger.kernel.org
Subject: Please pull 'upstream-fixes' branch of wireless-2.6
Message-ID: <20070327182624.GC3887@tuxdriver.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The following changes since commit e0f2e3a06be513352cb4955313ed7e55909acd84:
  Linus Torvalds (1):
        Linux 2.6.21-rc5

are found in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/linville/wireless-2.6.git upstream-fixes

David Woodhouse (1):
      bcm43xx: Fix machine check on PPC for version 1 PHY

Jean Tourrilhes (2):
      wext: Add missing ioctls to 64<->32 conversion
      WE-22 : prevent information leak on 64 bit

Larry Finger (1):
      bcm43xx: Fix code for confusion between PHY revision and PHY version

Stefano Brivio (1):
      bcm43xx: fix radio_set_tx_iq

 drivers/net/wireless/bcm43xx/bcm43xx_phy.c   |    4 +-
 drivers/net/wireless/bcm43xx/bcm43xx_radio.c |   12 ++--
 fs/compat_ioctl.c                            |    9 +++
 include/linux/wireless.h                     |   21 ++++++-
 include/net/iw_handler.h                     |   30 +++++++---
 net/core/rtnetlink.c                         |    3 +-
 net/core/wireless.c                          |   82 ++++++++++++++++----------
 7 files changed, 108 insertions(+), 53 deletions(-)

diff --git a/drivers/net/wireless/bcm43xx/bcm43xx_phy.c b/drivers/net/wireless/bcm43xx/bcm43xx_phy.c
index cae8925..d1e89be 100644
--- a/drivers/net/wireless/bcm43xx/bcm43xx_phy.c
+++ b/drivers/net/wireless/bcm43xx/bcm43xx_phy.c
@@ -757,7 +757,7 @@ static void bcm43xx_phy_initb5(struct bcm43xx_private *bcm)
 	if (radio->version == 0x2050)
 		bcm43xx_phy_write(bcm, 0x0038, 0x0667);
 
-	if (phy->type == BCM43xx_PHYTYPE_G) {
+	if (phy->connected) {
 		if (radio->version == 0x2050) {
 			bcm43xx_radio_write16(bcm, 0x007A,
 					      bcm43xx_radio_read16(bcm, 0x007A)
@@ -1192,7 +1192,7 @@ static void bcm43xx_phy_initg(struct bcm43xx_private *bcm)
 		bcm43xx_phy_write(bcm, 0x0811, 0x0400);
 		bcm43xx_phy_write(bcm, 0x0015, 0x00C0);
 	}
-	if (phy->connected) {
+	if (phy->rev >= 2 && phy->connected) {
 		tmp = bcm43xx_phy_read(bcm, 0x0400) & 0xFF;
 		if (tmp < 6) {
 			bcm43xx_phy_write(bcm, 0x04C2, 0x1816);
diff --git a/drivers/net/wireless/bcm43xx/bcm43xx_radio.c b/drivers/net/wireless/bcm43xx/bcm43xx_radio.c
index ee1e7a2..4025dd0 100644
--- a/drivers/net/wireless/bcm43xx/bcm43xx_radio.c
+++ b/drivers/net/wireless/bcm43xx/bcm43xx_radio.c
@@ -458,7 +458,7 @@ static void bcm43xx_calc_nrssi_offset(struct bcm43xx_private *bcm)
 		bcm43xx_phy_write(bcm, 0x005A, 0x0480);
 		bcm43xx_phy_write(bcm, 0x0059, 0x0810);
 		bcm43xx_phy_write(bcm, 0x0058, 0x000D);
-		if (phy->rev == 0) {
+		if (phy->analog == 0) {
 			bcm43xx_phy_write(bcm, 0x0003, 0x0122);
 		} else {
 			bcm43xx_phy_write(bcm, 0x000A,
@@ -570,9 +570,9 @@ void bcm43xx_calc_nrssi_slope(struct bcm43xx_private *bcm)
 		nrssi0 = (s16)bcm43xx_phy_read(bcm, 0x0027);
 		bcm43xx_radio_write16(bcm, 0x007A,
 				      bcm43xx_radio_read16(bcm, 0x007A) & 0x007F);
-		if (phy->rev >= 2) {
+		if (phy->analog >= 2) {
 			bcm43xx_write16(bcm, 0x03E6, 0x0040);
-		} else if (phy->rev == 0) {
+		} else if (phy->analog == 0) {
 			bcm43xx_write16(bcm, 0x03E6, 0x0122);
 		} else {
 			bcm43xx_write16(bcm, BCM43xx_MMIO_CHANNEL_EXT,
@@ -596,7 +596,7 @@ void bcm43xx_calc_nrssi_slope(struct bcm43xx_private *bcm)
 		bcm43xx_phy_write(bcm, 0x0015, backup[5]);
 		bcm43xx_phy_write(bcm, 0x002A, backup[6]);
 		bcm43xx_synth_pu_workaround(bcm, radio->channel);
-		if (phy->rev != 0)
+		if (phy->analog != 0)
 			bcm43xx_write16(bcm, 0x03F4, backup[13]);
 
 		bcm43xx_phy_write(bcm, 0x0020, backup[7]);
@@ -692,7 +692,7 @@ void bcm43xx_calc_nrssi_slope(struct bcm43xx_private *bcm)
 
 		bcm43xx_radio_write16(bcm, 0x007A,
 				      bcm43xx_radio_read16(bcm, 0x007A) & 0x007F);
-		if (phy->rev >= 2) {
+		if (phy->analog >= 2) {
 			bcm43xx_phy_write(bcm, 0x0003,
 					  (bcm43xx_phy_read(bcm, 0x0003)
 					   & 0xFF9F) | 0x0040);
@@ -1579,7 +1579,7 @@ void bcm43xx_radio_set_tx_iq(struct bcm43xx_private *bcm)
 	
 	for (i = 0; i < 5; i++) {
 		for (j = 0; j < 5; j++) {
-			if (tmp == (data_high[i] << 4 | data_low[j])) {
+			if (tmp == (data_high[i] | data_low[j])) {
 				bcm43xx_phy_write(bcm, 0x0069, (i - j) << 8 | 0x00C0);
 				return;
 			}
diff --git a/fs/compat_ioctl.c b/fs/compat_ioctl.c
index c81c958..8b1c5d8 100644
--- a/fs/compat_ioctl.c
+++ b/fs/compat_ioctl.c
@@ -2553,11 +2553,15 @@ HANDLE_IOCTL(I2C_RDWR, do_i2c_rdwr_ioctl)
 HANDLE_IOCTL(I2C_SMBUS, do_i2c_smbus_ioctl)
 /* wireless */
 HANDLE_IOCTL(SIOCGIWRANGE, do_wireless_ioctl)
+HANDLE_IOCTL(SIOCGIWPRIV, do_wireless_ioctl)
+HANDLE_IOCTL(SIOCGIWSTATS, do_wireless_ioctl)
 HANDLE_IOCTL(SIOCSIWSPY, do_wireless_ioctl)
 HANDLE_IOCTL(SIOCGIWSPY, do_wireless_ioctl)
 HANDLE_IOCTL(SIOCSIWTHRSPY, do_wireless_ioctl)
 HANDLE_IOCTL(SIOCGIWTHRSPY, do_wireless_ioctl)
+HANDLE_IOCTL(SIOCSIWMLME, do_wireless_ioctl)
 HANDLE_IOCTL(SIOCGIWAPLIST, do_wireless_ioctl)
+HANDLE_IOCTL(SIOCSIWSCAN, do_wireless_ioctl)
 HANDLE_IOCTL(SIOCGIWSCAN, do_wireless_ioctl)
 HANDLE_IOCTL(SIOCSIWESSID, do_wireless_ioctl)
 HANDLE_IOCTL(SIOCGIWESSID, do_wireless_ioctl)
@@ -2565,6 +2569,11 @@ HANDLE_IOCTL(SIOCSIWNICKN, do_wireless_ioctl)
 HANDLE_IOCTL(SIOCGIWNICKN, do_wireless_ioctl)
 HANDLE_IOCTL(SIOCSIWENCODE, do_wireless_ioctl)
 HANDLE_IOCTL(SIOCGIWENCODE, do_wireless_ioctl)
+HANDLE_IOCTL(SIOCSIWGENIE, do_wireless_ioctl)
+HANDLE_IOCTL(SIOCGIWGENIE, do_wireless_ioctl)
+HANDLE_IOCTL(SIOCSIWENCODEEXT, do_wireless_ioctl)
+HANDLE_IOCTL(SIOCGIWENCODEEXT, do_wireless_ioctl)
+HANDLE_IOCTL(SIOCSIWPMKSA, do_wireless_ioctl)
 HANDLE_IOCTL(SIOCSIFBR, old_bridge_ioctl)
 HANDLE_IOCTL(SIOCGIFBR, old_bridge_ioctl)
 HANDLE_IOCTL(RTC_IRQP_READ32, rtc_ioctl)
diff --git a/include/linux/wireless.h b/include/linux/wireless.h
index 447c52b..48759b2 100644
--- a/include/linux/wireless.h
+++ b/include/linux/wireless.h
@@ -1,10 +1,10 @@
 /*
  * This file define a set of standard wireless extensions
  *
- * Version :	21	14.3.06
+ * Version :	22	16.3.07
  *
  * Authors :	Jean Tourrilhes - HPL - <jt@hpl.hp.com>
- * Copyright (c) 1997-2006 Jean Tourrilhes, All Rights Reserved.
+ * Copyright (c) 1997-2007 Jean Tourrilhes, All Rights Reserved.
  */
 
 #ifndef _LINUX_WIRELESS_H
@@ -85,7 +85,7 @@
  * (there is some stuff that will be added in the future...)
  * I just plan to increment with each new version.
  */
-#define WIRELESS_EXT	21
+#define WIRELESS_EXT	22
 
 /*
  * Changes :
@@ -221,6 +221,10 @@
  *	- Add IW_RETRY_SHORT/IW_RETRY_LONG retry modifiers
  *	- Power/Retry relative values no longer * 100000
  *	- Add explicit flag to tell stats are in 802.11k RCPI : IW_QUAL_RCPI
+ *
+ * V21 to V22
+ * ----------
+ *	- Prevent leaking of kernel space in stream on 64 bits.
  */
 
 /**************************** CONSTANTS ****************************/
@@ -1085,4 +1089,15 @@ struct iw_event
 #define IW_EV_POINT_LEN	(IW_EV_LCP_LEN + sizeof(struct iw_point) - \
 			 IW_EV_POINT_OFF)
 
+/* Size of the Event prefix when packed in stream */
+#define IW_EV_LCP_PK_LEN	(4)
+/* Size of the various events when packed in stream */
+#define IW_EV_CHAR_PK_LEN	(IW_EV_LCP_PK_LEN + IFNAMSIZ)
+#define IW_EV_UINT_PK_LEN	(IW_EV_LCP_PK_LEN + sizeof(__u32))
+#define IW_EV_FREQ_PK_LEN	(IW_EV_LCP_PK_LEN + sizeof(struct iw_freq))
+#define IW_EV_PARAM_PK_LEN	(IW_EV_LCP_PK_LEN + sizeof(struct iw_param))
+#define IW_EV_ADDR_PK_LEN	(IW_EV_LCP_PK_LEN + sizeof(struct sockaddr))
+#define IW_EV_QUAL_PK_LEN	(IW_EV_LCP_PK_LEN + sizeof(struct iw_quality))
+#define IW_EV_POINT_PK_LEN	(IW_EV_LCP_LEN + 4)
+
 #endif	/* _LINUX_WIRELESS_H */
diff --git a/include/net/iw_handler.h b/include/net/iw_handler.h
index 10559e9..8a83018 100644
--- a/include/net/iw_handler.h
+++ b/include/net/iw_handler.h
@@ -1,10 +1,10 @@
 /*
  * This file define the new driver API for Wireless Extensions
  *
- * Version :	7	18.3.05
+ * Version :	8	16.3.07
  *
  * Authors :	Jean Tourrilhes - HPL - <jt@hpl.hp.com>
- * Copyright (c) 2001-2006 Jean Tourrilhes, All Rights Reserved.
+ * Copyright (c) 2001-2007 Jean Tourrilhes, All Rights Reserved.
  */
 
 #ifndef _IW_HANDLER_H
@@ -207,7 +207,7 @@
  * will be needed...
  * I just plan to increment with each new version.
  */
-#define IW_HANDLER_VERSION	7
+#define IW_HANDLER_VERSION	8
 
 /*
  * Changes :
@@ -239,6 +239,10 @@
  *	- Remove (struct iw_point *)->pointer from events and streams
  *	- Remove spy_offset from struct iw_handler_def
  *	- Add "check" version of event macros for ieee802.11 stack
+ *
+ * V7 to V8
+ * ----------
+ *	- Prevent leaking of kernel space in stream on 64 bits.
  */
 
 /**************************** CONSTANTS ****************************/
@@ -500,7 +504,11 @@ iwe_stream_add_event(char *	stream,		/* Stream of events */
 	/* Check if it's possible */
 	if(likely((stream + event_len) < ends)) {
 		iwe->len = event_len;
-		memcpy(stream, (char *) iwe, event_len);
+		/* Beware of alignement issues on 64 bits */
+		memcpy(stream, (char *) iwe, IW_EV_LCP_PK_LEN);
+		memcpy(stream + IW_EV_LCP_LEN,
+		       ((char *) iwe) + IW_EV_LCP_LEN,
+		       event_len - IW_EV_LCP_LEN);
 		stream += event_len;
 	}
 	return stream;
@@ -521,10 +529,10 @@ iwe_stream_add_point(char *	stream,		/* Stream of events */
 	/* Check if it's possible */
 	if(likely((stream + event_len) < ends)) {
 		iwe->len = event_len;
-		memcpy(stream, (char *) iwe, IW_EV_LCP_LEN);
+		memcpy(stream, (char *) iwe, IW_EV_LCP_PK_LEN);
 		memcpy(stream + IW_EV_LCP_LEN,
 		       ((char *) iwe) + IW_EV_LCP_LEN + IW_EV_POINT_OFF,
-		       IW_EV_POINT_LEN - IW_EV_LCP_LEN);
+		       IW_EV_POINT_PK_LEN - IW_EV_LCP_PK_LEN);
 		memcpy(stream + IW_EV_POINT_LEN, extra, iwe->u.data.length);
 		stream += event_len;
 	}
@@ -574,7 +582,11 @@ iwe_stream_check_add_event(char *	stream,		/* Stream of events */
 	/* Check if it's possible, set error if not */
 	if(likely((stream + event_len) < ends)) {
 		iwe->len = event_len;
-		memcpy(stream, (char *) iwe, event_len);
+		/* Beware of alignement issues on 64 bits */
+		memcpy(stream, (char *) iwe, IW_EV_LCP_PK_LEN);
+		memcpy(stream + IW_EV_LCP_LEN,
+		       ((char *) iwe) + IW_EV_LCP_LEN,
+		       event_len - IW_EV_LCP_LEN);
 		stream += event_len;
 	} else
 		*perr = -E2BIG;
@@ -598,10 +610,10 @@ iwe_stream_check_add_point(char *	stream,		/* Stream of events */
 	/* Check if it's possible */
 	if(likely((stream + event_len) < ends)) {
 		iwe->len = event_len;
-		memcpy(stream, (char *) iwe, IW_EV_LCP_LEN);
+		memcpy(stream, (char *) iwe, IW_EV_LCP_PK_LEN);
 		memcpy(stream + IW_EV_LCP_LEN,
 		       ((char *) iwe) + IW_EV_LCP_LEN + IW_EV_POINT_OFF,
-		       IW_EV_POINT_LEN - IW_EV_LCP_LEN);
+		       IW_EV_POINT_PK_LEN - IW_EV_LCP_PK_LEN);
 		memcpy(stream + IW_EV_POINT_LEN, extra, iwe->u.data.length);
 		stream += event_len;
 	} else
diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
index 6055074..33ea8ea 100644
--- a/net/core/rtnetlink.c
+++ b/net/core/rtnetlink.c
@@ -621,7 +621,8 @@ static int rtnl_getlink(struct sk_buff *skb, struct nlmsghdr* nlh, void *arg)
 		if (err < 0)
 			goto errout;
 
-		iw += IW_EV_POINT_OFF;
+		/* Payload is at an offset in buffer */
+		iw = iw_buf + IW_EV_POINT_OFF;
 	}
 #endif	/* CONFIG_NET_WIRELESS_RTNETLINK */
 
diff --git a/net/core/wireless.c b/net/core/wireless.c
index 9936ab1..b07fe27 100644
--- a/net/core/wireless.c
+++ b/net/core/wireless.c
@@ -2,7 +2,7 @@
  * This file implement the Wireless Extensions APIs.
  *
  * Authors :	Jean Tourrilhes - HPL - <jt@hpl.hp.com>
- * Copyright (c) 1997-2006 Jean Tourrilhes, All Rights Reserved.
+ * Copyright (c) 1997-2007 Jean Tourrilhes, All Rights Reserved.
  *
  * (As all part of the Linux kernel, this file is GPL)
  */
@@ -76,6 +76,9 @@
  *	o Change length in ESSID and NICK to strlen() instead of strlen()+1
  *	o Make standard_ioctl_num and standard_event_num unsigned
  *	o Remove (struct net_device *)->get_wireless_stats()
+ *
+ * v10 - 16.3.07 - Jean II
+ *	o Prevent leaking of kernel space in stream on 64 bits.
  */
 
 /***************************** INCLUDES *****************************/
@@ -427,6 +430,21 @@ static const int event_type_size[] = {
 	IW_EV_QUAL_LEN,			/* IW_HEADER_TYPE_QUAL */
 };
 
+/* Size (in bytes) of various events, as packed */
+static const int event_type_pk_size[] = {
+	IW_EV_LCP_PK_LEN,		/* IW_HEADER_TYPE_NULL */
+	0,
+	IW_EV_CHAR_PK_LEN,		/* IW_HEADER_TYPE_CHAR */
+	0,
+	IW_EV_UINT_PK_LEN,		/* IW_HEADER_TYPE_UINT */
+	IW_EV_FREQ_PK_LEN,		/* IW_HEADER_TYPE_FREQ */
+	IW_EV_ADDR_PK_LEN,		/* IW_HEADER_TYPE_ADDR */
+	0,
+	IW_EV_POINT_PK_LEN,		/* Without variable payload */
+	IW_EV_PARAM_PK_LEN,		/* IW_HEADER_TYPE_PARAM */
+	IW_EV_QUAL_PK_LEN,		/* IW_HEADER_TYPE_QUAL */
+};
+
 /************************ COMMON SUBROUTINES ************************/
 /*
  * Stuff that may be used in various place or doesn't fit in one
@@ -1217,7 +1235,7 @@ static int rtnetlink_standard_get(struct net_device *	dev,
 		memcpy(buffer + IW_EV_POINT_OFF, request, request_len);
 		/* Use our own copy of wrqu */
 		wrqu = (union iwreq_data *) (buffer + IW_EV_POINT_OFF
-					     + IW_EV_LCP_LEN);
+					     + IW_EV_LCP_PK_LEN);
 
 		/* No extra arguments. Trivial to handle */
 		ret = handler(dev, &info, wrqu, NULL);
@@ -1229,8 +1247,8 @@ static int rtnetlink_standard_get(struct net_device *	dev,
 
 		/* Get a temp copy of wrqu (skip pointer) */
 		memcpy(((char *) &wrqu_point) + IW_EV_POINT_OFF,
-		       ((char *) request) + IW_EV_LCP_LEN,
-		       IW_EV_POINT_LEN - IW_EV_LCP_LEN);
+		       ((char *) request) + IW_EV_LCP_PK_LEN,
+		       IW_EV_POINT_LEN - IW_EV_LCP_PK_LEN);
 
 		/* Calculate space needed by arguments. Always allocate
 		 * for max space. Easier, and won't last long... */
@@ -1240,7 +1258,7 @@ static int rtnetlink_standard_get(struct net_device *	dev,
 		   (wrqu_point.data.length > descr->max_tokens))
 			extra_size = (wrqu_point.data.length
 				      * descr->token_size);
-		buffer_size = extra_size + IW_EV_POINT_LEN + IW_EV_POINT_OFF;
+		buffer_size = extra_size + IW_EV_POINT_PK_LEN + IW_EV_POINT_OFF;
 #ifdef WE_RTNETLINK_DEBUG
 		printk(KERN_DEBUG "%s (WE.r) : Malloc %d bytes (%d bytes)\n",
 		       dev->name, extra_size, buffer_size);
@@ -1254,15 +1272,15 @@ static int rtnetlink_standard_get(struct net_device *	dev,
 
 		/* Put wrqu in the right place (just before extra).
 		 * Leave space for IWE header and dummy pointer...
-		 * Note that IW_EV_LCP_LEN==4 bytes, so it's still aligned...
+		 * Note that IW_EV_LCP_PK_LEN==4 bytes, so it's still aligned.
 		 */
-		memcpy(buffer + IW_EV_LCP_LEN + IW_EV_POINT_OFF,
+		memcpy(buffer + IW_EV_LCP_PK_LEN + IW_EV_POINT_OFF,
 		       ((char *) &wrqu_point) + IW_EV_POINT_OFF,
-		       IW_EV_POINT_LEN - IW_EV_LCP_LEN);
-		wrqu = (union iwreq_data *) (buffer + IW_EV_LCP_LEN);
+		       IW_EV_POINT_PK_LEN - IW_EV_LCP_PK_LEN);
+		wrqu = (union iwreq_data *) (buffer + IW_EV_LCP_PK_LEN);
 
 		/* Extra comes logically after that. Offset +12 bytes. */
-		extra = buffer + IW_EV_POINT_OFF + IW_EV_POINT_LEN;
+		extra = buffer + IW_EV_POINT_OFF + IW_EV_POINT_PK_LEN;
 
 		/* Call the handler */
 		ret = handler(dev, &info, wrqu, extra);
@@ -1270,11 +1288,11 @@ static int rtnetlink_standard_get(struct net_device *	dev,
 		/* Calculate real returned length */
 		extra_size = (wrqu->data.length * descr->token_size);
 		/* Re-adjust reply size */
-		request->len = extra_size + IW_EV_POINT_LEN;
+		request->len = extra_size + IW_EV_POINT_PK_LEN;
 
 		/* Put the iwe header where it should, i.e. scrap the
 		 * dummy pointer. */
-		memcpy(buffer + IW_EV_POINT_OFF, request, IW_EV_LCP_LEN);
+		memcpy(buffer + IW_EV_POINT_OFF, request, IW_EV_LCP_PK_LEN);
 
 #ifdef WE_RTNETLINK_DEBUG
 		printk(KERN_DEBUG "%s (WE.r) : Reply 0x%04X, hdr_len %d, tokens %d, extra_size %d, buffer_size %d\n", dev->name, cmd, hdr_len, wrqu->data.length, extra_size, buffer_size);
@@ -1331,10 +1349,10 @@ static inline int rtnetlink_standard_set(struct net_device *	dev,
 #endif	/* WE_RTNETLINK_DEBUG */
 
 	/* Extract fixed header from request. This is properly aligned. */
-	wrqu = &request->u;
+	wrqu = (union iwreq_data *) (((char *) request) + IW_EV_LCP_PK_LEN);
 
 	/* Check if wrqu is complete */
-	hdr_len = event_type_size[descr->header_type];
+	hdr_len = event_type_pk_size[descr->header_type];
 	if(request_len < hdr_len) {
 #ifdef WE_RTNETLINK_DEBUG
 		printk(KERN_DEBUG
@@ -1359,7 +1377,7 @@ static inline int rtnetlink_standard_set(struct net_device *	dev,
 
 		/* Put wrqu in the right place (skip pointer) */
 		memcpy(((char *) &wrqu_point) + IW_EV_POINT_OFF,
-		       wrqu, IW_EV_POINT_LEN - IW_EV_LCP_LEN);
+		       wrqu, IW_EV_POINT_PK_LEN - IW_EV_LCP_PK_LEN);
 		/* Don't forget about the event code... */
 		wrqu = &wrqu_point;
 
@@ -1483,7 +1501,7 @@ static inline int rtnetlink_private_get(struct net_device *	dev,
 		hdr_len = extra_size;
 		extra_size = 0;
 	} else {
-		hdr_len = IW_EV_POINT_LEN;
+		hdr_len = IW_EV_POINT_PK_LEN;
 	}
 
 	/* Check if wrqu is complete */
@@ -1514,7 +1532,7 @@ static inline int rtnetlink_private_get(struct net_device *	dev,
 		memcpy(buffer + IW_EV_POINT_OFF, request, request_len);
 		/* Use our own copy of wrqu */
 		wrqu = (union iwreq_data *) (buffer + IW_EV_POINT_OFF
-					     + IW_EV_LCP_LEN);
+					     + IW_EV_LCP_PK_LEN);
 
 		/* No extra arguments. Trivial to handle */
 		ret = handler(dev, &info, wrqu, (char *) wrqu);
@@ -1523,7 +1541,7 @@ static inline int rtnetlink_private_get(struct net_device *	dev,
 		char *	extra;
 
 		/* Buffer for full reply */
-		buffer_size = extra_size + IW_EV_POINT_LEN + IW_EV_POINT_OFF;
+		buffer_size = extra_size + IW_EV_POINT_PK_LEN + IW_EV_POINT_OFF;
 
 #ifdef WE_RTNETLINK_DEBUG
 		printk(KERN_DEBUG "%s (WE.r) : Malloc %d bytes (%d bytes)\n",
@@ -1538,15 +1556,15 @@ static inline int rtnetlink_private_get(struct net_device *	dev,
 
 		/* Put wrqu in the right place (just before extra).
 		 * Leave space for IWE header and dummy pointer...
-		 * Note that IW_EV_LCP_LEN==4 bytes, so it's still aligned...
+		 * Note that IW_EV_LCP_PK_LEN==4 bytes, so it's still aligned.
 		 */
-		memcpy(buffer + IW_EV_LCP_LEN + IW_EV_POINT_OFF,
-		       ((char *) request) + IW_EV_LCP_LEN,
-		       IW_EV_POINT_LEN - IW_EV_LCP_LEN);
-		wrqu = (union iwreq_data *) (buffer + IW_EV_LCP_LEN);
+		memcpy(buffer + IW_EV_LCP_PK_LEN + IW_EV_POINT_OFF,
+		       ((char *) request) + IW_EV_LCP_PK_LEN,
+		       IW_EV_POINT_PK_LEN - IW_EV_LCP_PK_LEN);
+		wrqu = (union iwreq_data *) (buffer + IW_EV_LCP_PK_LEN);
 
 		/* Extra comes logically after that. Offset +12 bytes. */
-		extra = buffer + IW_EV_POINT_OFF + IW_EV_POINT_LEN;
+		extra = buffer + IW_EV_POINT_OFF + IW_EV_POINT_PK_LEN;
 
 		/* Call the handler */
 		ret = handler(dev, &info, wrqu, extra);
@@ -1556,11 +1574,11 @@ static inline int rtnetlink_private_get(struct net_device *	dev,
 		if (!(descr->get_args & IW_PRIV_SIZE_FIXED))
 			extra_size = adjust_priv_size(descr->get_args, wrqu);
 		/* Re-adjust reply size */
-		request->len = extra_size + IW_EV_POINT_LEN;
+		request->len = extra_size + IW_EV_POINT_PK_LEN;
 
 		/* Put the iwe header where it should, i.e. scrap the
 		 * dummy pointer. */
-		memcpy(buffer + IW_EV_POINT_OFF, request, IW_EV_LCP_LEN);
+		memcpy(buffer + IW_EV_POINT_OFF, request, IW_EV_LCP_PK_LEN);
 
 #ifdef WE_RTNETLINK_DEBUG
 		printk(KERN_DEBUG "%s (WE.r) : Reply 0x%04X, hdr_len %d, tokens %d, extra_size %d, buffer_size %d\n", dev->name, cmd, hdr_len, wrqu->data.length, extra_size, buffer_size);
@@ -1641,14 +1659,14 @@ static inline int rtnetlink_private_set(struct net_device *	dev,
 	/* Does it fits in wrqu ? */
 	if((descr->set_args & IW_PRIV_SIZE_FIXED) &&
 	   (extra_size <= IFNAMSIZ)) {
-		hdr_len = IW_EV_LCP_LEN + extra_size;
+		hdr_len = IW_EV_LCP_PK_LEN + extra_size;
 		extra_size = 0;
 	} else {
-		hdr_len = IW_EV_POINT_LEN;
+		hdr_len = IW_EV_POINT_PK_LEN;
 	}
 
 	/* Extract fixed header from request. This is properly aligned. */
-	wrqu = &request->u;
+	wrqu = (union iwreq_data *) (((char *) request) + IW_EV_LCP_PK_LEN);
 
 	/* Check if wrqu is complete */
 	if(request_len < hdr_len) {
@@ -1675,7 +1693,7 @@ static inline int rtnetlink_private_set(struct net_device *	dev,
 
 		/* Put wrqu in the right place (skip pointer) */
 		memcpy(((char *) &wrqu_point) + IW_EV_POINT_OFF,
-		       wrqu, IW_EV_POINT_LEN - IW_EV_LCP_LEN);
+		       wrqu, IW_EV_POINT_PK_LEN - IW_EV_LCP_PK_LEN);
 
 		/* Does it fits within bounds ? */
 		if(wrqu_point.data.length > (descr->set_args &
@@ -1738,7 +1756,7 @@ int wireless_rtnetlink_get(struct net_device *	dev,
 	iw_handler		handler;
 
 	/* Check length */
-	if(len < IW_EV_LCP_LEN) {
+	if(len < IW_EV_LCP_PK_LEN) {
 		printk(KERN_DEBUG "%s (WE.r) : RtNetlink request too short (%d)\n",
 		       dev->name, len);
 		return -EINVAL;
@@ -1822,7 +1840,7 @@ int wireless_rtnetlink_set(struct net_device *	dev,
 	iw_handler		handler;
 
 	/* Check length */
-	if(len < IW_EV_LCP_LEN) {
+	if(len < IW_EV_LCP_PK_LEN) {
 		printk(KERN_DEBUG "%s (WE.r) : RtNetlink request too short (%d)\n",
 		       dev->name, len);
 		return -EINVAL;
-- 
John W. Linville
linville@tuxdriver.com

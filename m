Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:55009 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753002AbZAXOMy (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 24 Jan 2009 09:12:54 -0500
Subject: [PATCH 3/7 v2] airo: simplify WEP index and capability checks
From: Dan Williams <dcbw@redhat.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1232748914.447.2.camel@localhost.localdomain>
References: <1232748914.447.2.camel@localhost.localdomain>
Content-Type: text/plain
Date: Sat, 24 Jan 2009 09:11:35 -0500
Message-Id: <1232806295.2870.4.camel@localhost.localdomain> (sfid-20090124_151257_618100_8D3AD8D1)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Do the computation once at init time; don't ask the hardware
every time.

Signed-off-by: Dan Williams <dcbw@redhat.com>

diff --git a/drivers/net/wireless/airo.c b/drivers/net/wireless/airo.c
index a08aadf..e4ca5f8 100644
--- a/drivers/net/wireless/airo.c
+++ b/drivers/net/wireless/airo.c
@@ -1233,6 +1233,9 @@ struct airo_info {
 #define	PCI_SHARED_LEN		2*MPI_MAX_FIDS*PKTSIZE+RIDSIZE
 	char			proc_name[IFNAMSIZ];
 
+	int			wep_capable;
+	int			max_wep_idx;
+
 	/* WPA-related stuff */
 	unsigned int bssListFirst;
 	unsigned int bssListNext;
@@ -2836,6 +2839,9 @@ static struct net_device *_init_airo_card( unsigned short irq, int port,
 		rc = -EIO;
 		goto err_out_wifi;
 	}
+	/* WEP capability discovery */
+	ai->wep_capable = (cap_rid.softCap & cpu_to_le16(0x02)) ? 1 : 0;
+	ai->max_wep_idx = (cap_rid.softCap & cpu_to_le16(0x80)) ? 3 : 0;
 
 	airo_print_info(dev->name, "Firmware version %x.%x.%02x",
 	                ((le16_to_cpu(cap_rid.softVer) >> 8) & 0xF),
@@ -6265,11 +6271,9 @@ static int airo_get_mode(struct net_device *dev,
 	return 0;
 }
 
-static inline int valid_index(CapabilityRid *p, int index)
+static inline int valid_index(struct airo_info *ai, int index)
 {
-	if (index < 0)
-		return 0;
-	return index < (p->softCap & cpu_to_le16(0x80) ? 4 : 1);
+	return (index >= 0) && (index <= ai->max_wep_idx);
 }
 
 /*------------------------------------------------------------------*/
@@ -6282,16 +6286,12 @@ static int airo_set_encode(struct net_device *dev,
 			   char *extra)
 {
 	struct airo_info *local = dev->ml_priv;
-	CapabilityRid cap_rid;		/* Card capability info */
 	int perm = ( dwrq->flags & IW_ENCODE_TEMP ? 0 : 1 );
 	__le16 currentAuthType = local->config.authType;
 
-	/* Is WEP supported ? */
-	readCapabilityRid(local, &cap_rid, 1);
-	/* Older firmware doesn't support this...
-	if(!(cap_rid.softCap & cpu_to_le16(2))) {
+	if (!local->wep_capable)
 		return -EOPNOTSUPP;
-	} */
+
 	readConfigRid(local, 1);
 
 	/* Basic checking: do we have a key to set ?
@@ -6304,13 +6304,16 @@ static int airo_set_encode(struct net_device *dev,
 		wep_key_t key;
 		int index = (dwrq->flags & IW_ENCODE_INDEX) - 1;
 		int current_index = get_wep_key(local, 0xffff);
+
 		/* Check the size of the key */
 		if (dwrq->length > MAX_KEY_SIZE) {
 			return -EINVAL;
 		}
+
 		/* Check the index (none -> use current) */
-		if (!valid_index(&cap_rid, index))
+		if (!valid_index(local, index))
 			index = current_index;
+
 		/* Set the length */
 		if (dwrq->length > MIN_KEY_SIZE)
 			key.len = MAX_KEY_SIZE;
@@ -6339,12 +6342,13 @@ static int airo_set_encode(struct net_device *dev,
 	} else {
 		/* Do we want to just set the transmit key index ? */
 		int index = (dwrq->flags & IW_ENCODE_INDEX) - 1;
-		if (valid_index(&cap_rid, index)) {
+		if (valid_index(local, index))
 			set_wep_key(local, index, NULL, 0, perm, 1);
-		} else
+		else {
 			/* Don't complain if only change the mode */
 			if (!(dwrq->flags & IW_ENCODE_MODE))
 				return -EINVAL;
+		}
 	}
 	/* Read the flags */
 	if(dwrq->flags & IW_ENCODE_DISABLED)
@@ -6370,14 +6374,12 @@ static int airo_get_encode(struct net_device *dev,
 {
 	struct airo_info *local = dev->ml_priv;
 	int index = (dwrq->flags & IW_ENCODE_INDEX) - 1;
-	CapabilityRid cap_rid;		/* Card capability info */
 
-	/* Is it supported ? */
-	readCapabilityRid(local, &cap_rid, 1);
-	if(!(cap_rid.softCap & cpu_to_le16(2))) {
+	if (!local->wep_capable)
 		return -EOPNOTSUPP;
-	}
+
 	readConfigRid(local, 1);
+
 	/* Check encryption mode */
 	switch(local->config.authType)	{
 		case AUTH_ENCRYPT:
@@ -6396,7 +6398,7 @@ static int airo_get_encode(struct net_device *dev,
 	memset(extra, 0, 16);
 
 	/* Which key do we want ? -1 -> tx index */
-	if (!valid_index(&cap_rid, index))
+	if (!valid_index(local, index))
 		index = get_wep_key(local, 0xffff);
 	dwrq->flags |= index + 1;
 	/* Copy the key to the user buffer */
@@ -6419,24 +6421,20 @@ static int airo_set_encodeext(struct net_device *dev,
 	struct airo_info *local = dev->ml_priv;
 	struct iw_point *encoding = &wrqu->encoding;
 	struct iw_encode_ext *ext = (struct iw_encode_ext *)extra;
-	CapabilityRid cap_rid;		/* Card capability info */
 	int perm = ( encoding->flags & IW_ENCODE_TEMP ? 0 : 1 );
 	__le16 currentAuthType = local->config.authType;
 	int idx, key_len, alg = ext->alg, set_key = 1;
 	wep_key_t key;
 
-	/* Is WEP supported ? */
-	readCapabilityRid(local, &cap_rid, 1);
-	/* Older firmware doesn't support this...
-	if(!(cap_rid.softCap & cpu_to_le16(2))) {
+	if (!local->wep_capable)
 		return -EOPNOTSUPP;
-	} */
+
 	readConfigRid(local, 1);
 
 	/* Determine and validate the key index */
 	idx = encoding->flags & IW_ENCODE_INDEX;
 	if (idx) {
-		if (!valid_index(&cap_rid, idx - 1))
+		if (!valid_index(local, idx - 1))
 			return -EINVAL;
 		idx--;
 	} else
@@ -6505,14 +6503,11 @@ static int airo_get_encodeext(struct net_device *dev,
 	struct airo_info *local = dev->ml_priv;
 	struct iw_point *encoding = &wrqu->encoding;
 	struct iw_encode_ext *ext = (struct iw_encode_ext *)extra;
-	CapabilityRid cap_rid;		/* Card capability info */
 	int idx, max_key_len;
 
-	/* Is it supported ? */
-	readCapabilityRid(local, &cap_rid, 1);
-	if(!(cap_rid.softCap & cpu_to_le16(2))) {
+	if (!local->wep_capable)
 		return -EOPNOTSUPP;
-	}
+
 	readConfigRid(local, 1);
 
 	max_key_len = encoding->length - sizeof(*ext);
@@ -6521,7 +6516,7 @@ static int airo_get_encodeext(struct net_device *dev,
 
 	idx = encoding->flags & IW_ENCODE_INDEX;
 	if (idx) {
-		if (!valid_index(&cap_rid, idx - 1))
+		if (!valid_index(local, idx - 1))
 			return -EINVAL;
 		idx--;
 	} else



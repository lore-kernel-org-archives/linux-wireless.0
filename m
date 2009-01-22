Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:39479 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752748AbZAVSyr (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Jan 2009 13:54:47 -0500
Subject: [PATCH 4/7 v2] airo: split up WEP key operations
From: Dan Williams <dcbw@redhat.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1232464018.22158.14.camel@localhost.localdomain>
References: <1232462691.22158.6.camel@localhost.localdomain>
	 <1232464018.22158.14.camel@localhost.localdomain>
Content-Type: text/plain
Date: Thu, 22 Jan 2009 13:53:09 -0500
Message-Id: <1232650389.7980.2.camel@localhost.localdomain> (sfid-20090122_195452_625264_2A53DC50)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

get_wep_key() and set_wep_key() combined both get/set of the actual WEP
key and get/set of the transmit index into the same functions.  Split
those
out so it's clearer what is going one where.  Add error checking to WEP
key hardware operations too.

Signed-off-by: Dan Williams <dcbw@redhat.com>
---

v2: fix missing { } in airo_set_encode() that caused setting WEP keys to
fail.

diff --git a/drivers/net/wireless/airo.c b/drivers/net/wireless/airo.c
index 4230374..d483491 100644
--- a/drivers/net/wireless/airo.c
+++ b/drivers/net/wireless/airo.c
@@ -5177,55 +5177,98 @@ static int do_writerid( struct airo_info *ai, u16 rid, const void *rid_data,
 	return rc;
 }
 
-/* Returns the length of the key at the index.  If index == 0xffff
- * the index of the transmit key is returned.  If the key doesn't exist,
- * -1 will be returned.
+/* Returns the WEP key at the specified index, or -1 if that key does
+ * not exist.  The buffer is assumed to be at least 16 bytes in length.
  */
-static int get_wep_key(struct airo_info *ai, u16 index) {
+static int get_wep_key(struct airo_info *ai, u16 index, char *buf, u16 buflen)
+{
 	WepKeyRid wkr;
 	int rc;
 	__le16 lastindex;
 
 	rc = readWepKeyRid(ai, &wkr, 1, 1);
-	if (rc == SUCCESS) do {
+	if (rc != SUCCESS)
+		return -1;
+	do {
 		lastindex = wkr.kindex;
-		if (wkr.kindex == cpu_to_le16(index)) {
-			if (index == 0xffff) {
-				return wkr.mac[0];
-			}
-			return le16_to_cpu(wkr.klen);
+		if (le16_to_cpu(wkr.kindex) == index) {
+			int klen = min_t(int, buflen, le16_to_cpu(wkr.klen));
+			memcpy(buf, wkr.key, klen);
+			return klen;
 		}
-		readWepKeyRid(ai, &wkr, 0, 1);
+		rc = readWepKeyRid(ai, &wkr, 0, 1);
+		if (rc != SUCCESS)
+			return -1;
 	} while (lastindex != wkr.kindex);
 	return -1;
 }
 
-static int set_wep_key(struct airo_info *ai, u16 index,
-		       const char *key, u16 keylen, int perm, int lock )
+static int get_wep_tx_idx(struct airo_info *ai)
+{
+	WepKeyRid wkr;
+	int rc;
+	__le16 lastindex;
+
+	rc = readWepKeyRid(ai, &wkr, 1, 1);
+	if (rc != SUCCESS)
+		return -1;
+	do {
+		lastindex = wkr.kindex;
+		if (wkr.kindex == cpu_to_le16(0xffff))
+			return wkr.mac[0];
+		rc = readWepKeyRid(ai, &wkr, 0, 1);
+		if (rc != SUCCESS)
+			return -1;
+	} while (lastindex != wkr.kindex);
+	return -1;
+}
+
+static int set_wep_key(struct airo_info *ai, u16 index, const char *key,
+		       u16 keylen, int perm, int lock)
 {
 	static const unsigned char macaddr[ETH_ALEN] = { 0x01, 0, 0, 0, 0, 0 };
 	WepKeyRid wkr;
+	int rc;
 
-	memset(&wkr, 0, sizeof(wkr));
 	if (keylen == 0) {
-// We are selecting which key to use
-		wkr.len = cpu_to_le16(sizeof(wkr));
-		wkr.kindex = cpu_to_le16(0xffff);
-		wkr.mac[0] = (char)index;
-		if (perm) ai->defindex = (char)index;
-	} else {
-// We are actually setting the key
-		wkr.len = cpu_to_le16(sizeof(wkr));
-		wkr.kindex = cpu_to_le16(index);
-		wkr.klen = cpu_to_le16(keylen);
-		memcpy( wkr.key, key, keylen );
-		memcpy( wkr.mac, macaddr, ETH_ALEN );
+		airo_print_err(ai->dev->name, "%s: key length to set was zero",
+			       __func__);
+		return -1;
 	}
 
+	memset(&wkr, 0, sizeof(wkr));
+	wkr.len = cpu_to_le16(sizeof(wkr));
+	wkr.kindex = cpu_to_le16(index);
+	wkr.klen = cpu_to_le16(keylen);
+	memcpy(wkr.key, key, keylen);
+	memcpy(wkr.mac, macaddr, ETH_ALEN);
+
 	if (perm) disable_MAC(ai, lock);
-	writeWepKeyRid(ai, &wkr, perm, lock);
+	rc = writeWepKeyRid(ai, &wkr, perm, lock);
 	if (perm) enable_MAC(ai, lock);
-	return 0;
+	return rc;
+}
+
+static int set_wep_tx_idx(struct airo_info *ai, u16 index, int perm, int lock)
+{
+	WepKeyRid wkr;
+	int rc;
+
+	memset(&wkr, 0, sizeof(wkr));
+	wkr.len = cpu_to_le16(sizeof(wkr));
+	wkr.kindex = cpu_to_le16(0xffff);
+	wkr.mac[0] = (char)index;
+
+	if (perm) {
+		ai->defindex = (char)index;
+		disable_MAC(ai, lock);
+	}
+
+	rc = writeWepKeyRid(ai, &wkr, perm, lock);
+
+	if (perm)
+		enable_MAC(ai, lock);
+	return rc;
 }
 
 static void proc_wepkey_on_close( struct inode *inode, struct file *file ) {
@@ -5233,7 +5276,7 @@ static void proc_wepkey_on_close( struct inode *inode, struct file *file ) {
 	struct proc_dir_entry *dp = PDE(inode);
 	struct net_device *dev = dp->data;
 	struct airo_info *ai = dev->ml_priv;
-	int i;
+	int i, rc;
 	char key[16];
 	u16 index = 0;
 	int j = 0;
@@ -5247,7 +5290,12 @@ static void proc_wepkey_on_close( struct inode *inode, struct file *file ) {
 	    (data->wbuffer[1] == ' ' || data->wbuffer[1] == '\n')) {
 		index = data->wbuffer[0] - '0';
 		if (data->wbuffer[1] == '\n') {
-			set_wep_key(ai, index, NULL, 0, 1, 1);
+			rc = set_wep_tx_idx(ai, index, 1, 1);
+			if (rc < 0) {
+				airo_print_err(ai->dev->name, "failed to set "
+				               "WEP transmit index to %d: %d.",
+				               index, rc);
+			}
 			return;
 		}
 		j = 2;
@@ -5266,7 +5314,12 @@ static void proc_wepkey_on_close( struct inode *inode, struct file *file ) {
 			break;
 		}
 	}
-	set_wep_key(ai, index, key, i/3, 1, 1);
+
+	rc = set_wep_key(ai, index, key, i/3, 1, 1);
+	if (rc < 0) {
+		airo_print_err(ai->dev->name, "failed to set WEP key at index "
+		               "%d: %d.", index, rc);
+	}
 }
 
 static int proc_wepkey_open( struct inode *inode, struct file *file )
@@ -5500,13 +5553,13 @@ static void timer_func( struct net_device *dev ) {
 			break;
 		case AUTH_SHAREDKEY:
 			if (apriv->keyindex < auto_wep) {
-				set_wep_key(apriv, apriv->keyindex, NULL, 0, 0, 0);
+				set_wep_tx_idx(apriv, apriv->keyindex, 0, 0);
 				apriv->config.authType = AUTH_SHAREDKEY;
 				apriv->keyindex++;
 			} else {
 			        /* Drop to ENCRYPT */
 				apriv->keyindex = 0;
-				set_wep_key(apriv, apriv->defindex, NULL, 0, 0, 0);
+				set_wep_tx_idx(apriv, apriv->defindex, 0, 0);
 				apriv->config.authType = AUTH_ENCRYPT;
 			}
 			break;
@@ -6294,8 +6347,9 @@ static int airo_set_encode(struct net_device *dev,
 			   char *extra)
 {
 	struct airo_info *local = dev->ml_priv;
-	int perm = ( dwrq->flags & IW_ENCODE_TEMP ? 0 : 1 );
+	int perm = (dwrq->flags & IW_ENCODE_TEMP ? 0 : 1);
 	__le16 currentAuthType = local->config.authType;
+	int rc = 0;
 
 	if (!local->wep_capable)
 		return -EOPNOTSUPP;
@@ -6311,13 +6365,17 @@ static int airo_set_encode(struct net_device *dev,
 	if (dwrq->length > 0) {
 		wep_key_t key;
 		int index = (dwrq->flags & IW_ENCODE_INDEX) - 1;
-		int current_index = get_wep_key(local, 0xffff);
+		int current_index;
 
 		/* Check the size of the key */
 		if (dwrq->length > MAX_KEY_SIZE) {
 			return -EINVAL;
 		}
 
+		current_index = get_wep_tx_idx(local);
+		if (current_index < 0)
+			current_index = 0;
+
 		/* Check the index (none -> use current) */
 		if (!valid_index(local, index))
 			index = current_index;
@@ -6338,7 +6396,13 @@ static int airo_set_encode(struct net_device *dev,
 			/* Copy the key in the driver */
 			memcpy(key.key, extra, dwrq->length);
 			/* Send the key to the card */
-			set_wep_key(local, index, key.key, key.len, perm, 1);
+			rc = set_wep_key(local, index, key.key, key.len, perm, 1);
+			if (rc < 0) {
+				airo_print_err(local->dev->name, "failed to set"
+				               " WEP key at index %d: %d.",
+				               index, rc);
+				return rc;
+			}
 		}
 		/* WE specify that if a valid key is set, encryption
 		 * should be enabled (user may turn it off later)
@@ -6351,7 +6415,13 @@ static int airo_set_encode(struct net_device *dev,
 		/* Do we want to just set the transmit key index ? */
 		int index = (dwrq->flags & IW_ENCODE_INDEX) - 1;
-		if (valid_index(local, index))
-			set_wep_key(local, index, NULL, 0, perm, 1);
+		if (valid_index(local, index)) {
+			rc = set_wep_tx_idx(local, index, perm, 1);
+			if (rc < 0) {
+				airo_print_err(local->dev->name, "failed to set"
+				               " WEP transmit index to %d: %d.",
+				               index, rc);
+				return rc;
+			}
+		} else {
-		else {
 			/* Don't complain if only change the mode */
 			if (!(dwrq->flags & IW_ENCODE_MODE))
@@ -6382,6 +6452,7 @@ static int airo_get_encode(struct net_device *dev,
 {
 	struct airo_info *local = dev->ml_priv;
 	int index = (dwrq->flags & IW_ENCODE_INDEX) - 1;
+	u8 buf[16];
 
 	if (!local->wep_capable)
 		return -EOPNOTSUPP;
@@ -6406,14 +6477,17 @@ static int airo_get_encode(struct net_device *dev,
 	memset(extra, 0, 16);
 
 	/* Which key do we want ? -1 -> tx index */
-	if (!valid_index(local, index))
-		index = get_wep_key(local, 0xffff);
+	if (!valid_index(local, index)) {
+		index = get_wep_tx_idx(local);
+		if (index < 0)
+			index = 0;
+	}
 	dwrq->flags |= index + 1;
+
 	/* Copy the key to the user buffer */
-	dwrq->length = get_wep_key(local, index);
-	if (dwrq->length > 16) {
-		dwrq->length=0;
-	}
+	dwrq->length = get_wep_key(local, index, &buf[0], sizeof(buf));
+	memcpy(extra, buf, dwrq->length);
+
 	return 0;
 }
 
@@ -6431,7 +6505,7 @@ static int airo_set_encodeext(struct net_device *dev,
 	struct iw_encode_ext *ext = (struct iw_encode_ext *)extra;
 	int perm = ( encoding->flags & IW_ENCODE_TEMP ? 0 : 1 );
 	__le16 currentAuthType = local->config.authType;
-	int idx, key_len, alg = ext->alg, set_key = 1;
+	int idx, key_len, alg = ext->alg, set_key = 1, rc;
 	wep_key_t key;
 
 	if (!local->wep_capable)
@@ -6445,8 +6519,11 @@ static int airo_set_encodeext(struct net_device *dev,
 		if (!valid_index(local, idx - 1))
 			return -EINVAL;
 		idx--;
-	} else
-		idx = get_wep_key(local, 0xffff);
+	} else {
+		idx = get_wep_tx_idx(local);
+		if (idx < 0)
+			idx = 0;
+	}
 
 	if (encoding->flags & IW_ENCODE_DISABLED)
 		alg = IW_ENCODE_ALG_NONE;
@@ -6455,7 +6532,13 @@ static int airo_set_encodeext(struct net_device *dev,
 		/* Only set transmit key index here, actual
 		 * key is set below if needed.
 		 */
-		set_wep_key(local, idx, NULL, 0, perm, 1);
+		rc = set_wep_tx_idx(local, idx, perm, 1);
+		if (rc < 0) {
+			airo_print_err(local->dev->name, "failed to set "
+			               "WEP transmit index to %d: %d.",
+			               idx, rc);
+			return rc;
+		}
 		set_key = ext->key_len > 0 ? 1 : 0;
 	}
 
@@ -6481,7 +6564,12 @@ static int airo_set_encodeext(struct net_device *dev,
 			return -EINVAL;
 		}
 		/* Send the key to the card */
-		set_wep_key(local, idx, key.key, key.len, perm, 1);
+		rc = set_wep_key(local, idx, key.key, key.len, perm, 1);
+		if (rc < 0) {
+			airo_print_err(local->dev->name, "failed to set WEP key"
+			               " at index %d: %d.", idx, rc);
+			return rc;
+		}
 	}
 
 	/* Read the flags */
@@ -6512,6 +6600,7 @@ static int airo_get_encodeext(struct net_device *dev,
 	struct iw_point *encoding = &wrqu->encoding;
 	struct iw_encode_ext *ext = (struct iw_encode_ext *)extra;
 	int idx, max_key_len;
+	u8 buf[16];
 
 	if (!local->wep_capable)
 		return -EOPNOTSUPP;
@@ -6527,8 +6616,11 @@ static int airo_get_encodeext(struct net_device *dev,
 		if (!valid_index(local, idx - 1))
 			return -EINVAL;
 		idx--;
-	} else
-		idx = get_wep_key(local, 0xffff);
+	} else {
+		idx = get_wep_tx_idx(local);
+		if (idx < 0)
+			idx = 0;
+	}
 
 	encoding->flags = idx + 1;
 	memset(ext, 0, sizeof(*ext));
@@ -6551,10 +6643,8 @@ static int airo_get_encodeext(struct net_device *dev,
 	memset(extra, 0, 16);
 	
 	/* Copy the key to the user buffer */
-	ext->key_len = get_wep_key(local, idx);
-	if (ext->key_len > 16) {
-		ext->key_len=0;
-	}
+	ext->key_len = get_wep_key(local, idx, &buf[0], sizeof(buf));
+	memcpy(extra, buf, ext->key_len);
 
 	return 0;
 }



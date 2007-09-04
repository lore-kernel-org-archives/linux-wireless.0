Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:32860
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753306AbXIDNPc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Sep 2007 09:15:32 -0400
From: Michael Buesch <mb@bu3sch.de>
To: John Linville <linville@tuxdriver.com>
Subject: [PATCH] b43: Fix HW key clearing.
Date: Tue, 4 Sep 2007 15:14:23 +0200
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org, bcm43xx-dev@lists.berlios.de
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200709041514.23773.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This fixes clearing of the HW keys.

Signed-off-by: Michael Buesch <mb@bu3sch.de>

Index: wireless-dev/drivers/net/wireless/b43/main.c
===================================================================
--- wireless-dev.orig/drivers/net/wireless/b43/main.c	2007-08-31 15:37:00.000000000 +0200
+++ wireless-dev/drivers/net/wireless/b43/main.c	2007-08-31 16:01:34.000000000 +0200
@@ -727,7 +727,7 @@ static void key_write(struct b43_wldev *
 
 static void keymac_write(struct b43_wldev *dev, u8 index, const u8 * addr)
 {
-	u32 addrtmp[2];
+	u32 addrtmp[2] = { 0, 0, };
 	u8 per_sta_keys_start = 8;
 
 	if (b43_new_kidx_api(dev))
@@ -741,12 +741,14 @@ static void keymac_write(struct b43_wlde
 	 */
 	index -= per_sta_keys_start;
 
-	addrtmp[0] = addr[0];
-	addrtmp[0] |= ((u32) (addr[1]) << 8);
-	addrtmp[0] |= ((u32) (addr[2]) << 16);
-	addrtmp[0] |= ((u32) (addr[3]) << 24);
-	addrtmp[1] = addr[4];
-	addrtmp[1] |= ((u32) (addr[5]) << 8);
+	if (addr) {
+		addrtmp[0] = addr[0];
+		addrtmp[0] |= ((u32) (addr[1]) << 8);
+		addrtmp[0] |= ((u32) (addr[2]) << 16);
+		addrtmp[0] |= ((u32) (addr[3]) << 24);
+		addrtmp[1] = addr[4];
+		addrtmp[1] |= ((u32) (addr[5]) << 8);
+	}
 
 	if (dev->dev->id.revision >= 5) {
 		/* Receive match transmitter address mechanism */
@@ -776,7 +778,7 @@ static void do_key_write(struct b43_wlde
 			 u8 index, u8 algorithm,
 			 const u8 * key, size_t key_len, const u8 * mac_addr)
 {
-	u8 buf[B43_SEC_KEYSIZE];
+	u8 buf[B43_SEC_KEYSIZE] = { 0, };
 	u8 per_sta_keys_start = 8;
 
 	if (b43_new_kidx_api(dev))
@@ -785,10 +787,10 @@ static void do_key_write(struct b43_wlde
 	B43_WARN_ON(index >= dev->max_nr_keys);
 	B43_WARN_ON(key_len > B43_SEC_KEYSIZE);
 
-	memset(buf, 0, sizeof(buf));
 	if (index >= per_sta_keys_start)
-		keymac_write(dev, index, buf);	/* First zero out mac. */
-	memcpy(buf, key, key_len);
+		keymac_write(dev, index, NULL);	/* First zero out mac. */
+	if (key)
+		memcpy(buf, key, key_len);
 	key_write(dev, index, algorithm, buf);
 	if (index >= per_sta_keys_start)
 		keymac_write(dev, index, mac_addr);
@@ -804,10 +806,13 @@ static int b43_key_write(struct b43_wlde
 {
 	int i;
 	int sta_keys_start;
-	bool removal = 0;
 
 	if (key_len > B43_SEC_KEYSIZE)
 		return -EINVAL;
+	for (i = 0; i < dev->max_nr_keys; i++) {
+		/* Check that we don't already have this key. */
+		B43_WARN_ON(dev->key[i].keyconf == keyconf);
+	}
 	if (index < 0) {
 		/* Either pairwise key or address is 00:00:00:00:00:00
 		 * for transmit-only keys. Search the index. */
@@ -816,24 +821,13 @@ static int b43_key_write(struct b43_wlde
 		else
 			sta_keys_start = 8;
 		for (i = sta_keys_start; i < dev->max_nr_keys; i++) {
-			if (dev->key[i].keyconf == keyconf) {
-				/* we already have this key so we must be
-				 * in removal (there is no update) */
-				removal = 1;
+			if (!dev->key[i].keyconf) {
+				/* found empty */
 				index = i;
 				break;
 			}
 		}
 		if (index < 0) {
-			for (i = sta_keys_start; i < dev->max_nr_keys; i++) {
-				if (!dev->key[i].keyconf) {
-					/* found empty */
-					index = i;
-					break;
-				}
-			}
-		}
-		if (index < 0) {
 			b43err(dev->wl, "Out of hardware key memory\n");
 			return -ENOSPC;
 		}
@@ -847,22 +841,32 @@ static int b43_key_write(struct b43_wlde
 		do_key_write(dev, index + 4, algorithm, key, key_len, NULL);
 	}
 	keyconf->hw_key_idx = index;
-	dev->key[index].keyconf = removal ? NULL : keyconf;
+	dev->key[index].keyconf = keyconf;
+
+	return 0;
+}
+
+static int b43_key_clear(struct b43_wldev *dev, int index)
+{
+	if (B43_WARN_ON((index < 0) || (index >= dev->max_nr_keys)))
+		return -EINVAL;
+	do_key_write(dev, index, B43_SEC_ALGO_NONE,
+		     NULL, B43_SEC_KEYSIZE, NULL);
+	if ((index <= 3) && !b43_new_kidx_api(dev)) {
+		do_key_write(dev, index + 4, B43_SEC_ALGO_NONE,
+			     NULL, B43_SEC_KEYSIZE, NULL);
+	}
+	dev->key[index].keyconf = NULL;
 
 	return 0;
 }
 
 static void b43_clear_keys(struct b43_wldev *dev)
 {
-	static const u8 zero[B43_SEC_KEYSIZE] = { 0 };
-	unsigned int i;
+	int i;
 
-	BUILD_BUG_ON(B43_SEC_KEYSIZE < ETH_ALEN);
-	for (i = 0; i < dev->max_nr_keys; i++) {
-		do_key_write(dev, i, B43_SEC_ALGO_NONE,
-			     zero, B43_SEC_KEYSIZE, zero);
-		dev->key[i].keyconf = NULL;
-	}
+	for (i = 0; i < dev->max_nr_keys; i++)
+		b43_key_clear(dev, i);
 }
 
 void b43_power_saving_ctl_bits(struct b43_wldev *dev, unsigned int ps_flags)
@@ -2962,12 +2966,7 @@ static int b43_dev_set_key(struct ieee80
 		}
 		break;
 	case DISABLE_KEY: {
-		static const u8 zero[B43_SEC_KEYSIZE] = { 0 };
-
-		algorithm = B43_SEC_ALGO_NONE;
-		err = b43_key_write(dev, index, algorithm,
-				    zero, B43_SEC_KEYSIZE,
-				    NULL, key);
+		err = b43_key_clear(dev, key->hw_key_idx);
 		if (err)
 			goto out_unlock;
 		break;

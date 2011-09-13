Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:4056 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755091Ab1IMHuS (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Sep 2011 03:50:18 -0400
From: "Roland Vossen" <rvossen@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Subject: [PATCH 16/17] staging: brcm80211: fullmac sparse endianness
 encryption keys check
Date: Tue, 13 Sep 2011 09:49:56 +0200
Message-ID: <1315900197-7260-17-git-send-email-rvossen@broadcom.com> (sfid-20110913_095058_810400_3D01C745)
In-Reply-To: <1315900197-7260-1-git-send-email-rvossen@broadcom.com>
References: <1315900197-7260-1-git-send-email-rvossen@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Added support by making a distinction between a struct and its little
endian relative.

Reviewed-by: Arend van Spriel <arend@broadcom.com>
Reviewed-by: Franky Lin <frankyl@broadcom.com>
Signed-off-by: Roland Vossen <rvossen@broadcom.com>
---
 drivers/staging/brcm80211/brcmfmac/dhd.h         |   36 +++++++++--
 drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c |   78 ++++++++++++----------
 2 files changed, 73 insertions(+), 41 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmfmac/dhd.h b/drivers/staging/brcm80211/brcmfmac/dhd.h
index a92a28e..8898370 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd.h
+++ b/drivers/staging/brcm80211/brcmfmac/dhd.h
@@ -405,6 +405,11 @@ struct brcmf_ssid {
 	unsigned char SSID[32];
 };
 
+struct brcmf_ssid_le {
+	__le32 SSID_len;
+	unsigned char SSID[32];
+};
+
 struct brcmf_scan_params {
 	struct brcmf_ssid ssid;	/* default: {0, ""} */
 	u8 bssid[ETH_ALEN];	/* default: bcast */
@@ -500,16 +505,37 @@ struct brcmf_wsec_key {
 	u32 pad_1[18];
 	u32 algo;	/* CRYPTO_ALGO_AES_CCM, CRYPTO_ALGO_WEP128, etc */
 	u32 flags;	/* misc flags */
-	u32 pad_2[2];
-	int pad_3;
-	int iv_initialized;	/* has IV been initialized already? */
-	int pad_4;
+	u32 pad_2[3];
+	u32 iv_initialized;	/* has IV been initialized already? */
+	u32 pad_3;
 	/* Rx IV */
 	struct {
 		u32 hi;	/* upper 32 bits of IV */
 		u16 lo;	/* lower 16 bits of IV */
 	} rxiv;
-	u32 pad_5[2];
+	u32 pad_4[2];
+	u8 ea[ETH_ALEN];	/* per station */
+};
+
+/*
+ * dongle requires same struct as above but with fields in little endian order
+ */
+struct brcmf_wsec_key_le {
+	__le32 index;		/* key index */
+	__le32 len;		/* key length */
+	u8 data[WLAN_MAX_KEY_LEN];	/* key data */
+	__le32 pad_1[18];
+	__le32 algo;	/* CRYPTO_ALGO_AES_CCM, CRYPTO_ALGO_WEP128, etc */
+	__le32 flags;	/* misc flags */
+	__le32 pad_2[3];
+	__le32 iv_initialized;	/* has IV been initialized already? */
+	__le32 pad_3;
+	/* Rx IV */
+	struct {
+		__le32 hi;	/* upper 32 bits of IV */
+		__le16 lo;	/* lower 16 bits of IV */
+	} rxiv;
+	__le32 pad_4[2];
 	u8 ea[ETH_ALEN];	/* per station */
 };
 
diff --git a/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c b/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c
index 926b019..ce393ac 100644
--- a/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c
+++ b/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c
@@ -247,17 +247,6 @@ static const u32 __wl_cipher_suites[] = {
 	WLAN_CIPHER_SUITE_AES_CMAC,
 };
 
-static void convert_key_from_CPU(struct brcmf_wsec_key *key)
-{
-	key->index = cpu_to_le32(key->index);
-	key->len = cpu_to_le32(key->len);
-	key->algo = cpu_to_le32(key->algo);
-	key->flags = cpu_to_le32(key->flags);
-	key->rxiv.hi = cpu_to_le32(key->rxiv.hi);
-	key->rxiv.lo = cpu_to_le16(key->rxiv.lo);
-	key->iv_initialized = cpu_to_le32(key->iv_initialized);
-}
-
 static s32
 brcmf_dev_ioctl(struct net_device *dev, u32 cmd, void *arg, u32 len)
 {
@@ -278,6 +267,33 @@ brcmf_dev_ioctl(struct net_device *dev, u32 cmd, void *arg, u32 len)
 	return err;
 }
 
+static void convert_key_from_CPU(struct brcmf_wsec_key *key,
+				 struct brcmf_wsec_key_le *key_le)
+{
+	key_le->index = cpu_to_le32(key->index);
+	key_le->len = cpu_to_le32(key->len);
+	key_le->algo = cpu_to_le32(key->algo);
+	key_le->flags = cpu_to_le32(key->flags);
+	key_le->rxiv.hi = cpu_to_le32(key->rxiv.hi);
+	key_le->rxiv.lo = cpu_to_le16(key->rxiv.lo);
+	key_le->iv_initialized = cpu_to_le32(key->iv_initialized);
+	memcpy(key_le->data, key->data, sizeof(key->data));
+	memcpy(key_le->ea, key->ea, sizeof(key->ea));
+}
+
+static int send_key_to_dongle(struct net_device *dev,
+			      struct brcmf_wsec_key *key)
+{
+	int err;
+	struct brcmf_wsec_key_le key_le;
+
+	convert_key_from_CPU(key, &key_le);
+	err = brcmf_dev_ioctl(dev, BRCMF_C_SET_KEY, &key_le, sizeof(key_le));
+	if (err)
+		WL_ERR("WLC_SET_KEY error (%d)\n", err);
+	return err;
+}
+
 static s32
 brcmf_cfg80211_change_iface(struct wiphy *wiphy, struct net_device *ndev,
 			 enum nl80211_iftype type, u32 *flags,
@@ -1200,13 +1216,10 @@ brcmf_set_set_sharedkey(struct net_device *dev,
 			WL_CONN("key length (%d) key index (%d) algo (%d)\n",
 			       key.len, key.index, key.algo);
 			WL_CONN("key \"%s\"\n", key.data);
-			convert_key_from_CPU(&key);
-			err = brcmf_dev_ioctl(dev, BRCMF_C_SET_KEY, &key,
-					sizeof(key));
-			if (unlikely(err)) {
-				WL_ERR("WLC_SET_KEY error (%d)\n", err);
+			err = send_key_to_dongle(dev, &key);
+			if (err)
 				return err;
-			}
+
 			if (sec->auth_type == NL80211_AUTHTYPE_OPEN_SYSTEM) {
 				WL_CONN("set auth_type to shared key\n");
 				val = 1;	/* shared key */
@@ -1461,6 +1474,7 @@ brcmf_add_keyext(struct wiphy *wiphy, struct net_device *dev,
 	      u8 key_idx, const u8 *mac_addr, struct key_params *params)
 {
 	struct brcmf_wsec_key key;
+	struct brcmf_wsec_key_le key_le;
 	s32 err = 0;
 
 	memset(&key, 0, sizeof(key));
@@ -1473,12 +1487,9 @@ brcmf_add_keyext(struct wiphy *wiphy, struct net_device *dev,
 	/* check for key index change */
 	if (key.len == 0) {
 		/* key delete */
-		convert_key_from_CPU(&key);
-		err = brcmf_dev_ioctl(dev, BRCMF_C_SET_KEY, &key, sizeof(key));
-		if (unlikely(err)) {
-			WL_ERR("key delete error (%d)\n", err);
+		err = send_key_to_dongle(dev, &key);
+		if (err)
 			return err;
-		}
 	} else {
 		if (key.len > sizeof(key.data)) {
 			WL_ERR("Invalid key length (%d)\n", key.len);
@@ -1531,10 +1542,11 @@ brcmf_add_keyext(struct wiphy *wiphy, struct net_device *dev,
 			WL_ERR("Invalid cipher (0x%x)\n", params->cipher);
 			return -EINVAL;
 		}
-		convert_key_from_CPU(&key);
+		convert_key_from_CPU(&key, &key_le);
 
 		brcmf_netdev_wait_pend8021x(dev);
-		err = brcmf_dev_ioctl(dev, BRCMF_C_SET_KEY, &key, sizeof(key));
+		err = brcmf_dev_ioctl(dev, BRCMF_C_SET_KEY, &key_le,
+				      sizeof(key_le));
 		if (unlikely(err)) {
 			WL_ERR("WLC_SET_KEY error (%d)\n", err);
 			return err;
@@ -1606,13 +1618,9 @@ brcmf_cfg80211_add_key(struct wiphy *wiphy, struct net_device *dev,
 		goto done;
 	}
 
-	/* Set the new key/index */
-	convert_key_from_CPU(&key);
-	err = brcmf_dev_ioctl(dev, BRCMF_C_SET_KEY, &key, sizeof(key));
-	if (unlikely(err)) {
-		WL_ERR("WLC_SET_KEY error (%d)\n", err);
+	err = send_key_to_dongle(dev, &key); /* Set the new key/index */
+	if (err)
 		goto done;
-	}
 
 	val = WEP_ENABLED;
 	err = brcmf_dev_intvar_get(dev, "wsec", &wsec);
@@ -1658,17 +1666,15 @@ brcmf_cfg80211_del_key(struct wiphy *wiphy, struct net_device *dev,
 	key.algo = CRYPTO_ALGO_OFF;
 
 	WL_CONN("key index (%d)\n", key_idx);
+
 	/* Set the new key/index */
-	convert_key_from_CPU(&key);
-	err = brcmf_dev_ioctl(dev, BRCMF_C_SET_KEY, &key, sizeof(key));
-	if (unlikely(err)) {
+	err = send_key_to_dongle(dev, &key);
+	if (err) {
 		if (err == -EINVAL) {
 			if (key.index >= DOT11_MAX_DEFAULT_KEYS)
 				/* we ignore this key index in this case */
 				WL_ERR("invalid key index (%d)\n", key_idx);
-		} else
-			WL_ERR("WLC_SET_KEY error (%d)\n", err);
-
+		}
 		/* Ignore this error, may happen during DISASSOC */
 		err = -EAGAIN;
 		goto done;
-- 
1.7.4.1



Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:42970 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750959Ab1JLBCf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Oct 2011 21:02:35 -0400
Received: by bkbzt4 with SMTP id zt4so235648bkb.19
        for <linux-wireless@vger.kernel.org>; Tue, 11 Oct 2011 18:02:33 -0700 (PDT)
Content-Type: text/plain; charset=utf-8; format=flowed; delsp=yes
To: linux-wireless@vger.kernel.org
Date: Wed, 12 Oct 2011 03:02:29 +0200
Cc: "Bartosz MARKOWSKI" <bartosz.markowski@tieto.com>,
	"Janusz DZIEDZIC" <janusz.dziedzic@tieto.com>
Subject: [RFC 01/07] wireless-next: WAPI support for hardware-accelerated
 drivers
MIME-Version: 1.0
From: "Dmitry Tarnyagin" <abi.dmitryt@gmail.com>
Message-ID: <op.v27rufm9ya27un@edmitar> (sfid-20111012_030239_221122_93C5737F)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Janusz Dziedzic <janusz.dziedzic@tieto.com>
Date: Wed, 1 Jun 2011 14:40:13 +0200

This commit implements WAPI support for hardware-accelerated devices.

Signed-off-by: Dmitry Tarnyagin <dmitry.tarnyagin@stericsson.com>
---
  include/linux/ieee80211.h  |    3 ++
  include/linux/nl80211.h    |    5 ++-
  include/linux/wireless.h   |    6 ++++
  net/mac80211/Makefile      |    1 +
  net/mac80211/ieee80211_i.h |    2 +-
  net/mac80211/key.c         |    4 ++
  net/mac80211/key.h         |    2 +
  net/mac80211/main.c        |    1 +
  net/mac80211/rx.c          |    4 ++
  net/mac80211/tx.c          |    6 ++++
  net/mac80211/wapi.c        |   71  
++++++++++++++++++++++++++++++++++++++++++++
  net/mac80211/wapi.h        |   27 ++++++++++++++++
  net/wireless/nl80211.c     |    7 ++--
  net/wireless/util.c        |    8 +++++
  net/wireless/wext-compat.c |   39 +++++++++++++++++++++--
  15 files changed, 176 insertions(+), 10 deletions(-)
  create mode 100644 net/mac80211/wapi.c
  create mode 100644 net/mac80211/wapi.h

diff --git a/include/linux/ieee80211.h b/include/linux/ieee80211.h
index 48363c3..bf86b0d 100644
--- a/include/linux/ieee80211.h
+++ b/include/linux/ieee80211.h
@@ -1395,6 +1395,7 @@ enum ieee80211_key_len {
  	WLAN_KEY_LEN_CCMP = 16,
  	WLAN_KEY_LEN_TKIP = 32,
  	WLAN_KEY_LEN_AES_CMAC = 16,
+	WLAN_KEY_LEN_SMS4 = 32,
  };

  /* Public action codes */
@@ -1551,12 +1552,14 @@ enum ieee80211_sa_query_action {
  #define WLAN_CIPHER_SUITE_CCMP		0x000FAC04
  #define WLAN_CIPHER_SUITE_WEP104	0x000FAC05
  #define WLAN_CIPHER_SUITE_AES_CMAC	0x000FAC06
+#define WLAN_CIPHER_SUITE_SMS4		0x000FAC07

  /* AKM suite selectors */
  #define WLAN_AKM_SUITE_8021X		0x000FAC01
  #define WLAN_AKM_SUITE_PSK		0x000FAC02
  #define WLAN_AKM_SUITE_SAE			0x000FAC08
  #define WLAN_AKM_SUITE_FT_OVER_SAE	0x000FAC09
+#define WLAN_AKM_SUITE_WAPI_PSK		0x000FAC03

  #define WLAN_MAX_KEY_LEN		32

diff --git a/include/linux/nl80211.h b/include/linux/nl80211.h
index 9d797f2..be125a5 100644
--- a/include/linux/nl80211.h
+++ b/include/linux/nl80211.h
@@ -1379,8 +1379,8 @@ enum nl80211_attrs {
  #define NL80211_TKIP_DATA_OFFSET_RX_MIC_KEY	24
  #define NL80211_HT_CAPABILITY_LEN		26

-#define NL80211_MAX_NR_CIPHER_SUITES		5
-#define NL80211_MAX_NR_AKM_SUITES		2
+#define NL80211_MAX_NR_CIPHER_SUITES		6
+#define NL80211_MAX_NR_AKM_SUITES		3

  /**
   * enum nl80211_iftype - (virtual) interface types
@@ -2207,6 +2207,7 @@ enum nl80211_mfp {
  enum nl80211_wpa_versions {
  	NL80211_WPA_VERSION_1 = 1 << 0,
  	NL80211_WPA_VERSION_2 = 1 << 1,
+	NL80211_WAPI_VERSION_1 = 1 << 2,
  };

  /**
diff --git a/include/linux/wireless.h b/include/linux/wireless.h
index 4395b28..f3e2375 100644
--- a/include/linux/wireless.h
+++ b/include/linux/wireless.h
@@ -586,6 +586,7 @@
  #define IW_AUTH_WPA_VERSION_DISABLED	0x00000001
  #define IW_AUTH_WPA_VERSION_WPA		0x00000002
  #define IW_AUTH_WPA_VERSION_WPA2	0x00000004
+#define IW_AUTH_WPA_VERSION_WAPI	0x00000008

  /* IW_AUTH_PAIRWISE_CIPHER, IW_AUTH_GROUP_CIPHER, and  
IW_AUTH_CIPHER_GROUP_MGMT
   * values (bit field) */
@@ -595,10 +596,12 @@
  #define IW_AUTH_CIPHER_CCMP	0x00000008
  #define IW_AUTH_CIPHER_WEP104	0x00000010
  #define IW_AUTH_CIPHER_AES_CMAC	0x00000020
+#define IW_AUTH_CIPHER_SMS4	0x00000040

  /* IW_AUTH_KEY_MGMT values (bit field) */
  #define IW_AUTH_KEY_MGMT_802_1X	1
  #define IW_AUTH_KEY_MGMT_PSK	2
+#define IW_AUTH_KEY_MGMT_WAPI_PSK	4

  /* IW_AUTH_80211_AUTH_ALG values (bit field) */
  #define IW_AUTH_ALG_OPEN_SYSTEM	0x00000001
@@ -624,6 +627,7 @@
  #define IW_ENCODE_ALG_CCMP	3
  #define IW_ENCODE_ALG_PMK	4
  #define IW_ENCODE_ALG_AES_CMAC	5
+#define IW_ENCODE_ALG_SMS4	6
  /* struct iw_encode_ext ->ext_flags */
  #define IW_ENCODE_EXT_TX_SEQ_VALID	0x00000001
  #define IW_ENCODE_EXT_RX_SEQ_VALID	0x00000002
@@ -644,6 +648,8 @@
  #define IW_ENC_CAPA_CIPHER_TKIP	0x00000004
  #define IW_ENC_CAPA_CIPHER_CCMP	0x00000008
  #define IW_ENC_CAPA_4WAY_HANDSHAKE	0x00000010
+#define IW_ENC_CAPA_WAPI		0x00000020
+#define IW_ENC_CAPA_CIPHER_SMS4		0x00000040

  /* Event capability macros - in (struct iw_range *)->event_capa
   * Because we have more than 32 possible events, we use an array of
diff --git a/net/mac80211/Makefile b/net/mac80211/Makefile
index fdb54e6..ed3dd35 100644
--- a/net/mac80211/Makefile
+++ b/net/mac80211/Makefile
@@ -6,6 +6,7 @@ mac80211-y := \
  	sta_info.o \
  	wep.o \
  	wpa.o \
+	wapi.o \
  	scan.o offchannel.o \
  	ht.o agg-tx.o agg-rx.o \
  	ibss.o \
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 46fbf7f..1eaa7b3 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -42,7 +42,7 @@ struct ieee80211_local;
  #define TOTAL_MAX_TX_BUFFER 512

  /* Required encryption head and tailroom */
-#define IEEE80211_ENCRYPT_HEADROOM 8
+#define IEEE80211_ENCRYPT_HEADROOM 20
  #define IEEE80211_ENCRYPT_TAILROOM 18

  /* IEEE 802.11 (Ch. 9.5 Defragmentation) requires support for concurrent
diff --git a/net/mac80211/key.c b/net/mac80211/key.c
index e8ff846..91f0141 100644
--- a/net/mac80211/key.c
+++ b/net/mac80211/key.c
@@ -413,6 +413,10 @@ struct ieee80211_key *ieee80211_key_alloc(u32 cipher,  
int idx, size_t key_len,
  			return ERR_PTR(err);
  		}
  		break;
+	case WLAN_CIPHER_SUITE_SMS4:
+		key->conf.iv_len = WAPI_IV_LEN;
+		key->conf.icv_len = WAPI_ICV_LEN;
+		break;
  	}
  	memcpy(key->conf.key, key_data, key_len);
  	INIT_LIST_HEAD(&key->list);
diff --git a/net/mac80211/key.h b/net/mac80211/key.h
index 7d4e31f..455f1fe 100644
--- a/net/mac80211/key.h
+++ b/net/mac80211/key.h
@@ -29,6 +29,8 @@
  #define TKIP_IV_LEN		8
  #define TKIP_ICV_LEN		4
  #define CMAC_PN_LEN		6
+#define WAPI_IV_LEN		18
+#define WAPI_ICV_LEN		16

  #define NUM_RX_DATA_QUEUES	16

diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index 163226e..b9b9765 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -716,6 +716,7 @@ int ieee80211_register_hw(struct ieee80211_hw *hw)
  		WLAN_CIPHER_SUITE_WEP104,
  		WLAN_CIPHER_SUITE_TKIP,
  		WLAN_CIPHER_SUITE_CCMP,
+		WLAN_CIPHER_SUITE_SMS4,

  		/* keep last -- depends on hw flags! */
  		WLAN_CIPHER_SUITE_AES_CMAC
diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index 8bd8683..6cc9800 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -28,6 +28,7 @@
  #include "wpa.h"
  #include "tkip.h"
  #include "wme.h"
+#include "wapi.h"

  /*
   * monitor mode reception
@@ -1058,6 +1059,9 @@ ieee80211_rx_h_decrypt(struct ieee80211_rx_data *rx)
  	case WLAN_CIPHER_SUITE_AES_CMAC:
  		result = ieee80211_crypto_aes_cmac_decrypt(rx);
  		break;
+	case WLAN_CIPHER_SUITE_SMS4:
+		result = ieee80211_crypto_wapi_decrypt(rx);
+		break;
  	default:
  		/*
  		 * We can reach here only with HW-only algorithms
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index e2cdd6e..64ca6c1 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -31,6 +31,7 @@
  #include "mesh.h"
  #include "wep.h"
  #include "wpa.h"
+#include "wapi.h"
  #include "wme.h"
  #include "rate.h"

@@ -592,6 +593,11 @@ ieee80211_tx_h_select_key(struct ieee80211_tx_data  
*tx)
  			if (!ieee80211_is_mgmt(hdr->frame_control))
  				tx->key = NULL;
  			break;
+
+		case WLAN_CIPHER_SUITE_SMS4:
+			if (tx->ethertype == ETH_P_WAPI)
+				tx->key = NULL;
+			break;
  		}

  		if (unlikely(tx->key && tx->key->flags & KEY_FLAG_TAINTED))
diff --git a/net/mac80211/wapi.c b/net/mac80211/wapi.c
new file mode 100644
index 0000000..4780808
--- /dev/null
+++ b/net/mac80211/wapi.c
@@ -0,0 +1,71 @@
+/*
+ * Software WAPI encryption implementation
+ * Copyright (c) 2011, ST-Ericsson
+ * Author: Janusz Dziedzic <janusz.dziedzic@tieto.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/netdevice.h>
+#include <linux/types.h>
+#include <linux/random.h>
+#include <linux/compiler.h>
+#include <linux/crc32.h>
+#include <linux/crypto.h>
+#include <linux/err.h>
+#include <linux/mm.h>
+#include <linux/scatterlist.h>
+#include <linux/slab.h>
+#include <asm/unaligned.h>
+
+#include <net/mac80211.h>
+#include "ieee80211_i.h"
+#include "wapi.h"
+
+
+static int ieee80211_wapi_decrypt(struct ieee80211_local *local,
+				  struct sk_buff *skb,
+				  struct ieee80211_key *key)
+{
+	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)skb->data;
+	int hdrlen = ieee80211_hdrlen(hdr->frame_control);
+	struct ieee80211_rx_status *status = IEEE80211_SKB_RXCB(skb);
+	int data_len;
+
+	if (!(status->flag & RX_FLAG_DECRYPTED)) {
+		/* TODO - SMS4 decryption for firmware without
+		 * SMS4 support */
+		return RX_DROP_UNUSABLE;
+	}
+
+
+	data_len = skb->len - hdrlen - WAPI_IV_LEN - WAPI_ICV_LEN;
+	if (data_len < 0)
+		return RX_DROP_UNUSABLE;
+
+	/* Trim ICV */
+	skb_trim(skb, skb->len - WAPI_ICV_LEN);
+
+	/* Remove IV */
+	memmove(skb->data + WAPI_IV_LEN, skb->data, hdrlen);
+	skb_pull(skb, WAPI_IV_LEN);
+
+	return RX_CONTINUE;
+}
+
+ieee80211_rx_result
+ieee80211_crypto_wapi_decrypt(struct ieee80211_rx_data *rx)
+{
+	struct sk_buff *skb = rx->skb;
+	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)skb->data;
+
+	if (!ieee80211_is_data(hdr->frame_control))
+		return RX_CONTINUE;
+
+	if (ieee80211_wapi_decrypt(rx->local, rx->skb, rx->key))
+		return RX_DROP_UNUSABLE;
+
+	return RX_CONTINUE;
+}
diff --git a/net/mac80211/wapi.h b/net/mac80211/wapi.h
new file mode 100644
index 0000000..f06eee0
--- /dev/null
+++ b/net/mac80211/wapi.h
@@ -0,0 +1,27 @@
+/*
+ * Software WAPI encryption implementation
+ * Copyright (c) 2011, ST-Ericsson
+ * Author: Janusz Dziedzic <janusz.dziedzic@tieto.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#ifndef WAPI_H
+#define WAPI_H
+
+#include <linux/skbuff.h>
+#include <linux/types.h>
+#include "ieee80211_i.h"
+#include "key.h"
+
+#ifndef ETH_P_WAPI
+#define ETH_P_WAPI     0x88B4
+#endif
+
+
+ieee80211_rx_result
+ieee80211_crypto_wapi_decrypt(struct ieee80211_rx_data *rx);
+
+#endif /* WAPI_H */
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index fe059b1..4b7c1d4 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -98,7 +98,7 @@ static const struct nla_policy  
nl80211_policy[NL80211_ATTR_MAX+1] = {
  	[NL80211_ATTR_KEY_IDX] = { .type = NLA_U8 },
  	[NL80211_ATTR_KEY_CIPHER] = { .type = NLA_U32 },
  	[NL80211_ATTR_KEY_DEFAULT] = { .type = NLA_FLAG },
-	[NL80211_ATTR_KEY_SEQ] = { .type = NLA_BINARY, .len = 8 },
+	[NL80211_ATTR_KEY_SEQ] = { .type = NLA_BINARY, .len = 16 },
  	[NL80211_ATTR_KEY_TYPE] = { .type = NLA_U32 },

  	[NL80211_ATTR_BEACON_INTERVAL] = { .type = NLA_U32 },
@@ -204,7 +204,7 @@ static const struct nla_policy  
nl80211_key_policy[NL80211_KEY_MAX + 1] = {
  	[NL80211_KEY_DATA] = { .type = NLA_BINARY, .len = WLAN_MAX_KEY_LEN },
  	[NL80211_KEY_IDX] = { .type = NLA_U8 },
  	[NL80211_KEY_CIPHER] = { .type = NLA_U32 },
-	[NL80211_KEY_SEQ] = { .type = NLA_BINARY, .len = 8 },
+	[NL80211_KEY_SEQ] = { .type = NLA_BINARY, .len = 16 },
  	[NL80211_KEY_DEFAULT] = { .type = NLA_FLAG },
  	[NL80211_KEY_DEFAULT_MGMT] = { .type = NLA_FLAG },
  	[NL80211_KEY_TYPE] = { .type = NLA_U32 },
@@ -4167,7 +4167,8 @@ static bool nl80211_valid_auth_type(enum  
nl80211_auth_type auth_type)
  static bool nl80211_valid_wpa_versions(u32 wpa_versions)
  {
  	return !(wpa_versions & ~(NL80211_WPA_VERSION_1 |
-				  NL80211_WPA_VERSION_2));
+				  NL80211_WPA_VERSION_2 |
+				  NL80211_WAPI_VERSION_1));
  }

  static int nl80211_authenticate(struct sk_buff *skb, struct genl_info  
*info)
diff --git a/net/wireless/util.c b/net/wireless/util.c
index f5bd881..e0bd192 100644
--- a/net/wireless/util.c
+++ b/net/wireless/util.c
@@ -208,6 +208,10 @@ int cfg80211_validate_key_settings(struct  
cfg80211_registered_device *rdev,
  		if (params->key_len != WLAN_KEY_LEN_AES_CMAC)
  			return -EINVAL;
  		break;
+	case WLAN_CIPHER_SUITE_SMS4:
+		if (params->key_len != WLAN_KEY_LEN_SMS4)
+			return -EINVAL;
+		break;
  	default:
  		/*
  		 * We don't know anything about this algorithm,
@@ -231,6 +235,10 @@ int cfg80211_validate_key_settings(struct  
cfg80211_registered_device *rdev,
  			if (params->seq_len != 6)
  				return -EINVAL;
  			break;
+		case WLAN_CIPHER_SUITE_SMS4:
+			if (params->seq_len != 16)
+				return -EINVAL;
+			break;
  		}
  	}

diff --git a/net/wireless/wext-compat.c b/net/wireless/wext-compat.c
index 2aaca82..f63c7c4 100644
--- a/net/wireless/wext-compat.c
+++ b/net/wireless/wext-compat.c
@@ -216,6 +216,11 @@ int cfg80211_wext_giwrange(struct net_device *dev,
  			range->encoding_size[range->num_encoding_sizes++] =
  				WLAN_KEY_LEN_WEP104;
  			break;
+
+		case WLAN_CIPHER_SUITE_SMS4:
+			range->enc_capa |= (IW_ENC_CAPA_CIPHER_SMS4 |
+					    IW_ENC_CAPA_WAPI);
+			break;
  		}
  	}

@@ -699,6 +704,9 @@ static int cfg80211_wext_siwencodeext(struct  
net_device *dev,
  	case IW_ENCODE_ALG_AES_CMAC:
  		cipher = WLAN_CIPHER_SUITE_AES_CMAC;
  		break;
+	case IW_ENCODE_ALG_SMS4:
+		cipher = WLAN_CIPHER_SUITE_SMS4;
+		break;
  	default:
  		return -EOPNOTSUPP;
  	}
@@ -953,17 +961,21 @@ static int cfg80211_set_wpa_version(struct  
wireless_dev *wdev, u32 wpa_versions)
  {
  	if (wpa_versions & ~(IW_AUTH_WPA_VERSION_WPA |
  			     IW_AUTH_WPA_VERSION_WPA2|
+			     IW_AUTH_WPA_VERSION_WAPI|
  		             IW_AUTH_WPA_VERSION_DISABLED))
  		return -EINVAL;

  	if ((wpa_versions & IW_AUTH_WPA_VERSION_DISABLED) &&
  	    (wpa_versions & (IW_AUTH_WPA_VERSION_WPA|
-			     IW_AUTH_WPA_VERSION_WPA2)))
+			     IW_AUTH_WPA_VERSION_WPA2|
+			     IW_AUTH_WPA_VERSION_WAPI)))
  		return -EINVAL;

  	if (wpa_versions & IW_AUTH_WPA_VERSION_DISABLED)
  		wdev->wext.connect.crypto.wpa_versions &=
-			~(NL80211_WPA_VERSION_1|NL80211_WPA_VERSION_2);
+			~(NL80211_WPA_VERSION_1|
+			  NL80211_WPA_VERSION_2|
+			  NL80211_WAPI_VERSION_1);

  	if (wpa_versions & IW_AUTH_WPA_VERSION_WPA)
  		wdev->wext.connect.crypto.wpa_versions |=
@@ -973,6 +985,10 @@ static int cfg80211_set_wpa_version(struct  
wireless_dev *wdev, u32 wpa_versions)
  		wdev->wext.connect.crypto.wpa_versions |=
  			NL80211_WPA_VERSION_2;

+	if (wpa_versions & IW_AUTH_WPA_VERSION_WAPI)
+		wdev->wext.connect.crypto.wpa_versions |=
+			NL80211_WAPI_VERSION_1;
+
  	return 0;
  }

@@ -995,6 +1011,9 @@ static int cfg80211_set_cipher_group(struct  
wireless_dev *wdev, u32 cipher)
  			WLAN_CIPHER_SUITE_AES_CMAC;
  	else if (cipher & IW_AUTH_CIPHER_NONE)
  		wdev->wext.connect.crypto.cipher_group = 0;
+	else if (cipher & IW_AUTH_CIPHER_SMS4)
+		wdev->wext.connect.crypto.cipher_group =
+			WLAN_CIPHER_SUITE_SMS4;
  	else
  		return -EINVAL;

@@ -1031,7 +1050,12 @@ static int cfg80211_set_cipher_pairwise(struct  
wireless_dev *wdev, u32 cipher)
  		nr_ciphers++;
  	}

-	BUILD_BUG_ON(NL80211_MAX_NR_CIPHER_SUITES < 5);
+	if (cipher & IW_AUTH_CIPHER_SMS4) {
+		ciphers_pairwise[nr_ciphers] = WLAN_CIPHER_SUITE_SMS4;
+		nr_ciphers++;
+	}
+
+	BUILD_BUG_ON(NL80211_MAX_NR_CIPHER_SUITES < 6);

  	wdev->wext.connect.crypto.n_ciphers_pairwise = nr_ciphers;

@@ -1044,7 +1068,8 @@ static int cfg80211_set_key_mgt(struct wireless_dev  
*wdev, u32 key_mgt)
  	int nr_akm_suites = 0;

  	if (key_mgt & ~(IW_AUTH_KEY_MGMT_802_1X |
-			IW_AUTH_KEY_MGMT_PSK))
+			IW_AUTH_KEY_MGMT_PSK |
+			IW_AUTH_KEY_MGMT_WAPI_PSK))
  		return -EINVAL;

  	if (key_mgt & IW_AUTH_KEY_MGMT_802_1X) {
@@ -1059,6 +1084,12 @@ static int cfg80211_set_key_mgt(struct wireless_dev  
*wdev, u32 key_mgt)
  		nr_akm_suites++;
  	}

+	if (key_mgt & IW_AUTH_KEY_MGMT_WAPI_PSK) {
+		wdev->wext.connect.crypto.akm_suites[nr_akm_suites] =
+			WLAN_AKM_SUITE_WAPI_PSK;
+		nr_akm_suites++;
+	}
+
  	wdev->wext.connect.crypto.n_akm_suites = nr_akm_suites;

  	return 0;
-- 
1.7.1

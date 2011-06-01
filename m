Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:2405 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758861Ab1FALqk (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Jun 2011 07:46:40 -0400
From: "Roland Vossen" <rvossen@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Subject: [PATCH 81/83] staging: brcm80211: removed keys.h
Date: Wed, 1 Jun 2011 13:46:06 +0200
Message-ID: <1306928768-7501-81-git-send-email-rvossen@broadcom.com> (sfid-20110601_134750_570022_4ED47E3A)
In-Reply-To: <1306928768-7501-1-git-send-email-rvossen@broadcom.com>
References: <1306928768-7501-1-git-send-email-rvossen@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Code cleanup. Moved used definitions into main.h

Signed-off-by: Roland Vossen <rvossen@broadcom.com>
Reviewed-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/staging/brcm80211/brcmsmac/alloc.c       |    1 -
 drivers/staging/brcm80211/brcmsmac/ampdu.c       |    1 -
 drivers/staging/brcm80211/brcmsmac/antsel.c      |    1 -
 drivers/staging/brcm80211/brcmsmac/bottom_mac.c  |    1 -
 drivers/staging/brcm80211/brcmsmac/channel.c     |    1 -
 drivers/staging/brcm80211/brcmsmac/key.h         |  142 ----------------------
 drivers/staging/brcm80211/brcmsmac/mac80211_if.c |    1 -
 drivers/staging/brcm80211/brcmsmac/main.c        |    3 -
 drivers/staging/brcm80211/brcmsmac/main.h        |   43 +++++++
 drivers/staging/brcm80211/brcmsmac/phy_shim.c    |    1 -
 drivers/staging/brcm80211/brcmsmac/stf.c         |    1 -
 11 files changed, 43 insertions(+), 153 deletions(-)
 delete mode 100644 drivers/staging/brcm80211/brcmsmac/key.h

diff --git a/drivers/staging/brcm80211/brcmsmac/alloc.c b/drivers/staging/brcm80211/brcmsmac/alloc.c
index e5573bc..a884ae4 100644
--- a/drivers/staging/brcm80211/brcmsmac/alloc.c
+++ b/drivers/staging/brcm80211/brcmsmac/alloc.c
@@ -25,7 +25,6 @@
 #include "types.h"
 #include "scb.h"
 #include "pub.h"
-#include "key.h"
 #include "alloc.h"
 #include "rate.h"
 #include "phy/phy_hal.h"
diff --git a/drivers/staging/brcm80211/brcmsmac/ampdu.c b/drivers/staging/brcm80211/brcmsmac/ampdu.c
index 38662ab..7cf0018 100644
--- a/drivers/staging/brcm80211/brcmsmac/ampdu.c
+++ b/drivers/staging/brcm80211/brcmsmac/ampdu.c
@@ -26,7 +26,6 @@
 #include "rate.h"
 #include "scb.h"
 #include "pub.h"
-#include "key.h"
 #include "phy/phy_hal.h"
 #include "antsel.h"
 #include "channel.h"
diff --git a/drivers/staging/brcm80211/brcmsmac/antsel.c b/drivers/staging/brcm80211/brcmsmac/antsel.c
index fbe8e0b..fdac211 100644
--- a/drivers/staging/brcm80211/brcmsmac/antsel.c
+++ b/drivers/staging/brcm80211/brcmsmac/antsel.c
@@ -26,7 +26,6 @@
 
 #include "d11.h"
 #include "rate.h"
-#include "key.h"
 #include "scb.h"
 #include "pub.h"
 #include "phy/phy_hal.h"
diff --git a/drivers/staging/brcm80211/brcmsmac/bottom_mac.c b/drivers/staging/brcm80211/brcmsmac/bottom_mac.c
index da6a2a3..8a99bb1 100644
--- a/drivers/staging/brcm80211/brcmsmac/bottom_mac.c
+++ b/drivers/staging/brcm80211/brcmsmac/bottom_mac.c
@@ -38,7 +38,6 @@
 #include "rate.h"
 #include "scb.h"
 #include "pub.h"
-#include "key.h"
 #include "phy/phy_hal.h"
 #include "channel.h"
 #include "main.h"
diff --git a/drivers/staging/brcm80211/brcmsmac/channel.c b/drivers/staging/brcm80211/brcmsmac/channel.c
index ffeaedf..b172320 100644
--- a/drivers/staging/brcm80211/brcmsmac/channel.c
+++ b/drivers/staging/brcm80211/brcmsmac/channel.c
@@ -28,7 +28,6 @@
 #include "d11.h"
 #include "scb.h"
 #include "pub.h"
-#include "key.h"
 #include "phy/phy_hal.h"
 #include "bottom_mac.h"
 #include "rate.h"
diff --git a/drivers/staging/brcm80211/brcmsmac/key.h b/drivers/staging/brcm80211/brcmsmac/key.h
deleted file mode 100644
index ecfe969..0000000
--- a/drivers/staging/brcm80211/brcmsmac/key.h
+++ /dev/null
@@ -1,142 +0,0 @@
-/*
- * Copyright (c) 2010 Broadcom Corporation
- *
- * Permission to use, copy, modify, and/or distribute this software for any
- * purpose with or without fee is hereby granted, provided that the above
- * copyright notice and this permission notice appear in all copies.
- *
- * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
- * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
- * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY
- * SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
- * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN ACTION
- * OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF OR IN
- * CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
- */
-
-#ifndef _BRCM_KEY_H_
-#define _BRCM_KEY_H_
-
-#include <linux/if_ether.h>	/* for ETH_ALEN */
-
-struct scb;
-struct wlc_info;
-struct wlc_bsscfg;
-/* Maximum # of keys that wl driver supports in S/W.
- * Keys supported in H/W is less than or equal to WSEC_MAX_KEYS.
- */
-#define WSEC_MAX_KEYS		54	/* Max # of keys (50 + 4 default keys) */
-#define WLC_DEFAULT_KEYS	4	/* Default # of keys */
-
-#define WSEC_MAX_WOWL_KEYS 5	/* Max keys in WOWL mode (1 + 4 default keys) */
-
-#define WPA2_GTK_MAX	3
-
-/*
-* Max # of keys currently supported:
-*
-*     s/w keys if WSEC_SW(wlc->wsec).
-*     h/w keys otherwise.
-*/
-#define WLC_MAX_WSEC_KEYS(wlc) WSEC_MAX_KEYS
-
-/* number of 802.11 default (non-paired, group keys) */
-#define WSEC_MAX_DEFAULT_KEYS	4	/* # of default keys */
-
-/* Max # of hardware keys supported */
-#define WLC_MAX_WSEC_HW_KEYS(wlc) WSEC_MAX_RCMTA_KEYS
-
-/* Max # of hardware TKIP MIC keys supported */
-#define WLC_MAX_TKMIC_HW_KEYS(wlc) (WSEC_MAX_TKMIC_ENGINE_KEYS)
-
-#define WSEC_HW_TKMIC_KEY(wlc, key, bsscfg) \
-	((((wlc)->machwcap & MCAP_TKIPMIC)) && \
-	 (key) && ((key)->algo == CRYPTO_ALGO_TKIP) && \
-	 !WSEC_SOFTKEY(wlc, key, bsscfg) && \
-	WSEC_KEY_INDEX(wlc, key) >= WLC_DEFAULT_KEYS && \
-	(WSEC_KEY_INDEX(wlc, key) < WSEC_MAX_TKMIC_ENGINE_KEYS))
-
-/* index of key in key table */
-#define WSEC_KEY_INDEX(wlc, key)	((key)->idx)
-
-#define WSEC_SOFTKEY(wlc, key, bsscfg) (WLC_SW_KEYS(wlc, bsscfg) || \
-	WSEC_KEY_INDEX(wlc, key) >= WLC_MAX_WSEC_HW_KEYS(wlc))
-
-/* get a key, non-NULL only if key allocated and not clear */
-#define WSEC_KEY(wlc, i)	(((wlc)->wsec_keys[i] && (wlc)->wsec_keys[i]->len) ? \
-	(wlc)->wsec_keys[i] : NULL)
-
-#define WSEC_SCB_KEY_VALID(scb)	(((scb)->key && (scb)->key->len) ? true : false)
-
-/* default key */
-#define WSEC_BSS_DEFAULT_KEY(bsscfg) (((bsscfg)->wsec_index == -1) ? \
-	(struct wsec_key *)NULL:(bsscfg)->bss_def_keys[(bsscfg)->wsec_index])
-
-/* Macros for key management in IBSS mode */
-#define WSEC_IBSS_MAX_PEERS	16	/* Max # of IBSS Peers */
-#define WSEC_IBSS_RCMTA_INDEX(idx) \
-	(((idx - WSEC_MAX_DEFAULT_KEYS) % WSEC_IBSS_MAX_PEERS) + WSEC_MAX_DEFAULT_KEYS)
-
-/* contiguous # key slots for infrastructure mode STA */
-#define WSEC_BSS_STA_KEY_GROUP_SIZE	5
-
-typedef struct wsec_iv {
-	u32 hi;		/* upper 32 bits of IV */
-	u16 lo;		/* lower 16 bits of IV */
-} wsec_iv_t;
-
-#define WLC_NUMRXIVS	16	/* # rx IVs (one per 802.11e TID) */
-
-typedef struct wsec_key {
-	u8 ea[ETH_ALEN];	/* per station */
-	u8 idx;		/* key index in wsec_keys array */
-	u8 id;		/* key ID [0-3] */
-	u8 algo;		/* CRYPTO_ALGO_AES_CCM, CRYPTO_ALGO_WEP128, etc */
-	u8 rcmta;		/* rcmta entry index, same as idx by default */
-	u16 flags;		/* misc flags */
-	u8 algo_hw;		/* cache for hw register */
-	u8 aes_mode;		/* cache for hw register */
-	s8 iv_len;		/* IV length */
-	s8 icv_len;		/* ICV length */
-	u32 len;		/* key length..don't move this var */
-	/* data is 4byte aligned */
-	u8 data[WLAN_MAX_KEY_LEN];	/* key data */
-	wsec_iv_t rxiv[WLC_NUMRXIVS];	/* Rx IV (one per TID) */
-	wsec_iv_t txiv;		/* Tx IV */
-
-} wsec_key_t;
-
-#define broken_roundup(x, y) ((((x) + ((y) - 1)) / (y)) * (y))
-
-/* For use with wsec_key_t.flags */
-
-#define WSEC_BS_UPDATE		(1 << 0)	/* Indicates hw needs key update on BS switch */
-#define WSEC_PRIMARY_KEY	(1 << 1)	/* Indicates this key is the primary (ie tx) key */
-#define WSEC_TKIP_ERROR		(1 << 2)	/* Provoke deliberate MIC error */
-#define WSEC_REPLAY_ERROR	(1 << 3)	/* Provoke deliberate replay */
-#define WSEC_IBSS_PEER_GROUP_KEY	(1 << 7)	/* Flag: group key for a IBSS PEER */
-#define WSEC_ICV_ERROR		(1 << 8)	/* Provoke deliberate ICV error */
-
-#define wlc_key_insert(a, b, c, d, e, f, g, h, i, j) (-EBADE)
-#define wlc_key_update(a, b, c) do {} while (0)
-#define wlc_key_remove(a, b, c) do {} while (0)
-#define wlc_key_remove_all(a, b) do {} while (0)
-#define wlc_key_delete(a, b, c) do {} while (0)
-#define wlc_scb_key_delete(a, b) do {} while (0)
-#define wlc_key_lookup(a, b, c, d, e) (NULL)
-#define wlc_key_hw_init_all(a) do {} while (0)
-#define wlc_key_hw_init(a, b, c)  do {} while (0)
-#define wlc_key_hw_wowl_init(a, b, c, d) do {} while (0)
-#define wlc_key_sw_wowl_update(a, b, c, d, e) do {} while (0)
-#define wlc_key_sw_wowl_create(a, b, c) (-EBADE)
-#define wlc_key_iv_update(a, b, c, d, e) do {(void)e; } while (0)
-#define wlc_key_iv_init(a, b, c) do {} while (0)
-#define wlc_key_set_error(a, b, c) (-EBADE)
-#define wlc_key_dump_hw(a, b) (-EBADE)
-#define wlc_key_dump_sw(a, b) (-EBADE)
-#define wlc_key_defkeyflag(a) (0)
-#define wlc_rcmta_add_bssid(a, b) do {} while (0)
-#define wlc_rcmta_del_bssid(a, b) do {} while (0)
-#define wlc_key_scb_delete(a, b) do {} while (0)
-
-#endif				/* _BRCM_KEY_H_ */
diff --git a/drivers/staging/brcm80211/brcmsmac/mac80211_if.c b/drivers/staging/brcm80211/brcmsmac/mac80211_if.c
index e85a456..78f8348 100644
--- a/drivers/staging/brcm80211/brcmsmac/mac80211_if.c
+++ b/drivers/staging/brcm80211/brcmsmac/mac80211_if.c
@@ -34,7 +34,6 @@
 #include "phy/phy_int.h"
 #include "d11.h"
 #include "types.h"
-#include "key.h"
 #include "channel.h"
 #include "scb.h"
 #include "pub.h"
diff --git a/drivers/staging/brcm80211/brcmsmac/main.c b/drivers/staging/brcm80211/brcmsmac/main.c
index e2ea9b4..cfd04ca 100644
--- a/drivers/staging/brcm80211/brcmsmac/main.c
+++ b/drivers/staging/brcm80211/brcmsmac/main.c
@@ -33,7 +33,6 @@
 #include "rate.h"
 #include "scb.h"
 #include "pub.h"
-#include "key.h"
 #include "phy/phy_hal.h"
 #include "channel.h"
 #include "main.h"
@@ -521,8 +520,6 @@ void wlc_init(struct wlc_info *wlc)
 		}
 	}
 
-	wlc_key_hw_init_all(wlc);
-
 	wlc_bandinit_ordered(wlc, chanspec);
 
 	wlc_init_scb(wlc, &global_scb);
diff --git a/drivers/staging/brcm80211/brcmsmac/main.h b/drivers/staging/brcm80211/brcmsmac/main.h
index 201c644..c41205a 100644
--- a/drivers/staging/brcm80211/brcmsmac/main.h
+++ b/drivers/staging/brcm80211/brcmsmac/main.h
@@ -297,6 +297,49 @@ struct wlc_stf {
 #define WLC_HT_WEP_RESTRICT	0x01	/* restrict HT with WEP */
 #define WLC_HT_TKIP_RESTRICT	0x02	/* restrict HT with TKIP */
 
+/* Maximum # of keys that wl driver supports in S/W.
+ * Keys supported in H/W is less than or equal to WSEC_MAX_KEYS.
+ */
+#define WSEC_MAX_KEYS		54	/* Max # of keys (50 + 4 default keys) */
+#define WLC_DEFAULT_KEYS	4	/* Default # of keys */
+
+/*
+* Max # of keys currently supported:
+*
+*     s/w keys if WSEC_SW(wlc->wsec).
+*     h/w keys otherwise.
+*/
+#define WLC_MAX_WSEC_KEYS(wlc) WSEC_MAX_KEYS
+
+/* number of 802.11 default (non-paired, group keys) */
+#define WSEC_MAX_DEFAULT_KEYS	4	/* # of default keys */
+
+typedef struct wsec_iv {
+	u32 hi;		/* upper 32 bits of IV */
+	u16 lo;		/* lower 16 bits of IV */
+} wsec_iv_t;
+
+#define WLC_NUMRXIVS	16	/* # rx IVs (one per 802.11e TID) */
+
+typedef struct wsec_key {
+	u8 ea[ETH_ALEN];	/* per station */
+	u8 idx;		/* key index in wsec_keys array */
+	u8 id;		/* key ID [0-3] */
+	u8 algo;		/* CRYPTO_ALGO_AES_CCM, CRYPTO_ALGO_WEP128, etc */
+	u8 rcmta;		/* rcmta entry index, same as idx by default */
+	u16 flags;		/* misc flags */
+	u8 algo_hw;		/* cache for hw register */
+	u8 aes_mode;		/* cache for hw register */
+	s8 iv_len;		/* IV length */
+	s8 icv_len;		/* ICV length */
+	u32 len;		/* key length..don't move this var */
+	/* data is 4byte aligned */
+	u8 data[WLAN_MAX_KEY_LEN];	/* key data */
+	wsec_iv_t rxiv[WLC_NUMRXIVS];	/* Rx IV (one per TID) */
+	wsec_iv_t txiv;		/* Tx IV */
+
+} wsec_key_t;
+
 /*
  * core state (mac)
  */
diff --git a/drivers/staging/brcm80211/brcmsmac/phy_shim.c b/drivers/staging/brcm80211/brcmsmac/phy_shim.c
index d8dec65..925edeb 100644
--- a/drivers/staging/brcm80211/brcmsmac/phy_shim.c
+++ b/drivers/staging/brcm80211/brcmsmac/phy_shim.c
@@ -40,7 +40,6 @@
 #include "phy/phy_hal.h"
 #include "channel.h"
 #include "srom.h"
-#include "key.h"
 #include "bottom_mac.h"
 #include "phy_hal.h"
 #include "main.h"
diff --git a/drivers/staging/brcm80211/brcmsmac/stf.c b/drivers/staging/brcm80211/brcmsmac/stf.c
index 9b0f335..561aba8 100644
--- a/drivers/staging/brcm80211/brcmsmac/stf.c
+++ b/drivers/staging/brcm80211/brcmsmac/stf.c
@@ -28,7 +28,6 @@
 #include "rate.h"
 #include "scb.h"
 #include "pub.h"
-#include "key.h"
 #include "phy/phy_hal.h"
 #include "channel.h"
 #include "main.h"
-- 
1.7.4.1



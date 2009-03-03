Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 128-177-27-249.ip.openhosting.com ([128.177.27.249]:35417 "EHLO
	jmalinen.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754708AbZCCRYy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Mar 2009 12:24:54 -0500
Message-Id: <20090303172445.555151927@atheros.com> (sfid-20090303_182456_271260_9D14867B)
References: <20090303172325.437810138@atheros.com>
Date: Tue, 03 Mar 2009 19:23:27 +0200
From: Jouni Malinen <jouni.malinen@atheros.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org,
	Jouni Malinen <jouni.malinen@atheros.com>
Subject: [PATCH 02/15] ath9k: Set BSSID mask based on configured interfaces
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Instead of using a hardcoded BSSID mask (mask for own addresses),
iterate through all active interfaces and determine the minimal mask
that covers all local addresses.

Signed-off-by: Jouni Malinen <jouni.malinen@atheros.com>

---
 drivers/net/wireless/ath9k/Makefile  |    1 
 drivers/net/wireless/ath9k/ath9k.h   |   14 +----
 drivers/net/wireless/ath9k/main.c    |   15 ++++-
 drivers/net/wireless/ath9k/virtual.c |   88 +++++++++++++++++++++++++++++++++++
 4 files changed, 103 insertions(+), 15 deletions(-)

--- wireless-testing.orig/drivers/net/wireless/ath9k/main.c	2009-03-03 18:29:02.000000000 +0200
+++ wireless-testing/drivers/net/wireless/ath9k/main.c	2009-03-03 18:30:22.000000000 +0200
@@ -1512,11 +1512,8 @@ static int ath_init(u16 devid, struct at
 	ath9k_hw_setcapability(ah, ATH9K_CAP_DIVERSITY, 1, true, NULL);
 	sc->rx.defant = ath9k_hw_getdefantenna(ah);
 
-	if (ah->caps.hw_caps & ATH9K_HW_CAP_BSSIDMASK) {
+	if (ah->caps.hw_caps & ATH9K_HW_CAP_BSSIDMASK)
 		memcpy(sc->bssidmask, ath_bcast_mac, ETH_ALEN);
-		ATH_SET_VIF_BSSID_MASK(sc->bssidmask);
-		ath9k_hw_setbssidmask(sc);
-	}
 
 	sc->beacon.slottime = ATH9K_SLOT_TIME_9;	/* default to short slot time */
 
@@ -2126,6 +2123,12 @@ static int ath9k_add_interface(struct ie
 
 	mutex_lock(&sc->mutex);
 
+	if (!(sc->sc_ah->caps.hw_caps & ATH9K_HW_CAP_BSSIDMASK) &&
+	    sc->nvifs > 0) {
+		ret = -ENOBUFS;
+		goto out;
+	}
+
 	switch (conf->type) {
 	case NL80211_IFTYPE_STATION:
 		ic_opmode = NL80211_IFTYPE_STATION;
@@ -2158,6 +2161,10 @@ static int ath9k_add_interface(struct ie
 	avp->av_bslot = -1;
 
 	sc->nvifs++;
+
+	if (sc->sc_ah->caps.hw_caps & ATH9K_HW_CAP_BSSIDMASK)
+		ath9k_set_bssid_mask(hw);
+
 	if (sc->nvifs > 1)
 		goto out; /* skip global settings for secondary vif */
 
--- wireless-testing.orig/drivers/net/wireless/ath9k/ath9k.h	2009-03-03 18:29:02.000000000 +0200
+++ wireless-testing/drivers/net/wireless/ath9k/ath9k.h	2009-03-03 18:30:22.000000000 +0200
@@ -387,17 +387,6 @@ void ath_tx_aggr_resume(struct ath_softc
 /* VIFs */
 /********/
 
-/*
- * Define the scheme that we select MAC address for multiple
- * BSS on the same radio. The very first VIF will just use the MAC
- * address from the EEPROM. For the next 3 VIFs, we set the
- * U/L bit (bit 1) in MAC address, and use the next two bits as the
- * index of the VIF.
- */
-
-#define ATH_SET_VIF_BSSID_MASK(bssid_mask) \
-	((bssid_mask)[0] &= ~(((ATH_BCBUF-1)<<2)|0x02))
-
 struct ath_vif {
 	int av_bslot;
 	enum nl80211_iftype av_opmode;
@@ -675,4 +664,7 @@ static inline void ath9k_ps_restore(stru
 					  sc->sc_ah->restore_mode);
 }
 
+
+void ath9k_set_bssid_mask(struct ieee80211_hw *hw);
+
 #endif /* ATH9K_H */
--- wireless-testing.orig/drivers/net/wireless/ath9k/Makefile	2009-02-27 10:53:01.000000000 +0200
+++ wireless-testing/drivers/net/wireless/ath9k/Makefile	2009-03-03 18:30:22.000000000 +0200
@@ -9,6 +9,7 @@ ath9k-y +=	hw.o \
 		main.o \
 		recv.o \
 		xmit.o \
+		virtual.o \
 		rc.o
 
 ath9k-$(CONFIG_PCI) += pci.o
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ wireless-testing/drivers/net/wireless/ath9k/virtual.c	2009-03-03 18:30:22.000000000 +0200
@@ -0,0 +1,88 @@
+/*
+ * Copyright (c) 2008-2009 Atheros Communications Inc.
+ *
+ * Permission to use, copy, modify, and/or distribute this software for any
+ * purpose with or without fee is hereby granted, provided that the above
+ * copyright notice and this permission notice appear in all copies.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
+ * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
+ * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
+ * ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
+ * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
+ * ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
+ * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
+ */
+
+#include "ath9k.h"
+
+struct ath9k_vif_iter_data {
+	int count;
+	u8 *addr;
+};
+
+static void ath9k_vif_iter(void *data, u8 *mac, struct ieee80211_vif *vif)
+{
+	struct ath9k_vif_iter_data *iter_data = data;
+	u8 *nbuf;
+
+	nbuf = krealloc(iter_data->addr, (iter_data->count + 1) * ETH_ALEN,
+			GFP_ATOMIC);
+	if (nbuf == NULL)
+		return;
+
+	memcpy(nbuf + iter_data->count * ETH_ALEN, mac, ETH_ALEN);
+	iter_data->addr = nbuf;
+	iter_data->count++;
+}
+
+void ath9k_set_bssid_mask(struct ieee80211_hw *hw)
+{
+	struct ath_softc *sc = hw->priv;
+	struct ath9k_vif_iter_data iter_data;
+	int i, j;
+	u8 mask[ETH_ALEN];
+
+	/*
+	 * Add primary MAC address even if it is not in active use since it
+	 * will be configured to the hardware as the starting point and the
+	 * BSSID mask will need to be changed if another address is active.
+	 */
+	iter_data.addr = kmalloc(ETH_ALEN, GFP_ATOMIC);
+	if (iter_data.addr) {
+		memcpy(iter_data.addr, sc->sc_ah->macaddr, ETH_ALEN);
+		iter_data.count = 1;
+	} else
+		iter_data.count = 0;
+
+	/* Get list of all active MAC addresses */
+	ieee80211_iterate_active_interfaces_atomic(hw, ath9k_vif_iter,
+						   &iter_data);
+
+	/* Generate an address mask to cover all active addresses */
+	memset(mask, 0, ETH_ALEN);
+	for (i = 0; i < iter_data.count; i++) {
+		u8 *a1 = iter_data.addr + i * ETH_ALEN;
+		for (j = i + 1; j < iter_data.count; j++) {
+			u8 *a2 = iter_data.addr + j * ETH_ALEN;
+			mask[0] |= a1[0] ^ a2[0];
+			mask[1] |= a1[1] ^ a2[1];
+			mask[2] |= a1[2] ^ a2[2];
+			mask[3] |= a1[3] ^ a2[3];
+			mask[4] |= a1[4] ^ a2[4];
+			mask[5] |= a1[5] ^ a2[5];
+		}
+	}
+
+	kfree(iter_data.addr);
+
+	/* Invert the mask and configure hardware */
+	sc->bssidmask[0] = ~mask[0];
+	sc->bssidmask[1] = ~mask[1];
+	sc->bssidmask[2] = ~mask[2];
+	sc->bssidmask[3] = ~mask[3];
+	sc->bssidmask[4] = ~mask[4];
+	sc->bssidmask[5] = ~mask[5];
+
+	ath9k_hw_setbssidmask(sc);
+}

-- 

-- 
Jouni Malinen                                            PGP id EFC895FA

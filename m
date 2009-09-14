Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:43431 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751946AbZINIcB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Sep 2009 04:32:01 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, devel@linuxdriverproject.org,
	ath9k-devel@lists.ath9k.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH v2 4/4] atheros: define shared bssidmask setting
Date: Mon, 14 Sep 2009 04:32:03 -0400
Message-Id: <1252917123-11559-5-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1252917123-11559-1-git-send-email-lrodriguez@atheros.com>
References: <1252917123-11559-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Also make ath5k and ath9k use it, and share register definitions.

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/net/wireless/ath/Makefile         |    5 +-
 drivers/net/wireless/ath/ath.h            |    3 +
 drivers/net/wireless/ath/ath5k/ath5k.h    |    2 +-
 drivers/net/wireless/ath/ath5k/attach.c   |    2 +-
 drivers/net/wireless/ath/ath5k/base.c     |    1 +
 drivers/net/wireless/ath/ath5k/initvals.c |    4 +-
 drivers/net/wireless/ath/ath5k/pcu.c      |  121 ++--------------------------
 drivers/net/wireless/ath/ath5k/reg.h      |    8 +--
 drivers/net/wireless/ath/ath9k/hw.c       |   10 +--
 drivers/net/wireless/ath/ath9k/main.c     |    1 +
 drivers/net/wireless/ath/ath9k/recv.c     |    2 +-
 drivers/net/wireless/ath/ath9k/reg.h      |    5 +-
 drivers/net/wireless/ath/ath9k/virtual.c  |    2 +-
 drivers/net/wireless/ath/hw.c             |  126 +++++++++++++++++++++++++++++
 drivers/net/wireless/ath/reg.h            |   27 ++++++
 15 files changed, 179 insertions(+), 140 deletions(-)
 create mode 100644 drivers/net/wireless/ath/hw.c
 create mode 100644 drivers/net/wireless/ath/reg.h

diff --git a/drivers/net/wireless/ath/Makefile b/drivers/net/wireless/ath/Makefile
index 4bb0132..6ebf214 100644
--- a/drivers/net/wireless/ath/Makefile
+++ b/drivers/net/wireless/ath/Makefile
@@ -3,4 +3,7 @@ obj-$(CONFIG_ATH9K)		+= ath9k/
 obj-$(CONFIG_AR9170_USB)        += ar9170/
 
 obj-$(CONFIG_ATH_COMMON)	+= ath.o
-ath-objs 		:= main.o regd.o
+
+ath-objs :=	main.o \
+		regd.o \
+		hw.o
diff --git a/drivers/net/wireless/ath/ath.h b/drivers/net/wireless/ath/ath.h
index be68cb8..0582ee4 100644
--- a/drivers/net/wireless/ath/ath.h
+++ b/drivers/net/wireless/ath/ath.h
@@ -45,6 +45,7 @@ struct ath_ops {
 };
 
 struct ath_common {
+	void *ah;
 	u16 cachelsz;
 	u16 curaid;
 	u8 macaddr[ETH_ALEN];
@@ -58,4 +59,6 @@ struct sk_buff *ath_rxbuf_alloc(struct ath_common *common,
 				u32 len,
 				gfp_t gfp_mask);
 
+void ath_hw_setbssidmask(struct ath_common *common);
+
 #endif /* ATH_H */
diff --git a/drivers/net/wireless/ath/ath5k/ath5k.h b/drivers/net/wireless/ath/ath5k/ath5k.h
index 1416562..43585d5 100644
--- a/drivers/net/wireless/ath/ath5k/ath5k.h
+++ b/drivers/net/wireless/ath/ath5k/ath5k.h
@@ -1192,7 +1192,7 @@ extern int ath5k_hw_set_opmode(struct ath5k_hw *ah);
 /* BSSID Functions */
 extern int ath5k_hw_set_lladdr(struct ath5k_hw *ah, const u8 *mac);
 extern void ath5k_hw_set_associd(struct ath5k_hw *ah, const u8 *bssid, u16 assoc_id);
-extern int ath5k_hw_set_bssid_mask(struct ath5k_hw *ah, const u8 *mask);
+extern void ath5k_hw_set_bssid_mask(struct ath5k_hw *ah, const u8 *mask);
 /* Receive start/stop functions */
 extern void ath5k_hw_start_rx_pcu(struct ath5k_hw *ah);
 extern void ath5k_hw_stop_rx_pcu(struct ath5k_hw *ah);
diff --git a/drivers/net/wireless/ath/ath5k/attach.c b/drivers/net/wireless/ath/ath5k/attach.c
index c0840ab..e230de8 100644
--- a/drivers/net/wireless/ath/ath5k/attach.c
+++ b/drivers/net/wireless/ath/ath5k/attach.c
@@ -104,7 +104,7 @@ static int ath5k_hw_post(struct ath5k_hw *ah)
 int ath5k_hw_attach(struct ath5k_softc *sc)
 {
 	struct ath5k_hw *ah = sc->ah;
-	struct ath_common *common;
+	struct ath_common *common = ath5k_hw_common(ah);
 	struct pci_dev *pdev = sc->pdev;
 	struct ath5k_eeprom_info *ee;
 	int ret;
diff --git a/drivers/net/wireless/ath/ath5k/base.c b/drivers/net/wireless/ath/ath5k/base.c
index c78ad55..25a0a73 100644
--- a/drivers/net/wireless/ath/ath5k/base.c
+++ b/drivers/net/wireless/ath/ath5k/base.c
@@ -593,6 +593,7 @@ ath5k_pci_probe(struct pci_dev *pdev,
 	sc->ah->ah_iobase = sc->iobase;
 	common = ath5k_hw_common(sc->ah);
 	common->ops = &ath5k_common_ops;
+	common->ah = sc->ah;
 	common->cachelsz = csz << 2; /* convert to bytes */
 
 	/* Initialize device */
diff --git a/drivers/net/wireless/ath/ath5k/initvals.c b/drivers/net/wireless/ath/ath5k/initvals.c
index 18eb519..8fa4393 100644
--- a/drivers/net/wireless/ath/ath5k/initvals.c
+++ b/drivers/net/wireless/ath/ath5k/initvals.c
@@ -560,8 +560,8 @@ static const struct ath5k_ini ar5212_ini_common_start[] = {
 	{ AR5K_SLEEP0,		0x0002aaaa },
 	{ AR5K_SLEEP1,		0x02005555 },
 	{ AR5K_SLEEP2,		0x00000000 },
-	{ AR5K_BSS_IDM0,	0xffffffff },
-	{ AR5K_BSS_IDM1,	0x0000ffff },
+	{ AR_BSSMSKL,		0xffffffff },
+	{ AR_BSSMSKU,		0x0000ffff },
 	{ AR5K_TXPC,		0x00000000 },
 	{ AR5K_PROFCNT_TX,	0x00000000 },
 	{ AR5K_PROFCNT_RX,	0x00000000 },
diff --git a/drivers/net/wireless/ath/ath5k/pcu.c b/drivers/net/wireless/ath/ath5k/pcu.c
index f03c06d..9ac7638 100644
--- a/drivers/net/wireless/ath/ath5k/pcu.c
+++ b/drivers/net/wireless/ath/ath5k/pcu.c
@@ -290,10 +290,10 @@ void ath5k_hw_set_associd(struct ath5k_hw *ah, const u8 *bssid, u16 assoc_id)
 	 */
 	if (ah->ah_version == AR5K_AR5212) {
 		ath5k_hw_reg_write(ah, get_unaligned_le32(common->bssidmask),
-							AR5K_BSS_IDM0);
+				   AR_BSSMSKL);
 		ath5k_hw_reg_write(ah,
 				   get_unaligned_le16(common->curbssid + 4),
-				   AR5K_BSS_IDM1);
+				   AR_BSSMSKU);
 	}
 
 	/*
@@ -301,9 +301,9 @@ void ath5k_hw_set_associd(struct ath5k_hw *ah, const u8 *bssid, u16 assoc_id)
 	 */
 	low_id = get_unaligned_le32(bssid);
 	high_id = get_unaligned_le16(bssid);
-	ath5k_hw_reg_write(ah, low_id, AR5K_BSS_ID0);
+	ath5k_hw_reg_write(ah, low_id, AR_BSSMSKL);
 	ath5k_hw_reg_write(ah, high_id | ((assoc_id & 0x3fff) <<
-				AR5K_BSS_ID1_AID_S), AR5K_BSS_ID1);
+				AR5K_BSS_ID1_AID_S), AR_BSSMSKU);
 
 	if (assoc_id == 0) {
 		ath5k_hw_disable_pspoll(ah);
@@ -316,125 +316,18 @@ void ath5k_hw_set_associd(struct ath5k_hw *ah, const u8 *bssid, u16 assoc_id)
 	ath5k_hw_enable_pspoll(ah, NULL, 0);
 }
 
-/**
- * ath5k_hw_set_bssid_mask - filter out bssids we listen
- *
- * @ah: the &struct ath5k_hw
- * @mask: the bssid_mask, a u8 array of size ETH_ALEN
- *
- * BSSID masking is a method used by AR5212 and newer hardware to inform PCU
- * which bits of the interface's MAC address should be looked at when trying
- * to decide which packets to ACK. In station mode and AP mode with a single
- * BSS every bit matters since we lock to only one BSS. In AP mode with
- * multiple BSSes (virtual interfaces) not every bit matters because hw must
- * accept frames for all BSSes and so we tweak some bits of our mac address
- * in order to have multiple BSSes.
- *
- * NOTE: This is a simple filter and does *not* filter out all
- * relevant frames. Some frames that are not for us might get ACKed from us
- * by PCU because they just match the mask.
- *
- * When handling multiple BSSes you can get the BSSID mask by computing the
- * set of  ~ ( MAC XOR BSSID ) for all bssids we handle.
- *
- * When you do this you are essentially computing the common bits of all your
- * BSSes. Later it is assumed the harware will "and" (&) the BSSID mask with
- * the MAC address to obtain the relevant bits and compare the result with
- * (frame's BSSID & mask) to see if they match.
- */
-/*
- * Simple example: on your card you have have two BSSes you have created with
- * BSSID-01 and BSSID-02. Lets assume BSSID-01 will not use the MAC address.
- * There is another BSSID-03 but you are not part of it. For simplicity's sake,
- * assuming only 4 bits for a mac address and for BSSIDs you can then have:
- *
- *                  \
- * MAC:        0001 |
- * BSSID-01:   0100 | --> Belongs to us
- * BSSID-02:   1001 |
- *                  /
- * -------------------
- * BSSID-03:   0110  | --> External
- * -------------------
- *
- * Our bssid_mask would then be:
- *
- *             On loop iteration for BSSID-01:
- *             ~(0001 ^ 0100)  -> ~(0101)
- *                             ->   1010
- *             bssid_mask      =    1010
- *
- *             On loop iteration for BSSID-02:
- *             bssid_mask &= ~(0001   ^   1001)
- *             bssid_mask =   (1010)  & ~(0001 ^ 1001)
- *             bssid_mask =   (1010)  & ~(1001)
- *             bssid_mask =   (1010)  &  (0110)
- *             bssid_mask =   0010
- *
- * A bssid_mask of 0010 means "only pay attention to the second least
- * significant bit". This is because its the only bit common
- * amongst the MAC and all BSSIDs we support. To findout what the real
- * common bit is we can simply "&" the bssid_mask now with any BSSID we have
- * or our MAC address (we assume the hardware uses the MAC address).
- *
- * Now, suppose there's an incoming frame for BSSID-03:
- *
- * IFRAME-01:  0110
- *
- * An easy eye-inspeciton of this already should tell you that this frame
- * will not pass our check. This is beacuse the bssid_mask tells the
- * hardware to only look at the second least significant bit and the
- * common bit amongst the MAC and BSSIDs is 0, this frame has the 2nd LSB
- * as 1, which does not match 0.
- *
- * So with IFRAME-01 we *assume* the hardware will do:
- *
- *     allow = (IFRAME-01 & bssid_mask) == (bssid_mask & MAC) ? 1 : 0;
- *  --> allow = (0110 & 0010) == (0010 & 0001) ? 1 : 0;
- *  --> allow = (0010) == 0000 ? 1 : 0;
- *  --> allow = 0
- *
- *  Lets now test a frame that should work:
- *
- * IFRAME-02:  0001 (we should allow)
- *
- *     allow = (0001 & 1010) == 1010
- *
- *     allow = (IFRAME-02 & bssid_mask) == (bssid_mask & MAC) ? 1 : 0;
- *  --> allow = (0001 & 0010) ==  (0010 & 0001) ? 1 :0;
- *  --> allow = (0010) == (0010)
- *  --> allow = 1
- *
- * Other examples:
- *
- * IFRAME-03:  0100 --> allowed
- * IFRAME-04:  1001 --> allowed
- * IFRAME-05:  1101 --> allowed but its not for us!!!
- *
- */
-int ath5k_hw_set_bssid_mask(struct ath5k_hw *ah, const u8 *mask)
+void ath5k_hw_set_bssid_mask(struct ath5k_hw *ah, const u8 *mask)
 {
 	struct ath_common *common = ath5k_hw_common(ah);
-	u32 low_id, high_id;
 	ATH5K_TRACE(ah->ah_sc);
 
 	/* Cache bssid mask so that we can restore it
 	 * on reset */
 	memcpy(common->bssidmask, mask, ETH_ALEN);
-	if (ah->ah_version == AR5K_AR5212) {
-		low_id = get_unaligned_le32(mask);
-		high_id = get_unaligned_le16(mask + 4);
-
-		ath5k_hw_reg_write(ah, low_id, AR5K_BSS_IDM0);
-		ath5k_hw_reg_write(ah, high_id, AR5K_BSS_IDM1);
-
-		return 0;
-	}
-
-	return -EIO;
+	if (ah->ah_version == AR5K_AR5212)
+		ath_hw_setbssidmask(common);
 }
 
-
 /************\
 * RX Control *
 \************/
diff --git a/drivers/net/wireless/ath/ath5k/reg.h b/drivers/net/wireless/ath/ath5k/reg.h
index debad07..725acc4 100644
--- a/drivers/net/wireless/ath/ath5k/reg.h
+++ b/drivers/net/wireless/ath/ath5k/reg.h
@@ -35,7 +35,7 @@
  * released by Atheros and on various debug messages found on the net.
  */
 
-
+#include "../reg.h"
 
 /*====MAC DMA REGISTERS====*/
 
@@ -1650,12 +1650,6 @@
 #define AR5K_SLEEP2_DTIM_PER_S		16
 
 /*
- * BSSID mask registers
- */
-#define AR5K_BSS_IDM0			0x80e0	/* Upper bits */
-#define AR5K_BSS_IDM1			0x80e4	/* Lower bits */
-
-/*
  * TX power control (TPC) register
  *
  * XXX: PCDAC steps (0.5dbm) or DBM ?
diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index dabff52..80bfa18 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -2423,7 +2423,7 @@ int ath9k_hw_reset(struct ath_hw *ah, struct ath9k_channel *chan,
 		  | ah->sta_id1_defaults);
 	ath9k_hw_set_operating_mode(ah, ah->opmode);
 
-	ath9k_hw_setbssidmask(ah);
+	ath_hw_setbssidmask(common);
 
 	REG_WRITE(ah, AR_DEF_ANTENNA, saveDefAntenna);
 
@@ -3950,14 +3950,6 @@ void ath9k_hw_setmcastfilter(struct ath_hw *ah, u32 filter0, u32 filter1)
 	REG_WRITE(ah, AR_MCAST_FIL1, filter1);
 }
 
-void ath9k_hw_setbssidmask(struct ath_hw *ah)
-{
-	struct ath_common *common = ath9k_hw_common(ah);
-
-	REG_WRITE(ah, AR_BSSMSKL, get_unaligned_le32(common->bssidmask));
-	REG_WRITE(ah, AR_BSSMSKU, get_unaligned_le16(common->bssidmask + 4));
-}
-
 void ath9k_hw_write_associd(struct ath_hw *ah)
 {
 	struct ath_common *common = ath9k_hw_common(ah);
diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index 54d067c..3d5d597 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -1574,6 +1574,7 @@ static int ath_init_softc(u16 devid, struct ath_softc *sc, u16 subsysid)
 
 	common = ath9k_hw_common(ah);
 	common->ops = &ath9k_common_ops;
+	common->ah = ah;
 
 	/*
 	 * Cache line size is used to size and align various
diff --git a/drivers/net/wireless/ath/ath9k/recv.c b/drivers/net/wireless/ath/ath9k/recv.c
index 97a5efe..fb635a0 100644
--- a/drivers/net/wireless/ath/ath9k/recv.c
+++ b/drivers/net/wireless/ath/ath9k/recv.c
@@ -282,7 +282,7 @@ static void ath_opmode_init(struct ath_softc *sc)
 
 	/* configure bssid mask */
 	if (ah->caps.hw_caps & ATH9K_HW_CAP_BSSIDMASK)
-		ath9k_hw_setbssidmask(ah);
+		ath_hw_setbssidmask(common);
 
 	/* configure operational mode */
 	ath9k_hw_setopmode(ah);
diff --git a/drivers/net/wireless/ath/ath9k/reg.h b/drivers/net/wireless/ath/ath9k/reg.h
index e5c29eb..ce12252 100644
--- a/drivers/net/wireless/ath/ath9k/reg.h
+++ b/drivers/net/wireless/ath/ath9k/reg.h
@@ -17,6 +17,8 @@
 #ifndef REG_H
 #define REG_H
 
+#include "../reg.h"
+
 #define AR_CR                0x0008
 #define AR_CR_RXE            0x00000004
 #define AR_CR_RXD            0x00000020
@@ -1420,9 +1422,6 @@ enum {
 #define AR_SLEEP2_BEACON_TIMEOUT    0xFFE00000
 #define AR_SLEEP2_BEACON_TIMEOUT_S  21
 
-#define AR_BSSMSKL            0x80e0
-#define AR_BSSMSKU            0x80e4
-
 #define AR_TPC                 0x80e8
 #define AR_TPC_ACK             0x0000003f
 #define AR_TPC_ACK_S           0x00
diff --git a/drivers/net/wireless/ath/ath9k/virtual.c b/drivers/net/wireless/ath/ath9k/virtual.c
index 7b763b6..bc7d173 100644
--- a/drivers/net/wireless/ath/ath9k/virtual.c
+++ b/drivers/net/wireless/ath/ath9k/virtual.c
@@ -94,7 +94,7 @@ void ath9k_set_bssid_mask(struct ieee80211_hw *hw)
 	common->bssidmask[4] = ~mask[4];
 	common->bssidmask[5] = ~mask[5];
 
-	ath9k_hw_setbssidmask(sc->sc_ah);
+	ath_hw_setbssidmask(common);
 }
 
 int ath9k_wiphy_add(struct ath_softc *sc)
diff --git a/drivers/net/wireless/ath/hw.c b/drivers/net/wireless/ath/hw.c
new file mode 100644
index 0000000..ecc9eb0
--- /dev/null
+++ b/drivers/net/wireless/ath/hw.c
@@ -0,0 +1,126 @@
+/*
+ * Copyright (c) 2009 Atheros Communications Inc.
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
+#include <asm/unaligned.h>
+
+#include "ath.h"
+#include "reg.h"
+
+#define REG_READ	common->ops->read
+#define REG_WRITE	common->ops->write
+
+/**
+ * ath_hw_set_bssid_mask - filter out bssids we listen
+ *
+ * @common: the ath_common struct for the device.
+ *
+ * BSSID masking is a method used by AR5212 and newer hardware to inform PCU
+ * which bits of the interface's MAC address should be looked at when trying
+ * to decide which packets to ACK. In station mode and AP mode with a single
+ * BSS every bit matters since we lock to only one BSS. In AP mode with
+ * multiple BSSes (virtual interfaces) not every bit matters because hw must
+ * accept frames for all BSSes and so we tweak some bits of our mac address
+ * in order to have multiple BSSes.
+ *
+ * NOTE: This is a simple filter and does *not* filter out all
+ * relevant frames. Some frames that are not for us might get ACKed from us
+ * by PCU because they just match the mask.
+ *
+ * When handling multiple BSSes you can get the BSSID mask by computing the
+ * set of  ~ ( MAC XOR BSSID ) for all bssids we handle.
+ *
+ * When you do this you are essentially computing the common bits of all your
+ * BSSes. Later it is assumed the harware will "and" (&) the BSSID mask with
+ * the MAC address to obtain the relevant bits and compare the result with
+ * (frame's BSSID & mask) to see if they match.
+ *
+ * Simple example: on your card you have have two BSSes you have created with
+ * BSSID-01 and BSSID-02. Lets assume BSSID-01 will not use the MAC address.
+ * There is another BSSID-03 but you are not part of it. For simplicity's sake,
+ * assuming only 4 bits for a mac address and for BSSIDs you can then have:
+ *
+ *                  \
+ * MAC:        0001 |
+ * BSSID-01:   0100 | --> Belongs to us
+ * BSSID-02:   1001 |
+ *                  /
+ * -------------------
+ * BSSID-03:   0110  | --> External
+ * -------------------
+ *
+ * Our bssid_mask would then be:
+ *
+ *             On loop iteration for BSSID-01:
+ *             ~(0001 ^ 0100)  -> ~(0101)
+ *                             ->   1010
+ *             bssid_mask      =    1010
+ *
+ *             On loop iteration for BSSID-02:
+ *             bssid_mask &= ~(0001   ^   1001)
+ *             bssid_mask =   (1010)  & ~(0001 ^ 1001)
+ *             bssid_mask =   (1010)  & ~(1001)
+ *             bssid_mask =   (1010)  &  (0110)
+ *             bssid_mask =   0010
+ *
+ * A bssid_mask of 0010 means "only pay attention to the second least
+ * significant bit". This is because its the only bit common
+ * amongst the MAC and all BSSIDs we support. To findout what the real
+ * common bit is we can simply "&" the bssid_mask now with any BSSID we have
+ * or our MAC address (we assume the hardware uses the MAC address).
+ *
+ * Now, suppose there's an incoming frame for BSSID-03:
+ *
+ * IFRAME-01:  0110
+ *
+ * An easy eye-inspeciton of this already should tell you that this frame
+ * will not pass our check. This is beacuse the bssid_mask tells the
+ * hardware to only look at the second least significant bit and the
+ * common bit amongst the MAC and BSSIDs is 0, this frame has the 2nd LSB
+ * as 1, which does not match 0.
+ *
+ * So with IFRAME-01 we *assume* the hardware will do:
+ *
+ *     allow = (IFRAME-01 & bssid_mask) == (bssid_mask & MAC) ? 1 : 0;
+ *  --> allow = (0110 & 0010) == (0010 & 0001) ? 1 : 0;
+ *  --> allow = (0010) == 0000 ? 1 : 0;
+ *  --> allow = 0
+ *
+ *  Lets now test a frame that should work:
+ *
+ * IFRAME-02:  0001 (we should allow)
+ *
+ *     allow = (0001 & 1010) == 1010
+ *
+ *     allow = (IFRAME-02 & bssid_mask) == (bssid_mask & MAC) ? 1 : 0;
+ *  --> allow = (0001 & 0010) ==  (0010 & 0001) ? 1 :0;
+ *  --> allow = (0010) == (0010)
+ *  --> allow = 1
+ *
+ * Other examples:
+ *
+ * IFRAME-03:  0100 --> allowed
+ * IFRAME-04:  1001 --> allowed
+ * IFRAME-05:  1101 --> allowed but its not for us!!!
+ *
+ */
+void ath_hw_setbssidmask(struct ath_common *common)
+{
+	void *ah = common->ah;
+
+	REG_WRITE(ah, get_unaligned_le32(common->bssidmask), AR_BSSMSKL);
+	REG_WRITE(ah, get_unaligned_le16(common->bssidmask + 4), AR_BSSMSKU);
+}
+EXPORT_SYMBOL(ath_hw_setbssidmask);
diff --git a/drivers/net/wireless/ath/reg.h b/drivers/net/wireless/ath/reg.h
new file mode 100644
index 0000000..dfe1fbe
--- /dev/null
+++ b/drivers/net/wireless/ath/reg.h
@@ -0,0 +1,27 @@
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
+#ifndef ATH_REGISTERS_H
+#define ATH_REGISTERS_H
+
+/*
+ * BSSID mask registers. See ath_hw_set_bssid_mask()
+ * for detailed documentation about these registers.
+ */
+#define AR_BSSMSKL		0x80e0
+#define AR_BSSMSKU		0x80e4
+
+#endif /* ATH_REGISTERS_H */
-- 
1.6.3.3


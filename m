Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:46852 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752213AbZHLQ5D (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Aug 2009 12:57:03 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Wed, 12 Aug 2009 09:57:04 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <ath9k-devel@lists.ath9k.org>,
	<ath5k-devel@lists.ath5k.org>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH 1/3] ath: add common ath_rxbuf_alloc() and make ath9k use it
Date: Wed, 12 Aug 2009 09:56:59 -0700
Message-ID: <1250096221-11000-2-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1250096221-11000-1-git-send-email-lrodriguez@atheros.com>
References: <1250096221-11000-1-git-send-email-lrodriguez@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Turns out ath5k and ath9k can share the same helper to
allocates RX skbs. We allocate skbs aligned to the cache line
size. This requirement seems to have come from AR5210; when
this was not done it seems sometimes we'd get bogus data. I'm
also told it may have been a performance enhancement
consideration. In the end I can't be sure we can remove this
on new hardware so just keep this and start sharing it through
ath.ko.

Make ath9k start using this, ath5k is next.

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/net/wireless/ath/Kconfig       |    4 +--
 drivers/net/wireless/ath/ath.h         |   30 ++++++++++++++++++++++++
 drivers/net/wireless/ath/ath9k/ath9k.h |    4 ++-
 drivers/net/wireless/ath/ath9k/main.c  |    2 +-
 drivers/net/wireless/ath/ath9k/recv.c  |   40 +++----------------------------
 drivers/net/wireless/ath/main.c        |   36 ++++++++++++++++++++++++++++
 6 files changed, 75 insertions(+), 41 deletions(-)
 create mode 100644 drivers/net/wireless/ath/ath.h

diff --git a/drivers/net/wireless/ath/Kconfig b/drivers/net/wireless/ath/Kconfig
index 253b95a..11ded15 100644
--- a/drivers/net/wireless/ath/Kconfig
+++ b/drivers/net/wireless/ath/Kconfig
@@ -5,9 +5,7 @@ menuconfig ATH_COMMON
 	---help---
 	  This will enable the support for the Atheros wireless drivers.
 	  ath5k, ath9k and ar9170 drivers share some common code, this option
-	  enables the common ath.ko module which currently shares just common
-	  regulatory EEPROM helpers but will likely be extended later to share
-	  more between modules.
+	  enables the common ath.ko module which shares common helpers.
 
 	  For more information and documentation on this module you can visit:
 
diff --git a/drivers/net/wireless/ath/ath.h b/drivers/net/wireless/ath/ath.h
new file mode 100644
index 0000000..e284cd3
--- /dev/null
+++ b/drivers/net/wireless/ath/ath.h
@@ -0,0 +1,30 @@
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
+#ifndef ATH_H
+#define ATH_H
+
+#include <linux/skbuff.h>
+
+struct ath_common {
+	u16 cachelsz;
+};
+
+struct sk_buff *ath_rxbuf_alloc(struct ath_common *common,
+				u32 len,
+				gfp_t gfp_mask);
+
+#endif /* ATH_H */
diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index 7a5a157..2fd663c 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -25,6 +25,7 @@
 #include "hw.h"
 #include "rc.h"
 #include "debug.h"
+#include "../ath.h"
 
 struct ath_node;
 
@@ -532,6 +533,8 @@ struct ath_softc {
 	struct ieee80211_hw *hw;
 	struct device *dev;
 
+	struct ath_common common;
+
 	spinlock_t wiphy_lock; /* spinlock to protect ath_wiphy data */
 	struct ath_wiphy *pri_wiphy;
 	struct ath_wiphy **sec_wiphy; /* secondary wiphys (virtual radios); may
@@ -564,7 +567,6 @@ struct ath_softc {
 	u32 sc_flags; /* SC_OP_* */
 	u16 curtxpow;
 	u16 curaid;
-	u16 cachelsz;
 	u8 nbcnvifs;
 	u16 nvifs;
 	u8 tx_chainmask;
diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index efe2e85..b29d0ff 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -1327,7 +1327,7 @@ static int ath_init_softc(u16 devid, struct ath_softc *sc)
 	 */
 	ath_read_cachesize(sc, &csz);
 	/* XXX assert csz is non-zero */
-	sc->cachelsz = csz << 2;	/* convert to bytes */
+	sc->common.cachelsz = csz << 2;	/* convert to bytes */
 
 	ah = kzalloc(sizeof(struct ath_hw), GFP_KERNEL);
 	if (!ah) {
diff --git a/drivers/net/wireless/ath/ath9k/recv.c b/drivers/net/wireless/ath/ath9k/recv.c
index 1a08c69..61dbdd2 100644
--- a/drivers/net/wireless/ath/ath9k/recv.c
+++ b/drivers/net/wireless/ath/ath9k/recv.c
@@ -100,38 +100,6 @@ static u64 ath_extend_tsf(struct ath_softc *sc, u32 rstamp)
 	return (tsf & ~0x7fff) | rstamp;
 }
 
-static struct sk_buff *ath_rxbuf_alloc(struct ath_softc *sc, u32 len, gfp_t gfp_mask)
-{
-	struct sk_buff *skb;
-	u32 off;
-
-	/*
-	 * Cache-line-align.  This is important (for the
-	 * 5210 at least) as not doing so causes bogus data
-	 * in rx'd frames.
-	 */
-
-	/* Note: the kernel can allocate a value greater than
-	 * what we ask it to give us. We really only need 4 KB as that
-	 * is this hardware supports and in fact we need at least 3849
-	 * as that is the MAX AMSDU size this hardware supports.
-	 * Unfortunately this means we may get 8 KB here from the
-	 * kernel... and that is actually what is observed on some
-	 * systems :( */
-	skb = __dev_alloc_skb(len + sc->cachelsz - 1, gfp_mask);
-	if (skb != NULL) {
-		off = ((unsigned long) skb->data) % sc->cachelsz;
-		if (off != 0)
-			skb_reserve(skb, sc->cachelsz - off);
-	} else {
-		DPRINTF(sc, ATH_DBG_FATAL,
-			"skbuff alloc of size %u failed\n", len);
-		return NULL;
-	}
-
-	return skb;
-}
-
 /*
  * For Decrypt or Demic errors, we only mark packet status here and always push
  * up the frame up to let mac80211 handle the actual error case, be it no
@@ -336,10 +304,10 @@ int ath_rx_init(struct ath_softc *sc, int nbufs)
 	spin_lock_init(&sc->rx.rxbuflock);
 
 	sc->rx.bufsize = roundup(IEEE80211_MAX_MPDU_LEN,
-				 min(sc->cachelsz, (u16)64));
+				 min(sc->common.cachelsz, (u16)64));
 
 	DPRINTF(sc, ATH_DBG_CONFIG, "cachelsz %u rxbufsize %u\n",
-		sc->cachelsz, sc->rx.bufsize);
+		sc->common.cachelsz, sc->rx.bufsize);
 
 	/* Initialize rx descriptors */
 
@@ -352,7 +320,7 @@ int ath_rx_init(struct ath_softc *sc, int nbufs)
 	}
 
 	list_for_each_entry(bf, &sc->rx.rxbuf, list) {
-		skb = ath_rxbuf_alloc(sc, sc->rx.bufsize, GFP_KERNEL);
+		skb = ath_rxbuf_alloc(&sc->common, sc->rx.bufsize, GFP_KERNEL);
 		if (skb == NULL) {
 			error = -ENOMEM;
 			goto err;
@@ -777,7 +745,7 @@ int ath_rx_tasklet(struct ath_softc *sc, int flush)
 
 		/* Ensure we always have an skb to requeue once we are done
 		 * processing the current buffer's skb */
-		requeue_skb = ath_rxbuf_alloc(sc, sc->rx.bufsize, GFP_ATOMIC);
+		requeue_skb = ath_rxbuf_alloc(&sc->common, sc->rx.bufsize, GFP_ATOMIC);
 
 		/* If there is no memory we ignore the current RX'd frame,
 		 * tell hardware it can give us a new frame using the old
diff --git a/drivers/net/wireless/ath/main.c b/drivers/net/wireless/ath/main.c
index 9949b11..487193f 100644
--- a/drivers/net/wireless/ath/main.c
+++ b/drivers/net/wireless/ath/main.c
@@ -17,6 +17,42 @@
 #include <linux/kernel.h>
 #include <linux/module.h>
 
+#include "ath.h"
+
 MODULE_AUTHOR("Atheros Communications");
 MODULE_DESCRIPTION("Shared library for Atheros wireless LAN cards.");
 MODULE_LICENSE("Dual BSD/GPL");
+
+struct sk_buff *ath_rxbuf_alloc(struct ath_common *common,
+				u32 len,
+				gfp_t gfp_mask)
+{
+	struct sk_buff *skb;
+	u32 off;
+
+	/*
+	 * Cache-line-align.  This is important (for the
+	 * 5210 at least) as not doing so causes bogus data
+	 * in rx'd frames.
+	 */
+
+	/* Note: the kernel can allocate a value greater than
+	 * what we ask it to give us. We really only need 4 KB as that
+	 * is this hardware supports and in fact we need at least 3849
+	 * as that is the MAX AMSDU size this hardware supports.
+	 * Unfortunately this means we may get 8 KB here from the
+	 * kernel... and that is actually what is observed on some
+	 * systems :( */
+	skb = __dev_alloc_skb(len + common->cachelsz - 1, gfp_mask);
+	if (skb != NULL) {
+		off = ((unsigned long) skb->data) % common->cachelsz;
+		if (off != 0)
+			skb_reserve(skb, common->cachelsz - off);
+	} else {
+		printk(KERN_ERR "skbuff alloc of size %u failed\n", len);
+		return NULL;
+	}
+
+	return skb;
+}
+EXPORT_SYMBOL(ath_rxbuf_alloc);
-- 
1.6.3.3


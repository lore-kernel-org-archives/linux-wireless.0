Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:54316 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758220AbZKDWO2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Nov 2009 17:14:28 -0500
Date: Wed, 4 Nov 2009 17:14:26 -0500
From: "Luis R. Rodriguez" <mcgrof@bombadil.infradead.org>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: Matthew Wilcox <matthew@wil.cx>,
	Nick Kossifidis <mickflemm@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	ath5k-devel@lists.ath5k.org,
	Stephen Hemminger <shemminger@vyatta.com>,
	Kyle McMartin <kyle@mcmartin.ca>
Subject: Re: pci_set_mwi() and ath5k
Message-ID: <20091104221426.GA2599@bombadil.infradead.org>
References: <43e72e890911041204n55b54f8iace79938b40baa32@mail.gmail.com> <40f31dec0911041212p16cfc78eia1ab1817e425e767@mail.gmail.com> <43e72e890911041330j581e7bacp4e7b83a11c1de0e8@mail.gmail.com> <43e72e890911041336n7ffae0d2u135321a588f3e613@mail.gmail.com> <43e72e890911041352i334e170at71a519383d48a08@mail.gmail.com> <43e72e890911041352n3a398b41h8927387c228661c5@mail.gmail.com> <20091104220034.GI10555@parisc-linux.org> <43e72e890911041404q5f491bbbw123d8761037f9c63@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <43e72e890911041404q5f491bbbw123d8761037f9c63@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Nov 04, 2009 at 02:04:11PM -0800, Luis R. Rodriguez wrote:
> On Wed, Nov 4, 2009 at 2:00 PM, Matthew Wilcox <matthew@wil.cx> wrote:
> > On Wed, Nov 04, 2009 at 01:52:30PM -0800, Luis R. Rodriguez wrote:
> >> > Even better: I just confirmation from our systems team that our legacy
> >> > devices and 11n PCI devices don't support MWR so I'll remove all that
> >> > cruft crap.
> >>
> >> I meant MWI of course.
> >
> > Yes, but they don't necessarily just use cacheline size for MWI ... some
> > devices use cacheline size for setting up data structures.  Might be
> > worth just checking explicitly that they don't use the cacheline size
> > register for anything.
> 
> Oh right -- so the typical Atheros hack for this is to check the cache
> line size, and if its 0 set it to L1_CACHE_BYTES. Then eventually read
> from PCI_CACHE_LINE_SIZE pci config to align the skb data. So what I
> was doing now is removing all this cruft and replacing it with a
> generic allocator for atheros drivers that aligns simply to the
> L1_CACHE_BYTES. Sound kosher?

Something like this:

 drivers/net/wireless/ath/ath.h         |    6 +-----
 drivers/net/wireless/ath/ath5k/base.c  |   27 +++------------------------
 drivers/net/wireless/ath/ath9k/ahb.c   |    8 --------
 drivers/net/wireless/ath/ath9k/ath9k.h |    5 -----
 drivers/net/wireless/ath/ath9k/main.c  |    9 ---------
 drivers/net/wireless/ath/ath9k/pci.c   |   20 --------------------
 drivers/net/wireless/ath/ath9k/recv.c  |   11 +++++------
 drivers/net/wireless/ath/main.c        |   27 +++++----------------------
 8 files changed, 14 insertions(+), 99 deletions(-)

diff --git a/drivers/net/wireless/ath/ath.h b/drivers/net/wireless/ath/ath.h
index 4af1362..438f46f 100644
--- a/drivers/net/wireless/ath/ath.h
+++ b/drivers/net/wireless/ath/ath.h
@@ -63,7 +63,6 @@ struct ath_ops {
 struct ath_common;
 
 struct ath_bus_ops {
-	void		(*read_cachesize)(struct ath_common *common, int *csz);
 	void		(*cleanup)(struct ath_common *common);
 	bool		(*eeprom_read)(struct ath_common *common, u32 off, u16 *data);
 	void		(*bt_coex_prep)(struct ath_common *common);
@@ -78,7 +77,6 @@ struct ath_common {
 
 	struct ath_ani ani;
 
-	u16 cachelsz;
 	u16 curaid;
 	u8 macaddr[ETH_ALEN];
 	u8 curbssid[ETH_ALEN];
@@ -94,9 +92,7 @@ struct ath_common {
 	const struct ath_bus_ops *bus_ops;
 };
 
-struct sk_buff *ath_rxbuf_alloc(struct ath_common *common,
-				u32 len,
-				gfp_t gfp_mask);
+struct sk_buff *ath_rxbuf_alloc(u32 len, gfp_t gfp_mask);
 
 void ath_hw_setbssidmask(struct ath_common *common);
 
diff --git a/drivers/net/wireless/ath/ath5k/base.c b/drivers/net/wireless/ath/ath5k/base.c
index c7fc13c..6943660 100644
--- a/drivers/net/wireless/ath/ath5k/base.c
+++ b/drivers/net/wireless/ath/ath5k/base.c
@@ -466,7 +466,6 @@ ath5k_pci_probe(struct pci_dev *pdev,
 	struct ath_common *common;
 	struct ieee80211_hw *hw;
 	int ret;
-	u8 csz;
 
 	ret = pci_enable_device(pdev);
 	if (ret) {
@@ -482,22 +481,6 @@ ath5k_pci_probe(struct pci_dev *pdev,
 	}
 
 	/*
-	 * Cache line size is used to size and align various
-	 * structures used to communicate with the hardware.
-	 */
-	pci_read_config_byte(pdev, PCI_CACHE_LINE_SIZE, &csz);
-	if (csz == 0) {
-		/*
-		 * Linux 2.4.18 (at least) writes the cache line size
-		 * register as a 16-bit wide register which is wrong.
-		 * We must have this setup properly for rx buffer
-		 * DMA to work so force a reasonable value here if it
-		 * comes up zero.
-		 */
-		csz = L1_CACHE_BYTES >> 2;
-		pci_write_config_byte(pdev, PCI_CACHE_LINE_SIZE, csz);
-	}
-	/*
 	 * The default setting of latency timer yields poor results,
 	 * set it to the value used by other systems.  It may be worth
 	 * tweaking this setting more.
@@ -598,7 +581,6 @@ ath5k_pci_probe(struct pci_dev *pdev,
 	common->ops = &ath5k_common_ops;
 	common->ah = sc->ah;
 	common->hw = hw;
-	common->cachelsz = csz << 2; /* convert to bytes */
 
 	/* Initialize device */
 	ret = ath5k_hw_attach(sc);
@@ -1184,9 +1166,7 @@ struct sk_buff *ath5k_rx_skb_alloc(struct ath5k_softc *sc, dma_addr_t *skb_addr)
 	 * Allocate buffer with headroom_needed space for the
 	 * fake physical layer header at the start.
 	 */
-	skb = ath_rxbuf_alloc(common,
-			      common->rx_bufsize,
-			      GFP_ATOMIC);
+	skb = ath_rxbuf_alloc(common->rx_bufsize, GFP_ATOMIC);
 
 	if (!skb) {
 		ATH5K_ERR(sc, "can't alloc skbuff of size %u\n",
@@ -1636,10 +1616,9 @@ ath5k_rx_start(struct ath5k_softc *sc)
 	struct ath5k_buf *bf;
 	int ret;
 
-	common->rx_bufsize = roundup(IEEE80211_MAX_LEN, common->cachelsz);
+	common->rx_bufsize = IEEE80211_MAX_LEN;
 
-	ATH5K_DBG(sc, ATH5K_DEBUG_RESET, "cachelsz %u rx_bufsize %u\n",
-		  common->cachelsz, common->rx_bufsize);
+	ATH5K_DBG(sc, ATH5K_DEBUG_RESET, "rx_bufsize %u\n", common->rx_bufsize);
 
 	spin_lock_bh(&sc->rxbuflock);
 	sc->rxlink = NULL;
diff --git a/drivers/net/wireless/ath/ath9k/ahb.c b/drivers/net/wireless/ath/ath9k/ahb.c
index 329e6bc..9949524 100644
--- a/drivers/net/wireless/ath/ath9k/ahb.c
+++ b/drivers/net/wireless/ath/ath9k/ahb.c
@@ -21,12 +21,6 @@
 #include <linux/ath9k_platform.h>
 #include "ath9k.h"
 
-/* return bus cachesize in 4B word units */
-static void ath_ahb_read_cachesize(struct ath_common *common, int *csz)
-{
-	*csz = L1_CACHE_BYTES >> 2;
-}
-
 static void ath_ahb_cleanup(struct ath_common *common)
 {
 	struct ath_softc *sc = (struct ath_softc *)common->priv;
@@ -53,9 +47,7 @@ static bool ath_ahb_eeprom_read(struct ath_common *common, u32 off, u16 *data)
 }
 
 static struct ath_bus_ops ath_ahb_bus_ops  = {
-	.read_cachesize = ath_ahb_read_cachesize,
 	.cleanup = ath_ahb_cleanup,
-
 	.eeprom_read = ath_ahb_eeprom_read,
 };
 
diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index 377b0ea..66d4a70 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -618,11 +618,6 @@ int ath_get_hal_qnum(u16 queue, struct ath_softc *sc);
 int ath_get_mac80211_qnum(u32 queue, struct ath_softc *sc);
 int ath_cabq_update(struct ath_softc *);
 
-static inline void ath_read_cachesize(struct ath_common *common, int *csz)
-{
-	common->bus_ops->read_cachesize(common, csz);
-}
-
 static inline void ath_bus_cleanup(struct ath_common *common)
 {
 	common->bus_ops->cleanup(common);
diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index 01ac897..af9c785 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -1624,7 +1624,6 @@ static int ath_init_softc(u16 devid, struct ath_softc *sc, u16 subsysid,
 	struct ath_hw *ah = NULL;
 	struct ath_common *common;
 	int r = 0, i;
-	int csz = 0;
 	int qnum;
 
 	/* XXX: hardware will not be ready until ath_open() being called */
@@ -1656,14 +1655,6 @@ static int ath_init_softc(u16 devid, struct ath_softc *sc, u16 subsysid,
 	common->priv = sc;
 	common->debug_mask = ath9k_debug;
 
-	/*
-	 * Cache line size is used to size and align various
-	 * structures used to communicate with the hardware.
-	 */
-	ath_read_cachesize(common, &csz);
-	/* XXX assert csz is non-zero */
-	common->cachelsz = csz << 2;	/* convert to bytes */
-
 	r = ath9k_hw_init(ah);
 	if (r) {
 		ath_print(common, ATH_DBG_FATAL,
diff --git a/drivers/net/wireless/ath/ath9k/pci.c b/drivers/net/wireless/ath/ath9k/pci.c
index 5321f73..b0f72e4 100644
--- a/drivers/net/wireless/ath/ath9k/pci.c
+++ b/drivers/net/wireless/ath/ath9k/pci.c
@@ -30,25 +30,6 @@ static struct pci_device_id ath_pci_id_table[] __devinitdata = {
 	{ 0 }
 };
 
-/* return bus cachesize in 4B word units */
-static void ath_pci_read_cachesize(struct ath_common *common, int *csz)
-{
-	struct ath_softc *sc = (struct ath_softc *) common->priv;
-	u8 u8tmp;
-
-	pci_read_config_byte(to_pci_dev(sc->dev), PCI_CACHE_LINE_SIZE, &u8tmp);
-	*csz = (int)u8tmp;
-
-	/*
-	 * This check was put in to avoid "unplesant" consequences if
-	 * the bootrom has not fully initialized all PCI devices.
-	 * Sometimes the cache line size register is not set
-	 */
-
-	if (*csz == 0)
-		*csz = DEFAULT_CACHELINE >> 2;   /* Use the default size */
-}
-
 static void ath_pci_cleanup(struct ath_common *common)
 {
 	struct ath_softc *sc = (struct ath_softc *) common->priv;
@@ -97,7 +78,6 @@ static void ath_pci_bt_coex_prep(struct ath_common *common)
 }
 
 const static struct ath_bus_ops ath_pci_bus_ops = {
-	.read_cachesize = ath_pci_read_cachesize,
 	.cleanup = ath_pci_cleanup,
 	.eeprom_read = ath_pci_eeprom_read,
 	.bt_coex_prep = ath_pci_bt_coex_prep,
diff --git a/drivers/net/wireless/ath/ath9k/recv.c b/drivers/net/wireless/ath/ath9k/recv.c
index 36d23ef..341ff0a 100644
--- a/drivers/net/wireless/ath/ath9k/recv.c
+++ b/drivers/net/wireless/ath/ath9k/recv.c
@@ -346,11 +346,10 @@ int ath_rx_init(struct ath_softc *sc, int nbufs)
 	sc->sc_flags &= ~SC_OP_RXFLUSH;
 	spin_lock_init(&sc->rx.rxbuflock);
 
-	common->rx_bufsize = roundup(IEEE80211_MAX_MPDU_LEN,
-				     min(common->cachelsz, (u16)64));
+	common->rx_bufsize = IEEE80211_MAX_MPDU_LEN;
 
-	ath_print(common, ATH_DBG_CONFIG, "cachelsz %u rxbufsize %u\n",
-		  common->cachelsz, common->rx_bufsize);
+	ath_print(common, ATH_DBG_CONFIG, "rx_bufsize %u\n",
+		  common->rx_bufsize);
 
 	/* Initialize rx descriptors */
 
@@ -363,7 +362,7 @@ int ath_rx_init(struct ath_softc *sc, int nbufs)
 	}
 
 	list_for_each_entry(bf, &sc->rx.rxbuf, list) {
-		skb = ath_rxbuf_alloc(common, common->rx_bufsize, GFP_KERNEL);
+		skb = ath_rxbuf_alloc(common->rx_bufsize, GFP_KERNEL);
 		if (skb == NULL) {
 			error = -ENOMEM;
 			goto err;
@@ -810,7 +809,7 @@ int ath_rx_tasklet(struct ath_softc *sc, int flush)
 
 		/* Ensure we always have an skb to requeue once we are done
 		 * processing the current buffer's skb */
-		requeue_skb = ath_rxbuf_alloc(common, common->rx_bufsize, GFP_ATOMIC);
+		requeue_skb = ath_rxbuf_alloc(common->rx_bufsize, GFP_ATOMIC);
 
 		/* If there is no memory we ignore the current RX'd frame,
 		 * tell hardware it can give us a new frame using the old
diff --git a/drivers/net/wireless/ath/main.c b/drivers/net/wireless/ath/main.c
index 487193f..0a1c762 100644
--- a/drivers/net/wireless/ath/main.c
+++ b/drivers/net/wireless/ath/main.c
@@ -23,35 +23,18 @@ MODULE_AUTHOR("Atheros Communications");
 MODULE_DESCRIPTION("Shared library for Atheros wireless LAN cards.");
 MODULE_LICENSE("Dual BSD/GPL");
 
-struct sk_buff *ath_rxbuf_alloc(struct ath_common *common,
-				u32 len,
-				gfp_t gfp_mask)
+struct sk_buff *ath_rxbuf_alloc(u32 len, gfp_t gfp_mask)
 {
 	struct sk_buff *skb;
 	u32 off;
 
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
-	skb = __dev_alloc_skb(len + common->cachelsz - 1, gfp_mask);
+	skb = __dev_alloc_skb(len + L1_CACHE_BYTES - 1, gfp_mask);
 	if (skb != NULL) {
-		off = ((unsigned long) skb->data) % common->cachelsz;
+		off = ((unsigned long) skb->data) % L1_CACHE_BYTES;
 		if (off != 0)
-			skb_reserve(skb, common->cachelsz - off);
-	} else {
-		printk(KERN_ERR "skbuff alloc of size %u failed\n", len);
+			skb_reserve(skb, L1_CACHE_BYTES - off);
+	} else
 		return NULL;
-	}
 
 	return skb;
 }

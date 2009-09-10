Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:38474 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753451AbZIJTaY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Sep 2009 15:30:24 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org,
	devel@linuxdriverproject.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH 08/10] ath9k: move ath_common to ath_hw
Date: Thu, 10 Sep 2009 15:30:25 -0400
Message-Id: <1252611027-5285-9-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1252611027-5285-1-git-send-email-lrodriguez@atheros.com>
References: <1252611027-5285-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This ensures that we can access common on hw related code
independent of the driver core.

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/net/wireless/ath/ath9k/ath9k.h |    4 +---
 drivers/net/wireless/ath/ath9k/hw.h    |    1 +
 drivers/net/wireless/ath/ath9k/main.c  |   22 +++++++++++-----------
 drivers/net/wireless/ath/ath9k/recv.c  |   10 ++++++----
 4 files changed, 19 insertions(+), 18 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index 757f17f..0c64c80 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -553,8 +553,6 @@ struct ath_softc {
 	struct ieee80211_hw *hw;
 	struct device *dev;
 
-	struct ath_common common;
-
 	spinlock_t wiphy_lock; /* spinlock to protect ath_wiphy data */
 	struct ath_wiphy *pri_wiphy;
 	struct ath_wiphy **sec_wiphy; /* secondary wiphys (virtual radios); may
@@ -649,7 +647,7 @@ int ath_cabq_update(struct ath_softc *);
 
 static inline struct ath_common *ath9k_hw_common(struct ath_hw *ah)
 {
-	return &ah->ah_sc->common;
+	return &ah->common;
 }
 
 static inline struct ath_regulatory *ath9k_hw_regulatory(struct ath_hw *ah)
diff --git a/drivers/net/wireless/ath/ath9k/hw.h b/drivers/net/wireless/ath/ath9k/hw.h
index f8e7919..4f58908 100644
--- a/drivers/net/wireless/ath/ath9k/hw.h
+++ b/drivers/net/wireless/ath/ath9k/hw.h
@@ -435,6 +435,7 @@ struct ath_gen_timer_table {
 
 struct ath_hw {
 	struct ath_softc *ah_sc;
+	struct ath_common common;
 	struct ath9k_hw_version hw_version;
 	struct ath9k_ops_config config;
 	struct ath9k_hw_capabilities caps;
diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index 838b704..2423cdc 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -1352,7 +1352,7 @@ static int ath9k_reg_notifier(struct wiphy *wiphy,
 	struct ieee80211_hw *hw = wiphy_to_ieee80211_hw(wiphy);
 	struct ath_wiphy *aphy = hw->priv;
 	struct ath_softc *sc = aphy->sc;
-	struct ath_regulatory *reg = &sc->common.regulatory;
+	struct ath_regulatory *reg = ath9k_hw_regulatory(sc->sc_ah);
 
 	return ath_reg_notifier_apply(wiphy, request, reg);
 }
@@ -1520,14 +1520,6 @@ static int ath_init_softc(u16 devid, struct ath_softc *sc, u16 subsysid)
 	tasklet_init(&sc->bcon_tasklet, ath_beacon_tasklet,
 		     (unsigned long)sc);
 
-	/*
-	 * Cache line size is used to size and align various
-	 * structures used to communicate with the hardware.
-	 */
-	ath_read_cachesize(sc, &csz);
-	/* XXX assert csz is non-zero */
-	sc->common.cachelsz = csz << 2;	/* convert to bytes */
-
 	ah = kzalloc(sizeof(struct ath_hw), GFP_KERNEL);
 	if (!ah) {
 		r = -ENOMEM;
@@ -1539,6 +1531,16 @@ static int ath_init_softc(u16 devid, struct ath_softc *sc, u16 subsysid)
 	ah->hw_version.subsysid = subsysid;
 	sc->sc_ah = ah;
 
+	common = ath9k_hw_common(ah);
+
+	/*
+	 * Cache line size is used to size and align various
+	 * structures used to communicate with the hardware.
+	 */
+	ath_read_cachesize(sc, &csz);
+	/* XXX assert csz is non-zero */
+	common->cachelsz = csz << 2;	/* convert to bytes */
+
 	if (ath9k_init_debug(ah) < 0)
 		dev_err(sc->dev, "Unable to create debugfs files\n");
 
@@ -1681,8 +1683,6 @@ static int ath_init_softc(u16 devid, struct ath_softc *sc, u16 subsysid)
 	ath9k_hw_setcapability(ah, ATH9K_CAP_DIVERSITY, 1, true, NULL);
 	sc->rx.defant = ath9k_hw_getdefantenna(ah);
 
-	common = ath9k_hw_common(ah);
-
 	if (ah->caps.hw_caps & ATH9K_HW_CAP_BSSIDMASK)
 		memcpy(common->bssidmask, ath_bcast_mac, ETH_ALEN);
 
diff --git a/drivers/net/wireless/ath/ath9k/recv.c b/drivers/net/wireless/ath/ath9k/recv.c
index 3bdd4e6..97a5efe 100644
--- a/drivers/net/wireless/ath/ath9k/recv.c
+++ b/drivers/net/wireless/ath/ath9k/recv.c
@@ -297,6 +297,7 @@ static void ath_opmode_init(struct ath_softc *sc)
 
 int ath_rx_init(struct ath_softc *sc, int nbufs)
 {
+	struct ath_common *common = ath9k_hw_common(sc->sc_ah);
 	struct sk_buff *skb;
 	struct ath_buf *bf;
 	int error = 0;
@@ -306,10 +307,10 @@ int ath_rx_init(struct ath_softc *sc, int nbufs)
 	spin_lock_init(&sc->rx.rxbuflock);
 
 	sc->rx.bufsize = roundup(IEEE80211_MAX_MPDU_LEN,
-				 min(sc->common.cachelsz, (u16)64));
+				 min(common->cachelsz, (u16)64));
 
 	DPRINTF(sc->sc_ah, ATH_DBG_CONFIG, "cachelsz %u rxbufsize %u\n",
-		sc->common.cachelsz, sc->rx.bufsize);
+		common->cachelsz, sc->rx.bufsize);
 
 	/* Initialize rx descriptors */
 
@@ -322,7 +323,7 @@ int ath_rx_init(struct ath_softc *sc, int nbufs)
 	}
 
 	list_for_each_entry(bf, &sc->rx.rxbuf, list) {
-		skb = ath_rxbuf_alloc(&sc->common, sc->rx.bufsize, GFP_KERNEL);
+		skb = ath_rxbuf_alloc(common, sc->rx.bufsize, GFP_KERNEL);
 		if (skb == NULL) {
 			error = -ENOMEM;
 			goto err;
@@ -654,6 +655,7 @@ int ath_rx_tasklet(struct ath_softc *sc, int flush)
 	struct sk_buff *skb = NULL, *requeue_skb;
 	struct ieee80211_rx_status rx_status;
 	struct ath_hw *ah = sc->sc_ah;
+	struct ath_common *common = ath9k_hw_common(ah);
 	struct ieee80211_hdr *hdr;
 	int hdrlen, padsize, retval;
 	bool decrypt_error = false;
@@ -752,7 +754,7 @@ int ath_rx_tasklet(struct ath_softc *sc, int flush)
 
 		/* Ensure we always have an skb to requeue once we are done
 		 * processing the current buffer's skb */
-		requeue_skb = ath_rxbuf_alloc(&sc->common, sc->rx.bufsize, GFP_ATOMIC);
+		requeue_skb = ath_rxbuf_alloc(common, sc->rx.bufsize, GFP_ATOMIC);
 
 		/* If there is no memory we ignore the current RX'd frame,
 		 * tell hardware it can give us a new frame using the old
-- 
1.6.3.3


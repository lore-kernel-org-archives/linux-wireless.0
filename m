Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rn-out-0910.google.com ([64.233.170.185]:27926 "EHLO
	rn-out-0102.google.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753676AbXJLPEe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Oct 2007 11:04:34 -0400
Received: by rn-out-0102.google.com with SMTP id i6so37942rng
        for <linux-wireless@vger.kernel.org>; Fri, 12 Oct 2007 08:04:33 -0700 (PDT)
Date: Fri, 12 Oct 2007 11:04:38 -0400
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, Jiri Slaby <jirislaby@gmail.com>,
	Nick Kossifidis <mickflemm@gmail.com>
Subject: [PATCH 2/5] Add proper support for multicast
Message-ID: <20071012150438.GC9407@pogo> (sfid-20071012_160437_278161_0574B61A)
References: <20071012150052.GA9407@pogo> <20071012150349.GB9407@pogo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20071012150349.GB9407@pogo>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

There seems to be several ways to enable multicast. We choose right now
MadWifi's old implementation. We can later try
ath5k_hw_set_mcast_filterindex() as well.

ath5k_hw_get_rx_filter() may enable AR5K_RX_FILTER_RADARERR or
AR5K_RX_FILTER_PHYERR. We choose to respect only AR5K_RX_FILTER_PHYERR
for now because:

a. Most radars don't seem to work on 5GHz band now
b. Some have reported a lot of unnecessary noise is captured
   when trying to filter for radar
c. When and if someone wants to work on DFS for ath5k later
   this can be enabled then

Changes-licensed-under: 3-clause-BSD
Signed-off-by: Luis R. Rodriguez <mcgrof@gmail.com>
---
 drivers/net/wireless/ath5k/base.c |   62 ++++++++++++++++++++++++++++++------
 1 files changed, 51 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wireless/ath5k/base.c b/drivers/net/wireless/ath5k/base.c
index cda922e..3e46d8f 100644
--- a/drivers/net/wireless/ath5k/base.c
+++ b/drivers/net/wireless/ath5k/base.c
@@ -1400,8 +1400,12 @@ unlock:
 	FIF_BCN_PRBRESP_PROMISC
 /*
  * o always accept unicast, broadcast, and multicast traffic
- * o maintain current state of phy error reception (the hal
- *   may enable phy error frames for noise immunity work)
+ * o multicast traffic for all BSSIDs will be enabled if mac80211
+ *   says it should be
+ * o maintain current state of phy ofdm or phy cck error reception.
+ *   If the hardware detects any of these type of errors then
+ *   ath5k_hw_get_rx_filter() will pass to us the respective
+ *   hardware filters to be able to receive these type of frames.
  * o probe request frames are accepted only when operating in
  *   hostap, adhoc, or monitor modes
  * o enable promiscuous mode according to the interface state
@@ -1419,15 +1423,23 @@ static void ath_configure_filter(struct ieee80211_hw *hw,
 {
 	struct ath_softc *sc = hw->priv;
 	struct ath_hw *ah = sc->ah;
-	u32 rfilt;
+	u32 mfilt[2], val, rfilt;
+	u8 pos;
+	int i;
+
+	mfilt[0] = 0;
+	mfilt[1] = 0;
 
 	/* Only deal with supported flags */
 	changed_flags &= SUPPORTED_FIF_FLAGS;
 	*new_flags &= SUPPORTED_FIF_FLAGS;
 
-	/* XXX: Start by enabling broadcasts and Unicast, move this later
-	 * to mac802111 and add a flag for these */
-	rfilt = AR5K_RX_FILTER_UCAST | AR5K_RX_FILTER_BCAST;
+	/* If HW detects any phy or radar errors, leave those filters on.
+	 * Also, always enable Unicast, Broadcasts and Multicast
+	 * XXX: move unicast, bssid broadcasts and multicast to mac80211 */
+	rfilt = (ath5k_hw_get_rx_filter(ah) & (AR5K_RX_FILTER_PHYERR)) |
+		(AR5K_RX_FILTER_UCAST | AR5K_RX_FILTER_BCAST |
+		AR5K_RX_FILTER_MCAST);
 
 	if (changed_flags & (FIF_PROMISC_IN_BSS | FIF_OTHER_BSS)) {
 		if (*new_flags & FIF_PROMISC_IN_BSS) {
@@ -1438,18 +1450,44 @@ static void ath_configure_filter(struct ieee80211_hw *hw,
 			__clear_bit(ATH_STAT_PROMISC, sc->status);
 	}
 
-	if (*new_flags & FIF_ALLMULTI)
-		rfilt |= AR5K_RX_FILTER_MCAST;
+	/* Note, AR5K_RX_FILTER_MCAST is already enabled */
+	if (*new_flags & FIF_ALLMULTI) {
+		mfilt[0] =  ~0;
+		mfilt[1] =  ~0;
+	} else {
+		for (i = 0; i < mc_count; i++) {
+			if (!mclist)
+				break;
+			/* calculate XOR of eight 6-bit values */
+			val = LE_READ_4(mclist->dmi_addr + 0);
+			pos = (val >> 18) ^ (val >> 12) ^ (val >> 6) ^ val;
+			val = LE_READ_4(mclist->dmi_addr + 3);
+			pos ^= (val >> 18) ^ (val >> 12) ^ (val >> 6) ^ val;
+			pos &= 0x3f;
+			mfilt[pos / 32] |= (1 << (pos % 32));
+			/* XXX: we might be able to just do this instead,
+			* but not sure, needs testing, if we do use this we'd
+			* neet to inform below to not reset the mcast */
+			/* ath5k_hw_set_mcast_filterindex(ah,
+			 *      mclist->dmi_addr[5]); */
+			mclist = mclist->next;
+		}
+	}
+
 	/* This is the best we can do */
 	if (*new_flags & (FIF_FCSFAIL | FIF_PLCPFAIL))
 		rfilt |= AR5K_RX_FILTER_PHYERR;
+
 	/* FIF_BCN_PRBRESP_PROMISC really means to enable beacons
 	* and probes for any BSSID, this needs testing */
 	if (*new_flags & FIF_BCN_PRBRESP_PROMISC)
 		rfilt |= AR5K_RX_FILTER_BEACON | AR5K_RX_FILTER_PROBEREQ;
-	/* FIF_CONTROL doc says that FIF_PROMISC_IN_BSS is not set we should
-	* only pass on control frames for this station. This needs testing.
-	* I believe right now this enables *all* control frames */
+
+	/* FIF_CONTROL doc says that if FIF_PROMISC_IN_BSS is not
+	 * set we should only pass on control frames for this
+	 * station. This needs testing. I believe right now this
+	 * enables *all* control frames, which is OK.. but
+	 * but we should see if we can improve on granularity */
 	if (*new_flags & FIF_CONTROL)
 		rfilt |= AR5K_RX_FILTER_CONTROL;
 
@@ -1470,6 +1508,8 @@ static void ath_configure_filter(struct ieee80211_hw *hw,
 		rfilt |= AR5K_RX_FILTER_BEACON;
 	}
 
+	/* Set multicast bits */
+	ath5k_hw_set_mcast_filter(ah, mfilt[0], mfilt[1]);
 	/* Set the cached hw filter flags, this will alter actually
 	 * be set in HW */
 	sc->filter_flags = rfilt;
-- 
1.5.2.5


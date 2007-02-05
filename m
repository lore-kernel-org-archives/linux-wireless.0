Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:46983
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932333AbXBENSf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 Feb 2007 08:18:35 -0500
From: Michael Buesch <mb@bu3sch.de>
To: John Linville <linville@tuxdriver.com>
Subject: [PATCH] bcm43xx-d80211: Use d80211 API to generate RTS/CTS frames
Date: Mon, 5 Feb 2007 14:14:17 +0100
References: <200702051412.50703.mb@bu3sch.de>
In-Reply-To: <200702051412.50703.mb@bu3sch.de>
Cc: linux-wireless@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200702051414.17765.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Use the new d80211 API to generate RTS and CTS-to-self frames.

Signed-off-by: Michael Buesch <mb@bu3sch.de>

Index: bu3sch-wireless-dev/drivers/net/wireless/d80211/bcm43xx/bcm43xx_xmit.c
===================================================================
--- bu3sch-wireless-dev.orig/drivers/net/wireless/d80211/bcm43xx/bcm43xx_xmit.c	2007-02-05 14:01:40.000000000 +0100
+++ bu3sch-wireless-dev/drivers/net/wireless/d80211/bcm43xx/bcm43xx_xmit.c	2007-02-05 14:05:55.000000000 +0100
@@ -198,85 +198,6 @@ __le16 bcm43xx_calc_duration(const struc
 	return duration_id;
 }
 
-static inline
-u16 ceiling_div(u16 dividend, u16 divisor)
-{
-	return ((dividend + divisor - 1) / divisor);
-}
-
-//TODO
-#if 0
-static void bcm43xx_generate_rts(const struct bcm43xx_phy *phy,
-				 struct bcm43xx_txhdr_fw3 *txhdr,
-				 u16 *flags,
-				 u8 bitrate,
-				 const struct ieee80211_hdr *wlhdr)
-{
-	u16 fctl;
-	u16 dur;
-	u8 fallback_bitrate;
-	int ofdm_modulation;
-	int fallback_ofdm_modulation;
-	u8 *sa, *da;
-	u16 flen;
-
-	sa = ieee80211_get_SA((struct ieee80211_hdr *)wlhdr);
-	da = ieee80211_get_DA((struct ieee80211_hdr *)wlhdr);
-	fallback_bitrate = bcm43xx_calc_fallback_rate(bitrate);
-	ofdm_modulation = !(bcm43xx_is_cck_rate(bitrate));
-	fallback_ofdm_modulation = !(bcm43xx_is_cck_rate(fallback_bitrate));
-
-	flen = sizeof(u16) + sizeof(u16) + ETH_ALEN + ETH_ALEN + FCS_LEN,
-	bcm43xx_generate_plcp_hdr((struct bcm43xx_plcp_hdr4 *)(&txhdr->rts_cts_plcp),
-				  flen, bitrate);
-	bcm43xx_generate_plcp_hdr((struct bcm43xx_plcp_hdr4 *)(&txhdr->rts_cts_fallback_plcp),
-				  flen, fallback_bitrate);
-	fctl = IEEE80211_FTYPE_CTL | IEEE80211_STYPE_RTS;
-	dur = le16_to_cpu(wlhdr->duration_id);
-/*FIXME: should we test for dur==0 here and let it unmodified in this case?
- *       The following assert checks for this case...
- */
-assert(dur);
-/*FIXME: The duration calculation is not really correct.
- *       I am not 100% sure which bitrate to use. We use the RTS rate here,
- *       but this is likely to be wrong.
- */
-	if (phy->type == BCM43xx_PHYTYPE_A) {
-		/* Three times SIFS */
-		dur += 16 * 3;
-		/* Add ACK duration. */
-		dur += ceiling_div((16 + 8 * (14 /*bytes*/) + 6) * 10,
-				   bitrate * 4);
-		/* Add CTS duration. */
-		dur += ceiling_div((16 + 8 * (14 /*bytes*/) + 6) * 10,
-				   bitrate * 4);
-	} else {
-		/* Three times SIFS */
-		dur += 10 * 3;
-		/* Add ACK duration. */
-		dur += ceiling_div(8 * (14 /*bytes*/) * 10,
-				   bitrate);
-		/* Add CTS duration. */
-		dur += ceiling_div(8 * (14 /*bytes*/) * 10,
-				   bitrate);
-	}
-
-	txhdr->rts_cts_frame_control = cpu_to_le16(fctl);
-	txhdr->rts_cts_dur = cpu_to_le16(dur);
-//printk(MAC_FMT "  " MAC_FMT "  " MAC_FMT "\n", MAC_ARG(wlhdr->addr1), MAC_ARG(wlhdr->addr2), MAC_ARG(wlhdr->addr3));
-//printk(MAC_FMT "  " MAC_FMT "\n", MAC_ARG(sa), MAC_ARG(da));
-	memcpy(txhdr->rts_cts_mac1, wlhdr->addr1, ETH_ALEN);//FIXME!
-	memcpy(txhdr->rts_cts_mac2, sa, ETH_ALEN);
-
-	*flags |= BCM43xx_TXHDRFLAG_RTSCTS;
-	*flags |= BCM43xx_TXHDRFLAG_RTS;
-	if (ofdm_modulation)
-		*flags |= BCM43xx_TXHDRFLAG_RTSCTS_OFDM;
-	if (fallback_ofdm_modulation)
-		*flags |= BCM43xx_TXHDRFLAG_RTSCTSFALLBACK_OFDM;
-}
-#endif
-
 static void generate_txhdr_fw4(struct bcm43xx_wldev *dev,
 			       struct bcm43xx_txhdr_fw4 *txhdr,
 			       const unsigned char *fragment_data,
@@ -307,7 +228,6 @@ static void generate_txhdr_fw4(struct bc
 		txhdr->phy_rate = bcm43xx_plcp_get_ratecode_ofdm(rate);
 	else
 		txhdr->phy_rate = bcm43xx_plcp_get_ratecode_cck(rate);
-	//TODO RTS phyrate
 	txhdr->mac_frame_ctl = wlhdr->frame_control;
 	memcpy(txhdr->tx_receiver, wlhdr->addr1, 6);
 	txhdr->dur_fb = bcm43xx_calc_duration(wlhdr, rate_fb);
@@ -386,8 +306,47 @@ static void generate_txhdr_fw4(struct bc
 	if (phy->type == BCM43xx_PHYTYPE_A)
 		mac_ctl |= BCM43xx_TX4_MAC_5GHZ;
 
-	if (txctl->flags & IEEE80211_TXCTL_USE_RTS_CTS) {
-		//TODO
+	/* Generate the RTS or CTS-to-self frame */
+	if ((txctl->flags & IEEE80211_TXCTL_USE_RTS_CTS) ||
+	    (txctl->flags & IEEE80211_TXCTL_USE_CTS_PROTECT)) {
+		unsigned int len;
+		struct ieee80211_hdr *hdr;
+		int rts_rate, rts_rate_fb;
+		int rts_rate_ofdm, rts_rate_fb_ofdm;
+
+		rts_rate = txctl->rts_cts_rate;
+		rts_rate_ofdm = bcm43xx_is_ofdm_rate(rts_rate);
+		rts_rate_fb = bcm43xx_calc_fallback_rate(rts_rate);
+		rts_rate_fb_ofdm = bcm43xx_is_ofdm_rate(rts_rate_fb);
+
+		if (txctl->flags & IEEE80211_TXCTL_USE_CTS_PROTECT) {
+			ieee80211_ctstoself_get(dev->wl->hw,
+						fragment_data, fragment_len, txctl,
+						(struct ieee80211_cts *)(txhdr->rts_frame));
+			mac_ctl |= BCM43xx_TX4_MAC_SENDCTS;
+			len = sizeof(struct ieee80211_cts);
+		} else {
+			ieee80211_rts_get(dev->wl->hw,
+					  fragment_data, fragment_len, txctl,
+					  (struct ieee80211_rts *)(txhdr->rts_frame));
+			mac_ctl |= BCM43xx_TX4_MAC_SENDRTS;
+			len = sizeof(struct ieee80211_rts);
+		}
+		len += FCS_LEN;
+		bcm43xx_generate_plcp_hdr((struct bcm43xx_plcp_hdr4 *)(&txhdr->rts_plcp),
+					  len, rts_rate);
+		bcm43xx_generate_plcp_hdr((struct bcm43xx_plcp_hdr4 *)(&txhdr->rts_plcp_fb),
+					  len, rts_rate_fb);
+		hdr = (struct ieee80211_hdr *)(&txhdr->rts_frame);
+		txhdr->rts_dur_fb = hdr->duration_id;
+		if (rts_rate_ofdm) {
+			extra_ft |= BCM43xx_TX4_EFT_RTSOFDM;
+			txhdr->phy_rate_rts = bcm43xx_plcp_get_ratecode_ofdm(rts_rate);
+		} else
+			txhdr->phy_rate_rts = bcm43xx_plcp_get_ratecode_cck(rts_rate);
+		if (rts_rate_fb_ofdm)
+			extra_ft |= BCM43xx_TX4_EFT_RTSFBOFDM;
+		mac_ctl |= BCM43xx_TX4_MAC_LONGFRAME;
 	}
 
 	/* Magic cookie */


-- 
Greetings Michael.
